1 pragma solidity ^0.4.18; // solhint-disable-line
2 
3 /// @title Interface for contracts conforming to ERC-721: Non-Fungible Tokens
4 contract ERC721 {
5   // Required methods
6   function approve(address _to, uint256 _tokenId) public;
7   function balanceOf(address _owner) public view returns (uint256 balance);
8   function implementsERC721() public pure returns (bool);
9   function ownerOf(uint256 _tokenId) public view returns (address addr);
10   function takeOwnership(uint256 _tokenId) public;
11   function totalSupply() public view returns (uint256 total);
12   function transferFrom(address _from, address _to, uint256 _tokenId) public;
13   function transfer(address _to, uint256 _tokenId) public;
14 
15   event Transfer(address indexed from, address indexed to, uint256 tokenId);
16   event Approval(address indexed owner, address indexed approved, uint256 tokenId);
17 
18   // Optional
19   // function name() public view returns (string name);
20   // function symbol() public view returns (string symbol);
21   // function tokenOfOwnerByIndex(address _owner, uint256 _index) external view returns (uint256 tokenId);
22   // function tokenMetadata(uint256 _tokenId) public view returns (string infoUrl);
23 }
24 
25 
26 contract EthstatesToken is ERC721 {
27 
28   /*** EVENTS ***/
29 
30   /// @dev The Birth event is fired whenever a new state comes into existence.
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
43   string public constant NAME = "Ethstates"; // solhint-disable-line
44   string public constant SYMBOL = "EthstatesToken"; // solhint-disable-line
45 
46   uint256 private startingPrice = 0.025 ether;
47 
48   /*** STORAGE ***/
49 
50   /// @dev A mapping from state IDs to the address that owns them. 
51   /// All states have some valid owner address.
52   mapping (uint256 => address) public stateIndexToOwner;
53 
54   // @dev A mapping from owner address to count of tokens that address owns.
55   //  Used internally inside balanceOf() to resolve ownership count.
56   mapping (address => uint256) private ownershipTokenCount;
57 
58   /// @dev A mapping from StateIDs to an address that has been approved to call
59   ///  transferFrom(). Each State can only have one approved address for transfer
60   ///  at any time. A zero value means no approval is outstanding.
61   mapping (uint256 => address) public stateIndexToApproved;
62 
63   // @dev A mapping from StateIDs to the price of the token.
64   mapping (uint256 => uint256) private stateIndexToPrice;
65 
66   // The addresses of the accounts (or contracts) that can execute actions within each roles.
67   address public ceoAddress;
68   address public cooAddress;
69 
70   /*** DATATYPES ***/
71   struct State {
72     string name;
73   }
74 
75   State[] private states;
76 
77   /*** ACCESS MODIFIERS ***/
78   /// @dev Access modifier for CEO-only functionality
79   modifier onlyCEO() {
80     require(msg.sender == ceoAddress);
81     _;
82   }
83 
84   /// @dev Access modifier for COO-only functionality
85   modifier onlyCOO() {
86     require(msg.sender == cooAddress);
87     _;
88   }
89 
90   /// Access modifier for contract owner only functionality
91   modifier onlyCLevel() {
92     require(
93       msg.sender == ceoAddress ||
94       msg.sender == cooAddress
95     );
96     _;
97   }
98 
99   /*** CONSTRUCTOR ***/
100   function EthstatesToken() public {
101     ceoAddress = msg.sender;
102     cooAddress = msg.sender;
103   }
104 
105   /*** PUBLIC FUNCTIONS ***/
106   /// @notice Grant another address the right to transfer token via takeOwnership() and transferFrom().
107   /// @param _to The address to be granted transfer approval. Pass address(0) to
108   ///  clear all approvals.
109   /// @param _tokenId The ID of the Token that can be transferred if this call succeeds.
110   /// @dev Required for ERC-721 compliance.
111   function approve(
112     address _to,
113     uint256 _tokenId
114   ) public {
115     // Caller must own token.
116     require(_owns(msg.sender, _tokenId));
117 
118     stateIndexToApproved[_tokenId] = _to;
119 
120     Approval(msg.sender, _to, _tokenId);
121   }
122 
123   /// For querying balance of a particular account
124   /// @param _owner The address for balance query
125   /// @dev Required for ERC-721 compliance.
126   function balanceOf(address _owner) public view returns (uint256 balance) {
127     return ownershipTokenCount[_owner];
128   }
129 
130   /// @dev Creates a new State with the given name.
131   function createContractState(string _name) public onlyCOO {
132     _createState(_name, address(this), startingPrice);
133   }
134 
135   /// @notice Returns all the relevant information about a specific state.
136   /// @param _tokenId The tokenId of the state of interest.
137   function getState(uint256 _tokenId) public view returns (
138     string stateName,
139     uint256 sellingPrice,
140     address owner
141   ) {
142     State storage state = states[_tokenId];
143     stateName = state.name;
144     sellingPrice = stateIndexToPrice[_tokenId];
145     owner = stateIndexToOwner[_tokenId];
146   }
147 
148   function implementsERC721() public pure returns (bool) {
149     return true;
150   }
151 
152   /// @dev Required for ERC-721 compliance.
153   function name() public pure returns (string) {
154     return NAME;
155   }
156 
157   /// For querying owner of token
158   /// @param _tokenId The tokenID for owner inquiry
159   /// @dev Required for ERC-721 compliance.
160   function ownerOf(uint256 _tokenId)
161     public
162     view
163     returns (address owner)
164   {
165     owner = stateIndexToOwner[_tokenId];
166     require(owner != address(0));
167   }
168 
169   function payout(address _to) public onlyCLevel {
170     _payout(_to);
171   }
172 
173   // Allows someone to send ether and obtain the token
174   function purchase(uint256 _tokenId) public payable {
175     address oldOwner = stateIndexToOwner[_tokenId];
176     address newOwner = msg.sender;
177 
178     uint256 sellingPrice = stateIndexToPrice[_tokenId];
179 
180     // Making sure token owner is not sending to self
181     require(oldOwner != newOwner);
182 
183     // Safety check to prevent against an unexpected 0x0 default.
184     require(_addressNotNull(newOwner));
185 
186     // Making sure sent amount is greater than or equal to the sellingPrice
187     require(msg.value >= sellingPrice);
188 
189     // Payment is the amount going to the previous owner
190     uint256 payment = uint256(SafeMath.div(SafeMath.mul(sellingPrice, 96), 100));
191 
192     uint256 purchaseExcess = SafeMath.sub(msg.value, sellingPrice);
193 
194     stateIndexToPrice[_tokenId] = SafeMath.div(SafeMath.mul(sellingPrice, 120), 100);
195 
196     _transfer(oldOwner, newOwner, _tokenId);
197 
198     // Pay previous tokenOwner if owner is not contract
199     if (oldOwner != address(this)) {
200       oldOwner.transfer(payment); //(1-0.06)
201     }
202 
203     TokenSold(_tokenId, sellingPrice, stateIndexToPrice[_tokenId], oldOwner, newOwner, states[_tokenId].name);
204 
205     msg.sender.transfer(purchaseExcess);
206   }
207 
208   function priceOf(uint256 _tokenId) public view returns (uint256 price) {
209     return stateIndexToPrice[_tokenId];
210   }
211 
212   /// @dev Assigns a new address to act as the CEO. Only available to the current CEO.
213   /// @param _newCEO The address of the new CEO
214   function setCEO(address _newCEO) public onlyCEO {
215     require(_newCEO != address(0));
216 
217     ceoAddress = _newCEO;
218   }
219 
220   /// @dev Assigns a new address to act as the COO. Only available to the current COO.
221   /// @param _newCOO The address of the new COO
222   function setCOO(address _newCOO) public onlyCEO {
223     require(_newCOO != address(0));
224 
225     cooAddress = _newCOO;
226   }
227 
228   /// @dev Required for ERC-721 compliance.
229   function symbol() public pure returns (string) {
230     return SYMBOL;
231   }
232 
233   /// @notice Allow pre-approved user to take ownership of a token
234   /// @param _tokenId The ID of the Token that can be transferred if this call succeeds.
235   /// @dev Required for ERC-721 compliance.
236   function takeOwnership(uint256 _tokenId) public {
237     address newOwner = msg.sender;
238     address oldOwner = stateIndexToOwner[_tokenId];
239 
240     // Safety check to prevent against an unexpected 0x0 default.
241     require(_addressNotNull(newOwner));
242 
243     // Making sure transfer is approved
244     require(_approved(newOwner, _tokenId));
245 
246     _transfer(oldOwner, newOwner, _tokenId);
247   }
248 
249   /// @param _owner The owner whose ethstate tokens we are interested in.
250   /// @dev This method MUST NEVER be called by smart contract code. First, it's fairly
251   ///  expensive (it walks the entire States array looking for states belonging to owner),
252   ///  but it also returns a dynamic array, which is only supported for web3 calls, and
253   ///  not contract-to-contract calls.
254   function tokensOfOwner(address _owner) public view returns(uint256[] ownerTokens) {
255     uint256 tokenCount = balanceOf(_owner);
256     if (tokenCount == 0) {
257         // Return an empty array
258       return new uint256[](0);
259     } else {
260       uint256[] memory result = new uint256[](tokenCount);
261       uint256 totalStates = totalSupply();
262       uint256 resultIndex = 0;
263 
264       uint256 stateId;
265       for (stateId = 0; stateId <= totalStates; stateId++) {
266         if (stateIndexToOwner[stateId] == _owner) {
267           result[resultIndex] = stateId;
268           resultIndex++;
269         }
270       }
271       return result;
272     }
273   }
274 
275   /// For querying totalSupply of token
276   /// @dev Required for ERC-721 compliance.
277   function totalSupply() public view returns (uint256 total) {
278     return states.length;
279   }
280 
281   /// Owner initates the transfer of the token to another account
282   /// @param _to The address for the token to be transferred to.
283   /// @param _tokenId The ID of the Token that can be transferred if this call succeeds.
284   /// @dev Required for ERC-721 compliance.
285   function transfer(
286     address _to,
287     uint256 _tokenId
288   ) public {
289     require(_owns(msg.sender, _tokenId));
290     require(_addressNotNull(_to));
291 
292     _transfer(msg.sender, _to, _tokenId);
293   }
294 
295   /// Third-party initiates transfer of token from address _from to address _to
296   /// @param _from The address for the token to be transferred from.
297   /// @param _to The address for the token to be transferred to.
298   /// @param _tokenId The ID of the Token that can be transferred if this call succeeds.
299   /// @dev Required for ERC-721 compliance.
300   function transferFrom(
301     address _from,
302     address _to,
303     uint256 _tokenId
304   ) public {
305     require(_owns(_from, _tokenId));
306     require(_approved(_to, _tokenId));
307     require(_addressNotNull(_to));
308 
309     _transfer(_from, _to, _tokenId);
310   }
311 
312   /*** PRIVATE FUNCTIONS ***/
313   /// Safety check on _to address to prevent against an unexpected 0x0 default.
314   function _addressNotNull(address _to) private pure returns (bool) {
315     return _to != address(0);
316   }
317 
318   /// For checking approval of transfer for address _to
319   function _approved(address _to, uint256 _tokenId) private view returns (bool) {
320     return stateIndexToApproved[_tokenId] == _to;
321   }
322 
323   /// For creating State
324   function _createState(string _name, address _owner, uint256 _price) private {
325     State memory _state = State({
326       name: _name
327     });
328     uint256 newStateId = states.push(_state) - 1;
329 
330     // It's probably never going to happen, 4 billion tokens are A LOT, but
331     // let's just be 100% sure we never let this happen.
332     require(newStateId == uint256(uint32(newStateId)));
333 
334     Birth(newStateId, _name, _owner);
335 
336     stateIndexToPrice[newStateId] = _price;
337 
338     // This will assign ownership, and also emit the Transfer event as
339     // per ERC721 draft
340     _transfer(address(0), _owner, newStateId);
341   }
342 
343   /// Check for token ownership
344   function _owns(address claimant, uint256 _tokenId) private view returns (bool) {
345     return claimant == stateIndexToOwner[_tokenId];
346   }
347 
348   /// For paying out balance on contract
349   function _payout(address _to) private {
350     if (_to == address(0)) {
351       ceoAddress.transfer(this.balance);
352     } else {
353       _to.transfer(this.balance);
354     }
355   }
356 
357   /// @dev Assigns ownership of a specific State to an address.
358   function _transfer(address _from, address _to, uint256 _tokenId) private {
359     // Since the number of states is capped to 2^32 we can't overflow this
360     ownershipTokenCount[_to]++;
361     //transfer ownership
362     stateIndexToOwner[_tokenId] = _to;
363 
364     // When creating new states _from is 0x0, but we can't account that address.
365     if (_from != address(0)) {
366       ownershipTokenCount[_from]--;
367       // clear any previously approved ownership exchange
368       delete stateIndexToApproved[_tokenId];
369     }
370 
371     // Emit the transfer event.
372     Transfer(_from, _to, _tokenId);
373   }
374 }
375 
376 library SafeMath {
377 
378   /**
379   * @dev Multiplies two numbers, throws on overflow.
380   */
381   function mul(uint256 a, uint256 b) internal pure returns (uint256) {
382     if (a == 0) {
383       return 0;
384     }
385     uint256 c = a * b;
386     assert(c / a == b);
387     return c;
388   }
389 
390   /**
391   * @dev Integer division of two numbers, truncating the quotient.
392   */
393   function div(uint256 a, uint256 b) internal pure returns (uint256) {
394     // assert(b > 0); // Solidity automatically throws when dividing by 0
395     uint256 c = a / b;
396     // assert(a == b * c + a % b); // There is no case in which this doesn't hold
397     return c;
398   }
399 
400   /**
401   * @dev Substracts two numbers, throws on overflow (i.e. if subtrahend is greater than minuend).
402   */
403   function sub(uint256 a, uint256 b) internal pure returns (uint256) {
404     assert(b <= a);
405     return a - b;
406   }
407 
408   /**
409   * @dev Adds two numbers, throws on overflow.
410   */
411   function add(uint256 a, uint256 b) internal pure returns (uint256) {
412     uint256 c = a + b;
413     assert(c >= a);
414     return c;
415   }
416 }