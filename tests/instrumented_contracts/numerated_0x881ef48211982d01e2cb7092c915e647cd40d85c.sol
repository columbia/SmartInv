1 pragma solidity ^0.4.11;
2 
3 /**
4  * @title SafeMath
5  * @dev Math operations with safety checks that throw on error
6  */
7 library SafeMath {
8     function mul(uint256 a, uint256 b) internal constant returns (uint256) {
9         uint256 c = a * b;
10         assert(a == 0 || c / a == b);
11         return c;
12     }
13 
14     function div(uint256 a, uint256 b) internal constant returns (uint256) {
15         // assert(b > 0); // Solidity automatically throws when dividing by 0
16         uint256 c = a / b;
17         // assert(a == b * c + a % b); // There is no case in which this doesn't hold
18         return c;
19     }
20 
21     function sub(uint256 a, uint256 b) internal constant returns (uint256) {
22         assert(b <= a);
23         return a - b;
24     }
25 
26     function add(uint256 a, uint256 b) internal constant returns (uint256) {
27         uint256 c = a + b;
28         assert(c >= a);
29         return c;
30     }
31 }
32 
33 /**
34  * @title ERC20Basic
35  * @dev Simpler version of ERC20 interface
36  * @dev see https://github.com/ethereum/EIPs/issues/179
37  */
38 contract ERC20Basic {
39     uint256 public totalSupply;
40 
41     function balanceOf(address who) public constant returns (uint256);
42 
43     function transfer(address to, uint256 value) public returns (bool);
44 
45     event Transfer(address indexed from, address indexed to, uint256 value);
46 }
47 
48 /**
49  * @title ERC20 interface
50  * @dev see https://github.com/ethereum/EIPs/issues/20
51  */
52 contract ERC20 is ERC20Basic {
53     function allowance(address owner, address spender) public constant returns (uint256);
54 
55     function transferFrom(address from, address to, uint256 value) public returns (bool);
56 
57     function approve(address spender, uint256 value) public returns (bool);
58 
59     event Approval(address indexed owner, address indexed spender, uint256 value);
60 }
61 
62 /**
63  * @title Basic token
64  * @dev Basic version of StandardToken, with no allowances.
65  */
66 contract BasicToken is ERC20Basic {
67     using SafeMath for uint256;
68 
69     mapping (address => uint256) balances;
70 
71     /**
72     * @dev transfer token for a specified address
73     * @param _to The address to transfer to.
74     * @param _value The amount to be transferred.
75     */
76     function transfer(address _to, uint256 _value) public returns (bool) {
77         require(_to != address(0));
78 
79         // SafeMath.sub will throw if there is not enough balance.
80         balances[msg.sender] = balances[msg.sender].sub(_value);
81         balances[_to] = balances[_to].add(_value);
82         Transfer(msg.sender, _to, _value);
83         return true;
84     }
85 
86     /**
87     * @dev Gets the balance of the specified address.
88     * @param _owner The address to query the the balance of.
89     * @return An uint256 representing the amount owned by the passed address.
90     */
91     function balanceOf(address _owner) public constant returns (uint256 balance) {
92         return balances[_owner];
93     }
94 
95 }
96 
97 /**
98  * @title Shareable
99  * @dev inheritable "property" contract that enables methods to be protected by requiring the
100  * acquiescence of either a single, or, crucially, each of a number of, designated owners.
101  * @dev Usage: use modifiers onlyOwner (just own owned) or onlyManyOwners(hash), whereby the same hash must be provided by some number (specified in constructor) of the set of owners (specified in the constructor) before the interior is executed.
102  */
103 contract Shareable {
104 
105     event Confirmation(address owner, bytes32 operation);
106     event Revoke(address owner, bytes32 operation);
107     event RequirementChange(uint required);
108     event OwnerAddition(address indexed owner);
109     event OwnerRemoval(address indexed owner);
110 
111     // struct for the status of a pending operation.
112     struct PendingState {
113         uint256 index;
114         uint256 yetNeeded;
115         mapping (address => bool) ownersDone;
116     }
117 
118     // the number of owners that must confirm the same operation before it is run.
119     uint256 public required;
120 
121     // list of owners by index
122     address[] owners;
123 
124     // hash table of owners by address
125     mapping (address => bool) internal isOwner;
126 
127     // the ongoing operations.
128     mapping (bytes32 => PendingState) internal pendings;
129 
130     // the ongoing operations by index
131     bytes32[] internal pendingsIndex;
132 
133     /**
134      * @dev Throws if address is null.
135      * @param _address The address for check
136      */
137     modifier addressNotNull(address _address) {
138         require(_address != address(0));
139         _;
140     }
141 
142     /**
143      * @dev Throws if owners count less then quorum.
144      * @param _ownersCount New owners count
145      * @param _required New or old required param, min: 2
146      */
147     modifier validRequirement(uint256 _ownersCount, uint _required) {
148         require(_required > 1 && _ownersCount >= _required);
149         _;
150     }
151 
152     /**
153      * @dev Throws if owner does not exists.
154      * @param owner The address for check
155      */
156     modifier ownerExists(address owner) {
157         require(isOwner[owner]);
158         _;
159     }
160 
161     /**
162      * @dev Throws if owner exists.
163      * @param owner The address for check
164      */
165     modifier ownerDoesNotExist(address owner) {
166         require(!isOwner[owner]);
167         _;
168     }
169 
170     /**
171      * @dev Throws if called by any account other than the owner.
172      */
173     modifier onlyOwner {
174         require(isOwner[msg.sender]);
175         _;
176     }
177 
178     /**
179      * @dev Modifier for multisig functions.
180      * @param _operation The operation must have an intrinsic hash in order that later attempts can be
181      * realised as the same underlying operation and thus count as confirmations.
182      */
183     modifier onlyManyOwners(bytes32 _operation) {
184         if (confirmAndCheck(_operation)) {
185             _;
186         }
187     }
188 
189     /**
190      * @dev Constructor is given the number of sigs required to do protected "onlyManyOwners"
191      * transactions as well as the selection of addresses capable of confirming them.
192      * @param _additionalOwners A list of owners.
193      * @param _required The amount required for a operation to be approved.
194      */
195     function Shareable(address[] _additionalOwners, uint256 _required)
196         validRequirement(_additionalOwners.length + 1, _required)
197     {
198         owners.push(msg.sender);
199         isOwner[msg.sender] = true;
200 
201         for (uint i = 0; i < _additionalOwners.length; i++) {
202             require(!isOwner[_additionalOwners[i]] && _additionalOwners[i] != address(0));
203 
204             owners.push(_additionalOwners[i]);
205             isOwner[_additionalOwners[i]] = true;
206         }
207 
208         required = _required;
209     }
210 
211     /**
212      * @dev Allows to change the number of required confirmations.
213      * @param _required Number of required confirmations.
214      */
215     function changeRequirement(uint _required)
216         external
217         validRequirement(owners.length, _required)
218         onlyManyOwners(keccak256("change-requirement", _required))
219     {
220         required = _required;
221 
222         RequirementChange(_required);
223     }
224 
225     /**
226      * @dev Allows owners to add new owner with quorum.
227      * @param _owner The address to join for ownership.
228      */
229     function addOwner(address _owner)
230         external
231         addressNotNull(_owner)
232         ownerDoesNotExist(_owner)
233         onlyManyOwners(keccak256("add-owner", _owner))
234     {
235         owners.push(_owner);
236         isOwner[_owner] = true;
237 
238         OwnerAddition(_owner);
239     }
240 
241     /**
242      * @dev Allows owners to remove owner with quorum.
243      * @param _owner The address to remove from ownership.
244      */
245     function removeOwner(address _owner)
246         external
247         addressNotNull(_owner)
248         ownerExists(_owner)
249         onlyManyOwners(keccak256("remove-owner", _owner))
250         validRequirement(owners.length - 1, required)
251     {
252         // clear all pending operation list
253         clearPending();
254 
255         isOwner[_owner] = false;
256 
257         for (uint256 i = 0; i < owners.length - 1; i++) {
258             if (owners[i] == _owner) {
259                 owners[i] = owners[owners.length - 1];
260                 break;
261             }
262         }
263 
264         owners.length -= 1;
265 
266         OwnerRemoval(_owner);
267     }
268 
269     /**
270      * @dev Revokes a prior confirmation of the given operation.
271      * @param _operation A string identifying the operation.
272      */
273     function revoke(bytes32 _operation)
274         external
275         onlyOwner
276     {
277         var pending = pendings[_operation];
278 
279         if (pending.ownersDone[msg.sender]) {
280             pending.yetNeeded++;
281             pending.ownersDone[msg.sender] = false;
282 
283             uint256 count = 0;
284             for (uint256 i = 0; i < owners.length; i++) {
285                 if (hasConfirmed(_operation, owners[i])) {
286                     count++;
287                 }
288             }
289 
290             if (count <= 0) {
291                 pendingsIndex[pending.index] = pendingsIndex[pendingsIndex.length - 1];
292                 pendingsIndex.length--;
293                 delete pendings[_operation];
294             }
295 
296             Revoke(msg.sender, _operation);
297         }
298     }
299 
300     /**
301      * @dev Function to check is specific owner has already confirme the operation.
302      * @param _operation The operation identifier.
303      * @param _owner The owner address.
304      * @return True if the owner has confirmed and false otherwise.
305      */
306     function hasConfirmed(bytes32 _operation, address _owner)
307         constant
308         addressNotNull(_owner)
309         onlyOwner
310         returns (bool)
311     {
312         return pendings[_operation].ownersDone[_owner];
313     }
314 
315     /**
316      * @dev Confirm and operation and checks if it's already executable.
317      * @param _operation The operation identifier.
318      * @return Returns true when operation can be executed.
319      */
320     function confirmAndCheck(bytes32 _operation)
321         internal
322         onlyOwner
323         returns (bool)
324     {
325         var pending = pendings[_operation];
326 
327         // if we're not yet working on this operation, switch over and reset the confirmation status.
328         if (pending.yetNeeded == 0) {
329             clearOwnersDone(_operation);
330             // reset count of confirmations needed.
331             pending.yetNeeded = required;
332             // reset which owners have confirmed (none).
333             pendingsIndex.length++;
334             pending.index = pendingsIndex.length++;
335             pendingsIndex[pending.index] = _operation;
336         }
337 
338         // make sure we (the message sender) haven't confirmed this operation previously.
339         if (!hasConfirmed(_operation, msg.sender)) {
340             Confirmation(msg.sender, _operation);
341 
342             // ok - check if count is enough to go ahead.
343             if (pending.yetNeeded <= 1) {
344                 // enough confirmations: reset and run interior.
345                 clearOwnersDone(_operation);
346                 pendingsIndex[pending.index] = pendingsIndex[pendingsIndex.length - 1];
347                 pendingsIndex.length--;
348                 delete pendings[_operation];
349 
350                 return true;
351             } else {
352                 // not enough: record that this owner in particular confirmed.
353                 pending.yetNeeded--;
354                 pending.ownersDone[msg.sender] = true;
355             }
356         } else {
357             revert();
358         }
359 
360         return false;
361     }
362 
363     /**
364      * @dev Clear ownersDone in operation.
365      * @param _operation The operation identifier.
366      */
367     function clearOwnersDone(bytes32 _operation)
368         internal
369         onlyOwner
370     {
371         for (uint256 i = 0; i < owners.length; i++) {
372             if (pendings[_operation].ownersDone[owners[i]]) {
373                 pendings[_operation].ownersDone[owners[i]] = false;
374             }
375         }
376     }
377 
378     /**
379      * @dev Clear the pending list.
380      */
381     function clearPending()
382         internal
383         onlyOwner
384     {
385         uint256 length = pendingsIndex.length;
386 
387         for (uint256 i = 0; i < length; ++i) {
388             clearOwnersDone(pendingsIndex[i]);
389             delete pendings[pendingsIndex[i]];
390         }
391 
392         pendingsIndex.length = 0;
393     }
394 }
395 
396 /**
397  * @title Standard ERC20 token
398  *
399  * @dev Implementation of the basic standard token.
400  * @dev https://github.com/ethereum/EIPs/issues/20
401  * @dev Based on code by FirstBlood: https://github.com/Firstbloodio/token/blob/master/smart_contract/FirstBloodToken.sol
402  */
403 contract StandardToken is ERC20, BasicToken {
404 
405     mapping (address => mapping (address => uint256)) allowed;
406 
407 
408     /**
409      * @dev Transfer tokens from one address to another
410      * @param _from address The address which you want to send tokens from
411      * @param _to address The address which you want to transfer to
412      * @param _value uint256 the amount of tokens to be transferred
413      */
414     function transferFrom(address _from, address _to, uint256 _value) public returns (bool) {
415         require(_to != address(0));
416 
417         uint256 _allowance = allowed[_from][msg.sender];
418 
419         // Check is not needed because sub(_allowance, _value) will already throw if this condition is not met
420         // require (_value <= _allowance);
421 
422         balances[_from] = balances[_from].sub(_value);
423         balances[_to] = balances[_to].add(_value);
424         allowed[_from][msg.sender] = _allowance.sub(_value);
425         Transfer(_from, _to, _value);
426         return true;
427     }
428 
429     /**
430      * @dev Approve the passed address to spend the specified amount of tokens on behalf of msg.sender.
431      *
432      * Beware that changing an allowance with this method brings the risk that someone may use both the old
433      * and the new allowance by unfortunate transaction ordering. One possible solution to mitigate this
434      * race condition is to first reduce the spender's allowance to 0 and set the desired value afterwards:
435      * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
436      * @param _spender The address which will spend the funds.
437      * @param _value The amount of tokens to be spent.
438      */
439     function approve(address _spender, uint256 _value) public returns (bool) {
440         allowed[msg.sender][_spender] = _value;
441         Approval(msg.sender, _spender, _value);
442         return true;
443     }
444 
445     /**
446      * @dev Function to check the amount of tokens that an owner allowed to a spender.
447      * @param _owner address The address which owns the funds.
448      * @param _spender address The address which will spend the funds.
449      * @return A uint256 specifying the amount of tokens still available for the spender.
450      */
451     function allowance(address _owner, address _spender) public constant returns (uint256 remaining) {
452         return allowed[_owner][_spender];
453     }
454 
455     /**
456      * approve should be called when allowed[_spender] == 0. To increment
457      * allowed value is better to use this function to avoid 2 calls (and wait until
458      * the first transaction is mined)
459      * From MonolithDAO Token.sol
460      */
461     function increaseApproval(address _spender, uint _addedValue)
462         returns (bool success) {
463         allowed[msg.sender][_spender] = allowed[msg.sender][_spender].add(_addedValue);
464         Approval(msg.sender, _spender, allowed[msg.sender][_spender]);
465         return true;
466     }
467 
468     function decreaseApproval(address _spender, uint _subtractedValue)
469         returns (bool success) {
470         uint oldValue = allowed[msg.sender][_spender];
471         if (_subtractedValue > oldValue) {
472             allowed[msg.sender][_spender] = 0;
473         } else {
474             allowed[msg.sender][_spender] = oldValue.sub(_subtractedValue);
475         }
476         Approval(msg.sender, _spender, allowed[msg.sender][_spender]);
477         return true;
478     }
479 
480 }
481 
482 /**
483  * @title MintableToken
484  * @dev Simple ERC20 Token example, with mintable token creation.
485  */
486 contract MintableToken is StandardToken, Shareable {
487     event Mint(uint256 iteration, address indexed to, uint256 amount);
488 
489     // total supply limit
490     uint256 public totalSupplyLimit;
491 
492     // the number of blocks to the next supply
493     uint256 public numberOfBlocksBetweenSupplies;
494 
495     // mint is available after the block number
496     uint256 public nextSupplyAfterBlock;
497 
498     // the current iteration of the supply
499     uint256 public currentIteration = 1;
500 
501     // the amount of tokens available supply in prev iteration
502     uint256 private prevIterationSupplyLimit = 0;
503 
504     /**
505      * @dev Throws if minting are not allowed.
506      * @param _amount The amount of tokens to mint.
507      */
508     modifier canMint(uint256 _amount) {
509         // check block height
510         require(block.number >= nextSupplyAfterBlock);
511 
512         // check total supply limit
513         require(totalSupply.add(_amount) <= totalSupplyLimit);
514 
515         // check supply amount in current iteration
516         require(_amount <= currentIterationSupplyLimit());
517 
518         _;
519     }
520 
521     /**
522      * @dev Constructor
523      * @param _initialSupplyAddress The address that will recieve the initial minted tokens.
524      * @param _initialSupply The amount of tokens to initial mint.
525      * @param _firstIterationSupplyLimit The amount of token to limit first iteration.
526      * @param _totalSupplyLimit The amount of tokens to finish mint.
527      * @param _numberOfBlocksBetweenSupplies Number of blocks for the next mint.
528      * @param _additionalOwners A list of owners.
529      * @param _required The amount required for a transaction to be approved.
530      */
531     function MintableToken(
532         address _initialSupplyAddress,
533         uint256 _initialSupply,
534         uint256 _firstIterationSupplyLimit,
535         uint256 _totalSupplyLimit,
536         uint256 _numberOfBlocksBetweenSupplies,
537         address[] _additionalOwners,
538         uint256 _required
539     )
540         Shareable(_additionalOwners, _required)
541     {
542         require(_initialSupplyAddress != address(0) && _initialSupply > 0);
543 
544         prevIterationSupplyLimit = _firstIterationSupplyLimit;
545         totalSupplyLimit = _totalSupplyLimit;
546         numberOfBlocksBetweenSupplies = _numberOfBlocksBetweenSupplies;
547         nextSupplyAfterBlock = block.number.add(_numberOfBlocksBetweenSupplies);
548 
549         totalSupply = totalSupply.add(_initialSupply);
550         balances[_initialSupplyAddress] = balances[_initialSupplyAddress].add(_initialSupply);
551     }
552 
553     /**
554      * @dev Returns the limit on the supply in the current iteration.
555      */
556     function currentIterationSupplyLimit()
557         public
558         constant
559         returns (uint256 maxSupply)
560     {
561         if (currentIteration == 1) {
562             maxSupply = prevIterationSupplyLimit;
563         } else {
564             maxSupply = prevIterationSupplyLimit.mul(9881653713).div(10000000000);
565 
566             if (maxSupply > (totalSupplyLimit.sub(totalSupply))) {
567                 maxSupply = totalSupplyLimit.sub(totalSupply);
568             }
569         }
570     }
571 
572     /**
573      * @dev Function to init minting tokens
574      * @param _to The address that will recieve the minted tokens.
575      * @param _amount The amount of tokens to mint.
576      * @return A boolean that indicates if the operation was successful.
577      */
578     function mint(address _to, uint256 _amount)
579         external
580         canMint(_amount)
581         onlyManyOwners(keccak256("mint", _to, _amount))
582         returns (bool)
583     {
584         prevIterationSupplyLimit = currentIterationSupplyLimit();
585         nextSupplyAfterBlock = block.number.add(numberOfBlocksBetweenSupplies);
586 
587         totalSupply = totalSupply.add(_amount);
588         balances[_to] = balances[_to].add(_amount);
589 
590         Mint(currentIteration, _to, _amount);
591         Transfer(0x0, _to, _amount);
592 
593         currentIteration = currentIteration.add(1);
594 
595         clearPending();
596 
597         return true;
598     }
599 }
600 
601 /**
602  * @title OTN ERC20 token
603  */
604 contract OTNToken is MintableToken {
605     // token name
606     string public name = "Open Trading Network";
607 
608     // token symbol
609     string public symbol = "OTN";
610 
611     // token decimals
612     uint256 public decimals = 18;
613 
614     /**
615      * @dev Constructor
616      * @param _initialSupplyAddress The address that will recieve the initial minted tokens.
617      * @param _additionalOwners A list of owners.
618      */
619     function OTNToken(
620         address _initialSupplyAddress,
621         address[] _additionalOwners
622     )
623         MintableToken(
624             _initialSupplyAddress,
625             79000000e18,            // initial supply
626             350000e18,              // first iteration max supply
627             100000000e18,           // max supply for all time
628             100,                    // supply iteration every 100 blocks (17 sec per block)
629             _additionalOwners,      // additional owners
630             2                       // required number for a operations to be approved
631     )
632     {
633 
634     }
635 
636 }