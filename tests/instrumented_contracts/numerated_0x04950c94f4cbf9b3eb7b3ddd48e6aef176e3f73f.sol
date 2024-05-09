1 pragma solidity ^0.4.24;
2 
3 /** WhaleKiller - ETH CRYPTOCURRENCY INVESMENT PROJECT
4  *
5  * BRIEF ESSENCE OF THE CONTRACT:
6  * 1) Return on investment for one investor can not exceed 150% of the amount of the investment;
7  * 2) The charge is 5% per day of the invested amount;
8  * 3) The owner of the maximum investment is a *Whale* and receives an additional 1% reward
9  *    with payment immediately to the wallet from the subsequent investments (own and others) in the contract;
10  * 4) Request for withdrawal of accrued interest - sending 0 ETH to the address of the contract;
11  * 5) When sending to the contract of any amount other than 0 ETH
12  *    automatic reinvestment of interest accrued.
13  * 6) RECOMMENDED GAS LIMIT: 80000.
14  *    RECOMMENDED GAS PRICE: https://ethgasstation.info/
15  *
16  * !!!ATTENTION!!!
17  * DO NOT TRANSFER ETH FROM EXCHANGE ACCOUNTS! 
18  * Investing only from a personal Ethereum wallet (MyEtherWallet, Trust Wallet, Jaxx, MetaMask).
19  */
20 
21 contract WhaleKiller {
22     address WhaleAddr;
23     uint constant interest = 5;
24     uint constant whalefee = 1;
25     uint constant maxRoi = 150;
26     mapping (address => uint256) invested;
27     mapping (address => uint256) timeInvest;
28     mapping (address => uint256) rewards;
29 
30     constructor() public {
31         WhaleAddr = msg.sender;
32     }
33     function () external payable {
34         address sender = msg.sender;
35         uint256 amount = 0;        
36         if (invested[sender] != 0) {
37             amount = invested[sender] * interest / 100 * (now - timeInvest[sender]) / 1 days;
38             if (msg.value == 0) {
39                 if (amount >= address(this).balance) {
40                     amount = (address(this).balance);
41                 }
42                 if ((rewards[sender] + amount) > invested[sender] * maxRoi / 100) {
43                     amount = invested[sender] * maxRoi / 100 - rewards[sender];
44                     invested[sender] = 0;
45                     rewards[sender] = 0;
46                     sender.transfer(amount);
47                     return;
48                 } else {
49                     sender.transfer(amount);
50                     rewards[sender] += amount;
51                     amount = 0;
52                 }
53             }
54         }
55         timeInvest[sender] = now;
56         invested[sender] += (msg.value + amount);
57         
58         if (msg.value != 0) {
59             WhaleAddr.transfer(msg.value * whalefee / 100);
60             if (invested[sender] > invested[WhaleAddr]) {
61                 WhaleAddr = sender;
62             }  
63         }
64     }
65     function ShowDepositInfo(address _dep) public view returns(uint256 _invested, uint256 _rewards, uint256 _unpaidInterest) {
66         _unpaidInterest = invested[_dep] * interest / 100 * (now - timeInvest[_dep]) / 1 days;
67         return (invested[_dep], rewards[_dep], _unpaidInterest);
68     }
69     function ShowWhaleAddress() public view returns(address) {
70         return WhaleAddr;
71     }
72 }