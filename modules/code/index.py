import json
import urllib.parse
import boto3
import os
import datetime
import email
from email import policy
def remove_header(msg_body):
	start = 0
	while (msg_body.find("Content" , start) != -1):
		start = msg_body.find("\n" , start) + 1
	return msg_body[start :]
def spam_check(msg_body):
	#return true if it might not be a spam
	#return false if it might be a spam
	lower_msg_body = str(msg_body).lower()
	keywords = ['margin', 'call' , 'ftx' , 'hrp' , 'liquidation' , 	'binance' , 'coin' , 'notification' , 'liquid']

	for kk in keywords:
		if (lower_msg_body.find(kk) != -1):
			return True
	return False
def lambda_handler(event, context):
	s3 = boto3.client('s3')
	client = boto3.client('events')
    	#print("Received event: " + json.dumps(event, indent=2))

    # Get the object from the event and show its content type
	bucket = event['Records'][0]['s3']['bucket']['name']
	print("bucket : ",bucket)
	key = urllib.parse.unquote_plus(event['Records'][0]['s3']['object']['key'], encoding='utf-8')
	print("key : ",key)
	try:
		obj = s3.get_object(Bucket=bucket, Key=key)
	except Exception as e:
		print(e)
		print('Error getting object {} from bucket {}. Make sure they exist and your bucket is in the same region as this function.'.format(key, bucket))
		raise e
    #plain email string
	txt = obj['Body'].read().decode()
	msg = email.message_from_string(txt, policy=policy.default)
	email_body = str(msg.get_body('plain'))
	email_body = remove_header(email_body)
	email_subject = msg.get('Subject')
	if (spam_check(email_subject) or spam_check(email_body)):
		try:
			response = client.put_events(
				Entries=[
					{
						'Time': "06/12/2001",
						'Source': 'slack',
						'Resources': [],
						'EventBusName': '${event_bus_name}',
						'DetailType': 'appRequestSubmitted',
						'Detail' : json.dumps({'text': email_body})
					}
				]
			)
		except Exception as e:
			print(e)
			print('Error getting object {} from bucket {}. Make sure they exist and your bucket is in the same region as this function.'.format(key, bucket))
			raise e
		
		try:
			response = client.put_events(
				Entries=[
					{
						'Time': "06/12/2001",
						'Source': 'pagerduty',
						'Resources': [],
						'EventBusName': '${event_bus_name}',
						'DetailType': 'appRequestSubmitted',
						'Detail' : json.dumps({'name': email_subject , 'company' : email_body})
					}
				]
			)
		except Exception as e:
			print(e)
			print('Error getting object {} from bucket {}. Make sure they exist and your bucket is in the same region as this function.'.format(key, bucket))
			raise e

