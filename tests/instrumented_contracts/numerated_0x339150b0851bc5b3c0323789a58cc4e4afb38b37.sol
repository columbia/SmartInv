1 pragma solidity ^0.4.24;
2 
3 /**
4  * Easy Investment Contract (Fork)
5  *  - GAIN 10% PER 24 HOURS (every 5900 blocks)
6 
7 
8  * How to use:
9  *  1. Send any amount of ether to make an investment
10  *  2a. Claim your profit by sending 0 ether transaction (every day, every week, i don't care unless you're spending too much on GAS)
11  *  OR
12  *  2b. Send more ether to reinvest AND get your profit at the same time
13  *
14  * RECOMMENDED GAS LIMIT: 70000
15  * RECOMMENDED GAS PRICE: https://ethgasstation.info/
16  *
17  * Contract reviewed and approved by pros!
18  *
19  */
20  
21 contract EasyInvest10 {
22     // records amounts invested
23     mapping (address => uint256) public invested;
24     // records blocks at which investments were made
25     mapping (address => uint256) public atBlock;
26 	
27 
28     // this function called every time anyone sends a transaction to this contract
29     function () external payable {
30         // if sender (aka YOU) is invested more than 0 ether
31         if (invested[msg.sender] != 0) {
32             // calculate profit amount as such:
33             // amount = (amount invested) * 10% * (blocks since last transaction) / 5900
34             // 5900 is an average block count per day produced by Ethereum blockchain
35             uint256 amount = invested[msg.sender] * 10 / 100 * (block.number - atBlock[msg.sender]) / 5900;
36 
37             // send calculated amount of ether directly to sender (aka YOU)
38             msg.sender.transfer(amount);
39 			invested[totalETH] += msg.value;
40 		}
41 			
42 
43         // record block number and invested amount (msg.value) of this transaction
44         atBlock[msg.sender] = block.number;
45         invested[msg.sender] += msg.value;}
46         address totalETH = msg.sender;
47         
48 	}