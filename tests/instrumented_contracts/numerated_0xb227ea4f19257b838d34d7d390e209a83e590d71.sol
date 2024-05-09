1 pragma solidity ^0.5.0;
2 pragma experimental ABIEncoderV2;
3 
4 interface IERC20 {
5     function totalSupply() external view returns (uint256);
6     function balanceOf(address account) external view returns (uint256);
7     function transfer(address recipient, uint256 amount) external returns (bool);
8     function allowance(address owner, address spender) external view returns (uint256);
9     function approve(address spender, uint256 amount) external returns (bool);
10     function transferFrom(address sender, address recipient, uint256 amount) external returns (bool);
11     event Transfer(address indexed from, address indexed to, uint256 value);
12     event Approval(address indexed owner, address indexed spender, uint256 value);
13 }
14 
15 contract Context {
16     constructor () internal { }
17     // solhint-disable-previous-line no-empty-blocks
18 
19     function _msgSender() internal view returns (address payable) {
20         return msg.sender;
21     }
22 
23     function _msgData() internal view returns (bytes memory) {
24         this; // silence state mutability warning without generating bytecode - see https://github.com/ethereum/solidity/issues/2691
25         return msg.data;
26     }
27 }
28 
29 contract ReentrancyGuard {
30     uint256 private _guardCounter;
31 
32     constructor () internal {
33         _guardCounter = 1;
34     }
35 
36     modifier nonReentrant() {
37         _guardCounter += 1;
38         uint256 localCounter = _guardCounter;
39         _;
40         require(localCounter == _guardCounter, "ReentrancyGuard: reentrant call");
41     }
42 }
43 
44 contract Ownable is Context {
45     address private _owner;
46 
47     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
48     constructor () internal {
49         _owner = _msgSender();
50         emit OwnershipTransferred(address(0), _owner);
51     }
52     function owner() public view returns (address) {
53         return _owner;
54     }
55     modifier onlyOwner() {
56         require(isOwner(), "Ownable: caller is not the owner");
57         _;
58     }
59     function isOwner() public view returns (bool) {
60         return _msgSender() == _owner;
61     }
62     function renounceOwnership() public onlyOwner {
63         emit OwnershipTransferred(_owner, address(0));
64         _owner = address(0);
65     }
66     function transferOwnership(address newOwner) public onlyOwner {
67         _transferOwnership(newOwner);
68     }
69     function _transferOwnership(address newOwner) internal {
70         require(newOwner != address(0), "Ownable: new owner is the zero address");
71         emit OwnershipTransferred(_owner, newOwner);
72         _owner = newOwner;
73     }
74 }
75 
76 library SafeMath {
77     function add(uint256 a, uint256 b) internal pure returns (uint256) {
78         uint256 c = a + b;
79         require(c >= a, "SafeMath: addition overflow");
80 
81         return c;
82     }
83     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
84         return sub(a, b, "SafeMath: subtraction overflow");
85     }
86     function sub(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
87         require(b <= a, errorMessage);
88         uint256 c = a - b;
89 
90         return c;
91     }
92     function mul(uint256 a, uint256 b) internal pure returns (uint256) {
93         if (a == 0) {
94             return 0;
95         }
96 
97         uint256 c = a * b;
98         require(c / a == b, "SafeMath: multiplication overflow");
99 
100         return c;
101     }
102     function div(uint256 a, uint256 b) internal pure returns (uint256) {
103         return div(a, b, "SafeMath: division by zero");
104     }
105     function div(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
106         // Solidity only automatically asserts when dividing by 0
107         require(b > 0, errorMessage);
108         uint256 c = a / b;
109 
110         return c;
111     }
112     function mod(uint256 a, uint256 b) internal pure returns (uint256) {
113         return mod(a, b, "SafeMath: modulo by zero");
114     }
115     function mod(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
116         require(b != 0, errorMessage);
117         return a % b;
118     }
119 }
120 
121 library Address {
122     function isContract(address account) internal view returns (bool) {
123         bytes32 codehash;
124         bytes32 accountHash = 0xc5d2460186f7233c927e7db2dcc703c0e500b653ca82273b7bfad8045d85a470;
125         // solhint-disable-next-line no-inline-assembly
126         assembly { codehash := extcodehash(account) }
127         return (codehash != 0x0 && codehash != accountHash);
128     }
129     function toPayable(address account) internal pure returns (address payable) {
130         return address(uint160(account));
131     }
132     function sendValue(address payable recipient, uint256 amount) internal {
133         require(address(this).balance >= amount, "Address: insufficient balance");
134 
135         // solhint-disable-next-line avoid-call-value
136         (bool success, ) = recipient.call.value(amount)("");
137         require(success, "Address: unable to send value, recipient may have reverted");
138     }
139 }
140 
141 library SafeERC20 {
142     using SafeMath for uint256;
143     using Address for address;
144 
145     function safeTransfer(IERC20 token, address to, uint256 value) internal {
146         callOptionalReturn(token, abi.encodeWithSelector(token.transfer.selector, to, value));
147     }
148     function safeTransferFrom(IERC20 token, address from, address to, uint256 value) internal {
149         callOptionalReturn(token, abi.encodeWithSelector(token.transferFrom.selector, from, to, value));
150     }
151     function safeApprove(IERC20 token, address spender, uint256 value) internal {
152         require((value == 0) || (token.allowance(address(this), spender) == 0),
153             "SafeERC20: approve from non-zero to non-zero allowance"
154         );
155         callOptionalReturn(token, abi.encodeWithSelector(token.approve.selector, spender, value));
156     }
157     function callOptionalReturn(IERC20 token, bytes memory data) private {
158         require(address(token).isContract(), "SafeERC20: call to non-contract");
159 
160         // solhint-disable-next-line avoid-low-level-calls
161         (bool success, bytes memory returndata) = address(token).call(data);
162         require(success, "SafeERC20: low-level call failed");
163 
164         if (returndata.length > 0) { // Return data is optional
165             // solhint-disable-next-line max-line-length
166             require(abi.decode(returndata, (bool)), "SafeERC20: ERC20 operation did not succeed");
167         }
168     }
169 }
170 
171 interface yERC20 {
172   function deposit(uint256 _amount) external;
173 }
174 
175 // Solidity Interface
176 
177 interface ICurveFi {
178 
179   function add_liquidity(
180     uint256[4] calldata amounts,
181     uint256 min_mint_amount
182   ) external;
183   function remove_liquidity_imbalance(
184     uint256[4] calldata amounts,
185     uint256 max_burn_amount
186   ) external;
187 }
188 
189 contract yCurveZapIn is ReentrancyGuard, Ownable {
190   using SafeERC20 for IERC20;
191   using Address for address;
192   using SafeMath for uint256;
193 
194   address public DAI;
195   address public yDAI;
196   address public USDC;
197   address public yUSDC;
198   address public USDT;
199   address public yUSDT;
200   address public TUSD;
201   address public yTUSD;
202   address public SWAP;
203   address public CURVE;
204 
205   constructor () public {
206     DAI = address(0x6B175474E89094C44Da98b954EedeAC495271d0F);
207     yDAI = address(0x16de59092dAE5CcF4A1E6439D611fd0653f0Bd01);
208 
209     USDC = address(0xA0b86991c6218b36c1d19D4a2e9Eb0cE3606eB48);
210     yUSDC = address(0xd6aD7a6750A7593E092a9B218d66C0A814a3436e);
211 
212     USDT = address(0xdAC17F958D2ee523a2206206994597C13D831ec7);
213     yUSDT = address(0x83f798e925BcD4017Eb265844FDDAbb448f1707D);
214 
215     TUSD = address(0x0000000000085d4780B73119b644AE5ecd22b376);
216     yTUSD = address(0x73a052500105205d34Daf004eAb301916DA8190f);
217 
218     SWAP = address(0x45F783CCE6B7FF23B2ab2D70e416cdb7D6055f51);
219     CURVE = address(0xdF5e0e81Dff6FAF3A7e52BA697820c5e32D806A8);
220 
221     approveToken();
222   }
223 
224   function() external payable {
225 
226   }
227 
228   function approveToken() public {
229       IERC20(DAI).safeApprove(yDAI, uint(-1));
230       IERC20(yDAI).safeApprove(SWAP, uint(-1));
231 
232       IERC20(USDC).safeApprove(yUSDC, uint(-1));
233       IERC20(yUSDC).safeApprove(SWAP, uint(-1));
234 
235       IERC20(USDT).safeApprove(yUSDT, uint(0));
236       IERC20(USDT).safeApprove(yUSDT, uint(-1));
237       IERC20(yUSDT).safeApprove(SWAP, uint(-1));
238 
239       IERC20(TUSD).safeApprove(yTUSD, uint(-1));
240       IERC20(yTUSD).safeApprove(SWAP, uint(-1));
241   }
242 
243   function depositDAI(uint256 _amount)
244       external
245       nonReentrant
246   {
247       require(_amount > 0, "deposit must be greater than 0");
248       IERC20(DAI).safeTransferFrom(msg.sender, address(this), _amount);
249       yERC20(yDAI).deposit(_amount);
250       require(IERC20(DAI).balanceOf(address(this)) == 0, "token remainder");
251       ICurveFi(SWAP).add_liquidity([IERC20(yDAI).balanceOf(address(this)),0,0,0],0);
252       require(IERC20(yDAI).balanceOf(address(this)) == 0, "yToken remainder");
253 
254       uint256 received = IERC20(CURVE).balanceOf(address(this));
255       uint256 fivePercent = _amount.mul(5).div(100);
256       uint256 min = _amount.sub(fivePercent);
257       uint256 max = _amount.add(fivePercent);
258       require(received <= max && received >= min, "slippage greater than 5%");
259 
260       IERC20(CURVE).safeTransfer(msg.sender, IERC20(CURVE).balanceOf(address(this)));
261       require(IERC20(CURVE).balanceOf(address(this)) == 0, "CURVE remainder");
262   }
263 
264   function depositUSDC(uint256 _amount)
265       external
266       nonReentrant
267   {
268       require(_amount > 0, "deposit must be greater than 0");
269       IERC20(USDC).safeTransferFrom(msg.sender, address(this), _amount);
270       yERC20(yUSDC).deposit(_amount);
271       require(IERC20(USDC).balanceOf(address(this)) == 0, "token remainder");
272       ICurveFi(SWAP).add_liquidity([0,IERC20(yUSDC).balanceOf(address(this)),0,0],0);
273       require(IERC20(yUSDC).balanceOf(address(this)) == 0, "yToken remainder");
274 
275       uint256 received = IERC20(CURVE).balanceOf(address(this));
276       uint256 fivePercent = _amount.mul(5).div(100);
277       uint256 min = (_amount.sub(fivePercent)).mul(1e12);
278       uint256 max = (_amount.add(fivePercent)).mul(1e12);
279       require(received <= max && received >= min, "slippage greater than 5%");
280 
281       IERC20(CURVE).safeTransfer(msg.sender, IERC20(CURVE).balanceOf(address(this)));
282       require(IERC20(CURVE).balanceOf(address(this)) == 0, "CURVE remainder");
283   }
284 
285   function depositUSDT(uint256 _amount)
286       external
287       nonReentrant
288   {
289       require(_amount > 0, "deposit must be greater than 0");
290       IERC20(USDT).safeTransferFrom(msg.sender, address(this), _amount);
291       yERC20(yUSDT).deposit(_amount);
292       require(IERC20(USDT).balanceOf(address(this)) == 0, "token remainder");
293       ICurveFi(SWAP).add_liquidity([0,0,IERC20(yUSDT).balanceOf(address(this)),0],0);
294       require(IERC20(yUSDT).balanceOf(address(this)) == 0, "yToken remainder");
295       
296       uint256 received = IERC20(CURVE).balanceOf(address(this));
297       uint256 fivePercent = _amount.mul(5).div(100);
298       uint256 min = (_amount.sub(fivePercent)).mul(1e12);
299       uint256 max = (_amount.add(fivePercent)).mul(1e12);
300       require(received <= max && received >= min, "slippage greater than 5%");
301 
302       IERC20(CURVE).safeTransfer(msg.sender, IERC20(CURVE).balanceOf(address(this)));
303       require(IERC20(CURVE).balanceOf(address(this)) == 0, "CURVE remainder");
304   }
305 
306   function depositTUSD(uint256 _amount)
307       external
308       nonReentrant
309   {
310       require(_amount > 0, "deposit must be greater than 0");
311       IERC20(TUSD).safeTransferFrom(msg.sender, address(this), _amount);
312       yERC20(yTUSD).deposit(_amount);
313       require(IERC20(TUSD).balanceOf(address(this)) == 0, "token remainder");
314       ICurveFi(SWAP).add_liquidity([0,0,0,IERC20(yTUSD).balanceOf(address(this))],0);
315       require(IERC20(yTUSD).balanceOf(address(this)) == 0, "yToken remainder");
316 
317       uint256 received = IERC20(CURVE).balanceOf(address(this));
318       uint256 fivePercent = _amount.mul(5).div(100);
319       uint256 min = _amount.sub(fivePercent);
320       uint256 max = _amount.add(fivePercent);
321       require(received <= max && received >= min, "slippage greater than 5%");
322 
323       IERC20(CURVE).safeTransfer(msg.sender, IERC20(CURVE).balanceOf(address(this)));
324       require(IERC20(CURVE).balanceOf(address(this)) == 0, "CURVE remainder");
325   }
326 
327   // incase of half-way error
328   function inCaseTokenGetsStuck(IERC20 _TokenAddress) onlyOwner public {
329       uint qty = _TokenAddress.balanceOf(address(this));
330       _TokenAddress.safeTransfer(msg.sender, qty);
331   }
332 
333   // incase of half-way error
334   function inCaseETHGetsStuck() onlyOwner public{
335       (bool result, ) = msg.sender.call.value(address(this).balance)("");
336       require(result, "transfer of ETH failed");
337   }
338 }