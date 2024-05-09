1 /* ==================================================================== */
2 /* Copyright (c) 2018 The TokenTycoon Project.  All rights reserved.
3 /* 
4 /* https://tokentycoon.io
5 /*  
6 /* authors rickhunter.shen@gmail.com   
7 /*         ssesunding@gmail.com            
8 /* ==================================================================== */
9 
10 pragma solidity ^0.4.23;
11 
12 contract AccessAdmin {
13     bool public isPaused = false;
14     address public addrAdmin;  
15 
16     event AdminTransferred(address indexed preAdmin, address indexed newAdmin);
17 
18     constructor() public {
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
40         emit AdminTransferred(addrAdmin, _newAdmin);
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
53 contract AccessService is AccessAdmin {
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
67     function setService(address _newService) external {
68         require(msg.sender == addrService || msg.sender == addrAdmin);
69         require(_newService != address(0));
70         addrService = _newService;
71     }
72 
73     function setFinance(address _newFinance) external {
74         require(msg.sender == addrFinance || msg.sender == addrAdmin);
75         require(_newFinance != address(0));
76         addrFinance = _newFinance;
77     }
78 
79     function withdraw(address _target, uint256 _amount) 
80         external 
81     {
82         require(msg.sender == addrFinance || msg.sender == addrAdmin);
83         require(_amount > 0);
84         address receiver = _target == address(0) ? addrFinance : _target;
85         uint256 balance = address(this).balance;
86         if (_amount < balance) {
87             receiver.transfer(_amount);
88         } else {
89             receiver.transfer(address(this).balance);
90         }      
91     }
92 }
93 
94 interface WarTokenInterface {
95     function getFashion(uint256 _tokenId) external view returns(uint16[12]);
96     function ownerOf(uint256 _tokenId) external view returns (address);
97     function safeTransferByContract(uint256 _tokenId, address _to) external;
98 } 
99 
100 interface WonderTokenInterface {
101     function transferFrom(address _from, address _to, uint256 _tokenId) external;
102     function safeGiveByContract(uint256 _tokenId, address _to) external;
103     function getProtoIdByTokenId(uint256 _tokenId) external view returns(uint256); 
104 }
105 
106 interface ManagerTokenInterface {
107     function transferFrom(address _from, address _to, uint256 _tokenId) external;
108     function safeGiveByContract(uint256 _tokenId, address _to) external;
109     function getProtoIdByTokenId(uint256 _tokenId) external view returns(uint256);
110 }
111 
112 interface TalentCardInterface {
113     function safeSendCard(uint256 _amount, address _to) external;
114 }
115 
116 interface ERC20BaseInterface {
117     function balanceOf(address _from) external view returns(uint256);
118     function transfer(address _to, uint256 _value) external;
119     function transferFrom(address _from, address _to, uint256 _value) external returns (bool);
120     function approve(address _spender, uint256 _value) external; 
121 }
122 
123 contract TTCInterface is ERC20BaseInterface {
124     function approveAndCall(address _spender, uint256 _value, bytes _extraData) external returns (bool);
125 }
126 
127 contract TTPresale is AccessService {
128     TTCInterface ttcToken;
129     WarTokenInterface warToken;
130     ManagerTokenInterface ttmToken;
131     WonderTokenInterface ttwToken;
132 
133     event ManagerSold(
134         address indexed buyer,
135         address indexed buyTo,
136         uint256 mgrId,
137         uint256 nextTokenId
138     );
139 
140     event WonderSold(
141         address indexed buyer,
142         address indexed buyTo,
143         uint256 wonderId,
144         uint256 nextTokenId
145     );
146 
147     constructor() public {
148         addrAdmin = msg.sender;
149         addrFinance = msg.sender;
150         addrService = msg.sender;
151 
152         ttcToken = TTCInterface(0xfB673F08FC82807b4D0E139e794e3b328d63551f);
153         warToken = WarTokenInterface(0xDA9c03dFd4D137F926c3cF6953cb951832Eb08b2);
154     }
155 
156     function() external payable {
157 
158     }
159 
160     uint64 public nextDiscountTTMTokenId1 = 1;      // ManagerId: 1, tokenId:   1~50
161     uint64 public nextDiscountTTMTokenId6 = 361;    // ManagerId: 6, tokenId: 361~390
162     uint64 public nextCommonTTMTokenId2 = 51;       // ManagerId: 2, tokenId:  51~130
163     uint64 public nextCommonTTMTokenId3 = 131;      // ManagerId: 3, tokenId: 131~210
164     uint64 public nextCommonTTMTokenId7 = 391;      // ManagerId: 7, tokenId: 391~450
165     uint64 public nextCommonTTMTokenId8 = 451;      // ManagerId: 8, tokenId: 451~510
166     uint64 public nextDiscountTTWTokenId1 = 1;      // WonderId:  1, tokenId:   1~30
167     uint64 public nextCommonTTWTokenId2 = 31;       // WonderId:  2, tokenId:  31-90
168 
169     function setNextDiscountTTMTokenId1(uint64 _val) external onlyAdmin {
170         require(nextDiscountTTMTokenId1 >= 1 && nextDiscountTTMTokenId1 <= 51);
171         nextDiscountTTMTokenId1 = _val;
172     }
173 
174     function setNextDiscountTTMTokenId6(uint64 _val) external onlyAdmin {
175         require(nextDiscountTTMTokenId6 >= 361 && nextDiscountTTMTokenId6 <= 391);
176         nextDiscountTTMTokenId6 = _val;
177     }
178 
179     function setNextCommonTTMTokenId2(uint64 _val) external onlyAdmin {
180         require(nextCommonTTMTokenId2 >= 51 && nextCommonTTMTokenId2 <= 131);
181         nextCommonTTMTokenId2 = _val;
182     }
183 
184     function setNextCommonTTMTokenId3(uint64 _val) external onlyAdmin {
185         require(nextCommonTTMTokenId3 >= 131 && nextCommonTTMTokenId3 <= 211);
186         nextCommonTTMTokenId3 = _val;
187     }
188 
189     function setNextCommonTTMTokenId7(uint64 _val) external onlyAdmin {
190         require(nextCommonTTMTokenId7 >= 391 && nextCommonTTMTokenId7 <= 451);
191         nextCommonTTMTokenId7 = _val;
192     }
193 
194     function setNextCommonTTMTokenId8(uint64 _val) external onlyAdmin {
195         require(nextCommonTTMTokenId8 >= 451 && nextCommonTTMTokenId8 <= 511);
196         nextCommonTTMTokenId8 = _val;
197     }
198 
199     function setNextDiscountTTWTokenId1(uint64 _val) external onlyAdmin {
200         require(nextDiscountTTWTokenId1 >= 1 && nextDiscountTTWTokenId1 <= 31);
201         nextDiscountTTWTokenId1 = _val;
202     }
203 
204     function setNextCommonTTWTokenId2(uint64 _val) external onlyAdmin {
205         require(nextCommonTTWTokenId2 >= 31 && nextCommonTTWTokenId2 <= 91);
206         nextCommonTTWTokenId2 = _val;
207     }
208 
209     uint64 public endDiscountTime = 0;
210 
211     function setDiscountTime(uint64 _endTime) external onlyAdmin {
212         require(_endTime > block.timestamp);
213         endDiscountTime = _endTime;
214     }
215 
216     function setWARTokenAddress(address _addr) external onlyAdmin {
217         require(_addr != address(0));
218         warToken = WarTokenInterface(_addr);
219     }
220 
221     function setTTMTokenAddress(address _addr) external onlyAdmin {
222         require(_addr != address(0));
223         ttmToken = ManagerTokenInterface(_addr);
224     }
225 
226     function setTTWTokenAddress(address _addr) external onlyAdmin {
227         require(_addr != address(0));
228         ttwToken = WonderTokenInterface(_addr);
229     }
230 
231     function setTTCTokenAddress(address _addr) external onlyAdmin {
232         require(_addr != address(0));
233         ttcToken = TTCInterface(_addr);
234     }
235 
236     function _getExtraParam(bytes _extraData) 
237         private 
238         pure
239         returns(address addr, uint64 f, uint256 protoId) 
240     {
241         assembly { addr := mload(add(_extraData, 20)) } 
242         f = uint64(_extraData[20]);
243         protoId = uint256(_extraData[21]) * 256 + uint256(_extraData[22]);
244     }
245 
246     function receiveApproval(address _sender, uint256 _value, address _token, bytes _extraData) 
247         external
248         whenNotPaused 
249     {
250         require(msg.sender == address(ttcToken));
251         require(_extraData.length == 23);
252         (address toAddr, uint64 f, uint256 protoId) = _getExtraParam(_extraData);
253         require(ttcToken.transferFrom(_sender, address(this), _value));
254         if (f == 0) {
255             _buyDiscountTTM(_value, protoId, toAddr, _sender);
256         } else if (f == 1) {
257             _buyDiscountTTW(_value, protoId, toAddr, _sender);
258         } else if (f == 2) {
259             _buyCommonTTM(_value, protoId, toAddr, _sender);
260         } else if (f == 3) {
261             _buyCommonTTW(_value, protoId, toAddr, _sender);
262         } else {
263             require(false, "Invalid func id");
264         }
265     }
266 
267     function exchangeByPet(uint256 _warTokenId, uint256 _mgrId, address _gameWalletAddr)  
268         external
269         whenNotPaused
270     {
271         require(warToken.ownerOf(_warTokenId) == msg.sender);
272         uint16[12] memory warData = warToken.getFashion(_warTokenId);
273         uint16 protoId = warData[0];
274         if (_mgrId == 2) {
275             require(protoId == 10001 || protoId == 10003);
276             require(nextCommonTTMTokenId2 <= 130);
277             warToken.safeTransferByContract(_warTokenId, address(this));
278             nextCommonTTMTokenId2 += 1;
279             ttmToken.safeGiveByContract(nextCommonTTMTokenId2 - 1, _gameWalletAddr);
280             emit ManagerSold(msg.sender, _gameWalletAddr, 2, nextCommonTTMTokenId2);
281         } else if (_mgrId == 3) {
282             require(protoId == 10001 || protoId == 10003);
283             require(nextCommonTTMTokenId3 <= 210);
284             warToken.safeTransferByContract(_warTokenId, address(this));
285             nextCommonTTMTokenId3 += 1;
286             ttmToken.safeGiveByContract(nextCommonTTMTokenId3 - 1, _gameWalletAddr);
287             emit ManagerSold(msg.sender, _gameWalletAddr, 3, nextCommonTTMTokenId3);
288         } else if (_mgrId == 7) {
289             require(protoId == 10002 || protoId == 10004 || protoId == 10005);
290             require(nextCommonTTMTokenId7 <= 450);
291             warToken.safeTransferByContract(_warTokenId, address(this));
292             nextCommonTTMTokenId7 += 1;
293             ttmToken.safeGiveByContract(nextCommonTTMTokenId7 - 1, _gameWalletAddr);
294             emit ManagerSold(msg.sender, _gameWalletAddr, 7, nextCommonTTMTokenId7);
295         } else if (_mgrId == 8) {
296             require(protoId == 10002 || protoId == 10004 || protoId == 10005);
297             require(nextCommonTTMTokenId8 <= 510);
298             warToken.safeTransferByContract(_warTokenId, address(this));
299             nextCommonTTMTokenId8 += 1;
300             ttmToken.safeGiveByContract(nextCommonTTMTokenId8 - 1, _gameWalletAddr);
301             emit ManagerSold(msg.sender, _gameWalletAddr, 8, nextCommonTTMTokenId8);
302         } else {
303             require(false);
304         }
305     }
306 
307     function buyDiscountTTMByETH(uint256 _mgrId, address _gameWalletAddr) 
308         external 
309         payable
310         whenNotPaused 
311     {
312         _buyDiscountTTM(msg.value, _mgrId, _gameWalletAddr, msg.sender);
313     }
314 
315     function buyDiscountTTWByETH(uint256 _wonderId, address _gameWalletAddr) 
316         external 
317         payable
318         whenNotPaused 
319     {
320         _buyDiscountTTW(msg.value, _wonderId, _gameWalletAddr, msg.sender);
321     }
322     
323     function buyCommonTTMByETH(uint256 _mgrId, address _gameWalletAddr) 
324         external
325         payable
326         whenNotPaused
327     {
328         _buyCommonTTM(msg.value, _mgrId, _gameWalletAddr, msg.sender);
329     }
330 
331     function buyCommonTTWByETH(uint256 _wonderId, address _gameWalletAddr) 
332         external
333         payable
334         whenNotPaused
335     {
336         _buyCommonTTW(msg.value, _wonderId, _gameWalletAddr, msg.sender);
337     }
338 
339     function _buyDiscountTTM(uint256 _value, uint256 _mgrId, address _gameWalletAddr, address _buyer) 
340         private  
341     {
342         require(_gameWalletAddr != address(0));
343         if (_mgrId == 1) {
344             require(nextDiscountTTMTokenId1 <= 50, "This Manager is sold out");
345             if (block.timestamp <= endDiscountTime) {
346                 require(_value == 0.64 ether);
347             } else {
348                 require(_value == 0.99 ether);
349             }
350             nextDiscountTTMTokenId1 += 1;
351             ttmToken.safeGiveByContract(nextDiscountTTMTokenId1 - 1, _gameWalletAddr);
352             emit ManagerSold(_buyer, _gameWalletAddr, 1, nextDiscountTTMTokenId1);
353         } else if (_mgrId == 6) {
354             require(nextDiscountTTMTokenId6 <= 390, "This Manager is sold out");
355             if (block.timestamp <= endDiscountTime) {
356                 require(_value == 0.97 ether);
357             } else {
358                 require(_value == 1.49 ether);
359             }
360             nextDiscountTTMTokenId6 += 1;
361             ttmToken.safeGiveByContract(nextDiscountTTMTokenId6 - 1, _gameWalletAddr);
362             emit ManagerSold(_buyer, _gameWalletAddr, 6, nextDiscountTTMTokenId6);
363         } else {
364             require(false);
365         }
366     }
367 
368     function _buyDiscountTTW(uint256 _value, uint256 _wonderId, address _gameWalletAddr, address _buyer) 
369         private 
370     {
371         require(_gameWalletAddr != address(0));
372         require(_wonderId == 1); 
373 
374         require(nextDiscountTTWTokenId1 <= 30, "This Manager is sold out");
375         if (block.timestamp <= endDiscountTime) {
376             require(_value == 0.585 ether);
377         } else {
378             require(_value == 0.90 ether);
379         }
380         nextDiscountTTWTokenId1 += 1;
381         ttwToken.safeGiveByContract(nextDiscountTTWTokenId1 - 1, _gameWalletAddr);
382         emit WonderSold(_buyer, _gameWalletAddr, 1, nextDiscountTTWTokenId1);
383     }
384     
385     function _buyCommonTTM(uint256 _value, uint256 _mgrId, address _gameWalletAddr, address _buyer) 
386         private
387     {
388         require(_gameWalletAddr != address(0));
389         if (_mgrId == 2) {
390             require(nextCommonTTMTokenId2 <= 130);
391             require(_value == 0.99 ether);
392             nextCommonTTMTokenId2 += 1;
393             ttmToken.safeGiveByContract(nextCommonTTMTokenId2 - 1, _gameWalletAddr);
394             emit ManagerSold(_buyer, _gameWalletAddr, 2, nextCommonTTMTokenId2);
395         } else if (_mgrId == 3) {
396             require(nextCommonTTMTokenId3 <= 210);
397             require(_value == 0.99 ether);
398             nextCommonTTMTokenId3 += 1;
399             ttmToken.safeGiveByContract(nextCommonTTMTokenId3 - 1, _gameWalletAddr);
400             emit ManagerSold(_buyer, _gameWalletAddr, 3, nextCommonTTMTokenId3);
401         } else if (_mgrId == 7) {
402             require(nextCommonTTMTokenId7 <= 450);
403             require(_value == 1.49 ether);
404             nextCommonTTMTokenId7 += 1;
405             ttmToken.safeGiveByContract(nextCommonTTMTokenId7 - 1, _gameWalletAddr);
406             emit ManagerSold(_buyer, _gameWalletAddr, 7, nextCommonTTMTokenId7);
407         } else if (_mgrId == 8) {
408             require(nextCommonTTMTokenId8 <= 510);
409             require(_value == 1.49 ether);
410             nextCommonTTMTokenId8 += 1;
411             ttmToken.safeGiveByContract(nextCommonTTMTokenId8 - 1, _gameWalletAddr);
412             emit ManagerSold(_buyer, _gameWalletAddr, 8, nextCommonTTMTokenId8);
413         } else {
414             require(false);
415         }
416     }
417 
418     function _buyCommonTTW(uint256 _value, uint256 _wonderId, address _gameWalletAddr, address _buyer) 
419         private
420     {
421         require(_gameWalletAddr != address(0));
422         require(_wonderId == 2); 
423         require(nextCommonTTWTokenId2 <= 90);
424         require(_value == 0.50 ether);
425         nextCommonTTWTokenId2 += 1;
426         ttwToken.safeGiveByContract(nextCommonTTWTokenId2 - 1, _gameWalletAddr);
427         emit WonderSold(_buyer, _gameWalletAddr, 2, nextCommonTTWTokenId2);
428     }
429 
430     function withdrawERC20(address _erc20, address _target, uint256 _amount)
431         external
432     {
433         require(msg.sender == addrFinance || msg.sender == addrAdmin);
434         require(_amount > 0);
435         address receiver = _target == address(0) ? addrFinance : _target;
436         ERC20BaseInterface erc20Contract = ERC20BaseInterface(_erc20);
437         uint256 balance = erc20Contract.balanceOf(address(this));
438         require(balance > 0);
439         if (_amount < balance) {
440             erc20Contract.transfer(receiver, _amount);
441         } else {
442             erc20Contract.transfer(receiver, balance);
443         }   
444     }
445 
446     function getPresaleInfo() 
447         external 
448         view 
449         returns(
450             uint64 ttmCnt1,
451             uint64 ttmCnt2,
452             uint64 ttmCnt3,
453             uint64 ttmCnt6,
454             uint64 ttmCnt7,
455             uint64 ttmCnt8,
456             uint64 ttwCnt1,
457             uint64 ttwCnt2,
458             uint64 discountEnd
459         )
460     {
461         ttmCnt1 = 51 - nextDiscountTTMTokenId1;
462         ttmCnt2 = 131 - nextCommonTTMTokenId2;
463         ttmCnt3 = 211 - nextCommonTTMTokenId3;
464         ttmCnt6 = 391 - nextDiscountTTMTokenId6;
465         ttmCnt7 = 451 - nextCommonTTMTokenId7;
466         ttmCnt8 = 511 - nextCommonTTMTokenId8;
467         ttwCnt1 = 31 - nextDiscountTTWTokenId1;
468         ttwCnt2 = 91 - nextCommonTTWTokenId2;
469         discountEnd = endDiscountTime;
470     }
471 }