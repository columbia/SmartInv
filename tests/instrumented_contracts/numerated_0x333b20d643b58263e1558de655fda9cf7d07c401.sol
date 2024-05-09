1 /**
2  * @title SafeMath
3  * @dev Math operations with safety checks that throw on error
4  */
5 library SafeMath {
6 
7   /**
8   * @dev Multiplies two numbers, throws on overflow.
9   */
10   function mul(uint256 a, uint256 b) internal pure returns (uint256) {
11     if (a == 0) {
12       return 0;
13     }
14     uint256 c = a * b;
15     assert(c / a == b);
16     return c;
17   }
18 
19   /**
20   * @dev Integer division of two numbers, truncating the quotient.
21   */
22   function div(uint256 a, uint256 b) internal pure returns (uint256) {
23     // assert(b > 0); // Solidity automatically throws when dividing by 0
24     uint256 c = a / b;
25     // assert(a == b * c + a % b); // There is no case in which this doesn't hold
26     return c;
27   }
28 
29   /**
30   * @dev Substracts two numbers, throws on overflow (i.e. if subtrahend is greater than minuend).
31   */
32   function sub(uint256 a, uint256 b) internal pure returns (uint256) {
33     assert(b <= a);
34     return a - b;
35   }
36 
37   /**
38   * @dev Adds two numbers, throws on overflow.
39   */
40   function add(uint256 a, uint256 b) internal pure returns (uint256) {
41     uint256 c = a + b;
42     assert(c >= a);
43     return c;
44   }
45 
46 
47   /**
48 * @dev Parse a floating point number from String to uint, e.g. "250.56" to "25056"
49  */
50 function parse(string s)
51 internal constant
52 returns (uint256)
53 {
54 bytes memory b = bytes(s);
55 uint result = 0;
56 for (uint i = 0; i < b.length; i++) {
57     if (b[i] >= 48 && b[i] <= 57) {
58         result = result * 10 + (uint(b[i]) - 48);
59     }
60 }
61 return result;
62 }
63 
64 }
65 
66 /**
67  * @title ERC20Basic
68  * @dev Simpler version of ERC20 interface
69  * @dev see https://github.com/ethereum/EIPs/issues/179
70  */
71 contract ERC20Basic {
72   function totalSupply() public view returns (uint256);
73   function balanceOf(address who) public view returns (uint256);
74   function transfer(address to, uint256 value) public returns (bool);
75   event Transfer(address indexed from, address indexed to, uint256 value);
76 }
77 
78 /**
79  * @title Basic token
80  * @dev Basic version of StandardToken, with no allowances.
81  */
82 contract BasicToken is ERC20Basic {
83   using SafeMath for uint256;
84 
85   mapping(address => uint256) balances;
86 
87   uint256 totalSupply_;
88 
89   /**
90   * @dev total number of tokens in existence
91   */
92   function totalSupply() public view returns (uint256) {
93     return totalSupply_;
94   }
95 
96   /**
97   * @dev transfer token for a specified address
98   * @param _to The address to transfer to.
99   * @param _value The amount to be transferred.
100   */
101   function transfer(address _to, uint256 _value) public returns (bool) {
102     require(_to != address(0));
103     require(_value <= balances[msg.sender]);
104 
105     // SafeMath.sub will throw if there is not enough balance.
106     balances[msg.sender] = balances[msg.sender].sub(_value);
107     balances[_to] = balances[_to].add(_value);
108     Transfer(msg.sender, _to, _value);
109     return true;
110   }
111 
112   /**
113   * @dev Gets the balance of the specified address.
114   * @param _owner The address to query the the balance of.
115   * @return An uint256 representing the amount owned by the passed address.
116   */
117   function balanceOf(address _owner) public view returns (uint256 balance) {
118     return balances[_owner];
119   }
120 }
121 
122 /**
123  * @title ERC20 interface
124  * @dev see https://github.com/ethereum/EIPs/issues/20
125  */
126 contract ERC20 is ERC20Basic {
127   function allowance(address owner, address spender) public view returns (uint256);
128   function transferFrom(address from, address to, uint256 value) public returns (bool);
129   function approve(address spender, uint256 value) public returns (bool);
130   event Approval(address indexed owner, address indexed spender, uint256 value);
131 }
132 
133 /**
134  * @title Standard ERC20 token
135  *
136  * @dev Implementation of the basic standard token.
137  * @dev https://github.com/ethereum/EIPs/issues/20
138  * @dev Based on code by FirstBlood: https://github.com/Firstbloodio/token/blob/master/smart_contract/FirstBloodToken.sol
139  */
140 contract StandardToken is ERC20, BasicToken {
141 
142   mapping (address => mapping (address => uint256)) internal allowed;
143 
144 
145   /**
146    * @dev Transfer tokens from one address to another
147    * @param _from address The address which you want to send tokens from
148    * @param _to address The address which you want to transfer to
149    * @param _value uint256 the amount of tokens to be transferred
150    */
151   function transferFrom(address _from, address _to, uint256 _value) public returns (bool) {
152     require(_to != address(0));
153     require(_value <= balances[_from]);
154     require(_value <= allowed[_from][msg.sender]);
155 
156     balances[_from] = balances[_from].sub(_value);
157     balances[_to] = balances[_to].add(_value);
158     allowed[_from][msg.sender] = allowed[_from][msg.sender].sub(_value);
159     Transfer(_from, _to, _value);
160     return true;
161   }
162 
163   /**
164    * @dev Approve the passed address to spend the specified amount of tokens on behalf of msg.sender.
165    *
166    * Beware that changing an allowance with this method brings the risk that someone may use both the old
167    * and the new allowance by unfortunate transaction ordering. One possible solution to mitigate this
168    * race condition is to first reduce the spender's allowance to 0 and set the desired value afterwards:
169    * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
170    * @param _spender The address which will spend the funds.
171    * @param _value The amount of tokens to be spent.
172    */
173   function approve(address _spender, uint256 _value) public returns (bool) {
174     allowed[msg.sender][_spender] = _value;
175     Approval(msg.sender, _spender, _value);
176     return true;
177   }
178 
179   /**
180    * @dev Function to check the amount of tokens that an owner allowed to a spender.
181    * @param _owner address The address which owns the funds.
182    * @param _spender address The address which will spend the funds.
183    * @return A uint256 specifying the amount of tokens still available for the spender.
184    */
185   function allowance(address _owner, address _spender) public view returns (uint256) {
186     return allowed[_owner][_spender];
187   }
188 
189   /**
190    * @dev Increase the amount of tokens that an owner allowed to a spender.
191    *
192    * approve should be called when allowed[_spender] == 0. To increment
193    * allowed value is better to use this function to avoid 2 calls (and wait until
194    * the first transaction is mined)
195    * From MonolithDAO Token.sol
196    * @param _spender The address which will spend the funds.
197    * @param _addedValue The amount of tokens to increase the allowance by.
198    */
199   function increaseApproval(address _spender, uint _addedValue) public returns (bool) {
200     allowed[msg.sender][_spender] = allowed[msg.sender][_spender].add(_addedValue);
201     Approval(msg.sender, _spender, allowed[msg.sender][_spender]);
202     return true;
203   }
204 
205   /**
206    * @dev Decrease the amount of tokens that an owner allowed to a spender.
207    *
208    * approve should be called when allowed[_spender] == 0. To decrement
209    * allowed value is better to use this function to avoid 2 calls (and wait until
210    * the first transaction is mined)
211    * From MonolithDAO Token.sol
212    * @param _spender The address which will spend the funds.
213    * @param _subtractedValue The amount of tokens to decrease the allowance by.
214    */
215   function decreaseApproval(address _spender, uint _subtractedValue) public returns (bool) {
216     uint oldValue = allowed[msg.sender][_spender];
217     if (_subtractedValue > oldValue) {
218       allowed[msg.sender][_spender] = 0;
219     } else {
220       allowed[msg.sender][_spender] = oldValue.sub(_subtractedValue);
221     }
222     Approval(msg.sender, _spender, allowed[msg.sender][_spender]);
223     return true;
224   }
225 
226 }
227 
228 /**
229  * @title Ownable
230  * @dev The Ownable contract has an owner address, and provides basic authorization control
231  * functions, this simplifies the implementation of "user permissions".
232  */
233 contract Ownable {
234   address public owner;
235 
236 
237   event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
238 
239 
240   /**
241    * @dev The Ownable constructor sets the original `owner` of the contract to the sender
242    * account.
243    */
244   function Ownable() public {
245     owner = msg.sender;
246   }
247 
248   /**
249    * @dev Throws if called by any account other than the owner.
250    */
251   modifier onlyOwner() {
252     require(msg.sender == owner);
253     _;
254   }
255 
256   /**
257    * @dev Allows the current owner to transfer control of the contract to a newOwner.
258    * @param newOwner The address to transfer ownership to.
259    */
260   function transferOwnership(address newOwner) public onlyOwner {
261     require(newOwner != address(0));
262     OwnershipTransferred(owner, newOwner);
263     owner = newOwner;
264   }
265 
266 }
267 
268 /**
269  * @title Mintable token
270  * @dev Simple ERC20 Token example, with mintable token creation
271  * @dev Issue: * https://github.com/OpenZeppelin/zeppelin-solidity/issues/120
272  * Based on code by TokenMarketNet: https://github.com/TokenMarketNet/ico/blob/master/contracts/MintableToken.sol
273  */
274 contract MintableToken is StandardToken, Ownable {
275   event Mint(address indexed to, uint256 amount);
276   event MintFinished();
277 
278   bool public mintingFinished = false;
279 
280 
281   modifier canMint() {
282     require(!mintingFinished);
283     _;
284   }
285 
286   /**
287    * @dev Function to mint tokens
288    * @param _to The address that will receive the minted tokens.
289    * @param _amount The amount of tokens to mint.
290    * @return A boolean that indicates if the operation was successful.
291    */
292   function mint(address _to, uint256 _amount) onlyOwner canMint public returns (bool) {
293     totalSupply_ = totalSupply_.add(_amount);
294     balances[_to] = balances[_to].add(_amount);
295     Mint(_to, _amount);
296     Transfer(address(0), _to, _amount);
297     return true;
298   }
299 
300   /**
301    * @dev Function to stop minting new tokens.
302    * @return True if the operation was successful.
303    */
304   function finishMinting() onlyOwner canMint public returns (bool) {
305     mintingFinished = true;
306     MintFinished();
307     return true;
308   }
309 }
310 
311 contract BLS is MintableToken {
312   using SafeMath for uint256;
313 
314   string public name = "BLS Token";
315   string public symbol = "BLS";
316   uint8 public decimals = 18;
317 
318   bool public enableTransfers = false;
319 
320   // functions overrides in order to maintain the token locked during the ICO
321   function transfer(address _to, uint256 _value) public returns(bool) {
322     require(enableTransfers);
323     return super.transfer(_to,_value);
324   }
325 
326   function transferFrom(address _from, address _to, uint256 _value) public returns(bool) {
327       require(enableTransfers);
328       return super.transferFrom(_from,_to,_value);
329   }
330 
331   function approve(address _spender, uint256 _value) public returns (bool) {
332     require(enableTransfers);
333     return super.approve(_spender,_value);
334   }
335 
336   /* function burn(uint256 _value) public {
337     require(enableTransfers);
338     super.burn(_value);
339   } */
340 
341   function increaseApproval(address _spender, uint _addedValue) public returns (bool) {
342     require(enableTransfers);
343     super.increaseApproval(_spender, _addedValue);
344   }
345 
346   function decreaseApproval(address _spender, uint _subtractedValue) public returns (bool) {
347     require(enableTransfers);
348     super.decreaseApproval(_spender, _subtractedValue);
349   }
350 
351   // enable token transfers
352   function enableTokenTransfers() public onlyOwner {
353     enableTransfers = true;
354   }
355 }
356 
357 /**
358  * @title RefundVault
359  * @dev This contract is used for storing funds while a crowdsale
360  * is in progress. Supports refunding the money if crowdsale fails,
361  * and forwarding it if crowdsale is successful.
362  */
363 contract RefundVault is Ownable {
364   using SafeMath for uint256;
365 
366   enum State { Active, Refunding, Closed }
367 
368   mapping (address => uint256) public deposited;
369   address public wallet;
370   State public state;
371 
372   event Closed();
373   event RefundsEnabled();
374   event Refunded(address indexed beneficiary, uint256 weiAmount);
375 
376   function RefundVault(address _wallet) public {
377     require(_wallet != address(0));
378     wallet = _wallet;
379     state = State.Active;
380   }
381 
382   function deposit(address investor) onlyOwner public payable {
383     require(state == State.Active);
384     deposited[investor] = deposited[investor].add(msg.value);
385   }
386 
387   function close() onlyOwner public {
388     require(state == State.Active);
389     state = State.Closed;
390     Closed();
391     wallet.transfer(this.balance);
392   }
393 
394   function enableRefunds() onlyOwner public {
395     require(state == State.Active);
396     state = State.Refunding;
397     RefundsEnabled();
398   }
399 
400   function refund(address investor) public {
401     require(state == State.Refunding);
402     uint256 depositedValue = deposited[investor];
403     deposited[investor] = 0;
404     investor.transfer(depositedValue);
405     Refunded(investor, depositedValue);
406   }
407 }
408 
409 contract ICOEngineInterface {
410 
411     // false if the ico is not started, true if the ico is started and running, true if the ico is completed
412     function started() public view returns(bool);
413 
414     // false if the ico is not started, false if the ico is started and running, true if the ico is completed
415     function ended() public view returns(bool);
416 
417     // time stamp of the starting time of the ico, must return 0 if it depends on the block number
418     function startTime() public view returns(uint);
419 
420     // time stamp of the ending time of the ico, must retrun 0 if it depends on the block number
421     function endTime() public view returns(uint);
422 
423     // Optional function, can be implemented in place of startTime
424     // Returns the starting block number of the ico, must return 0 if it depends on the time stamp
425     // function startBlock() public view returns(uint);
426 
427     // Optional function, can be implemented in place of endTime
428     // Returns theending block number of the ico, must retrun 0 if it depends on the time stamp
429     // function endBlock() public view returns(uint);
430 
431     // returns the total number of the tokens available for the sale, must not change when the ico is started
432     function totalTokens() public view returns(uint);
433 
434     // returns the number of the tokens available for the ico. At the moment that the ico starts it must be equal to totalTokens(),
435     // then it will decrease. It is used to calculate the percentage of sold tokens as remainingTokens() / totalTokens()
436     function remainingTokens() public view returns(uint);
437 
438     // return the price as number of tokens released for each ether
439     function price() public view returns(uint);
440 }
441 
442 // Abstract base contract
443 contract KYCBase {
444     using SafeMath for uint256;
445 
446     mapping (address => bool) public isKycSigner;
447     mapping (uint64 => uint256) public alreadyPayed;
448 
449     event KycVerified(address indexed signer, address buyerAddress, uint64 buyerId, uint maxAmount);
450 
451     function KYCBase(address [] kycSigners) internal {
452         for (uint i = 0; i < kycSigners.length; i++) {
453             isKycSigner[kycSigners[i]] = true;
454         }
455     }
456 
457     // Must be implemented in descending contract to assign tokens to the buyers. Called after the KYC verification is passed
458     function releaseTokensTo(address buyer) internal returns(bool);
459 
460     // This method can be overridden to enable some sender to buy token for a different address
461     function senderAllowedFor(address buyer)
462         internal view returns(bool)
463     {
464         return buyer == msg.sender;
465     }
466 
467     function buyTokensFor(address buyerAddress, uint64 buyerId, uint maxAmount, uint8 v, bytes32 r, bytes32 s)
468         public payable returns (bool)
469     {
470         require(senderAllowedFor(buyerAddress));
471         return buyImplementation(buyerAddress, buyerId, maxAmount, v, r, s);
472     }
473 
474     function buyTokens(uint64 buyerId, uint maxAmount, uint8 v, bytes32 r, bytes32 s)
475         public payable returns (bool)
476     {
477         return buyImplementation(msg.sender, buyerId, maxAmount, v, r, s);
478     }
479 
480     function buyImplementation(address buyerAddress, uint64 buyerId, uint maxAmount, uint8 v, bytes32 r, bytes32 s)
481         private returns (bool)
482     {
483         // check the signature
484         bytes32 hash = sha256("Eidoo icoengine authorization", this, buyerAddress, buyerId, maxAmount);
485         address signer = ecrecover(hash, v, r, s);
486         if (!isKycSigner[signer]) {
487             revert();
488         } else {
489             uint256 totalPayed = alreadyPayed[buyerId].add(msg.value);
490             require(totalPayed <= maxAmount);
491             alreadyPayed[buyerId] = totalPayed;
492             KycVerified(signer, buyerAddress, buyerId, maxAmount);
493             return releaseTokensTo(buyerAddress);
494         }
495     }
496 
497     // No payable fallback function, the tokens must be buyed using the functions buyTokens and buyTokensFor
498     function () public {
499         revert();
500     }
501 }
502 
503 // <ORACLIZE_API>
504 /*
505 Copyright (c) 2015-2016 Oraclize SRL
506 Copyright (c) 2016 Oraclize LTD
507 
508 
509 
510 Permission is hereby granted, free of charge, to any person obtaining a copy
511 of this software and associated documentation files (the "Software"), to deal
512 in the Software without restriction, including without limitation the rights
513 to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
514 copies of the Software, and to permit persons to whom the Software is
515 furnished to do so, subject to the following conditions:
516 
517 
518 
519 The above copyright notice and this permission notice shall be included in
520 all copies or substantial portions of the Software.
521 
522 
523 
524 THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
525 IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
526 FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT.  IN NO EVENT SHALL THE
527 AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
528 LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
529 OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
530 THE SOFTWARE.
531 */
532 
533 //pragma solidity >=0.4.1 <=0.4.20;// Incompatible compiler version... please select one stated within pragma solidity or use different oraclizeAPI version
534 
535 contract OraclizeI {
536     address public cbAddress;
537     function query(uint _timestamp, string _datasource, string _arg) payable returns (bytes32 _id);
538     function query_withGasLimit(uint _timestamp, string _datasource, string _arg, uint _gaslimit) payable returns (bytes32 _id);
539     function query2(uint _timestamp, string _datasource, string _arg1, string _arg2) payable returns (bytes32 _id);
540     function query2_withGasLimit(uint _timestamp, string _datasource, string _arg1, string _arg2, uint _gaslimit) payable returns (bytes32 _id);
541     function queryN(uint _timestamp, string _datasource, bytes _argN) payable returns (bytes32 _id);
542     function queryN_withGasLimit(uint _timestamp, string _datasource, bytes _argN, uint _gaslimit) payable returns (bytes32 _id);
543     function getPrice(string _datasource) returns (uint _dsprice);
544     function getPrice(string _datasource, uint gaslimit) returns (uint _dsprice);
545     function useCoupon(string _coupon);
546     function setProofType(byte _proofType);
547     function setConfig(bytes32 _config);
548     function setCustomGasPrice(uint _gasPrice);
549     function randomDS_getSessionPubKeyHash() returns(bytes32);
550 }
551 
552 contract OraclizeAddrResolverI {
553     function getAddress() returns (address _addr);
554 }
555 
556 /*
557 Begin solidity-cborutils
558 
559 https://github.com/smartcontractkit/solidity-cborutils
560 
561 MIT License
562 
563 Copyright (c) 2018 SmartContract ChainLink, Ltd.
564 
565 Permission is hereby granted, free of charge, to any person obtaining a copy
566 of this software and associated documentation files (the "Software"), to deal
567 in the Software without restriction, including without limitation the rights
568 to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
569 copies of the Software, and to permit persons to whom the Software is
570 furnished to do so, subject to the following conditions:
571 
572 The above copyright notice and this permission notice shall be included in all
573 copies or substantial portions of the Software.
574 
575 THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
576 IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
577 FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
578 AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
579 LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
580 OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
581 SOFTWARE.
582  */
583 
584 library Buffer {
585     struct buffer {
586         bytes buf;
587         uint capacity;
588     }
589 
590     function init(buffer memory buf, uint capacity) internal constant {
591         if(capacity % 32 != 0) capacity += 32 - (capacity % 32);
592         // Allocate space for the buffer data
593         buf.capacity = capacity;
594         assembly {
595             let ptr := mload(0x40)
596             mstore(buf, ptr)
597             mstore(0x40, add(ptr, capacity))
598         }
599     }
600 
601     function resize(buffer memory buf, uint capacity) private constant {
602         bytes memory oldbuf = buf.buf;
603         init(buf, capacity);
604         append(buf, oldbuf);
605     }
606 
607     function max(uint a, uint b) private constant returns(uint) {
608         if(a > b) {
609             return a;
610         }
611         return b;
612     }
613 
614     /**
615      * @dev Appends a byte array to the end of the buffer. Reverts if doing so
616      *      would exceed the capacity of the buffer.
617      * @param buf The buffer to append to.
618      * @param data The data to append.
619      * @return The original buffer.
620      */
621     function append(buffer memory buf, bytes data) internal constant returns(buffer memory) {
622         if(data.length + buf.buf.length > buf.capacity) {
623             resize(buf, max(buf.capacity, data.length) * 2);
624         }
625 
626         uint dest;
627         uint src;
628         uint len = data.length;
629         assembly {
630             // Memory address of the buffer data
631             let bufptr := mload(buf)
632             // Length of existing buffer data
633             let buflen := mload(bufptr)
634             // Start address = buffer address + buffer length + sizeof(buffer length)
635             dest := add(add(bufptr, buflen), 32)
636             // Update buffer length
637             mstore(bufptr, add(buflen, mload(data)))
638             src := add(data, 32)
639         }
640 
641         // Copy word-length chunks while possible
642         for(; len >= 32; len -= 32) {
643             assembly {
644                 mstore(dest, mload(src))
645             }
646             dest += 32;
647             src += 32;
648         }
649 
650         // Copy remaining bytes
651         uint mask = 256 ** (32 - len) - 1;
652         assembly {
653             let srcpart := and(mload(src), not(mask))
654             let destpart := and(mload(dest), mask)
655             mstore(dest, or(destpart, srcpart))
656         }
657 
658         return buf;
659     }
660 
661     /**
662      * @dev Appends a byte to the end of the buffer. Reverts if doing so would
663      * exceed the capacity of the buffer.
664      * @param buf The buffer to append to.
665      * @param data The data to append.
666      * @return The original buffer.
667      */
668     function append(buffer memory buf, uint8 data) internal constant {
669         if(buf.buf.length + 1 > buf.capacity) {
670             resize(buf, buf.capacity * 2);
671         }
672 
673         assembly {
674             // Memory address of the buffer data
675             let bufptr := mload(buf)
676             // Length of existing buffer data
677             let buflen := mload(bufptr)
678             // Address = buffer address + buffer length + sizeof(buffer length)
679             let dest := add(add(bufptr, buflen), 32)
680             mstore8(dest, data)
681             // Update buffer length
682             mstore(bufptr, add(buflen, 1))
683         }
684     }
685 
686     /**
687      * @dev Appends a byte to the end of the buffer. Reverts if doing so would
688      * exceed the capacity of the buffer.
689      * @param buf The buffer to append to.
690      * @param data The data to append.
691      * @return The original buffer.
692      */
693     function appendInt(buffer memory buf, uint data, uint len) internal constant returns(buffer memory) {
694         if(len + buf.buf.length > buf.capacity) {
695             resize(buf, max(buf.capacity, len) * 2);
696         }
697 
698         uint mask = 256 ** len - 1;
699         assembly {
700             // Memory address of the buffer data
701             let bufptr := mload(buf)
702             // Length of existing buffer data
703             let buflen := mload(bufptr)
704             // Address = buffer address + buffer length + sizeof(buffer length) + len
705             let dest := add(add(bufptr, buflen), len)
706             mstore(dest, or(and(mload(dest), not(mask)), data))
707             // Update buffer length
708             mstore(bufptr, add(buflen, len))
709         }
710         return buf;
711     }
712 }
713 
714 library CBOR {
715     using Buffer for Buffer.buffer;
716 
717     uint8 private constant MAJOR_TYPE_INT = 0;
718     uint8 private constant MAJOR_TYPE_NEGATIVE_INT = 1;
719     uint8 private constant MAJOR_TYPE_BYTES = 2;
720     uint8 private constant MAJOR_TYPE_STRING = 3;
721     uint8 private constant MAJOR_TYPE_ARRAY = 4;
722     uint8 private constant MAJOR_TYPE_MAP = 5;
723     uint8 private constant MAJOR_TYPE_CONTENT_FREE = 7;
724 
725     function shl8(uint8 x, uint8 y) private constant returns (uint8) {
726         return x * (2 ** y);
727     }
728 
729     function encodeType(Buffer.buffer memory buf, uint8 major, uint value) private constant {
730         if(value <= 23) {
731             buf.append(uint8(shl8(major, 5) | value));
732         } else if(value <= 0xFF) {
733             buf.append(uint8(shl8(major, 5) | 24));
734             buf.appendInt(value, 1);
735         } else if(value <= 0xFFFF) {
736             buf.append(uint8(shl8(major, 5) | 25));
737             buf.appendInt(value, 2);
738         } else if(value <= 0xFFFFFFFF) {
739             buf.append(uint8(shl8(major, 5) | 26));
740             buf.appendInt(value, 4);
741         } else if(value <= 0xFFFFFFFFFFFFFFFF) {
742             buf.append(uint8(shl8(major, 5) | 27));
743             buf.appendInt(value, 8);
744         }
745     }
746 
747     function encodeIndefiniteLengthType(Buffer.buffer memory buf, uint8 major) private constant {
748         buf.append(uint8(shl8(major, 5) | 31));
749     }
750 
751     function encodeUInt(Buffer.buffer memory buf, uint value) internal constant {
752         encodeType(buf, MAJOR_TYPE_INT, value);
753     }
754 
755     function encodeInt(Buffer.buffer memory buf, int value) internal constant {
756         if(value >= 0) {
757             encodeType(buf, MAJOR_TYPE_INT, uint(value));
758         } else {
759             encodeType(buf, MAJOR_TYPE_NEGATIVE_INT, uint(-1 - value));
760         }
761     }
762 
763     function encodeBytes(Buffer.buffer memory buf, bytes value) internal constant {
764         encodeType(buf, MAJOR_TYPE_BYTES, value.length);
765         buf.append(value);
766     }
767 
768     function encodeString(Buffer.buffer memory buf, string value) internal constant {
769         encodeType(buf, MAJOR_TYPE_STRING, bytes(value).length);
770         buf.append(bytes(value));
771     }
772 
773     function startArray(Buffer.buffer memory buf) internal constant {
774         encodeIndefiniteLengthType(buf, MAJOR_TYPE_ARRAY);
775     }
776 
777     function startMap(Buffer.buffer memory buf) internal constant {
778         encodeIndefiniteLengthType(buf, MAJOR_TYPE_MAP);
779     }
780 
781     function endSequence(Buffer.buffer memory buf) internal constant {
782         encodeIndefiniteLengthType(buf, MAJOR_TYPE_CONTENT_FREE);
783     }
784 }
785 
786 /*
787 End solidity-cborutils
788  */
789 
790 contract usingOraclize {
791     uint constant day = 60*60*24;
792     uint constant week = 60*60*24*7;
793     uint constant month = 60*60*24*30;
794     byte constant proofType_NONE = 0x00;
795     byte constant proofType_TLSNotary = 0x10;
796     byte constant proofType_Android = 0x20;
797     byte constant proofType_Ledger = 0x30;
798     byte constant proofType_Native = 0xF0;
799     byte constant proofStorage_IPFS = 0x01;
800     uint8 constant networkID_auto = 0;
801     uint8 constant networkID_mainnet = 1;
802     uint8 constant networkID_testnet = 2;
803     uint8 constant networkID_morden = 2;
804     uint8 constant networkID_consensys = 161;
805 
806     OraclizeAddrResolverI OAR;
807 
808     OraclizeI oraclize;
809     modifier oraclizeAPI {
810         if((address(OAR)==0)||(getCodeSize(address(OAR))==0))
811             oraclize_setNetwork(networkID_auto);
812 
813         if(address(oraclize) != OAR.getAddress())
814             oraclize = OraclizeI(OAR.getAddress());
815 
816         _;
817     }
818     modifier coupon(string code){
819         oraclize = OraclizeI(OAR.getAddress());
820         oraclize.useCoupon(code);
821         _;
822     }
823 
824     function oraclize_setNetwork(uint8 networkID) internal returns(bool){
825         if (getCodeSize(0x1d3B2638a7cC9f2CB3D298A3DA7a90B67E5506ed)>0){ //mainnet
826             OAR = OraclizeAddrResolverI(0x1d3B2638a7cC9f2CB3D298A3DA7a90B67E5506ed);
827             oraclize_setNetworkName("eth_mainnet");
828             return true;
829         }
830         if (getCodeSize(0xc03A2615D5efaf5F49F60B7BB6583eaec212fdf1)>0){ //ropsten testnet
831             OAR = OraclizeAddrResolverI(0xc03A2615D5efaf5F49F60B7BB6583eaec212fdf1);
832             oraclize_setNetworkName("eth_ropsten3");
833             return true;
834         }
835         if (getCodeSize(0xB7A07BcF2Ba2f2703b24C0691b5278999C59AC7e)>0){ //kovan testnet
836             OAR = OraclizeAddrResolverI(0xB7A07BcF2Ba2f2703b24C0691b5278999C59AC7e);
837             oraclize_setNetworkName("eth_kovan");
838             return true;
839         }
840         if (getCodeSize(0x146500cfd35B22E4A392Fe0aDc06De1a1368Ed48)>0){ //rinkeby testnet
841             OAR = OraclizeAddrResolverI(0x146500cfd35B22E4A392Fe0aDc06De1a1368Ed48);
842             oraclize_setNetworkName("eth_rinkeby");
843             return true;
844         }
845         if (getCodeSize(0x6f485C8BF6fc43eA212E93BBF8ce046C7f1cb475)>0){ //ethereum-bridge
846             OAR = OraclizeAddrResolverI(0x6f485C8BF6fc43eA212E93BBF8ce046C7f1cb475);
847             return true;
848         }
849         if (getCodeSize(0x20e12A1F859B3FeaE5Fb2A0A32C18F5a65555bBF)>0){ //ether.camp ide
850             OAR = OraclizeAddrResolverI(0x20e12A1F859B3FeaE5Fb2A0A32C18F5a65555bBF);
851             return true;
852         }
853         if (getCodeSize(0x51efaF4c8B3C9AfBD5aB9F4bbC82784Ab6ef8fAA)>0){ //browser-solidity
854             OAR = OraclizeAddrResolverI(0x51efaF4c8B3C9AfBD5aB9F4bbC82784Ab6ef8fAA);
855             return true;
856         }
857         return false;
858     }
859 
860     function __callback(bytes32 myid, string result) {
861         __callback(myid, result, new bytes(0));
862     }
863     function __callback(bytes32 myid, string result, bytes proof) {
864     }
865 
866     function oraclize_useCoupon(string code) oraclizeAPI internal {
867         oraclize.useCoupon(code);
868     }
869 
870     function oraclize_getPrice(string datasource) oraclizeAPI internal returns (uint){
871         return oraclize.getPrice(datasource);
872     }
873 
874     function oraclize_getPrice(string datasource, uint gaslimit) oraclizeAPI internal returns (uint){
875         return oraclize.getPrice(datasource, gaslimit);
876     }
877 
878     function oraclize_query(string datasource, string arg) oraclizeAPI internal returns (bytes32 id){
879         uint price = oraclize.getPrice(datasource);
880         if (price > 1 ether + tx.gasprice*200000) return 0; // unexpectedly high price
881         return oraclize.query.value(price)(0, datasource, arg);
882     }
883     function oraclize_query(uint timestamp, string datasource, string arg) oraclizeAPI internal returns (bytes32 id){
884         uint price = oraclize.getPrice(datasource);
885         if (price > 1 ether + tx.gasprice*200000) return 0; // unexpectedly high price
886         return oraclize.query.value(price)(timestamp, datasource, arg);
887     }
888     function oraclize_query(uint timestamp, string datasource, string arg, uint gaslimit) oraclizeAPI internal returns (bytes32 id){
889         uint price = oraclize.getPrice(datasource, gaslimit);
890         if (price > 1 ether + tx.gasprice*gaslimit) return 0; // unexpectedly high price
891         return oraclize.query_withGasLimit.value(price)(timestamp, datasource, arg, gaslimit);
892     }
893     function oraclize_query(string datasource, string arg, uint gaslimit) oraclizeAPI internal returns (bytes32 id){
894         uint price = oraclize.getPrice(datasource, gaslimit);
895         if (price > 1 ether + tx.gasprice*gaslimit) return 0; // unexpectedly high price
896         return oraclize.query_withGasLimit.value(price)(0, datasource, arg, gaslimit);
897     }
898     function oraclize_query(string datasource, string arg1, string arg2) oraclizeAPI internal returns (bytes32 id){
899         uint price = oraclize.getPrice(datasource);
900         if (price > 1 ether + tx.gasprice*200000) return 0; // unexpectedly high price
901         return oraclize.query2.value(price)(0, datasource, arg1, arg2);
902     }
903     function oraclize_query(uint timestamp, string datasource, string arg1, string arg2) oraclizeAPI internal returns (bytes32 id){
904         uint price = oraclize.getPrice(datasource);
905         if (price > 1 ether + tx.gasprice*200000) return 0; // unexpectedly high price
906         return oraclize.query2.value(price)(timestamp, datasource, arg1, arg2);
907     }
908     function oraclize_query(uint timestamp, string datasource, string arg1, string arg2, uint gaslimit) oraclizeAPI internal returns (bytes32 id){
909         uint price = oraclize.getPrice(datasource, gaslimit);
910         if (price > 1 ether + tx.gasprice*gaslimit) return 0; // unexpectedly high price
911         return oraclize.query2_withGasLimit.value(price)(timestamp, datasource, arg1, arg2, gaslimit);
912     }
913     function oraclize_query(string datasource, string arg1, string arg2, uint gaslimit) oraclizeAPI internal returns (bytes32 id){
914         uint price = oraclize.getPrice(datasource, gaslimit);
915         if (price > 1 ether + tx.gasprice*gaslimit) return 0; // unexpectedly high price
916         return oraclize.query2_withGasLimit.value(price)(0, datasource, arg1, arg2, gaslimit);
917     }
918     function oraclize_query(string datasource, string[] argN) oraclizeAPI internal returns (bytes32 id){
919         uint price = oraclize.getPrice(datasource);
920         if (price > 1 ether + tx.gasprice*200000) return 0; // unexpectedly high price
921         bytes memory args = stra2cbor(argN);
922         return oraclize.queryN.value(price)(0, datasource, args);
923     }
924     function oraclize_query(uint timestamp, string datasource, string[] argN) oraclizeAPI internal returns (bytes32 id){
925         uint price = oraclize.getPrice(datasource);
926         if (price > 1 ether + tx.gasprice*200000) return 0; // unexpectedly high price
927         bytes memory args = stra2cbor(argN);
928         return oraclize.queryN.value(price)(timestamp, datasource, args);
929     }
930     function oraclize_query(uint timestamp, string datasource, string[] argN, uint gaslimit) oraclizeAPI internal returns (bytes32 id){
931         uint price = oraclize.getPrice(datasource, gaslimit);
932         if (price > 1 ether + tx.gasprice*gaslimit) return 0; // unexpectedly high price
933         bytes memory args = stra2cbor(argN);
934         return oraclize.queryN_withGasLimit.value(price)(timestamp, datasource, args, gaslimit);
935     }
936     function oraclize_query(string datasource, string[] argN, uint gaslimit) oraclizeAPI internal returns (bytes32 id){
937         uint price = oraclize.getPrice(datasource, gaslimit);
938         if (price > 1 ether + tx.gasprice*gaslimit) return 0; // unexpectedly high price
939         bytes memory args = stra2cbor(argN);
940         return oraclize.queryN_withGasLimit.value(price)(0, datasource, args, gaslimit);
941     }
942     function oraclize_query(string datasource, string[1] args) oraclizeAPI internal returns (bytes32 id) {
943         string[] memory dynargs = new string[](1);
944         dynargs[0] = args[0];
945         return oraclize_query(datasource, dynargs);
946     }
947     function oraclize_query(uint timestamp, string datasource, string[1] args) oraclizeAPI internal returns (bytes32 id) {
948         string[] memory dynargs = new string[](1);
949         dynargs[0] = args[0];
950         return oraclize_query(timestamp, datasource, dynargs);
951     }
952     function oraclize_query(uint timestamp, string datasource, string[1] args, uint gaslimit) oraclizeAPI internal returns (bytes32 id) {
953         string[] memory dynargs = new string[](1);
954         dynargs[0] = args[0];
955         return oraclize_query(timestamp, datasource, dynargs, gaslimit);
956     }
957     function oraclize_query(string datasource, string[1] args, uint gaslimit) oraclizeAPI internal returns (bytes32 id) {
958         string[] memory dynargs = new string[](1);
959         dynargs[0] = args[0];
960         return oraclize_query(datasource, dynargs, gaslimit);
961     }
962 
963     function oraclize_query(string datasource, string[2] args) oraclizeAPI internal returns (bytes32 id) {
964         string[] memory dynargs = new string[](2);
965         dynargs[0] = args[0];
966         dynargs[1] = args[1];
967         return oraclize_query(datasource, dynargs);
968     }
969     function oraclize_query(uint timestamp, string datasource, string[2] args) oraclizeAPI internal returns (bytes32 id) {
970         string[] memory dynargs = new string[](2);
971         dynargs[0] = args[0];
972         dynargs[1] = args[1];
973         return oraclize_query(timestamp, datasource, dynargs);
974     }
975     function oraclize_query(uint timestamp, string datasource, string[2] args, uint gaslimit) oraclizeAPI internal returns (bytes32 id) {
976         string[] memory dynargs = new string[](2);
977         dynargs[0] = args[0];
978         dynargs[1] = args[1];
979         return oraclize_query(timestamp, datasource, dynargs, gaslimit);
980     }
981     function oraclize_query(string datasource, string[2] args, uint gaslimit) oraclizeAPI internal returns (bytes32 id) {
982         string[] memory dynargs = new string[](2);
983         dynargs[0] = args[0];
984         dynargs[1] = args[1];
985         return oraclize_query(datasource, dynargs, gaslimit);
986     }
987     function oraclize_query(string datasource, string[3] args) oraclizeAPI internal returns (bytes32 id) {
988         string[] memory dynargs = new string[](3);
989         dynargs[0] = args[0];
990         dynargs[1] = args[1];
991         dynargs[2] = args[2];
992         return oraclize_query(datasource, dynargs);
993     }
994     function oraclize_query(uint timestamp, string datasource, string[3] args) oraclizeAPI internal returns (bytes32 id) {
995         string[] memory dynargs = new string[](3);
996         dynargs[0] = args[0];
997         dynargs[1] = args[1];
998         dynargs[2] = args[2];
999         return oraclize_query(timestamp, datasource, dynargs);
1000     }
1001     function oraclize_query(uint timestamp, string datasource, string[3] args, uint gaslimit) oraclizeAPI internal returns (bytes32 id) {
1002         string[] memory dynargs = new string[](3);
1003         dynargs[0] = args[0];
1004         dynargs[1] = args[1];
1005         dynargs[2] = args[2];
1006         return oraclize_query(timestamp, datasource, dynargs, gaslimit);
1007     }
1008     function oraclize_query(string datasource, string[3] args, uint gaslimit) oraclizeAPI internal returns (bytes32 id) {
1009         string[] memory dynargs = new string[](3);
1010         dynargs[0] = args[0];
1011         dynargs[1] = args[1];
1012         dynargs[2] = args[2];
1013         return oraclize_query(datasource, dynargs, gaslimit);
1014     }
1015 
1016     function oraclize_query(string datasource, string[4] args) oraclizeAPI internal returns (bytes32 id) {
1017         string[] memory dynargs = new string[](4);
1018         dynargs[0] = args[0];
1019         dynargs[1] = args[1];
1020         dynargs[2] = args[2];
1021         dynargs[3] = args[3];
1022         return oraclize_query(datasource, dynargs);
1023     }
1024     function oraclize_query(uint timestamp, string datasource, string[4] args) oraclizeAPI internal returns (bytes32 id) {
1025         string[] memory dynargs = new string[](4);
1026         dynargs[0] = args[0];
1027         dynargs[1] = args[1];
1028         dynargs[2] = args[2];
1029         dynargs[3] = args[3];
1030         return oraclize_query(timestamp, datasource, dynargs);
1031     }
1032     function oraclize_query(uint timestamp, string datasource, string[4] args, uint gaslimit) oraclizeAPI internal returns (bytes32 id) {
1033         string[] memory dynargs = new string[](4);
1034         dynargs[0] = args[0];
1035         dynargs[1] = args[1];
1036         dynargs[2] = args[2];
1037         dynargs[3] = args[3];
1038         return oraclize_query(timestamp, datasource, dynargs, gaslimit);
1039     }
1040     function oraclize_query(string datasource, string[4] args, uint gaslimit) oraclizeAPI internal returns (bytes32 id) {
1041         string[] memory dynargs = new string[](4);
1042         dynargs[0] = args[0];
1043         dynargs[1] = args[1];
1044         dynargs[2] = args[2];
1045         dynargs[3] = args[3];
1046         return oraclize_query(datasource, dynargs, gaslimit);
1047     }
1048     function oraclize_query(string datasource, string[5] args) oraclizeAPI internal returns (bytes32 id) {
1049         string[] memory dynargs = new string[](5);
1050         dynargs[0] = args[0];
1051         dynargs[1] = args[1];
1052         dynargs[2] = args[2];
1053         dynargs[3] = args[3];
1054         dynargs[4] = args[4];
1055         return oraclize_query(datasource, dynargs);
1056     }
1057     function oraclize_query(uint timestamp, string datasource, string[5] args) oraclizeAPI internal returns (bytes32 id) {
1058         string[] memory dynargs = new string[](5);
1059         dynargs[0] = args[0];
1060         dynargs[1] = args[1];
1061         dynargs[2] = args[2];
1062         dynargs[3] = args[3];
1063         dynargs[4] = args[4];
1064         return oraclize_query(timestamp, datasource, dynargs);
1065     }
1066     function oraclize_query(uint timestamp, string datasource, string[5] args, uint gaslimit) oraclizeAPI internal returns (bytes32 id) {
1067         string[] memory dynargs = new string[](5);
1068         dynargs[0] = args[0];
1069         dynargs[1] = args[1];
1070         dynargs[2] = args[2];
1071         dynargs[3] = args[3];
1072         dynargs[4] = args[4];
1073         return oraclize_query(timestamp, datasource, dynargs, gaslimit);
1074     }
1075     function oraclize_query(string datasource, string[5] args, uint gaslimit) oraclizeAPI internal returns (bytes32 id) {
1076         string[] memory dynargs = new string[](5);
1077         dynargs[0] = args[0];
1078         dynargs[1] = args[1];
1079         dynargs[2] = args[2];
1080         dynargs[3] = args[3];
1081         dynargs[4] = args[4];
1082         return oraclize_query(datasource, dynargs, gaslimit);
1083     }
1084     function oraclize_query(string datasource, bytes[] argN) oraclizeAPI internal returns (bytes32 id){
1085         uint price = oraclize.getPrice(datasource);
1086         if (price > 1 ether + tx.gasprice*200000) return 0; // unexpectedly high price
1087         bytes memory args = ba2cbor(argN);
1088         return oraclize.queryN.value(price)(0, datasource, args);
1089     }
1090     function oraclize_query(uint timestamp, string datasource, bytes[] argN) oraclizeAPI internal returns (bytes32 id){
1091         uint price = oraclize.getPrice(datasource);
1092         if (price > 1 ether + tx.gasprice*200000) return 0; // unexpectedly high price
1093         bytes memory args = ba2cbor(argN);
1094         return oraclize.queryN.value(price)(timestamp, datasource, args);
1095     }
1096     function oraclize_query(uint timestamp, string datasource, bytes[] argN, uint gaslimit) oraclizeAPI internal returns (bytes32 id){
1097         uint price = oraclize.getPrice(datasource, gaslimit);
1098         if (price > 1 ether + tx.gasprice*gaslimit) return 0; // unexpectedly high price
1099         bytes memory args = ba2cbor(argN);
1100         return oraclize.queryN_withGasLimit.value(price)(timestamp, datasource, args, gaslimit);
1101     }
1102     function oraclize_query(string datasource, bytes[] argN, uint gaslimit) oraclizeAPI internal returns (bytes32 id){
1103         uint price = oraclize.getPrice(datasource, gaslimit);
1104         if (price > 1 ether + tx.gasprice*gaslimit) return 0; // unexpectedly high price
1105         bytes memory args = ba2cbor(argN);
1106         return oraclize.queryN_withGasLimit.value(price)(0, datasource, args, gaslimit);
1107     }
1108     function oraclize_query(string datasource, bytes[1] args) oraclizeAPI internal returns (bytes32 id) {
1109         bytes[] memory dynargs = new bytes[](1);
1110         dynargs[0] = args[0];
1111         return oraclize_query(datasource, dynargs);
1112     }
1113     function oraclize_query(uint timestamp, string datasource, bytes[1] args) oraclizeAPI internal returns (bytes32 id) {
1114         bytes[] memory dynargs = new bytes[](1);
1115         dynargs[0] = args[0];
1116         return oraclize_query(timestamp, datasource, dynargs);
1117     }
1118     function oraclize_query(uint timestamp, string datasource, bytes[1] args, uint gaslimit) oraclizeAPI internal returns (bytes32 id) {
1119         bytes[] memory dynargs = new bytes[](1);
1120         dynargs[0] = args[0];
1121         return oraclize_query(timestamp, datasource, dynargs, gaslimit);
1122     }
1123     function oraclize_query(string datasource, bytes[1] args, uint gaslimit) oraclizeAPI internal returns (bytes32 id) {
1124         bytes[] memory dynargs = new bytes[](1);
1125         dynargs[0] = args[0];
1126         return oraclize_query(datasource, dynargs, gaslimit);
1127     }
1128 
1129     function oraclize_query(string datasource, bytes[2] args) oraclizeAPI internal returns (bytes32 id) {
1130         bytes[] memory dynargs = new bytes[](2);
1131         dynargs[0] = args[0];
1132         dynargs[1] = args[1];
1133         return oraclize_query(datasource, dynargs);
1134     }
1135     function oraclize_query(uint timestamp, string datasource, bytes[2] args) oraclizeAPI internal returns (bytes32 id) {
1136         bytes[] memory dynargs = new bytes[](2);
1137         dynargs[0] = args[0];
1138         dynargs[1] = args[1];
1139         return oraclize_query(timestamp, datasource, dynargs);
1140     }
1141     function oraclize_query(uint timestamp, string datasource, bytes[2] args, uint gaslimit) oraclizeAPI internal returns (bytes32 id) {
1142         bytes[] memory dynargs = new bytes[](2);
1143         dynargs[0] = args[0];
1144         dynargs[1] = args[1];
1145         return oraclize_query(timestamp, datasource, dynargs, gaslimit);
1146     }
1147     function oraclize_query(string datasource, bytes[2] args, uint gaslimit) oraclizeAPI internal returns (bytes32 id) {
1148         bytes[] memory dynargs = new bytes[](2);
1149         dynargs[0] = args[0];
1150         dynargs[1] = args[1];
1151         return oraclize_query(datasource, dynargs, gaslimit);
1152     }
1153     function oraclize_query(string datasource, bytes[3] args) oraclizeAPI internal returns (bytes32 id) {
1154         bytes[] memory dynargs = new bytes[](3);
1155         dynargs[0] = args[0];
1156         dynargs[1] = args[1];
1157         dynargs[2] = args[2];
1158         return oraclize_query(datasource, dynargs);
1159     }
1160     function oraclize_query(uint timestamp, string datasource, bytes[3] args) oraclizeAPI internal returns (bytes32 id) {
1161         bytes[] memory dynargs = new bytes[](3);
1162         dynargs[0] = args[0];
1163         dynargs[1] = args[1];
1164         dynargs[2] = args[2];
1165         return oraclize_query(timestamp, datasource, dynargs);
1166     }
1167     function oraclize_query(uint timestamp, string datasource, bytes[3] args, uint gaslimit) oraclizeAPI internal returns (bytes32 id) {
1168         bytes[] memory dynargs = new bytes[](3);
1169         dynargs[0] = args[0];
1170         dynargs[1] = args[1];
1171         dynargs[2] = args[2];
1172         return oraclize_query(timestamp, datasource, dynargs, gaslimit);
1173     }
1174     function oraclize_query(string datasource, bytes[3] args, uint gaslimit) oraclizeAPI internal returns (bytes32 id) {
1175         bytes[] memory dynargs = new bytes[](3);
1176         dynargs[0] = args[0];
1177         dynargs[1] = args[1];
1178         dynargs[2] = args[2];
1179         return oraclize_query(datasource, dynargs, gaslimit);
1180     }
1181 
1182     function oraclize_query(string datasource, bytes[4] args) oraclizeAPI internal returns (bytes32 id) {
1183         bytes[] memory dynargs = new bytes[](4);
1184         dynargs[0] = args[0];
1185         dynargs[1] = args[1];
1186         dynargs[2] = args[2];
1187         dynargs[3] = args[3];
1188         return oraclize_query(datasource, dynargs);
1189     }
1190     function oraclize_query(uint timestamp, string datasource, bytes[4] args) oraclizeAPI internal returns (bytes32 id) {
1191         bytes[] memory dynargs = new bytes[](4);
1192         dynargs[0] = args[0];
1193         dynargs[1] = args[1];
1194         dynargs[2] = args[2];
1195         dynargs[3] = args[3];
1196         return oraclize_query(timestamp, datasource, dynargs);
1197     }
1198     function oraclize_query(uint timestamp, string datasource, bytes[4] args, uint gaslimit) oraclizeAPI internal returns (bytes32 id) {
1199         bytes[] memory dynargs = new bytes[](4);
1200         dynargs[0] = args[0];
1201         dynargs[1] = args[1];
1202         dynargs[2] = args[2];
1203         dynargs[3] = args[3];
1204         return oraclize_query(timestamp, datasource, dynargs, gaslimit);
1205     }
1206     function oraclize_query(string datasource, bytes[4] args, uint gaslimit) oraclizeAPI internal returns (bytes32 id) {
1207         bytes[] memory dynargs = new bytes[](4);
1208         dynargs[0] = args[0];
1209         dynargs[1] = args[1];
1210         dynargs[2] = args[2];
1211         dynargs[3] = args[3];
1212         return oraclize_query(datasource, dynargs, gaslimit);
1213     }
1214     function oraclize_query(string datasource, bytes[5] args) oraclizeAPI internal returns (bytes32 id) {
1215         bytes[] memory dynargs = new bytes[](5);
1216         dynargs[0] = args[0];
1217         dynargs[1] = args[1];
1218         dynargs[2] = args[2];
1219         dynargs[3] = args[3];
1220         dynargs[4] = args[4];
1221         return oraclize_query(datasource, dynargs);
1222     }
1223     function oraclize_query(uint timestamp, string datasource, bytes[5] args) oraclizeAPI internal returns (bytes32 id) {
1224         bytes[] memory dynargs = new bytes[](5);
1225         dynargs[0] = args[0];
1226         dynargs[1] = args[1];
1227         dynargs[2] = args[2];
1228         dynargs[3] = args[3];
1229         dynargs[4] = args[4];
1230         return oraclize_query(timestamp, datasource, dynargs);
1231     }
1232     function oraclize_query(uint timestamp, string datasource, bytes[5] args, uint gaslimit) oraclizeAPI internal returns (bytes32 id) {
1233         bytes[] memory dynargs = new bytes[](5);
1234         dynargs[0] = args[0];
1235         dynargs[1] = args[1];
1236         dynargs[2] = args[2];
1237         dynargs[3] = args[3];
1238         dynargs[4] = args[4];
1239         return oraclize_query(timestamp, datasource, dynargs, gaslimit);
1240     }
1241     function oraclize_query(string datasource, bytes[5] args, uint gaslimit) oraclizeAPI internal returns (bytes32 id) {
1242         bytes[] memory dynargs = new bytes[](5);
1243         dynargs[0] = args[0];
1244         dynargs[1] = args[1];
1245         dynargs[2] = args[2];
1246         dynargs[3] = args[3];
1247         dynargs[4] = args[4];
1248         return oraclize_query(datasource, dynargs, gaslimit);
1249     }
1250 
1251     function oraclize_cbAddress() oraclizeAPI internal returns (address){
1252         return oraclize.cbAddress();
1253     }
1254     function oraclize_setProof(byte proofP) oraclizeAPI internal {
1255         return oraclize.setProofType(proofP);
1256     }
1257     function oraclize_setCustomGasPrice(uint gasPrice) oraclizeAPI internal {
1258         return oraclize.setCustomGasPrice(gasPrice);
1259     }
1260     function oraclize_setConfig(bytes32 config) oraclizeAPI internal {
1261         return oraclize.setConfig(config);
1262     }
1263 
1264     function oraclize_randomDS_getSessionPubKeyHash() oraclizeAPI internal returns (bytes32){
1265         return oraclize.randomDS_getSessionPubKeyHash();
1266     }
1267 
1268     function getCodeSize(address _addr) constant internal returns(uint _size) {
1269         assembly {
1270             _size := extcodesize(_addr)
1271         }
1272     }
1273 
1274     function parseAddr(string _a) internal returns (address){
1275         bytes memory tmp = bytes(_a);
1276         uint160 iaddr = 0;
1277         uint160 b1;
1278         uint160 b2;
1279         for (uint i=2; i<2+2*20; i+=2){
1280             iaddr *= 256;
1281             b1 = uint160(tmp[i]);
1282             b2 = uint160(tmp[i+1]);
1283             if ((b1 >= 97)&&(b1 <= 102)) b1 -= 87;
1284             else if ((b1 >= 65)&&(b1 <= 70)) b1 -= 55;
1285             else if ((b1 >= 48)&&(b1 <= 57)) b1 -= 48;
1286             if ((b2 >= 97)&&(b2 <= 102)) b2 -= 87;
1287             else if ((b2 >= 65)&&(b2 <= 70)) b2 -= 55;
1288             else if ((b2 >= 48)&&(b2 <= 57)) b2 -= 48;
1289             iaddr += (b1*16+b2);
1290         }
1291         return address(iaddr);
1292     }
1293 
1294     function strCompare(string _a, string _b) internal returns (int) {
1295         bytes memory a = bytes(_a);
1296         bytes memory b = bytes(_b);
1297         uint minLength = a.length;
1298         if (b.length < minLength) minLength = b.length;
1299         for (uint i = 0; i < minLength; i ++)
1300             if (a[i] < b[i])
1301                 return -1;
1302             else if (a[i] > b[i])
1303                 return 1;
1304         if (a.length < b.length)
1305             return -1;
1306         else if (a.length > b.length)
1307             return 1;
1308         else
1309             return 0;
1310     }
1311 
1312     function indexOf(string _haystack, string _needle) internal returns (int) {
1313         bytes memory h = bytes(_haystack);
1314         bytes memory n = bytes(_needle);
1315         if(h.length < 1 || n.length < 1 || (n.length > h.length))
1316             return -1;
1317         else if(h.length > (2**128 -1))
1318             return -1;
1319         else
1320         {
1321             uint subindex = 0;
1322             for (uint i = 0; i < h.length; i ++)
1323             {
1324                 if (h[i] == n[0])
1325                 {
1326                     subindex = 1;
1327                     while(subindex < n.length && (i + subindex) < h.length && h[i + subindex] == n[subindex])
1328                     {
1329                         subindex++;
1330                     }
1331                     if(subindex == n.length)
1332                         return int(i);
1333                 }
1334             }
1335             return -1;
1336         }
1337     }
1338 
1339     function strConcat(string _a, string _b, string _c, string _d, string _e) internal returns (string) {
1340         bytes memory _ba = bytes(_a);
1341         bytes memory _bb = bytes(_b);
1342         bytes memory _bc = bytes(_c);
1343         bytes memory _bd = bytes(_d);
1344         bytes memory _be = bytes(_e);
1345         string memory abcde = new string(_ba.length + _bb.length + _bc.length + _bd.length + _be.length);
1346         bytes memory babcde = bytes(abcde);
1347         uint k = 0;
1348         for (uint i = 0; i < _ba.length; i++) babcde[k++] = _ba[i];
1349         for (i = 0; i < _bb.length; i++) babcde[k++] = _bb[i];
1350         for (i = 0; i < _bc.length; i++) babcde[k++] = _bc[i];
1351         for (i = 0; i < _bd.length; i++) babcde[k++] = _bd[i];
1352         for (i = 0; i < _be.length; i++) babcde[k++] = _be[i];
1353         return string(babcde);
1354     }
1355 
1356     function strConcat(string _a, string _b, string _c, string _d) internal returns (string) {
1357         return strConcat(_a, _b, _c, _d, "");
1358     }
1359 
1360     function strConcat(string _a, string _b, string _c) internal returns (string) {
1361         return strConcat(_a, _b, _c, "", "");
1362     }
1363 
1364     function strConcat(string _a, string _b) internal returns (string) {
1365         return strConcat(_a, _b, "", "", "");
1366     }
1367 
1368     // parseInt
1369     function parseInt(string _a) internal returns (uint) {
1370         return parseInt(_a, 0);
1371     }
1372 
1373     // parseInt(parseFloat*10^_b)
1374     function parseInt(string _a, uint _b) internal returns (uint) {
1375         bytes memory bresult = bytes(_a);
1376         uint mint = 0;
1377         bool decimals = false;
1378         for (uint i=0; i<bresult.length; i++){
1379             if ((bresult[i] >= 48)&&(bresult[i] <= 57)){
1380                 if (decimals){
1381                    if (_b == 0) break;
1382                     else _b--;
1383                 }
1384                 mint *= 10;
1385                 mint += uint(bresult[i]) - 48;
1386             } else if (bresult[i] == 46) decimals = true;
1387         }
1388         if (_b > 0) mint *= 10**_b;
1389         return mint;
1390     }
1391 
1392     function uint2str(uint i) internal returns (string){
1393         if (i == 0) return "0";
1394         uint j = i;
1395         uint len;
1396         while (j != 0){
1397             len++;
1398             j /= 10;
1399         }
1400         bytes memory bstr = new bytes(len);
1401         uint k = len - 1;
1402         while (i != 0){
1403             bstr[k--] = byte(48 + i % 10);
1404             i /= 10;
1405         }
1406         return string(bstr);
1407     }
1408 
1409     using CBOR for Buffer.buffer;
1410     function stra2cbor(string[] arr) internal constant returns (bytes) {
1411         Buffer.buffer memory buf;
1412         Buffer.init(buf, 1024);
1413         buf.startArray();
1414         for (uint i = 0; i < arr.length; i++) {
1415             buf.encodeString(arr[i]);
1416         }
1417         buf.endSequence();
1418         return buf.buf;
1419     }
1420 
1421     function ba2cbor(bytes[] arr) internal constant returns (bytes) {
1422         Buffer.buffer memory buf;
1423         Buffer.init(buf, 1024);
1424         buf.startArray();
1425         for (uint i = 0; i < arr.length; i++) {
1426             buf.encodeBytes(arr[i]);
1427         }
1428         buf.endSequence();
1429         return buf.buf;
1430     }
1431 
1432     string oraclize_network_name;
1433     function oraclize_setNetworkName(string _network_name) internal {
1434         oraclize_network_name = _network_name;
1435     }
1436 
1437     function oraclize_getNetworkName() internal returns (string) {
1438         return oraclize_network_name;
1439     }
1440 
1441     function oraclize_newRandomDSQuery(uint _delay, uint _nbytes, uint _customGasLimit) internal returns (bytes32){
1442         if ((_nbytes == 0)||(_nbytes > 32)) throw;
1443 	// Convert from seconds to ledger timer ticks
1444         _delay *= 10;
1445         bytes memory nbytes = new bytes(1);
1446         nbytes[0] = byte(_nbytes);
1447         bytes memory unonce = new bytes(32);
1448         bytes memory sessionKeyHash = new bytes(32);
1449         bytes32 sessionKeyHash_bytes32 = oraclize_randomDS_getSessionPubKeyHash();
1450         assembly {
1451             mstore(unonce, 0x20)
1452             mstore(add(unonce, 0x20), xor(blockhash(sub(number, 1)), xor(coinbase, timestamp)))
1453             mstore(sessionKeyHash, 0x20)
1454             mstore(add(sessionKeyHash, 0x20), sessionKeyHash_bytes32)
1455         }
1456         bytes memory delay = new bytes(32);
1457         assembly {
1458             mstore(add(delay, 0x20), _delay)
1459         }
1460 
1461         bytes memory delay_bytes8 = new bytes(8);
1462         copyBytes(delay, 24, 8, delay_bytes8, 0);
1463 
1464         bytes[4] memory args = [unonce, nbytes, sessionKeyHash, delay];
1465         bytes32 queryId = oraclize_query("random", args, _customGasLimit);
1466 
1467         bytes memory delay_bytes8_left = new bytes(8);
1468 
1469         assembly {
1470             let x := mload(add(delay_bytes8, 0x20))
1471             mstore8(add(delay_bytes8_left, 0x27), div(x, 0x100000000000000000000000000000000000000000000000000000000000000))
1472             mstore8(add(delay_bytes8_left, 0x26), div(x, 0x1000000000000000000000000000000000000000000000000000000000000))
1473             mstore8(add(delay_bytes8_left, 0x25), div(x, 0x10000000000000000000000000000000000000000000000000000000000))
1474             mstore8(add(delay_bytes8_left, 0x24), div(x, 0x100000000000000000000000000000000000000000000000000000000))
1475             mstore8(add(delay_bytes8_left, 0x23), div(x, 0x1000000000000000000000000000000000000000000000000000000))
1476             mstore8(add(delay_bytes8_left, 0x22), div(x, 0x10000000000000000000000000000000000000000000000000000))
1477             mstore8(add(delay_bytes8_left, 0x21), div(x, 0x100000000000000000000000000000000000000000000000000))
1478             mstore8(add(delay_bytes8_left, 0x20), div(x, 0x1000000000000000000000000000000000000000000000000))
1479 
1480         }
1481 
1482         oraclize_randomDS_setCommitment(queryId, sha3(delay_bytes8_left, args[1], sha256(args[0]), args[2]));
1483         return queryId;
1484     }
1485 
1486     function oraclize_randomDS_setCommitment(bytes32 queryId, bytes32 commitment) internal {
1487         oraclize_randomDS_args[queryId] = commitment;
1488     }
1489 
1490     mapping(bytes32=>bytes32) oraclize_randomDS_args;
1491     mapping(bytes32=>bool) oraclize_randomDS_sessionKeysHashVerified;
1492 
1493     function verifySig(bytes32 tosignh, bytes dersig, bytes pubkey) internal returns (bool){
1494         bool sigok;
1495         address signer;
1496 
1497         bytes32 sigr;
1498         bytes32 sigs;
1499 
1500         bytes memory sigr_ = new bytes(32);
1501         uint offset = 4+(uint(dersig[3]) - 0x20);
1502         sigr_ = copyBytes(dersig, offset, 32, sigr_, 0);
1503         bytes memory sigs_ = new bytes(32);
1504         offset += 32 + 2;
1505         sigs_ = copyBytes(dersig, offset+(uint(dersig[offset-1]) - 0x20), 32, sigs_, 0);
1506 
1507         assembly {
1508             sigr := mload(add(sigr_, 32))
1509             sigs := mload(add(sigs_, 32))
1510         }
1511 
1512 
1513         (sigok, signer) = safer_ecrecover(tosignh, 27, sigr, sigs);
1514         if (address(sha3(pubkey)) == signer) return true;
1515         else {
1516             (sigok, signer) = safer_ecrecover(tosignh, 28, sigr, sigs);
1517             return (address(sha3(pubkey)) == signer);
1518         }
1519     }
1520 
1521     function oraclize_randomDS_proofVerify__sessionKeyValidity(bytes proof, uint sig2offset) internal returns (bool) {
1522         bool sigok;
1523 
1524         // Step 6: verify the attestation signature, APPKEY1 must sign the sessionKey from the correct ledger app (CODEHASH)
1525         bytes memory sig2 = new bytes(uint(proof[sig2offset+1])+2);
1526         copyBytes(proof, sig2offset, sig2.length, sig2, 0);
1527 
1528         bytes memory appkey1_pubkey = new bytes(64);
1529         copyBytes(proof, 3+1, 64, appkey1_pubkey, 0);
1530 
1531         bytes memory tosign2 = new bytes(1+65+32);
1532         tosign2[0] = 1; //role
1533         copyBytes(proof, sig2offset-65, 65, tosign2, 1);
1534         bytes memory CODEHASH = hex"fd94fa71bc0ba10d39d464d0d8f465efeef0a2764e3887fcc9df41ded20f505c";
1535         copyBytes(CODEHASH, 0, 32, tosign2, 1+65);
1536         sigok = verifySig(sha256(tosign2), sig2, appkey1_pubkey);
1537 
1538         if (sigok == false) return false;
1539 
1540 
1541         // Step 7: verify the APPKEY1 provenance (must be signed by Ledger)
1542         bytes memory LEDGERKEY = hex"7fb956469c5c9b89840d55b43537e66a98dd4811ea0a27224272c2e5622911e8537a2f8e86a46baec82864e98dd01e9ccc2f8bc5dfc9cbe5a91a290498dd96e4";
1543 
1544         bytes memory tosign3 = new bytes(1+65);
1545         tosign3[0] = 0xFE;
1546         copyBytes(proof, 3, 65, tosign3, 1);
1547 
1548         bytes memory sig3 = new bytes(uint(proof[3+65+1])+2);
1549         copyBytes(proof, 3+65, sig3.length, sig3, 0);
1550 
1551         sigok = verifySig(sha256(tosign3), sig3, LEDGERKEY);
1552 
1553         return sigok;
1554     }
1555 
1556     modifier oraclize_randomDS_proofVerify(bytes32 _queryId, string _result, bytes _proof) {
1557         // Step 1: the prefix has to match 'LP\x01' (Ledger Proof version 1)
1558         if ((_proof[0] != "L")||(_proof[1] != "P")||(_proof[2] != 1)) throw;
1559 
1560         bool proofVerified = oraclize_randomDS_proofVerify__main(_proof, _queryId, bytes(_result), oraclize_getNetworkName());
1561         if (proofVerified == false) throw;
1562 
1563         _;
1564     }
1565 
1566     function oraclize_randomDS_proofVerify__returnCode(bytes32 _queryId, string _result, bytes _proof) internal returns (uint8){
1567         // Step 1: the prefix has to match 'LP\x01' (Ledger Proof version 1)
1568         if ((_proof[0] != "L")||(_proof[1] != "P")||(_proof[2] != 1)) return 1;
1569 
1570         bool proofVerified = oraclize_randomDS_proofVerify__main(_proof, _queryId, bytes(_result), oraclize_getNetworkName());
1571         if (proofVerified == false) return 2;
1572 
1573         return 0;
1574     }
1575 
1576     function matchBytes32Prefix(bytes32 content, bytes prefix, uint n_random_bytes) internal returns (bool){
1577         bool match_ = true;
1578 
1579 	if (prefix.length != n_random_bytes) throw;
1580 
1581         for (uint256 i=0; i< n_random_bytes; i++) {
1582             if (content[i] != prefix[i]) match_ = false;
1583         }
1584 
1585         return match_;
1586     }
1587 
1588     function oraclize_randomDS_proofVerify__main(bytes proof, bytes32 queryId, bytes result, string context_name) internal returns (bool){
1589 
1590         // Step 2: the unique keyhash has to match with the sha256 of (context name + queryId)
1591         uint ledgerProofLength = 3+65+(uint(proof[3+65+1])+2)+32;
1592         bytes memory keyhash = new bytes(32);
1593         copyBytes(proof, ledgerProofLength, 32, keyhash, 0);
1594         if (!(sha3(keyhash) == sha3(sha256(context_name, queryId)))) return false;
1595 
1596         bytes memory sig1 = new bytes(uint(proof[ledgerProofLength+(32+8+1+32)+1])+2);
1597         copyBytes(proof, ledgerProofLength+(32+8+1+32), sig1.length, sig1, 0);
1598 
1599         // Step 3: we assume sig1 is valid (it will be verified during step 5) and we verify if 'result' is the prefix of sha256(sig1)
1600         if (!matchBytes32Prefix(sha256(sig1), result, uint(proof[ledgerProofLength+32+8]))) return false;
1601 
1602         // Step 4: commitment match verification, sha3(delay, nbytes, unonce, sessionKeyHash) == commitment in storage.
1603         // This is to verify that the computed args match with the ones specified in the query.
1604         bytes memory commitmentSlice1 = new bytes(8+1+32);
1605         copyBytes(proof, ledgerProofLength+32, 8+1+32, commitmentSlice1, 0);
1606 
1607         bytes memory sessionPubkey = new bytes(64);
1608         uint sig2offset = ledgerProofLength+32+(8+1+32)+sig1.length+65;
1609         copyBytes(proof, sig2offset-64, 64, sessionPubkey, 0);
1610 
1611         bytes32 sessionPubkeyHash = sha256(sessionPubkey);
1612         if (oraclize_randomDS_args[queryId] == sha3(commitmentSlice1, sessionPubkeyHash)){ //unonce, nbytes and sessionKeyHash match
1613             delete oraclize_randomDS_args[queryId];
1614         } else return false;
1615 
1616 
1617         // Step 5: validity verification for sig1 (keyhash and args signed with the sessionKey)
1618         bytes memory tosign1 = new bytes(32+8+1+32);
1619         copyBytes(proof, ledgerProofLength, 32+8+1+32, tosign1, 0);
1620         if (!verifySig(sha256(tosign1), sig1, sessionPubkey)) return false;
1621 
1622         // verify if sessionPubkeyHash was verified already, if not.. let's do it!
1623         if (oraclize_randomDS_sessionKeysHashVerified[sessionPubkeyHash] == false){
1624             oraclize_randomDS_sessionKeysHashVerified[sessionPubkeyHash] = oraclize_randomDS_proofVerify__sessionKeyValidity(proof, sig2offset);
1625         }
1626 
1627         return oraclize_randomDS_sessionKeysHashVerified[sessionPubkeyHash];
1628     }
1629 
1630 
1631     // the following function has been written by Alex Beregszaszi (@axic), use it under the terms of the MIT license
1632     function copyBytes(bytes from, uint fromOffset, uint length, bytes to, uint toOffset) internal returns (bytes) {
1633         uint minLength = length + toOffset;
1634 
1635         if (to.length < minLength) {
1636             // Buffer too small
1637             throw; // Should be a better way?
1638         }
1639 
1640         // NOTE: the offset 32 is added to skip the `size` field of both bytes variables
1641         uint i = 32 + fromOffset;
1642         uint j = 32 + toOffset;
1643 
1644         while (i < (32 + fromOffset + length)) {
1645             assembly {
1646                 let tmp := mload(add(from, i))
1647                 mstore(add(to, j), tmp)
1648             }
1649             i += 32;
1650             j += 32;
1651         }
1652 
1653         return to;
1654     }
1655 
1656     // the following function has been written by Alex Beregszaszi (@axic), use it under the terms of the MIT license
1657     // Duplicate Solidity's ecrecover, but catching the CALL return value
1658     function safer_ecrecover(bytes32 hash, uint8 v, bytes32 r, bytes32 s) internal returns (bool, address) {
1659         // We do our own memory management here. Solidity uses memory offset
1660         // 0x40 to store the current end of memory. We write past it (as
1661         // writes are memory extensions), but don't update the offset so
1662         // Solidity will reuse it. The memory used here is only needed for
1663         // this context.
1664 
1665         // FIXME: inline assembly can't access return values
1666         bool ret;
1667         address addr;
1668 
1669         assembly {
1670             let size := mload(0x40)
1671             mstore(size, hash)
1672             mstore(add(size, 32), v)
1673             mstore(add(size, 64), r)
1674             mstore(add(size, 96), s)
1675 
1676             // NOTE: we can reuse the request memory because we deal with
1677             //       the return code
1678             ret := call(3000, 1, 0, size, 128, size, 32)
1679             addr := mload(size)
1680         }
1681 
1682         return (ret, addr);
1683     }
1684 
1685     // the following function has been written by Alex Beregszaszi (@axic), use it under the terms of the MIT license
1686     function ecrecovery(bytes32 hash, bytes sig) internal returns (bool, address) {
1687         bytes32 r;
1688         bytes32 s;
1689         uint8 v;
1690 
1691         if (sig.length != 65)
1692           return (false, 0);
1693 
1694         // The signature format is a compact form of:
1695         //   {bytes32 r}{bytes32 s}{uint8 v}
1696         // Compact means, uint8 is not padded to 32 bytes.
1697         assembly {
1698             r := mload(add(sig, 32))
1699             s := mload(add(sig, 64))
1700 
1701             // Here we are loading the last 32 bytes. We exploit the fact that
1702             // 'mload' will pad with zeroes if we overread.
1703             // There is no 'mload8' to do this, but that would be nicer.
1704             v := byte(0, mload(add(sig, 96)))
1705 
1706             // Alternative solution:
1707             // 'byte' is not working due to the Solidity parser, so lets
1708             // use the second best option, 'and'
1709             // v := and(mload(add(sig, 65)), 255)
1710         }
1711 
1712         // albeit non-transactional signatures are not specified by the YP, one would expect it
1713         // to match the YP range of [27, 28]
1714         //
1715         // geth uses [0, 1] and some clients have followed. This might change, see:
1716         //  https://github.com/ethereum/go-ethereum/issues/2053
1717         if (v < 27)
1718           v += 27;
1719 
1720         if (v != 27 && v != 28)
1721             return (false, 0);
1722 
1723         return safer_ecrecover(hash, v, r, s);
1724     }
1725 
1726 }
1727 // </ORACLIZE_API>
1728 
1729 contract BitLumensCrowdsale is Ownable, ICOEngineInterface, KYCBase,usingOraclize {
1730     using  SafeMath for uint;
1731     enum State {Running,Success,Failure}
1732 
1733     // Current ETH/USD exchange rate
1734     uint256 public ETH_USD_EXCHANGE_CENTS= 500;// must be set by orcalize
1735 
1736     // Everything oraclize related
1737     event updatedPrice(string price);
1738     event newOraclizeQuery(string description);
1739     uint public oraclizeQueryCost;
1740 
1741     uint public etherPriceUSD;
1742     event Log(string text);
1743 
1744 
1745     uint public USD_SOFT_CAP;
1746     uint public USD_HARD_CAP;
1747 
1748     uint public BLS_TOTAL_CAP;
1749     uint public BLS_PRE_ICO;
1750 
1751     State public state;
1752 
1753     BLS public token;
1754 
1755     address public wallet;
1756     address bitlumensAccount= 0x40d41c859016ec561891526334881326f429b513;
1757     address teamAccount= 0xdf71b93617e5197cee3b9ad7ad05934467f95f44;
1758     address bountyAccount= 0x1b7b2c0a8d0032de88910f7ff5838f5f35bc9537;
1759 
1760     // from ICOEngineInterface
1761     uint public startTime;
1762     uint public endTime;
1763     // Time Rounds for ICO
1764     uint public roundTwoTime;
1765     uint public roundThreeTime;
1766     uint public roundFourTime;
1767     uint public roundFiveTime;
1768 
1769     // Discount multipliers , we will divide by 10 later -- divede by 10 later
1770     uint public constant TOKEN_FIRST_PRICE_RATE  = 20;
1771     uint public constant TOKEN_SECOND_PRICE_RATE = 15;
1772     uint public constant TOKEN_THIRD_PRICE_RATE  = 14;
1773     uint public constant TOKEN_FOURTH_PRICE_RATE  = 13;
1774     uint public constant TOKEN_FIFTH_PRICE_RATE = 12;
1775 
1776 
1777     // to track if team members already got their tokens
1778     bool public teamTokensDelivered = false;
1779     bool public bountyDelivered = false;
1780     bool public bitlumensDelivered = false;
1781 
1782     // from ICOEngineInterface
1783     uint public remainingTokens;
1784     // from ICOEngineInterface
1785     uint public totalTokens;
1786 
1787     // amount of wei raised
1788     uint public weiRaised;
1789 
1790     //amount of $$ raised
1791     uint public dollarRaised;
1792 
1793     // boolean to make sure preallocate is called only once
1794     bool public isPreallocated;
1795 
1796     // vault for refunding
1797     RefundVault public vault;
1798 
1799     /**
1800      * event for token purchase logging
1801      * @param purchaser who paid for the tokens
1802      * @param beneficiary who got the token
1803      * @param value weis paid for purchase
1804      * @param amount amount of tokens purchased
1805      */
1806     event TokenPurchase(address indexed purchaser, address indexed beneficiary, uint256 value, uint256 amount);
1807 
1808     /* event for ICO successfully finalized */
1809     event FinalizedOK();
1810 
1811     /* event for ICO not successfully finalized */
1812     event FinalizedNOK();
1813 
1814     /**
1815      * event for additional token minting
1816      * @param to who got the tokens
1817      * @param amount amount of tokens purchased
1818      */
1819     event Preallocated(address indexed to, uint256 amount);
1820 
1821     /**
1822      *  Constructor
1823      */
1824     function BitLumensCrowdsale(
1825       address [] kycSigner,
1826       address _token,
1827       address _wallet,
1828       uint _startTime,
1829       uint _roundTwoTime,
1830       uint _roundThreeTime,
1831       uint _roundFourTime,
1832       uint _roundFiveTime,
1833       uint _endTime,
1834       uint _BlsPreIco,
1835       uint _blsTotalCap,
1836       uint _softCapUsd,
1837       uint _hardCapUsd,
1838       uint _ethUsdExchangeCents
1839       )
1840         public payable
1841         KYCBase(kycSigner)
1842     {
1843         require(_token != address(0));
1844         require(_wallet != address(0));
1845 
1846         require(bitlumensAccount != address(0));
1847         require(teamAccount != address(0));
1848         require(bountyAccount != address(0));
1849         //please make sure that the start in 3)depoly_tokenSale is larger than now before migrate
1850         require(_startTime > now);
1851         require (_startTime < _roundTwoTime);
1852         require (_roundTwoTime < _roundThreeTime);
1853         require (_roundThreeTime < _roundFourTime);
1854         require (_roundFourTime < _roundFiveTime);
1855         require (_roundFiveTime < _endTime);
1856 
1857 
1858       // OAR = OraclizeAddrResolverI(0xDD6CdC488799a0C6ABF7339f7FBFbb9B8C7C84f6);
1859 
1860 
1861         token = BLS(_token);
1862         wallet = _wallet;
1863 
1864         startTime = _startTime;
1865         endTime = _endTime;
1866         roundTwoTime= _roundTwoTime;
1867         roundThreeTime= _roundThreeTime;
1868         roundFourTime= _roundFourTime;
1869         roundFiveTime= _roundFiveTime;
1870 
1871         ETH_USD_EXCHANGE_CENTS = _ethUsdExchangeCents;
1872 
1873         USD_SOFT_CAP = _softCapUsd;
1874         USD_HARD_CAP = _hardCapUsd;
1875 
1876         BLS_PRE_ICO = _BlsPreIco;
1877         BLS_TOTAL_CAP = _blsTotalCap;
1878         totalTokens = _blsTotalCap;
1879         remainingTokens = _blsTotalCap;
1880 
1881         vault = new RefundVault(_wallet);
1882 
1883         state = State.Running;
1884 
1885        oraclize_setCustomGasPrice(100000000000 wei); // set the gas price a little bit higher, so the pricefeed definitely works
1886        updatePrice();
1887        oraclizeQueryCost = oraclize_getPrice("URL");
1888 
1889     }
1890 
1891 
1892 
1893     /// oraclize START
1894 
1895         // @dev oraclize is called recursively here - once a callback fetches the newest ETH price, the next callback is scheduled for the next hour again
1896         function __callback(bytes32 myid, string result) {
1897             require(msg.sender == oraclize_cbAddress());
1898             // setting the token price here
1899             ETH_USD_EXCHANGE_CENTS = SafeMath.parse(result);
1900             updatedPrice(result);
1901             // fetch the next price
1902             updatePrice();
1903         }
1904 
1905         function updatePrice() payable {    // can be left public as a way for replenishing contract's ETH balance, just in case
1906             if (msg.sender != oraclize_cbAddress()) {
1907                 require(msg.value >= 200 finney);
1908             }
1909             if (oraclize_getPrice("URL") > this.balance) {
1910                 newOraclizeQuery("Oraclize query was NOT sent, please add some ETH to cover for the query fee");
1911             } else {
1912                 newOraclizeQuery("Oraclize sent, wait..");
1913                 // Schedule query in 1 hour. Set the gas amount to 220000, as parsing in __callback takes around 70000 - we play it safe.
1914                 //the time will be changed to higher value in real network(60 - > 3600 )
1915                 oraclize_query(86400, "URL", "json(https://min-api.cryptocompare.com/data/price?fsym=ETH&tsyms=USD).USD", 220000);
1916             }
1917         }
1918         //// oraclize END
1919 
1920     // function that is called from KYCBase
1921     function releaseTokensTo(address buyer) internal returns(bool) {
1922         // needs to be started
1923         require(started());
1924         require(!ended());
1925 
1926         //get the amount send in wei
1927         uint256 weiAmount = msg.value;
1928 
1929 
1930         uint256 WeiDollars = weiAmount.mul(ETH_USD_EXCHANGE_CENTS);
1931         // ammount of dollars X 1e18 (1token)
1932         WeiDollars = WeiDollars.div(100);
1933 
1934         //calculating number of tokens x 10 to prevent decemil
1935         uint256 currentPrice = price();
1936         uint tokens = WeiDollars.mul(currentPrice);
1937 
1938         //fix the number of tokens
1939         tokens = tokens.div(10);
1940 
1941         //calculate tokens Raised by subtracting total tokens from remaining tokens
1942         uint tokenRaised = totalTokens.sub(remainingTokens) ;
1943 
1944         // check if total token raised + the tokens calculated for investor <= (pre ico token limit)
1945         if(now < roundTwoTime ){
1946           require(tokenRaised.add(tokens) <= BLS_PRE_ICO);
1947         }
1948 
1949         //check if total token raised + the tokens calculated for investor <= (total token cap)
1950         require(tokenRaised.add(tokens) <= BLS_TOTAL_CAP);
1951 
1952         //check if hard cap is reached
1953         weiRaised = weiRaised.add(weiAmount);
1954         // total usd in wallet
1955         uint centsWeiRaised = weiRaised.mul(ETH_USD_EXCHANGE_CENTS);
1956         uint goal  = USD_HARD_CAP * (10**18) * (10**2);
1957 
1958         // if 25,000,000 $$ raised stop the ico
1959         require(centsWeiRaised <= goal);
1960 
1961         //decrease the number of remaining tokens
1962         remainingTokens = remainingTokens.sub(tokens);
1963 
1964         // mint tokens and transfer funds to investor
1965         token.mint(buyer, tokens);
1966         forwardFunds();
1967         TokenPurchase(msg.sender, buyer, weiAmount, tokens);
1968         return true;
1969     }
1970 
1971     function forwardFunds() internal {
1972       vault.deposit.value(msg.value)(msg.sender);
1973     }
1974 
1975 
1976     function finalize() onlyOwner public {
1977       require(state == State.Running);
1978       require(ended());
1979 
1980       uint centsWeiRaised = weiRaised.mul(ETH_USD_EXCHANGE_CENTS);
1981       uint minGoal  = USD_SOFT_CAP * (10**18) * (10**2);
1982 
1983       // Check the soft goal reaching
1984       if(centsWeiRaised >= minGoal) {
1985 
1986         //token Raised
1987         uint tokenRaised = totalTokens - remainingTokens;
1988         //bitlumes tokes 25% equivelent to (tokenraied / 2) (token raised = 50 %)
1989         uint bitlumensTokens = tokenRaised.div(2);
1990         uint bountyTokens = 4 * bitlumensTokens.div(100);
1991         uint TeamTokens = bitlumensTokens.sub(bountyTokens);
1992 
1993 
1994         token.mint(bitlumensAccount, bitlumensTokens);
1995         token.mint(teamAccount, TeamTokens);
1996         token.mint(bountyAccount, bountyTokens);
1997 
1998         teamTokensDelivered = true;
1999         bountyDelivered = true;
2000         bitlumensDelivered = true;
2001 
2002         // if goal reached
2003         // stop the minting
2004         token.finishMinting();
2005         // enable token transfers
2006         token.enableTokenTransfers();
2007         // close the vault and transfer funds to wallet
2008         vault.close();
2009         // ICO successfully finalized
2010         // set state to Success
2011         state = State.Success;
2012         FinalizedOK();
2013       }
2014       else {
2015         // if goal NOT reached
2016         // ICO not successfully finalized
2017         finalizeNOK();
2018       }
2019     }
2020 
2021 
2022 
2023      function finalizeNOK() onlyOwner public {
2024        // run checks again because this is a public function
2025        require(state == State.Running);
2026        require(ended());
2027        // enable the refunds
2028        vault.enableRefunds();
2029        // ICO not successfully finalised
2030        // set state to Failure
2031        state = State.Failure;
2032        FinalizedNOK();
2033      }
2034 
2035      // if crowdsale is unsuccessful, investors can claim refunds here
2036      function claimRefund() public {
2037        require(state == State.Failure);
2038        vault.refund(msg.sender);
2039     }
2040 
2041 
2042     // from ICOEngineInterface
2043     function started() public view returns(bool) {
2044         return now >= startTime;
2045     }
2046 
2047     // from ICOEngineInterface
2048     function ended() public view returns(bool) {
2049         return now >= endTime || remainingTokens == 0;
2050     }
2051 
2052     function startTime() public view returns(uint) {
2053       return(startTime);
2054     }
2055 
2056     function endTime() public view returns(uint){
2057       return(endTime);
2058     }
2059 
2060     function totalTokens() public view returns(uint){
2061       return(totalTokens);
2062     }
2063 
2064     function remainingTokens() public view returns(uint){
2065       return(remainingTokens);
2066     }
2067 
2068     // return the price as number of tokens released for each ether
2069     function price() public view returns(uint){
2070       // determine which discount to apply
2071       if (now < roundTwoTime) {
2072           return(TOKEN_FIRST_PRICE_RATE);
2073       } else if (now < roundThreeTime){
2074           return (TOKEN_SECOND_PRICE_RATE);
2075       } else if (now < roundFourTime) {
2076           return (TOKEN_THIRD_PRICE_RATE);
2077       }else if (now < roundFiveTime) {
2078           return (TOKEN_FOURTH_PRICE_RATE);
2079       } else {
2080           return (TOKEN_FIFTH_PRICE_RATE);
2081       }
2082     }
2083 
2084     // No payable fallback function, the tokens must be buyed using the functions buyTokens and buyTokensFor
2085     function () public {
2086         revert();
2087     }
2088 
2089 }