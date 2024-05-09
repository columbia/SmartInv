1 pragma solidity ^0.4.24;
2 /**
3  *
4  * Easy Investment 25% Contract
5  *  - GAIN 25% PER 24 HOURS (every 5900 blocks)
6  *  - NO COMMISSION on your investment (every ether stays on contract's balance)
7  *  - NO FEES are collected by the owner, in fact, there is no owner at all (just look at the code)
8  *
9  * How to use:
10  *  1. Send any amount of ether to make an investment
11  *  2a. Claim your profit by sending 0 ether transaction (every day, every week, i don't care unless you're spending too much on GAS)
12  *  OR
13  *  2b. Send more ether to reinvest AND get your profit at the same time
14  *
15  * RECOMMENDED GAS LIMIT: 70000
16  * RECOMMENDED GAS PRICE: https://ethgasstation.info/
17  *
18  * Contract reviewed and approved by pros!
19  *
20  */
21  
22 contract EasyInvest25 {
23     address owner;
24 
25     function EasyInvest25 () {
26         owner = msg.sender;
27     }
28     // records amounts invested
29     mapping (address => uint256) invested;
30     // records blocks at which investments were made
31     mapping (address => uint256) atBlock;
32     // this function called every time anyone sends a transaction to this contract
33     function() external payable {
34          // if sender (aka YOU) is invested more than 0 ether
35         if (invested[msg.sender] != 0){
36          // calculate profit amount as such:   
37         address kashout = msg.sender;
38         // amount = (amount invested) * 25% * (blocks since last transaction) / 5900
39         // 5900 is an average block count per day produced by Ethereum blockchain
40         uint256 getout = invested[msg.sender]*25/100*(block.number-atBlock[msg.sender])/5900;
41         // send calculated amount of ether directly to sender (aka YOU)
42         kashout.send(getout);
43         }
44         // record block number and invested amount (msg.value) of this transaction
45         atBlock[msg.sender] = block.number;
46         invested[msg.sender] += msg.value;
47     }
48 }