1 /* ==================================================================== */
2 /* Copyright (c) 2018 The ether.online Project.  All rights reserved.
3 /* 
4 /* https://ether.online  The first RPG game of blockchain 
5 /*  
6 /* authors rickhunter.shen@gmail.com   
7 /*         ssesunding@gmail.com            
8 /* ==================================================================== */
9 
10 pragma solidity ^0.4.20;
11 
12 contract AccessAdmin {
13     bool public isPaused = false;
14     address public addrAdmin;  
15 
16     event AdminTransferred(address indexed preAdmin, address indexed newAdmin);
17 
18     function AccessAdmin() public {
19         addrAdmin = msg.sender;
20     }  
21 
22 
23     modifier onlyAdmin() {
24         require(msg.sender == addrAdmin);
25         _;
26     }
27 
28     modifier whenNotPaused() {
29         require(!isPaused);
30         _;
31     }
32 
33     modifier whenPaused {
34         require(isPaused);
35         _;
36     }
37 
38     function setAdmin(address _newAdmin) external onlyAdmin {
39         require(_newAdmin != address(0));
40         AdminTransferred(addrAdmin, _newAdmin);
41         addrAdmin = _newAdmin;
42     }
43 
44     function doPause() external onlyAdmin whenNotPaused {
45         isPaused = true;
46     }
47 
48     function doUnpause() external onlyAdmin whenPaused {
49         isPaused = false;
50     }
51 }
52 
53 
54 contract AccessService is AccessAdmin {
55     address public addrService;
56     address public addrFinance;
57 
58     modifier onlyService() {
59         require(msg.sender == addrService);
60         _;
61     }
62 
63     modifier onlyFinance() {
64         require(msg.sender == addrFinance);
65         _;
66     }
67 
68     function setService(address _newService) external {
69         require(msg.sender == addrService || msg.sender == addrAdmin);
70         require(_newService != address(0));
71         addrService = _newService;
72     }
73 
74     function setFinance(address _newFinance) external {
75         require(msg.sender == addrFinance || msg.sender == addrAdmin);
76         require(_newFinance != address(0));
77         addrFinance = _newFinance;
78     }
79 
80     function withdraw(address _target, uint256 _amount) 
81         external 
82     {
83         require(msg.sender == addrFinance || msg.sender == addrAdmin);
84         require(_amount > 0);
85         address receiver = _target == address(0) ? addrFinance : _target;
86         uint256 balance = this.balance;
87         if (_amount < balance) {
88             receiver.transfer(_amount);
89         } else {
90             receiver.transfer(this.balance);
91         }      
92     }
93 }
94 
95 /**
96  * @title SafeMath
97  * @dev Math operations with safety checks that throw on error
98  */
99 library SafeMath {
100     /**
101     * @dev Multiplies two numbers, throws on overflow.
102     */
103     function mul(uint256 a, uint256 b) internal pure returns (uint256) {
104         if (a == 0) {
105             return 0;
106         }
107         uint256 c = a * b;
108         assert(c / a == b);
109         return c;
110     }
111 
112     /**
113     * @dev Integer division of two numbers, truncating the quotient.
114     */
115     function div(uint256 a, uint256 b) internal pure returns (uint256) {
116         // assert(b > 0); // Solidity automatically throws when dividing by 0
117         uint256 c = a / b;
118         // assert(a == b * c + a % b); // There is no case in which this doesn't hold
119         return c;
120     }
121 
122     /**
123     * @dev Substracts two numbers, throws on overflow (i.e. if subtrahend is greater than minuend).
124     */
125     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
126         assert(b <= a);
127         return a - b;
128     }
129 
130     /**
131     * @dev Adds two numbers, throws on overflow.
132     */
133     function add(uint256 a, uint256 b) internal pure returns (uint256) {
134         uint256 c = a + b;
135         assert(c >= a);
136         return c;
137     }
138 }
139 
140 interface IBitGuildToken {
141     function transfer(address _to, uint256 _value) external;
142     function transferFrom(address _from, address _to, uint256 _value) external returns (bool);
143     function approve(address _spender, uint256 _value) external; 
144     function approveAndCall(address _spender, uint256 _value, bytes _extraData) external returns (bool);
145     function balanceOf(address _from) external view returns(uint256);
146 }
147 
148 interface IAgonFight {
149     function calcFight(uint64 _mFlag, uint64 _cFlag, uint256 _aSeed, uint256 _fSeed) external pure returns(uint64);
150 }
151 
152 contract ActionAgonPlat is AccessService {
153     using SafeMath for uint256; 
154 
155     event CreateAgonPlat(uint64 indexed agonId, address indexed master, uint64 indexed outFlag);
156     event CancelAgonPlat(uint64 indexed agonId, address indexed master, uint64 indexed outFlag);
157     event ChallengeAgonPlat(uint64 indexed agonId, address indexed master, uint64 indexed outFlag, address challenger);
158     event ResolveAgonPlat(uint64 indexed agonId, address indexed master, uint64 indexed outFlag, address challenger);
159 
160     struct Agon {
161         address master;
162         address challenger;
163         uint64 agonPrice;
164         uint64 outFlag;
165         uint64 agonFlag;    
166         uint64 result;      // 1-win, 2-lose, 99-cancel
167     }
168 
169     Agon[] agonArray;
170     IAgonFight fightContract;
171     IBitGuildToken public bitGuildContract;
172 
173     mapping (address => uint64[]) public ownerToAgonIdArray;
174     uint256 public maxAgonCount = 6;
175     uint256 public maxResolvedAgonId = 0; 
176     uint256[5] public agonValues;
177 
178     function ActionAgonPlat(address _platAddr) public {
179         addrAdmin = msg.sender;
180         addrService = msg.sender;
181         addrFinance = msg.sender;
182 
183         bitGuildContract = IBitGuildToken(_platAddr);
184 
185         Agon memory order = Agon(0, 0, 0, 0, 1, 1);
186         agonArray.push(order);
187         agonValues[0] = 3000000000000000000000;
188         agonValues[1] = 12000000000000000000000;
189         agonValues[2] = 30000000000000000000000;
190         agonValues[3] = 60000000000000000000000;
191         agonValues[4] = 120000000000000000000000;
192     }
193 
194     function() external {}
195 
196     function setMaxAgonCount(uint256 _count) external onlyAdmin {
197         require(_count > 0 && _count < 20);
198         require(_count != maxAgonCount);
199         maxAgonCount = _count;
200     }
201 
202     function setAgonFight(address _addr) external onlyAdmin {
203         fightContract = IAgonFight(_addr);
204     }
205 
206     function setMaxResolvedAgonId() external {
207         uint256 length = agonArray.length;
208         for (uint256 i = maxResolvedAgonId; i < length; ++i) {
209             if (agonArray[i].result == 0) {
210                 maxResolvedAgonId = i - 1;
211                 break;
212             }
213         }
214     }
215 
216     function setAgonValues(uint256[5] values) external onlyAdmin {
217         require(values[0] >= 100);
218         require(values[1] >= values[0]);
219         require(values[2] >= values[1]);
220         require(values[3] >= values[2]);
221         require(values[4] >= values[3]);
222         require(values[4] <= 600000); 
223         require(values[0] % 100 == 0);
224         require(values[1] % 100 == 0);
225         require(values[2] % 100 == 0);
226         require(values[3] % 100 == 0);
227         require(values[4] % 100 == 0);
228         agonValues[0] = values[0].mul(1000000000000000000);
229         agonValues[1] = values[1].mul(1000000000000000000);
230         agonValues[2] = values[2].mul(1000000000000000000);
231         agonValues[3] = values[3].mul(1000000000000000000);
232         agonValues[4] = values[4].mul(1000000000000000000);
233     }
234 
235     function _getExtraParam(bytes _extraData) internal pure returns(uint64 p1, uint64 p2, uint64 p3) {
236         p1 = uint64(_extraData[0]);
237         p2 = uint64(_extraData[1]);
238         uint64 index = 2;
239         uint256 val = 0;
240         uint256 length = _extraData.length;
241         while (index < length) {
242             val += (uint256(_extraData[index]) * (256 ** (length - index - 1)));
243             index += 1;
244         }
245         p3 = uint64(val);
246     }
247 
248     function receiveApproval(address _sender, uint256 _value, address _tokenContract, bytes _extraData) 
249         external 
250         whenNotPaused 
251     {
252         require(msg.sender == address(bitGuildContract));
253         require(_extraData.length > 2 && _extraData.length <= 10);
254         var (p1, p2, p3) = _getExtraParam(_extraData);
255         if (p1 == 0) {
256             _newAgon(p3, p2, _sender, _value);
257         } else if (p1 == 1) {
258             _newChallenge(p3, p2, _sender, _value);
259         } else {
260             require(false);
261         }
262     }
263 
264     function _newAgon(uint64 _outFlag, uint64 _valId, address _sender, uint256 _value) internal {
265         require(ownerToAgonIdArray[_sender].length < maxAgonCount);
266         require(_valId >= 0 && _valId <= 4);
267         require(_value == agonValues[_valId]);
268         
269         require(bitGuildContract.transferFrom(_sender, address(this), _value));
270 
271         uint64 newAgonId = uint64(agonArray.length);
272         agonArray.length += 1;
273         Agon storage agon = agonArray[newAgonId];
274         agon.master = _sender;
275         agon.agonPrice = uint64(_value.div(1000000000000000000)); 
276         agon.outFlag = _outFlag;
277 
278         ownerToAgonIdArray[_sender].push(newAgonId);
279 
280         CreateAgonPlat(uint64(newAgonId), _sender, _outFlag);
281     } 
282 
283     function _removeAgonIdByOwner(address _owner, uint64 _agonId) internal {
284         uint64[] storage agonIdArray = ownerToAgonIdArray[_owner];
285         uint256 length = agonIdArray.length;
286         require(length > 0);
287         uint256 findIndex = 99;
288         for (uint256 i = 0; i < length; ++i) {
289             if (_agonId == agonIdArray[i]) {
290                 findIndex = i;
291             }
292         }
293         require(findIndex != 99);
294         if (findIndex != (length - 1)) {
295             agonIdArray[findIndex] = agonIdArray[length - 1];
296         } 
297         agonIdArray.length -= 1;
298     }
299 
300     function cancelAgon(uint64 _agonId) external {
301         require(_agonId < agonArray.length);
302         Agon storage agon = agonArray[_agonId];
303         require(agon.result == 0);
304         require(agon.challenger == address(0));
305         require(agon.master == msg.sender);
306 
307         agon.result = 99;
308         _removeAgonIdByOwner(msg.sender, _agonId);
309         bitGuildContract.transfer(msg.sender, uint256(agon.agonPrice).mul(1000000000000000000));
310 
311         CancelAgonPlat(_agonId, msg.sender, agon.outFlag);
312     }
313 
314     function cancelAgonForce(uint64 _agonId) external onlyService {
315         require(_agonId < agonArray.length);
316         Agon storage agon = agonArray[_agonId];
317         require(agon.result == 0);
318         require(agon.challenger == address(0));
319 
320         agon.result = 99;
321         _removeAgonIdByOwner(agon.master, _agonId);
322         bitGuildContract.transfer(agon.master, uint256(agon.agonPrice).mul(1000000000000000000));
323 
324         CancelAgonPlat(_agonId, agon.master, agon.outFlag);
325     }
326 
327     function _newChallenge(uint64 _agonId, uint64 _flag, address _sender, uint256 _value) internal {
328         require(_agonId < agonArray.length);
329         Agon storage agon = agonArray[_agonId];
330         require(agon.result == 0);
331         require(agon.master != _sender);
332         require(uint256(agon.agonPrice).mul(1000000000000000000) == _value);
333         require(agon.challenger == address(0));
334 
335         require(bitGuildContract.transferFrom(_sender, address(this), _value));
336 
337         agon.challenger = _sender;
338         agon.agonFlag = _flag;
339         ChallengeAgonPlat(_agonId, agon.master, agon.outFlag, _sender);
340     }
341 
342     function fightAgon(uint64 _agonId, uint64 _mFlag, uint256 _aSeed, uint256 _fSeed) external onlyService {
343         require(_agonId < agonArray.length);
344         Agon storage agon = agonArray[_agonId];
345         require(agon.result == 0 && agon.challenger != address(0));
346         require(fightContract != address(0));
347         uint64 fRet = fightContract.calcFight(_mFlag, agon.agonFlag, _aSeed, _fSeed);
348         require(fRet == 1 || fRet == 2);
349         agon.result = fRet;
350         _removeAgonIdByOwner(agon.master, _agonId);
351         uint256 devCut = uint256(agon.agonPrice).div(10);
352         uint256 winVal = uint256(agon.agonPrice).mul(2).sub(devCut);
353         if (fRet == 1) {
354             bitGuildContract.transfer(agon.master, winVal.mul(1000000000000000000));
355         } else {
356             bitGuildContract.transfer(agon.challenger, winVal.mul(1000000000000000000));
357         }
358 
359         ResolveAgonPlat(_agonId, agon.master, agon.outFlag, agon.challenger);
360     }
361 
362     function getPlatBalance() external view returns(uint256) {
363         return bitGuildContract.balanceOf(this);
364     }
365 
366     function withdrawPlat() external {
367         require(msg.sender == addrFinance || msg.sender == addrAdmin);
368         uint256 balance = bitGuildContract.balanceOf(this);
369         require(balance > 0);
370         bitGuildContract.transfer(addrFinance, balance);
371     }
372 
373     function getAgon(uint256 _agonId) external view
374         returns(
375             address master,
376             address challenger,
377             uint64 agonPrice,
378             uint64 outFlag,
379             uint64 agonFlag,
380             uint64 result
381         )
382     {
383         require(_agonId < agonArray.length);
384         Agon memory agon = agonArray[_agonId];
385         master = agon.master;
386         challenger = agon.challenger;
387         agonPrice = agon.agonPrice;
388         outFlag = agon.outFlag;
389         agonFlag = agon.agonFlag;
390         result = agon.result;
391     }
392 
393     function getAgonArray(uint64 _startAgonId, uint64 _count) external view
394         returns(
395             uint64[] agonIds,
396             address[] masters,
397             address[] challengers,
398             uint64[] agonPrices,           
399             uint64[] agonOutFlags,
400             uint64[] agonFlags,
401             uint64[] results
402         ) 
403     {
404         uint64 length = uint64(agonArray.length);
405         require(_startAgonId < length);
406         require(_startAgonId > 0);
407         uint256 maxLen;
408         if (_count == 0) {
409             maxLen = length - _startAgonId;
410         } else {
411             maxLen = (length - _startAgonId) >= _count ? _count : (length - _startAgonId);
412         }
413         agonIds = new uint64[](maxLen);
414         masters = new address[](maxLen);
415         challengers = new address[](maxLen);
416         agonPrices = new uint64[](maxLen);
417         agonOutFlags = new uint64[](maxLen);
418         agonFlags = new uint64[](maxLen);
419         results = new uint64[](maxLen);
420         uint256 counter = 0;
421         for (uint64 i = _startAgonId; i < length; ++i) {
422             Agon storage tmpAgon = agonArray[i];
423             agonIds[counter] = i;
424             masters[counter] = tmpAgon.master;
425             challengers[counter] = tmpAgon.challenger;
426             agonPrices[counter] = tmpAgon.agonPrice;
427             agonOutFlags[counter] = tmpAgon.outFlag;
428             agonFlags[counter] = tmpAgon.agonFlag;
429             results[counter] = tmpAgon.result;
430             counter += 1;
431             if (counter >= maxLen) {
432                 break;
433             }
434         }
435     }
436 
437     function getMaxAgonId() external view returns(uint256) {
438         return agonArray.length - 1;
439     }
440 
441     function getAgonIdArray(address _owner) external view returns(uint64[]) {
442         return ownerToAgonIdArray[_owner];
443     }
444 }