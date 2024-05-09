1 pragma solidity ^0.4.18; // solhint-disable-line
2 
3 /// @title Interface for contracts conforming to ERC-721: Non-Fungible Tokens
4 /// @author Dieter Shirley <dete@axiomzen.co> (https://github.com/dete)
5 contract ERC721 {
6   // Required methods
7   function approve(address _to, uint256 _tokenId) public;
8   function balanceOf(address _owner) public view returns (uint256 balance);
9   function implementsERC721() public pure returns (bool);
10   function ownerOf(uint256 _tokenId) public view returns (address addr);
11   function takeOwnership(uint256 _tokenId) public;
12   function totalSupply() public view returns (uint256 total);
13   function transferFrom(address _from, address _to, uint256 _tokenId) public;
14   function transfer(address _to, uint256 _tokenId) public;
15 
16   event Transfer(address indexed from, address indexed to, uint256 tokenId);
17   event Approval(address indexed owner, address indexed approved, uint256 tokenId);
18 
19   // Optional
20   // function name() public view returns (string name);
21   // function symbol() public view returns (string symbol);
22   // function tokenOfOwnerByIndex(address _owner, uint256 _index) external view returns (uint256 tokenId);
23   // function tokenMetadata(uint256 _tokenId) public view returns (string infoUrl);
24 }
25 
26 contract EtherMeals is ERC721 {
27 
28   /*** EVENTS ***/
29 
30   /// @dev The Birth event is fired whenever a new Meal comes into existence.
31   event Birth(uint256 tokenId, string name, address owner);
32 
33   /// @dev The TokenSold event is fired whenever a token is sold.
34   event TokenSold(uint256 tokenId, uint256 oldPrice, uint256 newPrice, address prevOwner, address winner, string name);
35 
36   /// @dev Transfer event as defined in current draft of ERC721.
37   ///  ownership is assigned, including births.
38   event Transfer(address from, address to, uint256 tokenId);
39 
40   /*** CONSTANTS ***/
41 
42   /// @notice Name and symbol of the non fungible token, as defined in ERC721.
43   string public constant NAME = "EtherMeals"; // solhint-disable-line
44   string public constant SYMBOL = "MealToken"; // solhint-disable-line
45 
46   uint256 private startingPrice = 0.001 ether;
47   uint256 private firstStepLimit =  0.053613 ether;
48   uint256 private secondStepLimit = 0.564957 ether;
49 
50   /*** STORAGE ***/
51 
52   /// @dev A mapping from meal IDs to the address that owns them. All meals have
53   ///  some valid owner address.
54   mapping (uint256 => address) public mealIndexToOwner;
55 
56   // @dev A mapping from owner address to count of tokens that address owns.
57   //  Used internally inside balanceOf() to resolve ownership count.
58   mapping (address => uint256) private ownershipTokenCount;
59 
60   /// @dev A mapping from MealIDs to an address that has been approved to call
61   ///  transferFrom(). Each Meal can only have one approved address for transfer
62   ///  at any time. A zero value means no approval is outstanding.
63   mapping (uint256 => address) public mealIndexToApproved;
64 
65   // @dev A mapping from MealIDs to the price of the token.
66   mapping (uint256 => uint256) private mealIndexToPrice;
67 
68   // The addresses of the accounts (or contracts) that can execute actions within each roles.
69   address public ceoAddress;
70   address public cooAddress;
71 
72   /*** DATATYPES ***/
73   struct Meal {
74     string name;
75   }
76 
77   Meal[] private meals;
78 
79   /*** ACCESS MODIFIERS ***/
80   /// @dev Access modifier for CEO-only functionality
81   modifier onlyCEO() {
82     require(msg.sender == ceoAddress);
83     _;
84   }
85 
86   /// @dev Access modifier for COO-only functionality
87   modifier onlyCOO() {
88     require(msg.sender == cooAddress);
89     _;
90   }
91 
92   /// Access modifier for contract owner only functionality
93   modifier onlyCLevel() {
94     require(
95       msg.sender == ceoAddress ||
96       msg.sender == cooAddress
97     );
98     _;
99   }
100 
101   /*** CONSTRUCTOR ***/
102   function EtherMeals() public {
103     ceoAddress = msg.sender;
104     cooAddress = msg.sender;
105   }
106 
107   /*** PUBLIC FUNCTIONS ***/
108   /// @notice Grant another address the right to transfer token via takeOwnership() and transferFrom().
109   /// @param _to The address to be granted transfer approval. Pass address(0) to
110   ///  clear all approvals.
111   /// @param _tokenId The ID of the Token that can be transferred if this call succeeds.
112   /// @dev Required for ERC-721 compliance.
113   function approve(
114     address _to,
115     uint256 _tokenId
116   ) public {
117     // Caller must own token.
118     require(_owns(msg.sender, _tokenId));
119 
120     mealIndexToApproved[_tokenId] = _to;
121 
122     Approval(msg.sender, _to, _tokenId);
123   }
124 
125   /// For querying balance of a particular account
126   /// @param _owner The address for balance query
127   /// @dev Required for ERC-721 compliance.
128   function balanceOf(address _owner) public view returns (uint256 balance) {
129     return ownershipTokenCount[_owner];
130   }
131 
132   /// @dev Creates a new Meal with the given name.
133   function createContractMeal(string _name) public onlyCLevel {
134     _createMeal(_name, address(this), startingPrice);
135   }
136 
137   /// @notice Returns all the relevant information about a specific meal.
138   /// @param _tokenId The tokenId of the meal of interest.
139   function getMeal(uint256 _tokenId) public view returns (
140     string mealName,
141     uint256 sellingPrice,
142     address owner
143   ) {
144     Meal storage meal = meals[_tokenId];
145     mealName = meal.name;
146     sellingPrice = mealIndexToPrice[_tokenId];
147     owner = mealIndexToOwner[_tokenId];
148   }
149 
150   function implementsERC721() public pure returns (bool) {
151     return true;
152   }
153 
154   /// @dev Required for ERC-721 compliance.
155   function name() public pure returns (string) {
156     return NAME;
157   }
158 
159   /// For querying owner of token
160   /// @param _tokenId The tokenID for owner inquiry
161   /// @dev Required for ERC-721 compliance.
162   function ownerOf(uint256 _tokenId)
163     public
164     view
165     returns (address owner)
166   {
167     owner = mealIndexToOwner[_tokenId];
168     require(owner != address(0));
169   }
170 
171   function payout(address _to) public onlyCLevel {
172     _payout(_to);
173   }
174 
175   // Allows someone to send ether and obtain the token
176   function purchase(uint256 _tokenId) public payable {
177     address oldOwner = mealIndexToOwner[_tokenId];
178     address newOwner = msg.sender;
179 
180     uint256 sellingPrice = mealIndexToPrice[_tokenId];
181 
182     // Making sure token owner is not sending to self
183     require(oldOwner != newOwner);
184 
185     // Safety check to prevent against an unexpected 0x0 default.
186     require(_addressNotNull(newOwner));
187 
188     // Making sure sent amount is greater than or equal to the sellingPrice
189     require(msg.value >= sellingPrice);
190 
191     uint256 payment = uint256(SafeMath.div(SafeMath.mul(sellingPrice, 92), 100));
192     uint256 purchaseExcess = SafeMath.sub(msg.value, sellingPrice);
193 
194     // Update prices
195     if (sellingPrice < firstStepLimit) {
196       // first stage
197       mealIndexToPrice[_tokenId] = SafeMath.div(SafeMath.mul(sellingPrice, 200), 90);
198     } else if (sellingPrice < secondStepLimit) {
199       // second stage
200       mealIndexToPrice[_tokenId] = SafeMath.div(SafeMath.mul(sellingPrice, 120), 90);
201     } else {
202       // third stage
203       mealIndexToPrice[_tokenId] = SafeMath.div(SafeMath.mul(sellingPrice, 115), 90);
204     }
205 
206     _transfer(oldOwner, newOwner, _tokenId);
207 
208     // Pay previous tokenOwner if owner is not contract
209     if (oldOwner != address(this)) {
210       oldOwner.transfer(payment); //(1-0.08)
211     }
212 
213     TokenSold(_tokenId, sellingPrice, mealIndexToPrice[_tokenId], oldOwner, newOwner, meals[_tokenId].name);
214 
215     msg.sender.transfer(purchaseExcess);
216   }
217 
218   function priceOf(uint256 _tokenId) public view returns (uint256 price) {
219     return mealIndexToPrice[_tokenId];
220   }
221 
222   /// @dev Assigns a new address to act as the CEO. Only available to the current CEO.
223   /// @param _newCEO The address of the new CEO
224   function setCEO(address _newCEO) public onlyCEO {
225     require(_newCEO != address(0));
226 
227     ceoAddress = _newCEO;
228   }
229 
230   /// @dev Assigns a new address to act as the COO. Only available to the current COO.
231   /// @param _newCOO The address of the new COO
232   function setCOO(address _newCOO) public onlyCEO {
233     require(_newCOO != address(0));
234 
235     cooAddress = _newCOO;
236   }
237 
238   /// @dev Required for ERC-721 compliance.
239   function symbol() public pure returns (string) {
240     return SYMBOL;
241   }
242 
243   /// @notice Allow pre-approved user to take ownership of a token
244   /// @param _tokenId The ID of the Token that can be transferred if this call succeeds.
245   /// @dev Required for ERC-721 compliance.
246   function takeOwnership(uint256 _tokenId) public {
247     address newOwner = msg.sender;
248     address oldOwner = mealIndexToOwner[_tokenId];
249 
250     // Safety check to prevent against an unexpected 0x0 default.
251     require(_addressNotNull(newOwner));
252 
253     // Making sure transfer is approved
254     require(_approved(newOwner, _tokenId));
255 
256     _transfer(oldOwner, newOwner, _tokenId);
257   }
258 
259   /// @param _owner The owner whose celebrity tokens we are interested in.
260   /// @dev This method MUST NEVER be called by smart contract code. First, it's fairly
261   ///  expensive (it walks the entire Meals array looking for meals belonging to owner),
262   ///  but it also returns a dynamic array, which is only supported for web3 calls, and
263   ///  not contract-to-contract calls.
264   function tokensOfOwner(address _owner) public view returns(uint256[] ownerTokens) {
265     uint256 tokenCount = balanceOf(_owner);
266     if (tokenCount == 0) {
267         // Return an empty array
268       return new uint256[](0);
269     } else {
270       uint256[] memory result = new uint256[](tokenCount);
271       uint256 totalMeals = totalSupply();
272       uint256 resultIndex = 0;
273 
274       uint256 mealId;
275       for (mealId = 0; mealId <= totalMeals; mealId++) {
276         if (mealIndexToOwner[mealId] == _owner) {
277           result[resultIndex] = mealId;
278           resultIndex++;
279         }
280       }
281       return result;
282     }
283   }
284 
285   /// For querying totalSupply of token
286   /// @dev Required for ERC-721 compliance.
287   function totalSupply() public view returns (uint256 total) {
288     return meals.length;
289   }
290 
291   /// Owner initates the transfer of the token to another account
292   /// @param _to The address for the token to be transferred to.
293   /// @param _tokenId The ID of the Token that can be transferred if this call succeeds.
294   /// @dev Required for ERC-721 compliance.
295   function transfer(
296     address _to,
297     uint256 _tokenId
298   ) public {
299     require(_owns(msg.sender, _tokenId));
300     require(_addressNotNull(_to));
301 
302     _transfer(msg.sender, _to, _tokenId);
303   }
304 
305   /// Third-party initiates transfer of token from address _from to address _to
306   /// @param _from The address for the token to be transferred from.
307   /// @param _to The address for the token to be transferred to.
308   /// @param _tokenId The ID of the Token that can be transferred if this call succeeds.
309   /// @dev Required for ERC-721 compliance.
310   function transferFrom(
311     address _from,
312     address _to,
313     uint256 _tokenId
314   ) public {
315     require(_owns(_from, _tokenId));
316     require(_approved(_to, _tokenId));
317     require(_addressNotNull(_to));
318 
319     _transfer(_from, _to, _tokenId);
320   }
321 
322   /*** PRIVATE FUNCTIONS ***/
323   /// Safety check on _to address to prevent against an unexpected 0x0 default.
324   function _addressNotNull(address _to) private pure returns (bool) {
325     return _to != address(0);
326   }
327 
328   /// For checking approval of transfer for address _to
329   function _approved(address _to, uint256 _tokenId) private view returns (bool) {
330     return mealIndexToApproved[_tokenId] == _to;
331   }
332 
333   /// For creating Meals
334   function _createMeal(string _name, address _owner, uint256 _price) private {
335     Meal memory _meal = Meal({
336       name: _name
337     });
338     uint256 newMealId = meals.push(_meal) - 1;
339 
340     // It's probably never going to happen, 4 billion tokens are A LOT, but
341     // let's just be 100% sure we never let this happen.
342     require(newMealId == uint256(uint32(newMealId)));
343 
344     Birth(newMealId, _name, _owner);
345 
346     mealIndexToPrice[newMealId] = _price;
347 
348     // This will assign ownership, and also emit the Transfer event as
349     // per ERC721 draft
350     _transfer(address(0), _owner, newMealId);
351   }
352 
353   /// Check for token ownership
354   function _owns(address claimant, uint256 _tokenId) private view returns (bool) {
355     return claimant == mealIndexToOwner[_tokenId];
356   }
357 
358   /// For paying out balance on contract
359   function _payout(address _to) private {
360     if (_to == address(0)) {
361       ceoAddress.transfer(this.balance);
362     } else {
363       _to.transfer(this.balance);
364     }
365   }
366 
367   /// @dev Assigns ownership of a specific Meal to an address.
368   function _transfer(address _from, address _to, uint256 _tokenId) private {
369     // Since the number of meals is capped to 2^32 we can't overflow this
370     ownershipTokenCount[_to]++;
371     //transfer ownership
372     mealIndexToOwner[_tokenId] = _to;
373 
374     // When creating new meals _from is 0x0, but we can't account that address.
375     if (_from != address(0)) {
376       ownershipTokenCount[_from]--;
377       // clear any previously approved ownership exchange
378       delete mealIndexToApproved[_tokenId];
379     }
380 
381     // Emit the transfer event.
382     Transfer(_from, _to, _tokenId);
383   }
384 }
385 library SafeMath {
386 
387   /**
388   * @dev Multiplies two numbers, throws on overflow.
389   */
390   function mul(uint256 a, uint256 b) internal pure returns (uint256) {
391     if (a == 0) {
392       return 0;
393     }
394     uint256 c = a * b;
395     assert(c / a == b);
396     return c;
397   }
398 
399   /**
400   * @dev Integer division of two numbers, truncating the quotient.
401   */
402   function div(uint256 a, uint256 b) internal pure returns (uint256) {
403     // assert(b > 0); // Solidity automatically throws when dividing by 0
404     uint256 c = a / b;
405     // assert(a == b * c + a % b); // There is no case in which this doesn't hold
406     return c;
407   }
408 
409   /**
410   * @dev Substracts two numbers, throws on overflow (i.e. if subtrahend is greater than minuend).
411   */
412   function sub(uint256 a, uint256 b) internal pure returns (uint256) {
413     assert(b <= a);
414     return a - b;
415   }
416 
417   /**
418   * @dev Adds two numbers, throws on overflow.
419   */
420   function add(uint256 a, uint256 b) internal pure returns (uint256) {
421     uint256 c = a + b;
422     assert(c >= a);
423     return c;
424   }
425 }