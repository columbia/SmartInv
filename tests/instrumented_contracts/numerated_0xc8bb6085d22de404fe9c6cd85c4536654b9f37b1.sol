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
45 contract GreenEthereus1 {
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
60     event LogInvestment(address indexed _addr, uint _value);
61     event LogPayment(address indexed _addr, uint _value);
62     event LogReferralInvestment(address indexed _referrer, address indexed _referral, uint _value);
63 
64     constructor(address _marketing, address _admin) public {
65         owner = msg.sender;
66         marketing = _marketing;
67         admin = _admin;
68     }
69 
70     function renounceOwnership() external {
71         require(msg.sender == owner);
72         owner = 0x0;
73     }
74 
75     function bytesToAddress(bytes _source) internal pure returns(address parsedreferrer) {
76         assembly {
77             parsedreferrer := mload(add(_source,0x14))
78         }
79         return parsedreferrer;
80     }
81 
82     function setRef(uint _value) internal {
83         address _referrer = bytesToAddress(bytes(msg.data));
84         if (_referrer != msg.sender && getInfo3(_referrer) > 0) {
85             referrers[msg.sender] = _referrer;
86             marketing.transfer(msg.value * 7 / 50);
87             refBonus[msg.sender] += _value * 3 / 100;
88             refBonus[_referrer] += _value / 10;
89 
90             emit LogReferralInvestment(_referrer, msg.sender, msg.value);
91         } else {
92             marketing.transfer(msg.value * 6 / 25);
93         }
94     }
95 
96     function() external payable {
97         if (msg.value < 50000000000000000) {
98             msg.sender.transfer(msg.value);
99             withdraw();
100         } else {
101             invest();
102         }
103     }
104 
105     function invest() public payable {
106 
107         require(msg.value >= 50000000000000000);
108         admin.transfer(msg.value * 3 / 100);
109 
110         if (deposit[msg.sender][0] > 0 || refBonus[msg.sender] > 0) {
111             withdraw();
112             if (deposit[msg.sender][0] > 0) {
113                 index[msg.sender] += 1;
114             }
115         }
116 
117         checkpoint[msg.sender] = block.timestamp;
118         finish[msg.sender][index[msg.sender]] = block.timestamp + (20 * 1 days);
119         deposit[msg.sender][index[msg.sender]] = msg.value;
120 
121         if (referrers[msg.sender] != 0x0) {
122             marketing.transfer(msg.value * 7 / 50);
123             refBonus[referrers[msg.sender]] += msg.value / 10;
124             emit LogReferralInvestment(referrers[msg.sender], msg.sender, msg.value);
125         } else if (msg.data.length == 20) {
126             setRef(msg.value);
127         } else {
128             marketing.transfer(msg.value * 6 / 25);
129         }
130 
131         emit LogInvestment(msg.sender, msg.value);
132     }
133 
134     function withdraw() public {
135 
136         uint _payout = refBonus[msg.sender];
137         refBonus[msg.sender] = 0;
138 
139         _payout = _payout.add(getInfo3(msg.sender));
140 
141         if (_payout > 0) {
142             checkpoint[msg.sender] = block.timestamp;
143             msg.sender.transfer(_payout);
144 
145             emit LogPayment(msg.sender, _payout);
146         }
147     }
148 
149     function getInfo1(address _address) public view returns(uint Invested) {
150         uint _sum;
151         for (uint i = 0; i <= index[_address]; i++) {
152             if (block.timestamp < finish[_address][i]) {
153                 _sum += deposit[_address][i];
154             }
155         }
156         Invested = _sum;
157     }
158 
159     function getInfo2(address _address, uint _number) public view returns(uint Deposit_N) {
160         if (block.timestamp < finish[_address][_number - 1]) {
161             Deposit_N = deposit[_address][_number - 1];
162         } else {
163             Deposit_N = 0;
164         }
165     }
166 
167     function getInfo3(address _address) public view returns(uint Dividends) {
168 
169         uint _payout;
170         uint _multiplier;
171 
172         if (block.timestamp > checkpoint[_address] + 2 days) {
173             _multiplier = 1;
174         }
175 
176         for (uint i = 0; i <= index[_address]; i++) {
177 
178             if (checkpoint[_address] < finish[_address][i]) {
179 
180                 if (block.timestamp > finish[_address][i]) {
181 
182                     if (finish[_address][i] > checkpoint[_address] + 2 days) {
183 
184                         _payout = _payout.add((deposit[_address][i].mul(_multiplier.mul(12).add(70)).div(1000)).mul(finish[_address][i].sub(checkpoint[_address].add(_multiplier.mul(2 days)))).div(1 days));
185                         _payout = _payout.add(deposit[_address][i].mul(14).div(100).mul(_multiplier));
186 
187                     } else {
188 
189                         _payout = _payout.add((deposit[_address][i].mul(7).div(100)).mul(finish[_address][i].sub(checkpoint[_address])).div(1 days));
190 
191                     }
192                     
193                 } else {
194 
195                     _payout = _payout.add((deposit[_address][i].mul(_multiplier.mul(12).add(70)).div(1000)).mul(block.timestamp.sub(checkpoint[_address].add(_multiplier.mul(2 days)))).div(1 days));
196                     _payout = _payout.add(deposit[_address][i].mul(14).div(100).mul(_multiplier));
197 
198                 }
199             }
200         }
201         Dividends = _payout;
202     }
203 
204     function getInfo4(address _address) public view returns(uint Bonuses) {
205         Bonuses = refBonus[_address];
206     }
207 }