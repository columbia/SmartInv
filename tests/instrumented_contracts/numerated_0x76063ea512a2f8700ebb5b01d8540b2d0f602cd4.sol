1 pragma solidity ^0.4.25;
2 /* 
3   this version of tradiing contracts uses mappings insead of array to keep track of
4   weapons on sale
5  */
6 
7 library SafeMath {
8   function mul(uint256 a, uint256 b) internal pure returns (uint256) {
9     if (a == 0) {
10       return 0;
11     }
12     uint256 c = a * b;
13     assert(c / a == b);
14     return c;
15   }
16   function div(uint256 a, uint256 b) internal pure returns (uint256) {
17     // assert(b > 0); // Solidity automatically throws when dividing by 0
18     uint256 c = a / b;
19     // assert(a == b * c + a % b); // There is no case in which this doesn't hold
20     return c;
21   }
22   function sub(uint256 a, uint256 b) internal pure returns (uint256) {
23     assert(b <= a);
24     return a - b;
25   }
26   function add(uint256 a, uint256 b) internal pure returns (uint256) {
27     uint256 c = a + b;
28     assert(c >= a && c>=b);
29     return c;
30   }
31 }
32 
33 contract WeaponTokenize {
34   event GameProprietaryDataUpdated(uint weaponId, string gameData);
35   event PublicDataUpdated(uint weaponId, string publicData);
36   event OwnerProprietaryDataUpdated(uint weaponId, string ownerProprietaryData);
37   event WeaponAdded(uint weaponId, string gameData, string publicData, string ownerData);
38   function updateOwnerOfWeapon (uint, address) public  returns(bool res);
39   function getOwnerOf (uint _weaponId) public view returns(address _owner) ;
40 }
41 
42 contract ERC20Interface {
43   function transfer(address to, uint tokens) public returns (bool success);
44   function balanceOf(address _sender) public returns (uint _bal);
45   function allowance(address tokenOwner, address spender) public view returns (uint remaining);
46   event Transfer(address indexed from, address indexed to, uint tokens);
47       function transferFrom(address from, address to, uint tokens) public returns (bool success);
48 }
49 
50 
51 contract TradeWeapon {
52   using SafeMath for uint;
53   // state variables
54   address public owner;
55   WeaponTokenize public weaponTokenize;
56   ERC20Interface public RCCToken;
57   uint public rate = 100; // 1 ETH = 100 RCC
58   uint public commssion_n = 50; // 1% commssion of each trade from both buyers and sellers
59   uint public commssion_d = 100;
60   bool public saleDisabled = false;
61   bool public ethSaleDisabled = false;
62 
63   // statics
64   uint public totalOrdersPlaced = 0;
65   uint public totalOrdersCancelled = 0;
66   uint public totalOrdersMatched = 0;
67 
68   struct item{
69     uint sellPrice;
70     uint commssion;
71     address seller;
72   }
73 
74   // this mapping contains weaponId to details of sale
75   mapping (uint => item) public weaponDetail;
76   // total weapon on Sale
77   uint totalWeaponOnSale;
78   // index => weaponId
79   mapping(uint => uint) public indexToWeaponId;
80   // weaponId => index
81   mapping(uint => uint) public weaponIdToIndex;
82   // mapping of weaponId to saleStatus
83   mapping (uint => bool) public isOnSale;
84   // address to operator
85   mapping (address => mapping(address => bool)) private operators;
86   
87   // events
88   event OrderPlaced(address _seller, address _placedBy, uint _weaponId, uint _sp);
89   event OderUpdated(address _seller, address _placedBy, uint _weaponId, uint _sp);
90   event OrderCacelled(address _placedBy, uint _weaponId);
91   event OrderMatched(address _buyer, address _seller, uint _sellPrice, address _placedBy, uint _commssion, string _payType);
92   
93   constructor (address _tokenizeAddress, address _rccAddress) public{
94     owner = msg.sender;
95     weaponTokenize =  WeaponTokenize(_tokenizeAddress);
96     RCCToken = ERC20Interface(_rccAddress);
97   }
98 
99   modifier onlyOwnerOrOperator(uint _weaponId) {
100     address weaponOwner = weaponTokenize.getOwnerOf(_weaponId);
101     require (
102       (msg.sender == weaponOwner ||
103       checkOperator(weaponOwner, msg.sender)
104       ), '2');
105     _;
106   }
107 
108   modifier onlyIfOnSale(uint _weaponId) {
109     require(isOnSale[_weaponId], '3');
110     _;
111   }
112 
113   modifier ifSaleLive(){
114     require(!saleDisabled, '6');
115     _;
116   }
117 
118   modifier ifEthSaleLive() {
119     require(!ethSaleDisabled, '7');
120     _;
121   }
122 
123   modifier onlyOwner() {
124     require (msg.sender == owner, '1');
125     _;
126   }
127 
128   ///////////////////////////////////////////////////////////////////////////////////
129                     // Only Owner //
130   ///////////////////////////////////////////////////////////////////////////////////
131 
132   function updateRate(uint _newRate) onlyOwner public {
133     rate = _newRate;
134   }
135 
136   function updateCommission(uint _commssion_n, uint _commssion_d) onlyOwner public {
137     commssion_n = _commssion_n;
138     commssion_d = _commssion_d;
139   }
140 
141   function disableSale() public onlyOwner {
142     saleDisabled = true;
143   }
144 
145   function enableSale() public onlyOwner {
146     saleDisabled = false;
147   }
148 
149   function disableEthSale() public onlyOwner {
150     ethSaleDisabled = false;
151   }
152 
153   function enableEthSale() public onlyOwner {
154     ethSaleDisabled = true;
155   }
156 
157   ///////////////////////////////////////////////////////////////////////////////////
158                     // Public Functions //
159   ///////////////////////////////////////////////////////////////////////////////////
160 
161   function addOperator(address newOperator) public{
162     operators[msg.sender][newOperator] =  true;
163   }
164 
165   function removeOperator(address _operator) public {
166     operators[msg.sender][_operator] =  false;
167   }
168 
169 
170 
171   function sellWeapon(uint _weaponId, uint _sellPrice) ifSaleLive onlyOwnerOrOperator(_weaponId) public {
172     // weapon should not be already on sale
173     require( ! isOnSale[_weaponId], '4');
174     // get owner of weapon from Tokenization contract
175     address weaponOwner = weaponTokenize.getOwnerOf(_weaponId);
176     // calculate commssion
177     uint _commssion = calculateCommission(_sellPrice);
178     
179     item memory testItem = item(_sellPrice, _commssion, weaponOwner);
180     // put weapon on sale
181     putWeaponOnSale(_weaponId, testItem);
182     // emit sell event
183     emit OrderPlaced(weaponOwner, msg.sender, _weaponId, _sellPrice);
184   }
185 
186   function updateSale(uint _weaponId, uint _sellPrice) ifSaleLive onlyIfOnSale(_weaponId) onlyOwnerOrOperator(_weaponId) public {
187     // calculate commssion
188     uint _commssion = calculateCommission(_sellPrice);
189     // get owner of weapon
190     address weaponOwner = weaponTokenize.getOwnerOf(_weaponId);
191     item memory testItem = item(_sellPrice ,_commssion, weaponOwner);
192     weaponDetail[_weaponId] = testItem;
193     emit OderUpdated(weaponOwner, msg.sender, _weaponId, _sellPrice);
194   }
195 
196 
197   function cancelSale(uint _weaponId) ifSaleLive onlyIfOnSale(_weaponId) onlyOwnerOrOperator(_weaponId) public {
198     (address weaponOwner,,) = getWeaponDetails(_weaponId);
199     removeWeaponFromSale(_weaponId);
200     totalOrdersCancelled = totalOrdersCancelled.add(1);
201     weaponTokenize.updateOwnerOfWeapon(_weaponId, weaponOwner);
202     emit OrderCacelled(msg.sender, _weaponId);
203   }
204 
205   function buyWeaponWithRCC(uint _weaponId, address _buyer) ifSaleLive onlyIfOnSale(_weaponId) public{
206     if (_buyer != address(0)){
207       buywithRCC(_weaponId, _buyer);
208     }else{
209       buywithRCC(_weaponId, msg.sender);
210     }
211   }
212 
213   function buyWeaponWithEth(uint _weaponId, address _buyer) ifSaleLive ifEthSaleLive onlyIfOnSale(_weaponId) public payable {
214     if (_buyer != address(0)){
215       buywithEth(_weaponId, _buyer, msg.value);
216     }else{
217       buywithEth(_weaponId, msg.sender, msg.value);
218     }
219   }
220 
221 
222   ///////////////////////////////////////////////////////////////////////////////////
223                     // Internal Fns //
224   ///////////////////////////////////////////////////////////////////////////////////
225 
226   function buywithRCC(uint _weaponId, address _buyer) internal {
227     // get details of weapon on sale
228     (address seller, uint spOfWeapon, uint commssion) = getWeaponDetails(_weaponId);
229     // get allowance to trading contract from buyer
230     uint allowance = RCCToken.allowance(_buyer, address(this));
231     // calculate selling price (= sp + commission)
232     uint sellersPrice = spOfWeapon.sub(commssion);
233     require(allowance >= spOfWeapon, '5');
234     // delete weapon for sale
235     removeWeaponFromSale(_weaponId);
236     // transfer coins
237     if(spOfWeapon > 0){
238       RCCToken.transferFrom(_buyer, seller, sellersPrice);
239     }
240     if(commssion > 0){
241       RCCToken.transferFrom(_buyer, owner, commssion);
242     }
243     // add to total orders matched
244 	  totalOrdersMatched = totalOrdersMatched.add(1);
245     // update ownership to buyer
246     weaponTokenize.updateOwnerOfWeapon(_weaponId, _buyer);
247     emit OrderMatched(_buyer, seller, spOfWeapon, msg.sender, commssion, 'RCC');
248   }
249 
250   function buywithEth(uint _weaponId, address _buyer, uint weiPaid) internal {
251     // basic validations
252     require ( rate > 0, '8');
253 
254     // get weapon details
255     (address seller, uint spOfWeapon, uint commssion) = getWeaponDetails(_weaponId);
256 
257     // calculate prices in wei
258     uint spInWei = spOfWeapon.div(rate);
259     require(spInWei > 0, '9');
260     require(weiPaid == spInWei, '10');
261     uint sellerPrice = spOfWeapon.sub(commssion);
262 
263     // send RCC to seller
264     require (RCCToken.balanceOf(address(this)) >= sellerPrice, '11');
265     RCCToken.transfer(seller, sellerPrice);
266 
267     // send ETH to admin
268     //address(owner).transfer(weiPaid);
269 
270     // remove weapon from sale
271     removeWeaponFromSale(_weaponId);
272 
273     // add to total orders matched
274 	  totalOrdersMatched = totalOrdersMatched.add(1);
275 
276     // transfer weapon to buyer
277     weaponTokenize.updateOwnerOfWeapon(_weaponId, _buyer);
278     emit OrderMatched(_buyer, seller, spOfWeapon,  msg.sender, commssion, 'ETH');
279   } 
280 
281   function putWeaponOnSale(uint _weaponId, item memory _testItem) internal {
282     // chnage ownership of weapon to this contract
283     weaponTokenize.updateOwnerOfWeapon(_weaponId, address(this));
284     // allocate last index to this weapon id
285     indexToWeaponId[totalWeaponOnSale.add(1)] = _weaponId;
286     //
287     weaponIdToIndex[_weaponId] = totalWeaponOnSale.add(1);
288     // increase totalWeapons
289     totalWeaponOnSale = totalWeaponOnSale.add(1);
290     // map weaponId to weaponDetail
291     weaponDetail[_weaponId] = _testItem;
292     // set on sale flag to true
293     isOnSale[_weaponId] = true;
294     // add to total orders placed
295     totalOrdersPlaced = totalOrdersPlaced.add(1);
296   }
297 
298   function removeWeaponFromSale(uint _weaponId) internal {
299     // set on sale property to false
300     isOnSale[_weaponId] = false;
301     // reset values of struct
302     weaponDetail[_weaponId] = item(0, 0,address(0));
303     uint indexOfDeletedWeapon = weaponIdToIndex[_weaponId];
304     if(indexOfDeletedWeapon != totalWeaponOnSale){
305       uint weaponAtLastIndex = indexToWeaponId[totalWeaponOnSale];
306       // map last elment to current one
307       weaponIdToIndex[weaponAtLastIndex] = indexOfDeletedWeapon;
308       indexToWeaponId[indexOfDeletedWeapon] = weaponAtLastIndex;
309       // last element to 0
310       weaponIdToIndex[_weaponId] = 0;
311       indexToWeaponId[totalWeaponOnSale] = 0;
312     } else{
313       weaponIdToIndex[_weaponId] = 0;
314       indexToWeaponId[indexOfDeletedWeapon] = 0;
315     }
316     totalWeaponOnSale = totalWeaponOnSale.sub(1);
317   }
318 
319   ///////////////////////////////////////////////////////////////////////////////////
320                     // Constant functions //
321   ///////////////////////////////////////////////////////////////////////////////////
322 
323   function getWeaponDetails (uint _weaponId) public view returns (address, uint, uint) {
324     item memory currentItem = weaponDetail[_weaponId];
325     return (currentItem.seller, currentItem.sellPrice, currentItem.commssion);
326   }
327 
328   function calculateCommission (uint _amount) public view returns (uint) {
329     return _amount.mul(commssion_n).div(commssion_d).div(100);
330   }
331 
332   function getTotalWeaponOnSale() public view returns (uint) {
333     return totalWeaponOnSale;
334   }
335 
336   function getWeaponAt(uint index) public view returns(address, uint, uint, uint) {
337     uint weaponId =  indexToWeaponId[index];
338     item memory currentItem = weaponDetail[weaponId];
339     return (currentItem.seller, currentItem.sellPrice, currentItem.commssion, weaponId);
340   }
341 
342   function checkOperator(address _user, address _operator) public view returns (bool){
343     return operators[_user][_operator];
344   }
345 
346 }