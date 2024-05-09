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
107 
108 contract Ownership {
109     address payable public owner;
110     address payable public pendingOwner;
111 
112     event OwnershipTransferred (address indexed from, address indexed to);
113 
114     constructor () public
115     {
116         owner = msg.sender;
117     }
118 
119     modifier onlyOwner {
120         require (msg.sender == owner, "Ownership: Access denied");
121         _;
122     }
123 
124     function transferOwnership (address payable _pendingOwner) public
125         onlyOwner
126     {
127         pendingOwner = _pendingOwner;
128     }
129 
130     function acceptOwnership () public
131     {
132         require (msg.sender == pendingOwner, "Ownership: Only new owner is allowed");
133 
134         emit OwnershipTransferred (owner, pendingOwner);
135 
136         owner = pendingOwner;
137         pendingOwner = address(0);
138     }
139 
140 }
141 
142 
143 /**
144  * @title Controllable contract
145  * @dev Implementation of the controllable operations
146  */
147 contract Controllable is Ownership {
148 
149     bool public stopped;
150     mapping (address => bool) public freezeAddresses;
151 
152     event Paused();
153     event Resumed();
154 
155     event FreezeAddress(address indexed addressOf);
156     event UnfreezeAddress(address indexed addressOf);
157 
158     modifier onlyActive(address _sender) {
159         require(!freezeAddresses[_sender], "Controllable: Not active");
160         _;
161     }
162 
163     modifier isUsable {
164         require(!stopped, "Controllable: Paused");
165         _;
166     }
167 
168     function pause () public
169         onlyOwner
170     {
171         stopped = true;
172         emit Paused ();
173     }
174     
175     function resume () public
176         onlyOwner
177     {
178         stopped = false;
179         emit Resumed ();
180     }
181 
182     function freezeAddress(address _addressOf) public
183         onlyOwner
184         returns (bool)
185     {
186         if (!freezeAddresses[_addressOf]) {
187             freezeAddresses[_addressOf] = true;
188             emit FreezeAddress(_addressOf);
189         }
190 
191         return true;
192     }
193 	
194     function unfreezeAddress(address _addressOf) public
195         onlyOwner
196         returns (bool)
197     {
198         if (freezeAddresses[_addressOf]) {
199             delete freezeAddresses[_addressOf];
200             emit UnfreezeAddress(_addressOf);
201         }
202 
203         return true;
204     }
205 
206 }
207 
208 
209 /**
210  * @title ERC20Basic
211  * @dev Simpler version of ERC20 interface
212  * @dev see https://github.com/ethereum/EIPs/issues/179
213  */
214 contract ERC20Basic {
215     function balanceOf(address who) public view returns (uint256);
216     function transfer(address to, uint256 value) public returns (bool);
217 
218     event Transfer(address indexed from, address indexed to, uint256 value);
219 }
220 
221 
222 /**
223  * @title ERC20 interface
224  * @dev see https://github.com/ethereum/EIPs/issues/20
225  */
226 contract ERC20 is ERC20Basic {
227     function allowance(address owner, address spender) public view returns (uint256);
228     function transferFrom(address from, address to, uint256 value) public returns (bool);
229     function approve(address spender, uint256 value) public returns (bool);
230 
231     event Approval(address indexed owner, address indexed spender, uint256 value);
232 }
233 
234 
235 /**
236  * @title Basic token
237  * @dev Basic version of StandardToken, with no allowances.
238  */
239 contract BasicToken is ERC20Basic, Controllable {
240     using SafeMathUint256 for uint256;
241 
242     mapping(address => uint256) balances;
243 
244     uint256 public totalSupply;
245 
246     constructor(uint256 _initialSupply) public
247     {
248         totalSupply = _initialSupply;
249 
250         if (0 < _initialSupply) {
251             balances[msg.sender] = _initialSupply;
252             emit Transfer(address(0), msg.sender, _initialSupply);
253         }
254     }
255 
256     /**
257     * @dev transfer token for a specified address
258     * @param _to The address to transfer to.
259     * @param _value The amount to be transferred.
260     */
261     function transfer(address _to, uint256 _value) public
262         isUsable
263         onlyActive(msg.sender)
264         onlyActive(_to)
265         returns (bool)
266     {
267         require(0 < _value, "BasicToken.transfer: Zero value");
268         require(_value <= balances[msg.sender], "BasicToken.transfer: Insufficient fund");
269 
270         // SafeMath.sub will throw if there is not enough balance.
271         balances[msg.sender] = balances[msg.sender].sub(_value);
272         balances[_to] = balances[_to].add(_value);
273         emit Transfer(msg.sender, _to, _value);
274         return true;
275     }
276 
277     /**
278     * @dev Gets the balance of the specified address.
279     * @param _owner The address to query the the balance of.
280     * @return An uint256 representing the amount owned by the passed address.
281     */
282     function balanceOf(address _owner) public view
283         returns (uint256 balance)
284     {
285         return balances[_owner];
286     }
287 
288 }
289 
290 
291 /**
292  * @title Standard ERC20 token
293  *
294  * @dev Implementation of the basic standard token.
295  * @dev https://github.com/ethereum/EIPs/issues/20
296  */
297 contract StandardToken is ERC20, BasicToken {
298 
299     mapping (address => mapping (address => uint256)) internal allowed;
300 
301     /**
302     * @dev Transfer tokens from one address to another
303     * @param _from address The address which you want to send tokens from
304     * @param _to address The address which you want to transfer to
305     * @param _value uint256 the amount of tokens to be transferred
306     */
307     function transferFrom(address _from, address _to, uint256 _value) public
308         isUsable
309         onlyActive(msg.sender)
310         onlyActive(_from)
311         onlyActive(_to)
312         returns (bool)
313     {
314         require(0 < _value, "StandardToken.transferFrom: Zero value");
315         require(_value <= balances[_from], "StandardToken.transferFrom: Insufficient fund");
316         require(_value <= allowed[_from][msg.sender], "StandardToken.transferFrom: Insufficient allowance");
317 
318         balances[_from] = balances[_from].sub(_value);
319         balances[_to] = balances[_to].add(_value);
320         allowed[_from][msg.sender] = allowed[_from][msg.sender].sub(_value);
321         emit Transfer(_from, _to, _value);
322         return true;
323     }
324 
325     /**
326     * @dev Approve the passed address to spend the specified amount of tokens on behalf of msg.sender.
327     *
328     * Beware that changing an allowance with this method brings the risk that someone may use both the old
329     * and the new allowance by unfortunate transaction ordering. One possible solution to mitigate this
330     * race condition is to first reduce the spender's allowance to 0 and set the desired value afterwards:
331     * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
332     * @param _spender The address which will spend the funds.
333     * @param _value The amount of tokens to be spent.
334     */
335     function approve(address _spender, uint256 _value) public
336         isUsable
337         onlyActive(msg.sender)
338         onlyActive(_spender)
339         returns (bool)
340     {
341         require(0 < _value, "StandardToken.approve: Zero value");
342 
343         allowed[msg.sender][_spender] = _value;
344         emit Approval(msg.sender, _spender, _value);
345         return true;
346     }
347 
348     /**
349     * @dev Function to check the amount of tokens that an owner allowed to a spender.
350     * @param _owner address The address which owns the funds.
351     * @param _spender address The address which will spend the funds.
352     * @return A uint256 specifying the amount of tokens still available for the spender.
353     */
354     function allowance(address _owner, address _spender) public view
355         returns (uint256)
356     {
357         return allowed[_owner][_spender];
358     }
359 
360     /**
361     * @dev Increase the amount of tokens that an owner allowed to a spender.
362     *
363     * approve should be called when allowed[_spender] == 0. To increment
364     * allowed value is better to use this function to avoid 2 calls (and wait until
365     * the first transaction is mined)
366     * From MonolithDAO Token.sol
367     * @param _spender The address which will spend the funds.
368     * @param _addedValue The amount of tokens to increase the allowance by.
369     */
370     function increaseApproval(address _spender, uint256 _addedValue) public
371         isUsable
372         onlyActive(msg.sender)
373         onlyActive(_spender)
374         returns (bool)
375     {
376         require(0 < _addedValue, "StandardToken.increaseApproval: Zero value");
377 
378         allowed[msg.sender][_spender] = allowed[msg.sender][_spender].add(_addedValue);
379         emit Approval(msg.sender, _spender, allowed[msg.sender][_spender]);
380         return true;
381     }
382 
383     /**
384     * @dev Decrease the amount of tokens that an owner allowed to a spender.
385     *
386     * approve should be called when allowed[_spender] == 0. To decrement
387     * allowed value is better to use this function to avoid 2 calls (and wait until
388     * the first transaction is mined)
389     * From MonolithDAO Token.sol
390     * @param _spender The address which will spend the funds.
391     * @param _subtractedValue The amount of tokens to decrease the allowance by.
392     */
393     function decreaseApproval(address _spender, uint256 _subtractedValue) public
394         isUsable
395         onlyActive(msg.sender)
396         onlyActive(_spender)
397         returns (bool)
398     {
399         require(0 < _subtractedValue, "StandardToken.decreaseApproval: Zero value");
400 
401         uint256 oldValue = allowed[msg.sender][_spender];
402 
403         if (_subtractedValue > oldValue)
404             allowed[msg.sender][_spender] = 0;
405         else
406             allowed[msg.sender][_spender] = oldValue.sub(_subtractedValue);
407 
408         emit Approval(msg.sender, _spender, allowed[msg.sender][_spender]);
409         return true;
410     }
411 
412 }
413 
414 
415 contract ApprovalReceiver {
416     function receiveApproval(address _from, uint256 _value, address _tokenContract, bytes calldata _extraData) external;
417 }
418 
419 contract ETT is StandardToken {
420     using SafeMathUint256 for uint256;
421 
422     bytes32 constant FREEZE_CODE_DEFAULT = 0x0000000000000000000000000000000000000000000000000000000000000000;
423 
424     event Freeze(address indexed from, uint256 value);
425     event Unfreeze(address indexed from, uint256 value);
426 
427     event FreezeWithPurpose(address indexed from, uint256 value, bytes32 purpose);
428     event UnfreezeWithPurpose(address indexed from, uint256 value, bytes32 purpose);
429 
430     string public name;
431     string public symbol;
432     uint8 public decimals;
433 
434     // Keep track total frozen balances
435     mapping (address => uint256) public freezeOf;
436     // Keep track sub total frozen balances
437     mapping (address => mapping (bytes32 => uint256)) public freezes;
438 
439     constructor(string memory _name, string memory _symbol, uint8 _decimals, uint256 _initialSupply) public
440         BasicToken(_initialSupply)
441     {
442         name = _name;
443         symbol = _symbol;
444         decimals = _decimals;
445     }
446 
447     /**
448     * @dev Freeze holder balance
449     *
450     * @param _from The address which will be freeze
451     * @param _value The amount of tokens to be freeze
452     */
453     function freeze(address _from, uint256 _value) external
454         onlyOwner
455         returns (bool)
456     {
457         require(_value <= balances[_from], "StableCoin.freeze: Insufficient fund");
458 
459         balances[_from] = balances[_from].sub(_value);
460         freezeOf[_from] = freezeOf[_from].add(_value);
461         freezes[_from][FREEZE_CODE_DEFAULT] = freezes[_from][FREEZE_CODE_DEFAULT].add(_value);
462         emit Freeze(_from, _value);
463         emit FreezeWithPurpose(_from, _value, FREEZE_CODE_DEFAULT);
464         return true;
465     }
466 	
467     /**
468     * @dev Freeze holder balance with purpose code
469     *
470     * @param _from The address which will be freeze
471     * @param _value The amount of tokens to be freeze
472     * @param _purpose The purpose of freeze
473     */
474     function freezeWithPurpose(address _from, uint256 _value, string calldata _purpose) external
475         returns (bool)
476     {
477         return freezeWithPurposeCode(_from, _value, encodePacked(_purpose));
478     }
479 	
480     /**
481     * @dev Freeze holder balance with purpose code
482     *
483     * @param _from The address which will be freeze
484     * @param _value The amount of tokens to be freeze
485     * @param _purposeCode The purpose code of freeze
486     */
487     function freezeWithPurposeCode(address _from, uint256 _value, bytes32 _purposeCode) public
488         onlyOwner
489         returns (bool)
490     {
491         require(_value <= balances[_from], "StableCoin.freezeWithPurposeCode: Insufficient fund");
492 
493         balances[_from] = balances[_from].sub(_value);
494         freezeOf[_from] = freezeOf[_from].add(_value);
495         freezes[_from][_purposeCode] = freezes[_from][_purposeCode].add(_value);
496         emit Freeze(_from, _value);
497         emit FreezeWithPurpose(_from, _value, _purposeCode);
498         return true;
499     }
500 	
501     /**
502     * @dev Unfreeze holder balance
503     *
504     * @param _from The address which will be unfreeze
505     * @param _value The amount of tokens to be unfreeze
506     */
507     function unfreeze(address _from, uint256 _value) external
508         onlyOwner
509         returns (bool)
510     {
511         require(_value <= freezes[_from][FREEZE_CODE_DEFAULT], "StableCoin.unfreeze: Insufficient fund");
512 
513         freezeOf[_from] = freezeOf[_from].sub(_value);
514         freezes[_from][FREEZE_CODE_DEFAULT] = freezes[_from][FREEZE_CODE_DEFAULT].sub(_value);
515         balances[_from] = balances[_from].add(_value);
516         emit Unfreeze(_from, _value);
517         emit UnfreezeWithPurpose(_from, _value, FREEZE_CODE_DEFAULT);
518         return true;
519     }
520 
521     /**
522     * @dev Unfreeze holder balance with purpose code
523     *
524     * @param _from The address which will be unfreeze
525     * @param _value The amount of tokens to be unfreeze
526     * @param _purpose The purpose of unfreeze
527     */
528     function unfreezeWithPurpose(address _from, uint256 _value, string calldata _purpose) external
529         onlyOwner
530         returns (bool)
531     {
532         return unfreezeWithPurposeCode(_from, _value, encodePacked(_purpose));
533     }
534 
535     /**
536     * @dev Unfreeze holder balance with purpose code
537     *
538     * @param _from The address which will be unfreeze
539     * @param _value The amount of tokens to be unfreeze
540     * @param _purposeCode The purpose code of unfreeze
541     */
542     function unfreezeWithPurposeCode(address _from, uint256 _value, bytes32 _purposeCode) public
543         onlyOwner
544         returns (bool)
545     {
546         require(_value <= freezes[_from][_purposeCode], "StableCoin.unfreezeWithPurposeCode: Insufficient fund");
547 
548         freezeOf[_from] = freezeOf[_from].sub(_value);
549         freezes[_from][_purposeCode] = freezes[_from][_purposeCode].sub(_value);
550         balances[_from] = balances[_from].add(_value);
551         emit Unfreeze(_from, _value);
552         emit UnfreezeWithPurpose(_from, _value, _purposeCode);
553         return true;
554     }
555 
556     /**
557      * @dev Allocate allowance and perform contract call
558      *
559      * @param _spender The spender address
560      * @param _value The allowance value
561      * @param _extraData The function call data
562      */
563     function approveAndCall(address _spender, uint256 _value, bytes calldata _extraData) external
564         isUsable
565         returns (bool)
566     {
567         // Give allowance to spender (previous approved allowances will be clear)
568         approve(_spender, _value);
569 
570         ApprovalReceiver(_spender).receiveApproval(msg.sender, _value, address(this), _extraData);
571         return true;
572     }
573 
574     function encodePacked(string memory s) internal pure
575         returns (bytes32)
576     {
577         return keccak256(abi.encodePacked(s));
578     }
579 
580 }