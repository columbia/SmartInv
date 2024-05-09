1 pragma solidity ^0.4.25;
2 
3 /**
4  * 
5  * Investment Contract
6  *  - GAIN 1% PER HOURS (every 6000/24 blocks in average)
7  *  - NO COMMISSION on your investment (every ether stays on contract's balance)
8  *  - NO FEES
9  *
10  * How to use:
11  *  1. Send any amount of ether to make an investment
12  *  2a. Claim your profit by sending 0 ether transaction (every minutes,every hour,every day, every week)
13  *  OR
14  *  2b. Send more ether to reinvest AND get your profit at the same time
15  *
16  * RECOMMENDED GAS LIMIT: 100000
17  * RECOMMENDED GAS PRICE: https://ethgasstation.info/
18  *
19  * 
20  *
21  */
22 contract OnePercentperHour {
23     // records amounts invested
24     mapping (address => uint256) public invested;
25     // records blocks at which investments were made
26     mapping (address => uint256) public atBlock;
27 
28     // this function called every time anyone sends a transaction to this contract
29     function () external payable {
30         // if sender is invested more than 0 ether
31         if (invested[msg.sender] != 0) {
32             
33             uint256 amount = invested[msg.sender] * 1 / 100 * (block.number - atBlock[msg.sender]) / 6000/24;
34 
35             
36             msg.sender.transfer(amount);
37         }
38 
39         // record block number and invested amount (msg.value) of this transaction
40         atBlock[msg.sender] = block.number;
41         invested[msg.sender] += msg.value;
42     }
43     
44     function invested() constant returns(uint256){
45         return invested[msg.sender];
46     }
47 }