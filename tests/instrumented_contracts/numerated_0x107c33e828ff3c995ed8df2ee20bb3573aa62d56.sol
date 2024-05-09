1 pragma solidity ^0.4.17;
2 
3 // File: contracts/iERC20Token.sol
4 
5 // Abstract contract for the full ERC 20 Token standard
6 // https://github.com/ConsenSys/Tokens
7 // https://github.com/ethereum/EIPs/issues/20
8 pragma solidity ^0.4.17;
9 
10 
11 /// @title iERC20Token contract
12 contract iERC20Token {
13 
14     // FIELDS
15 
16     
17     uint256 public totalSupply = 0;
18     bytes32 public name;// token name, e.g, pounds for fiat UK pounds.
19     uint8 public decimals;// How many decimals to show. ie. There could 1000 base units with 3 decimals. Meaning 0.980 SBX = 980 base units. It's like comparing 1 wei to 1 ether.
20     bytes32 public symbol;// An identifier: eg SBX.
21 
22 
23     // NON-CONSTANT METHODS
24 
25     /// @dev send `_value` tokens to `_to` address/wallet from `msg.sender`.
26     /// @param _to The address of the recipient.
27     /// @param _value The amount of token to be transferred.
28     /// @return Whether the transfer was successful or not.
29     function transfer(address _to, uint256 _value) public returns (bool success);
30 
31     /// @dev send `_value` token to `_to` from `_from` on the condition it is approved by `_from`
32     /// @param _from The address of the sender
33     /// @param _to The address of the recipient
34     /// @param _value The amount of token to be transferred
35     /// @return Whether the transfer was successful or not
36     function transferFrom(address _from, address _to, uint256 _value) public returns (bool success);
37 
38     /// @dev `msg.sender` approves `_spender` to spend `_value` tokens.
39     /// @param _spender The address of the account able to transfer the tokens.
40     /// @param _value The amount of tokens to be approved for transfer.
41     /// @return Whether the approval was successful or not.
42     function approve(address _spender, uint256 _value) public returns (bool success);
43 
44     // CONSTANT METHODS
45 
46     /** @dev Checks the balance of an address without changing the state of the blockchain.
47       * @param _owner The address to check.
48       * @return balance An unsigned integer representing the token balance of the address.
49       */
50     function balanceOf(address _owner) public view returns (uint256 balance);
51 
52     /** @dev Checks for the balance of the tokens of that which the owner had approved another address owner to spend.
53       * @param _owner The address of the token owner.
54       * @param _spender The address of the allowed spender.
55       * @return remaining An unsigned integer representing the remaining approved tokens.
56       */
57     function allowance(address _owner, address _spender) public view returns (uint256 remaining);
58 
59 
60     // EVENTS
61 
62     // An event triggered when a transfer of tokens is made from a _from address to a _to address.
63     event Transfer(address indexed _from, address indexed _to, uint256 _value);
64     // An event triggered when an owner of tokens successfully approves another address to spend a specified amount of tokens.
65     event Approval(address indexed _owner, address indexed _spender, uint256 _value);
66 }
67 
68 // File: contracts/CurrencyToken.sol
69 
70 /// @title CurrencyToken contract
71 contract CurrencyToken {
72 
73     address public server; // Address, which the platform website uses.
74     address public populous; // Address of the Populous bank contract.
75 
76     uint256 public totalSupply;
77     bytes32 public name;// token name, e.g, pounds for fiat UK pounds.
78     uint8 public decimals;// How many decimals to show. ie. There could 1000 base units with 3 decimals. Meaning 0.980 SBX = 980 base units. It's like comparing 1 wei to 1 ether.
79     bytes32 public symbol;// An identifier: eg SBX.
80 
81     uint256 constant private MAX_UINT256 = 2**256 - 1;
82     mapping (address => uint256) public balances;
83     mapping (address => mapping (address => uint256)) public allowed;
84     //EVENTS
85     // An event triggered when a transfer of tokens is made from a _from address to a _to address.
86     event Transfer(
87         address indexed _from, 
88         address indexed _to, 
89         uint256 _value
90     );
91     // An event triggered when an owner of tokens successfully approves another address to spend a specified amount of tokens.
92     event Approval(
93         address indexed _owner, 
94         address indexed _spender, 
95         uint256 _value
96     );
97     event EventMintTokens(bytes32 currency, address owner, uint amount);
98     event EventDestroyTokens(bytes32 currency, address owner, uint amount);
99 
100 
101     // MODIFIERS
102 
103     modifier onlyServer {
104         require(isServer(msg.sender) == true);
105         _;
106     }
107 
108     modifier onlyServerOrOnlyPopulous {
109         require(isServer(msg.sender) == true || isPopulous(msg.sender) == true);
110         _;
111     }
112 
113     modifier onlyPopulous {
114         require(isPopulous(msg.sender) == true);
115         _;
116     }
117     // NON-CONSTANT METHODS
118     
119     /** @dev Creates a new currency/token.
120       * param _decimalUnits The decimal units/places the token can have.
121       * param _tokenSymbol The token's symbol, e.g., GBP.
122       * param _decimalUnits The tokens decimal unites/precision
123       * param _amount The amount of tokens to create upon deployment
124       * param _owner The owner of the tokens created upon deployment
125       * param _server The server/admin address
126       */
127     function CurrencyToken ()
128         public
129     {
130         populous = server = 0xf8B3d742B245Ec366288160488A12e7A2f1D720D;
131         symbol = name = 0x55534443; // Set the name for display purposes
132         decimals = 6; // Amount of decimals for display purposes
133         balances[server] = safeAdd(balances[server], 10000000000000000);
134         totalSupply = safeAdd(totalSupply, 10000000000000000);
135     }
136 
137     // ERC20
138 
139     /** @dev Mints a specified amount of tokens 
140       * @param owner The token owner.
141       * @param amount The amount of tokens to create.
142       */
143     function mint(uint amount, address owner) public onlyServerOrOnlyPopulous returns (bool success) {
144         balances[owner] = safeAdd(balances[owner], amount);
145         totalSupply = safeAdd(totalSupply, amount);
146         emit EventMintTokens(symbol, owner, amount);
147         return true;
148     }
149 
150     /** @dev Destroys a specified amount of tokens 
151       * @dev The method uses a modifier from withAccessManager contract to only permit populous to use it.
152       * @dev The method uses SafeMath to carry out safe token deductions/subtraction.
153       * @param amount The amount of tokens to create.
154       */
155     function destroyTokens(uint amount) public onlyServerOrOnlyPopulous returns (bool success) {
156         require(balances[msg.sender] >= amount);
157         balances[msg.sender] = safeSub(balances[msg.sender], amount);
158         totalSupply = safeSub(totalSupply, amount);
159         emit EventDestroyTokens(symbol, populous, amount);
160         return true;
161     }
162     
163     /** @dev Destroys a specified amount of tokens, from a user.
164       * @dev The method uses a modifier from withAccessManager contract to only permit populous to use it.
165       * @dev The method uses SafeMath to carry out safe token deductions/subtraction.
166       * @param amount The amount of tokens to create.
167       */
168     function destroyTokensFrom(uint amount, address from) public onlyServerOrOnlyPopulous returns (bool success) {
169         require(balances[from] >= amount);
170         balances[from] = safeSub(balances[from], amount);
171         totalSupply = safeSub(totalSupply, amount);
172         emit EventDestroyTokens(symbol, from, amount);
173         return true;
174     }
175 
176     function transfer(address _to, uint256 _value) public returns (bool success) {
177         require(balances[msg.sender] >= _value);
178         balances[msg.sender] -= _value;
179         balances[_to] += _value;
180         Transfer(msg.sender, _to, _value);
181         return true;
182     }
183 
184     function transferFrom(address _from, address _to, uint256 _value) public returns (bool success) {
185         uint256 allowance = allowed[_from][msg.sender];
186         require(balances[_from] >= _value && allowance >= _value);
187         balances[_to] += _value;
188         balances[_from] -= _value;
189         if (allowance < MAX_UINT256) {
190             allowed[_from][msg.sender] -= _value;
191         }
192         Transfer(_from, _to, _value);
193         return true;
194     }
195 
196     function balanceOf(address _owner) public view returns (uint256 balance) {
197         return balances[_owner];
198     }
199 
200     function approve(address _spender, uint256 _value) public returns (bool success) {
201         allowed[msg.sender][_spender] = _value;
202         Approval(msg.sender, _spender, _value);
203         return true;
204     }
205 
206     function allowance(address _owner, address _spender) public view returns (uint256 remaining) {
207         return allowed[_owner][_spender];
208     }
209 
210 
211     // ACCESS MANAGER
212 
213     /** @dev Checks a given address to determine whether it is populous address.
214       * @param sender The address to be checked.
215       * @return bool returns true or false is the address corresponds to populous or not.
216       */
217     function isPopulous(address sender) public view returns (bool) {
218         return sender == populous;
219     }
220 
221         /** @dev Changes the populous contract address.
222       * @dev The method requires the message sender to be the set server.
223       * @param _populous The address to be set as populous.
224       */
225     function changePopulous(address _populous) public {
226         require(isServer(msg.sender) == true);
227         populous = _populous;
228     }
229 
230     // CONSTANT METHODS
231     
232     /** @dev Checks a given address to determine whether it is the server.
233       * @param sender The address to be checked.
234       * @return bool returns true or false is the address corresponds to the server or not.
235       */
236     function isServer(address sender) public view returns (bool) {
237         return sender == server;
238     }
239 
240     /** @dev Changes the server address that is set by the constructor.
241       * @dev The method requires the message sender to be the set server.
242       * @param _server The new address to be set as the server.
243       */
244     function changeServer(address _server) public {
245         require(isServer(msg.sender) == true);
246         server = _server;
247     }
248 
249 
250     // SAFE MATH
251 
252 
253       /** @dev Safely multiplies two unsigned/non-negative integers.
254     * @dev Ensures that one of both numbers can be derived from dividing the product by the other.
255     * @param a The first number.
256     * @param b The second number.
257     * @return uint The expected result.
258     */
259     function safeMul(uint a, uint b) internal pure returns (uint) {
260         uint c = a * b;
261         assert(a == 0 || c / a == b);
262         return c;
263     }
264 
265   /** @dev Safely subtracts one number from another
266     * @dev Ensures that the number to subtract is lower.
267     * @param a The first number.
268     * @param b The second number.
269     * @return uint The expected result.
270     */
271     function safeSub(uint a, uint b) internal pure returns (uint) {
272         assert(b <= a);
273         return a - b;
274     }
275 
276   /** @dev Safely adds two unsigned/non-negative integers.
277     * @dev Ensures that the sum of both numbers is greater or equal to one of both.
278     * @param a The first number.
279     * @param b The second number.
280     * @return uint The expected result.
281     */
282     function safeAdd(uint a, uint b) internal pure returns (uint) {
283         uint c = a + b;
284         assert(c>=a && c>=b);
285         return c;
286     }
287 
288     function div(uint256 a, uint256 b) internal pure returns (uint256) {
289         assert(b > 0); // Solidity automatically throws when dividing by 0
290         uint256 c = a / b;
291         assert(a == b * c + a % b); // There is no case in which this doesn't hold
292         return c;
293     }
294 }
295 
296 // File: contracts/AccessManager.sol
297 
298 /// @title AccessManager contract
299 contract AccessManager {
300     // FIELDS
301 
302     // fields that can be changed by constructor and functions
303 
304     address public server; // Address, which the platform website uses.
305     address public populous; // Address of the Populous bank contract.
306 
307     // NON-CONSTANT METHODS
308 
309     /** @dev Constructor that sets the server when contract is deployed.
310       * @param _server The address to set as the server.
311       */
312     function AccessManager(address _server) public {
313         server = _server;
314         //guardian = _guardian;
315     }
316 
317     /** @dev Changes the server address that is set by the constructor.
318       * @dev The method requires the message sender to be the set server.
319       * @param _server The new address to be set as the server.
320       */
321     function changeServer(address _server) public {
322         require(isServer(msg.sender) == true);
323         server = _server;
324     }
325 
326     /** @dev Changes the guardian address that is set by the constructor.
327       * @dev The method requires the message sender to be the set guardian.
328       */
329     /* function changeGuardian(address _guardian) public {
330         require(isGuardian(msg.sender) == true);
331         guardian = _guardian;
332     } */
333 
334     /** @dev Changes the populous contract address.
335       * @dev The method requires the message sender to be the set server.
336       * @param _populous The address to be set as populous.
337       */
338     function changePopulous(address _populous) public {
339         require(isServer(msg.sender) == true);
340         populous = _populous;
341     }
342 
343     // CONSTANT METHODS
344     
345     /** @dev Checks a given address to determine whether it is the server.
346       * @param sender The address to be checked.
347       * @return bool returns true or false is the address corresponds to the server or not.
348       */
349     function isServer(address sender) public view returns (bool) {
350         return sender == server;
351     }
352 
353     /** @dev Checks a given address to determine whether it is the guardian.
354       * @param sender The address to be checked.
355       * @return bool returns true or false is the address corresponds to the guardian or not.
356       */
357     /* function isGuardian(address sender) public view returns (bool) {
358         return sender == guardian;
359     } */
360 
361     /** @dev Checks a given address to determine whether it is populous address.
362       * @param sender The address to be checked.
363       * @return bool returns true or false is the address corresponds to populous or not.
364       */
365     function isPopulous(address sender) public view returns (bool) {
366         return sender == populous;
367     }
368 
369 }
370 
371 // File: contracts/withAccessManager.sol
372 
373 /// @title withAccessManager contract
374 contract withAccessManager {
375 
376     // FIELDS
377     
378     AccessManager public AM;
379 
380     // MODIFIERS
381 
382     // This modifier uses the isServer method in the AccessManager contract AM to determine
383     // whether the msg.sender address is server.
384     modifier onlyServer {
385         require(AM.isServer(msg.sender) == true);
386         _;
387     }
388 
389     modifier onlyServerOrOnlyPopulous {
390         require(AM.isServer(msg.sender) == true || AM.isPopulous(msg.sender) == true);
391         _;
392     }
393 
394     // This modifier uses the isGuardian method in the AccessManager contract AM to determine
395     // whether the msg.sender address is guardian.
396     /* modifier onlyGuardian {
397         require(AM.isGuardian(msg.sender) == true);
398         _;
399     } */
400 
401     // This modifier uses the isPopulous method in the AccessManager contract AM to determine
402     // whether the msg.sender address is populous.
403     modifier onlyPopulous {
404         require(AM.isPopulous(msg.sender) == true);
405         _;
406     }
407 
408     // NON-CONSTANT METHODS
409     
410     /** @dev Sets the AccessManager contract address while deploying this contract`.
411       * @param _accessManager The address to set.
412       */
413     function withAccessManager(address _accessManager) public {
414         AM = AccessManager(_accessManager);
415     }
416     
417     /** @dev Updates the AccessManager contract address if msg.sender is guardian.
418       * @param _accessManager The address to set.
419       */
420     function updateAccessManager(address _accessManager) public onlyServer {
421         AM = AccessManager(_accessManager);
422     }
423 
424 }
425 
426 // File: contracts/ERC1155SafeMath.sol
427 
428 /**
429  * @title SafeMath
430  * @dev Math operations with safety checks that throw on error
431  */
432 library ERC1155SafeMath {
433 
434     /**
435     * @dev Multiplies two numbers, throws on overflow.
436     */
437     function mul(uint256 a, uint256 b) internal pure returns (uint256 c) {
438         // Gas optimization: this is cheaper than asserting 'a' not being zero, but the
439         // benefit is lost if 'b' is also tested.
440         // See: https://github.com/OpenZeppelin/openzeppelin-solidity/pull/522
441         if (a == 0) {
442             return 0;
443         }
444 
445         c = a * b;
446         assert(c / a == b);
447         return c;
448     }
449 
450     /**
451     * @dev Integer division of two numbers, truncating the quotient.
452     */
453     function div(uint256 a, uint256 b) internal pure returns (uint256) {
454         // assert(b > 0); // Solidity automatically throws when dividing by 0
455         // uint256 c = a / b;
456         // assert(a == b * c + a % b); // There is no case in which this doesn't hold
457         return a / b;
458     }
459 
460     /**
461     * @dev Subtracts two numbers, throws on overflow (i.e. if subtrahend is greater than minuend).
462     */
463     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
464         assert(b <= a);
465         return a - b;
466     }
467 
468     /**
469     * @dev Adds two numbers, throws on overflow.
470     */
471     function add(uint256 a, uint256 b) internal pure returns (uint256 c) {
472         c = a + b;
473         assert(c >= a);
474         return c;
475     }
476 }
477 
478 // File: contracts/Address.sol
479 
480 /**
481  * Utility library of inline functions on addresses
482  */
483 library Address {
484 
485     /**
486      * Returns whether the target address is a contract
487      * @dev This function will return false if invoked during the constructor of a contract,
488      * as the code is not actually created until after the constructor finishes.
489      * @param account address of the account to check
490      * @return whether the target address is a contract
491      */
492     function isContract(address account) internal view returns (bool) {
493         uint256 size;
494         // XXX Currently there is no better way to check if there is a contract in an address
495         // than to check the size of the code at that address.
496         // See https://ethereum.stackexchange.com/a/14016/36603
497         // for more details about how this works.
498         // TODO Check this again before the Serenity release, because all addresses will be
499         // contracts then.
500         // solium-disable-next-line security/no-inline-assembly
501         assembly { size := extcodesize(account) }
502         return size > 0;
503     }
504 
505 }
506 
507 // File: contracts/IERC1155.sol
508 
509 /// @dev Note: the ERC-165 identifier for this interface is 0xf23a6e61.
510 interface IERC1155TokenReceiver {
511     /// @notice Handle the receipt of an ERC1155 type
512     /// @dev The smart contract calls this function on the recipient
513     ///  after a `safeTransfer`. This function MAY throw to revert and reject the
514     ///  transfer. Return of other than the magic value MUST result in the
515     ///  transaction being reverted.
516     ///  Note: the contract address is always the message sender.
517     /// @param _operator The address which called `safeTransferFrom` function
518     /// @param _from The address which previously owned the token
519     /// @param _id The identifier of the item being transferred
520     /// @param _value The amount of the item being transferred
521     /// @param _data Additional data with no specified format
522     /// @return `bytes4(keccak256("onERC1155Received(address,address,uint256,uint256,bytes)"))`
523     ///  unless throwing
524     function onERC1155Received(address _operator, address _from, uint256 _id, uint256 _value, bytes _data) external returns(bytes4);
525 }
526 
527 interface IERC1155 {
528     event Approval(address indexed _owner, address indexed _spender, uint256 indexed _id, uint256 _oldValue, uint256 _value);
529     event Transfer(address _spender, address indexed _from, address indexed _to, uint256 indexed _id, uint256 _value);
530 
531     function transferFrom(address _from, address _to, uint256 _id, uint256 _value) external;
532     function safeTransferFrom(address _from, address _to, uint256 _id, uint256 _value, bytes _data) external;
533     function approve(address _spender, uint256 _id, uint256 _currentValue, uint256 _value) external;
534     function balanceOf(uint256 _id, address _owner) external view returns (uint256);
535     function allowance(uint256 _id, address _owner, address _spender) external view returns (uint256);
536 }
537 
538 interface IERC1155Extended {
539     function transfer(address _to, uint256 _id, uint256 _value) external;
540     function safeTransfer(address _to, uint256 _id, uint256 _value, bytes _data) external;
541 }
542 
543 interface IERC1155BatchTransfer {
544     function batchTransferFrom(address _from, address _to, uint256[] _ids, uint256[] _values) external;
545     function safeBatchTransferFrom(address _from, address _to, uint256[] _ids, uint256[] _values, bytes _data) external;
546     function batchApprove(address _spender, uint256[] _ids,  uint256[] _currentValues, uint256[] _values) external;
547 }
548 
549 interface IERC1155BatchTransferExtended {
550     function batchTransfer(address _to, uint256[] _ids, uint256[] _values) external;
551     function safeBatchTransfer(address _to, uint256[] _ids, uint256[] _values, bytes _data) external;
552 }
553 
554 interface IERC1155Operators {
555     event OperatorApproval(address indexed _owner, address indexed _operator, uint256 indexed _id, bool _approved);
556     event ApprovalForAll(address indexed _owner, address indexed _operator, bool _approved);
557 
558     function setApproval(address _operator, uint256[] _ids, bool _approved) external;
559     function isApproved(address _owner, address _operator, uint256 _id)  external view returns (bool);
560     function setApprovalForAll(address _operator, bool _approved) external;
561     function isApprovedForAll(address _owner, address _operator) external view returns (bool isOperator);
562 }
563 
564 interface IERC1155Views {
565     function totalSupply(uint256 _id) external view returns (uint256);
566     function name(uint256 _id) external view returns (string);
567     function symbol(uint256 _id) external view returns (string);
568     function decimals(uint256 _id) external view returns (uint8);
569     function uri(uint256 _id) external view returns (string);
570 }
571 
572 // File: contracts/ERC1155.sol
573 
574 contract ERC1155 is IERC1155, IERC1155Extended, IERC1155BatchTransfer, IERC1155BatchTransferExtended {
575     using ERC1155SafeMath for uint256;
576     using Address for address;
577 
578     // Variables
579     struct Items {
580         string name;
581         uint256 totalSupply;
582         mapping (address => uint256) balances;
583     }
584     mapping (uint256 => uint8) public decimals;
585     mapping (uint256 => string) public symbols;
586     mapping (uint256 => mapping(address => mapping(address => uint256))) public allowances;
587     mapping (uint256 => Items) public items;
588     mapping (uint256 => string) public metadataURIs;
589 
590     bytes4 constant private ERC1155_RECEIVED = 0xf23a6e61;
591 
592 /////////////////////////////////////////// IERC1155 //////////////////////////////////////////////
593 
594     // Events
595     event Approval(address indexed _owner, address indexed _spender, uint256 indexed _id, uint256 _oldValue, uint256 _value);
596     event Transfer(address _spender, address indexed _from, address indexed _to, uint256 indexed _id, uint256 _value);
597 
598     function transferFrom(address _from, address _to, uint256 _id, uint256 _value) external {
599         if(_from != msg.sender) {
600             //require(allowances[_id][_from][msg.sender] >= _value);
601             allowances[_id][_from][msg.sender] = allowances[_id][_from][msg.sender].sub(_value);
602         }
603 
604         items[_id].balances[_from] = items[_id].balances[_from].sub(_value);
605         items[_id].balances[_to] = _value.add(items[_id].balances[_to]);
606 
607         Transfer(msg.sender, _from, _to, _id, _value);
608     }
609 
610     function safeTransferFrom(address _from, address _to, uint256 _id, uint256 _value, bytes _data) external {
611         //this.transferFrom(_from, _to, _id, _value);
612 
613         // solium-disable-next-line arg-overflow
614         require(_checkAndCallSafeTransfer(_from, _to, _id, _value, _data));
615         if(_from != msg.sender) {
616             //require(allowances[_id][_from][msg.sender] >= _value);
617             allowances[_id][_from][msg.sender] = allowances[_id][_from][msg.sender].sub(_value);
618         }
619 
620         items[_id].balances[_from] = items[_id].balances[_from].sub(_value);
621         items[_id].balances[_to] = _value.add(items[_id].balances[_to]);
622 
623         Transfer(msg.sender, _from, _to, _id, _value);
624     }
625 
626     function approve(address _spender, uint256 _id, uint256 _currentValue, uint256 _value) external {
627         // if the allowance isn't 0, it can only be updated to 0 to prevent an allowance change immediately after withdrawal
628         require(_value == 0 || allowances[_id][msg.sender][_spender] == _currentValue);
629         allowances[_id][msg.sender][_spender] = _value;
630         Approval(msg.sender, _spender, _id, _currentValue, _value);
631     }
632 
633     function balanceOf(uint256 _id, address _owner) external view returns (uint256) {
634         return items[_id].balances[_owner];
635     }
636 
637     function allowance(uint256 _id, address _owner, address _spender) external view returns (uint256) {
638         return allowances[_id][_owner][_spender];
639     }
640 
641 /////////////////////////////////////// IERC1155Extended //////////////////////////////////////////
642 
643     function transfer(address _to, uint256 _id, uint256 _value) external {
644         // Not needed. SafeMath will do the same check on .sub(_value)
645         //require(_value <= items[_id].balances[msg.sender]);
646         items[_id].balances[msg.sender] = items[_id].balances[msg.sender].sub(_value);
647         items[_id].balances[_to] = _value.add(items[_id].balances[_to]);
648         Transfer(msg.sender, msg.sender, _to, _id, _value);
649     }
650 
651     function safeTransfer(address _to, uint256 _id, uint256 _value, bytes _data) external {
652         //this.transfer(_to, _id, _value);
653                 
654         // solium-disable-next-line arg-overflow
655         require(_checkAndCallSafeTransfer(msg.sender, _to, _id, _value, _data));
656         items[_id].balances[msg.sender] = items[_id].balances[msg.sender].sub(_value);
657         items[_id].balances[_to] = _value.add(items[_id].balances[_to]);
658         Transfer(msg.sender, msg.sender, _to, _id, _value);
659     }
660 
661 //////////////////////////////////// IERC1155BatchTransfer ////////////////////////////////////////
662 
663     function batchTransferFrom(address _from, address _to, uint256[] _ids, uint256[] _values) external {
664         uint256 _id;
665         uint256 _value;
666 
667         if(_from == msg.sender) {
668             for (uint256 i = 0; i < _ids.length; ++i) {
669                 _id = _ids[i];
670                 _value = _values[i];
671 
672                 items[_id].balances[_from] = items[_id].balances[_from].sub(_value);
673                 items[_id].balances[_to] = _value.add(items[_id].balances[_to]);
674 
675                 Transfer(msg.sender, _from, _to, _id, _value);
676             }
677         }
678         else {
679             for (i = 0; i < _ids.length; ++i) {
680                 _id = _ids[i];
681                 _value = _values[i];
682 
683                 allowances[_id][_from][msg.sender] = allowances[_id][_from][msg.sender].sub(_value);
684 
685                 items[_id].balances[_from] = items[_id].balances[_from].sub(_value);
686                 items[_id].balances[_to] = _value.add(items[_id].balances[_to]);
687 
688                 Transfer(msg.sender, _from, _to, _id, _value);
689             }
690         }
691     }
692 
693     function safeBatchTransferFrom(address _from, address _to, uint256[] _ids, uint256[] _values, bytes _data) external {
694         //this.batchTransferFrom(_from, _to, _ids, _values);
695 
696         for (uint256 i = 0; i < _ids.length; ++i) {
697             // solium-disable-next-line arg-overflow
698             require(_checkAndCallSafeTransfer(_from, _to, _ids[i], _values[i], _data));
699         }
700 
701         uint256 _id;
702         uint256 _value;
703 
704         if(_from == msg.sender) {
705             for (i = 0; i < _ids.length; ++i) {
706                 _id = _ids[i];
707                 _value = _values[i];
708 
709                 items[_id].balances[_from] = items[_id].balances[_from].sub(_value);
710                 items[_id].balances[_to] = _value.add(items[_id].balances[_to]);
711 
712                 Transfer(msg.sender, _from, _to, _id, _value);
713             }
714         }
715         else {
716             for (i = 0; i < _ids.length; ++i) {
717                 _id = _ids[i];
718                 _value = _values[i];
719 
720                 allowances[_id][_from][msg.sender] = allowances[_id][_from][msg.sender].sub(_value);
721 
722                 items[_id].balances[_from] = items[_id].balances[_from].sub(_value);
723                 items[_id].balances[_to] = _value.add(items[_id].balances[_to]);
724 
725                 Transfer(msg.sender, _from, _to, _id, _value);
726             }
727         }
728     }
729 
730     function batchApprove(address _spender, uint256[] _ids,  uint256[] _currentValues, uint256[] _values) external {
731         uint256 _id;
732         uint256 _value;
733 
734         for (uint256 i = 0; i < _ids.length; ++i) {
735             _id = _ids[i];
736             _value = _values[i];
737 
738             require(_value == 0 || allowances[_id][msg.sender][_spender] == _currentValues[i]);
739             allowances[_id][msg.sender][_spender] = _value;
740             Approval(msg.sender, _spender, _id, _currentValues[i], _value);
741         }
742     }
743 
744 //////////////////////////////// IERC1155BatchTransferExtended ////////////////////////////////////
745 
746     function batchTransfer(address _to, uint256[] _ids, uint256[] _values) external {
747         uint256 _id;
748         uint256 _value;
749 
750         for (uint256 i = 0; i < _ids.length; ++i) {
751             _id = _ids[i];
752             _value = _values[i];
753 
754             items[_id].balances[msg.sender] = items[_id].balances[msg.sender].sub(_value);
755             items[_id].balances[_to] = _value.add(items[_id].balances[_to]);
756 
757             Transfer(msg.sender, msg.sender, _to, _id, _value);
758         }
759     }
760 
761     function safeBatchTransfer(address _to, uint256[] _ids, uint256[] _values, bytes _data) external {
762         //this.batchTransfer(_to, _ids, _values);
763 
764         for (uint256 i = 0; i < _ids.length; ++i) {
765             // solium-disable-next-line arg-overflow
766             require(_checkAndCallSafeTransfer(msg.sender, _to, _ids[i], _values[i], _data));
767         }
768 
769         uint256 _id;
770         uint256 _value;
771 
772         for (i = 0; i < _ids.length; ++i) {
773             _id = _ids[i];
774             _value = _values[i];
775 
776             items[_id].balances[msg.sender] = items[_id].balances[msg.sender].sub(_value);
777             items[_id].balances[_to] = _value.add(items[_id].balances[_to]);
778 
779             Transfer(msg.sender, msg.sender, _to, _id, _value);
780         }
781     }
782 
783 //////////////////////////////// IERC1155BatchTransferExtended ////////////////////////////////////
784 
785     // Optional meta data view Functions
786     // consider multi-lingual support for name?
787     function name(uint256 _id) external view returns (string) {
788         return items[_id].name;
789     }
790 
791     function symbol(uint256 _id) external view returns (string) {
792         return symbols[_id];
793     }
794 
795     function decimals(uint256 _id) external view returns (uint8) {
796         return decimals[_id];
797     }
798 
799     function totalSupply(uint256 _id) external view returns (uint256) {
800         return items[_id].totalSupply;
801     }
802 
803     function uri(uint256 _id) external view returns (string) {
804         return metadataURIs[_id];
805     }
806 
807 ////////////////////////////////////////// OPTIONALS //////////////////////////////////////////////
808 
809 
810     function multicastTransfer(address[] _to, uint256[] _ids, uint256[] _values) external {
811         for (uint256 i = 0; i < _to.length; ++i) {
812             uint256 _id = _ids[i];
813             uint256 _value = _values[i];
814             address _dst = _to[i];
815 
816             items[_id].balances[msg.sender] = items[_id].balances[msg.sender].sub(_value);
817             items[_id].balances[_dst] = _value.add(items[_id].balances[_dst]);
818 
819             Transfer(msg.sender, msg.sender, _dst, _id, _value);
820         }
821     }
822 
823     function safeMulticastTransfer(address[] _to, uint256[] _ids, uint256[] _values, bytes _data) external {
824         //this.multicastTransfer(_to, _ids, _values);
825 
826         for (uint256 i = 0; i < _ids.length; ++i) {
827             // solium-disable-next-line arg-overflow
828             require(_checkAndCallSafeTransfer(msg.sender, _to[i], _ids[i], _values[i], _data));
829         }
830 
831         for (i = 0; i < _to.length; ++i) {
832             uint256 _id = _ids[i];
833             uint256 _value = _values[i];
834             address _dst = _to[i];
835 
836             items[_id].balances[msg.sender] = items[_id].balances[msg.sender].sub(_value);
837             items[_id].balances[_dst] = _value.add(items[_id].balances[_dst]);
838 
839             Transfer(msg.sender, msg.sender, _dst, _id, _value);
840         }
841     }
842 
843 ////////////////////////////////////////// INTERNAL //////////////////////////////////////////////
844 
845     function _checkAndCallSafeTransfer(
846         address _from,
847         address _to,
848         uint256 _id,
849         uint256 _value,
850         bytes _data
851     )
852     internal
853     returns (bool)
854     {
855         if (!_to.isContract()) {
856             return true;
857         }
858         bytes4 retval = IERC1155TokenReceiver(_to).onERC1155Received(
859             msg.sender, _from, _id, _value, _data);
860         return (retval == ERC1155_RECEIVED);
861     }
862 }
863 
864 // File: contracts/ERC165.sol
865 
866 /**
867  * @title ERC165
868  * @dev https://github.com/ethereum/EIPs/blob/master/EIPS/eip-165.md
869  */
870 interface ERC165 {
871 
872   /**
873    * @notice Query if a contract implements an interface
874    * @param _interfaceId The interface identifier, as specified in ERC-165
875    * @dev Interface identification is specified in ERC-165. This function
876    * uses less than 30,000 gas.
877    */
878   function supportsInterface(bytes4 _interfaceId)
879     external
880     view
881     returns (bool);
882 }
883 
884 // File: contracts/ERC721Basic.sol
885 
886 /**
887  * @title ERC721 Non-Fungible Token Standard basic interface
888  * @dev see https://github.com/ethereum/EIPs/blob/master/EIPS/eip-721.md
889  */
890 contract ERC721Basic is ERC165 {
891 
892     bytes4 internal constant InterfaceId_ERC721 = 0x80ac58cd;
893     /*
894     * 0x80ac58cd ===
895     *   bytes4(keccak256('balanceOf(address)')) ^
896     *   bytes4(keccak256('ownerOf(uint256)')) ^
897     *   bytes4(keccak256('approve(address,uint256)')) ^
898     *   bytes4(keccak256('getApproved(uint256)')) ^
899     *   bytes4(keccak256('setApprovalForAll(address,bool)')) ^
900     *   bytes4(keccak256('isApprovedForAll(address,address)')) ^
901     *   bytes4(keccak256('transferFrom(address,address,uint256)')) ^
902     *   bytes4(keccak256('safeTransferFrom(address,address,uint256)')) ^
903     *   bytes4(keccak256('safeTransferFrom(address,address,uint256,bytes)'))
904     */
905 
906     bytes4 internal constant InterfaceId_ERC721Exists = 0x4f558e79;
907     /*
908     * 0x4f558e79 ===
909     *   bytes4(keccak256('exists(uint256)'))
910     */
911 
912     bytes4 internal constant InterfaceId_ERC721Enumerable = 0x780e9d63;
913     /**
914     * 0x780e9d63 ===
915     *   bytes4(keccak256('totalSupply()')) ^
916     *   bytes4(keccak256('tokenOfOwnerByIndex(address,uint256)')) ^
917     *   bytes4(keccak256('tokenByIndex(uint256)'))
918     */
919 
920     bytes4 internal constant InterfaceId_ERC721Metadata = 0x5b5e139f;
921     /**
922     * 0x5b5e139f ===
923     *   bytes4(keccak256('name()')) ^
924     *   bytes4(keccak256('symbol()')) ^
925     *   bytes4(keccak256('tokenURI(uint256)'))
926     */
927 
928     event Transfer(
929       address indexed _from,
930       address indexed _to,
931       uint256 indexed _tokenId
932     );
933     event Approval(
934       address indexed _owner,
935       address indexed _approved,
936       uint256 indexed _tokenId
937     );
938     event ApprovalForAll(
939       address indexed _owner,
940       address indexed _operator,
941       bool _approved
942     );
943 
944     function balanceOf(address _owner) public view returns (uint256 _balance);
945     function ownerOf(uint256 _tokenId) public view returns (address _owner);
946     function exists(uint256 _tokenId) public view returns (bool _exists);
947 
948     function approve(address _to, uint256 _tokenId) public;
949     function getApproved(uint256 _tokenId) public view returns (address _operator);
950 
951     function setApprovalForAll(address _operator, bool _approved) public;
952     function isApprovedForAll(address _owner, address _operator) public view returns (bool);
953 
954     function transferFrom(address _from, address _to, uint256 _tokenId) public;
955     function safeTransferFrom(address _from, address _to, uint256 _tokenId) public;
956 
957     function safeTransferFrom(address _from, address _to, uint256 _tokenId, bytes _data) public;
958 }
959 
960 // File: contracts/DepositContract.sol
961 
962 /// @title DepositContract contract
963 contract DepositContract is withAccessManager {
964 
965     bytes32 public clientId; // client ID.
966     uint256 public version = 2;
967 
968     // EVENTS
969     event EtherTransfer(address to, uint256 value);
970 
971     // NON-CONSTANT METHODS 
972 
973     /** @dev Constructor that sets the _clientID when the contract is deployed.
974       * @dev The method also sets the manager to the msg.sender.
975       * @param _clientId A string of fixed length representing the client ID.
976       */
977     function DepositContract(bytes32 _clientId, address accessManager) public withAccessManager(accessManager) {
978         clientId = _clientId;
979     }
980      
981     /** @dev Transfers an amount '_value' of tokens from msg.sender to '_to' address/wallet.
982       * @param populousTokenContract The address of the ERC20 token contract which implements the transfer method.
983       * @param _value the amount of tokens to transfer.
984       * @param _to The address/wallet to send to.
985       * @return success boolean true or false indicating whether the transfer was successful or not.
986       */
987     function transfer(address populousTokenContract, address _to, uint256 _value) public
988         onlyServerOrOnlyPopulous returns (bool success) 
989     {
990         return iERC20Token(populousTokenContract).transfer(_to, _value);
991     }
992 
993     /** @dev This function will transfer iERC1155 tokens
994      */
995     function transferERC1155(address _erc1155Token, address _to, uint256 _id, uint256 _value) 
996         public onlyServerOrOnlyPopulous returns (bool success) {
997         ERC1155(_erc1155Token).safeTransfer(_to, _id, _value, "");
998         return true;
999     }
1000 
1001     /**
1002     * @notice Handle the receipt of an NFT
1003     * @dev The ERC721 smart contract calls this function on the recipient
1004     * after a `safetransfer` if the recipient is a smart contract. This function MAY throw to revert and reject the
1005     * transfer. Return of other than the magic value (0x150b7a02) MUST result in the
1006     * transaction being reverted.
1007     * Note: the contract address is always the message sender.
1008     * @param _operator The address which called `safeTransferFrom` function
1009     * @param _from The address which previously owned the token
1010     * @param _tokenId The NFT identifier which is being transferred
1011     * @param _data Additional data with no specified format
1012     * @return `bytes4(keccak256("onERC721Received(address,address,uint256,bytes)"))`
1013     */
1014     function onERC721Received(address _operator, address _from, uint256 _tokenId, bytes _data) public returns(bytes4) {
1015         return 0x150b7a02; 
1016     }
1017 
1018     /// @notice Handle the receipt of an ERC1155 type
1019     /// @dev The smart contract calls this function on the recipient
1020     ///  after a `safeTransfer`. This function MAY throw to revert and reject the
1021     ///  transfer. Return of other than the magic value MUST result in the
1022     ///  transaction being reverted.
1023     ///  Note: the contract address is always the message sender.
1024     /// @param _operator The address which called `safeTransferFrom` function
1025     /// @param _from The address which previously owned the token
1026     /// @param _id The identifier of the item being transferred
1027     /// @param _value The amount of the item being transferred
1028     /// @param _data Additional data with no specified format
1029     /// @return `bytes4(keccak256("onERC1155Received(address,address,uint256,uint256,bytes)"))`
1030     ///  unless throwing
1031     function onERC1155Received(address _operator, address _from, uint256 _id, uint256 _value, bytes _data) public returns(bytes4) {
1032         return 0xf23a6e61;
1033     }
1034 
1035     /**
1036     * @dev Safely transfers the ownership of a given token ID to another address
1037     * If the target address is a contract, it must implement `onERC721Received`,
1038     * which is called upon a safe transfer, and return the magic value
1039     * `bytes4(keccak256("onERC721Received(address,address,uint256,bytes)"))`; otherwise,
1040     * the transfer is reverted.
1041     *
1042     * Requires the msg sender to be the owner, approved, or operator
1043     * @param erc721Token address of the erc721 token to target
1044     * @param _to address to receive the ownership of the given token ID
1045     * @param _tokenId uint256 ID of the token to be transferred
1046     */
1047     function transferERC721(
1048         address erc721Token,
1049         address _to,
1050         uint256 _tokenId
1051     )
1052         public onlyServerOrOnlyPopulous returns (bool success)
1053     {
1054         // solium-disable-next-line arg-overflow
1055         ERC721Basic(erc721Token).safeTransferFrom(this, _to, _tokenId, "");
1056         return true;
1057     }
1058 
1059     /** @dev Transfers ether from this contract to a specified wallet/address
1060       * @param _to An address implementing to send ether to.
1061       * @param _value The amount of ether to send in wei. 
1062       * @return bool Successful or unsuccessful transfer
1063       */
1064     function transferEther(address _to, uint256 _value) public 
1065         onlyServerOrOnlyPopulous returns (bool success) 
1066     {
1067         require(this.balance >= _value);
1068         require(_to.send(_value) == true);
1069         EtherTransfer(_to, _value);
1070         return true;
1071     }
1072 
1073     // payable function to allow this contract receive ether - for version 3
1074     //function () public payable {}
1075 
1076     // CONSTANT METHODS
1077     
1078     /** @dev Returns the ether or token balance of the current contract instance using the ERC20 balanceOf method.
1079       * @param populousTokenContract An address implementing the ERC20 token standard. 
1080       * @return uint An unsigned integer representing the returned token balance.
1081       */
1082     function balanceOf(address populousTokenContract) public view returns (uint256) {
1083         // ether
1084         if (populousTokenContract == address(0)) {
1085             return address(this).balance;
1086         } else {
1087             // erc20
1088             return iERC20Token(populousTokenContract).balanceOf(this);
1089         }
1090     }
1091 
1092     /**
1093     * @dev Gets the balance of the specified address
1094     * @param erc721Token address to erc721 token to target
1095     * @return uint256 representing the amount owned by the passed address
1096     */
1097     function balanceOfERC721(address erc721Token) public view returns (uint256) {
1098         return ERC721Basic(erc721Token).balanceOf(this);
1099         // returns ownedTokensCount[_owner];
1100     }
1101 
1102     /**
1103     * @dev Gets the balance of the specified address
1104     * @param _id the token id
1105     * @param erc1155Token address to erc1155 token to target
1106     * @return uint256 representing the amount owned by the passed address
1107     */
1108     function balanceOfERC1155(address erc1155Token, uint256 _id) external view returns (uint256) {
1109         return ERC1155(erc1155Token).balanceOf(_id, this);
1110     }
1111 
1112     /** @dev Gets the version of this deposit contract
1113       * @return uint256 version
1114       */
1115     function getVersion() public view returns (uint256) {
1116         return version;
1117     }
1118 
1119     // CONSTANT FUNCTIONS
1120 
1121     /** @dev This function gets the client ID or deposit contract owner
1122      * returns _clientId
1123      */
1124     function getClientId() public view returns (bytes32 _clientId) {
1125         return clientId;
1126     }
1127 }
1128 
1129 // File: contracts/SafeMath.sol
1130 
1131 /// @title Overflow aware uint math functions.
1132 /// @notice Inspired by https://github.com/MakerDAO/maker-otc/blob/master/contracts/simple_market.sol
1133 library SafeMath {
1134 
1135   /** @dev Safely multiplies two unsigned/non-negative integers.
1136     * @dev Ensures that one of both numbers can be derived from dividing the product by the other.
1137     * @param a The first number.
1138     * @param b The second number.
1139     * @return uint The expected result.
1140     */
1141     function safeMul(uint a, uint b) internal pure returns (uint) {
1142         uint c = a * b;
1143         assert(a == 0 || c / a == b);
1144         return c;
1145     }
1146 
1147   /** @dev Safely subtracts one number from another
1148     * @dev Ensures that the number to subtract is lower.
1149     * @param a The first number.
1150     * @param b The second number.
1151     * @return uint The expected result.
1152     */
1153     function safeSub(uint a, uint b) internal pure returns (uint) {
1154         assert(b <= a);
1155         return a - b;
1156     }
1157 
1158   /** @dev Safely adds two unsigned/non-negative integers.
1159     * @dev Ensures that the sum of both numbers is greater or equal to one of both.
1160     * @param a The first number.
1161     * @param b The second number.
1162     * @return uint The expected result.
1163     */
1164     function safeAdd(uint a, uint b) internal pure returns (uint) {
1165         uint c = a + b;
1166         assert(c>=a && c>=b);
1167         return c;
1168     }
1169 
1170     function div(uint256 a, uint256 b) internal pure returns (uint256) {
1171         assert(b > 0); // Solidity automatically throws when dividing by 0
1172         uint256 c = a / b;
1173         assert(a == b * c + a % b); // There is no case in which this doesn't hold
1174         return c;
1175     }
1176 }
1177 
1178 // File: contracts/iDataManager.sol
1179 
1180 /// @title DataManager contract
1181 contract iDataManager {
1182     // FIELDS
1183     uint256 public version;
1184     // currency symbol => currency erc20 contract address
1185     mapping(bytes32 => address) public currencyAddresses;
1186     // currency address => currency symbol
1187     mapping(address => bytes32) public currencySymbols;
1188     // clientId => depositAddress
1189     mapping(bytes32 => address) public depositAddresses;
1190     // depositAddress => clientId
1191     mapping(address => bytes32) public depositClientIds;
1192     // blockchainActionId => boolean 
1193     mapping(bytes32 => bool) public actionStatus;
1194     // blockchainActionData
1195     struct actionData {
1196         bytes32 currency;
1197         uint amount;
1198         bytes32 accountId;
1199         address to;
1200         uint pptFee;
1201     }
1202     // blockchainActionId => actionData
1203     mapping(bytes32 => actionData) public blockchainActionIdData;
1204     
1205     //actionId => invoiceId
1206     mapping(bytes32 => bytes32) public actionIdToInvoiceId;
1207     // invoice provider company data
1208     struct providerCompany {
1209         //bool isEnabled;
1210         bytes32 companyNumber;
1211         bytes32 companyName;
1212         bytes2 countryCode;
1213     }
1214     // companyCode => companyNumber => providerId
1215     mapping(bytes2 => mapping(bytes32 => bytes32)) public providerData;
1216     // providedId => providerCompany
1217     mapping(bytes32 => providerCompany) public providerCompanyData;
1218     // crowdsale invoiceDetails
1219     struct _invoiceDetails {
1220         bytes2 invoiceCountryCode;
1221         bytes32 invoiceCompanyNumber;
1222         bytes32 invoiceCompanyName;
1223         bytes32 invoiceNumber;
1224     }
1225     // crowdsale invoiceData
1226     struct invoiceData {
1227         bytes32 providerUserId;
1228         bytes32 invoiceCompanyName;
1229     }
1230 
1231     // country code => company number => invoice number => invoice data
1232     mapping(bytes2 => mapping(bytes32 => mapping(bytes32 => invoiceData))) public invoices;
1233     
1234     
1235     
1236     
1237     // NON-CONSTANT METHODS
1238 
1239     /** @dev Adds a new deposit smart contract address linked to a client id
1240       * @param _depositAddress the deposit smart contract address
1241       * @param _clientId the client id
1242       * @return success true/false denoting successful function call
1243       */
1244     function setDepositAddress(bytes32 _blockchainActionId, address _depositAddress, bytes32 _clientId) public returns (bool success);
1245 
1246     /** @dev Adds a new currency sumbol and smart contract address  
1247       * @param _currencyAddress the currency smart contract address
1248       * @param _currencySymbol the currency symbol
1249       * @return success true/false denoting successful function call
1250       */
1251     function setCurrency(bytes32 _blockchainActionId, address _currencyAddress, bytes32 _currencySymbol) public returns (bool success);
1252 
1253     /** @dev Updates a currency sumbol and smart contract address  
1254       * @param _currencyAddress the currency smart contract address
1255       * @param _currencySymbol the currency symbol
1256       * @return success true/false denoting successful function call
1257       */
1258     function _setCurrency(bytes32 _blockchainActionId, address _currencyAddress, bytes32 _currencySymbol) public returns (bool success);
1259 
1260 
1261     /** @dev set blockchain action data in struct 
1262       * @param _blockchainActionId the blockchain action id
1263       * @param currency the token currency symbol
1264       * @param accountId the clientId
1265       * @param to the blockchain address or smart contract address used in the transaction
1266       * @param amount the amount of tokens in the transaction
1267       * @return success true/false denoting successful function call
1268       */
1269     function setBlockchainActionData(
1270         bytes32 _blockchainActionId, bytes32 currency, 
1271         uint amount, bytes32 accountId, address to, uint pptFee) 
1272         public 
1273         returns (bool success);
1274 
1275     /** @dev upgrade deposit address 
1276       * @param _blockchainActionId the blockchain action id
1277       * @param _clientId the client id
1278       * @param _depositContract the deposit contract address for the client
1279       * @return success true/false denoting successful function call
1280       */
1281     function upgradeDepositAddress(bytes32 _blockchainActionId, bytes32 _clientId, address _depositContract) public returns (bool success);
1282   
1283 
1284     /** @dev Updates a deposit address for client id
1285       * @param _blockchainActionId the blockchain action id
1286       * @param _clientId the client id
1287       * @param _depositContract the deposit contract address for the client
1288       * @return success true/false denoting successful function call
1289       */
1290     function _setDepositAddress(bytes32 _blockchainActionId, bytes32 _clientId, address _depositContract) public returns (bool success);
1291 
1292     /** @dev Add a new invoice to the platform  
1293       * @param _providerUserId the providers user id
1294       * @param _invoiceCountryCode the country code of the provider
1295       * @param _invoiceCompanyNumber the providers company number
1296       * @param _invoiceCompanyName the providers company name
1297       * @param _invoiceNumber the invoice number
1298       * @return success true or false if function call is successful
1299       */
1300     function setInvoice(
1301         bytes32 _blockchainActionId, bytes32 _providerUserId, bytes2 _invoiceCountryCode, 
1302         bytes32 _invoiceCompanyNumber, bytes32 _invoiceCompanyName, bytes32 _invoiceNumber) 
1303         public returns (bool success);
1304 
1305     
1306     /** @dev Add a new invoice provider to the platform  
1307       * @param _blockchainActionId the blockchain action id
1308       * @param _userId the user id of the provider
1309       * @param _companyNumber the providers company number
1310       * @param _companyName the providers company name
1311       * @param _countryCode the providers country code
1312       * @return success true or false if function call is successful
1313       */
1314     function setProvider(
1315         bytes32 _blockchainActionId, bytes32 _userId, bytes32 _companyNumber, 
1316         bytes32 _companyName, bytes2 _countryCode) 
1317         public returns (bool success);
1318 
1319     /** @dev Update an added invoice provider to the platform  
1320       * @param _blockchainActionId the blockchain action id
1321       * @param _userId the user id of the provider
1322       * @param _companyNumber the providers company number
1323       * @param _companyName the providers company name
1324       * @param _countryCode the providers country code
1325       * @return success true or false if function call is successful
1326       */
1327     function _setProvider(
1328         bytes32 _blockchainActionId, bytes32 _userId, bytes32 _companyNumber, 
1329         bytes32 _companyName, bytes2 _countryCode) 
1330         public returns (bool success);
1331     
1332     // CONSTANT METHODS
1333 
1334     /** @dev Gets a deposit address with the client id 
1335       * @return clientDepositAddress The client's deposit address
1336       */
1337     function getDepositAddress(bytes32 _clientId) public view returns (address clientDepositAddress);
1338 
1339 
1340     /** @dev Gets a client id linked to a deposit address 
1341       * @return depositClientId The client id
1342       */
1343     function getClientIdWithDepositAddress(address _depositContract) public view returns (bytes32 depositClientId);
1344 
1345 
1346     /** @dev Gets a currency smart contract address 
1347       * @return currencyAddress The currency address
1348       */
1349     function getCurrency(bytes32 _currencySymbol) public view returns (address currencyAddress);
1350 
1351    
1352     /** @dev Gets a currency symbol given it's smart contract address 
1353       * @return currencySymbol The currency symbol
1354       */
1355     function getCurrencySymbol(address _currencyAddress) public view returns (bytes32 currencySymbol);
1356 
1357     /** @dev Gets details of a currency given it's smart contract address 
1358       * @return _symbol The currency symbol
1359       * @return _name The currency name
1360       * @return _decimals The currency decimal places/precision
1361       */
1362     function getCurrencyDetails(address _currencyAddress) public view returns (bytes32 _symbol, bytes32 _name, uint8 _decimals);
1363 
1364     /** @dev Get the blockchain action Id Data for a blockchain Action id
1365       * @param _blockchainActionId the blockchain action id
1366       * @return bytes32 currency
1367       * @return uint amount
1368       * @return bytes32 accountId
1369       * @return address to
1370       */
1371     function getBlockchainActionIdData(bytes32 _blockchainActionId) public view returns (bytes32 _currency, uint _amount, bytes32 _accountId, address _to);
1372 
1373 
1374     /** @dev Get the bool status of a blockchain Action id
1375       * @param _blockchainActionId the blockchain action id
1376       * @return bool actionStatus
1377       */
1378     function getActionStatus(bytes32 _blockchainActionId) public view returns (bool _blockchainActionStatus);
1379 
1380 
1381     /** @dev Gets the details of an invoice with the country code, company number and invocie number.
1382       * @param _invoiceCountryCode The country code.
1383       * @param _invoiceCompanyNumber The company number.
1384       * @param _invoiceNumber The invoice number
1385       * @return providerUserId The invoice provider user Id
1386       * @return invoiceCompanyName the invoice company name
1387       */
1388     function getInvoice(bytes2 _invoiceCountryCode, bytes32 _invoiceCompanyNumber, bytes32 _invoiceNumber) 
1389         public 
1390         view 
1391         returns (bytes32 providerUserId, bytes32 invoiceCompanyName);
1392 
1393 
1394     /** @dev Gets the details of an invoice provider with the country code and company number.
1395       * @param _providerCountryCode The country code.
1396       * @param _providerCompanyNumber The company number.
1397       * @return isEnabled The boolean value true/false indicating whether invoice provider is enabled or not
1398       * @return providerId The invoice provider user Id
1399       * @return companyName the invoice company name
1400       */
1401     function getProviderByCountryCodeCompanyNumber(bytes2 _providerCountryCode, bytes32 _providerCompanyNumber) 
1402         public 
1403         view 
1404         returns (bytes32 providerId, bytes32 companyName);
1405 
1406 
1407     /** @dev Gets the details of an invoice provider with the providers user Id.
1408       * @param _providerUserId The provider user Id.
1409       * @return countryCode The invoice provider country code
1410       * @return companyName the invoice company name
1411       */
1412     function getProviderByUserId(bytes32 _providerUserId) public view 
1413         returns (bytes2 countryCode, bytes32 companyName, bytes32 companyNumber);
1414 
1415 
1416     /** @dev Gets the version number for the current contract instance
1417       * @return _version The version number
1418       */
1419     function getVersion() public view returns (uint256 _version);
1420 
1421 }
1422 
1423 // File: contracts/DataManager.sol
1424 
1425 /// @title DataManager contract
1426 contract DataManager is iDataManager, withAccessManager {
1427     
1428 
1429     // NON-CONSTANT METHODS
1430 
1431     /** @dev Constructor that sets the server when contract is deployed.
1432       * @param _accessManager The address to set as the access manager.
1433       */
1434     function DataManager(address _accessManager, uint256 _version) public withAccessManager(_accessManager) {
1435         version = _version;
1436     }
1437 
1438     /** @dev Adds a new deposit smart contract address linked to a client id
1439       * @param _depositAddress the deposit smart contract address
1440       * @param _clientId the client id
1441       * @return success true/false denoting successful function call
1442       */
1443     function setDepositAddress(bytes32 _blockchainActionId, address _depositAddress, bytes32 _clientId) public onlyServerOrOnlyPopulous returns (bool success) {
1444         require(actionStatus[_blockchainActionId] == false);
1445         require(depositAddresses[_clientId] == 0x0 && depositClientIds[_depositAddress] == 0x0);
1446         depositAddresses[_clientId] = _depositAddress;
1447         depositClientIds[_depositAddress] = _clientId;
1448         assert(depositAddresses[_clientId] != 0x0 && depositClientIds[_depositAddress] != 0x0);
1449         return true;
1450     }
1451 
1452     /** @dev Adds a new currency sumbol and smart contract address  
1453       * @param _currencyAddress the currency smart contract address
1454       * @param _currencySymbol the currency symbol
1455       * @return success true/false denoting successful function call
1456       */
1457     function setCurrency(bytes32 _blockchainActionId, address _currencyAddress, bytes32 _currencySymbol) public onlyServerOrOnlyPopulous returns (bool success) {
1458         require(actionStatus[_blockchainActionId] == false);
1459         require(currencySymbols[_currencyAddress] == 0x0 && currencyAddresses[_currencySymbol] == 0x0);
1460         currencySymbols[_currencyAddress] = _currencySymbol;
1461         currencyAddresses[_currencySymbol] = _currencyAddress;
1462         assert(currencyAddresses[_currencySymbol] != 0x0 && currencySymbols[_currencyAddress] != 0x0);
1463         return true;
1464     }
1465 
1466     /** @dev Updates a currency sumbol and smart contract address  
1467       * @param _currencyAddress the currency smart contract address
1468       * @param _currencySymbol the currency symbol
1469       * @return success true/false denoting successful function call
1470       */
1471     function _setCurrency(bytes32 _blockchainActionId, address _currencyAddress, bytes32 _currencySymbol) public onlyServerOrOnlyPopulous returns (bool success) {
1472         require(actionStatus[_blockchainActionId] == false);
1473         currencySymbols[_currencyAddress] = _currencySymbol;
1474         currencyAddresses[_currencySymbol] = _currencyAddress;
1475         assert(currencyAddresses[_currencySymbol] != 0x0 && currencySymbols[_currencyAddress] != 0x0);
1476         setBlockchainActionData(_blockchainActionId, _currencySymbol, 0, 0x0, _currencyAddress, 0);
1477         return true;
1478     }
1479 
1480     /** @dev set blockchain action data in struct 
1481       * @param _blockchainActionId the blockchain action id
1482       * @param currency the token currency symbol
1483       * @param accountId the clientId
1484       * @param to the blockchain address or smart contract address used in the transaction
1485       * @param amount the amount of tokens in the transaction
1486       * @return success true/false denoting successful function call
1487       */
1488     function setBlockchainActionData(
1489         bytes32 _blockchainActionId, bytes32 currency, 
1490         uint amount, bytes32 accountId, address to, uint pptFee) 
1491         public
1492         onlyServerOrOnlyPopulous 
1493         returns (bool success)
1494     {
1495         require(actionStatus[_blockchainActionId] == false);
1496         blockchainActionIdData[_blockchainActionId].currency = currency;
1497         blockchainActionIdData[_blockchainActionId].amount = amount;
1498         blockchainActionIdData[_blockchainActionId].accountId = accountId;
1499         blockchainActionIdData[_blockchainActionId].to = to;
1500         blockchainActionIdData[_blockchainActionId].pptFee = pptFee;
1501         actionStatus[_blockchainActionId] = true;
1502         return true;
1503     }
1504     
1505     /** @dev Updates a deposit address for client id
1506       * @param _blockchainActionId the blockchain action id
1507       * @param _clientId the client id
1508       * @param _depositContract the deposit contract address for the client
1509       * @return success true/false denoting successful function call
1510       */
1511     function _setDepositAddress(bytes32 _blockchainActionId, bytes32 _clientId, address _depositContract) public
1512       onlyServerOrOnlyPopulous
1513       returns (bool success)
1514     {
1515         require(actionStatus[_blockchainActionId] == false);
1516         depositAddresses[_clientId] = _depositContract;
1517         depositClientIds[_depositContract] = _clientId;
1518         // check that deposit address has been stored for client Id
1519         assert(depositAddresses[_clientId] == _depositContract && depositClientIds[_depositContract] == _clientId);
1520         // set blockchain action data
1521         setBlockchainActionData(_blockchainActionId, 0x0, 0, _clientId, depositAddresses[_clientId], 0);
1522         return true;
1523     }
1524 
1525     /** @dev Add a new invoice to the platform  
1526       * @param _providerUserId the providers user id
1527       * @param _invoiceCountryCode the country code of the provider
1528       * @param _invoiceCompanyNumber the providers company number
1529       * @param _invoiceCompanyName the providers company name
1530       * @param _invoiceNumber the invoice number
1531       * @return success true or false if function call is successful
1532       */
1533     function setInvoice(
1534         bytes32 _blockchainActionId, bytes32 _providerUserId, bytes2 _invoiceCountryCode, 
1535         bytes32 _invoiceCompanyNumber, bytes32 _invoiceCompanyName, bytes32 _invoiceNumber) 
1536         public 
1537         onlyServerOrOnlyPopulous 
1538         returns (bool success) 
1539     {   
1540         require(actionStatus[_blockchainActionId] == false);
1541         bytes32 providerUserId; 
1542         bytes32 companyName;
1543         (providerUserId, companyName) = getInvoice(_invoiceCountryCode, _invoiceCompanyNumber, _invoiceNumber);
1544         require(providerUserId == 0x0 && companyName == 0x0);
1545         // country code => company number => invoice number => invoice data
1546         invoices[_invoiceCountryCode][_invoiceCompanyNumber][_invoiceNumber].providerUserId = _providerUserId;
1547         invoices[_invoiceCountryCode][_invoiceCompanyNumber][_invoiceNumber].invoiceCompanyName = _invoiceCompanyName;
1548         
1549         assert(
1550             invoices[_invoiceCountryCode][_invoiceCompanyNumber][_invoiceNumber].providerUserId != 0x0 && 
1551             invoices[_invoiceCountryCode][_invoiceCompanyNumber][_invoiceNumber].invoiceCompanyName != 0x0
1552         );
1553         return true;
1554     }
1555     
1556     /** @dev Add a new invoice provider to the platform  
1557       * @param _blockchainActionId the blockchain action id
1558       * @param _userId the user id of the provider
1559       * @param _companyNumber the providers company number
1560       * @param _companyName the providers company name
1561       * @param _countryCode the providers country code
1562       * @return success true or false if function call is successful
1563       */
1564     function setProvider(
1565         bytes32 _blockchainActionId, bytes32 _userId, bytes32 _companyNumber, 
1566         bytes32 _companyName, bytes2 _countryCode) 
1567         public 
1568         onlyServerOrOnlyPopulous
1569         returns (bool success)
1570     {   
1571         require(actionStatus[_blockchainActionId] == false);
1572         require(
1573             providerCompanyData[_userId].companyNumber == 0x0 && 
1574             providerCompanyData[_userId].countryCode == 0x0 &&
1575             providerCompanyData[_userId].companyName == 0x0);
1576         
1577         providerCompanyData[_userId].countryCode = _countryCode;
1578         providerCompanyData[_userId].companyName = _companyName;
1579         providerCompanyData[_userId].companyNumber = _companyNumber;
1580 
1581         providerData[_countryCode][_companyNumber] = _userId;
1582         return true;
1583     }
1584 
1585 
1586     /** @dev Update an added invoice provider to the platform  
1587       * @param _blockchainActionId the blockchain action id
1588       * @param _userId the user id of the provider
1589       * @param _companyNumber the providers company number
1590       * @param _companyName the providers company name
1591       * @param _countryCode the providers country code
1592       * @return success true or false if function call is successful
1593       */
1594     function _setProvider(
1595         bytes32 _blockchainActionId, bytes32 _userId, bytes32 _companyNumber, 
1596         bytes32 _companyName, bytes2 _countryCode) 
1597         public 
1598         onlyServerOrOnlyPopulous
1599         returns (bool success)
1600     {   
1601         require(actionStatus[_blockchainActionId] == false);
1602         providerCompanyData[_userId].countryCode = _countryCode;
1603         providerCompanyData[_userId].companyName = _companyName;
1604         providerCompanyData[_userId].companyNumber = _companyNumber;
1605         providerData[_countryCode][_companyNumber] = _userId;
1606         
1607         setBlockchainActionData(_blockchainActionId, 0x0, 0, _userId, 0x0, 0);
1608         return true;
1609     }
1610 
1611     // CONSTANT METHODS
1612 
1613     /** @dev Gets a deposit address with the client id 
1614       * @return clientDepositAddress The client's deposit address
1615       */
1616     function getDepositAddress(bytes32 _clientId) public view returns (address clientDepositAddress){
1617         return depositAddresses[_clientId];
1618     }
1619 
1620     /** @dev Gets a client id linked to a deposit address 
1621       * @return depositClientId The client id
1622       */
1623     function getClientIdWithDepositAddress(address _depositContract) public view returns (bytes32 depositClientId){
1624         return depositClientIds[_depositContract];
1625     }
1626 
1627     /** @dev Gets a currency smart contract address 
1628       * @return currencyAddress The currency address
1629       */
1630     function getCurrency(bytes32 _currencySymbol) public view returns (address currencyAddress) {
1631         return currencyAddresses[_currencySymbol];
1632     }
1633    
1634     /** @dev Gets a currency symbol given it's smart contract address 
1635       * @return currencySymbol The currency symbol
1636       */
1637     function getCurrencySymbol(address _currencyAddress) public view returns (bytes32 currencySymbol) {
1638         return currencySymbols[_currencyAddress];
1639     }
1640 
1641     /** @dev Gets details of a currency given it's smart contract address 
1642       * @return _symbol The currency symbol
1643       * @return _name The currency name
1644       * @return _decimals The currency decimal places/precision
1645       */
1646     function getCurrencyDetails(address _currencyAddress) public view returns (bytes32 _symbol, bytes32 _name, uint8 _decimals) {
1647         return (CurrencyToken(_currencyAddress).symbol(), CurrencyToken(_currencyAddress).name(), CurrencyToken(_currencyAddress).decimals());
1648     } 
1649 
1650     /** @dev Get the blockchain action Id Data for a blockchain Action id
1651       * @param _blockchainActionId the blockchain action id
1652       * @return bytes32 currency
1653       * @return uint amount
1654       * @return bytes32 accountId
1655       * @return address to
1656       */
1657     function getBlockchainActionIdData(bytes32 _blockchainActionId) public view 
1658     returns (bytes32 _currency, uint _amount, bytes32 _accountId, address _to) 
1659     {
1660         require(actionStatus[_blockchainActionId] == true);
1661         return (blockchainActionIdData[_blockchainActionId].currency, 
1662         blockchainActionIdData[_blockchainActionId].amount,
1663         blockchainActionIdData[_blockchainActionId].accountId,
1664         blockchainActionIdData[_blockchainActionId].to);
1665     }
1666 
1667     /** @dev Get the bool status of a blockchain Action id
1668       * @param _blockchainActionId the blockchain action id
1669       * @return bool actionStatus
1670       */
1671     function getActionStatus(bytes32 _blockchainActionId) public view returns (bool _blockchainActionStatus) {
1672         return actionStatus[_blockchainActionId];
1673     }
1674 
1675     /** @dev Gets the details of an invoice with the country code, company number and invocie number.
1676       * @param _invoiceCountryCode The country code.
1677       * @param _invoiceCompanyNumber The company number.
1678       * @param _invoiceNumber The invoice number
1679       * @return providerUserId The invoice provider user Id
1680       * @return invoiceCompanyName the invoice company name
1681       */
1682     function getInvoice(bytes2 _invoiceCountryCode, bytes32 _invoiceCompanyNumber, bytes32 _invoiceNumber) 
1683         public 
1684         view 
1685         returns (bytes32 providerUserId, bytes32 invoiceCompanyName) 
1686     {   
1687         bytes32 _providerUserId = invoices[_invoiceCountryCode][_invoiceCompanyNumber][_invoiceNumber].providerUserId;
1688         bytes32 _invoiceCompanyName = invoices[_invoiceCountryCode][_invoiceCompanyNumber][_invoiceNumber].invoiceCompanyName;
1689         return (_providerUserId, _invoiceCompanyName);
1690     }
1691 
1692     /** @dev Gets the details of an invoice provider with the country code and company number.
1693       * @param _providerCountryCode The country code.
1694       * @param _providerCompanyNumber The company number.
1695       * @return isEnabled The boolean value true/false indicating whether invoice provider is enabled or not
1696       * @return providerId The invoice provider user Id
1697       * @return companyName the invoice company name
1698       */
1699     function getProviderByCountryCodeCompanyNumber(bytes2 _providerCountryCode, bytes32 _providerCompanyNumber) 
1700         public 
1701         view 
1702         returns (bytes32 providerId, bytes32 companyName) 
1703     {
1704         bytes32 providerUserId = providerData[_providerCountryCode][_providerCompanyNumber];
1705         return (providerUserId, 
1706         providerCompanyData[providerUserId].companyName);
1707     }
1708 
1709     /** @dev Gets the details of an invoice provider with the providers user Id.
1710       * @param _providerUserId The provider user Id.
1711       * @return countryCode The invoice provider country code
1712       * @return companyName the invoice company name
1713       */
1714     function getProviderByUserId(bytes32 _providerUserId) public view 
1715         returns (bytes2 countryCode, bytes32 companyName, bytes32 companyNumber) 
1716     {
1717         return (providerCompanyData[_providerUserId].countryCode,
1718         providerCompanyData[_providerUserId].companyName,
1719         providerCompanyData[_providerUserId].companyNumber);
1720     }
1721 
1722     /** @dev Gets the version number for the current contract instance
1723       * @return _version The version number
1724       */
1725     function getVersion() public view returns (uint256 _version) {
1726         return version;
1727     }
1728 
1729 }
1730 
1731 // File: contracts/Populous.sol
1732 
1733 /**
1734 This is the core module of the system. Currently it holds the code of
1735 the Bank and crowdsale modules to avoid external calls and higher gas costs.
1736 It might be a good idea in the future to split the code, separate Bank
1737 and crowdsale modules into external files and have the core interact with them
1738 with addresses and interfaces. 
1739 */
1740 
1741 
1742 
1743 
1744 
1745 
1746 
1747 
1748 /// @title Populous contract
1749 contract Populous is withAccessManager {
1750     // EVENTS
1751     // Bank events
1752     event EventUSDCToUSDp(bytes32 _blockchainActionId, bytes32 _clientId, uint amount);
1753     event EventUSDpToUSDC(bytes32 _blockchainActionId, bytes32 _clientId, uint amount);
1754     event EventDepositAddressUpgrade(bytes32 blockchainActionId, address oldDepositContract, address newDepositContract, bytes32 clientId, uint256 version);
1755     event EventWithdrawPPT(bytes32 blockchainActionId, bytes32 accountId, address depositContract, address to, uint amount);
1756     event EventWithdrawPoken(bytes32 _blockchainActionId, bytes32 accountId, bytes32 currency, uint amount);
1757     event EventNewDepositContract(bytes32 blockchainActionId, bytes32 clientId, address depositContractAddress, uint256 version);
1758     event EventWithdrawXAUp(bytes32 _blockchainActionId, address erc1155Token, uint amount, uint token_id, bytes32 accountId, uint pptFee);
1759 
1760     // FIELDS
1761     struct tokens {   
1762         address _token;
1763         uint256 _precision;
1764     }
1765     mapping(bytes8 => tokens) public tokenDetails;
1766 
1767     // NON-CONSTANT METHODS
1768     // Constructor method called when contract instance is 
1769     // deployed with 'withAccessManager' modifier.
1770     function Populous(address _accessManager) public withAccessManager(_accessManager) {
1771         /*ropsten
1772         
1773         //pxt
1774         tokenDetails[0x505854]._token = 0xD8A7C588f8DC19f49dAFd8ecf08eec58e64d4cC9;
1775         tokenDetails[0x505854]._precision = 8;
1776         //usdc
1777         tokenDetails[0x55534443]._token = 0xF930f2C7Bc02F89D05468112520553FFc6D24801;
1778         tokenDetails[0x55534443]._precision = 6;
1779         //tusd
1780         tokenDetails[0x54555344]._token = 0x78e7BEE398D66660bDF820DbDB415A33d011cD48;
1781         tokenDetails[0x54555344]._precision = 18;
1782         //ppt
1783         tokenDetails[0x505054]._token = 0x0ff72e24AF7c09A647865820D4477F98fcB72a2c;        
1784         tokenDetails[0x505054]._precision = 8;
1785         //xau
1786         tokenDetails[0x584155]._token = 0x9b935E3779098bC5E1ffc073CaF916F1E92A6145;
1787         tokenDetails[0x584155]._precision = 0;
1788         //usdp
1789         tokenDetails[0x55534470]._token = 0xf4b1533b6F45fAC936fA508F7e5db6d4BbC4c8bd;
1790         tokenDetails[0x55534470]._precision = 6;
1791         */
1792         
1793         /*livenet*/
1794 
1795         //pxt
1796         tokenDetails[0x505854]._token = 0xc14830E53aA344E8c14603A91229A0b925b0B262;
1797         tokenDetails[0x505854]._precision = 8;
1798         //usdc
1799         tokenDetails[0x55534443]._token = 0xA0b86991c6218b36c1d19D4a2e9Eb0cE3606eB48;
1800         tokenDetails[0x55534443]._precision = 6;
1801         //tusd
1802         tokenDetails[0x54555344]._token = 0x8dd5fbCe2F6a956C3022bA3663759011Dd51e73E;
1803         tokenDetails[0x54555344]._precision = 18;
1804         //ppt
1805         tokenDetails[0x505054]._token = 0xd4fa1460F537bb9085d22C7bcCB5DD450Ef28e3a;        
1806         tokenDetails[0x505054]._precision = 8;
1807         //xau
1808         tokenDetails[0x584155]._token = 0x73a3b7DFFE9af119621f8467D8609771AB4BC33f;
1809         tokenDetails[0x584155]._precision = 0;
1810         //usdp
1811         tokenDetails[0x55534470]._token = 0xBaB5D0f110Be6f4a5b70a2FA22eD17324bFF6576;
1812         tokenDetails[0x55534470]._precision = 6;
1813         
1814     }
1815 
1816     /**
1817     BANK MODULE
1818     */
1819     // NON-CONSTANT METHODS
1820 
1821     function usdcToUsdp(
1822         address _dataManager, bytes32 _blockchainActionId, 
1823         bytes32 _clientId, uint amount)
1824         public
1825         onlyServer
1826     {   
1827         // client deposit smart contract address
1828         address _depositAddress = DataManager(_dataManager).getDepositAddress(_clientId);
1829         require(_dataManager != 0x0 && _depositAddress != 0x0 && amount > 0);
1830         //transfer usdc from deposit contract to server/admin
1831         require(DepositContract(_depositAddress).transfer(tokenDetails[0x55534443]._token, msg.sender, amount) == true);
1832         // mint USDp into depositAddress with amount
1833         require(CurrencyToken(tokenDetails[0x55534470]._token).mint(amount, _depositAddress) == true);     
1834         //set action data
1835         require(DataManager(_dataManager).setBlockchainActionData(_blockchainActionId, 0x55534470, amount, _clientId, _depositAddress, 0) == true); 
1836         //event
1837         emit EventUSDCToUSDp(_blockchainActionId, _clientId, amount);
1838     }
1839 
1840     function usdpToUsdc(
1841         address _dataManager, bytes32 _blockchainActionId, 
1842         bytes32 _clientId, uint amount) 
1843         public
1844         onlyServer
1845     {
1846         // client deposit smart contract address
1847         address _depositAddress = DataManager(_dataManager).getDepositAddress(_clientId);
1848         require(_dataManager != 0x0 && _depositAddress != 0x0 && amount > 0);
1849         //destroyFrom depositAddress USDp amount
1850         require(CurrencyToken(tokenDetails[0x55534470]._token).destroyTokensFrom(amount, _depositAddress) == true);
1851         //transferFrom USDC from server to depositAddress
1852         require(CurrencyToken(tokenDetails[0x55534443]._token).transferFrom(msg.sender, _depositAddress, amount) == true);
1853         //set action data
1854         require(DataManager(_dataManager).setBlockchainActionData(_blockchainActionId, 0x55534470, amount, _clientId, _depositAddress, 0) == true); 
1855         //event
1856         emit EventUSDpToUSDC(_blockchainActionId, _clientId, amount);
1857     }
1858 
1859     // Creates a new 'depositAddress' gotten from deploying a deposit contract linked to a client ID
1860     function createAddress(address _dataManager, bytes32 _blockchainActionId, bytes32 clientId) 
1861         public
1862         onlyServer
1863     {   
1864         require(_dataManager != 0x0);
1865         DepositContract newDepositContract;
1866         DepositContract dc;
1867         if (DataManager(_dataManager).getDepositAddress(clientId) != 0x0) {
1868             dc = DepositContract(DataManager(_dataManager).getDepositAddress(clientId));
1869             newDepositContract = new DepositContract(clientId, AM);
1870             require(!dc.call(bytes4(keccak256("getVersion()")))); 
1871             // only checking version 1 now to upgrade to version 2
1872             address PXT = tokenDetails[0x505854]._token;
1873             address PPT = tokenDetails[0x505054]._token;            
1874             if(dc.balanceOf(PXT) > 0){
1875                 require(dc.transfer(PXT, newDepositContract, dc.balanceOf(PXT)) == true);
1876             }
1877             if(dc.balanceOf(PPT) > 0) {
1878                 require(dc.transfer(PPT, newDepositContract, dc.balanceOf(PPT)) == true);
1879             }
1880             require(DataManager(_dataManager)._setDepositAddress(_blockchainActionId, clientId, newDepositContract) == true);
1881             EventDepositAddressUpgrade(_blockchainActionId, address(dc), DataManager(_dataManager).getDepositAddress(clientId), clientId, newDepositContract.getVersion());
1882         } else { 
1883             newDepositContract = new DepositContract(clientId, AM);
1884             require(DataManager(_dataManager).setDepositAddress(_blockchainActionId, newDepositContract, clientId) == true);
1885             require(DataManager(_dataManager).setBlockchainActionData(_blockchainActionId, 0x0, 0, clientId, DataManager(_dataManager).getDepositAddress(clientId), 0) == true);
1886             EventNewDepositContract(_blockchainActionId, clientId, DataManager(_dataManager).getDepositAddress(clientId), newDepositContract.getVersion());
1887         }
1888     }
1889 
1890     /* /// Ether to XAUp exchange between deposit contract and Populous.sol
1891     function exchangeXAUP(
1892         address _dataManager, bytes32 _blockchainActionId, 
1893         address erc20_tokenAddress, uint erc20_amount, uint xaup_amount, 
1894         uint _tokenId, bytes32 _clientId, address adminExternalWallet) 
1895         public 
1896         onlyServer
1897     {    
1898         ERC1155 xa = ERC1155(tokenDetails[0x584155]._token);
1899         // client deposit smart contract address
1900         address _depositAddress = DataManager(_dataManager).getDepositAddress(_clientId);
1901         require(
1902             // check dataManager contract is valid
1903             _dataManager != 0x0 &&
1904             // check deposit address of client
1905             _depositAddress != 0x0 && 
1906             // check xaup token address
1907             // tokenDetails[0x584155]._token != 0x0 && 
1908             erc20_tokenAddress != 0x0 &&
1909             // check action id is unused
1910             DataManager(_dataManager).getActionStatus(_blockchainActionId) == false &&
1911             // deposit contract version >= 2
1912             DepositContract(_depositAddress).getVersion() >= 2 &&
1913             // populous server xaup balance
1914             xa.balanceOf(_tokenId, msg.sender) >= xaup_amount
1915         );
1916         // transfer erc20 token balance from clients deposit contract to server/admin
1917         require(DepositContract(_depositAddress).transfer(erc20_tokenAddress, adminExternalWallet, erc20_amount) == true);
1918         // transfer xaup tokens to clients deposit address from populous server allowance
1919         xa.safeTransferFrom(msg.sender, _depositAddress, _tokenId, xaup_amount, "");
1920         // set action status in dataManager
1921         require(DataManager(_dataManager).setBlockchainActionData(_blockchainActionId, 0x0, erc20_amount, _clientId, _depositAddress, 0) == true);
1922         // emit event 
1923         EventExchangeXAUp(_blockchainActionId, erc20_tokenAddress, erc20_amount, xaup_amount, _tokenId, _clientId, _depositAddress);
1924     } */
1925 
1926 
1927     /** dev Import an amount of pokens of a particular currency from an ethereum wallet/address to bank
1928       * @param _blockchainActionId the blockchain action id
1929       * @param accountId the account id of the client
1930       * @param from the blockchain address to import pokens from
1931       * @param currency the poken currency
1932       */
1933     function withdrawPoken(
1934         address _dataManager, bytes32 _blockchainActionId, 
1935         bytes32 currency, uint256 amount, uint256 amountUSD,
1936         address from, address to, bytes32 accountId, 
1937         uint256 inCollateral,
1938         uint256 pptFee, address adminExternalWallet) 
1939         public 
1940         onlyServer 
1941     {
1942         require(_dataManager != 0x0);
1943         //DataManager dm = DataManager(_dataManager);
1944         require(DataManager(_dataManager).getActionStatus(_blockchainActionId) == false && DataManager(_dataManager).getDepositAddress(accountId) != 0x0);
1945         require(adminExternalWallet != 0x0 && pptFee > 0 && amount > 0);
1946         require(DataManager(_dataManager).getCurrency(currency) != 0x0);
1947         DepositContract o = DepositContract(DataManager(_dataManager).getDepositAddress(accountId));
1948         // check if pptbalance minus collateral held is more than pptFee then transfer pptFee from users ppt deposit to adminWallet
1949         require(SafeMath.safeSub(o.balanceOf(tokenDetails[0x505054]._token), inCollateral) >= pptFee);
1950         require(o.transfer(tokenDetails[0x505054]._token, adminExternalWallet, pptFee) == true);
1951         // WITHDRAW PART / DEBIT
1952         if(amount > CurrencyToken(DataManager(_dataManager).getCurrency(currency)).balanceOf(from)) {
1953             // destroying total balance as user has less than pokens they want to withdraw
1954             require(CurrencyToken(DataManager(_dataManager).getCurrency(currency)).destroyTokensFrom(CurrencyToken(DataManager(_dataManager).getCurrency(currency)).balanceOf(from), from) == true);
1955             //remaining ledger balance of deposit address is 0
1956         } else {
1957             // destroy amount from balance as user has more than pokens they want to withdraw
1958             require(CurrencyToken(DataManager(_dataManager).getCurrency(currency)).destroyTokensFrom(amount, from) == true);
1959             //left over balance is deposit address balance.
1960         }
1961         // TRANSFER PART / CREDIT
1962         // approve currency amount for populous for the next require to pass
1963         if(amountUSD > 0) //give the user USDC
1964         {
1965             CurrencyToken(tokenDetails[0x55534443]._token).transferFrom(msg.sender, to, amountUSD);
1966         }else { //give the user GBP / poken currency
1967             CurrencyToken(DataManager(_dataManager).getCurrency(currency)).transferFrom(msg.sender, to, amount);
1968         }
1969         require(DataManager(_dataManager).setBlockchainActionData(_blockchainActionId, currency, amount, accountId, to, pptFee) == true); 
1970         EventWithdrawPoken(_blockchainActionId, accountId, currency, amount);
1971     }
1972 
1973     /** @dev Withdraw an amount of PPT Populous tokens to a blockchain address 
1974       * @param _blockchainActionId the blockchain action id
1975       * @param pptAddress the address of the PPT smart contract
1976       * @param accountId the account id of the client
1977       * @param pptFee the amount of fees to pay in PPT tokens
1978       * @param adminExternalWallet the platform admin wallet address to pay the fees to 
1979       * @param to the blockchain address to withdraw and transfer the pokens to
1980       * @param inCollateral the amount of pokens withheld by the platform
1981       */    
1982     function withdrawERC20(
1983         address _dataManager, bytes32 _blockchainActionId, 
1984         address pptAddress, bytes32 accountId, 
1985         address to, uint256 amount, uint256 inCollateral, 
1986         uint256 pptFee, address adminExternalWallet) 
1987         public 
1988         onlyServer 
1989     {   
1990         require(_dataManager != 0x0);
1991         require(DataManager(_dataManager).getActionStatus(_blockchainActionId) == false && DataManager(_dataManager).getDepositAddress(accountId) != 0x0);
1992         require(adminExternalWallet != 0x0 && pptFee >= 0 && amount > 0);
1993         address depositContract = DataManager(_dataManager).getDepositAddress(accountId);
1994         if(pptAddress == tokenDetails[0x505054]._token) {
1995             uint pptBalance = SafeMath.safeSub(DepositContract(depositContract).balanceOf(tokenDetails[0x505054]._token), inCollateral);
1996             require(pptBalance >= SafeMath.safeAdd(amount, pptFee));
1997         } else {
1998             uint erc20Balance = DepositContract(depositContract).balanceOf(pptAddress);
1999             require(erc20Balance >= amount);
2000         }
2001         require(DepositContract(depositContract).transfer(tokenDetails[0x505054]._token, adminExternalWallet, pptFee) == true);
2002         require(DepositContract(depositContract).transfer(pptAddress, to, amount) == true);
2003         bytes32 tokenSymbol = iERC20Token(pptAddress).symbol();    
2004         require(DataManager(_dataManager).setBlockchainActionData(_blockchainActionId, tokenSymbol, amount, accountId, to, pptFee) == true);
2005         EventWithdrawPPT(_blockchainActionId, accountId, DataManager(_dataManager).getDepositAddress(accountId), to, amount);
2006     }
2007 
2008     // erc1155 withdraw function from deposit contract
2009 /*     function withdrawERC1155(
2010         address _dataManager, bytes32 _blockchainActionId,
2011         address _to, uint256 _id, uint256 _value,
2012         bytes32 accountId, uint256 pptFee, 
2013         address adminExternalWallet) 
2014         public
2015         onlyServer 
2016     {
2017         require(DataManager(_dataManager).getActionStatus(_blockchainActionId) == false && DataManager(_dataManager).getDepositAddress(accountId) != 0x0);
2018         require(adminExternalWallet != 0x0 && pptFee > 0 && _value > 0);
2019         DepositContract o = DepositContract(DataManager(_dataManager).getDepositAddress(accountId));
2020         require(o.transfer(tokenDetails[0x505054]._token, adminExternalWallet, pptFee) == true);
2021         // transfer xaup tokens to address from deposit contract
2022         require(o.transferERC1155(tokenDetails[0x584155]._token, _to, _id, _value) == true);
2023         // set action status in dataManager
2024         require(DataManager(_dataManager).setBlockchainActionData(_blockchainActionId, 0x584155, _value, accountId, _to, pptFee) == true);
2025         // emit event 
2026         EventWithdrawXAUp(_blockchainActionId, tokenDetails[0x584155]._token, _value, _id, accountId, pptFee);
2027     } */
2028 }