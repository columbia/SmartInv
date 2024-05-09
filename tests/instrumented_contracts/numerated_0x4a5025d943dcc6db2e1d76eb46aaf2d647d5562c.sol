1 pragma solidity ^0.4.23;
2 /*
3  *             ╔═╗┌─┐┌─┐┬┌─┐┬┌─┐┬   ┌─────────────────────────┐ ╦ ╦┌─┐┌┐ ╔═╗┬┌┬┐┌─┐
4  *             ║ ║├┤ ├┤ ││  │├─┤│   │ KOL Community Foundation  │ ║║║├┤ ├┴┐╚═╗│ │ ├┤
5  *             ╚═╝└  └  ┴└─┘┴┴ ┴┴─┘ └─┬─────────────────────┬─┘ ╚╩╝└─┘└─┘╚═╝┴ ┴ └─┘
6  *   ┌────────────────────────────────┘                     └──────────────────────────────┐
7  *   │    ┌─────────────────────────────────────────────────────────────────────────────┐  │
8  *   └────┤ Dev:Jack Koe ├─────────────┤ Special for: KOL  ├───────────────┤ 20200106   ├──┘
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
182 
183     uint16 public constant totalSuperNodes = 21;
184     uint16 public constant totalNodes = 500;
185     uint16 public constant halfSuperNodes = 11;
186     uint16 public constant mostNodes = 335;
187     uint16 public constant halfNodes = 251;
188     uint16 public constant minSuperNodes = 15;
189     uint16 public constant minNodes = 101;
190 
191     uint16 public constant most = 67;
192     uint16 public constant half = 51;
193     uint16 public constant less = 33;
194 
195     function construct() public {
196         ethFundDeposit = msg.sender;
197     }
198     function setEthFundDeposit(address _ethFundDeposit) onlyOwner public {
199         require(_ethFundDeposit != address(0));
200         ethFundDeposit = _ethFundDeposit;
201     }
202 
203     function transferETH() onlyOwner public {
204         require(ethFundDeposit != address(0));
205         require(address(this).balance != 0);
206         require(ethFundDeposit.send(address(this).balance));
207     }
208     function isOwner() internal view returns(bool success) {
209         if (msg.sender == owner) return true;
210         return false;
211     }
212 }
213 
214 contract KOLVote is KOL {
215 
216     uint256 public constant totalNodeSupply = 5000000 *(10**uint256(TOKEN_DECIMALS));
217     uint256 public constant totalUserSupply = 16000000 *(10**uint256(TOKEN_DECIMALS));
218     uint256 public nodeSupplyed = 0;
219     uint256 public userSupplyed = 0;
220 
221     uint256 public superNodesNum = 0;
222     uint256 public nodesNum = 0;
223     uint256 public dealTime =  3 days;
224     uint256 public missionId = 0;
225 
226     mapping(address => bool) private isSuperNode;
227     mapping(address => bool) private isNode;
228     mapping(address => mapping(uint256 => bool)) private Voter;
229 
230 
231     event MissionPassed(uint256 _missionId,bytes32 _name);
232     event OfferingFinished(uint256 _missionId,uint256 _totalAmount,uint256 _length);
233     event RecycleTokens(uint256 _missionId,uint256 _totalAmount);
234     event NodeChanged(uint16 _type,address _oldNode,address _newNode);
235     event MissionLaunched(bytes32 _name,uint256 _missionId,address _whoLaunch);
236     event Burn(address indexed burner, uint256 value);
237 
238     function burn(uint256 _value) internal {
239       require(_value <= balances[owner]);
240       require(_value <= totalSupply);
241       balances[owner] = balances[owner].sub(_value);
242       totalSupply = totalSupply.sub(_value);
243       emit Burn(owner, _value);
244       emit Transfer(owner, address(0), _value);
245     }
246 
247     modifier onlySuperNode() {
248       require(isSuperNode[msg.sender]);
249         _;
250     }
251     modifier onlyNode() {
252         require(isNode[msg.sender]);
253         _;
254     }
255     modifier onlyNodes() {
256         require(isSuperNode[msg.sender]||isNode[msg.sender]);
257         _;
258     }
259 
260     function setSuperNode(address superNodeAddress) onlyOwner public{
261       require(!isSuperNode[superNodeAddress]);
262       require(superNodesNum < totalSuperNodes);
263       isSuperNode[superNodeAddress] = true;
264       superNodesNum++;
265     }
266 
267     function setNode(address nodeAddress) onlyOwner public{
268       require(!isNode[nodeAddress]);
269       require(nodesNum < totalNodes);
270       isNode[nodeAddress] = true;
271       nodesNum++;
272 
273     }
274 
275     function querySuperNode(address _addr) public view returns(bool){
276       return(isSuperNode[_addr]);
277     }
278     function queryNode(address _addr) public view returns(bool){
279       return(isNode[_addr]);
280     }
281     /***************************************************/
282     /*       KOL Vote Code Begin here                  */
283     /***************************************************/
284 
285     struct KolMission{
286       address oldNode;
287       address newNode;
288       uint256 startTime;
289       uint256 endTime;
290       uint256 totalAmount;
291       uint256 offeringAmount;
292       bytes32 name;
293       uint16 agreeNodes;
294       uint16 refuseNodes;
295       uint16 agreeSuperNodes;
296       uint16 refuseSuperNodes;
297       bool superPassed;
298       bool nodePassed;
299       bool done;
300     }
301     mapping (uint256 => KolMission) private missionList;
302 
303     struct KolOffering{
304       address target;
305       uint256 targetAmount;
306     }
307     KolOffering[] private kolOfferings;
308 
309     mapping(uint256 => KolOffering[]) private offeringList;
310 
311     //_type:1,change supernode;2,change node;3,changeowner;4,mission launched;6,creation issuing;7,recycle token from owner
312     function createKolMission(uint16 _type,bytes32 _name,uint256 _totalAmount,address _oldNode,address _newNode) onlyNodes public {
313         bytes32 iName = _name;
314         if (_type == 2){
315           require(isSuperNode[msg.sender]);
316           iName = "CHANGE NODE";
317         }else if (_type == 3){
318           iName = "CHANGE OWNER";
319         }else if (_type == 1){
320           require(isNode[msg.sender]);
321           iName = "CHANGE SUPER NODE";
322         }else if ((_type ==4)){
323           require((_totalAmount + userSupplyed) <= totalUserSupply);
324         }else if (_type ==6){
325           require((_totalAmount + nodeSupplyed) <= totalNodeSupply);
326           iName = "CREATION ISSUING";
327         }else if (_type ==7){
328           iName = "RECYCLE TOKEN FROM OWNER";
329         }
330         missionList[missionId] = KolMission(_oldNode,
331                                             _newNode,
332                                             uint256(now),
333                                             uint256(now + dealTime),
334                                             _totalAmount,
335                                             0,
336                                             iName,
337                                             0,
338                                             0,
339                                             0,
340                                             0,
341                                             false,
342                                             false,
343                                             false);
344 
345         missionId++;
346         emit MissionLaunched(iName,missionId-1,msg.sender);
347     }
348     function addKolOffering(uint256 _missionId,address _target,uint256 _targetAmount) onlyNodes public{
349       require(missionList[_missionId].superPassed);
350       require(!missionList[_missionId].done);
351       if (missionList[_missionId].name == "CREATION ISSUING"){
352         require(isNode[_target]||isSuperNode[_target]);
353       }
354       require(missionList[_missionId].offeringAmount.add(_targetAmount) <= missionList[_missionId].totalAmount);
355       offeringList[_missionId].push(KolOffering(_target,_targetAmount));
356       missionList[_missionId].offeringAmount = missionList[_missionId].offeringAmount.add(_targetAmount);
357 
358     }
359     function missionPassed(uint256 _missionId) private {
360       if ((missionList[_missionId].name != "CHANGE SUPER NODE") &&
361               (missionList[_missionId].name != "CHANGE NODE") &&
362               (missionList[_missionId].name != "CHANGE OWNER") &&
363               (missionList[_missionId].name != "RECYCLE TOKEN FROM OWNER")){
364           emit MissionPassed(_missionId,missionList[_missionId].name);
365         }
366 
367     }
368     //once voting passed,excute auto;
369     function excuteAuto(uint256 _missionId) private {
370       if ((missionList[_missionId].name == "CHANGE NODE") && missionList[_missionId].superPassed){
371         require(isNode[missionList[_missionId].oldNode]);
372         require(!isSuperNode[missionList[_missionId].newNode]);
373         isNode[missionList[_missionId].oldNode] = false;
374         isNode[missionList[_missionId].newNode] = true;
375         missionList[_missionId].done = true;
376         emit NodeChanged(2,missionList[_missionId].oldNode,missionList[_missionId].newNode);
377       }else if ((missionList[_missionId].name == "CHANGE SUPER NODE") && missionList[_missionId].nodePassed){
378         require(isSuperNode[missionList[_missionId].oldNode]);
379         require(!isSuperNode[missionList[_missionId].newNode]);
380         isSuperNode[missionList[_missionId].oldNode] = false;
381         isSuperNode[missionList[_missionId].newNode] = true;
382         missionList[_missionId].done = true;
383         emit NodeChanged(1,missionList[_missionId].oldNode,missionList[_missionId].newNode);
384       }else if ((missionList[_missionId].name == "CHANGE OWNER") && missionList[_missionId].nodePassed){
385         emit NodeChanged(3,owner,missionList[_missionId].newNode);
386         _transferOwnership(missionList[_missionId].newNode);
387         missionList[_missionId].done = true;
388       }else if ((missionList[_missionId].name == "RECYCLE TOKEN FROM OWNER") && missionList[_missionId].nodePassed){
389         burn(missionList[_missionId].totalAmount);
390         emit RecycleTokens(_missionId,missionList[_missionId].totalAmount);
391         missionList[_missionId].done = true;
392       }
393     }
394     //_type,1,supernode;2,node
395     function voteMission(uint16 _type,uint256 _missionId,bool _agree) onlyNodes public{
396       require(!Voter[msg.sender][_missionId]);
397       require(!missionList[_missionId].done);
398       uint16 minNodesNum = minNodes;
399       uint16 minSuperNodesNum = minSuperNodes;
400       uint16 passNodes = halfNodes;
401       uint16 passSuperNodes = halfSuperNodes;
402       uint16 rate = half;
403       if (missionList[_missionId].name == "CHANGE OWNER") {
404         rate = most;
405         minNodesNum = totalNodes;
406         passNodes = mostNodes;
407       }else if (missionList[_missionId].name == "CHANGE NODE"){
408         rate = less;
409         minSuperNodesNum = minSuperNodes;
410         passSuperNodes = halfSuperNodes;
411       }else if (missionList[_missionId].name == "CHANGE SUPER NODE"){
412         rate = less;
413         minNodesNum = minNodes;
414         passNodes = halfNodes;
415       }else if (missionList[_missionId].name == "CREATION ISSUING"){
416         minNodesNum = minNodes;
417         passNodes = halfNodes;
418         minSuperNodesNum = minSuperNodes;
419         passSuperNodes = halfSuperNodes;
420       }else if (missionList[_missionId].name == "RECYCLE TOKEN FROM OWNER"){
421         minNodesNum = minNodes;
422         passNodes = halfNodes;
423       }
424 
425       if (_type == 1){
426         require(isSuperNode[msg.sender]);
427       }else if (_type ==2){
428         require(isNode[msg.sender]);
429       }
430 
431       if(now > missionList[_missionId].endTime){
432         if ( _type == 1 ){
433           if (
434             (missionList[_missionId].agreeSuperNodes + missionList[_missionId].refuseSuperNodes)>=minSuperNodesNum
435             &&
436             missionList[_missionId].agreeSuperNodes >= (missionList[_missionId].agreeSuperNodes + missionList[_missionId].refuseSuperNodes) * rate/100
437             ){
438               missionList[_missionId].superPassed = true;
439               missionPassed(_missionId);
440           }
441         }else if (_type ==2 ){
442           //节点投票
443           if (
444             (missionList[_missionId].agreeNodes + missionList[_missionId].refuseNodes)>=minNodesNum
445             &&
446             missionList[_missionId].agreeNodes >= (missionList[_missionId].refuseNodes + missionList[_missionId].refuseNodes) * rate/100
447             ){
448               missionList[_missionId].nodePassed = true;
449           }
450         }
451       }else{
452         if(_agree == true){
453           if (_type == 1){
454             missionList[_missionId].agreeSuperNodes++;
455           }else if(_type == 2){
456             missionList[_missionId].agreeNodes++;
457           }
458         }
459         else{
460           if (_type == 1){
461             missionList[_missionId].refuseSuperNodes++;
462           }else if(_type == 2){
463             missionList[_missionId].refuseNodes++;
464           }
465         }
466         if (_type == 1){
467           if (missionList[_missionId].agreeSuperNodes >= passSuperNodes) {
468               missionList[_missionId].superPassed = true;
469               missionPassed(_missionId);
470           }else if (missionList[_missionId].refuseSuperNodes >= passSuperNodes) {
471               missionList[_missionId].done = true;
472           }
473         }else if (_type ==2){
474           if (missionList[_missionId].agreeNodes >= passNodes) {
475               missionList[_missionId].nodePassed = true;
476           }else if (missionList[_missionId].refuseNodes >= passNodes) {
477               missionList[_missionId].done = true;
478           }
479         }
480       }
481       Voter[msg.sender][_missionId] = true;
482       excuteAuto(_missionId);
483     }
484 
485     function excuteVote(uint256 _missionId) onlyOwner public {
486       require(!missionList[_missionId].done);
487       require(uint256(now) < (missionList[_missionId].endTime + uint256(dealTime)));
488 
489       require(missionList[_missionId].superPassed);
490       require(missionList[_missionId].nodePassed);
491       require(missionList[_missionId].totalAmount == missionList[_missionId].offeringAmount);
492       require((missionList[_missionId].totalAmount.add(totalSupplyed))<=totalNodeSupply.add(totalUserSupply));
493 
494       if (missionList[_missionId].name == "CREATION ISSUING"){
495         require((nodeSupplyed.add(missionList[_missionId].totalAmount))<=totalNodeSupply);
496       }else{
497         require((userSupplyed.add(missionList[_missionId].totalAmount))<=totalUserSupply);
498       }
499       for (uint m = 0; m < offeringList[_missionId].length; m++){
500         balances[offeringList[_missionId][m].target] = balances[offeringList[_missionId][m].target].add(offeringList[_missionId][m].targetAmount);
501         emit Transfer(msg.sender,offeringList[_missionId][m].target,offeringList[_missionId][m].targetAmount);
502       }
503       totalSupplyed = totalSupplyed.add(missionList[_missionId].totalAmount);
504 
505       if (missionList[_missionId].name == "CREATION ISSUING"){
506         nodeSupplyed = nodeSupplyed.add(missionList[_missionId].totalAmount);
507       }else{
508         userSupplyed = userSupplyed.add(missionList[_missionId].totalAmount);
509       }
510       missionList[_missionId].done = true;
511       emit OfferingFinished(_missionId,missionList[_missionId].offeringAmount,offeringList[_missionId].length);
512 
513     }
514     function getMission1(uint256 _missionId) public view returns(address,
515                                                               address,
516                                                               uint256,
517                                                               uint256,
518                                                               uint256,
519                                                               uint256,
520                                                               bytes32){
521       return(missionList[_missionId].oldNode,
522               missionList[_missionId].newNode,
523               missionList[_missionId].startTime,
524               missionList[_missionId].endTime,
525               missionList[_missionId].totalAmount,
526               missionList[_missionId].offeringAmount,
527               missionList[_missionId].name);
528     }
529     function getMission2(uint256 _missionId) public view returns(uint16,
530                                                                 uint16,
531                                                                 uint16,
532                                                                 uint16,
533                                                                 bool,
534                                                                 bool,
535                                                                 bool){
536       return(
537             missionList[_missionId].agreeNodes,
538             missionList[_missionId].refuseNodes,
539             missionList[_missionId].agreeSuperNodes,
540             missionList[_missionId].refuseSuperNodes,
541             missionList[_missionId].superPassed,
542             missionList[_missionId].nodePassed,
543             missionList[_missionId].done);
544     }
545     function getOfferings(uint256 _missionId,uint256 _id) public view returns(address,uint256,uint256){
546       return(offeringList[_missionId][_id].target,offeringList[_missionId][_id].targetAmount,offeringList[_missionId].length);
547     }
548     function voted(address _node,uint256 _missionId) public view returns(bool){
549       return Voter[_node][_missionId];
550     }
551 }
552 contract KOLFund is Ownable{
553   using SafeMath for uint256;
554   string public name = "KOL Foundation";
555   string public symbol = "KOLFund";
556   KOLVote public token;
557 
558   uint256 public dealTime =  3 days;
559   uint256 public missionId = 0;
560 
561   uint16 public constant totalSuperNodes = 21;
562   uint16 public constant totalNodes = 500;
563   uint16 public constant halfSuperNodes = 11;
564   uint16 public constant mostNodes = 335;
565   uint16 public constant halfNodes = 251;
566   uint16 public constant minSuperNodes = 15;
567   uint16 public constant minNodes = 101;
568 
569   uint16 public constant most = 67;
570   uint16 public constant half = 51;
571   uint16 public constant less = 33;
572 
573   mapping(address => mapping(uint256 => bool)) private Voter;
574 
575   constructor(address _tokenAddress) public {
576     token = KOLVote(_tokenAddress);
577   }
578 
579   event MissionPassed(uint256 _missionId,bytes32 _name);
580   event OfferingFinished(uint256 _missionId,uint256 _totalAmount,uint256 _length);
581   event MissionLaunched(bytes32 _name,uint256 _missionId,address _whoLaunch);
582 
583   modifier onlySuperNode() {
584     require(token.querySuperNode(msg.sender));
585       _;
586   }
587   modifier onlyNode() {
588       require(token.queryNode(msg.sender));
589       _;
590   }
591   modifier onlyNodes() {
592       require(token.querySuperNode(msg.sender)||token.queryNode(msg.sender));
593       _;
594   }
595 
596   struct KolMission{
597     uint256 startTime;
598     uint256 endTime;
599     uint256 totalAmount;
600     uint256 offeringAmount;
601     bytes32 name;
602     uint16 agreeNodes;
603     uint16 refuseNodes;
604     uint16 agreeSuperNodes;
605     uint16 refuseSuperNodes;
606     bool superPassed;
607     bool nodePassed;
608     bool done;
609   }
610   mapping (uint256 => KolMission) private missionList;
611 
612   struct KolOffering{
613     address target;
614     uint256 targetAmount;
615   }
616   KolOffering[] private kolOfferings;
617   mapping(uint256 => KolOffering[]) private offeringList;
618 
619   function missionPassed(uint256 _missionId) private {
620     emit MissionPassed(_missionId,missionList[_missionId].name);
621   }
622   function createKolMission(bytes32 _name,uint256 _totalAmount) onlyNodes public {
623       bytes32 iName = _name;
624       missionList[missionId] = KolMission(uint256(now),
625                                           uint256(now + dealTime),
626                                           _totalAmount,
627                                           0,
628                                           iName,
629                                           0,
630                                           0,
631                                           0,
632                                           0,
633                                           false,
634                                           false,
635                                           false);
636 
637       missionId++;
638       emit MissionLaunched(iName,missionId-1,msg.sender);
639   }
640   function voteMission(uint16 _type,uint256 _missionId,bool _agree) onlyNodes public{
641     require(!Voter[msg.sender][_missionId]);
642     require(!missionList[_missionId].done);
643     uint16 minNodesNum = minNodes;
644     uint16 minSuperNodesNum = minSuperNodes;
645     uint16 passNodes = halfNodes;
646     uint16 passSuperNodes = halfSuperNodes;
647     uint16 rate = half;
648 
649     if (_type == 1){
650       require(token.querySuperNode(msg.sender));
651     }else if (_type ==2){
652       require(token.queryNode(msg.sender));
653     }
654 
655     if(now > missionList[_missionId].endTime){
656       if ( _type == 1 ){
657         if (
658           (missionList[_missionId].agreeSuperNodes + missionList[_missionId].refuseSuperNodes)>=minSuperNodesNum
659           &&
660           missionList[_missionId].agreeSuperNodes >= (missionList[_missionId].agreeSuperNodes + missionList[_missionId].refuseSuperNodes) * rate/100
661           ){
662             missionList[_missionId].superPassed = true;
663             missionPassed(_missionId);
664         }
665       }else if (_type ==2 ){
666         //节点投票
667         if (
668           (missionList[_missionId].agreeNodes + missionList[_missionId].refuseNodes)>=minNodesNum
669           &&
670           missionList[_missionId].agreeNodes >= (missionList[_missionId].refuseNodes + missionList[_missionId].refuseNodes) * rate/100
671           ){
672             missionList[_missionId].nodePassed = true;
673         }
674       }
675     }else{
676       if(_agree == true){
677         if (_type == 1){
678           missionList[_missionId].agreeSuperNodes++;
679         }else if(_type == 2){
680           missionList[_missionId].agreeNodes++;
681         }
682       }
683       else{
684         if (_type == 1){
685           missionList[_missionId].refuseSuperNodes++;
686         }else if(_type == 2){
687           missionList[_missionId].refuseNodes++;
688         }
689       }
690       if (_type == 1){
691         if (missionList[_missionId].agreeSuperNodes >= passSuperNodes) {
692             missionList[_missionId].superPassed = true;
693             missionPassed(_missionId);
694         }else if (missionList[_missionId].refuseSuperNodes >= passSuperNodes) {
695             missionList[_missionId].done = true;
696         }
697       }else if (_type ==2){
698         if (missionList[_missionId].agreeNodes >= passNodes) {
699             missionList[_missionId].nodePassed = true;
700         }else if (missionList[_missionId].refuseNodes >= passNodes) {
701             missionList[_missionId].done = true;
702         }
703       }
704     }
705     Voter[msg.sender][_missionId] = true;
706   }
707   function addKolOffering(uint256 _missionId,address _target,uint256 _targetAmount) onlyNodes public{
708     require(missionList[_missionId].superPassed);
709     require(!missionList[_missionId].done);
710     require(token.queryNode(_target)||token.querySuperNode(_target));
711     require(missionList[_missionId].offeringAmount.add(_targetAmount) <= missionList[_missionId].totalAmount);
712     offeringList[_missionId].push(KolOffering(_target,_targetAmount));
713     missionList[_missionId].offeringAmount = missionList[_missionId].offeringAmount.add(_targetAmount);
714 
715   }
716   function excuteVote(uint256 _missionId) onlyOwner public {
717     require(!missionList[_missionId].done);
718     require(uint256(now) < (missionList[_missionId].endTime + uint256(dealTime)));
719     require(missionList[_missionId].superPassed);
720     require(missionList[_missionId].nodePassed);
721     require(missionList[_missionId].totalAmount == missionList[_missionId].offeringAmount);
722 
723 
724     for (uint m = 0; m < offeringList[_missionId].length; m++){
725       token.transfer(offeringList[_missionId][m].target, offeringList[_missionId][m].targetAmount);
726     }
727     missionList[_missionId].done = true;
728     emit OfferingFinished(_missionId,missionList[_missionId].offeringAmount,offeringList[_missionId].length);
729 
730   }
731   function getMission1(uint256 _missionId) public view returns(uint256,
732                                                             uint256,
733                                                             uint256,
734                                                             uint256,
735                                                             bytes32){
736     return(missionList[_missionId].startTime,
737             missionList[_missionId].endTime,
738             missionList[_missionId].totalAmount,
739             missionList[_missionId].offeringAmount,
740             missionList[_missionId].name);
741   }
742   function getMission2(uint256 _missionId) public view returns(uint16,
743                                                               uint16,
744                                                               uint16,
745                                                               uint16,
746                                                               bool,
747                                                               bool,
748                                                               bool){
749     return(
750           missionList[_missionId].agreeNodes,
751           missionList[_missionId].refuseNodes,
752           missionList[_missionId].agreeSuperNodes,
753           missionList[_missionId].refuseSuperNodes,
754           missionList[_missionId].superPassed,
755           missionList[_missionId].nodePassed,
756           missionList[_missionId].done);
757   }
758   function getOfferings(uint256 _missionId,uint256 _id) public view returns(address,uint256,uint256){
759     return(offeringList[_missionId][_id].target,offeringList[_missionId][_id].targetAmount,offeringList[_missionId].length);
760   }
761   function voted(address _node,uint256 _missionId) public view returns(bool){
762     return Voter[_node][_missionId];
763   }
764 
765 }