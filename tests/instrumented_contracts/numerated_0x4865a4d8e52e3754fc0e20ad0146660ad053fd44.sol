1 pragma solidity ^0.5.0;
2 
3 contract Sopow {
4 
5     event NewStake(address source, uint256 hash, uint256 value, uint256 target, uint payment);
6     event NewMiner(address miner, uint256 hash, uint payment);
7     event Status(uint min, uint256 target, uint block);
8     event PaidOut(address miner, uint amount);
9 
10     address payable service = 0x935F545C5aA388B6846FB7A4c51ED1b180A4eFFF;
11 
12     //Set initial values
13     uint min = 1 wei;
14     uint finalBlock = 100000000;
15     uint lastBlock = 7000000;
16     address payable miner = 0x0000000000000000000000000000000000000000;
17     uint256 target = 0xffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffff;
18     uint256 total = 0;
19 
20     function getTargetAmount() public view returns(uint) {
21         return min;
22     }
23 
24     function getPayment() public view returns(uint) {
25         uint _total = getPreviousBalance();
26         return (_total / 2) + (_total / 4);
27     }
28 
29     function getTarget() public view returns(uint) {
30         return target;
31     }
32 
33     function getMiner() public view returns(address) {
34         return miner;
35     }
36 
37     function getFinalBlock() public view returns(uint) {
38         return finalBlock;
39     }
40 
41 
42     function getTotal() public view returns(uint) {
43         return total;
44     }
45 
46     // ---
47 
48     function getPreviousBalance() private view returns(uint) {
49         return address(this).balance - msg.value;
50     }
51 
52     function isFinished() private view returns(bool) {
53         return block.number >= getFinalBlock();
54     }
55 
56     function tooLate() private view returns(bool) {
57         return block.number >= getFinalBlock() + 11000;
58     }
59 
60     function work(uint _target, uint _total, uint _miner, uint _value) private pure returns(uint) {
61         return uint256(keccak256(abi.encodePacked(_target, _total, _miner, _value))) - _value;
62     }
63 
64     function getNextPayment() private view returns(uint) {
65         uint _total = address(this).balance;
66         return (_total / 2) + (_total / 4);
67     }
68 
69 
70     // ---
71 
72     function () external payable {
73         if (msg.sender != tx.origin) {
74             return;
75         }
76         payout();
77         uint _nextMinerPayment = getNextPayment();
78         uint _stake = msg.value;
79         uint _hash = work(target, total, uint256(miner), _stake);
80         emit NewStake(msg.sender, _hash, _stake, target, _nextMinerPayment);
81         if (_stake < min) {
82             return;
83         }
84         if (_hash < target) {
85             target = _hash;
86             miner = msg.sender;
87             min = _stake;
88             finalBlock = block.number + (block.number - lastBlock) + 42;
89             if (finalBlock > (block.number + 11000)) {
90                 finalBlock =  block.number + 11000;
91             }
92             lastBlock = block.number;
93             total += _stake;
94             emit NewMiner(miner, target, _nextMinerPayment);
95             emit Status(min, target, finalBlock);
96         }
97     }
98 
99     function payout() public {
100         if (!isFinished()) {
101             return;
102         }
103         // if nobody requested payout for more than 11000 blocks
104         if (tooLate()) {
105             service.transfer(getPreviousBalance() / 2);
106             min = min / 2;
107             target = 0x7fffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffff;
108             lastBlock  = block.number - 11000;
109             finalBlock = block.number + 11000;
110             return;
111         }
112         uint _total = getPreviousBalance();
113         uint _payment = getPayment();
114         uint _fee = _total / 8;
115         miner.transfer(_payment);
116         service.transfer(_fee);
117         emit PaidOut(miner, _payment);
118         min = _total / 64;
119         target = 0x7fffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffff;
120         lastBlock  = block.number - 11000;
121         finalBlock = block.number + 11000;
122         total = 0;
123         emit Status(min, target, finalBlock);
124     }
125 
126 }