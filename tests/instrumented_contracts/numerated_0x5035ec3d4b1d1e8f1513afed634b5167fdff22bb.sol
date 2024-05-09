1 // File: contracts/IUniswapExchange.sol
2 
3 pragma solidity ^0.5.0;
4 
5 // Solidity Interface
6 
7 contract IUniswapExchange {
8     // Address of ERC20 token sold on this exchange
9     function tokenAddress() external view returns (address token);
10     // Address of Uniswap Factory
11     function factoryAddress() external view returns (address factory);
12     // Provide Liquidity
13     function addLiquidity(uint256 min_liquidity, uint256 max_tokens, uint256 deadline) external payable returns (uint256);
14     function removeLiquidity(uint256 amount, uint256 min_eth, uint256 min_tokens, uint256 deadline) external returns (uint256, uint256);
15     // Get Prices
16     function getEthToTokenInputPrice(uint256 eth_sold) external view returns (uint256 tokens_bought);
17     function getEthToTokenOutputPrice(uint256 tokens_bought) external view returns (uint256 eth_sold);
18     function getTokenToEthInputPrice(uint256 tokens_sold) external view returns (uint256 eth_bought);
19     function getTokenToEthOutputPrice(uint256 eth_bought) external view returns (uint256 tokens_sold);
20     // Trade ETH to ERC20
21     function ethToTokenSwapInput(uint256 min_tokens, uint256 deadline) external payable returns (uint256  tokens_bought);
22     function ethToTokenTransferInput(uint256 min_tokens, uint256 deadline, address recipient) external payable returns (uint256  tokens_bought);
23     function ethToTokenSwapOutput(uint256 tokens_bought, uint256 deadline) external payable returns (uint256  eth_sold);
24     function ethToTokenTransferOutput(uint256 tokens_bought, uint256 deadline, address recipient) external payable returns (uint256  eth_sold);
25     // Trade ERC20 to ETH
26     function tokenToEthSwapInput(uint256 tokens_sold, uint256 min_eth, uint256 deadline) external returns (uint256  eth_bought);
27     function tokenToEthTransferInput(uint256 tokens_sold, uint256 min_tokens, uint256 deadline, address recipient) external returns (uint256  eth_bought);
28     function tokenToEthSwapOutput(uint256 eth_bought, uint256 max_tokens, uint256 deadline) external returns (uint256  tokens_sold);
29     function tokenToEthTransferOutput(uint256 eth_bought, uint256 max_tokens, uint256 deadline, address recipient) external returns (uint256  tokens_sold);
30     // Trade ERC20 to ERC20
31     function tokenToTokenSwapInput(uint256 tokens_sold, uint256 min_tokens_bought, uint256 min_eth_bought, uint256 deadline, address token_addr) external returns (uint256  tokens_bought);
32     function tokenToTokenTransferInput(uint256 tokens_sold, uint256 min_tokens_bought, uint256 min_eth_bought, uint256 deadline, address recipient, address token_addr) external returns (uint256  tokens_bought);
33     function tokenToTokenSwapOutput(uint256 tokens_bought, uint256 max_tokens_sold, uint256 max_eth_sold, uint256 deadline, address token_addr) external returns (uint256  tokens_sold);
34     function tokenToTokenTransferOutput(uint256 tokens_bought, uint256 max_tokens_sold, uint256 max_eth_sold, uint256 deadline, address recipient, address token_addr) external returns (uint256  tokens_sold);
35     // Trade ERC20 to Custom Pool
36     function tokenToExchangeSwapInput(uint256 tokens_sold, uint256 min_tokens_bought, uint256 min_eth_bought, uint256 deadline, address exchange_addr) external returns (uint256  tokens_bought);
37     function tokenToExchangeTransferInput(uint256 tokens_sold, uint256 min_tokens_bought, uint256 min_eth_bought, uint256 deadline, address recipient, address exchange_addr) external returns (uint256  tokens_bought);
38     function tokenToExchangeSwapOutput(uint256 tokens_bought, uint256 max_tokens_sold, uint256 max_eth_sold, uint256 deadline, address exchange_addr) external returns (uint256  tokens_sold);
39     function tokenToExchangeTransferOutput(uint256 tokens_bought, uint256 max_tokens_sold, uint256 max_eth_sold, uint256 deadline, address recipient, address exchange_addr) external returns (uint256  tokens_sold);
40     // ERC20 comaptibility for liquidity tokens
41     bytes32 public name;
42     bytes32 public symbol;
43     uint256 public decimals;
44     function transfer(address _to, uint256 _value) external returns (bool);
45     function transferFrom(address _from, address _to, uint256 value) external returns (bool);
46     function approve(address _spender, uint256 _value) external returns (bool);
47     function allowance(address _owner, address _spender) external view returns (uint256);
48     function balanceOf(address _owner) external view returns (uint256);
49     function totalSupply() public view returns (uint256);
50     // Never use
51     function setup(address token_addr) external;
52 }
53 
54 // File: contracts/IUniswapFactory.sol
55 
56 pragma solidity ^0.5.0;
57 
58 // Solidity Interface
59 
60 contract IUniswapFactory {
61     // Public Variables
62     address public exchangeTemplate;
63     uint256 public tokenCount;
64     // Create Exchange
65     function createExchange(address token) external returns (address exchange);
66     // Get Exchange and Token Info
67     function getExchange(address token) external view returns (address exchange);
68     function getToken(address exchange) external view returns (address token);
69     function getTokenWithId(uint256 tokenId) external view returns (address token);
70     // Never use
71     function initializeFactory(address template) external;
72 }
73 
74 // File: contracts/IDutchExchange.sol
75 
76 pragma solidity ^0.5.0;
77 
78 contract IDutchExchange {
79 
80 
81     mapping(address => mapping(address => uint)) public balances;
82 
83     // Token => Token => auctionIndex => amount
84     mapping(address => mapping(address => mapping(uint => uint))) public extraTokens;
85 
86     // Token => Token =>  auctionIndex => user => amount
87     mapping(address => mapping(address => mapping(uint => mapping(address => uint)))) public sellerBalances;
88     mapping(address => mapping(address => mapping(uint => mapping(address => uint)))) public buyerBalances;
89     mapping(address => mapping(address => mapping(uint => mapping(address => uint)))) public claimedAmounts;
90 
91     
92     function ethToken() public view returns(address);
93     function claimBuyerFunds(address, address, address, uint) public returns(uint, uint);
94     function deposit(address tokenAddress, uint amount) public returns (uint);
95     function withdraw(address tokenAddress, uint amount) public returns (uint);
96     function getAuctionIndex(address token1, address token2) public returns(uint256);
97     function postBuyOrder(address token1, address token2, uint256 auctionIndex, uint256 amount) public returns(uint256);
98     function postSellOrder(address token1, address token2, uint256 auctionIndex, uint256 tokensBought) public returns(uint256, uint256);
99     function getCurrentAuctionPrice(address token1, address token2, uint256 auctionIndex) public view returns(uint256, uint256);
100     function claimAndWithdrawTokensFromSeveralAuctionsAsBuyer(address[] calldata, address[] calldata, uint[] calldata) external view returns(uint[] memory, uint);
101 }
102 
103 // File: contracts/ITokenMinimal.sol
104 
105 pragma solidity ^0.5.0;
106 
107 contract ITokenMinimal {
108     function allowance(address tokenOwner, address spender) public view returns (uint remaining);
109     function balanceOf(address tokenOwner) public view returns (uint balance);
110     function deposit() public payable;
111     function withdraw(uint value) public;
112 }
113 
114 // File: openzeppelin-solidity/contracts/utils/Address.sol
115 
116 pragma solidity ^0.5.2;
117 
118 /**
119  * Utility library of inline functions on addresses
120  */
121 library Address {
122     /**
123      * Returns whether the target address is a contract
124      * @dev This function will return false if invoked during the constructor of a contract,
125      * as the code is not actually created until after the constructor finishes.
126      * @param account address of the account to check
127      * @return whether the target address is a contract
128      */
129     function isContract(address account) internal view returns (bool) {
130         uint256 size;
131         // XXX Currently there is no better way to check if there is a contract in an address
132         // than to check the size of the code at that address.
133         // See https://ethereum.stackexchange.com/a/14016/36603
134         // for more details about how this works.
135         // TODO Check this again before the Serenity release, because all addresses will be
136         // contracts then.
137         // solhint-disable-next-line no-inline-assembly
138         assembly { size := extcodesize(account) }
139         return size > 0;
140     }
141 }
142 
143 // File: openzeppelin-solidity/contracts/token/ERC20/IERC20.sol
144 
145 pragma solidity ^0.5.2;
146 
147 /**
148  * @title ERC20 interface
149  * @dev see https://eips.ethereum.org/EIPS/eip-20
150  */
151 interface IERC20 {
152     function transfer(address to, uint256 value) external returns (bool);
153 
154     function approve(address spender, uint256 value) external returns (bool);
155 
156     function transferFrom(address from, address to, uint256 value) external returns (bool);
157 
158     function totalSupply() external view returns (uint256);
159 
160     function balanceOf(address who) external view returns (uint256);
161 
162     function allowance(address owner, address spender) external view returns (uint256);
163 
164     event Transfer(address indexed from, address indexed to, uint256 value);
165 
166     event Approval(address indexed owner, address indexed spender, uint256 value);
167 }
168 
169 // File: contracts/SafeERC20.sol
170 
171 /*
172 
173 SafeERC20 by daostack.
174 The code is based on a fix by SECBIT Team.
175 
176 USE WITH CAUTION & NO WARRANTY
177 
178 REFERENCE & RELATED READING
179 - https://github.com/ethereum/solidity/issues/4116
180 - https://medium.com/@chris_77367/explaining-unexpected-reverts-starting-with-solidity-0-4-22-3ada6e82308c
181 - https://medium.com/coinmonks/missing-return-value-bug-at-least-130-tokens-affected-d67bf08521ca
182 - https://gist.github.com/BrendanChou/88a2eeb80947ff00bcf58ffdafeaeb61
183 
184 */
185 pragma solidity ^0.5.0;
186 
187 
188 
189 library SafeERC20 {
190     using Address for address;
191 
192     bytes4 constant private TRANSFER_SELECTOR = bytes4(keccak256(bytes("transfer(address,uint256)")));
193     bytes4 constant private TRANSFERFROM_SELECTOR = bytes4(keccak256(bytes("transferFrom(address,address,uint256)")));
194     bytes4 constant private APPROVE_SELECTOR = bytes4(keccak256(bytes("approve(address,uint256)")));
195 
196     function safeTransfer(address _erc20Addr, address _to, uint256 _value) internal {
197 
198         // Must be a contract addr first!
199         require(_erc20Addr.isContract(), "ERC20 is not a contract");
200 
201         (bool success, bytes memory returnValue) =
202         // solhint-disable-next-line avoid-low-level-calls
203         _erc20Addr.call(abi.encodeWithSelector(TRANSFER_SELECTOR, _to, _value));
204         // call return false when something wrong
205         require(success, "safeTransfer must succeed");
206         //check return value
207         require(returnValue.length == 0 || (returnValue.length == 32 && (returnValue[31] != 0)), "safeTransfer must return nothing or true");
208     }
209 
210     function safeTransferFrom(address _erc20Addr, address _from, address _to, uint256 _value) internal {
211 
212         // Must be a contract addr first!
213         require(_erc20Addr.isContract(), "ERC20 is not a contract");
214 
215         (bool success, bytes memory returnValue) =
216         // solhint-disable-next-line avoid-low-level-calls
217         _erc20Addr.call(abi.encodeWithSelector(TRANSFERFROM_SELECTOR, _from, _to, _value));
218         // call return false when something wrong
219         require(success, "safeTransferFrom must succeed");
220         //check return value
221         require(returnValue.length == 0 || (returnValue.length == 32 && (returnValue[31] != 0)), "safeTransferFrom must return nothing or true");
222     }
223 
224     function safeApprove(address _erc20Addr, address _spender, uint256 _value) internal {
225 
226         // Must be a contract addr first!
227         require(_erc20Addr.isContract(), "ERC20 is not a contract");
228         
229         // safeApprove should only be called when setting an initial allowance,
230         // or when resetting it to zero.
231         require((_value == 0) || (IERC20(_erc20Addr).allowance(address(this), _spender) == 0), "safeApprove should only be called when setting an initial allowance, or when resetting it to zero.");
232 
233         (bool success, bytes memory returnValue) =
234         // solhint-disable-next-line avoid-low-level-calls
235         _erc20Addr.call(abi.encodeWithSelector(APPROVE_SELECTOR, _spender, _value));
236         // call return false when something wrong
237         require(success, "safeApprove must succeed");
238         //check return value
239         require(returnValue.length == 0 || (returnValue.length == 32 && (returnValue[31] != 0)),  "safeApprove must return nothing or true");
240     }
241 }
242 
243 // File: openzeppelin-solidity/contracts/ownership/Ownable.sol
244 
245 pragma solidity ^0.5.2;
246 
247 /**
248  * @title Ownable
249  * @dev The Ownable contract has an owner address, and provides basic authorization control
250  * functions, this simplifies the implementation of "user permissions".
251  */
252 contract Ownable {
253     address private _owner;
254 
255     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
256 
257     /**
258      * @dev The Ownable constructor sets the original `owner` of the contract to the sender
259      * account.
260      */
261     constructor () internal {
262         _owner = msg.sender;
263         emit OwnershipTransferred(address(0), _owner);
264     }
265 
266     /**
267      * @return the address of the owner.
268      */
269     function owner() public view returns (address) {
270         return _owner;
271     }
272 
273     /**
274      * @dev Throws if called by any account other than the owner.
275      */
276     modifier onlyOwner() {
277         require(isOwner());
278         _;
279     }
280 
281     /**
282      * @return true if `msg.sender` is the owner of the contract.
283      */
284     function isOwner() public view returns (bool) {
285         return msg.sender == _owner;
286     }
287 
288     /**
289      * @dev Allows the current owner to relinquish control of the contract.
290      * It will not be possible to call the functions with the `onlyOwner`
291      * modifier anymore.
292      * @notice Renouncing ownership will leave the contract without an owner,
293      * thereby removing any functionality that is only available to the owner.
294      */
295     function renounceOwnership() public onlyOwner {
296         emit OwnershipTransferred(_owner, address(0));
297         _owner = address(0);
298     }
299 
300     /**
301      * @dev Allows the current owner to transfer control of the contract to a newOwner.
302      * @param newOwner The address to transfer ownership to.
303      */
304     function transferOwnership(address newOwner) public onlyOwner {
305         _transferOwnership(newOwner);
306     }
307 
308     /**
309      * @dev Transfers control of the contract to a newOwner.
310      * @param newOwner The address to transfer ownership to.
311      */
312     function _transferOwnership(address newOwner) internal {
313         require(newOwner != address(0));
314         emit OwnershipTransferred(_owner, newOwner);
315         _owner = newOwner;
316     }
317 }
318 
319 // File: contracts/Arbitrage.sol
320 
321 pragma solidity ^0.5.0;
322 
323 
324 
325 
326 
327 
328 
329 /// @title Uniswap Arbitrage - Executes arbitrage transactions between Uniswap and DutchX.
330 /// @author Billy Rennekamp - <billy@gnosis.pm>
331 contract Arbitrage is Ownable {
332 
333     uint constant max = uint(-1);
334 
335     IUniswapFactory public uniFactory;
336     IDutchExchange public dutchXProxy;
337 
338     event Profit(uint profit, bool wasDutchOpportunity);
339 
340     /// @dev Payable fallback function has nothing inside so it won't run out of gas with gas limited transfers
341     function() external payable {}
342 
343     /// @dev Only owner can deposit contract Ether into the DutchX as WETH
344     function depositEther() public payable onlyOwner {
345 
346         require(address(this).balance > 0, "Balance must be greater than 0 to deposit");
347         uint balance = address(this).balance;
348 
349         // // Deposit balance to WETH
350         address weth = dutchXProxy.ethToken();
351         ITokenMinimal(weth).deposit.value(balance)();
352 
353         uint wethBalance = ITokenMinimal(weth).balanceOf(address(this));
354         uint allowance = ITokenMinimal(weth).allowance(address(this), address(dutchXProxy));
355 
356         if (allowance < wethBalance) {
357             if (allowance != 0) {
358                 SafeERC20.safeApprove(weth, address(dutchXProxy), 0);
359             }
360             // Approve max amount of WETH to be transferred by dutchX
361             // Keeping it max will have same or similar costs to making it exact over and over again
362             SafeERC20.safeApprove(weth, address(dutchXProxy), max);
363         }
364 
365         // Deposit new amount on dutchX, confirm there's at least the amount we just deposited
366         uint newBalance = dutchXProxy.deposit(weth, balance);
367         require(newBalance >= balance, "Deposit WETH to DutchX didn't work.");
368     }
369 
370     /// @dev Only owner can withdraw WETH from DutchX, convert to Ether and transfer to owner
371     /// @param amount The amount of Ether to withdraw
372     function withdrawEtherThenTransfer(uint amount) external onlyOwner {
373         _withdrawEther(amount);
374         address(uint160(owner())).transfer(amount);
375     }
376 
377     /// @dev Only owner can transfer any Ether currently in the contract to the owner address.
378     /// @param amount The amount of Ether to withdraw
379     function transferEther(uint amount) external onlyOwner {
380         // If amount is zero, deposit the entire contract balance.
381         address(uint160(owner())).transfer(amount == 0 ? address(this).balance : amount);
382     }
383 
384     /// @dev Only owner function to withdraw WETH from the DutchX, convert it to Ether and keep it in contract
385     /// @param amount The amount of WETH to withdraw and convert.
386     function withdrawEther(uint amount) external onlyOwner {
387         _withdrawEther(amount);
388     }
389 
390     /// @dev Internal function to withdraw WETH from the DutchX, convert it to Ether and keep it in contract
391     /// @param amount The amount of WETH to withdraw and convert.
392     function _withdrawEther(uint amount) internal {
393         address weth = dutchXProxy.ethToken();
394         dutchXProxy.withdraw(weth, amount);
395         ITokenMinimal(weth).withdraw(amount);
396     }
397 
398     /// @dev Only owner can withdraw a token from the DutchX
399     /// @param token The token address that is being withdrawn.
400     /// @param amount The amount of token to withdraw. Can be larger than available balance and maximum will be withdrawn.
401     /// @return Returns the amount actually withdrawn from the DutchX
402     function withdrawToken(address token, uint amount) external onlyOwner returns (uint) {
403         return dutchXProxy.withdraw(token, amount);
404     }
405 
406     /// @dev Only owner can transfer tokens to the owner that belong to this contract
407     /// @param token The token address that is being transferred.
408     /// @param amount The amount of token to transfer.
409     function transferToken(address token, uint amount) external onlyOwner {
410         SafeERC20.safeTransfer(token, owner(), amount);
411     }
412 
413     /// @dev Only owner can approve tokens to be used by the DutchX
414     /// @param token The token address to be approved for use
415     /// @param spender The address that should be approved
416     /// @param allowance The amount of tokens that should be approved
417     function approveToken(address token, address spender, uint allowance) external onlyOwner {
418         SafeERC20.safeApprove(token, spender, allowance);
419     }
420 
421     /// @dev Only owner can deposit token to the DutchX
422     /// @param token The token address that is being deposited.
423     /// @param amount The amount of token to deposit.
424     function depositToken(address token, uint amount) external onlyOwner {
425         _depositToken(token, amount);
426     }
427 
428     /// @dev Internal function to deposit token to the DutchX
429     /// @param token The token address that is being deposited.
430     /// @param amount The amount of token to deposit.
431     function _depositToken(address token, uint amount) internal returns(uint deposited) {
432         uint balance = ITokenMinimal(token).balanceOf(address(this));
433         uint min = balance < amount ? balance : amount;
434         require(min > 0, "Balance of token insufficient");
435 
436         uint allowance = ITokenMinimal(token).allowance(address(this), address(dutchXProxy));
437         if (allowance < min) {
438             if (allowance != 0) {
439                 SafeERC20.safeApprove(token, address(dutchXProxy), 0);
440             }
441             SafeERC20.safeApprove(token, address(dutchXProxy), max);
442         }
443 
444         // Confirm that the balance of the token on the DutchX is at least how much was deposited
445         uint newBalance = dutchXProxy.deposit(token, min);
446         require(newBalance >= min, "deposit didn't work");
447         return min;
448     }
449 
450     /// @dev Executes a trade opportunity on dutchX. Assumes that there is a balance of WETH already on the dutchX
451     /// @param arbToken Address of the token that should be arbitraged.
452     /// @param amount Amount of Ether to use in arbitrage.
453     /// @return Returns if transaction can be executed.
454     function dutchOpportunity(address arbToken, uint256 amount) external onlyOwner {
455 
456         address etherToken = dutchXProxy.ethToken();
457 
458         // The order of parameters for getAuctionIndex don't matter
459         uint256 dutchAuctionIndex = dutchXProxy.getAuctionIndex(arbToken, etherToken);
460 
461         // postBuyOrder(sellToken, buyToken, amount)
462         // results in a decrease of the amount the user owns of the second token
463         // which means the buyToken is what the buyer wants to get rid of.
464         // "The buy token is what the buyer provides, the seller token is what the seller provides."
465         dutchXProxy.postBuyOrder(arbToken, etherToken, dutchAuctionIndex, amount);
466 
467         (uint tokensBought, ) = dutchXProxy.claimBuyerFunds(arbToken, etherToken, address(this), dutchAuctionIndex);
468         dutchXProxy.withdraw(arbToken, tokensBought);
469 
470         address uniswapExchange = uniFactory.getExchange(arbToken);
471 
472         uint allowance = ITokenMinimal(arbToken).allowance(address(this), address(uniswapExchange));
473         if (allowance < tokensBought) {
474             if (allowance != 0) {
475                 SafeERC20.safeApprove(arbToken, address(uniswapExchange), 0);
476             }
477             // Approve Uniswap to transfer arbToken on contract's behalf
478             // Keeping it max will have same or similar costs to making it exact over and over again
479             SafeERC20.safeApprove(arbToken, address(uniswapExchange), max);
480         }
481 
482         // tokenToEthSwapInput(inputToken, minimumReturn, timeToLive)
483         // minimumReturn is enough to make a profit (excluding gas)
484         // timeToLive is now because transaction is atomic
485         uint256 etherReturned = IUniswapExchange(uniswapExchange).tokenToEthSwapInput(tokensBought, 1, block.timestamp);
486 
487         // gas costs were excluded because worse case scenario the tx fails and gas costs were spent up to here anyway
488         // best worst case scenario the profit from the trade alleviates part of the gas costs even if still no total profit
489         require(etherReturned >= amount, "no profit");
490         emit Profit(etherReturned, true);
491 
492         // Ether is deposited as WETH
493         depositEther();
494     }
495 
496     /// @dev Executes a trade opportunity on uniswap.
497     /// @param arbToken Address of the token that should be arbitraged.
498     /// @param amount Amount of Ether to use in arbitrage.
499     /// @return Returns if transaction can be executed.
500     function uniswapOpportunity(address arbToken, uint256 amount) external onlyOwner {
501 
502         // WETH must be converted to Eth for Uniswap trade
503         // (Uniswap allows ERC20:ERC20 but most liquidity is on ETH:ERC20 markets)
504         _withdrawEther(amount);
505         require(address(this).balance >= amount, "buying from uniswap takes real Ether");
506 
507         // ethToTokenSwapInput(minTokens, deadline)
508         // minTokens is 1 because it will revert without a profit regardless
509         // deadline is now since trade is atomic
510         // solium-disable-next-line security/no-block-members
511         uint256 tokensBought = IUniswapExchange(uniFactory.getExchange(arbToken)).ethToTokenSwapInput.value(amount)(1, block.timestamp);
512 
513         // tokens need to be approved for the dutchX before they are deposited
514         tokensBought = _depositToken(arbToken, tokensBought);
515 
516         address etherToken = dutchXProxy.ethToken();
517 
518         // The order of parameters for getAuctionIndex don't matter
519         uint256 dutchAuctionIndex = dutchXProxy.getAuctionIndex(arbToken, etherToken);
520 
521         // spend max amount of tokens currently on the dutch x (might be combined from previous remainders)
522         // max is automatically reduced to maximum available tokens because there may be
523         // token remainders from previous auctions which closed after previous arbitrage opportunities
524         dutchXProxy.postBuyOrder(etherToken, arbToken, dutchAuctionIndex, max);
525         // solium-disable-next-line no-unused-vars
526         (uint etherReturned, ) = dutchXProxy.claimBuyerFunds(etherToken, arbToken, address(this), dutchAuctionIndex);
527 
528         // gas costs were excluded because worse case scenario the tx fails and gas costs were spent up to here anyway
529         // best worst case scenario the profit from the trade alleviates part of the gas costs even if still no total profit
530         require(etherReturned >= amount, "no profit");
531         emit Profit(etherReturned, false);
532         // Ether returned is already in dutchX balance where Ether is assumed to be stored when not being used.
533     }
534 
535 }
536 
537 // File: contracts/ArbitrageMainnet.sol
538 
539 pragma solidity ^0.5.0;
540 
541 /// @title Uniswap Arbitrage Module - Executes arbitrage transactions between Uniswap and DutchX.
542 /// @author Billy Rennekamp - <billy@gnosis.pm>
543 contract ArbitrageMainnet is Arbitrage {
544     constructor() public {
545         uniFactory = IUniswapFactory(0xc0a47dFe034B400B47bDaD5FecDa2621de6c4d95);
546         dutchXProxy = IDutchExchange(0xb9812E2fA995EC53B5b6DF34d21f9304762C5497);
547     }
548 }