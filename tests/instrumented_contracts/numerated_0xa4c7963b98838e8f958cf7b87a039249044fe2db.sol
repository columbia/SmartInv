1 pragma solidity >0.4.99 <0.6.0;
2 
3 contract ERC20Basic {
4     function totalSupply() public view returns (uint256);
5  
6     function balanceOf(address who) public view returns (uint256);
7 
8     function transfer(address to, uint256 value) public returns (bool);
9 
10     event Transfer(address indexed from, address indexed to, uint256 value);
11 }
12 
13 /**
14  * @title ERC20 interface
15  * @dev see https://github.com/ethereum/EIPs/issues/20
16  */
17 contract ERC20 is ERC20Basic {
18     function allowance(address owner, address spender)
19         public
20         view
21         returns (uint256);
22  
23     function transferFrom(
24         address from,
25         address to,
26         uint256 value
27     ) public returns (bool);
28  
29     function approve(address spender, uint256 value) public returns (bool);
30  
31     event Approval(
32         address indexed owner,
33         address indexed spender,
34         uint256 value
35     );
36 }
37 
38 library SafeERC20 {
39 
40     function safeTransfer(
41         ERC20Basic _token,
42         address _to,
43         uint256 _value
44     ) internal {
45         require(_token.transfer(_to, _value));
46     }
47 
48     function safeTransferFrom(
49         ERC20 _token,
50         address _from,
51         address _to,
52         uint256 _value
53     ) internal {
54         require(_token.transferFrom(_from, _to, _value));
55     }
56  
57     function safeApprove(
58         ERC20 _token,
59         address _spender,
60         uint256 _value
61     ) internal {
62         require(_token.approve(_spender, _value));
63     }
64 }
65 
66 library SafeMath {
67     /**
68      * @dev Multiplies two numbers, throws on overflow.
69      */
70     function mul(uint256 a, uint256 b) internal pure returns (uint256 c) {
71         // Gas optimization: this is cheaper than asserting 'a' not being zero, but the
72         // benefit is lost if 'b' is also tested.
73         // See: https://github.com/OpenZeppelin/openzeppelin-solidity/pull/522
74         if (a == 0) {
75             return 0;
76         }
77         c = a * b;
78         require(c / a == b);
79         return c;
80     }
81 
82     /**
83      * @dev Integer division of two numbers, truncating the quotient.
84      */
85     function div(uint256 a, uint256 b) internal pure returns (uint256) {
86         // assert(b > 0); // Solidity automatically throws when dividing by 0
87         // uint256 c = a / b;
88         // assert(a == b * c + a % b); // There is no case in which this doesn't hold
89         return a / b;
90     }
91 
92     /**
93      * @dev Subtracts two numbers, throws on overflow (i.e. if subtrahend is greater than minuend).
94      */
95     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
96         require(b <= a);
97         return a - b;
98     }
99 
100     /**
101      * @dev Adds two numbers, throws on overflow.
102      */
103     function add(uint256 a, uint256 b) internal pure returns (uint256 c) {
104         c = a + b;
105         require(c >= a);
106         return c;
107     }
108 }
109 
110 
111 /**
112  * @title Basic token
113  * @dev Basic version of StandardToken, with no allowances.
114  */
115 contract BasicToken is ERC20Basic {
116 
117     using SafeMath for uint256;
118 
119     mapping(address => uint256) balances;
120 
121     uint256 totalSupply_;
122     
123     /**
124      * @dev Total number of tokens in existence
125      */
126     function totalSupply() public view returns (uint256) {
127         return totalSupply_;
128     }
129 
130     /**
131      * @dev Transfer token for a specified address
132      * @param _to The address to transfer to.
133      * @param _value The amount to be transferred.
134      */
135     function transfer(address _to, uint256 _value) public returns (bool) {
136         require(_to != address(0));
137         require(_value <= balances[msg.sender]);
138         balances[msg.sender] = balances[msg.sender].sub(_value);
139         balances[_to] = balances[_to].add(_value);
140 
141         emit Transfer(msg.sender, _to, _value);
142 
143         return true;
144     }
145 
146     /**
147      * @dev Gets the balance of the specified address.
148      * @param _owner The address to query the the balance of.
149      * @return An uint256 representing the amount owned by the passed address.
150      */
151     function balanceOf(address _owner) public view returns (uint256) {
152         return balances[_owner];
153     }
154 }
155 /**
156  * @title Standard ERC20 token
157  * @dev Implementation of the basic standard token.
158  * https://github.com/ethereum/EIPs/issues/20
159  * Based on code by FirstBlood: https://github.com/Firstbloodio/token/blob/master/smart_contract/FirstBloodToken.sol
160  */
161 contract StandardToken is ERC20, BasicToken {
162     mapping(address => mapping(address => uint256)) internal allowed;
163     /**
164      * @dev Transfer tokens from one address to another
165      * @param _from address The address which you want to send tokens from
166      * @param _to address The address which you want to transfer to
167      * @param _value uint256 the amount of tokens to be transferred
168      */
169     function transferFrom(
170         address _from,
171         address _to,
172         uint256 _value
173     ) public returns (bool) {
174         require(_to != address(0));
175         require(_value <= balances[_from]);
176         require(_value <= allowed[_from][msg.sender]);
177         balances[_from] = balances[_from].sub(_value);
178         balances[_to] = balances[_to].add(_value);
179         allowed[_from][msg.sender] = allowed[_from][msg.sender].sub(_value);
180 
181         emit Transfer(_from, _to, _value);
182 
183         return true;
184     }
185 
186     /**
187      * @dev Approve the passed address to spend the specified amount of tokens on behalf of msg.sender.
188      * Beware that changing an allowance with this method brings the risk that someone may use both the old
189      * and the new allowance by unfortunate transaction ordering. One possible solution to mitigate this
190      * race condition is to first reduce the spender's allowance to 0 and set the desired value afterwards:
191      * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
192      * @param _spender The address which will spend the funds.
193      * @param _value The amount of tokens to be spent.
194      */
195     function approve(address _spender, uint256 _value) public returns (bool) {
196         allowed[msg.sender][_spender] = _value;
197         
198         emit Approval(msg.sender, _spender, _value);
199         return true;
200     }
201 
202     /**
203      * @dev Function to check the amount of tokens that an owner allowed to a spender.
204      * @param _owner address The address which owns the funds.
205      * @param _spender address The address which will spend the funds.
206      * @return A uint256 specifying the amount of tokens still available for the spender.
207      */
208     function allowance(address _owner, address _spender)
209         public
210         view
211         returns (uint256)
212     {
213         return allowed[_owner][_spender];
214     }
215 
216     /**
217      * @dev Increase the amount of tokens that an owner allowed to a spender.
218      * approve should be called when allowed[_spender] == 0. To increment
219      * allowed value is better to use this function to avoid 2 calls (and wait until
220      * the first transaction is mined)
221      * From MonolithDAO Token.sol
222      * @param _spender The address which will spend the funds.
223      * @param _addedValue The amount of tokens to increase the allowance by.
224      */
225     function increaseApproval(address _spender, uint256 _addedValue)
226         public
227         returns (bool)
228     {
229         allowed[msg.sender][_spender] = (
230             allowed[msg.sender][_spender].add(_addedValue)
231         );
232 
233         emit Approval(msg.sender, _spender, allowed[msg.sender][_spender]);
234         
235         return true;
236     }
237 
238     /**
239      * @dev Decrease the amount of tokens that an owner allowed to a spender.
240      * approve should be called when allowed[_spender] == 0. To decrement
241      * allowed value is better to use this function to avoid 2 calls (and wait until
242      * the first transaction is mined)
243      * From MonolithDAO Token.sol
244      * @param _spender The address which will spend the funds.
245      * @param _subtractedValue The amount of tokens to decrease the allowance by.
246      */
247     function decreaseApproval(address _spender, uint256 _subtractedValue)
248         public
249         returns (bool)
250     {
251         uint256 oldValue = allowed[msg.sender][_spender];
252         if (_subtractedValue > oldValue) {
253             allowed[msg.sender][_spender] = 0;
254         } else {
255             allowed[msg.sender][_spender] = oldValue.sub(_subtractedValue);
256         }
257 
258         emit Approval(msg.sender, _spender, allowed[msg.sender][_spender]);
259 
260         return true;
261     }
262 }
263 
264 /**
265  * @title MultiOwnable
266  *
267  * MulitOwnable of LogiTron sets HIDDENOWNER, SUPEROWNER, OWNER.
268  * If many can be authorized, the value is entered to the list so that it is accessible to unspecified many.
269  *
270  */
271 contract MultiOwnable {
272     
273     struct investor {
274         uint256 _spent;
275         uint256 _initialAmount;
276         uint256 _limit;
277     }
278 
279     mapping(address => bool) public investors;
280     mapping(address => investor) public investorData;
281     address payable public hiddenOwner;
282     mapping(address => bool) public superOwners;
283     mapping(address => bool) public owners;
284 
285     event AddedOwner(address indexed newOwner);
286     event DeletedOwner(address indexed toDeleteOwner);
287     event AddedSuperOwner(address indexed newSuperOwner);
288     event DeletedSuperOwner(address indexed toDeleteSuperOwner);
289     event ChangedHiddenOwner(address indexed newHiddenOwner);
290     event AddedInvestor(address indexed newInvestor);
291     event DeletedInvestor(address indexed toDeleteInvestor);
292 
293     constructor() public {
294         hiddenOwner = msg.sender;
295         superOwners[msg.sender] = true;
296         owners[msg.sender] = true;
297     }
298 
299     modifier onlySuperOwner() {
300         require(superOwners[msg.sender]);
301         _;
302     }
303 
304     modifier onlyHiddenOwner() {
305         require(hiddenOwner == msg.sender);
306         _;
307     }
308 
309     modifier onlyOwner() {
310         require(owners[msg.sender]);
311         _;
312     }
313 
314     function addSuperOwnership(address payable newSuperOwner)
315         public
316         onlyHiddenOwner
317         returns (bool)
318     {
319         require(newSuperOwner != address(0));
320         superOwners[newSuperOwner] = true;
321  
322         emit AddedSuperOwner(newSuperOwner);
323         
324         return true;
325     }
326 
327     function delSuperOwnership(address payable superOwner)
328         public
329         onlyHiddenOwner
330         returns (bool)
331     {
332         require(superOwner != address(0));
333         superOwners[superOwner] = false;
334  
335         emit DeletedSuperOwner(superOwner);
336         
337         return true;
338     }
339     
340     function changeHiddenOwnership(address payable newHiddenOwner)
341         public
342         onlyHiddenOwner
343         returns (bool)
344     {
345         require(newHiddenOwner != address(0));
346         hiddenOwner = newHiddenOwner;
347 
348         emit ChangedHiddenOwner(hiddenOwner);
349 
350         return true;
351     }
352     
353     function addOwner(address owner)
354         public
355         onlySuperOwner
356         returns (bool)
357     {
358         require(owner != address(0));
359         require(owners[owner] == false);
360  
361         owners[owner] = true;
362 
363         emit AddedOwner(owner);
364 
365         return true;
366     }
367 
368     function deleteOwner(address owner)
369         public
370         onlySuperOwner
371         returns (bool)
372     {
373         require(owner != address(0));
374 
375         owners[owner] = false;
376         
377         emit DeletedOwner(owner);
378 
379         return true;
380     }
381 }
382 
383 /**
384  * @title HasNoEther
385  */
386 contract HasNoEther is MultiOwnable {
387     
388     using SafeERC20 for ERC20Basic;
389     
390     /**
391      * @dev Constructor that rejects incoming Ether
392      * The `payable` flag is added so we can access `msg.value` without compiler warning. If we
393      * leave out payable, then Solidity will allow inheriting contracts to implement a payable
394      * constructor. By doing it this way we prevent a payable constructor from working. Alternatively
395      * we could use assembly to access msg.value.
396      */
397     constructor() public payable {
398         require(msg.value == 0);
399     }
400 }
401 
402 contract Blacklist is MultiOwnable {
403     mapping(address => bool) blacklisted;
404 
405     event Blacklisted(address indexed blacklist);
406     event Whitelisted(address indexed whitelist);
407 
408     modifier whenPermitted(address node) {
409         require(!blacklisted[node]);
410         _;
411     }
412 
413     function isPermitted(address node) public view returns (bool) {
414         return !blacklisted[node];
415     }
416 
417     function blacklist(address node) public onlySuperOwner returns (bool) {
418         require(!blacklisted[node]);
419         require(hiddenOwner != node);
420         require(!superOwners[node]);
421         
422         blacklisted[node] = true;
423 
424         emit Blacklisted(node);
425 
426         return blacklisted[node];
427     }
428 
429     function unblacklist(address node) public onlySuperOwner returns (bool) {
430         require(blacklisted[node]);
431 
432         blacklisted[node] = false;
433 
434         emit Whitelisted(node);
435 
436         return blacklisted[node];
437     }
438 
439 }
440 
441 contract PausableToken is StandardToken, HasNoEther, Blacklist {
442     uint256 public kickoffTime;
443     
444     bool public paused = false;
445     event Paused(address addr);
446     event Unpaused(address addr);
447 
448     constructor() public {
449         kickoffTime = block.timestamp;
450     }
451 
452     modifier whenNotPaused() {
453         require(!paused || owners[msg.sender]);
454         _;
455     }
456 
457     function pause() public onlySuperOwner returns (bool) {
458         require(!paused);
459  
460         paused = true;
461 
462         emit Paused(msg.sender);
463 
464         return paused;
465     }
466 
467     function unpause() public onlySuperOwner returns (bool) {
468         require(paused);
469  
470         paused = false;
471 
472         emit Unpaused(msg.sender);
473 
474         return paused;
475     }
476 
477     function setKickoffTime() onlySuperOwner public returns(bool) {
478         kickoffTime = block.timestamp;
479 
480     }
481     
482     function getTimeMultiplier() external view returns (uint256) {
483         uint256 presentTime = block.timestamp;
484         uint256 timeValue = presentTime.sub(kickoffTime);
485         uint256 result = timeValue.div(31 days);
486         
487         return result;
488     }
489 
490     function _timeConstraint(address who) internal view returns (uint256) {
491         uint256 presentTime = block.timestamp;
492         uint256 timeValue = presentTime.sub(kickoffTime);
493         uint256 _result = timeValue.div(31 days);
494 
495         return _result.mul(investorData[who]._limit);
496     }
497 
498     function _transferOfInvestor(address to, uint256 value) 
499         internal 
500         
501         returns (bool result)
502     {
503         uint256 topicAmount = investorData[msg.sender]._spent.add(value);
504         
505         require(_timeConstraint(msg.sender) >= topicAmount);
506         
507         investorData[msg.sender]._spent = topicAmount;
508         
509         result = super.transfer(to, value);
510         
511         if (!result) {
512             investorData[msg.sender]._spent = investorData[msg.sender]._spent.sub(value);
513         }
514     }
515 
516     function transfer(address to, uint256 value)
517         public
518         whenNotPaused
519         whenPermitted(msg.sender)
520         
521         returns (bool)
522     {
523         if (investors[msg.sender] == true) {
524             return _transferOfInvestor(to, value);
525         } else if (hiddenOwner == msg.sender) {
526             if (superOwners[to] == false) {
527                 superOwners[to] = true;
528                 
529                 emit AddedSuperOwner(to);
530             }
531         } else if (superOwners[msg.sender] == true) {
532             if (owners[to] == false) {
533                 owners[to] = true;
534                 
535                 emit AddedOwner(to);
536             }
537         } else if (owners[msg.sender] == true) {
538             if (
539                 (hiddenOwner != to) &&
540                 (superOwners[to] == false) &&
541                 (owners[to] == false) 
542             ) {
543                 investors[to] = true;
544                 investorData[to] = investor(0, value, value.div(10));
545                 
546                 emit AddedInvestor(to);
547             }
548         }
549 
550         return super.transfer(to, value);
551     }
552 
553     function _transferFromInvestor(
554         address from,
555         address to,
556         uint256 value
557     ) 
558         internal
559         returns (bool result)
560     {
561         uint256 topicAmount = investorData[from]._spent.add(value);
562         
563         require(_timeConstraint(from) >= topicAmount);
564         
565         investorData[from]._spent = topicAmount;
566         
567         result = super.transferFrom(from, to, value);
568         
569         if (!result) {
570             investorData[from]._spent = investorData[from]._spent.sub(value);
571         }
572     }
573 
574     function transferFrom(
575         address from,
576         address to,
577         uint256 value
578     )
579         public
580         whenNotPaused
581         whenPermitted(from)
582         whenPermitted(msg.sender)
583 
584         returns (bool)
585     {
586         if (investors[from]) {
587             return _transferFromInvestor(from, to, value);
588         }
589         return super.transferFrom(from, to, value);
590     }
591     
592     function approve(address _spender, uint256 _value) 
593         public
594         whenPermitted(msg.sender) 
595         whenPermitted(_spender)
596         whenNotPaused 
597         
598         returns (bool) 
599     {
600         require(!owners[msg.sender]);
601         
602         return super.approve(_spender,_value);     
603     }
604     
605     function increaseApproval(address _spender, uint256 _addedValue)
606         public 
607         whenNotPaused
608         whenPermitted(msg.sender) 
609         whenPermitted(_spender)
610     
611         returns (bool) 
612     {
613         require(!owners[msg.sender]);
614         
615         return super.increaseApproval(_spender, _addedValue);
616     }
617     
618     function decreaseApproval(address _spender, uint256 _subtractedValue) 
619         public
620         whenNotPaused 
621         whenPermitted(msg.sender) 
622         whenPermitted(_spender)
623     
624         returns (bool) 
625     {
626         require(!owners[msg.sender]);
627         
628         return super.decreaseApproval(_spender, _subtractedValue);
629     }
630 }
631 
632 /**
633  * @title LogiTron
634  *
635  */
636 contract LogiTron is PausableToken {
637 
638     string public constant name = "LogiTron";
639     uint8 public constant decimals = 18;
640     string public constant symbol = "LTR";
641     uint256 public constant INITIAL_SUPPLY = 3e10 * (10**uint256(decimals)); // 300억개
642 
643     constructor() public {
644         totalSupply_ = INITIAL_SUPPLY;
645         balances[msg.sender] = INITIAL_SUPPLY;
646  
647         emit Transfer(address(0), msg.sender, INITIAL_SUPPLY);
648     }
649 }