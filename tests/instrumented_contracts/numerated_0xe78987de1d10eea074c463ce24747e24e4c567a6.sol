1 pragma solidity ^0.4.18;
2 
3 
4 
5 
6 /**
7  * @title SafeMath
8  * @dev Math operations with safety checks that throw on error
9  */
10 library SafeMath {
11   function mul(uint256 a, uint256 b) internal pure returns (uint256) {
12     if (a == 0) {
13       return 0;
14     }
15     uint256 c = a * b;
16     assert(c / a == b);
17     return c;
18   }
19 
20   function div(uint256 a, uint256 b) internal pure returns (uint256) {
21     
22     uint256 c = a / b;
23     
24     return c;
25   }
26 
27   function sub(uint256 a, uint256 b) internal pure returns (uint256) {
28     assert(b <= a);
29     return a - b;
30   }
31 
32   function add(uint256 a, uint256 b) internal pure returns (uint256) {
33     uint256 c = a + b;
34     assert(c >= a);
35     return c;
36   }
37 }
38 
39 
40 
41 
42 
43 /**
44  * @title ERC20Basic
45  * @dev Simpler version of ERC20 interface
46  * @dev see https://github.com/ethereum/EIPs/issues/179
47  */
48 contract ERC20Basic {
49   uint256 public totalSupply;
50   function balanceOf(address who) public view returns (uint256);
51   function transfer(address to, uint256 value) public returns (bool);
52   event Transfer(address indexed from, address indexed to, uint256 value);
53 }
54 
55 
56 
57 
58 
59 
60 
61 
62 /**
63  * @title ERC20 interface
64  * @dev see https://github.com/ethereum/EIPs/issues/20
65  */
66 contract ERC20 is ERC20Basic {
67   function allowance(address owner, address spender) public view returns (uint256);
68   function transferFrom(address from, address to, uint256 value) public returns (bool);
69   function approve(address spender, uint256 value) public returns (bool);
70   event Approval(address indexed owner, address indexed spender, uint256 value);
71 }
72 
73 
74 
75 
76 
77 
78 
79 
80 
81 /**
82  * @title Basic token
83  * @dev Basic version of StandardToken, with no allowances.
84  */
85 contract BasicToken is ERC20Basic {
86   using SafeMath for uint256;
87 
88   mapping(address => uint256) balances;
89 
90   /**
91   * @dev transfer token for a specified address
92   * @param _to The address to transfer to.
93   * @param _value The amount to be transferred.
94   */
95   function transfer(address _to, uint256 _value) public returns (bool) {
96     require(_to != address(0));
97     require(_value <= balances[msg.sender]);
98 
99     
100     balances[msg.sender] = balances[msg.sender].sub(_value);
101     balances[_to] = balances[_to].add(_value);
102     Transfer(msg.sender, _to, _value);
103     return true;
104   }
105 
106   /**
107   * @dev Gets the balance of the specified address.
108   * @param _owner The address to query the the balance of.
109   * @return An uint256 representing the amount owned by the passed address.
110   */
111   function balanceOf(address _owner) public view returns (uint256 balance) {
112     return balances[_owner];
113   }
114 
115 }
116 
117 
118 
119 
120 
121 
122 
123 
124 
125 /**
126  * @title Standard ERC20 token
127  *
128  * @dev Implementation of the basic standard token.
129  * @dev https://github.com/ethereum/EIPs/issues/20
130  * @dev Based on code by FirstBlood: https://github.com/Firstbloodio/token/blob/master/smart_contract/FirstBloodToken.sol
131  */
132 contract StandardToken is ERC20, BasicToken {
133 
134   mapping (address => mapping (address => uint256)) internal allowed;
135 
136 
137   /**
138    * @dev Transfer tokens from one address to another
139    * @param _from address The address which you want to send tokens from
140    * @param _to address The address which you want to transfer to
141    * @param _value uint256 the amount of tokens to be transferred
142    */
143   function transferFrom(address _from, address _to, uint256 _value) public returns (bool) {
144     require(_to != address(0));
145     require(_value <= balances[_from]);
146     require(_value <= allowed[_from][msg.sender]);
147 
148     balances[_from] = balances[_from].sub(_value);
149     balances[_to] = balances[_to].add(_value);
150     allowed[_from][msg.sender] = allowed[_from][msg.sender].sub(_value);
151     Transfer(_from, _to, _value);
152     return true;
153   }
154 
155   /**
156    * @dev Approve the passed address to spend the specified amount of tokens on behalf of msg.sender.
157    *
158    * Beware that changing an allowance with this method brings the risk that someone may use both the old
159    * and the new allowance by unfortunate transaction ordering. One possible solution to mitigate this
160    * race condition is to first reduce the spender's allowance to 0 and set the desired value afterwards:
161    * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
162    * @param _spender The address which will spend the funds.
163    * @param _value The amount of tokens to be spent.
164    */
165   function approve(address _spender, uint256 _value) public returns (bool) {
166     allowed[msg.sender][_spender] = _value;
167     Approval(msg.sender, _spender, _value);
168     return true;
169   }
170 
171   /**
172    * @dev Function to check the amount of tokens that an owner allowed to a spender.
173    * @param _owner address The address which owns the funds.
174    * @param _spender address The address which will spend the funds.
175    * @return A uint256 specifying the amount of tokens still available for the spender.
176    */
177   function allowance(address _owner, address _spender) public view returns (uint256) {
178     return allowed[_owner][_spender];
179   }
180 
181   /**
182    * approve should be called when allowed[_spender] == 0. To increment
183    * allowed value is better to use this function to avoid 2 calls (and wait until
184    * the first transaction is mined)
185    * From MonolithDAO Token.sol
186    */
187   function increaseApproval(address _spender, uint _addedValue) public returns (bool) {
188     allowed[msg.sender][_spender] = allowed[msg.sender][_spender].add(_addedValue);
189     Approval(msg.sender, _spender, allowed[msg.sender][_spender]);
190     return true;
191   }
192 
193   function decreaseApproval(address _spender, uint _subtractedValue) public returns (bool) {
194     uint oldValue = allowed[msg.sender][_spender];
195     if (_subtractedValue > oldValue) {
196       allowed[msg.sender][_spender] = 0;
197     } else {
198       allowed[msg.sender][_spender] = oldValue.sub(_subtractedValue);
199     }
200     Approval(msg.sender, _spender, allowed[msg.sender][_spender]);
201     return true;
202   }
203 
204 }
205 
206 
207 
208 
209 /**
210  * @title Math
211  * @dev Assorted math operations
212  */
213 
214 library Math {
215   function max64(uint64 a, uint64 b) internal pure returns (uint64) {
216     return a >= b ? a : b;
217   }
218 
219   function min64(uint64 a, uint64 b) internal pure returns (uint64) {
220     return a < b ? a : b;
221   }
222 
223   function max256(uint256 a, uint256 b) internal pure returns (uint256) {
224     return a >= b ? a : b;
225   }
226 
227   function min256(uint256 a, uint256 b) internal pure returns (uint256) {
228     return a < b ? a : b;
229   }
230 }
231 
232 
233 
234 
235 
236 
237 /**
238  * @title Burnable Token
239  * @dev Token that can be irreversibly burned (destroyed).
240  */
241 contract BurnableToken is StandardToken {
242 
243     event Burn(address indexed burner, uint256 value);
244 
245     /**
246      * @dev Burns a specific amount of tokens.
247      * @param _value The amount of token to be burned.
248      */
249     function burn(uint256 _value) public {
250         require(_value > 0);
251         require(_value <= balances[msg.sender]);
252         
253         
254 
255         address burner = msg.sender;
256         balances[burner] = balances[burner].sub(_value);
257         totalSupply = totalSupply.sub(_value);
258         Burn(burner, _value);
259     }
260 }
261 
262 
263 
264 
265 
266 /**
267  * @title Ownable
268  * @dev The Ownable contract has an owner address, and provides basic authorization control
269  * functions, this simplifies the implementation of "user permissions".
270  */
271 contract Ownable {
272   address public owner;
273 
274 
275   event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
276 
277 
278   /**
279    * @dev The Ownable constructor sets the original `owner` of the contract to the sender
280    * account.
281    */
282   function Ownable() public {
283     owner = msg.sender;
284   }
285 
286 
287   /**
288    * @dev Throws if called by any account other than the owner.
289    */
290   modifier onlyOwner() {
291     require(msg.sender == owner);
292     _;
293   }
294 
295 
296   /**
297    * @dev Allows the current owner to transfer control of the contract to a newOwner.
298    * @param newOwner The address to transfer ownership to.
299    */
300   function transferOwnership(address newOwner) public onlyOwner {
301     require(newOwner != address(0));
302     OwnershipTransferred(owner, newOwner);
303     owner = newOwner;
304   }
305 
306 }
307 
308 
309 
310 
311 
312 
313 
314 
315 
316 contract Jewel {
317     function incise(address owner, uint256 value) external returns (uint);
318 }
319 
320 contract DayQualitys {
321     function getAreaQualityByDay(uint32 time, uint32 area) external returns (uint32);
322 }
323 
324 contract Mineral is BurnableToken, Ownable {
325 
326     string public name = "Mineral";
327     string public symbol = "ORE";
328     uint8 public decimals = 18;
329 
330     uint256 public constant INITIAL_SUPPLY = 800 * 1000 * 1000 * (10 ** uint256(decimals));
331 
332     uint public constant MINER_4_HOURS = 0.0005 ether;
333     uint public constant MINER_8_HOURS = 0.001 ether;
334     uint public constant MINER_24_HOURS = 0.003 ether;
335 
336     mapping(address => uint[][72]) public deployRange;
337 
338     
339     
340     uint public timeScale = 1; 
341 
342     
343     
344     mapping(uint32 => uint32[3][72]) private areaHourDeployed;
345 
346     
347     struct AreaHourDeployed {
348         uint32[72] lastCollectHour;
349         
350         mapping(uint32 => uint32[3][72]) hour; 
351     }
352     
353     
354     mapping(address => AreaHourDeployed) private userAreaHourDeployed;
355 
356     
357     uint8 public constant CHECK_POINT_HOUR = 4;
358 
359     
360     
361     mapping(uint32 => uint32[72]) private areaCheckPoints;
362 
363     
364     mapping(uint32 => uint) private dayAverageOutput;
365 
366     
367     struct AreaCheckPoint {
368         
369         mapping(uint32 => uint32[72]) hour;
370     }
371 
372     
373     
374     mapping(address => AreaCheckPoint) private userAreaCheckPoints;
375 
376     uint256 amountEther;
377 
378     
379     mapping (address => uint) public remainEther;
380 
381     uint32 public constractDeployTime = uint32(now) / 1 hours * 1 hours;
382 
383     mapping(address => uint) activeArea; 
384     
385     bool enableWhiteList = true;
386     mapping(address => bool) whiteUserList;    
387     address serverAddress;
388 
389     address coldWallet;
390 
391     bool enableCheckArea = true;
392 
393     Jewel public jewelContract;
394     DayQualitys public dayQualitysContract;
395 
396     event Pause();
397     event Unpause();
398 
399     bool public paused = false;
400 
401     function Mineral() public {
402         totalSupply = INITIAL_SUPPLY;
403         balances[this] = 300 * 1000 * 1000 * (10 ** uint256(decimals));
404         balances[msg.sender] = INITIAL_SUPPLY - balances[this];
405         dayAverageOutput[0] = 241920 * 10 ** uint256(decimals);
406     }
407 
408     /*
409     function setTimeScale(uint scale) public onlyOwner {
410         timeScale = scale;
411     }
412 
413     
414     function setConstractDeployTime(uint32 time) public onlyOwner {
415         constractDeployTime = time;
416     }*/
417 
418     function setColdWallet(address _coldWallet) public onlyOwner {
419         coldWallet = _coldWallet;
420     }
421 
422     function disableWhiteUserList() public onlyOwner {
423         enableWhiteList = false;
424     }
425 
426     function disableCheckArea() public onlyOwner {
427         enableCheckArea = false;
428     }
429 
430     modifier checkWhiteList() {
431         if (enableWhiteList) {
432             require(whiteUserList[msg.sender]);
433         }
434         _;
435     }
436 
437     function setServerAddress(address addr) public onlyOwner {
438         serverAddress = addr;
439     }
440 
441     function authUser(string addr) public {
442         require(msg.sender == serverAddress || msg.sender == owner);
443         address s = bytesToAddress(bytes(addr));
444         whiteUserList[s] = true;
445     }
446 
447     function bytesToAddress (bytes b) internal view returns (address) {
448         uint result = 0;
449         for (uint i = 0; i < b.length; i++) {
450             uint c = uint(b[i]);
451             if (c >= 48 && c <= 57) {
452                 result = result * 16 + (c - 48);
453             }
454             if(c >= 65 && c <= 90) {
455                 result = result * 16 + (c - 55);
456             }
457             if(c >= 97 && c <= 122) {
458                 result = result * 16 + (c - 87);
459             }
460         }
461         return address(result);
462     }
463 
464     function setDayQualitys(address dayQualitys) public onlyOwner {
465         dayQualitysContract = DayQualitys(dayQualitys);
466     }
467 
468     function getMyDeployAt(uint32 area, uint32 hour) public view returns (uint32[3]) {
469         return userAreaHourDeployed[msg.sender].hour[hour][area];
470     }
471 
472     function getMyMinersAt(uint32 area, uint32 hour) public view returns (uint32) {
473         return _getUserMinersAt(msg.sender, area, hour);
474     }
475 
476     function _getUserMinersAt(address user, uint32 area, uint32 hour) internal view returns(uint32) {
477         //now start from start's nearest check point
478         uint32 nc = hour/CHECK_POINT_HOUR*CHECK_POINT_HOUR;
479         if (userAreaCheckPoints[user].hour[nc][area] == 0 && userAreaCheckPoints[user].hour[nc + CHECK_POINT_HOUR][area] == 0) {
480             return 0;
481         }
482         uint32 h = 0;
483         int64 userInc = 0;
484         uint32[3] storage ptUser;
485         AreaHourDeployed storage _userAreaHourDeployed = userAreaHourDeployed[user];
486         
487         for (h = nc; h <= hour; ++h) {
488             
489             
490             
491             ptUser = _userAreaHourDeployed.hour[h][area];
492             userInc += ptUser[0] + ptUser[1] + ptUser[2] - _userAreaHourDeployed.hour[h - 4][area][0] - 
493                 _userAreaHourDeployed.hour[h - 8][area][1] - _userAreaHourDeployed.hour[h - 24][area][2];
494         }
495         return userAreaCheckPoints[user].hour[nc][area] + uint32(userInc);
496     }
497 
498     function getDeployAt(uint32 area, uint32 hour) public view returns (uint32[3]) {
499         return areaHourDeployed[hour][area];
500     }
501 
502 
503     function getMinersAt(uint32 area, uint32 hour) public view returns (uint32) {
504         return _getMinersAt(area, hour);
505     }
506 
507     function _getMinersAt(uint32 area, uint32 hour) internal view returns (uint32) {
508         //now start from start's nearest check point
509         uint32 nc = hour/CHECK_POINT_HOUR*CHECK_POINT_HOUR;
510         uint32 h = 0;
511         int64 userInc = 0;
512         int64 totalInc = 0;
513         uint32[3] storage ptArea;
514         
515         for (h = nc; h <= hour; ++h) {
516             
517             
518             
519             ptArea = areaHourDeployed[h][area];
520             totalInc += ptArea[0] + ptArea[1] + ptArea[2] - areaHourDeployed[h - 4][area][0] - areaHourDeployed[h - 8][area][1] - areaHourDeployed[h - 24][area][2];
521         }
522 
523         return areaCheckPoints[nc][area] + uint32(totalInc);
524     }
525 
526     function updateArea(uint areaId) internal pure returns (uint) {
527         
528         uint row = areaId / 8;
529         uint colum = areaId % 8;
530 
531         uint result = uint(1) << areaId;
532         if (row-1 >= 0) {
533             result |= uint(1) << ((row-1)*8+colum);
534         }
535         if (row+1 < 9) {
536             result |= uint(1) << ((row+1)*8+colum);
537         }
538         if (colum-1 >= 0) {
539             result |= uint(1) << (row*8+colum-1);
540         }
541         if (colum+1 < 8) {
542             result |= uint(1) << (row*8+colum+1);
543         }
544         
545         return result;
546     }
547 
548     function checkArea(uint32[] area, address user) internal {
549         if (enableCheckArea) {
550             uint[] memory distinctArea = new uint[](area.length);
551             uint distinctAreaLength = 0;
552         
553             for (uint i = 0; i < area.length; i++) {
554                 bool find = false;
555                 for (uint j = 0; j < distinctAreaLength; j++) {
556                     if (distinctArea[j] == area[i]) {
557                         find = true;
558                         break;
559                     }
560                 }     
561                 if (!find) {
562                     distinctArea[distinctAreaLength] = area[i];
563                     distinctAreaLength += 1;
564                 }
565             }
566 
567             if (activeArea[user] == 0) {
568                 require(distinctAreaLength == 1);
569                 activeArea[user] = updateArea(distinctArea[0]);
570             } else {
571                 uint userActiveArea = activeArea[user];
572                 uint updateActiveArea = userActiveArea;
573                 for (i = 0; i < distinctAreaLength; i++) {
574                     require(userActiveArea & uint(1) << distinctArea[i] > 0);
575                     updateActiveArea = updateActiveArea | updateArea(distinctArea[i]);
576                 }
577 
578                 activeArea[user] = updateActiveArea;
579             }
580         }
581     }
582 
583     function deployMiners(address user, uint32[] area, uint32[] period, uint32[] count) public checkWhiteList whenNotPaused payable {
584         require(area.length > 0);
585         require(area.length == period.length);
586         require(area.length == count.length);
587         address _user = user;
588         if (_user == address(0)) {
589             _user = msg.sender;
590         }
591         
592         uint32 _hour = uint32((now - constractDeployTime) * timeScale / 1 hours);
593 
594         checkArea(area, user);
595         
596         uint payment = _deployMiners(_user, _hour, area, period, count);
597         _updateCheckPoints(_user, _hour, area, period, count);
598 
599         require(payment <= msg.value);
600         remainEther[msg.sender] += (msg.value - payment);
601         if (coldWallet != address(0)) {
602             coldWallet.transfer(payment);
603         } else {
604             amountEther += payment;
605         }
606         
607     }
608 
609     /*function deployMinersTest(uint32 _hour, address user, uint32[] area, uint32[] period, uint32[] count) public checkWhiteList payable {
610         require(area.length > 0);
611         require(area.length == period.length);
612         require(area.length == count.length);
613         address _user = user;
614         if (_user == address(0)) {
615             _user = msg.sender;
616         }
617         
618 
619         checkArea(area, user);
620         
621         uint payment = _deployMiners(_user, _hour, area, period, count);
622         _updateCheckPoints(_user, _hour, area, period, count);
623 
624         require(payment <= msg.value);
625         remainEther[msg.sender] += (msg.value - payment);
626         amountEther += payment;
627     }*/
628 
629     function _deployMiners(address _user, uint32 _hour, uint32[] memory area, uint32[] memory period, uint32[] memory count) internal returns(uint){
630         uint payment = 0;
631         uint32 minerCount = 0;
632         uint32[3][72] storage _areaDeployed = areaHourDeployed[_hour];
633         uint32[3][72] storage _userAreaDeployed = userAreaHourDeployed[_user].hour[_hour];
634         
635         
636         for (uint index = 0; index < area.length; ++index) {
637             require (period[index] == 4 || period[index] == 8 || period[index] == 24);
638             if (period[index] == 4) {
639                 _areaDeployed[area[index]][0] += count[index];
640                 _userAreaDeployed[area[index]][0] += count[index];
641                 payment += count[index] * MINER_4_HOURS;
642             } else if (period[index] == 8) {
643                 _areaDeployed[area[index]][1] += count[index];
644                 _userAreaDeployed[area[index]][1] += count[index];
645                 payment += count[index] * MINER_8_HOURS;
646             } else if (period[index] == 24) {
647                 _areaDeployed[area[index]][2] += count[index];
648                 _userAreaDeployed[area[index]][2] += count[index];
649                 payment += count[index] * MINER_24_HOURS;
650             }
651             minerCount += count[index];
652             DeployMiner(_user, area[index], _hour, _hour + period[index], count[index]);
653 
654             adjustDeployRange(area[index], _hour, _hour + period[index]);
655         }
656         return payment;
657     }   
658 
659     function adjustDeployRange(uint area, uint start, uint end) internal {
660         uint len = deployRange[msg.sender][area].length;
661         if (len == 0) {
662             deployRange[msg.sender][area].push(start | (end << 128));
663         } else {
664             uint s = uint128(deployRange[msg.sender][area][len - 1]);
665             uint e = uint128(deployRange[msg.sender][area][len - 1] >> 128);
666             
667             if (start >= s && start < e) {
668                 end = e > end ? e : end;
669                 deployRange[msg.sender][area][len - 1] = s | (end << 128);
670             } else {
671                 deployRange[msg.sender][area].push(start | (end << 128));
672             }
673         }
674     }
675 
676     function getDeployArrayLength(uint area) public view returns (uint) {
677         return deployRange[msg.sender][area].length;
678     }
679     
680     function getDeploy(uint area, uint index) public view returns (uint,uint) {
681         uint s = uint128(deployRange[msg.sender][area][index]);
682         uint e = uint128(deployRange[msg.sender][area][index] >> 128);
683         return (s, e);
684     }
685 
686     function _updateCheckPoints(address _user, uint32 _hour, uint32[] memory area, uint32[] memory period, uint32[] memory count) internal {
687         uint32 _area = 0;
688         uint32 _count = 0;
689         uint32 ce4 = _hour + 4;
690         uint32 ce8 = _hour + 8;
691         uint32 ce24 = _hour + 24;
692         uint32 cs = (_hour/CHECK_POINT_HOUR+1)*CHECK_POINT_HOUR;
693         AreaCheckPoint storage _userAreaCheckPoints = userAreaCheckPoints[_user];
694         uint32 cp = 0;
695         for (uint index = 0; index < area.length; ++index) {
696             _area = area[index];
697             _count = count[index];
698             if (period[index] == 4) {
699                 for (cp = cs; cp <= ce4; cp += CHECK_POINT_HOUR) {
700                     areaCheckPoints[cp][_area] += _count;
701                     _userAreaCheckPoints.hour[cp][_area] += _count;
702                 }
703             } else if (period[index] == 8) {
704                 for (cp = cs; cp <= ce8; cp += CHECK_POINT_HOUR) {
705                     areaCheckPoints[cp][_area] += _count;
706                     _userAreaCheckPoints.hour[cp][_area] += _count;
707                 }
708             } else if (period[index] == 24) {
709                 for (cp = cs; cp <= ce24; cp += CHECK_POINT_HOUR) {
710                     areaCheckPoints[cp][_area] += _count;
711                     _userAreaCheckPoints.hour[cp][_area] += _count;
712                 }
713             }
714         }
715     }
716 
717     
718 
719     event DeployMiner(address addr, uint32 area, uint32 start, uint32 end, uint32 count);
720 
721     event Collect(address addr, uint32 area, uint32 start, uint32 end, uint areaCount);
722 
723     function getMyLastCollectHour(uint32 area) public view returns (uint32){
724         return userAreaHourDeployed[msg.sender].lastCollectHour[area];
725     }
726 
727     
728     
729     function collect(address user, uint32[] area) public  checkWhiteList whenNotPaused {
730         require(address(dayQualitysContract) != address(0));
731         uint32 current = uint32((now - constractDeployTime) * timeScale / 1 hours);
732         require(area.length > 0);
733         address _user = user;
734         if (_user == address(0)) {
735             _user = msg.sender;
736         }
737         uint total = 0;
738         
739         for (uint a = 0; a < area.length; ++a) {
740             uint len = deployRange[msg.sender][area[a]].length;
741             bool finish = true;
742             for (uint i = 0; i < len; i += 1) {
743                 uint s = uint128(deployRange[msg.sender][area[a]][i]);
744                 uint e = uint128(deployRange[msg.sender][area[a]][i] >> 128);
745                 if (current < e && current >= s ) {
746                     total += _collect(_user, uint32(s), current, area[a]);
747                     
748                     deployRange[msg.sender][area[a]][i] = current | (e << 128);
749                     finish = false;
750                 } else if (current >= e) {
751                     total += _collect(_user, uint32(s), uint32(e), area[a]);
752                 }
753             }
754             
755             if (finish) {
756                 deployRange[msg.sender][area[a]].length = 0;
757             } else {
758                 deployRange[msg.sender][area[a]][0] = deployRange[msg.sender][area[a]][len - 1];
759                 deployRange[msg.sender][area[a]].length = 1;
760             }
761         }    
762 
763         ERC20(this).transfer(_user, total);
764     }
765 
766     function _collect(address _user, uint32 start, uint32 end, uint32 area) internal returns (uint) {
767         uint result = 0;
768         uint32 writeCount = 1;
769         uint income = 0;
770         uint32[] memory totalMiners = new uint32[](CHECK_POINT_HOUR);
771         uint32[] memory userMiners = new uint32[](CHECK_POINT_HOUR);
772         uint32 ps = start/CHECK_POINT_HOUR*CHECK_POINT_HOUR+CHECK_POINT_HOUR;
773         if (ps >= end) {
774             
775             (income, writeCount) = _collectMinersByCheckPoints(_user, area, start, end, totalMiners, userMiners, writeCount);
776             result += income;
777         } else {
778             
779             (income, writeCount) = _collectMinersByCheckPoints(_user, area, start, ps, totalMiners, userMiners, writeCount);
780             result += income;
781 
782             while (ps < end) {
783                 (income, writeCount) = _collectMinersByCheckPoints(_user, area, ps, uint32(Math.min64(end, ps + CHECK_POINT_HOUR)), totalMiners, userMiners, writeCount);
784                 result += income;
785 
786                 ps += CHECK_POINT_HOUR;
787             }
788         }
789         Collect(_user, area, start, end, result);
790         return result;
791     }
792 
793     function _collectMinersByCheckPoints(address _user, uint32 area, uint32 start, uint32 end, uint32[] memory totalMiners, uint32[] memory userMiners, uint32 _writeCount) internal returns (uint income, uint32 writeCount) {
794         //now start from start's nearest check point
795         writeCount = _writeCount;
796         income = 0;
797         
798         
799         if (userAreaCheckPoints[_user].hour[start/CHECK_POINT_HOUR*CHECK_POINT_HOUR][area] == 0 && userAreaCheckPoints[_user].hour[start/CHECK_POINT_HOUR*CHECK_POINT_HOUR + CHECK_POINT_HOUR][area] == 0) {
800             return;
801         }
802         _getMinersByCheckPoints(_user, area, start, end, totalMiners, userMiners);
803         uint ao = dayAverageOutput[start / 24];
804         if (ao == 0) {
805             uint32 d = start / 24;
806             for (; d >= 0; --d) {
807                 if (dayAverageOutput[d] != 0) {
808                     break;
809                 }
810             } 
811             ao = dayAverageOutput[d];
812             for (d = d+1; d <= start / 24; ++d) {
813                 ao = ao*9996/10000;
814                 if ((start / 24 - d) < writeCount) {
815                     dayAverageOutput[d] = ao;
816                 }
817             }
818             if (writeCount > (start / 24 - d - 1)) {
819                 writeCount = writeCount - (start / 24 - d - 1);
820             } else {
821                 writeCount = 0;
822             }
823         }
824 
825         uint week = dayQualitysContract.getAreaQualityByDay(uint32(start * 1 hours + constractDeployTime), area);
826         require(week > 0);
827 
828         ao = week * ao / 10 / 24 / 72;
829         
830         income = _getTotalIncomeAt(end - start, userMiners, totalMiners, ao, week);
831 
832         if (week == 10) { 
833             income = income * 8 / 10;
834         } else if (week == 5) { 
835             income = income * 6 / 10;
836         } 
837     }
838 
839     function _getTotalIncomeAt(uint32 hourLength, uint32[] memory userMiners, uint32[] memory totalMiners, uint areaOutput, uint week) internal view returns(uint) {
840         uint income = 0;
841         for (uint i = 0; i < hourLength; ++i) {
842             if (userMiners[i] != 0 && totalMiners[i] != 0) {
843                 income += (Math.min256(10 ** uint256(decimals), areaOutput / totalMiners[i]) * userMiners[i]);
844             }
845         }
846         return income;
847     } 
848 
849     function _getMinersByCheckPoints(address _user, uint32 area, uint32 start, uint32 end, uint32[] memory totalMiners, uint32[] memory userMiners) internal view {
850         require((end - start) <= CHECK_POINT_HOUR);
851         //now start from start's nearest check point
852         uint32 h = 0;
853         int64 userInc = 0;
854         int64 totalInc = 0;
855         uint32[3] storage ptUser;
856         uint32[3] storage ptArea;
857         AreaHourDeployed storage _userAreaHourDeployed = userAreaHourDeployed[_user];
858         
859         for (h = start/CHECK_POINT_HOUR*CHECK_POINT_HOUR; h <= start; ++h) {
860             
861             
862             
863             ptUser = _userAreaHourDeployed.hour[h][area];
864             ptArea = areaHourDeployed[h][area];
865             totalInc += ptArea[0] + ptArea[1] + ptArea[2] - areaHourDeployed[h - 4][area][0] - areaHourDeployed[h - 8][area][1] - areaHourDeployed[h - 24][area][2];
866             userInc += ptUser[0] + ptUser[1] + ptUser[2] - _userAreaHourDeployed.hour[h - 4][area][0] - _userAreaHourDeployed.hour[h - 8][area][1] - _userAreaHourDeployed.hour[h - 24][area][2];
867         }
868 
869         totalMiners[0] = areaCheckPoints[start/CHECK_POINT_HOUR*CHECK_POINT_HOUR][area] + uint32(totalInc);
870         userMiners[0] = userAreaCheckPoints[_user].hour[start/CHECK_POINT_HOUR*CHECK_POINT_HOUR][area] + uint32(userInc);
871 
872         uint32 i = 1;
873         for (h = start + 1; h < end; ++h) {
874             
875             
876             
877             ptUser = _userAreaHourDeployed.hour[h][area];
878             ptArea = areaHourDeployed[h][area];
879             totalMiners[i] = totalMiners[i-1] + ptArea[0] + ptArea[1] + ptArea[2] - areaHourDeployed[h - 4][area][0] - areaHourDeployed[h - 8][area][1] - areaHourDeployed[h - 24][area][2];
880             userMiners[i] = userMiners[i-1] + ptUser[0] + ptUser[1] + ptUser[2] - _userAreaHourDeployed.hour[h - 4][area][0] - _userAreaHourDeployed.hour[h - 8][area][1] - _userAreaHourDeployed.hour[h - 24][area][2];
881             ++i;
882         }
883     }
884 
885     
886     function withdraw() public {
887         uint remain = remainEther[msg.sender]; 
888         require(remain > 0);
889         remainEther[msg.sender] = 0;
890 
891         msg.sender.transfer(remain);
892     }
893 
894     
895     function withdrawMinerFee() public onlyOwner {
896         require(amountEther > 0);
897         owner.transfer(amountEther);
898         amountEther = 0;
899     }
900 
901     modifier whenNotPaused() {
902         require(!paused);
903         _;
904     }
905 
906     modifier whenPaused() {
907         require(paused);
908         _;
909     }
910 
911     function pause() onlyOwner whenNotPaused public {
912         paused = true;
913         Pause();
914     }
915 
916     function unpause() onlyOwner whenPaused public {
917         paused = false;
918         Unpause();
919     }
920 
921     function transfer(address _to, uint256 _value) public whenNotPaused returns (bool) {
922         return super.transfer(_to, _value);
923     }
924 
925     function transferFrom(address _from, address _to, uint256 _value) public whenNotPaused returns (bool) {
926         return super.transferFrom(_from, _to, _value);
927     }
928 
929     function setJewelContract(address jewel) public onlyOwner {
930         jewelContract = Jewel(jewel);
931     }
932 
933     function incise(uint256 value) public returns (uint) {
934         require(jewelContract != address(0));
935 
936         uint256 balance = balances[msg.sender];
937         require(balance >= value);
938         uint256 count = (value / (10 ** uint256(decimals)));
939         require(count >= 1);
940 
941         uint ret = jewelContract.incise(msg.sender, count);
942 
943         burn(count * 10 ** uint256(decimals));
944 
945         return ret;
946     }
947 }