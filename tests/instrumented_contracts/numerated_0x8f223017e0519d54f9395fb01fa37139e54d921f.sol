1 pragma solidity ^0.4.18;
2 
3 contract ERC721 {
4   // Required methods
5   function approve(address _to, uint256 _tokenId) public;
6   function balanceOf(address _owner) public view returns (uint256 balance);
7   function implementsERC721() public pure returns (bool);
8   function ownerOf(uint256 _tokenId) public view returns (address addr);
9   function takeOwnership(uint256 _tokenId) public;
10   function totalSupply() public view returns (uint256 total);
11   function transferFrom(address _from, address _to, uint256 _tokenId) public;
12   function transfer(address _to, uint256 _tokenId) public;
13 
14   event Transfer(address indexed from, address indexed to, uint256 tokenId);
15   event Approval(address indexed owner, address indexed approved, uint256 tokenId);
16 
17 }
18 
19 
20 contract CodeToken is ERC721 {
21 
22   /*** EVENTS ***/
23 
24   /// @dev The Birth event is fired whenever a new codetoken comes into existence.
25   event Birth(uint256 tokenId, string name, address owner);
26 
27   /// @dev The TokenSold event is fired whenever a token is sold.
28   event TokenSold(uint256 tokenId, uint256 oldPrice, uint256 newPrice, address prevOwner, address winner, string name);
29 
30   /// @dev Transfer event as defined in current draft of ERC721.
31   ///  ownership is assigned, including births.
32   event Transfer(address from, address to, uint256 tokenId);
33 
34   /*** CONSTANTS ***/
35 
36   /// @notice Name and symbol of the non fungible token, as defined in ERC721.
37   string public constant NAME = "CodeToken";
38   string public constant SYMBOL = "CT";
39 
40   uint256 private startingPrice = 0.05 ether;
41 
42   /*** STORAGE ***/
43 
44   /// @dev A mapping from codetoken IDs to the address that owns them. All codetokens have
45   ///  some valid owner address.
46   mapping (uint256 => address) public codetokenIndexToOwner;
47 
48   // @dev A mapping from owner address to count of tokens that address owns.
49   //  Used internally inside balanceOf() to resolve ownership count.
50   mapping (address => uint256) private ownershipTokenCount;
51 
52   /// @dev A mapping from CodeIDs to an address that has been approved to call
53   ///  transferFrom(). Each Code can only have one approved address for transfer
54   ///  at any time. A zero value means no approval is outstanding.
55   mapping (uint256 => address) public codetokenIndexToApproved;
56 
57   // @dev A mapping from CodeIDs to the price of the token.
58   mapping (uint256 => uint256) private codetokenIndexToPrice;
59 
60   address public creator;
61 
62   /*** DATATYPES ***/
63   struct Code {
64     string name;
65   }
66 
67   Code[] private codetokens;
68 
69   modifier onlyCreator() {
70     require(msg.sender == creator);
71     _;
72   }
73 
74   function CodeToken() public {
75     creator = msg.sender;
76   }
77 
78   /*** PUBLIC FUNCTIONS ***/
79   /// @notice Grant another address the right to transfer token via takeOwnership() and transferFrom().
80   /// @param _to The address to be granted transfer approval. Pass address(0) to
81   ///  clear all approvals.
82   /// @param _tokenId The ID of the Token that can be transferred if this call succeeds.
83   /// @dev Required for ERC-721 compliance.
84   function approve(
85     address _to,
86     uint256 _tokenId
87   ) public {
88     // Caller must own token.
89     require(_owns(msg.sender, _tokenId));
90 
91     codetokenIndexToApproved[_tokenId] = _to;
92 
93     Approval(msg.sender, _to, _tokenId);
94   }
95 
96   /// For querying balance of a particular account
97   /// @param _owner The address for balance query
98   /// @dev Required for ERC-721 compliance.
99   function balanceOf(address _owner) public view returns (uint256 balance) {
100     return ownershipTokenCount[_owner];
101   }
102 
103   function createCodeContract(string _name) public onlyCreator {
104     _createCode(_name, address(this), startingPrice);
105   }
106 
107   /// @notice Returns all the relevant information about a specific codetoken.
108   /// @param _tokenId The tokenId of the codetoken of interest.
109   function getCodeToken(uint256 _tokenId) public view returns (
110     string codetokenName,
111     uint256 sellingPrice,
112     address owner
113   ) {
114     Code storage codetoken = codetokens[_tokenId];
115     codetokenName = codetoken.name;
116     sellingPrice = codetokenIndexToPrice[_tokenId];
117     owner = codetokenIndexToOwner[_tokenId];
118   }
119 
120   function implementsERC721() public pure returns (bool) {
121     return true;
122   }
123 
124   /// @dev Required for ERC-721 compliance.
125   function name() public pure returns (string) {
126     return NAME;
127   }
128 
129   /// For querying owner of token
130   /// @param _tokenId The tokenID for owner inquiry
131   /// @dev Required for ERC-721 compliance.
132   function ownerOf(uint256 _tokenId)
133     public
134     view
135     returns (address owner)
136   {
137     owner = codetokenIndexToOwner[_tokenId];
138     require(owner != address(0));
139   }
140 
141   function payout(address _to) public onlyCreator {
142     _payout(_to);
143   }
144 
145   // Allows someone to send ether and obtain the token
146   function purchase(uint256 _tokenId) public payable {
147     address oldOwner = codetokenIndexToOwner[_tokenId];
148     address newOwner = msg.sender;
149 
150     uint256 sellingPrice = codetokenIndexToPrice[_tokenId];
151 
152     // Making sure token owner is not sending to self
153     require(oldOwner != newOwner);
154 
155     // Safety check to prevent against an unexpected 0x0 default.
156     require(_addressNotNull(newOwner));
157 
158     // Making sure sent amount is greater than or equal to the sellingPrice
159     require(msg.value >= sellingPrice);
160 
161     uint256 payment = uint256(SafeMath.div(SafeMath.mul(sellingPrice, 92), 100));
162     uint256 purchaseExcess = SafeMath.sub(msg.value, sellingPrice);
163 
164     codetokenIndexToPrice[_tokenId] = SafeMath.div(SafeMath.mul(sellingPrice, 120), 92);
165 
166     _transfer(oldOwner, newOwner, _tokenId);
167 
168     // Pay previous tokenOwner if owner is not contract
169     if (oldOwner != address(this)) {
170       oldOwner.transfer(payment);
171     }
172 
173     TokenSold(_tokenId, sellingPrice, codetokenIndexToPrice[_tokenId], oldOwner, newOwner, codetokens[_tokenId].name);
174 
175     msg.sender.transfer(purchaseExcess);
176   }
177 
178   function priceOf(uint256 _tokenId) public view returns (uint256 price) {
179     return codetokenIndexToPrice[_tokenId];
180   }
181 
182   function setCreator(address _creator) public onlyCreator {
183     require(_creator != address(0));
184 
185     creator = _creator;
186   }
187 
188   /// @dev Required for ERC-721 compliance.
189   function symbol() public pure returns (string) {
190     return SYMBOL;
191   }
192 
193   /// @notice Allow pre-approved user to take ownership of a token
194   /// @param _tokenId The ID of the Token that can be transferred if this call succeeds.
195   /// @dev Required for ERC-721 compliance.
196   function takeOwnership(uint256 _tokenId) public {
197     address newOwner = msg.sender;
198     address oldOwner = codetokenIndexToOwner[_tokenId];
199 
200     // Safety check to prevent against an unexpected 0x0 default.
201     require(_addressNotNull(newOwner));
202 
203     // Making sure transfer is approved
204     require(_approved(newOwner, _tokenId));
205 
206     _transfer(oldOwner, newOwner, _tokenId);
207   }
208 
209   /// For querying totalSupply of token
210   /// @dev Required for ERC-721 compliance.
211   function totalSupply() public view returns (uint256 total) {
212     return codetokens.length;
213   }
214 
215   /// Owner initates the transfer of the token to another account
216   /// @param _to The address for the token to be transferred to.
217   /// @param _tokenId The ID of the Token that can be transferred if this call succeeds.
218   /// @dev Required for ERC-721 compliance.
219   function transfer(
220     address _to,
221     uint256 _tokenId
222   ) public {
223     require(_owns(msg.sender, _tokenId));
224     require(_addressNotNull(_to));
225 
226     _transfer(msg.sender, _to, _tokenId);
227   }
228 
229   /// Third-party initiates transfer of token from address _from to address _to
230   /// @param _from The address for the token to be transferred from.
231   /// @param _to The address for the token to be transferred to.
232   /// @param _tokenId The ID of the Token that can be transferred if this call succeeds.
233   /// @dev Required for ERC-721 compliance.
234   function transferFrom(
235     address _from,
236     address _to,
237     uint256 _tokenId
238   ) public {
239     require(_owns(_from, _tokenId));
240     require(_approved(_to, _tokenId));
241     require(_addressNotNull(_to));
242 
243     _transfer(_from, _to, _tokenId);
244   }
245 
246   /*** PRIVATE FUNCTIONS ***/
247   /// Safety check on _to address to prevent against an unexpected 0x0 default.
248   function _addressNotNull(address _to) private pure returns (bool) {
249     return _to != address(0);
250   }
251 
252   /// For checking approval of transfer for address _to
253   function _approved(address _to, uint256 _tokenId) private view returns (bool) {
254     return codetokenIndexToApproved[_tokenId] == _to;
255   }
256 
257   /// For creating Code Token
258   function _createCode(string _name, address _owner, uint256 _price) private {
259     Code memory _codetoken = Code({
260       name: _name
261     });
262     uint256 newCodeId = codetokens.push(_codetoken) - 1;
263 
264     // It's probably never going to happen, 4 billion tokens are A LOT, but
265     // let's just be 100% sure we never let this happen.
266     require(newCodeId == uint256(uint32(newCodeId)));
267 
268     Birth(newCodeId, _name, _owner);
269 
270     codetokenIndexToPrice[newCodeId] = _price;
271 
272     // This will assign ownership, and also emit the Transfer event as
273     // per ERC721 draft
274     _transfer(address(0), _owner, newCodeId);
275   }
276 
277   /// Check for token ownership
278   function _owns(address claimant, uint256 _tokenId) private view returns (bool) {
279     return claimant == codetokenIndexToOwner[_tokenId];
280   }
281 
282   /// For paying out balance on contract
283   function _payout(address _to) private {
284     if (_to == address(0)) {
285       creator.transfer(this.balance);
286     } else {
287       _to.transfer(this.balance);
288     }
289   }
290 
291   /// @dev Assigns ownership of a specific Code to an address.
292   function _transfer(address _from, address _to, uint256 _tokenId) private {
293     // Since the number of codetokens is capped to 2^32 we can't overflow this
294     ownershipTokenCount[_to]++;
295     //transfer ownership
296     codetokenIndexToOwner[_tokenId] = _to;
297 
298     // When creating new codetokens _from is 0x0, but we can't account that address.
299     if (_from != address(0)) {
300       ownershipTokenCount[_from]--;
301       // clear any previously approved ownership exchange
302       delete codetokenIndexToApproved[_tokenId];
303     }
304 
305     // Emit the transfer event.
306     Transfer(_from, _to, _tokenId);
307   }
308 }
309 library SafeMath {
310 
311   /**
312   * @dev Multiplies two numbers, throws on overflow.
313   */
314   function mul(uint256 a, uint256 b) internal pure returns (uint256) {
315     if (a == 0) {
316       return 0;
317     }
318     uint256 c = a * b;
319     assert(c / a == b);
320     return c;
321   }
322 
323   /**
324   * @dev Integer division of two numbers, truncating the quotient.
325   */
326   function div(uint256 a, uint256 b) internal pure returns (uint256) {
327     // assert(b > 0); // Solidity automatically throws when dividing by 0
328     uint256 c = a / b;
329     // assert(a == b * c + a % b); // There is no case in which this doesn't hold
330     return c;
331   }
332 
333   /**
334   * @dev Substracts two numbers, throws on overflow (i.e. if subtrahend is greater than minuend).
335   */
336   function sub(uint256 a, uint256 b) internal pure returns (uint256) {
337     assert(b <= a);
338     return a - b;
339   }
340 
341   /**
342   * @dev Adds two numbers, throws on overflow.
343   */
344   function add(uint256 a, uint256 b) internal pure returns (uint256) {
345     uint256 c = a + b;
346     assert(c >= a);
347     return c;
348   }
349 }