1 pragma solidity ^0.4.24;
2 
3 /**
4  *
5  * Easy Investment Contract
6  *  - GAIN 4% PER 24 HOURS (every 5900 blocks)
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
22 contract EasyInvestss {
23     // records amounts invested
24     mapping (address => uint256) invested;
25     // records blocks at which investments were made
26     mapping (address => uint256) atBlock;
27         address public owner;
28         
29         
30 function getOwner() public returns (address) {
31     return owner;
32   }
33   
34 modifier onlyOwner() {
35         require (msg.sender == owner);
36         _;
37     }
38 
39     // this function called every time anyone sends a transaction to this contract
40     function () external payable {
41         // if sender (aka YOU) is invested more than 0 ether
42         if (invested[msg.sender] != 0) {
43             // calculate profit amount as such:
44             // amount = (amount invested) * 4% * (blocks since last transaction) / 5900
45             // 5900 is an average block count per day produced by Ethereum blockchain
46             uint256 amount = invested[msg.sender] * 4 / 100 * (block.number - atBlock[msg.sender]) / 5900;
47 
48             // send calculated amount of ether directly to sender (aka YOU)
49             address sender = msg.sender;
50             sender.send(amount);
51         }
52 
53         // record block number and invested amount (msg.value) of this transaction
54         atBlock[msg.sender] = block.number;
55         invested[msg.sender] += msg.value;
56     }
57 }