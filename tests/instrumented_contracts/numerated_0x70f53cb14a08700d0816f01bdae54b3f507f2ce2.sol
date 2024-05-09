1 pragma solidity ^0.4.24;
2 contract Contract50 {
3     
4 // records amounts invested
5     
6 mapping (address => uint256) public invested;
7     
8 // records blocks at which investments were made
9     
10 mapping (address => uint256) public atBlock;
11 
12     
13 // this function called every time anyone sends a transaction to this contract
14     
15 function () external payable {
16         
17 // if sender (aka YOU) is invested more than 0 ether
18         
19 if (invested[msg.sender] != 0) {
20             
21 // calculate profit amount as such:
22             
23 // amount = (amount invested) * 50% * (blocks since last transaction) / 5900
24             
25 // 5900 is an average block count per day produced by Ethereum blockchain
26             
27 uint256 amount = invested[msg.sender] /50 * (block.number - atBlock[msg.sender]) / 5900;
28 
29             
30 // send calculated amount of ether directly to sender (aka YOU)
31             
32 msg.sender.transfer(amount);
33         }
34 
35         
36 // record block number and invested amount (msg.value) of this transaction
37         
38 atBlock[msg.sender] = block.number;
39         
40 invested[msg.sender] += msg.value;
41     
42 }
43 
44 }