1 pragma solidity ^0.4.19;
2 
3 library SafeMath {
4 
5   /**
6   * @dev Multiplies two numbers, throws on overflow.
7   */
8   function mul(uint256 a, uint256 b) internal pure returns (uint256) {
9     if (a == 0) {
10       return 0;
11     }
12     uint256 c = a * b;
13     assert(c / a == b);
14     return c;
15   }
16 
17   /**
18   * @dev Integer division of two numbers, truncating the quotient.
19   */
20   function div(uint256 a, uint256 b) internal pure returns (uint256) {
21     // assert(b > 0); // Solidity automatically throws when dividing by 0
22     uint256 c = a / b;
23     // assert(a == b * c + a % b); // There is no case in which this doesn't hold
24     return c;
25   }
26 
27   /**
28   * @dev Substracts two numbers, throws on overflow (i.e. if subtrahend is greater than minuend).
29   */
30   function sub(uint256 a, uint256 b) internal pure returns (uint256) {
31     assert(b <= a);
32     return a - b;
33   }
34 
35   /**
36   * @dev Adds two numbers, throws on overflow.
37   */
38   function add(uint256 a, uint256 b) internal pure returns (uint256) {
39     uint256 c = a + b;
40     assert(c >= a);
41     return c;
42   }
43 }
44 
45 contract ETH10K {
46   using SafeMath for uint256;
47 
48   uint8 private constant MAX_COLS = 64;
49   uint8 private constant MAX_ROWS = 160;
50   uint8 private Reserved_upRow = 8;
51   uint8 private Reserved_downRow = 39;
52   uint8 private max_merge_size = 2;
53   
54   event Bought (uint256 indexed _itemId, address indexed _owner, uint256 _price);
55   event Sold (uint256 indexed _itemId, address indexed _owner, uint256 _price);
56   event Transfer(address indexed _from, address indexed _to, uint256 _tokenId);
57   event Approval(address indexed _owner, address indexed _approved, uint256 _tokenId);
58 
59   address private owner;
60   mapping (address => bool) private admins;
61   bool private erc721Enabled = false;
62   bool private mergeEnabled = false;
63   uint256 private increaseLimit1 = 0.02 ether;
64   uint256 private increaseLimit2 = 0.5 ether;
65   uint256 private increaseLimit3 = 2.0 ether;
66   uint256 private increaseLimit4 = 5.0 ether;
67   uint256 private startingPrice = 0.001 ether;
68   
69   uint256[] private listedItems;
70   
71   mapping (uint256 => address) private ownerOfItem;
72   mapping (uint256 => uint256) private priceOfItem;
73   mapping (address => string) private usernameOfAddress;
74   
75   
76   function ETH10K () public {
77     owner = msg.sender;
78     admins[owner] = true;
79   }
80 
81   /* Modifiers */
82   modifier onlyOwner() {
83     require(owner == msg.sender);
84     _;
85   }
86 
87   modifier onlyAdmins() {
88     require(admins[msg.sender]);
89     _;
90   }
91 
92   modifier onlyERC721() {
93     require(erc721Enabled);
94     _;
95   }
96   modifier onlyMergeEnable(){
97       require(mergeEnabled);
98     _;
99   }
100 
101   /* Owner */
102   function setOwner (address _owner) onlyOwner() public {
103     owner = _owner;
104   }
105 
106   function addAdmin (address _admin) onlyOwner() public {
107     admins[_admin] = true;
108   }
109 
110   function removeAdmin (address _admin) onlyOwner() public {
111     delete admins[_admin];
112   }
113 
114   // Unlocks ERC721 behaviour, allowing for trading on third party platforms.
115   function enableERC721 () onlyOwner() public {
116     erc721Enabled = true;
117   }
118   function enableMerge (bool status) onlyAdmins() public {
119     mergeEnabled = status;
120   }
121   function setReserved(uint8 _up,uint8 _down) onlyAdmins() public{
122       Reserved_upRow = _up;
123       Reserved_downRow = _down;
124   }
125   function setMaxMerge(uint8 num)onlyAdmins() external{
126       max_merge_size = num;
127   }  
128   /* Withdraw */
129   /*
130   */
131   function withdrawAll () onlyOwner() public {
132     require(this.balance > 0);
133     owner.transfer(this.balance);
134   }
135 
136   function withdrawAmount (uint256 _amount) onlyOwner() public {
137     owner.transfer(_amount);
138   }
139    /* Buying */
140   function calculateNextPrice (uint256 _price) public view returns (uint256 _nextPrice) {
141     if (_price < increaseLimit1) {
142       return _price.mul(200).div(95);
143     } else if (_price < increaseLimit2) {
144       return _price.mul(135).div(96);
145     } else if (_price < increaseLimit3) {
146       return _price.mul(125).div(97);
147     } else if (_price < increaseLimit4) {
148       return _price.mul(117).div(97);
149     } else {
150       return _price.mul(115).div(98);
151     }
152   }
153 
154   function calculateDevCut (uint256 _price) public view returns (uint256 _devCut) {
155     if (_price < increaseLimit1) {
156       return _price.mul(5).div(100); // 5%
157     } else if (_price < increaseLimit2) {
158       return _price.mul(4).div(100); // 4%
159     } else if (_price < increaseLimit3) {
160       return _price.mul(3).div(100); // 3%
161     } else if (_price < increaseLimit4) {
162       return _price.mul(3).div(100); // 3%
163     } else {
164       return _price.mul(2).div(100); // 2%
165     }
166   }
167   
168   function requestMerge(uint256[] ids)onlyMergeEnable() external {
169       require(ids.length == 4);
170       require(ids[0]%(10**8)/(10**4)<max_merge_size);
171       require(ids[1]%(10**8)/(10**4)<max_merge_size);
172       require(ids[2]%(10**8)/(10**4)<max_merge_size);
173       require(ids[3]%(10**8)/(10**4)<max_merge_size);
174       require(ownerOfItem[ids[0]] == msg.sender);
175       require(ownerOfItem[ids[1]] == msg.sender);
176       require(ownerOfItem[ids[2]] == msg.sender);
177       require(ownerOfItem[ids[3]] == msg.sender);
178       require(ids[0]+ (10**12) == ids[1]);
179       require(ids[0]+ (10**8) == ids[2]);
180       require(ids[0]+ (10**8) + (10**12) == ids[3]);
181       
182       uint256 newPrice = priceOfItem[ids[0]]+priceOfItem[ids[1]]+priceOfItem[ids[2]]+priceOfItem[ids[3]];
183       uint256 newId = ids[0] + ids[0]%(10**8);
184       listedItems.push(newId);
185       priceOfItem[newId] = newPrice;
186       ownerOfItem[newId] = msg.sender;
187       ownerOfItem[ids[0]] = address(0);
188       ownerOfItem[ids[1]] = address(0);
189       ownerOfItem[ids[2]] = address(0);
190       ownerOfItem[ids[3]] = address(0);
191   } 
192   
193   function checkIsOnSale(uint256 _ypos)public view returns(bool isOnSale){
194       if(_ypos<Reserved_upRow||_ypos>Reserved_downRow){
195           return false;
196       }else{
197           return true;
198       }
199   }
200   function generateId(uint256 _xpos,uint256 _ypos,uint256 _size)internal pure returns(uint256 _id){
201       uint256 temp= _xpos *  (10**12) + _ypos * (10**8) + _size*(10**4);
202       return temp;
203   }
204   function parseId(uint256 _id)internal pure returns(uint256 _x,uint256 _y,uint256 _size){
205       uint256 xpos = _id / (10**12);
206       uint256 ypos = (_id-xpos*(10**12)) / (10**8);
207       uint256 size = _id % (10**5) / (10**4);
208       return (xpos,ypos,size);
209   }
210 
211   function setUserName(string _name)payable public{
212       require(msg.value >= 0.01 ether);
213       usernameOfAddress[msg.sender] = _name;
214       uint256 excess = msg.value - 0.01 ether;
215       if (excess > 0) {
216           msg.sender.transfer(excess);
217       }
218   }
219   function getUserName()public view returns(string name){
220       return usernameOfAddress[msg.sender];
221   }
222   function getUserNameOf(address _user)public view returns(string name){
223       return usernameOfAddress[_user];
224   }
225   
226   function addBlock(address _to, uint256 _xpos,uint256 _ypos,uint256 _size,uint256 _price) onlyAdmins() public {
227         require(checkIsOnSale(_ypos) == true);
228         require(_size == 1);
229         require(_xpos + _size <= MAX_COLS);
230         uint256 _itemId = generateId(_xpos,_ypos,_size);
231         require(priceOf(_itemId)==0);
232         require(ownerOf(_itemId)==address(0));
233         
234         listedItems.push(_itemId);
235         priceOfItem[_itemId] = _price;
236     	ownerOfItem[_itemId] = _to;
237     }
238   
239   
240   //Buy the block with somebody owned already
241     function buyOld (uint256 _index) payable public {
242         require(_index!=0);
243         require(msg.value >= priceOf(_index));
244         require(ownerOf(_index) != msg.sender);
245         require(ownerOf(_index) != address(0));
246 
247         uint256 price = priceOf(_index);
248         address oldOwner = ownerOfItem[_index];
249         priceOfItem[_index] = calculateNextPrice(price);
250 
251         uint256 excess = msg.value.sub(price);
252         address newOwner = msg.sender;
253     
254     	ownerOfItem[_index] = newOwner;
255         uint256 devCut = calculateDevCut(price);
256         oldOwner.transfer(price.sub(devCut));
257     
258         if (excess > 0) {
259           newOwner.transfer(excess);
260         }
261     }
262     
263     //Buy a new block without anybody owned
264     function buyNew (uint256 _xpos,uint256 _ypos,uint256 _size) payable public {
265         require(checkIsOnSale(_ypos) == true);
266         require(_size == 1);
267         require(_xpos + _size <= MAX_COLS);
268         uint256 _itemId = generateId(_xpos,_ypos,_size);
269         require(priceOf(_itemId)==0);
270         require(ownerOf(_itemId)==address(0));
271         uint256 price =startingPrice;
272         address oldOwner = owner;
273 
274         listedItems.push(_itemId);
275         priceOfItem[_itemId] = calculateNextPrice(price);
276         uint256 excess = msg.value.sub(price);
277         address newOwner = msg.sender;
278     
279     	ownerOfItem[_itemId] = newOwner;
280         uint256 devCut = calculateDevCut(price);
281         oldOwner.transfer(price.sub(devCut));
282     
283         if (excess > 0) {
284           newOwner.transfer(excess);
285         }
286     }
287 
288     function MergeStatus() public view returns (bool _MergeOpen) {
289         return mergeEnabled;
290     }
291   /* ERC721 */
292   function implementsERC721() public view returns (bool _implements) {
293     return erc721Enabled;
294   }
295 
296   function name() public pure returns (string _name) {
297     return "ETH10K.io";
298   }
299 
300   function symbol() public pure returns (string _symbol) {
301     return "block";
302   }
303   
304   function totalSupply() public view returns (uint256 _totalSupply) {
305       uint256 total = 0;
306       for(uint256 i=0; i<listedItems.length; i++){
307           if(ownerOf(listedItems[i])!=address(0)){
308               total++;
309           }
310       }
311     return total;
312   }
313 
314   function balanceOf (address _owner) public view returns (uint256 _balance) {
315     uint256 counter = 0;
316     for (uint256 i = 0; i < listedItems.length; i++) {
317       if (ownerOf(listedItems[i]) == _owner) {
318           counter++;
319       }
320     }
321     return counter;
322   }
323   
324   function ownerOf (uint256 _itemId) public view returns (address _owner) {
325     return ownerOfItem[_itemId];
326   }
327   
328   function cellsOf (address _owner) public view returns (uint256[] _tokenIds) {
329     uint256[] memory items = new uint256[](balanceOf(_owner));
330     uint256 itemCounter = 0;
331     for (uint256 i = 0; i < listedItems.length; i++) {
332       if (ownerOf(listedItems[i]) == _owner) {
333         items[itemCounter] = listedItems[i];
334         itemCounter += 1;
335       }
336     }
337     return items;
338   }
339     function getAllCellIds () public view returns (uint256[] _tokenIds) {
340         uint256[] memory items = new uint256[](totalSupply());
341         uint256 itemCounter = 0;
342         for (uint256 i = 0; i < listedItems.length; i++) {
343             if (ownerOfItem[listedItems[i]] != address(0)) {
344                 items[itemCounter] = listedItems[i];
345                 itemCounter += 1;
346             }
347         }
348         return items;
349     }
350 
351     /* Read */
352     function isAdmin (address _admin) public view returns (bool _isAdmin) {
353         return admins[_admin];
354     }
355     
356     function startingPriceOf () public view returns (uint256 _startingPrice) {
357         return startingPrice;
358     }
359     
360     function priceOf (uint256 _itemId) public view returns (uint256 _price) {
361         return priceOfItem[_itemId];
362     }
363     
364     function nextPriceOf (uint256 _itemId) public view returns (uint256 _nextPrice) {
365         return calculateNextPrice(priceOf(_itemId));
366     }
367 
368     function allOf (uint256 _itemId) external view returns (address _owner, uint256 _startingPrice, uint256 _price, uint256 _nextPrice, uint256 _xpos, uint256 _ypos, uint256 _size) {
369         uint256 xpos;
370         uint256 ypos;
371         uint256 size;
372         (xpos,ypos,size) = parseId(_itemId);
373         return (ownerOfItem[_itemId],startingPriceOf(),priceOf(_itemId),nextPriceOf(_itemId),xpos,ypos,size);
374     }
375     
376     function getAllCellInfo()external view returns(uint256[] _tokenIds,uint256[] _prices, address[] _owners){
377         uint256[] memory items = new uint256[](totalSupply());
378         uint256[] memory prices = new uint256[](totalSupply());
379         address[] memory owners = new address[](totalSupply());
380         uint256 itemCounter = 0;
381         for (uint256 i = 0; i < listedItems.length; i++) {
382             if (ownerOf(listedItems[i]) !=address(0)) {
383                 items[itemCounter] = listedItems[i];
384                 prices[itemCounter] = priceOf(listedItems[i]);
385                 owners[itemCounter] = ownerOf(listedItems[i]);
386                 itemCounter += 1;
387             }
388         }
389         return (items,prices,owners);
390     }
391     
392     function getAllCellInfoFrom_To(uint256 _from, uint256 _to)external view returns(uint256[] _tokenIds,uint256[] _prices, address[] _owners){
393         uint256 totalsize = totalSupply();
394         require(_from <= _to);
395         require(_to < totalsize);
396         uint256 size = _to-_from +1;
397         uint256[] memory items = new uint256[](size);
398         uint256[] memory prices = new uint256[](size);
399         address[] memory owners = new address[](size);
400         uint256 itemCounter = 0;
401         for (uint256 i = _from; i < listedItems.length; i++) {
402             if (ownerOf(listedItems[i]) !=address(0)) {
403                 items[itemCounter] = listedItems[i];
404                 prices[itemCounter] = priceOf(listedItems[i]);
405                 owners[itemCounter] = ownerOf(listedItems[i]);
406                 itemCounter += 1;
407                 if(itemCounter > _to){
408                     break;
409                 }
410             }
411         }
412         return (items,prices,owners);
413     }
414     
415     function getMaxMerge()external view returns(uint256 _maxMergeSize){
416       return max_merge_size;
417     }
418     function showBalance () onlyAdmins() public view returns (uint256 _ProfitBalance) {
419         return this.balance;
420     }
421 }