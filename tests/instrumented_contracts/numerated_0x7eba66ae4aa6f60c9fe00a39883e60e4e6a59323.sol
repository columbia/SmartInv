1 pragma solidity ^0.4.21;
2 
3 
4 contract EIP20Interface {
5     function name() public view returns (string);
6     
7     function symbol() public view returns (string);
8     
9     function decimals() public view returns (uint8);
10     
11     function totalSupply() public view returns (uint256);
12 
13     /// @param _owner The address from which the balance will be retrieved
14     /// @return The balance
15     function balanceOf(address _owner) public view returns (uint256 balance);
16 
17     /// @notice send `_value` token to `_to` from `msg.sender`
18     /// @param _to The address of the recipient
19     /// @param _value The amount of token to be transferred
20     /// @return Whether the transfer was successful or not
21     function transfer(address _to, uint256 _value) public returns (bool success);
22 
23     /// @notice send `_value` token to `_to` from `_from` on the condition it is approved by `_from`
24     /// @param _from The address of the sender
25     /// @param _to The address of the recipient
26     /// @param _value The amount of token to be transferred
27     /// @return Whether the transfer was successful or not
28     function transferFrom(address _from, address _to, uint256 _value) public returns (bool success);
29 
30     /// @notice `msg.sender` approves `_spender` to spend `_value` tokens
31     /// @param _spender The address of the account able to transfer the tokens
32     /// @param _value The amount of tokens to be approved for transfer
33     /// @return Whether the approval was successful or not
34     function approve(address _spender, uint256 _value) public returns (bool success);
35 
36     /// @param _owner The address of the account owning tokens
37     /// @param _spender The address of the account able to transfer the tokens
38     /// @return Amount of remaining tokens allowed to spent
39     function allowance(address _owner, address _spender) public view returns (uint256 remaining);
40 
41     // solhint-disable-next-line no-simple-event-func-name
42     event Transfer(address indexed _from, address indexed _to, uint256 _value);
43     event Approval(address indexed _owner, address indexed _spender, uint256 _value);
44 }
45 
46 
47 contract EIP20 is EIP20Interface {
48 
49     uint256 constant private MAX_UINT256 = 2**256 - 1;
50     mapping (address => uint256) public balances;
51     mapping (address => mapping (address => uint256)) public allowed;
52     /*
53     NOTE:
54     The following variables are OPTIONAL vanities. One does not have to include them.
55     They allow one to customise the token contract & in no way influences the core functionality.
56     Some wallets/interfaces might not even bother to look at this information.
57     */
58     string public tokenName;                   //fancy name: eg Simon Bucks
59     uint8 public tokenDecimals;                //How many decimals to show.
60     string public tokenSymbol;                 //An identifier: eg SBX
61     uint256 public tokenTotalSupply;
62 
63     constructor(
64         uint256 _initialAmount,
65         string _tokenName,
66         uint8 _decimalUnits,
67         string _tokenSymbol
68     ) public {
69         balances[msg.sender] = _initialAmount;               // Give the creator all initial tokens
70         tokenTotalSupply = _initialAmount;                        // Update total supply
71         tokenName = _tokenName;                                   // Set the name for display purposes
72         tokenDecimals = _decimalUnits;                            // Amount of decimals for display purposes
73         tokenSymbol = _tokenSymbol;                               // Set the symbol for display purposes
74     }
75     
76     function name() public view returns (string) {
77         return tokenName;
78     }
79     
80     function symbol() public view returns (string) {
81         return tokenSymbol;
82     }
83     
84     function decimals() public view returns (uint8) {
85         return tokenDecimals;
86     }
87     
88     function totalSupply() public view returns (uint256) {
89         return tokenTotalSupply;
90     }
91 
92     function transfer(address _to, uint256 _value) public returns (bool success) {
93         require(balances[msg.sender] >= _value);
94         balances[msg.sender] -= _value;
95         balances[_to] += _value;
96         emit Transfer(msg.sender, _to, _value); //solhint-disable-line indent, no-unused-vars
97         return true;
98     }
99 
100     function transferFrom(address _from, address _to, uint256 _value) public returns (bool success) {
101         uint256 allowance = allowed[_from][msg.sender];
102         require(balances[_from] >= _value && allowance >= _value);
103         balances[_to] += _value;
104         balances[_from] -= _value;
105         if (allowance < MAX_UINT256) {
106             allowed[_from][msg.sender] -= _value;
107         }
108         emit Transfer(_from, _to, _value); //solhint-disable-line indent, no-unused-vars
109         return true;
110     }
111 
112     function balanceOf(address _owner) public view returns (uint256 balance) {
113         return balances[_owner];
114     }
115 
116     function approve(address _spender, uint256 _value) public returns (bool success) {
117         allowed[msg.sender][_spender] = _value;
118         emit Approval(msg.sender, _spender, _value); //solhint-disable-line indent, no-unused-vars
119         return true;
120     }
121 
122     function allowance(address _owner, address _spender) public view returns (uint256 remaining) {
123         return allowed[_owner][_spender];
124     }
125 }
126 
127 
128 
129 /**
130  * @title SafeMath
131  * @dev Math operations with safety checks that throw on error
132  */
133 library SafeMath {
134 
135   /**
136   * @dev Multiplies two numbers, throws on overflow.
137   */
138   function mul(uint256 a, uint256 b) internal pure returns (uint256 c) {
139     if (a == 0) {
140       return 0;
141     }
142     c = a * b;
143     assert(c / a == b);
144     return c;
145   }
146 
147   /**
148   * @dev Integer division of two numbers, truncating the quotient.
149   */
150   function div(uint256 a, uint256 b) internal pure returns (uint256) {
151     // assert(b > 0); // Solidity automatically throws when dividing by 0
152     // uint256 c = a / b;
153     // assert(a == b * c + a % b); // There is no case in which this doesn't hold
154     return a / b;
155   }
156 
157   /**
158   * @dev Subtracts two numbers, throws on overflow (i.e. if subtrahend is greater than minuend).
159   */
160   function sub(uint256 a, uint256 b) internal pure returns (uint256) {
161     assert(b <= a);
162     return a - b;
163   }
164 
165   /**
166   * @dev Adds two numbers, throws on overflow.
167   */
168   function add(uint256 a, uint256 b) internal pure returns (uint256 c) {
169     c = a + b;
170     assert(c >= a);
171     return c;
172   }
173 }
174 
175 
176 contract TimeBankToken is EIP20 {
177   using SafeMath for uint;
178 
179   struct Vesting {
180     uint256 startTime; // vesting start time
181     uint256 initReleaseAmount;
182     uint256 amount;
183     uint256 interval; // release N% of amount each interval.
184     uint256 periods; // count of periods
185     uint256 withdrawed; // already used amount of released part
186   }
187 
188   mapping (address => Vesting[]) vestings;
189   
190   address[] managerList;
191   mapping (address => bool) managers;
192   mapping (bytes32 => mapping (address => bool)) confirms;
193   
194   /*
195   at least <threshold> confirmations
196   */
197   uint majorityThreshold;
198   uint managementThreshold;
199 
200   address coinbase;
201   address master;
202   bool public paused;
203 
204   function checkAddress(address _addr) internal pure returns (bool) {
205     return _addr != address(0);
206   }
207 
208   // 1 with 28 zeros
209   constructor(address _master, address[] _managers, uint _majorityThreshold, uint _managementThreshold) EIP20(10000000000000000000000000000, "Time Bank Token", 18, "TB") public {
210     require(checkAddress(_master));
211     require(_managers.length >= _majorityThreshold);
212     require(_managers.length >= _managementThreshold);
213     
214     paused = false;
215     master = _master;
216     coinbase = msg.sender;
217     majorityThreshold = _majorityThreshold;
218     managementThreshold = _managementThreshold;
219 
220     for (uint i=0; i<_managers.length; i++) {
221       require(checkAddress(_managers[i]));
222       managers[_managers[i]] = true;
223     }
224     managerList = _managers;
225 
226     // initial batch operations
227     // internalPresaleVesting(0x0095F9DffeE386B650230eD3eC28891c1053aBE0, 10000, 60, 120, 240);
228     // internalPresaleVesting(0x00D4fC2CC18B96c44D9755afB6D4e6804cF827ee, 20000, 60, 120, 240);
229     // internalPresale(0x0092E41D42E834705fd07c9136Fd0b1028226bE3, 30000);
230   }
231 
232   function pause() public isMaster isNotPaused {
233     require(isEnoughConfirmed(msg.data, 1));
234     paused = true;
235   }
236 
237   function resume() public isMaster isPaused {
238     require(isEnoughConfirmed(msg.data, 1));
239     paused = false;
240   }
241 
242   modifier isPaused {
243     require(paused == true);
244     _;
245   }
246 
247   modifier isNotPaused {
248     require(paused == false);
249     _;
250   }
251 
252   modifier isManager {
253     require(managers[msg.sender]);
254     _;
255   }
256 
257   modifier isMaster {
258     require(msg.sender == master);
259     _;
260   }
261 
262   modifier isNotCoinbase {
263     require(msg.sender != coinbase);
264     _;
265   }
266 
267   function managersCount() public view returns (uint) {
268     return managerList.length;
269   }
270 
271   function isAddressManager(address _to) public view returns (bool) {
272     return managers[_to];
273   }
274 
275   function getMajorityThreshold() public view  returns (uint) {
276     return majorityThreshold;
277   }
278 
279   event MajorityThresholdChanged(uint oldThreshold, uint newThreshold);
280   event ReplaceManager(address oldAddr, address newAddr);
281   event RemoveManager(address manager);
282   event AddManager(address manager);
283 
284   function setMajorityThreshold(uint _threshold) public isMaster isNotPaused {
285     require(_threshold > 0);
286     require(isEnoughConfirmed(msg.data, managementThreshold));
287     uint oldThreshold = majorityThreshold;
288     majorityThreshold = _threshold;
289     removeConfirm(msg.data);
290     emit MajorityThresholdChanged(oldThreshold, majorityThreshold);
291   }
292 
293   function replaceManager(address _old, address _new) public isMaster isNotPaused {
294     require(checkAddress(_old));
295     require(checkAddress(_new));
296     require(isEnoughConfirmed(msg.data, managementThreshold));
297     internalRemoveManager(_old);
298     internalAddManager(_new);
299     rebuildManagerList();
300     removeConfirm(msg.data);
301     emit ReplaceManager(_old, _new);
302   }
303 
304   function removeManager(address _manager) public isMaster isNotPaused {
305     require(checkAddress(_manager));
306     require(isEnoughConfirmed(msg.data, managementThreshold));
307     require(managerList.length > managementThreshold);
308     internalRemoveManager(_manager);
309     rebuildManagerList();
310     removeConfirm(msg.data);
311     emit RemoveManager(_manager);
312   }
313 
314   function internalRemoveManager(address _manager) internal {
315     require(checkAddress(_manager));
316     managers[_manager] = false;
317   }
318 
319   function addManager(address _manager) public isMaster isNotPaused {
320     require(checkAddress(_manager));
321     require(isEnoughConfirmed(msg.data, managementThreshold));
322     internalAddManager(_manager);
323     rebuildManagerList();
324     removeConfirm(msg.data);
325     emit AddManager(_manager);
326   }
327 
328   function internalAddManager(address _manager) internal {
329     require(checkAddress(_manager));
330     managers[_manager] = true;
331     managerList.push(_manager);
332   }
333 
334   mapping (address => bool) checked;
335 
336   function rebuildManagerList() internal {
337     address[] memory res = new address[](managerList.length);
338     for (uint k=0; k<managerList.length; k++) {
339       checked[managerList[k]] = false;
340     }
341     uint j=0;
342     for (uint i=0; i<managerList.length; i++) {
343       address manager = managerList[i];
344       if (managers[manager] && checked[manager] == false) {
345         res[j] = manager;
346         checked[manager] = true;
347         j++;
348       }
349     }
350     managerList = res;
351     managerList.length = j;
352   }
353 
354   function checkData(bytes data) internal pure returns (bool) {
355     return data.length != 0;
356   }
357 
358   event Confirm(address manager, bytes data);
359   event Revoke(address manager, bytes data);
360 
361   /*
362   manager use this function to confirm a operation
363   confirm will not be call inside other functions, so it can be external to save some gas
364   @param {bytes} data is the transaction's raw input
365   */
366   function confirm(bytes data) external isManager {
367     checkData(data);
368     bytes32 op = keccak256(data);
369     if (confirms[op][msg.sender] == false) {
370       confirms[op][msg.sender] = true;
371     }
372     emit Confirm(msg.sender, data);
373   }
374 
375   /*
376   manager use this function to revoke a confirm of the operation
377   revoke will not be call inside other functions, so it can be external to save some gas
378   @param {bytes} data is the transaction's raw input
379   */
380   function revoke(bytes data) external isManager {
381     checkData(data);
382     bytes32 op = keccak256(data);
383     if (confirms[op][msg.sender] == true) {
384       confirms[op][msg.sender] = false;
385     }
386     emit Revoke(msg.sender, data);
387   }
388 
389   /*
390   check a operation is confirmed or not
391   */
392   function isConfirmed(bytes data) public view isManager returns (bool) {
393     bytes32 op = keccak256(data);
394     return confirms[op][msg.sender];
395   }
396 
397   function isConfirmedBy(bytes data, address manager) public view returns (bool) {
398     bytes32 op = keccak256(data);
399     return confirms[op][manager];
400   } 
401 
402   function isMajorityConfirmed(bytes data) public view returns (bool) {
403     return isEnoughConfirmed(data, majorityThreshold);
404   }
405 
406   function isEnoughConfirmed(bytes data, uint count) internal view returns (bool) {
407     bytes32 op = keccak256(data);
408     uint confirmsCount = 0;
409     for (uint i=0; i<managerList.length; i++) {
410       if (confirms[op][managerList[i]] == true) {
411         confirmsCount = confirmsCount.add(1);
412       }
413     }
414     return confirmsCount >= count;
415   }
416 
417   /*
418   once the operation is executed, the confirm of the operation should be removed
419   */
420   function removeConfirm(bytes data) internal {
421     bytes32 op = keccak256(data);
422     for (uint i=0; i<managerList.length; i++) {
423       confirms[op][managerList[i]] = false;
424     }
425   }
426 
427   /*
428   sale coin with time locking
429   only the manager can call this function
430   and this operation should be confirmed
431   */
432   function presaleVesting(address _to, uint256 _startTime, uint256 _initReleaseAmount, uint256 _amount, uint256 _interval, uint256 _periods) public isManager isNotPaused {
433     checkAddress(_to);
434     require(isMajorityConfirmed(msg.data));
435     internalPresaleVesting(_to, _startTime, _initReleaseAmount, _amount, _interval, _periods);
436     removeConfirm(msg.data);
437   }
438 
439   function batchPresaleVesting(address[] _to, uint256[] _startTime, uint256[] _initReleaseAmount, uint256[] _amount, uint256[] _interval, uint256[] _periods) public isManager isNotPaused {
440     require(isMajorityConfirmed(msg.data));
441     for (uint i=0; i<_to.length; i++) {
442       internalPresaleVesting(_to[i], _startTime[i], _initReleaseAmount[i], _amount[i], _interval[i], _periods[i]);
443     }
444     removeConfirm(msg.data);
445   }
446 
447   function internalPresaleVesting(address _to, uint256 _startTime, uint256 _initReleaseAmount, uint256 _amount, uint256 _interval, uint256 _periods) internal {
448     require(balances[coinbase] >= _amount);
449     require(_initReleaseAmount <= _amount);
450     require(checkAddress(_to));
451     vestings[_to].push(Vesting(
452       _startTime, _initReleaseAmount, _amount, _interval, _periods, 0
453     ));
454     balances[coinbase] = balances[coinbase].sub(_amount);
455     emit PresaleVesting(_to, _startTime, _amount, _interval, _periods);
456   }
457 
458   /*
459   sale coin without time locking
460   only the manager can call this function
461   and this operation should be confirmed
462   */
463   function presale(address _to, uint256 _value) public isManager isNotPaused {
464     require(isMajorityConfirmed(msg.data));
465     internalPresale(_to, _value);
466     removeConfirm(msg.data);
467   }
468 
469   function batchPresale(address[] _to, uint256[] _amount) public isManager isNotPaused {
470     require(isMajorityConfirmed(msg.data));
471     for (uint i=0; i<_to.length; i++) {
472       internalPresale(_to[i], _amount[i]);
473     }
474     removeConfirm(msg.data);
475   }
476 
477   function internalPresale(address _to, uint256 _value) internal {
478     require(balances[coinbase] >= _value);
479     require(checkAddress(_to));
480     balances[_to] = balances[_to].add(_value);
481     balances[coinbase] = balances[coinbase].sub(_value);
482     emit Presale(_to, _value);
483   }
484 
485   /*
486   events
487   */
488   event Presale(address indexed to, uint256 value);
489   event PresaleVesting(address indexed to, uint256 startTime, uint256 amount, uint256 interval, uint256 periods);
490 
491   /*
492   math function used to calculate vesting curve
493   */
494   function vestingFunc(uint256 _currentTime, uint256 _startTime, uint256 _initReleaseAmount, uint256 _amount, uint256 _interval, uint256 _periods) public pure returns (uint256) {
495     if (_currentTime < _startTime) {
496       return 0;
497     }
498     uint256 t = _currentTime.sub(_startTime);
499     uint256 end = _periods.mul(_interval);
500     if (t >= end) {
501       return _amount;
502     }
503     uint256 i_amount = _amount.sub(_initReleaseAmount).div(_periods);
504     uint256 i = t.div(_interval);
505     return i_amount.mul(i).add(_initReleaseAmount);
506   }
507 
508   function queryWithdrawed(uint _idx) public view returns (uint256) {
509     return vestings[msg.sender][_idx].withdrawed;
510   }
511 
512   function queryVestingRemain(uint256 _currentTime, uint _idx) public view returns (uint256) {
513     uint256 released = vestingFunc(
514       _currentTime,
515       vestings[msg.sender][_idx].startTime, vestings[msg.sender][_idx].initReleaseAmount, vestings[msg.sender][_idx].amount,
516       vestings[msg.sender][_idx].interval, vestings[msg.sender][_idx].periods
517     );
518     return released.sub(vestings[msg.sender][_idx].withdrawed);
519   }
520 
521   /*
522   calculate the released amount of vesting coin
523   it cannot be view, because this function relays on 'now'
524   */
525   function vestingReleased(uint256 _startTime, uint256 _initReleaseAmount, uint256 _amount, uint256 _interval, uint256 _periods) internal view returns (uint256) {
526     return vestingFunc(now, _startTime, _initReleaseAmount, _amount, _interval, _periods);
527   }
528 
529   /*
530   withdraw all released vesting coin to balance
531   */
532   function withdrawVestings(address _to) internal {
533     uint256 sum = 0;
534     for (uint i=0; i<vestings[_to].length; i++) {
535       if (vestings[_to][i].amount == vestings[_to][i].withdrawed) {
536         continue;
537       }
538 
539       uint256 released = vestingReleased(
540         vestings[_to][i].startTime, vestings[_to][i].initReleaseAmount, vestings[_to][i].amount,
541         vestings[_to][i].interval, vestings[_to][i].periods
542       );
543       uint256 remain = released.sub(vestings[_to][i].withdrawed);
544       if (remain >= 0) {
545         vestings[_to][i].withdrawed = released;
546         sum = sum.add(remain);
547       }
548     }
549     balances[_to] = balances[_to].add(sum);
550   }
551 
552   /*
553   sum of all vestings balance (regardless of released or not)
554   each vesting is amount - withdrawed
555   */
556   function vestingsBalance(address _to) public view returns (uint256) {
557     uint256 sum = 0;
558     for (uint i=0; i<vestings[_to].length; i++) {
559       sum = sum.add(vestings[_to][i].amount.sub(vestings[_to][i].withdrawed));
560     }
561     return sum;
562   }
563 
564   /*
565   sum of all remaining vestings balance (only the released part)
566   released - withdrawed
567   */
568   function vestingsReleasedRemain(address _to) internal view returns (uint256) {
569     uint256 sum = 0;
570     for (uint i=0; i<vestings[_to].length; i++) {
571       uint256 released = vestingReleased(
572         vestings[_to][i].startTime, vestings[_to][i].initReleaseAmount, vestings[_to][i].amount,
573         vestings[_to][i].interval, vestings[_to][i].periods
574       );
575       sum = sum.add(released.sub(vestings[_to][i].withdrawed));
576     }
577     return sum;
578   }
579 
580   /*
581   total balance
582   sum of vestings balance (includes not released part) and unlocking coin balance
583   */
584   function balanceOf(address _to) public view returns (uint256) {
585     uint256 vbalance = vestingsBalance(_to);
586     return vbalance.add(super.balanceOf(_to));
587   }
588 
589   /*
590   sum of vestings balance and unlocking coin balance
591   */
592   function vestingsRemainBalance(address _to) internal view returns (uint256) {
593     return vestingsReleasedRemain(_to).add(super.balanceOf(_to));
594   }
595 
596   /*
597   transfer <_value> coin from <msg.sender> to <_to> address
598   1. check remain balance
599   2. withdraw all vesting coin to balance
600   3. call original ERC20 transafer function
601   */
602   function transfer(address _to, uint256 _value) public isNotCoinbase isNotPaused returns (bool) {
603     checkAddress(_to);
604     uint256 remain = vestingsRemainBalance(msg.sender);
605     require(remain >= _value);
606     withdrawVestings(msg.sender);
607     return super.transfer(_to, _value);
608   }
609 
610   /*
611   transferFrom <_value> coin from <_from> to <_to> address
612   1. check remain balance
613   2. withdraw all vesting coin to balance
614   3. call original ERC20 transafer function
615   */
616   function transferFrom(address _from, address _to, uint256 _value) public isNotPaused returns (bool) {
617     checkAddress(_from);
618     checkAddress(_to);
619     uint256 remain = vestingsRemainBalance(_from);
620     require(remain >= _value);
621     withdrawVestings(_from);
622     return super.transferFrom(_from, _to, _value);
623   }
624 
625   /*
626   approve <_value> coin from <_from> to <_to> address
627   1. check remain balance
628   2. withdraw all vesting coin to balance
629   3. call original ERC20 transafer function
630   */
631   function approve(address _spender, uint256 _value) public isNotCoinbase isNotPaused returns (bool) {
632     checkAddress(_spender);
633     uint256 remain = vestingsRemainBalance(msg.sender);
634     require(remain >= _value);
635     withdrawVestings(msg.sender);
636     return super.approve(_spender, _value);
637   }
638 
639   function allowance(address _owner, address _spender) public view returns (uint256) {
640     return super.allowance(_owner, _spender);
641   }
642 }