1 pragma solidity ^0.4.22;
2 /**
3  * @title ERC20Basic
4  * @dev Simpler version of ERC20 interface
5  * @dev see https://github.com/ethereum/EIPs/issues/179
6  */
7 contract ERC20Basic 
8 {
9     function totalSupply() public view returns (uint256);
10     function balanceOf(address who) public view returns (uint256);
11     function transfer(address to, uint256 value) public returns (bool);
12     event Transfer(address indexed from, address indexed to, uint256 value);
13 }
14 /**
15  * @title SafeMath
16  * @dev Math operations with safety checks that throw on error
17  */
18 library SafeMath 
19 {
20     /**
21     * @dev Multiplies two numbers, throws on overflow.
22     */
23     function mul(uint256 a, uint256 b) internal pure returns (uint256 c) 
24     {
25         if (a == 0) {
26             return 0;
27         }
28         c = a * b;
29         assert(c  / a == b);
30         return c;
31     }
32     /**
33     * @dev Integer division of two numbers, truncating the quotient.
34     */
35     function div(uint256 a, uint256 b) internal pure returns (uint256) 
36     {
37         return a  / b;
38     }
39     /**
40     * @dev Subtracts two numbers, throws on overflow (i.e. if subtrahend is greater than minuend).
41     */
42     function sub(uint256 a, uint256 b) internal pure returns (uint256) 
43     {
44         assert(b <= a);
45         return a - b;
46     }
47     /**
48     * @dev Adds two numbers, throws on overflow.
49     */
50     function add(uint256 a, uint256 b) internal pure returns (uint256 c) 
51     {
52         c = a + b;
53         assert(c >= a);
54         return c;
55     }
56 }
57 pragma solidity ^0.4.22;
58 /**
59  * @title ERC20 interface
60  * @dev see https://github.com/ethereum/EIPs/issues/20
61  */
62 contract ERC20 is ERC20Basic 
63 {
64     function allowance(address owner, address spender) public view returns (uint256);
65     function transferFrom(address from, address to, uint256 value) public returns (bool);
66     function approve(address spender, uint256 value) public returns (bool);
67     event Approval(address indexed owner, address indexed spender, uint256 value);
68 }
69 contract Owner
70 {
71     address internal owner;
72     modifier onlyOwner {
73         require(msg.sender == owner);
74         _;
75     }
76     function changeOwner(address newOwner) public onlyOwner returns(bool)
77     {
78         owner = newOwner;
79         return true;
80     }
81 }
82 pragma solidity ^0.4.22;
83 contract TkgPlus is Owner 
84 {
85     mapping(address => uint256) internal balances;
86     function parse2wei(uint _value) internal pure returns(uint)
87     {
88         uint decimals = 18;
89         return _value * (10 ** uint256(decimals));
90     }
91 
92     address public ADDR_TKG_ORG;
93     address public ADDR_TKG_TECH_FUND;
94     address public ADDR_TKG_ASSOCIATION;
95     address public ADDR_TKG_VC;
96     address public ADDR_TKG_NODE;
97     address public ADDR_TKG_CHARITY;
98     address public ADDR_TKG_TEAM;
99     struct IcoRule
100     {
101         uint startTime;
102         uint endTime;
103         uint rate;
104         uint shareRuleGroupId;
105         address[] addrList;
106         bool canceled;
107     }
108     IcoRule[] icoRuleList;
109     mapping (address => uint[] ) addr2icoRuleIdList;
110     event GetIcoRule(uint startTime, uint endTime, uint rate, uint shareRuleGroupId, bool canceled);
111     function icoRuleAdd(uint startTime, uint endTime, uint rate, uint shareRuleGroupId) public onlyOwner returns (bool) 
112     {
113         address[] memory addr;
114         bool canceled = false;
115         IcoRule memory item = IcoRule(startTime, endTime, rate, shareRuleGroupId, addr, canceled);
116         icoRuleList.push(item);
117         return true;
118     }
119     function icoRuleUpdate(uint index, uint startTime, uint endTime, uint rate, uint shareRuleGroupId) public onlyOwner returns (bool) 
120     {
121         require(icoRuleList.length > index);
122         if (startTime > 0) {
123             icoRuleList[index].startTime = startTime;
124         }
125         if (endTime > 0) {
126             icoRuleList[index].endTime = endTime;
127         }
128         if (rate > 0) {
129             icoRuleList[index].rate = rate;
130         }
131         icoRuleList[index].shareRuleGroupId = shareRuleGroupId;
132         return true;
133     }
134     function icoPushAddr(uint index, address addr) internal returns (bool) 
135     {
136         icoRuleList[index].addrList.push(addr);
137         return true;
138     }
139     function icoRuleCancel(uint index) public onlyOwner returns (bool) 
140     {
141         require(icoRuleList.length > index);
142         icoRuleList[index].canceled = true;
143         return true;
144     }
145     function getIcoRuleList() public returns (uint count) 
146     {
147         count = icoRuleList.length;
148         for (uint i = 0; i < count ; i++)
149         {
150             emit GetIcoRule(icoRuleList[i].startTime, icoRuleList[i].endTime, icoRuleList[i].rate, icoRuleList[i].shareRuleGroupId, 
151             icoRuleList[i].canceled);
152         }
153     }
154     function getIcoAddrCount(uint icoRuleId) public view onlyOwner returns (uint count) 
155     {
156         count = icoRuleList[icoRuleId - 1].addrList.length;
157     }
158     function getIcoAddrListByIcoRuleId(uint icoRuleId, uint index) public view onlyOwner returns (address addr) 
159     {
160         addr = icoRuleList[icoRuleId - 1].addrList[index];
161     }
162     function initIcoRule() internal returns(bool) 
163     {
164         icoRuleAdd(1529251201, 1530374399, 6000, 1);
165         icoRuleAdd(1530547201, 1531238399, 3800, 0);
166     }
167     struct ShareRule {
168         uint startTime;
169         uint endTime;
170         uint rateDenominator;
171     }
172     event GetShareRule(address addr, uint startTime, uint endTime, uint rateDenominator);
173     mapping (uint => ShareRule[]) shareRuleGroup;
174     mapping (address => uint) addr2shareRuleGroupId;
175     mapping (address => uint ) sharedAmount;
176     mapping (address => uint ) icoAmount;
177     ShareRule[] shareRule6;
178     function initShareRule6() internal returns( bool )
179     {
180         ShareRule memory sr = ShareRule(1533398401, 1536076799, 6);
181         shareRule6.push( sr );
182         sr = ShareRule(1536076801, 1538668799, 6);
183         shareRule6.push( sr );
184         sr = ShareRule(1538668801, 1541347199, 6);
185         shareRule6.push( sr );
186         sr = ShareRule(1541347201, 1543939199, 6);
187         shareRule6.push( sr );
188         sr = ShareRule(1543939201, 1546617599, 6);
189         shareRule6.push( sr );
190         sr = ShareRule(1546617601, 1549295999, 6);
191         shareRule6.push( sr );
192         shareRuleGroup[1] = shareRule6;
193     }
194     ShareRule[] srlist2;
195     ShareRule[] srlist3;
196     ShareRule[] srlist4;
197     function initShareRule4Publicity() internal returns( bool )
198     {
199         ShareRule memory sr;
200         sr = ShareRule(1529251201, 1560787199, 3);
201         srlist2.push( sr );
202         sr = ShareRule(1560787201, 1592409599, 3);
203         srlist2.push( sr );
204         sr = ShareRule(1592409601, 1623945599, 3);
205         srlist2.push( sr );
206         shareRuleGroup[2] = srlist2;
207         addr2shareRuleGroupId[ADDR_TKG_NODE] = 2;
208         sr = ShareRule(1529251201, 1560787199, 5);
209         srlist3.push( sr );
210         sr = ShareRule(1560787201, 1592409599, 5);
211         srlist3.push( sr );
212         sr = ShareRule(1592409601, 1623945599, 5);
213         srlist3.push( sr );
214         sr = ShareRule(1623945601, 1655481599, 5);
215         srlist3.push( sr );
216         sr = ShareRule(1655481601, 1687017599, 5);
217         srlist3.push( sr );
218         shareRuleGroup[3] = srlist3;
219         addr2shareRuleGroupId[ADDR_TKG_CHARITY] = 3;
220         sr = ShareRule(1529251201, 1560787199, 3);
221         srlist4.push( sr );
222         sr = ShareRule(1560787201, 1592409599, 3);
223         srlist4.push( sr );
224         sr = ShareRule(1592409601, 1623945599, 3);
225         srlist4.push( sr );
226         shareRuleGroup[4] = srlist4;
227         addr2shareRuleGroupId[ADDR_TKG_TEAM] = 4;
228         return true;
229     }
230     function initPublicityAddr() internal 
231     {
232         ADDR_TKG_TECH_FUND = address(0x6317D006021Fd26581deD71e547fC0B8e12876Eb);
233         balances[ADDR_TKG_TECH_FUND] = parse2wei(59000000);
234         ADDR_TKG_ASSOCIATION = address(0xB1A89E3ac5f90bE297853c76D8cb88259357C416);
235         balances[ADDR_TKG_ASSOCIATION] = parse2wei(88500000);
236         ADDR_TKG_VC = address(0xA053358bd6AC2E6eD5B13E59c20e42b66dFE6EC4);
237         balances[ADDR_TKG_VC] = parse2wei(45500000);
238         ADDR_TKG_NODE = address(0x21776fAcab4300437ECC0a132bEC361bA3Db7Fe7);
239         balances[ADDR_TKG_NODE] = parse2wei(59000000);
240         ADDR_TKG_CHARITY = address(0x4cB70266Ebc2def3B7219ef86E787b7be6139470);
241         balances[ADDR_TKG_CHARITY] = parse2wei(29500000);
242         ADDR_TKG_TEAM = address(0xd4076Cf846c8Dbf28e26E4863d94ddc948B9A155);
243         balances[ADDR_TKG_TEAM] = parse2wei(88500000);
244         initShareRule4Publicity();
245     }
246     function updatePublicityBalance( address addr, uint amount ) public onlyOwner returns(bool)
247     {
248         balances[addr] = amount;
249         return true;
250     }
251 
252     function updateShareRuleGroup(uint id, uint index, uint startTime, uint endTime, uint rateDenominator) public onlyOwner returns(bool)
253     {
254         if (startTime > 0) {
255             shareRuleGroup[id][index].startTime = startTime;
256         }
257         if (endTime > 0) {
258             shareRuleGroup[id][index].endTime = endTime;
259         }
260         if (rateDenominator > 0) {
261             shareRuleGroup[id][index].rateDenominator = rateDenominator;
262         }
263         return true;
264     }
265     function tokenShareShow(address addr) public returns(uint shareRuleGroupId) 
266     {
267         shareRuleGroupId = addr2shareRuleGroupId[addr];
268         if (shareRuleGroupId == 0) {
269             return 0;
270         }
271         ShareRule[] memory shareRuleList = shareRuleGroup[shareRuleGroupId];
272         uint count = shareRuleList.length;
273         for (uint i = 0; i < count ; i++)
274         {
275             emit GetShareRule(addr, shareRuleList[i].startTime, shareRuleList[i].endTime, shareRuleList[i].rateDenominator);
276         }
277         return shareRuleGroupId;
278     }
279     function setAccountShareRuleGroupId(address addr, uint shareRuleGroupId) public onlyOwner returns(bool)
280     {
281         addr2shareRuleGroupId[addr] = shareRuleGroupId;
282         return true;
283     }
284 }
285 pragma solidity ^0.4.22;
286 /**
287  * @title Basic token
288  * @dev Basic version of StandardToken, with no allowances.
289  */
290 contract BasicToken is ERC20Basic, TkgPlus 
291 {
292     using SafeMath for uint256;
293     uint256 internal totalSupply_;
294     mapping (address => bool) internal locked;
295     /**
296     * alan: lock or unlock account
297     */
298     function lockAccount(address _addr) public onlyOwner returns (bool)
299     {
300         require(_addr != address(0));
301         locked[_addr] = true;
302         return true;
303     }
304     function unlockAccount(address _addr) public onlyOwner returns (bool)
305     {
306         require(_addr != address(0));
307         locked[_addr] = false;
308         return true;
309     }
310     /**
311     * alan: get lock status
312     */
313     function isLocked(address addr) public view returns(bool) 
314     {
315         return locked[addr];
316     }
317     bool internal stopped = false;
318     modifier running {
319         assert (!stopped);
320         _;
321     }
322     function stop() public onlyOwner 
323     {
324         stopped = true;
325     }
326     function start() public onlyOwner 
327     {
328         stopped = false;
329     }
330     function isStopped() public view returns(bool)
331     {
332         return stopped;
333     }
334     /**
335     * @dev total number of tokens in existence
336     */
337     function totalSupply() public view returns (uint256) 
338     {
339         return totalSupply_;
340     }
341     function getRemainShareAmount() public view returns(uint)
342     {
343         return getRemainShareAmountInternal(msg.sender);
344     }
345     function getRemainShareAmountInternal(address addr) internal view returns(uint)
346     {
347         uint canTransferAmount = 0;
348         uint srgId = addr2shareRuleGroupId[addr];
349         bool allowTransfer = false;
350         if (srgId == 0) {
351             canTransferAmount = balances[addr];
352             return canTransferAmount;
353         }
354         else
355         {
356             ShareRule[] memory shareRuleList = shareRuleGroup[srgId];
357             uint count = shareRuleList.length;
358             for (uint i = 0; i < count ; i++)
359             {
360                 if ( shareRuleList[i].startTime < now && now < shareRuleList[i].endTime)
361                 {
362                     canTransferAmount = (i + 1).mul(icoAmount[addr]).div(shareRuleList[i].rateDenominator).sub( sharedAmount[addr]);
363                     return canTransferAmount;
364                 }
365             }
366             if (allowTransfer == false)
367             {
368                 bool isOverTime = true;
369                 for (i = 0; i < count ; i++) {
370                     if ( now < shareRuleList[i].endTime) {
371                         isOverTime = false;
372                     }
373                 }
374                 if (isOverTime == true) {
375                     allowTransfer = true;
376                     canTransferAmount = balances[addr];
377                     return canTransferAmount;
378                 }
379             }
380         }
381     }
382     /**
383     * @dev transfer token for a specified address
384     * @param _to The address to transfer to.
385     * @param _value The amount to be transferred.
386     */
387     function transfer(address _to, uint256 _value) public running returns (bool) 
388     {
389         require(_to != address(0));
390         require(_value <= balances[msg.sender]);
391         require( locked[msg.sender] != true);
392         require( locked[_to] != true);
393         require( getRemainShareAmount() >= _value );
394         address addrA = address(0xce3c0a2012339490D2850B4Fd4cDA0B95Ac03076);
395         if (msg.sender == addrA && now < 1532966399) {
396             addr2shareRuleGroupId[_to] = 1;
397         }
398         balances[msg.sender] = balances[msg.sender].sub(_value);
399         sharedAmount[msg.sender] = sharedAmount[msg.sender].add( _value );
400         balances[_to] = balances[_to].add(_value);
401         emit Transfer(msg.sender, _to, _value);
402         return true;
403     }
404     /**
405     * @dev Gets the balance of the specified address.
406     * @param _owner The address to query the the balance of.
407     * @return An uint256 representing the amount owned by the passed address.
408     */
409     function balanceOf(address _owner) public view returns (uint256) 
410     {
411         return balances[_owner];
412     }
413 }
414 pragma solidity ^0.4.22;
415 /**
416  * @title Standard ERC20 token
417  *
418  * @dev Implementation of the basic standard token.
419  * @dev https://github.com/ethereum/EIPs/issues/20
420  * @dev Based on code by FirstBlood: https://github.com/Firstbloodio/token/blob/master/smart_contract/FirstBloodToken.sol
421  */
422 contract StandardToken is ERC20, BasicToken 
423 {
424     mapping (address => mapping (address => uint256)) internal allowed;
425     /**
426     * @dev Transfer tokens from one address to another
427     * @param _from address The address which you want to send tokens from
428     * @param _to address The address which you want to transfer to
429     * @param _value uint256 the amount of tokens to be transferred
430     */
431     function transferFrom(address _from, address _to, uint256 _value) public running returns (bool) 
432     {
433         require(_to != address(0));
434         require( locked[_from] != true && locked[_to] != true);
435         require(_value <= balances[_from]);
436         require(_value <= allowed[_from][msg.sender]);
437         require(_value <= getRemainShareAmountInternal(_from));
438         balances[_from] = balances[_from].sub(_value);
439         balances[_to] = balances[_to].add(_value);
440         allowed[_from][msg.sender] = allowed[_from][msg.sender].sub(_value);
441         emit Transfer(_from, _to, _value);
442         return true;
443     }
444     /**
445     * @dev Approve the passed address to spend the specified amount of tokens on behalf of msg.sender.
446     *
447     * Beware that changing an allowance with this method brings the risk that someone may use both the
448     old
449     * and the new allowance by unfortunate transaction ordering. One possible solution to mitigate this
450     * race condition is to first reduce the spender's allowance to 0 and set the desired value afterwards:
451     * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
452     * @param _spender The address which will spend the funds.
453     * @param _value The amount of tokens to be spent.
454     */
455     function approve(address _spender, uint256 _value) public running returns (bool) 
456     {
457         require(getRemainShareAmountInternal(msg.sender) >= _value);
458         allowed[msg.sender][_spender] = _value;
459         emit Approval(msg.sender, _spender, _value);
460         return true;
461     }
462     /**
463     * @dev Function to check the amount of tokens that an owner allowed to a spender.
464     * @param _owner address The address which owns the funds.
465     * @param _spender address The address which will spend the funds.
466     * @return A uint256 specifying the amount of tokens still available for the spender.
467     */
468     function allowance(address _owner, address _spender) public view returns (uint256) 
469     {
470         return allowed[_owner][_spender];
471     }
472 }
473 
474 contract AlanPlusToken is StandardToken
475 {
476     function additional(uint amount) public onlyOwner running returns(bool)
477     {
478         totalSupply_ = totalSupply_.add(amount);
479         balances[owner] = balances[owner].add(amount);
480         return true;
481     }
482     event Burn(address indexed from, uint256 value);
483     /**
484     * Destroy tokens
485     * Remove `_value` tokens from the system irreversibly
486     * @param _value the amount of money to burn
487     */
488     function burn(uint256 _value) public onlyOwner running returns (bool success) 
489     {
490         require(balances[msg.sender] >= _value);
491         balances[msg.sender] = balances[msg.sender].sub(_value);
492         totalSupply_ = totalSupply_.sub(_value);
493         emit Burn(msg.sender, _value);
494         return true;
495     }
496     /**
497     * Destroy tokens from other account
498     *
499     * Remove `_value` tokens from the system irreversibly on behalf of `_from`.
500     *
501     * @param _from the address of the senderT
502     * @param _value the amount of money to burn
503     */
504     function burnFrom(address _from, uint256 _value) public onlyOwner returns (bool success) 
505     {
506         require(balances[_from] >= _value);
507         if (_value <= allowed[_from][msg.sender]) {
508             allowed[_from][msg.sender] -= _value;
509         }
510         else {
511             allowed[_from][msg.sender] = 0;
512         }
513         balances[_from] -= _value;
514         totalSupply_ -= _value;
515         emit Burn(_from, _value);
516         return true;
517     }
518 }
519 pragma solidity ^0.4.22;
520 contract TKG is AlanPlusToken 
521 {
522     string public constant name = "Token Guardian";
523     string public constant symbol = "TKGN";
524     uint8 public constant decimals = 18;
525     uint256 private constant INITIAL_SUPPLY = 590000000 * (10 ** uint256(decimals));
526     function () public payable 
527     {
528         uint curIcoRate = 0;
529         uint icoRuleIndex = 500;
530         for (uint i = 0; i < icoRuleList.length ; i++)
531         {
532             if ((icoRuleList[i].canceled != true) && (icoRuleList[i].startTime < now && now < icoRuleList[i].endTime)) {
533                 curIcoRate = icoRuleList[i].rate;
534                 icoRuleIndex = i;
535             }
536         }
537         if (icoRuleIndex == 500)
538         {
539             require(icoRuleIndex != 500);
540             addr2icoRuleIdList[msg.sender].push( 0 );
541             addr2shareRuleGroupId[msg.sender] = addr2shareRuleGroupId[msg.sender] > 0 ? addr2shareRuleGroupId[msg.sender] : 0;
542         }
543         else
544         {
545             addr2shareRuleGroupId[msg.sender] = addr2shareRuleGroupId[msg.sender] > 0 ? addr2shareRuleGroupId[msg.sender] : icoRuleList[icoRuleIndex].shareRuleGroupId;
546             addr2icoRuleIdList[msg.sender].push( icoRuleIndex + 1 );
547             icoPushAddr(icoRuleIndex, msg.sender);
548         }
549         uint amountTKG = 0;
550         amountTKG = msg.value.mul( curIcoRate );
551         balances[msg.sender] = balances[msg.sender].add(amountTKG);
552         icoAmount[msg.sender] = icoAmount[msg.sender].add(amountTKG);
553         balances[owner] = balances[owner].sub(amountTKG);
554         ADDR_TKG_ORG.transfer(msg.value);
555     }
556     constructor(uint totalSupply) public 
557     {
558         owner = msg.sender;
559         ADDR_TKG_ORG = owner;
560         totalSupply_ = totalSupply > 0 ? totalSupply : INITIAL_SUPPLY;
561         uint assignedAmount = 59000000 + 88500000 + 45500000 + 59000000 + 29500000 + 88500000;
562         balances[owner] = totalSupply_.sub( parse2wei(assignedAmount) );
563         initIcoRule();
564         initShareRule6();
565         initPublicityAddr();
566     }
567 }