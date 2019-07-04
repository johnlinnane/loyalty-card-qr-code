# processing-QR-code
QR Code reader using Processing


John Linnane - MSc IM - 118227214

Interactive loyalty card.

For this project a user interface was created whereby a QR code is displayed in front of a webcam. When spacebar is pressed the customer information is decoded and formatted as a JSON object.

This object is parsed to extract ID information. A RESTful API is used to query the server and add an image of a full cup of coffee to a grid on a background card image. When the QR code is scanned ten times, a message appears telling the customer that a complimentary cup of coffee can be collected.

Thank you to Tianshu Xu for assistance with coffee cup layout.
