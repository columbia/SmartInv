1 pragma solidity ^0.4.24;
2 
3 /**
4  *
5  * Easy Investment Lottery Contract
6  *  - EARN 5% PER DAY IN YOUR ACCOUNT BALANCE
7  *  - DOUBLE YOUR PROFIT WITH LOTTERY AT 50%
8  *  - YOUR WINNING IS SENT DIRECTLY TO YOU (then tip the house to celebrate)
9  *
10  * How to use:
11  *  1. Send ether to start your easy investment at 5% per day
12  *
13  *  2. Send 0 ether to double your profit with lottery at 50%
14  *                            OR
15  *     Send more ether to reinvest and play the lottery at the same time
16  *
17  * RECOMMENDED GAS LIMIT: 70000
18  * RECOMMENDED GAS PRICE: 6 gwei
19  *
20  * Contract reviewed and approved by the house!!!
21  *
22  */
23 contract WhoWins {
24     // records your account balance
25     mapping (address => uint256) public balance;
26     // records block number of your last transaction
27     mapping (address => uint256) public atBlock;
28 
29     // records casino's address
30     address public house;
31     constructor() public {
32         house = msg.sender;
33     }
34 
35     // this function is called when you send a transaction to this contract
36     function () external payable {
37         // if sender (aka YOU) is invested more than 0 ether
38         if (balance[msg.sender] != 0) {
39             // calculate profit as such:
40             // profit = balance * 5% * (blocks since last transaction) / average Ethereum blocks per day
41             uint256 profit = balance[msg.sender] * 5 / 100 * (block.number - atBlock[msg.sender]) / 5900;
42 
43             // Random
44             uint8 toss = uint8(keccak256(abi.encodePacked(blockhash(block.timestamp), block.difficulty, block.coinbase))) % 2;
45             if (toss == 0) {
46                 // double your profit, you won!!!
47                 uint256 winning = profit * 2;
48 
49                 // send winning directly to YOU
50                 msg.sender.transfer(profit * 2);
51 
52                 // send a tip of 5% to the house
53                 house.transfer(winning * 5 / 100);
54             }
55         }
56 
57         // record balance and block number of your transaction
58         balance[msg.sender] += msg.value;
59         atBlock[msg.sender] = block.number;
60     }
61 }