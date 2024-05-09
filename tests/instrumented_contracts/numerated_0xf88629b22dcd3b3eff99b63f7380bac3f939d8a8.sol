1 pragma solidity ^0.4.20;
2 
3 // v.1.0.0  2018.04.02
4 contract soccerGo {
5     address private owner;
6     mapping (address => bool) private admins;
7     
8     uint256 gameId = 0;
9     address callAddr = 0x0;
10     
11     event showPlayerAddress(address);
12     event showPlayerBet(uint256);
13     event showBetLeft(uint256);
14     event showBetRight(uint256);
15     event showResult(uint256);
16     event showCount(uint256);
17     event showTimeStamp(uint256);
18     event showWinValue(uint256);
19     
20     // Win limit
21     uint[] private slot_limit;
22     
23     // Dev fee
24     uint256 fee = 99;
25     
26     // Slot 1~10 win limit settings
27     function SetLimit(uint _slot, uint win_limit) onlyAdmins() public {
28         require(_slot > 0 && _slot < 12);
29         slot_limit[_slot - 1] = win_limit;
30     }
31     
32     function soccerGo() public {
33         owner = msg.sender;
34         admins[owner] = true;
35         
36         // RTP 97% ~ 98%
37         slot_limit.length = 11;
38         slot_limit[0] = 1170;
39         slot_limit[1] = 611;
40         slot_limit[2] = 416;
41         slot_limit[3] = 315;
42         slot_limit[4] = 253;
43         slot_limit[5] = 212;
44         slot_limit[6] = 182;
45         slot_limit[7] = 159;
46         slot_limit[8] = 141;
47         slot_limit[9] = 127;
48         slot_limit[10] = 115;
49     }
50     
51     function contractBalance() public view returns (uint256) {
52         return this.balance;
53     }
54     
55     // Bet limit
56     uint256 private min_value = 0.1 ether;
57     uint256 private max_value = 0.3 ether;
58     
59     // SetBetLimit
60     function setBetLimit(uint256 min, uint256 max) public onlyAdmins() {
61         uint256 base_bet = 0.1 ether;
62         min_value = base_bet * min;
63         max_value = base_bet * max;
64     }
65     
66     function setCalleeContract(address _caller) public onlyAdmins() {
67         callAddr = _caller;
68     }
69     
70     function playTypes(uint _slot_count) internal returns (uint) {
71         return (slot_limit[_slot_count - 1]);
72     }
73     
74     function getRandom(address _call) internal returns(uint) {
75         Callee c = Callee(_call);
76         return c.random(contractBalance(), msg.value, msg.sender);
77     }
78     
79     function setDevfee(uint256 _value) internal onlyAdmins() {
80         fee = _value;
81     }
82     
83     function buy(uint256 _left, uint256 _right)
84     public
85     payable
86     {
87         require(_left >= 1 && _left <= 13);
88         require(_right >= 1 && _right <= 13);
89         require(_right - _left >= 1);
90         require(msg.value >= min_value);
91         require(msg.value <= max_value);
92         
93         uint256 betValue = msg.value;
94         uint256 result = getRandom(callAddr);
95         uint256 types = playTypes(_right - _left - 1);
96         uint256 winValue = 0;
97         gameId++;
98         
99         if (result > _left && result < _right) {
100             winValue = betValue * types / 100;
101             msg.sender.transfer((winValue * fee) / 100);
102         }
103 
104         showPlayerAddress(msg.sender);
105         showPlayerBet(betValue);
106         showBetLeft(_left);
107         showBetRight(_right);
108         showResult(result);
109         showCount(gameId);
110         showTimeStamp(now);
111         showWinValue(winValue);
112     }
113     
114     /* Depoit */
115     function() payable public { }
116     
117     /* Withdraw */
118     function withdrawAll() onlyOwner() 
119     public 
120     {
121         owner.transfer(this.balance);
122     }
123 
124     function withdrawAmount(uint256 _amount) onlyOwner() 
125     public 
126     {
127         uint256 value = 1.0 ether;
128         owner.transfer(_amount * value);
129     }
130     
131     /* Modifiers */
132     modifier onlyOwner() 
133     {
134         require(owner == msg.sender);
135         _;
136     }
137 
138     modifier onlyAdmins() 
139     {
140         require(admins[msg.sender]);
141         _;
142     }
143   
144     /* Owner */
145     function setOwner (address _owner) onlyOwner() 
146     public 
147     {
148         owner = _owner;
149     }
150     
151     function addAdmin (address _admin) onlyOwner() 
152     public 
153     {
154         admins[_admin] = true;
155     }
156 
157     function removeAdmin (address _admin) onlyOwner() 
158     public 
159     {
160         delete admins[_admin];
161     }
162 }
163 
164 
165 contract Callee {
166     function random(uint256 _balance, uint256 _value, address _player) returns(uint);
167 }