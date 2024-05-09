1 pragma solidity ^0.4.22;
2 
3 // File: zeppelin-solidity/contracts/math/SafeMath.sol
4 
5 /**
6  * @title SafeMath
7  * @dev Math operations with safety checks that throw on error
8  */
9 library SafeMath {
10 
11   /**
12   * @dev Multiplies two numbers, throws on overflow.
13   */
14   function mul(uint256 a, uint256 b) internal pure returns (uint256) {
15     if (a == 0) {
16       return 0;
17     }
18     uint256 c = a * b;
19     assert(c / a == b);
20     return c;
21   }
22 
23   /**
24   * @dev Integer division of two numbers, truncating the quotient.
25   */
26   function div(uint256 a, uint256 b) internal pure returns (uint256) {
27     // assert(b > 0); // Solidity automatically throws when dividing by 0
28     uint256 c = a / b;
29     // assert(a == b * c + a % b); // There is no case in which this doesn't hold
30     return c;
31   }
32 
33   /**
34   * @dev Subtracts two numbers, throws on overflow (i.e. if subtrahend is greater than minuend).
35   */
36   function sub(uint256 a, uint256 b) internal pure returns (uint256) {
37     assert(b <= a);
38     return a - b;
39   }
40 
41   /**
42   * @dev Adds two numbers, throws on overflow.
43   */
44   function add(uint256 a, uint256 b) internal pure returns (uint256) {
45     uint256 c = a + b;
46     assert(c >= a);
47     return c;
48   }
49 }
50 
51 // File: zeppelin-solidity/contracts/ownership/Ownable.sol
52 
53 /**
54  * @title Ownable
55  * @dev The Ownable contract has an owner address, and provides basic authorization control
56  * functions, this simplifies the implementation of "user permissions".
57  */
58 contract Ownable {
59   address public owner;
60 
61 
62   event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
63 
64 
65   /**
66    * @dev The Ownable constructor sets the original `owner` of the contract to the sender
67    * account.
68    */
69   function Ownable() public {
70     owner = msg.sender;
71   }
72 
73   /**
74    * @dev Throws if called by any account other than the owner.
75    */
76   modifier onlyOwner() {
77     require(msg.sender == owner);
78     _;
79   }
80 
81   /**
82    * @dev Allows the current owner to transfer control of the contract to a newOwner.
83    * @param newOwner The address to transfer ownership to.
84    */
85   function transferOwnership(address newOwner) public onlyOwner {
86     require(newOwner != address(0));
87     OwnershipTransferred(owner, newOwner);
88     owner = newOwner;
89   }
90 
91 }
92 
93 // File: contracts/MainFabric.sol
94 
95 //import "./tokens/ERC20StandardToken.sol";
96 //import "./tokens/ERC20MintableToken.sol";
97 //import "./crowdsale/RefundCrowdsale.sol";
98 
99 contract MainFabric is Ownable {
100 
101     using SafeMath for uint256;
102 
103     struct Contract {
104         address addr;
105         address owner;
106         address fabric;
107         string contractType;
108         uint256 index;
109     }
110 
111     struct Fabric {
112         address addr;
113         address owner;
114         bool isActive;
115         uint256 index;
116     }
117 
118     struct Admin {
119         address addr;
120         address[] contratcs;
121         uint256 numContratcs;
122         uint256 index;
123     }
124 
125     // ---====== CONTRACTS ======---
126     /**
127      * @dev Get contract object by address
128      */
129     mapping(address => Contract) public contracts;
130 
131     /**
132      * @dev Contracts addresses list
133      */
134     address[] public contractsAddr;
135 
136     /**
137      * @dev Count of contracts in list
138      */
139     function numContracts() public view returns (uint256)
140     { return contractsAddr.length; }
141 
142 
143     // ---====== ADMINS ======---
144     /**
145      * @dev Get contract object by address
146      */
147     mapping(address => Admin) public admins;
148 
149     /**
150      * @dev Contracts addresses list
151      */
152     address[] public adminsAddr;
153 
154     /**
155      * @dev Count of contracts in list
156      */
157     function numAdmins() public view returns (uint256)
158     { return adminsAddr.length; }
159 
160     function getAdminContract(address _adminAddress, uint256 _index) public view returns (
161         address
162     ) {
163         return (
164             admins[_adminAddress].contratcs[_index]
165         );
166     }
167 
168     // ---====== FABRICS ======---
169     /**
170      * @dev Get fabric object by address
171      */
172     mapping(address => Fabric) public fabrics;
173 
174     /**
175      * @dev Fabrics addresses list
176      */
177     address[] public fabricsAddr;
178 
179     /**
180      * @dev Count of fabrics in list
181      */
182     function numFabrics() public view returns (uint256)
183     { return fabricsAddr.length; }
184 
185     /**
186    * @dev Throws if called by any account other than the owner.
187    */
188     modifier onlyFabric() {
189         require(fabrics[msg.sender].isActive);
190         _;
191     }
192 
193     // ---====== CONSTRUCTOR ======---
194 
195     function MainFabric() public {
196 
197     }
198 
199     /**
200      * @dev Add fabric
201      * @param _address Fabric address
202      */
203     function addFabric(
204         address _address
205     )
206     public
207     onlyOwner
208     returns (bool)
209     {
210         fabrics[_address].addr = _address;
211         fabrics[_address].owner = msg.sender;
212         fabrics[_address].isActive = true;
213         fabrics[_address].index = fabricsAddr.push(_address) - 1;
214 
215         return true;
216     }
217 
218     /**
219      * @dev Remove fabric
220      * @param _address Fabric address
221      */
222     function removeFabric(
223         address _address
224     )
225     public
226     onlyOwner
227     returns (bool)
228     {
229         require(fabrics[_address].isActive);
230         fabrics[_address].isActive = false;
231 
232         uint rowToDelete = fabrics[_address].index;
233         address keyToMove   = fabricsAddr[fabricsAddr.length-1];
234         fabricsAddr[rowToDelete] = keyToMove;
235         fabrics[keyToMove].index = rowToDelete;
236         fabricsAddr.length--;
237 
238         return true;
239     }
240 
241     /**
242      * @dev Create refund crowdsale
243      * @param _address Fabric address
244      */
245     function addContract(
246         address _address,
247         address _owner,
248         string _contractType
249     )
250     public
251     onlyFabric
252     returns (bool)
253     {
254         contracts[_address].addr = _address;
255         contracts[_address].owner = _owner;
256         contracts[_address].fabric = msg.sender;
257         contracts[_address].contractType = _contractType;
258         contracts[_address].index = contractsAddr.push(_address) - 1;
259 
260         if (admins[_owner].addr != _owner) {
261             admins[_owner].addr = _owner;
262             admins[_owner].index = adminsAddr.push(_owner) - 1;
263         }
264 
265         admins[_owner].contratcs.push(contracts[_address].addr);
266         admins[_owner].numContratcs++;
267 
268         return true;
269     }
270 }
271 
272 // File: contracts/tokens/ERC223/ERC223_receiving_contract.sol
273 
274 /**
275 * @title Contract that will work with ERC223 tokens.
276 */
277 
278 contract ERC223ReceivingContract {
279     /**
280      * @dev Standard ERC223 function that will handle incoming token transfers.
281      *
282      * @param _from  Token sender address.
283      * @param _value Amount of tokens.
284      * @param _data  Transaction metadata.
285      */
286     function tokenFallback(address _from, uint _value, bytes _data);
287 }
288 
289 // File: zeppelin-solidity/contracts/token/ERC20/ERC20Basic.sol
290 
291 /**
292  * @title ERC20Basic
293  * @dev Simpler version of ERC20 interface
294  * @dev see https://github.com/ethereum/EIPs/issues/179
295  */
296 contract ERC20Basic {
297   function totalSupply() public view returns (uint256);
298   function balanceOf(address who) public view returns (uint256);
299   function transfer(address to, uint256 value) public returns (bool);
300   event Transfer(address indexed from, address indexed to, uint256 value);
301 }
302 
303 // File: zeppelin-solidity/contracts/token/ERC20/BasicToken.sol
304 
305 /**
306  * @title Basic token
307  * @dev Basic version of StandardToken, with no allowances.
308  */
309 contract BasicToken is ERC20Basic {
310   using SafeMath for uint256;
311 
312   mapping(address => uint256) balances;
313 
314   uint256 totalSupply_;
315 
316   /**
317   * @dev total number of tokens in existence
318   */
319   function totalSupply() public view returns (uint256) {
320     return totalSupply_;
321   }
322 
323   /**
324   * @dev transfer token for a specified address
325   * @param _to The address to transfer to.
326   * @param _value The amount to be transferred.
327   */
328   function transfer(address _to, uint256 _value) public returns (bool) {
329     require(_to != address(0));
330     require(_value <= balances[msg.sender]);
331 
332     // SafeMath.sub will throw if there is not enough balance.
333     balances[msg.sender] = balances[msg.sender].sub(_value);
334     balances[_to] = balances[_to].add(_value);
335     Transfer(msg.sender, _to, _value);
336     return true;
337   }
338 
339   /**
340   * @dev Gets the balance of the specified address.
341   * @param _owner The address to query the the balance of.
342   * @return An uint256 representing the amount owned by the passed address.
343   */
344   function balanceOf(address _owner) public view returns (uint256 balance) {
345     return balances[_owner];
346   }
347 
348 }
349 
350 // File: zeppelin-solidity/contracts/token/ERC20/ERC20.sol
351 
352 /**
353  * @title ERC20 interface
354  * @dev see https://github.com/ethereum/EIPs/issues/20
355  */
356 contract ERC20 is ERC20Basic {
357   function allowance(address owner, address spender) public view returns (uint256);
358   function transferFrom(address from, address to, uint256 value) public returns (bool);
359   function approve(address spender, uint256 value) public returns (bool);
360   event Approval(address indexed owner, address indexed spender, uint256 value);
361 }
362 
363 // File: zeppelin-solidity/contracts/token/ERC20/StandardToken.sol
364 
365 /**
366  * @title Standard ERC20 token
367  *
368  * @dev Implementation of the basic standard token.
369  * @dev https://github.com/ethereum/EIPs/issues/20
370  * @dev Based on code by FirstBlood: https://github.com/Firstbloodio/token/blob/master/smart_contract/FirstBloodToken.sol
371  */
372 contract StandardToken is ERC20, BasicToken {
373 
374   mapping (address => mapping (address => uint256)) internal allowed;
375 
376 
377   /**
378    * @dev Transfer tokens from one address to another
379    * @param _from address The address which you want to send tokens from
380    * @param _to address The address which you want to transfer to
381    * @param _value uint256 the amount of tokens to be transferred
382    */
383   function transferFrom(address _from, address _to, uint256 _value) public returns (bool) {
384     require(_to != address(0));
385     require(_value <= balances[_from]);
386     require(_value <= allowed[_from][msg.sender]);
387 
388     balances[_from] = balances[_from].sub(_value);
389     balances[_to] = balances[_to].add(_value);
390     allowed[_from][msg.sender] = allowed[_from][msg.sender].sub(_value);
391     Transfer(_from, _to, _value);
392     return true;
393   }
394 
395   /**
396    * @dev Approve the passed address to spend the specified amount of tokens on behalf of msg.sender.
397    *
398    * Beware that changing an allowance with this method brings the risk that someone may use both the old
399    * and the new allowance by unfortunate transaction ordering. One possible solution to mitigate this
400    * race condition is to first reduce the spender's allowance to 0 and set the desired value afterwards:
401    * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
402    * @param _spender The address which will spend the funds.
403    * @param _value The amount of tokens to be spent.
404    */
405   function approve(address _spender, uint256 _value) public returns (bool) {
406     allowed[msg.sender][_spender] = _value;
407     Approval(msg.sender, _spender, _value);
408     return true;
409   }
410 
411   /**
412    * @dev Function to check the amount of tokens that an owner allowed to a spender.
413    * @param _owner address The address which owns the funds.
414    * @param _spender address The address which will spend the funds.
415    * @return A uint256 specifying the amount of tokens still available for the spender.
416    */
417   function allowance(address _owner, address _spender) public view returns (uint256) {
418     return allowed[_owner][_spender];
419   }
420 
421   /**
422    * @dev Increase the amount of tokens that an owner allowed to a spender.
423    *
424    * approve should be called when allowed[_spender] == 0. To increment
425    * allowed value is better to use this function to avoid 2 calls (and wait until
426    * the first transaction is mined)
427    * From MonolithDAO Token.sol
428    * @param _spender The address which will spend the funds.
429    * @param _addedValue The amount of tokens to increase the allowance by.
430    */
431   function increaseApproval(address _spender, uint _addedValue) public returns (bool) {
432     allowed[msg.sender][_spender] = allowed[msg.sender][_spender].add(_addedValue);
433     Approval(msg.sender, _spender, allowed[msg.sender][_spender]);
434     return true;
435   }
436 
437   /**
438    * @dev Decrease the amount of tokens that an owner allowed to a spender.
439    *
440    * approve should be called when allowed[_spender] == 0. To decrement
441    * allowed value is better to use this function to avoid 2 calls (and wait until
442    * the first transaction is mined)
443    * From MonolithDAO Token.sol
444    * @param _spender The address which will spend the funds.
445    * @param _subtractedValue The amount of tokens to decrease the allowance by.
446    */
447   function decreaseApproval(address _spender, uint _subtractedValue) public returns (bool) {
448     uint oldValue = allowed[msg.sender][_spender];
449     if (_subtractedValue > oldValue) {
450       allowed[msg.sender][_spender] = 0;
451     } else {
452       allowed[msg.sender][_spender] = oldValue.sub(_subtractedValue);
453     }
454     Approval(msg.sender, _spender, allowed[msg.sender][_spender]);
455     return true;
456   }
457 
458 }
459 
460 // File: contracts/tokens/ERC223/ERC223.sol
461 
462 /**
463  * @title Reference implementation of the ERC223 standard token.
464  */
465 contract ERC223 is StandardToken {
466 
467     event Transfer(address indexed from, address indexed to, uint value, bytes data);
468 
469     /**
470     * @dev transfer token for a specified address
471     * @param _to The address to transfer to.
472     * @param _value The amount to be transferred.
473     */
474     function transfer(address _to, uint _value) public returns (bool) {
475         bytes memory empty;
476         return transfer(_to, _value, empty);
477     }
478 
479     /**
480     * @dev transfer token for a specified address
481     * @param _to The address to transfer to.
482     * @param _value The amount to be transferred.
483     * @param _data Optional metadata.
484     */
485     function transfer(address _to, uint _value, bytes _data) public returns (bool) {
486         super.transfer(_to, _value);
487 
488         if (isContract(_to)) {
489             ERC223ReceivingContract receiver = ERC223ReceivingContract(_to);
490             receiver.tokenFallback(msg.sender, _value, _data);
491             Transfer(msg.sender, _to, _value, _data);
492         }
493 
494         return true;
495     }
496 
497     /**
498      * @dev Transfer tokens from one address to another
499      * @param _from address The address which you want to send tokens from
500      * @param _to address The address which you want to transfer to
501      * @param _value uint the amount of tokens to be transferred
502      */
503     function transferFrom(address _from, address _to, uint _value) public returns (bool) {
504         bytes memory empty;
505         return transferFrom(_from, _to, _value, empty);
506     }
507 
508     /**
509      * @dev Transfer tokens from one address to another
510      * @param _from address The address which you want to send tokens from
511      * @param _to address The address which you want to transfer to
512      * @param _value uint the amount of tokens to be transferred
513      * @param _data Optional metadata.
514      */
515     function transferFrom(address _from, address _to, uint _value, bytes _data) public returns (bool) {
516         super.transferFrom(_from, _to, _value);
517 
518         if (isContract(_to)) {
519             ERC223ReceivingContract receiver = ERC223ReceivingContract(_to);
520             receiver.tokenFallback(_from, _value, _data);
521         }
522 
523         Transfer(_from, _to, _value, _data);
524         return true;
525     }
526 
527     function isContract(address _addr) private view returns (bool) {
528         uint length;
529         assembly {
530             //retrieve the size of the code on target address, this needs assembly
531             length := extcodesize(_addr)
532         }
533         return (length>0);
534     }
535 }
536 
537 // File: contracts/tokens/ERC223StandardToken.sol
538 
539 contract ERC223StandardToken is StandardToken, ERC223 {
540 
541     string public name = "";
542     string public symbol = "";
543     uint8 public decimals = 18;
544 
545     function ERC223StandardToken(string _name, string _symbol, uint8 _decimals, address _owner, uint256 _totalSupply) public {
546         name = _name;
547         symbol = _symbol;
548         decimals = _decimals;
549 
550         totalSupply_ = _totalSupply;
551         balances[_owner] = _totalSupply;
552         Transfer(0x0, _owner, _totalSupply);
553     }
554 }
555 
556 // File: contracts/factories/BaseFactory.sol
557 
558 contract BaseFactory {
559 
560     address public mainFabricAddress;
561     string public title;
562 
563     struct Parameter {
564         string title;
565         string paramType;
566     }
567 
568     /**
569      * @dev params list
570      */
571     Parameter[] public params;
572 
573     /**
574      * @dev Count of parameters in factory
575      */
576     function numParameters() public view returns (uint256)
577     {
578         return params.length;
579     }
580 
581     function getParam(uint _i) public view returns (
582         string title,
583         string paramType
584     ) {
585         return (
586         params[_i].title,
587         params[_i].paramType
588         );
589     }
590 }
591 
592 // File: contracts/factories/ERC223StandardTokenFactory.sol
593 
594 contract ERC223StandardTokenFactory is BaseFactory {
595 
596     function ERC223StandardTokenFactory(address _mainFactory) public {
597         require(_mainFactory != 0x0);
598         mainFabricAddress = _mainFactory;
599 
600         title = "ERC223StandardToken";
601 
602         params.push(Parameter({
603             title: "Token name",
604             paramType: "string"
605             }));
606 
607         params.push(Parameter({
608             title: "Token symbol",
609             paramType: "string"
610             }));
611 
612         params.push(Parameter({
613             title: "Decimals",
614             paramType: "string"
615             }));
616 
617         params.push(Parameter({
618             title: "Token owner",
619             paramType: "string"
620             }));
621 
622         params.push(Parameter({
623             title: "Total supply",
624             paramType: "string"
625             }));
626     }
627 
628     function create(string _name, string _symbol, uint8 _decimals, address _owner, uint256 _totalSupply) public returns (ERC223StandardToken) {
629         ERC223StandardToken newContract = new ERC223StandardToken(_name, _symbol, _decimals, _owner, _totalSupply);
630 
631         MainFabric fabric = MainFabric(mainFabricAddress);
632         fabric.addContract(address(newContract), msg.sender, title);
633 
634         return newContract;
635     }
636 }