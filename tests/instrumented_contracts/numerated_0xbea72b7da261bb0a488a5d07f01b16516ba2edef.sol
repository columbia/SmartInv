1 pragma solidity ^0.4.24;
2 
3 /**
4  * Website: www.project424.us
5  *
6  * Telegram: https://t.me/joinchat/HtqvCxCb_B0jVIJyq3Tdgg
7  *
8  * RECOMMENDED GAS LIMIT: 200000
9  * RECOMMENDED GAS PRICE: https://ethgasstation.info/
10  */
11 
12 library SafeMath {
13 
14     function mul(uint256 _a, uint256 _b) internal pure returns (uint256) {
15         if (_a == 0) {
16             return 0;
17         }
18 
19         uint256 c = _a * _b;
20         require(c / _a == _b);
21 
22         return c;
23     }
24 
25     function div(uint256 _a, uint256 _b) internal pure returns (uint256) {
26         require(_b > 0);
27         uint256 c = _a / _b;
28 
29         return c;
30     }
31 
32     function sub(uint256 _a, uint256 _b) internal pure returns (uint256) {
33         require(_b <= _a);
34         uint256 c = _a - _b;
35 
36         return c;
37     }
38 
39     function add(uint256 _a, uint256 _b) internal pure returns (uint256) {
40         uint256 c = _a + _b;
41         require(c >= _a);
42 
43         return c;
44     }
45 
46     function mod(uint256 a, uint256 b) internal pure returns (uint256) {
47         require(b != 0);
48         return a % b;
49     }
50 }
51 
52 contract InvestorsStorage {
53     address private owner;
54 
55     mapping (address => Investor) private investors;
56 
57     struct Investor {
58         uint deposit;
59         uint checkpoint;
60     }
61 
62     constructor() public {
63         owner = msg.sender;
64     }
65 
66     modifier onlyOwner() {
67         require(msg.sender == owner);
68         _;
69     }
70 
71     function updateInfo(address _address, uint _value) external onlyOwner {
72         investors[_address].deposit += _value;
73         investors[_address].checkpoint = block.timestamp;
74     }
75 
76     function updateCheckpoint(address _address) external onlyOwner {
77         investors[_address].checkpoint = block.timestamp;
78     }
79 
80     function d(address _address) external view onlyOwner returns(uint) {
81         return investors[_address].deposit;
82     }
83 
84     function c(address _address) external view onlyOwner returns(uint) {
85         return investors[_address].checkpoint;
86     }
87 
88     function getInterest(address _address) external view onlyOwner returns(uint) {
89         if (investors[_address].deposit < 4240000000000000000) {
90             return 424;
91         } else {
92             return 600;
93         }
94     }
95 }
96 
97 contract Project424 {
98     using SafeMath for uint;
99 
100     address public owner;
101     address admin;
102     address marketing;
103 
104     uint waveStartUp;
105     uint nextPayDay;
106 
107     event LogInvestment(address indexed _addr, uint _value);
108     event LogPayment(address indexed _addr, uint _value);
109     event LogReferralInvestment(address indexed _referral, address indexed _referrer, uint _value);
110     event LogNewWave(uint _waveStartUp);
111 
112     InvestorsStorage private x;
113 
114     modifier notOnPause() {
115         require(waveStartUp <= block.timestamp);
116         _;
117     }
118 
119     function renounceOwnership() external {
120         require(msg.sender == owner);
121         owner = 0x0;
122     }
123 
124     function bytesToAddress(bytes _source) internal pure returns(address parsedReferrer) {
125         assembly {
126             parsedReferrer := mload(add(_source,0x14))
127         }
128         return parsedReferrer;
129     }
130 
131     function toReferrer(uint _value) internal {
132         address _referrer = bytesToAddress(bytes(msg.data));
133         if (_referrer != msg.sender) {
134             _referrer.transfer(_value / 20);
135             emit LogReferralInvestment(msg.sender, _referrer, _value);
136         }
137     }
138 
139     constructor(address _admin, address _marketing) public {
140         owner = msg.sender;
141         admin = _admin;
142         marketing = _marketing;
143         x = new InvestorsStorage();
144     }
145 
146     function getInfo(address _address) external view returns(uint deposit, uint amountToWithdraw) {
147         deposit = x.d(_address);
148         amountToWithdraw = block.timestamp.sub(x.c(_address)).div(1 days).mul(x.d(_address).mul(x.getInterest(_address)).div(10000));
149     }
150 
151     function() external payable {
152         if (msg.value == 0) {
153             withdraw();
154         } else {
155             invest();
156         }
157     }
158 
159     function invest() notOnPause public payable {
160 
161         admin.transfer(msg.value * 5 / 100);
162         marketing.transfer(msg.value / 10);
163 
164         if (x.d(msg.sender) > 0) {
165             withdraw();
166         }
167 
168         x.updateInfo(msg.sender, msg.value);
169 
170         if (msg.data.length == 20) {
171             toReferrer(msg.value);
172         }
173 
174         emit LogInvestment(msg.sender, msg.value);
175     }
176 
177     function withdraw() notOnPause public {
178 
179         if (address(this).balance < 100000000000000000) {
180             nextWave();
181             return;
182         }
183 
184         uint _payout = block.timestamp.sub(x.c(msg.sender)).div(1 days).mul(x.d(msg.sender).mul(x.getInterest(msg.sender)).div(10000));
185         x.updateCheckpoint(msg.sender);
186 
187         if (_payout > 0) {
188             msg.sender.transfer(_payout);
189             emit LogPayment(msg.sender, _payout);
190         }
191     }
192 
193     function nextWave() private {
194         x = new InvestorsStorage();
195         waveStartUp = block.timestamp + 7 days;
196         emit LogNewWave(waveStartUp);
197     }
198 }