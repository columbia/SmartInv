1 pragma solidity ^0.4.23;
2 
3 /**
4  * @title SafeMath
5  * @dev Math operations with safety checks that throw on error
6  */
7 library SafeMath {
8   /**
9   * @dev Multiplies two numbers, throws on overflow.
10   */
11   function mul(uint256 a, uint256 b) internal pure returns (uint256 c) {
12     // Gas optimization: this is cheaper than asserting 'a' not being zero, but the
13     // benefit is lost if 'b' is also tested.
14     // See: https://github.com/OpenZeppelin/openzeppelin-solidity/pull/522
15     if (a == 0) {
16       return 0;
17     }
18 
19     c = a * b;
20     assert(c / a == b);
21     return c;
22   }
23 
24   /**
25   * @dev Integer division of two numbers, truncating the quotient.
26   */
27   function div(uint256 a, uint256 b) internal pure returns (uint256) {
28     // assert(b > 0); // Solidity automatically throws when dividing by 0
29     // uint256 c = a / b;
30     // assert(a == b * c + a % b); // There is no case in which this doesn't hold
31     return a / b;
32   }
33 
34   /**
35   * @dev Subtracts two numbers, throws on overflow (i.e. if subtrahend is greater than minuend).
36   */
37   function sub(uint256 a, uint256 b) internal pure returns (uint256) {
38     assert(b <= a);
39     return a - b;
40   }
41 
42   /**
43   * @dev Adds two numbers, throws on overflow.
44   */
45   function add(uint256 a, uint256 b) internal pure returns (uint256 c) {
46     c = a + b;
47     assert(c >= a);
48     return c;
49   }
50 }
51 
52 
53 
54 /**
55  * @title Ownable
56  * @dev The Ownable contract has an owner address & authority addresses, and provides basic
57  * authorization control functions, this simplifies the implementation of user permissions.
58  */
59 contract Ownable {
60   address public owner;
61   bool public canRenounce = false;
62   mapping (address => bool) public authorities;
63 
64   event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
65   event AuthorityAdded(address indexed authority);
66   event AuthorityRemoved(address indexed authority);
67 
68   /**
69    * @dev The Ownable constructor sets the original `owner` of the contract to the sender account.
70    */
71   constructor() public {
72     owner = msg.sender;
73   }
74 
75   /**
76    * @dev Throws if called by any account other than the owner.
77    */
78   modifier onlyOwner() {
79     require(msg.sender == owner);
80     _;
81   }
82 
83   /**
84    * @dev Throws if called by any account other than the authority or owner.
85    */
86   modifier onlyAuthority() {
87       require(msg.sender == owner || authorities[msg.sender]);
88       _;
89   }
90 
91   /**
92    * @dev Allows the current owner to relinquish control of the contract.
93    */
94   function enableRenounceOwnership() onlyOwner public {
95     canRenounce = true;
96   }
97 
98   /**
99    * @dev Allows the current owner to transfer control of the contract to a newOwner.
100    * @param _newOwner The address to transfer ownership to.
101    */
102   function transferOwnership(address _newOwner) onlyOwner public {
103     if(!canRenounce){
104       require(_newOwner != address(0));
105     }
106     emit OwnershipTransferred(owner, _newOwner);
107     owner = _newOwner;
108   }
109 
110   /**
111    * @dev Adds authority to execute several functions to subOwner.
112    * @param _authority The address to add authority to.
113    */
114 
115   function addAuthority(address _authority) onlyOwner public {
116     authorities[_authority] = true;
117     emit AuthorityAdded(_authority);
118   }
119 
120 
121   /**
122    * @dev Removes authority to execute several functions from subOwner.
123    * @param _authority The address to remove authority from.
124    */
125 
126   function removeAuthority(address _authority) onlyOwner public {
127     authorities[_authority] = false;
128     emit AuthorityRemoved(_authority);
129   }
130 }
131 
132 
133 
134 /**
135  * @title Pausable
136  * @dev Base contract which allows children to implement an emergency stop mechanism.
137  */
138 contract Pausable is Ownable {
139   event Pause();
140   event Unpause();
141 
142   bool public paused = false;
143 
144   /**
145    * @dev Modifier to make a function callable only when the contract is not paused.
146    */
147   modifier whenNotPaused() {
148     require(!paused);
149     _;
150   }
151 
152   /**
153    * @dev Modifier to make a function callable only when the contract is paused.
154    */
155   modifier whenPaused() {
156     require(paused);
157     _;
158   }
159 
160   /**
161    * @dev called by the owner to pause, triggers stopped state
162    */
163   function pause() onlyOwner whenNotPaused public {
164     paused = true;
165     emit Pause();
166   }
167 
168   /**
169    * @dev called by the owner to unpause, returns to normal state
170    */
171   function unpause() onlyOwner whenPaused public {
172     paused = false;
173     emit Unpause();
174   }
175 }
176 
177 
178 
179 /**
180  * @title ERC223
181  * @dev ERC223 contract interface with ERC20 functions and events
182  *      Fully backward compatible with ERC20
183  *      Recommended implementation used at https://github.com/Dexaran/ERC223-token-standard/tree/Recommended
184  */
185 contract ERC223 {
186     uint public totalSupply;
187 
188     // ERC223 and ERC20 functions and events
189     function name() public view returns (string _name);
190     function symbol() public view returns (string _symbol);
191     function decimals() public view returns (uint8 _decimals);
192     function balanceOf(address who) public view returns (uint);
193     function totalSupply() public view returns (uint256 _supply);
194     function transfer(address to, uint value) public returns (bool ok);
195     function transfer(address to, uint value, bytes data) public returns (bool ok);
196     function transferFrom(address _from, address _to, uint256 _value) public returns (bool success);
197     function approve(address _spender, uint256 _value) public returns (bool success);
198     function allowance(address _owner, address _spender) public view returns (uint256 remaining);
199 
200     event Transfer(address indexed _from, address indexed _to, uint256 _value);
201     event Transfer(address indexed from, address indexed to, uint value, bytes indexed data);
202     event Approval(address indexed _owner, address indexed _spender, uint _value);
203 }
204 
205 
206 
207 /**
208  * @title ContractReceiver
209  * @dev Contract that is working with ERC223 tokens
210  */
211  contract ContractReceiver {
212 /**
213  * @dev Standard ERC223 function that will handle incoming token transfers.
214  *
215  * @param _from  Token sender address.
216  * @param _value Amount of tokens.
217  * @param _data  Transaction metadata.
218  */
219     function tokenFallback(address _from, uint _value, bytes _data) external;
220 }
221 
222 
223 
224 
225 /**
226  * @title YUKI
227  * @author YUKI_Hayate and NANJ_Shimokawa
228  * @dev YUKI is an ERC223 Token with ERC20 functions and events
229  *      Fully backward compatible with ERC20
230  */
231 contract YUKI is ERC223, Ownable, Pausable {
232     using SafeMath for uint256;
233 
234     string public name = "YUKI";
235     string public symbol = "YUKI";
236     uint8 public decimals = 8;
237     uint256 public totalSupply = 20e9 * 1e8;
238     uint256 public codeSize = 0;
239     bool public mintingFinished = false;
240 
241     address public initialMarketSales = 0x1b879912446d844Fb5915bf4f773F0Db9Cd16ADb;
242     address public incentiveForHolder = 0x0908e3Df5Ed1E67D2AaF38401d4826B2879e8f4b;
243     address public developmentFunds = 0x52F018dc3dd621c8b2D649AC0e22E271a0dE049e;
244     address public marketingFunds = 0x6771a091C97c79a52c8DD5d98A59c5d3B27F99aA;
245     address public organization = 0xD90E1f987252b8EA71ac1cF14465FE9A3803267F;
246 
247     mapping(address => uint256) public balanceOf;
248     mapping(address => mapping (address => uint256)) public allowance;
249     mapping (address => bool) public cannotSend;
250     mapping (address => bool) public cannotReceive;
251     mapping (address => uint256) public cannotSendUntil;
252     mapping (address => uint256) public cannotReceiveUntil;
253 
254     event FrozenFunds(address indexed target, bool cannotSend, bool cannotReceive);
255     event LockedFunds(address indexed target, uint256 cannotSendUntil, uint256 cannotReceiveUntil);
256     event Burn(address indexed from, uint256 amount);
257     event Mint(address indexed to, uint256 amount);
258     event MintFinished();
259 
260     /**
261      * @dev Constructor is called only once and can not be called again
262      */
263     constructor() public {
264         owner = msg.sender;
265 
266         balanceOf[initialMarketSales] = totalSupply.mul(45).div(100);
267         balanceOf[incentiveForHolder] = totalSupply.mul(5).div(100);
268         balanceOf[developmentFunds] = totalSupply.mul(20).div(100);
269         balanceOf[marketingFunds] = totalSupply.mul(175).div(1000);
270         balanceOf[organization] = totalSupply.mul(125).div(1000);
271     }
272 
273     function name() public view returns (string _name) {
274         return name;
275     }
276 
277     function symbol() public view returns (string _symbol) {
278         return symbol;
279     }
280 
281     function decimals() public view returns (uint8 _decimals) {
282         return decimals;
283     }
284 
285     function totalSupply() public view returns (uint256 _totalSupply) {
286         return totalSupply;
287     }
288 
289     function balanceOf(address _owner) public view returns (uint256 balance) {
290         return balanceOf[_owner];
291     }
292     
293     /**
294      * @dev Prevent targets from sending or receiving tokens
295      * @param targets Addresses to be frozen
296      * @param _cannotSend Whether to prevent targets from sending tokens or not
297      * @param _cannotReceive Whether to prevent targets from receiving tokens or not
298      */
299     function freezeAccounts(address[] targets, bool _cannotSend, bool _cannotReceive) onlyOwner public {
300         require(targets.length > 0);
301 
302         for (uint i = 0; i < targets.length; i++) {
303             cannotSend[targets[i]] = _cannotSend;
304             cannotReceive[targets[i]] = _cannotReceive;
305             emit FrozenFunds(targets[i], _cannotSend, _cannotReceive);
306         }
307     }
308 
309     /**
310      * @dev Prevent targets from sending or receiving tokens by setting Unix time
311      * @param targets Addresses to be locked funds
312      * @param _cannotSendUntil Unix time when locking up sending function will be finished
313      * @param _cannotReceiveUntil Unix time when locking up receiving function will be finished
314      */
315     function lockupAccounts(address[] targets, uint256 _cannotSendUntil, uint256 _cannotReceiveUntil) onlyOwner public {
316         require(targets.length > 0);
317 
318         for(uint i = 0; i < targets.length; i++){
319             require(cannotSendUntil[targets[i]] <= _cannotSendUntil
320                     && cannotReceiveUntil[targets[i]] <= _cannotReceiveUntil);
321 
322             cannotSendUntil[targets[i]] = _cannotSendUntil;
323             cannotReceiveUntil[targets[i]] = _cannotReceiveUntil;
324             emit LockedFunds(targets[i], _cannotSendUntil, _cannotReceiveUntil);
325         }
326     }
327 
328     /**
329      * @dev Function that is called when a user or another contract wants to transfer funds
330      */
331     function transfer(address _to, uint _value, bytes _data) whenNotPaused public returns (bool success) {
332         require(_value > 0
333                 && cannotSend[msg.sender] == false
334                 && cannotReceive[_to] == false
335                 && now > cannotSendUntil[msg.sender]
336                 && now > cannotReceiveUntil[_to]);
337 
338         if (isContract(_to)) {
339             return transferToContract(_to, _value, _data);
340         } else {
341             return transferToAddress(_to, _value, _data);
342         }
343     }
344 
345     /**
346      * @dev Standard function transfer similar to ERC20 transfer with no _data
347      *      Added due to backwards compatibility reasons
348      */
349     function transfer(address _to, uint _value) whenNotPaused public returns (bool success) {
350         require(_value > 0
351                 && cannotSend[msg.sender] == false
352                 && cannotReceive[_to] == false
353                 && now > cannotSendUntil[msg.sender]
354                 && now > cannotReceiveUntil[_to]);
355 
356         bytes memory empty;
357         if (isContract(_to)) {
358             return transferToContract(_to, _value, empty);
359         } else {
360             return transferToAddress(_to, _value, empty);
361         }
362     }
363 
364  /**
365    * @dev Returns whether the target address is a contract
366    * @param _addr address to check
367    * @return whether the target address is a contract
368    */
369   function isContract(address _addr) internal view returns (bool) {
370     uint256 size;
371     // Currently there is no better way to check if there is a contract in an address
372     // than to check the size of the code at that address.
373     // See https://ethereum.stackexchange.com/a/14016/36603
374     // for more details about how this works.
375     // Check this again before the Serenity release, because all addresses will be
376     // contracts then.
377     // solium-disable-next-line security/no-inline-assembly
378     assembly { size := extcodesize(_addr) }
379     return size > codeSize ;
380   }
381 
382     function setCodeSize(uint256 _codeSize) onlyOwner public {
383         codeSize = _codeSize;
384     }
385 
386     // function that is called when transaction target is an address
387     function transferToAddress(address _to, uint _value, bytes _data) private returns (bool success) {
388         require(balanceOf[msg.sender] >= _value);
389         balanceOf[msg.sender] = balanceOf[msg.sender].sub(_value);
390         balanceOf[_to] = balanceOf[_to].add(_value);
391         emit Transfer(msg.sender, _to, _value, _data);
392         emit Transfer(msg.sender, _to, _value);
393         return true;
394     }
395 
396     // function that is called when transaction target is a contract
397     function transferToContract(address _to, uint _value, bytes _data) private returns (bool success) {
398         require(balanceOf[msg.sender] >= _value);
399         balanceOf[msg.sender] = balanceOf[msg.sender].sub(_value);
400         balanceOf[_to] = balanceOf[_to].add(_value);
401         ContractReceiver receiver = ContractReceiver(_to);
402         receiver.tokenFallback(msg.sender, _value, _data);
403         emit Transfer(msg.sender, _to, _value, _data);
404         emit Transfer(msg.sender, _to, _value);
405         return true;
406     }
407 
408     /**
409      * @dev Transfer tokens from one address to another
410      *      Added due to backwards compatibility with ERC20
411      * @param _from address The address which you want to send tokens from
412      * @param _to address The address which you want to transfer to
413      * @param _value uint256 the amount of tokens to be transferred
414      */
415     function transferFrom(address _from, address _to, uint256 _value) whenNotPaused public returns (bool success) {
416         require(_to != address(0)
417                 && _value > 0
418                 && balanceOf[_from] >= _value
419                 && allowance[_from][msg.sender] >= _value
420                 && cannotSend[msg.sender] == false
421                 && cannotReceive[_to] == false
422                 && now > cannotSendUntil[msg.sender]
423                 && now > cannotReceiveUntil[_to]);
424 
425         balanceOf[_from] = balanceOf[_from].sub(_value);
426         balanceOf[_to] = balanceOf[_to].add(_value);
427         allowance[_from][msg.sender] = allowance[_from][msg.sender].sub(_value);
428         emit Transfer(_from, _to, _value);
429         return true;
430     }
431 
432     /**
433      * @dev Allows _spender to spend no more than _value tokens in your behalf
434      *      Added due to backwards compatibility with ERC20
435      * @param _spender The address authorized to spend
436      * @param _value the max amount they can spend
437      */
438     function approve(address _spender, uint256 _value) public returns (bool success) {
439         allowance[msg.sender][_spender] = _value;
440         emit Approval(msg.sender, _spender, _value);
441         return true;
442     }
443 
444     /**
445      * @dev Function to check the amount of tokens that an owner allowed to a spender
446      *      Added due to backwards compatibility with ERC20
447      * @param _owner address The address which owns the funds
448      * @param _spender address The address which will spend the funds
449      */
450     function allowance(address _owner, address _spender) public view returns (uint256 remaining) {
451         return allowance[_owner][_spender];
452     }
453 
454     /**
455      * @dev Burns a specific amount of tokens.
456      * @param _from The address that will burn the tokens.
457      * @param _unitAmount The amount of token to be burned.
458      */
459     function burn(address _from, uint256 _unitAmount) onlyOwner public {
460         require(_unitAmount > 0
461                 && balanceOf[_from] >= _unitAmount);
462 
463         balanceOf[_from] = balanceOf[_from].sub(_unitAmount);
464         totalSupply = totalSupply.sub(_unitAmount);
465         emit Burn(_from, _unitAmount);
466         emit Transfer(_from, address(0), _unitAmount);
467 
468     }
469     
470     modifier canMint() {
471         require(!mintingFinished);
472         _;
473     }
474 
475     /**
476      * @dev Function to mint tokens
477      * @param _to The address that will receive the minted tokens.
478      * @param _unitAmount The amount of tokens to mint.
479      */
480     function mint(address _to, uint256 _unitAmount) onlyOwner canMint public returns (bool) {
481         require(_unitAmount > 0);
482 
483         totalSupply = totalSupply.add(_unitAmount);
484         balanceOf[_to] = balanceOf[_to].add(_unitAmount);
485         emit Mint(_to, _unitAmount);
486         emit Transfer(address(0), _to, _unitAmount);
487         return true;
488     }
489 
490     /**
491      * @dev Function to stop minting new tokens.
492      */
493     function finishMinting() onlyOwner canMint public returns (bool) {
494         mintingFinished = true;
495         emit MintFinished();
496         return true;
497     }
498 
499     /**
500      * @dev Function to distribute tokens to the list of addresses by the provided amount
501      */
502     function batchTransfer(address[] addresses, uint256 amount) whenNotPaused public returns (bool) {
503         require(amount > 0
504                 && addresses.length > 0
505                 && cannotSend[msg.sender] == false
506                 && now > cannotSendUntil[msg.sender]);
507 
508         amount = amount.mul(1e8);
509         uint256 totalAmount = amount.mul(addresses.length);
510         require(balanceOf[msg.sender] >= totalAmount);
511 
512         for (uint i = 0; i < addresses.length; i++) {
513             require(addresses[i] != address(0)
514                     && cannotReceive[addresses[i]] == false
515                     && now > cannotReceiveUntil[addresses[i]]);
516 
517             balanceOf[addresses[i]] = balanceOf[addresses[i]].add(amount);
518             emit Transfer(msg.sender, addresses[i], amount);
519         }
520         balanceOf[msg.sender] = balanceOf[msg.sender].sub(totalAmount);
521         return true;
522     }
523 
524     function batchTransfer(address[] addresses, uint[] amounts) whenNotPaused public returns (bool) {
525         require(addresses.length > 0
526                 && addresses.length == amounts.length
527                 && cannotSend[msg.sender] == false
528                 && now > cannotSendUntil[msg.sender]);
529 
530         uint256 totalAmount = 0;
531 
532         for(uint i = 0; i < addresses.length; i++){
533             require(amounts[i] > 0
534                     && addresses[i] != address(0)
535                     && cannotReceive[addresses[i]] == false
536                     && now > cannotReceiveUntil[addresses[i]]);
537 
538             amounts[i] = amounts[i].mul(1e8);
539             balanceOf[addresses[i]] = balanceOf[addresses[i]].add(amounts[i]);
540             totalAmount = totalAmount.add(amounts[i]);
541             emit Transfer(msg.sender, addresses[i], amounts[i]);
542         }
543 
544         require(balanceOf[msg.sender] >= totalAmount);
545         balanceOf[msg.sender] = balanceOf[msg.sender].sub(totalAmount);
546         return true;
547     }
548 
549 
550     /**
551      * @dev Function to transfer tokens between addresses, only for Owner & subOwner
552      */
553 
554     function transferFromTo(address _from, address _to, uint256 _value, bytes _data) onlyAuthority public returns (bool) {
555         require(_value > 0
556                 && balanceOf[_from] >= _value
557                 && cannotSend[_from] == false
558                 && cannotReceive[_to] == false
559                 && now > cannotSendUntil[_from]
560                 && now > cannotReceiveUntil[_to]);
561 
562         balanceOf[_from] = balanceOf[_from].sub(_value);
563         balanceOf[_to] = balanceOf[_to].add(_value);
564         if(isContract(_to)) {
565             ContractReceiver receiver = ContractReceiver(_to);
566             receiver.tokenFallback(_from, _value, _data);
567         }
568         emit Transfer(_from, _to, _value, _data);
569         emit Transfer(_from, _to, _value);
570         return true;
571     }
572 
573     function transferFromTo(address _from, address _to, uint256 _value) onlyAuthority public returns (bool) {
574         bytes memory empty;
575         return transferFromTo(_from, _to, _value, empty);
576     }
577 
578     /**
579      * @dev fallback function
580      */
581     function() payable public {
582         revert();
583     }
584 
585     /**
586      * @dev Reject all ERC223 compatible tokens
587      * @param from_ address The address that is transferring the tokens
588      * @param value_ uint256 the amount of the specified token
589      * @param data_ Bytes The data passed from the caller.
590      */
591     function tokenFallback(address from_, uint256 value_, bytes data_) external pure {
592         from_;
593         value_;
594         data_;
595         revert();
596     }
597 }