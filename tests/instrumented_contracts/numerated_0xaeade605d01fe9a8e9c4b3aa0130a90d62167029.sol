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
32 contract BasicMetaTransaction {
33 
34     using SafeMath for uint256;
35 
36     event MetaTransactionExecuted(address userAddress, address payable relayerAddress, bytes functionSignature);
37     mapping(address => uint256) nonces;
38     
39     function getChainID() public pure returns (uint256) {
40         uint256 id;
41         assembly {
42             id := chainid()
43         }
44         return id;
45     }
46 
47     /**
48      * Main function to be called when user wants to execute meta transaction.
49      * The actual function to be called should be passed as param with name functionSignature
50      * Here the basic signature recovery is being used. Signature is expected to be generated using
51      * personal_sign method.
52      * @param userAddress Address of user trying to do meta transaction
53      * @param functionSignature Signature of the actual function to be called via meta transaction
54      * @param message Message to be signed by the user
55      * @param length Length of complete message that was signed
56      * @param sigR R part of the signature
57      * @param sigS S part of the signature
58      * @param sigV V part of the signature
59      */
60     function executeMetaTransaction(address userAddress,
61         bytes memory functionSignature, string memory message, string memory length,
62         bytes32 sigR, bytes32 sigS, uint8 sigV) public payable returns(bytes memory) {
63 
64         require(verify(userAddress, message, length, nonces[userAddress], getChainID(), sigR, sigS, sigV), "Signer and signature do not match");
65         // Append userAddress and relayer address at the end to extract it from calling context
66         (bool success, bytes memory returnData) = address(this).call(abi.encodePacked(functionSignature, userAddress));
67 
68         require(success, "Function call not successfull");
69         nonces[userAddress] = nonces[userAddress].add(1);
70         emit MetaTransactionExecuted(userAddress, msg.sender, functionSignature);
71         return returnData;
72     }
73 
74     function getNonce(address user) public view returns(uint256 nonce) {
75         nonce = nonces[user];
76     }
77 
78 
79 
80     function verify(address owner, string memory message, string memory length, uint256 nonce, uint256 chainID,
81         bytes32 sigR, bytes32 sigS, uint8 sigV) public pure returns (bool) {
82 
83         string memory nonceStr = uint2str(nonce);
84         string memory chainIDStr = uint2str(chainID);
85         bytes32 hash = keccak256(abi.encodePacked("\x19Ethereum Signed Message:\n", length, message, nonceStr, chainIDStr));
86 		return (owner == ecrecover(hash, sigV, sigR, sigS));
87     }
88 
89     /**
90      * Internal utility function used to convert an int to string.
91      * @param _i integer to be converted into a string
92      */
93     function uint2str(uint256 _i) internal pure returns (string memory _uintAsString) {
94         if (_i == 0) {
95             return "0";
96         }
97         uint j = _i;
98         uint len;
99         while (j != 0) {
100             len++;
101             j /= 10;
102         }
103         bytes memory bstr = new bytes(len);
104         uint k = len - 1;
105         uint256 temp = _i;
106         while (temp != 0) {
107             bstr[k--] = byte(uint8(48 + temp % 10));
108             temp /= 10;
109         }
110         return string(bstr);
111     }
112 
113     function msgSender() internal view returns(address sender) {
114         if(msg.sender == address(this)) {
115             bytes memory array = msg.data;
116             uint256 index = msg.data.length;
117             assembly {
118                 // Load the 32 bytes word from memory with the address on the lower 20 bytes, and mask those.
119                 sender := and(mload(add(array, index)), 0xffffffffffffffffffffffffffffffffffffffff)
120             }
121         } else {
122             sender = msg.sender;
123         }
124         return sender;
125     }
126 
127     // To recieve ether in contract
128     receive() external payable { }
129     fallback() external payable { }
130 }
131 
132 // File: browser/dex-adapter-simple.sol
133 
134 library Math {
135     /**
136      * @dev Returns the largest of two numbers.
137      */
138     function max(uint256 a, uint256 b) internal pure returns (uint256) {
139         return a >= b ? a : b;
140     }
141 
142     /**
143      * @dev Returns the smallest of two numbers.
144      */
145     function min(uint256 a, uint256 b) internal pure returns (uint256) {
146         return a < b ? a : b;
147     }
148 
149     /**
150      * @dev Returns the average of two numbers. The result is rounded towards
151      * zero.
152      */
153     function average(uint256 a, uint256 b) internal pure returns (uint256) {
154         // (a + b) / 2 can overflow, so we distribute
155         return (a / 2) + (b / 2) + ((a % 2 + b % 2) / 2);
156     }
157 }
158 
159 interface IERC20 {
160     function transfer(address recipient, uint256 amount) external returns (bool);
161     function transferFrom(address sender, address recipient, uint256 amount) external returns (bool);
162     function approve(address _spender, uint256 _value) external returns (bool);
163     function balanceOf(address _owner) external view returns (uint256 balance);
164 }
165 
166 interface IGateway {
167     function mint(bytes32 _pHash, uint256 _amount, bytes32 _nHash, bytes calldata _sig) external returns (uint256);
168     function burn(bytes calldata _to, uint256 _amount) external returns (uint256);
169 }
170 
171 interface IGatewayRegistry {
172     function getGatewayBySymbol(string calldata _tokenSymbol) external view returns (IGateway);
173     function getGatewayByToken(address  _tokenAddress) external view returns (IGateway);
174     function getTokenBySymbol(string calldata _tokenSymbol) external view returns (IERC20);
175 }
176 
177 interface ICurveExchange {
178     function exchange(int128 i, int128 j, uint256 dx, uint256 min_dy) external;
179 
180     function get_dy(int128, int128 j, uint256 dx) external view returns (uint256);
181 
182     function calc_token_amount(uint256[3] calldata amounts, bool deposit) external returns (uint256 amount);
183 
184     function add_liquidity(uint256[3] calldata amounts, uint256 min_mint_amount) external;
185 
186     function remove_liquidity(
187         uint256 _amount,
188         uint256[3] calldata min_amounts
189     ) external;
190 
191     function remove_liquidity_imbalance(uint256[3] calldata amounts, uint256 max_burn_amount) external;
192 
193     function remove_liquidity_one_coin(uint256 _token_amounts, int128 i, uint256 min_amount) external;
194 }
195 
196 interface IFreeFromUpTo {
197     function freeFromUpTo(address from, uint256 value) external returns (uint256 freed);
198     function balanceOf(address account) external view returns (uint256);
199     function approve(address spender, uint256 amount) external returns (bool);
200 }
201 
202 contract CurveExchangeAdapterSBTC is BasicMetaTransaction {
203     using SafeMath for uint256;
204 
205     IFreeFromUpTo public constant chi = IFreeFromUpTo(0x0000000000004946c0e9F43F4Dee607b0eF1fA1c);
206 
207     modifier discountCHI {
208         uint256 gasStart = gasleft();
209         _;
210         uint256 gasSpent = 21000 + gasStart - gasleft() + 16 *
211                            msg.data.length;
212         if(chi.balanceOf(address(this)) > 0) {
213             chi.freeFromUpTo(address(this), (gasSpent + 14154) / 41947);
214         }
215         else {
216             chi.freeFromUpTo(msgSender(), (gasSpent + 14154) / 41947);
217         }
218     }
219 
220     uint256 constant N_COINS = 3;
221     
222     //first coin always is renBTC
223     IERC20[N_COINS] coins;
224     uint256[N_COINS] precisions_normalized = [1,1,1e10];
225 
226     IERC20 curveToken;
227 
228     ICurveExchange public exchange;  
229     IGatewayRegistry public registry;
230 
231     event SwapReceived(uint256 mintedAmount, uint256 erc20BTCAmount, int128 j);
232     event DepositMintedCurve(uint256 mintedAmount, uint256 curveAmount, uint256[N_COINS] amounts);
233     event ReceiveRen(uint256 renAmount);
234     event Burn(uint256 burnAmount);
235 
236     constructor(ICurveExchange _exchange, address _curveTokenAddress, IGatewayRegistry _registry, IERC20[N_COINS] memory _coins) public {
237         exchange = _exchange;
238         registry = _registry;
239         curveToken = IERC20(_curveTokenAddress);
240         for(uint256 i = 0; i < N_COINS; i++) {
241             coins[i] = _coins[i];
242             require(coins[i].approve(address(exchange), uint256(-1)));
243         }
244         require(chi.approve(address(this), uint256(-1)));
245     }
246 
247     function recoverStuck(
248         bytes calldata encoded,
249         uint256 _amount,
250         bytes32 _nHash,
251         bytes calldata _sig
252     ) external {
253         uint256 start = encoded.length - 32;
254         address sender = abi.decode(encoded[start:], (address));
255         require(sender == msgSender());
256         bytes32 pHash = keccak256(encoded);
257         uint256 mintedAmount = registry.getGatewayBySymbol("BTC").mint(pHash, _amount, _nHash, _sig);
258         require(coins[0].transfer(msgSender(), mintedAmount));
259     }
260     
261     function mintThenSwap(
262         uint256 _minExchangeRate,
263         uint256 _newMinExchangeRate,
264         uint256 _slippage,
265         int128 _j,
266         address payable _coinDestination,
267         uint256 _amount,
268         bytes32 _nHash,
269         bytes calldata _sig
270     ) external discountCHI {
271         //params is [_minExchangeRate, _slippage, _i, _j]
272         //fail early so not to spend much gas?
273         //require(_i <= 2 && _j <= 2 && _i != _j);
274         // Mint renBTC tokens
275         bytes32 pHash = keccak256(abi.encode(_minExchangeRate, _slippage, _j, _coinDestination, msgSender()));
276         uint256 mintedAmount = registry.getGatewayBySymbol("BTC").mint(pHash, _amount, _nHash, _sig);
277         
278         // Get price
279         // compare if the exchange rate now * slippage in BPS is what user submitted as
280         uint256 dy = exchange.get_dy(0, _j, mintedAmount);
281         uint256 rate = dy.mul(1e8).div(precisions_normalized[uint256(_j)]).div(mintedAmount);
282         _slippage = uint256(1e4).sub(_slippage);
283         uint256 min_dy = dy.mul(_slippage).div(1e4);
284         
285         // Price is OK
286         if (rate >= _newMinExchangeRate) {
287             require(_j != 0);
288             doSwap(_j, mintedAmount, min_dy, _coinDestination);
289         } else {
290             //Send renBTC to the User instead
291             require(coins[0].transfer(_coinDestination, mintedAmount));
292             emit ReceiveRen(mintedAmount);
293         }
294     }
295 
296     function doSwap(int128 _j, uint256 _mintedAmount, uint256 _min_dy, address payable _coinDestination) internal {
297         uint256 startBalance = coins[uint256(_j)].balanceOf(address(this));
298         exchange.exchange(0, _j, _mintedAmount, _min_dy);
299         uint256 endBalance = coins[uint256(_j)].balanceOf(address(this));
300         uint256 bought = endBalance.sub(startBalance);
301     
302         //Send proceeds to the User
303         require(coins[uint256(_j)].transfer(_coinDestination, bought));
304         emit SwapReceived(_mintedAmount, bought, _j);
305     }
306 
307     function mintThenDeposit(
308         address payable _wbtcDestination, 
309         uint256 _amount, 
310         uint256[N_COINS] calldata _amounts, 
311         uint256 _min_mint_amount, 
312         uint256 _new_min_mint_amount, 
313         bytes32 _nHash, 
314         bytes calldata _sig
315     ) external discountCHI {
316         // Mint renBTC tokens
317         bytes32 pHash = keccak256(abi.encode(_wbtcDestination, _amounts, _min_mint_amount, msgSender()));
318         //use actual _amount the user sent
319         uint256 mintedAmount = registry.getGatewayBySymbol("BTC").mint(pHash, _amount, _nHash, _sig);
320 
321         //set renBTC to actual minted amount in case the user sent less BTC to Ren
322         uint256[N_COINS] memory receivedAmounts = _amounts;
323         receivedAmounts[0] = mintedAmount;
324         for(uint256 i = 1; i < N_COINS; i++) {
325             receivedAmounts[i] = _amounts[i];
326         }
327         if(exchange.calc_token_amount(_amounts, true) >= _new_min_mint_amount) {
328             doDeposit(receivedAmounts, mintedAmount, _new_min_mint_amount, _wbtcDestination);
329         }
330         else {
331             require(coins[0].transfer(_wbtcDestination, mintedAmount));
332             emit ReceiveRen(mintedAmount);
333         }
334     }
335 
336     function doDeposit(uint256[N_COINS] memory receivedAmounts, uint256 mintedAmount, uint256 _new_min_mint_amount, address _wbtcDestination) internal {
337         for(uint256 i = 1; i < N_COINS; i++) {
338             if(receivedAmounts[i] > 0) {
339                 require(coins[i].transferFrom(msgSender(), address(this), receivedAmounts[i]));
340             }
341         }
342         uint256 curveBalanceBefore = curveToken.balanceOf(address(this));
343         exchange.add_liquidity(receivedAmounts, 0);
344         uint256 curveBalanceAfter = curveToken.balanceOf(address(this));
345         uint256 curveAmount = curveBalanceAfter.sub(curveBalanceBefore);
346         require(curveAmount >= _new_min_mint_amount);
347         require(curveToken.transfer(_wbtcDestination, curveAmount));
348         emit DepositMintedCurve(mintedAmount, curveAmount, receivedAmounts);
349     }
350 
351     // function mintNoSwap(
352     //     uint256 _minExchangeRate,
353     //     uint256 _newMinExchangeRate,
354     //     uint256 _slippage,
355     //     int128 _j,
356     //     address payable _wbtcDestination,
357     //     uint256 _amount,
358     //     bytes32 _nHash,
359     //     bytes calldata _sig
360     // ) external discountCHI {
361     //     bytes32 pHash = keccak256(abi.encode(_minExchangeRate, _slippage, _j, _wbtcDestination, msgSender()));
362     //     uint256 mintedAmount = registry.getGatewayBySymbol("BTC").mint(pHash, _amount, _nHash, _sig);
363         
364     //     require(coins[0].transfer(_wbtcDestination, mintedAmount));
365     //     emit ReceiveRen(mintedAmount);
366     // }
367 
368     // function mintNoDeposit(
369     //     address payable _wbtcDestination, 
370     //     uint256 _amount, 
371     //     uint256[N_COINS] calldata _amounts, 
372     //     uint256 _min_mint_amount, 
373     //     uint256 _new_min_mint_amount, 
374     //     bytes32 _nHash, 
375     //     bytes calldata _sig
376     // ) external discountCHI {
377     //      // Mint renBTC tokens
378     //     bytes32 pHash = keccak256(abi.encode(_wbtcDestination, _amounts, _min_mint_amount, msgSender()));
379     //     //use actual _amount the user sent
380     //     uint256 mintedAmount = registry.getGatewayBySymbol("BTC").mint(pHash, _amount, _nHash, _sig);
381 
382     //     require(coins[0].transfer(_wbtcDestination, mintedAmount));
383     //     emit ReceiveRen(mintedAmount);
384     // }
385 
386     function removeLiquidityThenBurn(bytes calldata _btcDestination, address _coinDestination, uint256 amount, uint256[N_COINS] calldata min_amounts) external discountCHI {
387         uint256[N_COINS] memory balances;
388         for(uint256 i = 0; i < coins.length; i++) {
389             balances[i] = coins[i].balanceOf(address(this));
390         }
391 
392         require(curveToken.transferFrom(msgSender(), address(this), amount));
393         exchange.remove_liquidity(amount, min_amounts);
394 
395         for(uint256 i = 0; i < coins.length; i++) {
396             balances[i] = coins[i].balanceOf(address(this)).sub(balances[i]);
397             if(i == 0) continue;
398             require(coins[i].transfer(_coinDestination, balances[i]));
399         }
400 
401         // Burn and send proceeds to the User
402         uint256 burnAmount = registry.getGatewayBySymbol("BTC").burn(_btcDestination, balances[0]);
403         emit Burn(burnAmount);
404     }
405 
406     function removeLiquidityImbalanceThenBurn(bytes calldata _btcDestination, address _coinDestination, uint256[N_COINS] calldata amounts, uint256 max_burn_amount) external discountCHI {
407         uint256[N_COINS] memory balances;
408         for(uint256 i = 0; i < coins.length; i++) {
409             balances[i] = coins[i].balanceOf(address(this));
410         }
411 
412         uint256 _tokens = curveToken.balanceOf(msgSender());
413         if(_tokens > max_burn_amount) { 
414             _tokens = max_burn_amount;
415         }
416         require(curveToken.transferFrom(msgSender(), address(this), _tokens));
417         exchange.remove_liquidity_imbalance(amounts, max_burn_amount.mul(101).div(100));
418         _tokens = curveToken.balanceOf(address(this));
419         require(curveToken.transfer(_coinDestination, _tokens));
420 
421         for(uint256 i = 0; i < coins.length; i++) {
422             balances[i] = coins[i].balanceOf(address(this)).sub(balances[i]);
423             if(i == 0) continue;
424             require(coins[i].transfer(_coinDestination, balances[i]));
425         }
426 
427         // Burn and send proceeds to the User
428         uint256 burnAmount = registry.getGatewayBySymbol("BTC").burn(_btcDestination, balances[0]);
429         emit Burn(burnAmount);
430     }
431 
432     //always removing in renBTC, else use normal method
433     function removeLiquidityOneCoinThenBurn(bytes calldata _btcDestination, uint256 _token_amounts, uint256 min_amount, uint8 _i) external discountCHI {
434         uint256 startRenbtcBalance = coins[0].balanceOf(address(this));
435         require(curveToken.transferFrom(msgSender(), address(this), _token_amounts));
436         exchange.remove_liquidity_one_coin(_token_amounts, _i, min_amount);
437         uint256 endRenbtcBalance = coins[0].balanceOf(address(this));
438         uint256 renbtcWithdrawn = endRenbtcBalance.sub(startRenbtcBalance);
439 
440         // Burn and send proceeds to the User
441         uint256 burnAmount = registry.getGatewayBySymbol("BTC").burn(_btcDestination, renbtcWithdrawn);
442         emit Burn(burnAmount);
443     }
444     
445     function swapThenBurn(bytes calldata _btcDestination, uint256 _amount, uint256 _minRenbtcAmount, uint8 _i) external discountCHI {
446         require(coins[_i].transferFrom(msgSender(), address(this), _amount));
447         uint256 startRenbtcBalance = coins[0].balanceOf(address(this));
448         exchange.exchange(_i, 0, _amount, _minRenbtcAmount);
449         uint256 endRenbtcBalance = coins[0].balanceOf(address(this));
450         uint256 renbtcBought = endRenbtcBalance.sub(startRenbtcBalance);
451         
452         // Burn and send proceeds to the User
453         uint256 burnAmount = registry.getGatewayBySymbol("BTC").burn(_btcDestination, renbtcBought);
454         emit Burn(burnAmount);
455     }
456 }