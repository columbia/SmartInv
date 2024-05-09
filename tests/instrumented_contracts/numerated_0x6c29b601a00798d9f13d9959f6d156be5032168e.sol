1 pragma solidity ^0.4.24;
2 
3 /**
4  * Website: www.eth242.com
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
88         if (investors[_address].deposit < 2420000000000000000) {
89             return 242;
90         } else {
91             return 300;
92         }
93     }
94 }
95 
96 contract ETH242 {
97     using SafeMath for uint;
98 
99     address public owner;
100     address admin;
101     address marketing;
102 
103     uint waveStartUp;
104     uint nextPayDay;
105 
106     event LogInvestment(address indexed _addr, uint _value);
107     event LogPayment(address indexed _addr, uint _value);
108     event LogReferralInvestment(address indexed _referral, address indexed _referrer, uint _value);
109     event LogNewWave(uint _waveStartUp);
110 
111     InvestorsStorage private x;
112 
113     modifier notOnPause() {
114         require(waveStartUp <= block.timestamp);
115         _;
116     }
117 
118     function renounceOwnership() external {
119         require(msg.sender == owner);
120         owner = 0x0;
121     }
122 
123     function bytesToAddress(bytes _source) internal pure returns(address parsedReferrer) {
124         assembly {
125             parsedReferrer := mload(add(_source,0x14))
126         }
127         return parsedReferrer;
128     }
129 
130     function toReferrer(uint _value) internal {
131         address _referrer = bytesToAddress(bytes(msg.data));
132         if (_referrer != msg.sender) {
133             _referrer.transfer(_value / 20);
134             emit LogReferralInvestment(msg.sender, _referrer, _value);
135         }
136     }
137 
138     constructor() public {
139         owner = msg.sender;
140         admin = address(0xd38a013D7730564584C9aDBEeA83C1007E12E038);
141         marketing = address(0x81eCf0979668D3C6a812B404215B53310f14f451);
142         x = new InvestorsStorage();
143     }
144 
145     function getInfo(address _address) external view returns(uint deposit, uint amountToWithdraw) {
146         deposit = x.d(_address);
147         amountToWithdraw = block.timestamp.sub(x.c(_address)).div(1 days).mul(x.d(_address).mul(x.getInterest(_address)).div(10000));
148     }
149 
150     function() external payable {
151         if (msg.value == 0) {
152             withdraw();
153         } else {
154             invest();
155         }
156     }
157 
158     function invest() notOnPause public payable {
159 
160         admin.transfer(msg.value * 8 / 100);
161         marketing.transfer(msg.value * 5 / 100);
162 
163         if (x.d(msg.sender) > 0) {
164             withdraw();
165         }
166 
167         x.updateInfo(msg.sender, msg.value);
168 
169         if (msg.data.length == 20) {
170             toReferrer(msg.value);
171         }
172 
173         emit LogInvestment(msg.sender, msg.value);
174     }
175 
176     function withdraw() notOnPause public {
177 
178         if (address(this).balance < 100000000000000000) {
179             nextWave();
180             return;
181         }
182 
183         uint _payout = block.timestamp.sub(x.c(msg.sender)).div(1 days).mul(x.d(msg.sender).mul(x.getInterest(msg.sender)).div(10000));
184         x.updateCheckpoint(msg.sender);
185 
186         if (_payout > 0) {
187             msg.sender.transfer(_payout);
188             emit LogPayment(msg.sender, _payout);
189         }
190     }
191 
192     function nextWave() private {
193         x = new InvestorsStorage();
194         waveStartUp = block.timestamp + 7 days;
195         emit LogNewWave(waveStartUp);
196     }
197 }