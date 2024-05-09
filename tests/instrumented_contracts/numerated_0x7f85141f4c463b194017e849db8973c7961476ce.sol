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
45 contract CellTokens {
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
76   function CellTokens () public {
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
132     owner.transfer(this.balance);
133   }
134 
135   function withdrawAmount (uint256 _amount) onlyOwner() public {
136     owner.transfer(_amount);
137   }
138    /* Buying */
139   function calculateNextPrice (uint256 _price) public view returns (uint256 _nextPrice) {
140     if (_price < increaseLimit1) {
141       return _price.mul(200).div(95);
142     } else if (_price < increaseLimit2) {
143       return _price.mul(135).div(96);
144     } else if (_price < increaseLimit3) {
145       return _price.mul(125).div(97);
146     } else if (_price < increaseLimit4) {
147       return _price.mul(117).div(97);
148     } else {
149       return _price.mul(115).div(98);
150     }
151   }
152 
153   function calculateDevCut (uint256 _price) public view returns (uint256 _devCut) {
154     if (_price < increaseLimit1) {
155       return _price.mul(5).div(100); // 5%
156     } else if (_price < increaseLimit2) {
157       return _price.mul(4).div(100); // 4%
158     } else if (_price < increaseLimit3) {
159       return _price.mul(3).div(100); // 3%
160     } else if (_price < increaseLimit4) {
161       return _price.mul(3).div(100); // 3%
162     } else {
163       return _price.mul(2).div(100); // 2%
164     }
165   }
166   
167   function requestMerge(uint256[] ids)onlyMergeEnable() external {
168       require(ids.length == 4);
169       require(ids[0]%(10**8)/(10**4)<max_merge_size);
170       require(ids[0]%(10**8)/(10**4)<max_merge_size);
171       require(ids[0]%(10**8)/(10**4)<max_merge_size);
172       require(ids[0]%(10**8)/(10**4)<max_merge_size);
173       require(ownerOfItem[ids[0]] == msg.sender);
174       require(ownerOfItem[ids[1]] == msg.sender);
175       require(ownerOfItem[ids[2]] == msg.sender);
176       require(ownerOfItem[ids[3]] == msg.sender);
177       require(ids[0]+ (10**12) == ids[1]);
178       require(ids[0]+ (10**8) == ids[2]);
179       require(ids[0]+ (10**8) + (10**12) == ids[3]);
180       
181       uint256 newPrice = priceOfItem[ids[0]]+priceOfItem[ids[1]]+priceOfItem[ids[2]]+priceOfItem[ids[3]];
182       uint256 newId = ids[0] + ids[0]%(10**8);
183       listedItems.push(newId);
184       priceOfItem[newId] = newPrice;
185       ownerOfItem[newId] = msg.sender;
186       ownerOfItem[ids[0]] = address(0);
187       ownerOfItem[ids[1]] = address(0);
188       ownerOfItem[ids[2]] = address(0);
189       ownerOfItem[ids[3]] = address(0);
190   } 
191   
192   function checkIsOnSale(uint256 _ypos)public view returns(bool isOnSale){
193       if(_ypos<Reserved_upRow||_ypos>Reserved_downRow){
194           return false;
195       }else{
196           return true;
197       }
198   }
199   function generateId(uint256 _xpos,uint256 _ypos,uint256 _size)internal pure returns(uint256 _id){
200       uint256 temp= _xpos *  (10**12) + _ypos * (10**8) + _size*(10**4);
201       return temp;
202   }
203   function parseId(uint256 _id)internal pure returns(uint256 _x,uint256 _y,uint256 _size){
204       uint256 xpos = _id / (10**12);
205       uint256 ypos = (_id-xpos*(10**12)) / (10**8);
206       uint256 size = _id % (10**5) / (10**4);
207       return (xpos,ypos,size);
208   }
209 
210   function setUserName(string _name)payable public{
211       require(msg.value >= 0.01 ether);
212       usernameOfAddress[msg.sender] = _name;
213       uint256 excess = msg.value - 0.01 ether;
214       if (excess > 0) {
215           msg.sender.transfer(excess);
216       }
217   }
218   function getUserName()public view returns(string name){
219       return usernameOfAddress[msg.sender];
220   }
221   function getUserNameOf(address _user)public view returns(string name){
222       return usernameOfAddress[_user];
223   }
224     function buyOld (uint256 _index) payable public {
225         require(_index!=0);
226         require(msg.value >= priceOf(_index));
227         require(ownerOf(_index) != msg.sender);
228         require(ownerOf(_index) != address(0));
229 
230         uint256 price = priceOf(_index);
231         address oldOwner = ownerOfItem[_index];
232         priceOfItem[_index] = calculateNextPrice(price);
233 
234         uint256 excess = msg.value.sub(price);
235         address newOwner = msg.sender;
236     
237     	ownerOfItem[_index] = newOwner;
238         uint256 devCut = calculateDevCut(price);
239         oldOwner.transfer(price.sub(devCut));
240     
241         if (excess > 0) {
242           newOwner.transfer(excess);
243         }
244     }
245     function buyNew (uint256 _xpos,uint256 _ypos,uint256 _size) payable public {
246         require(checkIsOnSale(_ypos) == true);
247         require(_size == 1);
248         require(_xpos + _size <= MAX_COLS);
249         uint256 _itemId = generateId(_xpos,_ypos,_size);
250         require(priceOf(_itemId)==0);
251         uint256 price =startingPrice;
252         address oldOwner = owner;
253 
254         listedItems.push(_itemId);
255         priceOfItem[_itemId] = calculateNextPrice(price);
256         uint256 excess = msg.value.sub(price);
257         address newOwner = msg.sender;
258     
259     	ownerOfItem[_itemId] = newOwner;
260         uint256 devCut = calculateDevCut(price);
261         oldOwner.transfer(price.sub(devCut));
262     
263         if (excess > 0) {
264           newOwner.transfer(excess);
265         }
266     }
267 
268     function MergeStatus() public view returns (bool _MergeOpen) {
269         return mergeEnabled;
270     }
271   /* ERC721 */
272   function implementsERC721() public view returns (bool _implements) {
273     return erc721Enabled;
274   }
275 
276   function name() public pure returns (string _name) {
277     return "Crypto10K.io";
278   }
279 
280   function symbol() public pure returns (string _symbol) {
281     return "cells";
282   }
283   
284   function totalSupply() public view returns (uint256 _totalSupply) {
285       uint256 total = 0;
286       for(uint8 i=0; i<listedItems.length; i++){
287           if(ownerOf(listedItems[i])!=address(0)){
288               total++;
289           }
290       }
291     return total;
292   }
293 
294   function balanceOf (address _owner) public view returns (uint256 _balance) {
295     uint256 counter = 0;
296     for (uint8 i = 0; i < listedItems.length; i++) {
297       if (ownerOf(listedItems[i]) == _owner) {
298           counter++;
299       }
300     }
301     return counter;
302   }
303   
304   function ownerOf (uint256 _itemId) public view returns (address _owner) {
305     return ownerOfItem[_itemId];
306   }
307   
308   function cellsOf (address _owner) public view returns (uint256[] _tokenIds) {
309     uint256[] memory items = new uint256[](balanceOf(_owner));
310     uint256 itemCounter = 0;
311     for (uint8 i = 0; i < listedItems.length; i++) {
312       if (ownerOf(listedItems[i]) == _owner) {
313         items[itemCounter] = listedItems[i];
314         itemCounter += 1;
315       }
316     }
317     return items;
318   }
319     function getAllCellIds () public view returns (uint256[] _tokenIds) {
320         uint256[] memory items = new uint256[](totalSupply());
321         uint256 itemCounter = 0;
322         for (uint8 i = 0; i < listedItems.length; i++) {
323             if (ownerOfItem[listedItems[i]] != address(0)) {
324                 items[itemCounter] = listedItems[i];
325                 itemCounter += 1;
326             }
327         }
328         return items;
329     }
330 
331     /* Read */
332     function isAdmin (address _admin) public view returns (bool _isAdmin) {
333         return admins[_admin];
334     }
335     
336     function startingPriceOf () public view returns (uint256 _startingPrice) {
337         return startingPrice;
338     }
339     
340     function priceOf (uint256 _itemId) public view returns (uint256 _price) {
341         return priceOfItem[_itemId];
342     }
343     
344     function nextPriceOf (uint256 _itemId) public view returns (uint256 _nextPrice) {
345         return calculateNextPrice(priceOf(_itemId));
346     }
347 
348     function allOf (uint256 _itemId) external view returns (address _owner, uint256 _startingPrice, uint256 _price, uint256 _nextPrice, uint256 _xpos, uint256 _ypos, uint256 _size) {
349         uint256 xpos;
350         uint256 ypos;
351         uint256 size;
352         (xpos,ypos,size) = parseId(_itemId);
353         return (ownerOfItem[_itemId],startingPriceOf(),priceOf(_itemId),nextPriceOf(_itemId),xpos,ypos,size);
354     }
355     
356     function getAllCellInfo()external view returns(uint256[] _tokenIds,uint256[] _prices, address[] _owners){
357         uint256[] memory items = new uint256[](totalSupply());
358         uint256[] memory prices = new uint256[](totalSupply());
359         address[] memory owners = new address[](totalSupply());
360         uint256 itemCounter = 0;
361         for (uint8 i = 0; i < listedItems.length; i++) {
362             if (ownerOf(listedItems[i]) !=address(0)) {
363                 items[itemCounter] = listedItems[i];
364                 prices[itemCounter] = priceOf(listedItems[i]);
365                 owners[itemCounter] = ownerOf(listedItems[i]);
366                 itemCounter += 1;
367             }
368         }
369         return (items,prices,owners);
370     }
371     function getMaxMerge()external view returns(uint256 _maxMergeSize){
372       return max_merge_size;
373     }
374     function showBalance () onlyAdmins() public view returns (uint256 _ProfitBalance) {
375         return this.balance;
376     }
377 }