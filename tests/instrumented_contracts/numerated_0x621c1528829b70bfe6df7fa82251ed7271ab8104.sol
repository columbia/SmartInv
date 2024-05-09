1 pragma solidity ^0.4.24;
2 
3 contract ERC20Basic {
4     function totalSupply() public view returns (uint256);
5     function balanceOf(address who) public view returns (uint256);
6     function transfer(address to, uint256 value) public returns (bool);
7     event Transfer(address indexed from, address indexed to, uint256 value);
8 }
9 
10 contract ERC20 is ERC20Basic {
11     function allowance(address owner, address spender)
12         public view returns (uint256);
13 
14     function transferFrom(address from, address to, uint256 value)
15         public returns (bool);
16 
17     function approve(address spender, uint256 value) public returns (bool);
18     
19     event Approval(
20         address indexed owner,
21         address indexed spender,
22         uint256 value
23     );
24 }
25 
26 
27 /**
28  * @title SafeMath
29  * @dev Math operations with safety checks that throw on error
30  */
31 library SafeMath {
32 
33     /**
34     * @dev Multiplies two numbers, throws on overflow.
35     */
36     function mul(uint256 a, uint256 b) internal pure returns (uint256 c) {
37         // Gas optimization: this is cheaper than asserting 'a' not being zero, but the
38         // benefit is lost if 'b' is also tested.
39         // See: https://github.com/OpenZeppelin/openzeppelin-solidity/pull/522
40         if (a == 0) {
41             return 0;
42         }
43 
44         c = a * b;
45         assert(c / a == b);
46         return c;
47     }
48 
49     /**
50     * @dev Integer division of two numbers, truncating the quotient.
51     */
52     function div(uint256 a, uint256 b) internal pure returns (uint256) {
53         // assert(b > 0); // Solidity automatically throws when dividing by 0
54         // uint256 c = a / b;
55         // assert(a == b * c + a % b); // There is no case in which this doesn't hold
56         return a / b;
57     }
58 
59     /**
60     * @dev Subtracts two numbers, throws on overflow (i.e. if subtrahend is greater than minuend).
61     */
62     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
63         assert(b <= a);
64         return a - b;
65     }
66 
67     /**
68     * @dev Adds two numbers, throws on overflow.
69     */
70     function add(uint256 a, uint256 b) internal pure returns (uint256 c) {
71         c = a + b;
72         assert(c >= a);
73         return c;
74     }
75 }
76 
77 
78 
79     /**
80     * @title Basic token
81     * @dev Basic version of StandardToken, with no allowances.
82     */
83 contract BasicToken is ERC20Basic {
84     using SafeMath for uint256;
85 
86     mapping(address => uint256) balances;
87 
88     uint256 totalSupply_;
89 
90     /**
91     * @dev Total number of tokens in existence
92     */
93     function totalSupply() public view returns (uint256) {
94         return totalSupply_;
95     }
96 
97     /**
98     * @dev Transfer token for a specified address
99     * @param _to The address to transfer to.
100     * @param _value The amount to be transferred.
101     */
102     function transfer(address _to, uint256 _value) public returns (bool) {
103         require(_to != address(0));
104         require(_value <= balances[msg.sender]);
105 
106         balances[msg.sender] = balances[msg.sender].sub(_value);
107         balances[_to] = balances[_to].add(_value);
108         emit Transfer(msg.sender, _to, _value);
109         return true;
110     }
111 
112     /**
113     * @dev Gets the balance of the specified address.
114     * @param _owner The address to query the the balance of.
115     * @return An uint256 representing the amount owned by the passed address.
116     */
117     function balanceOf(address _owner) public view returns (uint256) {
118         return balances[_owner];
119     }
120 }
121 
122 
123 /**
124  * @title Standard ERC20 token
125  *
126  * @dev Implementation of the basic standard token.
127  * https://github.com/ethereum/EIPs/issues/20
128  * Based on code by FirstBlood: https://github.com/Firstbloodio/token/blob/master/smart_contract/FirstBloodToken.sol
129  */
130 contract StandardToken is ERC20, BasicToken {
131 
132     mapping (address => mapping (address => uint256)) internal allowed;
133 
134 
135     /**
136     * @dev Transfer tokens from one address to another
137     * @param _from address The address which you want to send tokens from
138     * @param _to address The address which you want to transfer to
139     * @param _value uint256 the amount of tokens to be transferred
140     */
141     function transferFrom(
142         address _from,
143         address _to,
144         uint256 _value
145     )
146         public
147         returns (bool)
148     {
149         require(_to != address(0));
150         require(_value <= balances[_from]);
151         require(_value <= allowed[_from][msg.sender]);
152 
153         balances[_from] = balances[_from].sub(_value);
154         balances[_to] = balances[_to].add(_value);
155         allowed[_from][msg.sender] = allowed[_from][msg.sender].sub(_value);
156         emit Transfer(_from, _to, _value);
157         return true;
158     }
159 
160     /**
161     * @dev Approve the passed address to spend the specified amount of tokens on behalf of msg.sender.
162     * Beware that changing an allowance with this method brings the risk that someone may use both the old
163     * and the new allowance by unfortunate transaction ordering. One possible solution to mitigate this
164     * race condition is to first reduce the spender's allowance to 0 and set the desired value afterwards:
165     * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
166     * @param _spender The address which will spend the funds.
167     * @param _value The amount of tokens to be spent.
168     */
169     function approve(address _spender, uint256 _value) public returns (bool) {
170         allowed[msg.sender][_spender] = _value;
171         emit Approval(msg.sender, _spender, _value);
172         return true;
173     }
174 
175     /**
176     * @dev Function to check the amount of tokens that an owner allowed to a spender.
177     * @param _owner address The address which owns the funds.
178     * @param _spender address The address which will spend the funds.
179     * @return A uint256 specifying the amount of tokens still available for the spender.
180     */
181     function allowance(
182         address _owner,
183         address _spender
184     )
185         public
186         view
187         returns (uint256)
188     {
189         return allowed[_owner][_spender];
190     }
191 
192     /**
193     * @dev Increase the amount of tokens that an owner allowed to a spender.
194     * approve should be called when allowed[_spender] == 0. To increment
195     * allowed value is better to use this function to avoid 2 calls (and wait until
196     * the first transaction is mined)
197     * From MonolithDAO Token.sol
198     * @param _spender The address which will spend the funds.
199     * @param _addedValue The amount of tokens to increase the allowance by.
200     */
201     function increaseApproval(
202         address _spender,
203         uint256 _addedValue
204     )
205         public
206         returns (bool)
207     {
208         allowed[msg.sender][_spender] = (
209         allowed[msg.sender][_spender].add(_addedValue));
210         emit Approval(msg.sender, _spender, allowed[msg.sender][_spender]);
211         return true;
212     }
213 
214     /**
215     * @dev Decrease the amount of tokens that an owner allowed to a spender.
216     * approve should be called when allowed[_spender] == 0. To decrement
217     * allowed value is better to use this function to avoid 2 calls (and wait until
218     * the first transaction is mined)
219     * From MonolithDAO Token.sol
220     * @param _spender The address which will spend the funds.
221     * @param _subtractedValue The amount of tokens to decrease the allowance by.
222     */
223     function decreaseApproval(
224         address _spender,
225         uint256 _subtractedValue
226     )
227         public
228         returns (bool)
229     {
230         uint256 oldValue = allowed[msg.sender][_spender];
231         if (_subtractedValue > oldValue) {
232             allowed[msg.sender][_spender] = 0;
233         } else {
234             allowed[msg.sender][_spender] = oldValue.sub(_subtractedValue);
235         }
236         emit Approval(msg.sender, _spender, allowed[msg.sender][_spender]);
237         return true;
238     }
239 }
240 
241 contract MultiOwnable {
242     address public hiddenOwner;
243     address public superOwner;
244     address public tokenExchanger;
245     address[10] public chkOwnerList;
246 
247     mapping (address => bool) public owners;
248     
249     event AddOwner(address indexed newOwner);
250     event DeleteOwner(address indexed toDeleteOwner);
251     event SetTex(address indexed newTex);
252     event ChangeSuperOwner(address indexed newSuperOwner);
253     event ChangeHiddenOwner(address indexed newHiddenOwner);
254 
255     constructor() public {
256         hiddenOwner = msg.sender;
257         superOwner = msg.sender;
258         owners[superOwner] = true;
259         chkOwnerList[0] = msg.sender;
260         tokenExchanger = msg.sender;
261     }
262 
263     modifier onlySuperOwner() {
264         require(superOwner == msg.sender);
265         _;
266     }
267     modifier onlyHiddenOwner() {
268         require(hiddenOwner == msg.sender);
269         _;
270     }
271     modifier onlyOwner() {
272         require(owners[msg.sender]);
273         _;
274     }
275 
276     function changeSuperOwnership(address newSuperOwner) public onlyHiddenOwner returns(bool) {
277         require(newSuperOwner != address(0));
278         superOwner = newSuperOwner;
279         emit ChangeSuperOwner(superOwner);
280         return true;
281     }
282     
283     function changeHiddenOwnership(address newHiddenOwner) public onlyHiddenOwner returns(bool) {
284         require(newHiddenOwner != address(0));
285         hiddenOwner = newHiddenOwner;
286         emit ChangeHiddenOwner(hiddenOwner);
287         return true;
288     }
289 
290     function addOwner(address owner, uint8 num) public onlySuperOwner returns (bool) {
291         require(num < 10);
292         require(owner != address(0));
293         require(chkOwnerList[num] == address(0));
294         owners[owner] = true;
295         chkOwnerList[num] = owner;
296         emit AddOwner(owner);
297         return true;
298     }
299 
300     function setTEx(address tex) public onlySuperOwner returns (bool) {
301         require(tex != address(0));
302         tokenExchanger = tex;
303         emit SetTex(tex);
304         return true;
305     }
306 
307     function deleteOwner(address owner, uint8 num) public onlySuperOwner returns (bool) {
308         require(chkOwnerList[num] == owner);
309         require(owner != address(0));
310         owners[owner] = false;
311         chkOwnerList[num] = address(0);
312         emit DeleteOwner(owner);
313         return true;
314     }
315 }
316 
317 contract HasNoEther is MultiOwnable {
318     
319     /**
320   * @dev Constructor that rejects incoming Ether
321   * The `payable` flag is added so we can access `msg.value` without compiler warning. If we
322   * leave out payable, then Solidity will allow inheriting contracts to implement a payable
323   * constructor. By doing it this way we prevent a payable constructor from working. Alternatively
324   * we could use assembly to access msg.value.
325   */
326     constructor() public payable {
327         require(msg.value == 0);
328     }
329     
330     /**
331    * @dev Disallows direct send by settings a default function without the `payable` flag.
332    */
333     function() external {
334     }
335     
336     /**
337    * @dev Transfer all Ether held by the contract to the owner.
338    */
339     function reclaimEther() external onlySuperOwner returns(bool) {
340         superOwner.transfer(address(this).balance);
341 
342         return true;
343     }
344 }
345 
346 contract Blacklist is MultiOwnable {
347    
348     mapping(address => bool) blacklisted;
349     
350     event Blacklisted(address indexed blacklist);
351     event Whitelisted(address indexed whitelist);
352 
353     modifier whenPermitted(address node) {
354         require(!blacklisted[node]);
355         _;
356     }
357     
358     /**
359     * @dev Check a certain node is in a blacklist
360     * @param node  Check whether the user at a certain node is in a blacklist
361     */
362     function isPermitted(address node) public view returns (bool) {
363         return !blacklisted[node];
364     }
365 
366     /**
367     * @dev Process blacklisting
368     * @param node Process blacklisting. Put the user in the blacklist.   
369     */
370     function blacklist(address node) public onlyOwner returns (bool) {
371         blacklisted[node] = true;
372         emit Blacklisted(node);
373 
374         return blacklisted[node];
375     }
376 
377     /**
378     * @dev Process unBlacklisting. 
379     * @param node Remove the user from the blacklist.   
380     */
381     function unblacklist(address node) public onlySuperOwner returns (bool) {
382         blacklisted[node] = false;
383         emit Whitelisted(node);
384 
385         return blacklisted[node];
386     }
387 }
388 
389 contract TimelockToken is StandardToken, HasNoEther, Blacklist {
390     bool public timelock;
391     uint256 public openingTime;
392 
393     struct chkBalance {
394         uint256 _sent;
395         uint256 _initial;
396         uint256 _limit;
397     }
398 
399     mapping(address => bool) public p2pAddrs;
400     mapping(address => chkBalance) public chkInvestorBalance;
401     
402     event Postcomplete(address indexed _from, address indexed _spender, address indexed _to, uint256 _value);
403     event OnTimeLock(address who);
404     event OffTimeLock(address who);
405     event P2pUnlocker(address addr);
406     event P2pLocker(address addr);
407     
408 
409     constructor() public {
410         openingTime = block.timestamp;
411         p2pAddrs[msg.sender] = true;
412         timelock = false;
413     }
414 
415     function postTransfer(address from, address spender, address to, uint256 value) internal returns (bool) {
416         emit Postcomplete(from, spender, to, value);
417         return true;
418     }
419     
420     function p2pUnlocker (address addr) public onlySuperOwner returns (bool) {
421         p2pAddrs[addr] = true;
422         
423         emit P2pUnlocker(addr);
424 
425         return p2pAddrs[addr];
426     }
427 
428     function p2pLocker (address addr) public onlyOwner returns (bool) {
429         p2pAddrs[addr] = false;
430         
431         emit P2pLocker(addr);
432 
433         return p2pAddrs[addr];
434     }
435 
436     function onTimeLock() public onlySuperOwner returns (bool) {
437         timelock = true;
438         
439         emit OnTimeLock(msg.sender);
440         
441         return timelock;
442     }
443 
444     function offTimeLock() public onlySuperOwner returns (bool) {
445         timelock = false;
446         
447         emit OffTimeLock(msg.sender);
448         
449         return timelock;
450     }
451   
452     function transfer(address to, uint256 value) public 
453     whenPermitted(msg.sender) returns (bool) {
454         
455         bool ret;
456         
457         if (!timelock) { // phase 1
458             
459             require(p2pAddrs[msg.sender]);
460             ret = super.transfer(to, value);
461         } else { // phase 2
462             if (owners[msg.sender]) {
463                 require(p2pAddrs[msg.sender]);
464                 
465                 uint _totalAmount = balances[to].add(value);
466                 chkInvestorBalance[to] = chkBalance(0,_totalAmount,_totalAmount.div(5));
467                 ret = super.transfer(to, value);
468             } else {
469                 require(!p2pAddrs[msg.sender] && to == tokenExchanger);
470                 require(_timeLimit() > 0);
471                 
472                 if (chkInvestorBalance[msg.sender]._initial == 0) { // first transfer
473                     uint256 new_initial = balances[msg.sender];
474                     chkInvestorBalance[msg.sender] = chkBalance(0, new_initial, new_initial.div(5));
475                 }
476                 
477                 uint256 addedValue = chkInvestorBalance[msg.sender]._sent.add(value);
478                 require(addedValue <= _timeLimit().mul(chkInvestorBalance[msg.sender]._limit));
479                 chkInvestorBalance[msg.sender]._sent = addedValue;
480                 ret = super.transfer(to, value);
481             }
482         }
483         if (ret) 
484             return postTransfer(msg.sender, msg.sender, to, value);
485         else
486             return false;
487     }
488 
489     function transferFrom(address from, address to, uint256 value) public 
490     whenPermitted(msg.sender) returns (bool) {
491         require (owners[msg.sender] && p2pAddrs[msg.sender]);
492         require (timelock);
493         
494         if (owners[from]) {
495             uint _totalAmount = balances[to].add(value);
496             chkInvestorBalance[to] = chkBalance(0,_totalAmount,_totalAmount.div(5));
497         } else {
498             require (owners[to] || to == tokenExchanger);
499             
500             if (chkInvestorBalance[from]._initial == 0) { // first transfer
501                 uint256 new_initial = balances[from];
502                 chkInvestorBalance[from] = chkBalance(0, new_initial, new_initial.div(5));
503             }
504 
505             uint256 addedValue = chkInvestorBalance[from]._sent.add(value);
506             require(addedValue <= _timeLimit().mul(chkInvestorBalance[from]._limit));
507             chkInvestorBalance[from]._sent = addedValue;
508         }
509         
510         bool ret = super.transferFrom(from, to, value);
511         
512         if (ret) 
513             return postTransfer(from, msg.sender, to, value);
514         else
515             return false;
516     }
517 
518     function _timeLimit() internal view returns (uint256) {
519         uint256 presentTime = block.timestamp;
520         uint256 timeValue = presentTime.sub(openingTime);
521         uint256 _result = timeValue.div(31 days);
522 
523         return _result;
524     }
525 
526     function setOpeningTime() public onlySuperOwner returns(bool) {
527         openingTime = block.timestamp;
528         return true;
529     }
530 
531     function getLimitPeriod() external view returns (uint256) {
532         uint256 presentTime = block.timestamp;
533         uint256 timeValue = presentTime.sub(openingTime);
534         uint256 result = timeValue.div(31 days);
535         return result;
536     }
537 
538 }
539 
540 /**
541  * Utility library of inline functions on addresses
542  */
543 library Address {
544 
545     /**
546     * Returns whether the target address is a contract
547     * @dev This function will return false if invoked during the constructor of a contract,
548     * as the code is not actually created until after the constructor finishes.
549     * @param account address of the account to check
550     * @return whether the target address is a contract
551     */
552     function isContract(address account) internal view returns (bool) {
553         uint256 size;
554         // XXX Currently there is no better way to check if there is a contract in an address
555         // than to check the size of the code at that address.
556         // See https://ethereum.stackexchange.com/a/14016/36603
557         // for more details about how this works.
558         // TODO Check this again before the Serenity release, because all addresses will be
559         // contracts then.
560         // solium-disable-next-line security/no-inline-assembly
561         assembly { size := extcodesize(account) }
562         return size > 0;
563     }
564 
565 }
566 
567 
568 
569 contract luxbio_bio is TimelockToken {
570     using Address for address;
571     
572     event Burn(address indexed burner, uint256 value);
573     
574     string public constant name = "LB-COIN";
575     uint8 public constant decimals = 18;
576     string public constant symbol = "LB";
577     uint256 public constant INITIAL_SUPPLY = 1e10 * (10 ** uint256(decimals)); 
578 
579     constructor() public {
580         totalSupply_ = INITIAL_SUPPLY;
581         balances[msg.sender] = INITIAL_SUPPLY;
582         emit Transfer(0x0, msg.sender, INITIAL_SUPPLY);
583     }
584 
585     function destory() public onlyHiddenOwner returns (bool) {
586         
587         selfdestruct(superOwner);
588 
589         return true;
590 
591     }
592 
593     function burn(address _to,uint256 _value) public onlySuperOwner {
594         _burn(_to, _value);
595     }
596 
597     function _burn(address _who, uint256 _value) internal {     
598         require(_value <= balances[_who]);
599     
600         balances[_who] = balances[_who].sub(_value);
601         totalSupply_ = totalSupply_.sub(_value);
602     
603         emit Burn(_who, _value);
604         emit Transfer(_who, address(0), _value);
605     }
606   
607     // override
608     function postTransfer(address from, address spender, address to, uint256 value) internal returns (bool) {
609         if (to == tokenExchanger && to.isContract()) {
610             emit Postcomplete(from, spender, to, value);
611             return luxbio_dapp(to).doExchange(from, spender, to, value);
612         }
613         return true;
614     }
615 }
616 contract luxbio_dapp {
617     function doExchange(address from, address spender, address to, uint256 value) public returns (bool);
618     event DoExchange(address indexed from, address indexed _spender, address indexed _to, uint256 _value);
619 }