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
172   function withdraw(uint256 _amount) external;
173 }
174 
175 // Solidity Interface
176 
177 interface ICurveFi {
178 
179   function remove_liquidity(
180     uint256 _amount,
181     uint256[4] calldata amounts
182   ) external;
183   function exchange(
184     int128 from, int128 to, uint256 _from_amount, uint256 _min_to_amount
185   ) external;
186 }
187 
188 contract yCurveZapOut is ReentrancyGuard, Ownable {
189   using SafeERC20 for IERC20;
190   using Address for address;
191   using SafeMath for uint256;
192 
193   address public DAI;
194   address public yDAI;
195   address public USDC;
196   address public yUSDC;
197   address public USDT;
198   address public yUSDT;
199   address public TUSD;
200   address public yTUSD;
201   address public SWAP;
202   address public CURVE;
203 
204   constructor () public {
205     DAI = address(0x6B175474E89094C44Da98b954EedeAC495271d0F);
206     yDAI = address(0x16de59092dAE5CcF4A1E6439D611fd0653f0Bd01);
207 
208     USDC = address(0xA0b86991c6218b36c1d19D4a2e9Eb0cE3606eB48);
209     yUSDC = address(0xd6aD7a6750A7593E092a9B218d66C0A814a3436e);
210 
211     USDT = address(0xdAC17F958D2ee523a2206206994597C13D831ec7);
212     yUSDT = address(0x83f798e925BcD4017Eb265844FDDAbb448f1707D);
213 
214     TUSD = address(0x0000000000085d4780B73119b644AE5ecd22b376);
215     yTUSD = address(0x73a052500105205d34Daf004eAb301916DA8190f);
216 
217     SWAP = address(0x45F783CCE6B7FF23B2ab2D70e416cdb7D6055f51);
218     CURVE = address(0xdF5e0e81Dff6FAF3A7e52BA697820c5e32D806A8);
219 
220     approveToken();
221   }
222 
223   function() external payable {
224 
225   }
226 
227   function approveToken() public {
228       IERC20(yDAI).safeApprove(SWAP, uint(-1));
229       IERC20(yUSDC).safeApprove(SWAP, uint(-1));
230       IERC20(yUSDT).safeApprove(SWAP, uint(-1));
231       IERC20(yTUSD).safeApprove(SWAP, uint(-1));
232   }
233 
234   function checkSlippage(uint256 _amount, address _token, uint256 _dec) public view returns (bool) {
235     uint256 received = (IERC20(_token).balanceOf(address(this))).mul(_dec);
236     uint256 fivePercent = _amount.mul(5).div(100);
237     uint256 min = _amount.sub(fivePercent);
238     uint256 max = _amount.add(fivePercent);
239     require(received <= max && received >= min, "slippage greater than 5%");
240     return true;
241   }
242 
243   function withdrawCurve(uint256 _amount) public {
244     require(_amount > 0, "deposit must be greater than 0");
245     IERC20(CURVE).safeTransferFrom(msg.sender, address(this), _amount);
246     ICurveFi(SWAP).remove_liquidity(IERC20(CURVE).balanceOf(address(this)), [uint256(0),0,0,0]);
247     require(IERC20(CURVE).balanceOf(address(this)) == 0, "CURVE remainder");
248   }
249 
250   function withdrawDAI(uint256 _amount)
251       external
252       nonReentrant
253   {
254       withdrawCurve(_amount);
255 
256       uint256 _ydai = IERC20(yDAI).balanceOf(address(this));
257       uint256 _yusdc = IERC20(yUSDC).balanceOf(address(this));
258       uint256 _yusdt = IERC20(yUSDT).balanceOf(address(this));
259       uint256 _ytusd = IERC20(yTUSD).balanceOf(address(this));
260 
261       require(_ydai > 0 || _yusdc > 0 || _yusdt > 0 || _ytusd > 0, "no y.tokens found");
262 
263       if (_yusdc > 0) {
264         ICurveFi(SWAP).exchange(1, 0, _yusdc, 0);
265         require(IERC20(yUSDC).balanceOf(address(this)) == 0, "y.USDC remainder");
266       }
267       if (_yusdt > 0) {
268         ICurveFi(SWAP).exchange(2, 0, _yusdt, 0);
269         require(IERC20(yUSDT).balanceOf(address(this)) == 0, "y.USDT remainder");
270       }
271       if (_ytusd > 0) {
272         ICurveFi(SWAP).exchange(3, 0, _ytusd, 0);
273         require(IERC20(yTUSD).balanceOf(address(this)) == 0, "y.TUSD remainder");
274       }
275 
276       yERC20(yDAI).withdraw(IERC20(yDAI).balanceOf(address(this)));
277       require(IERC20(yDAI).balanceOf(address(this)) == 0, "y.DAI remainder");
278 
279       checkSlippage(_amount, DAI, 1);
280 
281       IERC20(DAI).safeTransfer(msg.sender, IERC20(DAI).balanceOf(address(this)));
282       require(IERC20(DAI).balanceOf(address(this)) == 0, "DAI remainder");
283   }
284 
285   function withdrawUSDC(uint256 _amount)
286       external
287       nonReentrant
288   {
289       withdrawCurve(_amount);
290 
291       uint256 _ydai = IERC20(yDAI).balanceOf(address(this));
292       uint256 _yusdc = IERC20(yUSDC).balanceOf(address(this));
293       uint256 _yusdt = IERC20(yUSDT).balanceOf(address(this));
294       uint256 _ytusd = IERC20(yTUSD).balanceOf(address(this));
295 
296       require(_ydai > 0 || _yusdc > 0 || _yusdt > 0 || _ytusd > 0, "no y.tokens found");
297 
298       if (_ydai > 0) {
299         ICurveFi(SWAP).exchange(0, 1, _ydai, 0);
300         require(IERC20(yDAI).balanceOf(address(this)) == 0, "y.DAI remainder");
301       }
302       if (_yusdt > 0) {
303         ICurveFi(SWAP).exchange(2, 1, _yusdt, 0);
304         require(IERC20(yUSDT).balanceOf(address(this)) == 0, "y.USDT remainder");
305       }
306       if (_ytusd > 0) {
307         ICurveFi(SWAP).exchange(3, 1, _ytusd, 0);
308         require(IERC20(yTUSD).balanceOf(address(this)) == 0, "y.TUSD remainder");
309       }
310 
311       yERC20(yUSDC).withdraw(IERC20(yUSDC).balanceOf(address(this)));
312       require(IERC20(yUSDC).balanceOf(address(this)) == 0, "y.USDC remainder");
313 
314       checkSlippage(_amount, USDC, 1e12);
315 
316       IERC20(USDC).safeTransfer(msg.sender, IERC20(USDC).balanceOf(address(this)));
317       require(IERC20(USDC).balanceOf(address(this)) == 0, "USDC remainder");
318   }
319 
320   function withdrawUSDT(uint256 _amount)
321       external
322       nonReentrant
323   {
324       withdrawCurve(_amount);
325 
326       uint256 _ydai = IERC20(yDAI).balanceOf(address(this));
327       uint256 _yusdc = IERC20(yUSDC).balanceOf(address(this));
328       uint256 _yusdt = IERC20(yUSDT).balanceOf(address(this));
329       uint256 _ytusd = IERC20(yTUSD).balanceOf(address(this));
330 
331       require(_ydai > 0 || _yusdc > 0 || _yusdt > 0 || _ytusd > 0, "no y.tokens found");
332 
333       if (_ydai > 0) {
334         ICurveFi(SWAP).exchange(0, 2, _ydai, 0);
335         require(IERC20(yDAI).balanceOf(address(this)) == 0, "y.DAI remainder");
336       }
337       if (_yusdc > 0) {
338         ICurveFi(SWAP).exchange(1, 2, _yusdc, 0);
339         require(IERC20(yUSDC).balanceOf(address(this)) == 0, "y.USDC remainder");
340       }
341       if (_ytusd > 0) {
342         ICurveFi(SWAP).exchange(3, 2, _ytusd, 0);
343         require(IERC20(yTUSD).balanceOf(address(this)) == 0, "y.TUSD remainder");
344       }
345 
346       yERC20(yUSDT).withdraw(IERC20(yUSDT).balanceOf(address(this)));
347       require(IERC20(yUSDT).balanceOf(address(this)) == 0, "y.USDT remainder");
348 
349       checkSlippage(_amount, USDT, 1e12);
350 
351       IERC20(USDT).safeTransfer(msg.sender, IERC20(USDT).balanceOf(address(this)));
352       require(IERC20(USDT).balanceOf(address(this)) == 0, "USDT remainder");
353   }
354 
355   function withdrawTUSD(uint256 _amount)
356       external
357       nonReentrant
358   {
359       withdrawCurve(_amount);
360 
361       uint256 _ydai = IERC20(yDAI).balanceOf(address(this));
362       uint256 _yusdc = IERC20(yUSDC).balanceOf(address(this));
363       uint256 _yusdt = IERC20(yUSDT).balanceOf(address(this));
364       uint256 _ytusd = IERC20(yTUSD).balanceOf(address(this));
365 
366       require(_ydai > 0 || _yusdc > 0 || _yusdt > 0 || _ytusd > 0, "no y.tokens found");
367 
368       if (_ydai > 0) {
369         ICurveFi(SWAP).exchange(0, 3, _ydai, 0);
370         require(IERC20(yDAI).balanceOf(address(this)) == 0, "y.DAI remainder");
371       }
372       if (_yusdc > 0) {
373         ICurveFi(SWAP).exchange(1, 3, _yusdc, 0);
374         require(IERC20(yUSDC).balanceOf(address(this)) == 0, "y.USDC remainder");
375       }
376       if (_yusdt > 0) {
377         ICurveFi(SWAP).exchange(2, 3, _yusdt, 0);
378         require(IERC20(yUSDT).balanceOf(address(this)) == 0, "y.USDT remainder");
379       }
380 
381       yERC20(yTUSD).withdraw(IERC20(yTUSD).balanceOf(address(this)));
382       require(IERC20(yTUSD).balanceOf(address(this)) == 0, "y.TUSD remainder");
383 
384       checkSlippage(_amount, TUSD, 1);
385 
386       IERC20(TUSD).safeTransfer(msg.sender, IERC20(TUSD).balanceOf(address(this)));
387       require(IERC20(TUSD).balanceOf(address(this)) == 0, "TUSD remainder");
388   }
389 
390   // incase of half-way error
391   function inCaseTokenGetsStuck(IERC20 _TokenAddress) onlyOwner public {
392       uint qty = _TokenAddress.balanceOf(address(this));
393       _TokenAddress.safeTransfer(msg.sender, qty);
394   }
395 
396   // incase of half-way error
397   function inCaseETHGetsStuck() onlyOwner public{
398       (bool result, ) = msg.sender.call.value(address(this).balance)("");
399       require(result, "transfer of ETH failed");
400   }
401 }