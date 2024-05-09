1 
2 // File: contracts/IUniswapExchange.sol
3 
4 pragma solidity ^0.5.0;
5 
6 // Solidity Interface
7 
8 contract IUniswapExchange {
9     // Address of ERC20 token sold on this exchange
10     function tokenAddress() external view returns (address token);
11     // Address of Uniswap Factory
12     function factoryAddress() external view returns (address factory);
13     // Provide Liquidity
14     function addLiquidity(uint256 min_liquidity, uint256 max_tokens, uint256 deadline) external payable returns (uint256);
15     function removeLiquidity(uint256 amount, uint256 min_eth, uint256 min_tokens, uint256 deadline) external returns (uint256, uint256);
16     // Get Prices
17     function getEthToTokenInputPrice(uint256 eth_sold) external view returns (uint256 tokens_bought);
18     function getEthToTokenOutputPrice(uint256 tokens_bought) external view returns (uint256 eth_sold);
19     function getTokenToEthInputPrice(uint256 tokens_sold) external view returns (uint256 eth_bought);
20     function getTokenToEthOutputPrice(uint256 eth_bought) external view returns (uint256 tokens_sold);
21     // Trade ETH to ERC20
22     function ethToTokenSwapInput(uint256 min_tokens, uint256 deadline) external payable returns (uint256  tokens_bought);
23     function ethToTokenTransferInput(uint256 min_tokens, uint256 deadline, address recipient) external payable returns (uint256  tokens_bought);
24     function ethToTokenSwapOutput(uint256 tokens_bought, uint256 deadline) external payable returns (uint256  eth_sold);
25     function ethToTokenTransferOutput(uint256 tokens_bought, uint256 deadline, address recipient) external payable returns (uint256  eth_sold);
26     // Trade ERC20 to ETH
27     function tokenToEthSwapInput(uint256 tokens_sold, uint256 min_eth, uint256 deadline) external returns (uint256  eth_bought);
28     function tokenToEthTransferInput(uint256 tokens_sold, uint256 min_tokens, uint256 deadline, address recipient) external returns (uint256  eth_bought);
29     function tokenToEthSwapOutput(uint256 eth_bought, uint256 max_tokens, uint256 deadline) external returns (uint256  tokens_sold);
30     function tokenToEthTransferOutput(uint256 eth_bought, uint256 max_tokens, uint256 deadline, address recipient) external returns (uint256  tokens_sold);
31     // Trade ERC20 to ERC20
32     function tokenToTokenSwapInput(uint256 tokens_sold, uint256 min_tokens_bought, uint256 min_eth_bought, uint256 deadline, address token_addr) external returns (uint256  tokens_bought);
33     function tokenToTokenTransferInput(uint256 tokens_sold, uint256 min_tokens_bought, uint256 min_eth_bought, uint256 deadline, address recipient, address token_addr) external returns (uint256  tokens_bought);
34     function tokenToTokenSwapOutput(uint256 tokens_bought, uint256 max_tokens_sold, uint256 max_eth_sold, uint256 deadline, address token_addr) external returns (uint256  tokens_sold);
35     function tokenToTokenTransferOutput(uint256 tokens_bought, uint256 max_tokens_sold, uint256 max_eth_sold, uint256 deadline, address recipient, address token_addr) external returns (uint256  tokens_sold);
36     // Trade ERC20 to Custom Pool
37     function tokenToExchangeSwapInput(uint256 tokens_sold, uint256 min_tokens_bought, uint256 min_eth_bought, uint256 deadline, address exchange_addr) external returns (uint256  tokens_bought);
38     function tokenToExchangeTransferInput(uint256 tokens_sold, uint256 min_tokens_bought, uint256 min_eth_bought, uint256 deadline, address recipient, address exchange_addr) external returns (uint256  tokens_bought);
39     function tokenToExchangeSwapOutput(uint256 tokens_bought, uint256 max_tokens_sold, uint256 max_eth_sold, uint256 deadline, address exchange_addr) external returns (uint256  tokens_sold);
40     function tokenToExchangeTransferOutput(uint256 tokens_bought, uint256 max_tokens_sold, uint256 max_eth_sold, uint256 deadline, address recipient, address exchange_addr) external returns (uint256  tokens_sold);
41     // ERC20 comaptibility for liquidity tokens
42     bytes32 public name;
43     bytes32 public symbol;
44     uint256 public decimals;
45     function transfer(address _to, uint256 _value) external returns (bool);
46     function transferFrom(address _from, address _to, uint256 value) external returns (bool);
47     function approve(address _spender, uint256 _value) external returns (bool);
48     function allowance(address _owner, address _spender) external view returns (uint256);
49     function balanceOf(address _owner) external view returns (uint256);
50     function totalSupply() public view returns (uint256);
51     // Never use
52     function setup(address token_addr) external;
53 }
54 
55 // File: contracts/IUniswapFactory.sol
56 
57 pragma solidity ^0.5.0;
58 
59 // Solidity Interface
60 
61 contract IUniswapFactory {
62     // Public Variables
63     address public exchangeTemplate;
64     uint256 public tokenCount;
65     // Create Exchange
66     function createExchange(address token) external returns (address exchange);
67     // Get Exchange and Token Info
68     function getExchange(address token) external view returns (address exchange);
69     function getToken(address exchange) external view returns (address token);
70     function getTokenWithId(uint256 tokenId) external view returns (address token);
71     // Never use
72     function initializeFactory(address template) external;
73 }
74 
75 // File: contracts/IDutchExchange.sol
76 
77 pragma solidity ^0.5.0;
78 
79 contract IDutchExchange {
80 
81 
82     mapping(address => mapping(address => uint)) public balances;
83 
84     // Token => Token => auctionIndex => amount
85     mapping(address => mapping(address => mapping(uint => uint))) public extraTokens;
86 
87     // Token => Token =>  auctionIndex => user => amount
88     mapping(address => mapping(address => mapping(uint => mapping(address => uint)))) public sellerBalances;
89     mapping(address => mapping(address => mapping(uint => mapping(address => uint)))) public buyerBalances;
90     mapping(address => mapping(address => mapping(uint => mapping(address => uint)))) public claimedAmounts;
91 
92     
93     function ethToken() public view returns(address);
94     function claimBuyerFunds(address, address, address, uint) public returns(uint, uint);
95     function deposit(address tokenAddress, uint amount) public returns (uint);
96     function withdraw(address tokenAddress, uint amount) public returns (uint);
97     function getAuctionIndex(address token1, address token2) public returns(uint256);
98     function postBuyOrder(address token1, address token2, uint256 auctionIndex, uint256 amount) public returns(uint256);
99     function postSellOrder(address token1, address token2, uint256 auctionIndex, uint256 tokensBought) public returns(uint256, uint256);
100     function getCurrentAuctionPrice(address token1, address token2, uint256 auctionIndex) public view returns(uint256, uint256);
101     function claimAndWithdrawTokensFromSeveralAuctionsAsBuyer(address[] calldata, address[] calldata, uint[] calldata) external view returns(uint[] memory, uint);
102 }
103 
104 // File: contracts/ITokenMinimal.sol
105 
106 pragma solidity ^0.5.0;
107 
108 contract ITokenMinimal {
109     function allowance(address tokenOwner, address spender) public view returns (uint remaining);
110     function balanceOf(address tokenOwner) public view returns (uint balance);
111     function deposit() public payable;
112     function withdraw(uint value) public;
113 }
114 
115 // File: openzeppelin-solidity/contracts/utils/Address.sol
116 
117 pragma solidity ^0.5.2;
118 
119 /**
120  * Utility library of inline functions on addresses
121  */
122 library Address {
123     /**
124      * Returns whether the target address is a contract
125      * @dev This function will return false if invoked during the constructor of a contract,
126      * as the code is not actually created until after the constructor finishes.
127      * @param account address of the account to check
128      * @return whether the target address is a contract
129      */
130     function isContract(address account) internal view returns (bool) {
131         uint256 size;
132         // XXX Currently there is no better way to check if there is a contract in an address
133         // than to check the size of the code at that address.
134         // See https://ethereum.stackexchange.com/a/14016/36603
135         // for more details about how this works.
136         // TODO Check this again before the Serenity release, because all addresses will be
137         // contracts then.
138         // solhint-disable-next-line no-inline-assembly
139         assembly { size := extcodesize(account) }
140         return size > 0;
141     }
142 }
143 
144 // File: openzeppelin-solidity/contracts/token/ERC20/IERC20.sol
145 
146 pragma solidity ^0.5.2;
147 
148 /**
149  * @title ERC20 interface
150  * @dev see https://eips.ethereum.org/EIPS/eip-20
151  */
152 interface IERC20 {
153     function transfer(address to, uint256 value) external returns (bool);
154 
155     function approve(address spender, uint256 value) external returns (bool);
156 
157     function transferFrom(address from, address to, uint256 value) external returns (bool);
158 
159     function totalSupply() external view returns (uint256);
160 
161     function balanceOf(address who) external view returns (uint256);
162 
163     function allowance(address owner, address spender) external view returns (uint256);
164 
165     event Transfer(address indexed from, address indexed to, uint256 value);
166 
167     event Approval(address indexed owner, address indexed spender, uint256 value);
168 }
169 
170 // File: contracts/SafeERC20.sol
171 
172 /*
173 
174 SafeERC20 by daostack.
175 The code is based on a fix by SECBIT Team.
176 
177 USE WITH CAUTION & NO WARRANTY
178 
179 REFERENCE & RELATED READING
180 - https://github.com/ethereum/solidity/issues/4116
181 - https://medium.com/@chris_77367/explaining-unexpected-reverts-starting-with-solidity-0-4-22-3ada6e82308c
182 - https://medium.com/coinmonks/missing-return-value-bug-at-least-130-tokens-affected-d67bf08521ca
183 - https://gist.github.com/BrendanChou/88a2eeb80947ff00bcf58ffdafeaeb61
184 
185 */
186 pragma solidity ^0.5.0;
187 
188 
189 
190 library SafeERC20 {
191     using Address for address;
192 
193     bytes4 constant private TRANSFER_SELECTOR = bytes4(keccak256(bytes("transfer(address,uint256)")));
194     bytes4 constant private TRANSFERFROM_SELECTOR = bytes4(keccak256(bytes("transferFrom(address,address,uint256)")));
195     bytes4 constant private APPROVE_SELECTOR = bytes4(keccak256(bytes("approve(address,uint256)")));
196 
197     function safeTransfer(address _erc20Addr, address _to, uint256 _value) internal {
198 
199         // Must be a contract addr first!
200         require(_erc20Addr.isContract(), "ERC20 is not a contract");
201 
202         (bool success, bytes memory returnValue) =
203         // solhint-disable-next-line avoid-low-level-calls
204         _erc20Addr.call(abi.encodeWithSelector(TRANSFER_SELECTOR, _to, _value));
205         // call return false when something wrong
206         require(success, "safeTransfer must succeed");
207         //check return value
208         require(returnValue.length == 0 || (returnValue.length == 32 && (returnValue[31] != 0)), "safeTransfer must return nothing or true");
209     }
210 
211     function safeTransferFrom(address _erc20Addr, address _from, address _to, uint256 _value) internal {
212 
213         // Must be a contract addr first!
214         require(_erc20Addr.isContract(), "ERC20 is not a contract");
215 
216         (bool success, bytes memory returnValue) =
217         // solhint-disable-next-line avoid-low-level-calls
218         _erc20Addr.call(abi.encodeWithSelector(TRANSFERFROM_SELECTOR, _from, _to, _value));
219         // call return false when something wrong
220         require(success, "safeTransferFrom must succeed");
221         //check return value
222         require(returnValue.length == 0 || (returnValue.length == 32 && (returnValue[31] != 0)), "safeTransferFrom must return nothing or true");
223     }
224 
225     function safeApprove(address _erc20Addr, address _spender, uint256 _value) internal {
226 
227         // Must be a contract addr first!
228         require(_erc20Addr.isContract(), "ERC20 is not a contract");
229 
230         // vvv
231         // This section has been commented out because it is not a necesarry safeguard
232         // vvv
233         /*
234         // safeApprove should only be called when setting an initial allowance,
235         // or when resetting it to zero.
236         require((_value == 0) || (IERC20(_erc20Addr).allowance(address(this), _spender) == 0), "safeApprove should only be called when setting an initial allowance, or when resetting it to zero.");
237         */
238 
239         (bool success, bytes memory returnValue) =
240         // solhint-disable-next-line avoid-low-level-calls
241         _erc20Addr.call(abi.encodeWithSelector(APPROVE_SELECTOR, _spender, _value));
242         // call return false when something wrong
243         require(success, "safeApprove must succeed");
244         //check return value
245         require(returnValue.length == 0 || (returnValue.length == 32 && (returnValue[31] != 0)),  "safeApprove must return nothing or true");
246     }
247 }
248 
249 // File: openzeppelin-solidity/contracts/ownership/Ownable.sol
250 
251 pragma solidity ^0.5.2;
252 
253 /**
254  * @title Ownable
255  * @dev The Ownable contract has an owner address, and provides basic authorization control
256  * functions, this simplifies the implementation of "user permissions".
257  */
258 contract Ownable {
259     address private _owner;
260 
261     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
262 
263     /**
264      * @dev The Ownable constructor sets the original `owner` of the contract to the sender
265      * account.
266      */
267     constructor () internal {
268         _owner = msg.sender;
269         emit OwnershipTransferred(address(0), _owner);
270     }
271 
272     /**
273      * @return the address of the owner.
274      */
275     function owner() public view returns (address) {
276         return _owner;
277     }
278 
279     /**
280      * @dev Throws if called by any account other than the owner.
281      */
282     modifier onlyOwner() {
283         require(isOwner());
284         _;
285     }
286 
287     /**
288      * @return true if `msg.sender` is the owner of the contract.
289      */
290     function isOwner() public view returns (bool) {
291         return msg.sender == _owner;
292     }
293 
294     /**
295      * @dev Allows the current owner to relinquish control of the contract.
296      * It will not be possible to call the functions with the `onlyOwner`
297      * modifier anymore.
298      * @notice Renouncing ownership will leave the contract without an owner,
299      * thereby removing any functionality that is only available to the owner.
300      */
301     function renounceOwnership() public onlyOwner {
302         emit OwnershipTransferred(_owner, address(0));
303         _owner = address(0);
304     }
305 
306     /**
307      * @dev Allows the current owner to transfer control of the contract to a newOwner.
308      * @param newOwner The address to transfer ownership to.
309      */
310     function transferOwnership(address newOwner) public onlyOwner {
311         _transferOwnership(newOwner);
312     }
313 
314     /**
315      * @dev Transfers control of the contract to a newOwner.
316      * @param newOwner The address to transfer ownership to.
317      */
318     function _transferOwnership(address newOwner) internal {
319         require(newOwner != address(0));
320         emit OwnershipTransferred(_owner, newOwner);
321         _owner = newOwner;
322     }
323 }
324 
325 // File: contracts/Arbitrage.sol
326 
327 pragma solidity ^0.5.0;
328 
329 
330 
331 
332 
333 
334 
335 /// @title Uniswap Arbitrage - Executes arbitrage transactions between Uniswap and DutchX.
336 /// @author Billy Rennekamp - <billy@gnosis.pm>
337 contract Arbitrage is Ownable {
338 
339     uint constant max = uint(-1);
340 
341     IUniswapFactory public uniFactory;
342     IDutchExchange public dutchXProxy;
343 
344     event Profit(uint profit, bool wasDutchOpportunity);
345 
346     /// @dev Payable fallback function has nothing inside so it won't run out of gas with gas limited transfers
347     function() external payable {}
348 
349     /// @dev Only owner can deposit contract Ether into the DutchX as WETH
350     function depositEther() public payable onlyOwner {
351 
352         require(address(this).balance > 0, "Balance must be greater than 0 to deposit");
353         uint balance = address(this).balance;
354 
355         // // Deposit balance to WETH
356         address weth = dutchXProxy.ethToken();
357         ITokenMinimal(weth).deposit.value(balance)();
358 
359         uint wethBalance = ITokenMinimal(weth).balanceOf(address(this));
360         uint allowance = ITokenMinimal(weth).allowance(address(this), address(dutchXProxy));
361 
362         if (allowance < wethBalance) {
363             // Approve max amount of WETH to be transferred by dutchX
364             // Keeping it max will have same or similar costs to making it exact over and over again
365             SafeERC20.safeApprove(weth, address(dutchXProxy), max);
366         }
367 
368         // Deposit new amount on dutchX, confirm there's at least the amount we just deposited
369         uint newBalance = dutchXProxy.deposit(weth, balance);
370         require(newBalance >= balance, "Deposit WETH to DutchX didn't work.");
371     }
372 
373     /// @dev Only owner can withdraw WETH from DutchX, convert to Ether and transfer to owner
374     /// @param amount The amount of Ether to withdraw
375     function withdrawEtherThenTransfer(uint amount) external onlyOwner {
376         _withdrawEther(amount);
377         address(uint160(owner())).transfer(amount);
378     }
379 
380     /// @dev Only owner can transfer any Ether currently in the contract to the owner address.
381     /// @param amount The amount of Ether to withdraw
382     function transferEther(uint amount) external onlyOwner {
383         // If amount is zero, deposit the entire contract balance.
384         address(uint160(owner())).transfer(amount == 0 ? address(this).balance : amount);
385     }
386 
387     /// @dev Only owner function to withdraw WETH from the DutchX, convert it to Ether and keep it in contract
388     /// @param amount The amount of WETH to withdraw and convert.
389     function withdrawEther(uint amount) external onlyOwner {
390         _withdrawEther(amount);
391     }
392 
393     /// @dev Internal function to withdraw WETH from the DutchX, convert it to Ether and keep it in contract
394     /// @param amount The amount of WETH to withdraw and convert.
395     function _withdrawEther(uint amount) internal {
396         address weth = dutchXProxy.ethToken();
397         dutchXProxy.withdraw(weth, amount);
398         ITokenMinimal(weth).withdraw(amount);
399     }
400 
401     /// @dev Only owner can withdraw a token from the DutchX
402     /// @param token The token address that is being withdrawn.
403     /// @param amount The amount of token to withdraw. Can be larger than available balance and maximum will be withdrawn.
404     /// @return Returns the amount actually withdrawn from the DutchX
405     function withdrawToken(address token, uint amount) external onlyOwner returns (uint) {
406         return dutchXProxy.withdraw(token, amount);
407     }
408 
409     /// @dev Only owner can transfer tokens to the owner that belong to this contract
410     /// @param token The token address that is being transferred.
411     /// @param amount The amount of token to transfer.
412     function transferToken(address token, uint amount) external onlyOwner {
413         SafeERC20.safeTransfer(token, owner(), amount);
414     }
415 
416     /// @dev Only owner can approve tokens to be used by the DutchX
417     /// @param token The token address to be approved for use
418     /// @param allowance The amount of tokens that should be approved
419     function approveToken(address token, uint allowance) external onlyOwner {
420         SafeERC20.safeApprove(token, address(dutchXProxy), allowance);
421     }
422 
423     /// @dev Only owner can deposit token to the DutchX
424     /// @param token The token address that is being deposited.
425     /// @param amount The amount of token to deposit.
426     function depositToken(address token, uint amount) external onlyOwner {
427         _depositToken(token, amount);
428     }
429 
430     /// @dev Internal function to deposit token to the DutchX
431     /// @param token The token address that is being deposited.
432     /// @param amount The amount of token to deposit.
433     function _depositToken(address token, uint amount) internal {
434 
435         uint allowance = ITokenMinimal(token).allowance(address(this), address(dutchXProxy));
436         if (allowance < amount) {
437             SafeERC20.safeApprove(token, address(dutchXProxy), max);
438         }
439 
440         // Confirm that the balance of the token on the DutchX is at least how much was deposited
441         uint newBalance = dutchXProxy.deposit(token, amount);
442         require(newBalance >= amount, "deposit didn't work");
443     }
444 
445     /// @dev Executes a trade opportunity on dutchX. Assumes that there is a balance of WETH already on the dutchX
446     /// @param arbToken Address of the token that should be arbitraged.
447     /// @param amount Amount of Ether to use in arbitrage.
448     /// @return Returns if transaction can be executed.
449     function dutchOpportunity(address arbToken, uint256 amount) external onlyOwner {
450 
451         address etherToken = dutchXProxy.ethToken();
452 
453         // The order of parameters for getAuctionIndex don't matter
454         uint256 dutchAuctionIndex = dutchXProxy.getAuctionIndex(arbToken, etherToken);
455 
456         // postBuyOrder(sellToken, buyToken, amount)
457         // results in a decrease of the amount the user owns of the second token
458         // which means the buyToken is what the buyer wants to get rid of.
459         // "The buy token is what the buyer provides, the seller token is what the seller provides."
460         dutchXProxy.postBuyOrder(arbToken, etherToken, dutchAuctionIndex, amount);
461 
462         (uint tokensBought, ) = dutchXProxy.claimBuyerFunds(arbToken, etherToken, address(this), dutchAuctionIndex);
463         dutchXProxy.withdraw(arbToken, tokensBought);
464 
465         address uniswapExchange = uniFactory.getExchange(arbToken);
466 
467         uint allowance = ITokenMinimal(arbToken).allowance(address(this), address(uniswapExchange));
468         if (allowance < tokensBought) {
469             // Approve Uniswap to transfer arbToken on contract's behalf
470             // Keeping it max will have same or similar costs to making it exact over and over again
471             SafeERC20.safeApprove(arbToken, address(uniswapExchange), max);
472         }
473 
474         // tokenToEthSwapInput(inputToken, minimumReturn, timeToLive)
475         // minimumReturn is enough to make a profit (excluding gas)
476         // timeToLive is now because transaction is atomic
477         uint256 etherReturned = IUniswapExchange(uniswapExchange).tokenToEthSwapInput(tokensBought, 1, block.timestamp);
478 
479         // gas costs were excluded because worse case scenario the tx fails and gas costs were spent up to here anyway
480         // best worst case scenario the profit from the trade alleviates part of the gas costs even if still no total profit
481         require(etherReturned >= amount, "no profit");
482         emit Profit(etherReturned, true);
483 
484         // Ether is deposited as WETH
485         depositEther();
486     }
487 
488     /// @dev Executes a trade opportunity on uniswap.
489     /// @param arbToken Address of the token that should be arbitraged.
490     /// @param amount Amount of Ether to use in arbitrage.
491     /// @return Returns if transaction can be executed.
492     function uniswapOpportunity(address arbToken, uint256 amount) external onlyOwner {
493 
494         // WETH must be converted to Eth for Uniswap trade
495         // (Uniswap allows ERC20:ERC20 but most liquidity is on ETH:ERC20 markets)
496         _withdrawEther(amount);
497         require(address(this).balance >= amount, "buying from uniswap takes real Ether");
498 
499         // ethToTokenSwapInput(minTokens, deadline)
500         // minTokens is 1 because it will revert without a profit regardless
501         // deadline is now since trade is atomic
502         // solium-disable-next-line security/no-block-members
503         uint256 tokensBought = IUniswapExchange(uniFactory.getExchange(arbToken)).ethToTokenSwapInput.value(amount)(1, block.timestamp);
504 
505         // tokens need to be approved for the dutchX before they are deposited
506         _depositToken(arbToken, tokensBought);
507 
508         address etherToken = dutchXProxy.ethToken();
509 
510         // The order of parameters for getAuctionIndex don't matter
511         uint256 dutchAuctionIndex = dutchXProxy.getAuctionIndex(arbToken, etherToken);
512 
513         // spend max amount of tokens currently on the dutch x (might be combined from previous remainders)
514         // max is automatically reduced to maximum available tokens because there may be
515         // token remainders from previous auctions which closed after previous arbitrage opportunities
516         dutchXProxy.postBuyOrder(etherToken, arbToken, dutchAuctionIndex, max);
517         // solium-disable-next-line no-unused-vars
518         (uint etherReturned, ) = dutchXProxy.claimBuyerFunds(etherToken, arbToken, address(this), dutchAuctionIndex);
519 
520         // gas costs were excluded because worse case scenario the tx fails and gas costs were spent up to here anyway
521         // best worst case scenario the profit from the trade alleviates part of the gas costs even if still no total profit
522         require(etherReturned >= amount, "no profit");
523         emit Profit(etherReturned, false);
524         // Ether returned is already in dutchX balance where Ether is assumed to be stored when not being used.
525     }
526 
527 }
528 
529 // File: contracts/ArbitrageMainnet.sol
530 
531 pragma solidity ^0.5.0;
532 
533 /// @title Uniswap Arbitrage Module - Executes arbitrage transactions between Uniswap and DutchX.
534 /// @author Billy Rennekamp - <billy@gnosis.pm>
535 contract ArbitrageMainnet is Arbitrage {
536     constructor() public {
537         uniFactory = IUniswapFactory(0xc0a47dFe034B400B47bDaD5FecDa2621de6c4d95);
538         dutchXProxy = IDutchExchange(0xb9812E2fA995EC53B5b6DF34d21f9304762C5497);
539     }
540 }
