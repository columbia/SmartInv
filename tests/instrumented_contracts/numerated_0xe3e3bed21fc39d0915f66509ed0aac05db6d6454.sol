1 pragma solidity ^0.4.18;
2 
3 // File: contracts/Ownable.sol
4 
5 /// @title Ownable
6 /// @dev The Ownable contract has an owner address, and provides basic authorization control functions,
7 /// this simplifies the implementation of "user permissions".
8 /// @dev Based on OpenZeppelin's Ownable.
9 
10 contract Ownable {
11     address public owner;
12     address public newOwnerCandidate;
13 
14     event OwnershipRequested(address indexed by, address indexed to);
15     event OwnershipTransferred(address indexed from, address indexed to);
16 
17     /// @dev Constructor sets the original `owner` of the contract to the sender account.
18     function Ownable() public {
19         owner = msg.sender;
20     }
21 
22     /// @dev Reverts if called by any account other than the owner.
23     modifier onlyOwner() {
24         require(msg.sender == owner);
25         _;
26     }
27 
28     modifier onlyOwnerCandidate() {
29         require(msg.sender == newOwnerCandidate);
30         _;
31     }
32 
33     /// @dev Proposes to transfer control of the contract to a newOwnerCandidate.
34     /// @param _newOwnerCandidate address The address to transfer ownership to.
35     function requestOwnershipTransfer(address _newOwnerCandidate) external onlyOwner {
36         require(_newOwnerCandidate != address(0));
37 
38         newOwnerCandidate = _newOwnerCandidate;
39 
40         OwnershipRequested(msg.sender, newOwnerCandidate);
41     }
42 
43     /// @dev Accept ownership transfer. This method needs to be called by the perviously proposed owner.
44     function acceptOwnership() external onlyOwnerCandidate {
45         address previousOwner = owner;
46 
47         owner = newOwnerCandidate;
48         newOwnerCandidate = address(0);
49 
50         OwnershipTransferred(previousOwner, owner);
51     }
52 }
53 
54 // File: contracts/SafeMath.sol
55 
56 /// @title Math operations with safety checks
57 library SafeMath {
58     function mul(uint256 a, uint256 b) internal pure returns (uint256) {
59         uint256 c = a * b;
60         require(a == 0 || c / a == b);
61         return c;
62     }
63 
64     function div(uint256 a, uint256 b) internal pure returns (uint256) {
65         // require(b > 0); // Solidity automatically throws when dividing by 0
66         uint256 c = a / b;
67         // require(a == b * c + a % b); // There is no case in which this doesn't hold
68         return c;
69     }
70 
71     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
72         require(b <= a);
73         return a - b;
74     }
75 
76     function add(uint256 a, uint256 b) internal pure returns (uint256) {
77         uint256 c = a + b;
78         require(c >= a);
79         return c;
80     }
81 
82     function max64(uint64 a, uint64 b) internal pure returns (uint64) {
83         return a >= b ? a : b;
84     }
85 
86     function min64(uint64 a, uint64 b) internal pure returns (uint64) {
87         return a < b ? a : b;
88     }
89 
90     function max256(uint256 a, uint256 b) internal pure returns (uint256) {
91         return a >= b ? a : b;
92     }
93 
94     function min256(uint256 a, uint256 b) internal pure returns (uint256) {
95         return a < b ? a : b;
96     }
97 
98     function toPower2(uint256 a) internal pure returns (uint256) {
99         return mul(a, a);
100     }
101 
102     function sqrt(uint256 a) internal pure returns (uint256) {
103         uint256 c = (a + 1) / 2;
104         uint256 b = a;
105         while (c < b) {
106             b = c;
107             c = (a / c + c) / 2;
108         }
109         return b;
110     }
111 }
112 
113 // File: contracts/ERC20.sol
114 
115 /// @title ERC Token Standard #20 Interface (https://github.com/ethereum/EIPs/issues/20)
116 contract ERC20 {
117     uint public totalSupply;
118     function balanceOf(address _owner) constant public returns (uint balance);
119     function transfer(address _to, uint _value) public returns (bool success);
120     function transferFrom(address _from, address _to, uint _value) public returns (bool success);
121     function approve(address _spender, uint _value) public returns (bool success);
122     function allowance(address _owner, address _spender) public constant returns (uint remaining);
123     event Transfer(address indexed from, address indexed to, uint value);
124     event Approval(address indexed owner, address indexed spender, uint value);
125 }
126 
127 // File: contracts/BasicToken.sol
128 
129 /// @title Basic ERC20 token contract implementation.
130 /// @dev Based on OpenZeppelin's StandardToken.
131 contract BasicToken is ERC20 {
132     using SafeMath for uint256;
133 
134     uint256 public totalSupply;
135     mapping (address => mapping (address => uint256)) allowed;
136     mapping (address => uint256) balances;
137 
138     event Approval(address indexed owner, address indexed spender, uint256 value);
139     event Transfer(address indexed from, address indexed to, uint256 value);
140 
141     /// @dev Approve the passed address to spend the specified amount of tokens on behalf of msg.sender.
142     /// @param _spender address The address which will spend the funds.
143     /// @param _value uint256 The amount of tokens to be spent.
144     function approve(address _spender, uint256 _value) public returns (bool) {
145         // https://github.com/ethereum/EIPs/blob/master/EIPS/eip-20.md#approve (see NOTE)
146         if ((_value != 0) && (allowed[msg.sender][_spender] != 0)) {
147             revert();
148         }
149 
150         allowed[msg.sender][_spender] = _value;
151 
152         Approval(msg.sender, _spender, _value);
153 
154         return true;
155     }
156 
157     /// @dev Function to check the amount of tokens that an owner allowed to a spender.
158     /// @param _owner address The address which owns the funds.
159     /// @param _spender address The address which will spend the funds.
160     /// @return uint256 specifying the amount of tokens still available for the spender.
161     function allowance(address _owner, address _spender) constant public returns (uint256 remaining) {
162         return allowed[_owner][_spender];
163     }
164 
165 
166     /// @dev Gets the balance of the specified address.
167     /// @param _owner address The address to query the the balance of.
168     /// @return uint256 representing the amount owned by the passed address.
169     function balanceOf(address _owner) constant public returns (uint256 balance) {
170         return balances[_owner];
171     }
172 
173     /// @dev Transfer token to a specified address.
174     /// @param _to address The address to transfer to.
175     /// @param _value uint256 The amount to be transferred.
176     function transfer(address _to, uint256 _value) public returns (bool) {
177         require(_to != address(0));
178         balances[msg.sender] = balances[msg.sender].sub(_value);
179         balances[_to] = balances[_to].add(_value);
180 
181         Transfer(msg.sender, _to, _value);
182 
183         return true;
184     }
185 
186     /// @dev Transfer tokens from one address to another.
187     /// @param _from address The address which you want to send tokens from.
188     /// @param _to address The address which you want to transfer to.
189     /// @param _value uint256 the amount of tokens to be transferred.
190     function transferFrom(address _from, address _to, uint256 _value) public returns (bool) {
191         require(_to != address(0));
192         uint256 _allowance = allowed[_from][msg.sender];
193 
194         balances[_from] = balances[_from].sub(_value);
195         balances[_to] = balances[_to].add(_value);
196 
197         allowed[_from][msg.sender] = _allowance.sub(_value);
198 
199         Transfer(_from, _to, _value);
200 
201         return true;
202     }
203 }
204 
205 // File: contracts/ERC223Receiver.sol
206 
207 /// @title ERC223Receiver Interface
208 /// @dev Based on the specs form: https://github.com/ethereum/EIPs/issues/223
209 contract ERC223Receiver {
210     function tokenFallback(address _sender, uint _value, bytes _data) external returns (bool ok);
211 }
212 
213 // File: contracts/ERC677.sol
214 
215 /// @title ERC Token Standard #677 Interface (https://github.com/ethereum/EIPs/issues/677)
216 contract ERC677 is ERC20 {
217     function transferAndCall(address to, uint value, bytes data) public returns (bool ok);
218 
219     event TransferAndCall(address indexed from, address indexed to, uint value, bytes data);
220 }
221 
222 // File: contracts/Standard677Token.sol
223 
224 /// @title Standard677Token implentation, base on https://github.com/ethereum/EIPs/issues/677
225 
226 contract Standard677Token is ERC677, BasicToken {
227 
228   /// @dev ERC223 safe token transfer from one address to another
229   /// @param _to address the address which you want to transfer to.
230   /// @param _value uint256 the amount of tokens to be transferred.
231   /// @param _data bytes data that can be attached to the token transation
232   function transferAndCall(address _to, uint _value, bytes _data) public returns (bool) {
233     require(super.transfer(_to, _value)); // do a normal token transfer
234     TransferAndCall(msg.sender, _to, _value, _data);
235     //filtering if the target is a contract with bytecode inside it
236     if (isContract(_to)) return contractFallback(_to, _value, _data);
237     return true;
238   }
239 
240   /// @dev called when transaction target is a contract
241   /// @param _to address the address which you want to transfer to.
242   /// @param _value uint256 the amount of tokens to be transferred.
243   /// @param _data bytes data that can be attached to the token transation
244   function contractFallback(address _to, uint _value, bytes _data) private returns (bool) {
245     ERC223Receiver receiver = ERC223Receiver(_to);
246     require(receiver.tokenFallback(msg.sender, _value, _data));
247     return true;
248   }
249 
250   /// @dev check if the address is contract
251   /// assemble the given address bytecode. If bytecode exists then the _addr is a contract.
252   /// @param _addr address the address to check
253   function isContract(address _addr) private constant returns (bool is_contract) {
254     // retrieve the size of the code on target address, this needs assembly
255     uint length;
256     assembly { length := extcodesize(_addr) }
257     return length > 0;
258   }
259 }
260 
261 // File: contracts/TokenHolder.sol
262 
263 /// @title Token holder contract.
264 contract TokenHolder is Ownable {
265     /// @dev Allow the owner to transfer out any accidentally sent ERC20 tokens.
266     /// @param _tokenAddress address The address of the ERC20 contract.
267     /// @param _amount uint256 The amount of tokens to be transferred.
268     function transferAnyERC20Token(address _tokenAddress, uint256 _amount) public onlyOwner returns (bool success) {
269         return ERC20(_tokenAddress).transfer(owner, _amount);
270     }
271 }
272 
273 // File: contracts/ColuLocalCurrency.sol
274 
275 /// @title Colu Local Currency contract.
276 /// @author Rotem Lev.
277 contract ColuLocalCurrency is Ownable, Standard677Token, TokenHolder {
278     using SafeMath for uint256;
279     string public name;
280     string public symbol;
281     uint8 public decimals;
282     string public tokenURI;
283 
284     event TokenURIChanged(string newTokenURI);
285 
286     /// @dev cotract to use when issuing a CC (Local Currency)
287     /// @param _name string name for CC token that is created.
288     /// @param _symbol string symbol for CC token that is created.
289     /// @param _decimals uint8 percison for CC token that is created.
290     /// @param _totalSupply uint256 total supply of the CC token that is created.
291     /// @param _tokenURI string the URI may point to a JSON file that conforms to the "Metadata JSON Schema".
292     function ColuLocalCurrency(string _name, string _symbol, uint8 _decimals, uint256 _totalSupply, string _tokenURI) public {
293         require(_totalSupply != 0);
294         require(bytes(_name).length != 0);
295         require(bytes(_symbol).length != 0);
296 
297         totalSupply = _totalSupply;
298         name = _name;
299         symbol = _symbol;
300         decimals = _decimals;
301         tokenURI = _tokenURI;
302         balances[msg.sender] = totalSupply;
303     }
304 
305     /// @dev Sets the tokenURI field, can be called by the owner only
306     /// @param _tokenURI string the URI may point to a JSON file that conforms to the "Metadata JSON Schema".
307     function setTokenURI(string _tokenURI) public onlyOwner {
308       tokenURI = _tokenURI;
309       TokenURIChanged(_tokenURI);
310     }
311 }
312 
313 // File: contracts/Standard223Receiver.sol
314 
315 /// @title Standard ERC223 Token Receiver implementing tokenFallback function and tokenPayable modifier
316 
317 contract Standard223Receiver is ERC223Receiver {
318   Tkn tkn;
319 
320   struct Tkn {
321     address addr;
322     address sender; // the transaction caller
323     uint256 value;
324   }
325 
326   bool __isTokenFallback;
327 
328   modifier tokenPayable {
329     require(__isTokenFallback);
330     _;
331   }
332 
333   /// @dev Called when the receiver of transfer is contract
334   /// @param _sender address the address of tokens sender
335   /// @param _value uint256 the amount of tokens to be transferred.
336   /// @param _data bytes data that can be attached to the token transation
337   function tokenFallback(address _sender, uint _value, bytes _data) external returns (bool ok) {
338     if (!supportsToken(msg.sender)) {
339       return false;
340     }
341 
342     // Problem: This will do a sstore which is expensive gas wise. Find a way to keep it in memory.
343     // Solution: Remove the the data
344     tkn = Tkn(msg.sender, _sender, _value);
345     __isTokenFallback = true;
346     if (!address(this).delegatecall(_data)) {
347       __isTokenFallback = false;
348       return false;
349     }
350     // avoid doing an overwrite to .token, which would be more expensive
351     // makes accessing .tkn values outside tokenPayable functions unsafe
352     __isTokenFallback = false;
353 
354     return true;
355   }
356 
357   function supportsToken(address token) public constant returns (bool);
358 }
359 
360 // File: contracts/TokenOwnable.sol
361 
362 /// @title TokenOwnable
363 /// @dev The TokenOwnable contract adds a onlyTokenOwner modifier as a tokenReceiver with ownable addaptation
364 
365 contract TokenOwnable is Standard223Receiver, Ownable {
366     /// @dev Reverts if called by any account other than the owner for token sending.
367     modifier onlyTokenOwner() {
368         require(tkn.sender == owner);
369         _;
370     }
371 }
372 
373 // File: contracts/EllipseMarketMaker.sol
374 
375 /// @title Ellipse Market Maker contract.
376 /// @dev market maker, using ellipse equation.
377 /// @author Tal Beja.
378 contract EllipseMarketMaker is TokenOwnable {
379 
380   // precision for price representation (as in ether or tokens).
381   uint256 public constant PRECISION = 10 ** 18;
382 
383   // The tokens pair.
384   ERC20 public token1;
385   ERC20 public token2;
386 
387   // The tokens reserves.
388   uint256 public R1;
389   uint256 public R2;
390 
391   // The tokens full suplly.
392   uint256 public S1;
393   uint256 public S2;
394 
395   // State flags.
396   bool public operational;
397   bool public openForPublic;
398 
399   // Library contract address.
400   address public mmLib;
401 
402   /// @dev Constructor calling the library contract using delegate.
403   function EllipseMarketMaker(address _mmLib, address _token1, address _token2) public {
404     require(_mmLib != address(0));
405     // Signature of the mmLib's constructor function
406     // bytes4 sig = bytes4(keccak256("constructor(address,address,address)"));
407     bytes4 sig = 0x6dd23b5b;
408 
409     // 3 arguments of size 32
410     uint256 argsSize = 3 * 32;
411     // sig + arguments size
412     uint256 dataSize = 4 + argsSize;
413 
414 
415     bytes memory m_data = new bytes(dataSize);
416 
417     assembly {
418         // Add the signature first to memory
419         mstore(add(m_data, 0x20), sig)
420         // Add the parameters
421         mstore(add(m_data, 0x24), _mmLib)
422         mstore(add(m_data, 0x44), _token1)
423         mstore(add(m_data, 0x64), _token2)
424     }
425 
426     // delegatecall to the library contract
427     require(_mmLib.delegatecall(m_data));
428   }
429 
430   /// @dev returns true iff token is supperted by this contract (for erc223/677 tokens calls)
431   /// @param token can be token1 or token2
432   function supportsToken(address token) public constant returns (bool) {
433     return (token1 == token || token2 == token);
434   }
435 
436   /// @dev gets called when no other function matches, delegate to the lib contract.
437   function() public {
438     address _mmLib = mmLib;
439     if (msg.data.length > 0) {
440       assembly {
441         calldatacopy(0xff, 0, calldatasize)
442         let retVal := delegatecall(gas, _mmLib, 0xff, calldatasize, 0, 0x20)
443         switch retVal case 0 { revert(0,0) } default { return(0, 0x20) }
444       }
445     }
446   }
447 }
448 
449 // File: contracts/MarketMaker.sol
450 
451 /// @title Market Maker Interface.
452 /// @author Tal Beja.
453 contract MarketMaker is ERC223Receiver {
454 
455   function getCurrentPrice() public constant returns (uint _price);
456   function change(address _fromToken, uint _amount, address _toToken) public returns (uint _returnAmount);
457   function change(address _fromToken, uint _amount, address _toToken, uint _minReturn) public returns (uint _returnAmount);
458   function change(address _toToken) public returns (uint _returnAmount);
459   function change(address _toToken, uint _minReturn) public returns (uint _returnAmount);
460   function quote(address _fromToken, uint _amount, address _toToken) public constant returns (uint _returnAmount);
461   function openForPublicTrade() public returns (bool success);
462   function isOpenForPublic() public returns (bool success);
463 
464   event Change(address indexed fromToken, uint inAmount, address indexed toToken, uint returnAmount, address indexed account);
465 }
466 
467 // File: contracts/IEllipseMarketMaker.sol
468 
469 /// @title Ellipse Market Maker Interfase
470 /// @author Tal Beja
471 contract IEllipseMarketMaker is MarketMaker {
472 
473     // precision for price representation (as in ether or tokens).
474     uint256 public constant PRECISION = 10 ** 18;
475 
476     // The tokens pair.
477     ERC20 public token1;
478     ERC20 public token2;
479 
480     // The tokens reserves.
481     uint256 public R1;
482     uint256 public R2;
483 
484     // The tokens full suplly.
485     uint256 public S1;
486     uint256 public S2;
487 
488     // State flags.
489     bool public operational;
490     bool public openForPublic;
491 
492     // Library contract address.
493     address public mmLib;
494 
495     function supportsToken(address token) public constant returns (bool);
496 
497     function calcReserve(uint256 _R1, uint256 _S1, uint256 _S2) public pure returns (uint256);
498 
499     function validateReserves() public view returns (bool);
500 
501     function withdrawExcessReserves() public returns (uint256);
502 
503     function initializeAfterTransfer() public returns (bool);
504 
505     function initializeOnTransfer() public returns (bool);
506 
507     function getPrice(uint256 _R1, uint256 _R2, uint256 _S1, uint256 _S2) public constant returns (uint256);
508 }
509 
510 // File: contracts/CurrencyFactory.sol
511 
512 /// @title Colu Local Currency + Market Maker factory contract.
513 /// @author Rotem Lev.
514 contract CurrencyFactory is Standard223Receiver, TokenHolder {
515 
516   struct CurrencyStruct {
517     string name;
518     uint8 decimals;
519     uint256 totalSupply;
520     address owner;
521     address mmAddress;
522   }
523 
524 
525   // map of Market Maker owners: token address => currency struct
526   mapping (address => CurrencyStruct) public currencyMap;
527   // address of the deployed CLN contract (ERC20 Token)
528   address public clnAddress;
529   // address of the deployed elipse market maker contract
530   address public mmLibAddress;
531 
532   address[] public tokens;
533 
534   event MarketOpen(address indexed marketMaker);
535   event TokenCreated(address indexed token, address indexed owner);
536 
537   // modifier to check if called by issuer of the token
538   modifier tokenIssuerOnly(address token, address owner) {
539     require(currencyMap[token].owner == owner);
540     _;
541   }
542   // modifier to only accept transferAndCall from CLN token
543   modifier CLNOnly() {
544     require(msg.sender == clnAddress);
545     _;
546   }
547 
548   /// @dev checks if the instance of market maker contract is closed for public
549   /// @param _token address address of the CC token.
550   modifier marketClosed(address _token) {
551   	require(!MarketMaker(currencyMap[_token].mmAddress).isOpenForPublic());
552   	_;
553   }
554 
555   /// @dev checks if the instance of market maker contract is open for public
556   /// @param _token address address of the CC token.
557   modifier marketOpen(address _token) {
558     require(MarketMaker(currencyMap[_token].mmAddress).isOpenForPublic());
559     _;
560   }
561 
562   /// @dev constructor only reuires the address of the CLN token which must use the ERC20 interface
563   /// @param _mmLib address for the deployed market maker elipse contract
564   /// @param _clnAddress address for the deployed ERC20 CLN token
565   function CurrencyFactory(address _mmLib, address _clnAddress) public {
566   	require(_mmLib != address(0));
567   	require(_clnAddress != address(0));
568   	mmLibAddress = _mmLib;
569   	clnAddress = _clnAddress;
570   }
571 
572   /// @dev create the MarketMaker and the CC token put all the CC token in the Market Maker reserve
573   /// @param _name string name for CC token that is created.
574   /// @param _symbol string symbol for CC token that is created.
575   /// @param _decimals uint8 percison for CC token that is created.
576   /// @param _totalSupply uint256 total supply of the CC token that is created.
577   /// @param _tokenURI string the URI may point to a JSON file that conforms to the "Metadata JSON Schema".
578   function createCurrency(string _name,
579                           string _symbol,
580                           uint8 _decimals,
581                           uint256 _totalSupply,
582                           string _tokenURI) public
583                           returns (address) {
584 
585   	ColuLocalCurrency subToken = new ColuLocalCurrency(_name, _symbol, _decimals, _totalSupply, _tokenURI);
586   	EllipseMarketMaker newMarketMaker = new EllipseMarketMaker(mmLibAddress, clnAddress, subToken);
587   	//set allowance
588   	require(subToken.transfer(newMarketMaker, _totalSupply));
589   	require(IEllipseMarketMaker(newMarketMaker).initializeAfterTransfer());
590   	currencyMap[subToken] = CurrencyStruct({ name: _name, decimals: _decimals, totalSupply: _totalSupply, mmAddress: newMarketMaker, owner: msg.sender});
591     tokens.push(subToken);
592   	TokenCreated(subToken, msg.sender);
593   	return subToken;
594   }
595 
596   /// @dev create the MarketMaker and the CC token put all the CC token in the Market Maker reserve
597   /// @param _name string name for CC token that is created.
598   /// @param _symbol string symbol for CC token that is created.
599   /// @param _decimals uint8 percison for CC token that is created.
600   /// @param _totalSupply uint256 total supply of the CC token that is created.
601   function createCurrency(string _name,
602                           string _symbol,
603                           uint8 _decimals,
604                           uint256 _totalSupply) public
605                           returns (address) {
606     return createCurrency(_name, _symbol, _decimals, _totalSupply, '');
607   }
608 
609   /// @dev normal send cln to the market maker contract, sender must approve() before calling method. can only be called by owner
610   /// @dev sending CLN will return CC from the reserve to the sender.
611   /// @param _token address address of the cc token managed by this factory.
612   /// @param _clnAmount uint256 amount of CLN to transfer into the Market Maker reserve.
613   function insertCLNtoMarketMaker(address _token,
614                                   uint256 _clnAmount) public
615                                   tokenIssuerOnly(_token, msg.sender)
616                                   returns (uint256 _subTokenAmount) {
617   	require(_clnAmount > 0);
618   	address marketMakerAddress = getMarketMakerAddressFromToken(_token);
619   	require(ERC20(clnAddress).transferFrom(msg.sender, this, _clnAmount));
620   	require(ERC20(clnAddress).approve(marketMakerAddress, _clnAmount));
621   	_subTokenAmount = IEllipseMarketMaker(marketMakerAddress).change(clnAddress, _clnAmount, _token);
622     require(ERC20(_token).transfer(msg.sender, _subTokenAmount));
623   }
624 
625   /// @dev ERC223 transferAndCall, send cln to the market maker contract can only be called by owner (see MarketMaker)
626   /// @dev sending CLN will return CC from the reserve to the sender.
627   /// @param _token address address of the cc token managed by this factory.
628   function insertCLNtoMarketMaker(address _token) public
629                                   tokenPayable
630                                   CLNOnly
631                                   tokenIssuerOnly(_token, tkn.sender)
632                                   returns (uint256 _subTokenAmount) {
633   	address marketMakerAddress = getMarketMakerAddressFromToken(_token);
634   	require(ERC20(clnAddress).approve(marketMakerAddress, tkn.value));
635   	_subTokenAmount = IEllipseMarketMaker(marketMakerAddress).change(clnAddress, tkn.value, _token);
636     require(ERC20(_token).transfer(tkn.sender, _subTokenAmount));
637   }
638 
639   /// @dev normal send cc to the market maker contract, sender must approve() before calling method. can only be called by owner
640   /// @dev sending CC will return CLN from the reserve to the sender.
641   /// @param _token address address of the cc token managed by this factory.
642   /// @param _ccAmount uint256 amount of CC to transfer into the Market Maker reserve.
643   function extractCLNfromMarketMaker(address _token,
644                                      uint256 _ccAmount) public
645                                      tokenIssuerOnly(_token, msg.sender)
646                                      returns (uint256 _clnTokenAmount) {
647   	address marketMakerAddress = getMarketMakerAddressFromToken(_token);
648   	require(ERC20(_token).transferFrom(msg.sender, this, _ccAmount));
649   	require(ERC20(_token).approve(marketMakerAddress, _ccAmount));
650   	_clnTokenAmount = IEllipseMarketMaker(marketMakerAddress).change(_token, _ccAmount, clnAddress);
651   	require(ERC20(clnAddress).transfer(msg.sender, _clnTokenAmount));
652   }
653 
654   /// @dev ERC223 transferAndCall, send CC to the market maker contract can only be called by owner (see MarketMaker)
655   /// @dev sending CC will return CLN from the reserve to the sender.
656   function extractCLNfromMarketMaker() public
657                                     tokenPayable
658                                     tokenIssuerOnly(msg.sender, tkn.sender)
659                                     returns (uint256 _clnTokenAmount) {
660   	address marketMakerAddress = getMarketMakerAddressFromToken(msg.sender);
661   	require(ERC20(msg.sender).approve(marketMakerAddress, tkn.value));
662   	_clnTokenAmount = IEllipseMarketMaker(marketMakerAddress).change(msg.sender, tkn.value, clnAddress);
663   	require(ERC20(clnAddress).transfer(tkn.sender, _clnTokenAmount));
664   }
665 
666   /// @dev opens the Market Maker to recvice transactions from all sources.
667   /// @dev Request to transfer ownership of Market Maker contract to Owner instead of factory.
668   /// @param _token address address of the cc token managed by this factory.
669   function openMarket(address _token) public
670                       tokenIssuerOnly(_token, msg.sender)
671                       returns (bool) {
672   	address marketMakerAddress = getMarketMakerAddressFromToken(_token);
673   	require(MarketMaker(marketMakerAddress).openForPublicTrade());
674   	Ownable(marketMakerAddress).requestOwnershipTransfer(msg.sender);
675     Ownable(_token).requestOwnershipTransfer(msg.sender);
676   	MarketOpen(marketMakerAddress);
677   	return true;
678   }
679 
680   /// @dev implementation for standard 223 reciver.
681   /// @param _token address of the token used with transferAndCall.
682   function supportsToken(address _token) public constant returns (bool) {
683   	return (clnAddress == _token || currencyMap[_token].totalSupply > 0);
684   }
685 
686   /// @dev sets tokenURI for the given currency, can be used during the sell only
687   /// @param _token address address of the token to update
688   /// @param _tokenURI string the URI may point to a JSON file that conforms to the "Metadata JSON Schema".
689   function setTokenURI(address _token, string _tokenURI) public
690                               tokenIssuerOnly(_token, msg.sender)
691                               marketClosed(_token)
692                               returns (bool) {
693     ColuLocalCurrency(_token).setTokenURI(_tokenURI);
694     return true;
695   }
696 
697   /// @dev helper function to get the market maker address form token
698   /// @param _token address of the token used with transferAndCall.
699   function getMarketMakerAddressFromToken(address _token) public constant returns (address _marketMakerAddress) {
700   	_marketMakerAddress = currencyMap[_token].mmAddress;
701     require(_marketMakerAddress != address(0));
702   }
703 }