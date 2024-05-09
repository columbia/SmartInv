1 pragma solidity ^0.4.24;
2 
3 // File: contracts/ownership/MultiOwnable.sol
4 
5 /**
6  * @title MultiOwnable
7  * @dev The MultiOwnable contract has owners addresses and provides basic authorization control
8  * functions, this simplifies the implementation of "users permissions".
9  */
10 contract MultiOwnable {
11     address public manager; // address used to set owners
12     address[] public owners;
13     mapping(address => bool) public ownerByAddress;
14 
15     event SetOwners(address[] owners);
16 
17     modifier onlyOwner() {
18         require(ownerByAddress[msg.sender] == true);
19         _;
20     }
21 
22     /**
23      * @dev MultiOwnable constructor sets the manager
24      */
25     function MultiOwnable() public {
26         manager = msg.sender;
27     }
28 
29     /**
30      * @dev Function to set owners addresses
31      */
32     function setOwners(address[] _owners) public {
33         require(msg.sender == manager);
34         _setOwners(_owners);
35 
36     }
37 
38     function _setOwners(address[] _owners) internal {
39         for(uint256 i = 0; i < owners.length; i++) {
40             ownerByAddress[owners[i]] = false;
41         }
42 
43 
44         for(uint256 j = 0; j < _owners.length; j++) {
45             ownerByAddress[_owners[j]] = true;
46         }
47         owners = _owners;
48         emit SetOwners(_owners);
49     }
50 
51     function getOwners() public constant returns (address[]) {
52         return owners;
53     }
54 }
55 
56 // File: contracts/math/SafeMath.sol
57 
58 /**
59  * @title SafeMath
60  * @dev Math operations with safety checks that throw on error
61  */
62 library SafeMath {
63 
64   /**
65   * @dev Multiplies two numbers, throws on overflow.
66   */
67   function mul(uint256 a, uint256 b) internal pure returns (uint256 c) {
68     if (a == 0) {
69       return 0;
70     }
71     c = a * b;
72     assert(c / a == b);
73     return c;
74   }
75 
76   /**
77   * @dev Integer division of two numbers, truncating the quotient.
78   */
79   function div(uint256 a, uint256 b) internal pure returns (uint256) {
80     // assert(b > 0); // Solidity automatically throws when dividing by 0
81     // uint256 c = a / b;
82     // assert(a == b * c + a % b); // There is no case in which this doesn't hold
83     return a / b;
84   }
85 
86   /**
87   * @dev Subtracts two numbers, throws on overflow (i.e. if subtrahend is greater than minuend).
88   */
89   function sub(uint256 a, uint256 b) internal pure returns (uint256) {
90     assert(b <= a);
91     return a - b;
92   }
93 
94   /**
95   * @dev Adds two numbers, throws on overflow.
96   */
97   function add(uint256 a, uint256 b) internal pure returns (uint256 c) {
98     c = a + b;
99     assert(c >= a);
100     return c;
101   }
102 }
103 
104 // File: contracts/token/ERC20/ERC20.sol
105 
106 /**
107  * @title ERC20 interface
108  * @dev see https://github.com/ethereum/EIPs/issues/20
109  */
110 contract ERC20 {
111     function totalSupply() public view returns (uint256);
112 
113     function balanceOf(address _who) public view returns (uint256);
114 
115     function allowance(address _owner, address _spender)
116         public view returns (uint256);
117 
118     function transfer(address _to, uint256 _value) public returns (bool);
119 
120     function approve(address _spender, uint256 _value)
121         public returns (bool);
122 
123     function transferFrom(address _from, address _to, uint256 _value)
124         public returns (bool);
125 
126     event Transfer(
127         address indexed from,
128         address indexed to,
129         uint256 value
130     );
131 
132     event Approval(
133         address indexed owner,
134         address indexed spender,
135         uint256 value
136     );
137 }
138 
139 // File: contracts/token/ERC20/StandardToken.sol
140 
141 /**
142  * @title Standard ERC20 token
143  *
144  * @dev Implementation of the basic standard token.
145  * https://github.com/ethereum/EIPs/issues/20
146  * Based on code by FirstBlood: https://github.com/Firstbloodio/token/blob/master/smart_contract/FirstBloodToken.sol
147  */
148 contract StandardToken is ERC20 {
149     using SafeMath for uint256;
150 
151     mapping(address => uint256) balances;
152 
153     mapping (address => mapping (address => uint256)) internal allowed;
154 
155     uint256 totalSupply_;
156 
157     /**
158     * @dev Total number of tokens in existence
159     */
160     function totalSupply() public view returns (uint256) {
161         return totalSupply_;
162     }
163 
164     /**
165     * @dev Gets the balance of the specified address.
166     * @param _owner The address to query the the balance of.
167     * @return An uint256 representing the amount owned by the passed address.
168     */
169     function balanceOf(address _owner) public view returns (uint256) {
170         return balances[_owner];
171     }
172 
173     /**
174     * @dev Function to check the amount of tokens that an owner allowed to a spender.
175     * @param _owner address The address which owns the funds.
176     * @param _spender address The address which will spend the funds.
177     * @return A uint256 specifying the amount of tokens still available for the spender.
178     */
179     function allowance(
180         address _owner,
181         address _spender
182     )
183       public
184       view
185       returns (uint256)
186     {
187         return allowed[_owner][_spender];
188     }
189 
190     /**
191     * @dev Transfer token for a specified address
192     * @param _to The address to transfer to.
193     * @param _value The amount to be transferred.
194     */
195     function transfer(address _to, uint256 _value) public returns (bool) {
196         require(_value <= balances[msg.sender]);
197         require(_to != address(0));
198 
199         balances[msg.sender] = balances[msg.sender].sub(_value);
200         balances[_to] = balances[_to].add(_value);
201         emit Transfer(msg.sender, _to, _value);
202         return true;
203     }
204 
205     /**
206     * @dev Approve the passed address to spend the specified amount of tokens on behalf of msg.sender.
207     * Beware that changing an allowance with this method brings the risk that someone may use both the old
208     * and the new allowance by unfortunate transaction ordering. One possible solution to mitigate this
209     * race condition is to first reduce the spender's allowance to 0 and set the desired value afterwards:
210     * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
211     * @param _spender The address which will spend the funds.
212     * @param _value The amount of tokens to be spent.
213     */
214     function approve(address _spender, uint256 _value) public returns (bool) {
215         allowed[msg.sender][_spender] = _value;
216         emit Approval(msg.sender, _spender, _value);
217         return true;
218     }
219 
220     /**
221     * @dev Transfer tokens from one address to another
222     * @param _from address The address which you want to send tokens from
223     * @param _to address The address which you want to transfer to
224     * @param _value uint256 the amount of tokens to be transferred
225     */
226     function transferFrom(
227         address _from,
228         address _to,
229         uint256 _value
230     )
231       public
232       returns (bool)
233     {
234         require(_value <= balances[_from]);
235         require(_value <= allowed[_from][msg.sender]);
236         require(_to != address(0));
237 
238         balances[_from] = balances[_from].sub(_value);
239         balances[_to] = balances[_to].add(_value);
240         allowed[_from][msg.sender] = allowed[_from][msg.sender].sub(_value);
241         emit Transfer(_from, _to, _value);
242         return true;
243     }
244 
245     /**
246     * @dev Increase the amount of tokens that an owner allowed to a spender.
247     * approve should be called when allowed[_spender] == 0. To increment
248     * allowed value is better to use this function to avoid 2 calls (and wait until
249     * the first transaction is mined)
250     * From MonolithDAO Token.sol
251     * @param _spender The address which will spend the funds.
252     * @param _addedValue The amount of tokens to increase the allowance by.
253     */
254     function increaseApproval(
255         address _spender,
256         uint256 _addedValue
257     )
258       public
259       returns (bool)
260     {
261         allowed[msg.sender][_spender] = (
262             allowed[msg.sender][_spender].add(_addedValue));
263         emit Approval(msg.sender, _spender, allowed[msg.sender][_spender]);
264         return true;
265     }
266 
267     /**
268     * @dev Decrease the amount of tokens that an owner allowed to a spender.
269     * approve should be called when allowed[_spender] == 0. To decrement
270     * allowed value is better to use this function to avoid 2 calls (and wait until
271     * the first transaction is mined)
272     * From MonolithDAO Token.sol
273     * @param _spender The address which will spend the funds.
274     * @param _subtractedValue The amount of tokens to decrease the allowance by.
275     */
276     function decreaseApproval(
277         address _spender,
278         uint256 _subtractedValue
279     )
280       public
281       returns (bool)
282     {
283         uint256 oldValue = allowed[msg.sender][_spender];
284         if (_subtractedValue >= oldValue) {
285             allowed[msg.sender][_spender] = 0;
286         } else {
287             allowed[msg.sender][_spender] = oldValue.sub(_subtractedValue);
288         }
289         emit Approval(msg.sender, _spender, allowed[msg.sender][_spender]);
290         return true;
291     }
292 }
293 
294 // File: contracts/token/ITokenEventListener.sol
295 
296 /**
297  * @title ITokenEventListener
298  * @dev Interface which should be implemented by token listener
299  */
300 interface ITokenEventListener {
301     /**
302      * @dev Function is called after token transfer/transferFrom
303      * @param _from Sender address
304      * @param _to Receiver address
305      * @param _value Amount of tokens
306      */
307     function onTokenTransfer(address _from, address _to, uint256 _value) external;
308 }
309 
310 // File: contracts/token/ManagedToken.sol
311 
312 /**
313  * @title ManagedToken
314  * @dev ERC20 compatible token with issue and destroy facilities
315  * @dev All transfers can be monitored by token event listener
316  */
317 contract ManagedToken is StandardToken, MultiOwnable {
318 
319     bool public allowTransfers = false;
320     bool public issuanceFinished = false;
321 
322     ITokenEventListener public eventListener;
323 
324     event AllowTransfersChanged(bool _newState);
325     event Issue(address indexed _to, uint256 _value);
326     event Destroy(address indexed _from, uint256 _value);
327     event IssuanceFinished();
328 
329     modifier transfersAllowed() {
330         assert(allowTransfers);
331         _;
332     }
333 
334     modifier canIssue() {
335         assert(!issuanceFinished);
336         _;
337     }
338 
339     /**
340      * @dev ManagedToken constructor
341      * @param _listener Token listener(address can be 0x0)
342      * @param _owners Owners list
343      */
344     function ManagedToken(address _listener, address[] _owners) public {
345         if(_listener != address(0)) {
346             eventListener = ITokenEventListener(_listener);
347         }
348         _setOwners(_owners);
349     }
350 
351     /**
352      * @dev Enable/disable token transfers. Can be called only by owners
353      * @param _allowTransfers True - allow False - disable
354      */
355     function setAllowTransfers(bool _allowTransfers) external onlyOwner {
356         allowTransfers = _allowTransfers;
357         emit AllowTransfersChanged(_allowTransfers);
358     }
359 
360     /**
361      * @dev Set/remove token event listener
362      * @param _listener Listener address (Contract must implement ITokenEventListener interface)
363      */
364     function setListener(address _listener) public onlyOwner {
365         if(_listener != address(0)) {
366             eventListener = ITokenEventListener(_listener);
367         } else {
368             delete eventListener;
369         }
370     }
371 
372     /**
373      * @dev Override transfer function. Add event listener condition
374      */
375     function transfer(address _to, uint256 _value) public transfersAllowed returns (bool) {
376         bool success = super.transfer(_to, _value);
377         if(hasListener() && success) {
378             eventListener.onTokenTransfer(msg.sender, _to, _value);
379         }
380         return success;
381     }
382 
383     /**
384      * @dev Override transferFrom function. Add event listener condition
385      */
386     function transferFrom(address _from, address _to, uint256 _value) public transfersAllowed returns (bool) {
387         bool success = super.transferFrom(_from, _to, _value);
388         if(hasListener() && success) {
389             eventListener.onTokenTransfer(_from, _to, _value);
390         }
391         return success;
392     }
393 
394     function hasListener() internal view returns(bool) {
395         if(eventListener == address(0)) {
396             return false;
397         }
398         return true;
399     }
400 
401     /**
402      * @dev Issue tokens to specified wallet
403      * @param _to Wallet address
404      * @param _value Amount of tokens
405      */
406     function issue(address _to, uint256 _value) external onlyOwner canIssue {
407     }
408 
409     /**
410      * @dev Destroy tokens on specified address (Called by owner or token holder)
411      * @dev Fund contract address must be in the list of owners to burn token during refund
412      * @param _from Wallet address
413      * @param _value Amount of tokens to destroy
414      */
415     function destroy(address _from, uint256 _value) external {
416     }
417     
418     /**
419      * @dev Increase the amount of tokens that an owner allowed to a spender.
420      *
421      * approve should be called when allowed[_spender] == 0. To increment
422      * allowed value is better to use this function to avoid 2 calls (and wait until
423      * the first transaction is mined)
424      * From OpenZeppelin StandardToken.sol
425      * @param _spender The address which will spend the funds.
426      * @param _addedValue The amount of tokens to increase the allowance by.
427      */
428     function increaseApproval(address _spender, uint _addedValue) public returns (bool) {
429         allowed[msg.sender][_spender] = SafeMath.add(allowed[msg.sender][_spender], _addedValue);
430         emit Approval(msg.sender, _spender, allowed[msg.sender][_spender]);
431         return true;
432     }
433 
434     /**
435      * @dev Decrease the amount of tokens that an owner allowed to a spender.
436      *
437      * approve should be called when allowed[_spender] == 0. To decrement
438      * allowed value is better to use this function to avoid 2 calls (and wait until
439      * the first transaction is mined)
440      * From OpenZeppelin StandardToken.sol
441      * @param _spender The address which will spend the funds.
442      * @param _subtractedValue The amount of tokens to decrease the allowance by.
443      */
444     function decreaseApproval(address _spender, uint _subtractedValue) public returns (bool) {
445         uint oldValue = allowed[msg.sender][_spender];
446         if (_subtractedValue > oldValue) {
447             allowed[msg.sender][_spender] = 0;
448         } else {
449             allowed[msg.sender][_spender] = SafeMath.sub(oldValue, _subtractedValue);
450         }
451         emit Approval(msg.sender, _spender, allowed[msg.sender][_spender]);
452         return true;
453     }
454 
455     /**
456      * @dev Finish token issuance
457      * @return True if success
458      */
459     function finishIssuance() public onlyOwner {
460         issuanceFinished = true;
461         emit IssuanceFinished();
462     }
463 }
464 
465 // File: contracts/token/TransferLimitedToken.sol
466 
467 /**
468  * @title TransferLimitedToken
469  * @dev Token with ability to limit transfers within wallets included in limitedWallets list for certain period of time
470  */
471 contract TransferLimitedToken is ManagedToken {
472 
473     mapping(address => bool) public limitedWallets;
474     address public limitedWalletsManager;
475     bool public isLimitEnabled;
476 
477     modifier onlyManager() {
478         require(msg.sender == limitedWalletsManager);
479         _;
480     }
481 
482     /**
483      * @dev Check if transfer between addresses is available
484      * @param _from From address
485      * @param _to To address
486      */
487     modifier canTransfer(address _from, address _to)  {
488         require(!isLimitEnabled || (!limitedWallets[_from] && !limitedWallets[_to]));
489         _;
490     }
491 
492     /**
493      * @dev TransferLimitedToken constructor
494      * @param _listener Token listener(address can be 0x0)
495      * @param _owners Owners list
496      * @param _limitedWalletsManager Address used to add/del wallets from limitedWallets
497      */
498     function TransferLimitedToken(address _listener, address[] _owners, address _limitedWalletsManager) public
499         ManagedToken(_listener, _owners)
500     {
501         isLimitEnabled = true;
502         limitedWalletsManager = _limitedWalletsManager;
503     }
504 
505     /**
506      * @dev Add address to limitedWallets
507      * @dev Can be called only by manager
508      */
509     function addLimitedWalletAddress(address _wallet) public onlyManager {
510         limitedWallets[_wallet] = true;
511     }
512 
513     /**
514      * @dev Del address from limitedWallets
515      * @dev Can be called only by manager
516      */
517     function delLimitedWalletAddress(address _wallet) public onlyManager {
518         limitedWallets[_wallet] = false;
519     }
520 
521     function isLimitedWalletAddress(address _wallet) public view returns(bool) {
522         return limitedWallets[_wallet];
523     }
524 
525     /**
526      * @dev Enable/disable token transfers limited wallet. Can be called only by manager
527      * @param _setLimitEnabled True - enable limit transfer False - disable
528      */
529     function setLimitEnabled(bool _setLimitEnabled) public onlyManager {
530         isLimitEnabled = _setLimitEnabled;
531     }
532     
533 
534     /**
535      * @dev Override transfer function. Add canTransfer modifier to check possibility of transferring
536      */
537     function transfer(address _to, uint256 _value) public canTransfer(msg.sender, _to) returns (bool) {
538         return super.transfer(_to, _value);
539     }
540 
541     /**
542      * @dev Override transferFrom function. Add canTransfer modifier to check possibility of transferring
543      */
544     function transferFrom(address _from, address _to, uint256 _value) public canTransfer(_from, _to) returns (bool) {
545         return super.transferFrom(_from, _to, _value);
546     }
547 
548     /**
549      * @dev Override approve function. Add canTransfer modifier to check possibility of transferring
550      */
551     function approve(address _spender, uint256 _value) public canTransfer(msg.sender, _spender) returns (bool) {
552         return super.approve(_spender,_value);
553     }
554 }
555 
556 // File: contracts/MCCToken.sol
557 
558 contract MCCToken is TransferLimitedToken {
559     // =================================================================================================================
560     //                                         Members
561     // =================================================================================================================
562     string public name = "MyCreditChain";
563 
564     string public symbol = "MCC";
565 
566     uint8 public decimals = 18;
567 
568     event Burn(address indexed burner, uint256 value);
569 
570     // =================================================================================================================
571     //                                         Constructor
572     // =================================================================================================================
573 
574     /**
575      * @dev MCC Token
576      *      To change to a token for DAICO, you must set up an ITokenEvenListener
577      *      to change the voting weight setting through the listener for the
578      *      transfer of the token.
579      */
580     function MCCToken(address _listener, address[] _owners, address _manager) public
581         TransferLimitedToken(_listener, _owners, _manager)
582     {
583         totalSupply_ = uint256(1000000000).mul(uint256(10) ** decimals); // token total supply : 1000000000
584 
585         balances[_owners[0]] = totalSupply_;
586     }
587 
588     /**
589      * @dev Override ManagedToken.issue. MCCToken can not issue but it need to
590      *      distribute tokens to contributors while crowding sales. So. we changed this
591      *       Issue tokens to specified wallet
592      * @param _to Wallet address
593      * @param _value Amount of tokens
594      */
595     function issue(address _to, uint256 _value) external onlyOwner canIssue {
596         balances[msg.sender] = SafeMath.sub(balances[msg.sender], _value);
597         balances[_to] = SafeMath.add(balances[_to], _value);
598         emit Issue(_to, _value);
599         emit Transfer(msg.sender, _to, _value);
600     }
601 
602     /**
603      * @dev Burns a specific amount of tokens.
604      * @param _value The amount of token to be burned.
605      */
606     function burn(uint256 _value) public {
607         _burn(msg.sender, _value);
608     }
609 
610     /**
611     * @dev Burns a specific amount of tokens from the target address and decrements allowance
612     * @param _from address The address which you want to send tokens from
613     * @param _value uint256 The amount of token to be burned
614     */
615     function burnFrom(address _from, uint256 _value) public {
616         require(_value <= allowed[_from][msg.sender]);
617         // Should https://github.com/OpenZeppelin/zeppelin-solidity/issues/707 be accepted,
618         // this function needs to emit an event with the updated approval.
619         allowed[_from][msg.sender] = allowed[_from][msg.sender].sub(_value);
620         _burn(_from, _value);
621     }
622 
623     function _burn(address _who, uint256 _value) internal {
624         require(_value <= balances[_who]);
625         // no need to require value <= totalSupply, since that would imply the
626         // sender's balance is greater than the totalSupply, which *should* be an assertion failure
627 
628         balances[_who] = balances[_who].sub(_value);
629         totalSupply_ = totalSupply_.sub(_value);
630         emit Burn(_who, _value);
631         emit Transfer(_who, address(0), _value);
632     }
633 }