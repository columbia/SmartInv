1 pragma solidity 0.4.18;
2 
3 /// @title ERC Token Standard #20 Interface (https://github.com/ethereum/EIPs/issues/20)
4 contract ERC20 {
5     uint public totalSupply;
6     function balanceOf(address _owner) constant public returns (uint balance);
7     function transfer(address _to, uint _value) public returns (bool success);
8     function transferFrom(address _from, address _to, uint _value) public returns (bool success);
9     function approve(address _spender, uint _value) public returns (bool success);
10     function allowance(address _owner, address _spender) public constant returns (uint remaining);
11     event Transfer(address indexed from, address indexed to, uint value);
12     event Approval(address indexed owner, address indexed spender, uint value);
13 }
14 
15 
16 
17 
18 /// @title Basic ERC20 token contract implementation.
19 /// @dev Based on OpenZeppelin's StandardToken.
20 contract BasicToken is ERC20 {
21     using SafeMath for uint256;
22 
23     uint256 public totalSupply;
24     mapping (address => mapping (address => uint256)) allowed;
25     mapping (address => uint256) balances;
26 
27     event Approval(address indexed owner, address indexed spender, uint256 value);
28     event Transfer(address indexed from, address indexed to, uint256 value);
29 
30     /// @dev Approve the passed address to spend the specified amount of tokens on behalf of msg.sender.
31     /// @param _spender address The address which will spend the funds.
32     /// @param _value uint256 The amount of tokens to be spent.
33     function approve(address _spender, uint256 _value) public returns (bool) {
34         // https://github.com/ethereum/EIPs/blob/master/EIPS/eip-20.md#approve (see NOTE)
35         if ((_value != 0) && (allowed[msg.sender][_spender] != 0)) {
36             revert();
37         }
38 
39         allowed[msg.sender][_spender] = _value;
40 
41         Approval(msg.sender, _spender, _value);
42 
43         return true;
44     }
45 
46     /// @dev Function to check the amount of tokens that an owner allowed to a spender.
47     /// @param _owner address The address which owns the funds.
48     /// @param _spender address The address which will spend the funds.
49     /// @return uint256 specifying the amount of tokens still available for the spender.
50     function allowance(address _owner, address _spender) constant public returns (uint256 remaining) {
51         return allowed[_owner][_spender];
52     }
53 
54 
55     /// @dev Gets the balance of the specified address.
56     /// @param _owner address The address to query the the balance of.
57     /// @return uint256 representing the amount owned by the passed address.
58     function balanceOf(address _owner) constant public returns (uint256 balance) {
59         return balances[_owner];
60     }
61 
62     /// @dev Transfer token to a specified address.
63     /// @param _to address The address to transfer to.
64     /// @param _value uint256 The amount to be transferred.
65     function transfer(address _to, uint256 _value) public returns (bool) {
66         require(_to != address(0));
67         balances[msg.sender] = balances[msg.sender].sub(_value);
68         balances[_to] = balances[_to].add(_value);
69 
70         Transfer(msg.sender, _to, _value);
71 
72         return true;
73     }
74 
75     /// @dev Transfer tokens from one address to another.
76     /// @param _from address The address which you want to send tokens from.
77     /// @param _to address The address which you want to transfer to.
78     /// @param _value uint256 the amount of tokens to be transferred.
79     function transferFrom(address _from, address _to, uint256 _value) public returns (bool) {
80         require(_to != address(0));
81         var _allowance = allowed[_from][msg.sender];
82 
83         balances[_from] = balances[_from].sub(_value);
84         balances[_to] = balances[_to].add(_value);
85 
86         allowed[_from][msg.sender] = _allowance.sub(_value);
87 
88         Transfer(_from, _to, _value);
89 
90         return true;
91     }
92 }
93 
94 
95 
96 
97 /// @title ERC Token Standard #677 Interface (https://github.com/ethereum/EIPs/issues/677)
98 contract ERC677 is ERC20 {
99     function transferAndCall(address to, uint value, bytes data) public returns (bool ok);
100 
101     event TransferAndCall(address indexed from, address indexed to, uint value, bytes data);
102 }
103 
104 /// @title Math operations with safety checks
105 library SafeMath {
106     function mul(uint256 a, uint256 b) internal pure returns (uint256) {
107         uint256 c = a * b;
108         require(a == 0 || c / a == b);
109         return c;
110     }
111 
112     function div(uint256 a, uint256 b) internal pure returns (uint256) {
113         // require(b > 0); // Solidity automatically throws when dividing by 0
114         uint256 c = a / b;
115         // require(a == b * c + a % b); // There is no case in which this doesn't hold
116         return c;
117     }
118 
119     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
120         require(b <= a);
121         return a - b;
122     }
123 
124     function add(uint256 a, uint256 b) internal pure returns (uint256) {
125         uint256 c = a + b;
126         require(c >= a);
127         return c;
128     }
129 
130     function max64(uint64 a, uint64 b) internal pure returns (uint64) {
131         return a >= b ? a : b;
132     }
133 
134     function min64(uint64 a, uint64 b) internal pure returns (uint64) {
135         return a < b ? a : b;
136     }
137 
138     function max256(uint256 a, uint256 b) internal pure returns (uint256) {
139         return a >= b ? a : b;
140     }
141 
142     function min256(uint256 a, uint256 b) internal pure returns (uint256) {
143         return a < b ? a : b;
144     }
145 
146     function toPower2(uint256 a) internal pure returns (uint256) {
147         return mul(a, a);
148     }
149 
150     function sqrt(uint256 a) internal pure returns (uint256) {
151         uint256 c = (a + 1) / 2;
152         uint256 b = a;
153         while (c < b) {
154             b = c;
155             c = (a / c + c) / 2;
156         }
157         return b;
158     }
159 }
160 
161 
162 
163 
164 
165 /// @title Standard677Token implentation, base on https://github.com/ethereum/EIPs/issues/677
166 
167 contract Standard677Token is ERC677, BasicToken {
168 
169   /// @dev ERC223 safe token transfer from one address to another
170   /// @param _to address the address which you want to transfer to.
171   /// @param _value uint256 the amount of tokens to be transferred.
172   /// @param _data bytes data that can be attached to the token transation
173   function transferAndCall(address _to, uint _value, bytes _data) public returns (bool) {
174     require(super.transfer(_to, _value)); // do a normal token transfer
175     TransferAndCall(msg.sender, _to, _value, _data);
176     //filtering if the target is a contract with bytecode inside it
177     if (isContract(_to)) return contractFallback(_to, _value, _data);
178     return true;
179   }
180 
181   /// @dev called when transaction target is a contract
182   /// @param _to address the address which you want to transfer to.
183   /// @param _value uint256 the amount of tokens to be transferred.
184   /// @param _data bytes data that can be attached to the token transation
185   function contractFallback(address _to, uint _value, bytes _data) private returns (bool) {
186     ERC223Receiver receiver = ERC223Receiver(_to);
187     require(receiver.tokenFallback(msg.sender, _value, _data));
188     return true;
189   }
190 
191   /// @dev check if the address is contract
192   /// assemble the given address bytecode. If bytecode exists then the _addr is a contract.
193   /// @param _addr address the address to check
194   function isContract(address _addr) private constant returns (bool is_contract) {
195     // retrieve the size of the code on target address, this needs assembly
196     uint length;
197     assembly { length := extcodesize(_addr) }
198     return length > 0;
199   }
200 }
201 
202 
203 /// @title Ownable
204 /// @dev The Ownable contract has an owner address, and provides basic authorization control functions,
205 /// this simplifies the implementation of "user permissions".
206 /// @dev Based on OpenZeppelin's Ownable.
207 
208 contract Ownable {
209     address public owner;
210     address public newOwnerCandidate;
211 
212     event OwnershipRequested(address indexed _by, address indexed _to);
213     event OwnershipTransferred(address indexed _from, address indexed _to);
214 
215     /// @dev Constructor sets the original `owner` of the contract to the sender account.
216     function Ownable() public {
217         owner = msg.sender;
218     }
219 
220     /// @dev Reverts if called by any account other than the owner.
221     modifier onlyOwner() {
222         require(msg.sender == owner);
223         _;
224     }
225 
226     modifier onlyOwnerCandidate() {
227         require(msg.sender == newOwnerCandidate);
228         _;
229     }
230 
231     /// @dev Proposes to transfer control of the contract to a newOwnerCandidate.
232     /// @param _newOwnerCandidate address The address to transfer ownership to.
233     function requestOwnershipTransfer(address _newOwnerCandidate) external onlyOwner {
234         require(_newOwnerCandidate != address(0));
235 
236         newOwnerCandidate = _newOwnerCandidate;
237 
238         OwnershipRequested(msg.sender, newOwnerCandidate);
239     }
240 
241     /// @dev Accept ownership transfer. This method needs to be called by the perviously proposed owner.
242     function acceptOwnership() external onlyOwnerCandidate {
243         address previousOwner = owner;
244 
245         owner = newOwnerCandidate;
246         newOwnerCandidate = address(0);
247 
248         OwnershipTransferred(previousOwner, owner);
249     }
250 }
251 
252 
253 
254 
255 /// @title Token holder contract.
256 contract TokenHolder is Ownable {
257     /// @dev Allow the owner to transfer out any accidentally sent ERC20 tokens.
258     /// @param _tokenAddress address The address of the ERC20 contract.
259     /// @param _amount uint256 The amount of tokens to be transferred.
260     function transferAnyERC20Token(address _tokenAddress, uint256 _amount) public onlyOwner returns (bool success) {
261         return ERC20(_tokenAddress).transfer(owner, _amount);
262     }
263 }
264 
265 
266 
267 
268 
269 
270 /// @title Colu Local Currency contract.
271 /// @author Rotem Lev.
272 contract ColuLocalCurrency is Ownable, Standard677Token, TokenHolder {
273     using SafeMath for uint256;
274     string public name;
275     string public symbol;
276     uint8 public decimals;
277    
278     /// @dev cotract to use when issuing a CC (Local Currency)
279     /// @param _name string name for CC token that is created.
280     /// @param _symbol string symbol for CC token that is created.
281     /// @param _decimals uint8 percison for CC token that is created.
282     /// @param _totalSupply uint256 total supply of the CC token that is created. 
283     function ColuLocalCurrency(string _name, string _symbol, uint8 _decimals, uint256 _totalSupply) public {
284         require(_totalSupply != 0);     
285         require(bytes(_name).length != 0);
286         require(bytes(_symbol).length != 0);
287 
288         totalSupply = _totalSupply;
289         name = _name;
290         symbol = _symbol;
291         decimals = _decimals;
292         balances[msg.sender] = totalSupply;
293     }
294 }
295 
296 /// @title ERC223Receiver Interface
297 /// @dev Based on the specs form: https://github.com/ethereum/EIPs/issues/223
298 contract ERC223Receiver {
299     function tokenFallback(address _sender, uint _value, bytes _data) external returns (bool ok);
300 }
301 
302 
303 
304  /// @title Standard ERC223 Token Receiver implementing tokenFallback function and tokenPayable modifier
305 
306 contract Standard223Receiver is ERC223Receiver {
307   Tkn tkn;
308 
309   struct Tkn {
310     address addr;
311     address sender; // the transaction caller
312     uint256 value;
313   }
314 
315   bool __isTokenFallback;
316 
317   modifier tokenPayable {
318     require(__isTokenFallback);
319     _;
320   }
321 
322   /// @dev Called when the receiver of transfer is contract
323   /// @param _sender address the address of tokens sender
324   /// @param _value uint256 the amount of tokens to be transferred.
325   /// @param _data bytes data that can be attached to the token transation
326   function tokenFallback(address _sender, uint _value, bytes _data) external returns (bool ok) {
327     if (!supportsToken(msg.sender)) {
328       return false;
329     }
330 
331     // Problem: This will do a sstore which is expensive gas wise. Find a way to keep it in memory.
332     // Solution: Remove the the data
333     tkn = Tkn(msg.sender, _sender, _value);
334     __isTokenFallback = true;
335     if (!address(this).delegatecall(_data)) {
336       __isTokenFallback = false;
337       return false;
338     }
339     // avoid doing an overwrite to .token, which would be more expensive
340     // makes accessing .tkn values outside tokenPayable functions unsafe
341     __isTokenFallback = false;
342 
343     return true;
344   }
345 
346   function supportsToken(address token) public constant returns (bool);
347 }
348 
349 
350 
351 
352 
353 /// @title TokenOwnable
354 /// @dev The TokenOwnable contract adds a onlyTokenOwner modifier as a tokenReceiver with ownable addaptation
355 
356 contract TokenOwnable is Standard223Receiver, Ownable {
357     /// @dev Reverts if called by any account other than the owner for token sending.
358     modifier onlyTokenOwner() {
359         require(tkn.sender == owner);
360         _;
361     }
362 }
363 
364 
365 
366 /// @title Market Maker Interface.
367 /// @author Tal Beja.
368 contract MarketMaker is ERC223Receiver {
369 
370   function getCurrentPrice() public constant returns (uint _price);
371   function change(address _fromToken, uint _amount, address _toToken) public returns (uint _returnAmount);
372   function change(address _fromToken, uint _amount, address _toToken, uint _minReturn) public returns (uint _returnAmount);
373   function change(address _toToken) public returns (uint _returnAmount);
374   function change(address _toToken, uint _minReturn) public returns (uint _returnAmount);
375   function quote(address _fromToken, uint _amount, address _toToken) public constant returns (uint _returnAmount);
376   function openForPublicTrade() public returns (bool success);
377   function isOpenForPublic() public returns (bool success);
378 
379   event Change(address indexed fromToken, uint inAmount, address indexed toToken, uint returnAmount, address indexed account);
380 }
381 
382 
383 
384 
385 
386 /// @title Ellipse Market Maker contract.
387 /// @dev market maker, using ellipse equation.
388 /// @author Tal Beja.
389 contract EllipseMarketMaker is TokenOwnable {
390 
391   // precision for price representation (as in ether or tokens).
392   uint256 public constant PRECISION = 10 ** 18;
393 
394   // The tokens pair.
395   ERC20 public token1;
396   ERC20 public token2;
397 
398   // The tokens reserves.
399   uint256 public R1;
400   uint256 public R2;
401 
402   // The tokens full suplly.
403   uint256 public S1;
404   uint256 public S2;
405 
406   // State flags.
407   bool public operational;
408   bool public openForPublic;
409 
410   // Library contract address.
411   address public mmLib;
412 
413   /// @dev Constructor calling the library contract using delegate.
414   function EllipseMarketMaker(address _mmLib, address _token1, address _token2) public {
415     require(_mmLib != address(0));
416     // Signature of the mmLib's constructor function
417     // bytes4 sig = bytes4(keccak256("constructor(address,address,address)"));
418     bytes4 sig = 0x6dd23b5b;
419 
420     // 3 arguments of size 32
421     uint256 argsSize = 3 * 32;
422     // sig + arguments size
423     uint256 dataSize = 4 + argsSize;
424 
425 
426     bytes memory m_data = new bytes(dataSize);
427 
428     assembly {
429         // Add the signature first to memory
430         mstore(add(m_data, 0x20), sig)
431         // Add the parameters
432         mstore(add(m_data, 0x24), _mmLib)
433         mstore(add(m_data, 0x44), _token1)
434         mstore(add(m_data, 0x64), _token2)
435     }
436 
437     // delegatecall to the library contract
438     require(_mmLib.delegatecall(m_data));
439   }
440 
441   /// @dev returns true iff token is supperted by this contract (for erc223/677 tokens calls)
442   /// @param token can be token1 or token2
443   function supportsToken(address token) public constant returns (bool) {
444     return (token1 == token || token2 == token);
445   }
446 
447   /// @dev gets called when no other function matches, delegate to the lib contract.
448   function() public {
449     address _mmLib = mmLib;
450     if (msg.data.length > 0) {
451       assembly {
452         calldatacopy(0xff, 0, calldatasize)
453         let retVal := delegatecall(gas, _mmLib, 0xff, calldatasize, 0, 0x20)
454         switch retVal case 0 { revert(0,0) } default { return(0, 0x20) }
455       }
456     }
457   }
458 }
459 
460 
461 
462 
463 
464 /// @title Ellipse Market Maker Interfase
465 /// @author Tal Beja
466 contract IEllipseMarketMaker is MarketMaker {
467 
468     // precision for price representation (as in ether or tokens).
469     uint256 public constant PRECISION = 10 ** 18;
470 
471     // The tokens pair.
472     ERC20 public token1;
473     ERC20 public token2;
474 
475     // The tokens reserves.
476     uint256 public R1;
477     uint256 public R2;
478 
479     // The tokens full suplly.
480     uint256 public S1;
481     uint256 public S2;
482 
483     // State flags.
484     bool public operational;
485     bool public openForPublic;
486 
487     // Library contract address.
488     address public mmLib;
489 
490     function supportsToken(address token) public constant returns (bool);
491 
492     function calcReserve(uint256 _R1, uint256 _S1, uint256 _S2) public pure returns (uint256);
493 
494     function validateReserves() public view returns (bool);
495 
496     function withdrawExcessReserves() public returns (uint256);
497 
498     function initializeAfterTransfer() public returns (bool);
499 
500     function initializeOnTransfer() public returns (bool);
501 
502     function getPrice(uint256 _R1, uint256 _R2, uint256 _S1, uint256 _S2) public constant returns (uint256);
503 }
504 
505 
506 
507 
508 
509 
510 
511 
512 
513 /// @title Colu Local Currency + Market Maker factory contract.
514 /// @author Rotem Lev.
515 contract CurrencyFactory is Standard223Receiver, TokenHolder {
516 
517   struct CurrencyStruct {
518     string name;
519     uint8 decimals;
520     uint256 totalSupply;
521     address owner;
522     address mmAddress;
523   }
524 
525 
526   // map of Market Maker owners: token address => currency struct
527   mapping (address => CurrencyStruct) public currencyMap;
528   // address of the deployed CLN contract (ERC20 Token)
529   address public clnAddress;
530   // address of the deployed elipse market maker contract
531   address public mmLibAddress;
532 
533   address[] public tokens;
534 
535   event MarketOpen(address indexed marketMaker);
536   event TokenCreated(address indexed token, address indexed owner);
537 
538   // modifier to check if called by issuer of the token
539   modifier tokenIssuerOnly(address token, address owner) {
540     require(currencyMap[token].owner == owner);
541     _;
542   }
543   // modifier to only accept transferAndCall from CLN token
544   modifier CLNOnly() {
545     require(msg.sender == clnAddress);
546     _;
547   }
548 
549   /// @dev constructor only reuires the address of the CLN token which must use the ERC20 interface
550   /// @param _mmLib address for the deployed market maker elipse contract
551   /// @param _clnAddress address for the deployed ERC20 CLN token
552   function CurrencyFactory(address _mmLib, address _clnAddress) public {
553   	require(_mmLib != address(0));
554   	require(_clnAddress != address(0));
555   	mmLibAddress = _mmLib;
556   	clnAddress = _clnAddress;
557   }
558 
559   /// @dev create the MarketMaker and the CC token put all the CC token in the Market Maker reserve
560   /// @param _name string name for CC token that is created.
561   /// @param _symbol string symbol for CC token that is created.
562   /// @param _decimals uint8 percison for CC token that is created.
563   /// @param _totalSupply uint256 total supply of the CC token that is created.
564   function createCurrency(string _name,
565                           string _symbol,
566                           uint8 _decimals,
567                           uint256 _totalSupply) public
568                           returns (address) {
569 
570   	ColuLocalCurrency subToken = new ColuLocalCurrency(_name, _symbol, _decimals, _totalSupply);
571   	EllipseMarketMaker newMarketMaker = new EllipseMarketMaker(mmLibAddress, clnAddress, subToken);
572   	//set allowance
573   	require(subToken.transfer(newMarketMaker, _totalSupply));
574   	require(IEllipseMarketMaker(newMarketMaker).initializeAfterTransfer());
575   	currencyMap[subToken] = CurrencyStruct({ name: _name, decimals: _decimals, totalSupply: _totalSupply, mmAddress: newMarketMaker, owner: msg.sender});
576     tokens.push(subToken);
577   	TokenCreated(subToken, msg.sender);
578   	return subToken;
579   }
580 
581   /// @dev normal send cln to the market maker contract, sender must approve() before calling method. can only be called by owner
582   /// @dev sending CLN will return CC from the reserve to the sender.
583   /// @param _token address address of the cc token managed by this factory.
584   /// @param _clnAmount uint256 amount of CLN to transfer into the Market Maker reserve.
585   function insertCLNtoMarketMaker(address _token,
586                                   uint256 _clnAmount) public
587                                   tokenIssuerOnly(_token, msg.sender)
588                                   returns (uint256 _subTokenAmount) {
589   	require(_clnAmount > 0);
590   	address marketMakerAddress = getMarketMakerAddressFromToken(_token);
591   	require(ERC20(clnAddress).transferFrom(msg.sender, this, _clnAmount));
592   	require(ERC20(clnAddress).approve(marketMakerAddress, _clnAmount));
593   	_subTokenAmount = IEllipseMarketMaker(marketMakerAddress).change(clnAddress, _clnAmount, _token);
594     require(ERC20(_token).transfer(msg.sender, _subTokenAmount));
595   }
596 
597   /// @dev ERC223 transferAndCall, send cln to the market maker contract can only be called by owner (see MarketMaker)
598   /// @dev sending CLN will return CC from the reserve to the sender.
599   /// @param _token address address of the cc token managed by this factory.
600   function insertCLNtoMarketMaker(address _token) public
601                                   tokenPayable
602                                   CLNOnly
603                                   tokenIssuerOnly(_token, tkn.sender)
604                                   returns (uint256 _subTokenAmount) {
605   	address marketMakerAddress = getMarketMakerAddressFromToken(_token);
606   	require(ERC20(clnAddress).approve(marketMakerAddress, tkn.value));
607   	_subTokenAmount = IEllipseMarketMaker(marketMakerAddress).change(clnAddress, tkn.value, _token);
608     require(ERC20(_token).transfer(tkn.sender, _subTokenAmount));
609   }
610 
611   /// @dev normal send cc to the market maker contract, sender must approve() before calling method. can only be called by owner
612   /// @dev sending CC will return CLN from the reserve to the sender.
613   /// @param _token address address of the cc token managed by this factory.
614   /// @param _ccAmount uint256 amount of CC to transfer into the Market Maker reserve.
615   function extractCLNfromMarketMaker(address _token,
616                                      uint256 _ccAmount) public
617                                      tokenIssuerOnly(_token, msg.sender)
618                                      returns (uint256 _clnTokenAmount) {
619   	address marketMakerAddress = getMarketMakerAddressFromToken(_token);
620   	require(ERC20(_token).transferFrom(msg.sender, this, _ccAmount));
621   	require(ERC20(_token).approve(marketMakerAddress, _ccAmount));
622   	_clnTokenAmount = IEllipseMarketMaker(marketMakerAddress).change(_token, _ccAmount, clnAddress);
623   	require(ERC20(clnAddress).transfer(msg.sender, _clnTokenAmount));
624   }
625 
626   /// @dev ERC223 transferAndCall, send CC to the market maker contract can only be called by owner (see MarketMaker)
627   /// @dev sending CC will return CLN from the reserve to the sender.
628   function extractCLNfromMarketMaker() public
629                                     tokenPayable
630                                     tokenIssuerOnly(msg.sender, tkn.sender)
631                                     returns (uint256 _clnTokenAmount) {
632   	address marketMakerAddress = getMarketMakerAddressFromToken(msg.sender);
633   	require(ERC20(msg.sender).approve(marketMakerAddress, tkn.value));
634   	_clnTokenAmount = IEllipseMarketMaker(marketMakerAddress).change(msg.sender, tkn.value, clnAddress);
635   	require(ERC20(clnAddress).transfer(tkn.sender, _clnTokenAmount));
636   }
637 
638   /// @dev opens the Market Maker to recvice transactions from all sources.
639   /// @dev Request to transfer ownership of Market Maker contract to Owner instead of factory.
640   /// @param _token address address of the cc token managed by this factory.
641   function openMarket(address _token) public
642                       tokenIssuerOnly(_token, msg.sender)
643                       returns (bool) {
644   	address marketMakerAddress = getMarketMakerAddressFromToken(_token);
645   	require(MarketMaker(marketMakerAddress).openForPublicTrade());
646   	Ownable(marketMakerAddress).requestOwnershipTransfer(msg.sender);
647   	MarketOpen(marketMakerAddress);
648   	return true;
649   }
650 
651   /// @dev implementation for standard 223 reciver.
652   /// @param _token address of the token used with transferAndCall.
653   function supportsToken(address _token) public constant returns (bool) {
654   	return (clnAddress == _token || currencyMap[_token].totalSupply > 0);
655   }
656 
657   /// @dev helper function to get the market maker address form token
658   /// @param _token address of the token used with transferAndCall.
659   function getMarketMakerAddressFromToken(address _token) public constant returns (address _marketMakerAddress) {
660   	_marketMakerAddress = currencyMap[_token].mmAddress;
661     require(_marketMakerAddress != address(0));
662   }
663 }
664 
665 
666 
667 
668 
669 
670 
671 
672 
673 /**
674  * The IssuanceFactory creates an issuance contract that accepts on one side CLN
675  * locks then up in an elipse market maker up to the supplied softcap
676  * and returns a CC token based on price that is derived form the two supplies and reserves of each
677  */
678 
679 /// @title Colu Issuance factoy with CLN for CC tokens.
680 /// @author Rotem Lev.
681 contract IssuanceFactory is CurrencyFactory {
682 	using SafeMath for uint256;
683 
684 	uint256 public PRECISION;
685 
686   struct IssuanceStruct {
687   	uint256 hardcap;
688   	uint256 reserve;
689     uint256 startTime;
690     uint256 endTime;
691     uint256 targetPrice;
692     uint256 clnRaised;
693   }
694 
695   uint256 public totalCLNcustodian;
696 
697   //map of Market Maker owners
698   mapping (address => IssuanceStruct) public issueMap;
699   // total supply of CLN
700   uint256 public CLNTotalSupply;
701 
702   event CLNRaised(address indexed token, address indexed participant, uint256 amount);
703   event CLNRefunded(address indexed token, address indexed participant, uint256 amount);
704 
705   event SaleFinalized(address indexed token, uint256 clnRaised);
706 
707   // sale has begun based on time and status
708   modifier saleOpen(address _token) {
709   	require(now >= issueMap[_token].startTime && issueMap[_token].endTime >= now);
710     require(issueMap[_token].clnRaised < issueMap[_token].hardcap);
711   	_;
712   }
713 
714   // sale is passed its endtime
715   modifier hasEnded(address _token) {
716     require(issueMap[_token].endTime < now);
717   	_;
718   }
719 
720   // sale considered successful when it raised equal to or more than the softcap
721   modifier saleWasSuccessfull(address _token) {
722   	require(issueMap[_token].clnRaised >= issueMap[_token].reserve);
723   	_;
724   }
725 
726    // sale considerd failed when it raised less than the softcap
727   modifier saleHasFailed(address _token) {
728   	require(issueMap[_token].clnRaised < issueMap[_token].reserve);
729   	_;
730   }
731 
732   // checks if the instance of market maker contract is closed for public
733   modifier marketClosed(address _token) {
734   	require(!MarketMaker(currencyMap[_token].mmAddress).isOpenForPublic());
735   	_;
736   }
737   /// @dev constructor
738   /// @param _mmLib address for the deployed elipse market maker contract
739   /// @param _clnAddress address for the deployed CLN ERC20 token
740   function IssuanceFactory(address _mmLib, address _clnAddress) public CurrencyFactory(_mmLib, _clnAddress) {
741     CLNTotalSupply = ERC20(_clnAddress).totalSupply();
742     PRECISION = IEllipseMarketMaker(_mmLib).PRECISION();
743   }
744 
745 	/// @dev createIssuance create local currency issuance sale
746 	/// @param _startTime uint256 blocktime for sale start
747 	/// @param _durationTime uint 256 duration of the sale
748 	/// @param _hardcap uint CLN hardcap for issuance
749 	/// @param _reserveAmount uint CLN reserve ammount
750 	/// @param _name string name of the token
751 	/// @param _symbol string symbol of the token
752 	/// @param _decimals uint8 ERC20 decimals of local currency
753 	/// @param _totalSupply uint total supply of the local currency
754   function createIssuance( uint256 _startTime,
755                             uint256 _durationTime,
756                             uint256 _hardcap,
757                             uint256 _reserveAmount,
758                             string _name,
759                             string _symbol,
760                             uint8 _decimals,
761                             uint256 _totalSupply) public
762                             returns (address) {
763     require(_startTime > now);
764     require(_durationTime > 0);
765 	require(_hardcap > 0);
766 
767     uint256 R2 = IEllipseMarketMaker(mmLibAddress).calcReserve(_reserveAmount, CLNTotalSupply, _totalSupply);
768     uint256 targetPrice = IEllipseMarketMaker(mmLibAddress).getPrice(_reserveAmount, R2, CLNTotalSupply, _totalSupply);
769     require(isValidIssuance(_hardcap, targetPrice, _totalSupply, R2));
770     address tokenAddress = super.createCurrency(_name,  _symbol,  _decimals,  _totalSupply);
771     addToMap(tokenAddress, _startTime, _startTime + _durationTime, _hardcap, _reserveAmount, targetPrice);
772 
773     return tokenAddress;
774   }
775 
776   /// @dev internal helper to add currency data to the issuance map
777   /// @param _token address token address for this issuance (same as CC adress)
778   /// @param _startTime uint256 blocktime for sale start
779   /// @param _endTime uint256 blocktime for sale end
780   /// @param _hardcap uint256 sale hardcap
781   /// @param _reserveAmount uint256 sale softcap
782   /// @param _targetPrice uint256 sale CC price per CLN if it were to pass the softcap
783   function addToMap(address _token,
784                     uint256 _startTime,
785                     uint256 _endTime,
786                     uint256 _hardcap,
787                     uint256 _reserveAmount,
788                     uint256 _targetPrice) private {
789   	issueMap[_token] = IssuanceStruct({ hardcap: _hardcap,
790 										reserve: _reserveAmount,
791 										startTime: _startTime,
792 										endTime: _endTime,
793 										clnRaised: 0,
794 										targetPrice: _targetPrice});
795   }
796 
797   /// @dev participate in the issuance of the local currency
798   /// @param _token address token address for this issuance (same as CC adress)
799   /// @param _clnAmount uint256 amount of CLN to try and participate
800   /// @return releaseAmount uint ammount of CC tokens released and transfered to sender
801   function participate(address _token,
802 						uint256 _clnAmount) public
803 						saleOpen(_token)
804 						returns (uint256 releaseAmount) {
805 	require(_clnAmount > 0);
806     address marketMakerAddress = getMarketMakerAddressFromToken(_token);
807 
808     // how much do we need to actually send to market maker of the incomming amount
809     // and how much of the amount can participate
810     uint256 transferToReserveAmount;
811     uint256 participationAmount;
812     (transferToReserveAmount, participationAmount) = getParticipationAmounts(_clnAmount, _token);
813     // send what we need to the market maker for reserve
814     require(ERC20(clnAddress).transferFrom(msg.sender, this, participationAmount));
815   	approveAndChange(clnAddress, _token, transferToReserveAmount, marketMakerAddress);
816     // pay back to participant with the participated amount * price
817     releaseAmount = participationAmount.mul(issueMap[_token].targetPrice).div(PRECISION);
818 
819     issueMap[_token].clnRaised = issueMap[_token].clnRaised.add(participationAmount);
820     totalCLNcustodian = totalCLNcustodian.add(participationAmount);
821     CLNRaised(_token, msg.sender, participationAmount);
822     require(ERC20(_token).transfer(msg.sender, releaseAmount));
823   }
824 
825   /// @dev Participate in the CLN based issuance (for contract)
826   /// @param _token address token address for this issuance (same as CC adress)
827   function participate(address _token)
828 						public
829 						tokenPayable
830 						saleOpen(_token)
831 						returns (uint256 releaseAmount) {
832   	require(tkn.value > 0 && msg.sender == clnAddress);
833     //check if we need to send cln to mm or save it
834     uint256 transferToReserveAmount;
835     uint256 participationAmount;
836     (transferToReserveAmount, participationAmount) = getParticipationAmounts(tkn.value, _token);
837     address marketMakerAddress = getMarketMakerAddressFromToken(_token);
838   	approveAndChange(clnAddress, _token, transferToReserveAmount, marketMakerAddress);
839     // transfer only what we need
840     releaseAmount = participationAmount.mul(issueMap[_token].targetPrice).div(PRECISION);
841     issueMap[_token].clnRaised = issueMap[_token].clnRaised.add(participationAmount);
842     totalCLNcustodian = totalCLNcustodian.add(participationAmount);
843     CLNRaised(_token, tkn.sender, participationAmount);
844     require(ERC20(_token).transfer(tkn.sender, releaseAmount));
845     // send CLN change to the participent since its transferAndCall
846     if (tkn.value > participationAmount)
847        require(ERC20(clnAddress).transfer(tkn.sender, tkn.value.sub(participationAmount)));
848   }
849 
850   /// @dev called by the creator to finish the sale, open the market maker and get his tokens
851   /// @dev can only be called after the sale end time and if the sale passed the softcap
852   /// @param _token address token address for this issuance (same as CC adress)
853   function finalize(address _token) public
854   							tokenIssuerOnly(_token, msg.sender)
855   							hasEnded(_token)
856 							saleWasSuccessfull(_token)
857   							marketClosed(_token)
858   							returns (bool) {
859     // move all CC and CLN that were raised and not in the reserves to the issuer
860     address marketMakerAddress = getMarketMakerAddressFromToken(_token);
861     uint256 clnAmount = issueMap[_token].clnRaised.sub(issueMap[_token].reserve);
862     totalCLNcustodian = totalCLNcustodian.sub(clnAmount);
863     uint256 ccAmount = ERC20(_token).balanceOf(this);
864     // open Market Maker for public trade.
865     require(MarketMaker(marketMakerAddress).openForPublicTrade());
866 
867     require(ERC20(_token).transfer(msg.sender, ccAmount));
868     require(ERC20(clnAddress).transfer(msg.sender, clnAmount));
869     SaleFinalized(_token, issueMap[_token].clnRaised);
870     return true;
871 }
872 
873   /// @dev Give back CC and get a refund back in CLN,
874   /// dev can only be called after sale ended and the softcap not reached
875   /// @param _token address token address for this issuance (same as CC adress)
876   /// @param _ccAmount uint256 amount of CC to try and refund
877   function refund(address _token,
878                   uint256 _ccAmount) public
879   							hasEnded(_token)
880   							saleHasFailed(_token)
881   							marketClosed(_token)
882   							returns (bool) {
883 	require(_ccAmount > 0);
884 	// exchange CC for CLN throuh Market Maker
885   	address marketMakerAddress = getMarketMakerAddressFromToken(_token);
886   	require(ERC20(_token).transferFrom(msg.sender, this, _ccAmount));
887   	uint256 factoryCCAmount = ERC20(_token).balanceOf(this);
888   	require(ERC20(_token).approve(marketMakerAddress, factoryCCAmount));
889   	require(MarketMaker(marketMakerAddress).change(_token, factoryCCAmount, clnAddress) > 0);
890 
891   	uint256 returnAmount = _ccAmount.mul(PRECISION).div(issueMap[_token].targetPrice);
892     issueMap[_token].clnRaised = issueMap[_token].clnRaised.sub(returnAmount);
893     totalCLNcustodian = totalCLNcustodian.sub(returnAmount);
894     CLNRefunded(_token, msg.sender, returnAmount);
895   	require(ERC20(clnAddress).transfer(msg.sender, returnAmount));
896     return true;
897   }
898 
899 
900   /// @dev Give back CC and get a refund back in CLN,
901   /// dev can only be called after sale ended and the softcap not
902   function refund() public
903 	                tokenPayable
904 					hasEnded(msg.sender)
905 					saleHasFailed(msg.sender)
906 					marketClosed(msg.sender)
907 					returns (bool) {
908 	require(tkn.value > 0);
909   	// if we have CC time to thorw it to the Market Maker
910   	address marketMakerAddress = getMarketMakerAddressFromToken(msg.sender);
911   	uint256 factoryCCAmount = ERC20(msg.sender).balanceOf(this);
912   	require(ERC20(msg.sender).approve(marketMakerAddress, factoryCCAmount));
913   	require(MarketMaker(marketMakerAddress).change(msg.sender, factoryCCAmount, clnAddress) > 0);
914 
915   	uint256 returnAmount = tkn.value.mul(PRECISION).div(issueMap[msg.sender].targetPrice);
916     issueMap[msg.sender].clnRaised = issueMap[msg.sender].clnRaised.sub(returnAmount);
917     totalCLNcustodian = totalCLNcustodian.sub(returnAmount);
918     CLNRefunded(msg.sender, tkn.sender, returnAmount);
919   	require(ERC20(clnAddress).transfer(tkn.sender, returnAmount));
920     return true;
921 
922   }
923 
924   /// @dev normal send cln to the market maker contract, sender must approve() before calling method. can only be called by owner
925   /// @dev sending CLN will return CC from the reserve to the sender.
926   function insertCLNtoMarketMaker(address, uint256) public returns (uint256) {
927     require(false);
928     return 0;
929   }
930 
931   /// @dev ERC223 transferAndCall, send cln to the market maker contract can only be called by owner (see MarketMaker)
932   /// @dev sending CLN will return CC from the reserve to the sender.
933   function insertCLNtoMarketMaker(address) public returns (uint256) {
934     require(false);
935     return 0;
936   }
937 
938   /// @dev normal send CC to the market maker contract, sender must approve() before calling method. can only be called by owner
939   /// @dev sending CC will return CLN from the reserve to the sender.
940   function extractCLNfromMarketMaker(address, uint256) public returns (uint256) {
941     require(false);
942     return 0;
943   }
944 
945   /// @dev ERC223 transferAndCall, send CC to the market maker contract can only be called by owner (see MarketMaker)
946   /// @dev sending CC will return CLN from the reserve to the sender.
947   function extractCLNfromMarketMaker() public returns (uint256) {
948     require(false);
949     return 0;
950   }
951 
952   /// @dev opens the Market Maker to recvice transactions from all sources.
953   /// @dev Request to transfer ownership of Market Maker contract to Owner instead of factory.
954   function openMarket(address) public returns (bool) {
955 		require(false);
956 		return false;
957   }
958 
959   /// @dev checks if the parameters that were sent to the create are valid for a promised price and buyback
960   /// @param _hardcap uint256 CLN hardcap for issuance
961   /// @param _price uint256 computed through the market maker using the supplies and reserves
962   /// @param _S2 uint256 supply of the CC token
963   /// @param _R2 uint256 reserve of the CC token
964   function isValidIssuance(uint256 _hardcap,
965                             uint256 _price,
966                             uint256 _S2,
967                             uint256 _R2) public view
968                             returns (bool) {
969  	  return (_S2 > _R2 && _S2.sub(_R2).mul(PRECISION) >= _hardcap.mul(_price));
970   }
971 
972 
973   /// @dev helper function to fetch market maker contract address deploed with the CC
974   /// @param _token address token address for this issuance (same as CC adress)
975   function getMarketMakerAddressFromToken(address _token) public constant returns (address) {
976   	return currencyMap[_token].mmAddress;
977   }
978 
979   /// @dev helper function to approve tokens for market maker and then change tokens
980   /// @param _token address deployed ERC20 token address to spend
981   /// @param _token2 address deployed ERC20 token address to buy
982   /// @param _amount uint256 amount of _token to spend
983   /// @param _marketMakerAddress address for the deploed market maker with this CC
984   function approveAndChange(address _token,
985                             address _token2,
986                             uint256 _amount,
987                             address _marketMakerAddress) private
988                             returns (uint256) {
989   	if (_amount > 0) {
990 	  	require(ERC20(_token).approve(_marketMakerAddress, _amount));
991 	  	return MarketMaker(_marketMakerAddress).change(_token, _amount, _token2);
992 	  }
993 	  return 0;
994   }
995 
996   /// @dev helper function participation with CLN
997   /// @dev returns the amount to send to reserve and amount to participate
998   /// @param _clnAmount amount of cln the user wants to participate with
999   /// @param _token address token address for this issuance (same as CC adress)
1000   /// @return {
1001   ///	"transferToReserveAmount": ammount of CLN to transfer to reserves
1002   ///	"participationAmount": ammount of CLN that the sender will participate with in the sale
1003   ///}
1004   function getParticipationAmounts(uint256 _clnAmount,
1005                                    address _token) private view
1006                                    returns (uint256 transferToReserveAmount, uint256 participationAmount) {
1007     uint256 clnRaised = issueMap[_token].clnRaised;
1008     uint256 reserve = issueMap[_token].reserve;
1009     uint256 hardcap = issueMap[_token].hardcap;
1010     participationAmount = SafeMath.min256(_clnAmount, hardcap.sub(clnRaised));
1011     if (reserve > clnRaised) {
1012       transferToReserveAmount = SafeMath.min256(participationAmount, reserve.sub(clnRaised));
1013     }
1014   }
1015 
1016   /// @dev Returns total number of issuances after filters are applied.
1017   /// @dev this function is gas wasteful so do not call this from a state changing transaction
1018   /// @param _pending include pending currency issuances.
1019   /// @param _started include started currency issuances.
1020   /// @param _successful include successful and ended currency issuances.
1021   /// @param _failed include failed and ended currency issuances.
1022   /// @return Total number of currency issuances after filters are applied.
1023   function getIssuanceCount(bool _pending, bool _started, bool _successful, bool _failed)
1024     public
1025     view
1026     returns (uint _count)
1027   {
1028     for (uint i = 0; i < tokens.length; i++) {
1029       IssuanceStruct memory issuance = issueMap[tokens[i]];
1030       if ((_pending && issuance.startTime > now)
1031         || (_started && now >= issuance.startTime && issuance.endTime >= now && issuance.clnRaised < issuance.hardcap)
1032         || (_successful && issuance.endTime < now && issuance.clnRaised >= issuance.reserve)
1033         || (_successful && issuance.endTime >= now && issuance.clnRaised == issuance.hardcap)
1034         || (_failed && issuance.endTime < now && issuance.clnRaised < issuance.reserve))
1035         _count += 1;
1036     }
1037   }
1038 
1039   /// @dev Returns list of issuance ids (allso the token address of the issuance) in defined range after filters are applied.
1040   /// @dev _offset and _limit parameters are intended for pagination
1041   /// @dev this function is gas wasteful so do not call this from a state changing transaction
1042   /// @param _pending include pending currency issuances.
1043   /// @param _started include started currency issuances.
1044   /// @param _successful include successful and ended currency issuances.
1045   /// @param _failed include failed and ended currency issuances.
1046   /// @param _offset index start position of issuance ids array.
1047   /// @param _limit maximum number of issuance ids to return.
1048   /// @return Returns array of token adresses for issuance.
1049   function getIssuanceIds(bool _pending, bool _started, bool _successful, bool _failed, uint _offset, uint _limit)
1050     public
1051     view
1052     returns (address[] _issuanceIds)
1053   {
1054 	require(_limit >= 1);
1055 	require(_limit <= 100);
1056     _issuanceIds = new address[](_limit);
1057     uint filteredIssuancesCount = 0;
1058 	uint retrieveIssuancesCount = 0;
1059     for (uint i = 0; i < tokens.length; i++) {
1060       IssuanceStruct memory issuance = issueMap[tokens[i]];
1061       if ((_pending && issuance.startTime > now)
1062         || (_started && now >= issuance.startTime && issuance.endTime >= now && issuance.clnRaised < issuance.hardcap)
1063         || (_successful && issuance.endTime < now && issuance.clnRaised >= issuance.reserve)
1064         || (_successful && issuance.endTime >= now && issuance.clnRaised == issuance.hardcap)
1065         || (_failed && issuance.endTime < now && issuance.clnRaised < issuance.reserve))
1066       {
1067 		if (filteredIssuancesCount >= _offset) {
1068 			_issuanceIds[retrieveIssuancesCount] = tokens[i];
1069 			retrieveIssuancesCount += 1;
1070 		}
1071 		if (retrieveIssuancesCount == _limit) {
1072 			return _issuanceIds;
1073 		}
1074         filteredIssuancesCount += 1;
1075       }
1076     }
1077 
1078 	if (retrieveIssuancesCount < _limit) {
1079 		address[] memory _issuanceIdsTemp = new address[](retrieveIssuancesCount);
1080 		for (i = 0; i < retrieveIssuancesCount; i++) {
1081 			_issuanceIdsTemp[i] = _issuanceIds[i];
1082 		}
1083 		return _issuanceIdsTemp;
1084 	}
1085   }
1086 
1087   /// @dev Allow the owner to transfer out any accidentally sent ERC20 tokens.
1088   /// @param _tokenAddress address The address of the ERC20 contract.
1089   /// @param _amount uint256 The amount of tokens to be transferred.
1090   function transferAnyERC20Token(address _tokenAddress, uint256 _amount) public onlyOwner returns (bool success) {
1091     if (_tokenAddress == clnAddress) {
1092       uint256 excessCLN = ERC20(clnAddress).balanceOf(this).sub(totalCLNcustodian);
1093       require(excessCLN <= _amount);
1094     }
1095 
1096     if (issueMap[_tokenAddress].hardcap > 0) {
1097       require(MarketMaker(currencyMap[_tokenAddress].mmAddress).isOpenForPublic());
1098     }
1099     return ERC20(_tokenAddress).transfer(owner, _amount);
1100   }
1101 }