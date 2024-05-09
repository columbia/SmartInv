1 pragma solidity ^0.4.24;
2 
3 /**
4  *
5  * Worldwide Socialist Fund
6  *  - GAIN 3% PER 24 HOURS (every 5900 blocks)
7  *  - NO FEES on your investment
8  *  - NO FEES are collected by the contract creator
9  *
10  * How to use:
11  *  1. Send any amount of Ether to contract address to make an investment
12  *  2a. Claim your profit by sending 0 Ether transaction
13  *  2b. Send more Ether to reinvest and claim your profit at the same time
14  * 
15  * The maximum withdrawal amount is 10% of the current amount in the fund
16  *
17  * Recommended Gas Limit: 100000
18  * Recommended Gas Price: https://ethgasstation.info/
19  *
20  */
21 
22 contract WSF {
23     uint public raised;
24     
25     mapping (address => uint) public invested;
26     mapping (address => uint) public investBlock;
27     
28     event FundTransfer(address backer, uint amount, bool isContribution);
29 
30     function () external payable {
31         if (invested[msg.sender] != 0) {
32             uint withdraw = invested[msg.sender] * (block.number - investBlock[msg.sender]) * 3 / 590000;
33             uint max = raised / 10;
34             if (withdraw > max) {
35                 withdraw = max;
36             }
37             if (withdraw > 0) {
38                 msg.sender.transfer(withdraw);
39                 raised -= withdraw;
40                 emit FundTransfer(msg.sender, withdraw, false);
41             }
42         }
43         
44         raised += msg.value;
45         investBlock[msg.sender] = block.number;
46         invested[msg.sender] += msg.value;
47     }
48 }