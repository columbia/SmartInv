1 pragma solidity ^0.4.18;
2 
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
33 contract ERC721 {
34   event Transfer(address indexed _from, address indexed _to, uint256 _tokenId);
35   event Approval(address indexed _owner, address indexed _approved, uint256 _tokenId);
36 
37   function balanceOf(address _owner) public view returns (uint256 _balance);
38   function ownerOf(uint256 _tokenId) public view returns (address _owner);
39   function transfer(address _to, uint256 _tokenId) public;
40   function approve(address _to, uint256 _tokenId) public;
41   function takeOwnership(uint256 _tokenId) public;
42 }
43 
44 contract ERC721Token is ERC721 {
45   using SafeMath for uint256;
46 
47   // Total amount of tokens
48   uint256 private totalTokens;
49 
50   // Mapping from token ID to owner
51   mapping (uint256 => address) private tokenOwner;
52 
53   // Mapping from token ID to approved address
54   mapping (uint256 => address) private tokenApprovals;
55 
56   // Mapping from owner to list of owned token IDs
57   mapping (address => uint256[]) private ownedTokens;
58 
59   // Mapping from token ID to index of the owner tokens list
60   mapping(uint256 => uint256) private ownedTokensIndex;
61 
62   /**
63   * @dev Guarantees msg.sender is owner of the given token
64   * @param _tokenId uint256 ID of the token to validate its ownership belongs to msg.sender
65   */
66   modifier onlyOwnerOf(uint256 _tokenId) {
67     require(ownerOf(_tokenId) == msg.sender);
68     _;
69   }
70 
71   /**
72   * @dev Gets the total amount of tokens stored by the contract
73   * @return uint256 representing the total amount of tokens
74   */
75   function totalSupply() public view returns (uint256) {
76     return totalTokens;
77   }
78 
79   /**
80   * @dev Gets the balance of the specified address
81   * @param _owner address to query the balance of
82   * @return uint256 representing the amount owned by the passed address
83   */
84   function balanceOf(address _owner) public view returns (uint256) {
85     return ownedTokens[_owner].length;
86   }
87 
88   /**
89   * @dev Gets the list of tokens owned by a given address
90   * @param _owner address to query the tokens of
91   * @return uint256[] representing the list of tokens owned by the passed address
92   */
93   function tokensOf(address _owner) public view returns (uint256[]) {
94     return ownedTokens[_owner];
95   }
96 
97   /**
98   * @dev Gets the owner of the specified token ID
99   * @param _tokenId uint256 ID of the token to query the owner of
100   * @return owner address currently marked as the owner of the given token ID
101   */
102   function ownerOf(uint256 _tokenId) public view returns (address) {
103     address owner = tokenOwner[_tokenId];
104     require(owner != address(0));
105     return owner;
106   }
107 
108   /**
109    * @dev Gets the approved address to take ownership of a given token ID
110    * @param _tokenId uint256 ID of the token to query the approval of
111    * @return address currently approved to take ownership of the given token ID
112    */
113   function approvedFor(uint256 _tokenId) public view returns (address) {
114     return tokenApprovals[_tokenId];
115   }
116 
117   /**
118   * @dev Transfers the ownership of a given token ID to another address
119   * @param _to address to receive the ownership of the given token ID
120   * @param _tokenId uint256 ID of the token to be transferred
121   */
122   function transfer(address _to, uint256 _tokenId) public onlyOwnerOf(_tokenId) {
123     clearApprovalAndTransfer(msg.sender, _to, _tokenId);
124   }
125 
126   /**
127   * @dev Approves another address to claim for the ownership of the given token ID
128   * @param _to address to be approved for the given token ID
129   * @param _tokenId uint256 ID of the token to be approved
130   */
131   function approve(address _to, uint256 _tokenId) public onlyOwnerOf(_tokenId) {
132     address owner = ownerOf(_tokenId);
133     require(_to != owner);
134     if (approvedFor(_tokenId) != 0 || _to != 0) {
135       tokenApprovals[_tokenId] = _to;
136       Approval(owner, _to, _tokenId);
137     }
138   }
139 
140   /**
141   * @dev Claims the ownership of a given token ID
142   * @param _tokenId uint256 ID of the token being claimed by the msg.sender
143   */
144   function takeOwnership(uint256 _tokenId) public {
145     require(isApprovedFor(msg.sender, _tokenId));
146     clearApprovalAndTransfer(ownerOf(_tokenId), msg.sender, _tokenId);
147   }
148 
149   /**
150   * @dev Mint token function
151   * @param _to The address that will own the minted token
152   * @param _tokenId uint256 ID of the token to be minted by the msg.sender
153   */
154   function _mint(address _to, uint256 _tokenId) internal {
155     require(_to != address(0));
156     addToken(_to, _tokenId);
157     Transfer(0x0, _to, _tokenId);
158   }
159 
160   /**
161   * @dev Burns a specific token
162   * @param _tokenId uint256 ID of the token being burned by the msg.sender
163   */
164   function _burn(uint256 _tokenId) onlyOwnerOf(_tokenId) internal {
165     if (approvedFor(_tokenId) != 0) {
166       clearApproval(msg.sender, _tokenId);
167     }
168     removeToken(msg.sender, _tokenId);
169     Transfer(msg.sender, 0x0, _tokenId);
170   }
171 
172   /**
173    * @dev Tells whether the msg.sender is approved for the given token ID or not
174    * This function is not private so it can be extended in further implementations like the operatable ERC721
175    * @param _owner address of the owner to query the approval of
176    * @param _tokenId uint256 ID of the token to query the approval of
177    * @return bool whether the msg.sender is approved for the given token ID or not
178    */
179   function isApprovedFor(address _owner, uint256 _tokenId) internal view returns (bool) {
180     return approvedFor(_tokenId) == _owner;
181   }
182 
183   /**
184   * @dev Internal function to clear current approval and transfer the ownership of a given token ID
185   * @param _from address which you want to send tokens from
186   * @param _to address which you want to transfer the token to
187   * @param _tokenId uint256 ID of the token to be transferred
188   */
189   function clearApprovalAndTransfer(address _from, address _to, uint256 _tokenId) internal {
190     require(_to != address(0));
191     require(_to != ownerOf(_tokenId));
192     require(ownerOf(_tokenId) == _from);
193 
194     clearApproval(_from, _tokenId);
195     removeToken(_from, _tokenId);
196     addToken(_to, _tokenId);
197     Transfer(_from, _to, _tokenId);
198   }
199 
200   /**
201   * @dev Internal function to clear current approval of a given token ID
202   * @param _tokenId uint256 ID of the token to be transferred
203   */
204   function clearApproval(address _owner, uint256 _tokenId) private {
205     require(ownerOf(_tokenId) == _owner);
206     tokenApprovals[_tokenId] = 0;
207     Approval(_owner, 0, _tokenId);
208   }
209 
210   /**
211   * @dev Internal function to add a token ID to the list of a given address
212   * @param _to address representing the new owner of the given token ID
213   * @param _tokenId uint256 ID of the token to be added to the tokens list of the given address
214   */
215   function addToken(address _to, uint256 _tokenId) private {
216     require(tokenOwner[_tokenId] == address(0));
217     tokenOwner[_tokenId] = _to;
218     uint256 length = balanceOf(_to);
219     ownedTokens[_to].push(_tokenId);
220     ownedTokensIndex[_tokenId] = length;
221     totalTokens = totalTokens.add(1);
222   }
223 
224   /**
225   * @dev Internal function to remove a token ID from the list of a given address
226   * @param _from address representing the previous owner of the given token ID
227   * @param _tokenId uint256 ID of the token to be removed from the tokens list of the given address
228   */
229   function removeToken(address _from, uint256 _tokenId) private {
230     require(ownerOf(_tokenId) == _from);
231 
232     uint256 tokenIndex = ownedTokensIndex[_tokenId];
233     uint256 lastTokenIndex = balanceOf(_from).sub(1);
234     uint256 lastToken = ownedTokens[_from][lastTokenIndex];
235 
236     tokenOwner[_tokenId] = 0;
237     ownedTokens[_from][tokenIndex] = lastToken;
238     ownedTokens[_from][lastTokenIndex] = 0;
239     // Note that this will handle single-element arrays. In that case, both tokenIndex and lastTokenIndex are going to
240     // be zero. Then we can make sure that we will remove _tokenId from the ownedTokens list since we are first swapping
241     // the lastToken to the first position, and then dropping the element placed in the last position of the list
242 
243     ownedTokens[_from].length--;
244     ownedTokensIndex[_tokenId] = 0;
245     ownedTokensIndex[lastToken] = tokenIndex;
246     totalTokens = totalTokens.sub(1);
247   }
248 }
249 
250 contract Ownable {
251   address public owner;
252 
253   function Ownable() public {
254     owner = msg.sender;
255   }
256 
257   modifier onlyOwner() {
258     require(msg.sender == owner);
259     _;
260   }
261 
262   function transferOwnership(address newOwner) public onlyOwner {
263     if (newOwner != address(0)) {
264       owner = newOwner;
265     }
266   }
267 }
268 
269 contract HarmToken is ERC721Token, Ownable {
270   mapping(uint256 => string) metadataUri;
271   mapping(string => uint256) tokenByMetadataUri;
272   mapping(string => uint256) prices;
273 
274   string public name = "HARM COIN";
275   string public symbol = "QQQ";
276   uint256 public newTokenPrice = 8500;
277   uint256 public priceMultiplier = 1000;
278 
279   modifier tokenExists(uint256 _tokenId) {
280     require(_tokenId > 0);
281     require(_tokenId < totalSupply() + 1);
282     _;
283   }
284 
285   function createEmptyToken() private returns (uint256){
286     uint256 tokenId = totalSupply() + 1;
287     require(tokenId <= 64);
288     _mint(owner, tokenId);
289     return tokenId;
290   }
291 
292   function tokenMetadata(uint256 _tokenId) external view tokenExists(_tokenId)
293   returns (string infoUrl) {
294     return metadataUri[_tokenId];
295   }
296 
297   function lookupToken(string _metadataUri) public view returns (uint256) {
298     return tokenByMetadataUri[_metadataUri];
299   }
300 
301   function stringEmpty(string s) pure private returns (bool){
302     bytes memory testEmptyString = bytes(s);
303     return testEmptyString.length == 0;
304   }
305 
306   function setTokenMetadata(uint256 _tokenId, string _metadataUri) private tokenExists(_tokenId) {
307     require(stringEmpty(metadataUri[_tokenId]));
308     metadataUri[_tokenId] = _metadataUri;
309     tokenByMetadataUri[_metadataUri] = _tokenId;
310   }
311 
312   function makeWeiPrice(uint256 _price) public view returns (uint256) {
313     return _price * priceMultiplier * 1000 * 1000 * 1000 * 1000;
314   }
315 
316   function setPriceByMetadataUri(string _metadataUri, uint256 _price) external onlyOwner {
317     prices[_metadataUri] = _price;
318   }
319 
320   function getPriceByMetadataUri(string _metadataUri) view external returns (uint256) {
321     require(prices[_metadataUri] > 0);
322     return prices[_metadataUri];
323   }
324 
325   function getWeiPriceByMetadataUri(string _metadataUri) view external returns (uint256) {
326     require(prices[_metadataUri] > 0);
327     return makeWeiPrice(prices[_metadataUri]);
328   }
329 
330   function newTokenWeiPrice() view public returns (uint256) {
331     return makeWeiPrice(newTokenPrice);
332   }
333 
334   function buyWildcardToken() payable external returns (uint256) {
335     require(msg.value >= newTokenWeiPrice());
336 
337     uint256 tokenId = createEmptyToken();
338     clearApprovalAndTransfer(owner, msg.sender, tokenId);
339     return tokenId;
340   }
341 
342   function tokenizeAndBuyWork(string _metadataUri) payable external returns (uint256) {
343     require(prices[_metadataUri] > 0);
344     require(msg.value >= makeWeiPrice(prices[_metadataUri]));
345     require(workAdopted(_metadataUri) == false);
346 
347     uint256 tokenId = createEmptyToken();
348     setTokenMetadata(tokenId, _metadataUri);
349     clearApprovalAndTransfer(owner, msg.sender, tokenId);
350     return tokenId;
351   }
352 
353   function buyWorkWithToken(string _metadataUri, uint256 _tokenId) external {
354     require(ownerOf(_tokenId) == msg.sender);
355     require(workAdopted(_metadataUri) == false);
356 
357     setTokenMetadata(_tokenId, _metadataUri);
358   }
359 
360   function setNewTokenPrice(uint256 _price) onlyOwner external {
361     newTokenPrice = _price; // in euro
362   }
363 
364   function () payable public { }
365 
366   function payOut(address destination) external onlyOwner {
367     destination.transfer(this.balance);
368   }
369 
370   function workAdopted(string _metadataUri) public view returns (bool) {
371     return lookupToken(_metadataUri) != 0;
372   }
373 
374   function getBalance() external view onlyOwner returns (uint256) {
375     return this.balance;
376   }
377 
378   function setPriceMultiplier(uint256 _priceMultiplier) external onlyOwner {
379     require(_priceMultiplier > 0);
380     priceMultiplier = _priceMultiplier;
381   }
382 }