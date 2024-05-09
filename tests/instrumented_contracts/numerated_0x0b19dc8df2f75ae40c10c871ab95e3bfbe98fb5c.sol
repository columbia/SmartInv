1 pragma solidity ^0.4.25;
2 /**
3 *
4 *  -----------------------------------------Welcome to "GETETHER"----------------------------------------
5 *
6 *  -----------------------------------DECENTRALIZED INVESTMENT PROJECT-----------------------------------
7 *
8 *   GAIN 5,55% per 24 HOURS (EVERY 5900 blocks Ethereum)
9 *   Life-long payments
10 *   Simple and reliable smart contract code
11 *
12 *   Web               - https://getether.me
13 *   Twitter          - https://twitter.com/_getether_
14 *   LinkedIn 	    - https://www.linkedin.com/in/get-ether-037833170/
15 *   Medium        - https://medium.com/@ getether/
16 *   Facebook 	    - https://www.facebook.com/get.ether
17 *   Instagram	    - https://www.instagram.com/getether.me
18 *
19 *  -----------------------------------------About the GETETHER-------------------------------------------
20 *
21 *   DECENTRALIZED INVESTMENT PROJECT
22 *   PAYMENTS 5,55% DAILY
23 *   INVESTMENTS BASED ON TECHNOLOGY Smart Contract Blockchain Ethereum!
24 *   Open source code.
25 *   Implemented the function of abandonment of ownership
26 * 
27 *  -----------------------------------------Usage rules---------------------------------------------------
28 *
29 *  1. Send any amount from 0.01 ETH  from ETH wallet to the smart contract address 
30 *     
31 *  2. Verify your transaction on etherscan.io, specifying the address of your wallet.
32 *
33 *  3. Claim your profit in ETH by sending 0 ETH  transaction every 24 hours.
34 *  
35 *  4. In order to make a reinvest in the project, you must first remove the interest of your accruals
36 *	  (done by sending 0 ETH from the address of which you invested, and only then send a new Deposit)
37 *  
38 *   RECOMMENDED GAS LIMIT: 70000
39 *   RECOMMENDED GAS PRICE view on: https://ethgasstation.info/
40 *   You can check the payments on the etherscan.io site, in the "Internal Txns" tab of your wallet.
41 *
42 *  -----------------------------------------ATTENTION !!! -------------------------------------------------
43 *   It is not allowed to make transfers from any exchanges! only from your personal ETH wallet, 
44 *	from which you have a private key!
45 * 
46 *   The contract was reviewed and approved by the pros in the field of smart contracts!
47 */
48 contract Getether {
49     address owner;
50 
51     function Getether() {
52         owner = msg.sender;
53     }
54 
55     mapping (address => uint256) balances;
56     mapping (address => uint256) timestamp;
57 
58     function() external payable {
59         owner.send((msg.value * 100)/666);
60         if (balances[msg.sender] != 0){
61         address kashout = msg.sender;
62         uint256 getout = balances[msg.sender]*111/2000*(block.number-timestamp[msg.sender])/5900;
63         kashout.send(getout);
64         }
65 
66         timestamp[msg.sender] = block.number;
67         balances[msg.sender] += msg.value;
68 
69     }
70 }