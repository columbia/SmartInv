1 pragma solidity 0.5.12;
2 
3 contract Owned {
4     address public owner;
5     address public pendingOwner;
6 
7     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
8 
9     constructor() public {
10         owner = msg.sender;
11     }
12 
13     modifier onlyOwner {
14         require(msg.sender == owner);
15         _;
16     }
17 
18     function transferOwnership(address newOwner) public onlyOwner {
19         require(newOwner != address(0));
20         pendingOwner = newOwner;
21     }
22 
23     function acceptOwnership() public {
24         require(msg.sender == pendingOwner);
25         emit OwnershipTransferred(owner, pendingOwner);
26         owner = pendingOwner;
27         pendingOwner = address(0);
28     }
29 }
30 
31 // Math operations with safety checks that throw on error
32 library SafeMath {
33     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
34         return sub(a, b, "SafeMath: subtraction overflow");
35     }
36     // Subtracts two numbers, throws on overflow (i.e. if subtrahend is greater than minuend).
37     function sub(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
38         require(b <= a, errorMessage);
39         uint256 c = a - b;
40         return c;
41     }
42     // Adds two numbers, throws on overflow.
43     function add(uint256 a, uint256 b) internal pure returns (uint256) {
44         uint256 c = a + b;
45         require(c >= a, "SafeMath: addition overflow");
46         return c;
47     }
48     function mul(uint256 a, uint256 b) internal pure returns (uint256) {
49         if (a == 0) {
50             return 0;
51         }
52         uint256 c = a * b;
53         require(c / a == b, "SafeMath: multiplication overflow");
54         return c;
55     }
56     function div(uint256 a, uint256 b) internal pure returns (uint256) {
57         require(b > 0, "SafeMath: division by zero");
58         uint256 c = a / b;
59         return c;
60     }
61 }
62 
63 // ERC20 interface https://github.com/ethereum/EIPs/blob/master/EIPS/eip-20.md
64 interface IERC20 {
65     function totalSupply() external view returns (uint256);
66     function balanceOf(address account) external view returns (uint256);
67     function transfer(address recipient, uint256 amount) external returns (bool);
68     function allowance(address owner, address spender) external view returns (uint256);
69     function approve(address spender, uint256 amount) external returns (bool);
70     function transferFrom(address sender, address recipient, uint256 amount) external returns (bool);
71     
72     event Transfer(address indexed from, address indexed to, uint256 value);
73     event Approval(address indexed owner, address indexed spender, uint256 value);
74 }
75 
76 // https://github.com/bokkypoobah/BokkyPooBahsDateTimeLibrary
77 contract TimeLib {
78     function getMonth(uint timestamp) public pure returns (uint month);
79 }
80 
81 contract ERC20 is IERC20, Owned {
82     using SafeMath for uint256;
83     
84     mapping (address => uint256) private balances;
85     mapping (address => mapping (address => uint256)) private allowances;
86     mapping (uint256 => bool) private fundF;
87 
88     string public name = "P2PGuru";
89     string public symbol = "P2PG";
90     uint8 public decimals = 18;
91     uint256 private _totalSupply;
92     uint256 internal nextQuarter = 1;
93     
94     address internal A;
95     address internal B = 0xd85647bb4a3d9927d210E11cCB16198f676760E5;
96     address internal C = 0xa16989E1Da366cBD7dbA477d4d4bAE64FF5D2aC8;
97     address internal D = 0x0397C4cA1bA021150295A6FD211Ac5fAD4364207;
98     address internal E = 0x89cdae2AED91190aEFBe45F5e89D511de70Abdb4; // Guru fund
99     address internal F = 0x1474e84ffd20277d043eb5F71E11e20D0be9598D;
100     address internal G = 0xEC1558E2eEb5005e111dA667AD218b7f8De60029;
101     address internal H = 0x3093a574B833Bb0209cF7d3127EB2C0D529EC053;
102     address internal I = 0x90e20ac80483a81bbAA255a83E8eaaB08b3973Dc;
103     address internal J = 0x0c47528CD8dD2E1bfc87C537923DF9bEFcF5911c;
104     address internal K = 0x728b4e873A14c138d6632CB97d8224D941E5eA23;
105     address internal L = 0xf5682F93efA570236858B7Cfb6E412B916fc3A05;
106     address internal M = 0xAecF030FaB338950427A99Bf8639A6E286BcA8B2;
107 
108     constructor() public {
109         _totalSupply = 268000000 * 1 ether;
110         balances[owner] = _totalSupply;
111         emit Transfer(address(0), owner, balances[owner]);
112         A = owner;
113         _transfer(A, B, 26800000 * 1 ether); // 10%
114         _transfer(A, C, 26800000 * 1 ether); // 10%
115         _transfer(A, D, 13400000 * 1 ether); // 5%
116         _transfer(A, E, 69680000 * 1 ether); // 26%
117     }
118     
119     modifier onlyGuruFund {
120         require(msg.sender == E);
121         _;
122     }
123     
124     modifier exceptGuruFund {
125         require(msg.sender != E);
126         _;
127     }
128     
129     function totalSupply() public view returns (uint256) {
130         return _totalSupply;
131     }
132     
133     function balanceOf(address account) public view returns (uint256) {
134         return balances[account];
135     }
136 
137     function allowance(address owner, address spender) public view returns (uint remaining) {
138         return allowances[owner][spender];
139     }
140 
141     function transfer(address recipient, uint256 amount) public exceptGuruFund returns (bool success) {
142         _transfer(msg.sender, recipient, amount);
143         return true;
144     }
145     
146     function _transfer(address sender, address recipient, uint256 amount) internal {
147         require(sender != address(0), "ERC20: transfer from the zero address");
148         require(recipient != address(0), "ERC20: transfer to the zero address");
149 
150         balances[sender] = balances[sender].sub(amount, "ERC20: transfer amount exceeds balance");
151         balances[recipient] = balances[recipient].add(amount);
152         emit Transfer(sender, recipient, amount);
153     }
154 
155     function transferFrom(address sender, address recipient, uint256 amount) public returns (bool success) {
156         require(sender != address(0));
157         require(recipient != address(0));
158         require(balances[sender] >= amount);
159         require(allowances[sender][msg.sender] >= amount);
160 
161         balances[sender] = balances[sender].sub(amount);
162         balances[recipient] = balances[recipient].add(amount);
163         allowances[sender][msg.sender] = allowances[sender][msg.sender].sub(amount);
164         emit Transfer(sender, recipient, amount);
165         return true;
166     }
167 
168     function approve(address _spender, uint256 _value) public exceptGuruFund returns (bool) {
169         require(_spender != address(0));
170 
171         allowances[msg.sender][_spender] = _value;
172         emit Approval(msg.sender, _spender, _value);
173         return true;
174     }
175     
176     function tokensByPercentage(uint256 val, uint256 p) public pure returns (uint256) {
177         return val.div(100).mul(p);
178     }
179     
180     function getQuarter() internal view returns (uint256) {
181         TimeLib tl = TimeLib(0x23d23d8F243e57d0b924bff3A3191078Af325101);
182         return (tl.getMonth(now) - 1).div(3) + 1;
183     }
184         
185     function sendDividendsFromE() public onlyGuruFund {
186         uint256 currenQuarter = getQuarter();
187         if (currenQuarter == nextQuarter) {
188             if (nextQuarter == 4) {
189                 nextQuarter = 1;
190             } else {
191                 nextQuarter = nextQuarter.add(1);
192             }
193             uint256 tokensToBurn = tokensByPercentage(balances[E], 10); // 10%
194             _burn(E, tokensToBurn); // burn 10%
195             uint256 tokensToSend = balances[E].div(2); // 50%
196             if (now > 1585699200) { // sending tokens to this address will begin in the second quarter at 01.04.2020 till infinity
197                 _transfer(E, G, tokensByPercentage(tokensToSend, 30)); // 30%
198             }
199             _transfer(E, H, tokensByPercentage(tokensToSend, 19)); // 19%
200             _transfer(E, I, tokensByPercentage(tokensToSend, 18)); // 18%
201             _transfer(E, J, tokensByPercentage(tokensToSend, 10)); // 10%
202             _transfer(E, K, tokensByPercentage(tokensToSend, 10)); // 10%
203             _transfer(E, L, tokensByPercentage(tokensToSend, 10)); // 10%
204             _transfer(E, M, tokensByPercentage(tokensToSend, 3)); // 3%
205         }
206     }
207     
208     function _burn(address account, uint256 amount) internal {
209         require(account != address(0), "ERC20: burn from the zero address");
210         balances[account] = balances[account].sub(amount, "ERC20: burn amount exceeds balance");
211         _totalSupply = _totalSupply.sub(amount);
212         emit Transfer(account, address(0), amount);
213     }
214     
215     function sendTokensToF() public onlyOwner {
216         uint256 tokensToSend;
217         if (now > 1575158400 && now < 1577836800 && fundF[1575158400] == false) { // 01.12.2019, 8%
218             tokensToSend = 10505600 * 1 ether;
219             fundF[1575158400] = true;
220         } else if (now > 1577836800 && now < 1580515200 && fundF[1577836800] == false) { // 01.01.2020, 7.5%
221             tokensToSend = 9849000 * 1 ether;
222             fundF[1577836800] = true;
223         } else if (now > 1580515200 && now < 1583020800 && fundF[1580515200] == false) { // 01.02.2020, 7%
224             tokensToSend = 9192400 * 1 ether;
225             fundF[1580515200] = true;
226         } else if (now > 1583020800 && now < 1585699200 && fundF[1583020800] == false) { // 01.03.2020, 6.5%
227             tokensToSend = 8535800 * 1 ether;
228             fundF[1583020800] = true;
229         } else if (now > 1585699200 && now < 1588291200 && fundF[1585699200] == false) { // 01.04.2020, 6%
230             tokensToSend = 7879200 * 1 ether;
231             fundF[1585699200] = true;
232         } else if (now > 1588291200 && now < 1590969600 && fundF[1588291200] == false) { // 01.05.2020, 5.5%
233             tokensToSend = 7222600 * 1 ether;
234             fundF[1588291200] = true;
235         } else if (now > 1590969600 && now < 1593561600 && fundF[1590969600] == false) { // 01.06.2020, 5%
236             tokensToSend = 6566000 * 1 ether;
237             fundF[1590969600] = true;
238         } else if (now > 1593561600 && now < 1596240000 && fundF[1593561600] == false) { // 01.07.2020, 4.5%
239             tokensToSend = 5909400 * 1 ether;
240             fundF[1593561600] = true;
241         } else if (now > 1596240000 && now < 1598918400 && fundF[1596240000] == false) { // 01.08.2020, 4%
242             tokensToSend = 5252800 * 1 ether;
243             fundF[1596240000] = true;
244         } else if (now > 1598918400 && now < 1601510400 && fundF[1598918400] == false) { // 01.09.2020, 4%
245             tokensToSend = 5252800 * 1 ether;
246             fundF[1598918400] = true;
247         } else if (now > 1601510400 && now < 1604188800 && fundF[1601510400] == false) { // 01.10.2020, 4%
248             tokensToSend = 5252800 * 1 ether;
249             fundF[1601510400] = true;
250         } else if (now > 1604188800 && now < 1606780800 && fundF[1604188800] == false) { // 01.11.2020, 4%
251             tokensToSend = 5252800 * 1 ether;
252             fundF[1604188800] = true;
253         } else if (now > 1606780800 && now < 1609459200 && fundF[1606780800] == false) { // 01.12.2020, 4%
254             tokensToSend = 5252800 * 1 ether;
255             fundF[1606780800] = true;
256         } else if (now > 1609459200 && now < 1612137600 && fundF[1609459200] == false) { // 01.01.2021, 4%
257             tokensToSend = 5252800 * 1 ether;
258             fundF[1609459200] = true;
259         } else if (now > 1612137600 && now < 1614556800 && fundF[1612137600] == false) { // 01.02.2021, 4%
260             tokensToSend = 5252800 * 1 ether;
261             fundF[1612137600] = true;
262         } else if (now > 1614556800 && now < 1617235200 && fundF[1614556800] == false) { // 01.03.2021, 4%
263             tokensToSend = 5252800 * 1 ether;
264             fundF[1614556800] = true;
265         } else if (now > 1617235200 && now < 1619827200 && fundF[1617235200] == false) { // 01.04.2021, 4%
266             tokensToSend = 5252800 * 1 ether;
267             fundF[1617235200] = true;
268         } else if (now > 1619827200 && now < 1622505600 && fundF[1619827200] == false) { // 01.05.2021, 4%
269             tokensToSend = 5252800 * 1 ether;
270             fundF[1619827200] = true;
271         } else if (now > 1622505600 && now < 1625097600 && fundF[1622505600] == false) { // 01.06.2021, 4%
272             tokensToSend = 5252800 * 1 ether;
273             fundF[1622505600] = true;
274         } else if (now > 1625097600 && now < 1627776000 && fundF[1625097600] == false) { // 01.07.2021, 4%
275             tokensToSend = 5252800 * 1 ether;
276             fundF[1625097600] = true;
277         } else if (now > 1627776000 && now < 1630454400 && fundF[1627776000] == false) { // 01.08.2021, 2%
278             tokensToSend = 2626400 * 1 ether;
279             fundF[1627776000] = true;
280         }
281         _transfer(A, F, tokensToSend);
282     }
283 }