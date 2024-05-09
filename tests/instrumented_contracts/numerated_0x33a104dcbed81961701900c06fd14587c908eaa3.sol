1 pragma solidity ^0.4.18;
2 
3 
4 contract AccessControl {
5     address public creatorAddress;
6     uint16 public totalSeraphims = 0;
7     mapping (address => bool) public seraphims;
8 
9     bool public isMaintenanceMode = true;
10  
11     modifier onlyCREATOR() {
12         require(msg.sender == creatorAddress);
13         _;
14     }
15 
16     modifier onlySERAPHIM() {
17         require(seraphims[msg.sender] == true);
18         _;
19     }
20     
21     modifier isContractActive {
22         require(!isMaintenanceMode);
23         _;
24     }
25     
26     // Constructor
27     function AccessControl() public {
28         creatorAddress = msg.sender;
29     }
30     
31 
32     function addSERAPHIM(address _newSeraphim) onlyCREATOR public {
33         if (seraphims[_newSeraphim] == false) {
34             seraphims[_newSeraphim] = true;
35             totalSeraphims += 1;
36         }
37     }
38     
39     function removeSERAPHIM(address _oldSeraphim) onlyCREATOR public {
40         if (seraphims[_oldSeraphim] == true) {
41             seraphims[_oldSeraphim] = false;
42             totalSeraphims -= 1;
43         }
44     }
45 
46     function updateMaintenanceMode(bool _isMaintaining) onlyCREATOR public {
47         isMaintenanceMode = _isMaintaining;
48     }
49 
50   
51 } 
52 
53 
54 
55 /**
56  * @title ERC721 interface
57  * @dev see https://github.com/ethereum/eips/issues/721
58  */
59 contract ERC721 {
60   event Transfer(address indexed _from, address indexed _to, uint256 _tokenId);
61   event Approval(address indexed _owner, address indexed _approved, uint256 _tokenId);
62 
63   function balanceOf(address _owner) public view returns (uint256 _balance);
64   function ownerOf(uint256 _tokenId) public view returns (address _owner);
65   function transfer(address _to, uint256 _tokenId) public;
66   function approve(address _to, uint256 _tokenId) public;
67   function takeOwnership(uint256 _tokenId) public;
68 }
69 
70 
71 contract SafeMath {
72     function safeAdd(uint x, uint y) pure internal returns(uint) {
73       uint z = x + y;
74       assert((z >= x) && (z >= y));
75       return z;
76     }
77 
78     function safeSubtract(uint x, uint y) pure internal returns(uint) {
79       assert(x >= y);
80       uint z = x - y;
81       return z;
82     }
83 
84     function safeMult(uint x, uint y) pure internal returns(uint) {
85       uint z = x * y;
86       assert((x == 0)||(z/x == y));
87       return z;
88     }
89 
90     function getRandomNumber(uint16 maxRandom, uint8 min, address privateAddress) constant public returns(uint8) {
91         uint256 genNum = uint256(block.blockhash(block.number-1)) + uint256(privateAddress);
92         return uint8(genNum % (maxRandom - min + 1)+min);
93     }
94 }
95 
96 
97 
98 
99 contract IMedalData is AccessControl {
100   
101     modifier onlyOwnerOf(uint256 _tokenId) {
102     require(ownerOf(_tokenId) == msg.sender);
103     _;
104   }
105    
106 function totalSupply() public view returns (uint256);
107 function setMaxTokenNumbers()  onlyCREATOR external;
108 function balanceOf(address _owner) public view returns (uint256);
109 function tokensOf(address _owner) public view returns (uint256[]) ;
110 function ownerOf(uint256 _tokenId) public view returns (address);
111 function approvedFor(uint256 _tokenId) public view returns (address) ;
112 function transfer(address _to, uint256 _tokenId) public onlyOwnerOf(_tokenId);
113 function approve(address _to, uint256 _tokenId) public onlyOwnerOf(_tokenId);
114 function takeOwnership(uint256 _tokenId) public;
115 function _createMedal(address _to, uint8 _seriesID) onlySERAPHIM public ;
116 function getCurrentTokensByType(uint32 _seriesID) public constant returns (uint32);
117 function getMedalType (uint256 _tokenId) public constant returns (uint8);
118 function _burn(uint256 _tokenId) onlyOwnerOf(_tokenId) external;
119 function isApprovedFor(address _owner, uint256 _tokenId) internal view returns (bool) ;
120 function clearApprovalAndTransfer(address _from, address _to, uint256 _tokenId) internal;
121 function clearApproval(address _owner, uint256 _tokenId) private;
122 function addToken(address _to, uint256 _tokenId) private ;
123 function removeToken(address _from, uint256 _tokenId) private;
124 }
125 
126 
127 /**
128  * @title ERC721Token
129  * Generic implementation for the required functionality of the ERC721 standard
130  */
131 contract MedalData is ERC721, AccessControl, SafeMath, IMedalData {
132   
133   // Total amount of tokens
134   uint256 private totalTokens;
135 
136   // Mapping from token ID to owner
137   mapping (uint256 => address) public tokenOwner;
138 
139 // Mapping from token ID to medal type
140   mapping (uint256 => uint8) public medalType;
141   
142   // Mapping from token ID to approved address
143   mapping (uint256 => address) private tokenApprovals;
144 
145   // Mapping from owner to list of owned token IDs
146   mapping (address => uint256[]) private ownedTokens;
147 
148   // Mapping from token ID to index of the owner tokens list
149   mapping(uint256 => uint256) private ownedTokensIndex;
150   
151   uint32[12] public currentTokenNumbers;
152   
153   uint32[12] public maxTokenNumbers;
154 
155 
156 
157 
158 
159   /**
160   * @dev Guarantees msg.sender is owner of the given token
161   * @param _tokenId uint256 ID of the token to validate its ownership belongs to msg.sender
162   */
163   modifier onlyOwnerOf(uint256 _tokenId) {
164     require(ownerOf(_tokenId) == msg.sender);
165     _;
166   }
167 
168   /**
169   * @dev Gets the total amount of tokens stored by the contract
170   * @return uint256 representing the total amount of tokens
171   */
172   function totalSupply() public view returns (uint256) {
173     return totalTokens;
174   }
175   
176   function setMaxTokenNumbers() onlyCREATOR external  {
177       maxTokenNumbers[0] = 5000;
178       maxTokenNumbers[1] = 5000;
179       maxTokenNumbers[2] = 5000;
180       maxTokenNumbers[3] = 5000;
181       maxTokenNumbers[4] = 500;
182       maxTokenNumbers[5] = 500;
183       maxTokenNumbers[6] = 200;
184       maxTokenNumbers[7] = 200;
185       maxTokenNumbers[8] = 200;
186       maxTokenNumbers[9] = 100;
187       maxTokenNumbers[10] = 100;
188       maxTokenNumbers[11] = 50;
189   }
190 
191   /**
192   * @dev Gets the balance of the specified address
193   * @param _owner address to query the balance of
194   * @return uint256 representing the amount owned by the passed address
195   */
196   function balanceOf(address _owner) public view returns (uint256) {
197     return ownedTokens[_owner].length;
198   }
199 
200   /**
201   * @dev Gets the list of tokens owned by a given address
202   * @param _owner address to query the tokens of
203   * @return uint256[] representing the list of tokens owned by the passed address
204   */
205   function tokensOf(address _owner) public view returns (uint256[]) {
206     return ownedTokens[_owner];
207   }
208 
209   /**
210   * @dev Gets the owner of the specified token ID
211   * @param _tokenId uint256 ID of the token to query the owner of
212   * @return owner address currently marked as the owner of the given token ID
213   */
214   function ownerOf(uint256 _tokenId) public view returns (address) {
215     address owner = tokenOwner[_tokenId];
216     require(owner != address(0));
217     return owner;
218   }
219 
220   /**
221    * @dev Gets the approved address to take ownership of a given token ID
222    * @param _tokenId uint256 ID of the token to query the approval of
223    * @return address currently approved to take ownership of the given token ID
224    */
225   function approvedFor(uint256 _tokenId) public view returns (address) {
226     return tokenApprovals[_tokenId];
227   }
228 
229   /**
230   * @dev Transfers the ownership of a given token ID to another address
231   * @param _to address to receive the ownership of the given token ID
232   * @param _tokenId uint256 ID of the token to be transferred
233   */
234   function transfer(address _to, uint256 _tokenId) public onlyOwnerOf(_tokenId) {
235     clearApprovalAndTransfer(msg.sender, _to, _tokenId);
236   }
237 
238   /**
239   * @dev Approves another address to claim for the ownership of the given token ID
240   * @param _to address to be approved for the given token ID
241   * @param _tokenId uint256 ID of the token to be approved
242   */
243   function approve(address _to, uint256 _tokenId) public onlyOwnerOf(_tokenId) {
244     address owner = ownerOf(_tokenId);
245     require(_to != owner);
246     if (approvedFor(_tokenId) != 0 || _to != 0) {
247       tokenApprovals[_tokenId] = _to;
248       Approval(owner, _to, _tokenId);
249     }
250   }
251 
252   /**
253   * @dev Claims the ownership of a given token ID
254   * @param _tokenId uint256 ID of the token being claimed by the msg.sender
255   */
256   function takeOwnership(uint256 _tokenId) public {
257     require(isApprovedFor(msg.sender, _tokenId));
258     clearApprovalAndTransfer(ownerOf(_tokenId), msg.sender, _tokenId);
259   }
260 
261   /**
262   * @dev Mint token function
263   * @param _to The address that will own the minted token
264   */
265   
266   function _createMedal(address _to, uint8 _seriesID)  onlySERAPHIM public {
267     require(_to != address(0));
268    if (currentTokenNumbers[_seriesID] <= maxTokenNumbers[_seriesID]) {
269     medalType[totalTokens] = _seriesID;
270     currentTokenNumbers[_seriesID]= currentTokenNumbers[_seriesID]+1;
271     addToken(_to, totalTokens);
272     Transfer(0x0, _to, totalTokens);
273   }
274   }
275 
276 
277     function getCurrentTokensByType(uint32 _seriesID) public constant returns (uint32) {
278         return currentTokenNumbers[_seriesID];
279     }
280 
281     function getMedalType (uint256 _tokenId) public constant returns (uint8) {
282         return medalType[_tokenId];
283     }
284   /**
285   * @dev Burns a specific token
286   * @param _tokenId uint256 ID of the token being burned by the msg.sender
287   */
288   function _burn(uint256 _tokenId) onlyOwnerOf(_tokenId) external {
289     if (approvedFor(_tokenId) != 0) {
290       clearApproval(msg.sender, _tokenId);
291     }
292     removeToken(msg.sender, _tokenId);
293     Transfer(msg.sender, 0x0, _tokenId);
294   }
295 
296   /**
297    * @dev Tells whether the msg.sender is approved for the given token ID or not
298    * This function is not private so it can be extended in further implementations like the operatable ERC721
299    * @param _owner address of the owner to query the approval of
300    * @param _tokenId uint256 ID of the token to query the approval of
301    * @return bool whether the msg.sender is approved for the given token ID or not
302    */
303   function isApprovedFor(address _owner, uint256 _tokenId) internal view returns (bool) {
304     return approvedFor(_tokenId) == _owner;
305   }
306 
307   /**
308   * @dev Internal function to clear current approval and transfer the ownership of a given token ID
309   * @param _from address which you want to send tokens from
310   * @param _to address which you want to transfer the token to
311   * @param _tokenId uint256 ID of the token to be transferred
312   */
313   function clearApprovalAndTransfer(address _from, address _to, uint256 _tokenId) internal {
314     require(_to != address(0));
315     require(_to != ownerOf(_tokenId));
316     require(ownerOf(_tokenId) == _from);
317 
318     clearApproval(_from, _tokenId);
319     removeToken(_from, _tokenId);
320     addToken(_to, _tokenId);
321     Transfer(_from, _to, _tokenId);
322   }
323 
324   /**
325   * @dev Internal function to clear current approval of a given token ID
326   * @param _tokenId uint256 ID of the token to be transferred
327   */
328   function clearApproval(address _owner, uint256 _tokenId) private {
329     require(ownerOf(_tokenId) == _owner);
330     tokenApprovals[_tokenId] = 0;
331     Approval(_owner, 0, _tokenId);
332   }
333 
334   /**
335   * @dev Internal function to add a token ID to the list of a given address
336   * @param _to address representing the new owner of the given token ID
337   * @param _tokenId uint256 ID of the token to be added to the tokens list of the given address
338   */
339   function addToken(address _to, uint256 _tokenId) private {
340     require(tokenOwner[_tokenId] == address(0));
341     tokenOwner[_tokenId] = _to;
342     uint256 length = balanceOf(_to);
343     ownedTokens[_to].push(_tokenId);
344     ownedTokensIndex[_tokenId] = length;
345     totalTokens = safeAdd(totalTokens, 1);
346   }
347 
348   /**
349   * @dev Internal function to remove a token ID from the list of a given address
350   * @param _from address representing the previous owner of the given token ID
351   * @param _tokenId uint256 ID of the token to be removed from the tokens list of the given address
352   */
353   function removeToken(address _from, uint256 _tokenId) private {
354     require(ownerOf(_tokenId) == _from);
355 
356     uint256 tokenIndex = ownedTokensIndex[_tokenId];
357     uint256 lastTokenIndex = safeSubtract(balanceOf(_from),1);
358     uint256 lastToken = ownedTokens[_from][lastTokenIndex];
359 
360     tokenOwner[_tokenId] = 0;
361     ownedTokens[_from][tokenIndex] = lastToken;
362     ownedTokens[_from][lastTokenIndex] = 0;
363     // Note that this will handle single-element arrays. In that case, both tokenIndex and lastTokenIndex are going to
364     // be zero. Then we can make sure that we will remove _tokenId from the ownedTokens list since we are first swapping
365     // the lastToken to the first position, and then dropping the element placed in the last position of the list
366 
367     ownedTokens[_from].length--;
368     ownedTokensIndex[_tokenId] = 0;
369     ownedTokensIndex[lastToken] = tokenIndex;
370     totalTokens = safeSubtract(totalTokens,1);
371   }
372 }