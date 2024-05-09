1 pragma solidity ^0.4.24;
2 /* Crypto SuperGirlfriend */
3 
4 library SafeMath {
5   function mul(uint256 a, uint256 b) internal pure returns (uint256) {
6     if (a == 0) {
7       return 0;
8     }
9     uint256 c = a * b;
10     assert(c / a == b);
11     return c;
12   }
13 
14   function div(uint256 a, uint256 b) internal pure returns (uint256) {    
15     uint256 c = a / b;    
16     return c;
17   }
18 
19   function sub(uint256 a, uint256 b) internal pure returns (uint256) {
20     assert(b <= a);
21     return a - b;
22   }
23 
24   function add(uint256 a, uint256 b) internal pure returns (uint256) {
25     uint256 c = a + b;
26     assert(c >= a);
27     return c;
28   }
29 }
30 
31   
32 
33 contract CryptoSuperGirlfriend {
34   using SafeMath for uint256;
35 
36   address private addressOfOwner;  
37  
38   event Add (uint256 indexed _itemId, address indexed _owner, uint256 _price);
39   event Bought (uint256 indexed _itemId, address indexed _owner, uint256 _price);
40   event Sold (uint256 indexed _itemId, address indexed _owner, uint256 _price);
41   event Transfer(address indexed _from, address indexed _to, uint256 _tokenId);
42   event Approval(address indexed _owner, address indexed _approved, uint256 _tokenId);
43   
44   
45   uint256 private priceInit = 0.01 ether;
46   uint256 private idStart = 10001;
47   uint256 private idMax = 10191;
48 
49   struct OwnerInfo{      
50         string ownerName;
51         string ownerWords;  
52         string ownerImg; 
53         string ownerNation;     
54   }
55 
56   uint256[] private listedItems;
57   mapping (uint256 => address) private ownerOfItem;
58   mapping (uint256 => uint256) private priceOfItem;
59   mapping (uint256 => uint256) private sellPriceOfItem;
60   mapping (uint256 => OwnerInfo) private ownerInfoOfItem;
61   mapping (uint256 => string) private nameOfItem; 
62   mapping (uint256 => address) private approvedOfItem;
63 
64   
65   /* Modifiers */
66   modifier onlyOwner () {
67     require(addressOfOwner == msg.sender);
68     _;
69   }   
70 
71   /* Initilization */
72   constructor () public {
73     addressOfOwner = msg.sender;   
74   }
75 
76   /* Admin */
77   function transferOwnership (address _owner) onlyOwner() public {   
78     addressOfOwner = _owner;
79   }  
80   
81   /* Read */
82   function owner () public view returns (address _owner) {
83     return addressOfOwner;
84   } 
85   
86   /* Listing */  
87   function addItem (uint256 _itemId, string _name, uint256 _sellPrice) onlyOwner() external { 
88        newItem(_itemId, _name, _sellPrice);
89   }
90 
91   function newItem (uint256 _itemId, string _name, uint256 _sellPrice) internal {
92     require(_checkItemId(_itemId));
93     require(tokenExists(_itemId) == false);
94     
95     ownerOfItem[_itemId] = address(0);
96     priceOfItem[_itemId] = 0;
97     sellPriceOfItem[_itemId] = _sellPrice;
98     nameOfItem[_itemId] = _name;
99     OwnerInfo memory oi = OwnerInfo("", "", "", "");  
100     ownerInfoOfItem[_itemId] = oi;    
101 
102     listedItems.push(_itemId);    
103 
104     emit Add(_itemId, address(0), _sellPrice);
105   }
106   
107   /* Market */  
108   function calculateNextPrice (uint256 _price) public view returns (uint256 _nextPrice) {    
109     
110     // Update prices
111     if (_price == 0 ether) {
112       // first stage
113       return priceInit;
114     } else if (_price < 1 ether) {
115       // first stage
116       return _price.mul(2);
117     } else if (_price < 10 ether) {
118       // second stage
119       return _price.mul(150).div(100);
120     } else {
121       // third stage
122       return _price.mul(120).div(100);
123     }
124 
125   }
126   
127   function buy (uint256 _itemId, uint256 _sellPrice, string _name, string _ownerName, string _ownerWords, string _ownerImg, string _ownerNation) payable public returns (bool _result) {
128     require(_checkItemId(_itemId));
129     require(ownerOf(_itemId) != msg.sender);
130     require(msg.sender != address(0)); 
131     require(_sellPrice == 0 || _sellPrice.sub(priceInit) >= 0);
132     require(msg.value.sub(sellPriceOf(_itemId)) >= 0);
133     require(msg.value.mul(2).sub(_sellPrice) >= 0);   
134    
135     if(_sellPrice == 0)
136        _sellPrice = calculateNextPrice(msg.value);  
137     
138     if(tokenExists(_itemId) == false)
139        newItem(_itemId, _name, priceInit);
140 
141     address oldOwner = ownerOf(_itemId);
142     address newOwner = msg.sender;      
143     
144     if(oldOwner != address(0))    
145     {
146       if(msg.value > priceOf(_itemId))
147       {
148          uint256 tradeCut;
149          tradeCut = msg.value.sub(priceOf(_itemId));
150          tradeCut = tradeCut.mul(10).div(100); 
151          oldOwner.transfer(msg.value.sub(tradeCut)); 
152       }
153       else
154          oldOwner.transfer(msg.value); 
155     }    
156       
157     priceOfItem[_itemId] = msg.value;    
158     sellPriceOfItem[_itemId] = _sellPrice;
159     OwnerInfo memory oi = OwnerInfo(_ownerName, _ownerWords, _ownerImg, _ownerNation);  
160     ownerInfoOfItem[_itemId] = oi;    
161     
162     _transfer(oldOwner, newOwner, _itemId); 
163     emit Bought(_itemId, newOwner, msg.value);
164     emit Sold(_itemId, oldOwner, msg.value);   
165     owner().transfer(address(this).balance);  
166 
167     return true;
168     
169   }
170   
171   function changeItemName (uint256 _itemId, string _name) onlyOwner() public returns (bool _result) {    
172     require(_checkItemId(_itemId));
173     nameOfItem[_itemId] = _name;
174     
175     return true;    
176   } 
177   
178   function changeOwnerInfo (uint256 _itemId, uint256 _sellPrice, string _ownerName, string _ownerWords, string _ownerImg, string _ownerNation) public returns (bool _result) {    
179     require(_checkItemId(_itemId));
180     require(ownerOf(_itemId) == msg.sender);
181     require(_sellPrice.sub(priceInit) >= 0);
182     require(priceOfItem[_itemId].mul(2).sub(_sellPrice) >= 0); 
183     
184     sellPriceOfItem[_itemId] = _sellPrice;    
185     OwnerInfo memory oi = OwnerInfo(_ownerName, _ownerWords, _ownerImg, _ownerNation);  
186     ownerInfoOfItem[_itemId] = oi;       
187 
188     return true;    
189   }
190 
191   function setIdRange (uint256 _idStart, uint256 _idMax) onlyOwner() public {    
192    
193     idStart = _idStart;    
194     idMax = _idMax;
195     
196   } 
197 
198   /* Read */
199   function tokenExists (uint256 _itemId) public view returns (bool _exists) {
200     require(_checkItemId(_itemId));     
201     bool bExist = false;
202     for(uint256 i=0; i<listedItems.length; i++)
203     {
204        if(listedItems[i] == _itemId)
205        {
206           bExist = true;  
207           break;
208        } 
209     }
210     return bExist;
211   }
212   
213   function priceOf (uint256 _itemId) public view returns (uint256 _price) {
214     require(_checkItemId(_itemId)); 
215     return priceOfItem[_itemId];
216   }
217   
218   function sellPriceOf (uint256 _itemId) public view returns (uint256 _nextPrice) {
219     require(_checkItemId(_itemId));    
220     if(sellPriceOfItem[_itemId] == 0)
221         return priceInit; 
222     else 
223         return sellPriceOfItem[_itemId];
224   }
225   
226   function ownerInfoOf (uint256 _itemId) public view returns (uint256, string, string, string, string) {
227     require(_checkItemId(_itemId));    
228     return (_itemId, ownerInfoOfItem[_itemId].ownerName, ownerInfoOfItem[_itemId].ownerWords, ownerInfoOfItem[_itemId].ownerImg, ownerInfoOfItem[_itemId].ownerNation);
229   }
230 
231   function itemOf (uint256 _itemId) public view returns (uint256, string, address, uint256, uint256) {
232     require(_checkItemId(_itemId));
233     return (_itemId, nameOfItem[_itemId], ownerOf(_itemId), priceOf(_itemId), sellPriceOf(_itemId));
234   }
235 
236   function itemsRange (uint256 _from, uint256 _take) public view returns (uint256[], uint256[], uint256[]) {
237     require(idMax.add(1) >= idStart.add(_from.add(_take)));    
238 
239     uint256[] memory items = new uint256[](_take);    
240     uint256[] memory prices = new uint256[](_take);
241     uint256[] memory sellPrices = new uint256[](_take);    
242 
243     for (uint256 i = _from; i < _from.add(_take); i++) {  
244       uint256 j = i - _from;    
245       items[j] = idStart + i;      
246       prices[j] = priceOf(idStart + i);
247       sellPrices[j] = sellPriceOf(idStart + i);     
248     }
249    
250     return (items, prices, sellPrices);
251     
252   }
253  
254   function tokensOf (address _owner) public view returns (uint256[], address[], uint256[], uint256[]) {   
255     uint256 num = balanceOf(_owner);
256     uint256[] memory items = new uint256[](num);
257     address[] memory owners = new address[](num);
258     uint256[] memory prices = new uint256[](num);
259     uint256[] memory sellPrices = new uint256[](num);
260     uint256 k = 0;
261 
262     for (uint256 i = 0; i < listedItems.length; i++) {
263       if (ownerOf(listedItems[i]) == _owner) {
264           items[k] = listedItems[i];
265           owners[k] = ownerOf(listedItems[i]);
266           prices[k] = priceOf(listedItems[i]);
267           sellPrices[k] = sellPriceOf(listedItems[i]);
268           k++;
269       }
270     }
271    
272     return (items, owners, prices, sellPrices);
273   }
274 
275   /* ERC721 */
276   function implementsERC721 () public pure returns (bool _implements) {
277     return true;
278   }
279 
280   function balanceOf (address _owner) public view returns (uint256 _balance) {
281     require(_owner != address(0));
282     uint256 counter = 0;
283 
284     for (uint256 i = 0; i < listedItems.length; i++) {
285       if (ownerOf(listedItems[i]) == _owner) {
286         counter++;
287       }
288     }
289 
290     return counter;
291   }
292 
293   function ownerOf (uint256 _itemId) public view returns (address _owner) {
294     return ownerOfItem[_itemId];
295   }
296 
297   function transfer(address _to, uint256 _itemId) public {
298     require(msg.sender == ownerOf(_itemId));
299     _transfer(msg.sender, _to, _itemId);
300   }
301 
302   function transferFrom(address _from, address _to, uint256 _itemId) public {
303     require(getApproved(_itemId) == msg.sender);
304     _transfer(_from, _to, _itemId);
305   }
306 
307   function approve(address _to, uint256 _itemId) public {
308     require(msg.sender != _to);
309     require(tokenExists(_itemId));
310     require(ownerOf(_itemId) == msg.sender);
311 
312     if (_to == address(0)) {
313       if (approvedOfItem[_itemId] != address(0)) {
314         delete approvedOfItem[_itemId];
315         emit Approval(msg.sender, address(0), _itemId);
316       }
317     } else {
318       approvedOfItem[_itemId] = _to;
319       emit Approval(msg.sender, _to, _itemId);
320     }
321   }
322 
323   function getApproved (uint256 _itemId) public view returns (address _approved) {
324     require(tokenExists(_itemId));
325     return approvedOfItem[_itemId];
326   }
327 
328   function name () public pure returns (string _name) {
329     return "Crypto Super Girlfriend";
330   }
331 
332   function symbol () public pure returns (string _symbol) {
333     return "CSGF";
334   }
335  
336   function totalSupply () public view returns (uint256 _totalSupply) {
337     return listedItems.length;
338   }  
339 
340   function tokenByIndex (uint256 _index) public view returns (uint256 _itemId) {
341     require(_index < totalSupply());
342     return listedItems[_index];
343   }
344 
345   function tokenOfOwnerByIndex (address _owner, uint256 _index) public view returns (uint256 _itemId) {
346     require(_index < balanceOf(_owner));
347 
348     uint count = 0;
349     for (uint i = 0; i < listedItems.length; i++) {
350       uint itemId = listedItems[i];
351       if (ownerOf(itemId) == _owner) {
352         if (count == _index) { return itemId; }
353         count += 1;
354       }
355     }
356 
357     assert(false);
358   }
359 
360   /* Internal */
361   function _transfer(address _from, address _to, uint256 _itemId) internal {
362     require(tokenExists(_itemId));
363     require(ownerOf(_itemId) == _from);
364     require(_to != address(0));
365     require(_to != address(this));
366 
367     ownerOfItem[_itemId] = _to;
368     approvedOfItem[_itemId] = 0;
369 
370     emit Transfer(_from, _to, _itemId);
371   }
372 
373   function _checkItemId(uint256 _itemId) internal view returns (bool) {
374    if(_itemId.sub(idStart) >= 0 && idMax.sub(_itemId) >= 0) return true; 
375    return false;
376   }
377   
378 }