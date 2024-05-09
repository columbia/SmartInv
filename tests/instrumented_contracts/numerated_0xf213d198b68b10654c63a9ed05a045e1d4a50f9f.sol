1 pragma solidity ^0.4.17;
2 
3 /// @title Interface for contracts conforming to ERC-721: Non-Fungible Tokens
4 /// @author Dieter Shirley <dete@axiomzen.co> (https://github.com/dete)
5 contract ERC721 {
6     // Required methods
7     function implementsERC721() public pure returns (bool);
8     function totalSupply() public view returns (uint256 total);
9     function balanceOf(address _owner) public view returns (uint256 balance);
10     function ownerOf(uint256 _tokenId) external view returns (address owner);
11     function approve(address _to, uint256 _tokenId) external;
12     function transfer(address _to, uint256 _tokenId) public;
13     function transferFrom(address _from, address _to, uint256 _tokenId) external;
14 
15     // Events
16     event Transfer(address from, address to, uint256 tokenId);
17     event Approval(address owner, address approved, uint256 tokenId);
18     // Optional
19     // function name() public view returns (string name);
20     // function symbol() public view returns (string symbol);
21     // function tokensOfOwner(address _owner) external view returns (uint256[] tokenIds);
22     // function tokenMetadata(uint256 _tokenId, string _preferredTransport) public view returns (string infoUrl);
23 
24     // ERC-165 Compatibility (https://github.com/ethereum/EIPs/issues/165)
25     // function supportsInterface(bytes4 _interfaceID) external view returns (bool);
26 }
27 
28 contract FootballerAccessControl{
29 
30   ///@dev Emited when contract is upgraded
31   event ContractUpgrade(address newContract);
32   //The address of manager (the account or contracts) that can execute action within the role.
33   address public managerAddress;
34 
35   ///@dev keeps track whether the contract is paused.
36   bool public paused = false;
37 
38   function FootballerAccessControl() public {
39     managerAddress = msg.sender;
40   }
41 
42   /// @dev Access modifier for manager-only functionality
43   modifier onlyManager() {
44     require(msg.sender == managerAddress);
45     _;
46   }
47 
48   ///@dev assigns a new address to act as the Manager.Only available to the current Manager.
49   function setManager(address _newManager) external onlyManager {
50     require(_newManager != address(0));
51     managerAddress = _newManager;
52   }
53 
54   /*** Pausable functionality adapted from OpenZeppelin ***/
55 
56   /// @dev Modifier to allow actions only when the contract IS NOT paused
57   modifier whenNotPaused() {
58     require(!paused);
59     _;
60   }
61 
62   /// @dev Modifier to allow actions only when the contract IS paused
63   modifier whenPaused {
64       require(paused);
65       _;
66   }
67 
68   /// @dev Called by manager to pause the contract. Used only when
69   ///  a bug or exploit is detected and we need to limit damage.
70   function pause() external onlyManager whenNotPaused {
71     paused = true;
72   }
73 
74   /// @dev Unpauses the smart contract. Can only be called by the manager,
75   /// since one reason we may pause the contract is when manager accounts are compromised.
76   /// @notice This is public rather than external so it can be called by derived contracts.
77   function unpause() public onlyManager {
78     // can't unpause if contract was upgraded
79     paused = false;
80   }
81 
82 }
83 
84 contract FootballerBase is FootballerAccessControl {
85   using SafeMath for uint256;
86   /*** events ***/
87   event Create(address owner, uint footballerId);
88   event Transfer(address _from, address _to, uint256 tokenId);
89 
90   uint private randNonce = 0;
91 
92   //球员/球星 属性
93   struct footballer {
94     uint price; //球员-价格 ， 球星-一口价 单位wei
95     //球员的战斗属性
96     uint defend; //防御
97     uint attack; //进攻
98     uint quality; //素质
99   }
100 
101   //存球星和球员
102   footballer[] public footballers;
103   //将球员的id和球员的拥有者对应起来
104   mapping (uint256 => address) public footballerToOwner;
105 
106   //记录拥有者有多少球员，在balanceOf（）内部使用来解决所有权计数
107   mapping (address => uint256) public ownershipTokenCount;
108 
109   //从footballID 到 已批准调用transferFrom（）的地址的映射
110   //每个球员只能有一个批准的地址。零值表示没有批准
111   mapping (uint256 => address) public footballerToApproved;
112 
113   // 将特定球员的所有权 赋给 某个地址
114   function _transfer(address _from, address _to, uint256 _tokenId) internal {
115     footballerToApproved[_tokenId] = address(0);
116     ownershipTokenCount[_to] = ownershipTokenCount[_to].add(1);
117     footballerToOwner[_tokenId] = _to;
118     ownershipTokenCount[_from] = ownershipTokenCount[_from].sub(1);
119     emit Transfer(_from, _to, _tokenId);
120   }
121 
122   //管理员用于投放球星,和createStar函数一起使用，才能将球星完整信息保存起来
123   function _createFootballerStar(uint _price,uint _defend,uint _attack, uint _quality) internal onlyManager returns(uint) {
124       footballer memory _player = footballer({
125         price:_price,
126         defend:_defend,
127         attack:_attack,
128         quality:_quality
129       });
130       uint newFootballerId = footballers.push(_player) - 1;
131       footballerToOwner[newFootballerId] = managerAddress;
132       ownershipTokenCount[managerAddress] = ownershipTokenCount[managerAddress].add(1);
133       //记录这个球星可以进行交易
134       footballerToApproved[newFootballerId] = managerAddress;
135       require(newFootballerId == uint256(uint32(newFootballerId)));
136       emit Create(managerAddress, newFootballerId);
137       return newFootballerId;
138     }
139 
140 
141     //用于当用户买卡包时，随机生成球员
142     function createFootballer () internal returns (uint) {
143         footballer memory _player = footballer({
144           price: 0,
145           defend: _randMod(20,80),
146           attack: _randMod(20,80),
147           quality: _randMod(20,80)
148         });
149         uint newFootballerId = footballers.push(_player) - 1;
150       //  require(newFootballerId == uint256(uint32(newFootballerId)));
151         footballerToOwner[newFootballerId] = msg.sender;
152         ownershipTokenCount[msg.sender] =ownershipTokenCount[msg.sender].add(1);
153         emit Create(msg.sender, newFootballerId);
154         return newFootballerId;
155     }
156 
157   // 生成一个从 _min 到 _max 范围内的随机数（不包括 _max）
158   function _randMod(uint _min, uint _max) private returns(uint) {
159       randNonce++;
160       uint modulus = _max - _min;
161       return uint(keccak256(now, msg.sender, randNonce)) % modulus + _min;
162   }
163 
164 }
165 
166 contract FootballerOwnership is FootballerBase, ERC721 {
167   /// @notice Name and symbol of the non fungible token, as defined in ERC721.
168   string public constant name = "CyptoWorldCup";
169   string public constant symbol = "CWC";
170 
171 
172   function implementsERC721() public pure returns (bool) {
173     return true;
174   }
175 
176   //判断一个给定的地址是不是现在某个球员的拥有者
177   function _owns(address _claimant, uint256 _tokenId) internal view returns (bool) {
178     return footballerToOwner[_tokenId] == _claimant;
179   }
180 
181   //判断一个给定的地址现在对于某个球员 是不是有 transferApproval
182   function _approvedFor(address _claimant, uint256 _tokenId) internal view returns (bool) {
183     return footballerToApproved[_tokenId] == _claimant;
184   }
185 
186   //给某地址的用户 对 球员有transfer的权利
187   function _approve(uint256 _tokenId, address _approved) internal {
188       footballerToApproved[_tokenId] = _approved;
189   }
190 
191   //返回 owner 拥有的球员数
192   function balanceOf(address _owner) public view returns (uint256 count) {
193     return ownershipTokenCount[_owner];
194   }
195 
196   //转移 球员 给 另一个地址
197   function transfer(address _to, uint256 _tokenId) public whenNotPaused {
198     require(_to != address(0));
199     require(_to != address(this));
200     //只能send自己的球员
201     require(_owns(msg.sender, _tokenId));
202     //重新分配所有权，清除待批准 approvals ，发出转移事件
203     _transfer(msg.sender, _to, _tokenId);
204   }
205 
206   //授予另一个地址通过transferFrom（）转移特定球员的权利。
207   function approve(address _to, uint256 _tokenId) external whenNotPaused {
208     //只有球员的拥有者才有资格决定要把这个权利给谁
209     require(_owns(msg.sender, _tokenId));
210     _approve(_tokenId, _to);
211     emit Approval(msg.sender, _to, _tokenId);
212   }
213 
214   //转让由另一个地址所拥有的球员，该地址之前已经获得所有者的转让批准
215   function transferFrom(address _from, address _to, uint256 _tokenId) external whenNotPaused {
216     require(_to != address(0));
217     //不允许转让本合同以防止意外滥用。
218     // 合约不应该拥有任何球员（除非 在创建球星之后并且在拍卖之前 非常短）。
219     require(_to != address(this));
220     require(_approvedFor(msg.sender, _tokenId));
221     require(_owns(_from, _tokenId));
222     //该函数定义在FootballerBase
223     _transfer(_from, _to, _tokenId);
224   }
225 
226   //返回现在一共有多少（球员+球星）
227   function totalSupply() public view returns (uint) {
228     return footballers.length;
229   }
230 
231   //返回该特定球员的拥有者的地址
232   function ownerOf(uint256 _tokenId) external view returns (address owner) {
233     owner = footballerToOwner[_tokenId];
234     require(owner != address(0));
235   }
236 
237   //返回该地址的用户拥有的球员的id
238   function tokensOfOwner(address _owner) external view returns(uint256[] ownerTokens) {
239     uint256 tokenCount = balanceOf(_owner);
240     if(tokenCount == 0) {
241       return new uint256[](0);
242     } else {
243       uint256[] memory result = new uint256[](tokenCount);
244       uint256 totalpalyers = totalSupply();
245       uint256 resultIndex = 0;
246       uint256 footballerId;
247       for (footballerId = 0; footballerId < totalpalyers; footballerId++) {
248         if(footballerToOwner[footballerId] == _owner) {
249           result[resultIndex] = footballerId;
250           resultIndex++;
251         }
252       }
253       return result;
254     }
255   }
256 }
257 
258 contract FootballerAction is FootballerOwnership {
259   //创建球星
260   function createFootballerStar(uint _price,uint _defend,uint _attack, uint _quality) public returns(uint) {
261       return _createFootballerStar(_price,_defend,_attack,_quality);
262   }
263 
264   //抽卡包得球星
265   function CardFootballers() public payable returns (uint) {
266       uint price = 4000000000000 wei; //0.04 eth
267       require(msg.value >= price);
268       uint ballerCount = 14;
269       uint newFootballerId = 0;
270       for (uint i = 0; i < ballerCount; i++) {
271          newFootballerId = createFootballer();
272       }
273       managerAddress.transfer(msg.value);
274       return price;
275   }
276 
277   function buyStar(uint footballerId,uint price) public payable  {
278     require(msg.value >= price);
279     //将球星的拥有权 交给 购买的用户
280     address holder = footballerToApproved[footballerId];
281     require(holder != address(0));
282     _transfer(holder,msg.sender,footballerId);
283     //给卖家转钱
284     holder.transfer(msg.value);
285   }
286 
287   //用户出售自己拥有的球员或球星
288   function sell(uint footballerId,uint price) public returns(uint) {
289     require(footballerToOwner[footballerId] == msg.sender);
290     require(footballerToApproved[footballerId] == address(0));
291     footballerToApproved[footballerId] = msg.sender;
292     footballers[footballerId].price = price;
293   }
294 
295   //显示球队
296   function getTeamBallers(address actor) public view returns (uint[]) {
297     uint len = footballers.length;
298     uint count=0;
299     for(uint i = 0; i < len; i++) {
300         if(_owns(actor, i)){
301           if(footballerToApproved[i] == address(0)){
302             count++;
303           }
304        }
305     }
306     uint[] memory res = new uint256[](count);
307     uint index = 0;
308     for(i = 0; i < len; i++) {
309       if(_owns(actor, i)){
310           if(footballerToApproved[i] == address(0)){
311             res[index] = i;
312             index++;
313           }
314         }
315     }
316     return res;
317   }
318 
319   //显示出售的球星+球员
320   function getSellBallers() public view returns (uint[]) {
321     uint len = footballers.length;
322     uint count = 0;
323     for(uint i = 0; i < len; i++) {
324         if(footballerToApproved[i] != address(0)){
325           count++;
326         }
327     }
328     uint[] memory res = new uint256[](count);
329     uint index = 0;
330     for( i = 0; i < len; i++) {
331         if(footballerToApproved[i] != address(0)){
332           res[index] = i;
333           index++;
334         }
335     }
336     return res;
337   }
338 
339   //获得球员+球星的总数量
340   function getAllBaller() public view returns (uint) {
341     uint len = totalSupply();
342     return len;
343   }
344 
345 }
346 
347 library SafeMath {
348     /**
349     * @dev Multiplies two numbers, throws on overflow.
350     */
351     function mul(uint256 a, uint256 b) internal pure returns (uint256) {
352         if (a == 0) {
353             return 0;
354         }
355         uint256 c = a * b;
356         assert(c / a == b);
357         return c;
358     }
359 
360 
361     /**
362     * @dev Integer division of two numbers, truncating the quotient.
363     */
364     function div(uint256 a, uint256 b) internal pure returns (uint256) {
365         // assert(b > 0); // Solidity automatically throws when dividing by 0
366         uint256 c = a / b;
367         // assert(a == b * c + a % b); // There is no case in which this doesn't hold
368         return c;
369     }
370 
371     /**
372     * @dev Substracts two numbers, throws on overflow (i.e. if subtrahend is greater than minuend).
373     */
374     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
375         assert(b <= a);
376         return a - b;
377     }
378 
379     /**
380     * @dev Adds two numbers, throws on overflow.
381     */
382     function add(uint256 a, uint256 b) internal pure returns (uint256) {
383         uint256 c = a + b;
384         assert(c >= a);
385         return c;
386     }
387 }