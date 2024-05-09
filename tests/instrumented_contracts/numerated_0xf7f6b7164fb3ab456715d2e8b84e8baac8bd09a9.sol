1 pragma solidity ^0.4.19;
2 
3 contract Club {
4   struct Member {
5     bytes20 username;
6     uint64 karma; 
7     uint16 canWithdrawPeriod;
8     uint16 birthPeriod;
9   }
10 
11   // Manage members.
12   mapping(address => Member) public members;
13 }
14 
15 // Last person to press the button before time runs out, wins the pot.
16 // Button presses cost $.50
17 // You must pay .5% of the total pot to press the button the first time. (this amount is donated to the reddithereum community).
18 // After the first button press, a 6 hour countdown will begin, and you won't be able to press the button for 12 hours.
19 // Each time you press the button, the countdown will decrease by 10%, and cooldown will increase by 10%.
20 // The pot starts at $100.
21 contract Button {
22   event Pressed(address indexed presser, uint256 endBlock);
23   event Winner(address winner, uint256 winnings);
24 
25   uint64 public countdown;
26   uint64 public countdownDecrement;
27   uint64 public cooloffIncrement;
28 
29   uint64 public pressFee;
30   uint64 public signupFee; // basis points * contract value
31   Club public club; // collects signup, bypasses signup.
32 
33   address public lastPresser;
34   uint64 public endBlock;
35 
36   struct Presser {
37     uint64 numPresses;
38     uint64 cooloffEnd;
39   }
40 
41   mapping (address => Presser) public pressers;
42 
43   function Button(
44     uint64 _countdown, 
45     uint64 _countdownDecrement, 
46     uint64 _cooloffIncrement, 
47     uint64 _pressFee, 
48     uint64 _signupFee, 
49     address _club
50   ) public payable {
51     countdown = _countdown;
52     countdownDecrement = _countdownDecrement;
53     cooloffIncrement = _cooloffIncrement;
54     pressFee = _pressFee;
55     signupFee = _signupFee;
56     club = Club(_club);
57 
58     lastPresser = msg.sender;
59     endBlock = uint64(block.number + countdown);
60   }
61 
62   function press() public payable {
63     require(block.number <= endBlock);
64 
65     uint256 change = msg.value-pressFee;
66     Presser storage p = pressers[msg.sender];
67     require(p.cooloffEnd < block.number);
68 
69     if (p.numPresses == 0) {
70       // balance - value will never be negative.
71       uint128 npf = _newPresserFee(address(this).balance - msg.value);
72       change -= npf;
73       address(club).transfer(npf);
74     }
75     // Breaks when pressFee+presserFee > 2^256
76     require(change <= msg.value);
77 
78     lastPresser = msg.sender;
79     uint64 finalCountdown = countdown - (p.numPresses*countdownDecrement);
80     if (finalCountdown < 10 || finalCountdown > countdown) {
81       finalCountdown = 10;
82     }
83     endBlock = uint64(block.number + finalCountdown);
84 
85     p.numPresses++;
86     p.cooloffEnd = uint64(block.number + (p.numPresses*cooloffIncrement));
87 
88     if (change > 0) {
89       msg.sender.transfer(change);
90     }
91 
92     Pressed(msg.sender, endBlock);
93   }
94 
95   function close() public {
96     require(block.number > endBlock);
97     require(lastPresser == msg.sender);
98     Winner(msg.sender, address(this).balance);
99     selfdestruct(msg.sender);
100   }
101 
102   // Breaks when balance = 10^20 ether.
103   function newPresserFee() public view returns (uint128) {
104     return _newPresserFee(address(this).balance);
105   }
106 
107   function isMember() public view returns (bool) {
108     return _isMember();
109   }
110 
111   // Caller must assure that _balance < max_uint128.
112   function _newPresserFee(uint256 _balance) private view returns (uint128) {
113     if (_isMember()){
114       return 0;
115     }
116     return uint128((_balance * signupFee) / 10000);
117   }
118 
119   function _isMember() private view returns (bool) {
120     var(un, k, cwp, bp) = club.members(msg.sender);
121     // members have non-zero birthPeriods
122     return bp != 0;
123   }
124 
125   // Up the stakes...
126   function() payable public {}
127 }