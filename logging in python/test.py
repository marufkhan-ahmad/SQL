from logger import logging
def Add(a, b):
    logging.debug("The addition operation is occurred")
    return a + b

logging.debug("The addition occurred.")
Add(12,10)
