1 /*
2     The MIT License (MIT)
3 
4     Copyright 2018 - 2019, Autonomous Software.
5 
6     Permission is hereby granted, free of charge, to any person obtaining
7     a copy of this software and associated documentation files (the
8     "Software"), to deal in the Software without restriction, including
9     without limitation the rights to use, copy, modify, merge, publish,
10     distribute, sublicense, and/or sell copies of the Software, and to
11     permit persons to whom the Software is furnished to do so, subject to
12     the following conditions:
13 
14     The above copyright notice and this permission notice shall be included
15     in all copies or substantial portions of the Software.
16 
17     THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS
18     OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF
19     MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT.
20     IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY
21     CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER IN AN ACTION OF CONTRACT,
22     TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN CONNECTION WITH THE
23     SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.
24 */
25 pragma solidity ^0.4.25;
26 
27 
28 /**
29  * Reference: https://github.com/OpenZeppelin/zeppelin-solidity/blob/master/contracts/math/SafeMath.sol
30  *
31  * @title SafeMath
32  * @dev Math operations with safety checks that throw on error
33  */
34 library SafeMath {
35 
36     /**
37     * @dev Multiplies two numbers, throws on overflow.
38     */
39     function mul(uint256 a, uint256 b) internal pure returns (uint256) {
40         if (a == 0) {
41             return 0;
42         }
43         uint256 c = a * b;
44         assert(c / a == b);
45         return c;
46     }
47 
48     /**
49     * @dev Integer division of two numbers, truncating the quotient.
50     */
51     function div(uint256 a, uint256 b) internal pure returns (uint256) {
52         // assert(b > 0); // Solidity automatically throws when dividing by 0
53         uint256 c = a / b;
54         // assert(a == b * c + a % b); // There is no case in which this doesn't hold
55         return c;
56     }
57 
58     /**
59     * @dev Substracts two numbers, throws on overflow (i.e. if subtrahend is greater than minuend).
60     */
61     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
62         assert(b <= a);
63         return a - b;
64     }
65 
66     /**
67     * @dev Adds two numbers, throws on overflow.
68     */
69     function add(uint256 a, uint256 b) internal pure returns (uint256) {
70         uint256 c = a + b;
71         assert(c >= a);
72         return c;
73     }
74 }
75 /* end SafeMath library */
76 
77 
78 /// @title Math operation when both numbers has decimal places.
79 /// @notice Use this contract when both numbers has 18 decimal places. 
80 contract FixedMath {
81     
82     using SafeMath for uint;
83     uint constant internal METDECIMALS = 18;
84     uint constant internal METDECMULT = 10 ** METDECIMALS;
85     uint constant internal DECIMALS = 18;
86     uint constant internal DECMULT = 10 ** DECIMALS;
87 
88     /// @notice Multiplication.
89     function fMul(uint x, uint y) internal pure returns (uint) {
90         return (x.mul(y)).div(DECMULT);
91     }
92 
93     /// @notice Division.
94     function fDiv(uint numerator, uint divisor) internal pure returns (uint) {
95         return (numerator.mul(DECMULT)).div(divisor);
96     }
97 
98     /// @notice Square root.
99     /// @dev Reference: https://stackoverflow.com/questions/3766020/binary-search-to-compute-square-root-java
100     function fSqrt(uint n) internal pure returns (uint) {
101         if (n == 0) {
102             return 0;
103         }
104         uint z = n * n;
105         require(z / n == n);
106 
107         uint high = fAdd(n, DECMULT);
108         uint low = 0;
109         while (fSub(high, low) > 1) {
110             uint mid = fAdd(low, high) / 2;
111             if (fSqr(mid) <= n) {
112                 low = mid;
113             } else {
114                 high = mid;
115             }
116         }
117         return low;
118     }
119 
120     /// @notice Square.
121     function fSqr(uint n) internal pure returns (uint) {
122         return fMul(n, n);
123     }
124 
125     /// @notice Add.
126     function fAdd(uint x, uint y) internal pure returns (uint) {
127         return x.add(y);
128     }
129 
130     /// @notice Sub.
131     function fSub(uint x, uint y) internal pure returns (uint) {
132         return x.sub(y);
133     }
134 }
135 
136 
137 /// @title A formula contract for converter
138 contract Formula is FixedMath {
139 
140     /// @notice Trade in reserve(ETH/MET) and mint new smart tokens
141     /// @param smartTokenSupply Total supply of smart token
142     /// @param reserveTokensSent Amount of token sent by caller
143     /// @param reserveTokenBalance Balance of reserve token in the contract
144     /// @return Smart token minted
145     function returnForMint(uint smartTokenSupply, uint reserveTokensSent, uint reserveTokenBalance) 
146         internal pure returns (uint)
147     {
148         uint s = smartTokenSupply;
149         uint e = reserveTokensSent;
150         uint r = reserveTokenBalance;
151         /// smartToken for mint(T) = S * (sqrt(1 + E/R) - 1)
152         /// DECMULT is same as 1 for values with 18 decimal places
153         return ((fMul(s, (fSub(fSqrt(fAdd(DECMULT, fDiv(e, r))), DECMULT)))).mul(METDECMULT)).div(DECMULT);
154     }
155 
156     /// @notice Redeem smart tokens, get back reserve(ETH/MET) token
157     /// @param smartTokenSupply Total supply of smart token
158     /// @param smartTokensSent Smart token sent
159     /// @param reserveTokenBalance Balance of reserve token in the contract
160     /// @return Reserve token redeemed
161     function returnForRedemption(uint smartTokenSupply, uint smartTokensSent, uint reserveTokenBalance)
162         internal pure returns (uint)
163     {
164         uint s = smartTokenSupply;
165         uint t = smartTokensSent;
166         uint r = reserveTokenBalance;
167         /// reserveToken (E) = R * (1 - (1 - T/S)**2)
168         /// DECMULT is same as 1 for values with 18 decimal places
169         return ((fMul(r, (fSub(DECMULT, fSqr(fSub(DECMULT, fDiv(t, s))))))).mul(METDECMULT)).div(DECMULT);
170     }
171 }
172 
173 
174 /// @title Pricer contract to calculate descending price during auction.
175 contract Pricer {
176 
177     using SafeMath for uint;
178     uint constant internal METDECIMALS = 18;
179     uint constant internal METDECMULT = 10 ** METDECIMALS;
180     uint public minimumPrice = 33*10**11;
181     uint public minimumPriceInDailyAuction = 1;
182 
183     uint public tentimes;
184     uint public hundredtimes;
185     uint public thousandtimes;
186 
187     uint constant public MULTIPLIER = 1984320568*10**5;
188 
189     /// @notice Pricer constructor, calculate 10, 100 and 1000 times of 0.99.
190     function initPricer() public {
191         uint x = METDECMULT;
192         uint i;
193         
194         /// Calculate 10 times of 0.99
195         for (i = 0; i < 10; i++) {
196             x = x.mul(99).div(100);
197         }
198         tentimes = x;
199         x = METDECMULT;
200 
201         /// Calculate 100 times of 0.99 using tentimes calculated above.
202         /// tentimes has 18 decimal places and due to this METDECMLT is
203         /// used as divisor.
204         for (i = 0; i < 10; i++) {
205             x = x.mul(tentimes).div(METDECMULT);
206         }
207         hundredtimes = x;
208         x = METDECMULT;
209 
210         /// Calculate 1000 times of 0.99 using hundredtimes calculated above.
211         /// hundredtimes has 18 decimal places and due to this METDECMULT is
212         /// used as divisor.
213         for (i = 0; i < 10; i++) {
214             x = x.mul(hundredtimes).div(METDECMULT);
215         }
216         thousandtimes = x;
217     }
218 
219     /// @notice Price of MET at nth minute out during operational auction
220     /// @param initialPrice The starting price ie last purchase price
221     /// @param _n The number of minutes passed since last purchase
222     /// @return The resulting price
223     function priceAt(uint initialPrice, uint _n) public view returns (uint price) {
224         uint mult = METDECMULT;
225         uint i;
226         uint n = _n;
227 
228         /// If quotient of n/1000 is greater than 0 then calculate multiplier by
229         /// multiplying thousandtimes and mult in a loop which runs quotient times.
230         /// Also assign new value to n which is remainder of n/1000.
231         if (n / 1000 > 0) {
232             for (i = 0; i < n / 1000; i++) {
233                 mult = mult.mul(thousandtimes).div(METDECMULT);
234             }
235             n = n % 1000;
236         }
237 
238         /// If quotient of n/100 is greater than 0 then calculate multiplier by
239         /// multiplying hundredtimes and mult in a loop which runs quotient times.
240         /// Also assign new value to n which is remainder of n/100.
241         if (n / 100 > 0) {
242             for (i = 0; i < n / 100; i++) {
243                 mult = mult.mul(hundredtimes).div(METDECMULT);
244             }
245             n = n % 100;
246         }
247 
248         /// If quotient of n/10 is greater than 0 then calculate multiplier by
249         /// multiplying tentimes and mult in a loop which runs quotient times.
250         /// Also assign new value to n which is remainder of n/10.
251         if (n / 10 > 0) {
252             for (i = 0; i < n / 10; i++) {
253                 mult = mult.mul(tentimes).div(METDECMULT);
254             }
255             n = n % 10;
256         }
257 
258         /// Calculate multiplier by multiplying 0.99 and mult, repeat it n times.
259         for (i = 0; i < n; i++) {
260             mult = mult.mul(99).div(100);
261         }
262 
263         /// price is calculated as initialPrice multiplied by 0.99 and that too _n times.
264         /// Here mult is METDECMULT multiplied by 0.99 and that too _n times.
265         price = initialPrice.mul(mult).div(METDECMULT);
266         
267         if (price < minimumPriceInDailyAuction) {
268             price = minimumPriceInDailyAuction;
269         }
270     }
271 
272     /// @notice Price of MET at nth minute during initial auction.
273     /// @param lastPurchasePrice The price of MET in last transaction
274     /// @param numTicks The number of minutes passed since last purchase
275     /// @return The resulting price
276     function priceAtInitialAuction(uint lastPurchasePrice, uint numTicks) public view returns (uint price) {
277         /// Price will decrease linearly every minute by the factor of MULTIPLIER.
278         /// If lastPurchasePrice is greater than decrease in price then calculated the price.
279         /// Return minimumPrice, if calculated price is less than minimumPrice.
280         /// If decrease in price is more than lastPurchasePrice then simply return the minimumPrice.
281         if (lastPurchasePrice > MULTIPLIER.mul(numTicks)) {
282             price = lastPurchasePrice.sub(MULTIPLIER.mul(numTicks));
283         }
284 
285         if (price < minimumPrice) {
286             price = minimumPrice;
287         }
288     }
289 }
290 
291 
292 /// @dev Reference: https://github.com/ethereum/EIPs/blob/master/EIPS/eip-20.md
293 /// @notice ERC20 standard interface
294 interface ERC20 {
295     function totalSupply() public constant returns (uint256);
296     function balanceOf(address _owner) public constant returns (uint256);
297     function allowance(address _owner, address _spender) public constant returns (uint256);
298 
299     event Transfer(address indexed _from, address indexed _to, uint256 _value);
300     function transfer(address _to, uint256 _value) public returns (bool);
301     function transferFrom(address _from, address _to, uint256 _value) public returns (bool);
302 
303     event Approval(address indexed _owner, address indexed _spender, uint256 _value);
304     function approve(address _spender, uint256 _value) public returns (bool);
305 }
306 
307 
308 /// @title Ownable
309 contract Ownable {
310 
311     address public owner;
312     event OwnershipChanged(address indexed prevOwner, address indexed newOwner);
313 
314     constructor() public {
315         owner = msg.sender;
316     }
317 
318     /// @dev Throws if called by any account other than the owner.
319     modifier onlyOwner() {
320         require(msg.sender == owner);
321         _;
322     }
323 
324     /// @notice Allows the current owner to transfer control of the contract to a newOwner.
325     /// @param _newOwner ..
326     /// @return true/false
327     function changeOwnership(address _newOwner) public onlyOwner returns (bool) {
328         require(_newOwner != address(0));
329         require(_newOwner != owner);
330         emit OwnershipChanged(owner, _newOwner);
331         owner = _newOwner;
332         return true;
333     }
334 }
335 
336 
337 /// @title Owned
338 contract Owned is Ownable {
339 
340     address public newOwner;
341 
342     /// @notice Allows the current owner to transfer control of the contract to a newOwner.
343     /// @param _newOwner ..
344     /// @return true/false
345     function changeOwnership(address _newOwner) public onlyOwner returns (bool) {
346         require(_newOwner != owner);
347         newOwner = _newOwner;
348         return true;
349     }
350 
351     /// @notice Allows the new owner to accept ownership of the contract.
352     /// @return true/false
353     function acceptOwnership() public returns (bool) {
354         require(msg.sender == newOwner);
355 
356         emit OwnershipChanged(owner, newOwner);
357         owner = newOwner;
358         return true;
359     }
360 }
361 
362 
363 /// @title Mintable contract to allow minting and destroy.
364 contract Mintable is Owned {
365 
366     using SafeMath for uint256;
367 
368     event Mint(address indexed _to, uint _value);
369     event Destroy(address indexed _from, uint _value);
370     event Transfer(address indexed _from, address indexed _to, uint256 _value);
371 
372     uint256 internal _totalSupply;
373     mapping(address => uint256) internal _balanceOf;
374 
375     address public autonomousConverter;
376     address public minter;
377     ITokenPorter public tokenPorter;
378 
379     /// @notice init reference of other contract and initial supply
380     /// @param _autonomousConverter ..
381     /// @param _minter ..
382     /// @param _initialSupply ..
383     /// @param _decmult Decimal places
384     function initMintable(address _autonomousConverter, address _minter, uint _initialSupply, 
385         uint _decmult) public onlyOwner {
386         require(autonomousConverter == 0x0 && _autonomousConverter != 0x0);
387         require(minter == 0x0 && _minter != 0x0);
388       
389         autonomousConverter = _autonomousConverter;
390         minter = _minter;
391         _totalSupply = _initialSupply.mul(_decmult);
392         _balanceOf[_autonomousConverter] = _totalSupply;
393     }
394 
395     function totalSupply() public constant returns (uint256) {
396         return _totalSupply;
397     }
398 
399     function balanceOf(address _owner) public constant returns (uint256) {
400         return _balanceOf[_owner];
401     }
402 
403     /// @notice set address of token porter
404     /// @param _tokenPorter address of token porter
405     function setTokenPorter(address _tokenPorter) public onlyOwner returns (bool) {
406         require(_tokenPorter != 0x0);
407 
408         tokenPorter = ITokenPorter(_tokenPorter);
409         return true;
410     }
411 
412     /// @notice allow minter and tokenPorter to mint token and assign to address
413     /// @param _to ..
414     /// @param _value Amount to be minted  
415     function mint(address _to, uint _value) public returns (bool) {
416         require(msg.sender == minter || msg.sender == address(tokenPorter));
417         _balanceOf[_to] = _balanceOf[_to].add(_value);
418         _totalSupply = _totalSupply.add(_value);
419         emit Mint(_to, _value);
420         emit Transfer(0x0, _to, _value);
421         return true;
422     }
423 
424     /// @notice allow autonomousConverter and tokenPorter to mint token and assign to address
425     /// @param _from ..
426     /// @param _value Amount to be destroyed
427     function destroy(address _from, uint _value) public returns (bool) {
428         require(msg.sender == autonomousConverter || msg.sender == address(tokenPorter));
429         _balanceOf[_from] = _balanceOf[_from].sub(_value);
430         _totalSupply = _totalSupply.sub(_value);
431         emit Destroy(_from, _value);
432         emit Transfer(_from, 0x0, _value);
433         return true;
434     }
435 }
436 
437 
438 /// @title Token contract
439 contract Token is ERC20, Mintable {
440     mapping(address => mapping(address => uint256)) internal _allowance;
441 
442     function initToken(address _autonomousConverter, address _minter,
443     uint _initialSupply, uint _decmult) public onlyOwner {
444         initMintable(_autonomousConverter, _minter, _initialSupply, _decmult);
445     }
446 
447     /// @notice Provide allowance information
448     function allowance(address _owner, address _spender) public constant returns (uint256) {
449         return _allowance[_owner][_spender];
450     }
451 
452     /// @notice Transfer tokens from sender to the provided address.
453     /// @param _to Receiver of the tokens
454     /// @param _value Amount of token
455     /// @return true/false
456     function transfer(address _to, uint256 _value) public returns (bool) {
457         require(_to != address(0));
458         require(_to != minter);
459         require(_to != address(this));
460         require(_to != autonomousConverter);
461         Proceeds proceeds = Auctions(minter).proceeds();
462         require((_to != address(proceeds)));
463 
464         _balanceOf[msg.sender] = _balanceOf[msg.sender].sub(_value);
465         _balanceOf[_to] = _balanceOf[_to].add(_value);
466 
467         emit Transfer(msg.sender, _to, _value);
468         return true;
469     }
470 
471     /// @notice Transfer tokens based on allowance.
472     /// msg.sender must have allowance for spending the tokens from owner ie _from
473     /// @param _from Owner of the tokens
474     /// @param _to Receiver of the tokens
475     /// @param _value Amount of tokens to transfer
476     /// @return true/false
477     function transferFrom(address _from, address _to, uint256 _value) public returns (bool) { 
478         require(_to != address(0));       
479         require(_to != minter && _from != minter);
480         require(_to != address(this) && _from != address(this));
481         Proceeds proceeds = Auctions(minter).proceeds();
482         require(_to != address(proceeds) && _from != address(proceeds));
483         //AC can accept MET via this function, needed for MetToEth conversion
484         require(_from != autonomousConverter);
485         require(_allowance[_from][msg.sender] >= _value);
486         
487         _balanceOf[_from] = _balanceOf[_from].sub(_value);
488         _balanceOf[_to] = _balanceOf[_to].add(_value);
489         _allowance[_from][msg.sender] = _allowance[_from][msg.sender].sub(_value);
490 
491         emit Transfer(_from, _to, _value);
492         return true;
493     }
494 
495     /// @notice Approve spender to spend the tokens ie approve allowance
496     /// @param _spender Spender of the tokens
497     /// @param _value Amount of tokens that can be spent by spender
498     /// @return true/false
499     function approve(address _spender, uint256 _value) public returns (bool) {
500         require(_spender != address(this));
501         _allowance[msg.sender][_spender] = _value;
502         emit Approval(msg.sender, _spender, _value);
503         return true;
504     }
505 
506     /// @notice Transfer the tokens from sender to all the address provided in the array.
507     /// @dev Left 160 bits are the recipient address and the right 96 bits are the token amount.
508     /// @param bits array of uint
509     /// @return true/false
510     function multiTransfer(uint[] bits) public returns (bool) {
511         for (uint i = 0; i < bits.length; i++) {
512             address a = address(bits[i] >> 96);
513             uint amount = bits[i] & ((1 << 96) - 1);
514             if (!transfer(a, amount)) revert();
515         }
516 
517         return true;
518     }
519 
520     /// @notice Increase allowance of spender
521     /// @param _spender Spender of the tokens
522     /// @param _value Amount of tokens that can be spent by spender
523     /// @return true/false
524     function approveMore(address _spender, uint256 _value) public returns (bool) {
525         uint previous = _allowance[msg.sender][_spender];
526         uint newAllowance = previous.add(_value);
527         _allowance[msg.sender][_spender] = newAllowance;
528         emit Approval(msg.sender, _spender, newAllowance);
529         return true;
530     }
531 
532     /// @notice Decrease allowance of spender
533     /// @param _spender Spender of the tokens
534     /// @param _value Amount of tokens that can be spent by spender
535     /// @return true/false
536     function approveLess(address _spender, uint256 _value) public returns (bool) {
537         uint previous = _allowance[msg.sender][_spender];
538         uint newAllowance = previous.sub(_value);
539         _allowance[msg.sender][_spender] = newAllowance;
540         emit Approval(msg.sender, _spender, newAllowance);
541         return true;
542     }
543 }
544 
545 
546 /// @title  Smart tokens are an intermediate token generated during conversion of MET-ETH
547 contract SmartToken is Mintable {
548     uint constant internal METDECIMALS = 18;
549     uint constant internal METDECMULT = 10 ** METDECIMALS;
550 
551     function initSmartToken(address _autonomousConverter, address _minter, uint _initialSupply) public  onlyOwner {
552         initMintable(_autonomousConverter, _minter, _initialSupply, METDECMULT); 
553     }
554 }
555 
556 
557 /// @title ERC20 token. Metronome token 
558 contract METToken is Token {
559 
560     string public constant name = "Metronome";
561     string public constant symbol = "MET";
562     uint8 public constant decimals = 18;
563 
564     bool public transferAllowed;
565 
566     function initMETToken(address _autonomousConverter, address _minter, 
567         uint _initialSupply, uint _decmult) public onlyOwner {
568         initToken(_autonomousConverter, _minter, _initialSupply, _decmult);
569     }
570     
571     /// @notice Transferable modifier to allow transfer only after initial auction ended.
572     modifier transferable() {
573         require(transferAllowed);
574         _;
575     }
576 
577     function enableMETTransfers() public returns (bool) {
578         require(!transferAllowed && Auctions(minter).isInitialAuctionEnded());
579         transferAllowed = true; 
580         return true;
581     }
582 
583     /// @notice Transfer tokens from caller to another address
584     /// @param _to address The address which you want to transfer to
585     /// @param _value uint256 the amout of tokens to be transfered
586     function transfer(address _to, uint256 _value) public transferable returns (bool) {
587         return super.transfer(_to, _value);
588         
589     }
590 
591     /// @notice Transfer tokens from one address to another
592     /// @param _from address The address from which you want to transfer
593     /// @param _to address The address which you want to transfer to
594     /// @param _value uint256 the amout of tokens to be transfered
595     function transferFrom(address _from, address _to, uint256 _value) public transferable returns (bool) {        
596         return super.transferFrom(_from, _to, _value);
597     }
598 
599     /// @notice Transfer the token from sender to all the addresses provided in array.
600     /// @dev Left 160 bits are the recipient address and the right 96 bits are the token amount.
601     /// @param bits array of uint
602     /// @return true/false
603     function multiTransfer(uint[] bits) public transferable returns (bool) {
604         return super.multiTransfer(bits);
605     }
606     
607     mapping (address => bytes32) public roots;
608 
609     function setRoot(bytes32 data) public {
610         roots[msg.sender] = data;
611     }
612 
613     function getRoot(address addr) public view returns (bytes32) {
614         return roots[addr];
615     }
616 
617     function rootsMatch(address a, address b) public view returns (bool) {
618         return roots[a] == roots[b];
619     }
620 
621     /// @notice import MET tokens from another chain to this chain.
622     /// @param _destinationChain destination chain name
623     /// @param _addresses _addresses[0] is destMetronomeAddr and _addresses[1] is recipientAddr
624     /// @param _extraData extra information for import
625     /// @param _burnHashes _burnHashes[0] is previous burnHash, _burnHashes[1] is current burnHash
626     /// @param _supplyOnAllChains MET supply on all supported chains
627     /// @param _importData _importData[0] is _blockTimestamp, _importData[1] is _amount, _importData[2] is _fee
628     /// _importData[3] is _burnedAtTick, _importData[4] is _genesisTime, _importData[5] is _dailyMintable
629     /// _importData[6] is _burnSequence, _importData[7] is _dailyAuctionStartTime
630     /// @param _proof proof
631     /// @return true/false
632     function importMET(bytes8 _originChain, bytes8 _destinationChain, address[] _addresses, bytes _extraData, 
633         bytes32[] _burnHashes, uint[] _supplyOnAllChains, uint[] _importData, bytes _proof) public returns (bool)
634     {
635         require(address(tokenPorter) != 0x0);
636         return tokenPorter.importMET(_originChain, _destinationChain, _addresses, _extraData, 
637         _burnHashes, _supplyOnAllChains, _importData, _proof);
638     }
639 
640     /// @notice export MET tokens from this chain to another chain.
641     /// @param _destChain destination chain address
642     /// @param _destMetronomeAddr address of Metronome contract on the destination chain 
643     /// where this MET will be imported.
644     /// @param _destRecipAddr address of account on destination chain
645     /// @param _amount amount
646     /// @param _extraData extra information for future expansion
647     /// @return true/false
648     function export(bytes8 _destChain, address _destMetronomeAddr, address _destRecipAddr, uint _amount, uint _fee, 
649     bytes _extraData) public returns (bool)
650     {
651         require(address(tokenPorter) != 0x0);
652         return tokenPorter.export(msg.sender, _destChain, _destMetronomeAddr,
653         _destRecipAddr, _amount, _fee, _extraData);
654     }
655 
656     struct Sub {
657         uint startTime;      
658         uint payPerWeek; 
659         uint lastWithdrawTime;
660     }
661 
662     event LogSubscription(address indexed subscriber, address indexed subscribesTo);
663     event LogCancelSubscription(address indexed subscriber, address indexed subscribesTo);
664 
665     mapping (address => mapping (address => Sub)) public subs;
666 
667     /// @notice subscribe for a weekly recurring payment 
668     /// @param _startTime Subscription start time.
669     /// @param _payPerWeek weekly payment
670     /// @param _recipient address of beneficiary
671     /// @return true/false
672     function subscribe(uint _startTime, uint _payPerWeek, address _recipient) public returns (bool) {
673         require(_startTime >= block.timestamp);
674         require(_payPerWeek != 0);
675         require(_recipient != 0);
676 
677         subs[msg.sender][_recipient] = Sub(_startTime, _payPerWeek, _startTime);  
678         
679         emit LogSubscription(msg.sender, _recipient);
680         return true;
681     }
682 
683     /// @notice cancel a subcription. 
684     /// @param _recipient address of beneficiary
685     /// @return true/false
686     function cancelSubscription(address _recipient) public returns (bool) {
687         require(subs[msg.sender][_recipient].startTime != 0);
688         require(subs[msg.sender][_recipient].payPerWeek != 0);
689 
690         subs[msg.sender][_recipient].startTime = 0;
691         subs[msg.sender][_recipient].payPerWeek = 0;
692         subs[msg.sender][_recipient].lastWithdrawTime = 0;
693 
694         emit LogCancelSubscription(msg.sender, _recipient);
695         return true;
696     }
697 
698     /// @notice get subcription details
699     /// @param _owner ..
700     /// @param _recipient ..
701     /// @return startTime, payPerWeek, lastWithdrawTime
702     function getSubscription(address _owner, address _recipient) public constant
703         returns (uint startTime, uint payPerWeek, uint lastWithdrawTime) 
704     {
705         Sub storage sub = subs[_owner][_recipient];
706         return (
707             sub.startTime,
708             sub.payPerWeek,
709             sub.lastWithdrawTime
710         );
711     }
712 
713     /// @notice caller can withdraw the token from subscribers.
714     /// @param _owner subcriber
715     /// @return true/false
716     function subWithdraw(address _owner) public transferable returns (bool) {
717         require(subWithdrawFor(_owner, msg.sender));
718         return true;
719     }
720 
721     /// @notice Allow callers to withdraw token in one go from all of its subscribers
722     /// @param _owners array of address of subscribers
723     /// @return number of successful transfer done
724     function multiSubWithdraw(address[] _owners) public returns (uint) {
725         uint n = 0;
726         for (uint i=0; i < _owners.length; i++) {
727             if (subWithdrawFor(_owners[i], msg.sender)) {
728                 n++;
729             } 
730         }
731         return n;
732     }
733 
734     /// @notice Trigger MET token transfers for all pairs of subscribers and beneficiaries
735     /// @dev address at i index in owners and recipients array is subcriber-beneficiary pair.
736     /// @param _owners ..
737     /// @param _recipients .. 
738     /// @return number of successful transfer done
739     function multiSubWithdrawFor(address[] _owners, address[] _recipients) public returns (uint) {
740         // owners and recipients need 1-to-1 mapping, must be same length
741         require(_owners.length == _recipients.length);
742 
743         uint n = 0;
744         for (uint i = 0; i < _owners.length; i++) {
745             if (subWithdrawFor(_owners[i], _recipients[i])) {
746                 n++;
747             }
748         }
749 
750         return n;
751     }
752 
753     function subWithdrawFor(address _from, address _to) internal returns (bool) {
754         Sub storage sub = subs[_from][_to];
755         
756         if (sub.startTime > 0 && sub.startTime < block.timestamp && sub.payPerWeek > 0) {
757             uint weekElapsed = (now.sub(sub.lastWithdrawTime)).div(7 days);
758             uint amount = weekElapsed.mul(sub.payPerWeek);
759             if (weekElapsed > 0 && _balanceOf[_from] >= amount) {
760                 subs[_from][_to].lastWithdrawTime = block.timestamp;
761                 _balanceOf[_from] = _balanceOf[_from].sub(amount);
762                 _balanceOf[_to] = _balanceOf[_to].add(amount);
763                 emit Transfer(_from, _to, amount);
764                 return true;
765             }
766         }       
767         return false;
768     }
769 }
770 
771 
772 /// @title Autonomous Converter contract for MET <=> ETH exchange
773 contract AutonomousConverter is Formula, Owned {
774 
775     SmartToken public smartToken;
776     METToken public reserveToken;
777     Auctions public auctions;
778 
779     enum WhichToken { Eth, Met }
780     bool internal initialized = false;
781 
782     event LogFundsIn(address indexed from, uint value);
783     event ConvertEthToMet(address indexed from, uint eth, uint met);
784     event ConvertMetToEth(address indexed from, uint eth, uint met);
785 
786     function init(address _reserveToken, address _smartToken, address _auctions) 
787         public onlyOwner payable 
788     {
789         require(!initialized);
790         auctions = Auctions(_auctions);
791         reserveToken = METToken(_reserveToken);
792         smartToken = SmartToken(_smartToken);
793         initialized = true;
794     }
795 
796     function handleFund() public payable {
797         require(msg.sender == address(auctions.proceeds()));
798         emit LogFundsIn(msg.sender, msg.value);
799     }
800 
801     function getMetBalance() public view returns (uint) {
802         return balanceOf(WhichToken.Met);
803     }
804 
805     function getEthBalance() public view returns (uint) {
806         return balanceOf(WhichToken.Eth);
807     }
808 
809     /// @notice return the expected MET for ETH
810     /// @param _depositAmount ETH.
811     /// @return expected MET value for ETH
812     function getMetForEthResult(uint _depositAmount) public view returns (uint256) {
813         return convertingReturn(WhichToken.Eth, _depositAmount);
814     }
815 
816     /// @notice return the expected ETH for MET
817     /// @param _depositAmount MET.
818     /// @return expected ETH value for MET
819     function getEthForMetResult(uint _depositAmount) public view returns (uint256) {
820         return convertingReturn(WhichToken.Met, _depositAmount);
821     }
822 
823     /// @notice send ETH and get MET
824     /// @param _mintReturn execute conversion only if return is equal or more than _mintReturn
825     /// @return returnedMet MET retured after conversion
826     function convertEthToMet(uint _mintReturn) public payable returns (uint returnedMet) {
827         returnedMet = convert(WhichToken.Eth, _mintReturn, msg.value);
828         emit ConvertEthToMet(msg.sender, msg.value, returnedMet);
829     }
830 
831     /// @notice send MET and get ETH
832     /// @dev Caller will be required to approve the AutonomousConverter to initiate the transfer
833     /// @param _amount MET amount
834     /// @param _mintReturn execute conversion only if return is equal or more than _mintReturn
835     /// @return returnedEth ETh returned after conversion
836     function convertMetToEth(uint _amount, uint _mintReturn) public returns (uint returnedEth) {
837         returnedEth = convert(WhichToken.Met, _mintReturn, _amount);
838         emit ConvertMetToEth(msg.sender, returnedEth, _amount);
839     }
840 
841     function balanceOf(WhichToken which) internal view returns (uint) {
842         if (which == WhichToken.Eth) return address(this).balance;
843         if (which == WhichToken.Met) return reserveToken.balanceOf(this);
844         revert();
845     }
846 
847     function convertingReturn(WhichToken whichFrom, uint _depositAmount) internal view returns (uint256) {
848         
849         WhichToken to = WhichToken.Met;
850         if (whichFrom == WhichToken.Met) {
851             to = WhichToken.Eth;
852         }
853 
854         uint reserveTokenBalanceFrom = balanceOf(whichFrom).add(_depositAmount);
855         uint mintRet = returnForMint(smartToken.totalSupply(), _depositAmount, reserveTokenBalanceFrom);
856         
857         uint newSmartTokenSupply = smartToken.totalSupply().add(mintRet);
858         uint reserveTokenBalanceTo = balanceOf(to);
859         return returnForRedemption(
860             newSmartTokenSupply,
861             mintRet,
862             reserveTokenBalanceTo);
863     }
864 
865     function convert(WhichToken whichFrom, uint _minReturn, uint amnt) internal returns (uint) {
866         WhichToken to = WhichToken.Met;
867         if (whichFrom == WhichToken.Met) {
868             to = WhichToken.Eth;
869             require(reserveToken.transferFrom(msg.sender, this, amnt));
870         }
871 
872         uint mintRet = mint(whichFrom, amnt, 1);
873         
874         return redeem(to, mintRet, _minReturn);
875     }
876 
877     function mint(WhichToken which, uint _depositAmount, uint _minReturn) internal returns (uint256 amount) {
878         require(_minReturn > 0);
879 
880         amount = mintingReturn(which, _depositAmount);
881         require(amount >= _minReturn);
882         require(smartToken.mint(msg.sender, amount));
883     }
884 
885     function mintingReturn(WhichToken which, uint _depositAmount) internal view returns (uint256) {
886         uint256 smartTokenSupply = smartToken.totalSupply();
887         uint256 reserveBalance = balanceOf(which);
888         return returnForMint(smartTokenSupply, _depositAmount, reserveBalance);
889     }
890 
891     function redeem(WhichToken which, uint _amount, uint _minReturn) internal returns (uint redeemable) {
892         require(_amount <= smartToken.balanceOf(msg.sender));
893         require(_minReturn > 0);
894 
895         redeemable = redemptionReturn(which, _amount);
896         require(redeemable >= _minReturn);
897 
898         uint256 reserveBalance = balanceOf(which);
899         require(reserveBalance >= redeemable);
900 
901         uint256 tokenSupply = smartToken.totalSupply();
902         require(_amount < tokenSupply);
903 
904         smartToken.destroy(msg.sender, _amount);
905         if (which == WhichToken.Eth) {
906             msg.sender.transfer(redeemable);
907         } else {
908             require(reserveToken.transfer(msg.sender, redeemable));
909         }
910     }
911 
912     function redemptionReturn(WhichToken which, uint smartTokensSent) internal view returns (uint256) {
913         uint smartTokenSupply = smartToken.totalSupply();
914         uint reserveTokenBalance = balanceOf(which);
915         return returnForRedemption(
916             smartTokenSupply,
917             smartTokensSent,
918             reserveTokenBalance);
919     }
920 }
921 
922 
923 /// @title Proceeds contract
924 contract Proceeds is Owned {
925     using SafeMath for uint256;
926 
927     AutonomousConverter public autonomousConverter;
928     Auctions public auctions;
929     event LogProceedsIn(address indexed from, uint value); 
930     event LogClosedAuction(address indexed from, uint value);
931     uint latestAuctionClosed;
932 
933     function initProceeds(address _autonomousConverter, address _auctions) public onlyOwner {
934         require(address(auctions) == 0x0 && _auctions != 0x0);
935         require(address(autonomousConverter) == 0x0 && _autonomousConverter != 0x0);
936 
937         autonomousConverter = AutonomousConverter(_autonomousConverter);
938         auctions = Auctions(_auctions);
939     }
940 
941     function handleFund() public payable {
942         require(msg.sender == address(auctions));
943         emit LogProceedsIn(msg.sender, msg.value);
944     }
945 
946     /// @notice Forward 0.25% of total ETH balance of proceeds to AutonomousConverter contract
947     function closeAuction() public {
948         uint lastPurchaseTick = auctions.lastPurchaseTick();
949         uint currentAuction = auctions.currentAuction();
950         uint val = ((address(this).balance).mul(25)).div(10000); 
951         if (val > 0 && (currentAuction > auctions.whichAuction(lastPurchaseTick)) 
952             && (latestAuctionClosed < currentAuction)) {
953             latestAuctionClosed = currentAuction;
954             autonomousConverter.handleFund.value(val)();
955             emit LogClosedAuction(msg.sender, val);
956         }
957     }
958 }
959 
960 
961 /// @title Auction contract. Send ETH to the contract address and buy MET. 
962 contract Auctions is Pricer, Owned {
963 
964     using SafeMath for uint256;
965     METToken public token;
966     Proceeds public proceeds;
967     address[] public founders;
968     mapping(address => TokenLocker) public tokenLockers;
969     uint internal constant DAY_IN_SECONDS = 86400;
970     uint internal constant DAY_IN_MINUTES = 1440;
971     uint public genesisTime;
972     uint public lastPurchaseTick;
973     uint public lastPurchasePrice;
974     uint public constant INITIAL_GLOBAL_DAILY_SUPPLY = 2880 * METDECMULT;
975     uint public INITIAL_FOUNDER_SUPPLY = 1999999 * METDECMULT;
976     uint public INITIAL_AC_SUPPLY = 1 * METDECMULT;
977     uint public totalMigratedOut = 0;
978     uint public totalMigratedIn = 0;
979     uint public timeScale = 1;
980     uint public constant INITIAL_SUPPLY = 10000000 * METDECMULT;
981     uint public mintable = INITIAL_SUPPLY;
982     uint public initialAuctionDuration = 7 days;
983     uint public initialAuctionEndTime;
984     uint public dailyAuctionStartTime;
985     uint public constant DAILY_PURCHASE_LIMIT = 1000 ether;
986     mapping (address => uint) internal purchaseInTheAuction;
987     mapping (address => uint) internal lastPurchaseAuction;
988     bool public minted;
989     bool public initialized;
990     uint public globalSupplyAfterPercentageLogic = 52598080 * METDECMULT;
991     uint public constant AUCTION_WHEN_PERCENTAGE_LOGIC_STARTS = 14791;
992     bytes8 public chain = "ETH";
993     event LogAuctionFundsIn(address indexed sender, uint amount, uint tokens, uint purchasePrice, uint refund);
994 
995     constructor() public {
996         mintable = INITIAL_SUPPLY - 2000000 * METDECMULT;
997     }
998 
999     /// @notice Payable function to buy MET in descending price auction
1000     function () public payable running {
1001         require(msg.value > 0);
1002         
1003         uint amountForPurchase = msg.value;
1004         uint excessAmount;
1005 
1006         if (currentAuction() > whichAuction(lastPurchaseTick)) {
1007             proceeds.closeAuction();
1008             restartAuction();
1009         }
1010 
1011         if (isInitialAuctionEnded()) {
1012             require(now >= dailyAuctionStartTime);
1013             if (lastPurchaseAuction[msg.sender] < currentAuction()) {
1014                 if (amountForPurchase > DAILY_PURCHASE_LIMIT) {
1015                     excessAmount = amountForPurchase.sub(DAILY_PURCHASE_LIMIT);
1016                     amountForPurchase = DAILY_PURCHASE_LIMIT;
1017                 }           
1018                 purchaseInTheAuction[msg.sender] = msg.value;
1019                 lastPurchaseAuction[msg.sender] = currentAuction();
1020             } else {
1021                 require(purchaseInTheAuction[msg.sender] < DAILY_PURCHASE_LIMIT);
1022                 if (purchaseInTheAuction[msg.sender].add(amountForPurchase) > DAILY_PURCHASE_LIMIT) {
1023                     excessAmount = (purchaseInTheAuction[msg.sender].add(amountForPurchase)).sub(DAILY_PURCHASE_LIMIT);
1024                     amountForPurchase = amountForPurchase.sub(excessAmount);
1025                 }
1026                 purchaseInTheAuction[msg.sender] = purchaseInTheAuction[msg.sender].add(msg.value);
1027             }
1028         }
1029 
1030         uint _currentTick = currentTick();
1031 
1032         uint weiPerToken;
1033         uint tokens;
1034         uint refund;
1035         (weiPerToken, tokens, refund) = calcPurchase(amountForPurchase, _currentTick);
1036         require(tokens > 0);
1037 
1038         if (now < initialAuctionEndTime && (token.totalSupply()).add(tokens) >= INITIAL_SUPPLY) {
1039             initialAuctionEndTime = now;
1040             dailyAuctionStartTime = ((initialAuctionEndTime / 1 days) + 1) * 1 days;
1041         }
1042 
1043         lastPurchaseTick = _currentTick;
1044         lastPurchasePrice = weiPerToken;
1045 
1046         assert(tokens <= mintable);
1047         mintable = mintable.sub(tokens);
1048 
1049         assert(refund <= amountForPurchase);
1050         uint ethForProceeds = amountForPurchase.sub(refund);
1051 
1052         proceeds.handleFund.value(ethForProceeds)();
1053 
1054         require(token.mint(msg.sender, tokens));
1055 
1056         refund = refund.add(excessAmount);
1057         if (refund > 0) {
1058             if (purchaseInTheAuction[msg.sender] > 0) {
1059                 purchaseInTheAuction[msg.sender] = purchaseInTheAuction[msg.sender].sub(refund);
1060             }
1061             msg.sender.transfer(refund);
1062         }
1063         emit LogAuctionFundsIn(msg.sender, ethForProceeds, tokens, lastPurchasePrice, refund);
1064     }
1065 
1066     modifier running() {
1067         require(isRunning());
1068         _;
1069     }
1070 
1071     function isRunning() public constant returns (bool) {
1072         return (block.timestamp >= genesisTime && genesisTime > 0);
1073     }
1074 
1075     /// @notice current tick(minute) of the metronome clock
1076     /// @return tick count
1077     function currentTick() public view returns(uint) {
1078         return whichTick(block.timestamp);
1079     }
1080 
1081     /// @notice current auction
1082     /// @return auction count 
1083     function currentAuction() public view returns(uint) {
1084         return whichAuction(currentTick());
1085     }
1086 
1087     /// @notice tick count at the timestamp t. 
1088     /// @param t timestamp
1089     /// @return tick count
1090     function whichTick(uint t) public view returns(uint) {
1091         if (genesisTime > t) { 
1092             revert(); 
1093         }
1094         return (t - genesisTime) * timeScale / 1 minutes;
1095     }
1096 
1097     /// @notice Auction count at given the timestamp t
1098     /// @param t timestamp
1099     /// @return Auction count
1100     function whichAuction(uint t) public view returns(uint) {
1101         if (whichTick(dailyAuctionStartTime) > t) {
1102             return 0;
1103         } else {
1104             return ((t - whichTick(dailyAuctionStartTime)) / DAY_IN_MINUTES) + 1;
1105         }
1106     }
1107 
1108     /// @notice one single function telling everything about Metronome Auction
1109     function heartbeat() public view returns (
1110         bytes8 _chain,
1111         address auctionAddr,
1112         address convertAddr,
1113         address tokenAddr,
1114         uint minting,
1115         uint totalMET,
1116         uint proceedsBal,
1117         uint currTick,
1118         uint currAuction,
1119         uint nextAuctionGMT,
1120         uint genesisGMT,
1121         uint currentAuctionPrice,
1122         uint _dailyMintable,
1123         uint _lastPurchasePrice) {
1124         _chain = chain;
1125         convertAddr = proceeds.autonomousConverter();
1126         tokenAddr = token;
1127         auctionAddr = this;
1128         totalMET = token.totalSupply();
1129         proceedsBal = address(proceeds).balance;
1130 
1131         currTick = currentTick();
1132         currAuction = currentAuction();
1133         if (currAuction == 0) {
1134             nextAuctionGMT = dailyAuctionStartTime;
1135         } else {
1136             nextAuctionGMT = (currAuction * DAY_IN_SECONDS) / timeScale + dailyAuctionStartTime;
1137         }
1138         genesisGMT = genesisTime;
1139 
1140         currentAuctionPrice = currentPrice();
1141         _dailyMintable = dailyMintable();
1142         minting = currentMintable();
1143         _lastPurchasePrice = lastPurchasePrice;
1144     }
1145 
1146     /// @notice Initialize Auctions parameters
1147     /// @param _startTime The block.timestamp when first auction starts
1148     /// @param _minimumPrice Nobody can buy tokens for less than this price
1149     /// @param _startingPrice Start price of MET when first auction starts
1150     /// @param _timeScale time scale factor for auction. will be always 1 in live environment
1151     function initAuctions(uint _startTime, uint _minimumPrice, uint _startingPrice, uint _timeScale) 
1152         public onlyOwner returns (bool) 
1153     {
1154         require(minted);
1155         require(!initialized);
1156         require(_timeScale != 0);
1157         initPricer();
1158         if (_startTime > 0) { 
1159             genesisTime = (_startTime / (1 minutes)) * (1 minutes) + 60;
1160         } else {
1161             genesisTime = block.timestamp + 60 - (block.timestamp % 60);
1162         }
1163 
1164         initialAuctionEndTime = genesisTime + initialAuctionDuration;
1165 
1166         // if initialAuctionEndTime is midnight, then daily auction will start immediately
1167         // after initial auction.
1168         if (initialAuctionEndTime == (initialAuctionEndTime / 1 days) * 1 days) {
1169             dailyAuctionStartTime = initialAuctionEndTime;
1170         } else {
1171             dailyAuctionStartTime = ((initialAuctionEndTime / 1 days) + 1) * 1 days;
1172         }
1173 
1174         lastPurchaseTick = 0;
1175 
1176         if (_minimumPrice > 0) {
1177             minimumPrice = _minimumPrice;
1178         }
1179 
1180         timeScale = _timeScale;
1181 
1182         if (_startingPrice > 0) {
1183             lastPurchasePrice = _startingPrice * 1 ether;
1184         } else {
1185             lastPurchasePrice = 2 ether;
1186         }
1187 
1188         for (uint i = 0; i < founders.length; i++) {
1189             TokenLocker tokenLocker = tokenLockers[founders[i]];
1190             tokenLocker.lockTokenLocker();
1191         }
1192         
1193         initialized = true;
1194         return true;
1195     }
1196 
1197     function createTokenLocker(address _founder, address _token) public onlyOwner {
1198         require(_token != 0x0);
1199         require(_founder != 0x0);
1200         founders.push(_founder);
1201         TokenLocker tokenLocker = new TokenLocker(address(this), _token);
1202         tokenLockers[_founder] = tokenLocker;
1203         tokenLocker.changeOwnership(_founder);
1204     }
1205 
1206     /// @notice Mint initial supply for founder and move to token locker
1207     /// @param _founders Left 160 bits are the founder address and the right 96 bits are the token amount.
1208     /// @param _token MET token contract address
1209     /// @param _proceeds Address of Proceeds contract
1210     function mintInitialSupply(uint[] _founders, address _token, 
1211         address _proceeds, address _autonomousConverter) public onlyOwner returns (bool) 
1212     {
1213         require(!minted);
1214         require(_founders.length != 0);
1215         require(address(token) == 0x0 && _token != 0x0);
1216         require(address(proceeds) == 0x0 && _proceeds != 0x0);
1217         require(_autonomousConverter != 0x0);
1218 
1219         token = METToken(_token);
1220         proceeds = Proceeds(_proceeds);
1221 
1222         // _founders will be minted into individual token lockers
1223         uint foundersTotal;
1224         for (uint i = 0; i < _founders.length; i++) {
1225             address addr = address(_founders[i] >> 96);
1226             require(addr != 0x0);
1227             uint amount = _founders[i] & ((1 << 96) - 1);
1228             require(amount > 0);
1229             TokenLocker tokenLocker = tokenLockers[addr];
1230             require(token.mint(address(tokenLocker), amount));
1231             tokenLocker.deposit(addr, amount);
1232             foundersTotal = foundersTotal.add(amount);
1233         }
1234 
1235         // reconcile minted total for founders
1236         require(foundersTotal == INITIAL_FOUNDER_SUPPLY);
1237 
1238         // mint a small amount to the AC
1239         require(token.mint(_autonomousConverter, INITIAL_AC_SUPPLY));
1240 
1241         minted = true;
1242         return true;
1243     }
1244 
1245     /// @notice Suspend auction if not started yet
1246     function stopEverything() public onlyOwner {
1247         if (genesisTime < block.timestamp) {
1248             revert(); 
1249         }
1250         genesisTime = genesisTime + (60 * 60 * 24 * 365 * 1000); // 1000 years
1251         initialAuctionEndTime = genesisTime;
1252         dailyAuctionStartTime = genesisTime;
1253     }
1254 
1255     /// @notice Return information about initial auction status.
1256     function isInitialAuctionEnded() public view returns (bool) {
1257         return (initialAuctionEndTime != 0 && 
1258             (now >= initialAuctionEndTime || token.totalSupply() >= INITIAL_SUPPLY));
1259     }
1260 
1261     /// @notice Global MET supply
1262     function globalMetSupply() public view returns (uint) {
1263 
1264         uint currAuc = currentAuction();
1265         if (currAuc > AUCTION_WHEN_PERCENTAGE_LOGIC_STARTS) {
1266             return globalSupplyAfterPercentageLogic;
1267         } else {
1268             return INITIAL_SUPPLY.add(INITIAL_GLOBAL_DAILY_SUPPLY.mul(currAuc));
1269         }
1270     }
1271 
1272     /// @notice Global MET daily supply. Daily supply is greater of 1) 2880 2)2% of then outstanding supply per year.
1273     /// @dev 2% logic will kicks in at 14792th auction. 
1274     function globalDailySupply() public view returns (uint) {
1275         uint dailySupply = INITIAL_GLOBAL_DAILY_SUPPLY;
1276         uint thisAuction = currentAuction();
1277 
1278         if (thisAuction > AUCTION_WHEN_PERCENTAGE_LOGIC_STARTS) {
1279             uint lastAuctionPurchase = whichAuction(lastPurchaseTick);
1280             uint recentAuction = AUCTION_WHEN_PERCENTAGE_LOGIC_STARTS + 1;
1281             if (lastAuctionPurchase > recentAuction) {
1282                 recentAuction = lastAuctionPurchase;
1283             }
1284 
1285             uint totalAuctions = thisAuction - recentAuction;
1286             if (totalAuctions > 1) {
1287                 // derived formula to find close to accurate daily supply when some auction missed. 
1288                 uint factor = 36525 + ((totalAuctions - 1) * 2);
1289                 dailySupply = (globalSupplyAfterPercentageLogic.mul(2).mul(factor)).div(36525 ** 2);
1290 
1291             } else {
1292                 dailySupply = globalSupplyAfterPercentageLogic.mul(2).div(36525);
1293             }
1294 
1295             if (dailySupply < INITIAL_GLOBAL_DAILY_SUPPLY) {
1296                 dailySupply = INITIAL_GLOBAL_DAILY_SUPPLY; 
1297             }
1298         }
1299 
1300         return dailySupply;
1301     }
1302 
1303     /// @notice Current price of MET in current auction
1304     /// @return weiPerToken 
1305     function currentPrice() public constant returns (uint weiPerToken) {
1306         weiPerToken = calcPriceAt(currentTick());
1307     }
1308 
1309     /// @notice Daily mintable MET in current auction
1310     function dailyMintable() public constant returns (uint) {
1311         return nextAuctionSupply(0);
1312     }
1313 
1314     /// @notice Total tokens on this chain
1315     function tokensOnThisChain() public view returns (uint) {
1316         uint totalSupply = token.totalSupply();
1317         uint currMintable = currentMintable();
1318         return totalSupply.add(currMintable);
1319     }
1320 
1321     /// @notice Current mintable MET in auction
1322     function currentMintable() public view returns (uint) {
1323         uint currMintable = mintable;
1324         uint currAuction = currentAuction();
1325         uint totalAuctions = currAuction.sub(whichAuction(lastPurchaseTick));
1326         if (totalAuctions > 0) {
1327             currMintable = mintable.add(nextAuctionSupply(totalAuctions));
1328         }
1329         return currMintable;
1330     }
1331 
1332     /// @notice prepare auction when first import is done on a non ETH chain
1333     function prepareAuctionForNonOGChain() public {
1334         require(msg.sender == address(token.tokenPorter()) || msg.sender == address(token));
1335         require(token.totalSupply() == 0);
1336         require(chain != "ETH");
1337         lastPurchaseTick = currentTick();
1338     }
1339 
1340     /// @notice Find out what the results would be of a prospective purchase
1341     /// @param _wei Amount of wei the purchaser will pay
1342     /// @param _timestamp Prospective purchase timestamp
1343     /// @return weiPerToken expected MET token rate
1344     /// @return tokens Expected token for a prospective purchase
1345     /// @return refund Wei refund the purchaser will get if amount is excess and MET supply is less
1346     function whatWouldPurchaseDo(uint _wei, uint _timestamp) public constant
1347         returns (uint weiPerToken, uint tokens, uint refund)
1348     {
1349         weiPerToken = calcPriceAt(whichTick(_timestamp));
1350         uint calctokens = METDECMULT.mul(_wei).div(weiPerToken);
1351         tokens = calctokens;
1352         if (calctokens > mintable) {
1353             tokens = mintable;
1354             uint weiPaying = mintable.mul(weiPerToken).div(METDECMULT);
1355             refund = _wei.sub(weiPaying);
1356         }
1357     }
1358 
1359     /// @notice Return the information about the next auction
1360     /// @return _startTime Start time of next auction
1361     /// @return _startPrice Start price of MET in next auction
1362     /// @return _auctionTokens  MET supply in next auction
1363     function nextAuction() internal constant returns(uint _startTime, uint _startPrice, uint _auctionTokens) {
1364         if (block.timestamp < genesisTime) {
1365             _startTime = genesisTime;
1366             _startPrice = lastPurchasePrice;
1367             _auctionTokens = mintable;
1368             return;
1369         }
1370 
1371         uint recentAuction = whichAuction(lastPurchaseTick);
1372         uint currAuc = currentAuction();
1373         uint totalAuctions = currAuc - recentAuction;
1374         _startTime = dailyAuctionStartTime;
1375         if (currAuc > 1) {
1376             _startTime = auctionStartTime(currentTick());
1377         }
1378 
1379         _auctionTokens = nextAuctionSupply(totalAuctions);
1380 
1381         if (totalAuctions > 1) {
1382             _startPrice = lastPurchasePrice / 100 + 1;
1383         } else {
1384             if (mintable == 0 || totalAuctions == 0) {
1385                 // Sold out scenario or someone querying projected start price of next auction
1386                 _startPrice = (lastPurchasePrice * 2) + 1;   
1387             } else {
1388                 // Timed out and all tokens not sold.
1389                 if (currAuc == 1) {
1390                     // If initial auction timed out then price before start of new auction will touch floor price
1391                     _startPrice = minimumPrice * 2;
1392                 } else {
1393                     // Descending price till end of auction and then multiply by 2
1394                     uint tickWhenAuctionEnded = whichTick(_startTime);
1395                     uint numTick = 0;
1396                     if (tickWhenAuctionEnded > lastPurchaseTick) {
1397                         numTick = tickWhenAuctionEnded - lastPurchaseTick;
1398                     }
1399                     _startPrice = priceAt(lastPurchasePrice, numTick) * 2;
1400                 }
1401                 
1402                 
1403             }
1404         }
1405     }
1406 
1407     /// @notice Calculate results of a purchase
1408     /// @param _wei Amount of wei the purchaser will pay
1409     /// @param _t Prospective purchase tick
1410     /// @return weiPerToken expected MET token rate
1411     /// @return tokens Expected token for a prospective purchase
1412     /// @return refund Wei refund the purchaser will get if amount is excess and MET supply is less
1413     function calcPurchase(uint _wei, uint _t) internal view returns (uint weiPerToken, uint tokens, uint refund)
1414     {
1415         require(_t >= lastPurchaseTick);
1416         uint numTicks = _t - lastPurchaseTick;
1417         if (isInitialAuctionEnded()) {
1418             weiPerToken = priceAt(lastPurchasePrice, numTicks);
1419         } else {
1420             weiPerToken = priceAtInitialAuction(lastPurchasePrice, numTicks);
1421         }
1422 
1423         uint calctokens = METDECMULT.mul(_wei).div(weiPerToken);
1424         tokens = calctokens;
1425         if (calctokens > mintable) {
1426             tokens = mintable;
1427             uint ethPaying = mintable.mul(weiPerToken).div(METDECMULT);
1428             refund = _wei.sub(ethPaying);
1429         }
1430     }
1431 
1432     /// @notice MET supply for next Auction also considering  carry forward met.
1433     /// @param totalAuctionMissed auction count when no purchase done.
1434     function nextAuctionSupply(uint totalAuctionMissed) internal view returns (uint supply) {
1435         uint thisAuction = currentAuction();
1436         uint tokensHere = token.totalSupply().add(mintable);
1437         supply = INITIAL_GLOBAL_DAILY_SUPPLY;
1438         uint dailySupplyAtLastPurchase;
1439         if (thisAuction > AUCTION_WHEN_PERCENTAGE_LOGIC_STARTS) {
1440             supply = globalDailySupply();
1441             if (totalAuctionMissed > 1) {
1442                 dailySupplyAtLastPurchase = globalSupplyAfterPercentageLogic.mul(2).div(36525);
1443                 supply = dailySupplyAtLastPurchase.add(supply).mul(totalAuctionMissed).div(2);
1444             } 
1445             supply = (supply.mul(tokensHere)).div(globalSupplyAfterPercentageLogic);
1446         } else {
1447             if (totalAuctionMissed > 1) {
1448                 supply = supply.mul(totalAuctionMissed);
1449             }
1450             uint previousGlobalMetSupply = 
1451             INITIAL_SUPPLY.add(INITIAL_GLOBAL_DAILY_SUPPLY.mul(whichAuction(lastPurchaseTick)));
1452             supply = (supply.mul(tokensHere)).div(previousGlobalMetSupply);
1453         
1454         }
1455     }
1456 
1457     /// @notice price at a number of minutes out in Initial auction and daily auction
1458     /// @param _tick Metronome tick
1459     /// @return weiPerToken
1460     function calcPriceAt(uint _tick) internal constant returns (uint weiPerToken) {
1461         uint recentAuction = whichAuction(lastPurchaseTick);
1462         uint totalAuctions = whichAuction(_tick).sub(recentAuction);
1463         uint prevPrice;
1464 
1465         uint numTicks = 0;
1466 
1467         // Auction is sold out and metronome clock is in same auction
1468         if (mintable == 0 && totalAuctions == 0) {
1469             return lastPurchasePrice;
1470         }
1471 
1472         // Metronome has missed one auction ie no purchase in last auction
1473         if (totalAuctions > 1) {
1474             prevPrice = lastPurchasePrice / 100 + 1;
1475             numTicks = numTicksSinceAuctionStart(_tick);
1476         } else if (totalAuctions == 1) {
1477             // Metronome clock is in new auction, next auction
1478             // previous auction sold out
1479             if (mintable == 0) {
1480                 prevPrice = lastPurchasePrice * 2;
1481             } else {
1482                 // previous auctions timed out
1483                 // first daily auction
1484                 if (whichAuction(_tick) == 1) {
1485                     prevPrice = minimumPrice * 2;
1486                 } else {
1487                     prevPrice = priceAt(lastPurchasePrice, numTicksTillAuctionStart(_tick)) * 2;
1488                 }
1489             }
1490             numTicks = numTicksSinceAuctionStart(_tick);
1491         } else {
1492             //Auction is running
1493             prevPrice = lastPurchasePrice;
1494             numTicks = _tick - lastPurchaseTick;
1495         }
1496 
1497         require(numTicks >= 0);
1498 
1499         if (isInitialAuctionEnded()) {
1500             weiPerToken = priceAt(prevPrice, numTicks);
1501         } else {
1502             weiPerToken = priceAtInitialAuction(prevPrice, numTicks);
1503         }
1504     }
1505 
1506     /// @notice Calculate number of ticks elapsed between auction start time and given tick.
1507     /// @param _tick Given metronome tick
1508     function numTicksSinceAuctionStart(uint _tick) private view returns (uint ) {
1509         uint currentAuctionStartTime = auctionStartTime(_tick);
1510         return _tick - whichTick(currentAuctionStartTime);
1511     }
1512     
1513     /// @notice Calculate number of ticks elapsed between lastPurchaseTick and auctions start time of given tick.
1514     /// @param _tick Given metronome tick
1515     function numTicksTillAuctionStart(uint _tick) private view returns (uint) {
1516         uint currentAuctionStartTime = auctionStartTime(_tick);
1517         return whichTick(currentAuctionStartTime) - lastPurchaseTick;
1518     }
1519 
1520     /// @notice First calculate the auction which contains the given tick and then calculate
1521     /// auction start time of given tick.
1522     /// @param _tick Metronome tick
1523     function auctionStartTime(uint _tick) private view returns (uint) {
1524         return ((whichAuction(_tick)) * 1 days) / timeScale + dailyAuctionStartTime - 1 days;
1525     }
1526 
1527     /// @notice start the next day's auction
1528     function restartAuction() private {
1529         uint time;
1530         uint price;
1531         uint auctionTokens;
1532         (time, price, auctionTokens) = nextAuction();
1533 
1534         uint thisAuction = currentAuction();
1535         if (thisAuction > AUCTION_WHEN_PERCENTAGE_LOGIC_STARTS) {
1536             globalSupplyAfterPercentageLogic = globalSupplyAfterPercentageLogic.add(globalDailySupply());
1537         }
1538 
1539         mintable = mintable.add(auctionTokens);
1540         lastPurchasePrice = price;
1541         lastPurchaseTick = whichTick(time);
1542     }
1543 }
1544 
1545 
1546 /// @title This contract serves as a locker for a founder's tokens
1547 contract TokenLocker is Ownable {
1548     using SafeMath for uint;
1549     uint internal constant QUARTER = 91 days + 450 minutes;
1550   
1551     Auctions public auctions;
1552     METToken public token;
1553     bool public locked = false;
1554   
1555     uint public deposited;
1556     uint public lastWithdrawTime;
1557     uint public quarterlyWithdrawable;
1558     
1559     event Withdrawn(address indexed who, uint amount);
1560     event Deposited(address indexed who, uint amount);
1561 
1562     modifier onlyAuction() {
1563         require(msg.sender == address(auctions));
1564         _;
1565     }
1566 
1567     modifier preLock() { 
1568         require(!locked);
1569         _; 
1570     }
1571 
1572     modifier postLock() { 
1573         require(locked); 
1574         _; 
1575     }
1576 
1577     /// @notice Constructor to initialize TokenLocker contract.
1578     /// @param _auctions Address of auctions contract
1579     /// @param _token Address of METToken contract
1580     constructor(address _auctions, address _token) public {
1581         require(_auctions != 0x0);
1582         require(_token != 0x0);
1583         auctions = Auctions(_auctions);
1584         token = METToken(_token);
1585     }
1586 
1587     /// @notice If auctions is initialized, call to this function will result in
1588     /// locking of deposited tokens and further deposit of tokens will not be allowed.
1589     function lockTokenLocker() public onlyAuction {
1590         require(auctions.initialAuctionEndTime() != 0);
1591         require(auctions.initialAuctionEndTime() >= auctions.genesisTime()); 
1592         locked = true;
1593     }
1594 
1595     /// @notice It will deposit tokens into the locker for given beneficiary.
1596     /// @param beneficiary Address of the beneficiary, whose tokens are being locked.
1597     /// @param amount Amount of tokens being locked
1598     function deposit (address beneficiary, uint amount ) public onlyAuction preLock {
1599         uint totalBalance = token.balanceOf(this);
1600         require(totalBalance.sub(deposited) >= amount);
1601         deposited = deposited.add(amount);
1602         emit Deposited(beneficiary, amount);
1603     }
1604 
1605     /// @notice This function will allow token withdraw from locker.
1606     /// 25% of total deposited tokens can be withdrawn after initial auction end.
1607     /// Remaining 75% can be withdrawn in equal amount over 12 quarters.
1608     function withdraw() public onlyOwner postLock {
1609         require(deposited > 0);
1610         uint withdrawable = 0; 
1611         uint withdrawTime = auctions.initialAuctionEndTime();
1612         if (lastWithdrawTime == 0 && auctions.isInitialAuctionEnded()) {
1613             withdrawable = withdrawable.add((deposited.mul(25)).div(100));
1614             quarterlyWithdrawable = (deposited.sub(withdrawable)).div(12);
1615             lastWithdrawTime = withdrawTime;
1616         }
1617 
1618         require(lastWithdrawTime != 0);
1619 
1620         if (now >= lastWithdrawTime.add(QUARTER)) {
1621             uint daysSinceLastWithdraw = now.sub(lastWithdrawTime);
1622             uint totalQuarters = daysSinceLastWithdraw.div(QUARTER);
1623 
1624             require(totalQuarters > 0);
1625         
1626             withdrawable = withdrawable.add(quarterlyWithdrawable.mul(totalQuarters));
1627 
1628             if (now >= withdrawTime.add(QUARTER.mul(12))) {
1629                 withdrawable = deposited;
1630             }
1631 
1632             lastWithdrawTime = lastWithdrawTime.add(totalQuarters.mul(QUARTER));
1633         }
1634 
1635         if (withdrawable > 0) {
1636             deposited = deposited.sub(withdrawable);
1637             token.transfer(msg.sender, withdrawable);
1638             emit Withdrawn(msg.sender, withdrawable);
1639         }
1640     }
1641 }
1642 
1643 
1644 /// @title Interface for TokenPorter contract.
1645 /// Define events and functions for TokenPorter contract
1646 interface ITokenPorter {
1647     event ExportOnChainClaimedReceiptLog(address indexed destinationMetronomeAddr, 
1648         address indexed destinationRecipientAddr, uint amount);
1649 
1650     event ExportReceiptLog(bytes8 destinationChain, address destinationMetronomeAddr,
1651         address indexed destinationRecipientAddr, uint amountToBurn, uint fee, bytes extraData, uint currentTick,
1652         uint indexed burnSequence, bytes32 indexed currentBurnHash, bytes32 prevBurnHash, uint dailyMintable,
1653         uint[] supplyOnAllChains, uint genesisTime, uint blockTimestamp, uint dailyAuctionStartTime);
1654 
1655     event ImportReceiptLog(address indexed destinationRecipientAddr, uint amountImported, 
1656         uint fee, bytes extraData, uint currentTick, uint indexed importSequence, 
1657         bytes32 indexed currentHash, bytes32 prevHash, uint dailyMintable, uint blockTimestamp, address caller);
1658 
1659     function export(address tokenOwner, bytes8 _destChain, address _destMetronomeAddr, 
1660         address _destRecipAddr, uint _amount, uint _fee, bytes _extraData) public returns (bool);
1661     
1662     function importMET(bytes8 _originChain, bytes8 _destinationChain, address[] _addresses, bytes _extraData, 
1663         bytes32[] _burnHashes, uint[] _supplyOnAllChains, uint[] _importData, bytes _proof) public returns (bool);
1664 
1665 }
1666 
1667 
1668 /// @title This contract will provide export functionality for tokens.
1669 contract TokenPorter is ITokenPorter, Owned {
1670     using SafeMath for uint;
1671     Auctions public auctions;
1672     METToken public token;
1673     Validator public validator;
1674 
1675     uint public burnSequence = 1;
1676     uint public importSequence = 1;
1677     uint public chainHopStartTime = now + (2*60*60*24);
1678     // This is flat fee and must be in 18 decimal value
1679     uint public minimumExportFee = 1 * (10 ** 12);
1680     // export fee per 10,000 MET. 1 means 0.01% or 1 met as fee for export of 10,000 met
1681     uint public exportFee = 50;
1682     bytes32[] public exportedBurns;
1683     uint[] public supplyOnAllChains = new uint[](6);
1684     mapping (bytes32 => bytes32) public merkleRoots;
1685     mapping (bytes32 => bytes32) public mintHashes;
1686     // store burn hashes and burnSequence to find burn hash exist or not. 
1687     // Burn sequence may be used to find chain of burn hashes
1688     mapping (bytes32 => uint) public burnHashes;
1689     /// @notice mapping that tracks valid destination chains for export
1690     mapping(bytes8 => address) public destinationChains;
1691 
1692     event LogExportReceipt(bytes8 destinationChain, address destinationMetronomeAddr,
1693         address indexed destinationRecipientAddr, uint amountToBurn, uint fee, bytes extraData, uint currentTick,
1694         uint burnSequence, bytes32 indexed currentBurnHash, bytes32 prevBurnHash, uint dailyMintable,
1695         uint[] supplyOnAllChains, uint blockTimestamp, address indexed exporter);
1696 
1697     event LogImportRequest(bytes8 originChain, bytes32 indexed currentBurnHash, bytes32 prevHash,
1698         address indexed destinationRecipientAddr, uint amountToImport, uint fee, uint exportTimeStamp,
1699         uint burnSequence, bytes extraData);
1700     
1701     event LogImport(bytes8 originChain, address indexed destinationRecipientAddr, uint amountImported, uint fee,
1702     bytes extraData, uint indexed importSequence, bytes32 indexed currentHash);
1703     
1704     /// @notice Initialize TokenPorter contract.
1705     /// @param _tokenAddr Address of metToken contract
1706     /// @param _auctionsAddr Address of auctions contract
1707     function initTokenPorter(address _tokenAddr, address _auctionsAddr) public onlyOwner {
1708         require(_tokenAddr != 0x0);
1709         require(_auctionsAddr != 0x0);
1710         auctions = Auctions(_auctionsAddr);
1711         token = METToken(_tokenAddr);
1712     }
1713 
1714     /// @notice set minimum export fee. Minimum flat fee applicable for export-import 
1715     /// @param _minimumExportFee minimum export fee
1716     function setMinimumExportFee(uint _minimumExportFee) public onlyOwner returns (bool) {
1717         require(_minimumExportFee > 0);
1718         minimumExportFee = _minimumExportFee;
1719         return true;
1720     }
1721 
1722     /// @notice set export fee in percentage. 
1723     /// @param _exportFee fee amount per 10,000 met
1724     function setExportFeePerTenThousand(uint _exportFee) public onlyOwner returns (bool) {
1725         exportFee = _exportFee;
1726         return true;
1727     }
1728 
1729     /// @notice set chain hop start time. Also, useful if owner want to suspend chain hop 
1730     // until given time in case anything goes wrong
1731     /// @param _startTime fee amount per 10,000 met
1732     function setChainHopStartTime(uint _startTime) public onlyOwner returns (bool) {
1733         require(_startTime >= block.timestamp);
1734         chainHopStartTime = _startTime;
1735         return true;
1736     }
1737 
1738     /// @notice set address of validator contract
1739     /// @param _validator address of validator contract
1740     function setValidator(address _validator) public onlyOwner returns (bool) {
1741         require(_validator != 0x0);
1742         validator = Validator(_validator);
1743         return true;
1744     }
1745 
1746     /// @notice only owner can add destination chains
1747     /// @param _chainName string of destination blockchain name
1748     /// @param _contractAddress address of destination MET token to import to
1749     function addDestinationChain(bytes8 _chainName, address _contractAddress) public onlyOwner returns (bool) {
1750         require(_chainName != 0 && _contractAddress != address(0));
1751         destinationChains[_chainName] = _contractAddress;
1752         return true;
1753     }
1754 
1755     /// @notice only owner can remove destination chains
1756     /// @param _chainName string of destination blockchain name
1757     function removeDestinationChain(bytes8 _chainName) public onlyOwner returns (bool) {
1758         require(_chainName != 0);
1759         require(destinationChains[_chainName] != address(0));
1760         destinationChains[_chainName] = address(0);
1761         return true;   
1762     }
1763 
1764     /// @notice holds claims from users that have exported on-chain
1765     /// @param key is address of destination MET token contract
1766     /// @param subKey is address of users account that burned their original MET token
1767     mapping (address  => mapping(address => uint)) public claimables;
1768 
1769     /// @notice destination MET token contract calls claimReceivables to record burned 
1770     /// tokens have been minted in new chain 
1771     /// @param recipients array of addresses of each user that has exported from
1772     /// original chain.  These can be generated by LogExportReceipt
1773     function claimReceivables(address[] recipients) public returns (uint) {
1774         require(recipients.length > 0);
1775 
1776         uint total;
1777         for (uint i = 0; i < recipients.length; i++) {
1778             address recipient = recipients[i];
1779             uint amountBurned = claimables[msg.sender][recipient];
1780             if (amountBurned > 0) {
1781                 claimables[msg.sender][recipient] = 0;
1782                 emit ExportOnChainClaimedReceiptLog(msg.sender, recipient, amountBurned);
1783                 total = total.add(1);
1784             }
1785         }
1786         return total;
1787     }
1788 
1789     /// @notice Request for import MET tokens from another chain to this chain. 
1790     /// Minting will be done once off chain validators validate import request.
1791     /// @param _originChain source chain name
1792     /// @param _destinationChain destination chain name
1793     /// @param _addresses _addresses[0] is destMetronomeAddr and _addresses[1] is recipientAddr
1794     /// @param _extraData extra information for import
1795     /// @param _burnHashes _burnHashes[0] is previous burnHash, _burnHashes[1] is current burnHash
1796     /// @param _supplyOnAllChains MET supply on all supported chains
1797     /// @param _importData _importData[0] is _blockTimestamp, _importData[1] is _amount, _importData[2] is _fee
1798     /// _importData[3] is _burnedAtTick, _importData[4] is _genesisTime, _importData[5] is _dailyMintable
1799     /// _importData[6] is _burnSequence, _importData[7] is _dailyAuctionStartTime
1800     /// @param _proof merkle root
1801     /// @return true/false
1802     function importMET(bytes8 _originChain, bytes8 _destinationChain, address[] _addresses, bytes _extraData, 
1803         bytes32[] _burnHashes, uint[] _supplyOnAllChains, uint[] _importData, bytes _proof) public returns (bool)
1804     {
1805         
1806         require(msg.sender == address(token));
1807         require(now >= chainHopStartTime);
1808         require(_importData.length == 8);
1809         require(_addresses.length == 2);
1810         require(_burnHashes.length == 2);
1811         require(!validator.hashClaimed(_burnHashes[1]));
1812         require(isReceiptValid(_originChain, _destinationChain, _addresses, _extraData, _burnHashes, 
1813         _supplyOnAllChains, _importData));
1814         require(_destinationChain == auctions.chain());
1815         require(_addresses[0] == address(token));
1816         require(_importData[1] != 0);
1817         
1818         // We do not want to change already deployed interface, hence accepting '_proof' 
1819         // as bytes and converting into bytes32. Here _proof is merkle root.
1820         merkleRoots[_burnHashes[1]] = bytesToBytes32(_proof);
1821 
1822         // mint hash is used for further validation before minting and after attestation by off chain validators. 
1823         mintHashes[_burnHashes[1]] = keccak256(abi.encodePacked(_originChain, 
1824         _addresses[1], _importData[1], _importData[2]));
1825         
1826         emit LogImportRequest(_originChain, _burnHashes[1], _burnHashes[0], _addresses[1], _importData[1],
1827             _importData[2], _importData[0], _importData[6], _extraData);
1828         return true;
1829     }
1830 
1831     /// @notice Export MET tokens from this chain to another chain.
1832     /// @param tokenOwner Owner of the token, whose tokens are being exported.
1833     /// @param _destChain Destination chain for exported tokens
1834     /// @param _destMetronomeAddr Metronome address on destination chain
1835     /// @param _destRecipAddr Recipient address on the destination chain
1836     /// @param _amount Amount of token being exported
1837     /// @param _extraData Extra data for this export
1838     /// @return boolean true/false based on the outcome of export
1839     function export(address tokenOwner, bytes8 _destChain, address _destMetronomeAddr,
1840         address _destRecipAddr, uint _amount, uint _fee, bytes _extraData) public returns (bool) {
1841         require(msg.sender == address(token));
1842         require(now >= chainHopStartTime);
1843         require(_destChain != 0x0 && _destMetronomeAddr != 0x0 && _destRecipAddr != 0x0 && _amount != 0);
1844         require(destinationChains[_destChain] == _destMetronomeAddr);
1845         
1846         require(token.balanceOf(tokenOwner) >= _amount.add(_fee));
1847         require(_fee >= minimumExportFee && _fee >= (_amount.mul(exportFee).div(10000)));
1848         token.destroy(tokenOwner, _amount.add(_fee));
1849 
1850         uint dailyMintable = auctions.dailyMintable();
1851         uint currentTick = auctions.currentTick();
1852        
1853        
1854         if (burnSequence == 1) {
1855             exportedBurns.push(keccak256(abi.encodePacked(uint8(0))));
1856         }
1857 
1858         if (_destChain == auctions.chain()) {
1859             claimables[_destMetronomeAddr][_destRecipAddr] = 
1860                 claimables[_destMetronomeAddr][_destRecipAddr].add(_amount);
1861         }
1862         uint blockTime = block.timestamp;
1863         bytes32 currentBurn = keccak256(abi.encodePacked(
1864             blockTime, 
1865             auctions.chain(),
1866             _destChain, 
1867             _destMetronomeAddr, 
1868             _destRecipAddr, 
1869             _amount,
1870             _fee,
1871             currentTick,
1872             auctions.genesisTime(),
1873             dailyMintable,
1874             _extraData,
1875             exportedBurns[burnSequence - 1]));
1876        
1877         exportedBurns.push(currentBurn);
1878         burnHashes[currentBurn] = burnSequence;
1879         supplyOnAllChains[0] = token.totalSupply();
1880         
1881         emit LogExportReceipt(_destChain, _destMetronomeAddr, _destRecipAddr, _amount, _fee, _extraData, 
1882             currentTick, burnSequence, currentBurn, exportedBurns[burnSequence - 1], dailyMintable,
1883             supplyOnAllChains, blockTime, tokenOwner);
1884 
1885         burnSequence = burnSequence + 1;
1886         return true;
1887     }
1888 
1889     /// @notice mintToken will be called by validator contract only and that too only after hash attestation.
1890     /// @param originChain origin chain from where these token burnt.
1891     /// @param recipientAddress tokens will be minted for this address.
1892     /// @param amount amount being imported/minted
1893     /// @param fee fee paid during export
1894     /// @param extraData any extra data related to export-import process.
1895     /// @param currentHash current export hash from source/origin chain.
1896     /// @param validators validators
1897     /// @return true/false indicating minting was successful or not
1898     function mintToken(bytes8 originChain, address recipientAddress, uint amount, 
1899         uint fee, bytes extraData, bytes32 currentHash, uint globalSupplyInOtherChains, 
1900         address[] validators) public returns (bool) {
1901         require(msg.sender == address(validator));
1902         require(originChain != 0x0);
1903         require(recipientAddress != 0x0);
1904         require(amount > 0);
1905         require(currentHash != 0x0);
1906 
1907         //Validate that mint data is same as the data received during import request.
1908         require(mintHashes[currentHash] == keccak256(abi.encodePacked(originChain, recipientAddress, amount, fee)));
1909 
1910         require(isGlobalSupplyValid(amount, fee, globalSupplyInOtherChains));
1911         
1912         if (importSequence == 1 && token.totalSupply() == 0) {
1913             auctions.prepareAuctionForNonOGChain();
1914         }
1915         
1916         require(token.mint(recipientAddress, amount));
1917         // fee amount has already been validated during export and its part of burn hash
1918         // so we may not need to calculate it again.
1919         uint feeToDistribute =  fee.div(validators.length);
1920         for (uint i = 0; i < validators.length; i++) {
1921             token.mint(validators[i], feeToDistribute);
1922         }
1923         emit LogImport(originChain, recipientAddress, amount, fee, extraData, importSequence, currentHash);
1924         importSequence++;
1925         return true;
1926     }
1927 
1928     /// @notice Convert bytes to bytes32
1929     function bytesToBytes32(bytes b) private pure returns (bytes32) {
1930         bytes32 out;
1931 
1932         for (uint i = 0; i < 32; i++) {
1933             out |= bytes32(b[i] & 0xFF) >> (i * 8);
1934         }
1935         return out;
1936     }
1937 
1938     /// @notice Check global supply is still valid with current import amount and fee
1939     function isGlobalSupplyValid(uint amount, uint fee, uint globalSupplyInOtherChains) private view returns (bool) {
1940         uint amountToImport = amount.add(fee);
1941         uint currentGlobalSupply = globalSupplyInOtherChains.add(token.totalSupply());
1942         return (amountToImport.add(currentGlobalSupply) <= auctions.globalMetSupply());
1943     }
1944 
1945     /// @notice validate the export receipt
1946     function isReceiptValid(bytes8 _originChain, bytes8 _destinationChain, address[] _addresses, bytes _extraData, 
1947         bytes32[] _burnHashes, uint[] _supplyOnAllChain, uint[] _importData) private pure returns(bool) {
1948 
1949         // Due to stack too deep error and limitation in using number of local 
1950         // variables we had to use array here.
1951         // _importData[0] is _blockTimestamp, _importData[1] is _amount, _importData[2] is _fee,
1952         // _importData[3] is _burnedAtTick, _importData[4] is _genesisTime,
1953         // _importData[5] is _dailyMintable, _importData[6] is _burnSequence,
1954         // _addresses[0] is _destMetronomeAddr and _addresses[1] is _recipAddr
1955         // _burnHashes[0] is previous burnHash, _burnHashes[1] is current burnHash
1956 
1957         if (_burnHashes[1] == keccak256(abi.encodePacked(_importData[0], _originChain,
1958             _destinationChain, _addresses[0], _addresses[1], _importData[1], _importData[2], 
1959             _importData[3], _importData[4], _importData[5], _extraData, _burnHashes[0]))) {
1960             return true;
1961         }
1962         
1963         return false;
1964     }
1965 }    
1966 
1967 
1968 /// @title Proposals intiated by validators.  
1969 contract Proposals is Owned {
1970     uint public votingPeriod = 60 * 60 * 24 * 15;
1971 
1972     Validator public validator;
1973     mapping (address => uint) public valProposals;
1974 
1975     bytes32[] public actions;
1976     
1977     struct Proposal {
1978         uint proposalId;
1979         bytes32 action;
1980         uint expiry;
1981         address validator;
1982         uint newThreshold;
1983         uint supportCount;
1984         address[] voters;
1985         bool passed;
1986         mapping (address => bool) voted;
1987 
1988     }
1989 
1990     Proposal[] public proposals;
1991 
1992     event LogVoted(uint indexed proposalId, address indexed voter, bool support);
1993 
1994     event LogProposalCreated(uint indexed proposalId, address indexed newValidator, 
1995         uint newThreshold, address creator, uint expiry, bytes32 indexed action);
1996 
1997     event LogProposalClosed(uint indexed proposalId, address indexed newValidator, 
1998         uint newThreshold, bytes32 indexed action, uint expiry, uint supportCount, bool passed);
1999 
2000     /// @dev Throws if called by any account other than the validator.
2001     modifier onlyValidator() {
2002         require(validator.isValidator(msg.sender));
2003         _;
2004     }
2005 
2006     constructor() public {
2007         actions.push("addval");
2008         actions.push("removeval");
2009         actions.push("updatethreshold");
2010     }
2011 
2012     /// @notice set address of validator contract
2013     /// @param _validator address of validator contract
2014     function setValidator(address _validator) public onlyOwner returns (bool) {
2015         require(_validator != 0x0);
2016         validator = Validator(_validator);
2017         return true;
2018     }
2019 
2020     /// @notice set update voting period
2021     /// @param _t voting period
2022     function updateVotingPeriod(uint _t) public onlyOwner returns (bool) {
2023         require(_t != 0);
2024         votingPeriod = _t;
2025         return true;
2026     }
2027 
2028     /// @notice validator can initiate proposal for add new validator.
2029     /// @param _validator new validator address
2030     /// @param _newThreshold new threshold value. 0 if do not want to update it
2031     function proposeNewValidator(address _validator, uint _newThreshold) public onlyValidator returns (uint) {
2032         require(_validator != 0x0);
2033         require(!validator.isValidator(_validator));
2034         if (_newThreshold > 0) {
2035             uint valCount = validator.getValidatorsCount();
2036             require(validator.isNewThresholdValid(valCount + 1, _newThreshold));
2037         }
2038         return createNewProposal(_validator, msg.sender, actions[0], _newThreshold);
2039     }
2040 
2041     /// @notice validator can initiate proposal to remove bad actor or idle validators.
2042     /// validators can be removed if support count >= threshold or  support count == voting count.
2043     /// Later approach is to remove idle validator from system. 
2044     /// @param _validator new validator address
2045     /// @param _newThreshold new threshold value. 0 if do not want to update it
2046     function proposeRemoveValidator(address _validator, uint _newThreshold) public onlyValidator returns (uint) {
2047         require(_validator != 0x0);
2048         require(validator.isValidator(_validator));
2049         if (_newThreshold > 0) {
2050             uint valCount = validator.getValidatorsCount();
2051             require(validator.isNewThresholdValid(valCount - 1, _newThreshold));
2052         }
2053         return createNewProposal(_validator, msg.sender, actions[1], _newThreshold);
2054     }
2055 
2056     /// @notice validator can initiate proposal to update threshold value
2057     /// @param _newThreshold new threshold value. 0 if do not want to update it
2058     function proposeNewThreshold(uint _newThreshold) public onlyValidator returns (uint) {
2059         uint valCount = validator.getValidatorsCount();
2060         require(validator.isNewThresholdValid(valCount, _newThreshold));
2061         return createNewProposal(0x0, msg.sender, actions[2], _newThreshold);
2062     }
2063 
2064     /// @notice validator can vote for a proposal
2065     /// @param _proposalId ..
2066     /// @param _support true/false
2067     function voteForProposal(uint _proposalId, bool _support) public onlyValidator {
2068         require(proposals[_proposalId].expiry != 0);
2069         require(now < proposals[_proposalId].expiry);
2070         require(!proposals[_proposalId].passed);
2071         require(!(proposals[_proposalId]).voted[msg.sender]);
2072         proposals[_proposalId].voters.push(msg.sender);
2073         proposals[_proposalId].voted[msg.sender] = true;
2074         if (_support) {
2075             proposals[_proposalId].supportCount++;
2076         }
2077         emit LogVoted(_proposalId, msg.sender, _support);
2078     }
2079     
2080     /// @notice public function to close a proposal if expired or majority support received
2081     /// @param _proposalId ..
2082     function closeProposal(uint _proposalId) public {
2083         require(proposals[_proposalId].expiry != 0);
2084         if (proposals[_proposalId].supportCount >= validator.threshold()) {
2085             executeProposal(_proposalId, proposals[_proposalId].newThreshold);
2086         } else if (now > proposals[_proposalId].expiry) {
2087             // Proposal to remove idle validator if no one take objection
2088             if ((proposals[_proposalId].action == actions[1]) && 
2089                 (proposals[_proposalId].voters.length == proposals[_proposalId].supportCount)) {
2090                 executeProposal(_proposalId, proposals[_proposalId].newThreshold);
2091             }
2092         }   
2093     }
2094 
2095     /// @notice private function to update outcome of a proposal
2096     /// @param _proposalId ..
2097     /// @param _newThreshold ..
2098     function executeProposal(uint _proposalId, uint _newThreshold) private {
2099         if (proposals[_proposalId].action == actions[0]) {
2100             validator.addValidator(proposals[_proposalId].validator);
2101         } else if (proposals[_proposalId].action == actions[1]) {
2102             validator.removeValidator(proposals[_proposalId].validator);
2103         }
2104         if (_newThreshold != 0 && _newThreshold != validator.threshold()) {
2105             validator.updateThreshold(_newThreshold);
2106         }
2107         proposals[_proposalId].passed = true;
2108         emit LogProposalClosed(_proposalId, proposals[_proposalId].validator, 
2109             _newThreshold, proposals[_proposalId].action, proposals[_proposalId].expiry, 
2110             proposals[_proposalId].supportCount, true);
2111     }
2112 
2113     /// @notice private function to create a proposal
2114     /// @param _validator validator address
2115     /// @param _creator creator
2116     /// @param _action _action
2117     /// @param _newThreshold _newThreshold
2118     function createNewProposal(address _validator, address _creator, bytes32 _action, 
2119         uint _newThreshold) private returns (uint proposalId) {
2120         proposalId = proposals.length++;
2121         if (_validator != 0x0) {
2122             require((valProposals[_validator] == 0) || (now > proposals[valProposals[_validator]].expiry) 
2123             || (proposals[valProposals[_validator]].passed));
2124             valProposals[_validator] = proposalId;
2125         }
2126         uint expiry = now + votingPeriod;
2127         Proposal storage p = proposals[proposalId];
2128         p.proposalId = proposalId;
2129         p.action = _action;
2130         p.expiry = expiry;
2131         p.validator = _validator;
2132         p.newThreshold = _newThreshold;
2133         emit LogProposalCreated(proposalId, _validator, _newThreshold, _creator, expiry, _action);
2134     }
2135 }
2136 
2137 
2138 /// @title Validator contract for off chain validators to validate hash
2139 contract Validator is Owned {
2140 
2141     using SafeMath for uint;
2142 
2143     /// @notice Mapping to store the attestation done by each offchain validator for a hash
2144     mapping (bytes32 => mapping (address => bool)) public hashAttestations;
2145     mapping (bytes32 => mapping (address => bool)) public hashRefutation;
2146     mapping (bytes32 => uint) public attestationCount;
2147     mapping (address => bool) public isValidator;
2148     address[] public validators;
2149     METToken public token;
2150     TokenPorter public tokenPorter;
2151     Auctions public auctions;
2152     Proposals public proposals;
2153 
2154     mapping (bytes32 => bool) public hashClaimed;
2155 
2156     // Miniumum quorum require for various voting like import, add new validators, add new chain
2157     uint public threshold = 2;
2158 
2159     event LogAttestation(bytes32 indexed hash, address indexed recipientAddr, bool isValid);
2160     event LogValidatorAdded(address indexed validator, address indexed caller, uint threshold);
2161     event LogValidatorRemoved(address indexed validator, address indexed caller, uint threshold);
2162   
2163     /// @dev Throws if called by any account other than the validator.
2164     modifier onlyValidator() {
2165         require(isValidator[msg.sender]);
2166         _;
2167     }
2168 
2169     /// @dev Throws if called by unauthorized account
2170     modifier onlyAuthorized() {
2171         require(msg.sender == owner || msg.sender == address(proposals));
2172         _;
2173     }
2174 
2175     /// @param _validator validator address
2176     function addValidator(address _validator) public onlyAuthorized {
2177         require(!isValidator[_validator]);
2178         validators.push(_validator);
2179         isValidator[_validator] = true;
2180         uint minThreshold = (validators.length / 2) + 1;
2181         if (threshold < minThreshold) {
2182             threshold = minThreshold;
2183         }
2184         emit LogValidatorAdded(_validator, msg.sender, threshold);
2185     }
2186 
2187     /// @param _validator validator address
2188     function removeValidator(address _validator) public onlyAuthorized {
2189         // Must add new validators before removing to maintain minimum one validator active
2190         require(validators.length > 1);
2191         delete isValidator[_validator];
2192         for (uint i = 0; i < (validators.length); i++) {
2193             if (validators[i] == _validator) {
2194                 if (i != (validators.length - 1)) {
2195                     validators[i] = validators[validators.length - 1];
2196                 }
2197                 validators.length--; 
2198                 break;
2199             }
2200         }
2201 
2202         if (threshold >= validators.length) {
2203             if (validators.length == 1) {
2204                 threshold = 1;
2205             } else {
2206                 threshold = validators.length - 1;
2207             }
2208         }
2209         emit LogValidatorRemoved(_validator, msg.sender, threshold);
2210     }
2211 
2212     /// @notice fetch count of validators
2213     function getValidatorsCount() public view returns (uint) { 
2214         return  validators.length;
2215     }
2216 
2217     /// @notice set threshold for validation and minting
2218     /// @param _threshold threshold count
2219     /// @return true/false
2220     function updateThreshold(uint _threshold) public onlyAuthorized returns (bool) {
2221         require(isNewThresholdValid(validators.length, _threshold));
2222         threshold = _threshold;
2223         return true;
2224     }
2225 
2226     /// @notice check valid threshold value. Common function for validator and proposal contract
2227     /// @param _valCount valicator count
2228     /// @param _threshold new threshold value
2229     /// @return true/false
2230     function isNewThresholdValid(uint _valCount, uint _threshold) public pure returns (bool) {
2231         if (_threshold == 1 && _valCount == 2) {
2232             return true;
2233         } else if (_threshold >= 1 && _threshold < _valCount && (_threshold > (_valCount / 2))) {
2234             return true;
2235         }
2236         return false;
2237     }
2238 
2239     /// @notice set address of Proposals contract
2240     /// @param _proposals address of token porter
2241     /// @return true/false
2242     function setProposalContract(address _proposals) public onlyOwner returns (bool) {
2243         require(_proposals != 0x0);
2244         proposals = Proposals(_proposals);
2245         return true;
2246     }
2247 
2248     /// @notice set address of token porter
2249     /// @param _tokenPorter address of token porter
2250     /// @return true/false
2251     function setTokenPorter(address _tokenPorter) public onlyOwner returns (bool) {
2252         require(_tokenPorter != 0x0);
2253         tokenPorter = TokenPorter(_tokenPorter);
2254         return true;
2255     }
2256 
2257     /// @notice set contract addresses in validator contract.
2258     /// @param _tokenAddr address of MetToken contract
2259     /// @param _auctionsAddr address of Auction contract
2260     /// @param _tokenPorterAddr address of TokenPorter contract
2261     function initValidator(address _tokenAddr, address _auctionsAddr, address _tokenPorterAddr) public onlyOwner {
2262         require(_tokenAddr != 0x0);
2263         require(_auctionsAddr != 0x0);
2264         require(_tokenPorterAddr != 0x0);
2265         tokenPorter = TokenPorter(_tokenPorterAddr);
2266         auctions = Auctions(_auctionsAddr);
2267         token = METToken(_tokenAddr);
2268     }
2269 
2270     /// @notice Off chain validator call this function to validate and attest the hash. 
2271     /// @param _burnHash current burnHash
2272     /// @param _originChain source chain
2273     /// @param _recipientAddr recipientAddr
2274     /// @param _amount amount to import
2275     /// @param _fee fee for import-export
2276     /// @param _proof proof
2277     /// @param _extraData extra information for import
2278     /// @param _globalSupplyInOtherChains total supply in all other chains except this chain
2279     function attestHash(bytes32 _burnHash, bytes8 _originChain, address _recipientAddr, 
2280         uint _amount, uint _fee, bytes32[] _proof, bytes _extraData,
2281         uint _globalSupplyInOtherChains) public onlyValidator {
2282         require(_burnHash != 0x0);
2283         require(!hashAttestations[_burnHash][msg.sender]);
2284         require(!hashRefutation[_burnHash][msg.sender]);
2285         require(verifyProof(tokenPorter.merkleRoots(_burnHash), _burnHash, _proof));
2286         hashAttestations[_burnHash][msg.sender] = true;
2287         attestationCount[_burnHash]++;
2288         emit LogAttestation(_burnHash, _recipientAddr, true);
2289         
2290         if (attestationCount[_burnHash] >= threshold && !hashClaimed[_burnHash]) {
2291             hashClaimed[_burnHash] = true;
2292             require(tokenPorter.mintToken(_originChain, _recipientAddr, _amount, _fee, 
2293                 _extraData, _burnHash, _globalSupplyInOtherChains, validators));
2294         }
2295     }
2296 
2297     /// @notice off chain validator can refute hash, if given export hash is not verified in origin chain.
2298     /// @param _burnHash Burn hash
2299     function refuteHash(bytes32 _burnHash, address _recipientAddr) public onlyValidator {
2300         require(!hashAttestations[_burnHash][msg.sender]);
2301         require(!hashRefutation[_burnHash][msg.sender]);
2302         hashRefutation[_burnHash][msg.sender] = true;
2303         emit LogAttestation(_burnHash, _recipientAddr, false);
2304     }
2305 
2306     /// @notice verify that the given leaf is in merkle root.
2307     /// @param _root merkle root
2308     /// @param _leaf leaf node, current burn hash
2309     /// @param _proof merkle path
2310     /// @return true/false outcome of the verification.
2311     function verifyProof(bytes32 _root, bytes32 _leaf, bytes32[] _proof) private pure returns (bool) {
2312         require(_root != 0x0 && _leaf != 0x0 && _proof.length != 0);
2313 
2314         bytes32 _hash = _leaf;
2315         for (uint i = 0; i < _proof.length; i++) {
2316             _hash = sha256(_proof[i], _hash);
2317         } 
2318         return (_hash == _root);
2319     }
2320 
2321 }