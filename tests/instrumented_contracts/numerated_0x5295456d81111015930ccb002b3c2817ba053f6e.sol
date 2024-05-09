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
404         balances[parseAddr("0x22de6b7F8b6119bA8E62FB4165834eA00adb6f3E")] = 110 * 1000 * 1000 * (10 ** uint256(decimals));
405         balances[parseAddr("0xA3eCD9F46CCfE4D27D747C9c7469990df7412d48")] = 30 * 1000 * 1000 * (10 ** uint256(decimals));
406         balances[parseAddr("0x686824DB069586aC0aD8060816F1D66A0EE8297b")] = 60 * 1000 * 1000 * (10 ** uint256(decimals));
407         balances[parseAddr("0x9E8eA5C674EBd85868215ceFab9c108Ab9ceA702")] = 150 * 1000 * 1000 * (10 ** uint256(decimals));
408         balances[parseAddr("0x4706f5d2a0d4D4eE5A37dDE1438C7de774A2A184")] = 150 * 1000 * 1000 * (10 ** uint256(decimals));
409         dayAverageOutput[0] = 241920 * 10 ** uint256(decimals);
410     }
411 
412     function parseAddr(string _a) internal returns (address){
413         bytes memory tmp = bytes(_a);
414         uint160 iaddr = 0;
415         uint160 b1;
416         uint160 b2;
417         for (uint i=2; i<2+2*20; i+=2){
418             iaddr *= 256;
419             b1 = uint160(tmp[i]);
420             b2 = uint160(tmp[i+1]);
421             if ((b1 >= 97)&&(b1 <= 102)) b1 -= 87;
422             else if ((b1 >= 48)&&(b1 <= 57)) b1 -= 48;
423             if ((b2 >= 97)&&(b2 <= 102)) b2 -= 87;
424             else if ((b2 >= 48)&&(b2 <= 57)) b2 -= 48;
425             iaddr += (b1*16+b2);
426         }
427         return address(iaddr);
428     }
429 
430     /*
431     function setTimeScale(uint scale) public onlyOwner {
432         timeScale = scale;
433     }
434 
435     
436     function setConstractDeployTime(uint32 time) public onlyOwner {
437         constractDeployTime = time;
438     }*/
439 
440     function setColdWallet(address _coldWallet) public onlyOwner {
441         coldWallet = _coldWallet;
442     }
443 
444     function disableWhiteUserList() public onlyOwner {
445         enableWhiteList = false;
446     }
447 
448     function disableCheckArea() public onlyOwner {
449         enableCheckArea = false;
450     }
451 
452     modifier checkWhiteList() {
453         if (enableWhiteList) {
454             require(whiteUserList[msg.sender]);
455         }
456         _;
457     }
458 
459     function setServerAddress(address addr) public onlyOwner {
460         serverAddress = addr;
461     }
462 
463     function authUser(string addr) public {
464         require(msg.sender == serverAddress || msg.sender == owner);
465         address s = bytesToAddress(bytes(addr));
466         whiteUserList[s] = true;
467     }
468 
469     function bytesToAddress (bytes b) internal view returns (address) {
470         uint result = 0;
471         for (uint i = 0; i < b.length; i++) {
472             uint c = uint(b[i]);
473             if (c >= 48 && c <= 57) {
474                 result = result * 16 + (c - 48);
475             }
476             if(c >= 65 && c <= 90) {
477                 result = result * 16 + (c - 55);
478             }
479             if(c >= 97 && c <= 122) {
480                 result = result * 16 + (c - 87);
481             }
482         }
483         return address(result);
484     }
485 
486     function setDayQualitys(address dayQualitys) public onlyOwner {
487         dayQualitysContract = DayQualitys(dayQualitys);
488     }
489 
490     function getMyDeployAt(uint32 area, uint32 hour) public view returns (uint32[3]) {
491         return userAreaHourDeployed[msg.sender].hour[hour][area];
492     }
493 
494     function getMyMinersAt(uint32 area, uint32 hour) public view returns (uint32) {
495         return _getUserMinersAt(msg.sender, area, hour);
496     }
497 
498     function _getUserMinersAt(address user, uint32 area, uint32 hour) internal view returns(uint32) {
499         //now start from start's nearest check point
500         uint32 nc = hour/CHECK_POINT_HOUR*CHECK_POINT_HOUR;
501         if (userAreaCheckPoints[user].hour[nc][area] == 0 && userAreaCheckPoints[user].hour[nc + CHECK_POINT_HOUR][area] == 0) {
502             return 0;
503         }
504         uint32 h = 0;
505         int64 userInc = 0;
506         uint32[3] storage ptUser;
507         AreaHourDeployed storage _userAreaHourDeployed = userAreaHourDeployed[user];
508         
509         for (h = nc; h <= hour; ++h) {
510             
511             
512             
513             ptUser = _userAreaHourDeployed.hour[h][area];
514             userInc += ptUser[0] + ptUser[1] + ptUser[2] - _userAreaHourDeployed.hour[h - 4][area][0] - 
515                 _userAreaHourDeployed.hour[h - 8][area][1] - _userAreaHourDeployed.hour[h - 24][area][2];
516         }
517         return userAreaCheckPoints[user].hour[nc][area] + uint32(userInc);
518     }
519 
520     function getDeployAt(uint32 area, uint32 hour) public view returns (uint32[3]) {
521         return areaHourDeployed[hour][area];
522     }
523 
524 
525     function getMinersAt(uint32 area, uint32 hour) public view returns (uint32) {
526         return _getMinersAt(area, hour);
527     }
528 
529     function _getMinersAt(uint32 area, uint32 hour) internal view returns (uint32) {
530         //now start from start's nearest check point
531         uint32 nc = hour/CHECK_POINT_HOUR*CHECK_POINT_HOUR;
532         uint32 h = 0;
533         int64 userInc = 0;
534         int64 totalInc = 0;
535         uint32[3] storage ptArea;
536         
537         for (h = nc; h <= hour; ++h) {
538             
539             
540             
541             ptArea = areaHourDeployed[h][area];
542             totalInc += ptArea[0] + ptArea[1] + ptArea[2] - areaHourDeployed[h - 4][area][0] - areaHourDeployed[h - 8][area][1] - areaHourDeployed[h - 24][area][2];
543         }
544 
545         return areaCheckPoints[nc][area] + uint32(totalInc);
546     }
547 
548     function updateArea(uint areaId) internal pure returns (uint) {
549         
550         uint row = areaId / 8;
551         uint colum = areaId % 8;
552 
553         uint result = uint(1) << areaId;
554         if (row-1 >= 0) {
555             result |= uint(1) << ((row-1)*8+colum);
556         }
557         if (row+1 < 9) {
558             result |= uint(1) << ((row+1)*8+colum);
559         }
560         if (colum-1 >= 0) {
561             result |= uint(1) << (row*8+colum-1);
562         }
563         if (colum+1 < 8) {
564             result |= uint(1) << (row*8+colum+1);
565         }
566         
567         return result;
568     }
569 
570     function checkArea(uint32[] area, address user) internal {
571         if (enableCheckArea) {
572             uint[] memory distinctArea = new uint[](area.length);
573             uint distinctAreaLength = 0;
574         
575             for (uint i = 0; i < area.length; i++) {
576                 bool find = false;
577                 for (uint j = 0; j < distinctAreaLength; j++) {
578                     if (distinctArea[j] == area[i]) {
579                         find = true;
580                         break;
581                     }
582                 }     
583                 if (!find) {
584                     distinctArea[distinctAreaLength] = area[i];
585                     distinctAreaLength += 1;
586                 }
587             }
588 
589             if (activeArea[user] == 0) {
590                 require(distinctAreaLength == 1);
591                 activeArea[user] = updateArea(distinctArea[0]);
592             } else {
593                 uint userActiveArea = activeArea[user];
594                 uint updateActiveArea = userActiveArea;
595                 for (i = 0; i < distinctAreaLength; i++) {
596                     require(userActiveArea & uint(1) << distinctArea[i] > 0);
597                     updateActiveArea = updateActiveArea | updateArea(distinctArea[i]);
598                 }
599 
600                 activeArea[user] = updateActiveArea;
601             }
602         }
603     }
604 
605     function deployMiners(address user, uint32[] area, uint32[] period, uint32[] count) public checkWhiteList whenNotPaused payable {
606         require(area.length > 0);
607         require(area.length == period.length);
608         require(area.length == count.length);
609         address _user = user;
610         if (_user == address(0)) {
611             _user = msg.sender;
612         }
613         
614         uint32 _hour = uint32((now - constractDeployTime) * timeScale / 1 hours);
615 
616         checkArea(area, user);
617         
618         uint payment = _deployMiners(_user, _hour, area, period, count);
619         _updateCheckPoints(_user, _hour, area, period, count);
620 
621         require(payment <= msg.value);
622         remainEther[msg.sender] += (msg.value - payment);
623         if (coldWallet != address(0)) {
624             coldWallet.transfer(payment);
625         } else {
626             amountEther += payment;
627         }
628         
629     }
630 
631     /*function deployMinersTest(uint32 _hour, address user, uint32[] area, uint32[] period, uint32[] count) public checkWhiteList payable {
632         require(area.length > 0);
633         require(area.length == period.length);
634         require(area.length == count.length);
635         address _user = user;
636         if (_user == address(0)) {
637             _user = msg.sender;
638         }
639         
640 
641         checkArea(area, user);
642         
643         uint payment = _deployMiners(_user, _hour, area, period, count);
644         _updateCheckPoints(_user, _hour, area, period, count);
645 
646         require(payment <= msg.value);
647         remainEther[msg.sender] += (msg.value - payment);
648         amountEther += payment;
649     }*/
650 
651     function _deployMiners(address _user, uint32 _hour, uint32[] memory area, uint32[] memory period, uint32[] memory count) internal returns(uint){
652         uint payment = 0;
653         uint32 minerCount = 0;
654         uint32[3][72] storage _areaDeployed = areaHourDeployed[_hour];
655         uint32[3][72] storage _userAreaDeployed = userAreaHourDeployed[_user].hour[_hour];
656         
657         
658         for (uint index = 0; index < area.length; ++index) {
659             require (period[index] == 4 || period[index] == 8 || period[index] == 24);
660             if (period[index] == 4) {
661                 _areaDeployed[area[index]][0] += count[index];
662                 _userAreaDeployed[area[index]][0] += count[index];
663                 payment += count[index] * MINER_4_HOURS;
664             } else if (period[index] == 8) {
665                 _areaDeployed[area[index]][1] += count[index];
666                 _userAreaDeployed[area[index]][1] += count[index];
667                 payment += count[index] * MINER_8_HOURS;
668             } else if (period[index] == 24) {
669                 _areaDeployed[area[index]][2] += count[index];
670                 _userAreaDeployed[area[index]][2] += count[index];
671                 payment += count[index] * MINER_24_HOURS;
672             }
673             minerCount += count[index];
674             DeployMiner(_user, area[index], _hour, _hour + period[index], count[index]);
675 
676             adjustDeployRange(area[index], _hour, _hour + period[index]);
677         }
678         return payment;
679     }   
680 
681     function adjustDeployRange(uint area, uint start, uint end) internal {
682         uint len = deployRange[msg.sender][area].length;
683         if (len == 0) {
684             deployRange[msg.sender][area].push(start | (end << 128));
685         } else {
686             uint s = uint128(deployRange[msg.sender][area][len - 1]);
687             uint e = uint128(deployRange[msg.sender][area][len - 1] >> 128);
688             
689             if (start >= s && start < e) {
690                 end = e > end ? e : end;
691                 deployRange[msg.sender][area][len - 1] = s | (end << 128);
692             } else {
693                 deployRange[msg.sender][area].push(start | (end << 128));
694             }
695         }
696     }
697 
698     function getDeployArrayLength(uint area) public view returns (uint) {
699         return deployRange[msg.sender][area].length;
700     }
701     
702     function getDeploy(uint area, uint index) public view returns (uint,uint) {
703         uint s = uint128(deployRange[msg.sender][area][index]);
704         uint e = uint128(deployRange[msg.sender][area][index] >> 128);
705         return (s, e);
706     }
707 
708     function _updateCheckPoints(address _user, uint32 _hour, uint32[] memory area, uint32[] memory period, uint32[] memory count) internal {
709         uint32 _area = 0;
710         uint32 _count = 0;
711         uint32 ce4 = _hour + 4;
712         uint32 ce8 = _hour + 8;
713         uint32 ce24 = _hour + 24;
714         uint32 cs = (_hour/CHECK_POINT_HOUR+1)*CHECK_POINT_HOUR;
715         AreaCheckPoint storage _userAreaCheckPoints = userAreaCheckPoints[_user];
716         uint32 cp = 0;
717         for (uint index = 0; index < area.length; ++index) {
718             _area = area[index];
719             _count = count[index];
720             if (period[index] == 4) {
721                 for (cp = cs; cp <= ce4; cp += CHECK_POINT_HOUR) {
722                     areaCheckPoints[cp][_area] += _count;
723                     _userAreaCheckPoints.hour[cp][_area] += _count;
724                 }
725             } else if (period[index] == 8) {
726                 for (cp = cs; cp <= ce8; cp += CHECK_POINT_HOUR) {
727                     areaCheckPoints[cp][_area] += _count;
728                     _userAreaCheckPoints.hour[cp][_area] += _count;
729                 }
730             } else if (period[index] == 24) {
731                 for (cp = cs; cp <= ce24; cp += CHECK_POINT_HOUR) {
732                     areaCheckPoints[cp][_area] += _count;
733                     _userAreaCheckPoints.hour[cp][_area] += _count;
734                 }
735             }
736         }
737     }
738 
739     
740 
741     event DeployMiner(address addr, uint32 area, uint32 start, uint32 end, uint32 count);
742 
743     event Collect(address addr, uint32 area, uint32 start, uint32 end, uint areaCount);
744 
745     function getMyLastCollectHour(uint32 area) public view returns (uint32){
746         return userAreaHourDeployed[msg.sender].lastCollectHour[area];
747     }
748 
749     
750     
751     function collect(address user, uint32[] area) public  checkWhiteList whenNotPaused {
752         require(address(dayQualitysContract) != address(0));
753         uint32 current = uint32((now - constractDeployTime) * timeScale / 1 hours);
754         require(area.length > 0);
755         address _user = user;
756         if (_user == address(0)) {
757             _user = msg.sender;
758         }
759         uint total = 0;
760         
761         for (uint a = 0; a < area.length; ++a) {
762             uint len = deployRange[msg.sender][area[a]].length;
763             bool finish = true;
764             for (uint i = 0; i < len; i += 1) {
765                 uint s = uint128(deployRange[msg.sender][area[a]][i]);
766                 uint e = uint128(deployRange[msg.sender][area[a]][i] >> 128);
767                 if (current < e && current >= s ) {
768                     total += _collect(_user, uint32(s), current, area[a]);
769                     
770                     deployRange[msg.sender][area[a]][i] = current | (e << 128);
771                     finish = false;
772                 } else if (current >= e) {
773                     total += _collect(_user, uint32(s), uint32(e), area[a]);
774                 }
775             }
776             
777             if (finish) {
778                 deployRange[msg.sender][area[a]].length = 0;
779             } else {
780                 deployRange[msg.sender][area[a]][0] = deployRange[msg.sender][area[a]][len - 1];
781                 deployRange[msg.sender][area[a]].length = 1;
782             }
783         }    
784 
785         ERC20(this).transfer(_user, total);
786     }
787 
788     function _collect(address _user, uint32 start, uint32 end, uint32 area) internal returns (uint) {
789         uint result = 0;
790         uint32 writeCount = 1;
791         uint income = 0;
792         uint32[] memory totalMiners = new uint32[](CHECK_POINT_HOUR);
793         uint32[] memory userMiners = new uint32[](CHECK_POINT_HOUR);
794         uint32 ps = start/CHECK_POINT_HOUR*CHECK_POINT_HOUR+CHECK_POINT_HOUR;
795         if (ps >= end) {
796             
797             (income, writeCount) = _collectMinersByCheckPoints(_user, area, start, end, totalMiners, userMiners, writeCount);
798             result += income;
799         } else {
800             
801             (income, writeCount) = _collectMinersByCheckPoints(_user, area, start, ps, totalMiners, userMiners, writeCount);
802             result += income;
803 
804             while (ps < end) {
805                 (income, writeCount) = _collectMinersByCheckPoints(_user, area, ps, uint32(Math.min64(end, ps + CHECK_POINT_HOUR)), totalMiners, userMiners, writeCount);
806                 result += income;
807 
808                 ps += CHECK_POINT_HOUR;
809             }
810         }
811         Collect(_user, area, start, end, result);
812         return result;
813     }
814 
815     function _collectMinersByCheckPoints(address _user, uint32 area, uint32 start, uint32 end, uint32[] memory totalMiners, uint32[] memory userMiners, uint32 _writeCount) internal returns (uint income, uint32 writeCount) {
816         //now start from start's nearest check point
817         writeCount = _writeCount;
818         income = 0;
819         
820         
821         if (userAreaCheckPoints[_user].hour[start/CHECK_POINT_HOUR*CHECK_POINT_HOUR][area] == 0 && userAreaCheckPoints[_user].hour[start/CHECK_POINT_HOUR*CHECK_POINT_HOUR + CHECK_POINT_HOUR][area] == 0) {
822             return;
823         }
824         _getMinersByCheckPoints(_user, area, start, end, totalMiners, userMiners);
825         uint ao = dayAverageOutput[start / 24];
826         if (ao == 0) {
827             uint32 d = start / 24;
828             for (; d >= 0; --d) {
829                 if (dayAverageOutput[d] != 0) {
830                     break;
831                 }
832             } 
833             ao = dayAverageOutput[d];
834             for (d = d+1; d <= start / 24; ++d) {
835                 ao = ao*9996/10000;
836                 if ((start / 24 - d) < writeCount) {
837                     dayAverageOutput[d] = ao;
838                 }
839             }
840             if (writeCount > (start / 24 - d - 1)) {
841                 writeCount = writeCount - (start / 24 - d - 1);
842             } else {
843                 writeCount = 0;
844             }
845         }
846 
847         uint week = dayQualitysContract.getAreaQualityByDay(uint32(start * 1 hours + constractDeployTime), area);
848         require(week > 0);
849 
850         ao = week * ao / 10 / 24 / 72;
851         
852         income = _getTotalIncomeAt(end - start, userMiners, totalMiners, ao, week);
853 
854         if (week == 10) { 
855             income = income * 8 / 10;
856         } else if (week == 5) { 
857             income = income * 6 / 10;
858         } 
859     }
860 
861     function _getTotalIncomeAt(uint32 hourLength, uint32[] memory userMiners, uint32[] memory totalMiners, uint areaOutput, uint week) internal view returns(uint) {
862         uint income = 0;
863         for (uint i = 0; i < hourLength; ++i) {
864             if (userMiners[i] != 0 && totalMiners[i] != 0) {
865                 income += (Math.min256(10 ** uint256(decimals), areaOutput / totalMiners[i]) * userMiners[i]);
866             }
867         }
868         return income;
869     } 
870 
871     function _getMinersByCheckPoints(address _user, uint32 area, uint32 start, uint32 end, uint32[] memory totalMiners, uint32[] memory userMiners) internal view {
872         require((end - start) <= CHECK_POINT_HOUR);
873         //now start from start's nearest check point
874         uint32 h = 0;
875         int64 userInc = 0;
876         int64 totalInc = 0;
877         uint32[3] storage ptUser;
878         uint32[3] storage ptArea;
879         AreaHourDeployed storage _userAreaHourDeployed = userAreaHourDeployed[_user];
880         
881         for (h = start/CHECK_POINT_HOUR*CHECK_POINT_HOUR; h <= start; ++h) {
882             
883             
884             
885             ptUser = _userAreaHourDeployed.hour[h][area];
886             ptArea = areaHourDeployed[h][area];
887             totalInc += ptArea[0] + ptArea[1] + ptArea[2] - areaHourDeployed[h - 4][area][0] - areaHourDeployed[h - 8][area][1] - areaHourDeployed[h - 24][area][2];
888             userInc += ptUser[0] + ptUser[1] + ptUser[2] - _userAreaHourDeployed.hour[h - 4][area][0] - _userAreaHourDeployed.hour[h - 8][area][1] - _userAreaHourDeployed.hour[h - 24][area][2];
889         }
890 
891         totalMiners[0] = areaCheckPoints[start/CHECK_POINT_HOUR*CHECK_POINT_HOUR][area] + uint32(totalInc);
892         userMiners[0] = userAreaCheckPoints[_user].hour[start/CHECK_POINT_HOUR*CHECK_POINT_HOUR][area] + uint32(userInc);
893 
894         uint32 i = 1;
895         for (h = start + 1; h < end; ++h) {
896             
897             
898             
899             ptUser = _userAreaHourDeployed.hour[h][area];
900             ptArea = areaHourDeployed[h][area];
901             totalMiners[i] = totalMiners[i-1] + ptArea[0] + ptArea[1] + ptArea[2] - areaHourDeployed[h - 4][area][0] - areaHourDeployed[h - 8][area][1] - areaHourDeployed[h - 24][area][2];
902             userMiners[i] = userMiners[i-1] + ptUser[0] + ptUser[1] + ptUser[2] - _userAreaHourDeployed.hour[h - 4][area][0] - _userAreaHourDeployed.hour[h - 8][area][1] - _userAreaHourDeployed.hour[h - 24][area][2];
903             ++i;
904         }
905     }
906 
907     
908     function withdraw() public {
909         uint remain = remainEther[msg.sender]; 
910         require(remain > 0);
911         remainEther[msg.sender] = 0;
912 
913         msg.sender.transfer(remain);
914     }
915 
916     
917     function withdrawMinerFee() public onlyOwner {
918         require(amountEther > 0);
919         owner.transfer(amountEther);
920         amountEther = 0;
921     }
922 
923     modifier whenNotPaused() {
924         require(!paused);
925         _;
926     }
927 
928     modifier whenPaused() {
929         require(paused);
930         _;
931     }
932 
933     function pause() onlyOwner whenNotPaused public {
934         paused = true;
935         Pause();
936     }
937 
938     function unpause() onlyOwner whenPaused public {
939         paused = false;
940         Unpause();
941     }
942 
943     function transfer(address _to, uint256 _value) public whenNotPaused returns (bool) {
944         return super.transfer(_to, _value);
945     }
946 
947     function transferFrom(address _from, address _to, uint256 _value) public whenNotPaused returns (bool) {
948         return super.transferFrom(_from, _to, _value);
949     }
950 
951     function setJewelContract(address jewel) public onlyOwner {
952         jewelContract = Jewel(jewel);
953     }
954 
955     function incise(uint256 value) public returns (uint) {
956         require(jewelContract != address(0));
957 
958         uint256 balance = balances[msg.sender];
959         require(balance >= value);
960         uint256 count = (value / (10 ** uint256(decimals)));
961         require(count >= 1);
962 
963         uint ret = jewelContract.incise(msg.sender, count);
964 
965         burn(count * 10 ** uint256(decimals));
966 
967         return ret;
968     }
969 }