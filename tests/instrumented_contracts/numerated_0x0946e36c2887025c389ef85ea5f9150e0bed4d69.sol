1 pragma solidity ^0.4.23;
2 /*
3  *             ╔═╗┌─┐┌─┐┬┌─┐┬┌─┐┬   ┌─────────────────────────┐ ╦ ╦┌─┐┌┐ ╔═╗┬┌┬┐┌─┐
4  *             ║ ║├┤ ├┤ ││  │├─┤│   │ KOL Community Alliance  │ ║║║├┤ ├┴┐╚═╗│ │ ├┤
5  *             ╚═╝└  └  ┴└─┘┴┴ ┴┴─┘ └─┬─────────────────────┬─┘ ╚╩╝└─┘└─┘╚═╝┴ ┴ └─┘
6  *   ┌────────────────────────────────┘                     └──────────────────────────────┐
7  *   │    ┌─────────────────────────────────────────────────────────────────────────────┐  │
8  *   └────┤ Dev:Jack Koe ├─────────────┤ Special for: KOL  ├───────────────┤ 20191211   ├──┘
9  *        └─────────────────────────────────────────────────────────────────────────────┘
10  */
11 
12 library SafeMath {
13 
14   function mul(uint256 _a, uint256 _b) internal pure returns (uint256 c) {
15     if (_a == 0) {
16       return 0;
17     }
18     c = _a * _b;
19     assert(c / _a == _b);
20     return c;
21   }
22   function div(uint256 _a, uint256 _b) internal pure returns (uint256) {
23     return _a / _b;
24   }
25   function sub(uint256 _a, uint256 _b) internal pure returns (uint256) {
26     assert(_b <= _a);
27     return _a - _b;
28   }
29   function add(uint256 _a, uint256 _b) internal pure returns (uint256 c) {
30     c = _a + _b;
31     assert(c >= _a);
32     return c;
33   }
34 }
35 
36 contract Ownable {
37 
38   address public owner;
39   event OwnershipTransferred(
40     address indexed previousOwner,
41     address indexed newOwner
42   );
43   constructor() public {
44     owner = msg.sender;
45   }
46   modifier onlyOwner() {
47     require(msg.sender == owner);
48     _;
49   }
50   function _transferOwnership(address _newOwner) internal {
51     require(_newOwner != address(0));
52     emit OwnershipTransferred(owner, _newOwner);
53     owner = _newOwner;
54   }
55 }
56 
57 contract ERC20Basic {
58   function balanceOf(address _who) public view returns (uint256);
59   function transfer(address _to, uint256 _value) public returns (bool);
60   event Transfer(address indexed from, address indexed to, uint256 value);
61 }
62 
63 contract ERC20 is ERC20Basic {
64   function allowance(address _owner, address _spender)
65     public view returns (uint256);
66 
67   function transferFrom(address _from, address _to, uint256 _value)
68     public returns (bool);
69 
70   function approve(address _spender, uint256 _value) public returns (bool);
71   event Approval(
72     address indexed owner,
73     address indexed spender,
74     uint256 value
75   );
76 }
77 
78 contract BasicToken is Ownable,ERC20Basic {
79   using SafeMath for uint256;
80 
81   mapping(address => uint256) internal balances;
82 
83   function transfer(address _to, uint256 _value) public returns (bool) {
84     require(msg.sender != owner);
85     require(_value <= balances[msg.sender]);
86     require(_to != address(0));
87 
88     balances[msg.sender] = balances[msg.sender].sub(_value);
89     balances[_to] = balances[_to].add(_value);
90     emit Transfer(msg.sender, _to, _value);
91     return true;
92   }
93   function balanceOf(address _owner) public view returns (uint256) {
94     return balances[_owner];
95   }
96 }
97 
98 contract StandardToken is ERC20, BasicToken {
99 
100   mapping (address => mapping (address => uint256)) internal allowed;
101 
102   function transferFrom(
103     address _from,
104     address _to,
105     uint256 _value
106   )
107     public
108     returns (bool)
109   {
110     require(_from != owner);
111     require(_value <= balances[_from]);
112     require(_value <= allowed[_from][msg.sender]);
113     require(_to != address(0));
114 
115     balances[_from] = balances[_from].sub(_value);
116     balances[_to] = balances[_to].add(_value);
117     allowed[_from][msg.sender] = allowed[_from][msg.sender].sub(_value);
118     emit Transfer(_from, _to, _value);
119     return true;
120   }
121   function approve(address _spender, uint256 _value) public returns (bool) {
122     allowed[msg.sender][_spender] = _value;
123     emit Approval(msg.sender, _spender, _value);
124     return true;
125   }
126   function allowance(
127     address _owner,
128     address _spender
129    )
130     public
131     view
132     returns (uint256)
133   {
134     return allowed[_owner][_spender];
135   }
136 
137   function increaseApproval(
138     address _spender,
139     uint256 _addedValue
140   )
141     public
142     returns (bool)
143   {
144     allowed[msg.sender][_spender] = (
145       allowed[msg.sender][_spender].add(_addedValue));
146     emit Approval(msg.sender, _spender, allowed[msg.sender][_spender]);
147     return true;
148   }
149 
150   function decreaseApproval(
151     address _spender,
152     uint256 _subtractedValue
153   )
154     public
155     returns (bool)
156   {
157     uint256 oldValue = allowed[msg.sender][_spender];
158     if (_subtractedValue >= oldValue) {
159       allowed[msg.sender][_spender] = 0;
160     } else {
161       allowed[msg.sender][_spender] = oldValue.sub(_subtractedValue);
162     }
163     emit Approval(msg.sender, _spender, allowed[msg.sender][_spender]);
164     return true;
165   }
166 
167 }
168 
169 contract KOL is StandardToken{
170     using SafeMath for uint256;
171 
172     uint256 public constant TOKEN_DECIMALS = 18;
173 
174     string public name = "KOL Community Alliance";
175     string public symbol = "KOL";
176     uint256 public decimals = TOKEN_DECIMALS;
177     uint256 public totalSupply = 21000000 *(10**uint256(TOKEN_DECIMALS));
178 
179     uint256 public totalSupplyed = 0;
180     address public ethFundDeposit;
181 
182     uint16 public constant totalSuperNodes = 21;
183     uint16 public constant totalNodes = 500;
184     uint16 public constant halfSuperNodes = 11;
185     uint16 public constant mostNodes = 335;
186     uint16 public constant halfNodes = 251;
187     uint16 public constant minSuperNodes = 15;
188     uint16 public constant minNodes = 101;
189 
190     uint16 public constant most = 67;
191     uint16 public constant half = 51;
192     uint16 public constant less = 33;
193 
194     function construct() public {
195         ethFundDeposit = msg.sender;
196     }
197     function setEthFundDeposit(address _ethFundDeposit) onlyOwner public {
198         require(_ethFundDeposit != address(0));
199         ethFundDeposit = _ethFundDeposit;
200     }
201 
202     function transferETH() onlyOwner public {
203         require(ethFundDeposit != address(0));
204         require(address(this).balance != 0);
205         require(ethFundDeposit.send(address(this).balance));
206     }
207     function isOwner() internal view returns(bool success) {
208         if (msg.sender == owner) return true;
209         return false;
210     }
211 }
212 
213 contract KOLVote is KOL {
214 
215     uint256 public constant totalNodeSupply = 5000000 *(10**uint256(TOKEN_DECIMALS));
216     uint256 public constant totalUserSupply = 16000000 *(10**uint256(TOKEN_DECIMALS));
217     uint256 public nodeSupplyed = 0;
218     uint256 public userSupplyed = 0;
219 
220     uint256 public superNodesNum = 0;
221     uint256 public nodesNum = 0;
222     uint256 public dealTime =  3 days;
223     uint256 public missionId = 0;
224 
225     mapping(address => bool) private isSuperNode;
226     mapping(address => bool) private isNode;
227     mapping(address => mapping(uint256 => bool)) private Voter;
228 
229 
230     event MissionPassed(uint256 _missionId,bytes32 _name);
231     event OfferingFinished(uint256 _missionId,uint256 _totalAmount,uint256 _length);
232     event RecycleTokens(uint256 _missionId,uint256 _totalAmount);
233     event NodeChanged(uint16 _type,address _oldNode,address _newNode);
234     event MissionLaunched(bytes32 _name,uint256 _missionId,address _whoLaunch);
235     event Burn(address indexed burner, uint256 value);
236 
237     function burn(uint256 _value) internal {
238       require(_value <= balances[owner]);
239       require(_value <= totalSupply);
240       balances[owner] = balances[owner].sub(_value);
241       totalSupply = totalSupply.sub(_value);
242       emit Burn(owner, _value);
243       emit Transfer(owner, address(0), _value);
244     }
245 
246     modifier onlySuperNode() {
247       require(isSuperNode[msg.sender]);
248         _;
249     }
250     modifier onlyNode() {
251         require(isNode[msg.sender]);
252         _;
253     }
254     modifier onlyNodes() {
255         require(isSuperNode[msg.sender]||isNode[msg.sender]);
256         _;
257     }
258 
259     function setSuperNode(address superNodeAddress) onlyOwner public{
260       require(!isSuperNode[superNodeAddress]);
261       require(superNodesNum < totalSuperNodes);
262       isSuperNode[superNodeAddress] = true;
263       superNodesNum++;
264     }
265 
266     function setNode(address nodeAddress) onlyOwner public{
267       require(!isNode[nodeAddress]);
268       require(nodesNum < totalNodes);
269       isNode[nodeAddress] = true;
270       nodesNum++;
271 
272     }
273 
274     function querySuperNode(address _addr) public view returns(bool){
275       return(isSuperNode[_addr]);
276     }
277     function queryNode(address _addr) public view returns(bool){
278       return(isNode[_addr]);
279     }
280     /***************************************************/
281     /*       KOL Vote Code Begin here                  */
282     /***************************************************/
283 
284     struct KolMission{
285       address oldNode;
286       address newNode;
287       uint256 startTime;
288       uint256 endTime;
289       uint256 totalAmount;
290       uint256 offeringAmount;
291       bytes32 name;
292       uint16 agreeNodes;
293       uint16 refuseNodes;
294       uint16 agreeSuperNodes;
295       uint16 refuseSuperNodes;
296       bool superPassed;
297       bool nodePassed;
298       bool done;
299     }
300     mapping (uint256 => KolMission) private missionList;
301 
302     struct KolOffering{
303       address target;
304       uint256 targetAmount;
305     }
306     KolOffering[] private kolOfferings;
307 
308     mapping(uint256 => KolOffering[]) private offeringList;
309 
310     //_type:1,change supernode;2,change node;3,changeowner;4,mission launched;6,creation issuing;7,recycle token from owner
311     function createKolMission(uint16 _type,bytes32 _name,uint256 _totalAmount,address _oldNode,address _newNode) onlyNodes public {
312         bytes32 iName = _name;
313         if (_type == 2){
314           require(isSuperNode[msg.sender]);
315           iName = "CHANGE NODE";
316         }else if (_type == 3){
317           iName = "CHANGE OWNER";
318         }else if (_type == 1){
319           require(isNode[msg.sender]);
320           iName = "CHANGE SUPER NODE";
321         }else if ((_type ==4)){
322           require((_totalAmount + userSupplyed) <= totalUserSupply);
323         }else if (_type ==6){
324           require((_totalAmount + nodeSupplyed) <= totalNodeSupply);
325           iName = "CREATION ISSUING";
326         }else if (_type ==7){
327           iName = "RECYCLE TOKEN FROM OWNER";
328         }
329         missionList[missionId] = KolMission(_oldNode,
330                                             _newNode,
331                                             uint256(now),
332                                             uint256(now + dealTime),
333                                             _totalAmount,
334                                             0,
335                                             iName,
336                                             0,
337                                             0,
338                                             0,
339                                             0,
340                                             false,
341                                             false,
342                                             false);
343 
344         missionId++;
345         emit MissionLaunched(iName,missionId-1,msg.sender);
346     }
347     function addKolOffering(uint256 _missionId,address _target,uint256 _targetAmount) onlyNodes public{
348       require(missionList[_missionId].superPassed);
349       require(!missionList[_missionId].done);
350       if (missionList[_missionId].name == "CREATION ISSUING"){
351         require(isNode[_target]||isSuperNode[_target]);
352       }
353       require(missionList[_missionId].offeringAmount.add(_targetAmount) <= missionList[_missionId].totalAmount);
354       offeringList[_missionId].push(KolOffering(_target,_targetAmount));
355       missionList[_missionId].offeringAmount = missionList[_missionId].offeringAmount.add(_targetAmount);
356 
357     }
358     function missionPassed(uint256 _missionId) private {
359       if ((missionList[_missionId].name != "CHANGE SUPER NODE") &&
360               (missionList[_missionId].name != "CHANGE NODE") &&
361               (missionList[_missionId].name != "CHANGE OWNER") &&
362               (missionList[_missionId].name != "RECYCLE TOKEN FROM OWNER")){
363           emit MissionPassed(_missionId,missionList[_missionId].name);
364         }
365 
366     }
367     //once voting passed,excute auto;
368     function excuteAuto(uint256 _missionId) private {
369       if ((missionList[_missionId].name == "CHANGE NODE") && missionList[_missionId].superPassed){
370         require(isNode[missionList[_missionId].oldNode]);
371         require(!isSuperNode[missionList[_missionId].newNode]);
372         isNode[missionList[_missionId].oldNode] = false;
373         isNode[missionList[_missionId].newNode] = true;
374         missionList[_missionId].done = true;
375         emit NodeChanged(2,missionList[_missionId].oldNode,missionList[_missionId].newNode);
376       }else if ((missionList[_missionId].name == "CHANGE SUPER NODE") && missionList[_missionId].nodePassed){
377         require(isSuperNode[missionList[_missionId].oldNode]);
378         require(!isSuperNode[missionList[_missionId].newNode]);
379         isSuperNode[missionList[_missionId].oldNode] = false;
380         isSuperNode[missionList[_missionId].newNode] = true;
381         missionList[_missionId].done = true;
382         emit NodeChanged(1,missionList[_missionId].oldNode,missionList[_missionId].newNode);
383       }else if ((missionList[_missionId].name == "CHANGE OWNER") && missionList[_missionId].nodePassed){
384         emit NodeChanged(3,owner,missionList[_missionId].newNode);
385         _transferOwnership(missionList[_missionId].newNode);
386         missionList[_missionId].done = true;
387       }else if ((missionList[_missionId].name == "RECYCLE TOKEN FROM OWNER") && missionList[_missionId].nodePassed){
388         burn(missionList[_missionId].totalAmount);
389         emit RecycleTokens(_missionId,missionList[_missionId].totalAmount);
390         missionList[_missionId].done = true;
391       }
392     }
393     //_type,1,supernode;2,node
394     function voteMission(uint16 _type,uint256 _missionId,bool _agree) onlyNodes public{
395       require(!Voter[msg.sender][_missionId]);
396       require(!missionList[_missionId].done);
397       uint16 minNodesNum = minNodes;
398       uint16 minSuperNodesNum = minSuperNodes;
399       uint16 passNodes = halfNodes;
400       uint16 passSuperNodes = halfSuperNodes;
401       uint16 rate = half;
402       if (missionList[_missionId].name == "CHANGE OWNER") {
403         rate = most;
404         minNodesNum = totalNodes;
405         passNodes = mostNodes;
406       }else if (missionList[_missionId].name == "CHANGE NODE"){
407         rate = less;
408         minSuperNodesNum = minSuperNodes;
409         passSuperNodes = halfSuperNodes;
410       }else if (missionList[_missionId].name == "CHANGE SUPER NODE"){
411         rate = less;
412         minNodesNum = minNodes;
413         passNodes = halfNodes;
414       }else if (missionList[_missionId].name == "CREATION ISSUING"){
415         minNodesNum = minNodes;
416         passNodes = halfNodes;
417         minSuperNodesNum = minSuperNodes;
418         passSuperNodes = halfSuperNodes;
419       }else if (missionList[_missionId].name == "RECYCLE TOKEN FROM OWNER"){
420         minNodesNum = minNodes;
421         passNodes = halfNodes;
422       }
423 
424       if (_type == 1){
425         require(isSuperNode[msg.sender]);
426       }else if (_type ==2){
427         require(isNode[msg.sender]);
428       }
429 
430       if(now > missionList[_missionId].endTime){
431         if ( _type == 1 ){
432           if (
433             (missionList[_missionId].agreeSuperNodes + missionList[_missionId].refuseSuperNodes)>=minSuperNodesNum
434             &&
435             missionList[_missionId].agreeSuperNodes >= (missionList[_missionId].agreeSuperNodes + missionList[_missionId].refuseSuperNodes) * rate/100
436             ){
437               missionList[_missionId].superPassed = true;
438               missionPassed(_missionId);
439           }
440         }else if (_type ==2 ){
441           //节点投票
442           if (
443             (missionList[_missionId].agreeNodes + missionList[_missionId].refuseNodes)>=minNodesNum
444             &&
445             missionList[_missionId].agreeNodes >= (missionList[_missionId].refuseNodes + missionList[_missionId].refuseNodes) * rate/100
446             ){
447               missionList[_missionId].nodePassed = true;
448           }
449         }
450       }else{
451         if(_agree == true){
452           if (_type == 1){
453             missionList[_missionId].agreeSuperNodes++;
454           }else if(_type == 2){
455             missionList[_missionId].agreeNodes++;
456           }
457         }
458         else{
459           if (_type == 1){
460             missionList[_missionId].refuseSuperNodes++;
461           }else if(_type == 2){
462             missionList[_missionId].refuseNodes++;
463           }
464         }
465         if (_type == 1){
466           if (missionList[_missionId].agreeSuperNodes >= passSuperNodes) {
467               missionList[_missionId].superPassed = true;
468               missionPassed(_missionId);
469           }else if (missionList[_missionId].refuseSuperNodes >= passSuperNodes) {
470               missionList[_missionId].done = true;
471           }
472         }else if (_type ==2){
473           if (missionList[_missionId].agreeNodes >= passNodes) {
474               missionList[_missionId].nodePassed = true;
475           }else if (missionList[_missionId].refuseNodes >= passNodes) {
476               missionList[_missionId].done = true;
477           }
478         }
479       }
480       Voter[msg.sender][_missionId] = true;
481       excuteAuto(_missionId);
482     }
483 
484     function excuteVote(uint256 _missionId) onlyOwner public {
485       require(!missionList[_missionId].done);
486       require(uint256(now) < (missionList[_missionId].endTime + uint256(dealTime)));
487 
488       require(missionList[_missionId].superPassed);
489       require(missionList[_missionId].nodePassed);
490       require(missionList[_missionId].totalAmount == missionList[_missionId].offeringAmount);
491       require((missionList[_missionId].totalAmount.add(totalSupplyed))<=totalNodeSupply.add(totalUserSupply));
492 
493       if (missionList[_missionId].name == "CREATION ISSUING"){
494         require((nodeSupplyed.add(missionList[_missionId].totalAmount))<=totalNodeSupply);
495       }else{
496         require((userSupplyed.add(missionList[_missionId].totalAmount))<=totalUserSupply);
497       }
498       for (uint m = 0; m < offeringList[_missionId].length; m++){
499         balances[offeringList[_missionId][m].target] = balances[offeringList[_missionId][m].target].add(offeringList[_missionId][m].targetAmount);
500         emit Transfer(msg.sender,offeringList[_missionId][m].target,offeringList[_missionId][m].targetAmount);
501       }
502       totalSupplyed = totalSupplyed.add(missionList[_missionId].totalAmount);
503 
504       if (missionList[_missionId].name == "CREATION ISSUING"){
505         nodeSupplyed = nodeSupplyed.add(missionList[_missionId].totalAmount);
506       }else{
507         userSupplyed = userSupplyed.add(missionList[_missionId].totalAmount);
508       }
509       missionList[_missionId].done = true;
510       emit OfferingFinished(_missionId,missionList[_missionId].offeringAmount,offeringList[_missionId].length);
511 
512     }
513     function getMission1(uint256 _missionId) public view returns(address,
514                                                               address,
515                                                               uint256,
516                                                               uint256,
517                                                               uint256,
518                                                               uint256,
519                                                               bytes32){
520       return(missionList[_missionId].oldNode,
521               missionList[_missionId].newNode,
522               missionList[_missionId].startTime,
523               missionList[_missionId].endTime,
524               missionList[_missionId].totalAmount,
525               missionList[_missionId].offeringAmount,
526               missionList[_missionId].name);
527     }
528     function getMission2(uint256 _missionId) public view returns(uint16,
529                                                                 uint16,
530                                                                 uint16,
531                                                                 uint16,
532                                                                 bool,
533                                                                 bool,
534                                                                 bool){
535       return(
536             missionList[_missionId].agreeNodes,
537             missionList[_missionId].refuseNodes,
538             missionList[_missionId].agreeSuperNodes,
539             missionList[_missionId].refuseSuperNodes,
540             missionList[_missionId].superPassed,
541             missionList[_missionId].nodePassed,
542             missionList[_missionId].done);
543     }
544     function getOfferings(uint256 _missionId,uint256 _id) public view returns(address,uint256,uint256){
545       return(offeringList[_missionId][_id].target,offeringList[_missionId][_id].targetAmount,offeringList[_missionId].length);
546     }
547     function voted(address _node,uint256 _missionId) public view returns(bool){
548       return Voter[_node][_missionId];
549     }
550 }