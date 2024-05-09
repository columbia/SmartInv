1 pragma solidity >=0.5.0 <0.6.0;
2 
3 //721协议
4 interface ERC721 {
5     event Transfer(address indexed _from, address indexed _to, uint256 indexed _tokenId);
6     event Approval(address indexed _owner, address indexed _approved, uint256 indexed _tokenId);
7     event ApprovalForAll(address indexed _owner, address indexed _operator, bool _approved);
8     function balanceOf(address _owner) external view returns (uint256);
9     function ownerOf(uint256 _tokenId) external view returns (address);
10     function safeTransferFrom(address _from, address _to, uint256 _tokenId, bytes calldata data) external;
11     function safeTransferFrom(address _from, address _to, uint256 _tokenId) external;
12     function transferFrom(address _from, address _to, uint256 _tokenId) external;
13     function approve(address _approved, uint256 _tokenId) external;
14     function setApprovalForAll(address _operator, bool _approved) external;
15     function getApproved(uint256 _tokenId) external view returns (address);
16     function isApprovedForAll(address _owner, address _operator) external view returns (bool);
17 }
18 
19 //165协议
20 interface ERC165{
21     function supportsInterface(bytes4 interfaceID) external view returns (bool);
22 }
23 
24 interface ERC721TokenReceiver {
25     function onERC721Received(address _from, uint256 _tokenId, bytes calldata data) external returns(bytes4);
26 }
27 
28 contract AccessAdmin{
29     bool public isPaused = false;
30     address public adminAddr;
31 
32     event AdminTransferred(address indexed preAdmin, address indexed newAdmin);
33 
34     constructor() public {
35         adminAddr = msg.sender;
36     }
37 
38     modifier onlyAdmin() {
39         require(msg.sender == adminAddr);
40         _;
41     }
42 
43     modifier whenNotPaused() {
44         require(!isPaused);
45         _;
46     }
47 
48     modifier whenPaused {
49         require(isPaused);
50         _;
51     }
52 
53     function setAdmin(address _newAdmin) external onlyAdmin {
54         require(_newAdmin != address(0));
55         emit AdminTransferred(adminAddr, _newAdmin);
56         adminAddr = _newAdmin;
57     }
58 
59     function doPause() external onlyAdmin whenNotPaused {
60         isPaused = true;
61     }
62 
63     function doUnpause() external onlyAdmin whenPaused {
64         isPaused = false;
65     }
66 }
67 
68 contract SpecialSoldiers is ERC721,AccessAdmin {
69     //物品
70     struct Item{
71         uint256 itemMainType;
72         uint256 itemSubtype;
73         uint16 itemLevel;
74         uint16 itemQuality;
75         uint16 itemPhase; 
76         uint64 createTime;
77         uint64 updateTime;
78         uint16 updateCNT;
79         uint256 attr1;
80         uint256 attr2;
81         uint256 attr3;
82         uint256 attr4;
83         uint256 attr5;
84     }
85 
86     //物品数组
87     Item[] public itemArray; //item ID is the index in this array
88     //每个地址拥有的物品的个数
89     mapping (address => uint256) public ownershipTokenCount;
90     //物品id到地址的mapping地址
91     mapping (uint256 => address) public ItemIDToOwner;
92     //临时具有操作物品tansfer权限的地址
93     mapping (uint256 => address) public ItemIDToApproved;
94     //具有对某个地址下所有物品transfer权限的地址
95     mapping (address => mapping (address => bool)) operatorToApprovals;
96     //信任的地址,官方地址,或者其他合约地址
97     mapping (address => bool) trustAddr;
98     //物品加锁
99     mapping (uint256 => bool) public itemLocked;
100 
101     //用来查询合约支持的协议,和实现的协议方法
102     bytes4 constant InterfaceSignature_ERC165 =
103         bytes4(keccak256('supportsInterface(bytes4)'));
104     bytes4 constant InterfaceSignature_ERC721 =
105         bytes4(keccak256('balanceOf(address)')) ^
106         bytes4(keccak256('ownerOf(uint256)')) ^
107         bytes4(keccak256('safeTransferFrom(address,address,uint256,bytes)')) ^
108         bytes4(keccak256('safeTransferFrom(address,address,uint256)')) ^
109         bytes4(keccak256('transferFrom(address,address,uint256)')) ^
110         bytes4(keccak256('approve(address,uint256)')) ^
111         bytes4(keccak256('setApprovalForAll(address,bool)')) ^
112         bytes4(keccak256('getApproved(uint256)')) ^
113         bytes4(keccak256('isApprovedForAll(address,address)'));
114 
115     //定义通知
116     event Transfer(address indexed _from, address indexed _to, uint256 indexed _tokenId);
117     event Approval(address indexed _owner, address indexed _approved, uint256 indexed _tokenId);
118     event ApprovalForAll(address indexed _owner, address indexed _operator, bool _approved);
119     event ItemUpdate(address  _owner,uint256  _itemID);
120     event ItemCreate(address  _owner,uint256  _itemID);
121     event ItemUnlock(address _caller,address _owner,uint256  _itemID);
122 
123     //构造函数
124     constructor() public{
125         adminAddr = msg.sender;
126     }
127 
128     //修饰函数,用来在函数执行前判断一些条件
129     modifier isValidToken(uint256 _tokenID) {
130         require(_tokenID >= 0 && _tokenID <= itemArray.length);
131         require(ItemIDToOwner[_tokenID] != address(0));
132         _;
133     }
134 
135     modifier isItemLock(uint256 _tokenID) {
136         require(itemLocked[_tokenID]);
137         _;
138     }
139 
140     modifier isItemUnlock(uint256 _tokenID) {
141         require(!itemLocked[_tokenID]);
142         _;
143     }
144 
145     modifier canTransfer(uint256 _tokenId) {
146         address owner = ItemIDToOwner[_tokenId];
147         require(msg.sender == owner || msg.sender == ItemIDToApproved[_tokenId] || operatorToApprovals[owner][msg.sender]);
148         _;
149     }
150 
151     //用于获取itemArray的长度
152     function getitemArrayLength() external view returns(uint256){
153         return(itemArray.length);
154     }
155 
156     //用于链上查询合约支持的协议
157     function supportsInterface(bytes4 _interfaceId) external pure  returns(bool) {
158         return ((_interfaceId == InterfaceSignature_ERC165) || (_interfaceId == InterfaceSignature_ERC721));
159     }
160 
161     function setTrustAddr(address _addr,bool _trust) external onlyAdmin{
162         require(_addr != address(0));
163         trustAddr[_addr] = _trust;
164     }
165 
166     function getTrustAddr(address _addr) external view onlyAdmin returns(bool){
167         return (trustAddr[_addr]);
168     }
169 
170     function _transfer(address _from, address _to, uint256 _tokenId) internal {
171         ownershipTokenCount[_to]++;
172         ItemIDToOwner[_tokenId] = _to;
173 
174         if (_from != address(0)) {
175             ownershipTokenCount[_from]--;
176             delete ItemIDToApproved[_tokenId];
177         }
178 
179         emit Transfer(_from, _to, _tokenId);
180     }
181 
182     //更新物品的状态
183     function updateItem(uint256 _tp,uint256 _subTp,uint16 _level,uint256[5] calldata _attr,uint16 _quality,uint16 _phase,uint256 _tokenId) external whenNotPaused isValidToken(_tokenId) isItemUnlock(_tokenId){
184         require(msg.sender==adminAddr || trustAddr[msg.sender]);
185         
186         itemArray[_tokenId].itemMainType = _tp;
187         itemArray[_tokenId].itemSubtype = _subTp;
188         itemArray[_tokenId].itemLevel = _level;
189         itemArray[_tokenId].itemQuality = _quality;
190         itemArray[_tokenId].itemPhase = _phase;
191         itemArray[_tokenId].updateTime = uint64(now);
192         itemArray[_tokenId].updateCNT += 1;
193         itemArray[_tokenId].attr1 = _attr[0];
194         itemArray[_tokenId].attr2 = _attr[1];
195         itemArray[_tokenId].attr3 = _attr[2];
196         itemArray[_tokenId].attr4 = _attr[3];
197         itemArray[_tokenId].attr5 = _attr[4];
198 
199         address owner = ItemIDToOwner[_tokenId];
200         itemLocked[_tokenId] = true;
201         emit ItemUpdate(owner,_tokenId);
202     }
203     
204     //创建物品
205     function createNewItem(uint256 _tp,uint256 _subTp,address _owner,uint256[5] calldata _attr,uint16 _quality,uint16 _phase) external whenNotPaused {
206         require(msg.sender==adminAddr || trustAddr[msg.sender]);
207         require(_owner != address(0));
208         require(itemArray.length < 4294967296);
209         
210         uint64 currentTime = uint64(now);
211         Item memory _newItem = Item({
212             itemMainType: _tp,
213             itemSubtype: _subTp,
214             itemLevel: 1,
215             itemQuality:_quality,
216             itemPhase:_phase,
217             createTime:currentTime,
218             updateTime:currentTime,
219             updateCNT:0,
220             attr1:_attr[0],
221             attr2:_attr[1],
222             attr3:_attr[2],
223             attr4:_attr[3],
224             attr5:_attr[4]
225         });
226         uint256 newItemID = itemArray.push(_newItem) - 1;
227         itemLocked[newItemID] = true;
228         
229         _transfer(address(0), _owner, newItemID);
230         emit ItemCreate(_owner,newItemID);
231     }
232 
233     //物品解锁,解锁后才能更新状态
234     function unLockedItem(uint256 _tokenId) external whenNotPaused isValidToken(_tokenId) isItemLock(_tokenId) {
235         require(msg.sender==adminAddr || trustAddr[msg.sender]);
236         address owner = ItemIDToOwner[_tokenId];
237         itemLocked[_tokenId] = false;
238         emit ItemUnlock(msg.sender,owner,_tokenId);
239     }
240 
241     //某个地址所有物品个数
242     function balanceOf(address _owner) external view returns (uint256 count) {
243         return ownershipTokenCount[_owner];
244     }
245 
246     //某个物品所属地址
247     function ownerOf(uint256 _tokenId) external view returns (address owner)
248     {
249         owner = ItemIDToOwner[_tokenId];
250 
251         require(owner != address(0));
252     }
253 
254     function _safeTransferFrom(address _from, address _to, uint256 _tokenId, bytes memory data) internal isValidToken(_tokenId) canTransfer(_tokenId){
255         _transfer(_from, _to, _tokenId);
256 
257         //only call onERC721Received when _to is a contract address
258         uint256 codeSize;
259         assembly { codeSize := extcodesize(_to) }
260         if (codeSize == 0) {
261             return;
262         }
263 
264         bytes4 retval = ERC721TokenReceiver(_to).onERC721Received(_from, _tokenId, data);
265         // bytes4(keccak256("onERC721Received(address,uint256,bytes)")) = 0xf0b9e5ba;
266         require(retval == 0xf0b9e5ba);
267     }
268 
269     //合约之间的物品的transfer,对方合约需要要支持721协议,要做onERC721Received判断
270     function safeTransferFrom(address _from, address _to, uint256 _tokenId, bytes calldata data) external whenNotPaused{
271         _safeTransferFrom(_from, _to, _tokenId, data);
272     }
273 
274     function safeTransferFrom(address _from, address _to, uint256 _tokenId) external whenNotPaused{
275         _safeTransferFrom(_from, _to, _tokenId, "");
276     }
277 
278     //物品的transfer,到一个用户地址
279     function transferFrom(address _from, address _to, uint256 _tokenId) external whenNotPaused isValidToken(_tokenId) canTransfer(_tokenId){
280         address owner = ItemIDToOwner[_tokenId];
281         require(owner != address(0));
282         require(_to != address(0));
283         require(_from == owner);
284         _transfer(_from, _to, _tokenId);
285     }
286 
287     function _approve(uint256 _tokenId, address _approved) internal {
288         ItemIDToApproved[_tokenId] = _approved;
289     }
290 
291     //让另一个地址具有临时transfer物品的权限
292     function approve(address _approved, uint256 _tokenId) external whenNotPaused{
293         address owner = ItemIDToOwner[_tokenId];
294         require(owner != address(0));
295         require(msg.sender == owner || operatorToApprovals[owner][msg.sender]);
296 
297         _approve(_tokenId, _approved);
298         emit Approval(msg.sender,  _approved, _tokenId);
299     }
300 
301     //让另一个地址具有transfer当前地址内所有物品的权限
302     function setApprovalForAll(address _operator, bool _approved) external whenNotPaused{
303         require(_operator != address(0));
304         operatorToApprovals[msg.sender][_operator] = _approved;
305         emit ApprovalForAll(msg.sender, _operator, _approved);
306     }
307 
308     function getApproved(uint256 _tokenId) external view returns (address){
309         return ItemIDToApproved[_tokenId];
310     }
311 
312     function isApprovedForAll(address _owner, address _operator) external view returns (bool){
313         return operatorToApprovals[_owner][_operator];
314     }
315 }