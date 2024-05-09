1 pragma solidity ^0.4.18;
2 
3 // File: zeppelin-solidity/contracts/math/SafeMath.sol
4 
5 /**
6  * @title SafeMath
7  * @dev Math operations with safety checks that throw on error
8  */
9 library SafeMath {
10 
11   /**
12   * @dev Multiplies two numbers, throws on overflow.
13   */
14   function mul(uint256 a, uint256 b) internal pure returns (uint256) {
15     if (a == 0) {
16       return 0;
17     }
18     uint256 c = a * b;
19     assert(c / a == b);
20     return c;
21   }
22 
23   /**
24   * @dev Integer division of two numbers, truncating the quotient.
25   */
26   function div(uint256 a, uint256 b) internal pure returns (uint256) {
27     // assert(b > 0); // Solidity automatically throws when dividing by 0
28     uint256 c = a / b;
29     // assert(a == b * c + a % b); // There is no case in which this doesn't hold
30     return c;
31   }
32 
33   /**
34   * @dev Substracts two numbers, throws on overflow (i.e. if subtrahend is greater than minuend).
35   */
36   function sub(uint256 a, uint256 b) internal pure returns (uint256) {
37     assert(b <= a);
38     return a - b;
39   }
40 
41   /**
42   * @dev Adds two numbers, throws on overflow.
43   */
44   function add(uint256 a, uint256 b) internal pure returns (uint256) {
45     uint256 c = a + b;
46     assert(c >= a);
47     return c;
48   }
49 }
50 
51 // File: zeppelin-solidity/contracts/token/ERC721/ERC721.sol
52 
53 /**
54  * @title ERC721 interface
55  * @dev see https://github.com/ethereum/eips/issues/721
56  */
57 contract ERC721 {
58   event Transfer(address indexed _from, address indexed _to, uint256 _tokenId);
59   event Approval(address indexed _owner, address indexed _approved, uint256 _tokenId);
60 
61   function balanceOf(address _owner) public view returns (uint256 _balance);
62   function ownerOf(uint256 _tokenId) public view returns (address _owner);
63   function transfer(address _to, uint256 _tokenId) public;
64   function approve(address _to, uint256 _tokenId) public;
65   function takeOwnership(uint256 _tokenId) public;
66 }
67 
68 // File: zeppelin-solidity/contracts/token/ERC721/ERC721Token.sol
69 
70 /**
71  * @title ERC721Token
72  * Generic implementation for the required functionality of the ERC721 standard
73  */
74 contract ERC721Token is ERC721 {
75   using SafeMath for uint256;
76 
77   // Total amount of tokens
78   uint256 private totalTokens;
79 
80   // Mapping from token ID to owner
81   mapping (uint256 => address) private tokenOwner;
82 
83   // Mapping from token ID to approved address
84   mapping (uint256 => address) private tokenApprovals;
85 
86   // Mapping from owner to list of owned token IDs
87   mapping (address => uint256[]) private ownedTokens;
88 
89   // Mapping from token ID to index of the owner tokens list
90   mapping(uint256 => uint256) private ownedTokensIndex;
91 
92   /**
93   * @dev Guarantees msg.sender is owner of the given token
94   * @param _tokenId uint256 ID of the token to validate its ownership belongs to msg.sender
95   */
96   modifier onlyOwnerOf(uint256 _tokenId) {
97     require(ownerOf(_tokenId) == msg.sender);
98     _;
99   }
100 
101   /**
102   * @dev Gets the total amount of tokens stored by the contract
103   * @return uint256 representing the total amount of tokens
104   */
105   function totalSupply() public view returns (uint256) {
106     return totalTokens;
107   }
108 
109   /**
110   * @dev Gets the balance of the specified address
111   * @param _owner address to query the balance of
112   * @return uint256 representing the amount owned by the passed address
113   */
114   function balanceOf(address _owner) public view returns (uint256) {
115     return ownedTokens[_owner].length;
116   }
117 
118   /**
119   * @dev Gets the list of tokens owned by a given address
120   * @param _owner address to query the tokens of
121   * @return uint256[] representing the list of tokens owned by the passed address
122   */
123   function tokensOf(address _owner) public view returns (uint256[]) {
124     return ownedTokens[_owner];
125   }
126 
127   /**
128   * @dev Gets the owner of the specified token ID
129   * @param _tokenId uint256 ID of the token to query the owner of
130   * @return owner address currently marked as the owner of the given token ID
131   */
132   function ownerOf(uint256 _tokenId) public view returns (address) {
133     address owner = tokenOwner[_tokenId];
134     require(owner != address(0));
135     return owner;
136   }
137 
138   /**
139    * @dev Gets the approved address to take ownership of a given token ID
140    * @param _tokenId uint256 ID of the token to query the approval of
141    * @return address currently approved to take ownership of the given token ID
142    */
143   function approvedFor(uint256 _tokenId) public view returns (address) {
144     return tokenApprovals[_tokenId];
145   }
146 
147   /**
148   * @dev Transfers the ownership of a given token ID to another address
149   * @param _to address to receive the ownership of the given token ID
150   * @param _tokenId uint256 ID of the token to be transferred
151   */
152   function transfer(address _to, uint256 _tokenId) public onlyOwnerOf(_tokenId) {
153     clearApprovalAndTransfer(msg.sender, _to, _tokenId);
154   }
155 
156   /**
157   * @dev Approves another address to claim for the ownership of the given token ID
158   * @param _to address to be approved for the given token ID
159   * @param _tokenId uint256 ID of the token to be approved
160   */
161   function approve(address _to, uint256 _tokenId) public onlyOwnerOf(_tokenId) {
162     address owner = ownerOf(_tokenId);
163     require(_to != owner);
164     if (approvedFor(_tokenId) != 0 || _to != 0) {
165       tokenApprovals[_tokenId] = _to;
166       Approval(owner, _to, _tokenId);
167     }
168   }
169 
170   /**
171   * @dev Claims the ownership of a given token ID
172   * @param _tokenId uint256 ID of the token being claimed by the msg.sender
173   */
174   function takeOwnership(uint256 _tokenId) public {
175     require(isApprovedFor(msg.sender, _tokenId));
176     clearApprovalAndTransfer(ownerOf(_tokenId), msg.sender, _tokenId);
177   }
178 
179   /**
180   * @dev Mint token function
181   * @param _to The address that will own the minted token
182   * @param _tokenId uint256 ID of the token to be minted by the msg.sender
183   */
184   function _mint(address _to, uint256 _tokenId) internal {
185     require(_to != address(0));
186     addToken(_to, _tokenId);
187     Transfer(0x0, _to, _tokenId);
188   }
189 
190   /**
191   * @dev Burns a specific token
192   * @param _tokenId uint256 ID of the token being burned by the msg.sender
193   */
194   function _burn(uint256 _tokenId) onlyOwnerOf(_tokenId) internal {
195     if (approvedFor(_tokenId) != 0) {
196       clearApproval(msg.sender, _tokenId);
197     }
198     removeToken(msg.sender, _tokenId);
199     Transfer(msg.sender, 0x0, _tokenId);
200   }
201 
202   /**
203    * @dev Tells whether the msg.sender is approved for the given token ID or not
204    * This function is not private so it can be extended in further implementations like the operatable ERC721
205    * @param _owner address of the owner to query the approval of
206    * @param _tokenId uint256 ID of the token to query the approval of
207    * @return bool whether the msg.sender is approved for the given token ID or not
208    */
209   function isApprovedFor(address _owner, uint256 _tokenId) internal view returns (bool) {
210     return approvedFor(_tokenId) == _owner;
211   }
212 
213   /**
214   * @dev Internal function to clear current approval and transfer the ownership of a given token ID
215   * @param _from address which you want to send tokens from
216   * @param _to address which you want to transfer the token to
217   * @param _tokenId uint256 ID of the token to be transferred
218   */
219   function clearApprovalAndTransfer(address _from, address _to, uint256 _tokenId) internal {
220     require(_to != address(0));
221     require(_to != ownerOf(_tokenId));
222     require(ownerOf(_tokenId) == _from);
223 
224     clearApproval(_from, _tokenId);
225     removeToken(_from, _tokenId);
226     addToken(_to, _tokenId);
227     Transfer(_from, _to, _tokenId);
228   }
229 
230   /**
231   * @dev Internal function to clear current approval of a given token ID
232   * @param _tokenId uint256 ID of the token to be transferred
233   */
234   function clearApproval(address _owner, uint256 _tokenId) private {
235     require(ownerOf(_tokenId) == _owner);
236     tokenApprovals[_tokenId] = 0;
237     Approval(_owner, 0, _tokenId);
238   }
239 
240   /**
241   * @dev Internal function to add a token ID to the list of a given address
242   * @param _to address representing the new owner of the given token ID
243   * @param _tokenId uint256 ID of the token to be added to the tokens list of the given address
244   */
245   function addToken(address _to, uint256 _tokenId) private {
246     require(tokenOwner[_tokenId] == address(0));
247     tokenOwner[_tokenId] = _to;
248     uint256 length = balanceOf(_to);
249     ownedTokens[_to].push(_tokenId);
250     ownedTokensIndex[_tokenId] = length;
251     totalTokens = totalTokens.add(1);
252   }
253 
254   /**
255   * @dev Internal function to remove a token ID from the list of a given address
256   * @param _from address representing the previous owner of the given token ID
257   * @param _tokenId uint256 ID of the token to be removed from the tokens list of the given address
258   */
259   function removeToken(address _from, uint256 _tokenId) private {
260     require(ownerOf(_tokenId) == _from);
261 
262     uint256 tokenIndex = ownedTokensIndex[_tokenId];
263     uint256 lastTokenIndex = balanceOf(_from).sub(1);
264     uint256 lastToken = ownedTokens[_from][lastTokenIndex];
265 
266     tokenOwner[_tokenId] = 0;
267     ownedTokens[_from][tokenIndex] = lastToken;
268     ownedTokens[_from][lastTokenIndex] = 0;
269     // Note that this will handle single-element arrays. In that case, both tokenIndex and lastTokenIndex are going to
270     // be zero. Then we can make sure that we will remove _tokenId from the ownedTokens list since we are first swapping
271     // the lastToken to the first position, and then dropping the element placed in the last position of the list
272 
273     ownedTokens[_from].length--;
274     ownedTokensIndex[_tokenId] = 0;
275     ownedTokensIndex[lastToken] = tokenIndex;
276     totalTokens = totalTokens.sub(1);
277   }
278 }
279 
280 // File: contracts/Tokenizator.sol
281 
282 /**
283  * @title Tokenizator
284  * @dev A ERC721 contract with token metadata, allows the creation of one token
285    per day by any address.
286  */
287 contract Tokenizator is ERC721Token {
288   using SafeMath for uint256;
289 
290   struct TokenMetadata {
291     bytes32 name;
292     uint256 creationTimestamp;
293     address creator;
294     string description;
295     string base64Image;
296   }
297 
298   uint256 public lockTimestamp;
299 
300   mapping(uint256 => TokenMetadata) public tokenMetadata;
301 
302   function Tokenizator() {
303     lockTimestamp = now;
304   }
305 
306   /**
307   * @dev Public fuction to create a token, it creates only 1 token per hour
308   * @param _name bytes32 Name of the token
309   * @param _description string Description of the token
310   * @param _base64Image string image in base64
311   */
312   function createToken(
313     bytes32 _name, string _description, string _base64Image
314   ) public {
315     require(now > lockTimestamp);
316     lockTimestamp = lockTimestamp.add(1 days);
317     uint256 _tokenId = totalSupply().add(1);
318     _mint(msg.sender, _tokenId);
319     addTokenMetadata(_tokenId, _name, _description, _base64Image);
320   }
321 
322   /**
323   * @dev Internal function to add a the metadata of a token
324   * @param _tokenId uint256 ID of the token to be added to the tokens list of the given address
325   * @param _name bytes32 Name of the token
326   * @param _description string Description of the token
327   * @param _base64Image string image in base64
328   */
329   function addTokenMetadata(
330     uint256 _tokenId, bytes32 _name, string _description, string _base64Image
331   ) private {
332     tokenMetadata[_tokenId] = TokenMetadata(
333       _name, now, msg.sender, _description, _base64Image
334     );
335   }
336 
337   /**
338   * @dev Burns a specific token
339   * @param _tokenId uint256 ID of the token being burned by the msg.sender
340   */
341   function _burn(uint256 _tokenId) onlyOwnerOf(_tokenId) internal {
342     delete tokenMetadata[_tokenId];
343     super._burn(_tokenId);
344   }
345 }