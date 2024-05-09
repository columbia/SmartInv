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
97 /**
98  * @title ERC721Token
99  * Generic implementation for the required functionality of the ERC721 standard
100  */
101 contract MedalData is ERC721, AccessControl, SafeMath {
102   
103   // Total amount of tokens
104   uint256 private totalTokens;
105 
106   // Mapping from token ID to owner
107   mapping (uint256 => address) public tokenOwner;
108 
109 // Mapping from token ID to medal type
110   mapping (uint256 => uint8) public medalType;
111   
112   // Mapping from token ID to approved address
113   mapping (uint256 => address) private tokenApprovals;
114 
115   // Mapping from owner to list of owned token IDs
116   mapping (address => uint256[]) private ownedTokens;
117 
118   // Mapping from token ID to index of the owner tokens list
119   mapping(uint256 => uint256) private ownedTokensIndex;
120   
121   uint32[12] public currentTokenNumbers;
122   
123   uint32[12] public maxTokenNumbers;
124 
125 
126 
127 
128 
129   /**
130   * @dev Guarantees msg.sender is owner of the given token
131   * @param _tokenId uint256 ID of the token to validate its ownership belongs to msg.sender
132   */
133   modifier onlyOwnerOf(uint256 _tokenId) {
134     require(ownerOf(_tokenId) == msg.sender);
135     _;
136   }
137 
138   /**
139   * @dev Gets the total amount of tokens stored by the contract
140   * @return uint256 representing the total amount of tokens
141   */
142   function totalSupply() public view returns (uint256) {
143     return totalTokens;
144   }
145   
146   function setMaxTokenNumbers() external onlyCREATOR {
147       maxTokenNumbers[0] = 5000;
148       maxTokenNumbers[1] = 5000;
149       maxTokenNumbers[2] = 5000;
150       maxTokenNumbers[3] = 5000;
151       maxTokenNumbers[4] = 500;
152       maxTokenNumbers[5] = 500;
153       maxTokenNumbers[6] = 200;
154       maxTokenNumbers[7] = 200;
155       maxTokenNumbers[8] = 200;
156       maxTokenNumbers[9] = 100;
157       maxTokenNumbers[10] = 100;
158       maxTokenNumbers[11] = 50;
159   }
160 
161   /**
162   * @dev Gets the balance of the specified address
163   * @param _owner address to query the balance of
164   * @return uint256 representing the amount owned by the passed address
165   */
166   function balanceOf(address _owner) public view returns (uint256) {
167     return ownedTokens[_owner].length;
168   }
169 
170   /**
171   * @dev Gets the list of tokens owned by a given address
172   * @param _owner address to query the tokens of
173   * @return uint256[] representing the list of tokens owned by the passed address
174   */
175   function tokensOf(address _owner) public view returns (uint256[]) {
176     return ownedTokens[_owner];
177   }
178 
179   /**
180   * @dev Gets the owner of the specified token ID
181   * @param _tokenId uint256 ID of the token to query the owner of
182   * @return owner address currently marked as the owner of the given token ID
183   */
184   function ownerOf(uint256 _tokenId) public view returns (address) {
185     address owner = tokenOwner[_tokenId];
186     require(owner != address(0));
187     return owner;
188   }
189 
190   /**
191    * @dev Gets the approved address to take ownership of a given token ID
192    * @param _tokenId uint256 ID of the token to query the approval of
193    * @return address currently approved to take ownership of the given token ID
194    */
195   function approvedFor(uint256 _tokenId) public view returns (address) {
196     return tokenApprovals[_tokenId];
197   }
198 
199   /**
200   * @dev Transfers the ownership of a given token ID to another address
201   * @param _to address to receive the ownership of the given token ID
202   * @param _tokenId uint256 ID of the token to be transferred
203   */
204   function transfer(address _to, uint256 _tokenId) public onlyOwnerOf(_tokenId) {
205     clearApprovalAndTransfer(msg.sender, _to, _tokenId);
206   }
207 
208   /**
209   * @dev Approves another address to claim for the ownership of the given token ID
210   * @param _to address to be approved for the given token ID
211   * @param _tokenId uint256 ID of the token to be approved
212   */
213   function approve(address _to, uint256 _tokenId) public onlyOwnerOf(_tokenId) {
214     address owner = ownerOf(_tokenId);
215     require(_to != owner);
216     if (approvedFor(_tokenId) != 0 || _to != 0) {
217       tokenApprovals[_tokenId] = _to;
218       Approval(owner, _to, _tokenId);
219     }
220   }
221 
222   /**
223   * @dev Claims the ownership of a given token ID
224   * @param _tokenId uint256 ID of the token being claimed by the msg.sender
225   */
226   function takeOwnership(uint256 _tokenId) public {
227     require(isApprovedFor(msg.sender, _tokenId));
228     clearApprovalAndTransfer(ownerOf(_tokenId), msg.sender, _tokenId);
229   }
230 
231   /**
232   * @dev Mint token function
233   * @param _to The address that will own the minted token
234   */
235   
236   function _createMedal(address _to, uint8 _seriesID) public onlySERAPHIM {
237     require(_to != address(0));
238    if (currentTokenNumbers[_seriesID] <= maxTokenNumbers[_seriesID]) {
239     medalType[totalTokens] = _seriesID;
240     currentTokenNumbers[_seriesID]= currentTokenNumbers[_seriesID]+1;
241     addToken(_to, totalTokens);
242     Transfer(0x0, _to, totalTokens);
243   }
244   }
245 
246 
247     function getCurrentTokensByType(uint32 _seriesID) public constant returns (uint32) {
248         return currentTokenNumbers[_seriesID];
249     }
250 
251     function getMedalType (uint256 _tokenId) public constant returns (uint8) {
252         return medalType[_tokenId];
253     }
254   /**
255   * @dev Burns a specific token
256   * @param _tokenId uint256 ID of the token being burned by the msg.sender
257   */
258   function _burn(uint256 _tokenId) onlyOwnerOf(_tokenId) external {
259     if (approvedFor(_tokenId) != 0) {
260       clearApproval(msg.sender, _tokenId);
261     }
262     removeToken(msg.sender, _tokenId);
263     Transfer(msg.sender, 0x0, _tokenId);
264   }
265 
266   /**
267    * @dev Tells whether the msg.sender is approved for the given token ID or not
268    * This function is not private so it can be extended in further implementations like the operatable ERC721
269    * @param _owner address of the owner to query the approval of
270    * @param _tokenId uint256 ID of the token to query the approval of
271    * @return bool whether the msg.sender is approved for the given token ID or not
272    */
273   function isApprovedFor(address _owner, uint256 _tokenId) internal view returns (bool) {
274     return approvedFor(_tokenId) == _owner;
275   }
276 
277   /**
278   * @dev Internal function to clear current approval and transfer the ownership of a given token ID
279   * @param _from address which you want to send tokens from
280   * @param _to address which you want to transfer the token to
281   * @param _tokenId uint256 ID of the token to be transferred
282   */
283   function clearApprovalAndTransfer(address _from, address _to, uint256 _tokenId) internal {
284     require(_to != address(0));
285     require(_to != ownerOf(_tokenId));
286     require(ownerOf(_tokenId) == _from);
287 
288     clearApproval(_from, _tokenId);
289     removeToken(_from, _tokenId);
290     addToken(_to, _tokenId);
291     Transfer(_from, _to, _tokenId);
292   }
293 
294   /**
295   * @dev Internal function to clear current approval of a given token ID
296   * @param _tokenId uint256 ID of the token to be transferred
297   */
298   function clearApproval(address _owner, uint256 _tokenId) private {
299     require(ownerOf(_tokenId) == _owner);
300     tokenApprovals[_tokenId] = 0;
301     Approval(_owner, 0, _tokenId);
302   }
303 
304   /**
305   * @dev Internal function to add a token ID to the list of a given address
306   * @param _to address representing the new owner of the given token ID
307   * @param _tokenId uint256 ID of the token to be added to the tokens list of the given address
308   */
309   function addToken(address _to, uint256 _tokenId) private {
310     require(tokenOwner[_tokenId] == address(0));
311     tokenOwner[_tokenId] = _to;
312     uint256 length = balanceOf(_to);
313     ownedTokens[_to].push(_tokenId);
314     ownedTokensIndex[_tokenId] = length;
315     totalTokens = safeAdd(totalTokens, 1);
316   }
317 
318   /**
319   * @dev Internal function to remove a token ID from the list of a given address
320   * @param _from address representing the previous owner of the given token ID
321   * @param _tokenId uint256 ID of the token to be removed from the tokens list of the given address
322   */
323   function removeToken(address _from, uint256 _tokenId) private {
324     require(ownerOf(_tokenId) == _from);
325 
326     uint256 tokenIndex = ownedTokensIndex[_tokenId];
327     uint256 lastTokenIndex = safeSubtract(balanceOf(_from),1);
328     uint256 lastToken = ownedTokens[_from][lastTokenIndex];
329 
330     tokenOwner[_tokenId] = 0;
331     ownedTokens[_from][tokenIndex] = lastToken;
332     ownedTokens[_from][lastTokenIndex] = 0;
333     // Note that this will handle single-element arrays. In that case, both tokenIndex and lastTokenIndex are going to
334     // be zero. Then we can make sure that we will remove _tokenId from the ownedTokens list since we are first swapping
335     // the lastToken to the first position, and then dropping the element placed in the last position of the list
336 
337     ownedTokens[_from].length--;
338     ownedTokensIndex[_tokenId] = 0;
339     ownedTokensIndex[lastToken] = tokenIndex;
340     totalTokens = safeSubtract(totalTokens,1);
341   }
342 }