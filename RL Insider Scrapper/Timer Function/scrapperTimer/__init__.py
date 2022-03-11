import datetime
import logging

import azure.functions as func

import requests


def main(mytimer: func.TimerRequest) -> None:
    utc_timestamp = datetime.datetime.utcnow().replace(
        tzinfo=datetime.timezone.utc).isoformat()

    if mytimer.past_due:
        logging.info('The timer is past due!')

    logging.info('Python timer trigger function ran at %s', utc_timestamp)
    response = requests.get("https://aryaarlinvestmentstrigger.azurewebsites.net/api/scrapper")

    #0 0 6 * * * 6am every day
    #*/10 * * * * * every ten seconds
