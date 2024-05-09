1 pragma solidity ^0.5.1;
2 
3 contract NIOX {
4     uint256 public peopleCount = 0;
5     
6     mapping(address => Person ) public people;
7     
8     uint256 constant stage11 = 1584016200; // ---- Thursday, March 12, 2020 6:00:00 PM GMT+05:30
9     uint256 constant stage12 = 1591964999; // ---- Friday, June 12, 2020 5:59:59 PM GMT+05:30
10     uint256 constant stage21 = 1591965000; // ---- Friday, June 12, 2020 6:00:00 PM GMT+05:30
11     uint256 constant stage22 = 1597235399; // ---- Wednesday, August 12, 2020 5:59:59 PM GMT+05:30
12     uint256 constant stage31 = 1597235400; // ---- Wednesday, August 12, 2020 6:00:00 PM GMT+05:30
13     uint256 constant stage32 = 1599913799; // ---- Saturday, September 12, 2020 5:59:59 PM GMT+05:30
14     
15     uint256 constant oneyear = 31556926; // 31556926 secs = 1 YEAR
16     
17     
18     uint256 constant sixmonth = 15778458; // 6 month
19    uint256 constant addAddressLastDate = 1609404905;// DEc 31, 2020 5:59:59 PM GMT+05:30
20    uint256 constant minStakeAmt = 3000000000;
21 
22     
23     // Status of user's address that he has withdrew NIOX or staked or haven't decided yet
24     enum userState {Withdraw, Staked, NotDecided}
25     
26     // Status of user's address after claiming their tokens
27     enum withdrawState {NotWithdraw, PartiallyWithdraw, FullyWithdraw}
28     
29     //users remaining claimed tokens
30     enum remainToken {stage0, stage1, stage2, stage3, stage4}
31     
32     // Token name
33     string public constant name = "AutonioK";
34 
35     // Token symbol
36     string public constant symbol = "NIOXK";
37 
38 	// Token decimals
39     uint8 public constant decimals = 4;
40     
41     // Contract owner will be your Link account
42     address public owner;
43 
44     address public treasury;
45 
46     uint256 public totalSupply;
47 
48     mapping (address => mapping (address => uint256)) private allowed;
49     mapping (address => uint256) private balances;
50 
51     event Approval(address indexed tokenholder, address indexed spender, uint256 value);
52     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
53     event Transfer(address indexed from, address indexed to, uint256 value);
54     event AddedNewUser(address indexed, uint _value);
55 
56     modifier onlyOwner() {
57         require(msg.sender == owner);
58         _;
59     }   
60 
61     modifier checkUser() {
62         require(msg.sender == people[msg.sender]._address);
63         _;
64     }
65 
66     struct Person {
67         uint _id;
68         address _address;
69         uint256 _value;
70         uint256 _txHashAddress;
71         userState _userState;
72         withdrawState _withdrawState;
73         remainToken _remainToken;
74         uint256 _blocktimestamp;
75         uint256 _userStateBlocktimestamp;
76     }
77 
78     constructor() public {
79         owner = msg.sender;
80 
81         // Add your wallet address here which will contain your total token supply
82         treasury = owner;
83 
84         // Set your total token supply (default 1000)
85         totalSupply = 3000000000000;
86 
87         balances[treasury] = totalSupply;
88         emit Transfer(address(0), treasury, totalSupply);
89     }
90 
91     function () external payable {
92         revert();
93     }
94 
95     function allowance(address _tokenholder, address _spender) public view returns (uint256 remaining) {
96         return allowed[_tokenholder][_spender];
97     }
98 
99     function approve(address _spender, uint256 _value) public returns (bool) {
100         require(_spender != address(0));
101         require(_spender != msg.sender);
102 
103         allowed[msg.sender][_spender] = _value;
104 
105         emit Approval(msg.sender, _spender, _value);
106 
107         return true;
108     }
109 
110     function balanceOf(address _tokenholder) public view returns (uint256 balance) {
111         return balances[_tokenholder];
112     }
113 
114     function decreaseApproval(address _spender, uint _subtractedValue) public returns (bool success) {
115         require(_spender != address(0));
116         require(_spender != msg.sender);
117 
118         if (allowed[msg.sender][_spender] <= _subtractedValue) {
119             allowed[msg.sender][_spender] = 0;
120         } else {
121             allowed[msg.sender][_spender] = allowed[msg.sender][_spender] - _subtractedValue;
122         }
123 
124         emit Approval(msg.sender, _spender, allowed[msg.sender][_spender]);
125 
126         return true;
127     }
128 
129     function increaseApproval(address _spender, uint _addedValue) public returns (bool success) {
130         require(_spender != address(0));
131         require(_spender != msg.sender);
132         require(allowed[msg.sender][_spender] <= allowed[msg.sender][_spender] + _addedValue);
133 
134         allowed[msg.sender][_spender] = allowed[msg.sender][_spender] + _addedValue;
135 
136         emit Approval(msg.sender, _spender, allowed[msg.sender][_spender]);
137 
138         return true;
139     }
140 
141     function transfer(address _to, uint256 _value) public returns (bool) {
142         require(_to != msg.sender);
143         require(_to != address(0));
144         require(_to != address(this));
145         require(balances[msg.sender] - _value <= balances[msg.sender]);
146         require(balances[_to] <= balances[_to] + _value);
147         require(_value <= transferableTokens(msg.sender));
148 
149         balances[msg.sender] = balances[msg.sender] - _value;
150         balances[_to] = balances[_to] + _value;
151 
152         emit Transfer(msg.sender, _to, _value);
153 
154         return true;
155     }
156 
157     function transferFrom(address _from, address _to, uint256 _value) public returns (bool) {
158         require(_from != address(0));
159         require(_from != address(this));
160         require(_to != _from);
161         require(_to != address(0));
162         require(_to != address(this));
163         require(_value <= transferableTokens(_from));
164         require(allowed[_from][msg.sender] - _value <= allowed[_from][msg.sender]);
165         require(balances[_from] - _value <= balances[_from]);
166         require(balances[_to] <= balances[_to] + _value);
167         allowed[_from][msg.sender] = allowed[_from][msg.sender] - _value;
168         balances[_from] = balances[_from] - _value;
169         balances[_to] = balances[_to] + _value;
170 
171         emit Transfer(_from, _to, _value);
172 
173         return true;
174     }
175 
176     function transferOwnership(address _newOwner) public {
177         require(msg.sender == owner);
178         require(_newOwner != address(0));
179         require(_newOwner != address(this));
180         require(_newOwner != owner);
181 
182         address previousOwner = owner;
183         owner = _newOwner;
184 
185         emit OwnershipTransferred(previousOwner, _newOwner);
186     }
187 
188     function transferableTokens(address holder) public view returns (uint256) {
189         return balanceOf(holder);
190     }
191     
192     function addAddress(address _useraddress, uint256 _value, uint256 _txHashAddress, userState _userState, withdrawState _withdrawState, remainToken _remainToken) public onlyOwner {
193         
194         require(people[_useraddress]._address != _useraddress);
195         require(block.timestamp <= addAddressLastDate);
196         
197         incrementCount();
198         people[_useraddress] = Person(peopleCount, _useraddress, _value, _txHashAddress, _userState, _withdrawState, _remainToken, block.timestamp, 0);
199     }
200     
201     function incrementCount() internal {
202         peopleCount += 1;
203     }
204     
205     function getRemainTokenCount(address  _address) public view returns (uint256 tokens) {
206         
207         require(_address == people[_address]._address);
208         
209         if(people[_address]._remainToken == remainToken.stage0) {
210             
211             return people[_address]._value;
212         }
213         
214         else if(people[_address]._remainToken == remainToken.stage1) {
215             
216             return people[_address]._value / 100 * 50;
217         }
218         
219         else if(people[_address]._remainToken == remainToken.stage2) {
220             
221             return people[_address]._value / 100 * 30;
222         }
223         
224         else if(people[_address]._remainToken == remainToken.stage3) {
225             
226             return people[_address]._value / 100 * 20;
227         }
228         
229         else if(people[_address]._remainToken == remainToken.stage4) {
230             
231             return 0;
232         }
233     }
234     
235     function getWithdrawTokenCount(address  _address) public view returns (uint256 tokens) {
236         
237         require(_address == people[_address]._address);
238         
239         if(people[_address]._remainToken == remainToken.stage0) {
240             
241             return 0;
242         }
243         
244         else if(people[_address]._remainToken == remainToken.stage1) {
245             
246             return people[_address]._value / 100 * 50;
247         }
248         
249         else if(people[_address]._remainToken == remainToken.stage2) {
250             
251             return people[_address]._value / 100 * 70;
252         }
253         
254         else if(people[_address]._remainToken == remainToken.stage3) {
255             
256             return people[_address]._value / 100 * 80;
257         }
258         
259         else if(people[_address]._remainToken == remainToken.stage4) {
260             
261             return people[_address]._value;
262         }
263     }
264     
265     function getUserState(address _address) public view returns (userState){
266         
267         require(_address == people[_address]._address);
268         
269         return people[_address]._userState;
270     }
271     
272     function withdrawOrStake(userState _userStates) public returns (bool) {
273         
274         require(msg.sender == people[msg.sender]._address);
275         require(people[msg.sender]._userState == userState.NotDecided);
276         require(people[msg.sender]._userStateBlocktimestamp == 0);
277         
278         if(people[msg.sender]._userState == userState.NotDecided && _userStates == userState.Withdraw){
279             people[msg.sender]._userState = userState.Withdraw;
280             people[msg.sender]._userStateBlocktimestamp = block.timestamp;
281             return true;
282         }
283         else if(people[msg.sender]._userState == userState.NotDecided && _userStates == userState.Staked && people[msg.sender]._value >= minStakeAmt ){
284             people[msg.sender]._userState = userState.Staked;
285             people[msg.sender]._userStateBlocktimestamp = block.timestamp;
286             return true;
287         }
288         else {
289             return false;
290         }
291         
292     }
293     
294     function changeStakeToWithdraw() public checkUser returns (bool) {
295         
296         require(msg.sender == people[msg.sender]._address);
297         require(people[msg.sender]._userState == userState.Staked);
298         require(people[msg.sender]._userStateBlocktimestamp != 0);
299         require(block.timestamp >= (people[msg.sender]._userStateBlocktimestamp + sixmonth));
300         
301         if(people[msg.sender]._userState == userState.Staked){
302             people[msg.sender]._userState = userState.Withdraw;
303             // people[msg.sender]._blocktimestamp = block.timestamp;
304             return true;
305         }
306         
307     }
308     
309     function withdrawToken() public checkUser returns (bool){
310         
311         require(msg.sender == people[msg.sender]._address);
312         require(people[msg.sender]._userState == userState.Withdraw);
313         require(people[msg.sender]._userStateBlocktimestamp != 0);
314         require(people[msg.sender]._withdrawState == withdrawState.NotWithdraw);
315         require(people[msg.sender]._remainToken == remainToken.stage0);
316         
317         if (block.timestamp >= stage11 && block.timestamp <= stage12 ){
318             
319             uint256 clamimTkn = people[msg.sender]._value / 100 * 50; 
320              require(owner != msg.sender);
321              require(balances[owner] - clamimTkn <= balances[owner]);
322              require(balances[msg.sender] <= balances[msg.sender] + clamimTkn);
323              require(clamimTkn <= transferableTokens(owner));
324         
325             balances[owner] = balances[owner] - clamimTkn;
326             balances[msg.sender] = balances[msg.sender] + clamimTkn;
327     
328             emit Transfer(owner, msg.sender, clamimTkn);
329             
330             people[msg.sender]._withdrawState = withdrawState.PartiallyWithdraw;
331             people[msg.sender]._remainToken = remainToken.stage1;
332             people[msg.sender]._blocktimestamp = block.timestamp;
333             
334             return true;
335         }
336         else if (block.timestamp > stage21 && block.timestamp <= stage22 ){
337             
338             uint256 clamimTkn = people[msg.sender]._value / 100 * 70; 
339              require(owner != msg.sender);
340              require(balances[owner] - clamimTkn <= balances[owner]);
341              require(balances[msg.sender] <= balances[msg.sender] + clamimTkn);
342              require(clamimTkn <= transferableTokens(owner));
343         
344             balances[owner] = balances[owner] - clamimTkn;
345             balances[msg.sender] = balances[msg.sender] + clamimTkn;
346     
347             emit Transfer(owner, msg.sender, clamimTkn);
348             
349             people[msg.sender]._withdrawState = withdrawState.PartiallyWithdraw;
350             people[msg.sender]._remainToken = remainToken.stage2;
351             people[msg.sender]._blocktimestamp = block.timestamp;
352             
353             return true;
354         }
355         else if (block.timestamp > stage31 && block.timestamp <= stage32 ){
356             
357             uint256 clamimTkn = people[msg.sender]._value / 100 * 80; 
358              require(owner != msg.sender);
359              require(balances[owner] - clamimTkn <= balances[owner]);
360              require(balances[msg.sender] <= balances[msg.sender] + clamimTkn);
361              require(clamimTkn <= transferableTokens(owner));
362         
363             balances[owner] = balances[owner] - clamimTkn;
364             balances[msg.sender] = balances[msg.sender] + clamimTkn;
365     
366             emit Transfer(owner, msg.sender, clamimTkn);
367             
368             people[msg.sender]._withdrawState = withdrawState.PartiallyWithdraw;
369             people[msg.sender]._remainToken = remainToken.stage3;
370             people[msg.sender]._blocktimestamp = block.timestamp;
371             
372             return true;
373         }
374         else if (block.timestamp > stage32){
375             
376             uint256 clamimTkn = people[msg.sender]._value; 
377              require(owner != msg.sender);
378              require(balances[owner] - clamimTkn <= balances[owner]);
379              require(balances[msg.sender] <= balances[msg.sender] + clamimTkn);
380              require(clamimTkn <= transferableTokens(owner));
381         
382             balances[owner] = balances[owner] - clamimTkn;
383             balances[msg.sender] = balances[msg.sender] + clamimTkn;
384     
385             emit Transfer(owner, msg.sender, clamimTkn);
386             
387             people[msg.sender]._withdrawState = withdrawState.FullyWithdraw;
388             people[msg.sender]._remainToken = remainToken.stage4;
389             people[msg.sender]._blocktimestamp = block.timestamp;
390             
391             return true;
392         }
393     }
394     
395     function withdrawRemainPenaltyToken() public checkUser returns (bool){
396         
397         require(msg.sender == people[msg.sender]._address);
398         require(people[msg.sender]._userState == userState.Withdraw);
399         require(people[msg.sender]._withdrawState == withdrawState.PartiallyWithdraw);
400         require(block.timestamp >= people[msg.sender]._blocktimestamp + oneyear);
401         
402         if (people[msg.sender]._remainToken == remainToken.stage1){
403             
404             uint256 clamimTkn = people[msg.sender]._value / 100 * 50; 
405              require(owner != msg.sender);
406              require(balances[owner] - clamimTkn <= balances[owner]);
407              require(balances[msg.sender] <= balances[msg.sender] + clamimTkn);
408              require(clamimTkn <= transferableTokens(owner));
409         
410             balances[owner] = balances[owner] - clamimTkn;
411             balances[msg.sender] = balances[msg.sender] + clamimTkn;
412     
413             emit Transfer(owner, msg.sender, clamimTkn);
414             people[msg.sender]._withdrawState = withdrawState.FullyWithdraw;
415             people[msg.sender]._remainToken = remainToken.stage4;
416             
417             return true;
418         }
419         else if (people[msg.sender]._remainToken == remainToken.stage2){
420             
421             uint256 clamimTkn = people[msg.sender]._value / 100 * 30; 
422              require(owner != msg.sender);
423              require(balances[owner] - clamimTkn <= balances[owner]);
424              require(balances[msg.sender] <= balances[msg.sender] + clamimTkn);
425              require(clamimTkn <= transferableTokens(owner));
426         
427             balances[owner] = balances[owner] - clamimTkn;
428             balances[msg.sender] = balances[msg.sender] + clamimTkn;
429     
430             emit Transfer(owner, msg.sender, clamimTkn);
431             
432             people[msg.sender]._withdrawState = withdrawState.FullyWithdraw;
433             people[msg.sender]._remainToken = remainToken.stage4;
434             
435             return true;
436         }
437         else if (people[msg.sender]._remainToken == remainToken.stage3){
438             
439             uint256 clamimTkn = people[msg.sender]._value / 100 * 20; 
440              require(owner != msg.sender);
441              require(balances[owner] - clamimTkn <= balances[owner]);
442              require(balances[msg.sender] <= balances[msg.sender] + clamimTkn);
443              require(clamimTkn <= transferableTokens(owner));
444         
445             balances[owner] = balances[owner] - clamimTkn;
446             balances[msg.sender] = balances[msg.sender] + clamimTkn;
447     
448             emit Transfer(owner, msg.sender, clamimTkn);
449             
450             people[msg.sender]._withdrawState = withdrawState.FullyWithdraw;
451             people[msg.sender]._remainToken = remainToken.stage4;
452             
453             return true;
454         }
455     }
456     
457     function remainPenaltyClaimDate(address  _address) public view returns (uint256 date) {
458         
459          require(_address == people[_address]._address);
460          require(people[_address]._withdrawState == withdrawState.PartiallyWithdraw);
461          require(people[_address]._userState == userState.Withdraw);
462          
463          return people[_address]._blocktimestamp + oneyear;
464         
465     }
466 }
467 contract Token {
468     function totalSupply() external view returns (uint256 _totalSupply){}
469     function balanceOf(address _owner) external view returns (uint256 _balance){}
470     function transfer(address _to, uint256 _value) external returns (bool _success){}
471     function transferFrom(address _from, address _to, uint256 _value) external returns (bool _success){}
472     function approve(address _spender, uint256 _value) external returns (bool _success){}
473     function allowance(address _owner, address _spender) external view returns (uint256 _remaining){}
474 
475     event Transfer(address indexed _from, address indexed _to, uint256 _value);
476     event Approval(address indexed _owner, address indexed _spender, uint256 _value);
477 }
478 
479 contract Staking {
480     
481     uint256 public peopleCount = 0;
482     
483     mapping(address => Person ) public people;
484     
485     mapping(address => BlockUser ) public blockpeople;
486     
487     // for new users
488     uint256 constant stage11 = 1597708801; // ---- Tuesday, August 18, 2020 12:00:01 AM
489     uint256 constant stage12 = 1605657600; // ---- Wednesday, November 18, 2020 12:00:00 AM
490     uint256 constant stage21 = 1605657601; // ---- Wednesday, November 18, 2020 12:00:01 AM
491     uint256 constant stage22 = 1610928000; // ---- Monday, January 18, 2021 12:00:00 AM
492     uint256 constant stage31 = 1610928001; // ---- Monday, January 18, 2021 12:00:01 AM
493     uint256 constant stage32 = 1613606400; // ---- Thursday, February 18, 2021 12:00:00 AM
494     
495     
496     //for old users
497     uint256 constant ostage11 = 1584016200; // ---- Thursday, March 12, 2020 6:00:00 PM GMT+05:30
498     uint256 constant ostage12 = 1591964999; // ---- Friday, June 12, 2020 5:59:59 PM GMT+05:30
499     uint256 constant ostage21 = 1591965000; // ---- Friday, June 12, 2020 6:00:00 PM GMT+05:30
500     uint256 constant ostage22 = 1597235399; // ---- Wednesday, August 12, 2020 5:59:59 PM GMT+05:30
501     uint256 constant ostage31 = 1597235400; // ---- Wednesday, August 12, 2020 6:00:00 PM GMT+05:30
502     uint256 constant ostage32 = 1599913799; // ---- Saturday, September 12, 2020 5:59:59 PM GMT+05:30
503     
504     uint256 constant oneyear = 31556926; // 31556926 secs = 1 YEAR
505     
506     
507     uint256 constant sixmonth = 15778458; // 6 month
508     uint256 constant day21 = 1814400; // 21 days /3 weeks;
509     
510     uint256 constant minStakeAmt = 3000000000;
511 
512     
513     // Status of user's address that he has withdrew NIOX or staked or haven't decided yet
514     enum userState {Withdraw, Staked, NotDecided}
515     userState UserState;
516     
517     // Status of user's address after claiming their tokens
518     enum withdrawState {NotWithdraw, PartiallyWithdraw, FullyWithdraw}
519     
520     //users remaining claimed tokens
521     enum remainToken {stage0, stage1, stage2, stage3, stage4}
522     
523 
524     NIOX token;
525     
526     NIOX Ntoken;
527     
528     address public owner;
529 
530     mapping (address => mapping (address => uint256)) private allowed;
531     mapping (address => uint256) private balances;
532 
533     event Approval(address indexed tokenholder, address indexed spender, uint256 value);
534     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
535     event Transfer(address indexed from, address indexed to, uint256 value);
536     event AddedNewUser(address indexed, uint _value);
537 
538     modifier onlyOwner() {
539         require(msg.sender == owner,"You are not Authorize to call this function");
540         _;
541     }   
542 
543     modifier checkUser() {
544         require(msg.sender == people[msg.sender]._address);
545         _;
546     }
547 
548     struct stakeData{
549         uint256 id;
550         uint256 amt; 
551         uint256 _stakeTimeStamp;
552         uint256 _withdrawTimestamp;
553         uint256 _withdrawOrNotyet;
554     }
555 
556     struct Person {
557         uint _id;
558         address _address;
559         uint256 _value;
560         uint256 _txHashAddress;
561         userState _userState;
562         withdrawState _withdrawState;
563         remainToken _remainToken;
564         uint256 _blocktimestamp;
565         uint256 _userStateBlocktimestamp;
566         uint256 _stakeCounter; 
567         uint256 _withdrawTimestamp;
568         mapping(uint256 => stakeData) stakeStruct; 
569     }
570     
571     struct BlockUser {
572         address _address;
573     }
574 
575    
576     constructor() public {
577         owner = msg.sender;
578     
579         token = NIOX(0x9cEc335cf6922eeb5A563C871D1F09f2cf264230); // old niox token
580         
581         Ntoken = NIOX(0xc813EA5e3b48BEbeedb796ab42A30C5599b01740); // new niox token
582     }
583 
584     function () external payable {
585         revert();
586     }
587 
588     function addAddressExisting() public {
589         
590         require(people[msg.sender]._address != msg.sender,"You are already added");
591         require(getPeopleAddress(msg.sender) == msg.sender,"You are not addded to previous contract");
592         
593         incrementCount();
594         
595         (,address addres,uint256 value,uint256 txhash,,,,uint256 bts,uint256 usbts) = token.people(msg.sender);
596         userState us = getUserStateData(msg.sender);
597         withdrawState ws = getWithdrawStateData(msg.sender);
598         remainToken rt = getRemainTokenData(msg.sender);
599        
600         people[msg.sender] = Person(peopleCount, addres, value, txhash,us,ws,rt,bts,usbts,0,0);
601         
602         if(us == Staking.userState.Staked){
603             Person storage t =  people[msg.sender];
604             people[msg.sender]._stakeCounter += 1;
605             t.stakeStruct[people[msg.sender]._stakeCounter] = stakeData(people[msg.sender]._stakeCounter ,value,usbts,0,0);
606             
607         }
608     }
609     
610     function addAddressNew(address _useraddress, uint256 _value, uint256 _txHashAddress, userState _userState, withdrawState _withdrawState, remainToken _remainToken) public onlyOwner {
611         
612         require(people[_useraddress]._address != _useraddress, "You are already added");
613         require(getPeopleAddress(_useraddress) != _useraddress, "You are in previous contract try to add from addAddressExisting method");
614         
615         incrementCount();
616         people[_useraddress] = Person(peopleCount, _useraddress, _value, _txHashAddress, _userState, _withdrawState, _remainToken, block.timestamp, 0,0,0);
617 
618     }
619     
620     function blockuser(address _useraddress) public onlyOwner {
621         
622         require(blockpeople[_useraddress]._address != _useraddress, "Already Blocked");
623         
624         blockpeople[_useraddress] = BlockUser(_useraddress);
625         
626     }
627 
628     function unblockuser(address _useraddress) public onlyOwner {
629         
630         require(blockpeople[_useraddress]._address == _useraddress, "Already Blocked");
631         
632         // blockpeople[_useraddress] = BlockUser();
633         delete blockpeople[_useraddress];
634         
635     }
636     
637     function chkUserInPreviousContract(address _useraddress) public view returns(bool){
638         
639         if(getPeopleAddress(_useraddress) == _useraddress){
640             return true;
641         } else {
642             return false;
643         }
644     }
645     
646     function stake(uint256 _amt) public {
647          
648          require(people[msg.sender]._address == msg.sender, "You are not added");
649          
650          Person storage t =  people[msg.sender]; 
651         
652          if (people[msg.sender]._stakeCounter == 0 ){
653              
654              if(_amt >= minStakeAmt){
655                  // call approve manually
656                 require(Ntoken.transferFrom((msg.sender),address(this), _amt));
657          
658                 
659                  people[msg.sender]._stakeCounter += 1;
660                  t.stakeStruct[people[msg.sender]._stakeCounter] = stakeData(people[msg.sender]._stakeCounter, _amt, block.timestamp,0,0);
661                  people[msg.sender]._userState = userState.Staked;
662                  
663              }
664              else {
665                  revert();
666              }
667         
668          }
669          else if (people[msg.sender]._stakeCounter > 0 ){  // if not first then chk last unstake
670              
671              if(t.stakeStruct[people[msg.sender]._stakeCounter]._withdrawTimestamp == 0){
672                  // call approve manually
673                   require(Ntoken.transferFrom((msg.sender),address(this), _amt));
674                  
675                  people[msg.sender]._stakeCounter += 1;
676                  t.stakeStruct[people[msg.sender]._stakeCounter] = stakeData(people[msg.sender]._stakeCounter, _amt, block.timestamp,0,0);
677              
678              }
679              else if (t.stakeStruct[people[msg.sender]._stakeCounter]._withdrawTimestamp > 0){
680                  
681                  if(_amt >= minStakeAmt){
682                      // call approve manually
683                   require(Ntoken.transferFrom((msg.sender),address(this), _amt));
684          
685                 
686                  people[msg.sender]._stakeCounter += 1;
687                  t.stakeStruct[people[msg.sender]._stakeCounter] = stakeData(people[msg.sender]._stakeCounter, _amt, block.timestamp,0,0);
688                  people[msg.sender]._userState = userState.Staked;
689                  
690                  }
691                  else {
692                      revert();
693                  }
694                  
695              }
696              
697          }
698          
699     }
700     
701     function stakeForOther(uint256 _amt, address _useraddress) public onlyOwner {
702          
703          require(people[_useraddress]._address == _useraddress, "adress are not added");
704          
705          Person storage t =  people[_useraddress]; 
706         
707                  // call approve manually
708                  require(Ntoken.transferFrom(msg.sender,address(this), _amt));
709          
710                 
711                  people[_useraddress]._stakeCounter += 1;
712                  t.stakeStruct[people[_useraddress]._stakeCounter] = stakeData(people[_useraddress]._stakeCounter, _amt, block.timestamp,0,0);
713                  people[_useraddress]._userState = userState.Staked;
714          
715     }
716 
717     function totalStaked(address _useraddress) public view returns(uint256 _totalStakes) {
718            _totalStakes = 0;
719            Person storage t =  people[_useraddress];
720            for (uint256 s = 1; s <= people[_useraddress]._stakeCounter; s += 1){
721                if(t.stakeStruct[s]._withdrawTimestamp == 0){
722                    _totalStakes += t.stakeStruct[s].amt;
723                }
724                
725            }
726       
727       return _totalStakes;
728    }
729   
730     function getStakeTokenById(uint256 _tokenId, address _useraddress) public view returns(address, uint256, uint256,uint256, uint256) {
731       Person storage t =  people[_useraddress];
732       return (t._address, t.stakeStruct[_tokenId].amt,t.stakeStruct[_tokenId]._stakeTimeStamp ,t.stakeStruct[_tokenId]._withdrawTimestamp, t.stakeStruct[_tokenId]._withdrawOrNotyet);
733     }
734     
735     function getUserStateData(address _useraddress) internal view returns(userState){
736         (,,,,NIOX.userState us,,,,) = token.people(_useraddress);
737         if(us == NIOX.userState.NotDecided){
738         return Staking.userState.NotDecided;
739          }
740         else if(us == NIOX.userState.Withdraw){
741             return Staking.userState.Withdraw;
742         }
743         else if(us == NIOX.userState.Staked){
744             return Staking.userState.Staked;
745         }
746     }
747     
748     function getWithdrawStateData(address _useraddress) internal view returns(withdrawState){
749         (,,,,,NIOX.withdrawState ws,,,) = token.people(_useraddress);
750         if(ws == NIOX.withdrawState.NotWithdraw){
751         return Staking.withdrawState.NotWithdraw;
752          }
753         else if(ws == NIOX.withdrawState.PartiallyWithdraw){
754             return Staking.withdrawState.PartiallyWithdraw;
755         }
756         else if(ws == NIOX.withdrawState.FullyWithdraw){
757             return Staking.withdrawState.FullyWithdraw;
758         }
759     }
760     
761     function getRemainTokenData(address _useraddress) internal view returns(remainToken){
762         (,,,,,,NIOX.remainToken rt,,) = token.people(_useraddress);
763         if(rt == NIOX.remainToken.stage0){
764         return Staking.remainToken.stage0;
765          }
766         else if(rt == NIOX.remainToken.stage1){
767             return Staking.remainToken.stage1;
768         }
769         else if(rt == NIOX.remainToken.stage2){
770             return Staking.remainToken.stage2;
771         }
772         else if(rt == NIOX.remainToken.stage3){
773             return Staking.remainToken.stage3;
774         }
775         else if(rt == NIOX.remainToken.stage4){
776             return Staking.remainToken.stage4;
777         }
778     }
779     
780     function getUsbtsData(address _useraddress) internal view returns(uint256 usbts){
781         (,,,,,,,,uint256 _usbts) = token.people(_useraddress);
782         return _usbts;
783     }
784     
785     function getPeopleAddress(address _addr)  internal view returns (address _addres){
786             (,address _address,,,,,,,) = token.people(_addr);
787             return _address;
788     }
789     
790     function incrementCount() internal {
791         peopleCount += 1;
792     }
793     
794     function getRemainTokenCount(address  _address) public view returns (uint256 tokens) {
795         
796         require(_address == people[_address]._address);
797         
798         if(people[_address]._remainToken == remainToken.stage0) {
799             
800             return people[_address]._value;
801         }
802         
803         else if(people[_address]._remainToken == remainToken.stage1) {
804             
805             return people[_address]._value / 100 * 50;
806         }
807         
808         else if(people[_address]._remainToken == remainToken.stage2) {
809             
810             return people[_address]._value / 100 * 30;
811         }
812         
813         else if(people[_address]._remainToken == remainToken.stage3) {
814             
815             return people[_address]._value / 100 * 20;
816         }
817         
818         else if(people[_address]._remainToken == remainToken.stage4) {
819             
820             return 0;
821         }
822     }
823     
824     function getWithdrawTokenCount(address  _address) public view returns (uint256 tokens) {
825         
826         require(_address == people[_address]._address);
827         
828         if(people[_address]._remainToken == remainToken.stage0) {
829             
830             return 0;
831         }
832         
833         else if(people[_address]._remainToken == remainToken.stage1) {
834             
835             return people[_address]._value / 100 * 50;
836         }
837         
838         else if(people[_address]._remainToken == remainToken.stage2) {
839             
840             return people[_address]._value / 100 * 70;
841         }
842         
843         else if(people[_address]._remainToken == remainToken.stage3) {
844             
845             return people[_address]._value / 100 * 80;
846         }
847         
848         else if(people[_address]._remainToken == remainToken.stage4) {
849             
850             return people[_address]._value;
851         }
852     }
853     
854     function getUserState(address _address) public view returns (userState){
855         
856         require(_address == people[_address]._address);
857         
858         return people[_address]._userState;
859     }
860     
861     function withdrawOrStake(userState _userStates) public returns (bool) {
862         
863         require(msg.sender == people[msg.sender]._address);
864         require(people[msg.sender]._userState == userState.NotDecided);
865         require(people[msg.sender]._userStateBlocktimestamp == 0);
866         
867         if(people[msg.sender]._userState == userState.NotDecided && _userStates == userState.Withdraw){
868             people[msg.sender]._userState = userState.Withdraw;
869             people[msg.sender]._userStateBlocktimestamp = block.timestamp;
870             return true;
871         }
872         else if(people[msg.sender]._userState == userState.NotDecided && _userStates == userState.Staked && people[msg.sender]._value >= minStakeAmt ){
873             people[msg.sender]._userState = userState.Staked;
874             people[msg.sender]._userStateBlocktimestamp = block.timestamp;
875             
876             Person storage t =  people[msg.sender];
877             people[msg.sender]._stakeCounter += 1;
878             t.stakeStruct[people[msg.sender]._stakeCounter] = stakeData(people[msg.sender]._stakeCounter ,people[msg.sender]._value,block.timestamp,0,0);
879             
880             return true;
881         }
882         else {
883             return false;
884         }
885         
886     }
887     
888     function getFirstStakeDate(address _useraddress) public view returns(uint256) {
889          require(_useraddress == people[_useraddress]._address);
890          require(_useraddress != blockpeople[_useraddress]._address);
891          Person storage t =  people[_useraddress];
892          
893          for (uint256 s0 = 1; s0 <= people[_useraddress]._stakeCounter; s0 += 1){
894                if(t.stakeStruct[s0]._withdrawTimestamp == 0){
895                    uint256 _firstStakeTimestamp = t.stakeStruct[s0]._stakeTimeStamp;
896                    return _firstStakeTimestamp;
897                }
898            }
899     }
900     
901     function unstakeRequest() public {
902         require(msg.sender == people[msg.sender]._address);
903         require(msg.sender != blockpeople[msg.sender]._address);
904         require(getFirstStakeDate(msg.sender) != 0 );
905         require(block.timestamp >= getFirstStakeDate(msg.sender) + sixmonth);
906         Person storage t =  people[msg.sender];
907         require(t.stakeStruct[people[msg.sender]._stakeCounter]._withdrawTimestamp == 0);
908          
909         for (uint256 s = 1; s <= people[msg.sender]._stakeCounter; s += 1){
910                        if(t.stakeStruct[s]._withdrawTimestamp == 0){ //chk that previos withdraws
911                            t.stakeStruct[s]._withdrawTimestamp = block.timestamp;
912                            t.stakeStruct[s]._withdrawOrNotyet = 1;
913                        }
914                     
915         }
916          
917         people[msg.sender]._withdrawTimestamp = block.timestamp;
918          
919     }
920     
921     function withdrawToken() public returns (bool){
922         
923         require(msg.sender == people[msg.sender]._address,"You are not authorized"); // chk user is aithorized
924         require(people[msg.sender]._userState == userState.Withdraw,"userState Issue"); //user into withdraw state
925         // require(people[msg.sender]._userStateBlocktimestamp != 0,"usbts issue"); // must has choosen withdraw or stake 
926         require(people[msg.sender]._withdrawState == withdrawState.NotWithdraw,"withdrawState issue"); // not withdraw any tkns
927         require(people[msg.sender]._remainToken == remainToken.stage0,"remainToken issue"); // not withdraw any tkns
928         require(msg.sender != blockpeople[msg.sender]._address); //not blocked
929         require(people[msg.sender]._withdrawTimestamp == 0);  // is not staker
930 
931         
932         if (getPeopleAddress(msg.sender) !=  msg.sender){
933             if (block.timestamp >= stage11 && block.timestamp <= stage12 ){
934             
935             uint256 clamimTkn = people[msg.sender]._value / 100 * 50; 
936             
937              require(Ntoken.transfer(msg.sender, clamimTkn));
938             
939             people[msg.sender]._withdrawState = withdrawState.PartiallyWithdraw;
940             people[msg.sender]._remainToken = remainToken.stage1;
941             people[msg.sender]._blocktimestamp = block.timestamp;
942             
943             return true;
944         }
945         else if (block.timestamp > stage21 && block.timestamp <= stage22 ){
946             
947             uint256 clamimTkn = people[msg.sender]._value / 100 * 70; 
948             
949              require(Ntoken.transfer(msg.sender, clamimTkn));
950             
951             people[msg.sender]._withdrawState = withdrawState.PartiallyWithdraw;
952             people[msg.sender]._remainToken = remainToken.stage2;
953             people[msg.sender]._blocktimestamp = block.timestamp;
954             
955             return true;
956         }
957         else if (block.timestamp > stage31 && block.timestamp <= stage32 ){
958             
959             uint256 clamimTkn = people[msg.sender]._value / 100 * 80; 
960             
961              require(Ntoken.transfer(msg.sender, clamimTkn));
962             
963             people[msg.sender]._withdrawState = withdrawState.PartiallyWithdraw;
964             people[msg.sender]._remainToken = remainToken.stage3;
965             people[msg.sender]._blocktimestamp = block.timestamp;
966             
967             return true;
968         }
969         else if (block.timestamp > stage32 ){
970             
971             uint256 clamimTkn = people[msg.sender]._value; 
972             
973              require(Ntoken.transfer(msg.sender, clamimTkn));
974             
975             people[msg.sender]._withdrawState = withdrawState.FullyWithdraw;
976             people[msg.sender]._remainToken = remainToken.stage4;
977             people[msg.sender]._blocktimestamp = block.timestamp;
978             
979             return true;
980         }
981         } else {
982             if (block.timestamp >= ostage11 && block.timestamp <= ostage12 ){
983             
984             uint256 clamimTkn = people[msg.sender]._value / 100 * 50; 
985             
986              require(Ntoken.transfer(msg.sender, clamimTkn));
987             
988             people[msg.sender]._withdrawState = withdrawState.PartiallyWithdraw;
989             people[msg.sender]._remainToken = remainToken.stage1;
990             people[msg.sender]._blocktimestamp = block.timestamp;
991             
992             return true;
993         }
994         else if (block.timestamp > ostage21 && block.timestamp <= ostage22 ){
995             
996             uint256 clamimTkn = people[msg.sender]._value / 100 * 70; 
997             
998              require(Ntoken.transfer(msg.sender, clamimTkn));
999             
1000             people[msg.sender]._withdrawState = withdrawState.PartiallyWithdraw;
1001             people[msg.sender]._remainToken = remainToken.stage2;
1002             people[msg.sender]._blocktimestamp = block.timestamp;
1003             
1004             return true;
1005         }
1006         else if (block.timestamp > ostage31 && block.timestamp <= ostage32 ){
1007             
1008             uint256 clamimTkn = people[msg.sender]._value / 100 * 80; 
1009             
1010              require(Ntoken.transfer(msg.sender, clamimTkn));
1011             
1012             people[msg.sender]._withdrawState = withdrawState.PartiallyWithdraw;
1013             people[msg.sender]._remainToken = remainToken.stage3;
1014             people[msg.sender]._blocktimestamp = block.timestamp;
1015             
1016             return true;
1017         }
1018         else if (block.timestamp > ostage32 ){
1019             
1020             uint256 clamimTkn = people[msg.sender]._value; 
1021             
1022             require(Ntoken.transfer(msg.sender, clamimTkn));
1023             
1024             people[msg.sender]._withdrawState = withdrawState.FullyWithdraw;
1025             people[msg.sender]._remainToken = remainToken.stage4;
1026             people[msg.sender]._blocktimestamp = block.timestamp;
1027             
1028             return true;
1029         }
1030         }
1031         
1032     }
1033     
1034     function unstake() public returns(bool){
1035         
1036         require(msg.sender == people[msg.sender]._address,"You are not in previous contract");
1037         require(msg.sender != blockpeople[msg.sender]._address); // not blocked
1038         require(people[msg.sender]._withdrawTimestamp != 0 ); // chk that user has done unstakeme
1039         Person storage t =  people[msg.sender];
1040         require(block.timestamp >= people[msg.sender]._withdrawTimestamp + day21);
1041         uint256 clamimTkn = 0;
1042         for (uint256 s = 1; s <= people[msg.sender]._stakeCounter; s += 1){
1043             
1044                        if(t.stakeStruct[s]._withdrawOrNotyet == 1){ //chk that previos withdraws
1045                            clamimTkn += t.stakeStruct[s].amt;
1046                            t.stakeStruct[s]._withdrawOrNotyet = 0;
1047                        }
1048                     
1049          }
1050                 
1051                     
1052                     require(Ntoken.transfer(msg.sender, clamimTkn));
1053                     
1054                     people[msg.sender]._withdrawTimestamp = 0;
1055                     
1056                     return true;
1057 
1058     
1059     }
1060     
1061     function withdrawRemainPenaltyToken() public checkUser returns (bool){
1062         
1063         require(msg.sender == people[msg.sender]._address);
1064         require(people[msg.sender]._userState == userState.Withdraw);
1065         require(people[msg.sender]._withdrawState == withdrawState.PartiallyWithdraw);
1066         require(block.timestamp >= people[msg.sender]._blocktimestamp + oneyear);
1067         require(msg.sender != blockpeople[msg.sender]._address);
1068         
1069         if (people[msg.sender]._remainToken == remainToken.stage1){
1070             
1071             uint256 clamimTkn = people[msg.sender]._value / 100 * 50; 
1072            
1073             require(Ntoken.transfer(msg.sender, clamimTkn));
1074           
1075             people[msg.sender]._withdrawState = withdrawState.FullyWithdraw;
1076             people[msg.sender]._remainToken = remainToken.stage4;
1077             
1078             return true;
1079         }
1080         else if (people[msg.sender]._remainToken == remainToken.stage2){
1081             
1082             uint256 clamimTkn = people[msg.sender]._value / 100 * 30; 
1083             
1084             require(Ntoken.transfer(msg.sender, clamimTkn));
1085             
1086             people[msg.sender]._withdrawState = withdrawState.FullyWithdraw;
1087             people[msg.sender]._remainToken = remainToken.stage4;
1088             
1089             return true;
1090         }
1091         else if (people[msg.sender]._remainToken == remainToken.stage3){
1092             
1093             uint256 clamimTkn = people[msg.sender]._value / 100 * 20; 
1094             
1095             require(Ntoken.transfer(msg.sender, clamimTkn));
1096             
1097             people[msg.sender]._withdrawState = withdrawState.FullyWithdraw;
1098             people[msg.sender]._remainToken = remainToken.stage4;
1099             
1100             return true;
1101         }
1102     }
1103     
1104     function remainPenaltyClaimDate(address  _address) public view returns (uint256 date) {
1105         
1106          require(_address == people[_address]._address);
1107          require(people[_address]._withdrawState == withdrawState.PartiallyWithdraw);
1108          require(people[_address]._userState == userState.Withdraw);
1109          
1110          return people[_address]._blocktimestamp + oneyear;
1111         
1112     }
1113     
1114     // withdraw owner tokens
1115     
1116     function withdrawOwnerNioxToken(uint256 _tkns) public  onlyOwner returns (bool) {
1117              require(token.transfer(msg.sender, _tkns));
1118              return true;
1119         }
1120         
1121     function withdrawOtherTokens(address tokenContract, uint256 count) external onlyOwner returns (bool)  {
1122      Token tc = Token(tokenContract);
1123      require(tc.transfer(owner, count));
1124      return true;
1125     }
1126     
1127 }