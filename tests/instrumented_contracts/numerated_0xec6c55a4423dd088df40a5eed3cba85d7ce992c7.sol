1 // SPDX-License-Identifier: AGPL-3.0-or-later
2 pragma solidity 0.8.4;
3 
4 
5 abstract contract OwnableStatic {
6 
7     mapping( address => bool ) public _isOwner;
8 
9     constructor() {
10         _setOwner(msg.sender, true);
11     }
12 
13     modifier onlyOwner() {
14     require( _isOwner[msg.sender] );
15     _;
16   }
17 
18     function _setOwner(address newOwner, bool makeOwner) private {
19         _isOwner[newOwner] = makeOwner;
20         // _owner = newOwner;
21         // emit OwnershipTransferred(oldOwner, newOwner);
22     }
23 
24     function setOwnerShip( address newOwner, bool makeOOwner ) external onlyOwner() returns ( bool success ) {
25     _isOwner[newOwner] = makeOOwner;
26     success = true;
27   }
28 }
29 
30 library AddressUtils {
31   function toString (address account) internal pure returns (string memory) {
32     bytes32 value = bytes32(uint256(uint160(account)));
33     bytes memory alphabet = '0123456789abcdef';
34     bytes memory chars = new bytes(42);
35 
36     chars[0] = '0';
37     chars[1] = 'x';
38 
39     for (uint256 i = 0; i < 20; i++) {
40       chars[2 + i * 2] = alphabet[uint8(value[i + 12] >> 4)];
41       chars[3 + i * 2] = alphabet[uint8(value[i + 12] & 0x0f)];
42     }
43 
44     return string(chars);
45   }
46 
47   function isContract (address account) internal view returns (bool) {
48     uint size;
49     assembly { size := extcodesize(account) }
50     return size > 0;
51   }
52 
53   function sendValue (address payable account, uint amount) internal {
54     (bool success, ) = account.call{ value: amount }('');
55     require(success, 'AddressUtils: failed to send value');
56   }
57 
58   function functionCall (address target, bytes memory data) internal returns (bytes memory) {
59     return functionCall(target, data, 'AddressUtils: failed low-level call');
60   }
61 
62   function functionCall (address target, bytes memory data, string memory error) internal returns (bytes memory) {
63     return _functionCallWithValue(target, data, 0, error);
64   }
65 
66   function functionCallWithValue (address target, bytes memory data, uint value) internal returns (bytes memory) {
67     return functionCallWithValue(target, data, value, 'AddressUtils: failed low-level call with value');
68   }
69 
70   function functionCallWithValue (address target, bytes memory data, uint value, string memory error) internal returns (bytes memory) {
71     require(address(this).balance >= value, 'AddressUtils: insufficient balance for call');
72     return _functionCallWithValue(target, data, value, error);
73   }
74 
75   function _functionCallWithValue (address target, bytes memory data, uint value, string memory error) private returns (bytes memory) {
76     require(isContract(target), 'AddressUtils: function call to non-contract');
77 
78     (bool success, bytes memory returnData) = target.call{ value: value }(data);
79 
80     if (success) {
81       return returnData;
82     } else if (returnData.length > 0) {
83       assembly {
84         let returnData_size := mload(returnData)
85         revert(add(32, returnData), returnData_size)
86       }
87     } else {
88       revert(error);
89     }
90   }
91 }
92 
93 interface IERC20 {
94   event Transfer(
95     address indexed from,
96     address indexed to,
97     uint256 value
98   );
99 
100   event Approval(
101     address indexed owner,
102     address indexed spender,
103     uint256 value
104   );
105 
106   function totalSupply () external view returns (uint256);
107 
108   function balanceOf (
109     address account
110   ) external view returns (uint256);
111 
112   function transfer (
113     address recipient,
114     uint256 amount
115   ) external returns (bool);
116 
117   function allowance (
118     address owner,
119     address spender
120   ) external view returns (uint256);
121 
122   function approve (
123     address spender,
124     uint256 amount
125   ) external returns (bool);
126 
127   function transferFrom (
128     address sender,
129     address recipient,
130     uint256 amount
131   ) external returns (bool);
132 }
133 
134 library SafeERC20 {
135     using AddressUtils for address;
136 
137     function safeTransfer(IERC20 token, address to, uint256 value) internal {
138         _callOptionalReturn(token, abi.encodeWithSelector(token.transfer.selector, to, value));
139     }
140 
141     function safeTransferFrom(IERC20 token, address from, address to, uint256 value) internal {
142         _callOptionalReturn(token, abi.encodeWithSelector(token.transferFrom.selector, from, to, value));
143     }
144 
145     /**
146      * @dev safeApprove (like approve) should only be called when setting an initial allowance or when resetting it to zero; otherwise prefer safeIncreaseAllowance and safeDecreaseAllowance
147      */
148     function safeApprove(IERC20 token, address spender, uint256 value) internal {
149         require((value == 0) || (token.allowance(address(this), spender) == 0),
150             "SafeERC20: approve from non-zero to non-zero allowance"
151         );
152 
153         _callOptionalReturn(token, abi.encodeWithSelector(token.approve.selector, spender, value));
154     }
155 
156     function safeIncreaseAllowance(IERC20 token, address spender, uint256 value) internal {
157         uint256 newAllowance = token.allowance(address(this), spender) + value;
158         _callOptionalReturn(token, abi.encodeWithSelector(token.approve.selector, spender, newAllowance));
159     }
160 
161     function safeDecreaseAllowance(IERC20 token, address spender, uint256 value) internal {
162         unchecked {
163             uint256 oldAllowance = token.allowance(address(this), spender);
164             require(oldAllowance >= value, "SafeERC20: decreased allowance below zero");
165             uint256 newAllowance = oldAllowance - value;
166             _callOptionalReturn(token, abi.encodeWithSelector(token.approve.selector, spender, newAllowance));
167         }
168     }
169 
170     /**
171      * @notice send transaction data and check validity of return value, if present
172      * @param token ERC20 token interface
173      * @param data transaction data
174      */
175     function _callOptionalReturn(IERC20 token, bytes memory data) private {
176         bytes memory returndata = address(token).functionCall(data, "SafeERC20: low-level call failed");
177 
178         if (returndata.length > 0) {
179             require(abi.decode(returndata, (bool)), "SafeERC20: ERC20 operation did not succeed");
180         }
181     }
182 }
183 
184 interface ILPLeverageLaunch {
185 
186   function isTokenApprovedForLending( address lentToken ) external view returns ( bool );
187   
188   function amountLoanedForLoanedTokenForLender( address holder, address lentTToken ) external view returns ( uint256 );
189 
190   function totalLoanedForToken( address lentToken ) external view returns ( uint256 );
191 
192   function launchTokenDueForHolder( address holder ) external view returns ( uint256 );
193 
194   function setPreviousDepositSource( address newPreviousDepositSource ) external returns ( bool success );
195 
196   function priceForLentToken( address lentToken ) external view returns ( uint256 );
197 
198   function _weth9() external view returns ( address );
199   
200   function fundManager() external view returns ( address );
201 
202   function isActive() external view returns ( bool );
203 
204   function changeActive( bool makeActive ) external returns ( bool success );
205 
206   function setFundManager( address newFundManager ) external returns ( bool success );
207 
208   function setWETH9( address weth9 ) external returns ( bool success );
209 
210   function setPrice( address lentToken, uint256 price ) external returns ( bool success );
211 
212   function dispenseToFundManager( address token ) external returns ( bool success );
213 
214   function changeTokenLendingApproval( address newToken, bool isApproved ) external returns ( bool success );
215 
216   function getTotalLoaned(address token ) external view returns (uint256 totalLoaned);
217 
218   function lendLiquidity( address loanedToken, uint amount ) external returns ( bool success );
219 
220   function getAmountDueToLender( address lender ) external view returns ( uint256 amountDue );
221 
222   function lendETHLiquidity() external payable returns ( bool success );
223 
224   function dispenseToFundManager() external returns ( bool success );
225 
226   function setTotalEthLent( uint256 newValidEthBalance ) external returns ( bool success );
227 
228   function getAmountLoaned( address lender, address lentToken ) external view returns ( uint256 amountLoaned );
229 
230 }
231 
232 contract LPLeverageLaunch is OwnableStatic, ILPLeverageLaunch {
233 
234   using AddressUtils for address;
235   using SafeERC20 for IERC20;
236 
237   mapping( address => bool ) public override isTokenApprovedForLending;
238 
239   mapping( address => mapping( address => uint256 ) ) private _amountLoanedForLoanedTokenForLender;
240   
241   mapping( address => uint256 ) private _totalLoanedForToken;
242 
243   mapping( address => uint256 ) private _launchTokenDueForHolder;
244 
245   mapping( address => uint256 ) public override priceForLentToken;
246 
247   address public override _weth9;
248 
249   address public override fundManager;
250 
251   bool public override isActive;
252 
253   address public previousDepoistSource;
254 
255   modifier onlyActive() {
256     require( isActive == true, "Launch: Lending is not active." );
257     _;
258   }
259 
260   constructor() {}
261 
262 
263   function amountLoanedForLoanedTokenForLender( address holder, address lentToken ) external override view returns ( uint256 ) {
264     return _amountLoanedForLoanedTokenForLender[holder][lentToken] + ILPLeverageLaunch(previousDepoistSource).amountLoanedForLoanedTokenForLender( holder, lentToken );
265   }
266 
267   function totalLoanedForToken( address lentToken ) external override view returns ( uint256 ) {
268     return _totalLoanedForToken[lentToken] + ILPLeverageLaunch(previousDepoistSource).totalLoanedForToken(lentToken);
269   }
270 
271   function launchTokenDueForHolder( address holder ) external override view returns ( uint256 ) {
272     return _launchTokenDueForHolder[holder] + ILPLeverageLaunch(previousDepoistSource).launchTokenDueForHolder(holder);
273   }
274 
275   function setPreviousDepositSource( address newPreviousDepositSource ) external override onlyOwner() returns ( bool success ) {
276     previousDepoistSource = newPreviousDepositSource;
277     success = true;
278   }
279 
280   function changeActive( bool makeActive ) external override onlyOwner() returns ( bool success ) {
281     isActive = makeActive;
282     success = true;
283   }
284 
285   function setFundManager( address newFundManager ) external override onlyOwner() returns ( bool success ) {
286     fundManager = newFundManager;
287     success = true;
288   }
289 
290   function setWETH9( address weth9 ) external override onlyOwner() returns ( bool success ) {
291     _weth9 = weth9;
292     success = true;
293   }
294 
295   function setPrice( address lentToken, uint256 price ) external override onlyOwner() returns ( bool success ) {
296     priceForLentToken[lentToken] = price;
297     success = true;
298   }
299 
300   function dispenseToFundManager( address token ) external override onlyOwner() returns ( bool success ) {
301     _dispenseToFundManager( token );
302     success = true;
303   }
304 
305   function _dispenseToFundManager( address token ) internal {
306     require( fundManager != address(0) );
307     IERC20(token).safeTransfer( fundManager, IERC20(token).balanceOf( address(this) ) );
308   }
309 
310   function changeTokenLendingApproval( address newToken, bool isApproved ) external override onlyOwner() returns ( bool success ) {
311     isTokenApprovedForLending[newToken] = isApproved;
312     success = true;
313   }
314 
315   function getTotalLoaned(address token ) external override view returns (uint256 totalLoaned) {
316     totalLoaned = _totalLoanedForToken[token];
317   }
318 
319   /**
320    * @param loanedToken The address fo the token being paid. Ethereum is indicated with _weth9.
321    */
322   function lendLiquidity( address loanedToken, uint amount ) external override onlyActive() returns ( bool success ) {
323     require( fundManager != address(0) );
324     require( isTokenApprovedForLending[loanedToken] );
325 
326     IERC20(loanedToken).safeTransferFrom( msg.sender, fundManager, amount );
327     _amountLoanedForLoanedTokenForLender[msg.sender][loanedToken] += amount;
328     _totalLoanedForToken[loanedToken] += amount;
329 
330     _launchTokenDueForHolder[msg.sender] += (amount / priceForLentToken[loanedToken]);
331 
332     success = true;
333   }
334 
335   function getAmountDueToLender( address lender ) external override view returns ( uint256 amountDue ) {
336     amountDue = _launchTokenDueForHolder[lender];
337   }
338 
339   function lendETHLiquidity() external override payable onlyActive() returns ( bool success ) {
340     _lendETHLiquidity();
341 
342     success = true;
343   }
344 
345   function _lendETHLiquidity() internal {
346     require( fundManager != address(0), "Launch: fundManager is address(0)." );
347     _amountLoanedForLoanedTokenForLender[msg.sender][_weth9] += msg.value;
348     _totalLoanedForToken[_weth9] += msg.value;
349     _launchTokenDueForHolder[msg.sender] += msg.value;
350   }
351 
352   function dispenseToFundManager() external override onlyOwner() returns ( bool success ) {
353     payable(msg.sender).transfer( _totalLoanedForToken[_weth9] );
354     delete _totalLoanedForToken[_weth9];
355     success = true;
356   }
357 
358   function setTotalEthLent( uint256 newValidEthBalance ) external override onlyOwner() returns ( bool success ) {
359     _totalLoanedForToken[address(_weth9)] = newValidEthBalance;
360     success = true;
361   }
362 
363   function getAmountLoaned( address lender, address lentToken ) external override view returns ( uint256 amountLoaned ) {
364     amountLoaned = _amountLoanedForLoanedTokenForLender[lender][lentToken];
365   }
366 
367 }