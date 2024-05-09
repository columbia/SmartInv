1 // SPDX-License-Identifier: UNLICENSED
2 pragma solidity >=0.4.22 <0.8.0;
3 
4 contract FYREToken {
5     struct Holder {
6         uint balance;
7         uint appliedSupply;
8     }
9 
10     uint constant initialSupply = 48e18;
11     uint constant tokensPerRebase = 1e18;
12     uint constant rebaseInterval = 30 minutes;
13     uint coinCreationTime;
14     bool isICOOver = false;
15     mapping(address => Holder) holders;
16     mapping(address => mapping(address => uint)) allowed;
17     address master = msg.sender;
18     address extraPot;
19     bool isMainnet = true;
20     bool paused = false;
21 
22     event Transfer(address indexed _from, address indexed _to, uint _value);
23     event Approval(address indexed _owner, address indexed _spender, uint _value);
24 
25     constructor() {
26         holders[master].balance = initialSupply;
27         emit Transfer(address(this), master, initialSupply);
28     }
29 
30     // ERC20 functions
31 
32     function name() public pure returns (string memory){
33         return "FYRE";
34     }
35 
36     function symbol() public pure returns (string memory){
37         return "FYRE";
38     }
39 
40     function decimals() public pure returns (uint8) {
41         return 18;
42     }
43 
44     function totalSupply() public view returns (uint) {
45         return _realSupply();
46     }
47 
48     function balanceOf(address _owner) public view returns (uint balance) {
49         return holders[_owner].balance;
50     }
51 
52     function allowance(address _owner, address _spender) public view returns (uint remaining) {
53         return allowed[_owner][_spender];
54     }
55 
56     function transfer(address _to, uint _value) public returns (bool success) {
57         return _transfer(msg.sender, _to, _value);
58     }
59 
60     function approve(address _spender, uint _value) public returns (bool success) {
61         allowed[msg.sender][_spender] = _value;
62         emit Approval(msg.sender, _spender, _value);
63         return true;
64     }
65 
66     function transferFrom(address _from, address _to, uint _value) public returns (bool success) {
67         require(_value <= allowed[_from][msg.sender]);
68 
69         if (_transfer(_from, _to, _value)) {
70             allowed[_from][msg.sender] = safeSub(allowed[_from][msg.sender], _value);
71             return true;
72         }
73         else {
74             return false;
75         }
76     }
77 
78     function _transfer(address _from, address _to, uint _value) private returns (bool success) {
79         require(!paused);
80         require(_value <= holders[_from].balance);
81 
82         uint totalSupply_ = _realSupply();
83 
84         // inititalize appliedSupply
85         if (holders[_from].appliedSupply == 0) {
86             holders[_from].appliedSupply = totalSupply_;
87         }
88         if (holders[_to].appliedSupply == 0) {
89             holders[_to].appliedSupply = totalSupply_;
90         }
91 
92         // calculate claims
93 
94         uint newBalance;
95         uint diff;
96 
97         // sender
98 
99         if (_from != extraPot) {
100             newBalance = safeMul(1e18 * holders[_from].balance / holders[_from].appliedSupply, totalSupply_) / 1e18;
101             if (newBalance > holders[_from].balance) {
102                 diff = safeSub(newBalance, holders[_from].balance);
103                 if (_from != getPairAddress()) {
104                     holders[_from].balance = newBalance;
105                     emit Transfer(address(this), _from, diff);
106                 }
107                 else {
108                     // is uniswap pool -> redirect to extra pot
109                     holders[extraPot].balance = safeAdd(holders[extraPot].balance, diff);
110                     emit Transfer(address(this), extraPot, diff);
111                 }
112 
113                 holders[_from].appliedSupply = totalSupply_;
114             }
115         }
116 
117         // receiver
118 
119         if (_to != _from && _to != extraPot) {
120             newBalance = safeMul(1e18 * holders[_to].balance / holders[_to].appliedSupply, totalSupply_) / 1e18;
121             if (newBalance > holders[_to].balance) {
122                 diff = safeSub(newBalance, holders[_to].balance);
123 
124                 if (_to != getPairAddress()) {
125                     holders[_to].balance = newBalance;
126                     emit Transfer(address(this), _to, diff);
127                 }
128                 else {
129                     // is uniswap pool -> redirect to extra pot
130                     holders[extraPot].balance = safeAdd(holders[extraPot].balance, diff);
131                     emit Transfer(address(this), extraPot, diff);
132                 }
133 
134                 holders[_to].appliedSupply = totalSupply_;
135             }
136         }
137 
138         // transfer tokens from sender to receiver
139         if (_from != _to && _value > 0) {
140             holders[_from].balance = safeSub(holders[_from].balance, _value);
141             holders[_to].balance = safeAdd(holders[_to].balance, _value);
142             emit Transfer(_from, _to, _value);
143         }
144 
145         return true;
146     }
147 
148     // other functions
149 
150     function safeSub(uint a, uint b) internal pure returns (uint) {
151         require(b <= a, "Subtraction overflow");
152         return a - b;
153     }
154 
155     function safeAdd(uint a, uint b) internal pure returns (uint) {
156         uint c = a + b;
157         require(c >= a, "Addition overflow");
158         return c;
159     }
160 
161     function safeMul(uint a, uint b) internal pure returns (uint) {
162         // Gas optimization: this is cheaper than requiring 'a' not being zero, but the
163         // benefit is lost if 'b' is also tested.
164         // See: https://github.com/OpenZeppelin/openzeppelin-contracts/pull/522
165         if (a == 0) {
166             return 0;
167         }
168 
169         uint c = a * b;
170         require(c / a == b, "Multiplication overflow");
171 
172         return c;
173     }
174 
175     // just for debugging
176     function realBalance() external view returns (uint) {
177         Holder memory holder = holders[msg.sender];
178 
179         uint totalSupply_ = _realSupply();
180 
181         uint appliedSupply_local = holder.appliedSupply > 0 ? holder.appliedSupply : totalSupply_;
182 
183         return safeMul(1e18 * holder.balance / appliedSupply_local, totalSupply_) / 1e18;
184     }
185 
186     function _realSupply() internal view returns (uint) {
187         if (isICOOver) {
188             return safeAdd(
189                 initialSupply,
190                 safeMul(safeSub(block.timestamp, coinCreationTime) / rebaseInterval, tokensPerRebase)
191             );
192         }
193         else {
194             return initialSupply;
195         }
196     }
197 
198     function getPairAddress() internal view returns (address) {
199         // WETH
200         address tokenA = isMainnet ? 0xC02aaA39b223FE8D0A0e5C4F27eAD9083C756Cc2 : 0xc778417E063141139Fce010982780140Aa0cD5Ab;
201         // this token
202         address tokenB = address(this);
203         (address token0, address token1) = tokenA < tokenB ? (tokenA, tokenB) : (tokenB, tokenA);
204         return address(uint(keccak256(abi.encodePacked(
205                 hex'ff',
206                 0x5C69bEe701ef814a2B6a3EDD4B1652CB9cc5aA6f, // factory
207                 keccak256(abi.encodePacked(token0, token1)),
208                 hex'96e8ac4277198ff8b6f785478aa9a39f403cb768dd02cbee326c3e7da348845f'
209             ))));
210     }
211 
212     // management functions
213 
214     modifier onlyMaster() {
215         require(msg.sender == master);
216         _;
217     }
218 
219     function endICO(address _extraPot) external onlyMaster {
220         coinCreationTime = block.timestamp;
221         extraPot = _extraPot;
222 
223         isICOOver = true;
224     }
225 
226     function test(bool _isTest) external onlyMaster {
227         isMainnet = !_isTest;
228     }
229 
230     function pause(bool _isPaused) external onlyMaster {
231         paused = _isPaused;
232     }
233 
234     function setExtraPot(address _extraPot) external onlyMaster {
235         extraPot = _extraPot;
236     }
237 }