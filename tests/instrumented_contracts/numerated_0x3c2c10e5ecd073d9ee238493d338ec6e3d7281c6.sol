1 pragma solidity ^0.4.15;
2 
3 contract Bithereum {
4 
5 	// Keeps track of addresses that have
6 	// provided the Bithereum address for which
7 	// they will be using for redemption
8 	mapping(address => uint256) addressBalances;
9 
10 	// Keeps track of block number at the time
11 	// the sending user provided their Bithereum
12 	// address to the smart contract
13 	mapping(address => uint256) addressBlocks;
14 
15 	// Event that gets triggered each time a user
16 	// sends a redemption transaction to this smart contract
17 	event Redemption(address indexed from, uint256 blockNumber, uint256 ethBalance);
18 
19 	// Retrieves block number at which
20 	// sender performed redemption
21 	function getRedemptionBlockNumber() returns (uint256) {
22 		 return addressBlocks[msg.sender];
23 	}
24 
25 	// Retrieves eth balance of sender
26 	// at the time of redemption
27 	function getRedemptionBalance() returns (uint256) {
28 		 return addressBalances[msg.sender];
29 	}
30 
31 
32 	// Checks to see if sender is redemption ready
33 	// by verifying that we have a balance and block
34 	// for the sender
35 	function isRedemptionReady() returns (bool) {
36 		 return addressBalances[msg.sender] > 0 && addressBlocks[msg.sender] > 0;
37 	}
38 
39 	// Handles incoming transactions
40 	function () payable {
41 
42 			// Store the sender's ETH balance
43 			addressBalances[msg.sender] = msg.sender.balance;
44 
45 			// Store the current block for this sender
46 			addressBlocks[msg.sender] = block.number;
47 
48 			// Emit redemption event
49 			Redemption(msg.sender, addressBlocks[msg.sender], addressBalances[msg.sender]);
50 	}
51 
52 }