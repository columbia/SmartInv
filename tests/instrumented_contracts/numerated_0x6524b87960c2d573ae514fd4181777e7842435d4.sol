1 /**
2  *Submitted for verification at Etherscan.io on 2019-07-31
3 */
4 
5 pragma solidity ^0.4.21;
6 
7 contract ApproveAndCallFallBack {
8     function receiveApproval(address from, uint256 tokens, address token, bytes memory data) public payable returns (bool);
9 }
10 
11 library Math {
12   function max64(uint64 _a, uint64 _b) internal pure returns (uint64) {
13     return _a >= _b ? _a : _b;
14   }
15 
16   function min64(uint64 _a, uint64 _b) internal pure returns (uint64) {
17     return _a < _b ? _a : _b;
18   }
19 
20   function max256(uint256 _a, uint256 _b) internal pure returns (uint256) {
21     return _a >= _b ? _a : _b;
22   }
23 
24   function min256(uint256 _a, uint256 _b) internal pure returns (uint256) {
25     return _a < _b ? _a : _b;
26   }
27 }
28 
29 library SafeMath {
30 
31   /**
32   * @dev Multiplies two numbers, throws on overflow.
33   */
34   function mul(uint256 _a, uint256 _b) internal pure returns (uint256 c) {
35     // Gas optimization: this is cheaper than asserting 'a' not being zero, but the
36     // benefit is lost if 'b' is also tested.
37     // See: https://github.com/OpenZeppelin/openzeppelin-solidity/pull/522
38     if (_a == 0) {
39       return 0;
40     }
41 
42     c = _a * _b;
43     assert(c / _a == _b);
44     return c;
45   }
46 
47   /**
48   * @dev Integer division of two numbers, truncating the quotient.
49   */
50   function div(uint256 _a, uint256 _b) internal pure returns (uint256) {
51     // assert(_b > 0); // Solidity automatically throws when dividing by 0
52     // uint256 c = _a / _b;
53     // assert(_a == _b * c + _a % _b); // There is no case in which this doesn't hold
54     return _a / _b;
55   }
56 
57   /**
58   * @dev Subtracts two numbers, throws on overflow (i.e. if subtrahend is greater than minuend).
59   */
60   function sub(uint256 _a, uint256 _b) internal pure returns (uint256) {
61     assert(_b <= _a);
62     return _a - _b;
63   }
64 
65   /**
66   * @dev Adds two numbers, throws on overflow.
67   */
68   function add(uint256 _a, uint256 _b) internal pure returns (uint256 c) {
69     c = _a + _b;
70     assert(c >= _a);
71     return c;
72   }
73 }
74 
75 contract Ownable {
76   address public owner;
77 
78 
79   event OwnershipRenounced(address indexed previousOwner);
80   event OwnershipTransferred(
81     address indexed previousOwner,
82     address indexed newOwner
83   );
84 
85 
86   /**
87    * @dev The Ownable constructor sets the original `owner` of the contract to the sender
88    * account.
89    */
90   constructor() public {
91     owner = msg.sender;
92   }
93 
94   /**
95    * @dev Throws if called by any account other than the owner.
96    */
97   modifier onlyOwner() {
98     require(msg.sender == owner);
99     _;
100   }
101 
102   /**
103    * @dev Allows the current owner to relinquish control of the contract.
104    * @notice Renouncing to ownership will leave the contract without an owner.
105    * It will not be possible to call the functions with the `onlyOwner`
106    * modifier anymore.
107    */
108   function renounceOwnership() public onlyOwner {
109     emit OwnershipRenounced(owner);
110     owner = address(0);
111   }
112 
113   /**
114    * @dev Allows the current owner to transfer control of the contract to a newOwner.
115    * @param _newOwner The address to transfer ownership to.
116    */
117   function transferOwnership(address _newOwner) public onlyOwner {
118     _transferOwnership(_newOwner);
119   }
120 
121   /**
122    * @dev Transfers control of the contract to a newOwner.
123    * @param _newOwner The address to transfer ownership to.
124    */
125   function _transferOwnership(address _newOwner) internal {
126     require(_newOwner != address(0));
127     emit OwnershipTransferred(owner, _newOwner);
128     owner = _newOwner;
129   }
130 }
131 
132 contract ERC20Basic {
133   function totalSupply() public view returns (uint256);
134   function balanceOf(address _who) public view returns (uint256);
135   function transfer(address _to, uint256 _value) public returns (bool);
136   event Transfer(address indexed from, address indexed to, uint256 value);
137 }
138 
139 contract ERC20 is ERC20Basic {
140   function allowance(address _owner, address _spender)
141     public view returns (uint256);
142 
143   function transferFrom(address _from, address _to, uint256 _value)
144     public returns (bool);
145 
146   function approve(address _spender, uint256 _value) public returns (bool);
147   event Approval(
148     address indexed owner,
149     address indexed spender,
150     uint256 value
151   );
152 }
153 
154 contract DetailedERC20 is ERC20 {
155   string public name;
156   string public symbol;
157   uint8 public decimals;
158 
159   constructor(string _name, string _symbol, uint8 _decimals) public {
160     name = _name;
161     symbol = _symbol;
162     decimals = _decimals;
163   }
164 }
165 
166 contract BasicToken is ERC20Basic {
167   using SafeMath for uint256;
168 
169   mapping(address => uint256) internal balances;
170 
171   uint256 internal totalSupply_;
172 
173   /**
174   * @dev Total number of tokens in existence
175   */
176   function totalSupply() public view returns (uint256) {
177     return totalSupply_;
178   }
179 
180   /**
181   * @dev Transfer token for a specified address
182   * @param _to The address to transfer to.
183   * @param _value The amount to be transferred.
184   */
185   function transfer(address _to, uint256 _value) public returns (bool) {
186     require(_value <= balances[msg.sender]);
187     require(_to != address(0));
188 
189     balances[msg.sender] = balances[msg.sender].sub(_value);
190     balances[_to] = balances[_to].add(_value);
191     emit Transfer(msg.sender, _to, _value);
192     return true;
193   }
194 
195   /**
196   * @dev Gets the balance of the specified address.
197   * @param _owner The address to query the the balance of.
198   * @return An uint256 representing the amount owned by the passed address.
199   */
200   function balanceOf(address _owner) public view returns (uint256) {
201     return balances[_owner];
202   }
203 
204 }
205 
206 contract BurnableToken is BasicToken {
207 
208   event Burn(address indexed burner, uint256 value);
209 
210   /**
211    * @dev Burns a specific amount of tokens.
212    * @param _value The amount of token to be burned.
213    */
214   function burn(uint256 _value) public {
215     _burn(msg.sender, _value);
216   }
217 
218   function _burn(address _who, uint256 _value) internal {
219     require(_value <= balances[_who]);
220     // no need to require value <= totalSupply, since that would imply the
221     // sender's balance is greater than the totalSupply, which *should* be an assertion failure
222 
223     balances[_who] = balances[_who].sub(_value);
224     totalSupply_ = totalSupply_.sub(_value);
225     emit Burn(_who, _value);
226     emit Transfer(_who, address(0), _value);
227   }
228 }
229 
230 contract StandardToken is ERC20, BasicToken {
231 
232   mapping (address => mapping (address => uint256)) internal allowed;
233 
234 
235   /**
236    * @dev Transfer tokens from one address to another
237    * @param _from address The address which you want to send tokens from
238    * @param _to address The address which you want to transfer to
239    * @param _value uint256 the amount of tokens to be transferred
240    */
241   function transferFrom(
242     address _from,
243     address _to,
244     uint256 _value
245   )
246     public
247     returns (bool)
248   {
249     require(_value <= balances[_from]);
250     require(_value <= allowed[_from][msg.sender]);
251     require(_to != address(0));
252 
253     balances[_from] = balances[_from].sub(_value);
254     balances[_to] = balances[_to].add(_value);
255     allowed[_from][msg.sender] = allowed[_from][msg.sender].sub(_value);
256     emit Transfer(_from, _to, _value);
257     return true;
258   }
259 
260   /**
261    * @dev Approve the passed address to spend the specified amount of tokens on behalf of msg.sender.
262    * Beware that changing an allowance with this method brings the risk that someone may use both the old
263    * and the new allowance by unfortunate transaction ordering. One possible solution to mitigate this
264    * race condition is to first reduce the spender's allowance to 0 and set the desired value afterwards:
265    * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
266    * @param _spender The address which will spend the funds.
267    * @param _value The amount of tokens to be spent.
268    */
269   function approve(address _spender, uint256 _value) public returns (bool) {
270     allowed[msg.sender][_spender] = _value;
271     emit Approval(msg.sender, _spender, _value);
272     return true;
273   }
274 
275   /**
276    * @dev Function to check the amount of tokens that an owner allowed to a spender.
277    * @param _owner address The address which owns the funds.
278    * @param _spender address The address which will spend the funds.
279    * @return A uint256 specifying the amount of tokens still available for the spender.
280    */
281   function allowance(
282     address _owner,
283     address _spender
284    )
285     public
286     view
287     returns (uint256)
288   {
289     return allowed[_owner][_spender];
290   }
291 
292   /**
293    * @dev Increase the amount of tokens that an owner allowed to a spender.
294    * approve should be called when allowed[_spender] == 0. To increment
295    * allowed value is better to use this function to avoid 2 calls (and wait until
296    * the first transaction is mined)
297    * From MonolithDAO Token.sol
298    * @param _spender The address which will spend the funds.
299    * @param _addedValue The amount of tokens to increase the allowance by.
300    */
301   function increaseApproval(
302     address _spender,
303     uint256 _addedValue
304   )
305     public
306     returns (bool)
307   {
308     allowed[msg.sender][_spender] = (
309       allowed[msg.sender][_spender].add(_addedValue));
310     emit Approval(msg.sender, _spender, allowed[msg.sender][_spender]);
311     return true;
312   }
313 
314   /**
315    * @dev Decrease the amount of tokens that an owner allowed to a spender.
316    * approve should be called when allowed[_spender] == 0. To decrement
317    * allowed value is better to use this function to avoid 2 calls (and wait until
318    * the first transaction is mined)
319    * From MonolithDAO Token.sol
320    * @param _spender The address which will spend the funds.
321    * @param _subtractedValue The amount of tokens to decrease the allowance by.
322    */
323   function decreaseApproval(
324     address _spender,
325     uint256 _subtractedValue
326   )
327     public
328     returns (bool)
329   {
330     uint256 oldValue = allowed[msg.sender][_spender];
331     if (_subtractedValue >= oldValue) {
332       allowed[msg.sender][_spender] = 0;
333     } else {
334       allowed[msg.sender][_spender] = oldValue.sub(_subtractedValue);
335     }
336     emit Approval(msg.sender, _spender, allowed[msg.sender][_spender]);
337     return true;
338   }
339 
340 }
341 
342 contract StandardBurnableToken is BurnableToken, StandardToken {
343 
344   /**
345    * @dev Burns a specific amount of tokens from the target address and decrements allowance
346    * @param _from address The address which you want to send tokens from
347    * @param _value uint256 The amount of token to be burned
348    */
349   function burnFrom(address _from, uint256 _value) public {
350     require(_value <= allowed[_from][msg.sender]);
351     // Should https://github.com/OpenZeppelin/zeppelin-solidity/issues/707 be accepted,
352     // this function needs to emit an event with the updated approval.
353     allowed[_from][msg.sender] = allowed[_from][msg.sender].sub(_value);
354     _burn(_from, _value);
355   }
356 }
357 
358 library SafeERC20 {
359   function safeTransfer(
360     ERC20Basic _token,
361     address _to,
362     uint256 _value
363   )
364     internal
365   {
366     require(_token.transfer(_to, _value));
367   }
368 
369   function safeTransferFrom(
370     ERC20 _token,
371     address _from,
372     address _to,
373     uint256 _value
374   )
375     internal
376   {
377     require(_token.transferFrom(_from, _to, _value));
378   }
379 
380   function safeApprove(
381     ERC20 _token,
382     address _spender,
383     uint256 _value
384   )
385     internal
386   {
387     require(_token.approve(_spender, _value));
388   }
389 }
390 
391 
392 contract TokenVesting is Ownable {
393   using SafeMath for uint256;
394   using SafeERC20 for ERC20Basic;
395 
396   event Released(uint256 amount);
397   event Revoked();
398 
399   // beneficiary of tokens after they are released
400   address public beneficiary;
401 
402   uint256 public cliff;
403   uint256 public start;
404   uint256 public duration;
405 
406   bool public revocable;
407 
408   mapping (address => uint256) public released;
409   mapping (address => bool) public revoked;
410 
411   /**
412    * @dev Creates a vesting contract that vests its balance of any ERC20 token to the
413    * _beneficiary, gradually in a linear fashion until _start + _duration. By then all
414    * of the balance will have vested.
415    * @param _beneficiary address of the beneficiary to whom vested tokens are transferred
416    * @param _cliff duration in seconds of the cliff in which tokens will begin to vest
417    * @param _start the time (as Unix time) at which point vesting starts
418    * @param _duration duration in seconds of the period in which the tokens will vest
419    * @param _revocable whether the vesting is revocable or not
420    */
421   constructor(
422     address _beneficiary,
423     uint256 _start,
424     uint256 _cliff,
425     uint256 _duration,
426     bool _revocable
427   )
428     public
429   {
430     require(_beneficiary != address(0));
431     require(_cliff <= _duration);
432 
433     beneficiary = _beneficiary;
434     revocable = _revocable;
435     duration = _duration;
436     cliff = _start.add(_cliff);
437     start = _start;
438   }
439 
440   /**
441    * @notice Transfers vested tokens to beneficiary.
442    * @param _token ERC20 token which is being vested
443    */
444   function release(ERC20Basic _token) public {
445     uint256 unreleased = releasableAmount(_token);
446 
447     require(unreleased > 0);
448 
449     released[_token] = released[_token].add(unreleased);
450 
451     _token.safeTransfer(beneficiary, unreleased);
452 
453     emit Released(unreleased);
454   }
455 
456   /**
457    * @notice Allows the owner to revoke the vesting. Tokens already vested
458    * remain in the contract, the rest are returned to the owner.
459    * @param _token ERC20 token which is being vested
460    */
461   function revoke(ERC20Basic _token) public onlyOwner {
462     require(revocable);
463     require(!revoked[_token]);
464 
465     uint256 balance = _token.balanceOf(address(this));
466 
467     uint256 unreleased = releasableAmount(_token);
468     uint256 refund = balance.sub(unreleased);
469 
470     revoked[_token] = true;
471 
472     _token.safeTransfer(owner, refund);
473 
474     emit Revoked();
475   }
476 
477   /**
478    * @dev Calculates the amount that has already vested but hasn't been released yet.
479    * @param _token ERC20 token which is being vested
480    */
481   function releasableAmount(ERC20Basic _token) public view returns (uint256) {
482     return vestedAmount(_token).sub(released[_token]);
483   }
484 
485   /**
486    * @dev Calculates the amount that has already vested.
487    * @param _token ERC20 token which is being vested
488    */
489   function vestedAmount(ERC20Basic _token) public view returns (uint256) {
490     uint256 currentBalance = _token.balanceOf(address(this));
491     uint256 totalBalance = currentBalance.add(released[_token]);
492 
493     if (block.timestamp < cliff) {
494       return 0;
495     } else if (block.timestamp >= start.add(duration) || revoked[_token]) {
496       return totalBalance;
497     } else {
498       return totalBalance.mul(block.timestamp.sub(start)).div(duration);
499     }
500   }
501 }
502 
503 
504 contract TokenPool {
505     ERC20Basic public token;
506 
507     modifier poolReady {
508         require(token != address(0));
509         _;
510     }
511 
512     function setToken(ERC20Basic newToken) public {
513         require(token == address(0));
514 
515         token = newToken;
516     }
517 
518     function balance() view public returns (uint256) {
519         return token.balanceOf(this);
520     }
521 
522     function transferTo(address dst, uint256 amount) internal returns (bool) {
523         return token.transfer(dst, amount);
524     }
525 
526     function getFrom() view public returns (address) {
527         return this;
528     }
529 }
530 
531 contract AdvisorPool is TokenPool, Ownable {
532 
533     function addVestor(
534         address _beneficiary,
535         uint256 _start,
536         uint256 _cliff,
537         uint256 _duration,
538         uint256 totalTokens
539     ) public onlyOwner poolReady returns (TokenVesting) {
540         TokenVesting vesting = new TokenVesting(_beneficiary, _start, _cliff, _duration, false);
541 
542         transferTo(vesting, totalTokens);
543 
544         return vesting;
545     }
546 
547     function transfer(address _beneficiary, uint256 amount) public onlyOwner poolReady returns (bool) {
548         return transferTo(_beneficiary, amount);
549     }
550 }
551 
552 contract TeamPool is TokenPool, Ownable {
553 
554     mapping(address => TokenVesting[]) cache;
555 
556     function addVestor(
557         address _beneficiary,
558         uint256 _start,
559         uint256 _cliff,
560         uint256 _duration,
561         uint256 totalTokens,
562         bool revokable
563     ) public onlyOwner poolReady returns (TokenVesting) {
564         cache[_beneficiary].push(new TokenVesting(_beneficiary, _start, _cliff, _duration, revokable));
565 
566         uint newIndex = cache[_beneficiary].length - 1;
567 
568         transferTo(cache[_beneficiary][newIndex], totalTokens);
569 
570         return cache[_beneficiary][newIndex];
571     }
572 
573     function vestingCount(address _beneficiary) public view poolReady returns (uint) {
574         return cache[_beneficiary].length;
575     }
576 
577     function revoke(address _beneficiary, uint index) public onlyOwner poolReady {
578         require(index < vestingCount(_beneficiary));
579         require(cache[_beneficiary][index] != address(0));
580 
581         cache[_beneficiary][index].revoke(token);
582     }
583 }
584 
585 contract StandbyGamePool is TokenPool, Ownable {
586     TokenPool public currentVersion;
587     bool public ready = false;
588 
589     function update(TokenPool newAddress) onlyOwner public {
590         require(!ready);
591         ready = true;
592         currentVersion = newAddress;
593         transferTo(newAddress, balance());
594     }
595 
596     function() public payable {
597         require(ready);
598         if(!currentVersion.delegatecall(msg.data)) revert();
599     }
600 }
601 
602 contract TokenUpdate is StandardBurnableToken, DetailedERC20 {
603     event Mint(address indexed to, uint256 amount);
604     
605     mapping(address => bool) internal _legacyTokens;
606     
607     address internal defaultLegacyToken;
608     
609     function _mint(address _to, uint256 _amount) internal returns (bool) {
610         totalSupply_ = totalSupply_.add(_amount);
611         balances[_to] = balances[_to].add(_amount);
612         emit Mint(_to, _amount);
613         emit Transfer(address(0), _to, _amount);
614         return true;
615     }
616                 
617     /**
618    * @dev Transfers part of an account's balance in the old token to this
619    * contract, and mints the same amount of new tokens for that account.
620    * @param token The legacy token to migrate from, should be registered under this token
621    * @param account whose tokens will be migrated
622    * @param amount amount of tokens to be migrated
623    */
624    function migrate(address token, address account, uint256 amount) public {
625        require(_legacyTokens[token]);
626        
627        StandardBurnableToken legacyToken = StandardBurnableToken(token);
628        
629        legacyToken.burnFrom(account, amount);
630        _mint(account, amount); 
631    }
632 
633   /**
634    * @dev Transfers all of an account's allowed balance in the old token to
635    * this contract, and mints the same amount of new tokens for that account.
636    * @param token The legacy token to migrate from, should be registered under this token
637    * @param account whose tokens will be migrated
638    */
639   function migrateAll(address token, address account) public {
640       require(_legacyTokens[token]);
641        
642       StandardBurnableToken legacyToken = StandardBurnableToken(token);
643        
644       uint256 balance = legacyToken.balanceOf(account);
645       uint256 allowance = legacyToken.allowance(account, this);
646       uint256 amount = Math.min256(balance, allowance);
647       migrate(token, account, amount);
648   }
649   
650   function migrateAll(address account) public {
651       migrateAll(defaultLegacyToken, account);
652   }
653 }
654 
655 
656 contract BenzeneToken is TokenUpdate, ApproveAndCallFallBack {
657     using SafeMath for uint256;
658 
659     string public constant name = "Benzene";
660     string public constant symbol = "BZN";
661     uint8 public constant decimals = 18;
662 
663     address public GamePoolAddress;
664     address public TeamPoolAddress;
665     address public AdvisorPoolAddress;
666 
667     constructor(address gamePool,
668                 address teamPool, //vest
669                 address advisorPool,
670                 address oldTeamPool,
671                 address oldAdvisorPool,
672                 address[] oldBzn) public DetailedERC20(name, symbol, decimals) {
673         
674         require(oldBzn.length > 0);
675         
676         DetailedERC20 _legacyToken; //Save the last token (should be latest version)
677         for (uint i = 0; i < oldBzn.length; i++) {
678             //Ensure this is an actual token
679             _legacyToken = DetailedERC20(oldBzn[i]);
680             
681             //Now register it for update
682             _legacyTokens[oldBzn[i]] = true;
683         }
684         
685         defaultLegacyToken = _legacyToken;
686         
687         GamePoolAddress = gamePool;
688         
689         uint256 teampool_balance =  _legacyToken.balanceOf(oldTeamPool);
690         require(teampool_balance > 0); //Ensure the last token actually has a balance
691         balances[teamPool] = teampool_balance;
692         totalSupply_ = totalSupply_.add(teampool_balance);
693         TeamPoolAddress = teamPool;
694 
695         
696         uint256 advisor_balance =  _legacyToken.balanceOf(oldAdvisorPool);
697         require(advisor_balance > 0); //Ensure the last token actually has a balance
698         balances[advisorPool] = advisor_balance;
699         totalSupply_ = totalSupply_.add(advisor_balance);
700         AdvisorPoolAddress = advisorPool;
701                     
702         TeamPool(teamPool).setToken(this);
703         AdvisorPool(advisorPool).setToken(this);
704     }
705   
706   function approveAndCall(address spender, uint tokens, bytes memory data) public payable returns (bool success) {
707       super.approve(spender, tokens);
708       
709       ApproveAndCallFallBack toCall = ApproveAndCallFallBack(spender);
710       
711       require(toCall.receiveApproval.value(msg.value)(msg.sender, tokens, address(this), data));
712       
713       return true;
714   }
715   
716   function receiveApproval(address from, uint256 tokens, address token, bytes memory data) public payable returns (bool) {
717       super.migrate(token, from, tokens);
718       
719       return true;
720   }
721 }