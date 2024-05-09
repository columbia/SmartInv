1 pragma solidity ^0.5.0;
2 
3 library SafeMath {
4 
5     function mul(uint256 a, uint256 b) internal pure returns (uint256) {
6         if (a == 0) {
7             return 0;
8         }
9         uint256 c = a * b;
10         assert(c / a == b);
11         return c;
12     }
13 
14     function div(uint256 a, uint256 b) internal pure returns (uint256) {
15         // assert(b > 0); // Solidity automatically throws when dividing by 0
16         uint256 c = a / b;
17         // assert(a == b * c + a % b); // There is no case in which this doesn't hold
18         return c;
19     }
20 
21     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
22         assert(b <= a);
23         return a - b;
24     }
25 
26     function add(uint256 a, uint256 b) internal pure returns (uint256) {
27         uint256 c = a + b;
28         assert(c >= a);
29         return c;
30     }
31 }
32 
33 contract Ownable {
34     address public owner;
35     address public newOwner;
36 
37     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
38 
39     constructor() public {
40         owner = msg.sender;
41         newOwner = address(0);
42     }
43 
44     modifier onlyOwner() {
45         require(msg.sender == owner);
46         _;
47     }
48     modifier onlyNewOwner() {
49         require(msg.sender != address(0));
50         require(msg.sender == newOwner);
51         _;
52     }
53 
54     function transferOwnership(address _newOwner) public onlyOwner {
55         require(_newOwner != address(0));
56         newOwner = _newOwner;
57     }
58 
59     function acceptOwnership() public onlyNewOwner returns(bool) {
60         emit OwnershipTransferred(owner, newOwner);
61         owner = newOwner;
62         newOwner = address(0);
63     }
64 }
65 
66 contract Pausable is Ownable {
67     event Pause();
68     event Unpause();
69 
70     bool public paused = false;
71 
72     modifier whenNotPaused() {
73         require(!paused);
74         _;
75     }
76 
77     modifier whenPaused() {
78         require(paused);
79         _;
80     }
81 
82     function pause() onlyOwner whenNotPaused public {
83         paused = true;
84         emit Pause();
85     }
86 
87     function unpause() onlyOwner whenPaused public {
88         paused = false;
89         emit Unpause();
90     }
91 }
92 
93 contract ERC20 {
94     function totalSupply() public view returns (uint256);
95     function balanceOf(address who) public view returns (uint256);
96     function allowance(address owner, address spender) public view returns (uint256);
97     function transfer(address to, uint256 value) public returns (bool);
98     function transferFrom(address from, address to, uint256 value) public returns (bool);
99     function approve(address spender, uint256 value) public returns (bool);
100 
101     event Approval(address indexed owner, address indexed spender, uint256 value);
102     event Transfer(address indexed from, address indexed to, uint256 value);
103 }
104 
105 contract GrabityCoin is ERC20, Ownable, Pausable {
106 
107     using SafeMath for uint256;
108 
109     struct LockupInfo {
110         uint256 releaseTime;
111         uint256 lockupBalance;
112         uint256 termOfMonth;
113     }
114 
115     string public name;
116     string public symbol;
117     uint8 constant public decimals =18;
118     uint256 internal initialSupply;
119     uint256 internal totalSupply_;
120     uint256 internal mintCap;
121 
122     mapping(address => uint256) internal balances;
123     mapping(address => bool) internal locks;
124     mapping(address => bool) public frozen;
125     mapping(address => mapping(address => uint256)) internal allowed;
126     mapping(address => LockupInfo[]) internal lockupInfo;
127     
128     uint256[36] internal unlockPeriodUnixTimeStamp;
129     
130     address implementation;
131 
132     event Lock(address indexed holder, uint256 value);
133     event Unlock(address indexed holder, uint256 value);
134     event Burn(address indexed owner, uint256 value);
135     event Mint(uint256 value);
136     event Freeze(address indexed holder);
137     event Unfreeze(address indexed holder);
138 
139     modifier notFrozen(address _holder) {
140         require(!frozen[_holder]);
141         _;
142     }
143 
144     constructor() public {
145         name = "Grabity Coin";
146         symbol = "GBT";
147         initialSupply = 10000000000; // 10,000,000,000개
148         totalSupply_ = initialSupply * 10 ** uint(decimals);
149         mintCap = 10000000000 * 10 ** uint(decimals); //10,000,000,000
150         balances[owner] = totalSupply_;
151         
152         unlockPeriodUnixTimeStamp = [
153                 1559347200, 1561939200, 1564617600, 1567296000, 1569888000, 1572566400, 1575158400, 
154                 1577836800, 1580515200, 1583020800, 1585699200, 1588291200, 1590969600, 1593561600, 1596240000, 1598918400, 1601510400, 1604188800, 1606780800,
155                 1609459200, 1612137600, 1614556800, 1617235200, 1619827200, 1622505600, 1625097600, 1627776000, 1630454400, 1633046400, 1635724800, 1638316800,
156                 1640995200, 1643673600, 1646092800, 1648771200, 1651363200
157             ];
158 
159         emit Transfer(address(0), owner, totalSupply_);
160     }
161 
162     function () payable external {
163         address impl = implementation;
164         require(impl != address(0));
165         assembly {
166             let ptr := mload(0x40)
167             calldatacopy(ptr, 0, calldatasize)
168             let result := delegatecall(gas, impl, ptr, calldatasize, 0, 0)
169             let size := returndatasize
170             returndatacopy(ptr, 0, size)
171             
172             switch result
173             case 0 { revert(ptr, size) }
174             default { return(ptr, size) }
175         }
176     }
177     function _setImplementation(address _newImp) internal {
178         implementation = _newImp;
179     }
180     
181     function upgradeTo(address _newImplementation) public onlyOwner {
182         require(implementation != _newImplementation);
183         _setImplementation(_newImplementation);
184     }
185 
186     function totalSupply() public view returns (uint256) {
187         return totalSupply_;
188     }
189 
190     function transfer(address _to, uint256 _value) public whenNotPaused notFrozen(msg.sender) returns (bool) {
191         if (locks[msg.sender]) {
192             autoUnlock(msg.sender);
193         }
194         require(_to != address(0));
195         require(_value <= balances[msg.sender]);
196 
197         // SafeMath.sub will throw if there is not enough balance.
198         balances[msg.sender] = balances[msg.sender].sub(_value);
199         balances[_to] = balances[_to].add(_value);
200         emit Transfer(msg.sender, _to, _value);
201         return true;
202     }
203     
204      function multiTransfer(address[] memory _toList, uint256[] memory _valueList) public whenNotPaused notFrozen(msg.sender) returns(bool){
205         if(_toList.length != _valueList.length){
206             revert();
207         }
208         
209         for(uint256 i = 0; i < _toList.length; i++){
210             transfer(_toList[i], _valueList[i]);
211         }
212         
213         return true;
214     }
215     
216      function multiTransferWithLockup(address[] memory _toList, uint256[] memory _dateIndex, uint256[] memory _valueList, uint256[] memory _termOfMonthList) public onlyOwner returns(bool){
217         if((_toList.length != _valueList.length) || (_valueList.length != _termOfMonthList.length)){
218             revert();
219         }
220         
221         for(uint256 i = 0; i < _toList.length; i++){
222             distribute(_toList[i], _valueList[i]);
223         
224             lockupAsTermOfMonth(_toList[i], _dateIndex[i], _valueList[i], _termOfMonthList[i]);
225         }
226         
227         return true;
228     }
229     
230     function balanceOf(address _holder) public view returns (uint256 balance) {
231         uint256 lockedBalance = 0;
232         if(locks[_holder]) {
233             for(uint256 idx = 0; idx < lockupInfo[_holder].length ; idx++ ) {
234                 lockedBalance = lockedBalance.add(lockupInfo[_holder][idx].lockupBalance);
235             }
236         }
237         return balances[_holder] + lockedBalance;
238     }
239     
240     function currentBalanceOf(address _holder) public view returns(uint256 balance){
241         uint256 unlockedBalance = 0;
242         if(locks[_holder]){
243             for(uint256 idx =0; idx < lockupInfo[_holder].length; idx++){
244                 if( lockupInfo[_holder][idx].releaseTime <= now){
245                     unlockedBalance = unlockedBalance.add(lockupInfo[_holder][idx].lockupBalance);
246                 }
247             }
248         }
249         return balances[_holder] + unlockedBalance;
250     }
251 
252     function transferFrom(address _from, address _to, uint256 _value) public whenNotPaused notFrozen(_from)returns (bool) {
253         if (locks[_from]) {
254             autoUnlock(_from);
255         }
256         require(_to != address(0));
257         require(_value <= balances[_from]);
258         require(_value <= allowed[_from][msg.sender]);
259 
260         balances[_from] = balances[_from].sub(_value);
261         balances[_to] = balances[_to].add(_value);
262         allowed[_from][msg.sender] = allowed[_from][msg.sender].sub(_value);
263         emit Transfer(_from, _to, _value);
264         return true;
265     }
266 
267     function approve(address _spender, uint256 _value) public whenNotPaused returns (bool) {
268         allowed[msg.sender][_spender] = _value;
269         emit Approval(msg.sender, _spender, _value);
270         return true;
271     }
272 
273     function increaseAllowance(address spender, uint256 addedValue) public returns (bool) {
274         require(spender != address(0));
275         allowed[msg.sender][spender] = (allowed[msg.sender][spender].add(addedValue));
276 
277         emit Approval(msg.sender, spender, allowed[msg.sender][spender]);
278         return true;
279     }
280 
281     function decreaseAllowance( address spender, uint256 subtractedValue) public returns (bool) {
282         require(spender != address(0));
283         allowed[msg.sender][spender] = (allowed[msg.sender][spender].sub(subtractedValue));
284 
285         emit Approval(msg.sender, spender, allowed[msg.sender][spender]);
286         return true;
287     }
288 
289     function allowance(address _holder, address _spender) public view returns (uint256) {
290         return allowed[_holder][_spender];
291     }
292 
293     function lock(address _holder, uint256 _releaseStart, uint256 _amount, uint256 _termOfMonth) public onlyOwner returns(bool){
294         require(balances[_holder] >= _amount);
295         balances[_holder] = balances[_holder].sub(_amount);
296         
297         lockupInfo[_holder].push(
298             LockupInfo(_releaseStart, _amount, _termOfMonth)    
299         );
300         
301         locks[_holder] = true;
302         
303         emit Lock(_holder, _amount);
304         
305         return true;
306         
307     }
308 
309     function _unlock(address _holder, uint256 _idx) internal returns (bool) {
310         require(locks[_holder]);
311         require(_idx < lockupInfo[_holder].length);
312         LockupInfo storage lockupinfo = lockupInfo[_holder][_idx];
313         uint256 releaseAmount = lockupinfo.lockupBalance;
314         
315         delete lockupInfo[_holder][_idx];
316         
317         lockupInfo[_holder][_idx] = lockupInfo[_holder][lockupInfo[_holder].length.sub(1)];
318         
319         lockupInfo[_holder].length -= 1;
320         
321         if(lockupInfo[_holder].length == 0){
322             locks[_holder] = false;
323         }
324         
325         emit Unlock(_holder, releaseAmount);
326         balances[_holder] = balances[_holder].add(releaseAmount);
327         
328         return true;
329     }
330 
331     function unlock(address _holder, uint256 _idx) public onlyOwner returns (bool) {
332         _unlock(_holder, _idx);
333     }
334 
335     function freezeAccount(address _holder) public onlyOwner returns (bool) {
336         require(!frozen[_holder]);
337         frozen[_holder] = true;
338         emit Freeze(_holder);
339         return true;
340     }
341 
342     function unfreezeAccount(address _holder) public onlyOwner returns (bool) {
343         require(frozen[_holder]);
344         frozen[_holder] = false;
345         emit Unfreeze(_holder);
346         return true;
347     }
348 
349     function getNowTime() public view returns(uint256) {
350         return now;
351     }
352 
353     function showLockState(address _holder, uint256 _idx) public view returns (bool, uint256, uint256, uint256, uint256) {
354         if(locks[_holder]) {
355             return (
356                 locks[_holder],
357                 lockupInfo[_holder].length,
358                 lockupInfo[_holder][_idx].releaseTime,
359                 lockupInfo[_holder][_idx].lockupBalance,
360                 lockupInfo[_holder][_idx].termOfMonth
361             );
362         } else {
363             return (
364                 locks[_holder],
365                 lockupInfo[_holder].length,
366                 0,0,0
367             );
368 
369         }
370     }
371     
372     function lockupAsTermOfMonth(address _holder, uint256 _dateIndex, uint256 _amount, uint256 _termOfMonth) internal returns (bool) {
373         if(_termOfMonth == 0){
374             lock(_holder, unlockPeriodUnixTimeStamp[_dateIndex], _amount, _termOfMonth);
375         }else{
376             uint256 lockupAmountPerRatio = _amount /  _termOfMonth;
377             uint256 lockupAmountRemainder = _amount % _termOfMonth;
378             
379             for(uint256 i=0; i < _termOfMonth; i++){
380                 if(i != _termOfMonth - 1){
381                     lock(_holder, unlockPeriodUnixTimeStamp[_dateIndex+i], lockupAmountPerRatio, _termOfMonth);
382                 }else{
383                     lock(_holder, unlockPeriodUnixTimeStamp[_dateIndex+i], lockupAmountPerRatio+lockupAmountRemainder, _termOfMonth);
384                 }
385             }
386         }
387         return true;
388     }
389 
390     function distribute(address _to, uint256 _value) public onlyOwner returns (bool) {
391         require(_to != address(0));
392         require(_value <= balances[msg.sender]);
393 
394         balances[msg.sender] = balances[msg.sender].sub(_value);
395         balances[_to] = balances[_to].add(_value);
396         emit Transfer(msg.sender, _to, _value);
397         return true;
398     }
399 
400     function distributeWithLockup(address _holder, uint256 _dateIndex, uint256 _amount, uint256 _termOfMonth) public onlyOwner returns (bool) {
401         distribute(_holder, _amount);
402     
403         lockupAsTermOfMonth(_holder, _dateIndex, _amount, _termOfMonth);
404         return true;
405     }
406     
407     function claimToken(ERC20 token, address _to, uint256 _value) public onlyOwner returns (bool) {
408         token.transfer(_to, _value);
409         return true;
410     }
411 
412     function burn(uint256 _value) public onlyOwner returns (bool success) {
413         require(_value <= balances[msg.sender]);
414         address burner = msg.sender;
415         balances[burner] = balances[burner].sub(_value);
416         totalSupply_ = totalSupply_.sub(_value);
417         emit Burn(burner, _value);
418         emit Transfer(burner, address(0), _value);
419         return true;
420     }
421 
422     function mint(address _to, uint256 _amount) onlyOwner public returns (bool) {
423         require(mintCap >= totalSupply_.add(_amount));
424         totalSupply_ = totalSupply_.add(_amount);
425         balances[_to] = balances[_to].add(_amount);
426         emit Transfer(address(0), _to, _amount);
427         return true;
428     }
429 
430      function autoUnlock(address _holder) internal returns(bool){
431         if(locks[_holder] == false){
432             return true;
433         }
434         
435         for(uint256 idx = 0; idx < lockupInfo[_holder].length; idx++){
436             if(lockupInfo[_holder][idx].releaseTime <= now)
437             {
438                 if(_unlock(_holder, idx)){
439                     idx -= 1;
440                 }
441             }
442         }
443         return true;
444     }
445 }