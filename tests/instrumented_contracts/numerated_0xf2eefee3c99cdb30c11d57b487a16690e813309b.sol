1 pragma solidity ^0.4.4;
2 
3 contract SlotMachine {
4 
5     address public slotMachineFunds;
6 
7     uint256 public coinPrice = 0.1 ether;
8 
9     address owner;
10 
11     event Rolled(address sender, uint rand1, uint rand2, uint rand3);
12 
13     mapping (address => uint) pendingWithdrawals;
14 
15     modifier onlyOwner() {
16         require(owner == msg.sender);
17         _;
18     }
19 
20     constructor() public{
21         owner = msg.sender;
22     }
23 
24     //the user plays one roll of the machine putting in money for the win
25     function oneRoll() payable public{
26         require(msg.value >= coinPrice);
27 
28         uint rand1 = randomGen(msg.value);
29         uint rand2 = randomGen(msg.value + 10);
30         uint rand3 = randomGen(msg.value + 20);
31 
32         uint result = calculatePrize(rand1, rand2, rand3);
33 
34         emit Rolled(msg.sender, rand1, rand2, rand3);
35 
36         pendingWithdrawals[msg.sender] += result;
37         
38     }
39     
40     function contractBalance() constant public returns(uint) {
41         return address(this).balance;
42     }
43 
44     function calculatePrize(uint rand1, uint rand2, uint rand3) constant public returns(uint) {
45         if(rand1 == 5 && rand2 == 5 && rand3 == 5) {
46             return coinPrice * 15;
47         } else if (rand1 == 6 && rand2 == 5 && rand3 == 6) {
48             return coinPrice * 10;
49         } else if (rand1 == 4 && rand2 == 4 && rand3 == 4) {
50             return coinPrice * 8;
51         } else if (rand1 == 3 && rand2 == 3 && rand3 == 3) {
52             return coinPrice * 6;
53         } else if (rand1 == 2 && rand2 == 2 && rand3 == 2) {
54             return coinPrice * 5;
55         } else if (rand1 == 1 && rand2 == 1 && rand3 == 1) {
56             return coinPrice * 3;
57         } else if ((rand1 == rand2) || (rand1 == rand3) || (rand2 == rand3)) {
58             return coinPrice;
59         } else {
60             return 0;
61         }
62     }
63 
64     function withdraw() public{
65         uint amount = pendingWithdrawals[msg.sender];
66 
67         pendingWithdrawals[msg.sender] = 0;
68 
69         msg.sender.transfer(amount);
70     }
71 
72     function balanceOf(address user) constant public returns(uint) {
73         return pendingWithdrawals[user];
74     }
75 
76     function setCoinPrice(uint _coinPrice) public onlyOwner {
77         coinPrice = _coinPrice;
78     }
79 
80     function() onlyOwner payable public {
81     }
82     
83     function addEther() payable public {}
84 
85     function cashout(uint _amount) onlyOwner public{
86         msg.sender.transfer(_amount);
87     }
88 
89     function randomGen(uint seed) private constant returns (uint randomNumber) {
90         return (uint(keccak256(blockhash(block.number-1), seed )) % 6) + 1;
91     }
92     
93     function killContract() public onlyOwner { //onlyOwner is custom modifier
94   	    selfdestruct(owner);  // `owner` is the owners address
95     }
96 
97 
98 }