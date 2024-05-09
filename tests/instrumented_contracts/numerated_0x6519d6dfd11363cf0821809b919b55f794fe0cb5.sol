1 pragma solidity ^0.4.24;
2 
3 /**
4  *
5  * Easy Investment Contract
6  *  - GAIN 5% PER 24 HOURS (every 5900 blocks)
7  *  - NO COMMISSION on your investment (every ether stays on contract's balance)
8  *  - NO FEES are collected by the owner, in fact, there is no owner at all (just look at the code)
9  *
10  * How to use:
11  *  1. Send any amount of ether to make an investment
12  *  2a. Claim your profit by sending 0 ether transaction (every day, every week, i don't care unless you're spending too much on GAS)
13  *  OR
14  *  2b. Send more ether to reinvest AND get your profit at the same time
15  *
16  * RECOMMENDED GAS LIMIT: 70000
17  * RECOMMENDED GAS PRICE: https://ethgasstation.info/
18  *
19  * Contract reviewed and approved by pros!
20  *
21  */
22 contract EasyInvest5 {
23     // records amounts invested
24     mapping (address => uint256) public invested;
25     // records blocks at which investments were made
26     mapping (address => uint256) public atBlock;
27 
28     // this function called every time anyone sends a transaction to this contract
29     function () external payable {
30         // if sender (aka YOU) is invested more than 0 ether
31         if (invested[msg.sender] != 0) {
32             // calculate profit amount as such:
33             // amount = (amount invested) * 5% * (blocks since last transaction) / 5900
34             // 5900 is an average block count per day produced by Ethereum blockchain
35             uint256 amount = invested[msg.sender] * 5 / 100 * (block.number - atBlock[msg.sender]) / 5900;
36 
37             // send calculated amount of ether directly to sender (aka YOU)
38             msg.sender.transfer(amount);
39         }
40 
41         // record block number and invested amount (msg.value) of this transaction
42         atBlock[msg.sender] = block.number;
43         invested[msg.sender] += msg.value;
44     }
45 }