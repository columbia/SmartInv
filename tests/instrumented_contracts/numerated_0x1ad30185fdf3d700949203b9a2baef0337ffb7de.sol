1 pragma solidity 0.4.25;
2 
3 
4 library SafeMath {
5 
6 
7     function mul(uint256 _a, uint256 _b) internal pure returns (uint256) {
8         if (_a == 0) {
9             return 0;
10         }
11 
12         uint256 c = _a * _b;
13         require(c / _a == _b);
14 
15         return c;
16     }
17 
18     function div(uint256 _a, uint256 _b) internal pure returns (uint256) {
19         require(_b > 0);
20         uint256 c = _a / _b;
21 
22         return c;
23     }
24 
25     function sub(uint256 _a, uint256 _b) internal pure returns (uint256) {
26         require(_b <= _a);
27         uint256 c = _a - _b;
28 
29         return c;
30     }
31 
32     function add(uint256 _a, uint256 _b) internal pure returns (uint256) {
33         uint256 c = _a + _b;
34         require(c >= _a);
35 
36         return c;
37     }
38 
39     function mod(uint256 a, uint256 b) internal pure returns (uint256) {
40         require(b != 0);
41         return a % b;
42     }
43 }
44 
45 contract GreenEthereus {
46     using SafeMath for uint;
47 
48     address public owner;
49     address marketing;
50     address admin;
51 
52     mapping (address => uint) index;
53     mapping (address => mapping (uint => uint)) deposit;
54     mapping (address => mapping (uint => uint)) finish;
55     mapping (address => uint) checkpoint;
56 
57     mapping (address => address) referrers;
58     mapping (address => uint) refBonus;
59 
60     event LogInvestment(address _addr, uint _value);
61     event LogPayment(address _addr, uint _value);
62     event LogNewReferrer(address _referral, address _referrer);
63     event LogReferralInvestment(address _referral, uint _value);
64 
65     constructor(address _marketing, address _admin) public {
66         owner = msg.sender;
67         marketing = _marketing;
68         admin = _admin;
69     }
70 
71     function renounceOwnership() external {
72         require(msg.sender == owner);
73         owner = 0x0;
74     }
75 
76     function bytesToAddress(bytes _source) internal pure returns(address parsedreferrer) {
77         assembly {
78             parsedreferrer := mload(add(_source,0x14))
79         }
80         return parsedreferrer;
81     }
82 
83     function setRef(uint _value) internal {
84         address _referrer = bytesToAddress(bytes(msg.data));
85         if (_referrer != msg.sender) {
86             referrers[msg.sender] = _referrer;
87             refBonus[msg.sender] += _value * 3 / 100;
88             refBonus[_referrer] += _value / 10;
89 
90             emit LogNewReferrer(msg.sender, _referrer);
91             emit LogReferralInvestment(msg.sender, msg.value);
92         }
93     }
94 
95     function() external payable {
96         if (msg.value == 0) {
97             withdraw();
98         } else {
99             invest();
100         }
101     }
102 
103     function invest() public payable {
104 
105         require(msg.value >= 50000000000000000);
106         admin.transfer(msg.value * 3 / 100);
107 
108         if (deposit[msg.sender][0] > 0 || refBonus[msg.sender] > 0) {
109             withdraw();
110             if (deposit[msg.sender][0] > 0) {
111                 index[msg.sender] += 1;
112             }
113         }
114 
115         checkpoint[msg.sender] = block.timestamp;
116         finish[msg.sender][index[msg.sender]] = block.timestamp + (40 * 1 days);
117         deposit[msg.sender][index[msg.sender]] = msg.value;
118 
119         if (referrers[msg.sender] != 0x0) {
120             marketing.transfer(msg.value * 7 / 50);
121             refBonus[referrers[msg.sender]] += msg.value / 10;
122             emit LogReferralInvestment(msg.sender, msg.value);
123         } else if (msg.data.length == 20) {
124             marketing.transfer(msg.value * 7 / 50);
125             setRef(msg.value);
126         } else {
127             marketing.transfer(msg.value * 6 / 25);
128         }
129 
130         emit LogInvestment(msg.sender, msg.value);
131     }
132 
133     function withdraw() public {
134 
135         uint _payout = refBonus[msg.sender];
136         refBonus[msg.sender] = 0;
137 
138         for (uint i = 0; i <= index[msg.sender]; i++) {
139             if (checkpoint[msg.sender] < finish[msg.sender][i]) {
140                 if (block.timestamp > finish[msg.sender][i]) {
141                     _payout = _payout.add((deposit[msg.sender][i].div(20)).mul(finish[msg.sender][i].sub(checkpoint[msg.sender])).div(1 days));
142                     checkpoint[msg.sender] = block.timestamp;
143                 } else {
144                     _payout = _payout.add((deposit[msg.sender][i].div(20)).mul(block.timestamp.sub(checkpoint[msg.sender])).div(1 days));
145                     checkpoint[msg.sender] = block.timestamp;
146                 }
147             }
148         }
149 
150         if (_payout > 0) {
151             msg.sender.transfer(_payout);
152 
153             emit LogPayment(msg.sender, _payout);
154         }
155     }
156 
157     function getInfo1(address _address) public view returns(uint Invested) {
158         uint _sum;
159         for (uint i = 0; i <= index[_address]; i++) {
160             if (block.timestamp < finish[_address][i]) {
161                 _sum += deposit[_address][i];
162             }
163         }
164         Invested = _sum;
165     }
166 
167     function getInfo2(address _address, uint _number) public view returns(uint Deposit_N) {
168         if (block.timestamp < finish[_address][_number - 1]) {
169             Deposit_N = deposit[_address][_number - 1];
170         } else {
171             Deposit_N = 0;
172         }
173     }
174 
175     function getInfo3(address _address) public view returns(uint Dividends, uint Bonuses) {
176         uint _payout;
177         for (uint i = 0; i <= index[_address]; i++) {
178             if (checkpoint[_address] < finish[_address][i]) {
179                 if (block.timestamp > finish[_address][i]) {
180                     _payout = _payout.add((deposit[_address][i].div(20)).mul(finish[_address][i].sub(checkpoint[_address])).div(1 days));
181                 } else {
182                     _payout = _payout.add((deposit[_address][i].div(20)).mul(block.timestamp.sub(checkpoint[_address])).div(1 days));
183                 }
184             }
185         }
186         Dividends = _payout;
187         Bonuses = refBonus[_address];
188     }
189 }