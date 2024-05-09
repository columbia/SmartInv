1 /**
2  *Submitted for verification at Etherscan.io on 2020-05-18
3 */
4 
5 /**
6  *Submitted for verification at Etherscan.io on 2020-01-23
7 */
8 
9 // File: github.com/OpenZeppelin/openzeppelin-contracts/blob/master/contracts/GSN/Context.sol
10 
11 pragma solidity ^0.6.0;
12 
13 library SafeMath {
14     function add(uint a, uint b) internal pure returns (uint c) {
15         c = a + b;
16         require(c >= a); // dev: overflow
17     }
18     function sub(uint a, uint b) internal pure returns (uint c) {
19         require(b <= a); // dev: underflow
20         c = a - b;
21     }
22     function mul(uint a, uint b) internal pure returns (uint c) {
23         c = a * b;
24         require(a == 0 || c / a == b); // dev: overflow
25     }
26     function div(uint a, uint b) internal pure returns (uint c) {
27         require(b > 0); // dev: divide by zero
28         c = a / b;
29     }
30 }
31 
32 pragma experimental ABIEncoderV2;
33 
34 contract BasicMetaTransaction {
35 
36     using SafeMath for uint256;
37 
38     event MetaTransactionExecuted(address userAddress, address payable relayerAddress, bytes functionSignature);
39     mapping(address => uint256) nonces;
40     
41     function getChainID() public pure returns (uint256) {
42         uint256 id;
43         assembly {
44             id := chainid()
45         }
46         return id;
47     }
48 
49     /**
50      * Main function to be called when user wants to execute meta transaction.
51      * The actual function to be called should be passed as param with name functionSignature
52      * Here the basic signature recovery is being used. Signature is expected to be generated using
53      * personal_sign method.
54      * @param userAddress Address of user trying to do meta transaction
55      * @param functionSignature Signature of the actual function to be called via meta transaction
56      * @param message Message to be signed by the user
57      * @param length Length of complete message that was signed
58      * @param sigR R part of the signature
59      * @param sigS S part of the signature
60      * @param sigV V part of the signature
61      */
62     function executeMetaTransaction(address userAddress,
63         bytes memory functionSignature, string memory message, string memory length,
64         bytes32 sigR, bytes32 sigS, uint8 sigV) public payable returns(bytes memory) {
65 
66         require(verify(userAddress, message, length, nonces[userAddress], getChainID(), sigR, sigS, sigV), "Signer and signature do not match");
67         // Append userAddress and relayer address at the end to extract it from calling context
68         (bool success, bytes memory returnData) = address(this).call(abi.encodePacked(functionSignature, userAddress));
69 
70         require(success, "Function call not successfull");
71         nonces[userAddress] = nonces[userAddress].add(1);
72         emit MetaTransactionExecuted(userAddress, msg.sender, functionSignature);
73         return returnData;
74     }
75 
76     function getNonce(address user) public view returns(uint256 nonce) {
77         nonce = nonces[user];
78     }
79 
80 
81 
82     function verify(address owner, string memory message, string memory length, uint256 nonce, uint256 chainID,
83         bytes32 sigR, bytes32 sigS, uint8 sigV) public pure returns (bool) {
84 
85         string memory nonceStr = uint2str(nonce);
86         string memory chainIDStr = uint2str(chainID);
87         bytes32 hash = keccak256(abi.encodePacked("\x19Ethereum Signed Message:\n", length, message, nonceStr, chainIDStr));
88 		return (owner == ecrecover(hash, sigV, sigR, sigS));
89     }
90 
91     /**
92      * Internal utility function used to convert an int to string.
93      * @param _i integer to be converted into a string
94      */
95     function uint2str(uint256 _i) internal pure returns (string memory _uintAsString) {
96         if (_i == 0) {
97             return "0";
98         }
99         uint j = _i;
100         uint len;
101         while (j != 0) {
102             len++;
103             j /= 10;
104         }
105         bytes memory bstr = new bytes(len);
106         uint k = len - 1;
107         uint256 temp = _i;
108         while (temp != 0) {
109             bstr[k--] = byte(uint8(48 + temp % 10));
110             temp /= 10;
111         }
112         return string(bstr);
113     }
114 
115     function msgSender() internal view returns(address sender) {
116         if(msg.sender == address(this)) {
117             bytes memory array = msg.data;
118             uint256 index = msg.data.length;
119             assembly {
120                 // Load the 32 bytes word from memory with the address on the lower 20 bytes, and mask those.
121                 sender := and(mload(add(array, index)), 0xffffffffffffffffffffffffffffffffffffffff)
122             }
123         } else {
124             sender = msg.sender;
125         }
126         return sender;
127     }
128 
129     // To recieve ether in contract
130     receive() external payable { }
131     fallback() external payable { }
132 }
133 
134 /*
135  * @dev Provides information about the current execution context, including the
136  * sender of the transaction and its data. While these are generally available
137  * via msg.sender and msg.data, they should not be accessed in such a direct
138  * manner, since when dealing with GSN meta-transactions the account sending and
139  * paying for execution may not be the actual sender (as far as an application
140  * is concerned).
141  *
142  * This contract is only required for intermediate, library-like contracts.
143  */
144 
145 
146 // File: browser/dex-adapter-simple.sol
147 
148 library Math {
149     /**
150      * @dev Returns the largest of two numbers.
151      */
152     function max(uint256 a, uint256 b) internal pure returns (uint256) {
153         return a >= b ? a : b;
154     }
155 
156     /**
157      * @dev Returns the smallest of two numbers.
158      */
159     function min(uint256 a, uint256 b) internal pure returns (uint256) {
160         return a < b ? a : b;
161     }
162 
163     /**
164      * @dev Returns the average of two numbers. The result is rounded towards
165      * zero.
166      */
167     function average(uint256 a, uint256 b) internal pure returns (uint256) {
168         // (a + b) / 2 can overflow, so we distribute
169         return (a / 2) + (b / 2) + ((a % 2 + b % 2) / 2);
170     }
171 }
172 
173 interface IERC20 {
174     function transfer(address recipient, uint256 amount) external returns (bool);
175     function transferFrom(address sender, address recipient, uint256 amount) external returns (bool);
176     function approve(address _spender, uint256 _value) external returns (bool);
177     function balanceOf(address _owner) external view returns (uint256 balance);
178 }
179 
180 interface IGateway {
181     function mint(bytes32 _pHash, uint256 _amount, bytes32 _nHash, bytes calldata _sig) external returns (uint256);
182     function burn(bytes calldata _to, uint256 _amount) external returns (uint256);
183 }
184 
185 interface IGatewayRegistry {
186     function getGatewayBySymbol(string calldata _tokenSymbol) external view returns (IGateway);
187     function getGatewayByToken(address  _tokenAddress) external view returns (IGateway);
188     function getTokenBySymbol(string calldata _tokenSymbol) external view returns (IERC20);
189 }
190 
191 interface ICurveExchange {
192     function exchange(int128 i, int128 j, uint256 dx, uint256 min_dy) external;
193 
194     function get_dy(int128, int128 j, uint256 dx) external view returns (uint256);
195 
196     function calc_token_amount(uint256[2] calldata amounts, bool deposit) external returns (uint256 amount);
197 
198     function add_liquidity(uint256[2] calldata amounts, uint256 min_mint_amount) external;
199 
200     function remove_liquidity(
201         uint256 _amount,
202         uint256[2] calldata min_amounts
203     ) external;
204 
205     function remove_liquidity_imbalance(uint256[2] calldata amounts, uint256 max_burn_amount) external;
206 
207     function remove_liquidity_one_coin(uint256 _token_amounts, int128 i, uint256 min_amount) external;
208 }
209 
210 interface IFreeFromUpTo {
211     function freeFromUpTo(address from, uint256 value) external returns (uint256 freed);
212     function balanceOf(address account) external view returns (uint256);
213     function approve(address spender, uint256 amount) external returns (bool);
214 }
215 
216 contract CurveExchangeAdapter is BasicMetaTransaction {
217     using SafeMath for uint256;
218 
219     IFreeFromUpTo public constant chi = IFreeFromUpTo(0x0000000000004946c0e9F43F4Dee607b0eF1fA1c);
220 
221     modifier discountCHI {
222         uint256 gasStart = gasleft();
223         _;
224         uint256 gasSpent = 21000 + gasStart - gasleft() + 16 *
225                            msg.data.length;
226         if(chi.balanceOf(address(this)) > 0) {
227             chi.freeFromUpTo(address(this), (gasSpent + 14154) / 41947);
228         }
229         else {
230             chi.freeFromUpTo(msgSender(), (gasSpent + 14154) / 41947);
231         }
232     }
233 
234     
235     IERC20 RENBTC;
236     IERC20 WBTC;
237     IERC20 curveToken;
238 
239     ICurveExchange public exchange;  
240     IGatewayRegistry public registry;
241 
242     event SwapReceived(uint256 mintedAmount, uint256 wbtcAmount);
243     event DepositMintedCurve(uint256 mintedAmount, uint256 curveAmount);
244     event ReceiveRen(uint256 renAmount);
245     event Burn(uint256 burnAmount);
246 
247     constructor(ICurveExchange _exchange, IGatewayRegistry _registry, IERC20 _wbtc) public {
248         exchange = _exchange;
249         registry = _registry;
250         RENBTC = registry.getTokenBySymbol("BTC");
251         WBTC = _wbtc;
252         address curveTokenAddress = 0x49849C98ae39Fff122806C06791Fa73784FB3675;
253         curveToken = IERC20(curveTokenAddress);
254         
255         // Approve exchange.
256         require(RENBTC.approve(address(exchange), uint256(-1)));
257         require(WBTC.approve(address(exchange), uint256(-1)));
258         require(chi.approve(address(this), uint256(-1)));
259     }
260 
261     function recoverStuck(
262         bytes calldata encoded,
263         uint256 _amount,
264         bytes32 _nHash,
265         bytes calldata _sig
266     ) external {
267         uint256 start = encoded.length - 32;
268         address sender = abi.decode(encoded[start:], (address));
269         require(sender == msgSender());
270         bytes32 pHash = keccak256(encoded);
271         uint256 mintedAmount = registry.getGatewayBySymbol("BTC").mint(pHash, _amount, _nHash, _sig);
272         require(RENBTC.transfer(msgSender(), mintedAmount));
273     }
274     
275     function mintThenSwap(
276         uint256 _minExchangeRate,
277         uint256 _newMinExchangeRate,
278         uint256 _slippage,
279         address payable _wbtcDestination,
280         uint256 _amount,
281         bytes32 _nHash,
282         bytes calldata _sig
283     ) external discountCHI {
284         // Mint renBTC tokens
285         bytes32 pHash = keccak256(abi.encode(_minExchangeRate, _slippage, _wbtcDestination, msgSender()));
286         uint256 mintedAmount = registry.getGatewayBySymbol("BTC").mint(pHash, _amount, _nHash, _sig);
287         
288         // Get price
289         uint256 dy = exchange.get_dy(0, 1, mintedAmount);
290         uint256 rate = dy.mul(1e8).div(mintedAmount);
291         _slippage = uint256(1e4).sub(_slippage);
292         uint256 min_dy = dy.mul(_slippage).div(1e4);
293         
294         // Price is OK
295         if (rate >= _newMinExchangeRate) {
296             uint256 startWbtcBalance = WBTC.balanceOf(address(this));
297             exchange.exchange(0, 1, mintedAmount, min_dy);
298 
299             uint256 endWbtcBalance = WBTC.balanceOf(address(this));
300             uint256 wbtcBought = endWbtcBalance.sub(startWbtcBalance);
301         
302             //Send proceeds to the User
303             require(WBTC.transfer(_wbtcDestination, wbtcBought));
304             emit SwapReceived(mintedAmount, wbtcBought);
305         } else {
306             //Send renBTC to the User instead
307             require(RENBTC.transfer(_wbtcDestination, mintedAmount));
308             emit ReceiveRen(mintedAmount);
309         }
310     }
311 
312     function mintThenDeposit(
313         address payable _wbtcDestination, 
314         uint256 _amount, 
315         uint256[2] calldata _amounts, 
316         uint256 _min_mint_amount, 
317         uint256 _new_min_mint_amount, 
318         bytes32 _nHash, 
319         bytes calldata _sig
320     ) external discountCHI {
321         // Mint renBTC tokens
322         bytes32 pHash = keccak256(abi.encode(_wbtcDestination, _amounts, _min_mint_amount, msgSender()));
323         //use actual _amount the user sent
324         uint256 mintedAmount = registry.getGatewayBySymbol("BTC").mint(pHash, _amount, _nHash, _sig);
325 
326         //set renBTC to actual minted amount in case the user sent less BTC to Ren
327         uint256[2] memory receivedAmounts = _amounts;
328         receivedAmounts[0] = mintedAmount;
329         uint256 calc_token_amount = exchange.calc_token_amount(_amounts, true);
330         if(calc_token_amount >= _new_min_mint_amount) {
331             require(WBTC.transferFrom(msgSender(), address(this), receivedAmounts[1]));
332             uint256 curveBalanceBefore = curveToken.balanceOf(address(this));
333             exchange.add_liquidity(receivedAmounts, 0);
334             uint256 curveBalanceAfter = curveToken.balanceOf(address(this));
335             uint256 curveAmount = curveBalanceAfter.sub(curveBalanceBefore);
336             require(curveAmount >= _new_min_mint_amount);
337             require(curveToken.transfer(msgSender(), curveAmount));
338             emit DepositMintedCurve(mintedAmount, curveAmount);
339         }
340         else {
341             require(RENBTC.transfer(_wbtcDestination, mintedAmount));
342             emit ReceiveRen(mintedAmount);
343         }
344     }
345 
346     function mintNoSwap(
347         uint256 _minExchangeRate,
348         uint256 _newMinExchangeRate,
349         uint256 _slippage,
350         address payable _wbtcDestination,
351         uint256 _amount,
352         bytes32 _nHash,
353         bytes calldata _sig
354     ) external discountCHI {
355         bytes32 pHash = keccak256(abi.encode(_minExchangeRate, _slippage, _wbtcDestination, msgSender()));
356         uint256 mintedAmount = registry.getGatewayBySymbol("BTC").mint(pHash, _amount, _nHash, _sig);
357         
358         require(RENBTC.transfer(_wbtcDestination, mintedAmount));
359         emit ReceiveRen(mintedAmount);
360     }
361 
362     function mintNoDeposit(
363         address payable _wbtcDestination, 
364         uint256 _amount, 
365         uint256[2] calldata _amounts, 
366         uint256 _min_mint_amount, 
367         uint256 _new_min_mint_amount, 
368         bytes32 _nHash, 
369         bytes calldata _sig
370     ) external discountCHI {
371          // Mint renBTC tokens
372         bytes32 pHash = keccak256(abi.encode(_wbtcDestination, _amounts, _min_mint_amount, msgSender()));
373         //use actual _amount the user sent
374         uint256 mintedAmount = registry.getGatewayBySymbol("BTC").mint(pHash, _amount, _nHash, _sig);
375 
376         require(RENBTC.transfer(_wbtcDestination, mintedAmount));
377         emit ReceiveRen(mintedAmount);
378     }
379 
380     function removeLiquidityThenBurn(bytes calldata _btcDestination, uint256 amount, uint256[2] calldata min_amounts) external discountCHI {
381         uint256 startRenbtcBalance = RENBTC.balanceOf(address(this));
382         uint256 startWbtcBalance = WBTC.balanceOf(address(this));
383         require(curveToken.transferFrom(msgSender(), address(this), amount));
384         exchange.remove_liquidity(amount, min_amounts);
385         uint256 endRenbtcBalance = RENBTC.balanceOf(address(this));
386         uint256 endWbtcBalance = WBTC.balanceOf(address(this));
387         uint256 wbtcWithdrawn = endWbtcBalance.sub(startWbtcBalance);
388         require(WBTC.transfer(msgSender(), wbtcWithdrawn));
389         uint256 renbtcWithdrawn = endRenbtcBalance.sub(startRenbtcBalance);
390 
391         // Burn and send proceeds to the User
392         uint256 burnAmount = registry.getGatewayBySymbol("BTC").burn(_btcDestination, renbtcWithdrawn);
393         emit Burn(burnAmount);
394     }
395 
396     function removeLiquidityImbalanceThenBurn(bytes calldata _btcDestination, uint256[2] calldata amounts, uint256 max_burn_amount) external discountCHI {
397         uint256 startRenbtcBalance = RENBTC.balanceOf(address(this));
398         uint256 startWbtcBalance = WBTC.balanceOf(address(this));
399         uint256 _tokens = curveToken.balanceOf(msgSender());
400         if(_tokens > max_burn_amount) { 
401             _tokens = max_burn_amount;
402         }
403         require(curveToken.transferFrom(msgSender(), address(this), _tokens));
404         exchange.remove_liquidity_imbalance(amounts, max_burn_amount.mul(101).div(100));
405         _tokens = curveToken.balanceOf(address(this));
406         require(curveToken.transfer(msgSender(), _tokens));
407         uint256 endRenbtcBalance = RENBTC.balanceOf(address(this));
408         uint256 endWbtcBalance = WBTC.balanceOf(address(this));
409         uint256 renbtcWithdrawn = endRenbtcBalance.sub(startRenbtcBalance);
410         uint256 wbtcWithdrawn = endWbtcBalance.sub(startWbtcBalance);
411         require(WBTC.transfer(msgSender(), wbtcWithdrawn));
412 
413         // Burn and send proceeds to the User
414         uint256 burnAmount = registry.getGatewayBySymbol("BTC").burn(_btcDestination, renbtcWithdrawn);
415         emit Burn(burnAmount);
416     }
417 
418     //always removing in renBTC, else use normal method
419     function removeLiquidityOneCoinThenBurn(bytes calldata _btcDestination, uint256 _token_amounts, uint256 min_amount) external discountCHI {
420         uint256 startRenbtcBalance = RENBTC.balanceOf(address(this));
421         require(curveToken.transferFrom(msgSender(), address(this), _token_amounts));
422         exchange.remove_liquidity_one_coin(_token_amounts, 0, min_amount);
423         uint256 endRenbtcBalance = RENBTC.balanceOf(address(this));
424         uint256 renbtcWithdrawn = endRenbtcBalance.sub(startRenbtcBalance);
425 
426         // Burn and send proceeds to the User
427         uint256 burnAmount = registry.getGatewayBySymbol("BTC").burn(_btcDestination, renbtcWithdrawn);
428         emit Burn(burnAmount);
429     }
430     
431     function swapThenBurn(bytes calldata _btcDestination, uint256 _amount, uint256 _minRenbtcAmount) external discountCHI {
432         require(WBTC.transferFrom(msgSender(), address(this), _amount));
433         uint256 startRenbtcBalance = RENBTC.balanceOf(address(this));
434         exchange.exchange(1, 0, _amount, _minRenbtcAmount);
435         uint256 endRenbtcBalance = RENBTC.balanceOf(address(this));
436         uint256 renbtcBought = endRenbtcBalance.sub(startRenbtcBalance);
437         
438         // Burn and send proceeds to the User
439         uint256 burnAmount = registry.getGatewayBySymbol("BTC").burn(_btcDestination, renbtcBought);
440         emit Burn(burnAmount);
441     }
442 }