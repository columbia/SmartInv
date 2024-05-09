1 pragma solidity ^0.4.19;
2 
3 contract Button {
4   event Pressed(address indexed presser, uint256 endBlock);
5   event Winner(address winner, uint256 winnings);
6   event Donation(address donator, uint256 amount);
7 
8   address public factory = msg.sender;
9 
10   uint64 public countdown;
11   uint64 public countdownDecrement;
12   uint64 public cooloffIncrement;
13   uint64 public pressFee;
14   uint64 public signupFee; // basis points * contract value
15 
16   address public lastPresser;
17   uint64 public endBlock;
18 
19   struct Presser {
20     uint64 numPresses;
21     uint64 cooloffEnd;
22   }
23 
24   mapping (address => Presser) public pressers;
25 
26   // Signup fee collection.
27   address public owner;
28   uint256 public rake;
29 
30   constructor (
31     uint64 _countdown, 
32     uint64 _countdownDecrement, 
33     uint64 _cooloffIncrement, 
34     uint64 _pressFee, 
35     uint64 _signupFee, 
36     address _sender
37   ) public payable {
38     countdown = _countdown;
39     countdownDecrement = _countdownDecrement;
40     cooloffIncrement = _cooloffIncrement;
41     pressFee = _pressFee;
42     signupFee = _signupFee;
43     lastPresser = _sender;
44 
45     owner = _sender;
46     endBlock = uint64(block.number + countdown);
47   }
48 
49   function getInfo() public view returns(
50     uint64, // Countdown
51     uint64, // CountdownDecrement
52     uint64, // CooloffIncrement
53     uint64, // PressFee
54     uint64, // SignupFee
55     address,// LastPresser
56     uint64, // EndBlock
57     uint64, // NumPresses
58     uint64, // CooloffEnd
59     uint256 // Pot
60   ) {
61     Presser p = pressers[msg.sender];
62     return (
63       countdown, 
64       countdownDecrement, 
65       cooloffIncrement, 
66       pressFee, 
67       signupFee, 
68       lastPresser, 
69       endBlock, 
70       p.numPresses,
71       p.cooloffEnd,
72       address(this).balance-rake
73     );
74   }
75 
76   function press() public payable {
77     require(block.number <= endBlock);
78 
79     Presser storage p = pressers[msg.sender];
80     require(p.cooloffEnd < block.number);
81 
82     uint256 change = msg.value-pressFee;
83     if (p.numPresses == 0) {
84       // balance - value will never be negative.
85       uint128 npf = _newPresserFee(address(this).balance - rake - msg.value);
86       change -= npf;
87       rake += npf;
88     }
89     // Breaks when pressFee+newPresserFee > 2^256
90     require(change <= msg.value);
91 
92     lastPresser = msg.sender;
93     uint64 finalCountdown = countdown - (p.numPresses*countdownDecrement);
94     if (finalCountdown < 10 || finalCountdown > countdown) {
95       finalCountdown = 10;
96     }
97     endBlock = uint64(block.number + finalCountdown);
98 
99     p.numPresses++;
100     p.cooloffEnd = uint64(block.number + (p.numPresses*cooloffIncrement));
101 
102     if (change > 0) {
103       // Re-entrancy protected by p.cooloffEnd guard.
104       msg.sender.transfer(change);
105     }
106 
107     emit Pressed(msg.sender, endBlock);
108   }
109 
110   function close() public {
111     require(block.number > endBlock);
112 
113     ButtonFactory f = ButtonFactory(factory);
114 
115     if (!owner.send(3*rake/4)){
116       // Owner can't accept their portion of the rake, so send it to the factory.
117       f.announceWinner.value(rake)(lastPresser, address(this).balance);
118     } else {
119       f.announceWinner.value(rake/4)(lastPresser, address(this).balance);
120     }
121 
122     emit Winner(lastPresser, address(this).balance);
123     selfdestruct(lastPresser);
124   }
125 
126   // Breaks when balance = 10^20 ether.
127   function newPresserFee() public view returns (uint128) {
128     return _newPresserFee(address(this).balance-rake);
129   }
130 
131   // Caller must assure that _balance < max_uint128.
132   function _newPresserFee(uint256 _balance) private view returns (uint128) {
133     return uint128((_balance * signupFee) / 10000);
134   }
135 
136   // Up the stakes...
137   function() payable public {
138     emit Donation(msg.sender, msg.value);
139   }
140 }
141 
142 // Hey, my name is Joe...
143 contract ButtonFactory {
144   event NewButton(address indexed buttonAddr, address indexed creator, uint64 countdown, uint64 countdownDec, uint64 cooloffInc, uint64 pressFee, uint64 signupFee);
145   event ButtonWinner(address indexed buttonAddr, address indexed winner, uint256 pot);
146 
147   address public owner = msg.sender;
148   uint256 public creationFee;
149 
150   mapping (address => bool) buttons;
151 
152   function setCreationFee(uint256 _fee) public {
153     require(msg.sender == owner);
154     creationFee = _fee;
155   }
156 
157   function createButton(
158     uint64 _countdown, 
159     uint64 _countdownDecrement, 
160     uint64 _cooloffIncrement, 
161     uint64 _pressFee, 
162     uint64 _signupFee
163   ) public payable returns (address) {
164     uint256 cf = ((_countdown / 1441) + 1) * creationFee;
165     require(msg.value >= cf);
166     address newButton = new Button(_countdown, _countdownDecrement, _cooloffIncrement, _pressFee, _signupFee, msg.sender);
167     buttons[newButton] = true;
168 
169     emit NewButton(newButton, msg.sender, _countdown, _countdownDecrement, _cooloffIncrement, _pressFee, _signupFee);
170     return newButton;
171   }
172 
173   function announceWinner(address _winner, uint256 _pot) public payable {
174     require(buttons[msg.sender]);
175     delete buttons[msg.sender];
176     emit ButtonWinner(msg.sender, _winner, _pot);
177   }
178 
179   function withdraw() public {
180     require(msg.sender == owner);
181     msg.sender.transfer(address(this).balance);
182   }
183 }