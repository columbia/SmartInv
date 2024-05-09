1 pragma solidity ^0.4.23;
2 
3 
4 /**
5  * @title SafeMath
6  * @dev Math operations with safety checks that throw on error
7  */
8 library SafeMath {
9 
10     /**
11      * @dev Multiplies two numbers, throws on overflow.
12      */
13     function mul(uint256 a, uint256 b) internal pure returns (uint256 c) {
14         // Gas optimization: this is cheaper than asserting 'a' not being zero, but the
15         // benefit is lost if 'b' is also tested.
16         // See: https://github.com/OpenZeppelin/openzeppelin-solidity/pull/522
17         if (a == 0) {
18             return 0;
19         }
20 
21         c = a * b;
22         assert(c / a == b);
23         return c;
24     }
25 
26     /**
27      * @dev Integer division of two numbers, truncating the quotient.
28      */
29     function div(uint256 a, uint256 b) internal pure returns (uint256) {
30         // assert(b > 0); // Solidity automatically throws when dividing by 0
31         // uint256 c = a / b;
32         // assert(a == b * c + a % b); // There is no case in which this doesn't hold
33         return a / b;
34     }
35 
36     /**
37      * @dev Subtracts two numbers, throws on overflow (i.e. if subtrahend is greater than minuend).
38      */
39     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
40         assert(b <= a);
41         return a - b;
42     }
43 
44     /**
45      * @dev Adds two numbers, throws on overflow.
46      */
47     function add(uint256 a, uint256 b) internal pure returns (uint256 c) {
48         c = a + b;
49         assert(c >= a);
50         return c;
51     }
52 }
53 
54 /**
55  * @title Signature verifier
56  * @dev To verify C level actions
57  */
58 contract SignatureVerifier {
59 
60     function splitSignature(bytes sig)
61     internal
62     pure
63     returns (uint8, bytes32, bytes32)
64     {
65         require(sig.length == 65);
66 
67         bytes32 r;
68         bytes32 s;
69         uint8 v;
70 
71         assembly {
72         // first 32 bytes, after the length prefix
73             r := mload(add(sig, 32))
74         // second 32 bytes
75             s := mload(add(sig, 64))
76         // final byte (first byte of the next 32 bytes)
77             v := byte(0, mload(add(sig, 96)))
78         }
79         return (v, r, s);
80     }
81 
82     // Returns the address that signed a given string message
83     function verifyString(
84         string message,
85         uint8 v,
86         bytes32 r,
87         bytes32 s)
88     internal pure
89     returns (address signer) {
90 
91         // The message header; we will fill in the length next
92         string memory header = "\x19Ethereum Signed Message:\n000000";
93         uint256 lengthOffset;
94         uint256 length;
95 
96         assembly {
97         // The first word of a string is its length
98             length := mload(message)
99         // The beginning of the base-10 message length in the prefix
100             lengthOffset := add(header, 57)
101         }
102 
103         // Maximum length we support
104         require(length <= 999999);
105         // The length of the message's length in base-10
106         uint256 lengthLength = 0;
107         // The divisor to get the next left-most message length digit
108         uint256 divisor = 100000;
109         // Move one digit of the message length to the right at a time
110 
111         while (divisor != 0) {
112             // The place value at the divisor
113             uint256 digit = length / divisor;
114             if (digit == 0) {
115                 // Skip leading zeros
116                 if (lengthLength == 0) {
117                     divisor /= 10;
118                     continue;
119                 }
120             }
121             // Found a non-zero digit or non-leading zero digit
122             lengthLength++;
123             // Remove this digit from the message length's current value
124             length -= digit * divisor;
125             // Shift our base-10 divisor over
126             divisor /= 10;
127 
128             // Convert the digit to its ASCII representation (man ascii)
129             digit += 0x30;
130             // Move to the next character and write the digit
131             lengthOffset++;
132             assembly {
133                 mstore8(lengthOffset, digit)
134             }
135         }
136         // The null string requires exactly 1 zero (unskip 1 leading 0)
137         if (lengthLength == 0) {
138             lengthLength = 1 + 0x19 + 1;
139         } else {
140             lengthLength += 1 + 0x19;
141         }
142         // Truncate the tailing zeros from the header
143         assembly {
144             mstore(header, lengthLength)
145         }
146         // Perform the elliptic curve recover operation
147         bytes32 check = keccak256(header, message);
148         return ecrecover(check, v, r, s);
149     }
150 }
151 
152 /**
153  * @title A DEKLA token access control
154  * @author DEKLA (https://www.dekla.io)
155  * @dev The Dekla token has 3 C level address to manage.
156  * They can execute special actions but it need to be approved by another C level address.
157  */
158 contract AccessControl is SignatureVerifier {
159     using SafeMath for uint256;
160 
161     // C level address that can execute special actions.
162     address public ceoAddress;
163     address public cfoAddress;
164     address public cooAddress;
165     address public systemAddress;
166     uint256 public CLevelTxCount_ = 0;
167 
168     // @dev store nonces
169     mapping(address => uint256) nonces;
170 
171     // @dev C level transaction must be approved with another C level address
172     modifier onlyCLevel() {
173         require(
174             msg.sender == cooAddress ||
175             msg.sender == ceoAddress ||
176             msg.sender == cfoAddress
177         );
178         _;
179     }
180 
181     modifier onlySystem() {
182         require(msg.sender == systemAddress);
183         _;
184     }
185 
186     function recover(bytes32 hash, bytes sig) public pure returns (address) {
187         bytes32 r;
188         bytes32 s;
189         uint8 v;
190         //Check the signature length
191         if (sig.length != 65) {
192             return (address(0));
193         }
194         // Divide the signature in r, s and v variables
195         (v, r, s) = splitSignature(sig);
196         // Version of signature should be 27 or 28, but 0 and 1 are also possible versions
197         if (v < 27) {
198             v += 27;
199         }
200         // If the version is correct return the signer address
201         if (v != 27 && v != 28) {
202             return (address(0));
203         } else {
204             bytes memory prefix = "\x19Ethereum Signed Message:\n32";
205             bytes32 prefixedHash = keccak256(prefix, hash);
206             return ecrecover(prefixedHash, v, r, s);
207         }
208     }
209 
210     function signedCLevel(
211         bytes32 _message,
212         bytes _sig
213     )
214     internal
215     view
216     onlyCLevel
217     returns (bool)
218     {
219         address signer = recover(_message, _sig);
220 
221         require(signer != msg.sender);
222         return (
223         signer == cooAddress ||
224         signer == ceoAddress ||
225         signer == cfoAddress
226         );
227     }
228 
229     event addressLogger(address signer);
230 
231     /**
232      * @notice Hash (keccak256) of the payload used by setCEO
233      * @param _newCEO address The address of the new CEO
234      * @param _nonce uint256 setCEO transaction number.
235      */
236     function getCEOHashing(address _newCEO, uint256 _nonce) public pure returns (bytes32) {
237         return keccak256(bytes4(0x486A0F3E), _newCEO, _nonce);
238     }
239 
240     // @dev Assigns a new address to act as the CEO. The C level transaction, must verify.
241     // @param _newCEO The address of the new CEO
242     function setCEO(
243         address _newCEO,
244         bytes _sig
245     ) external onlyCLevel {
246         require(
247             _newCEO != address(0) &&
248             _newCEO != cfoAddress &&
249             _newCEO != cooAddress
250         );
251 
252         bytes32 hashedTx = getCEOHashing(_newCEO, nonces[msg.sender]);
253         require(signedCLevel(hashedTx, _sig));
254         nonces[msg.sender]++;
255 
256         ceoAddress = _newCEO;
257         CLevelTxCount_++;
258     }
259 
260     /**
261      * @notice Hash (keccak256) of the payload used by setCFO
262      * @param _newCFO address The address of the new CFO
263      * @param _nonce uint256 setCEO transaction number.
264      */
265     function getCFOHashing(address _newCFO, uint256 _nonce) public pure returns (bytes32) {
266         return keccak256(bytes4(0x486A0F01), _newCFO, _nonce);
267     }
268 
269     // @dev Assigns a new address to act as the CFO. The C level transaction, must verify.
270     // @param _newCFO The address of the new CFO
271     function setCFO(
272         address _newCFO,
273         bytes _sig
274     ) external onlyCLevel {
275         require(
276             _newCFO != address(0) &&
277             _newCFO != ceoAddress &&
278             _newCFO != cooAddress
279         );
280 
281         bytes32 hashedTx = getCFOHashing(_newCFO, nonces[msg.sender]);
282         require(signedCLevel(hashedTx, _sig));
283         nonces[msg.sender]++;
284 
285         cfoAddress = _newCFO;
286         CLevelTxCount_++;
287     }
288 
289     /**
290      * @notice Hash (keccak256) of the payload used by setCOO
291      * @param _newCOO address The address of the new COO
292      * @param _nonce uint256 setCEO transaction number.
293      */
294     function getCOOHashing(address _newCOO, uint256 _nonce) public pure returns (bytes32) {
295         return keccak256(bytes4(0x486A0F02), _newCOO, _nonce);
296     }
297 
298     // @dev Assigns a new address to act as the COO. The C level transaction, must verify.
299     // @param _newCOO The address of the new COO, _sig signature used to verify COO address
300     function setCOO(
301         address _newCOO,
302         bytes _sig
303     ) external onlyCLevel {
304         require(
305             _newCOO != address(0) &&
306             _newCOO != ceoAddress &&
307             _newCOO != cfoAddress
308         );
309 
310         bytes32 hashedTx = getCOOHashing(_newCOO, nonces[msg.sender]);
311         require(signedCLevel(hashedTx, _sig));
312         nonces[msg.sender]++;
313 
314         cooAddress = _newCOO;
315         CLevelTxCount_++;
316     }
317 
318     function getNonce() external view returns (uint256) {
319         return nonces[msg.sender];
320     }
321 }
322 
323 
324 interface ERC20 {
325     function transfer(address _to, uint _value) external returns (bool success);
326 
327     function balanceOf(address who) external view returns (uint256);
328 }
329 
330 contract PreSaleToken is AccessControl {
331 
332     using SafeMath for uint256;
333 
334     // @dev This define events
335     event BuyDeklaSuccessful(uint256 dekla, address buyer);
336     event SendDeklaSuccessful(uint256 dekla, address buyer);
337     event WithdrawEthSuccessful(uint256 price, address receiver);
338     event WithdrawDeklaSuccessful(uint256 price, address receiver);
339     event UpdateDeklaPriceSuccessful(uint256 bonus, address sender);
340 
341     // @dev This is price of 1 DKL (Dekla Token)
342     // Current: 1 DKL = 0.00002259 ETH = 22590000000000 Wei = 0.005$
343     uint256 public deklaTokenPrice = 22590000000000;
344 
345     // @dev percent bonus ~ 8.8%
346     uint16 public bonus = 880;
347 
348     // @dev decimals unit
349     uint256 public decimals = 18;
350 
351     // @dev Dekla Token minimum
352     uint256 public deklaMinimum = 5000 * (10 ** decimals);
353 
354     // ERC20 basic token contract being help
355     ERC20 public token;
356 
357     // @dev store address and dekla token
358     mapping(address => uint256) deklaTokenOf;
359 
360     // @dev sale status
361     bool public preSaleEnd;
362 
363     // @dev total dekla token amount for pre-sale
364     uint256 public totalToken;
365 
366     // @dev total number of token already been should
367     uint256 public soldToken;
368 
369     address public systemAddress;
370 
371     // @dev store nonces
372     mapping(address => uint256) nonces;
373 
374     constructor(
375         address _ceoAddress,
376         address _cfoAddress,
377         address _cooAddress,
378         address _systemAddress,
379         uint256 _totalToken
380     ) public {
381         require(_totalToken > 0);
382         // initial C level address
383         ceoAddress = _ceoAddress;
384         cfoAddress = _cfoAddress;
385         cooAddress = _cooAddress;
386         totalToken = _totalToken * (10 ** decimals);
387         systemAddress = _systemAddress;
388     }
389 
390     //check that the token is set
391     modifier validToken() {
392         require(token != address(0));
393         _;
394     }
395 
396     modifier onlySystem() {
397         require(msg.sender ==  systemAddress);
398         _;
399     }
400 
401     function recover(bytes32 hash, bytes sig) public pure returns (address) {
402         bytes32 r;
403         bytes32 s;
404         uint8 v;
405         //Check the signature length
406         if (sig.length != 65) {
407             return (address(0));
408         }
409         // Divide the signature in r, s and v variables
410         (v, r, s) = splitSignature(sig);
411         // Version of signature should be 27 or 28, but 0 and 1 are also possible versions
412         if (v < 27) {
413             v += 27;
414         }
415         // If the version is correct return the signer address
416         if (v != 27 && v != 28) {
417             return (address(0));
418         } else {
419             bytes memory prefix = "\x19Ethereum Signed Message:\n32";
420             bytes32 prefixedHash = keccak256(prefix, hash);
421             return ecrecover(prefixedHash, v, r, s);
422         }
423     }
424     
425     function getNonces(address _sender) public view returns (uint256) {
426         return nonces[_sender];
427     }
428     
429     function getTokenAddressHashing(address _token, uint256 _nonce) public pure returns (bytes32) {
430         return keccak256(bytes4(0x486A0F03), _token, _nonce);
431     }
432 
433     function setTokenAddress(address _token, bytes _sig) external onlyCLevel {
434         bytes32 hashedTx = getTokenAddressHashing(_token, nonces[msg.sender]);
435         require(signedCLevel(hashedTx, _sig));
436         token = ERC20(_token);
437         nonces[msg.sender]++;
438     }
439 
440     // @dev update selling status
441     // @dev _selling == true: sale token is running, _selling = true: sale token is pause/stop
442     // @param _selling is status of selling
443     function setPreSaleEnd(bool _end) external onlyCLevel {
444         preSaleEnd = _end;
445     }
446 
447     // @dev get preSaleEnd status
448     function isPreSaleEnd() external view returns (bool) {
449         return preSaleEnd;
450     }
451 
452     function setDeklaPrice(uint256 _price) external onlySystem {
453         deklaTokenPrice = _price;
454         emit UpdateDeklaPriceSuccessful(_price, msg.sender);
455     }
456 
457     // @dev buy Dekla Token with eth of pre-sale
458     // @param value is eth balance
459     function() external payable {
460         // validate sale is opening
461         require(!preSaleEnd);
462 
463         // unit of msg.value is Wei
464         uint256 amount = msg.value.div(deklaTokenPrice);
465         amount = amount * (10 ** decimals);
466 
467         // require total Dekla Token minimum
468         require(amount >= deklaMinimum);
469 
470         // update total token left
471         soldToken = soldToken.add(amount);
472 
473         if(soldToken < totalToken) {
474             // calculate how much Dekla Token buyer will have with bonus is 8,8%
475             amount = amount.add(amount.mul(bonus).div(10000));
476         }
477 
478         // store dekla balance
479         deklaTokenOf[msg.sender] = deklaTokenOf[msg.sender].add(amount);
480 
481         // This notifies clients about the buy dekla
482         emit BuyDeklaSuccessful(amount, msg.sender);
483     }
484 
485     function getPromoBonusHashing(address _buyer, uint16 _bonus, uint256 _nonce) public pure returns (bytes32) {
486         return keccak256(bytes4(0x486A0F2F), _buyer, _bonus, _nonce);
487     }
488 
489     // @dev buy Dekla Token with eth of pre-sale
490     // @param value is eth balance
491     function buyDkl(uint16 _bonus, bytes _sig) external payable {
492         // validate sale is opening
493         require(!preSaleEnd);
494 
495         // bonus maximum should be <= 1500 ~ 15% and >= 500 ~ 5%
496         require(_bonus >= 500 && _bonus <= 1500);
497 
498         bytes32 hashedTx = getPromoBonusHashing(msg.sender, _bonus, nonces[msg.sender]);
499 
500         // promo bonus should sign by systemAddress
501         require(recover(hashedTx, _sig) == systemAddress);
502 
503         // update nonces of sender
504         nonces[msg.sender]++;
505 
506         // unit of msg.value is Wei
507         uint256 amount = msg.value.div(deklaTokenPrice);
508         amount = amount * (10 ** decimals);
509 
510         // require total Dekla Token minimum
511         require(amount >= deklaMinimum);
512 
513         // update total token left
514         soldToken = soldToken.add(amount);
515 
516         if(soldToken < totalToken) {
517             // calculate how much Dekla Token buyer will have with bonus
518             amount = amount.add(amount.mul(_bonus).div(10000));
519         }
520 
521         // store dekla balance
522         deklaTokenOf[msg.sender] = deklaTokenOf[msg.sender].add(amount);
523 
524         // This notifies clients about the buy dekla
525         emit BuyDeklaSuccessful(amount, msg.sender);
526     }
527 
528     // @dev get Dekla Token of user
529     function getDeklaTokenOf(address _address) external view returns (uint256) {
530         return deklaTokenOf[_address];
531     }
532 
533     // @dev calculate Dekla Token received with ETH
534     function calculateDekla(uint256 _value) external view returns (uint256) {
535         require(_value >= deklaTokenPrice);
536         return _value.div(deklaTokenPrice);
537     }
538 
539     // @dev send Dekla Token to buyer
540     function sendDekla(address _address) external payable validToken {
541         // check address
542         require(_address != address(0));
543 
544         // get buyer info
545         uint256 amount = deklaTokenOf[_address];
546 
547         // buyer dekla should be greater than 0
548         require(amount > 0);
549 
550         // check total dekla of owner
551         require(token.balanceOf(this) >= amount);
552 
553         // reset dekla
554         deklaTokenOf[_address] = 0;
555 
556         // transfer dekla to user
557         token.transfer(_address, amount);
558 
559         // notify event to receiver
560         emit SendDeklaSuccessful(amount, _address);
561     }
562 
563     function sendDeklaToMultipleUsers(address[] _receivers) external payable validToken {
564         // check address list not empty
565         require(_receivers.length > 0);
566 
567         // loop send dekla
568         for (uint i = 0; i < _receivers.length; i++) {
569             address _address = _receivers[i];
570 
571             // check address
572             require(_address != address(0));
573 
574             // get buyer info
575             uint256 amount = deklaTokenOf[_address];
576 
577             // buyer dekla should be greater than 0
578             // check total dekla of owner
579             if (amount > 0 && token.balanceOf(this) >= amount) {
580                 // reset dekla
581                 deklaTokenOf[_address] = 0;
582 
583                 // transfer dekla to user
584                 token.transfer(_address, amount);
585 
586                 // notify event to receiver
587                 emit SendDeklaSuccessful(amount, _address);
588             }
589         }
590     }
591 
592     function withdrawEthHashing(address _address, uint256 _nonce) public pure returns (bytes32) {
593         return keccak256(bytes4(0x486A0F0D), _address, _nonce);
594     }
595 
596     // @dev withdraw ETH balance from owner to wallet input
597     // @param withdrawWallet is wallet address of receiver ETH
598     function withdrawEth(address _withdrawWallet, bytes _sig) external onlyCLevel {
599         bytes32 hashedTx = withdrawEthHashing(_withdrawWallet, nonces[msg.sender]);
600         require(signedCLevel(hashedTx, _sig));
601         nonces[msg.sender]++;
602 
603         uint256 balance = address(this).balance;
604 
605         // balance should be greater than 0
606         require(balance > 0);
607 
608         // transfer ETH to receiver
609         _withdrawWallet.transfer(balance);
610 
611         // notify event to receiver
612         emit WithdrawEthSuccessful(balance, _withdrawWallet);
613     }
614 
615     function withdrawDeklaHashing(address _address, uint256 _nonce) public pure returns (bytes32) {
616         return keccak256(bytes4(0x486A0F0E), _address, _nonce);
617     }
618 
619     // @dev withdraw DKL balance from owner to wallet input
620     // @param _walletAddress is wallet address of receiver DKL
621     function withdrawDekla(address _withdrawWallet, bytes _sig) external validToken onlyCLevel {
622         bytes32 hashedTx = withdrawDeklaHashing(_withdrawWallet, nonces[msg.sender]);
623         require(signedCLevel(hashedTx, _sig));
624         nonces[msg.sender]++;
625 
626         uint256 balance = token.balanceOf(this);
627 
628         // the sold tokens must be left
629         require(balance > soldToken);
630 
631         // transfer dekla to receiver
632         token.transfer(_withdrawWallet, balance - soldToken);
633 
634         // notify event to receiver
635         emit WithdrawDeklaSuccessful(balance, _withdrawWallet);
636     }
637 }