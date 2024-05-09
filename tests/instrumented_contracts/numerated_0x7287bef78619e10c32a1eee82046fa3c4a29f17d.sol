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
26 contract CryptoPornSmartContract is ERC721 {
27 
28   /*** EVENTS ***/
29 
30   /// @dev The Birth event is fired whenever a new person comes into existence.
31   event Birth(uint256 tokenId, string name, address owner);
32 
33   /// @dev The TokenSold event is fired whenever a token is sold.
34   event TokenSold(uint256 tokenId, uint256 oldPrice, uint256 newPrice, address prevOwner, address newOwner, string name);
35 
36   /// @dev Transfer event as defined in current draft of ERC721. 
37   ///  ownership is assigned, including births.
38   event Transfer(address from, address to, uint256 tokenId);
39 
40   /*** CONSTANTS ***/
41 
42   /// @notice Name and symbol of the non fungible token, as defined in ERC721.
43   string public constant NAME = "CryptoPorn"; // solhint-disable-line
44   string public constant SYMBOL = "CryptoPornSmartContract"; // solhint-disable-line
45 
46   uint256 private startingPrice = 0.01 ether;
47   uint256 private firstStepLimit =  0.053613 ether;
48   uint256 private secondStepLimit = 0.564957 ether;
49 
50   /*** STORAGE ***/
51 
52   /// @dev A mapping from person IDs to the address that owns them. All persons have
53   ///  some valid owner address.
54   mapping (uint256 => address) public personIndexToOwner;
55 
56   // @dev A mapping from owner address to count of tokens that address owns.
57   //  Used internally inside balanceOf() to resolve ownership count.
58   mapping (address => uint256) private ownershipTokenCount;
59 
60   /// @dev A mapping from PersonIDs to an address that has been approved to call
61   ///  transferFrom(). Each Person can only have one approved address for transfer
62   ///  at any time. A zero value means no approval is outstanding.
63   mapping (uint256 => address) public personIndexToApproved;
64 
65 // The addresses of the accounts (or contracts) that can execute actions within each roles. 
66   address public ceoAddress;
67   
68   // The addresses of the accounts (or contracts) that can execute actions within each roles. 
69   address[4] public cooAddresses;
70 
71   /*** DATATYPES ***/
72   struct Person {
73     string name;
74     uint256 sellingPrice;
75   }
76 
77   Person[] private persons;
78 
79   /*** ACCESS MODIFIERS ***/
80   /// @dev Access modifier for CEO-only functionality
81   modifier onlyCEO() {
82     require(msg.sender == ceoAddress);
83     _;
84   }
85   
86   /// @dev Access modifier for CLevel-only functionality
87   modifier onlyCLevel() {
88     require(msg.sender == ceoAddress ||
89         msg.sender == cooAddresses[0] ||
90         msg.sender == cooAddresses[1] ||
91         msg.sender == cooAddresses[2] ||
92         msg.sender == cooAddresses[3]);
93     _;
94   }
95   
96   /*** CONSTRUCTOR ***/
97   function CryptoPornSmartContract() public {
98     ceoAddress = msg.sender;
99   }
100 
101   /*** PUBLIC FUNCTIONS ***/
102   /// @notice Grant another address the right to transfer token via takeOwnership() and transferFrom().
103   /// @param _to The address to be granted transfer approval. Pass address(0) to
104   ///  clear all approvals.
105   /// @param _tokenId The ID of the Token that can be transferred if this call succeeds.
106   /// @dev Required for ERC-721 compliance.
107   function approve(
108     address _to,
109     uint256 _tokenId
110   ) public {
111     // Caller must own token.
112     require(_owns(msg.sender, _tokenId));
113 
114     personIndexToApproved[_tokenId] = _to;
115 
116     Approval(msg.sender, _to, _tokenId);
117   }
118 
119   /// For querying balance of a particular account
120   /// @param _owner The address for balance query
121   /// @dev Required for ERC-721 compliance.
122   function balanceOf(address _owner) public view returns (uint256 balance) {
123     return ownershipTokenCount[_owner];
124   }
125 
126   /// @dev Creates a new promo Person with the given name, with given _price and assignes it to an address.
127   function createNewPerson(address _owner, string _name, uint256 _factor) public onlyCLevel {
128     address personOwner = _owner;
129     uint256 price = startingPrice;
130     if (!_addressNotNull(personOwner)) {
131       personOwner = address(this);
132     }
133 
134     if (_factor > 0) {
135       price = price * _factor;
136     }
137 
138     _createPerson(_name, personOwner, price);
139   }
140 
141   /// @notice Returns all the relevant information about a specific person.
142   /// @param _tokenId The tokenId of the person of interest.
143   function getPerson(uint256 _tokenId) public view returns (
144     string personName,
145     uint256 sellingPrice,
146     address owner
147   ) {
148     Person storage person = persons[_tokenId];
149     personName = person.name;
150     sellingPrice = person.sellingPrice;
151     owner = personIndexToOwner[_tokenId];
152   }
153 
154   function implementsERC721() public pure returns (bool) {
155     return true;
156   }
157 
158   /// @dev Required for ERC-721 compliance.
159   function name() public pure returns (string) {
160     return NAME;
161   }
162 
163   /// For querying owner of token
164   /// @param _tokenId The tokenID for owner inquiry
165   /// @dev Required for ERC-721 compliance.
166   function ownerOf(uint256 _tokenId)
167     public
168     view
169     returns (address owner)
170   {
171     owner = personIndexToOwner[_tokenId];
172     require(owner != address(0));
173   }
174 
175   function payout() public onlyCLevel {
176     _payout();
177   }
178 
179   // Allows someone to send ether and obtain the token
180   function purchase(uint256 _tokenId) public payable {
181     Person storage person = persons[_tokenId];
182     uint256 oldSellintPrice = person.sellingPrice;
183     address oldOwner = personIndexToOwner[_tokenId];
184     address newOwner = msg.sender;
185 
186     // Making sure token owner is not sending to self
187     require(oldOwner != newOwner);
188 
189     // Safety check to prevent against an unexpected 0x0 default.
190     require(_addressNotNull(newOwner));
191 
192     // Making sure sent amount is greater than or equal to the sellingPrice
193     require(msg.value >= person.sellingPrice);
194 
195     uint256 payment = uint256(SafeMath.div(SafeMath.mul(person.sellingPrice, 94), 100));
196     uint256 purchaseExcess = SafeMath.sub(msg.value, person.sellingPrice);
197 
198     // Update prices
199     if (person.sellingPrice < firstStepLimit) {
200       // first stage
201       person.sellingPrice = SafeMath.div(SafeMath.mul(person.sellingPrice, 200), 94);
202     } else if (person.sellingPrice < secondStepLimit) {
203       // second stage
204       person.sellingPrice = SafeMath.div(SafeMath.mul(person.sellingPrice, 120), 94);
205     } else {
206       // third stage
207       person.sellingPrice = SafeMath.div(SafeMath.mul(person.sellingPrice, 115), 94);
208     }
209 
210     _transfer(oldOwner, newOwner, _tokenId);
211 
212     // Pay previous tokenOwner if owner is not contract
213     if (oldOwner != address(this)) {
214       oldOwner.transfer(payment); //(1-0.06)
215     }
216 
217     TokenSold(_tokenId, oldSellintPrice, person.sellingPrice, oldOwner, newOwner, persons[_tokenId].name);
218 
219     msg.sender.transfer(purchaseExcess);
220   }
221 
222   function priceOf(uint256 _tokenId) public view returns (uint256 price) {
223     return persons[_tokenId].sellingPrice;
224   }
225 
226   /// @dev Assigns a new address to act as the COO. Only available to the current COO.
227   /// @param _newCOO1 The address of the new COO1
228   /// @param _newCOO2 The address of the new COO2
229   /// @param _newCOO3 The address of the new COO3
230   /// @param _newCOO4 The address of the new COO4
231   function setCOO(address _newCOO1, address _newCOO2, address _newCOO3, address _newCOO4) public onlyCEO {
232     cooAddresses[0] = _newCOO1;
233     cooAddresses[1] = _newCOO2;
234     cooAddresses[2] = _newCOO3;
235     cooAddresses[3] = _newCOO4;
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
248     address oldOwner = personIndexToOwner[_tokenId];
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
261   ///  expensive (it walks the entire Persons array looking for persons belonging to owner),
262   ///  but it also returns a dynamic array, which is only supported for web3 calls, and
263   ///  not contract-to-contract calls.
264   function tokensOfOwner(address _owner) public view returns(uint256[] ownerTokens) {
265     uint256 tokenCount = balanceOf(_owner);
266     if (tokenCount == 0) {
267         // Return an empty array
268       return new uint256[](0);
269     } else {
270       uint256[] memory result = new uint256[](tokenCount);
271       uint256 totalPersons = totalSupply();
272       uint256 resultIndex = 0;
273 
274       uint256 personId;
275       for (personId = 0; personId <= totalPersons; personId++) {
276         if (personIndexToOwner[personId] == _owner) {
277           result[resultIndex] = personId;
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
288     return persons.length;
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
330     return personIndexToApproved[_tokenId] == _to;
331   }
332 
333   /// For creating Person
334   function _createPerson(string _name, address _owner, uint256 _price) private {
335     Person memory _person = Person({
336       name: _name,
337       sellingPrice: _price
338     });
339     uint256 newPersonId = persons.push(_person) - 1;
340 
341     // It's probably never going to happen, 4 billion tokens are A LOT, but
342     // let's just be 100% sure we never let this happen.
343     require(newPersonId == uint256(uint32(newPersonId)));
344 
345     Birth(newPersonId, _name, _owner);
346 
347     // This will assign ownership, and also emit the Transfer event as
348     // per ERC721 draft
349     _transfer(address(0), _owner, newPersonId);
350   }
351 
352   /// Check for token ownership
353   function _owns(address claimant, uint256 _tokenId) private view returns (bool) {
354     return claimant == personIndexToOwner[_tokenId];
355   }
356 
357   /// For paying out balance on contract
358   function _payout() private {
359     uint256 amount = SafeMath.div(this.balance, 4);
360     cooAddresses[0].transfer(amount);
361     cooAddresses[1].transfer(amount);
362     cooAddresses[2].transfer(amount);
363     cooAddresses[3].transfer(amount);
364   }
365 
366   /// @dev Assigns ownership of a specific Person to an address.
367   function _transfer(address _from, address _to, uint256 _tokenId) private {
368     // Since the number of persons is capped to 2^32 we can't overflow this
369     ownershipTokenCount[_to]++;
370     //transfer ownership
371     personIndexToOwner[_tokenId] = _to;
372 
373     // When creating new persons _from is 0x0, but we can't account that address.
374     if (_addressNotNull(_from)) {
375       ownershipTokenCount[_from]--;
376       // clear any previously approved ownership exchange
377       delete personIndexToApproved[_tokenId];
378     }
379 
380     // Emit the transfer event.
381     Transfer(_from, _to, _tokenId);
382   }
383 }
384 library SafeMath {
385 
386   /**
387   * @dev Multiplies two numbers, throws on overflow.
388   */
389   function mul(uint256 a, uint256 b) internal pure returns (uint256) {
390     if (a == 0) {
391       return 0;
392     }
393     uint256 c = a * b;
394     assert(c / a == b);
395     return c;
396   }
397 
398   /**
399   * @dev Integer division of two numbers, truncating the quotient.
400   */
401   function div(uint256 a, uint256 b) internal pure returns (uint256) {
402     // assert(b > 0); // Solidity automatically throws when dividing by 0
403     uint256 c = a / b;
404     // assert(a == b * c + a % b); // There is no case in which this doesn't hold
405     return c;
406   }
407 
408   /**
409   * @dev Substracts two numbers, throws on overflow (i.e. if subtrahend is greater than minuend).
410   */
411   function sub(uint256 a, uint256 b) internal pure returns (uint256) {
412     assert(b <= a);
413     return a - b;
414   }
415 
416   /**
417   * @dev Adds two numbers, throws on overflow.
418   */
419   function add(uint256 a, uint256 b) internal pure returns (uint256) {
420     uint256 c = a + b;
421     assert(c >= a);
422     return c;
423   }
424 }