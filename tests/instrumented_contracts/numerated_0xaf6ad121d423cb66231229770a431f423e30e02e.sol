1 /**
2  * Source Code first verified at https://etherscan.io on Friday, May 24, 2019
3  (UTC) */
4 
5 // File: contracts/IUniswapExchange.sol
6 
7 pragma solidity ^0.5.0;
8 
9 // Solidity Interface
10 
11 contract IUniswapExchange {
12     // Address of ERC20 token sold on this exchange
13     function tokenAddress() external view returns (address token);
14     // Address of Uniswap Factory
15     function factoryAddress() external view returns (address factory);
16     // Provide Liquidity
17     function addLiquidity(uint256 min_liquidity, uint256 max_tokens, uint256 deadline) external payable returns (uint256);
18     function removeLiquidity(uint256 amount, uint256 min_eth, uint256 min_tokens, uint256 deadline) external returns (uint256, uint256);
19     // Get Prices
20     function getEthToTokenInputPrice(uint256 eth_sold) external view returns (uint256 tokens_bought);
21     function getEthToTokenOutputPrice(uint256 tokens_bought) external view returns (uint256 eth_sold);
22     function getTokenToEthInputPrice(uint256 tokens_sold) external view returns (uint256 eth_bought);
23     function getTokenToEthOutputPrice(uint256 eth_bought) external view returns (uint256 tokens_sold);
24     // Trade ETH to ERC20
25     function ethToTokenSwapInput(uint256 min_tokens, uint256 deadline) external payable returns (uint256  tokens_bought);
26     function ethToTokenTransferInput(uint256 min_tokens, uint256 deadline, address recipient) external payable returns (uint256  tokens_bought);
27     function ethToTokenSwapOutput(uint256 tokens_bought, uint256 deadline) external payable returns (uint256  eth_sold);
28     function ethToTokenTransferOutput(uint256 tokens_bought, uint256 deadline, address recipient) external payable returns (uint256  eth_sold);
29     // Trade ERC20 to ETH
30     function tokenToEthSwapInput(uint256 tokens_sold, uint256 min_eth, uint256 deadline) external returns (uint256  eth_bought);
31     function tokenToEthTransferInput(uint256 tokens_sold, uint256 min_tokens, uint256 deadline, address recipient) external returns (uint256  eth_bought);
32     function tokenToEthSwapOutput(uint256 eth_bought, uint256 max_tokens, uint256 deadline) external returns (uint256  tokens_sold);
33     function tokenToEthTransferOutput(uint256 eth_bought, uint256 max_tokens, uint256 deadline, address recipient) external returns (uint256  tokens_sold);
34     // Trade ERC20 to ERC20
35     function tokenToTokenSwapInput(uint256 tokens_sold, uint256 min_tokens_bought, uint256 min_eth_bought, uint256 deadline, address token_addr) external returns (uint256  tokens_bought);
36     function tokenToTokenTransferInput(uint256 tokens_sold, uint256 min_tokens_bought, uint256 min_eth_bought, uint256 deadline, address recipient, address token_addr) external returns (uint256  tokens_bought);
37     function tokenToTokenSwapOutput(uint256 tokens_bought, uint256 max_tokens_sold, uint256 max_eth_sold, uint256 deadline, address token_addr) external returns (uint256  tokens_sold);
38     function tokenToTokenTransferOutput(uint256 tokens_bought, uint256 max_tokens_sold, uint256 max_eth_sold, uint256 deadline, address recipient, address token_addr) external returns (uint256  tokens_sold);
39     // Trade ERC20 to Custom Pool
40     function tokenToExchangeSwapInput(uint256 tokens_sold, uint256 min_tokens_bought, uint256 min_eth_bought, uint256 deadline, address exchange_addr) external returns (uint256  tokens_bought);
41     function tokenToExchangeTransferInput(uint256 tokens_sold, uint256 min_tokens_bought, uint256 min_eth_bought, uint256 deadline, address recipient, address exchange_addr) external returns (uint256  tokens_bought);
42     function tokenToExchangeSwapOutput(uint256 tokens_bought, uint256 max_tokens_sold, uint256 max_eth_sold, uint256 deadline, address exchange_addr) external returns (uint256  tokens_sold);
43     function tokenToExchangeTransferOutput(uint256 tokens_bought, uint256 max_tokens_sold, uint256 max_eth_sold, uint256 deadline, address recipient, address exchange_addr) external returns (uint256  tokens_sold);
44     // ERC20 comaptibility for liquidity tokens
45     bytes32 public name;
46     bytes32 public symbol;
47     uint256 public decimals;
48     function transfer(address _to, uint256 _value) external returns (bool);
49     function transferFrom(address _from, address _to, uint256 value) external returns (bool);
50     function approve(address _spender, uint256 _value) external returns (bool);
51     function allowance(address _owner, address _spender) external view returns (uint256);
52     function balanceOf(address _owner) external view returns (uint256);
53     function totalSupply() public view returns (uint256);
54     // Never use
55     function setup(address token_addr) external;
56 }
57 
58 // File: contracts/IUniswapFactory.sol
59 
60 pragma solidity ^0.5.0;
61 
62 // Solidity Interface
63 
64 contract IUniswapFactory {
65     // Public Variables
66     address public exchangeTemplate;
67     uint256 public tokenCount;
68     // Create Exchange
69     function createExchange(address token) external returns (address exchange);
70     // Get Exchange and Token Info
71     function getExchange(address token) external view returns (address exchange);
72     function getToken(address exchange) external view returns (address token);
73     function getTokenWithId(uint256 tokenId) external view returns (address token);
74     // Never use
75     function initializeFactory(address template) external;
76 }
77 
78 // File: contracts/IDutchExchange.sol
79 
80 pragma solidity ^0.5.0;
81 
82 contract IDutchExchange {
83 
84 
85     mapping(address => mapping(address => uint)) public balances;
86 
87     // Token => Token => auctionIndex => amount
88     mapping(address => mapping(address => mapping(uint => uint))) public extraTokens;
89 
90     // Token => Token =>  auctionIndex => user => amount
91     mapping(address => mapping(address => mapping(uint => mapping(address => uint)))) public sellerBalances;
92     mapping(address => mapping(address => mapping(uint => mapping(address => uint)))) public buyerBalances;
93     mapping(address => mapping(address => mapping(uint => mapping(address => uint)))) public claimedAmounts;
94 
95     
96     function ethToken() public view returns(address);
97     function claimBuyerFunds(address, address, address, uint) public returns(uint, uint);
98     function deposit(address tokenAddress, uint amount) public returns (uint);
99     function withdraw(address tokenAddress, uint amount) public returns (uint);
100     function getAuctionIndex(address token1, address token2) public returns(uint256);
101     function postBuyOrder(address token1, address token2, uint256 auctionIndex, uint256 amount) public returns(uint256);
102     function postSellOrder(address token1, address token2, uint256 auctionIndex, uint256 tokensBought) public returns(uint256, uint256);
103     function getCurrentAuctionPrice(address token1, address token2, uint256 auctionIndex) public view returns(uint256, uint256);
104     function claimAndWithdrawTokensFromSeveralAuctionsAsBuyer(address[] calldata, address[] calldata, uint[] calldata) external view returns(uint[] memory, uint);
105 }
106 
107 // File: contracts/ITokenMinimal.sol
108 
109 pragma solidity ^0.5.0;
110 
111 contract ITokenMinimal {
112     function allowance(address tokenOwner, address spender) public view returns (uint remaining);
113     function balanceOf(address tokenOwner) public view returns (uint balance);
114     function deposit() public payable;
115     function withdraw(uint value) public;
116 }
117 
118 // File: openzeppelin-solidity/contracts/utils/Address.sol
119 
120 pragma solidity ^0.5.2;
121 
122 /**
123  * Utility library of inline functions on addresses
124  */
125 library Address {
126     /**
127      * Returns whether the target address is a contract
128      * @dev This function will return false if invoked during the constructor of a contract,
129      * as the code is not actually created until after the constructor finishes.
130      * @param account address of the account to check
131      * @return whether the target address is a contract
132      */
133     function isContract(address account) internal view returns (bool) {
134         uint256 size;
135         // XXX Currently there is no better way to check if there is a contract in an address
136         // than to check the size of the code at that address.
137         // See https://ethereum.stackexchange.com/a/14016/36603
138         // for more details about how this works.
139         // TODO Check this again before the Serenity release, because all addresses will be
140         // contracts then.
141         // solhint-disable-next-line no-inline-assembly
142         assembly { size := extcodesize(account) }
143         return size > 0;
144     }
145 }
146 
147 // File: openzeppelin-solidity/contracts/token/ERC20/IERC20.sol
148 
149 pragma solidity ^0.5.2;
150 
151 /**
152  * @title ERC20 interface
153  * @dev see https://eips.ethereum.org/EIPS/eip-20
154  */
155 interface IERC20 {
156     function transfer(address to, uint256 value) external returns (bool);
157 
158     function approve(address spender, uint256 value) external returns (bool);
159 
160     function transferFrom(address from, address to, uint256 value) external returns (bool);
161 
162     function totalSupply() external view returns (uint256);
163 
164     function balanceOf(address who) external view returns (uint256);
165 
166     function allowance(address owner, address spender) external view returns (uint256);
167 
168     event Transfer(address indexed from, address indexed to, uint256 value);
169 
170     event Approval(address indexed owner, address indexed spender, uint256 value);
171 }
172 
173 // File: contracts/SafeERC20.sol
174 
175 /*
176 
177 SafeERC20 by daostack.
178 The code is based on a fix by SECBIT Team.
179 
180 USE WITH CAUTION & NO WARRANTY
181 
182 REFERENCE & RELATED READING
183 - https://github.com/ethereum/solidity/issues/4116
184 - https://medium.com/@chris_77367/explaining-unexpected-reverts-starting-with-solidity-0-4-22-3ada6e82308c
185 - https://medium.com/coinmonks/missing-return-value-bug-at-least-130-tokens-affected-d67bf08521ca
186 - https://gist.github.com/BrendanChou/88a2eeb80947ff00bcf58ffdafeaeb61
187 
188 */
189 pragma solidity ^0.5.0;
190 
191 
192 
193 library SafeERC20 {
194     using Address for address;
195 
196     bytes4 constant private TRANSFER_SELECTOR = bytes4(keccak256(bytes("transfer(address,uint256)")));
197     bytes4 constant private TRANSFERFROM_SELECTOR = bytes4(keccak256(bytes("transferFrom(address,address,uint256)")));
198     bytes4 constant private APPROVE_SELECTOR = bytes4(keccak256(bytes("approve(address,uint256)")));
199 
200     function safeTransfer(address _erc20Addr, address _to, uint256 _value) internal {
201 
202         // Must be a contract addr first!
203         require(_erc20Addr.isContract(), "ERC20 is not a contract");
204 
205         (bool success, bytes memory returnValue) =
206         // solhint-disable-next-line avoid-low-level-calls
207         _erc20Addr.call(abi.encodeWithSelector(TRANSFER_SELECTOR, _to, _value));
208         // call return false when something wrong
209         require(success, "safeTransfer must succeed");
210         //check return value
211         require(returnValue.length == 0 || (returnValue.length == 32 && (returnValue[31] != 0)), "safeTransfer must return nothing or true");
212     }
213 
214     function safeTransferFrom(address _erc20Addr, address _from, address _to, uint256 _value) internal {
215 
216         // Must be a contract addr first!
217         require(_erc20Addr.isContract(), "ERC20 is not a contract");
218 
219         (bool success, bytes memory returnValue) =
220         // solhint-disable-next-line avoid-low-level-calls
221         _erc20Addr.call(abi.encodeWithSelector(TRANSFERFROM_SELECTOR, _from, _to, _value));
222         // call return false when something wrong
223         require(success, "safeTransferFrom must succeed");
224         //check return value
225         require(returnValue.length == 0 || (returnValue.length == 32 && (returnValue[31] != 0)), "safeTransferFrom must return nothing or true");
226     }
227 
228     function safeApprove(address _erc20Addr, address _spender, uint256 _value) internal {
229 
230         // Must be a contract addr first!
231         require(_erc20Addr.isContract(), "ERC20 is not a contract");
232         
233         // safeApprove should only be called when setting an initial allowance,
234         // or when resetting it to zero.
235         require((_value == 0) || (IERC20(_erc20Addr).allowance(address(this), _spender) == 0), "safeApprove should only be called when setting an initial allowance, or when resetting it to zero.");
236 
237         (bool success, bytes memory returnValue) =
238         // solhint-disable-next-line avoid-low-level-calls
239         _erc20Addr.call(abi.encodeWithSelector(APPROVE_SELECTOR, _spender, _value));
240         // call return false when something wrong
241         require(success, "safeApprove must succeed");
242         //check return value
243         require(returnValue.length == 0 || (returnValue.length == 32 && (returnValue[31] != 0)),  "safeApprove must return nothing or true");
244     }
245 }
246 
247 // File: openzeppelin-solidity/contracts/ownership/Ownable.sol
248 
249 pragma solidity ^0.5.2;
250 
251 /**
252  * @title Ownable
253  * @dev The Ownable contract has an owner address, and provides basic authorization control
254  * functions, this simplifies the implementation of "user permissions".
255  */
256 contract Ownable {
257     address private _owner;
258 
259     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
260 
261     /**
262      * @dev The Ownable constructor sets the original `owner` of the contract to the sender
263      * account.
264      */
265     constructor () internal {
266         _owner = msg.sender;
267         emit OwnershipTransferred(address(0), _owner);
268     }
269 
270     /**
271      * @return the address of the owner.
272      */
273     function owner() public view returns (address) {
274         return _owner;
275     }
276 
277     /**
278      * @dev Throws if called by any account other than the owner.
279      */
280     modifier onlyOwner() {
281         require(isOwner());
282         _;
283     }
284 
285     /**
286      * @return true if `msg.sender` is the owner of the contract.
287      */
288     function isOwner() public view returns (bool) {
289         return msg.sender == _owner;
290     }
291 
292     /**
293      * @dev Allows the current owner to relinquish control of the contract.
294      * It will not be possible to call the functions with the `onlyOwner`
295      * modifier anymore.
296      * @notice Renouncing ownership will leave the contract without an owner,
297      * thereby removing any functionality that is only available to the owner.
298      */
299     function renounceOwnership() public onlyOwner {
300         emit OwnershipTransferred(_owner, address(0));
301         _owner = address(0);
302     }
303 
304     /**
305      * @dev Allows the current owner to transfer control of the contract to a newOwner.
306      * @param newOwner The address to transfer ownership to.
307      */
308     function transferOwnership(address newOwner) public onlyOwner {
309         _transferOwnership(newOwner);
310     }
311 
312     /**
313      * @dev Transfers control of the contract to a newOwner.
314      * @param newOwner The address to transfer ownership to.
315      */
316     function _transferOwnership(address newOwner) internal {
317         require(newOwner != address(0));
318         emit OwnershipTransferred(_owner, newOwner);
319         _owner = newOwner;
320     }
321 }
322 
323 // File: contracts/Arbitrage.sol
324 
325 pragma solidity ^0.5.0;
326 
327 
328 
329 
330 
331 
332 
333 /// @title Uniswap Arbitrage - Executes arbitrage transactions between Uniswap and DutchX.
334 /// @author Billy Rennekamp - <billy@gnosis.pm>
335 contract Arbitrage is Ownable {
336 
337     uint constant max = uint(-1);
338 
339     IUniswapFactory public uniFactory;
340     IDutchExchange public dutchXProxy;
341 
342     event Profit(uint profit, bool wasDutchOpportunity);
343 
344     /// @dev Payable fallback function has nothing inside so it won't run out of gas with gas limited transfers
345     function() external payable {}
346 
347     /// @dev Only owner can deposit contract Ether into the DutchX as WETH
348     function depositEther() public payable onlyOwner {
349 
350         require(address(this).balance > 0, "Balance must be greater than 0 to deposit");
351         uint balance = address(this).balance;
352 
353         // // Deposit balance to WETH
354         address weth = dutchXProxy.ethToken();
355         ITokenMinimal(weth).deposit.value(balance)();
356 
357         uint wethBalance = ITokenMinimal(weth).balanceOf(address(this));
358         uint allowance = ITokenMinimal(weth).allowance(address(this), address(dutchXProxy));
359 
360         if (allowance < wethBalance) {
361             if (allowance != 0) {
362                 SafeERC20.safeApprove(weth, address(dutchXProxy), 0);
363             }
364             // Approve max amount of WETH to be transferred by dutchX
365             // Keeping it max will have same or similar costs to making it exact over and over again
366             SafeERC20.safeApprove(weth, address(dutchXProxy), max);
367         }
368 
369         // Deposit new amount on dutchX, confirm there's at least the amount we just deposited
370         uint newBalance = dutchXProxy.deposit(weth, balance);
371         require(newBalance >= balance, "Deposit WETH to DutchX didn't work.");
372     }
373 
374     /// @dev Only owner can withdraw WETH from DutchX, convert to Ether and transfer to owner
375     /// @param amount The amount of Ether to withdraw
376     function withdrawEtherThenTransfer(uint amount) external onlyOwner {
377         _withdrawEther(amount);
378         address(uint160(owner())).transfer(amount);
379     }
380 
381     /// @dev Only owner can transfer any Ether currently in the contract to the owner address.
382     /// @param amount The amount of Ether to withdraw
383     function transferEther(uint amount) external onlyOwner {
384         // If amount is zero, deposit the entire contract balance.
385         address(uint160(owner())).transfer(amount == 0 ? address(this).balance : amount);
386     }
387 
388     /// @dev Only owner function to withdraw WETH from the DutchX, convert it to Ether and keep it in contract
389     /// @param amount The amount of WETH to withdraw and convert.
390     function withdrawEther(uint amount) external onlyOwner {
391         _withdrawEther(amount);
392     }
393 
394     /// @dev Internal function to withdraw WETH from the DutchX, convert it to Ether and keep it in contract
395     /// @param amount The amount of WETH to withdraw and convert.
396     function _withdrawEther(uint amount) internal {
397         address weth = dutchXProxy.ethToken();
398         dutchXProxy.withdraw(weth, amount);
399         ITokenMinimal(weth).withdraw(amount);
400     }
401 
402     /// @dev Only owner can withdraw a token from the DutchX
403     /// @param token The token address that is being withdrawn.
404     /// @param amount The amount of token to withdraw. Can be larger than available balance and maximum will be withdrawn.
405     /// @return Returns the amount actually withdrawn from the DutchX
406     function withdrawToken(address token, uint amount) external onlyOwner returns (uint) {
407         return dutchXProxy.withdraw(token, amount);
408     }
409 
410     /// @dev Only owner can transfer tokens to the owner that belong to this contract
411     /// @param token The token address that is being transferred.
412     /// @param amount The amount of token to transfer.
413     function transferToken(address token, uint amount) external onlyOwner {
414         SafeERC20.safeTransfer(token, owner(), amount);
415     }
416 
417     /// @dev Only owner can approve tokens to be used by the DutchX
418     /// @param token The token address to be approved for use
419     /// @param spender The address that should be approved
420     /// @param allowance The amount of tokens that should be approved
421     function approveToken(address token, address spender, uint allowance) external onlyOwner {
422         SafeERC20.safeApprove(token, spender, allowance);
423     }
424 
425     /// @dev Only owner can deposit token to the DutchX
426     /// @param token The token address that is being deposited.
427     /// @param amount The amount of token to deposit.
428     function depositToken(address token, uint amount) external onlyOwner {
429         _depositToken(token, amount);
430     }
431 
432     /// @dev Internal function to deposit token to the DutchX
433     /// @param token The token address that is being deposited.
434     /// @param amount The amount of token to deposit.
435     function _depositToken(address token, uint amount) internal returns(uint deposited) {
436         uint balance = ITokenMinimal(token).balanceOf(address(this));
437         uint min = balance < amount ? balance : amount;
438         require(min > 0, "Balance of token insufficient");
439 
440         uint allowance = ITokenMinimal(token).allowance(address(this), address(dutchXProxy));
441         if (allowance < min) {
442             if (allowance != 0) {
443                 SafeERC20.safeApprove(token, address(dutchXProxy), 0);
444             }
445             SafeERC20.safeApprove(token, address(dutchXProxy), max);
446         }
447 
448         // Confirm that the balance of the token on the DutchX is at least how much was deposited
449         uint newBalance = dutchXProxy.deposit(token, min);
450         require(newBalance >= min, "deposit didn't work");
451         return min;
452     }
453 
454     /// @dev Executes a trade opportunity on dutchX. Assumes that there is a balance of WETH already on the dutchX
455     /// @param arbToken Address of the token that should be arbitraged.
456     /// @param amount Amount of Ether to use in arbitrage.
457     /// @return Returns if transaction can be executed.
458     function dutchOpportunity(address arbToken, uint256 amount) external onlyOwner {
459 
460         address etherToken = dutchXProxy.ethToken();
461 
462         // The order of parameters for getAuctionIndex don't matter
463         uint256 dutchAuctionIndex = dutchXProxy.getAuctionIndex(arbToken, etherToken);
464 
465         // postBuyOrder(sellToken, buyToken, amount)
466         // results in a decrease of the amount the user owns of the second token
467         // which means the buyToken is what the buyer wants to get rid of.
468         // "The buy token is what the buyer provides, the seller token is what the seller provides."
469         dutchXProxy.postBuyOrder(arbToken, etherToken, dutchAuctionIndex, amount);
470 
471         (uint tokensBought, ) = dutchXProxy.claimBuyerFunds(arbToken, etherToken, address(this), dutchAuctionIndex);
472         dutchXProxy.withdraw(arbToken, tokensBought);
473 
474         address uniswapExchange = uniFactory.getExchange(arbToken);
475 
476         uint allowance = ITokenMinimal(arbToken).allowance(address(this), address(uniswapExchange));
477         if (allowance < tokensBought) {
478             if (allowance != 0) {
479                 SafeERC20.safeApprove(arbToken, address(uniswapExchange), 0);
480             }
481             // Approve Uniswap to transfer arbToken on contract's behalf
482             // Keeping it max will have same or similar costs to making it exact over and over again
483             SafeERC20.safeApprove(arbToken, address(uniswapExchange), max);
484         }
485 
486         // tokenToEthSwapInput(inputToken, minimumReturn, timeToLive)
487         // minimumReturn is enough to make a profit (excluding gas)
488         // timeToLive is now because transaction is atomic
489         uint256 etherReturned = IUniswapExchange(uniswapExchange).tokenToEthSwapInput(tokensBought, 1, block.timestamp);
490 
491         // gas costs were excluded because worse case scenario the tx fails and gas costs were spent up to here anyway
492         // best worst case scenario the profit from the trade alleviates part of the gas costs even if still no total profit
493         require(etherReturned >= amount, "no profit");
494         emit Profit(etherReturned, true);
495 
496         // Ether is deposited as WETH
497         depositEther();
498     }
499 
500     /// @dev Executes a trade opportunity on uniswap.
501     /// @param arbToken Address of the token that should be arbitraged.
502     /// @param amount Amount of Ether to use in arbitrage.
503     /// @return Returns if transaction can be executed.
504     function uniswapOpportunity(address arbToken, uint256 amount) external onlyOwner {
505 
506         // WETH must be converted to Eth for Uniswap trade
507         // (Uniswap allows ERC20:ERC20 but most liquidity is on ETH:ERC20 markets)
508         _withdrawEther(amount);
509         require(address(this).balance >= amount, "buying from uniswap takes real Ether");
510 
511         // ethToTokenSwapInput(minTokens, deadline)
512         // minTokens is 1 because it will revert without a profit regardless
513         // deadline is now since trade is atomic
514         // solium-disable-next-line security/no-block-members
515         uint256 tokensBought = IUniswapExchange(uniFactory.getExchange(arbToken)).ethToTokenSwapInput.value(amount)(1, block.timestamp);
516 
517         // tokens need to be approved for the dutchX before they are deposited
518         tokensBought = _depositToken(arbToken, tokensBought);
519 
520         address etherToken = dutchXProxy.ethToken();
521 
522         // The order of parameters for getAuctionIndex don't matter
523         uint256 dutchAuctionIndex = dutchXProxy.getAuctionIndex(arbToken, etherToken);
524 
525         // spend max amount of tokens currently on the dutch x (might be combined from previous remainders)
526         // max is automatically reduced to maximum available tokens because there may be
527         // token remainders from previous auctions which closed after previous arbitrage opportunities
528         dutchXProxy.postBuyOrder(etherToken, arbToken, dutchAuctionIndex, max);
529         // solium-disable-next-line no-unused-vars
530         (uint etherReturned, ) = dutchXProxy.claimBuyerFunds(etherToken, arbToken, address(this), dutchAuctionIndex);
531 
532         // gas costs were excluded because worse case scenario the tx fails and gas costs were spent up to here anyway
533         // best worst case scenario the profit from the trade alleviates part of the gas costs even if still no total profit
534         require(etherReturned >= amount, "no profit");
535         emit Profit(etherReturned, false);
536         // Ether returned is already in dutchX balance where Ether is assumed to be stored when not being used.
537     }
538 
539 }
540 
541 // File: contracts/ArbitrageMainnet.sol
542 
543 pragma solidity ^0.5.0;
544 
545 /// @title Uniswap Arbitrage Module - Executes arbitrage transactions between Uniswap and DutchX.
546 /// @author Billy Rennekamp - <billy@gnosis.pm>
547 contract ArbitrageMainnet is Arbitrage {
548     constructor() public {
549         uniFactory = IUniswapFactory(0xc0a47dFe034B400B47bDaD5FecDa2621de6c4d95);
550         dutchXProxy = IDutchExchange(0xb9812E2fA995EC53B5b6DF34d21f9304762C5497);
551     }
552 }