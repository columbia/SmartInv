1 pragma solidity ^0.4.24;
2 
3 /**
4  * Website: www.project567.pw
5  *
6  *
7  * RECOMMENDED GAS LIMIT: 200000
8  * RECOMMENDED GAS PRICE: https://ethgasstation.info/
9  */
10 
11 library SafeMath {
12 
13     function mul(uint256 _a, uint256 _b) internal pure returns (uint256) {
14         if (_a == 0) {
15             return 0;
16         }
17 
18         uint256 c = _a * _b;
19         require(c / _a == _b);
20 
21         return c;
22     }
23 
24     function div(uint256 _a, uint256 _b) internal pure returns (uint256) {
25         require(_b > 0);
26         uint256 c = _a / _b;
27 
28         return c;
29     }
30 
31     function sub(uint256 _a, uint256 _b) internal pure returns (uint256) {
32         require(_b <= _a);
33         uint256 c = _a - _b;
34 
35         return c;
36     }
37 
38     function add(uint256 _a, uint256 _b) internal pure returns (uint256) {
39         uint256 c = _a + _b;
40         require(c >= _a);
41 
42         return c;
43     }
44 
45     function mod(uint256 a, uint256 b) internal pure returns (uint256) {
46         require(b != 0);
47         return a % b;
48     }
49 }
50 
51 contract InvestorsStorage {
52     address private owner;
53 
54     mapping (address => Investor) private investors;
55 
56     struct Investor {
57         uint deposit;
58         uint checkpoint;
59     }
60 
61     constructor() public {
62         owner = msg.sender;
63     }
64 
65     modifier onlyOwner() {
66         require(msg.sender == owner);
67         _;
68     }
69 
70     function updateInfo(address _address, uint _value) external onlyOwner {
71         investors[_address].deposit += _value;
72         investors[_address].checkpoint = block.timestamp;
73     }
74 
75     function updateCheckpoint(address _address) external onlyOwner {
76         investors[_address].checkpoint = block.timestamp;
77     }
78 
79     function d(address _address) external view onlyOwner returns(uint) {
80         return investors[_address].deposit;
81     }
82 
83     function c(address _address) external view onlyOwner returns(uint) {
84         return investors[_address].checkpoint;
85     }
86 
87     function getInterest(address _address) external view onlyOwner returns(uint) {
88         if (investors[_address].deposit <= 3000000000000000000) {
89             return 500;
90         } else if (investors[_address].deposit <= 6000000000000000000) {
91             return 600;
92         } else {
93             return 700;
94         }
95     }
96 }
97 
98 contract Project567 {
99     using SafeMath for uint;
100 
101     address public owner;
102     address admin;
103     address marketing;
104 
105     uint waveStartUp;
106     uint nextPayDay;
107 
108     event LogInvestment(address indexed _addr, uint _value);
109     event LogPayment(address indexed _addr, uint _value);
110     event LogReferralInvestment(address indexed _referral, address indexed _referrer, uint _value);
111     event LogNewWave(uint _waveStartUp);
112 
113     InvestorsStorage private x;
114 
115     modifier notOnPause() {
116         require(waveStartUp <= block.timestamp);
117         _;
118     }
119 
120     function renounceOwnership() external {
121         require(msg.sender == owner);
122         owner = 0x0;
123     }
124 
125     function bytesToAddress(bytes _source) internal pure returns(address parsedReferrer) {
126         assembly {
127             parsedReferrer := mload(add(_source,0x14))
128         }
129         return parsedReferrer;
130     }
131 
132     function toReferrer(uint _value) internal {
133         address _referrer = bytesToAddress(bytes(msg.data));
134         if (_referrer != msg.sender) {
135             _referrer.transfer(_value / 20);
136             emit LogReferralInvestment(msg.sender, _referrer, _value);
137         }
138     }
139 
140     constructor(address _admin, address _marketing) public {
141         owner = msg.sender;
142         admin = _admin;
143         marketing = _marketing;
144         x = new InvestorsStorage();
145     }
146 
147     function getInfo(address _address) external view returns(uint deposit, uint amountToWithdraw) {
148         deposit = x.d(_address);
149         amountToWithdraw = block.timestamp.sub(x.c(_address)).div(1 days).mul(x.d(_address).mul(x.getInterest(_address)).div(10000));
150     }
151 
152     function() external payable {
153         if (msg.value == 0) {
154             withdraw();
155         } else {
156             invest();
157         }
158     }
159 
160     function invest() notOnPause public payable {
161 
162         admin.transfer(msg.value * 5 / 100);
163         marketing.transfer(msg.value / 10);
164 
165         if (x.d(msg.sender) > 0) {
166             withdraw();
167         }
168 
169         x.updateInfo(msg.sender, msg.value);
170 
171         if (msg.data.length == 20) {
172             toReferrer(msg.value);
173         }
174 
175         emit LogInvestment(msg.sender, msg.value);
176     }
177 
178     function withdraw() notOnPause public {
179 
180         if (address(this).balance < 100000000000000000) {
181             nextWave();
182             return;
183         }
184 
185         uint _payout = block.timestamp.sub(x.c(msg.sender)).div(1 days).mul(x.d(msg.sender).mul(x.getInterest(msg.sender)).div(10000));
186         x.updateCheckpoint(msg.sender);
187 
188         if (_payout > 0) {
189             msg.sender.transfer(_payout);
190             emit LogPayment(msg.sender, _payout);
191         }
192     }
193 
194     function nextWave() private {
195         x = new InvestorsStorage();
196         waveStartUp = block.timestamp + 7 days;
197         emit LogNewWave(waveStartUp);
198     }
199 }