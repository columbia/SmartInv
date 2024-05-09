1 pragma solidity ^0.4.23;
2 
3 // File: contracts\abstract\Pool\IRoleModel.sol
4 
5 contract IRoleModel {
6   /**
7   * @dev RL_DEFAULT is role of basic account for example: investor
8   */
9   uint8 constant RL_DEFAULT = 0x00;
10   
11   /**
12   * @dev RL_POOL_MANAGER is role of person who will initialize pooling contract by asking admin to create it
13   * this person will find ICO and investors
14   */
15   uint8 constant RL_POOL_MANAGER = 0x01;
16   
17   /**
18   * @dev RL_ICO_MANAGER is role of person who have access to ICO contract as owner or tokenholder
19   */
20   uint8 constant RL_ICO_MANAGER = 0x02;
21   
22   /**
23   * @dev RL_ADMIN is role of person who create contract (BANKEX admin)
24   */
25   uint8 constant RL_ADMIN = 0x04;
26   
27   /**
28   * @dev RL_PAYBOT is like admin but without some capabilities that RL_ADMIN has
29   */
30   uint8 constant RL_PAYBOT = 0x08;
31 
32   function getRole_() view internal returns(uint8);
33   function getRole_(address _for) view internal returns(uint8);
34   function getRoleAddress_(uint8 _for) view internal returns(address);
35   
36 }
37 
38 // File: contracts\abstract\Pool\IStateModel.sol
39 
40 contract IStateModel {
41   /**
42   * @dev ST_DEFAULT state of contract when pooling manager didn't start raising
43   * it is an initialization state
44   */
45   uint8 constant ST_DEFAULT = 0x00;
46   
47   /**
48   * @dev ST_RAISING state of contract when contract is collecting ETH for ICO manager
49   */
50   uint8 constant ST_RAISING = 0x01;
51   
52   /**
53   * @dev ST_WAIT_FOR_ICO state of contract when contract is waiting for tokens from ICO manager
54   */
55   uint8 constant ST_WAIT_FOR_ICO = 0x02;
56   
57   /**
58   * @dev ST_MONEY_BACK state of contract when contract return all ETH back to investors
59   * it is unusual situation that occurred only if there are some problems
60   */
61   uint8 constant ST_MONEY_BACK = 0x04;
62   
63   /**
64   * @dev ST_TOKEN_DISTRIBUTION state of contract when contract return all tokens to investors
65   * if investor have some ETH that are not taken by ICO manager
66   * it is possible to take this ETH back too
67   */
68   uint8 constant ST_TOKEN_DISTRIBUTION = 0x08;
69   
70   /**
71   * @dev ST_FUND_DEPRECATED state of contract when all functions of contract will not work
72   * they will work only for Admin
73   * state means that contract lifecycle is ended
74   */
75   uint8 constant ST_FUND_DEPRECATED = 0x10;
76   
77   /**
78   * @dev TST_DEFAULT time state of contract when contract is waiting to be triggered by pool manager
79   */
80   uint8 constant TST_DEFAULT = 0x00;
81   
82   /**
83   * @dev TST_RAISING time state of contract when contract is collecting ETH for ICO manager
84   */
85   uint8 constant TST_RAISING = 0x01;
86   
87   /**
88   * @dev TST_WAIT_FOR_ICO time state of contract when contract is waiting for tokens from ICO manager
89   */
90   uint8 constant TST_WAIT_FOR_ICO = 0x02;
91   
92   /**
93   * @dev TST_TOKEN_DISTRIBUTION time state of contract when contract return all tokens to investors
94   */
95   uint8 constant TST_TOKEN_DISTRIBUTION = 0x08;
96   
97   /**
98   * @dev TST_FUND_DEPRECATED time state of contract when all functions of contract will not work
99   * they will work only for Admin
100   * state means that contract lifecycle is ended
101   */
102   uint8 constant TST_FUND_DEPRECATED = 0x10;
103   
104   /**
105   * @dev RST_NOT_COLLECTED state of contract when amount ETH is less than minimal amount to buy tokens
106   */
107   uint8 constant RST_NOT_COLLECTED = 0x01;
108   
109   /**
110   * @dev RST_COLLECTED state of contract when amount ETH is more than minimal amount to buy tokens
111   */
112   uint8 constant RST_COLLECTED = 0x02;
113   
114   /**
115   * @dev RST_FULL state of contract when amount ETH is more than maximal amount to buy tokens
116   */
117   uint8 constant RST_FULL = 0x04;
118 
119   function getState_() internal view returns (uint8);
120   function getShareRemaining_() internal view returns(uint);
121 }
122 
123 // File: contracts\abstract\Pool\RoleModel.sol
124 
125 contract RoleModel is IRoleModel{
126   mapping (address => uint8) internal role_;
127   mapping (uint8 => address) internal roleAddress_;
128   
129   function setRole_(uint8 _for, address _afor) internal returns(bool) {
130     require((role_[_afor] == 0) && (roleAddress_[_for] == address(0)));
131     role_[_afor] = _for;
132     roleAddress_[_for] = _afor;
133   }
134 
135   function getRole_() view internal returns(uint8) {
136     return role_[msg.sender];
137   }
138 
139   function getRole_(address _for) view internal returns(uint8) {
140     return role_[_for];
141   }
142 
143   function getRoleAddress_(uint8 _for) view internal returns(address) {
144     return roleAddress_[_for];
145   }
146   
147   /**
148   * @dev It returns role in pooling of account address that you sent via param
149   * @param _targetAddress is an address of account to return account's role
150   * @return role of account (0 if RL_DEFAULT, 1 if RL_POOL_MANAGER, 2 if RL_ICO_MANAGER, 4 if RL_ADMIN, 8 if RL_PAYBOT)
151   */
152   function getRole(address _targetAddress) external view returns(uint8){
153     return role_[_targetAddress];
154   }
155 
156 }
157 
158 // File: contracts\abstract\TimeMachine\ITimeMachine.sol
159 
160 contract ITimeMachine {
161   function getTimestamp_() internal view returns (uint);
162 }
163 
164 // File: contracts\abstract\Pool\IShareStore.sol
165 
166 contract IShareStore {
167   function getTotalShare_() internal view returns(uint);
168   
169   /**
170   * @dev event which is triggered every time when somebody send ETH during raising period
171   * @param addr is an address of account who sent ETH
172   * @param value is a sum in ETH which account sent to pooling contract
173   */
174   event BuyShare(address indexed addr, uint value);
175   
176   /**
177   * @dev event which is triggered every time when somebody will return it's ETH back during money back period
178   * @param addr is an address of account. Pooling contract send ETH to this address
179   * @param value is a sum in ETH which was sent from pooling
180   */
181   event RefundShare(address indexed addr, uint value);
182   
183   /**
184   * @dev event which is triggered every time when stakeholder get ETH from contract
185   * @param role is a role of stakeholder (for example: 4 is RL_ADMIN)
186   * @param addr is an address of account. Pooling contract send ETH to this address
187   * @param value is a sum in ETH which was sent from pooling
188   */
189   event ReleaseEtherToStakeholder(uint8 indexed role, address indexed addr, uint value);
190   
191   /**
192   * @dev event which is triggered when ICO manager show that value amount of tokens were approved to this contract
193   * @param addr is an address of account who trigger function (ICO manager)
194   * @param value is a sum in tokens which ICO manager approve to this contract
195   */
196   event AcceptTokenFromICO(address indexed addr, uint value);
197   
198   /**
199   * @dev event which is triggered every time when somebody will return it's ETH back during token distribution period
200   * @param addr is an address of account. Pooling contract send ETH to this address
201   * @param value is a sum in ETH which was sent from pooling
202   */
203   event ReleaseEther(address indexed addr, uint value);
204   
205   /**
206   * @dev event which is triggered every time when somebody will return it's tokens back during token distribution period
207   * @param addr is an address of account. Pooling contract send tokens to this address
208   * @param value is a sum in tokens which was sent from pooling
209   */
210   event ReleaseToken(address indexed addr, uint value);
211 
212 }
213 
214 // File: contracts\libs\math\SafeMath.sol
215 
216 /**
217  * @title SafeMath
218  * @dev Math operations with safety checks that throw on error
219  */
220 library SafeMath {
221 
222   /**
223   * @dev Multiplies two numbers, throws on overflow.
224   */
225   function mul(uint256 a, uint256 b) internal pure returns (uint256) {
226     if (a == 0) {
227       return 0;
228     }
229     uint256 c = a * b;
230     assert(c / a == b);
231     return c;
232   }
233 
234   /**
235   * @dev Integer division of two numbers, truncating the quotient.
236   */
237   function div(uint256 a, uint256 b) internal pure returns (uint256) {
238     // assert(b > 0); // Solidity automatically throws when dividing by 0
239     uint256 c = a / b;
240     // assert(a == b * c + a % b); // There is no case in which this doesn't hold
241     return c;
242   }
243 
244   /**
245   * @dev Substracts two numbers, throws on overflow (i.e. if subtrahend is greater than minuend).
246   */
247   function sub(uint256 a, uint256 b) internal pure returns (uint256) {
248     assert(b <= a);
249     return a - b;
250   }
251 
252   /**
253   * @dev Adds two numbers, throws on overflow.
254   */
255   function add(uint256 a, uint256 b) internal pure returns (uint256) {
256     uint256 c = a + b;
257     assert(c >= a);
258     return c;
259   }
260 }
261 
262 // File: contracts\abstract\Pool\StateModel.sol
263 
264 contract StateModel is IRoleModel, IShareStore, IStateModel, ITimeMachine {
265   using SafeMath for uint;
266   /**
267    * @dev time to start accepting ETH from investors
268    */
269   uint public launchTimestamp;
270 
271   /**
272    * @dev time to raise ETH for ICO
273    */
274   uint public raisingPeriod;
275 
276   /**
277    * @dev time to wait tokens from ICO manager
278    */
279   uint public icoPeriod;
280 
281   /**
282    * @dev time to distribute tokens and remaining ETH to investors
283    */
284   uint public distributionPeriod;
285 
286   /**
287    * @dev minimal collected fund in ETH
288    */
289   uint public minimalFundSize;
290   
291   /**
292    * @dev maximal collected fund in ETH
293    */
294   uint public maximalFundSize;
295   
296   uint8 internal initialState_;
297 
298   function getShareRemaining_() internal view returns(uint)
299   {
300     return maximalFundSize.sub(getTotalShare_());
301   }
302  
303   function getTimeState_() internal view returns (uint8) {
304     uint _launchTimestamp = launchTimestamp;
305     uint _relativeTimestamp = getTimestamp_() - _launchTimestamp;
306     if (_launchTimestamp == 0)
307       return TST_DEFAULT;
308     if (_relativeTimestamp < raisingPeriod)
309       return TST_RAISING;
310     if (_relativeTimestamp < icoPeriod)
311       return TST_WAIT_FOR_ICO;
312     if (_relativeTimestamp < distributionPeriod)
313       return TST_TOKEN_DISTRIBUTION;
314     return TST_FUND_DEPRECATED;
315   }
316 
317   function getRaisingState_() internal view returns(uint8) {
318     uint _totalEther = getTotalShare_();
319     if (_totalEther < minimalFundSize) 
320       return RST_NOT_COLLECTED;
321     if (_totalEther < maximalFundSize)
322       return RST_COLLECTED;
323     return RST_FULL;
324   }
325 
326   function getState_() internal view returns (uint8) {
327     uint _initialState = initialState_;
328     uint _timeState = getTimeState_();
329     uint _raisingState = getRaisingState_();
330     return getState_(_initialState, _timeState, _raisingState);
331   }
332   
333   function getState_(uint _initialState, uint _timeState, uint _raisingState) private pure returns (uint8) {
334     if (_initialState == ST_DEFAULT) return ST_DEFAULT;
335 
336     if (_initialState == ST_RAISING) {
337       if (_timeState == TST_RAISING) {
338         if (_raisingState == RST_FULL) {
339           return ST_WAIT_FOR_ICO;
340         }
341         return ST_RAISING;
342       }
343       if (_raisingState == RST_NOT_COLLECTED && (_timeState == TST_WAIT_FOR_ICO || _timeState == TST_TOKEN_DISTRIBUTION)) {
344         return ST_MONEY_BACK;
345       }
346       if (_timeState == TST_WAIT_FOR_ICO) {
347         return ST_WAIT_FOR_ICO;
348       }
349       if (_timeState == TST_TOKEN_DISTRIBUTION) {
350         return ST_TOKEN_DISTRIBUTION;
351       }
352       return ST_FUND_DEPRECATED;
353     }
354 
355     if (_initialState == ST_WAIT_FOR_ICO) {
356       if (_timeState == TST_RAISING || _timeState == TST_WAIT_FOR_ICO) {
357         return ST_WAIT_FOR_ICO;
358       }
359       if (_timeState == TST_TOKEN_DISTRIBUTION) {
360         return ST_TOKEN_DISTRIBUTION;
361       }
362       return ST_FUND_DEPRECATED;
363     }
364 
365     if (_initialState == ST_MONEY_BACK) {
366       if (_timeState == TST_RAISING || _timeState == TST_WAIT_FOR_ICO || _timeState == TST_TOKEN_DISTRIBUTION) {
367         return ST_MONEY_BACK;
368       }
369       return ST_FUND_DEPRECATED;
370     }
371     
372     if (_initialState == ST_TOKEN_DISTRIBUTION) {
373       if (_timeState == TST_RAISING || _timeState == TST_WAIT_FOR_ICO || _timeState == TST_TOKEN_DISTRIBUTION) {
374         return ST_TOKEN_DISTRIBUTION;
375       }
376       return ST_FUND_DEPRECATED;
377     }
378 
379     return ST_FUND_DEPRECATED;
380   }
381   
382   function setState_(uint _stateNew) internal returns (bool) {
383     uint _initialState = initialState_;
384     uint _timeState = getTimeState_();
385     uint _raisingState = getRaisingState_();
386     uint8 _state = getState_(_initialState, _timeState, _raisingState);
387     uint8 _role = getRole_();
388 
389     if (_stateNew == ST_RAISING) {
390       if ((_role == RL_POOL_MANAGER) && (_state == ST_DEFAULT)) {
391         launchTimestamp = getTimestamp_();
392         initialState_ = ST_RAISING;
393         return true;
394       }
395       revert();
396     }
397 
398     if (_stateNew == ST_WAIT_FOR_ICO) {
399       if ((_role == RL_POOL_MANAGER || _role == RL_ICO_MANAGER) && (_raisingState == RST_COLLECTED)) {
400         initialState_ = ST_WAIT_FOR_ICO;
401         return true;
402       }
403       revert();
404     }
405 
406     if (_stateNew == ST_MONEY_BACK) {
407       if ((_role == RL_POOL_MANAGER || _role == RL_ADMIN || _role == RL_PAYBOT) && (_state == ST_RAISING)) {
408         initialState_ = ST_MONEY_BACK;
409         return true;
410       }
411       revert();
412     }
413 
414     if (_stateNew == ST_TOKEN_DISTRIBUTION) {
415       if ((_role == RL_POOL_MANAGER || _role == RL_ADMIN || _role == RL_ICO_MANAGER || _role == RL_PAYBOT) && (_state == ST_WAIT_FOR_ICO)) {
416         initialState_ = ST_TOKEN_DISTRIBUTION;
417         return true;
418       }
419       revert();
420     }
421 
422     revert();
423     return true;
424   }
425   
426   /**
427   * @dev Returns state of pooling (for example: raising)
428   * @return state (0 if ST_DEFAULT, 1 if ST_RAISING, 2 if ST_WAIT_FOR_ICO, 4 if ST_MONEY_BACK, 8 if ST_TOKEN_DISTRIBUTION, 10 if ST_FUND_DEPRECATED)
429   */
430   function getState() external view returns(uint8) {
431     return getState_();
432   }
433   
434   /**
435   * @dev Allow to set state by stakeholders
436   * @return result of operation, true if success
437   */
438   function setState(uint newState) external returns(bool) {
439     return setState_(newState);
440   }
441 
442 }
443 
444 // File: contracts\libs\token\ERC20\IERC20.sol
445 
446 /**
447  * @title ERC20 interface
448  * @dev see https://github.com/ethereum/EIPs/issues/20
449  */
450 contract IERC20{
451   function allowance(address owner, address spender) external view returns (uint);
452   function transferFrom(address from, address to, uint value) external returns (bool);
453   function approve(address spender, uint value) external returns (bool);
454   function totalSupply() external view returns (uint);
455   function balanceOf(address who) external view returns (uint);
456   function transfer(address to, uint value) external returns (bool);
457   
458   event Transfer(address indexed from, address indexed to, uint value);
459   event Approval(address indexed owner, address indexed spender, uint value);
460 }
461 
462 // File: contracts\abstract\Pool\ShareStore.sol
463 
464 contract ShareStore is IRoleModel, IShareStore, IStateModel {
465   
466   using SafeMath for uint;
467   
468   /**
469   * @dev minimal amount of ETH in wei which is allowed to become investor
470   */
471   uint public minimalDeposit;
472   
473   /**
474   * @dev address of ERC20 token of ICO
475   */
476   address public tokenAddress;
477   
478   /**
479   * @dev investors balance which they have if they sent ETH during RAISING state
480   */
481   mapping (address=>uint) public share;
482   
483   /**
484   * @dev total amount of ETH collected from investors  in wei
485   */
486   uint public totalShare;
487   
488   /**
489   * @dev total amount of tokens collected from ERC20 contract
490   */
491   uint public totalToken;
492   
493   /**
494   * @dev total amount of ETH which stake holder can get
495   */
496   mapping (uint8=>uint) public stakeholderShare;
497   mapping (address=>uint) internal etherReleased_;
498   mapping (address=>uint) internal tokenReleased_;
499   mapping (uint8=>uint) internal stakeholderEtherReleased_;
500   uint constant DECIMAL_MULTIPLIER = 1e18;
501 
502   /**
503   * @dev price of one token in ethers
504   */
505   uint public tokenPrice;
506   
507   /**
508   * @dev payable function which does:
509   * If current state = ST_RASING - allows to send ETH for future tokens
510   * If current state = ST_MONEY_BACK - will send back all ETH that msg.sender has on balance
511   * If current state = ST_TOKEN_DISTRIBUTION - will reurn all ETH and Tokens that msg.sender has on balance
512   * in case of ST_MONEY_BACK or ST_TOKEN_DISTRIBUTION all ETH sum will be sent back (sum to trigger this function)
513   */
514   function () public payable {
515     uint8 _state = getState_();
516     if (_state == ST_RAISING){
517       buyShare_(_state);
518       return;
519     }
520     
521     if (_state == ST_MONEY_BACK) {
522       refundShare_(msg.sender, share[msg.sender]);
523       if(msg.value > 0)
524         msg.sender.transfer(msg.value);
525       return;
526     }
527     
528     if (_state == ST_TOKEN_DISTRIBUTION) {
529       releaseEther_(msg.sender, getBalanceEtherOf_(msg.sender));
530       releaseToken_(msg.sender, getBalanceTokenOf_(msg.sender));
531       if(msg.value > 0)
532         msg.sender.transfer(msg.value);
533       return;
534     }
535     revert();
536   }
537   
538   
539   /**
540   * @dev Allow to buy part of tokens if current state is RAISING
541   * @return result of operation, true if success
542   */
543   function buyShare() external payable returns(bool) {
544     return buyShare_(getState_());
545   }
546   
547   /**
548   * @dev Allow (Important) ICO manager to say that _value amount of tokens is approved from ERC20 contract to this contract
549   * @param _value amount of tokens that ICO manager approve from it's ERC20 contract to this contract
550   * @return result of operation, true if success
551   */
552   function acceptTokenFromICO(uint _value) external returns(bool) {
553     return acceptTokenFromICO_(_value);
554   }
555   
556   /**
557   * @dev Returns amount of ETH that stake holder (for example: ICO manager) can release from this contract
558   * @param _for role of stakeholder (for example: 2)
559   * @return amount of ETH in wei
560   */
561   function getStakeholderBalanceOf(uint8 _for) external view returns(uint) {
562     return getStakeholderBalanceOf_(_for);
563   }
564   
565   /**
566   * @dev Returns amount of ETH that person can release from this contract
567   * @param _for address of person
568   * @return amount of ETH in wei
569   */
570   function getBalanceEtherOf(address _for) external view returns(uint) {
571     return getBalanceEtherOf_(_for);
572   }
573   
574   /**
575   * @dev Returns amount of tokens that person can release from this contract
576   * @param _for address of person
577   * @return amount of tokens
578   */
579   function getBalanceTokenOf(address _for) external view returns(uint) {
580     return getBalanceTokenOf_(_for);
581   }
582   
583   /**
584   * @dev Release amount of ETH to msg.sender (must be stakeholder)
585   * @param _value amount of ETH in wei
586   * @return result of operation, true if success
587   */
588   function releaseEtherToStakeholder(uint _value) external returns(bool) {
589     uint8 _state = getState_();
590     uint8 _for = getRole_();
591     require(!((_for == RL_ICO_MANAGER) && ((_state != ST_WAIT_FOR_ICO) || (tokenPrice > 0))));
592     return releaseEtherToStakeholder_(_state, _for, _value);
593   }
594   
595   /**
596   * @dev Release amount of ETH to stakeholder by admin or paybot
597   * @param _for stakeholder role (for example: 2)
598   * @param _value amount of ETH in wei
599   * @return result of operation, true if success
600   */
601   function releaseEtherToStakeholderForce(uint8 _for, uint _value) external returns(bool) {
602     uint8 _role = getRole_();
603     require((_role==RL_ADMIN) || (_role==RL_PAYBOT));
604     uint8 _state = getState_();
605     require(!((_for == RL_ICO_MANAGER) && ((_state != ST_WAIT_FOR_ICO) || (tokenPrice > 0))));
606     return releaseEtherToStakeholder_(_state, _for, _value);
607   }
608   
609   /**
610   * @dev Release amount of ETH to msg.sender
611   * @param _value amount of ETH in wei
612   * @return result of operation, true if success
613   */
614   function releaseEther(uint _value) external returns(bool) {
615     uint8 _state = getState_();
616     require(_state == ST_TOKEN_DISTRIBUTION);
617     return releaseEther_(msg.sender, _value);
618   }
619   
620   /**
621   * @dev Release amount of ETH to person by admin or paybot
622   * @param _for address of person
623   * @param _value amount of ETH in wei
624   * @return result of operation, true if success
625   */
626   function releaseEtherForce(address _for, uint _value) external returns(bool) {
627     uint8 _role = getRole_();
628     uint8 _state = getState_();
629     require(_state == ST_TOKEN_DISTRIBUTION);
630     require((_role==RL_ADMIN) || (_role==RL_PAYBOT));
631     return releaseEther_(_for, _value);
632   }
633 
634   /**
635   * @dev Release amount of ETH to person by admin or paybot
636   * @param _for addresses of persons
637   * @param _value amounts of ETH in wei
638   * @return result of operation, true if success
639   */
640   function releaseEtherForceMulti(address[] _for, uint[] _value) external returns(bool) {
641     uint _sz = _for.length;
642     require(_value.length == _sz);
643     uint8 _role = getRole_();
644     uint8 _state = getState_();
645     require(_state == ST_TOKEN_DISTRIBUTION);
646     require((_role==RL_ADMIN) || (_role==RL_PAYBOT));
647     for (uint i = 0; i < _sz; i++){
648       require(releaseEther_(_for[i], _value[i]));
649     }
650     return true;
651   }
652   
653   /**
654   * @dev Release amount of tokens to msg.sender
655   * @param _value amount of tokens
656   * @return result of operation, true if success
657   */
658   function releaseToken(uint _value) external returns(bool) {
659     uint8 _state = getState_();
660     require(_state == ST_TOKEN_DISTRIBUTION);
661     return releaseToken_(msg.sender, _value);
662   }
663   
664   /**
665   * @dev Release amount of tokens to person by admin or paybot
666   * @param _for address of person
667   * @param _value amount of tokens
668   * @return result of operation, true if success
669   */
670   function releaseTokenForce(address _for, uint _value) external returns(bool) {
671     uint8 _role = getRole_();
672     uint8 _state = getState_();
673     require(_state == ST_TOKEN_DISTRIBUTION);
674     require((_role==RL_ADMIN) || (_role==RL_PAYBOT));
675     return releaseToken_(_for, _value);
676   }
677 
678 
679   /**
680   * @dev Release amount of tokens to person by admin or paybot
681   * @param _for addresses of persons
682   * @param _value amounts of tokens
683   * @return result of operation, true if success
684   */
685   function releaseTokenForceMulti(address[] _for, uint[] _value) external returns(bool) {
686     uint _sz = _for.length;
687     require(_value.length == _sz);
688     uint8 _role = getRole_();
689     uint8 _state = getState_();
690     require(_state == ST_TOKEN_DISTRIBUTION);
691     require((_role==RL_ADMIN) || (_role==RL_PAYBOT));
692     for(uint i = 0; i < _sz; i++){
693       require(releaseToken_(_for[i], _value[i]));
694     }
695     return true;
696   }
697   
698   /**
699   * @dev Allow to return ETH back to msg.sender if state Money back
700   * @param _value amount of ETH in wei
701   * @return result of operation, true if success
702   */
703   function refundShare(uint _value) external returns(bool) {
704     uint8 _state = getState_();
705     require (_state == ST_MONEY_BACK);
706     return refundShare_(msg.sender, _value);
707   }
708   
709   /**
710   * @dev Allow to return ETH back to person by admin or paybot if state Money back
711   * @param _for address of person
712   * @param _value amount of ETH in wei
713   * @return result of operation, true if success
714   */
715   function refundShareForce(address _for, uint _value) external returns(bool) {
716     uint8 _state = getState_();
717     uint8 _role = getRole_();
718     require(_role == RL_ADMIN || _role == RL_PAYBOT);
719     require (_state == ST_MONEY_BACK || _state == ST_RAISING);
720     return refundShare_(_for, _value);
721   }
722   
723   /**
724   * @dev Allow to use functions of other contract from this contract
725   * @param _to address of contract to call
726   * @param _value amount of ETH in wei
727   * @param _data contract function call in bytes type
728   * @return result of operation, true if success
729   */
730   function execute(address _to, uint _value, bytes _data) external returns (bool) {
731     require (getRole_()==RL_ADMIN);
732     require (getState_()==ST_FUND_DEPRECATED);
733     /* solium-disable-next-line */
734     return _to.call.value(_value)(_data);
735   }
736   
737   function getTotalShare_() internal view returns(uint){
738     return totalShare;
739   }
740 
741   function getEtherCollected_() internal view returns(uint){
742     return totalShare;
743   }
744 
745   function buyShare_(uint8 _state) internal returns(bool) {
746     require(_state == ST_RAISING);
747     require(msg.value >= minimalDeposit);
748     uint _shareRemaining = getShareRemaining_();
749     uint _shareAccept = (msg.value <= _shareRemaining) ? msg.value : _shareRemaining;
750 
751     share[msg.sender] = share[msg.sender].add(_shareAccept);
752     totalShare = totalShare.add(_shareAccept);
753     emit BuyShare(msg.sender, _shareAccept);
754     if (msg.value!=_shareAccept) {
755       msg.sender.transfer(msg.value.sub(_shareAccept));
756     }
757     return true;
758   }
759 
760   function acceptTokenFromICO_(uint _value) internal returns(bool) {
761     uint8 _state = getState_();
762     uint8 _for = getRole_();
763     require(_state == ST_WAIT_FOR_ICO);
764     require(_for == RL_ICO_MANAGER);
765     
766     totalToken = totalToken.add(_value);
767     emit AcceptTokenFromICO(msg.sender, _value);
768     require(IERC20(tokenAddress).transferFrom(msg.sender, this, _value));
769     if (tokenPrice > 0) {
770       releaseEtherToStakeholder_(_state, _for, _value.mul(tokenPrice).div(DECIMAL_MULTIPLIER));
771     }
772     return true;
773   }
774 
775   function getStakeholderBalanceOf_(uint8 _for) internal view returns (uint) {
776     if (_for == RL_ICO_MANAGER) {
777       return getEtherCollected_().mul(stakeholderShare[_for]).div(DECIMAL_MULTIPLIER).sub(stakeholderEtherReleased_[_for]);
778     }
779 
780     if ((_for == RL_POOL_MANAGER) || (_for == RL_ADMIN)) {
781       return stakeholderEtherReleased_[RL_ICO_MANAGER].mul(stakeholderShare[_for]).div(stakeholderShare[RL_ICO_MANAGER]);
782     }
783     return 0;
784   }
785 
786   function releaseEtherToStakeholder_(uint8 _state, uint8 _for, uint _value) internal returns (bool) {
787     require(_for != RL_DEFAULT);
788     require(_for != RL_PAYBOT);
789     require(!((_for == RL_ICO_MANAGER) && (_state != ST_WAIT_FOR_ICO)));
790     uint _balance = getStakeholderBalanceOf_(_for);
791     address _afor = getRoleAddress_(_for);
792     require(_balance >= _value);
793     stakeholderEtherReleased_[_for] = stakeholderEtherReleased_[_for].add(_value);
794     emit ReleaseEtherToStakeholder(_for, _afor, _value);
795     _afor.transfer(_value);
796     return true;
797   }
798 
799   function getBalanceEtherOf_(address _for) internal view returns (uint) {
800     uint _stakeholderTotalEtherReserved = stakeholderEtherReleased_[RL_ICO_MANAGER]
801     .mul(DECIMAL_MULTIPLIER).div(stakeholderShare[RL_ICO_MANAGER]);
802     uint _restEther = getEtherCollected_().sub(_stakeholderTotalEtherReserved);
803     return _restEther.mul(share[_for]).div(totalShare).sub(etherReleased_[_for]);
804   }
805 
806   function getBalanceTokenOf_(address _for) internal view returns (uint) {
807     return totalToken.mul(share[_for]).div(totalShare).sub(tokenReleased_[_for]);
808   }
809 
810   function releaseEther_(address _for, uint _value) internal returns (bool) {
811     uint _balance = getBalanceEtherOf_(_for);
812     require(_balance >= _value);
813     etherReleased_[_for] = etherReleased_[_for].add(_value);
814     emit ReleaseEther(_for, _value);
815     _for.transfer(_value);
816     return true;
817   }
818 
819   function releaseToken_( address _for, uint _value) internal returns (bool) {
820     uint _balance = getBalanceTokenOf_(_for);
821     require(_balance >= _value);
822     tokenReleased_[_for] = tokenReleased_[_for].add(_value);
823     emit ReleaseToken(_for, _value);
824     require(IERC20(tokenAddress).transfer(_for, _value));
825     return true;
826   }
827 
828   function refundShare_(address _for, uint _value) internal returns(bool) {
829     uint _balance = share[_for];
830     require(_balance >= _value);
831     share[_for] = _balance.sub(_value);
832     totalShare = totalShare.sub(_value);
833     emit RefundShare(_for, _value);
834     _for.transfer(_value);
835     return true;
836   }
837   
838 }
839 
840 // File: contracts\abstract\Pool\Pool.sol
841 
842 contract Pool is ShareStore, StateModel, RoleModel {
843 }
844 
845 // File: contracts\abstract\TimeMachine\TimeMachineP.sol
846 
847 /**
848 * @dev TimeMachine implementation for production
849 */
850 contract TimeMachineP {
851   
852   /**
853   * @dev get current real timestamp
854   * @return current real timestamp
855   */
856   function getTimestamp_() internal view returns(uint) {
857     return block.timestamp;
858   }
859 }
860 
861 // File: contracts\production\poolProd\PoolProd.sol
862 
863 contract PoolProd is Pool, TimeMachineP {
864   uint constant DECIMAL_MULTIPLIER = 1e18;
865   
866 
867   constructor() public {
868     uint day = 86400;
869     raisingPeriod = day*30;
870     icoPeriod = day*60;
871     distributionPeriod = day*90;
872 
873     minimalFundSize = 0.1e18;
874     maximalFundSize = 10e18;
875 
876     minimalDeposit = 0.01e18;
877 
878     stakeholderShare[RL_ADMIN] = 0.02e18;
879     stakeholderShare[RL_POOL_MANAGER] = 0.01e18;
880     stakeholderShare[RL_ICO_MANAGER] = DECIMAL_MULTIPLIER - 0.02e18 - 0.01e18;
881 
882     setRole_(RL_ADMIN, 0xa4280AEF10BE355d6777d97758cb6fC6c5C3779C);
883     setRole_(RL_POOL_MANAGER, 0x91b4DABf4f2562E714DBd84B6D4a4efd7e1a97a8);
884     setRole_(RL_ICO_MANAGER, 0x79Cd7826636cb299059272f4324a5866496807Ef);
885     setRole_(RL_PAYBOT, 0x3Fae7A405A45025E5Fb0AD09e225C4168bF916D4);
886 
887     tokenAddress = 0x45245bc59219eeaAF6cD3f382e078A461FF9De7B;
888     tokenPrice = 5000000000000000;
889   }
890 }