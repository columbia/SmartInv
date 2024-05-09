1 pragma solidity ^0.4.23;
2 
3 
4 /**
5  * @title Signature verifier
6  * @dev To verify C level actions
7  */
8 contract SignatureVerifier {
9 
10     function splitSignature(bytes sig)
11     internal
12     pure
13     returns (uint8, bytes32, bytes32)
14     {
15         require(sig.length == 65);
16 
17         bytes32 r;
18         bytes32 s;
19         uint8 v;
20 
21         assembly {
22         // first 32 bytes, after the length prefix
23             r := mload(add(sig, 32))
24         // second 32 bytes
25             s := mload(add(sig, 64))
26         // final byte (first byte of the next 32 bytes)
27             v := byte(0, mload(add(sig, 96)))
28         }
29         return (v, r, s);
30     }
31 
32     // Returns the address that signed a given string message
33     function verifyString(
34         string message,
35         uint8 v,
36         bytes32 r,
37         bytes32 s)
38     internal pure
39     returns (address signer) {
40 
41         // The message header; we will fill in the length next
42         string memory header = "\x19Ethereum Signed Message:\n000000";
43         uint256 lengthOffset;
44         uint256 length;
45 
46         assembly {
47         // The first word of a string is its length
48             length := mload(message)
49         // The beginning of the base-10 message length in the prefix
50             lengthOffset := add(header, 57)
51         }
52 
53         // Maximum length we support
54         require(length <= 999999);
55         // The length of the message's length in base-10
56         uint256 lengthLength = 0;
57         // The divisor to get the next left-most message length digit
58         uint256 divisor = 100000;
59         // Move one digit of the message length to the right at a time
60 
61         while (divisor != 0) {
62             // The place value at the divisor
63             uint256 digit = length / divisor;
64             if (digit == 0) {
65                 // Skip leading zeros
66                 if (lengthLength == 0) {
67                     divisor /= 10;
68                     continue;
69                 }
70             }
71             // Found a non-zero digit or non-leading zero digit
72             lengthLength++;
73             // Remove this digit from the message length's current value
74             length -= digit * divisor;
75             // Shift our base-10 divisor over
76             divisor /= 10;
77 
78             // Convert the digit to its ASCII representation (man ascii)
79             digit += 0x30;
80             // Move to the next character and write the digit
81             lengthOffset++;
82             assembly {
83                 mstore8(lengthOffset, digit)
84             }
85         }
86         // The null string requires exactly 1 zero (unskip 1 leading 0)
87         if (lengthLength == 0) {
88             lengthLength = 1 + 0x19 + 1;
89         } else {
90             lengthLength += 1 + 0x19;
91         }
92         // Truncate the tailing zeros from the header
93         assembly {
94             mstore(header, lengthLength)
95         }
96         // Perform the elliptic curve recover operation
97         bytes32 check = keccak256(abi.encodePacked(header, message));
98         return ecrecover(check, v, r, s);
99     }
100 }
101 
102 
103 /**
104  * @title SafeMath
105  * @dev Math operations with safety checks that throw on error
106  */
107 library SafeMath {
108 
109     /**
110      * @dev Multiplies two numbers, throws on overflow.
111      */
112     function mul(uint256 a, uint256 b) internal pure returns (uint256 c) {
113         // Gas optimization: this is cheaper than asserting 'a' not being zero, but the
114         // benefit is lost if 'b' is also tested.
115         // See: https://github.com/OpenZeppelin/openzeppelin-solidity/pull/522
116         if (a == 0) {
117             return 0;
118         }
119 
120         c = a * b;
121         assert(c / a == b);
122         return c;
123     }
124 
125     /**
126      * @dev Integer division of two numbers, truncating the quotient.
127      */
128     function div(uint256 a, uint256 b) internal pure returns (uint256) {
129         // assert(b > 0); // Solidity automatically throws when dividing by 0
130         // uint256 c = a / b;
131         // assert(a == b * c + a % b); // There is no case in which this doesn't hold
132         return a / b;
133     }
134 
135     /**
136      * @dev Subtracts two numbers, throws on overflow (i.e. if subtrahend is greater than minuend).
137      */
138     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
139         assert(b <= a);
140         return a - b;
141     }
142 
143     /**
144      * @dev Adds two numbers, throws on overflow.
145      */
146     function add(uint256 a, uint256 b) internal pure returns (uint256 c) {
147         c = a + b;
148         assert(c >= a);
149         return c;
150     }
151 }
152 
153 /**
154  * @title A DEKLA token access control
155  * @author DEKLA (https://www.dekla.io)
156  * @dev The Dekla token has 3 C level address to manage.
157  * They can execute special actions but it need to be approved by another C level address.
158  */
159 contract AccessControl is SignatureVerifier {
160     using SafeMath for uint256;
161 
162     // C level address that can execute special actions.
163     address public ceoAddress;
164     address public cfoAddress;
165     address public cooAddress;
166     address public systemAddress;
167     uint256 public CLevelTxCount_ = 0;
168 
169     // @dev store nonces
170     mapping(address => uint256) nonces;
171 
172     // @dev C level transaction must be approved with another C level address
173     modifier onlyCLevel() {
174         require(
175             msg.sender == cooAddress ||
176             msg.sender == ceoAddress ||
177             msg.sender == cfoAddress
178         );
179         _;
180     }
181 
182     modifier onlySystem() {
183         require(msg.sender == systemAddress);
184         _;
185     }
186 
187     function recover(bytes32 hash, bytes sig) public pure returns (address) {
188         bytes32 r;
189         bytes32 s;
190         uint8 v;
191         //Check the signature length
192         if (sig.length != 65) {
193             return (address(0));
194         }
195         // Divide the signature in r, s and v variables
196         (v, r, s) = splitSignature(sig);
197         // Version of signature should be 27 or 28, but 0 and 1 are also possible versions
198         if (v < 27) {
199             v += 27;
200         }
201         // If the version is correct return the signer address
202         if (v != 27 && v != 28) {
203             return (address(0));
204         } else {
205             bytes memory prefix = "\x19Ethereum Signed Message:\n32";
206             bytes32 prefixedHash = keccak256(abi.encodePacked(prefix, hash));
207             return ecrecover(prefixedHash, v, r, s);
208         }
209     }
210 
211     function signedCLevel(
212         bytes32 _message,
213         bytes _sig
214     )
215     internal
216     view
217     onlyCLevel
218     returns (bool)
219     {
220         address signer = recover(_message, _sig);
221 
222         require(signer != msg.sender);
223         return (
224         signer == cooAddress ||
225         signer == ceoAddress ||
226         signer == cfoAddress
227         );
228     }
229 
230     event addressLogger(address signer);
231 
232     /**
233      * @notice Hash (keccak256) of the payload used by setCEO
234      * @param _newCEO address The address of the new CEO
235      * @param _nonce uint256 setCEO transaction number.
236      */
237     function getCEOHashing(address _newCEO, uint256 _nonce) public pure returns (bytes32) {
238         return keccak256(abi.encodePacked(bytes4(0x486A0F3E), _newCEO, _nonce));
239     }
240 
241     // @dev Assigns a new address to act as the CEO. The C level transaction, must verify.
242     // @param _newCEO The address of the new CEO
243     function setCEO(
244         address _newCEO,
245         bytes _sig
246     ) external onlyCLevel {
247         require(
248             _newCEO != address(0) &&
249             _newCEO != cfoAddress &&
250             _newCEO != cooAddress
251         );
252 
253         bytes32 hashedTx = getCEOHashing(_newCEO, nonces[msg.sender]);
254         require(signedCLevel(hashedTx, _sig));
255         nonces[msg.sender]++;
256 
257         ceoAddress = _newCEO;
258         CLevelTxCount_++;
259     }
260 
261     /**
262      * @notice Hash (keccak256) of the payload used by setCFO
263      * @param _newCFO address The address of the new CFO
264      * @param _nonce uint256 setCEO transaction number.
265      */
266     function getCFOHashing(address _newCFO, uint256 _nonce) public pure returns (bytes32) {
267         return keccak256(abi.encodePacked(bytes4(0x486A0F01), _newCFO, _nonce));
268     }
269 
270     // @dev Assigns a new address to act as the CFO. The C level transaction, must verify.
271     // @param _newCFO The address of the new CFO
272     function setCFO(
273         address _newCFO,
274         bytes _sig
275     ) external onlyCLevel {
276         require(
277             _newCFO != address(0) &&
278             _newCFO != ceoAddress &&
279             _newCFO != cooAddress
280         );
281 
282         bytes32 hashedTx = getCFOHashing(_newCFO, nonces[msg.sender]);
283         require(signedCLevel(hashedTx, _sig));
284         nonces[msg.sender]++;
285 
286         cfoAddress = _newCFO;
287         CLevelTxCount_++;
288     }
289 
290     /**
291      * @notice Hash (keccak256) of the payload used by setCOO
292      * @param _newCOO address The address of the new COO
293      * @param _nonce uint256 setCEO transaction number.
294      */
295     function getCOOHashing(address _newCOO, uint256 _nonce) public pure returns (bytes32) {
296         return keccak256(abi.encodePacked(bytes4(0x486A0F02), _newCOO, _nonce));
297     }
298 
299     // @dev Assigns a new address to act as the COO. The C level transaction, must verify.
300     // @param _newCOO The address of the new COO, _sig signature used to verify COO address
301     function setCOO(
302         address _newCOO,
303         bytes _sig
304     ) external onlyCLevel {
305         require(
306             _newCOO != address(0) &&
307             _newCOO != ceoAddress &&
308             _newCOO != cfoAddress
309         );
310 
311         bytes32 hashedTx = getCOOHashing(_newCOO, nonces[msg.sender]);
312         require(signedCLevel(hashedTx, _sig));
313         nonces[msg.sender]++;
314 
315         cooAddress = _newCOO;
316         CLevelTxCount_++;
317     }
318 
319     function getNonce() external view returns (uint256) {
320         return nonces[msg.sender];
321     }
322 }
323 
324 
325 interface ERC20 {
326     function transfer(address _to, uint _value) external returns (bool success);
327 
328     function balanceOf(address who) external view returns (uint256);
329 }
330 
331 contract SaleToken is AccessControl {
332     using SafeMath for uint256;
333 
334     // @dev This define events
335     event BuyDeklaSuccessful(uint256 dekla, address buyer);
336     event UpdateDeklaPriceSuccessful(uint256 price, address sender);
337     event WithdrawEthSuccessful(address sender, uint256 amount);
338     event WithdrawDeklaSuccessful(address sender, uint256 amount);
339     event UpdateMinimumPurchaseAmountSuccessful(address sender, uint256 percent);
340 
341     // @dev This is price of 1 DKL (Dekla Token)
342     // Current: 1 DKL = 0.005$
343     uint256 public deklaTokenPrice = 22590000000000;
344 
345     uint256 public decimals = 18;
346 
347     // @dev minimum purchase amount
348     uint256 public minimumPurchaseAmount;
349 
350     // @dev store nonces
351     mapping(address => uint256) nonces;
352 
353     address public systemAddress;
354 
355     // ERC20 basic token contract being held
356     ERC20 public token;
357 
358     constructor(
359         address _ceoAddress,
360         address _cfoAddress,
361         address _cooAddress,
362         address _systemAddress
363     ) public {
364         // initial C level address
365         ceoAddress = _ceoAddress;
366         cfoAddress = _cfoAddress;
367         cooAddress = _cooAddress;
368         systemAddress = _systemAddress;
369         minimumPurchaseAmount = 50 * (10 ** decimals);
370     }
371 
372     //check that the token is set
373     modifier validToken() {
374         require(token != address(0));
375         _;
376     }
377 
378     modifier onlySystem() {
379         require(msg.sender == systemAddress);
380         _;
381     }
382 
383     function recover(bytes32 hash, bytes sig) public pure returns (address) {
384         bytes32 r;
385         bytes32 s;
386         uint8 v;
387         //Check the signature length
388         if (sig.length != 65) {
389             return (address(0));
390         }
391         // Divide the signature in r, s and v variables
392         (v, r, s) = splitSignature(sig);
393         // Version of signature should be 27 or 28, but 0 and 1 are also possible versions
394         if (v < 27) {
395             v += 27;
396         }
397         // If the version is correct return the signer address
398         if (v != 27 && v != 28) {
399             return (address(0));
400         } else {
401             bytes memory prefix = "\x19Ethereum Signed Message:\n32";
402             bytes32 prefixedHash = keccak256(abi.encodePacked(prefix, hash));
403             return ecrecover(prefixedHash, v, r, s);
404         }
405     }
406 
407     function getNonces(address _sender) public view returns (uint256) {
408         return nonces[_sender];
409     }
410 
411     function setDeklaPrice(uint256 _price) external onlySystem {
412         deklaTokenPrice = _price;
413         emit UpdateDeklaPriceSuccessful(_price, msg.sender);
414     }
415 
416     function setMinimumPurchaseAmount(uint256 _price) external onlySystem {
417         minimumPurchaseAmount = _price;
418         emit UpdateMinimumPurchaseAmountSuccessful(msg.sender, _price);
419     }
420 
421     function getTokenAddressHashing(address _token, uint256 _nonce) public pure returns (bytes32) {
422         return keccak256(abi.encodePacked(bytes4(0x486A0E30), _token, _nonce));
423     }
424 
425     function setTokenAddress(address _token, bytes _sig) external onlyCLevel {
426         bytes32 hashedTx = getTokenAddressHashing(_token, nonces[msg.sender]);
427         require(signedCLevel(hashedTx, _sig));
428         token = ERC20(_token);
429     }
430 
431     // @dev calculate Dekla Token received with ETH
432     function calculateDekla(uint256 _value) external view returns (uint256) {
433         require(_value >= deklaTokenPrice);
434         return _value.div(deklaTokenPrice);
435     }
436 
437     // @dev buy dekla token, with eth balance
438     // @param value is eth balance
439     function() external payable validToken {
440         // calculate how much Dekla Token buyer will have
441         uint256 amount = msg.value.div(deklaTokenPrice) * (10 ** decimals);
442 
443         // require minimum purchase amount
444         require(amount >= minimumPurchaseAmount);
445 
446         // check total Dekla Token of owner
447         require(token.balanceOf(this) >= amount);
448 
449         token.transfer(msg.sender, amount);
450         emit BuyDeklaSuccessful(amount, msg.sender);
451     }
452 
453     // @dev - get message hashing of withdraw eth
454     // @param - _address of withdraw wallet
455     // @param - _nonce
456     function withdrawEthHashing(address _address, uint256 _amount, uint256 _nonce) public pure returns (bytes32) {
457         return keccak256(abi.encodePacked(bytes4(0x486A0E32), _address, _amount, _nonce));
458     }
459 
460     // @dev withdraw ETH balance from owner to wallet input
461     // @param _withdrawWallet is wallet address of receiver ETH
462     // @param _sig bytes
463     function withdrawEth(address _withdrawWallet, uint256 _amount, bytes _sig) external onlyCLevel {
464         bytes32 hashedTx = withdrawEthHashing(_withdrawWallet, _amount, nonces[msg.sender]);
465         require(signedCLevel(hashedTx, _sig));
466         nonces[msg.sender]++;
467 
468         uint256 balance = address(this).balance;
469 
470         // balance should be greater than 0
471         require(balance > 0);
472 
473         // balance should be greater than amount
474         require(balance >= _amount);
475 
476         _withdrawWallet.transfer(_amount);
477         emit WithdrawEthSuccessful(_withdrawWallet, _amount);
478     }
479 
480     // @dev - get message hashing of withdraw dkl
481     // @param - _address of withdraw wallet
482     // @param - _nonce
483     function withdrawDeklaHashing(address _address, uint256 _amount, uint256 _nonce) public pure returns (bytes32) {
484         return keccak256(abi.encodePacked(bytes4(0x486A0E33), _address, _amount, _nonce));
485     }
486 
487     // @dev withdraw DKL balance from owner to wallet input
488     // @param _withdrawWallet is wallet address of receiver DKL
489     // @param _sig bytes
490     function withdrawDekla(address _withdrawWallet, uint256 _amount, bytes _sig) external validToken onlyCLevel {
491         bytes32 hashedTx = withdrawDeklaHashing(_withdrawWallet, _amount, nonces[msg.sender]);
492         require(signedCLevel(hashedTx, _sig));
493         nonces[msg.sender]++;
494 
495         uint256 balance = token.balanceOf(this);
496 
497         // balance should be greater than 0
498         require(balance > 0);
499 
500         // balance should be greater than amount
501         require(balance >= _amount);
502 
503         // transfer dekla to receiver
504         token.transfer(_withdrawWallet, _amount);
505         emit WithdrawDeklaSuccessful(_withdrawWallet, _amount);
506     }
507 }