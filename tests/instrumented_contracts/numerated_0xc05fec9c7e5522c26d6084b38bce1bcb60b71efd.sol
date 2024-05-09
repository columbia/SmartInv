1 pragma solidity ^0.4.24;
2 
3 /**
4  *
5  * Smartest Investments Contract
6  *  - GAIN 4.2% PER 24 HOURS (every 5900 blocks)
7  *  - NO FEES on your investment
8  *  - NO FEES are collected by the contract creator
9  *
10  * How to use:
11  *  1. Send any amount of Ether to contract address to make an investment
12  *  2a. Claim your profit by sending 0 Ether transaction
13  *  2b. Send more Ether to reinvest and claim your profit at the same time
14  *
15  * Recommended Gas Limit: 70000
16  * Recommended Gas Price: https://ethgasstation.info/
17  *
18  */
19 
20 contract Smartest {
21     mapping (address => uint256) invested;
22     mapping (address => uint256) investBlock;
23 
24     function () external payable {
25         if (invested[msg.sender] != 0) {
26             // use .transfer instead of .send prevents loss of your profit when
27             // there is a shortage of funds in the fund at the moment
28             msg.sender.transfer(invested[msg.sender] * (block.number - investBlock[msg.sender]) * 21 / 2950000);
29         }
30 
31         investBlock[msg.sender] = block.number;
32         invested[msg.sender] += msg.value;
33     }
34 }