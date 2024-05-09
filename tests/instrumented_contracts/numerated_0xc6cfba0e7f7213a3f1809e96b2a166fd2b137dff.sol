1 // SPDX-License-Identifier: MIT
2 
3 pragma solidity ^0.6.0;
4 
5 /**
6  * @dev Wrappers over Solidity's arithmetic operations with added overflow
7  * checks.
8  *
9  * Arithmetic operations in Solidity wrap on overflow. This can easily result
10  * in bugs, because programmers usually assume that an overflow raises an
11  * error, which is the standard behavior in high level programming languages.
12  * `SafeMath` restores this intuition by reverting the transaction when an
13  * operation overflows.
14  *
15  * Using this library instead of the unchecked operations eliminates an entire
16  * class of bugs, so it's recommended to use it always.
17  */
18 library SafeMath {
19     /**
20      * @dev Returns the addition of two unsigned integers, reverting on
21      * overflow.
22      *
23      * Counterpart to Solidity's `+` operator.
24      *
25      * Requirements:
26      * - Addition cannot overflow.
27      */
28     function add(uint256 a, uint256 b) internal pure returns (uint256) {
29         uint256 c = a + b;
30         require(c >= a, "SafeMath: addition overflow");
31 
32         return c;
33     }
34 
35     /**
36      * @dev Returns the subtraction of two unsigned integers, reverting on
37      * overflow (when the result is negative).
38      *
39      * Counterpart to Solidity's `-` operator.
40      *
41      * Requirements:
42      * - Subtraction cannot overflow.
43      */
44     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
45         return sub(a, b, "SafeMath: subtraction overflow");
46     }
47 
48     /**
49      * @dev Returns the subtraction of two unsigned integers, reverting with custom message on
50      * overflow (when the result is negative).
51      *
52      * Counterpart to Solidity's `-` operator.
53      *
54      * Requirements:
55      * - Subtraction cannot overflow.
56      */
57     function sub(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
58         require(b <= a, errorMessage);
59         uint256 c = a - b;
60 
61         return c;
62     }
63 
64     /**
65      * @dev Returns the multiplication of two unsigned integers, reverting on
66      * overflow.
67      *
68      * Counterpart to Solidity's `*` operator.
69      *
70      * Requirements:
71      * - Multiplication cannot overflow.
72      */
73     function mul(uint256 a, uint256 b) internal pure returns (uint256) {
74         // Gas optimization: this is cheaper than requiring 'a' not being zero, but the
75         // benefit is lost if 'b' is also tested.
76         // See: https://github.com/OpenZeppelin/openzeppelin-contracts/pull/522
77         if (a == 0) {
78             return 0;
79         }
80 
81         uint256 c = a * b;
82         require(c / a == b, "SafeMath: multiplication overflow");
83 
84         return c;
85     }
86 
87     /**
88      * @dev Returns the integer division of two unsigned integers. Reverts on
89      * division by zero. The result is rounded towards zero.
90      *
91      * Counterpart to Solidity's `/` operator. Note: this function uses a
92      * `revert` opcode (which leaves remaining gas untouched) while Solidity
93      * uses an invalid opcode to revert (consuming all remaining gas).
94      *
95      * Requirements:
96      * - The divisor cannot be zero.
97      */
98     function div(uint256 a, uint256 b) internal pure returns (uint256) {
99         return div(a, b, "SafeMath: division by zero");
100     }
101 
102     /**
103      * @dev Returns the integer division of two unsigned integers. Reverts with custom message on
104      * division by zero. The result is rounded towards zero.
105      *
106      * Counterpart to Solidity's `/` operator. Note: this function uses a
107      * `revert` opcode (which leaves remaining gas untouched) while Solidity
108      * uses an invalid opcode to revert (consuming all remaining gas).
109      *
110      * Requirements:
111      * - The divisor cannot be zero.
112      */
113     function div(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
114         // Solidity only automatically asserts when dividing by 0
115         require(b > 0, errorMessage);
116         uint256 c = a / b;
117         // assert(a == b * c + a % b); // There is no case in which this doesn't hold
118 
119         return c;
120     }
121 
122     /**
123      * @dev Returns the remainder of dividing two unsigned integers. (unsigned integer modulo),
124      * Reverts when dividing by zero.
125      *
126      * Counterpart to Solidity's `%` operator. This function uses a `revert`
127      * opcode (which leaves remaining gas untouched) while Solidity uses an
128      * invalid opcode to revert (consuming all remaining gas).
129      *
130      * Requirements:
131      * - The divisor cannot be zero.
132      */
133     function mod(uint256 a, uint256 b) internal pure returns (uint256) {
134         return mod(a, b, "SafeMath: modulo by zero");
135     }
136 
137     /**
138      * @dev Returns the remainder of dividing two unsigned integers. (unsigned integer modulo),
139      * Reverts with custom message when dividing by zero.
140      *
141      * Counterpart to Solidity's `%` operator. This function uses a `revert`
142      * opcode (which leaves remaining gas untouched) while Solidity uses an
143      * invalid opcode to revert (consuming all remaining gas).
144      *
145      * Requirements:
146      * - The divisor cannot be zero.
147      */
148     function mod(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
149         require(b != 0, errorMessage);
150         return a % b;
151     }
152 }
153 
154 pragma solidity ^0.6.6;
155 
156 interface Token {
157     function balanceOf(address account) external view returns (uint256);
158     function transferFrom(address sender, address recipient, uint256 amount) external returns (bool);
159 }
160 
161 contract HackerFederation {
162     using SafeMath for uint256;
163 
164     // Hashrate decimals
165     uint256 public constant hashRateDecimals = 5;
166     // 10 usdt = 1 T
167     uint256 public constant hashRatePerUsdt = 10;
168     // Manager address
169     address public owner;
170     // Root address
171     address public rootAddress;
172     // Burn address
173     address public burnAddress;
174 
175     // DAI-HE3 pair address
176     address public daiToHe3Address;
177 
178     // DAI ERC20 address
179     address public daiTokenAddress;
180     Token tokenDai;
181     // HE-3 ERC20 address
182     address public he3TokenAddress;
183     Token tokenHe3;
184 
185     // HE-1 ERC20 address
186     address public he1TokenAddress;
187 
188     // Userinfo
189     struct User {
190         address superior;
191         uint256 hashRate;
192         bool isUser;
193     }
194     mapping(address => User) public users;
195 
196     // Buy hashrate event
197     event LogBuyHashRate(address indexed owner, address indexed superior, uint256 hashRate);
198 
199     constructor(
200         address _rootAddress, 
201         address _burnAddress, 
202         address _daiToHe3Address, 
203         address _daiTokenAddress, 
204         address _he3TokenAddress, 
205         address _he1TokenAddress
206     ) public {
207         owner = msg.sender;
208         rootAddress = _rootAddress;
209         burnAddress = _burnAddress;
210         daiToHe3Address = _daiToHe3Address;
211 
212         daiTokenAddress = _daiTokenAddress;
213         tokenDai = Token(daiTokenAddress);
214 
215         he3TokenAddress = _he3TokenAddress;
216         tokenHe3 = Token(he3TokenAddress);
217 
218         he1TokenAddress = _he1TokenAddress;
219     }
220 
221     // Modifier func
222     modifier onlyOwner() {
223         require(msg.sender == owner, "This function is restricted to the owner");
224         _;
225     }
226 
227     modifier notAddress0(address newAddress) {
228         require(newAddress != address(0), "Address should not be address(0)");
229         _;
230     }
231 
232     /**
233      * Use HE-1 to buy hashrate
234      *
235      * Requirements:
236      *
237      * - `_tokenAmount`: Amount of HE-1 
238      * - `_superior`: User's inviter
239      */
240     function buyHashRateWithHE1(uint256 _tokenAmount, address _superior) public {
241         _buyHashRate(he1TokenAddress, _tokenAmount, _tokenAmount.div(10**12), _superior);
242     }
243 
244     /**
245      * Use HE-3 to buy hashrate
246      *
247      * Requirements:
248      *
249      * - `_tokenAmount`: Amount of HE-3
250      * - `_superior`: User's inviter
251      */
252     function buyHashRateWithHE3(uint256 _tokenAmount, address _superior) public {
253         uint256 totalDai = getHe3ToDai(_tokenAmount);
254         _buyHashRate(he3TokenAddress, _tokenAmount, totalDai.div(10**12), _superior);
255     }
256 
257     /**
258      * Buy hashrate
259      *
260      * Requirements:
261      *
262      * - `_token`: HE-1 or HE-3 address
263      * - `_tokenAmount`: Amount of token
264      * - `_usdtAmount`: Value of _tokenAmount to USDT
265      * - `_superior`: inviter
266      */
267     function _buyHashRate(address _tokenAddress,uint256 _tokenAmount, uint256 _usdtAmount, address _superior) internal {
268         // require _superior
269         require(users[_superior].isUser || _superior == rootAddress, "Superiorshould be a user or rootAddress");
270         
271         // burn the token sent by user
272         bool sent = Token(_tokenAddress).transferFrom(msg.sender, burnAddress, _tokenAmount);
273         require(sent, "Token transfer failed");
274 
275         // USDT decimals = 6
276         require(_usdtAmount >= 10000000, "Usdt should be great than or equal 10");
277         
278         uint256 hashRate = _usdtAmount.div(10).div(hashRatePerUsdt);
279         if (users[msg.sender].isUser) {
280             users[msg.sender].hashRate = users[msg.sender].hashRate.add(hashRate);
281         } else {
282             users[msg.sender].superior = _superior;
283             users[msg.sender].hashRate = hashRate;
284             users[msg.sender].isUser = true;
285         }
286         
287         // Buy hashrate event
288         emit LogBuyHashRate(msg.sender, _superior, hashRate);
289     }
290 
291     // Update owner address
292     function updateOwnerAddress(address _newOwnerAddress) public onlyOwner {
293         owner = _newOwnerAddress;
294     }
295 
296     // Update burn address
297     function updateBurnAddress(address _newBurnAddress) public onlyOwner {
298         burnAddress = _newBurnAddress;
299     }
300 
301     // update HE-3 contract address
302     function updateHe3TokenAddress(address _he3TokenAddress) public onlyOwner notAddress0(_he3TokenAddress) {
303         he3TokenAddress = _he3TokenAddress;
304         tokenHe3 = Token(he3TokenAddress);
305     }
306 
307     // update HE-1 contract address
308     function updateHe1TokenAddress(address _he1TokenAddress) public onlyOwner notAddress0(_he1TokenAddress) {
309         he1TokenAddress = _he1TokenAddress;
310     }
311 
312     // update DAI contract address
313     function updateDaiToHe3AddressAddress(address _daiToHe3Address) public onlyOwner notAddress0(_daiToHe3Address) {
314         daiToHe3Address = _daiToHe3Address;
315     }
316 
317     // update DAI-HE3 uniswap pair contract address
318     function updateDaiTokenAddress(address _daiTokenAddress) public onlyOwner notAddress0(_daiTokenAddress) {
319         daiTokenAddress = _daiTokenAddress;
320         tokenDai = Token(daiTokenAddress);
321     }
322 
323     /**
324      * Is user?
325      */
326     function isUser(address _userAddress) public view returns (bool) {
327         return users[_userAddress].isUser;
328     }
329 
330     // Get amount 1 HE3 to DAI
331     function getDaiPerHe3() public view returns (uint256) {
332         return getHe3ToDai(10**18);
333     }
334 
335     // Get amount _he3Amount HE3 to DAI 
336     function getHe3ToDai(uint256 _he3Amount) internal view returns (uint256) {
337         return tokenDai.balanceOf(daiToHe3Address).mul(_he3Amount).div(tokenHe3.balanceOf(daiToHe3Address));
338     }
339 }