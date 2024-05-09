1 // SPDX-License-Identifier: Unlicensed
2 
3 pragma solidity ^0.8.7;
4 
5 abstract contract Context {
6     function _msgSender() internal view virtual returns (address payable) {
7         return payable(msg.sender);
8     }
9 
10     function _msgData() internal view virtual returns (bytes memory) {
11         this; // silence state mutability warning without generating bytecode - see https://github.com/ethereum/solidity/issues/2691
12         return msg.data;
13     }
14 }
15 
16 abstract contract Ownable is Context {
17     address private _owner;
18 
19     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
20 
21     constructor() {
22         _transferOwnership(_msgSender());
23     }
24 
25     modifier onlyOwner() {
26         _checkOwner();
27         _;
28     }
29 
30     function owner() public view virtual returns (address) {
31         return _owner;
32     }
33 
34     function _checkOwner() internal view virtual {
35         require(owner() == _msgSender(), "Ownable: caller is not the owner");
36     }
37 
38     function renounceOwnership() public virtual onlyOwner {
39         _transferOwnership(address(0));
40     }
41 
42     function transferOwnership(address newOwner) public virtual onlyOwner {
43         require(newOwner != address(0), "Ownable: new owner is the zero address");
44         _transferOwnership(newOwner);
45     }
46 
47     function _transferOwnership(address newOwner) internal virtual {
48         address oldOwner = _owner;
49         _owner = newOwner;
50         emit OwnershipTransferred(oldOwner, newOwner);
51     }
52 }
53 
54 
55 
56 interface IERC20 {
57 
58     event Transfer(address indexed from, address indexed to, uint256 value);
59     event Approval(address indexed owner, address indexed spender, uint256 value);
60 
61     function totalSupply() external view returns (uint256);
62     function balanceOf(address account) external view returns (uint256);
63     function transfer(address to, uint256 amount) external returns (bool);
64     function allowance(address owner, address spender) external view returns (uint256);
65     function approve(address spender, uint256 amount) external returns (bool);
66     function transferFrom(
67         address from,
68         address to,
69         uint256 amount
70     ) external returns (bool);
71 }
72 
73 interface IERC20Permit {
74     
75     function permit(
76         address owner,
77         address spender,
78         uint256 value,
79         uint256 deadline,
80         uint8 v,
81         bytes32 r,
82         bytes32 s
83     ) external;
84 
85     function nonces(address owner) external view returns (uint256);
86     function DOMAIN_SEPARATOR() external view returns (bytes32);
87 }
88 
89 library Address {
90     
91     function isContract(address account) internal view returns (bool) {
92         // This method relies on extcodesize/address.code.length, which returns 0
93         // for contracts in construction, since the code is only stored at the end
94         // of the constructor execution.
95 
96         return account.code.length > 0;
97     }
98 
99     function sendValue(address payable recipient, uint256 amount) internal {
100         require(address(this).balance >= amount, "Address: insufficient balance");
101 
102         (bool success, ) = recipient.call{value: amount}("");
103         require(success, "Address: unable to send value, recipient may have reverted");
104     }
105 
106     function functionCall(address target, bytes memory data) internal returns (bytes memory) {
107         return functionCallWithValue(target, data, 0, "Address: low-level call failed");
108     }
109 
110     function functionCall(
111         address target,
112         bytes memory data,
113         string memory errorMessage
114     ) internal returns (bytes memory) {
115         return functionCallWithValue(target, data, 0, errorMessage);
116     }
117 
118     function functionCallWithValue(
119         address target,
120         bytes memory data,
121         uint256 value
122     ) internal returns (bytes memory) {
123         return functionCallWithValue(target, data, value, "Address: low-level call with value failed");
124     }
125 
126     function functionCallWithValue(
127         address target,
128         bytes memory data,
129         uint256 value,
130         string memory errorMessage
131     ) internal returns (bytes memory) {
132         require(address(this).balance >= value, "Address: insufficient balance for call");
133         (bool success, bytes memory returndata) = target.call{value: value}(data);
134         return verifyCallResultFromTarget(target, success, returndata, errorMessage);
135     }
136 
137     function functionStaticCall(address target, bytes memory data) internal view returns (bytes memory) {
138         return functionStaticCall(target, data, "Address: low-level static call failed");
139     }
140 
141     function functionStaticCall(
142         address target,
143         bytes memory data,
144         string memory errorMessage
145     ) internal view returns (bytes memory) {
146         (bool success, bytes memory returndata) = target.staticcall(data);
147         return verifyCallResultFromTarget(target, success, returndata, errorMessage);
148     }
149 
150     function functionDelegateCall(address target, bytes memory data) internal returns (bytes memory) {
151         return functionDelegateCall(target, data, "Address: low-level delegate call failed");
152     }
153 
154     function functionDelegateCall(
155         address target,
156         bytes memory data,
157         string memory errorMessage
158     ) internal returns (bytes memory) {
159         (bool success, bytes memory returndata) = target.delegatecall(data);
160         return verifyCallResultFromTarget(target, success, returndata, errorMessage);
161     }
162 
163     function verifyCallResultFromTarget(
164         address target,
165         bool success,
166         bytes memory returndata,
167         string memory errorMessage
168     ) internal view returns (bytes memory) {
169         if (success) {
170             if (returndata.length == 0) {
171                 // only check isContract if the call was successful and the return data is empty
172                 // otherwise we already know that it was a contract
173                 require(isContract(target), "Address: call to non-contract");
174             }
175             return returndata;
176         } else {
177             _revert(returndata, errorMessage);
178         }
179     }
180 
181     function verifyCallResult(
182         bool success,
183         bytes memory returndata,
184         string memory errorMessage
185     ) internal pure returns (bytes memory) {
186         if (success) {
187             return returndata;
188         } else {
189             _revert(returndata, errorMessage);
190         }
191     }
192 
193     function _revert(bytes memory returndata, string memory errorMessage) private pure {
194         // Look for revert reason and bubble it up if present
195         if (returndata.length > 0) {
196             // The easiest way to bubble the revert reason is using memory via assembly
197             /// @solidity memory-safe-assembly
198             assembly {
199                 let returndata_size := mload(returndata)
200                 revert(add(32, returndata), returndata_size)
201             }
202         } else {
203             revert(errorMessage);
204         }
205     }
206 }
207 
208 
209 library SafeERC20 {
210     using Address for address;
211 
212     function safeTransfer(
213         IERC20 token,
214         address to,
215         uint256 value
216     ) internal {
217         _callOptionalReturn(token, abi.encodeWithSelector(token.transfer.selector, to, value));
218     }
219 
220     function safeTransferFrom(
221         IERC20 token,
222         address from,
223         address to,
224         uint256 value
225     ) internal {
226         _callOptionalReturn(token, abi.encodeWithSelector(token.transferFrom.selector, from, to, value));
227     }
228 
229     function safeApprove(
230         IERC20 token,
231         address spender,
232         uint256 value
233     ) internal {
234         // safeApprove should only be called when setting an initial allowance,
235         // or when resetting it to zero. To increase and decrease it, use
236         // 'safeIncreaseAllowance' and 'safeDecreaseAllowance'
237         require(
238             (value == 0) || (token.allowance(address(this), spender) == 0),
239             "SafeERC20: approve from non-zero to non-zero allowance"
240         );
241         _callOptionalReturn(token, abi.encodeWithSelector(token.approve.selector, spender, value));
242     }
243 
244     function safeIncreaseAllowance(
245         IERC20 token,
246         address spender,
247         uint256 value
248     ) internal {
249         uint256 newAllowance = token.allowance(address(this), spender) + value;
250         _callOptionalReturn(token, abi.encodeWithSelector(token.approve.selector, spender, newAllowance));
251     }
252 
253     function safeDecreaseAllowance(
254         IERC20 token,
255         address spender,
256         uint256 value
257     ) internal {
258         unchecked {
259             uint256 oldAllowance = token.allowance(address(this), spender);
260             require(oldAllowance >= value, "SafeERC20: decreased allowance below zero");
261             uint256 newAllowance = oldAllowance - value;
262             _callOptionalReturn(token, abi.encodeWithSelector(token.approve.selector, spender, newAllowance));
263         }
264     }
265 
266     function safePermit(
267         IERC20Permit token,
268         address owner,
269         address spender,
270         uint256 value,
271         uint256 deadline,
272         uint8 v,
273         bytes32 r,
274         bytes32 s
275     ) internal {
276         uint256 nonceBefore = token.nonces(owner);
277         token.permit(owner, spender, value, deadline, v, r, s);
278         uint256 nonceAfter = token.nonces(owner);
279         require(nonceAfter == nonceBefore + 1, "SafeERC20: permit did not succeed");
280     }
281 
282     function _callOptionalReturn(IERC20 token, bytes memory data) private {
283         // We need to perform a low level call here, to bypass Solidity's return data size checking mechanism, since
284         // we're implementing it ourselves. We use {Address.functionCall} to perform this call, which verifies that
285         // the target address contains contract code and also asserts for success in the low-level call.
286 
287         bytes memory returndata = address(token).functionCall(data, "SafeERC20: low-level call failed");
288         if (returndata.length > 0) {
289             // Return data is optional
290             require(abi.decode(returndata, (bool)), "SafeERC20: ERC20 operation did not succeed");
291         }
292     }
293 }
294 
295 contract KishimotoMigration is Ownable {
296     using SafeERC20 for IERC20;
297 
298     mapping (address => uint256) private _conversionRatio; // div by 1000000000
299     mapping (address => mapping(address => uint256)) private _migrateAmount ;
300 
301     IERC20 public constant KishimotoV2 = IERC20(0xAE36155a55F04a696b8362777620027882B31dB5);
302 
303     event Migrated(address indexed account, address indexed token, uint256 amount, uint256 tokensReceived);
304     event ConversionRatioUpdated(uint256 oldRatio, uint256 newRatio);
305 
306     constructor() {
307         // initializing conversion ratio
308         _conversionRatio[0xf5b1Fd29d23e98Db2D9EBb8435E1082e3B38FB65] = 916;   // 1 Bn kishiV1 = 916 kishiV2
309         _conversionRatio[0x5e4Efb364071C64Ee3641fe1E68cB5d2D5558709] = 3071;   // 1 Bn katsumi = 3071 kishiV2
310     }
311 
312     function getConversionRatio(address token) external view returns(uint256){
313         return _conversionRatio[token];
314     }
315 
316     function getClaimableToken(address account, address token) external view returns(uint256) {
317         uint256 accountBalance = IERC20(token).balanceOf(account);
318         uint256 migrateAmount = _migrateAmount[token][account];
319 
320         if (accountBalance > migrateAmount) {
321             accountBalance = migrateAmount;
322         }
323 
324         uint256 claimableTokens = (accountBalance * _conversionRatio[token]) / (10**9);
325 
326         return claimableTokens;
327     }
328 
329     function getMigrateAmount(address token, address account) external view returns(uint256) {
330         return _migrateAmount[token][account];
331     }
332 
333     function migrate(address token) external returns (bool){
334         require(_conversionRatio[token] != 0, "Token not whitelisted");
335         uint256 migrateAmount = _migrateAmount[token][_msgSender()];
336 
337         require(migrateAmount > 0, "No Tokens to migrate");
338 
339         uint256 balance = IERC20(token).balanceOf(_msgSender());
340         if (balance > migrateAmount) {
341             balance = migrateAmount;
342         }
343 
344         _migrateAmount[token][_msgSender()] = migrateAmount - balance;
345         IERC20(token).safeTransferFrom(_msgSender(), address(this), balance);
346 
347         uint256 claimableTokens = (balance * _conversionRatio[token]) / (10**9);
348 
349         KishimotoV2.safeTransfer(_msgSender(), claimableTokens);
350 
351         emit Migrated(_msgSender(), token, balance, claimableTokens);
352 
353         return true;
354     }
355 
356 
357     function updateConversionRatio(address token, uint256 newRatio) external onlyOwner {
358         uint256 oldRatio = _conversionRatio[token];
359         _conversionRatio[token] = newRatio;
360 
361         emit ConversionRatioUpdated(oldRatio, newRatio);
362     }
363 
364     function emergencyWithdraw(address token, uint256 amount) external onlyOwner {
365         IERC20(token).safeTransfer(owner(), amount);
366     }
367 
368     function withdrawETH(address recipient) external onlyOwner {
369         (bool success, ) = recipient.call{ value: address(this).balance }("");
370         require(success, "unable to send value, recipient may have reverted");
371     }
372 
373     function updateMigrateAmount(address token, address[] memory accounts, uint256[] memory amounts) external onlyOwner {
374         require(accounts.length == amounts.length, "Invalid input");
375 
376         for(uint256 i=0 ; i< accounts.length ; i++) {
377             _migrateAmount[token][accounts[i]] = amounts[i];
378         }
379         
380     }
381 }