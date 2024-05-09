1 pragma solidity ^0.5.0;
2 
3 
4 
5 
6 
7 contract Sopow {
8 
9     event NewStake(address source, uint256 hash, uint256 value, uint256 target, uint payment);
10     event NewMiner(address miner, uint256 hash, uint payment);
11     event Status(uint min, uint256 target, uint block);
12     event PaidOut(address miner, uint amount);
13 
14     address payable service = 0x935F545C5aA388B6846FB7A4c51ED1b180A4eFFF;
15 
16     //Set initial values
17     uint min = 1 wei;
18     uint finalBlock = 100000000;
19     uint lastBlock = 7000000;
20     address payable miner = 0x0000000000000000000000000000000000000000;
21     uint256 target = 0xffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffff;
22 
23     function getTargetAmount() public view returns(uint) {
24         return min;
25     }
26 
27     function getPayment() public view returns(uint) {
28         uint _total = getPreviousBalance();
29         return (_total / 2) + (_total / 4);
30     }
31 
32     function getTarget() public view returns(uint) {
33         return target;
34     }
35 
36     function getMiner() public view returns(address) {
37         return miner;
38     }
39 
40     function getFinalBlock() public view returns(uint) {
41         return finalBlock;
42     }
43 
44     // ---
45 
46     function getPreviousBalance() private view returns(uint) {
47         return address(this).balance - msg.value;
48     }
49 
50     function isFinished() private view returns(bool) {
51         return block.number >= getFinalBlock();
52     }
53 
54     function tooLate() private view returns(bool) {
55         return block.number >= getFinalBlock() + 11000;
56     }
57 
58     function work(uint _target, uint _total, uint _value) private pure returns(uint) {
59         return uint256(keccak256(abi.encodePacked(_target, _total, _value))) - _value;
60     }
61 
62     function getNextPayment() private view returns(uint) {
63         uint _total = address(this).balance;
64         return (_total / 2) + (_total / 4);
65     }
66 
67     // ---
68 
69     function () external payable {
70         if (msg.sender != tx.origin) {
71             return;
72         }
73 
74         payout();
75 
76         uint total = getPreviousBalance();
77         uint nextMinerPayment = getNextPayment();
78         uint hash = work(target, total, msg.value);
79         uint stake = msg.value;
80         emit NewStake(msg.sender, hash, msg.value, target, nextMinerPayment);
81 
82         if (stake < min) {
83             return;
84         }
85 
86         if (hash < target) {
87             target = hash;
88             miner = msg.sender;
89             min = stake;
90             finalBlock = block.number + (block.number - lastBlock) + 42;
91             if (finalBlock > (block.number + 11000)) {
92                 finalBlock =  block.number + 11000;
93             }
94             lastBlock = block.number;
95             emit NewMiner(miner, target, nextMinerPayment);
96             emit Status(min, target, finalBlock);
97         }
98     }
99 
100     function payout() public {
101         if (!isFinished()) {
102             return;
103         }
104 
105         // if nobody requested payout for more than 11000 blocks
106         if (tooLate()) {
107             service.transfer(getPreviousBalance() / 2);
108             min = min / 2;
109             target = 0x7fffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffff;
110             lastBlock  = block.number - 11000;
111             finalBlock = block.number + 11000;
112             return;
113         }
114 
115         uint _total = getPreviousBalance();
116         uint _payment = getPayment();
117         uint _fee = _total / 8;
118 
119         miner.transfer(_payment);
120         service.transfer(_fee);
121         emit PaidOut(miner, _payment);
122 
123         min = _total / 64;
124         target = 0x7fffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffff;
125         lastBlock  = block.number - 11000;
126         finalBlock = block.number + 11000;
127         emit Status(min, target, finalBlock);
128     }
129 
130 }