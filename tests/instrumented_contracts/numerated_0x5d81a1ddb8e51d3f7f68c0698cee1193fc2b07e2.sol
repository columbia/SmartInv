1 pragma solidity >=0.5.0 <0.6.0;
2 
3 /**
4  * @title SafeMath for uint256
5  * @dev Math operations with safety checks that throw on error
6  */
7 library SafeMathUint256 {
8     /**
9     * @dev Multiplies two numbers, throws on overflow.
10     */
11     function mul(uint256 a, uint256 b) internal pure returns (uint256 c) {
12         if (a == 0) {
13             return 0;
14         }
15         c = a * b;
16         require(c / a == b, "SafeMath: Multiplier exception");
17         return c;
18     }
19 
20     /**
21     * @dev Integer division of two numbers, truncating the quotient.
22     */
23     function div(uint256 a, uint256 b) internal pure returns (uint256) {
24         return a / b; // Solidity automatically throws when dividing by 0
25     }
26 
27     /**
28     * @dev Subtracts two numbers, throws on overflow (i.e. if subtrahend is greater than minuend).
29     */
30     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
31         require(b <= a, "SafeMath: Subtraction exception");
32         return a - b;
33     }
34 
35     /**
36     * @dev Adds two numbers, throws on overflow.
37     */
38     function add(uint256 a, uint256 b) internal pure returns (uint256 c) {
39         c = a + b;
40         require(c >= a, "SafeMath: Addition exception");
41         return c;
42     }
43 
44     /**
45     * @dev Divides two numbers and returns the remainder (unsigned integer modulo),
46     * reverts when dividing by zero.
47     */
48     function mod(uint256 a, uint256 b) internal pure returns (uint256) {
49         require(b != 0, "SafeMath: Modulo exception");
50         return a % b;
51     }
52 
53 }
54 
55 /**
56  * @title SafeMath for uint8
57  * @dev Math operations with safety checks that throw on error
58  */
59 library SafeMathUint8 {
60     /**
61     * @dev Multiplies two numbers, throws on overflow.
62     */
63     function mul(uint8 a, uint8 b) internal pure returns (uint8 c) {
64         if (a == 0) {
65             return 0;
66         }
67         c = a * b;
68         require(c / a == b, "SafeMath: Multiplier exception");
69         return c;
70     }
71 
72     /**
73     * @dev Integer division of two numbers, truncating the quotient.
74     */
75     function div(uint8 a, uint8 b) internal pure returns (uint8) {
76         return a / b; // Solidity automatically throws when dividing by 0
77     }
78 
79     /**
80     * @dev Subtracts two numbers, throws on overflow (i.e. if subtrahend is greater than minuend).
81     */
82     function sub(uint8 a, uint8 b) internal pure returns (uint8) {
83         require(b <= a, "SafeMath: Subtraction exception");
84         return a - b;
85     }
86 
87     /**
88     * @dev Adds two numbers, throws on overflow.
89     */
90     function add(uint8 a, uint8 b) internal pure returns (uint8 c) {
91         c = a + b;
92         require(c >= a, "SafeMath: Addition exception");
93         return c;
94     }
95 
96     /**
97     * @dev Divides two numbers and returns the remainder (unsigned integer modulo),
98     * reverts when dividing by zero.
99     */
100     function mod(uint8 a, uint8 b) internal pure returns (uint8) {
101         require(b != 0, "SafeMath: Modulo exception");
102         return a % b;
103     }
104 
105 }
106 
107 contract Ownership {
108     address payable public owner;
109     address payable public pendingOwner;
110 
111     event OwnershipTransferred (address indexed from, address indexed to);
112 
113     constructor () public
114     {
115         owner = msg.sender;
116     }
117 
118     modifier onlyOwner {
119         require (msg.sender == owner, "Ownership: Access denied");
120         _;
121     }
122 
123     function transferOwnership (address payable _pendingOwner) public
124         onlyOwner
125     {
126         pendingOwner = _pendingOwner;
127     }
128 
129     function acceptOwnership () public
130     {
131         require (msg.sender == pendingOwner, "Ownership: Only new owner is allowed");
132 
133         emit OwnershipTransferred (owner, pendingOwner);
134 
135         owner = pendingOwner;
136         pendingOwner = address(0);
137     }
138 
139 }
140 
141 /**
142  * @title Controllable contract
143  * @dev Implementation of the controllable operations
144  */
145 contract Controllable is Ownership {
146 
147     bool public stopped;
148     mapping (address => bool) public freezeAddresses;
149 
150     event Paused();
151     event Resumed();
152 
153     event FreezeAddress(address indexed addressOf);
154     event UnfreezeAddress(address indexed addressOf);
155 
156     modifier onlyActive(address _sender) {
157         require(!freezeAddresses[_sender], "Controllable: Not active");
158         _;
159     }
160 
161     modifier isUsable {
162         require(!stopped, "Controllable: Paused");
163         _;
164     }
165 
166     function pause () public
167         onlyOwner
168     {
169         stopped = true;
170         emit Paused ();
171     }
172     
173     function resume () public
174         onlyOwner
175     {
176         stopped = false;
177         emit Resumed ();
178     }
179 
180     function freezeAddress(address _addressOf) public
181         onlyOwner
182         returns (bool)
183     {
184         if (!freezeAddresses[_addressOf]) {
185             freezeAddresses[_addressOf] = true;
186             emit FreezeAddress(_addressOf);
187         }
188 
189         return true;
190     }
191 	
192     function unfreezeAddress(address _addressOf) public
193         onlyOwner
194         returns (bool)
195     {
196         if (freezeAddresses[_addressOf]) {
197             delete freezeAddresses[_addressOf];
198             emit UnfreezeAddress(_addressOf);
199         }
200 
201         return true;
202     }
203 
204 }
205 
206 /**
207  * @title ERC20Basic
208  * @dev Simpler version of ERC20 interface
209  * @dev see https://github.com/ethereum/EIPs/issues/179
210  */
211 contract ERC20Basic {
212     function balanceOf(address who) public view returns (uint256);
213     function transfer(address to, uint256 value) public returns (bool);
214 
215     event Transfer(address indexed from, address indexed to, uint256 value);
216 }
217 
218 
219 /**
220  * @title ERC20 interface
221  * @dev see https://github.com/ethereum/EIPs/issues/20
222  */
223 contract ERC20 is ERC20Basic {
224     function allowance(address owner, address spender) public view returns (uint256);
225     function transferFrom(address from, address to, uint256 value) public returns (bool);
226     function approve(address spender, uint256 value) public returns (bool);
227 
228     event Approval(address indexed owner, address indexed spender, uint256 value);
229 }
230 
231 
232 /**
233  * @title Basic token
234  * @dev Basic version of StandardToken, with no allowances.
235  */
236 contract BasicToken is ERC20Basic, Controllable {
237     using SafeMathUint256 for uint256;
238 
239     mapping(address => uint256) balances;
240 
241     uint256 public totalSupply;
242 
243     constructor(uint256 _initialSupply) public
244     {
245         totalSupply = _initialSupply;
246 
247         if (0 < _initialSupply) {
248             balances[msg.sender] = _initialSupply;
249             emit Transfer(address(0), msg.sender, _initialSupply);
250         }
251     }
252 
253     /**
254     * @dev transfer token for a specified address
255     * @param _to The address to transfer to.
256     * @param _value The amount to be transferred.
257     */
258     function transfer(address _to, uint256 _value) public
259         isUsable
260         onlyActive(msg.sender)
261         onlyActive(_to)
262         returns (bool)
263     {
264         require(0 < _value, "BasicToken.transfer: Zero value");
265         require(_value <= balances[msg.sender], "BasicToken.transfer: Insufficient fund");
266 
267         // SafeMath.sub will throw if there is not enough balance.
268         balances[msg.sender] = balances[msg.sender].sub(_value);
269         balances[_to] = balances[_to].add(_value);
270         emit Transfer(msg.sender, _to, _value);
271         return true;
272     }
273 
274     /**
275     * @dev Gets the balance of the specified address.
276     * @param _owner The address to query the the balance of.
277     * @return An uint256 representing the amount owned by the passed address.
278     */
279     function balanceOf(address _owner) public view
280         returns (uint256 balance)
281     {
282         return balances[_owner];
283     }
284 
285 }
286 
287 
288 /**
289  * @title Standard ERC20 token
290  *
291  * @dev Implementation of the basic standard token.
292  * @dev https://github.com/ethereum/EIPs/issues/20
293  */
294 contract StandardToken is ERC20, BasicToken {
295 
296     mapping (address => mapping (address => uint256)) internal allowed;
297 
298     /**
299     * @dev Transfer tokens from one address to another
300     * @param _from address The address which you want to send tokens from
301     * @param _to address The address which you want to transfer to
302     * @param _value uint256 the amount of tokens to be transferred
303     */
304     function transferFrom(address _from, address _to, uint256 _value) public
305         isUsable
306         onlyActive(msg.sender)
307         onlyActive(_from)
308         onlyActive(_to)
309         returns (bool)
310     {
311         require(0 < _value, "StandardToken.transferFrom: Zero value");
312         require(_value <= balances[_from], "StandardToken.transferFrom: Insufficient fund");
313         require(_value <= allowed[_from][msg.sender], "StandardToken.transferFrom: Insufficient allowance");
314 
315         balances[_from] = balances[_from].sub(_value);
316         balances[_to] = balances[_to].add(_value);
317         allowed[_from][msg.sender] = allowed[_from][msg.sender].sub(_value);
318         emit Transfer(_from, _to, _value);
319         return true;
320     }
321 
322     /**
323     * @dev Approve the passed address to spend the specified amount of tokens on behalf of msg.sender.
324     *
325     * Beware that changing an allowance with this method brings the risk that someone may use both the old
326     * and the new allowance by unfortunate transaction ordering. One possible solution to mitigate this
327     * race condition is to first reduce the spender's allowance to 0 and set the desired value afterwards:
328     * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
329     * @param _spender The address which will spend the funds.
330     * @param _value The amount of tokens to be spent.
331     */
332     function approve(address _spender, uint256 _value) public
333         isUsable
334         onlyActive(msg.sender)
335         onlyActive(_spender)
336         returns (bool)
337     {
338         require(0 < _value, "StandardToken.approve: Zero value");
339 
340         allowed[msg.sender][_spender] = _value;
341         emit Approval(msg.sender, _spender, _value);
342         return true;
343     }
344 
345     /**
346     * @dev Function to check the amount of tokens that an owner allowed to a spender.
347     * @param _owner address The address which owns the funds.
348     * @param _spender address The address which will spend the funds.
349     * @return A uint256 specifying the amount of tokens still available for the spender.
350     */
351     function allowance(address _owner, address _spender) public view
352         returns (uint256)
353     {
354         return allowed[_owner][_spender];
355     }
356 
357     /**
358     * @dev Increase the amount of tokens that an owner allowed to a spender.
359     *
360     * approve should be called when allowed[_spender] == 0. To increment
361     * allowed value is better to use this function to avoid 2 calls (and wait until
362     * the first transaction is mined)
363     * From MonolithDAO Token.sol
364     * @param _spender The address which will spend the funds.
365     * @param _addedValue The amount of tokens to increase the allowance by.
366     */
367     function increaseApproval(address _spender, uint256 _addedValue) public
368         isUsable
369         onlyActive(msg.sender)
370         onlyActive(_spender)
371         returns (bool)
372     {
373         require(0 < _addedValue, "StandardToken.increaseApproval: Zero value");
374 
375         allowed[msg.sender][_spender] = allowed[msg.sender][_spender].add(_addedValue);
376         emit Approval(msg.sender, _spender, allowed[msg.sender][_spender]);
377         return true;
378     }
379 
380     /**
381     * @dev Decrease the amount of tokens that an owner allowed to a spender.
382     *
383     * approve should be called when allowed[_spender] == 0. To decrement
384     * allowed value is better to use this function to avoid 2 calls (and wait until
385     * the first transaction is mined)
386     * From MonolithDAO Token.sol
387     * @param _spender The address which will spend the funds.
388     * @param _subtractedValue The amount of tokens to decrease the allowance by.
389     */
390     function decreaseApproval(address _spender, uint256 _subtractedValue) public
391         isUsable
392         onlyActive(msg.sender)
393         onlyActive(_spender)
394         returns (bool)
395     {
396         require(0 < _subtractedValue, "StandardToken.decreaseApproval: Zero value");
397 
398         uint256 oldValue = allowed[msg.sender][_spender];
399 
400         if (_subtractedValue > oldValue)
401             allowed[msg.sender][_spender] = 0;
402         else
403             allowed[msg.sender][_spender] = oldValue.sub(_subtractedValue);
404 
405         emit Approval(msg.sender, _spender, allowed[msg.sender][_spender]);
406         return true;
407     }
408 
409 }
410 
411 contract ApprovalReceiver {
412     function receiveApproval(address _from, uint256 _value, address _tokenContract, bytes calldata _extraData) external;
413 }
414 
415 contract USDA is StandardToken {
416     using SafeMathUint256 for uint256;
417 
418     bytes32 constant FREEZE_CODE_DEFAULT = 0x0000000000000000000000000000000000000000000000000000000000000000;
419 
420     event Freeze(address indexed from, uint256 value);
421     event Unfreeze(address indexed from, uint256 value);
422 
423     event FreezeWithPurpose(address indexed from, uint256 value, bytes32 purpose);
424     event UnfreezeWithPurpose(address indexed from, uint256 value, bytes32 purpose);
425 
426     string public name;
427     string public symbol;
428     uint8 public decimals;
429 
430     // Keep track total frozen balances
431     mapping (address => uint256) public freezeOf;
432     // Keep track sub total frozen balances
433     mapping (address => mapping (bytes32 => uint256)) public freezes;
434 
435     constructor(string memory _name, string memory _symbol, uint8 _decimals, uint256 _initialSupply) public
436         BasicToken(_initialSupply)
437     {
438         name = _name;
439         symbol = _symbol;
440         decimals = _decimals;
441     }
442 
443     /**
444      * @dev Increase total supply (mint) to an address
445      *
446      * @param _value The amount of tokens to be mint
447      * @param _to The address which will receive token
448      */
449     function increaseSupply(uint256 _value, address _to) external
450         onlyOwner
451         onlyActive(_to)
452         returns (bool)
453     {
454         require(0 < _value, "StableCoin.increaseSupply: Zero value");
455 
456         totalSupply = totalSupply.add(_value);
457         balances[_to] = balances[_to].add(_value);
458         emit Transfer(address(0), _to, _value);
459         return true;
460     }
461 
462     /**
463      * @dev Increase total supply (mint) to an address with deposit
464      *
465      * @param _value The amount of tokens to be mint
466      * @param _to The address which will receive token
467      * @param _deposit The amount of deposit
468      */
469     function increaseSupplyWithDeposit(uint256 _value, address _to, uint256 _deposit) external
470         onlyOwner
471         onlyActive(_to)
472         returns (bool)
473     {
474         require(0 < _value, "StableCoin.increaseSupplyWithDeposit: Zero value");
475         require(_deposit <= _value, "StableCoin.increaseSupplyWithDeposit: Insufficient deposit");
476 
477         totalSupply = totalSupply.add(_value);
478         balances[_to] = balances[_to].add(_value);
479         freezeWithPurposeCode(_to, _deposit, encodePacked("InitialDeposit"));
480         emit Transfer(address(0), _to, _value.sub(_deposit));
481         return true;
482     }
483 
484     /**
485      * @dev Decrease total supply (burn) from an address that gave allowance
486      *
487      * @param _value The amount of tokens to be burn
488      * @param _from The address's token will be burn
489      */
490     function decreaseSupply(uint256 _value, address _from) external
491         onlyOwner
492         onlyActive(_from)
493         returns (bool)
494     {
495         require(0 < _value, "StableCoin.decreaseSupply: Zero value");
496         require(_value <= balances[_from], "StableCoin.decreaseSupply: Insufficient fund");
497         require(_value <= allowed[_from][address(0)], "StableCoin.decreaseSupply: Insufficient allowance");
498 
499         totalSupply = totalSupply.sub(_value);
500         balances[_from] = balances[_from].sub(_value);
501         allowed[_from][address(0)] = allowed[_from][address(0)].sub(_value);
502         emit Transfer(_from, address(0), _value);
503         return true;
504     }
505 	
506     /**
507     * @dev Freeze holder balance
508     *
509     * @param _from The address which will be freeze
510     * @param _value The amount of tokens to be freeze
511     */
512     function freeze(address _from, uint256 _value) external
513         onlyOwner
514         returns (bool)
515     {
516         require(_value <= balances[_from], "StableCoin.freeze: Insufficient fund");
517 
518         balances[_from] = balances[_from].sub(_value);
519         freezeOf[_from] = freezeOf[_from].add(_value);
520         freezes[_from][FREEZE_CODE_DEFAULT] = freezes[_from][FREEZE_CODE_DEFAULT].add(_value);
521         emit Freeze(_from, _value);
522         emit FreezeWithPurpose(_from, _value, FREEZE_CODE_DEFAULT);
523         return true;
524     }
525 	
526     /**
527     * @dev Freeze holder balance with purpose code
528     *
529     * @param _from The address which will be freeze
530     * @param _value The amount of tokens to be freeze
531     * @param _purpose The purpose of freeze
532     */
533     function freezeWithPurpose(address _from, uint256 _value, string calldata _purpose) external
534         returns (bool)
535     {
536         return freezeWithPurposeCode(_from, _value, encodePacked(_purpose));
537     }
538 	
539     /**
540     * @dev Freeze holder balance with purpose code
541     *
542     * @param _from The address which will be freeze
543     * @param _value The amount of tokens to be freeze
544     * @param _purposeCode The purpose code of freeze
545     */
546     function freezeWithPurposeCode(address _from, uint256 _value, bytes32 _purposeCode) public
547         onlyOwner
548         returns (bool)
549     {
550         require(_value <= balances[_from], "StableCoin.freezeWithPurposeCode: Insufficient fund");
551 
552         balances[_from] = balances[_from].sub(_value);
553         freezeOf[_from] = freezeOf[_from].add(_value);
554         freezes[_from][_purposeCode] = freezes[_from][_purposeCode].add(_value);
555         emit Freeze(_from, _value);
556         emit FreezeWithPurpose(_from, _value, _purposeCode);
557         return true;
558     }
559 	
560     /**
561     * @dev Unfreeze holder balance
562     *
563     * @param _from The address which will be unfreeze
564     * @param _value The amount of tokens to be unfreeze
565     */
566     function unfreeze(address _from, uint256 _value) external
567         onlyOwner
568         returns (bool)
569     {
570         require(_value <= freezes[_from][FREEZE_CODE_DEFAULT], "StableCoin.unfreeze: Insufficient fund");
571 
572         freezeOf[_from] = freezeOf[_from].sub(_value);
573         freezes[_from][FREEZE_CODE_DEFAULT] = freezes[_from][FREEZE_CODE_DEFAULT].sub(_value);
574         balances[_from] = balances[_from].add(_value);
575         emit Unfreeze(_from, _value);
576         emit UnfreezeWithPurpose(_from, _value, FREEZE_CODE_DEFAULT);
577         return true;
578     }
579 
580     /**
581     * @dev Unfreeze holder balance with purpose code
582     *
583     * @param _from The address which will be unfreeze
584     * @param _value The amount of tokens to be unfreeze
585     * @param _purpose The purpose of unfreeze
586     */
587     function unfreezeWithPurpose(address _from, uint256 _value, string calldata _purpose) external
588         onlyOwner
589         returns (bool)
590     {
591         return unfreezeWithPurposeCode(_from, _value, encodePacked(_purpose));
592     }
593 
594     /**
595     * @dev Unfreeze holder balance with purpose code
596     *
597     * @param _from The address which will be unfreeze
598     * @param _value The amount of tokens to be unfreeze
599     * @param _purposeCode The purpose code of unfreeze
600     */
601     function unfreezeWithPurposeCode(address _from, uint256 _value, bytes32 _purposeCode) public
602         onlyOwner
603         returns (bool)
604     {
605         require(_value <= freezes[_from][_purposeCode], "StableCoin.unfreezeWithPurposeCode: Insufficient fund");
606 
607         freezeOf[_from] = freezeOf[_from].sub(_value);
608         freezes[_from][_purposeCode] = freezes[_from][_purposeCode].sub(_value);
609         balances[_from] = balances[_from].add(_value);
610         emit Unfreeze(_from, _value);
611         emit UnfreezeWithPurpose(_from, _value, _purposeCode);
612         return true;
613     }
614 
615     /**
616      * @dev Allocate allowance and perform contract call
617      *
618      * @param _spender The spender address
619      * @param _value The allowance value
620      * @param _extraData The function call data
621      */
622     function approveAndCall(address _spender, uint256 _value, bytes calldata _extraData) external
623         isUsable
624         returns (bool)
625     {
626         // Give allowance to spender (previous approved allowances will be clear)
627         approve(_spender, _value);
628 
629         ApprovalReceiver(_spender).receiveApproval(msg.sender, _value, address(this), _extraData);
630         return true;
631     }
632 
633     function encodePacked(string memory s) internal pure
634         returns (bytes32)
635     {
636         return keccak256(abi.encodePacked(s));
637     }
638 
639 }