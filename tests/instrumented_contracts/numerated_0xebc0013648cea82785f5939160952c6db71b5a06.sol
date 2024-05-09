1 // Sources flattened with hardhat v2.11.1 https://hardhat.org
2 
3 // File @openzeppelin/contracts/utils/Context.sol@v4.7.3
4 
5 // SPDX-License-Identifier: MIT
6 // OpenZeppelin Contracts v4.4.1 (utils/Context.sol)
7 
8 pragma solidity ^0.8.0;
9 
10 /**
11  * @dev Provides information about the current execution context, including the
12  * sender of the transaction and its data. While these are generally available
13  * via msg.sender and msg.data, they should not be accessed in such a direct
14  * manner, since when dealing with meta-transactions the account sending and
15  * paying for execution may not be the actual sender (as far as an application
16  * is concerned).
17  *
18  * This contract is only required for intermediate, library-like contracts.
19  */
20 abstract contract Context {
21     function _msgSender() internal view virtual returns (address) {
22         return msg.sender;
23     }
24 
25     function _msgData() internal view virtual returns (bytes calldata) {
26         return msg.data;
27     }
28 }
29 
30 
31 // File @openzeppelin/contracts/access/Ownable.sol@v4.7.3
32 
33 
34 // OpenZeppelin Contracts (last updated v4.7.0) (access/Ownable.sol)
35 
36 pragma solidity ^0.8.0;
37 
38 /**
39  * @dev Contract module which provides a basic access control mechanism, where
40  * there is an account (an owner) that can be granted exclusive access to
41  * specific functions.
42  *
43  * By default, the owner account will be the one that deploys the contract. This
44  * can later be changed with {transferOwnership}.
45  *
46  * This module is used through inheritance. It will make available the modifier
47  * `onlyOwner`, which can be applied to your functions to restrict their use to
48  * the owner.
49  */
50 abstract contract Ownable is Context {
51     address private _owner;
52 
53     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
54 
55     /**
56      * @dev Initializes the contract setting the deployer as the initial owner.
57      */
58     constructor() {
59         _transferOwnership(_msgSender());
60     }
61 
62     /**
63      * @dev Throws if called by any account other than the owner.
64      */
65     modifier onlyOwner() {
66         _checkOwner();
67         _;
68     }
69 
70     /**
71      * @dev Returns the address of the current owner.
72      */
73     function owner() public view virtual returns (address) {
74         return _owner;
75     }
76 
77     /**
78      * @dev Throws if the sender is not the owner.
79      */
80     function _checkOwner() internal view virtual {
81         require(owner() == _msgSender(), "Ownable: caller is not the owner");
82     }
83 
84     /**
85      * @dev Leaves the contract without owner. It will not be possible to call
86      * `onlyOwner` functions anymore. Can only be called by the current owner.
87      *
88      * NOTE: Renouncing ownership will leave the contract without an owner,
89      * thereby removing any functionality that is only available to the owner.
90      */
91     function renounceOwnership() public virtual onlyOwner {
92         _transferOwnership(address(0));
93     }
94 
95     /**
96      * @dev Transfers ownership of the contract to a new account (`newOwner`).
97      * Can only be called by the current owner.
98      */
99     function transferOwnership(address newOwner) public virtual onlyOwner {
100         require(newOwner != address(0), "Ownable: new owner is the zero address");
101         _transferOwnership(newOwner);
102     }
103 
104     /**
105      * @dev Transfers ownership of the contract to a new account (`newOwner`).
106      * Internal function without access restriction.
107      */
108     function _transferOwnership(address newOwner) internal virtual {
109         address oldOwner = _owner;
110         _owner = newOwner;
111         emit OwnershipTransferred(oldOwner, newOwner);
112     }
113 }
114 
115 
116 // File @openzeppelin/contracts/utils/Counters.sol@v4.7.3
117 
118 
119 // OpenZeppelin Contracts v4.4.1 (utils/Counters.sol)
120 
121 pragma solidity ^0.8.0;
122 
123 /**
124  * @title Counters
125  * @author Matt Condon (@shrugs)
126  * @dev Provides counters that can only be incremented, decremented or reset. This can be used e.g. to track the number
127  * of elements in a mapping, issuing ERC721 ids, or counting request ids.
128  *
129  * Include with `using Counters for Counters.Counter;`
130  */
131 library Counters {
132     struct Counter {
133         // This variable should never be directly accessed by users of the library: interactions must be restricted to
134         // the library's function. As of Solidity v0.5.2, this cannot be enforced, though there is a proposal to add
135         // this feature: see https://github.com/ethereum/solidity/issues/4637
136         uint256 _value; // default: 0
137     }
138 
139     function current(Counter storage counter) internal view returns (uint256) {
140         return counter._value;
141     }
142 
143     function increment(Counter storage counter) internal {
144         unchecked {
145             counter._value += 1;
146         }
147     }
148 
149     function decrement(Counter storage counter) internal {
150         uint256 value = counter._value;
151         require(value > 0, "Counter: decrement overflow");
152         unchecked {
153             counter._value = value - 1;
154         }
155     }
156 
157     function reset(Counter storage counter) internal {
158         counter._value = 0;
159     }
160 }
161 
162 
163 // File @openzeppelin/contracts/token/ERC20/IERC20.sol@v4.7.3
164 
165 
166 // OpenZeppelin Contracts (last updated v4.6.0) (token/ERC20/IERC20.sol)
167 
168 pragma solidity ^0.8.0;
169 
170 /**
171  * @dev Interface of the ERC20 standard as defined in the EIP.
172  */
173 interface IERC20 {
174     /**
175      * @dev Emitted when `value` tokens are moved from one account (`from`) to
176      * another (`to`).
177      *
178      * Note that `value` may be zero.
179      */
180     event Transfer(address indexed from, address indexed to, uint256 value);
181 
182     /**
183      * @dev Emitted when the allowance of a `spender` for an `owner` is set by
184      * a call to {approve}. `value` is the new allowance.
185      */
186     event Approval(address indexed owner, address indexed spender, uint256 value);
187 
188     /**
189      * @dev Returns the amount of tokens in existence.
190      */
191     function totalSupply() external view returns (uint256);
192 
193     /**
194      * @dev Returns the amount of tokens owned by `account`.
195      */
196     function balanceOf(address account) external view returns (uint256);
197 
198     /**
199      * @dev Moves `amount` tokens from the caller's account to `to`.
200      *
201      * Returns a boolean value indicating whether the operation succeeded.
202      *
203      * Emits a {Transfer} event.
204      */
205     function transfer(address to, uint256 amount) external returns (bool);
206 
207     /**
208      * @dev Returns the remaining number of tokens that `spender` will be
209      * allowed to spend on behalf of `owner` through {transferFrom}. This is
210      * zero by default.
211      *
212      * This value changes when {approve} or {transferFrom} are called.
213      */
214     function allowance(address owner, address spender) external view returns (uint256);
215 
216     /**
217      * @dev Sets `amount` as the allowance of `spender` over the caller's tokens.
218      *
219      * Returns a boolean value indicating whether the operation succeeded.
220      *
221      * IMPORTANT: Beware that changing an allowance with this method brings the risk
222      * that someone may use both the old and the new allowance by unfortunate
223      * transaction ordering. One possible solution to mitigate this race
224      * condition is to first reduce the spender's allowance to 0 and set the
225      * desired value afterwards:
226      * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
227      *
228      * Emits an {Approval} event.
229      */
230     function approve(address spender, uint256 amount) external returns (bool);
231 
232     /**
233      * @dev Moves `amount` tokens from `from` to `to` using the
234      * allowance mechanism. `amount` is then deducted from the caller's
235      * allowance.
236      *
237      * Returns a boolean value indicating whether the operation succeeded.
238      *
239      * Emits a {Transfer} event.
240      */
241     function transferFrom(
242         address from,
243         address to,
244         uint256 amount
245     ) external returns (bool);
246 }
247 
248 
249 // File @openzeppelin/contracts/security/ReentrancyGuard.sol@v4.7.3
250 
251 
252 // OpenZeppelin Contracts v4.4.1 (security/ReentrancyGuard.sol)
253 
254 pragma solidity ^0.8.0;
255 
256 /**
257  * @dev Contract module that helps prevent reentrant calls to a function.
258  *
259  * Inheriting from `ReentrancyGuard` will make the {nonReentrant} modifier
260  * available, which can be applied to functions to make sure there are no nested
261  * (reentrant) calls to them.
262  *
263  * Note that because there is a single `nonReentrant` guard, functions marked as
264  * `nonReentrant` may not call one another. This can be worked around by making
265  * those functions `private`, and then adding `external` `nonReentrant` entry
266  * points to them.
267  *
268  * TIP: If you would like to learn more about reentrancy and alternative ways
269  * to protect against it, check out our blog post
270  * https://blog.openzeppelin.com/reentrancy-after-istanbul/[Reentrancy After Istanbul].
271  */
272 abstract contract ReentrancyGuard {
273     // Booleans are more expensive than uint256 or any type that takes up a full
274     // word because each write operation emits an extra SLOAD to first read the
275     // slot's contents, replace the bits taken up by the boolean, and then write
276     // back. This is the compiler's defense against contract upgrades and
277     // pointer aliasing, and it cannot be disabled.
278 
279     // The values being non-zero value makes deployment a bit more expensive,
280     // but in exchange the refund on every call to nonReentrant will be lower in
281     // amount. Since refunds are capped to a percentage of the total
282     // transaction's gas, it is best to keep them low in cases like this one, to
283     // increase the likelihood of the full refund coming into effect.
284     uint256 private constant _NOT_ENTERED = 1;
285     uint256 private constant _ENTERED = 2;
286 
287     uint256 private _status;
288 
289     constructor() {
290         _status = _NOT_ENTERED;
291     }
292 
293     /**
294      * @dev Prevents a contract from calling itself, directly or indirectly.
295      * Calling a `nonReentrant` function from another `nonReentrant`
296      * function is not supported. It is possible to prevent this from happening
297      * by making the `nonReentrant` function external, and making it call a
298      * `private` function that does the actual work.
299      */
300     modifier nonReentrant() {
301         // On the first call to nonReentrant, _notEntered will be true
302         require(_status != _ENTERED, "ReentrancyGuard: reentrant call");
303 
304         // Any calls to nonReentrant after this point will fail
305         _status = _ENTERED;
306 
307         _;
308 
309         // By storing the original value once again, a refund is triggered (see
310         // https://eips.ethereum.org/EIPS/eip-2200)
311         _status = _NOT_ENTERED;
312     }
313 }
314 
315 
316 // File @chainlink/contracts/src/v0.8/interfaces/AggregatorV3Interface.sol@v0.5.1
317 
318 
319 pragma solidity ^0.8.0;
320 
321 interface AggregatorV3Interface {
322   function decimals() external view returns (uint8);
323 
324   function description() external view returns (string memory);
325 
326   function version() external view returns (uint256);
327 
328   function getRoundData(uint80 _roundId)
329     external
330     view
331     returns (
332       uint80 roundId,
333       int256 answer,
334       uint256 startedAt,
335       uint256 updatedAt,
336       uint80 answeredInRound
337     );
338 
339   function latestRoundData()
340     external
341     view
342     returns (
343       uint80 roundId,
344       int256 answer,
345       uint256 startedAt,
346       uint256 updatedAt,
347       uint80 answeredInRound
348     );
349 }
350 
351 
352 // File contracts/SafuuXSacrificeETHonly.sol
353 
354 
355 pragma solidity 0.8.17;
356 
357 
358 
359 
360 
361 contract SafuuXSacrificeETHonly is Ownable, ReentrancyGuard {
362     using Counters for Counters.Counter;
363     Counters.Counter public nextSacrificeId;
364 
365     address payable public safuuWallet;
366     address payable public serviceWallet;
367     bool public isSacrificeActive;
368     uint256 public totalSacrifice;
369 
370     struct sacrifice {
371         uint256 id;
372         string tokenSymbol;
373         address accountAddress;
374         uint256 tokenAmount;
375         uint256 tokenPriceUSD;
376         uint256 timestamp;
377         string status;
378     }
379 
380     mapping(uint256 => sacrifice) public Sacrifice;
381     mapping(string => uint256) public totalSacrificeAmount;
382     mapping(address => uint256) public ETHDeposit;
383     mapping(address => mapping(string => uint256[])) private AccountDeposits;
384 
385     mapping(string => address) public AllowedTokens;
386     mapping(string => uint256) public TokenDecimals;
387     mapping(string => address) public ChainlinkContracts;
388     mapping(uint256 => string) public SacrificeStatus;
389 
390     event ETHDeposited(
391         string indexed symbol,
392         address indexed accountAddress,
393         uint256 amount
394     );
395 
396     constructor(address payable _safuuWallet, address payable _serviceWallet) {
397         safuuWallet = _safuuWallet;
398         serviceWallet = _serviceWallet;
399         _init();
400     }
401 
402 
403     function depositETH() external payable nonReentrant returns (uint256){
404         require(isSacrificeActive == true, "depositETH: Sacrifice not active");
405         require(msg.value > 0, "depositETH: Amount must be greater than ZERO");
406 
407         nextSacrificeId.increment();
408         uint256 priceFeed = getChainLinkPrice(ChainlinkContracts["ETH"]);
409         ETHDeposit[msg.sender] += msg.value;
410         AccountDeposits[msg.sender]["ETH"].push(nextSacrificeId.current());
411 
412         uint256 tokenPriceUSD = priceFeed / 1e4;
413         totalSacrifice += tokenPriceUSD * (msg.value / 1e14);
414         totalSacrificeAmount["ETH"] += (msg.value / 1e14);
415 
416         _createNewSacrifice(
417             "ETH",
418             msg.sender,
419             msg.value,
420             priceFeed,
421             block.timestamp,
422             SacrificeStatus[2]
423         );
424 
425         uint256 safuuSplit = (msg.value * 998) / 1000;
426         uint256 serviceSplit = (msg.value * 2) / 1000;
427         safuuWallet.transfer(safuuSplit);
428         serviceWallet.transfer(serviceSplit);
429 
430         emit ETHDeposited("ETH", msg.sender, msg.value);
431 
432         return nextSacrificeId.current();
433     }
434 
435     function _createNewSacrifice(
436         string memory _symbol,
437         address _account,
438         uint256 _amount,
439         uint256 _priceUSD,
440         uint256 _timestamp,
441         string memory _status
442     ) internal {
443         sacrifice storage newSacrifice = Sacrifice[nextSacrificeId.current()];
444         newSacrifice.id = nextSacrificeId.current();
445         newSacrifice.tokenSymbol = _symbol;
446         newSacrifice.accountAddress = _account;
447         newSacrifice.tokenAmount = _amount;
448         newSacrifice.tokenPriceUSD = _priceUSD;
449         newSacrifice.timestamp = _timestamp;
450         newSacrifice.status = _status;
451     }
452 
453     function updateSacrificeData(
454         uint256 sacrificeId,
455         uint256 _status,
456         address _account,
457         uint256 _amount,
458         uint256 _priceUSD,
459         uint256 _timestamp
460     ) external onlyOwner {
461         sacrifice storage updateSacrifice = Sacrifice[sacrificeId];
462         updateSacrifice.accountAddress = _account;
463         updateSacrifice.tokenAmount = _amount;
464         updateSacrifice.tokenPriceUSD = _priceUSD;
465         updateSacrifice.timestamp = _timestamp;
466         updateSacrifice.status = SacrificeStatus[_status];
467     }
468 
469     function setAllowedTokens(string memory _symbol, address _tokenAddress)
470         public
471         onlyOwner
472     {
473         AllowedTokens[_symbol] = _tokenAddress;
474     }
475 
476     function setTokenDecimals(string memory _symbol, uint256 _decimals)
477         public
478         onlyOwner
479     {
480         TokenDecimals[_symbol] = _decimals;
481     }
482 
483     function setChainlink(string memory _symbol, address _tokenAddress)
484         public
485         onlyOwner
486     {
487         ChainlinkContracts[_symbol] = _tokenAddress;
488     }
489 
490     function setSacrificeStatus(bool _isActive) external onlyOwner {
491         isSacrificeActive = _isActive;
492     }
493 
494     function setSafuuWallet(address payable _safuuWallet) external onlyOwner {//nachomod
495         safuuWallet = _safuuWallet;
496     }
497 
498     function setServiceWallet(address payable _serviceWallet) external onlyOwner {//nachomod
499         serviceWallet = _serviceWallet;
500     }
501 
502     function setTotalSacrifice(uint256 _totalSacrificeUSD) external onlyOwner {
503         totalSacrifice = _totalSacrificeUSD;
504     }
505 
506     function recoverETH() external onlyOwner {
507         require(payable(msg.sender).send(address(this).balance));
508     }
509 
510     function recoverERC20(IERC20 tokenContract, address to) external onlyOwner {
511         tokenContract.transfer(to, tokenContract.balanceOf(address(this)));
512     }
513 
514     function getCurrentSacrificeID() external view returns (uint256) {
515         return nextSacrificeId.current();
516     }
517 
518     function getAccountDeposits(address _account, string memory _symbol)
519         public
520         view
521         returns (uint256[] memory)
522     {
523         return AccountDeposits[_account][_symbol];
524     }
525 
526     function getChainLinkPrice(address contractAddress)
527         public
528         view
529         returns (uint256)
530     {
531         AggregatorV3Interface priceFeed = AggregatorV3Interface(
532             contractAddress
533         );
534         (
535             ,
536             int256 price,
537             ,
538             ,
539 
540         ) = priceFeed.latestRoundData();
541         return uint256(price);
542     }
543 
544     function getPriceBySymbol(string memory _symbol)
545         public
546         view
547         returns (uint256)
548     {
549         require(
550             ChainlinkContracts[_symbol] != address(0),
551             "getChainLinkPrice: Address not part of Chainlink token list"
552         );
553 
554         return getChainLinkPrice(ChainlinkContracts[_symbol]);
555     }
556 
557     function _init() internal {
558         isSacrificeActive = false;
559 
560         SacrificeStatus[1] = "pending";
561         SacrificeStatus[2] = "completed";
562         SacrificeStatus[3] = "cancelled";
563 
564         // ****** Testnet Data ******
565         //setChainlink("ETH", 0xD4a33860578De61DBAbDc8BFdb98FD742fA7028e);
566 
567         // ****** Mainnet Data ******
568         setChainlink("ETH", 0x5f4eC3Df9cbd43714FE2740f5E3616155c5b8419);
569 
570         setTokenDecimals("ETH", 1e14);
571     }
572 }