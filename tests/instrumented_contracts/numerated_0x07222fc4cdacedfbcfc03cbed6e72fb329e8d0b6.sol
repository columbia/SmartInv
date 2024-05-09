1 pragma solidity ^0.4.20;
2 
3 library SafeMath {
4 
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
15     // assert(b > 0); // Solidity automatically throws when dividing by 0
16     uint256 c = a / b;
17     // assert(a == b * c + a % b); // There is no case in which this doesn't hold
18     return c;
19   }
20 
21   function sub(uint256 a, uint256 b) internal pure returns (uint256) {
22     assert(b <= a);
23     return a - b;
24   }
25 
26   function add(uint256 a, uint256 b) internal pure returns (uint256) {
27     uint256 c = a + b;
28     assert(c >= a);
29     return c;
30   }
31 }
32 
33 contract Ownable {
34 
35   address public coOwner;
36 
37   function Ownable() public {
38     coOwner = msg.sender;
39   }
40 
41   modifier onlyCoOwner() {
42     require(msg.sender == coOwner);
43     _;
44   }
45 
46   function transferCoOwnership(address _newOwner) public onlyCoOwner {
47     require(_newOwner != address(0));
48 
49     coOwner = _newOwner;
50 
51     CoOwnershipTransferred(coOwner, _newOwner);
52   }
53   
54   function CoWithdraw() public onlyCoOwner {
55       coOwner.transfer(this.balance);
56   }  
57   
58   event CoOwnershipTransferred(address indexed previousOwner, address indexed newOwner);
59 }
60 
61 /// @title Interface for contracts conforming to ERC-721: Non-Fungible Tokens
62 /// @author Dieter Shirley <dete@axiomzen.co> (https://github.com/dete)
63 contract ERC721 {
64   // Required methods
65   function approve(address _to, uint256 _tokenId) public;
66   function balanceOf(address _owner) public view returns (uint256 balance);
67   function implementsERC721() public pure returns (bool);
68   function ownerOf(uint256 _tokenId) public view returns (address addr);
69   function takeOwnership(uint256 _tokenId) public;
70   function totalSupply() public view returns (uint256 total);
71   function transferFrom(address _from, address _to, uint256 _tokenId) public;
72   function transfer(address _to, uint256 _tokenId) public;
73 
74   event Transfer(address indexed from, address indexed to, uint256 tokenId);
75   event Approval(address indexed owner, address indexed approved, uint256 tokenId);
76 
77   // Optional
78   // function name() public view returns (string name);
79   // function symbol() public view returns (string symbol);
80   // function tokenOfOwnerByIndex(address _owner, uint256 _index) external view returns (uint256 tokenId);
81   // function tokenMetadata(uint256 _tokenId) public view returns (string infoUrl);
82 }
83 
84 contract CryptoCarsRent is ERC721, Ownable {
85 
86   event CarCreated(uint256 tokenId, string name, address owner);
87   event TokenSold(uint256 tokenId, uint256 oldPrice, uint256 newPrice, address prevOwner, address winner, string name);
88   event Transfer(address from, address to, uint256 tokenId);
89 
90   string public constant NAME = "CryptoCars";
91   string public constant SYMBOL = "CarsToken";
92 
93   uint256 private startingSellPrice = 0.012 ether;
94 
95   mapping (uint256 => address) public carIdToOwner;
96 
97   mapping (uint256 => address) public carIdToRenter;
98   mapping (uint256 => uint256) public carIdRentStartTime;
99 
100   mapping (address => uint256) private ownershipTokenCount;
101 
102   mapping (uint256 => address) public carIdToApproved;
103 
104   mapping (uint256 => uint256) private carIdToPrice;
105   mapping (uint256 => uint256) private carIdToProfit;
106 
107   /*** DATATYPES ***/
108   struct Car {
109     string name;
110   }
111 
112   Car[] private cars;
113 
114   function approve(address _to, uint256 _tokenId) public { //ERC721
115     // Caller must own token.
116     require(_owns(msg.sender, _tokenId));
117     carIdToApproved[_tokenId] = _to;
118     Approval(msg.sender, _to, _tokenId);
119   }
120 
121   function balanceOf(address _owner) public view returns (uint256 balance) { //ERC721
122     return ownershipTokenCount[_owner];
123   }
124 
125   function createCarToken(string _name) public onlyCoOwner {
126     _createCar(_name, address(this), startingSellPrice);
127   }
128 
129   function createCarsTokens() public onlyCoOwner {
130 
131 	for (uint8 car=0; car<21; car++) {
132 	   _createCar("Crypto Car", address(this), startingSellPrice);
133 	 }
134 
135   }
136   
137   function getCar(uint256 _tokenId) public view returns (string carName, uint256 sellingPrice, address owner) {
138     Car storage car = cars[_tokenId];
139     carName = car.name;
140     sellingPrice = carIdToPrice[_tokenId];
141     owner = carIdToOwner[_tokenId];
142   }
143 
144   function implementsERC721() public pure returns (bool) {
145     return true;
146   }
147 
148   function name() public pure returns (string) { //ERC721
149     return NAME;
150   }
151 
152   function ownerOf(uint256 _tokenId) public view returns (address owner) { //ERC721
153     owner = carIdToOwner[_tokenId];
154     require(owner != address(0));
155   }
156 
157   // Allows someone to send ether and obtain the token
158   function purchase(uint256 _tokenId) public payable {
159     address oldOwner = carIdToOwner[_tokenId];
160     address newOwner = msg.sender;
161 	uint256 renter_payment;
162 	uint256 payment;
163 	
164 	if (now - carIdRentStartTime[_tokenId] > 7200) // 2 hours of rent finished
165 		carIdToRenter[_tokenId] = address(0);
166 		
167 	address renter = carIdToRenter[_tokenId];
168 
169     uint256 sellingPrice = carIdToPrice[_tokenId];
170 	uint256 profit = carIdToProfit[_tokenId];
171 
172     require(oldOwner != newOwner);
173     require(_addressNotNull(newOwner));
174     require(msg.value >= sellingPrice);
175 	
176 	
177 
178     if (renter != address(0)) {
179 		renter_payment = uint256(SafeMath.div(SafeMath.mul(profit, 45), 100)); //45% from profit to car's renter
180 		payment = uint256(SafeMath.sub(SafeMath.div(SafeMath.mul(sellingPrice, 97), 100), renter_payment)); //'97% - renter_payment' to previous owner
181 	} else {
182 		renter_payment = 0;
183 		payment = uint256(SafeMath.div(SafeMath.mul(sellingPrice, 94), 100)); //94% to previous owner
184 	}
185 
186 	
187     // Next price will in 2 times more.
188 	if (sellingPrice < 500 finney) {
189 		carIdToPrice[_tokenId] = SafeMath.mul(sellingPrice, 2); //rice by 100%
190 	}
191 	else {
192 		carIdToPrice[_tokenId] = uint256(SafeMath.div(SafeMath.mul(sellingPrice, 15), 10)); //rice by 50%
193 	}
194 	
195     //plannig profit from next selling
196   	carIdToProfit[_tokenId] = uint256(SafeMath.sub(carIdToPrice[_tokenId], sellingPrice));
197     carIdToRenter[_tokenId] = address(0);
198 	carIdRentStartTime[_tokenId] =  0;
199 	
200     _transfer(oldOwner, newOwner, _tokenId);
201 
202     // Pay previous tokenOwner if owner is not contract
203     if (oldOwner != address(this)) {
204       oldOwner.transfer(payment); //
205     }
206 
207     // Pay to token renter 
208     if (renter != address(0)) {
209       renter.transfer(renter_payment); //
210     }
211 
212     TokenSold(_tokenId, sellingPrice, carIdToPrice[_tokenId], oldOwner, newOwner, cars[_tokenId].name);
213 	
214     if (msg.value > sellingPrice) { //if excess pay
215 	    uint256 purchaseExcess = SafeMath.sub(msg.value, sellingPrice);
216 		msg.sender.transfer(purchaseExcess);
217 	}
218   }
219 
220   function rent(uint256 _tokenId) public payable {
221 	require(now - carIdRentStartTime[_tokenId] > 7200); // 2 hours of previous rent finished
222 	require(msg.sender != carIdToOwner[_tokenId]);
223 	
224 	uint256 profit = carIdToProfit[_tokenId]; //plannig profit from selling 
225 	uint256 rentPrice = uint256(SafeMath.div(SafeMath.mul(profit, 10), 100)); //10% from profit is a rent price
226      
227     require(_addressNotNull(msg.sender));
228     require(msg.value >= rentPrice);	 
229 	
230 	carIdRentStartTime[_tokenId] = now;
231 	carIdToRenter[_tokenId] = msg.sender;
232 	
233 	address carOwner = carIdToOwner[_tokenId];
234 	require(carOwner != address(this));
235 	
236 	
237     if (carOwner != address(this)) {
238       carOwner.transfer(rentPrice); //
239     }
240 	
241     if (msg.value > rentPrice) { //if excess pay
242 	    uint256 purchaseExcess = SafeMath.sub(msg.value, rentPrice);
243 		msg.sender.transfer(purchaseExcess);
244 	}	
245   }
246   
247   
248   function symbol() public pure returns (string) { //ERC721
249     return SYMBOL;
250   }
251 
252 
253   function takeOwnership(uint256 _tokenId) public { //ERC721
254     address newOwner = msg.sender;
255     address oldOwner = carIdToOwner[_tokenId];
256 
257     require(_addressNotNull(newOwner));
258     require(_approved(newOwner, _tokenId));
259 
260     _transfer(oldOwner, newOwner, _tokenId);
261   }
262   
263   function allCarsInfo() public view returns (address[] owners, address[] renters, uint256[] prices, uint256[] profits) { //for web site view
264 	
265 	uint256 totalResultCars = totalSupply();
266 	
267     if (totalResultCars == 0) {
268         // Return an empty array
269       return (new address[](0),new address[](0),new uint256[](0),new uint256[](0));
270     }
271 	
272 	address[] memory owners_res = new address[](totalResultCars);
273 	address[] memory renters_res = new address[](totalResultCars);
274 	uint256[] memory prices_res = new uint256[](totalResultCars);
275 	uint256[] memory profits_res = new uint256[](totalResultCars);
276 	
277 	for (uint256 carId = 0; carId < totalResultCars; carId++) {
278 	  owners_res[carId] = carIdToOwner[carId];
279 	  if (now - carIdRentStartTime[carId] <= 7200) // 2 hours of rent finished
280 		renters_res[carId] = carIdToRenter[carId];
281 	  else 
282 		renters_res[carId] = address(0);
283 		
284 	  prices_res[carId] = carIdToPrice[carId];
285 	  profits_res[carId] = carIdToProfit[carId];
286 	}
287 	
288 	return (owners_res, renters_res, prices_res, profits_res);
289   }  
290 
291   function priceOf(uint256 _tokenId) public view returns (uint256 price) { //for web site view
292     return carIdToPrice[_tokenId];
293   }
294   
295   function tokensOfOwner(address _owner) public view returns(uint256[] ownerTokens) { //for web site view
296     uint256 tokenCount = balanceOf(_owner);
297     if (tokenCount == 0) {
298         // Return an empty array
299       return new uint256[](0);
300     } else {
301       uint256[] memory result = new uint256[](tokenCount);
302       uint256 totalCars = totalSupply();
303       uint256 resultIndex = 0;
304 
305       uint256 carId;
306       for (carId = 0; carId <= totalCars; carId++) {
307         if (carIdToOwner[carId] == _owner) {
308           result[resultIndex] = carId;
309           resultIndex++;
310         }
311       }
312       return result;
313     }
314   }
315 
316   function totalSupply() public view returns (uint256 total) { //ERC721
317     return cars.length;
318   }
319 
320   function transfer(address _to, uint256 _tokenId) public { //ERC721
321     require(_owns(msg.sender, _tokenId));
322     require(_addressNotNull(_to));
323 
324 	_transfer(msg.sender, _to, _tokenId);
325   }
326 
327   function transferFrom(address _from, address _to, uint256 _tokenId) public { //ERC721
328     require(_owns(_from, _tokenId));
329     require(_approved(_to, _tokenId));
330     require(_addressNotNull(_to));
331 
332     _transfer(_from, _to, _tokenId);
333   }
334 
335 
336   /* PRIVATE FUNCTIONS */
337   function _addressNotNull(address _to) private pure returns (bool) {
338     return _to != address(0);
339   }
340 
341   function _approved(address _to, uint256 _tokenId) private view returns (bool) {
342     return carIdToApproved[_tokenId] == _to;
343   }
344 
345   function _createCar(string _name, address _owner, uint256 _price) private {
346     Car memory _car = Car({
347       name: _name
348     });
349     uint256 newCarId = cars.push(_car) - 1;
350 
351     require(newCarId == uint256(uint32(newCarId))); //check maximum limit of tokens
352 
353     CarCreated(newCarId, _name, _owner);
354 
355     carIdToPrice[newCarId] = _price;
356 
357     _transfer(address(0), _owner, newCarId);
358   }
359 
360   function _owns(address _checkedAddr, uint256 _tokenId) private view returns (bool) {
361     return _checkedAddr == carIdToOwner[_tokenId];
362   }
363 
364 function _transfer(address _from, address _to, uint256 _tokenId) private {
365     ownershipTokenCount[_to]++;
366     carIdToOwner[_tokenId] = _to;
367 
368     // When creating new cars _from is 0x0, but we can't account that address.
369     if (_from != address(0)) {
370       ownershipTokenCount[_from]--;
371       // clear any previously approved ownership exchange
372       delete carIdToApproved[_tokenId];
373     }
374 
375     // Emit the transfer event.
376     Transfer(_from, _to, _tokenId);
377   }
378 }