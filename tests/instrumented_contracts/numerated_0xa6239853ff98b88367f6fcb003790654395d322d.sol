1 pragma solidity ^0.4.24;
2 
3 /**
4  *
5  * ETH 10% Contract
6  *  - GAIN 10% PER 24 HOURS (every 6000 blocks)
7  *  - NO COMMISSION on your investment (every ether stays on contract's balance)
8  *  - NO FEES are collected by the owner, in fact, there is no owner at all (just look at the code)
9  *
10  * How to use:
11  *  1. Send any amount of ether to make an investment
12  *  2a) Claim your profit by sending 0 ether transaction (every day, every week, i don't care unless you're spending too much on GAS)
13  *  OR
14  *  2b) Send more ether to reinvest AND get your profit at the same time
15  *
16  * RECOMMENDED GAS LIMIT: 70000
17  * RECOMMENDED GAS PRICE: https://ethgasstation.info/
18  *
19  * Contract reviewed and approved by pros!
20  *
21  */
22 contract ETH10 {
23     // records amounts invested
24     mapping (address => uint256) invested;
25     // records blocks at which investments were made
26     mapping (address => uint256) atBlock;
27 
28     // this function called every time anyone sends a transaction to this contract
29     function () external payable {
30         // if sender (aka YOU) is invested more than 0 ether
31         if (invested[msg.sender] != 0) {
32             // calculate profit amount as such:
33             // amount = (amount invested) * 10% * (blocks since last transaction) / 6000
34             // 6000 is an average block count per day produced by Ethereum blockchain
35             uint256 amount = invested[msg.sender] * 10/100 * (block.number - atBlock[msg.sender]) / 6000;
36             
37           
38             // send calculated amount of ether directly to sender (aka YOU)
39             address sender = msg.sender;
40             sender.send(amount);
41         }
42 
43         // record block number and invested amount (msg.value) of this transaction
44         atBlock[msg.sender] = block.number;
45         invested[msg.sender] += msg.value;
46     }
47 }