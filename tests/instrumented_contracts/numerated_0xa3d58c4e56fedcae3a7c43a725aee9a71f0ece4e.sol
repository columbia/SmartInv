1 /*
2     The MIT License (MIT)
3 
4     Copyright 2017 - 2018, Alchemy Limited, LLC and Smart Contract Solutions.
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
25 pragma solidity ^0.4.21;
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
314     function Ownable() public {
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
325     /// @param _newOwner 
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
343     /// @param _newOwner 
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
380     /// @param _autonomousConverter 
381     /// @param _minter 
382     /// @param _initialSupply 
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
413     /// @param _to 
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
425     /// @param _from 
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
443      uint _initialSupply, uint _decmult) public onlyOwner {
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
699     /// @param _owner 
700     /// @param _recipient 
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
736     /// @param _owners 
737     /// @param _recipients 
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
995     function Auctions() public {
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
1146     /// @notice Skip Initialization and minting if we're not the OG Metronome
1147     /// @param _token MET token contract address
1148     /// @param _proceeds Address of Proceeds contract
1149     /// @param _genesisTime The block.timestamp when first auction started on OG chain
1150     /// @param _minimumPrice Nobody can buy tokens for less than this price
1151     /// @param _startingPrice Start price of MET when first auction starts
1152     /// @param _timeScale time scale factor for auction. will be always 1 in live environment
1153     /// @param _chain chain where this contract is being deployed
1154     /// @param _initialAuctionEndTime  Initial Auction end time in ETH chain. 
1155     function skipInitBecauseIAmNotOg(address _token, address _proceeds, uint _genesisTime, 
1156         uint _minimumPrice, uint _startingPrice, uint _timeScale, bytes8 _chain, 
1157         uint _initialAuctionEndTime) public onlyOwner returns (bool) {
1158         require(!minted);
1159         require(!initialized);
1160         require(_timeScale != 0);
1161         require(address(token) == 0x0 && _token != 0x0);
1162         require(address(proceeds) == 0x0 && _proceeds != 0x0);
1163         initPricer();
1164 
1165         // minting substitute section
1166         token = METToken(_token);
1167         proceeds = Proceeds(_proceeds);
1168 
1169         INITIAL_FOUNDER_SUPPLY = 0;
1170         INITIAL_AC_SUPPLY = 0;
1171         mintable = 0;  // 
1172 
1173         // initial auction substitute section
1174         genesisTime = _genesisTime;
1175         initialAuctionEndTime = _initialAuctionEndTime;
1176 
1177         // if initialAuctionEndTime is midnight, then daily auction will start immediately
1178         // after initial auction.
1179         if (initialAuctionEndTime == (initialAuctionEndTime / 1 days) * 1 days) {
1180             dailyAuctionStartTime = initialAuctionEndTime;
1181         } else {
1182             dailyAuctionStartTime = ((initialAuctionEndTime / 1 days) + 1) * 1 days;
1183         }
1184 
1185         lastPurchaseTick = 0;
1186 
1187         if (_minimumPrice > 0) {
1188             minimumPrice = _minimumPrice;
1189         }
1190 
1191         timeScale = _timeScale;
1192 
1193         if (_startingPrice > 0) {
1194             lastPurchasePrice = _startingPrice * 1 ether;
1195         } else {
1196             lastPurchasePrice = 2 ether;
1197         }
1198         chain = _chain;
1199         minted = true;
1200         initialized = true;
1201         return true;
1202     }
1203 
1204     /// @notice Initialize Auctions parameters
1205     /// @param _startTime The block.timestamp when first auction starts
1206     /// @param _minimumPrice Nobody can buy tokens for less than this price
1207     /// @param _startingPrice Start price of MET when first auction starts
1208     /// @param _timeScale time scale factor for auction. will be always 1 in live environment
1209     function initAuctions(uint _startTime, uint _minimumPrice, uint _startingPrice, uint _timeScale) 
1210         public onlyOwner returns (bool) 
1211     {
1212         require(minted);
1213         require(!initialized);
1214         require(_timeScale != 0);
1215         initPricer();
1216         if (_startTime > 0) { 
1217             genesisTime = (_startTime / (1 minutes)) * (1 minutes) + 60;
1218         } else {
1219             genesisTime = block.timestamp + 60 - (block.timestamp % 60);
1220         }
1221 
1222         initialAuctionEndTime = genesisTime + initialAuctionDuration;
1223 
1224         // if initialAuctionEndTime is midnight, then daily auction will start immediately
1225         // after initial auction.
1226         if (initialAuctionEndTime == (initialAuctionEndTime / 1 days) * 1 days) {
1227             dailyAuctionStartTime = initialAuctionEndTime;
1228         } else {
1229             dailyAuctionStartTime = ((initialAuctionEndTime / 1 days) + 1) * 1 days;
1230         }
1231 
1232         lastPurchaseTick = 0;
1233 
1234         if (_minimumPrice > 0) {
1235             minimumPrice = _minimumPrice;
1236         }
1237 
1238         timeScale = _timeScale;
1239 
1240         if (_startingPrice > 0) {
1241             lastPurchasePrice = _startingPrice * 1 ether;
1242         } else {
1243             lastPurchasePrice = 2 ether;
1244         }
1245 
1246         for (uint i = 0; i < founders.length; i++) {
1247             TokenLocker tokenLocker = tokenLockers[founders[i]];
1248             tokenLocker.lockTokenLocker();
1249         }
1250         
1251         initialized = true;
1252         return true;
1253     }
1254 
1255     function createTokenLocker(address _founder, address _token) public onlyOwner {
1256         require(_token != 0x0);
1257         require(_founder != 0x0);
1258         founders.push(_founder);
1259         TokenLocker tokenLocker = new TokenLocker(address(this), _token);
1260         tokenLockers[_founder] = tokenLocker;
1261         tokenLocker.changeOwnership(_founder);
1262     }
1263 
1264     /// @notice Mint initial supply for founder and move to token locker
1265     /// @param _founders Left 160 bits are the founder address and the right 96 bits are the token amount.
1266     /// @param _token MET token contract address
1267     /// @param _proceeds Address of Proceeds contract
1268     function mintInitialSupply(uint[] _founders, address _token, 
1269         address _proceeds, address _autonomousConverter) public onlyOwner returns (bool) 
1270     {
1271         require(!minted);
1272         require(_founders.length != 0);
1273         require(address(token) == 0x0 && _token != 0x0);
1274         require(address(proceeds) == 0x0 && _proceeds != 0x0);
1275         require(_autonomousConverter != 0x0);
1276 
1277         token = METToken(_token);
1278         proceeds = Proceeds(_proceeds);
1279 
1280         // _founders will be minted into individual token lockers
1281         uint foundersTotal;
1282         for (uint i = 0; i < _founders.length; i++) {
1283             address addr = address(_founders[i] >> 96);
1284             require(addr != 0x0);
1285             uint amount = _founders[i] & ((1 << 96) - 1);
1286             require(amount > 0);
1287             TokenLocker tokenLocker = tokenLockers[addr];
1288             require(token.mint(address(tokenLocker), amount));
1289             tokenLocker.deposit(addr, amount);
1290             foundersTotal = foundersTotal.add(amount);
1291         }
1292 
1293         // reconcile minted total for founders
1294         require(foundersTotal == INITIAL_FOUNDER_SUPPLY);
1295 
1296         // mint a small amount to the AC
1297         require(token.mint(_autonomousConverter, INITIAL_AC_SUPPLY));
1298 
1299         minted = true;
1300         return true;
1301     }
1302 
1303     /// @notice Suspend auction if not started yet
1304     function stopEverything() public onlyOwner {
1305         if (genesisTime < block.timestamp) {
1306             revert(); 
1307         }
1308         genesisTime = genesisTime + 1000 years;
1309         initialAuctionEndTime = genesisTime;
1310         dailyAuctionStartTime = genesisTime;
1311     }
1312 
1313     /// @notice Return information about initial auction status.
1314     function isInitialAuctionEnded() public view returns (bool) {
1315         return (initialAuctionEndTime != 0 && 
1316             (now >= initialAuctionEndTime || token.totalSupply() >= INITIAL_SUPPLY));
1317     }
1318 
1319     /// @notice Global MET supply
1320     function globalMetSupply() public view returns (uint) {
1321 
1322         uint currAuc = currentAuction();
1323         if (currAuc > AUCTION_WHEN_PERCENTAGE_LOGIC_STARTS) {
1324             return globalSupplyAfterPercentageLogic;
1325         } else {
1326             return INITIAL_SUPPLY.add(INITIAL_GLOBAL_DAILY_SUPPLY.mul(currAuc));
1327         }
1328     }
1329 
1330     /// @notice Global MET daily supply. Daily supply is greater of 1) 2880 2)2% of then outstanding supply per year.
1331     /// @dev 2% logic will kicks in at 14792th auction. 
1332     function globalDailySupply() public view returns (uint) {
1333         uint dailySupply = INITIAL_GLOBAL_DAILY_SUPPLY;
1334         uint thisAuction = currentAuction();
1335 
1336         if (thisAuction > AUCTION_WHEN_PERCENTAGE_LOGIC_STARTS) {
1337             uint lastAuctionPurchase = whichAuction(lastPurchaseTick);
1338             uint recentAuction = AUCTION_WHEN_PERCENTAGE_LOGIC_STARTS + 1;
1339             if (lastAuctionPurchase > recentAuction) {
1340                 recentAuction = lastAuctionPurchase;
1341             }
1342 
1343             uint totalAuctions = thisAuction - recentAuction;
1344             if (totalAuctions > 1) {
1345                 // derived formula to find close to accurate daily supply when some auction missed. 
1346                 uint factor = 36525 + ((totalAuctions - 1) * 2);
1347                 dailySupply = (globalSupplyAfterPercentageLogic.mul(2).mul(factor)).div(36525 ** 2);
1348 
1349             } else {
1350                 dailySupply = globalSupplyAfterPercentageLogic.mul(2).div(36525);
1351             }
1352 
1353             if (dailySupply < INITIAL_GLOBAL_DAILY_SUPPLY) {
1354                 dailySupply = INITIAL_GLOBAL_DAILY_SUPPLY; 
1355             }
1356         }
1357 
1358         return dailySupply;
1359     }
1360 
1361     /// @notice Current price of MET in current auction
1362     /// @return weiPerToken 
1363     function currentPrice() public constant returns (uint weiPerToken) {
1364         weiPerToken = calcPriceAt(currentTick());
1365     }
1366 
1367     /// @notice Daily mintable MET in current auction
1368     function dailyMintable() public constant returns (uint) {
1369         return nextAuctionSupply(0);
1370     }
1371 
1372     /// @notice Total tokens on this chain
1373     function tokensOnThisChain() public view returns (uint) {
1374         uint totalSupply = token.totalSupply();
1375         uint currMintable = currentMintable();
1376         return totalSupply.add(currMintable);
1377     }
1378 
1379     /// @notice Current mintable MET in auction
1380     function currentMintable() public view returns (uint) {
1381         uint currMintable = mintable;
1382         uint currAuction = currentAuction();
1383         uint totalAuctions = currAuction.sub(whichAuction(lastPurchaseTick));
1384         if (totalAuctions > 0) {
1385             currMintable = mintable.add(nextAuctionSupply(totalAuctions));
1386         }
1387         return currMintable;
1388     }
1389 
1390     /// @notice prepare auction when first import is done on a non ETH chain
1391     function prepareAuctionForNonOGChain() public {
1392         require(msg.sender == address(token.tokenPorter()) || msg.sender == address(token));
1393         require(token.totalSupply() == 0);
1394         require(chain != "ETH");
1395         lastPurchaseTick = currentTick();
1396     }
1397 
1398     /// @notice Find out what the results would be of a prospective purchase
1399     /// @param _wei Amount of wei the purchaser will pay
1400     /// @param _timestamp Prospective purchase timestamp
1401     /// @return weiPerToken expected MET token rate
1402     /// @return tokens Expected token for a prospective purchase
1403     /// @return refund Wei refund the purchaser will get if amount is excess and MET supply is less
1404     function whatWouldPurchaseDo(uint _wei, uint _timestamp) public constant
1405         returns (uint weiPerToken, uint tokens, uint refund)
1406     {
1407         weiPerToken = calcPriceAt(whichTick(_timestamp));
1408         uint calctokens = METDECMULT.mul(_wei).div(weiPerToken);
1409         tokens = calctokens;
1410         if (calctokens > mintable) {
1411             tokens = mintable;
1412             uint weiPaying = mintable.mul(weiPerToken).div(METDECMULT);
1413             refund = _wei.sub(weiPaying);
1414         }
1415     }
1416     
1417     /// @notice Return the information about the next auction
1418     /// @return _startTime Start time of next auction
1419     /// @return _startPrice Start price of MET in next auction
1420     /// @return _auctionTokens  MET supply in next auction
1421     function nextAuction() internal constant returns(uint _startTime, uint _startPrice, uint _auctionTokens) {
1422         if (block.timestamp < genesisTime) {
1423             _startTime = genesisTime;
1424             _startPrice = lastPurchasePrice;
1425             _auctionTokens = mintable;
1426             return;
1427         }
1428 
1429         uint recentAuction = whichAuction(lastPurchaseTick);
1430         uint currAuc = currentAuction();
1431         uint totalAuctions = currAuc - recentAuction;
1432         _startTime = dailyAuctionStartTime;
1433         if (currAuc > 1) {
1434             _startTime = auctionStartTime(currentTick());
1435         }
1436 
1437         _auctionTokens = nextAuctionSupply(totalAuctions);
1438 
1439         if (totalAuctions > 1) {
1440             _startPrice = lastPurchasePrice / 100 + 1;
1441         } else {
1442             if (mintable == 0 || totalAuctions == 0) {
1443                 // Sold out scenario or someone querying projected start price of next auction
1444                 _startPrice = (lastPurchasePrice * 2) + 1;   
1445             } else {
1446                 // Timed out and all tokens not sold.
1447                 if (currAuc == 1) {
1448                     // If initial auction timed out then price before start of new auction will touch floor price
1449                     _startPrice = minimumPrice * 2;
1450                 } else {
1451                     // Descending price till end of auction and then multiply by 2
1452                     uint tickWhenAuctionEnded = whichTick(_startTime);
1453                     uint numTick = 0;
1454                     if (tickWhenAuctionEnded > lastPurchaseTick) {
1455                         numTick = tickWhenAuctionEnded - lastPurchaseTick;
1456                     }
1457                     _startPrice = priceAt(lastPurchasePrice, numTick) * 2;
1458                 }
1459                 
1460                 
1461             }
1462         }
1463     }
1464 
1465     /// @notice Calculate results of a purchase
1466     /// @param _wei Amount of wei the purchaser will pay
1467     /// @param _t Prospective purchase tick
1468     /// @return weiPerToken expected MET token rate
1469     /// @return tokens Expected token for a prospective purchase
1470     /// @return refund Wei refund the purchaser will get if amount is excess and MET supply is less
1471     function calcPurchase(uint _wei, uint _t) internal view returns (uint weiPerToken, uint tokens, uint refund)
1472     {
1473         require(_t >= lastPurchaseTick);
1474         uint numTicks = _t - lastPurchaseTick;
1475         if (isInitialAuctionEnded()) {
1476             weiPerToken = priceAt(lastPurchasePrice, numTicks);
1477         } else {
1478             weiPerToken = priceAtInitialAuction(lastPurchasePrice, numTicks);
1479         }
1480 
1481         uint calctokens = METDECMULT.mul(_wei).div(weiPerToken);
1482         tokens = calctokens;
1483         if (calctokens > mintable) {
1484             tokens = mintable;
1485             uint ethPaying = mintable.mul(weiPerToken).div(METDECMULT);
1486             refund = _wei.sub(ethPaying);
1487         }
1488     }
1489 
1490     /// @notice MET supply for next Auction also considering  carry forward met.
1491     /// @param totalAuctionMissed auction count when no purchase done.
1492     function nextAuctionSupply(uint totalAuctionMissed) internal view returns (uint supply) {
1493         uint thisAuction = currentAuction();
1494         uint tokensHere = token.totalSupply().add(mintable);
1495         supply = INITIAL_GLOBAL_DAILY_SUPPLY;
1496         uint dailySupplyAtLastPurchase;
1497         if (thisAuction > AUCTION_WHEN_PERCENTAGE_LOGIC_STARTS) {
1498             supply = globalDailySupply();
1499             if (totalAuctionMissed > 1) {
1500                 dailySupplyAtLastPurchase = globalSupplyAfterPercentageLogic.mul(2).div(36525);
1501                 supply = dailySupplyAtLastPurchase.add(supply).mul(totalAuctionMissed).div(2);
1502             } 
1503             supply = (supply.mul(tokensHere)).div(globalSupplyAfterPercentageLogic);
1504         } else {
1505             if (totalAuctionMissed > 1) {
1506                 supply = supply.mul(totalAuctionMissed);
1507             }
1508             uint previousGlobalMetSupply = 
1509             INITIAL_SUPPLY.add(INITIAL_GLOBAL_DAILY_SUPPLY.mul(whichAuction(lastPurchaseTick)));
1510             supply = (supply.mul(tokensHere)).div(previousGlobalMetSupply);
1511         
1512         }
1513     }
1514 
1515     /// @notice price at a number of minutes out in Initial auction and daily auction
1516     /// @param _tick Metronome tick
1517     /// @return weiPerToken
1518     function calcPriceAt(uint _tick) internal constant returns (uint weiPerToken) {
1519         uint recentAuction = whichAuction(lastPurchaseTick);
1520         uint totalAuctions = whichAuction(_tick).sub(recentAuction);
1521         uint prevPrice;
1522 
1523         uint numTicks = 0;
1524 
1525         // Auction is sold out and metronome clock is in same auction
1526         if (mintable == 0 && totalAuctions == 0) {
1527             return lastPurchasePrice;
1528         }
1529 
1530         // Metronome has missed one auction ie no purchase in last auction
1531         if (totalAuctions > 1) {
1532             prevPrice = lastPurchasePrice / 100 + 1;
1533             numTicks = numTicksSinceAuctionStart(_tick);
1534         } else if (totalAuctions == 1) {
1535             // Metronome clock is in new auction, next auction
1536             // previous auction sold out
1537             if (mintable == 0) {
1538                 prevPrice = lastPurchasePrice * 2;
1539             } else {
1540                 // previous auctions timed out
1541                 // first daily auction
1542                 if (whichAuction(_tick) == 1) {
1543                     prevPrice = minimumPrice * 2;
1544                 } else {
1545                     prevPrice = priceAt(lastPurchasePrice, numTicksTillAuctionStart(_tick)) * 2;
1546                 }
1547             }
1548             numTicks = numTicksSinceAuctionStart(_tick);
1549         } else {
1550             //Auction is running
1551             prevPrice = lastPurchasePrice;
1552             numTicks = _tick - lastPurchaseTick;
1553         }
1554 
1555         require(numTicks >= 0);
1556 
1557         if (isInitialAuctionEnded()) {
1558             weiPerToken = priceAt(prevPrice, numTicks);
1559         } else {
1560             weiPerToken = priceAtInitialAuction(prevPrice, numTicks);
1561         }
1562     }
1563 
1564     /// @notice Calculate number of ticks elapsed between auction start time and given tick.
1565     /// @param _tick Given metronome tick
1566     function numTicksSinceAuctionStart(uint _tick) private view returns (uint ) {
1567         uint currentAuctionStartTime = auctionStartTime(_tick);
1568         return _tick - whichTick(currentAuctionStartTime);
1569     }
1570     
1571     /// @notice Calculate number of ticks elapsed between lastPurchaseTick and auctions start time of given tick.
1572     /// @param _tick Given metronome tick
1573     function numTicksTillAuctionStart(uint _tick) private view returns (uint) {
1574         uint currentAuctionStartTime = auctionStartTime(_tick);
1575         return whichTick(currentAuctionStartTime) - lastPurchaseTick;
1576     }
1577 
1578     /// @notice First calculate the auction which contains the given tick and then calculate
1579     /// auction start time of given tick.
1580     /// @param _tick Metronome tick
1581     function auctionStartTime(uint _tick) private view returns (uint) {
1582         return ((whichAuction(_tick)) * 1 days) / timeScale + dailyAuctionStartTime - 1 days;
1583     }
1584 
1585     /// @notice start the next day's auction
1586     function restartAuction() private {
1587         uint time;
1588         uint price;
1589         uint auctionTokens;
1590         (time, price, auctionTokens) = nextAuction();
1591 
1592         uint thisAuction = currentAuction();
1593         if (thisAuction > AUCTION_WHEN_PERCENTAGE_LOGIC_STARTS) {
1594             globalSupplyAfterPercentageLogic = globalSupplyAfterPercentageLogic.add(globalDailySupply());
1595         }
1596 
1597         mintable = mintable.add(auctionTokens);
1598         lastPurchasePrice = price;
1599         lastPurchaseTick = whichTick(time);
1600     }
1601 }
1602 
1603 
1604 /// @title This contract serves as a locker for a founder's tokens
1605 contract TokenLocker is Ownable {
1606     using SafeMath for uint;
1607     uint internal constant QUARTER = 91 days + 450 minutes;
1608   
1609     Auctions public auctions;
1610     METToken public token;
1611     bool public locked = false;
1612   
1613     uint public deposited;
1614     uint public lastWithdrawTime;
1615     uint public quarterlyWithdrawable;
1616     
1617     event Withdrawn(address indexed who, uint amount);
1618     event Deposited(address indexed who, uint amount);
1619 
1620     modifier onlyAuction() {
1621         require(msg.sender == address(auctions));
1622         _;
1623     }
1624 
1625     modifier preLock() { 
1626         require(!locked);
1627         _; 
1628     }
1629 
1630     modifier postLock() { 
1631         require(locked); 
1632         _; 
1633     }
1634 
1635     /// @notice Constructor to initialize TokenLocker contract.
1636     /// @param _auctions Address of auctions contract
1637     /// @param _token Address of METToken contract
1638     function TokenLocker(address _auctions, address _token) public {
1639         require(_auctions != 0x0);
1640         require(_token != 0x0);
1641         auctions = Auctions(_auctions);
1642         token = METToken(_token);
1643     }
1644 
1645     /// @notice If auctions is initialized, call to this function will result in
1646     /// locking of deposited tokens and further deposit of tokens will not be allowed.
1647     function lockTokenLocker() public onlyAuction {
1648         require(auctions.initialAuctionEndTime() != 0);
1649         require(auctions.initialAuctionEndTime() >= auctions.genesisTime()); 
1650         locked = true;
1651     }
1652 
1653     /// @notice It will deposit tokens into the locker for given beneficiary.
1654     /// @param beneficiary Address of the beneficiary, whose tokens are being locked.
1655     /// @param amount Amount of tokens being locked
1656     function deposit (address beneficiary, uint amount ) public onlyAuction preLock {
1657         uint totalBalance = token.balanceOf(this);
1658         require(totalBalance.sub(deposited) >= amount);
1659         deposited = deposited.add(amount);
1660         emit Deposited(beneficiary, amount);
1661     }
1662 
1663     /// @notice This function will allow token withdraw from locker.
1664     /// 25% of total deposited tokens can be withdrawn after initial auction end.
1665     /// Remaining 75% can be withdrawn in equal amount over 12 quarters.
1666     function withdraw() public onlyOwner postLock {
1667         require(deposited > 0);
1668         uint withdrawable = 0; 
1669         uint withdrawTime = auctions.initialAuctionEndTime();
1670         if (lastWithdrawTime == 0 && auctions.isInitialAuctionEnded()) {
1671             withdrawable = withdrawable.add((deposited.mul(25)).div(100));
1672             quarterlyWithdrawable = (deposited.sub(withdrawable)).div(12);
1673             lastWithdrawTime = withdrawTime;
1674         }
1675 
1676         require(lastWithdrawTime != 0);
1677 
1678         if (now >= lastWithdrawTime.add(QUARTER)) {
1679             uint daysSinceLastWithdraw = now.sub(lastWithdrawTime);
1680             uint totalQuarters = daysSinceLastWithdraw.div(QUARTER);
1681 
1682             require(totalQuarters > 0);
1683         
1684             withdrawable = withdrawable.add(quarterlyWithdrawable.mul(totalQuarters));
1685 
1686             if (now >= withdrawTime.add(QUARTER.mul(12))) {
1687                 withdrawable = deposited;
1688             }
1689 
1690             lastWithdrawTime = lastWithdrawTime.add(totalQuarters.mul(QUARTER));
1691         }
1692 
1693         if (withdrawable > 0) {
1694             deposited = deposited.sub(withdrawable);
1695             token.transfer(msg.sender, withdrawable);
1696             emit Withdrawn(msg.sender, withdrawable);
1697         }
1698     }
1699 }
1700 
1701 
1702 /// @title Interface for TokenPorter contract.
1703 /// Define events and functions for TokenPorter contract
1704 interface ITokenPorter {
1705     event ExportOnChainClaimedReceiptLog(address indexed destinationMetronomeAddr, 
1706         address indexed destinationRecipientAddr, uint amount);
1707 
1708     event ExportReceiptLog(bytes8 destinationChain, address destinationMetronomeAddr,
1709         address indexed destinationRecipientAddr, uint amountToBurn, uint fee, bytes extraData, uint currentTick,
1710         uint indexed burnSequence, bytes32 indexed currentBurnHash, bytes32 prevBurnHash, uint dailyMintable,
1711         uint[] supplyOnAllChains, uint genesisTime, uint blockTimestamp, uint dailyAuctionStartTime);
1712 
1713     event ImportReceiptLog(address indexed destinationRecipientAddr, uint amountImported, 
1714         uint fee, bytes extraData, uint currentTick, uint indexed importSequence, 
1715         bytes32 indexed currentHash, bytes32 prevHash, uint dailyMintable, uint blockTimestamp, address caller);
1716 
1717     function export(address tokenOwner, bytes8 _destChain, address _destMetronomeAddr, 
1718         address _destRecipAddr, uint _amount, uint _fee, bytes _extraData) public returns (bool);
1719     
1720     function importMET(bytes8 _originChain, bytes8 _destinationChain, address[] _addresses, bytes _extraData, 
1721         bytes32[] _burnHashes, uint[] _supplyOnAllChains, uint[] _importData, bytes _proof) public returns (bool);
1722 
1723 }
1724 
1725 
1726 /// @title This contract will provide export functionality for tokens.
1727 contract TokenPorter is ITokenPorter, Owned {
1728     using SafeMath for uint;
1729     Auctions public auctions;
1730     METToken public token;
1731     Validator public validator;
1732     ChainLedger public chainLedger;
1733 
1734     uint public burnSequence = 1;
1735     uint public importSequence = 1;
1736     bytes32[] public exportedBurns;
1737     uint[] public supplyOnAllChains = new uint[](6);
1738 
1739     /// @notice mapping that tracks valid destination chains for export
1740     mapping(bytes8 => address) public destinationChains;
1741 
1742     /// @notice Initialize TokenPorter contract.
1743     /// @param _tokenAddr Address of metToken contract
1744     /// @param _auctionsAddr Address of auctions contract
1745     function initTokenPorter(address _tokenAddr, address _auctionsAddr) public onlyOwner {
1746         require(_tokenAddr != 0x0);
1747         require(_auctionsAddr != 0x0);
1748         auctions = Auctions(_auctionsAddr);
1749         token = METToken(_tokenAddr);
1750     }
1751 
1752     /// @notice set address of validator contract
1753     /// @param _validator address of validator contract
1754     function setValidator(address _validator) public onlyOwner returns (bool) {
1755         require(_validator != 0x0);
1756         validator = Validator(_validator);
1757         return true;
1758     }
1759 
1760     /// @notice set address of chainLedger contract
1761     /// @param _chainLedger address of chainLedger contract
1762     function setChainLedger(address _chainLedger) public onlyOwner returns (bool) {
1763         require(_chainLedger != 0x0);
1764         chainLedger = ChainLedger(_chainLedger);
1765         return true;
1766     }
1767 
1768     /// @notice only owner can add destination chains
1769     /// @param _chainName string of destination blockchain name
1770     /// @param _contractAddress address of destination MET token to import to
1771     function addDestinationChain(bytes8 _chainName, address _contractAddress) 
1772         public onlyOwner returns (bool) 
1773     {
1774         require(_chainName != 0 && _contractAddress != address(0));
1775         destinationChains[_chainName] = _contractAddress;
1776         return true;
1777     }
1778 
1779     /// @notice only owner can remove destination chains
1780     /// @param _chainName string of destination blockchain name
1781     function removeDestinationChain(bytes8 _chainName) public onlyOwner returns (bool) {
1782         require(_chainName != 0);
1783         require(destinationChains[_chainName] != address(0));
1784         destinationChains[_chainName] = address(0);
1785         return true;   
1786     }
1787 
1788     /// @notice holds claims from users that have exported on-chain
1789     /// @param key is address of destination MET token contract
1790     /// @param subKey is address of users account that burned their original MET token
1791     mapping (address  => mapping(address => uint)) public claimables;
1792 
1793     /// @notice destination MET token contract calls claimReceivables to record burned 
1794     /// tokens have been minted in new chain
1795     /// @param recipients array of addresses of each user that has exported from
1796     /// original chain.  These can be generated by ExportReceiptLog
1797     function claimReceivables(address[] recipients) public returns (uint) {
1798         require(recipients.length > 0);
1799 
1800         uint total;
1801         for (uint i = 0; i < recipients.length; i++) {
1802             address recipient = recipients[i];
1803             uint amountBurned = claimables[msg.sender][recipient];
1804             if (amountBurned > 0) {
1805                 claimables[msg.sender][recipient] = 0;
1806                 emit ExportOnChainClaimedReceiptLog(msg.sender, recipient, amountBurned);
1807                 total = total.add(1);
1808             }
1809         }
1810         return total;
1811     }
1812 
1813     /// @notice import MET tokens from another chain to this chain.
1814     /// @param _destinationChain destination chain name
1815     /// @param _addresses _addresses[0] is destMetronomeAddr and _addresses[1] is recipientAddr
1816     /// @param _extraData extra information for import
1817     /// @param _burnHashes _burnHashes[0] is previous burnHash, _burnHashes[1] is current burnHash
1818     /// @param _supplyOnAllChains MET supply on all supported chains
1819     /// @param _importData _importData[0] is _blockTimestamp, _importData[1] is _amount, _importData[2] is _fee
1820     /// _importData[3] is _burnedAtTick, _importData[4] is _genesisTime, _importData[5] is _dailyMintable
1821     /// _importData[6] is _burnSequence, _importData[7] is _dailyAuctionStartTime
1822     /// @param _proof proof
1823     /// @return true/false
1824     function importMET(bytes8 _originChain, bytes8 _destinationChain, address[] _addresses, bytes _extraData, 
1825         bytes32[] _burnHashes, uint[] _supplyOnAllChains, uint[] _importData, bytes _proof) public returns (bool)
1826     {
1827         
1828         require(msg.sender == address(token));
1829         require(_importData.length == 8);
1830         require(_addresses.length == 2);
1831         require(_burnHashes.length == 2);
1832         require(validator.isReceiptClaimable(_originChain, _destinationChain, _addresses, _extraData, _burnHashes, 
1833         _supplyOnAllChains, _importData, _proof));
1834 
1835         validator.claimHash(_burnHashes[1]);
1836 
1837         require(_destinationChain == auctions.chain());
1838         uint amountToImport = _importData[1].add(_importData[2]);
1839         require(amountToImport.add(token.totalSupply()) <= auctions.globalMetSupply());
1840 
1841         require(_addresses[0] == address(token));
1842 
1843         if (_importData[1] == 0) {
1844             return false;
1845         }
1846 
1847         if (importSequence == 1 && token.totalSupply() == 0) {
1848             auctions.prepareAuctionForNonOGChain();
1849         }
1850         
1851         token.mint(_addresses[1], _importData[1]);
1852         emit ImportReceiptLog(_addresses[1], _importData[1], _importData[2], _extraData,
1853         auctions.currentTick(), importSequence, _burnHashes[1],
1854         _burnHashes[0], auctions.dailyMintable(), now, msg.sender);
1855         importSequence++;
1856         chainLedger.registerImport(_originChain, _destinationChain, _importData[1]);
1857         return true;
1858     }
1859 
1860     /// @notice Export MET tokens from this chain to another chain.
1861     /// @param tokenOwner Owner of the token, whose tokens are being exported.
1862     /// @param _destChain Destination chain for exported tokens
1863     /// @param _destMetronomeAddr Metronome address on destination chain
1864     /// @param _destRecipAddr Recipient address on the destination chain
1865     /// @param _amount Amount of token being exported
1866     /// @param _extraData Extra data for this export
1867     /// @return boolean true/false based on the outcome of export
1868     function export(address tokenOwner, bytes8 _destChain, address _destMetronomeAddr,
1869         address _destRecipAddr, uint _amount, uint _fee, bytes _extraData) public returns (bool) 
1870     {
1871         require(msg.sender == address(token));
1872 
1873         require(_destChain != 0x0 && _destMetronomeAddr != 0x0 && _destRecipAddr != 0x0 && _amount != 0);
1874         require(destinationChains[_destChain] == _destMetronomeAddr);
1875         
1876         require(token.balanceOf(tokenOwner) >= _amount.add(_fee));
1877 
1878         token.destroy(tokenOwner, _amount.add(_fee));
1879 
1880         uint dailyMintable = auctions.dailyMintable();
1881         uint currentTick = auctions.currentTick();
1882        
1883        
1884         if (burnSequence == 1) {
1885             exportedBurns.push(keccak256(uint8(0)));
1886         }
1887 
1888         if (_destChain == auctions.chain()) {
1889             claimables[_destMetronomeAddr][_destRecipAddr] = 
1890                 claimables[_destMetronomeAddr][_destRecipAddr].add(_amount);
1891         }
1892         uint blockTime = block.timestamp;
1893         bytes32 currentBurn = keccak256(
1894             blockTime, 
1895             auctions.chain(),
1896             _destChain, 
1897             _destMetronomeAddr, 
1898             _destRecipAddr, 
1899             _amount,
1900             currentTick,
1901             auctions.genesisTime(),
1902             dailyMintable,
1903             token.totalSupply(),
1904             _extraData,
1905             exportedBurns[burnSequence - 1]);
1906        
1907         exportedBurns.push(currentBurn);
1908 
1909         supplyOnAllChains[0] = token.totalSupply();
1910         
1911         emit ExportReceiptLog(_destChain, _destMetronomeAddr, _destRecipAddr, _amount, _fee, _extraData, 
1912             currentTick, burnSequence, currentBurn, exportedBurns[burnSequence - 1], dailyMintable,
1913             supplyOnAllChains, auctions.genesisTime(), blockTime, auctions.dailyAuctionStartTime());
1914 
1915         burnSequence = burnSequence + 1;
1916         chainLedger.registerExport(auctions.chain(), _destChain, _amount);
1917         return true;
1918     }
1919 }    
1920 
1921 
1922 contract ChainLedger is Owned {
1923 
1924     using SafeMath for uint;
1925     mapping (bytes8 => uint) public balance;
1926     mapping (bytes8 => bool) public validChain;
1927     bytes8[] public chains;
1928 
1929     address public tokenPorter;
1930     Auctions public auctions;
1931 
1932     event LogRegisterChain(address indexed caller, bytes8 indexed chain, uint supply, bool outcome);
1933     event LogRegisterExport(address indexed caller, bytes8 indexed originChain, bytes8 indexed destChain, uint amount);
1934     event LogRegisterImport(address indexed caller, bytes8 indexed originChain, bytes8 indexed destChain, uint amount);
1935 
1936     function initChainLedger(address _tokenPorter, address _auctionsAddr) public onlyOwner returns (bool) {
1937         require(_tokenPorter != 0x0);
1938         require(_auctionsAddr != 0x0);
1939         
1940         tokenPorter = _tokenPorter;
1941         auctions = Auctions(_auctionsAddr);
1942         
1943         return true;
1944     }
1945 
1946     function registerChain(bytes8 chain, uint supply) public onlyOwner returns (bool) {
1947         require(!validChain[chain]); 
1948         validChain[chain] = true;
1949         chains.push(chain);
1950         balance[chain] = supply;
1951         emit LogRegisterChain(msg.sender, chain, supply, true);
1952     }
1953 
1954     function registerExport(bytes8 originChain, bytes8 destChain, uint amount) public {
1955         require(msg.sender == tokenPorter || msg.sender == owner);
1956         require(validChain[originChain] && validChain[destChain]);
1957         require(balance[originChain] >= amount);
1958 
1959         balance[originChain] = balance[originChain].sub(amount);
1960         balance[destChain] = balance[destChain].add(amount);
1961         emit LogRegisterExport(msg.sender, originChain, destChain, amount);
1962     }
1963 
1964     function registerImport(bytes8 originChain, bytes8 destChain, uint amount) public {
1965         require(msg.sender == tokenPorter || msg.sender == owner);
1966         require(validChain[originChain] && validChain[destChain]);
1967 
1968         balance[originChain] = balance[originChain].sub(amount);
1969         balance[destChain] = balance[destChain].add(amount);
1970         emit LogRegisterImport(msg.sender, originChain, destChain, amount);
1971     }  
1972 }
1973 
1974 
1975 contract Validator is Owned {
1976 
1977     mapping (bytes32 => mapping (address => bool)) public hashAttestations;
1978     mapping (address => bool) public isValidator;
1979     mapping (address => uint8) public validatorNum;
1980     address[] public validators;
1981     address public metToken;
1982     address public tokenPorter;
1983 
1984     mapping (bytes32 => bool) public hashClaimed;
1985 
1986     uint8 public threshold = 2;
1987 
1988     event LogAttestation(bytes32 indexed hash, address indexed who, bool isValid);
1989 
1990     /// @param _validator1 first validator  
1991     /// @param _validator2 second validator
1992     /// @param _validator3 third validator
1993     function initValidator(address _validator1, address _validator2, address _validator3) public onlyOwner {
1994         // Clear old validators. Validators can be updated multiple times
1995         for (uint8 i = 0; i < validators.length; i++) {
1996             delete isValidator[validators[i]];
1997             delete validatorNum[validators[i]];
1998         }
1999         delete validators;
2000         validators.push(_validator1);
2001         validators.push(_validator2);
2002         validators.push(_validator3);
2003         // TODO: This will be NA, Bloq and a third party (escrow or company) at launch, 
2004         // and should be scripted into deploy
2005 
2006         isValidator[_validator1] = true;
2007         isValidator[_validator2] = true;
2008         isValidator[_validator3] = true;
2009 
2010         validatorNum[_validator1] = 0;
2011         validatorNum[_validator2] = 1;
2012         validatorNum[_validator3] = 2;
2013 
2014     }
2015 
2016     /// @notice set address of token porter
2017     /// @param _tokenPorter address of token porter
2018     function setTokenPorter(address _tokenPorter) public onlyOwner returns (bool) {
2019         require(_tokenPorter != 0x0);
2020         tokenPorter = _tokenPorter;
2021         return true;
2022     }
2023 
2024     function validateHash(bytes32 hash) public {
2025         require(isValidator[msg.sender]);
2026         hashAttestations[hash][msg.sender] = true;
2027         emit LogAttestation(hash, msg.sender, true);
2028     }
2029 
2030     function invalidateHash(bytes32 hash) public {
2031         require(isValidator[msg.sender]);
2032         hashAttestations[hash][msg.sender] = false;
2033         emit LogAttestation(hash, msg.sender, false);
2034     }
2035 
2036     function hashClaimable(bytes32 hash) public view returns(bool) {
2037         if (hashClaimed[hash]) { return false; }
2038 
2039         uint8 count = 0;
2040 
2041         for (uint8 i = 0; i < validators.length; i++) {
2042             if (hashAttestations[hash][validators[i]]) { count++;} 
2043         }
2044 
2045         if (count >= threshold) { return true; }
2046         return false;
2047     }
2048 
2049     function claimHash(bytes32 hash) public {
2050         require(msg.sender == tokenPorter);
2051         require(hashClaimable(hash));
2052         hashClaimed[hash] = true;
2053     }
2054 
2055     function isReceiptClaimable(bytes8 _originChain, bytes8 _destinationChain, address[] _addresses, bytes _extraData, 
2056         bytes32[] _burnHashes, uint[] _supplyOnAllChain, uint[] _importData, bytes _proof) public view returns(bool) {
2057         // We want to validate that these hash to the provided hash as a safety check, 
2058         // then we want to know if the hash is Claimable. 
2059 
2060         // Due to stack too deep error and limitation in using number of local 
2061         // variables we have to use uint array here. 
2062         // _importData[0] is _blockTimestamp, _importData[1] is _amount, _importData[2] is _fee,
2063         // _importData[3] is _burnedAtTick, _importData[4] is _genesisTime,
2064         // _importData[5] is _dailyMintable, _importData[6] is _burnSequence,
2065         // _addresses[0] is _destMetronomeAddr and _addresses[1] is _recipAddr
2066 
2067         require(_burnHashes[1] == keccak256(_importData[0], _originChain, _destinationChain, _addresses[0], 
2068             _addresses[1], _importData[1], _importData[3], _importData[4], _importData[5], _supplyOnAllChain[0], 
2069             _extraData, _burnHashes[0]));
2070 
2071         if (hashClaimable(_burnHashes[1])) {
2072             return true;
2073         } 
2074         
2075         return false;
2076 
2077     }
2078 }