1 pragma solidity ^0.4.18;
2 
3 
4 library SafeMath {
5 
6   /**
7   * @dev Multiplies two numbers, throws on overflow.
8   */
9   function mul(uint256 a, uint256 b) internal pure returns (uint256) {
10     if (a == 0) {
11       return 0;
12     }
13     uint256 c = a * b;
14     assert(c / a == b);
15     return c;
16   }
17 
18   /**
19   * @dev Integer division of two numbers, truncating the quotient.
20   */
21   function div(uint256 a, uint256 b) internal pure returns (uint256) {
22     // assert(b > 0); // Solidity automatically throws when dividing by 0
23     uint256 c = a / b;
24     // assert(a == b * c + a % b); // There is no case in which this doesn't hold
25     return c;
26   }
27 
28   /**
29   * @dev Substracts two numbers, throws on overflow (i.e. if subtrahend is greater than minuend).
30   */
31   function sub(uint256 a, uint256 b) internal pure returns (uint256) {
32     assert(b <= a);
33     return a - b;
34   }
35 
36   /**
37   * @dev Adds two numbers, throws on overflow.
38   */
39   function add(uint256 a, uint256 b) internal pure returns (uint256) {
40     uint256 c = a + b;
41     assert(c >= a);
42     return c;
43   }
44 }
45 
46 
47 
48 contract ERC721 {
49   event Transfer(address indexed _from, address indexed _to, uint256 _tokenId);
50   event Approval(address indexed _owner, address indexed _approved, uint256 _tokenId);
51 
52   function balanceOf(address _owner) public view returns (uint256 _balance);
53   function ownerOf(uint256 _tokenId) public view returns (address _owner);
54   function transfer(address _to, uint256 _tokenId) public;
55   function approve(address _to, uint256 _tokenId) public;
56   function takeOwnership(uint256 _tokenId) public;
57 }
58 
59 
60 
61 contract ERC721Token is ERC721 {
62   using SafeMath for uint256;
63 
64   // Total amount of tokens
65   uint256 private totalTokens;
66 
67   // Mapping from token ID to owner
68   mapping (uint256 => address) private tokenOwner;
69 
70   // Mapping from token ID to approved address
71   mapping (uint256 => address) private tokenApprovals;
72 
73   // Mapping from owner to list of owned token IDs
74   mapping (address => uint256[]) private ownedTokens;
75 
76   // Mapping from token ID to index of the owner tokens list
77   mapping(uint256 => uint256) private ownedTokensIndex;
78 
79   /**
80   * @dev Guarantees msg.sender is owner of the given token
81   * @param _tokenId uint256 ID of the token to validate its ownership belongs to msg.sender
82   */
83   modifier onlyOwnerOf(uint256 _tokenId) {
84     require(ownerOf(_tokenId) == msg.sender);
85     _;
86   }
87 
88   /**
89   * @dev Gets the total amount of tokens stored by the contract
90   * @return uint256 representing the total amount of tokens
91   */
92   function totalSupply() public view returns (uint256) {
93     return totalTokens;
94   }
95 
96   /**
97   * @dev Gets the balance of the specified address
98   * @param _owner address to query the balance of
99   * @return uint256 representing the amount owned by the passed address
100   */
101   function balanceOf(address _owner) public view returns (uint256) {
102     return ownedTokens[_owner].length;
103   }
104 
105   /**
106   * @dev Gets the list of tokens owned by a given address
107   * @param _owner address to query the tokens of
108   * @return uint256[] representing the list of tokens owned by the passed address
109   */
110   function tokensOf(address _owner) public view returns (uint256[]) {
111     return ownedTokens[_owner];
112   }
113 
114   /**
115   * @dev Gets the owner of the specified token ID
116   * @param _tokenId uint256 ID of the token to query the owner of
117   * @return owner address currently marked as the owner of the given token ID
118   */
119   function ownerOf(uint256 _tokenId) public view returns (address) {
120     address owner = tokenOwner[_tokenId];
121     require(owner != address(0));
122     return owner;
123   }
124 
125   /**
126    * @dev Gets the approved address to take ownership of a given token ID
127    * @param _tokenId uint256 ID of the token to query the approval of
128    * @return address currently approved to take ownership of the given token ID
129    */
130   function approvedFor(uint256 _tokenId) public view returns (address) {
131     return tokenApprovals[_tokenId];
132   }
133 
134   /**
135   * @dev Transfers the ownership of a given token ID to another address
136   * @param _to address to receive the ownership of the given token ID
137   * @param _tokenId uint256 ID of the token to be transferred
138   */
139   function transfer(address _to, uint256 _tokenId) public onlyOwnerOf(_tokenId) {
140     clearApprovalAndTransfer(msg.sender, _to, _tokenId);
141   }
142 
143   /**
144   * @dev Approves another address to claim for the ownership of the given token ID
145   * @param _to address to be approved for the given token ID
146   * @param _tokenId uint256 ID of the token to be approved
147   */
148   function approve(address _to, uint256 _tokenId) public onlyOwnerOf(_tokenId) {
149     address owner = ownerOf(_tokenId);
150     require(_to != owner);
151     if (approvedFor(_tokenId) != 0 || _to != 0) {
152       tokenApprovals[_tokenId] = _to;
153       Approval(owner, _to, _tokenId);
154     }
155   }
156 
157   /**
158   * @dev Claims the ownership of a given token ID
159   * @param _tokenId uint256 ID of the token being claimed by the msg.sender
160   */
161   function takeOwnership(uint256 _tokenId) public {
162     require(isApprovedFor(msg.sender, _tokenId));
163     clearApprovalAndTransfer(ownerOf(_tokenId), msg.sender, _tokenId);
164   }
165 
166   /**
167   * @dev Mint token function
168   * @param _to The address that will own the minted token
169   * @param _tokenId uint256 ID of the token to be minted by the msg.sender
170   */
171   function _mint(address _to, uint256 _tokenId) internal {
172     require(_to != address(0));
173     addToken(_to, _tokenId);
174     Transfer(0x0, _to, _tokenId);
175   }
176 
177   /**
178   * @dev Burns a specific token
179   * @param _tokenId uint256 ID of the token being burned by the msg.sender
180   */
181   function _burn(uint256 _tokenId) onlyOwnerOf(_tokenId) internal {
182     if (approvedFor(_tokenId) != 0) {
183       clearApproval(msg.sender, _tokenId);
184     }
185     removeToken(msg.sender, _tokenId);
186     Transfer(msg.sender, 0x0, _tokenId);
187   }
188 
189   /**
190    * @dev Tells whether the msg.sender is approved for the given token ID or not
191    * This function is not private so it can be extended in further implementations like the operatable ERC721
192    * @param _owner address of the owner to query the approval of
193    * @param _tokenId uint256 ID of the token to query the approval of
194    * @return bool whether the msg.sender is approved for the given token ID or not
195    */
196   function isApprovedFor(address _owner, uint256 _tokenId) internal view returns (bool) {
197     return approvedFor(_tokenId) == _owner;
198   }
199 
200   /**
201   * @dev Internal function to clear current approval and transfer the ownership of a given token ID
202   * @param _from address which you want to send tokens from
203   * @param _to address which you want to transfer the token to
204   * @param _tokenId uint256 ID of the token to be transferred
205   */
206   function clearApprovalAndTransfer(address _from, address _to, uint256 _tokenId) internal {
207     require(_to != address(0));
208     require(_to != ownerOf(_tokenId));
209     require(ownerOf(_tokenId) == _from);
210 
211     clearApproval(_from, _tokenId);
212     removeToken(_from, _tokenId);
213     addToken(_to, _tokenId);
214     Transfer(_from, _to, _tokenId);
215   }
216 
217   /**
218   * @dev Internal function to clear current approval of a given token ID
219   * @param _tokenId uint256 ID of the token to be transferred
220   */
221   function clearApproval(address _owner, uint256 _tokenId) private {
222     require(ownerOf(_tokenId) == _owner);
223     tokenApprovals[_tokenId] = 0;
224     Approval(_owner, 0, _tokenId);
225   }
226 
227   /**
228   * @dev Internal function to add a token ID to the list of a given address
229   * @param _to address representing the new owner of the given token ID
230   * @param _tokenId uint256 ID of the token to be added to the tokens list of the given address
231   */
232   function addToken(address _to, uint256 _tokenId) private {
233     require(tokenOwner[_tokenId] == address(0));
234     tokenOwner[_tokenId] = _to;
235     uint256 length = balanceOf(_to);
236     ownedTokens[_to].push(_tokenId);
237     ownedTokensIndex[_tokenId] = length;
238     totalTokens = totalTokens.add(1);
239   }
240 
241   /**
242   * @dev Internal function to remove a token ID from the list of a given address
243   * @param _from address representing the previous owner of the given token ID
244   * @param _tokenId uint256 ID of the token to be removed from the tokens list of the given address
245   */
246   function removeToken(address _from, uint256 _tokenId) private {
247     require(ownerOf(_tokenId) == _from);
248 
249     uint256 tokenIndex = ownedTokensIndex[_tokenId];
250     uint256 lastTokenIndex = balanceOf(_from).sub(1);
251     uint256 lastToken = ownedTokens[_from][lastTokenIndex];
252 
253     tokenOwner[_tokenId] = 0;
254     ownedTokens[_from][tokenIndex] = lastToken;
255     ownedTokens[_from][lastTokenIndex] = 0;
256     // Note that this will handle single-element arrays. In that case, both tokenIndex and lastTokenIndex are going to
257     // be zero. Then we can make sure that we will remove _tokenId from the ownedTokens list since we are first swapping
258     // the lastToken to the first position, and then dropping the element placed in the last position of the list
259 
260     ownedTokens[_from].length--;
261     ownedTokensIndex[_tokenId] = 0;
262     ownedTokensIndex[lastToken] = tokenIndex;
263     totalTokens = totalTokens.sub(1);
264   }
265 }
266 
267 
268 
269 
270 
271 contract CommonEth {
272 
273     //模式
274     enum  Modes {LIVE, TEST}
275 
276     //合约当前模式
277     Modes public mode = Modes.LIVE;
278 
279     //管理人员列表
280     address internal ceoAddress;
281     address internal cfoAddress;
282     address internal cooAddress;
283 
284 
285     address public newContractAddress;
286 
287     event ContractUpgrade(address newContract);
288 
289     function setNewAddress(address _v2Address) external onlyCEO {
290         newContractAddress = _v2Address;
291         ContractUpgrade(_v2Address);
292     }
293 
294 
295     //构造
296     function CommonEth() public {
297         ceoAddress = msg.sender;
298     }
299 
300     modifier onlyCEO() {
301         require(msg.sender == ceoAddress);
302         _;
303     }
304 
305     modifier onlyCFO() {
306         require(msg.sender == cfoAddress);
307         _;
308     }
309 
310     modifier onlyCOO() {
311         require(msg.sender == cooAddress);
312         _;
313     }
314 
315     modifier onlyStaff() {
316         require(msg.sender == ceoAddress || msg.sender == cooAddress || msg.sender == cfoAddress);
317         _;
318     }
319 
320     modifier onlyManger() {
321         require(msg.sender == ceoAddress || msg.sender == cooAddress || msg.sender == cfoAddress);
322         _;
323     }
324 
325     //合约状态检查：live状态、管理员或者测试人员不受限制
326     modifier onlyLiveMode() {
327         require(mode == Modes.LIVE || msg.sender == ceoAddress || msg.sender == cooAddress || msg.sender == cfoAddress);
328         _;
329     }
330 
331     //获取自己的身份
332     function staffInfo() public view onlyStaff returns (bool ceo, bool coo, bool cfo, bool qa){
333         return (msg.sender == ceoAddress, msg.sender == cooAddress, msg.sender == cfoAddress,false);
334     }
335 
336 
337     //进入测试模式
338     function stopLive() public onlyCOO {
339         mode = Modes.TEST;
340     }
341 
342     //开启LIVE模式式
343     function startLive() public onlyCOO {
344         mode = Modes.LIVE;
345     }
346 
347     function getMangers() public view onlyManger returns (address _ceoAddress, address _cooAddress, address _cfoAddress){
348         return (ceoAddress, cooAddress, cfoAddress);
349     }
350 
351     function setCEO(address _newCEO) public onlyCEO {
352         require(_newCEO != address(0));
353         ceoAddress = _newCEO;
354     }
355 
356     function setCFO(address _newCFO) public onlyCEO {
357         require(_newCFO != address(0));
358         cfoAddress = _newCFO;
359     }
360 
361     function setCOO(address _newCOO) public onlyCEO {
362         require(_newCOO != address(0));
363         cooAddress = _newCOO;
364     }
365 
366 
367 
368 }
369 
370 
371 
372 contract NFToken is ERC721Token, CommonEth {
373     //TOKEN结构
374     struct TokenModel {
375         uint id;//id
376         string serial;//编号
377         uint createTime;
378         uint price;//当前价格
379         uint lastTime;
380         uint openTime;
381     }
382 
383     //所有tokens
384     mapping(uint => TokenModel)  tokens;
385     mapping(string => uint)  idOfSerial;
386 
387     //每次交易后价格上涨
388     uint RISE_RATE = 110;
389     uint RISE_RATE_FAST = 150;
390     //平台抽成
391     uint8 SALE_FEE_RATE = 2;
392 
393     //瓜分活动投入
394     uint CARVE_UP_INPUT = 0.01 ether;
395     //瓜分票
396     uint[10] carveUpTokens = [0, 0, 0, 0, 0, 0, 0, 0, 0, 0];
397     uint8 carverUpIndex = 0;
398 
399     function NFToken() {
400         setCFO(msg.sender);
401         setCOO(msg.sender);
402     }
403 
404     //默认方法
405     function() external payable {
406 
407     }
408 
409     //交易分红
410     event TransferBonus(address indexed _to, uint256 _tokenId, uint _bonus);
411     //未交易卡更新
412     event UnsoldUpdate(uint256 indexed _tokenId, uint price, uint openTime);
413     //加入瓜分
414     event JoinCarveUp(address indexed _account, uint _tokenId, uint _input);
415     //瓜分分红
416     event CarveUpBonus(address indexed _account, uint _tokenId, uint _bonus);
417     //event CarveUpDone(uint _t, uint _t0, uint _t1, uint _t2, uint _t3, uint _t4, uint _t5, uint _t6, uint _t7, uint _t8, uint _t9);
418 
419     //加入瓜分活动
420     function joinCarveUpTen(uint _tokenId) public payable onlyLiveMode onlyOwnerOf(_tokenId) returns (bool){
421         //确认投入金额
422         require(msg.value == CARVE_UP_INPUT);
423         //确认 这张卡的本轮只用一次
424         for (uint8 i = 0; i < carverUpIndex; i++) {
425             require(carveUpTokens[i] != _tokenId);
426         }
427         //按当前索引进入队列
428         carveUpTokens[carverUpIndex] = _tokenId;
429 
430         //日志&事件
431         JoinCarveUp(msg.sender, _tokenId, msg.value);
432         //第10人出现,结算了
433         if (carverUpIndex % 10 == 9) {
434             //索引归0
435             carverUpIndex = 0;
436             uint theLoserIndex = (now % 10 + (now / 10 % 10) + (now / 100 % 10) + (now / 1000 % 10)) % 10;
437             for (uint8 j = 0; j < 10; j++) {
438                 if (j != theLoserIndex) {
439                     uint bonus = CARVE_UP_INPUT * 110 / 100;
440                     ownerOf(carveUpTokens[j]).transfer(bonus);
441                     CarveUpBonus(ownerOf(carveUpTokens[j]), carveUpTokens[j], bonus);
442                 }else{
443                     CarveUpBonus(ownerOf(carveUpTokens[j]), carveUpTokens[j], 0);
444                 }
445             }
446             //日志&事件
447             //CarveUpDone(theLoserIndex, carveUpTokens[0], carveUpTokens[1], carveUpTokens[2], carveUpTokens[3], carveUpTokens[4], carveUpTokens[5], carveUpTokens[6], carveUpTokens[7], carveUpTokens[8], carveUpTokens[9]);
448             carveUpTokens = [0, 0, 0, 0, 0, 0, 0, 0, 0, 0];
449         } else {
450             carverUpIndex++;
451         }
452         return true;
453     }
454 
455     // 买入【其它人可以以等于或高于当前价格买入，交易过程平台收取交易价格抽成2%，每次交易后价格上涨】
456     function buy(uint _id) public payable onlyLiveMode returns (bool){
457         TokenModel storage token = tokens[_id];
458         require(token.price != 0);
459         require(token.openTime < now);
460         //检查价格
461         require(msg.value >= token.price);
462         //付钱给出让转
463         ownerOf(_id).transfer(token.price * (100 - 2 * SALE_FEE_RATE) / 100);
464         //给用户分成
465         if (totalSupply() > 1) {
466             uint bonus = token.price * SALE_FEE_RATE / 100 / (totalSupply() - 1);
467             for (uint i = 1; i <= totalSupply(); i++) {
468                 if (i != _id) {
469                     ownerOf(i).transfer(bonus);
470                     TransferBonus(ownerOf(i), i, bonus);
471                 }
472             }
473         }
474         //转让
475         clearApprovalAndTransfer(ownerOf(_id), msg.sender, _id);
476         //价格上涨
477         if (token.price < 1 ether) {
478             token.price = token.price * RISE_RATE_FAST / 100;
479         } else {
480             token.price = token.price * RISE_RATE / 100;
481         }
482         token.lastTime = now;
483         return true;
484     }
485 
486     //上架
487     function createByCOO(string serial, uint price, uint openTime) public onlyCOO returns (uint){
488         uint currentTime = now;
489         return __createNewToken(this, serial, currentTime, price, currentTime, openTime).id;
490     }
491 
492     //更新未出售中的token
493     function updateUnsold(string serial, uint _price, uint _openTime) public onlyCOO returns (bool){
494         require(idOfSerial[serial] > 0);
495         TokenModel storage token = tokens[idOfSerial[serial]];
496         require(token.lastTime == token.createTime);
497         token.price = _price;
498         token.openTime = _openTime;
499         UnsoldUpdate(token.id, token.price, token.openTime);
500         return true;
501     }
502 
503     //生成新的token
504     function __createNewToken(address _to, string serial, uint createTime, uint price, uint lastTime, uint openTime) private returns (TokenModel){
505         require(price > 0);
506         require(idOfSerial[serial] == 0);
507         uint id = totalSupply() + 1;
508         idOfSerial[serial] = id;
509         TokenModel memory s = TokenModel(id, serial, createTime, price, lastTime, openTime);
510         tokens[id] = s;
511         _mint(_to, id);
512         return s;
513     }
514 
515     //根据ID得详细
516     function getTokenById(uint _id) public view returns (uint id, string serial, uint createTime, uint price, uint lastTime, uint openTime, address owner)
517     {
518         return (tokens[_id].id, tokens[_id].serial, tokens[_id].createTime, tokens[_id].price, tokens[_id].lastTime, tokens[_id].openTime, ownerOf(_id));
519     }
520 
521     //获取瓜分游戏
522     function getCarveUpTokens() public view returns (uint[10]){
523         return carveUpTokens;
524     }
525 
526     //财务提现
527     function withdrawContractEther(uint withdrawAmount) public onlyCFO {
528         uint256 balance = this.balance;
529         require(balance - carverUpIndex * CARVE_UP_INPUT > withdrawAmount);
530         cfoAddress.transfer(withdrawAmount);
531     }
532 
533     //获取可提现金额
534     function withdrawAbleEther() public view onlyCFO returns (uint){
535         return this.balance - carverUpIndex * CARVE_UP_INPUT;
536     }
537 }