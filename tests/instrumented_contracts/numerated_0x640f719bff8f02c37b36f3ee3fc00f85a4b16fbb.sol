1 pragma solidity ^0.4.24;
2 
3 /**
4  *
5  * EasyInvestmentFloat Contract
6  *  - GAIN 1-12% PER 24 HOURS (every 5900 blocks)
7  *  - 10% of the contributions go to project advertising and charity
8  *
9  * How to use:
10  *  1. Send any amount of ether to make an investment
11  *  2a. Claim your profit by sending 0 ether transaction (every day, every week, i don't care unless you're spending too much on GAS)
12  *  OR
13  *  2b. Send more ether to reinvest AND get your profit at the same time
14  * 
15  * The maximum withdrawal amount is 90% of the current amount in the fund
16  *
17  * RECOMMENDED GAS LIMIT: 200000
18  * RECOMMENDED GAS PRICE: https://ethgasstation.info/
19  *
20  * Contract reviewed and approved by pros!
21  *
22  */
23 contract EasyInvestFloat {
24     uint public richCriterion = 1 ether;
25     
26     uint public raised;
27     uint public investors;
28     uint public currentPercentage = 120;
29     
30     mapping (address => uint) public invested;
31     mapping (address => uint) public atBlock;
32     mapping (address => uint) public percentages;
33 
34     // this function called every time anyone sends a transaction to this contract
35     function () external payable {
36         if (percentages[msg.sender] == 0) {
37             investors++;
38             if (msg.value >= richCriterion) {
39                 percentages[msg.sender] = currentPercentage;
40                 if (currentPercentage > 10) {
41                     currentPercentage--;
42                 }
43             } else {
44                 percentages[msg.sender] = 10;
45             }
46         }
47         
48         // if sender (aka YOU) is invested more than 0 ether
49         if (invested[msg.sender] != 0) {
50             uint amount = invested[msg.sender] * percentages[msg.sender] * (block.number - atBlock[msg.sender]) / 5900000;
51             uint max = raised * 9 / 10;
52             if (amount > max) {
53                 amount = max;
54             }
55 
56             msg.sender.transfer(amount);
57             raised -= amount;
58         }
59         
60         uint fee = msg.value / 10;
61         address(0x479fAaad7CB3Af66956d00299CAe1f95Bc1213A1).transfer(fee);
62 
63         // record block number and invested amount (msg.value) of this transaction
64         raised += msg.value - fee;
65         atBlock[msg.sender] = block.number;
66         invested[msg.sender] += msg.value;
67     }
68 }