def handler(event, context):
    message = f"Hello {event['key']} !"
    return {
        "message": message
    }