1 pragma solidity 0.4.18;
2 
3 /**
4  * @title ReceivingContract Interface
5  * @dev ReceivingContract handle incoming token transfers.
6  */
7 contract ReceivingContract {
8 
9     /**
10      * @dev Handle incoming token transfers.
11      * @param _from The token sender address.
12      * @param _value The amount of tokens.
13      */
14     function tokenFallback(address _from, uint _value) public;
15 
16 }
17 
18 /**
19  * @title SafeMath
20  * @dev Math operations with safety checks that throw on error
21  */
22 library SafeMath {
23 
24     /**
25      * @dev Multiplies two numbers, throws on overflow.
26      */
27     function mul(uint _a, uint _b)
28         internal
29         pure
30         returns (uint)
31     {
32         if (_a == 0) {
33             return 0;
34         }
35     
36         uint c = _a * _b;
37         assert(c / _a == _b);
38         return c;
39     }
40 
41     /**
42      * @dev Integer division of two numbers, truncating the quotient.
43      */
44     function div(uint _a, uint _b)
45         internal
46         pure
47         returns (uint)
48     {
49         // Solidity automatically throws when dividing by 0
50         uint c = _a / _b;
51         return c;
52     }
53 
54     /**
55      * @dev Substracts two numbers, throws on overflow (i.e. if subtrahend is greater than minuend).
56      */
57     function sub(uint _a, uint _b)
58         internal
59         pure
60         returns (uint)
61     {
62         assert(_b <= _a);
63         return _a - _b;
64     }
65 
66     /**
67      * @dev Adds two numbers, throws on overflow.
68      */
69     function add(uint _a, uint _b)
70         internal
71         pure
72         returns (uint)
73     {
74         uint c = _a + _b;
75         assert(c >= _a);
76         return c;
77     }
78 
79 }
80 
81 /**
82  * @title Ownable
83  * @dev The Ownable contract has an owner address, and provides basic authorization control
84  * functions, this simplifies the implementation of "user permissions".
85  */
86 contract Ownable {
87 
88     address public owner;
89 
90     /**
91      * Events
92      */
93     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
94 
95     /**
96      * @dev Throws if called by any account other than the owner.
97      */
98     modifier onlyOwner() {
99         require(msg.sender == owner);
100         _;
101     }
102 
103     /**
104      * @dev Constructor
105      * Sets the original `owner` of the contract to the sender account.
106      */
107     function Ownable() public {
108         owner = msg.sender;
109         OwnershipTransferred(0, owner);
110     }
111 
112     /**
113      * @dev Allows the current owner to transfer control of the contract to a new owner.
114      * @param _newOwner The address to transfer ownership to.
115      */
116     function transferOwnership(address _newOwner)
117         public
118         onlyOwner
119     {
120         require(_newOwner != 0);
121 
122         OwnershipTransferred(owner, _newOwner);
123         owner = _newOwner;
124     }
125 
126 }
127 
128 /**
129  * @title Standard ERC20 token
130  */
131 contract StandardToken is Ownable {
132 
133     using SafeMath for uint;
134 
135     string public name;
136     string public symbol;
137     uint8 public decimals;
138 
139     uint public totalSupply;
140     mapping(address => uint) public balanceOf;
141     mapping(address => mapping(address => uint)) internal allowed;
142 
143     /**
144      * Events
145      */
146     event ChangeTokenInformation(string name, string symbol);
147     event Transfer(address indexed from, address indexed to, uint value);
148     event Approval(address indexed owner, address indexed spender, uint value);
149 
150     /**
151      * Owner can update token information here.
152      *
153      * It is often useful to conceal the actual token association, until
154      * the token operations, like central issuance or reissuance have been completed.
155      *
156      * This function allows the token owner to rename the token after the operations
157      * have been completed and then point the audience to use the token contract.
158      */
159     function changeTokenInformation(string _name, string _symbol)
160         public
161         onlyOwner
162     {
163         name = _name;
164         symbol = _symbol;
165         ChangeTokenInformation(_name, _symbol);
166     }
167 
168     /**
169      * @dev Transfer token for a specified address
170      * @param _to The address to transfer to.
171      * @param _value The amount to be transferred.
172      */
173     function transfer(address _to, uint _value)
174         public
175         returns (bool)
176     {
177         require(_to != 0);
178         require(_value > 0);
179 
180         balanceOf[msg.sender] = balanceOf[msg.sender].sub(_value);
181         balanceOf[_to] = balanceOf[_to].add(_value);
182         Transfer(msg.sender, _to, _value);
183         return true;
184     }
185 
186     /**
187      * @dev Transfer tokens from one address to another
188      * @param _from The address which you want to send tokens from
189      * @param _to The address which you want to transfer to
190      * @param _value The amount of tokens to be transferred
191      */
192     function transferFrom(address _from, address _to, uint _value)
193         public
194         returns (bool)
195     {
196         require(_to != 0);
197         require(_value > 0);
198 
199         balanceOf[_from] = balanceOf[_from].sub(_value);
200         balanceOf[_to] = balanceOf[_to].add(_value);
201         allowed[_from][msg.sender] = allowed[_from][msg.sender].sub(_value);
202         Transfer(_from, _to, _value);
203         return true;
204     }
205 
206     /**
207      * @dev Approve the passed address to spend the specified amount of tokens on behalf of msg.sender.
208      *
209      * Beware that changing an allowance with this method brings the risk that someone may use both the old
210      * and the new allowance by unfortunate transaction ordering. One possible solution to mitigate this
211      * race condition is to first reduce the spender's allowance to 0 and set the desired value afterwards:
212      * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
213      *
214      * @param _spender The address which will spend the funds.
215      * @param _value The amount of tokens to be spent.
216      */
217     function approve(address _spender, uint _value)
218         public
219         returns (bool)
220     {
221         allowed[msg.sender][_spender] = _value;
222         Approval(msg.sender, _spender, _value);
223         return true;
224     }
225 
226     /**
227      * @dev Increase the amount of tokens that an owner allowed to a spender.
228      *
229      * approve should be called when allowed[_spender] == 0. To increment
230      * allowed value is better to use this function to avoid 2 calls (and wait until
231      * the first transaction is mined)
232      *
233      * @param _spender The address which will spend the funds.
234      * @param _addedValue The amount of tokens to increase the allowance by.
235      */
236     function increaseApproval(address _spender, uint _addedValue)
237         public
238         returns (bool)
239     {
240         require(_addedValue > 0);
241 
242         allowed[msg.sender][_spender] = allowed[msg.sender][_spender].add(_addedValue);
243         Approval(msg.sender, _spender, allowed[msg.sender][_spender]);
244         return true;
245     }
246 
247     /**
248      * @dev Decrease the amount of tokens that an owner allowed to a spender.
249      *
250      * approve should be called when allowed[_spender] == 0. To decrement
251      * allowed value is better to use this function to avoid 2 calls (and wait until
252      * the first transaction is mined)
253      *
254      * @param _spender The address which will spend the funds.
255      * @param _subtractedValue The amount of tokens to decrease the allowance by.
256      */
257     function decreaseApproval(address _spender, uint _subtractedValue)
258         public
259         returns (bool)
260     {
261         require(_subtractedValue > 0);
262 
263         uint oldValue = allowed[msg.sender][_spender];
264 
265         if (_subtractedValue > oldValue) {
266             allowed[msg.sender][_spender] = 0;
267 
268         } else {
269             allowed[msg.sender][_spender] = oldValue.sub(_subtractedValue);
270         }
271 
272         Approval(msg.sender, _spender, allowed[msg.sender][_spender]);
273         return true;
274     }
275 
276     /**
277      * @dev Function to check the amount of tokens that an owner allowed to a spender.
278      * @param _owner The address which owns the funds.
279      * @param _spender The address which will spend the funds.
280      * @return A uint specifying the amount of tokens still available for the spender.
281      */
282     function allowance(address _owner, address _spender)
283         public
284         view
285         returns (uint)
286     {
287         return allowed[_owner][_spender];
288     }
289 
290 }
291 
292 /**
293  * @title Pausable token
294  * @dev Token that can be freeze "Transfer" function
295  */
296 contract PausableToken is StandardToken {
297 
298     bool public isTradable = true;
299 
300     /**
301      * Events
302      */
303     event FreezeTransfer();
304     event UnfreezeTransfer();
305 
306     modifier canTransfer() {
307         require(isTradable);
308         _;
309     }
310 
311     /**
312      * Disallow to transfer token from an address to other address
313      */
314     function freezeTransfer()
315         public
316         onlyOwner
317     {
318         isTradable = false;
319         FreezeTransfer();
320     }
321 
322     /**
323      * Allow to transfer token from an address to other address
324      */
325     function unfreezeTransfer()
326         public
327         onlyOwner
328     {
329         isTradable = true;
330         UnfreezeTransfer();
331     }
332 
333     /**
334      * @dev Transfer token for a specified address
335      * @param _to The address to transfer to.
336      * @param _value The amount to be transferred.
337      */
338     function transfer(address _to, uint _value)
339         public
340         canTransfer
341         returns (bool)
342     {
343         return super.transfer(_to, _value);
344     }
345 
346     /**
347      * @dev Transfer tokens from one address to another
348      * @param _from The address which you want to send tokens from
349      * @param _to The address which you want to transfer to
350      * @param _value The amount of tokens to be transferred
351      */
352     function transferFrom(address _from, address _to, uint _value)
353         public
354         canTransfer
355         returns (bool)
356     {
357         return super.transferFrom(_from, _to, _value);
358     }
359 
360     /**
361      * @dev Approve the passed address to spend the specified amount of tokens on behalf of msg.sender.
362      *
363      * Beware that changing an allowance with this method brings the risk that someone may use both the old
364      * and the new allowance by unfortunate transaction ordering. One possible solution to mitigate this
365      * race condition is to first reduce the spender's allowance to 0 and set the desired value afterwards:
366      * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
367      *
368      * @param _spender The address which will spend the funds.
369      * @param _value The amount of tokens to be spent.
370      */
371     function approve(address _spender, uint _value)
372         public
373         canTransfer
374         returns (bool)
375     {
376         return super.approve(_spender, _value);
377     }
378 
379     /**
380      * @dev Increase the amount of tokens that an owner allowed to a spender.
381      *
382      * approve should be called when allowed[_spender] == 0. To increment
383      * allowed value is better to use this function to avoid 2 calls (and wait until
384      * the first transaction is mined)
385      *
386      * @param _spender The address which will spend the funds.
387      * @param _addedValue The amount of tokens to increase the allowance by.
388      */
389     function increaseApproval(address _spender, uint _addedValue)
390         public
391         canTransfer
392         returns (bool)
393     {
394         return super.increaseApproval(_spender, _addedValue);
395     }
396 
397     /**
398      * @dev Decrease the amount of tokens that an owner allowed to a spender.
399      *
400      * approve should be called when allowed[_spender] == 0. To decrement
401      * allowed value is better to use this function to avoid 2 calls (and wait until
402      * the first transaction is mined)
403      *
404      * @param _spender The address which will spend the funds.
405      * @param _subtractedValue The amount of tokens to decrease the allowance by.
406      */
407     function decreaseApproval(address _spender, uint _subtractedValue)
408         public
409         canTransfer
410         returns (bool)
411     {
412         return super.decreaseApproval(_spender, _subtractedValue);
413     }
414 
415 }
416 
417 /**
418  * @title UpgradeAgent Interface
419  * @dev Upgrade agent transfers tokens to a new contract. Upgrade agent itself can be the
420  * token contract, or just a middle man contract doing the heavy lifting.
421  */
422 contract UpgradeAgent {
423 
424     bool public isUpgradeAgent = true;
425 
426     function upgradeFrom(address _from, uint _value) public;
427 
428 }
429 
430 /**
431  * @title Upgradable token
432  */
433 contract UpgradableToken is StandardToken {
434 
435     address public upgradeMaster;
436 
437     // The next contract where the tokens will be migrated.
438     UpgradeAgent public upgradeAgent;
439 
440     bool public isUpgradable = false;
441 
442     // How many tokens we have upgraded by now.
443     uint public totalUpgraded;
444 
445     /**
446      * Events
447      */
448     event ChangeUpgradeMaster(address newMaster);
449     event ChangeUpgradeAgent(address newAgent);
450     event FreezeUpgrade();
451     event UnfreezeUpgrade();
452     event Upgrade(address indexed from, address indexed to, uint value);
453 
454     modifier onlyUpgradeMaster() {
455         require(msg.sender == upgradeMaster);
456         _;
457     }
458 
459     modifier canUpgrade() {
460         require(isUpgradable);
461         _;
462     }
463 
464     /**
465      * Change the upgrade master.
466      * @param _newMaster New upgrade master.
467      */
468     function changeUpgradeMaster(address _newMaster)
469         public
470         onlyOwner
471     {
472         require(_newMaster != 0);
473 
474         upgradeMaster = _newMaster;
475         ChangeUpgradeMaster(_newMaster);
476     }
477 
478     /**
479      * Change the upgrade agent.
480      * @param _newAgent New upgrade agent.
481      */
482     function changeUpgradeAgent(address _newAgent)
483         public
484         onlyOwner
485     {
486         require(totalUpgraded == 0);
487 
488         upgradeAgent = UpgradeAgent(_newAgent);
489 
490         require(upgradeAgent.isUpgradeAgent());
491 
492         ChangeUpgradeAgent(_newAgent);
493     }
494 
495     /**
496      * Disallow to upgrade token to new smart contract
497      */
498     function freezeUpgrade()
499         public
500         onlyOwner
501     {
502         isUpgradable = false;
503         FreezeUpgrade();
504     }
505 
506     /**
507      * Allow to upgrade token to new smart contract
508      */
509     function unfreezeUpgrade()
510         public
511         onlyOwner
512     {
513         isUpgradable = true;
514         UnfreezeUpgrade();
515     }
516 
517     /**
518      * Token holder upgrade their tokens to a new smart contract.
519      */
520     function upgrade()
521         public
522         canUpgrade
523     {
524         uint amount = balanceOf[msg.sender];
525 
526         require(amount > 0);
527 
528         processUpgrade(msg.sender, amount);
529     }
530 
531     /**
532      * Upgrader upgrade tokens of holder to a new smart contract.
533      * @param _holders List of token holder.
534      */
535     function forceUpgrade(address[] _holders)
536         public
537         onlyUpgradeMaster
538         canUpgrade
539     {
540         uint amount;
541 
542         for (uint i = 0; i < _holders.length; i++) {
543             amount = balanceOf[_holders[i]];
544 
545             if (amount == 0) {
546                 continue;
547             }
548 
549             processUpgrade(_holders[i], amount);
550         }
551     }
552 
553     function processUpgrade(address _holder, uint _amount)
554         private
555     {
556         balanceOf[_holder] = balanceOf[_holder].sub(_amount);
557 
558         // Take tokens out from circulation
559         totalSupply = totalSupply.sub(_amount);
560         totalUpgraded = totalUpgraded.add(_amount);
561 
562         // Upgrade agent reissues the tokens
563         upgradeAgent.upgradeFrom(_holder, _amount);
564         Upgrade(_holder, upgradeAgent, _amount);
565     }
566 
567 }
568 
569 /**
570  * @title QNTU 1.0 token
571  */
572 contract QNTU is UpgradableToken, PausableToken {
573 
574     /**
575      * @dev Constructor
576      */
577     function QNTU(address[] _wallets, uint[] _amount)
578         public
579     {
580         require(_wallets.length == _amount.length);
581 
582         symbol = "QNTU";
583         name = "QNTU Token";
584         decimals = 18;
585 
586         uint num = 0;
587         uint length = _wallets.length;
588         uint multiplier = 10 ** uint(decimals);
589 
590         for (uint i = 0; i < length; i++) {
591             num = _amount[i] * multiplier;
592 
593             balanceOf[_wallets[i]] = num;
594             Transfer(0, _wallets[i], num);
595 
596             totalSupply += num;
597         }
598     }
599 
600     /**
601      * @dev Transfer token for a specified contract
602      * @param _to The address to transfer to.
603      * @param _value The amount to be transferred.
604      */
605     function transferToContract(address _to, uint _value)
606         public
607         canTransfer
608         returns (bool)
609     {
610         require(_value > 0);
611 
612         balanceOf[msg.sender] = balanceOf[msg.sender].sub(_value);
613         balanceOf[_to] = balanceOf[_to].add(_value);
614 
615         ReceivingContract receiver = ReceivingContract(_to);
616         receiver.tokenFallback(msg.sender, _value);
617 
618         Transfer(msg.sender, _to, _value);
619         return true;
620     }
621 
622 }