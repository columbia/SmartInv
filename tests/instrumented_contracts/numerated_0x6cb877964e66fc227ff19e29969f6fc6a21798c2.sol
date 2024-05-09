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
53 contract AccessNoWithdraw is AccessAdmin {
54     address public addrService;
55     address public addrFinance;
56 
57     modifier onlyService() {
58         require(msg.sender == addrService);
59         _;
60     }
61 
62     modifier onlyFinance() {
63         require(msg.sender == addrFinance);
64         _;
65     }
66 
67     modifier onlyManager() { 
68         require(msg.sender == addrService || msg.sender == addrAdmin || msg.sender == addrFinance);
69         _; 
70     }
71     
72     function setService(address _newService) external {
73         require(msg.sender == addrService || msg.sender == addrAdmin);
74         require(_newService != address(0));
75         addrService = _newService;
76     }
77 
78     function setFinance(address _newFinance) external {
79         require(msg.sender == addrFinance || msg.sender == addrAdmin);
80         require(_newFinance != address(0));
81         addrFinance = _newFinance;
82     }
83 }
84 
85 /**
86  * @title SafeMath
87  * @dev Math operations with safety checks that throw on error
88  */
89 library SafeMath {
90     /**
91     * @dev Multiplies two numbers, throws on overflow.
92     */
93     function mul(uint256 a, uint256 b) internal pure returns (uint256) {
94         if (a == 0) {
95             return 0;
96         }
97         uint256 c = a * b;
98         assert(c / a == b);
99         return c;
100     }
101 
102     /**
103     * @dev Integer division of two numbers, truncating the quotient.
104     */
105     function div(uint256 a, uint256 b) internal pure returns (uint256) {
106         // assert(b > 0); // Solidity automatically throws when dividing by 0
107         uint256 c = a / b;
108         // assert(a == b * c + a % b); // There is no case in which this doesn't hold
109         return c;
110     }
111 
112     /**
113     * @dev Substracts two numbers, throws on overflow (i.e. if subtrahend is greater than minuend).
114     */
115     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
116         assert(b <= a);
117         return a - b;
118     }
119 
120     /**
121     * @dev Adds two numbers, throws on overflow.
122     */
123     function add(uint256 a, uint256 b) internal pure returns (uint256) {
124         uint256 c = a + b;
125         assert(c >= a);
126         return c;
127     }
128 }
129 
130 interface IAgonFight {
131     function calcFight(uint64 _mFlag, uint64 _cFlag, uint256 _aSeed, uint256 _fSeed) external pure returns(uint64);
132 }
133 
134 contract ActionAgon is AccessNoWithdraw {
135     using SafeMath for uint256; 
136 
137     event CreateAgon(uint64 indexed agonId, address indexed master, uint64 indexed outFlag);
138     event CancelAgon(uint64 indexed agonId, address indexed master, uint64 indexed outFlag);
139     event ChallengeAgon(uint64 indexed agonId, address indexed master, uint64 indexed outFlag, address challenger);
140     event ResolveAgon(uint64 indexed agonId, address indexed master, uint64 indexed outFlag, address challenger);
141 
142     struct Agon {
143         address master;
144         address challenger;
145         uint64 agonPrice;
146         uint64 outFlag;
147         uint64 agonFlag;    
148         uint64 result;      // 1-win, 2-lose, 99-cancel
149     }
150 
151     Agon[] agonArray;
152     address public poolContract;
153     IAgonFight fightContract;
154 
155     mapping (address => uint64[]) public ownerToAgonIdArray;
156     uint256 public maxAgonCount = 6;
157     uint256 public maxResolvedAgonId = 0; 
158     uint256[5] public agonValues = [0.05 ether, 0.2 ether, 0.5 ether, 1 ether, 2 ether];
159 
160     function ActionAgon() public {
161         addrAdmin = msg.sender;
162         addrService = msg.sender;
163         addrFinance = msg.sender;
164 
165         Agon memory order = Agon(0, 0, 0, 0, 1, 1);
166         agonArray.push(order);
167     }
168 
169     function() external {}
170 
171     function setArenaPool(address _addr) external onlyAdmin {
172         require(_addr != address(0));
173         poolContract = _addr;
174     }
175 
176     function setMaxAgonCount(uint256 _count) external onlyAdmin {
177         require(_count > 0 && _count < 20);
178         require(_count != maxAgonCount);
179         maxAgonCount = _count;
180     }
181 
182     function setAgonFight(address _addr) external onlyAdmin {
183         fightContract = IAgonFight(_addr);
184     }
185 
186     function setMaxResolvedAgonId() external {
187         uint256 length = agonArray.length;
188         for (uint256 i = maxResolvedAgonId; i < length; ++i) {
189             if (agonArray[i].result == 0) {
190                 maxResolvedAgonId = i - 1;
191                 break;
192             }
193         }
194     }
195 
196     function setAgonValues(uint256[5] values) external onlyAdmin {
197         require(values[0] >= 0.001 ether);
198         require(values[1] >= values[0]);
199         require(values[2] >= values[1]);
200         require(values[3] >= values[2]);
201         require(values[4] >= values[3]);
202         require(values[4] <= 10 ether);     // 10 ether < 2^64
203         require(values[0] % 1000000000 == 0);
204         require(values[1] % 1000000000 == 0);
205         require(values[2] % 1000000000 == 0);
206         require(values[3] % 1000000000 == 0);
207         require(values[4] % 1000000000 == 0);
208         agonValues[0] = values[0];
209         agonValues[1] = values[1];
210         agonValues[2] = values[2];
211         agonValues[3] = values[3];
212         agonValues[4] = values[4];
213     }
214 
215     function newAgon(uint64 _outFlag, uint64 _valId) external payable whenNotPaused {
216         require(ownerToAgonIdArray[msg.sender].length < maxAgonCount);
217         require(_valId >= 0 && _valId <= 4);
218         require(msg.value == agonValues[_valId]);
219         
220         uint64 newAgonId = uint64(agonArray.length);
221         agonArray.length += 1;
222         Agon storage agon = agonArray[newAgonId];
223         agon.master = msg.sender;
224         agon.agonPrice = uint64(msg.value);    // 10 ether < 2^64
225         agon.outFlag = _outFlag;
226 
227         ownerToAgonIdArray[msg.sender].push(newAgonId);
228 
229         CreateAgon(uint64(newAgonId), msg.sender, _outFlag);
230     } 
231 
232     function _removeAgonIdByOwner(address _owner, uint64 _agonId) internal {
233         uint64[] storage agonIdArray = ownerToAgonIdArray[_owner];
234         uint256 length = agonIdArray.length;
235         require(length > 0);
236         uint256 findIndex = 99;
237         for (uint256 i = 0; i < length; ++i) {
238             if (_agonId == agonIdArray[i]) {
239                 findIndex = i;
240             }
241         }
242         require(findIndex != 99);
243         if (findIndex != (length - 1)) {
244             agonIdArray[findIndex] = agonIdArray[length - 1];
245         } 
246         agonIdArray.length -= 1;
247     }
248 
249     function cancelAgon(uint64 _agonId) external {
250         require(_agonId < agonArray.length);
251         Agon storage agon = agonArray[_agonId];
252         require(agon.result == 0);
253         require(agon.challenger == address(0));
254         require(agon.master == msg.sender);
255 
256         agon.result = 99;
257         _removeAgonIdByOwner(msg.sender, _agonId);
258         msg.sender.transfer(agon.agonPrice);
259 
260         CancelAgon(_agonId, msg.sender, agon.outFlag);
261     }
262 
263     function cancelAgonForce(uint64 _agonId) external onlyService {
264         require(_agonId < agonArray.length);
265         Agon storage agon = agonArray[_agonId];
266         require(agon.result == 0);
267         require(agon.challenger == address(0));
268 
269         agon.result = 99;
270         _removeAgonIdByOwner(agon.master, _agonId);
271         agon.master.transfer(agon.agonPrice);
272 
273         CancelAgon(_agonId, agon.master, agon.outFlag);
274     }
275 
276     function newChallenge(uint64 _agonId, uint64 _flag) external payable whenNotPaused {
277         require(_agonId < agonArray.length);
278         Agon storage agon = agonArray[_agonId];
279         require(agon.result == 0);
280         require(agon.master != msg.sender);
281         require(uint256(agon.agonPrice) == msg.value);
282         require(agon.challenger == address(0));
283 
284         agon.challenger = msg.sender;
285         agon.agonFlag = _flag;
286         ChallengeAgon(_agonId, agon.master, agon.outFlag, msg.sender);
287     }
288 
289     function fightAgon(uint64 _agonId, uint64 _mFlag, uint256 _aSeed, uint256 _fSeed) external onlyService {
290         require(_agonId < agonArray.length);
291         Agon storage agon = agonArray[_agonId];
292         require(agon.result == 0 && agon.challenger != address(0));
293         require(fightContract != address(0));
294         uint64 fRet = fightContract.calcFight(_mFlag, agon.agonFlag, _aSeed, _fSeed);
295         require(fRet == 1 || fRet == 2);
296         agon.result = fRet;
297         _removeAgonIdByOwner(agon.master, _agonId);
298         uint256 devCut = uint256(agon.agonPrice).div(10);
299         uint256 winVal = uint256(agon.agonPrice).mul(2).sub(devCut);
300         if (fRet == 1) {
301             agon.master.transfer(winVal);
302         } else {
303             agon.challenger.transfer(winVal);
304         }
305         if (poolContract != address(0)) {
306             uint256 pVal = devCut.div(2);
307             poolContract.transfer(pVal);
308             addrFinance.transfer(devCut.sub(pVal));
309         } else {
310             addrFinance.transfer(devCut);
311         }
312         ResolveAgon(_agonId, agon.master, agon.outFlag, agon.challenger);
313     }
314 
315     function getAgon(uint256 _agonId) external view
316         returns(
317             address master,
318             address challenger,
319             uint64 agonPrice,
320             uint64 outFlag,
321             uint64 agonFlag,
322             uint64 result
323         )
324     {
325         require(_agonId < agonArray.length);
326         Agon memory agon = agonArray[_agonId];
327         master = agon.master;
328         challenger = agon.challenger;
329         agonPrice = agon.agonPrice;
330         outFlag = agon.outFlag;
331         agonFlag = agon.agonFlag;
332         result = agon.result;
333     }
334 
335     function getAgonArray(uint64 _startAgonId, uint64 _count) external view
336         returns(
337             uint64[] agonIds,
338             address[] masters,
339             address[] challengers,
340             uint64[] agonPrices,           
341             uint64[] agonOutFlags,
342             uint64[] agonFlags,
343             uint64[] results
344         ) 
345     {
346         uint64 length = uint64(agonArray.length);
347         require(_startAgonId < length);
348         require(_startAgonId > 0);
349         uint256 maxLen;
350         if (_count == 0) {
351             maxLen = length - _startAgonId;
352         } else {
353             maxLen = (length - _startAgonId) >= _count ? _count : (length - _startAgonId);
354         }
355         agonIds = new uint64[](maxLen);
356         masters = new address[](maxLen);
357         challengers = new address[](maxLen);
358         agonPrices = new uint64[](maxLen);
359         agonOutFlags = new uint64[](maxLen);
360         agonFlags = new uint64[](maxLen);
361         results = new uint64[](maxLen);
362         uint256 counter = 0;
363         for (uint64 i = _startAgonId; i < length; ++i) {
364             Agon storage tmpAgon = agonArray[i];
365             agonIds[counter] = i;
366             masters[counter] = tmpAgon.master;
367             challengers[counter] = tmpAgon.challenger;
368             agonPrices[counter] = tmpAgon.agonPrice;
369             agonOutFlags[counter] = tmpAgon.outFlag;
370             agonFlags[counter] = tmpAgon.agonFlag;
371             results[counter] = tmpAgon.result;
372             counter += 1;
373             if (counter >= maxLen) {
374                 break;
375             }
376         }
377     }
378 
379     function getMaxAgonId() external view returns(uint256) {
380         return agonArray.length - 1;
381     }
382 
383     function getAgonIdArray(address _owner) external view returns(uint64[]) {
384         return ownerToAgonIdArray[_owner];
385     }
386 }