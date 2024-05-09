1 pragma solidity ^0.4.16;
2 
3 // copyright contact@Etheremon.com
4 
5 contract SafeMath {
6 
7     /* function assert(bool assertion) internal { */
8     /*   if (!assertion) { */
9     /*     throw; */
10     /*   } */
11     /* }      // assert no longer needed once solidity is on 0.4.10 */
12 
13     function safeAdd(uint256 x, uint256 y) pure internal returns(uint256) {
14       uint256 z = x + y;
15       assert((z >= x) && (z >= y));
16       return z;
17     }
18 
19     function safeSubtract(uint256 x, uint256 y) pure internal returns(uint256) {
20       assert(x >= y);
21       uint256 z = x - y;
22       return z;
23     }
24 
25     function safeMult(uint256 x, uint256 y) pure internal returns(uint256) {
26       uint256 z = x * y;
27       assert((x == 0)||(z/x == y));
28       return z;
29     }
30 
31 }
32 
33 contract BasicAccessControl {
34     address public owner;
35     // address[] public moderators;
36     uint16 public totalModerators = 0;
37     mapping (address => bool) public moderators;
38     bool public isMaintaining = false;
39 
40     function BasicAccessControl() public {
41         owner = msg.sender;
42     }
43 
44     modifier onlyOwner {
45         require(msg.sender == owner);
46         _;
47     }
48 
49     modifier onlyModerators() {
50         require(msg.sender == owner || moderators[msg.sender] == true);
51         _;
52     }
53 
54     modifier isActive {
55         require(!isMaintaining);
56         _;
57     }
58 
59     function ChangeOwner(address _newOwner) onlyOwner public {
60         if (_newOwner != address(0)) {
61             owner = _newOwner;
62         }
63     }
64 
65 
66     function AddModerator(address _newModerator) onlyOwner public {
67         if (moderators[_newModerator] == false) {
68             moderators[_newModerator] = true;
69             totalModerators += 1;
70         }
71     }
72     
73     function RemoveModerator(address _oldModerator) onlyOwner public {
74         if (moderators[_oldModerator] == true) {
75             moderators[_oldModerator] = false;
76             totalModerators -= 1;
77         }
78     }
79 
80     function UpdateMaintaining(bool _isMaintaining) onlyOwner public {
81         isMaintaining = _isMaintaining;
82     }
83 }
84 
85 contract EtheremonEnum {
86 
87     enum ResultCode {
88         SUCCESS,
89         ERROR_CLASS_NOT_FOUND,
90         ERROR_LOW_BALANCE,
91         ERROR_SEND_FAIL,
92         ERROR_NOT_TRAINER,
93         ERROR_NOT_ENOUGH_MONEY,
94         ERROR_INVALID_AMOUNT,
95         ERROR_OBJ_NOT_FOUND,
96         ERROR_OBJ_INVALID_OWNERSHIP
97     }
98     
99     enum ArrayType {
100         CLASS_TYPE,
101         STAT_STEP,
102         STAT_START,
103         STAT_BASE,
104         OBJ_SKILL
105     }
106 }
107 
108 contract EtheremonDataBase is EtheremonEnum, BasicAccessControl, SafeMath {
109     
110     uint64 public totalMonster;
111     uint32 public totalClass;
112     
113     // write
114     function addElementToArrayType(ArrayType _type, uint64 _id, uint8 _value) onlyModerators public returns(uint);
115     function removeElementOfArrayType(ArrayType _type, uint64 _id, uint8 _value) onlyModerators public returns(uint);
116     function setMonsterClass(uint32 _classId, uint256 _price, uint256 _returnPrice, bool _catchable) onlyModerators public returns(uint32);
117     function addMonsterObj(uint32 _classId, address _trainer, string _name) onlyModerators public returns(uint64);
118     function setMonsterObj(uint64 _objId, string _name, uint32 _exp, uint32 _createIndex, uint32 _lastClaimIndex) onlyModerators public;
119     function increaseMonsterExp(uint64 _objId, uint32 amount) onlyModerators public;
120     function decreaseMonsterExp(uint64 _objId, uint32 amount) onlyModerators public;
121     function removeMonsterIdMapping(address _trainer, uint64 _monsterId) onlyModerators public;
122     function addMonsterIdMapping(address _trainer, uint64 _monsterId) onlyModerators public;
123     function clearMonsterReturnBalance(uint64 _monsterId) onlyModerators public returns(uint256 amount);
124     function collectAllReturnBalance(address _trainer) onlyModerators public returns(uint256 amount);
125     function transferMonster(address _from, address _to, uint64 _monsterId) onlyModerators public returns(ResultCode);
126     function addExtraBalance(address _trainer, uint256 _amount) onlyModerators public returns(uint256);
127     function deductExtraBalance(address _trainer, uint256 _amount) onlyModerators public returns(uint256);
128     function setExtraBalance(address _trainer, uint256 _amount) onlyModerators public;
129     
130     // read
131     function getSizeArrayType(ArrayType _type, uint64 _id) constant public returns(uint);
132     function getElementInArrayType(ArrayType _type, uint64 _id, uint _index) constant public returns(uint8);
133     function getMonsterClass(uint32 _classId) constant public returns(uint32 classId, uint256 price, uint256 returnPrice, uint32 total, bool catchable);
134     function getMonsterObj(uint64 _objId) constant public returns(uint64 objId, uint32 classId, address trainer, uint32 exp, uint32 createIndex, uint32 lastClaimIndex, uint createTime);
135     function getMonsterName(uint64 _objId) constant public returns(string name);
136     function getExtraBalance(address _trainer) constant public returns(uint256);
137     function getMonsterDexSize(address _trainer) constant public returns(uint);
138     function getMonsterObjId(address _trainer, uint index) constant public returns(uint64);
139     function getExpectedBalance(address _trainer) constant public returns(uint256);
140     function getMonsterReturn(uint64 _objId) constant public returns(uint256 current, uint256 total);
141 }
142 
143 interface EtheremonBattleInterface {
144     function isOnBattle(uint64 _objId) constant external returns(bool) ;
145 }
146 
147 interface EtheremonMonsterNFTInterface {
148    function triggerTransferEvent(address _from, address _to, uint _tokenId) external;
149    function getMonsterCP(uint64 _monsterId) constant external returns(uint cp);
150 }
151 
152 contract EtheremonTradeData is BasicAccessControl {
153     struct BorrowItem {
154         uint index;
155         address owner;
156         address borrower;
157         uint price;
158         bool lent;
159         uint releaseTime;
160         uint createTime;
161     }
162     
163     struct SellingItem {
164         uint index;
165         uint price;
166         uint createTime;
167     }
168 
169     mapping(uint => SellingItem) public sellingDict; // monster id => item
170     uint[] public sellingList; // monster id
171     
172     mapping(uint => BorrowItem) public borrowingDict;
173     uint[] public borrowingList;
174 
175     mapping(address => uint[]) public lendingList;
176     
177     function removeSellingItem(uint _itemId) onlyModerators external {
178         SellingItem storage item = sellingDict[_itemId];
179         if (item.index == 0)
180             return;
181         
182         if (item.index <= sellingList.length) {
183             // Move an existing element into the vacated key slot.
184             sellingDict[sellingList[sellingList.length-1]].index = item.index;
185             sellingList[item.index-1] = sellingList[sellingList.length-1];
186             sellingList.length -= 1;
187             delete sellingDict[_itemId];
188         }
189     }
190     
191     function addSellingItem(uint _itemId, uint _price, uint _createTime) onlyModerators external {
192         SellingItem storage item = sellingDict[_itemId];
193         item.price = _price;
194         item.createTime = _createTime;
195         
196         if (item.index == 0) {
197             item.index = ++sellingList.length;
198             sellingList[item.index - 1] = _itemId;
199         }
200     }
201     
202     function removeBorrowingItem(uint _itemId) onlyModerators external {
203         BorrowItem storage item = borrowingDict[_itemId];
204         if (item.index == 0)
205             return;
206         
207         if (item.index <= borrowingList.length) {
208             // Move an existing element into the vacated key slot.
209             borrowingDict[borrowingList[borrowingList.length-1]].index = item.index;
210             borrowingList[item.index-1] = borrowingList[borrowingList.length-1];
211             borrowingList.length -= 1;
212             delete borrowingDict[_itemId];
213         }
214     }
215 
216     function addBorrowingItem(address _owner, uint _itemId, uint _price, address _borrower, bool _lent, uint _releaseTime, uint _createTime) onlyModerators external {
217         BorrowItem storage item = borrowingDict[_itemId];
218         item.owner = _owner;
219         item.borrower = _borrower;
220         item.price = _price;
221         item.lent = _lent;
222         item.releaseTime = _releaseTime;
223         item.createTime = _createTime;
224         
225         if (item.index == 0) {
226             item.index = ++borrowingList.length;
227             borrowingList[item.index - 1] = _itemId;
228         }
229     }
230     
231     function addItemLendingList(address _trainer, uint _objId) onlyModerators external {
232         lendingList[_trainer].push(_objId);
233     }
234     
235     function removeItemLendingList(address _trainer, uint _objId) onlyModerators external {
236         uint foundIndex = 0;
237         uint[] storage objList = lendingList[_trainer];
238         for (; foundIndex < objList.length; foundIndex++) {
239             if (objList[foundIndex] == _objId) {
240                 break;
241             }
242         }
243         if (foundIndex < objList.length) {
244             objList[foundIndex] = objList[objList.length-1];
245             delete objList[objList.length-1];
246             objList.length--;
247         }
248     }
249 
250     // read access
251     function isOnBorrow(uint _objId) constant external returns(bool) {
252         return (borrowingDict[_objId].index > 0);
253     }
254     
255     function isOnSell(uint _objId) constant external returns(bool) {
256         return (sellingDict[_objId].index > 0);
257     }
258     
259     function isOnLent(uint _objId) constant external returns(bool) {
260         return borrowingDict[_objId].lent;
261     }
262     
263     function getSellPrice(uint _objId) constant external returns(uint) {
264         return sellingDict[_objId].price;
265     }
266     
267     function isOnTrade(uint _objId) constant external returns(bool) {
268         return ((borrowingDict[_objId].index > 0) || (sellingDict[_objId].index > 0)); 
269     }
270     
271     function getBorrowBasicInfo(uint _objId) constant external returns(address owner, bool lent) {
272         BorrowItem storage borrowItem = borrowingDict[_objId];
273         return (borrowItem.owner, borrowItem.lent);
274     }
275     
276     function getBorrowInfo(uint _objId) constant external returns(uint index, address owner, address borrower, uint price, bool lent, uint createTime, uint releaseTime) {
277         BorrowItem storage borrowItem = borrowingDict[_objId];
278         return (borrowItem.index, borrowItem.owner, borrowItem.borrower, borrowItem.price, borrowItem.lent, borrowItem.createTime, borrowItem.releaseTime);
279     }
280     
281     function getSellInfo(uint _objId) constant external returns(uint index, uint price, uint createTime) {
282         SellingItem storage item = sellingDict[_objId];
283         return (item.index, item.price, item.createTime);
284     }
285     
286     function getTotalSellingItem() constant external returns(uint) {
287         return sellingList.length;
288     }
289     
290     function getTotalBorrowingItem() constant external returns(uint) {
291         return borrowingList.length;
292     }
293     
294     function getTotalLendingItem(address _trainer) constant external returns(uint) {
295         return lendingList[_trainer].length;
296     }
297     
298     function getSellingInfoByIndex(uint _index) constant external returns(uint objId, uint price, uint createTime) {
299         objId = sellingList[_index];
300         SellingItem storage item = sellingDict[objId];
301         price = item.price;
302         createTime = item.createTime;
303     }
304     
305     function getBorrowInfoByIndex(uint _index) constant external returns(uint objId, address owner, address borrower, uint price, bool lent, uint createTime, uint releaseTime) {
306         objId = borrowingList[_index];
307         BorrowItem storage borrowItem = borrowingDict[objId];
308         return (objId, borrowItem.owner, borrowItem.borrower, borrowItem.price, borrowItem.lent, borrowItem.createTime, borrowItem.releaseTime);
309     }
310     
311     function getLendingObjId(address _trainer, uint _index) constant external returns(uint) {
312         return lendingList[_trainer][_index];
313     }
314     
315     function getLendingInfo(address _trainer, uint _index) constant external returns(uint objId, address owner, address borrower, uint price, bool lent, uint createTime, uint releaseTime) {
316         objId = lendingList[_trainer][_index];
317         BorrowItem storage borrowItem = borrowingDict[objId];
318         return (objId, borrowItem.owner, borrowItem.borrower, borrowItem.price, borrowItem.lent, borrowItem.createTime, borrowItem.releaseTime);
319     }
320     
321     function getTradingInfo(uint _objId) constant external returns(uint sellingPrice, uint lendingPrice, bool lent, uint releaseTime, address owner, address borrower) {
322         SellingItem storage item = sellingDict[_objId];
323         sellingPrice = item.price;
324         BorrowItem storage borrowItem = borrowingDict[_objId];
325         lendingPrice = borrowItem.price;
326         lent = borrowItem.lent;
327         releaseTime = borrowItem.releaseTime;
328         owner = borrowItem.owner;
329         borrower = borrower;
330     }
331 }