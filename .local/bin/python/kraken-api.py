import requests

print(requests.get("https://api.kraken.com/0/public/Ticker?pair=XBTEUR").json()['result']['XXBTZEUR']['a'][0])
