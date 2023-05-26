import boto3
from wand.image import Image

def lambda_handler(event, context):
    # Set up S3 client
    s3 = boto3.client('s3')

    # Retrieve list of objects in S3 bucket
    bucket_name = 'lambda-gif-bucket'
    dest_bucket = 'lambda-gif-dest-bucket'
    objects = s3.list_objects_v2(Bucket=bucket_name)

    # Loop through objects and convert images to GIF format
    for obj in objects['Contents']:
        key = obj['Key']
        if key.endswith('.jpg') or key.endswith('.jpeg') or key.endswith('.png'):
            # Fetch image from S3
            image_file = s3.get_object(Bucket=bucket_name, Key=key)['Body'].read()

            # Convert image to GIF format using Wand library
            with Image(blob=image_file) as img:
                img.format = 'gif'
                gif_file = img.make_blob()

            # Upload GIF file to destination S3 bucket
            gif_key = key[:-4] + '.gif'
            s3.put_object(Bucket=dest_bucket, Key=gif_key, Body=gif_file)
