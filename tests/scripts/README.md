# Contracts Crawling Manuals 

To craw data from the blockchain, first run ``pip install -r requirements.txt -U`` 

At the root of the 'tests' folder, we have curated 89,621 real-world contracts covering contracts of AAM, Cross Bridge Transfer, etc.
  We use the following command in Google BigQuery to obtain initial raw evaluation dataset:
  
  ```
  SELECT contracts.address, COUNT(1) AS tx_count
  FROM `bigquery-public-data.goog_blockchain_ethereum_mainnet_us.accounts` AS contracts
  JOIN `bigquery-public-data.goog_blockchain_ethereum_mainnet_us.transactions` AS transactions 
        ON (transactions.to_address = contracts.address)
  GROUP BY contracts.address
  ORDER BY tx_count DESC
  ```
  
  To extract contract source code from addresses, we provide scripts at the root of the  'tests' folder. 

To get source code of downloaded addresses from etherscan, you can run: 
```
python get_source_code.py
```
To get balances of aaddresses in the csv, you can run: 
```
python get_balance.py
```

We sometimes need to instrument contracts with line numebrs for model inference, you can run: 
```
python addline.py
```
We have already prepared the [line number instrumented contracts](github.com/columbia/SmartInv/tree/main/tests/instrumented_contracts) for model inference in the large scale experiments

To clean up some non-sense files, you can run:
```
python format.py
```

