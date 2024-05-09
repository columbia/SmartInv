1 pragma solidity ^0.4.23;
2 /*
3  *          
4  *              KOL Community Foundation
5  *             Dev:Jack Koe
6  *             Special for: KOL
7  *   
8  *             20200406
9  *  
10  */
11 
12 
13 
14 
15  library SafeMath {
16    function mul(uint a, uint b) internal pure  returns (uint) {
17      uint c = a * b;
18      require(a == 0 || c / a == b);
19      return c;
20    }
21    function div(uint a, uint b) internal pure returns (uint) {
22      require(b > 0);
23      uint c = a / b;
24      require(a == b * c + a % b);
25      return c;
26    }
27    function sub(uint a, uint b) internal pure returns (uint) {
28      require(b <= a);
29      return a - b;
30    }
31    function add(uint a, uint b) internal pure returns (uint) {
32      uint c = a + b;
33      require(c >= a);
34      return c;
35    }
36    function max64(uint64 a, uint64 b) internal  pure returns (uint64) {
37      return a >= b ? a : b;
38    }
39    function min64(uint64 a, uint64 b) internal  pure returns (uint64) {
40      return a < b ? a : b;
41    }
42    function max256(uint256 a, uint256 b) internal  pure returns (uint256) {
43      return a >= b ? a : b;
44    }
45    function min256(uint256 a, uint256 b) internal  pure returns (uint256) {
46      return a < b ? a : b;
47    }
48  }
49 
50  /**
51   * @title KOL Node Lock & Release Contract
52   * @dev visit: https://github.com/jackoelv/KOL/
53  */
54 
55  contract ERC20Basic {
56    uint public totalSupply;
57    function balanceOf(address who) public constant returns (uint);
58    function transfer(address to, uint value) public;
59    event Transfer(address indexed from, address indexed to, uint value);
60  }
61 
62  contract ERC20 is ERC20Basic {
63    function allowance(address owner, address spender) public constant returns (uint);
64    function transferFrom(address from, address to, uint value) public;
65    function approve(address spender, uint value) public;
66    event Approval(address indexed owner, address indexed spender, uint value);
67  }
68 
69  /**
70   * @title KOL Node Lock & Release Contract
71   * @dev visit: https://github.com/jackoelv/KOL/
72  */
73 
74  contract BasicToken is ERC20Basic {
75 
76    using SafeMath for uint;
77 
78    mapping(address => uint) balances;
79 
80    function transfer(address _to, uint _value) public{
81      balances[msg.sender] = balances[msg.sender].sub(_value);
82      balances[_to] = balances[_to].add(_value);
83      emit Transfer(msg.sender, _to, _value);
84    }
85 
86    function balanceOf(address _owner) public constant returns (uint balance) {
87      return balances[_owner];
88    }
89  }
90 
91  /**
92   * @title KOL Node Lock & Release Contract
93   * @dev visit: https://github.com/jackoelv/KOL/
94  */
95 
96  contract StandardToken is BasicToken, ERC20 {
97    mapping (address => mapping (address => uint)) allowed;
98    uint256 public userSupplyed;
99 
100    function transferFrom(address _from, address _to, uint _value) public {
101      balances[_to] = balances[_to].add(_value);
102      balances[_from] = balances[_from].sub(_value);
103      allowed[_from][msg.sender] = allowed[_from][msg.sender].sub(_value);
104      emit Transfer(_from, _to, _value);
105    }
106 
107    function approve(address _spender, uint _value) public{
108      require((_value == 0) || (allowed[msg.sender][_spender] == 0)) ;
109      allowed[msg.sender][_spender] = _value;
110      emit Approval(msg.sender, _spender, _value);
111    }
112 
113    function allowance(address _owner, address _spender) public constant returns (uint remaining) {
114      return allowed[_owner][_spender];
115    }
116  }
117  contract KOL is StandardToken {
118    function queryNode(address _addr) public view returns(bool);
119    function querySuperNode(address _addr) public view returns(bool);
120  }
121 
122  /**
123   * @title KOL Node Lock & Release Contract
124   * @dev visit: https://github.com/jackoelv/KOL/
125  */
126 
127  contract Ownable {
128      address public owner;
129 
130      constructor() public{
131          owner = msg.sender;
132      }
133 
134      modifier onlyOwner {
135          require(msg.sender == owner);
136          _;
137      }
138      function transferOwnership(address newOwner) onlyOwner public{
139          if (newOwner != address(0)) {
140              owner = newOwner;
141          }
142      }
143  }
144  /**
145   * @title KOL Node Lock & Release Contract
146   * @dev visit: https://github.com/jackoelv/KOL/
147  */
148 contract KOLLockNode is Ownable{
149   using SafeMath for uint256;
150   string public name = "KOL Node Lock";
151   KOL public token;
152 
153   uint256 public dealTime =  3 days;
154   uint256 public missionId = 0;
155   uint256 public nodeRate = 0;
156   uint256 public releasedAll = 0;
157   uint256 public balanceAll = 0;
158   /* 正式环境 */
159 
160   uint16 public constant totalSuperNodes = 21;
161   uint16 public constant totalNodes = 500;
162   uint16 public constant halfSuperNodes = 11;
163   uint16 public constant mostNodes = 335;
164   uint16 public constant halfNodes = 251;
165   uint16 public constant minSuperNodes = 15;
166   uint16 public constant minNodes = 101;
167 
168 
169   uint16 public constant most = 67;
170   uint16 public constant half = 51;
171   uint16 public constant less = 33;
172 
173   mapping(address => mapping(uint256 => bool)) private Voter;
174 
175   constructor(address _tokenAddress) public {
176     token = KOL(_tokenAddress);
177   }
178 
179   event MissionPassed(uint256 _missionId,bytes32 _name);
180   event OfferingFinished(uint256 _missionId,uint256 _totalAmount,uint256 _length);
181   event MissionLaunched(bytes32 _name,uint256 _missionId,address _whoLaunch);
182   event AllTokenBack(address _fund,uint256 _amount);
183   event Recycled(address _node,uint256 _amount);
184   event RateChanged(uint256 _rate);
185 
186 
187   modifier onlySuperNode() {
188     require(token.querySuperNode(msg.sender));
189       _;
190   }
191   modifier onlyNode() {
192       require(token.queryNode(msg.sender));
193       _;
194   }
195   modifier onlyNodes() {
196       require(token.querySuperNode(msg.sender)||token.queryNode(msg.sender));
197       _;
198   }
199 
200   struct KolMission{
201     uint256 startTime;
202     uint256 endTime;
203     uint256 totalAmount;
204     uint256 offeringAmount;
205     uint256 rate;
206     bytes32 name;
207     address recycleNodeAddr;
208     uint16 agreeNodes;
209     uint16 refuseNodes;
210     uint16 agreeSuperNodes;
211     uint16 refuseSuperNodes;
212     bool superPassed;
213     bool nodePassed;
214     bool done;
215   }
216   mapping (uint256 => KolMission) private missionList;
217 
218   struct KolOffering{
219     address target;
220     uint256 targetAmount;
221   }
222 
223   mapping (address => uint256) private nodeBalance;
224   mapping (address => uint256) private nodeReleasedBalance;
225 
226   KolOffering[] private kolOfferings;
227   mapping(uint256 => KolOffering[]) private offeringList;
228 
229   function missionPassed(uint256 _missionId) private {
230     emit MissionPassed(_missionId,missionList[_missionId].name);
231   }
232   function createKolMission(bytes32 _name,uint256 _totalAmount,address _recycleNodeAddr,uint256 _rate) onlyNodes public {
233       bytes32 iName = _name;
234       uint256 balance = token.balanceOf(this);
235       uint256 allLeftBalance = balanceAll.sub(releasedAll);
236       require(balance >= allLeftBalance.add(_totalAmount));
237       missionList[missionId] = KolMission(uint256(now),
238                                           uint256(now + dealTime),
239                                           _totalAmount,
240                                           0,
241                                           _rate,
242                                           iName,
243                                           _recycleNodeAddr,
244                                           0,
245                                           0,
246                                           0,
247                                           0,
248                                           false,
249                                           false,
250                                           false);
251 
252       missionId++;
253       emit MissionLaunched(iName,missionId-1,msg.sender);
254   }
255   function voteMission(uint16 _type,uint256 _missionId,bool _agree) onlyNodes public{
256     require(!Voter[msg.sender][_missionId]);
257     require(!missionList[_missionId].done);
258     uint16 minNodesNum = minNodes;
259     uint16 minSuperNodesNum = minSuperNodes;
260     uint16 passNodes = halfNodes;
261     uint16 passSuperNodes = halfSuperNodes;
262     uint16 rate = half;
263 
264     if (_type == 1){
265       require(token.querySuperNode(msg.sender));
266     }else if (_type ==2){
267       require(token.queryNode(msg.sender));
268     }
269 
270     if(now > missionList[_missionId].endTime){
271       if ( _type == 1 ){
272         if (
273           (missionList[_missionId].agreeSuperNodes + missionList[_missionId].refuseSuperNodes)>=minSuperNodesNum
274           &&
275           missionList[_missionId].agreeSuperNodes >= (missionList[_missionId].agreeSuperNodes + missionList[_missionId].refuseSuperNodes) * rate/100
276           ){
277             missionList[_missionId].superPassed = true;
278             missionPassed(_missionId);
279         }
280       }else if (_type ==2 ){
281         //节点投票
282         if (
283           (missionList[_missionId].agreeNodes + missionList[_missionId].refuseNodes)>=minNodesNum
284           &&
285           missionList[_missionId].agreeNodes >= (missionList[_missionId].refuseNodes + missionList[_missionId].refuseNodes) * rate/100
286           ){
287             missionList[_missionId].nodePassed = true;
288         }
289       }
290     }else{
291       if(_agree == true){
292         if (_type == 1){
293           missionList[_missionId].agreeSuperNodes++;
294         }else if(_type == 2){
295           missionList[_missionId].agreeNodes++;
296         }
297       }
298       else{
299         if (_type == 1){
300           missionList[_missionId].refuseSuperNodes++;
301         }else if(_type == 2){
302           missionList[_missionId].refuseNodes++;
303         }
304       }
305       if (_type == 1){
306         if (missionList[_missionId].agreeSuperNodes >= passSuperNodes) {
307             missionList[_missionId].superPassed = true;
308             missionPassed(_missionId);
309         }else if (missionList[_missionId].refuseSuperNodes >= passSuperNodes) {
310             missionList[_missionId].done = true;
311         }
312       }else if (_type ==2){
313         if (missionList[_missionId].agreeNodes >= passNodes) {
314             missionList[_missionId].nodePassed = true;
315         }else if (missionList[_missionId].refuseNodes >= passNodes) {
316             missionList[_missionId].done = true;
317         }
318       }
319     }
320     Voter[msg.sender][_missionId] = true;
321   }
322 
323   function excuteVote(uint256 _missionId) onlyOwner public {
324     require(!missionList[_missionId].done);
325     require(uint256(now) < (missionList[_missionId].endTime + uint256(dealTime)));
326     require(missionList[_missionId].superPassed);
327     require(missionList[_missionId].nodePassed);
328     if (missionList[_missionId].name == "TRANSFER ALL KOL TO FUND"){
329       transferAllKolToFund();
330       missionList[_missionId].done = true;
331     }else if (missionList[_missionId].name == "RECYCLE KOL FROM OLDNODE"){
332       recycleKOL(missionList[_missionId].recycleNodeAddr);
333       missionList[_missionId].done = true;
334     }else if(missionList[_missionId].name == "CHANGE RELEASE RATE"){
335       nodeRate = missionList[_missionId].rate;
336       missionList[_missionId].done = true;
337       emit RateChanged(nodeRate);
338     }else{
339       require(token.balanceOf(this).add(releasedAll) >= balanceAll.add(missionList[_missionId].totalAmount));
340       require(missionList[_missionId].totalAmount == missionList[_missionId].offeringAmount);
341       for (uint m = 0; m < offeringList[_missionId].length; m++){
342         //这里要做一个记账。
343         /* token.transfer(offeringList[_missionId][m].target, offeringList[_missionId][m].targetAmount); */
344         nodeBalance[offeringList[_missionId][m].target] = nodeBalance[offeringList[_missionId][m].target].add(offeringList[_missionId][m].targetAmount);
345       }
346       balanceAll = balanceAll.add(missionList[_missionId].offeringAmount);
347       nodeRate = missionList[_missionId].rate;
348       missionList[_missionId].done = true;
349       emit RateChanged(nodeRate);
350       emit OfferingFinished(_missionId,missionList[_missionId].offeringAmount,offeringList[_missionId].length);
351     }
352 
353   }
354   function getMission1(uint256 _missionId) public view returns(uint256,
355                                                             uint256,
356                                                             uint256,
357                                                             uint256,
358                                                             uint256,
359                                                             bytes32,
360                                                             address){
361     return(missionList[_missionId].startTime,
362             missionList[_missionId].endTime,
363             missionList[_missionId].totalAmount,
364             missionList[_missionId].offeringAmount,
365             missionList[_missionId].rate,
366             missionList[_missionId].name,
367             missionList[_missionId].recycleNodeAddr);
368   }
369   function getMission2(uint256 _missionId) public view returns(uint16,
370                                                               uint16,
371                                                               uint16,
372                                                               uint16,
373                                                               bool,
374                                                               bool,
375                                                               bool){
376     return(
377           missionList[_missionId].agreeNodes,
378           missionList[_missionId].refuseNodes,
379           missionList[_missionId].agreeSuperNodes,
380           missionList[_missionId].refuseSuperNodes,
381           missionList[_missionId].superPassed,
382           missionList[_missionId].nodePassed,
383           missionList[_missionId].done);
384   }
385   function getOfferings(uint256 _missionId,uint256 _id) public view returns(address,uint256,uint256){
386     return(offeringList[_missionId][_id].target,offeringList[_missionId][_id].targetAmount,offeringList[_missionId].length);
387   }
388 
389   function addKolOffering(uint256 _missionId,address[] _target ,uint256[] _targetAmount) onlyNodes public{
390     require(missionList[_missionId].superPassed);
391     require(!missionList[_missionId].done);
392     require(_target.length == _targetAmount.length);
393     bool isNode = false;
394     for (uint j = 0; j< _targetAmount.length; j++){
395 
396       isNode = token.queryNode(_target[j])||token.querySuperNode(_target[j]);
397       require(isNode);
398       missionList[_missionId].offeringAmount = missionList[_missionId].offeringAmount.add(_targetAmount[j]);
399       offeringList[_missionId].push(KolOffering(_target[j],_targetAmount[j]));
400 
401     }
402     require(missionList[_missionId].totalAmount >= missionList[_missionId].offeringAmount);
403 
404   }
405   function voted(address _node,uint256 _missionId) public view returns(bool){
406     return Voter[_node][_missionId];
407   }
408   function getKOL() onlyNodes public {
409 
410     require(nodeBalance[msg.sender] > 0);
411     uint256 amount = nodeBalance[msg.sender].mul(nodeRate).div(100);
412     uint256 releaseKol = amount.sub(nodeReleasedBalance[msg.sender]);
413     require(releaseKol > 0);
414     require(nodeReleasedBalance[msg.sender].add(releaseKol)<=nodeBalance[msg.sender]);
415     require(token.balanceOf(this) >= releaseKol);
416 
417     token.transfer(msg.sender, releaseKol);
418     nodeReleasedBalance[msg.sender] = nodeReleasedBalance[msg.sender].add(releaseKol);
419     releasedAll = releasedAll.add(releaseKol);
420   }
421   function queryBalance(address _node) onlyNodes public view returns(uint256,uint256){
422     return(nodeBalance[_node],nodeReleasedBalance[_node]);
423   }
424   function transferAllKolToFund() private {
425     address fund = 0x27750e6D41Aef99501eBC256538c6A13a254Ea15;
426     uint256 balance = token.balanceOf(this);
427     token.transfer(fund, balance);
428     emit AllTokenBack(fund,balance);
429   }
430   function recycleKOL(address _node) private {
431     require((!token.queryNode(_node)) && (!token.querySuperNode(msg.sender)));
432     require(nodeBalance[_node] > 0);
433     uint256 recycles = nodeBalance[_node].sub(nodeReleasedBalance[_node]);
434     balanceAll = balanceAll.sub(recycles);
435     nodeBalance[_node] = nodeReleasedBalance[_node];
436     emit Recycled(_node,recycles);
437   }
438   function leftKOL() public view returns(uint256,bool) {
439     uint256 balance = token.balanceOf(this);
440     uint256 allLeftBalance = balanceAll.sub(releasedAll);
441     if (balance >= allLeftBalance)
442       return(balance.sub(allLeftBalance),true);
443     else
444       return(allLeftBalance.sub(balance),false);
445   }
446 
447 }