1 pragma solidity ^0.4.23;
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
57 pragma solidity ^0.4.23;
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
72     mapping(address => bool) internal admins;
73     modifier onlyOwner {
74         require(msg.sender == owner);
75         _;
76     }
77     modifier onlyAdmin {
78         require(admins[msg.sender] == true || msg.sender == owner);
79         _;
80     }
81     function changeOwner(address newOwner) public onlyOwner returns(bool)
82     {
83         owner = newOwner;
84         return true;
85     }
86     function setAdmin(address addr) public onlyOwner returns(bool) 
87     {
88         admins[addr] = true;
89         return true;
90     }
91     function delAdmin(address addr) public onlyOwner returns(bool) 
92     {
93         admins[addr] = false;
94         return true;
95     }
96 }
97 pragma solidity ^0.4.23;
98 contract MayaPlus is Owner 
99 {
100     mapping(address => uint256) internal balances;
101     function parse2wei(uint _value) internal pure returns(uint)
102     {
103         uint decimals = 18;
104         return _value * (10 ** uint256(decimals));
105     }
106     address public ADDR_MAYA_ORG;
107     address public ADDR_MAYA_MARKETING ;
108     address public ADDR_MAYA_TEAM;
109     address public ADDR_MAYA_ASSOCIATION;
110     struct IcoRule
111     {
112         uint startTime;
113         uint endTime;
114         uint rate;
115         uint shareRuleGroupId;
116         address[] addrList;
117         bool canceled;
118     }
119     IcoRule[] icoRuleList;
120     mapping (address => uint[] ) addr2icoRuleIdList;
121     event GetIcoRule(uint startTime, uint endTime, uint rate, uint shareRuleGroupId, bool canceled);
122     function icoRuleAdd(uint startTime, uint endTime, uint rate, uint shareRuleGroupId) public onlyOwner returns (bool) 
123     {
124         address[] memory addr;
125         bool canceled = false;
126         IcoRule memory item = IcoRule(startTime, endTime, rate, shareRuleGroupId, addr, canceled);
127         icoRuleList.push(item);
128         return true;
129     }
130     function icoRuleUpdate(uint index, uint startTime, uint endTime, uint rate, uint shareRuleGroupId) public onlyOwner returns (bool) 
131     {
132         require(icoRuleList.length > index);
133         if (startTime > 0) {
134             icoRuleList[index].startTime = startTime;
135         }
136         if (endTime > 0) {
137             icoRuleList[index].endTime = endTime;
138         }
139         if (rate > 0) {
140             icoRuleList[index].rate = rate;
141         }
142         icoRuleList[index].shareRuleGroupId = shareRuleGroupId;
143         return true;
144     }
145     function icoPushAddr(uint index, address addr) internal returns (bool) 
146     {
147         icoRuleList[index].addrList.push(addr);
148         return true;
149     }
150     function icoRuleCancel(uint index) public onlyOwner returns (bool) 
151     {
152         require(icoRuleList.length > index);
153         icoRuleList[index].canceled = true;
154         return true;
155     }
156     function getIcoRuleList() public returns (uint count) 
157     {
158         count = icoRuleList.length;
159         for (uint i = 0; i < count ; i++)
160         {
161             emit GetIcoRule(icoRuleList[i].startTime, icoRuleList[i].endTime, icoRuleList[i].rate, icoRuleList[i].shareRuleGroupId, 
162             icoRuleList[i].canceled);
163         }
164     }
165     function getIcoAddrCount(uint icoRuleId) public view onlyOwner returns (uint count) 
166     {
167         count = icoRuleList[icoRuleId - 1].addrList.length;
168     }
169     function getIcoAddrListByIcoRuleId(uint icoRuleId, uint index) public view onlyOwner returns (address addr) 
170     {
171         addr = icoRuleList[icoRuleId - 1].addrList[index];
172     }
173     function initIcoRule() internal returns(bool) 
174     {
175         icoRuleAdd(1529424001, 1532275199, 2600, 0);
176         icoRuleAdd(1532275201, 1533484799, 2100, 0);
177         icoRuleAdd(1533484801, 1534694399, 1700, 0);
178         icoRuleAdd(1534694401, 1535903999, 1400, 0);
179         icoRuleAdd(1535904001, 1537113599, 1100, 0);
180     }
181     struct ShareRule {
182         uint startTime;
183         uint endTime;
184         uint rateDenominator;
185     }
186     event GetShareRule(address addr, uint startTime, uint endTime, uint rateDenominator);
187     mapping (uint => ShareRule[]) shareRuleGroup;
188     mapping (address => uint) addr2shareRuleGroupId;
189     mapping (address => uint ) sharedAmount;
190     mapping (address => uint ) icoAmount;
191     ShareRule[] srlist_Team;
192     function initShareRule4Publicity() internal returns( bool )
193     {
194         ShareRule memory sr;
195         sr = ShareRule(1548432001, 1579967999, 5);
196         srlist_Team.push( sr );
197         sr = ShareRule(1579968001, 1611590399, 5);
198         srlist_Team.push( sr );
199         sr = ShareRule(1611590401, 1643126399, 5);
200         srlist_Team.push( sr );
201         sr = ShareRule(1643126401, 1674662399, 5);
202         srlist_Team.push( sr );
203         sr = ShareRule(1674662401, 1706198399, 5);
204         srlist_Team.push( sr );
205         shareRuleGroup[2] = srlist_Team;
206         addr2shareRuleGroupId[ADDR_MAYA_TEAM] = 2;
207         return true;
208     }
209     function initPublicityAddr() internal 
210     {
211         ADDR_MAYA_MARKETING = address(0xb92863581E6C3Ba7eDC78fFa45CdbBa59A4aD03C);
212         balances[ADDR_MAYA_MARKETING] = parse2wei(50000000);
213         ADDR_MAYA_ASSOCIATION = address(0xff849bf00Fd77C357A7B9A09E572a1510ff7C0dC);
214         balances[ADDR_MAYA_ASSOCIATION] = parse2wei(500000000);
215         ADDR_MAYA_TEAM = address(0xb391e1b2186DB3b8d2F3D0968F30AB456F1eCa57);
216         balances[ADDR_MAYA_TEAM] = parse2wei(100000000);
217         initShareRule4Publicity();
218     }
219     function updateShareRuleGroup(uint id, uint index, uint startTime, uint endTime, uint rateDenominator) public onlyOwner returns(bool)
220     {
221         if (startTime > 0) {
222             shareRuleGroup[id][index].startTime = startTime;
223         }
224         if (endTime > 0) {
225             shareRuleGroup[id][index].endTime = endTime;
226         }
227         if (rateDenominator > 0) {
228             shareRuleGroup[id][index].rateDenominator = rateDenominator;
229         }
230         return true;
231     }
232     function tokenShareShow(address addr) public returns(uint shareRuleGroupId) 
233     {
234         shareRuleGroupId = addr2shareRuleGroupId[addr];
235         if (shareRuleGroupId == 0) {
236             return 0;
237         }
238         ShareRule[] memory shareRuleList = shareRuleGroup[shareRuleGroupId];
239         uint count = shareRuleList.length;
240         for (uint i = 0; i < count ; i++)
241         {
242             emit GetShareRule(addr, shareRuleList[i].startTime, shareRuleList[i].endTime, shareRuleList[i].rateDenominator);
243         }
244         return shareRuleGroupId;
245     }
246     function setAccountShareRuleGroupId(address addr, uint shareRuleGroupId) public onlyOwner returns(bool)
247     {
248         addr2shareRuleGroupId[addr] = shareRuleGroupId;
249         return true;
250     }
251 }
252 pragma solidity ^0.4.23;
253 /**
254  * @title Basic token
255  * @dev Basic version of StandardToken, with no allowances.
256  */
257 contract BasicToken is ERC20Basic, MayaPlus 
258 {
259     using SafeMath for uint256;
260     uint256 internal totalSupply_;
261     mapping (address => bool) internal locked;
262     mapping (address => bool) internal isAgent;
263     mapping (address => uint) internal agentRate;
264     function setAgentRate(address addr, uint rate) public onlyAdmin returns(bool)
265     {
266         require( addr != address(0) );
267         agentRate[addr] = rate;
268         return true;
269     }
270     /**
271     * alan: lock or unlock account
272     */
273     function lockAccount(address _addr) public onlyAdmin returns (bool)
274     {
275         require(_addr != address(0));
276         locked[_addr] = true;
277         return true;
278     }
279     function unlockAccount(address _addr) public onlyAdmin returns (bool)
280     {
281         require(_addr != address(0));
282         locked[_addr] = false;
283         return true;
284     }
285     /**
286     * alan: get lock status
287     */
288     function isLocked(address addr) public view returns(bool) 
289     {
290         return locked[addr];
291     }
292     bool internal stopped = false;
293     modifier running {
294         assert (!stopped);
295         _;
296     }
297     function stop() public onlyOwner 
298     {
299         stopped = true;
300     }
301     function start() public onlyOwner 
302     {
303         stopped = false;
304     }
305     function isStopped() public view returns(bool)
306     {
307         return stopped;
308     }
309     /**
310     * @dev total number of tokens in existence
311     */
312     function totalSupply() public view returns (uint256) 
313     {
314         return totalSupply_;
315     }
316     function getRemainShareAmount() public view returns(uint)
317     {
318         return getRemainShareAmountInternal(msg.sender);
319     }
320     function getRemainShareAmountInternal(address addr) internal view returns(uint)
321     {
322         uint canTransferAmount = 0;
323         uint srgId = addr2shareRuleGroupId[addr];
324         bool allowTransfer = false;
325         if (srgId == 0) {
326             canTransferAmount = balances[addr];
327             return canTransferAmount;
328         }
329         else
330         {
331             ShareRule[] memory shareRuleList = shareRuleGroup[srgId];
332             uint count = shareRuleList.length;
333             for (uint i = 0; i < count ; i++)
334             {
335                 if ( shareRuleList[i].startTime < now && now < shareRuleList[i].endTime)
336                 {
337                     canTransferAmount = (i + 1).mul(icoAmount[addr]).div(shareRuleList[i].rateDenominator).sub( sharedAmount[addr]);
338                     return canTransferAmount;
339                 }
340             }
341             if (allowTransfer == false)
342             {
343                 bool isOverTime = true;
344                 for (i = 0; i < count ; i++) {
345                     if ( now < shareRuleList[i].endTime) {
346                         isOverTime = false;
347                     }
348                 }
349                 if (isOverTime == true) {
350                     allowTransfer = true;
351                     canTransferAmount = balances[addr];
352                     return canTransferAmount;
353                 }
354             }
355         }
356     }
357     /**
358     * @dev transfer token for a specified address
359     * @param _to The address to transfer to.
360     * @param _value The amount to be transferred.
361     */
362     function transfer(address _to, uint256 _value) public running returns (bool) 
363     {
364         require(_to != address(0));
365         require(_value <= balances[msg.sender]);
366         require( locked[msg.sender] != true);
367         require( locked[_to] != true);
368         require( getRemainShareAmount() >= _value );
369         balances[msg.sender] = balances[msg.sender].sub(_value);
370         sharedAmount[msg.sender] = sharedAmount[msg.sender].add( _value );
371         balances[_to] = balances[_to].add(_value);
372         emit Transfer(msg.sender, _to, _value);
373         return true;
374     }
375     /**
376     * @dev Gets the balance of the specified address.
377     * @param _owner The address to query the the balance of.
378     * @return An uint256 representing the amount owned by the passed address.
379     */
380     function balanceOf(address _owner) public view returns (uint256) 
381     {
382         return balances[_owner];
383     }
384 }
385 pragma solidity ^0.4.23;
386 /**
387  * @title Standard ERC20 token
388  *
389  * @dev Implementation of the basic standard token.
390  * @dev https://github.com/ethereum/EIPs/issues/20
391  * @dev Based on code by FirstBlood: https://github.com/Firstbloodio/token/blob/master/smart_contract/FirstBloodToken.sol
392  */
393 contract StandardToken is ERC20, BasicToken 
394 {
395     mapping (address => mapping (address => uint256)) internal allowed;
396     /**
397     * @dev Transfer tokens from one address to another
398     * @param _from address The address which you want to send tokens from
399     * @param _to address The address which you want to transfer to
400     * @param _value uint256 the amount of tokens to be transferred
401     */
402     function transferFrom(address _from, address _to, uint256 _value) public running returns (bool) 
403     {
404         require(_to != address(0));
405         require( locked[_from] != true && locked[_to] != true);
406         require(_value <= balances[_from]);
407         require(_value <= allowed[_from][msg.sender]);
408         balances[_from] = balances[_from].sub(_value);
409         balances[_to] = balances[_to].add(_value);
410         allowed[_from][msg.sender] = allowed[_from][msg.sender].sub(_value);
411         emit Transfer(_from, _to, _value);
412         return true;
413     }
414     /**
415     * @dev Approve the passed address to spend the specified amount of tokens on behalf of msg.sender.
416     *
417     * Beware that changing an allowance with this method brings the risk that someone may use both the
418     old
419     * and the new allowance by unfortunate transaction ordering. One possible solution to mitigate this
420     * race condition is to first reduce the spender's allowance to 0 and set the desired value afterwards:
421     * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
422     * @param _spender The address which will spend the funds.
423     * @param _value The amount of tokens to be spent.
424     */
425     function approve(address _spender, uint256 _value) public running returns (bool) 
426     {
427         require(getRemainShareAmountInternal(msg.sender) >= _value);
428         allowed[msg.sender][_spender] = _value;
429         emit Approval(msg.sender, _spender, _value);
430         return true;
431     }
432     /**
433     * @dev Function to check the amount of tokens that an owner allowed to a spender.
434     * @param _owner address The address which owns the funds.
435     * @param _spender address The address which will spend the funds.
436     * @return A uint256 specifying the amount of tokens still available for the spender.
437     */
438     function allowance(address _owner, address _spender) public view returns (uint256) 
439     {
440         return allowed[_owner][_spender];
441     }
442 }
443 contract AlanPlusToken is StandardToken
444 {
445     event Burn(address indexed from, uint256 value);
446     /**
447     * Destroy tokens
448     * Remove `_value` tokens from the system irreversibly
449     * @param _value the amount of money to burn
450     */
451     function burn(uint256 _value) public onlyOwner running returns (bool success) 
452     {
453         require(balances[msg.sender] >= _value);
454         balances[msg.sender] = balances[msg.sender].sub(_value);
455         totalSupply_ = totalSupply_.sub(_value);
456         emit Burn(msg.sender, _value);
457         return true;
458     }
459     /**
460     * Destroy tokens from other account
461     *
462     * Remove `_value` tokens from the system irreversibly on behalf of `_from`.
463     *
464     * @param _from the address of the senderT
465     * @param _value the amount of money to burn
466     */
467     function burnFrom(address _from, uint256 _value) public onlyOwner returns (bool success) 
468     {
469         require(balances[_from] >= _value);
470         if (_value <= allowed[_from][msg.sender]) {
471             allowed[_from][msg.sender] -= _value;
472         }
473         else {
474             allowed[_from][msg.sender] = 0;
475         }
476         balances[_from] -= _value;
477         totalSupply_ -= _value;
478         emit Burn(_from, _value);
479         return true;
480     }
481 }
482 pragma solidity ^0.4.23;
483 contract MAYA is AlanPlusToken 
484 {
485     string public constant name = "Maya";
486     string public constant symbol = "MAYA";
487     uint8 public constant decimals = 18;
488     uint256 private constant INITIAL_SUPPLY = 1000000000 * (10 ** uint256(decimals));
489     function () public payable 
490     {
491         uint curIcoRate = 0;
492         if (agentRate[msg.sender] > 0) {
493             curIcoRate = agentRate[msg.sender];
494         }
495         else 
496         {
497             uint icoRuleIndex = 500;
498             for (uint i = 0; i < icoRuleList.length ; i++)
499             {
500                 if ((icoRuleList[i].canceled != true) && (icoRuleList[i].startTime < now && now < icoRuleList[i].endTime)) {
501                     curIcoRate = icoRuleList[i].rate;
502                     icoRuleIndex = i;
503                 }
504             }
505             if (icoRuleIndex == 500)
506             {
507                 require(icoRuleIndex != 500);
508                 addr2icoRuleIdList[msg.sender].push( 0 );
509                 addr2shareRuleGroupId[msg.sender] = addr2shareRuleGroupId[msg.sender] > 0 ? addr2shareRuleGroupId[msg.sender] : 0;
510             }
511             else
512             {
513                 addr2shareRuleGroupId[msg.sender] = addr2shareRuleGroupId[msg.sender] > 0 ? addr2shareRuleGroupId[msg.sender] : icoRuleList[icoRuleIndex].shareRuleGroupId;
514                 addr2icoRuleIdList[msg.sender].push( icoRuleIndex + 1 );
515                 icoPushAddr(icoRuleIndex, msg.sender);
516             }
517         }
518         uint amountMAYA = 0;
519         amountMAYA = msg.value.mul( curIcoRate );
520         balances[msg.sender] = balances[msg.sender].add(amountMAYA);
521         icoAmount[msg.sender] = icoAmount[msg.sender].add(amountMAYA);
522         balances[owner] = balances[owner].sub(amountMAYA);
523         ADDR_MAYA_ORG.transfer(msg.value);
524     }
525     event AddBalance(address addr, uint amount);
526     event SubBalance(address addr, uint amount);
527     address addrContractCaller;
528     modifier isContractCaller {
529         require(msg.sender == addrContractCaller);
530         _;
531     }
532     function addBalance(address addr, uint amount) public isContractCaller returns(bool)
533     {
534         require(addr != address(0));
535         balances[addr] = balances[addr].add(amount);
536         emit AddBalance(addr, amount);
537         return true;
538     }
539     function subBalance(address addr, uint amount) public isContractCaller returns(bool)
540     {
541         require(balances[addr] >= amount);
542         balances[addr] = balances[addr].sub(amount);
543         emit SubBalance(addr, amount);
544         return true;
545     }
546     function setAddrContractCaller(address addr) onlyOwner public returns(bool)
547     {
548         require(addr != address(0));
549         addrContractCaller = addr;
550         return true;
551     }
552     constructor(uint totalSupply) public 
553     {
554         owner = msg.sender;
555         ADDR_MAYA_ORG = owner;
556         totalSupply_ = totalSupply > 0 ? totalSupply : INITIAL_SUPPLY;
557         uint assignedAmount = 500000000 + 50000000 + 100000000;
558         assignedAmount = parse2wei(assignedAmount);
559         balances[owner] = totalSupply_.sub( assignedAmount );
560         initIcoRule();
561         initPublicityAddr();
562         lockAccount(ADDR_MAYA_TEAM);
563     }
564 }