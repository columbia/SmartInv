1 pragma solidity ^0.4.21;
2 
3 contract EIP20Interface {
4     function name() public view returns (string);
5     
6     function symbol() public view returns (string);
7     
8     function decimals() public view returns (uint8);
9     
10     function totalSupply() public view returns (uint256);
11 
12     /// @param _owner The address from which the balance will be retrieved
13     /// @return The balance
14     function balanceOf(address _owner) public view returns (uint256 balance);
15 
16     /// @notice send `_value` token to `_to` from `msg.sender`
17     /// @param _to The address of the recipient
18     /// @param _value The amount of token to be transferred
19     /// @return Whether the transfer was successful or not
20     function transfer(address _to, uint256 _value) public returns (bool success);
21 
22     /// @notice send `_value` token to `_to` from `_from` on the condition it is approved by `_from`
23     /// @param _from The address of the sender
24     /// @param _to The address of the recipient
25     /// @param _value The amount of token to be transferred
26     /// @return Whether the transfer was successful or not
27     function transferFrom(address _from, address _to, uint256 _value) public returns (bool success);
28 
29     /// @notice `msg.sender` approves `_spender` to spend `_value` tokens
30     /// @param _spender The address of the account able to transfer the tokens
31     /// @param _value The amount of tokens to be approved for transfer
32     /// @return Whether the approval was successful or not
33     function approve(address _spender, uint256 _value) public returns (bool success);
34 
35     /// @param _owner The address of the account owning tokens
36     /// @param _spender The address of the account able to transfer the tokens
37     /// @return Amount of remaining tokens allowed to spent
38     function allowance(address _owner, address _spender) public view returns (uint256 remaining);
39 
40     // solhint-disable-next-line no-simple-event-func-name
41     event Transfer(address indexed _from, address indexed _to, uint256 _value);
42     event Approval(address indexed _owner, address indexed _spender, uint256 _value);
43 }
44 
45 contract EIP20 is EIP20Interface {
46 
47     uint256 constant private MAX_UINT256 = 2**256 - 1;
48     mapping (address => uint256) public balances;
49     mapping (address => mapping (address => uint256)) public allowed;
50     /*
51     NOTE:
52     The following variables are OPTIONAL vanities. One does not have to include them.
53     They allow one to customise the token contract & in no way influences the core functionality.
54     Some wallets/interfaces might not even bother to look at this information.
55     */
56     string public tokenName;                   //fancy name: eg Simon Bucks
57     uint8 public tokenDecimals;                //How many decimals to show.
58     string public tokenSymbol;                 //An identifier: eg SBX
59     uint256 public tokenTotalSupply;
60 
61     constructor(
62         uint256 _initialAmount,
63         string _tokenName,
64         uint8 _decimalUnits,
65         string _tokenSymbol
66     ) public {
67         balances[msg.sender] = _initialAmount;               // Give the creator all initial tokens
68         tokenTotalSupply = _initialAmount;                        // Update total supply
69         tokenName = _tokenName;                                   // Set the name for display purposes
70         tokenDecimals = _decimalUnits;                            // Amount of decimals for display purposes
71         tokenSymbol = _tokenSymbol;                               // Set the symbol for display purposes
72     }
73     
74     function name() public view returns (string) {
75         return tokenName;
76     }
77     
78     function symbol() public view returns (string) {
79         return tokenSymbol;
80     }
81     
82     function decimals() public view returns (uint8) {
83         return tokenDecimals;
84     }
85     
86     function totalSupply() public view returns (uint256) {
87         return tokenTotalSupply;
88     }
89 
90     function transfer(address _to, uint256 _value) public returns (bool success) {
91         require(balances[msg.sender] >= _value);
92         balances[msg.sender] -= _value;
93         balances[_to] += _value;
94         emit Transfer(msg.sender, _to, _value); //solhint-disable-line indent, no-unused-vars
95         return true;
96     }
97 
98     function transferFrom(address _from, address _to, uint256 _value) public returns (bool success) {
99         uint256 allowance = allowed[_from][msg.sender];
100         require(balances[_from] >= _value && allowance >= _value);
101         balances[_to] += _value;
102         balances[_from] -= _value;
103         if (allowance < MAX_UINT256) {
104             allowed[_from][msg.sender] -= _value;
105         }
106         emit Transfer(_from, _to, _value); //solhint-disable-line indent, no-unused-vars
107         return true;
108     }
109 
110     function balanceOf(address _owner) public view returns (uint256 balance) {
111         return balances[_owner];
112     }
113 
114     function approve(address _spender, uint256 _value) public returns (bool success) {
115         allowed[msg.sender][_spender] = _value;
116         emit Approval(msg.sender, _spender, _value); //solhint-disable-line indent, no-unused-vars
117         return true;
118     }
119 
120     function allowance(address _owner, address _spender) public view returns (uint256 remaining) {
121         return allowed[_owner][_spender];
122     }
123 }
124 
125 /**
126  * @title SafeMath
127  * @dev Math operations with safety checks that throw on error
128  */
129 library SafeMath {
130 
131   /**
132   * @dev Multiplies two numbers, throws on overflow.
133   */
134   function mul(uint256 a, uint256 b) internal pure returns (uint256 c) {
135     if (a == 0) {
136       return 0;
137     }
138     c = a * b;
139     assert(c / a == b);
140     return c;
141   }
142 
143   /**
144   * @dev Integer division of two numbers, truncating the quotient.
145   */
146   function div(uint256 a, uint256 b) internal pure returns (uint256) {
147     // assert(b > 0); // Solidity automatically throws when dividing by 0
148     // uint256 c = a / b;
149     // assert(a == b * c + a % b); // There is no case in which this doesn't hold
150     return a / b;
151   }
152 
153   /**
154   * @dev Subtracts two numbers, throws on overflow (i.e. if subtrahend is greater than minuend).
155   */
156   function sub(uint256 a, uint256 b) internal pure returns (uint256) {
157     assert(b <= a);
158     return a - b;
159   }
160 
161   /**
162   * @dev Adds two numbers, throws on overflow.
163   */
164   function add(uint256 a, uint256 b) internal pure returns (uint256 c) {
165     c = a + b;
166     assert(c >= a);
167     return c;
168   }
169 }
170 
171 contract TimeBankToken is EIP20 {
172   using SafeMath for uint;
173 
174   struct Vesting {
175     uint256 startTime; // vesting start time
176     uint256 initReleaseAmount;
177     uint256 amount;
178     uint256 interval; // release N% of amount each interval.
179     uint256 periods; // count of periods
180     uint256 withdrawed; // already used amount of released part
181   }
182 
183   mapping (address => Vesting[]) vestings;
184   
185   address[] managerList;
186   mapping (address => bool) managers;
187   mapping (bytes32 => mapping (address => bool)) confirms;
188   
189   /*
190   at least <threshold> confirmations
191   */
192   uint majorityThreshold;
193   uint managementThreshold;
194 
195   address coinbase;
196   address master;
197   bool public paused;
198 
199   function checkAddress(address _addr) internal pure returns (bool) {
200     return _addr != address(0);
201   }
202 
203   // 1 with 28 zeros
204   constructor(address _master, address[] _managers, uint _majorityThreshold, uint _managementThreshold) EIP20(10000000000000000000000000000, "Time Bank Token", 18, "TBT") public {
205     require(checkAddress(_master));
206     require(_managers.length >= _majorityThreshold);
207     require(_managers.length >= _managementThreshold);
208     
209     paused = false;
210     master = _master;
211     coinbase = msg.sender;
212     majorityThreshold = _majorityThreshold;
213     managementThreshold = _managementThreshold;
214 
215     for (uint i=0; i<_managers.length; i++) {
216       require(checkAddress(_managers[i]));
217       managers[_managers[i]] = true;
218     }
219     managerList = _managers;
220 
221     // initial batch operations
222     // internalPresaleVesting(0x0095F9DffeE386B650230eD3eC28891c1053aBE0, 10000, 60, 120, 240);
223     // internalPresaleVesting(0x00D4fC2CC18B96c44D9755afB6D4e6804cF827ee, 20000, 60, 120, 240);
224     // internalPresale(0x0092E41D42E834705fd07c9136Fd0b1028226bE3, 30000);
225   }
226 
227   function pause() public isMaster isNotPaused {
228     require(isEnoughConfirmed(msg.data, 1));
229     paused = true;
230   }
231 
232   function resume() public isMaster isPaused {
233     require(isEnoughConfirmed(msg.data, 1));
234     paused = false;
235   }
236 
237   modifier isPaused {
238     require(paused == true);
239     _;
240   }
241 
242   modifier isNotPaused {
243     require(paused == false);
244     _;
245   }
246 
247   modifier isManager {
248     require(managers[msg.sender]);
249     _;
250   }
251 
252   modifier isMaster {
253     require(msg.sender == master);
254     _;
255   }
256 
257   modifier isNotCoinbase {
258     require(msg.sender != coinbase);
259     _;
260   }
261 
262   function managersCount() public view returns (uint) {
263     return managerList.length;
264   }
265 
266   function isAddressManager(address _to) public view returns (bool) {
267     return managers[_to];
268   }
269 
270   function getMajorityThreshold() public view  returns (uint) {
271     return majorityThreshold;
272   }
273 
274   event MajorityThresholdChanged(uint oldThreshold, uint newThreshold);
275   event ReplaceManager(address oldAddr, address newAddr);
276   event RemoveManager(address manager);
277   event AddManager(address manager);
278 
279   function setMajorityThreshold(uint _threshold) public isMaster isNotPaused {
280     require(_threshold > 0);
281     require(isEnoughConfirmed(msg.data, managementThreshold));
282     uint oldThreshold = majorityThreshold;
283     majorityThreshold = _threshold;
284     removeConfirm(msg.data);
285     emit MajorityThresholdChanged(oldThreshold, majorityThreshold);
286   }
287 
288   function replaceManager(address _old, address _new) public isMaster isNotPaused {
289     require(checkAddress(_old));
290     require(checkAddress(_new));
291     require(isEnoughConfirmed(msg.data, managementThreshold));
292     internalRemoveManager(_old);
293     internalAddManager(_new);
294     rebuildManagerList();
295     removeConfirm(msg.data);
296     emit ReplaceManager(_old, _new);
297   }
298 
299   function removeManager(address _manager) public isMaster isNotPaused {
300     require(checkAddress(_manager));
301     require(isEnoughConfirmed(msg.data, managementThreshold));
302     require(managerList.length > managementThreshold);
303     internalRemoveManager(_manager);
304     rebuildManagerList();
305     removeConfirm(msg.data);
306     emit RemoveManager(_manager);
307   }
308 
309   function internalRemoveManager(address _manager) internal {
310     require(checkAddress(_manager));
311     managers[_manager] = false;
312   }
313 
314   function addManager(address _manager) public isMaster isNotPaused {
315     require(checkAddress(_manager));
316     require(isEnoughConfirmed(msg.data, managementThreshold));
317     internalAddManager(_manager);
318     rebuildManagerList();
319     removeConfirm(msg.data);
320     emit AddManager(_manager);
321   }
322 
323   function internalAddManager(address _manager) internal {
324     require(checkAddress(_manager));
325     managers[_manager] = true;
326     managerList.push(_manager);
327   }
328 
329   mapping (address => bool) checked;
330 
331   function rebuildManagerList() internal {
332     address[] memory res = new address[](managerList.length);
333     for (uint k=0; k<managerList.length; k++) {
334       checked[managerList[k]] = false;
335     }
336     uint j=0;
337     for (uint i=0; i<managerList.length; i++) {
338       address manager = managerList[i];
339       if (managers[manager] && checked[manager] == false) {
340         res[j] = manager;
341         checked[manager] = true;
342         j++;
343       }
344     }
345     managerList = res;
346     managerList.length = j;
347   }
348 
349   function checkData(bytes data) internal pure returns (bool) {
350     return data.length != 0;
351   }
352 
353   event Confirm(address manager, bytes data);
354   event Revoke(address manager, bytes data);
355 
356   /*
357   manager use this function to confirm a operation
358   confirm will not be call inside other functions, so it can be external to save some gas
359   @param {bytes} data is the transaction's raw input
360   */
361   function confirm(bytes data) external isManager {
362     checkData(data);
363     bytes32 op = keccak256(data);
364     if (confirms[op][msg.sender] == false) {
365       confirms[op][msg.sender] = true;
366     }
367     emit Confirm(msg.sender, data);
368   }
369 
370   /*
371   manager use this function to revoke a confirm of the operation
372   revoke will not be call inside other functions, so it can be external to save some gas
373   @param {bytes} data is the transaction's raw input
374   */
375   function revoke(bytes data) external isManager {
376     checkData(data);
377     bytes32 op = keccak256(data);
378     if (confirms[op][msg.sender] == true) {
379       confirms[op][msg.sender] = false;
380     }
381     emit Revoke(msg.sender, data);
382   }
383 
384   /*
385   check a operation is confirmed or not
386   */
387   function isConfirmed(bytes data) public view isManager returns (bool) {
388     bytes32 op = keccak256(data);
389     return confirms[op][msg.sender];
390   }
391 
392   function isConfirmedBy(bytes data, address manager) public view returns (bool) {
393     bytes32 op = keccak256(data);
394     return confirms[op][manager];
395   } 
396 
397   function isMajorityConfirmed(bytes data) public view returns (bool) {
398     return isEnoughConfirmed(data, majorityThreshold);
399   }
400 
401   function isEnoughConfirmed(bytes data, uint count) internal view returns (bool) {
402     bytes32 op = keccak256(data);
403     uint confirmsCount = 0;
404     for (uint i=0; i<managerList.length; i++) {
405       if (confirms[op][managerList[i]] == true) {
406         confirmsCount = confirmsCount.add(1);
407       }
408     }
409     return confirmsCount >= count;
410   }
411 
412   /*
413   once the operation is executed, the confirm of the operation should be removed
414   */
415   function removeConfirm(bytes data) internal {
416     bytes32 op = keccak256(data);
417     for (uint i=0; i<managerList.length; i++) {
418       confirms[op][managerList[i]] = false;
419     }
420   }
421 
422   /*
423   sale coin with time locking
424   only the manager can call this function
425   and this operation should be confirmed
426   */
427   function presaleVesting(address _to, uint256 _startTime, uint256 _initReleaseAmount, uint256 _amount, uint256 _interval, uint256 _periods) public isManager isNotPaused {
428     checkAddress(_to);
429     require(isMajorityConfirmed(msg.data));
430     internalPresaleVesting(_to, _startTime, _initReleaseAmount, _amount, _interval, _periods);
431     removeConfirm(msg.data);
432   }
433 
434   function batchPresaleVesting(address[] _to, uint256[] _startTime, uint256[] _initReleaseAmount, uint256[] _amount, uint256[] _interval, uint256[] _periods) public isManager isNotPaused {
435     require(isMajorityConfirmed(msg.data));
436     for (uint i=0; i<_to.length; i++) {
437       internalPresaleVesting(_to[i], _startTime[i], _initReleaseAmount[i], _amount[i], _interval[i], _periods[i]);
438     }
439     removeConfirm(msg.data);
440   }
441 
442   function internalPresaleVesting(address _to, uint256 _startTime, uint256 _initReleaseAmount, uint256 _amount, uint256 _interval, uint256 _periods) internal {
443     require(balances[coinbase] >= _amount);
444     require(_initReleaseAmount <= _amount);
445     require(checkAddress(_to));
446     vestings[_to].push(Vesting(
447       _startTime, _initReleaseAmount, _amount, _interval, _periods, 0
448     ));
449     balances[coinbase] = balances[coinbase].sub(_amount);
450     emit PresaleVesting(_to, _startTime, _amount, _interval, _periods);
451   }
452 
453   /*
454   sale coin without time locking
455   only the manager can call this function
456   and this operation should be confirmed
457   */
458   function presale(address _to, uint256 _value) public isManager isNotPaused {
459     require(isMajorityConfirmed(msg.data));
460     internalPresale(_to, _value);
461     removeConfirm(msg.data);
462   }
463 
464   function batchPresale(address[] _to, uint256[] _amount) public isManager isNotPaused {
465     require(isMajorityConfirmed(msg.data));
466     for (uint i=0; i<_to.length; i++) {
467       internalPresale(_to[i], _amount[i]);
468     }
469     removeConfirm(msg.data);
470   }
471 
472   function internalPresale(address _to, uint256 _value) internal {
473     require(balances[coinbase] >= _value);
474     require(checkAddress(_to));
475     balances[_to] = balances[_to].add(_value);
476     balances[coinbase] = balances[coinbase].sub(_value);
477     emit Presale(_to, _value);
478   }
479 
480   /*
481   events
482   */
483   event Presale(address indexed to, uint256 value);
484   event PresaleVesting(address indexed to, uint256 startTime, uint256 amount, uint256 interval, uint256 periods);
485 
486   /*
487   math function used to calculate vesting curve
488   */
489   function vestingFunc(uint256 _currentTime, uint256 _startTime, uint256 _initReleaseAmount, uint256 _amount, uint256 _interval, uint256 _periods) public pure returns (uint256) {
490     if (_currentTime < _startTime) {
491       return 0;
492     }
493     uint256 t = _currentTime.sub(_startTime);
494     uint256 end = _periods.mul(_interval);
495     if (t >= end) {
496       return _amount;
497     }
498     uint256 i_amount = _amount.sub(_initReleaseAmount).div(_periods);
499     uint256 i = t.div(_interval);
500     return i_amount.mul(i).add(_initReleaseAmount);
501   }
502 
503   function queryWithdrawed(uint _idx) public view returns (uint256) {
504     return vestings[msg.sender][_idx].withdrawed;
505   }
506 
507   function queryVestingRemain(uint256 _currentTime, uint _idx) public view returns (uint256) {
508     uint256 released = vestingFunc(
509       _currentTime,
510       vestings[msg.sender][_idx].startTime, vestings[msg.sender][_idx].initReleaseAmount, vestings[msg.sender][_idx].amount,
511       vestings[msg.sender][_idx].interval, vestings[msg.sender][_idx].periods
512     );
513     return released.sub(vestings[msg.sender][_idx].withdrawed);
514   }
515 
516   /*
517   calculate the released amount of vesting coin
518   it cannot be view, because this function relays on 'now'
519   */
520   function vestingReleased(uint256 _startTime, uint256 _initReleaseAmount, uint256 _amount, uint256 _interval, uint256 _periods) internal view returns (uint256) {
521     return vestingFunc(now, _startTime, _initReleaseAmount, _amount, _interval, _periods);
522   }
523 
524   /*
525   withdraw all released vesting coin to balance
526   */
527   function withdrawVestings(address _to) internal {
528     uint256 sum = 0;
529     for (uint i=0; i<vestings[_to].length; i++) {
530       if (vestings[_to][i].amount == vestings[_to][i].withdrawed) {
531         continue;
532       }
533 
534       uint256 released = vestingReleased(
535         vestings[_to][i].startTime, vestings[_to][i].initReleaseAmount, vestings[_to][i].amount,
536         vestings[_to][i].interval, vestings[_to][i].periods
537       );
538       uint256 remain = released.sub(vestings[_to][i].withdrawed);
539       if (remain >= 0) {
540         vestings[_to][i].withdrawed = released;
541         sum = sum.add(remain);
542       }
543     }
544     balances[_to] = balances[_to].add(sum);
545   }
546 
547   /*
548   sum of all vestings balance (regardless of released or not)
549   each vesting is amount - withdrawed
550   */
551   function vestingsBalance(address _to) public view returns (uint256) {
552     uint256 sum = 0;
553     for (uint i=0; i<vestings[_to].length; i++) {
554       sum = sum.add(vestings[_to][i].amount.sub(vestings[_to][i].withdrawed));
555     }
556     return sum;
557   }
558 
559   /*
560   sum of all remaining vestings balance (only the released part)
561   released - withdrawed
562   */
563   function vestingsReleasedRemain(address _to) internal view returns (uint256) {
564     uint256 sum = 0;
565     for (uint i=0; i<vestings[_to].length; i++) {
566       uint256 released = vestingReleased(
567         vestings[_to][i].startTime, vestings[_to][i].initReleaseAmount, vestings[_to][i].amount,
568         vestings[_to][i].interval, vestings[_to][i].periods
569       );
570       sum = sum.add(released.sub(vestings[_to][i].withdrawed));
571     }
572     return sum;
573   }
574 
575   /*
576   total balance
577   sum of vestings balance (includes not released part) and unlocking coin balance
578   */
579   function balanceOf(address _to) public view returns (uint256) {
580     uint256 vbalance = vestingsBalance(_to);
581     return vbalance.add(super.balanceOf(_to));
582   }
583 
584   /*
585   sum of vestings balance and unlocking coin balance
586   */
587   function vestingsRemainBalance(address _to) internal view returns (uint256) {
588     return vestingsReleasedRemain(_to).add(super.balanceOf(_to));
589   }
590 
591   /*
592   transfer <_value> coin from <msg.sender> to <_to> address
593   1. check remain balance
594   2. withdraw all vesting coin to balance
595   3. call original ERC20 transafer function
596   */
597   function transfer(address _to, uint256 _value) public isNotCoinbase isNotPaused returns (bool) {
598     checkAddress(_to);
599     uint256 remain = vestingsRemainBalance(msg.sender);
600     require(remain >= _value);
601     withdrawVestings(msg.sender);
602     return super.transfer(_to, _value);
603   }
604 
605   /*
606   transferFrom <_value> coin from <_from> to <_to> address
607   1. check remain balance
608   2. withdraw all vesting coin to balance
609   3. call original ERC20 transafer function
610   */
611   function transferFrom(address _from, address _to, uint256 _value) public isNotPaused returns (bool) {
612     checkAddress(_from);
613     checkAddress(_to);
614     uint256 remain = vestingsRemainBalance(_from);
615     require(remain >= _value);
616     withdrawVestings(_from);
617     return super.transferFrom(_from, _to, _value);
618   }
619 
620   /*
621   approve <_value> coin from <_from> to <_to> address
622   1. check remain balance
623   2. withdraw all vesting coin to balance
624   3. call original ERC20 transafer function
625   */
626   function approve(address _spender, uint256 _value) public isNotCoinbase isNotPaused returns (bool) {
627     checkAddress(_spender);
628     uint256 remain = vestingsRemainBalance(msg.sender);
629     require(remain >= _value);
630     withdrawVestings(msg.sender);
631     return super.approve(_spender, _value);
632   }
633 
634   function allowance(address _owner, address _spender) public view returns (uint256) {
635     return super.allowance(_owner, _spender);
636   }
637 }