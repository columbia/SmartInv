1 pragma solidity ^0.4.18;
2 
3 /**
4  * @title Ownable
5  * @dev The Ownable contract has an owner address, and provides basic authorization control
6  * functions, this simplifies the implementation of "user permissions".
7  */
8 contract Ownable {
9   address public ownerAddress;
10 
11   event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
12 
13   /**
14    * @dev The Ownable constructor sets the original `owner` of the contract to the sender
15    * account.
16    */
17   function Ownable() public {
18     ownerAddress = msg.sender;
19   }
20 
21 
22   /**
23    * @dev Throws if called by any account other than the owner.
24    */
25   modifier onlyOwner() {
26     require(msg.sender == ownerAddress);
27     _;
28   }
29 
30   /**
31    * @dev Allows the current owner to transfer control of the contract to a newOwner.
32    * @param newOwner The address to transfer ownership to.
33    */
34   function transferOwnership(address newOwner) public onlyOwner {
35     require(newOwner != address(0));
36     OwnershipTransferred(ownerAddress, newOwner);
37     ownerAddress = newOwner;
38   }
39 
40 
41 }
42 
43 
44 /**
45  * @title SafeMath
46  * @dev Math operations with safety checks that throw on error
47  */
48 library SafeMath {
49 
50   /**
51   * @dev Multiplies two numbers, throws on overflow.
52   */
53   function mul(uint256 a, uint256 b) internal pure returns (uint256) {
54     if (a == 0) {
55       return 0;
56     }
57     uint256 c = a * b;
58     assert(c / a == b);
59     return c;
60   }
61 
62   /**
63   * @dev Integer division of two numbers, truncating the quotient.
64   */
65   function div(uint256 a, uint256 b) internal pure returns (uint256) {
66     // assert(b > 0); // Solidity automatically throws when dividing by 0
67     uint256 c = a / b;
68     // assert(a == b * c + a % b); // There is no case in which this doesn't hold
69     return c;
70   }
71 
72   /**
73   * @dev Subtracts two numbers, throws on overflow (i.e. if subtrahend is greater than minuend).
74   */
75   function sub(uint256 a, uint256 b) internal pure returns (uint256) {
76     assert(b <= a);
77     return a - b;
78   }
79 
80   /**
81   * @dev Adds two numbers, throws on overflow.
82   */
83   function add(uint256 a, uint256 b) internal pure returns (uint256) {
84     uint256 c = a + b;
85     assert(c >= a);
86     return c;
87   }
88 }
89 
90 /**
91  * @title SafeMath32
92  * @dev SafeMath library implemented for uint32
93  */
94 library SafeMath32 {
95 
96   function mul(uint32 a, uint32 b) internal pure returns (uint32) {
97     if (a == 0) {
98       return 0;
99     }
100     uint32 c = a * b;
101     assert(c / a == b);
102     return c;
103   }
104 
105   function div(uint32 a, uint32 b) internal pure returns (uint32) {
106     // assert(b > 0); // Solidity automatically throws when dividing by 0
107     uint32 c = a / b;
108     // assert(a == b * c + a % b); // There is no case in which this doesn't hold
109     return c;
110   }
111 
112   function sub(uint32 a, uint32 b) internal pure returns (uint32) {
113     assert(b <= a);
114     return a - b;
115   }
116 
117   function add(uint32 a, uint32 b) internal pure returns (uint32) {
118     uint32 c = a + b;
119     assert(c >= a);
120     return c;
121   }
122 }
123 
124 /**
125  * @title SafeMath16
126  * @dev SafeMath library implemented for uint16
127  */
128 library SafeMath16 {
129 
130   function mul(uint16 a, uint16 b) internal pure returns (uint16) {
131     if (a == 0) {
132       return 0;
133     }
134     uint16 c = a * b;
135     assert(c / a == b);
136     return c;
137   }
138 
139   function div(uint16 a, uint16 b) internal pure returns (uint16) {
140     // assert(b > 0); // Solidity automatically throws when dividing by 0
141     uint16 c = a / b;
142     // assert(a == b * c + a % b); // There is no case in which this doesn't hold
143     return c;
144   }
145 
146   function sub(uint16 a, uint16 b) internal pure returns (uint16) {
147     assert(b <= a);
148     return a - b;
149   }
150 
151   function add(uint16 a, uint16 b) internal pure returns (uint16) {
152     uint16 c = a + b;
153     assert(c >= a);
154     return c;
155   }
156 }
157 
158 
159 
160 contract ERC721 {
161   event Transfer(address indexed _from, address indexed _to, uint256 _tokenId);
162   event Approval(address indexed _owner, address indexed _approved, uint256 _tokenId);
163 
164   function balanceOf(address _owner) public view returns (uint256 _balance);
165   function ownerOf(uint256 _tokenId) public view returns (address _owner);
166   function transfer(address _to, uint256 _tokenId) public;
167   function approve(address _to, uint256 _tokenId) public;
168   function takeOwnership(uint256 _tokenId) public;
169 }
170 
171 
172 contract Solethium is Ownable, ERC721 {
173 
174     uint16 private devCutPromille = 25;
175 
176     /**
177     ** @dev EVENTS
178     **/
179     event EventSolethiumObjectCreated(uint256 tokenId, string name);
180     event EventSolethiumObjectBought(address oldOwner, address newOwner, uint price);
181 
182     // @dev use SafeMath for the following uints
183     using SafeMath for uint256; // 1,15792E+77
184     using SafeMath for uint32; // 4294967296
185     using SafeMath for uint16; // 65536
186 
187     //  @dev an object - CrySolObject ( dev expression for Solethium Object)- contains relevant attributes only
188     struct CrySolObject {
189         string name;
190         uint256 price;
191         uint256 id;
192         uint16 parentID;
193         uint16 percentWhenParent;
194         address owner;
195         uint8 specialPropertyType; // 0=NONE, 1=PARENT_UP
196         uint8 specialPropertyValue; // example: 5 meaning 0,5 %
197     }
198     
199 
200     //  @dev an array of all CrySolObject objects in the game
201     CrySolObject[] public crySolObjects;
202     //  @dev integer - total number of CrySol Objects
203     uint16 public numberOfCrySolObjects;
204     //  @dev Total number of CrySol ETH worth in the game
205     uint256 public ETHOfCrySolObjects;
206 
207     mapping (address => uint) public ownerCrySolObjectsCount; // for owner address, track number on tokens owned
208     mapping (address => uint) public ownerAddPercentToParent; // adding additional percents to owners of some Objects when they have PARENT objects
209     mapping (address => string) public ownerToNickname; // for owner address, track his nickname
210 
211 
212     /**
213     ** @dev MODIFIERS
214     **/
215     modifier onlyOwnerOf(uint _id) {
216         require(msg.sender == crySolObjects[_id].owner);
217         _;
218     } 
219 
220     /**
221     ** @dev NEXT PRICE CALCULATIONS
222     **/
223 
224     uint256 private nextPriceTreshold1 = 0.05 ether;
225     uint256 private nextPriceTreshold2 = 0.3 ether;
226     uint256 private nextPriceTreshold3 = 1.0 ether;
227     uint256 private nextPriceTreshold4 = 5.0 ether;
228     uint256 private nextPriceTreshold5 = 10.0 ether;
229 
230     function calculateNextPrice (uint256 _price) public view returns (uint256 _nextPrice) {
231         if (_price <= nextPriceTreshold1) {
232             return _price.mul(200).div(100);
233         } else if (_price <= nextPriceTreshold2) {
234             return _price.mul(170).div(100);
235         } else if (_price <= nextPriceTreshold3) {
236             return _price.mul(150).div(100);
237         } else if (_price <= nextPriceTreshold4) {
238             return _price.mul(140).div(100);
239         } else if (_price <= nextPriceTreshold5) {
240             return _price.mul(130).div(100);
241         } else {
242             return _price.mul(120).div(100);
243         }
244     }
245 
246 
247 
248     /**
249     ** @dev this method is used to create CrySol Object
250     **/
251     function createCrySolObject(string _name, uint _price, uint16 _parentID, uint16 _percentWhenParent, uint8 _specialPropertyType, uint8 _specialPropertyValue) external onlyOwner() {
252         uint256 _id = crySolObjects.length;
253         crySolObjects.push(CrySolObject(_name, _price, _id, _parentID, _percentWhenParent, msg.sender, _specialPropertyType, _specialPropertyValue)) ; //insert into array
254         ownerCrySolObjectsCount[msg.sender] = ownerCrySolObjectsCount[msg.sender].add(1); // increase count for OWNER
255         numberOfCrySolObjects = (uint16)(numberOfCrySolObjects.add(1)); // increase count for Total number
256         ETHOfCrySolObjects = ETHOfCrySolObjects.add(_price); // increase total ETH worth of all tokens
257         EventSolethiumObjectCreated(_id, _name);
258 
259     }
260 
261     /**
262     ** @dev this method is used to GET CrySol Objects from one OWNER
263     **/
264     function getCrySolObjectsByOwner(address _owner) external view returns(uint[]) {
265         uint256 tokenCount = ownerCrySolObjectsCount[_owner];
266         if (tokenCount == 0) {
267             return new uint256[](0);
268         } else {
269             uint[] memory result = new uint[](tokenCount);
270             uint counter = 0;
271             for (uint i = 0; i < numberOfCrySolObjects; i++) {
272             if (crySolObjects[i].owner == _owner) {
273                     result[counter] = i;
274                     counter++;
275                 }
276             }
277             return result;
278         }
279     }
280 
281 
282     /**
283     ** @dev this method is used to GET ALL CrySol Objects in the game
284     **/
285     function getAllCrySolObjects() external view returns(uint[]) {
286         uint[] memory result = new uint[](numberOfCrySolObjects);
287         uint counter = 0;
288         for (uint i = 0; i < numberOfCrySolObjects; i++) {
289                 result[counter] = i;
290                 counter++;
291         }
292         return result;
293     }
294     
295     /**
296     ** @dev this method is used to calculate Developer's Cut in the game
297     **/
298     function returnDevelopersCut(uint256 _price) private view returns(uint) {
299             return _price.mul(devCutPromille).div(1000);
300     }
301 
302     /**
303     ** @dev this method is used to calculate Parent Object's Owner Cut in the game
304     ** owner of PARENT objects will get : percentWhenParent % from his Objects + any additional bonuses he may have from SPECIAL trade objects
305     ** that are increasing PARENT percentage
306     **/
307     function returnParentObjectCut( CrySolObject storage _obj, uint256 _price ) private view returns(uint) {
308         uint256 _percentWhenParent = crySolObjects[_obj.parentID].percentWhenParent + (ownerAddPercentToParent[crySolObjects[_obj.parentID].owner]).div(10);
309         return _price.mul(_percentWhenParent).div(100); //_parentCut
310     }
311 
312     
313      /**
314     ** @dev this method is used to TRANSFER OWNERSHIP of the CrySol Objects in the game on the BUY event
315     **/
316     function _transferOwnershipOnBuy(address _oldOwner, uint _id, address _newOwner) private {
317             // decrease count for original OWNER
318             ownerCrySolObjectsCount[_oldOwner] = ownerCrySolObjectsCount[_oldOwner].sub(1); 
319 
320             // new owner gets ownership
321             crySolObjects[_id].owner = _newOwner;  
322             ownerCrySolObjectsCount[_newOwner] = ownerCrySolObjectsCount[_newOwner].add(1); // increase count for the new OWNER
323 
324             ETHOfCrySolObjects = ETHOfCrySolObjects.sub(crySolObjects[_id].price);
325             crySolObjects[_id].price = calculateNextPrice(crySolObjects[_id].price); // now, calculate and update next price
326             ETHOfCrySolObjects = ETHOfCrySolObjects.add(crySolObjects[_id].price);
327     }
328     
329 
330 
331 
332     /**
333     ** @dev this method is used to BUY CrySol Objects in the game, defining what will happen with the next price
334     **/
335     function buyCrySolObject(uint _id) external payable {
336 
337             CrySolObject storage _obj = crySolObjects[_id];
338             uint256 price = _obj.price;
339             address oldOwner = _obj.owner; // seller
340             address newOwner = msg.sender; // buyer
341 
342             require(msg.value >= price);
343             require(msg.sender != _obj.owner); // can't buy again the same thing!
344 
345             uint256 excess = msg.value.sub(price);
346             
347             // calculate if percentage will go to parent Object owner 
348             crySolObjects[_obj.parentID].owner.transfer(returnParentObjectCut(_obj, price));
349 
350             // Transfer payment to old owner minus the developer's cut, parent owner's cut and any special Object's cut.
351              uint256 _oldOwnerCut = 0;
352             _oldOwnerCut = price.sub(returnDevelopersCut(price));
353             _oldOwnerCut = _oldOwnerCut.sub(returnParentObjectCut(_obj, price));
354             oldOwner.transfer(_oldOwnerCut);
355 
356             // if there was excess in payment, return that to newOwner buying Object!
357             if (excess > 0) {
358                 newOwner.transfer(excess);
359             }
360 
361             //if the sell object has special property, we have to update ownerAddPercentToParent for owners addresses
362             // 0=NONE, 1=PARENT_UP
363             if (_obj.specialPropertyType == 1) {
364                 if (oldOwner != ownerAddress) {
365                     ownerAddPercentToParent[oldOwner] = ownerAddPercentToParent[oldOwner].sub(_obj.specialPropertyValue);
366                 }
367                 ownerAddPercentToParent[newOwner] = ownerAddPercentToParent[newOwner].add(_obj.specialPropertyValue);
368             } 
369 
370             _transferOwnershipOnBuy(oldOwner, _id, newOwner);
371             
372             // fire event
373             EventSolethiumObjectBought(oldOwner, newOwner, price);
374 
375     }
376 
377 
378     /**
379     ** @dev this method is used to SET user's nickname
380     **/
381     function setOwnerNickName(address _owner, string _nickName) external {
382         require(msg.sender == _owner);
383         ownerToNickname[_owner] = _nickName; // set nickname
384     }
385 
386     /**
387     ** @dev this method is used to GET user's nickname
388     **/
389     function getOwnerNickName(address _owner) external view returns(string) {
390         return ownerToNickname[_owner];
391     }
392 
393     /**
394     ** @dev some helper / info getter functions
395     **/
396     function getContractOwner() external view returns(address) {
397         return ownerAddress; 
398     }
399     function getBalance() external view returns(uint) {
400         return this.balance;
401     }
402     function getNumberOfCrySolObjects() external view returns(uint16) {
403         return numberOfCrySolObjects;
404     }
405 
406 
407     /*
408         @dev Withdraw All or part of contract balance to Contract Owner address
409     */
410     function withdrawAll() onlyOwner() public {
411         ownerAddress.transfer(this.balance);
412     }
413     function withdrawAmount(uint256 _amount) onlyOwner() public {
414         ownerAddress.transfer(_amount);
415     }
416 
417 
418     /**
419     ** @dev this method is used to modify parentID if needed later;
420     **      For this game it is very important to keep intended hierarchy; you never know WHEN exactly transaction will be confirmed in the blockchain
421     **      Every Object creation is transaction; if by some accident Objects get "wrong" ID in the crySolObjects array, this is the method where we can adjust parentId
422     **      for objects orbiting it (we don't want for Moon to end up orbiting Mars :) )
423     **/
424     function setParentID (uint _crySolObjectID, uint16 _parentID) external onlyOwner() {
425         crySolObjects[_crySolObjectID].parentID = _parentID;
426     }
427 
428 
429    /**
430    **  @dev ERC-721 compliant methods;
431    ** Another contracts can simply talk to us without needing to know anything about our internal contract implementation 
432    **/
433 
434      mapping (uint => address) crySolObjectsApprovals;
435 
436     event Transfer(address indexed _from, address indexed _to, uint256 _id);
437     event Approval(address indexed _owner, address indexed _approved, uint256 _id);
438 
439     function name() public pure returns (string _name) {
440         return "Solethium";
441     }
442 
443     function symbol() public pure returns (string _symbol) {
444         return "SOL";
445     }
446 
447     function totalSupply() public view returns (uint256 _totalSupply) {
448         return crySolObjects.length;
449     } 
450 
451     function balanceOf(address _owner) public view returns (uint256 _balance) {
452         return ownerCrySolObjectsCount[_owner];
453     }
454 
455     function ownerOf(uint256 _id) public view returns (address _owner) {
456         return crySolObjects[_id].owner;
457     }
458 
459     function _transferHelper(address _from, address _to, uint256 _id) private {
460         ownerCrySolObjectsCount[_to] = ownerCrySolObjectsCount[_to].add(1);
461         ownerCrySolObjectsCount[_from] = ownerCrySolObjectsCount[_from].sub(1);
462         crySolObjects[_id].owner = _to;
463         Transfer(_from, _to, _id); // fire event
464     }
465 
466       function transfer(address _to, uint256 _id) public onlyOwnerOf(_id) {
467         _transferHelper(msg.sender, _to, _id);
468     }
469 
470     function approve(address _to, uint256 _id) public onlyOwnerOf(_id) {
471         require(msg.sender != _to);
472         crySolObjectsApprovals[_id] = _to;
473         Approval(msg.sender, _to, _id); // fire event
474     }
475 
476     function takeOwnership(uint256 _id) public {
477         require(crySolObjectsApprovals[_id] == msg.sender);
478         _transferHelper(ownerOf(_id), msg.sender, _id);
479     }
480 
481    
482 
483 
484 }