1 pragma solidity ^0.4.18;
2 
3 
4 /**
5  * @title SafeMath
6  * @dev Math operations with safety checks that throw on error
7  */
8 library SafeMath {
9 
10   /**
11   * @dev Multiplies two numbers, throws on overflow.
12   */
13   function mul(uint256 a, uint256 b) internal pure returns (uint256) {
14     if (a == 0) {
15       return 0;
16     }
17     uint256 c = a * b;
18     assert(c / a == b);
19     return c;
20   }
21 
22   /**
23   * @dev Integer division of two numbers, truncating the quotient.
24   */
25   function div(uint256 a, uint256 b) internal pure returns (uint256) {
26     // assert(b > 0); // Solidity automatically throws when dividing by 0
27     uint256 c = a / b;
28     // assert(a == b * c + a % b); // There is no case in which this doesn't hold
29     return c;
30   }
31 
32   /**
33   * @dev Substracts two numbers, throws on overflow (i.e. if subtrahend is greater than minuend).
34   */
35   function sub(uint256 a, uint256 b) internal pure returns (uint256) {
36     assert(b <= a);
37     return a - b;
38   }
39 
40   /**
41   * @dev Adds two numbers, throws on overflow.
42   */
43   function add(uint256 a, uint256 b) internal pure returns (uint256) {
44     uint256 c = a + b;
45     assert(c >= a);
46     return c;
47   }
48 }
49 
50 /**
51  * @title Ownable
52  * @dev The Ownable contract has an owner address, and provides basic authorization control
53  * functions, this simplifies the implementation of "user permissions".
54  */
55 contract Ownable {
56   address public owner;
57 
58 
59   event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
60 
61 
62   /**
63    * @dev The Ownable constructor sets the original `owner` of the contract to the sender
64    * account.
65    */
66   function Ownable() public {
67     owner = msg.sender;
68   }
69 
70   /**
71    * @dev Throws if called by any account other than the owner.
72    */
73   modifier onlyOwner() {
74     require(msg.sender == owner);
75     _;
76   }
77 
78   /**
79    * @dev Allows the current owner to transfer control of the contract to a newOwner.
80    * @param newOwner The address to transfer ownership to.
81    */
82   function transferOwnership(address newOwner) public onlyOwner {
83     require(newOwner != address(0));
84     emit OwnershipTransferred(owner, newOwner);
85     owner = newOwner;
86   }
87 
88 }
89 
90 /**
91  * @title ERC20Basic
92  * @dev Simpler version of ERC20 interface
93  * @dev see https://github.com/ethereum/EIPs/issues/179
94  */
95 contract ERC20Basic {
96   function totalSupply() public view returns (uint256);
97   function balanceOf(address who) public view returns (uint256);
98   function transfer(address to, uint256 value) public returns (bool);
99   event Transfer(address indexed from, address indexed to, uint256 value);
100 }
101 
102 /**
103  * @title ERC20 interface
104  * @dev see https://github.com/ethereum/EIPs/issues/20
105  */
106 contract ERC20 is ERC20Basic {
107   function allowance(address owner, address spender) public view returns (uint256);
108   function transferFrom(address from, address to, uint256 value) public returns (bool);
109   function approve(address spender, uint256 value) public returns (bool);
110   event Approval(address indexed owner, address indexed spender, uint256 value);
111 }
112 
113 /**
114  * @title SafeERC20
115  * @dev Wrappers around ERC20 operations that throw on failure.
116  * To use this library you can add a `using SafeERC20 for ERC20;` statement to your contract,
117  * which allows you to call the safe operations as `token.safeTransfer(...)`, etc.
118  */
119 library SafeERC20 {
120   function safeTransfer(ERC20Basic token, address to, uint256 value) internal {
121     assert(token.transfer(to, value));
122   }
123 
124   function safeTransferFrom(ERC20 token, address from, address to, uint256 value) internal {
125     assert(token.transferFrom(from, to, value));
126   }
127 
128   function safeApprove(ERC20 token, address spender, uint256 value) internal {
129     assert(token.approve(spender, value));
130   }
131 }
132 
133 /**
134  * @title ERC721 interface
135  * @dev see https://github.com/ethereum/eips/issues/721
136  */
137 contract ERC721 {
138   event Transfer(address indexed _from, address indexed _to, uint256 _tokenId);
139   event Approval(address indexed _owner, address indexed _approved, uint256 _tokenId);
140 
141   function balanceOf(address _owner) public view returns (uint256 _balance);
142   function ownerOf(uint256 _tokenId) public view returns (address _owner);
143   function transfer(address _to, uint256 _tokenId) public;
144   function approve(address _to, uint256 _tokenId) public;
145   function takeOwnership(uint256 _tokenId) public;
146 }
147 
148 /**
149  * @title ERC721Token
150  * Generic implementation for the required functionality of the ERC721 standard
151  */
152 contract ERC721Token is ERC721 {
153   using SafeMath for uint256;
154 
155   // Total amount of tokens
156   uint256 private totalTokens;
157 
158   // Mapping from token ID to owner
159   mapping (uint256 => address) private tokenOwner;
160 
161   // Mapping from token ID to approved address
162   mapping (uint256 => address) private tokenApprovals;
163 
164   // Mapping from owner to list of owned token IDs
165   mapping (address => uint256[]) private ownedTokens;
166 
167   // Mapping from token ID to index of the owner tokens list
168   mapping(uint256 => uint256) private ownedTokensIndex;
169 
170   /**
171   * @dev Guarantees msg.sender is owner of the given token
172   * @param _tokenId uint256 ID of the token to validate its ownership belongs to msg.sender
173   */
174   modifier onlyOwnerOf(uint256 _tokenId) {
175     require(ownerOf(_tokenId) == msg.sender);
176     _;
177   }
178 
179   /**
180   * @dev Gets the total amount of tokens stored by the contract
181   * @return uint256 representing the total amount of tokens
182   */
183   function totalSupply() public view returns (uint256) {
184     return totalTokens;
185   }
186 
187   /**
188   * @dev Gets the balance of the specified address
189   * @param _owner address to query the balance of
190   * @return uint256 representing the amount owned by the passed address
191   */
192   function balanceOf(address _owner) public view returns (uint256) {
193     return ownedTokens[_owner].length;
194   }
195 
196   /**
197   * @dev Gets the list of tokens owned by a given address
198   * @param _owner address to query the tokens of
199   * @return uint256[] representing the list of tokens owned by the passed address
200   */
201   function tokensOf(address _owner) public view returns (uint256[]) {
202     return ownedTokens[_owner];
203   }
204 
205   /**
206   * @dev Gets the owner of the specified token ID
207   * @param _tokenId uint256 ID of the token to query the owner of
208   * @return owner address currently marked as the owner of the given token ID
209   */
210   function ownerOf(uint256 _tokenId) public view returns (address) {
211     address owner = tokenOwner[_tokenId];
212     require(owner != address(0));
213     return owner;
214   }
215 
216   /**
217    * @dev Gets the approved address to take ownership of a given token ID
218    * @param _tokenId uint256 ID of the token to query the approval of
219    * @return address currently approved to take ownership of the given token ID
220    */
221   function approvedFor(uint256 _tokenId) public view returns (address) {
222     return tokenApprovals[_tokenId];
223   }
224 
225   /**
226   * @dev Transfers the ownership of a given token ID to another address
227   * @param _to address to receive the ownership of the given token ID
228   * @param _tokenId uint256 ID of the token to be transferred
229   */
230   function transfer(address _to, uint256 _tokenId) public onlyOwnerOf(_tokenId) {
231     clearApprovalAndTransfer(msg.sender, _to, _tokenId);
232   }
233 
234   /**
235   * @dev Approves another address to claim for the ownership of the given token ID
236   * @param _to address to be approved for the given token ID
237   * @param _tokenId uint256 ID of the token to be approved
238   */
239   function approve(address _to, uint256 _tokenId) public onlyOwnerOf(_tokenId) {
240     address owner = ownerOf(_tokenId);
241     require(_to != owner);
242     if (approvedFor(_tokenId) != 0 || _to != 0) {
243       tokenApprovals[_tokenId] = _to;
244       emit Approval(owner, _to, _tokenId);
245     }
246   }
247 
248   /**
249   * @dev Claims the ownership of a given token ID
250   * @param _tokenId uint256 ID of the token being claimed by the msg.sender
251   */
252   function takeOwnership(uint256 _tokenId) public {
253     require(isApprovedFor(msg.sender, _tokenId));
254     clearApprovalAndTransfer(ownerOf(_tokenId), msg.sender, _tokenId);
255   }
256 
257   /**
258   * @dev Mint token function
259   * @param _to The address that will own the minted token
260   * @param _tokenId uint256 ID of the token to be minted by the msg.sender
261   */
262   function _mint(address _to, uint256 _tokenId) internal {
263     require(_to != address(0));
264     addToken(_to, _tokenId);
265     emit Transfer(0x0, _to, _tokenId);
266   }
267 
268   /**
269   * @dev Burns a specific token
270   * @param _tokenId uint256 ID of the token being burned by the msg.sender
271   */
272   function _burn(uint256 _tokenId) onlyOwnerOf(_tokenId) internal {
273     if (approvedFor(_tokenId) != 0) {
274       clearApproval(msg.sender, _tokenId);
275     }
276     removeToken(msg.sender, _tokenId);
277     emit Transfer(msg.sender, 0x0, _tokenId);
278   }
279 
280   /**
281    * @dev Tells whether the msg.sender is approved for the given token ID or not
282    * This function is not private so it can be extended in further implementations like the operatable ERC721
283    * @param _owner address of the owner to query the approval of
284    * @param _tokenId uint256 ID of the token to query the approval of
285    * @return bool whether the msg.sender is approved for the given token ID or not
286    */
287   function isApprovedFor(address _owner, uint256 _tokenId) internal view returns (bool) {
288     return approvedFor(_tokenId) == _owner;
289   }
290 
291   /**
292   * @dev Internal function to clear current approval and transfer the ownership of a given token ID
293   * @param _from address which you want to send tokens from
294   * @param _to address which you want to transfer the token to
295   * @param _tokenId uint256 ID of the token to be transferred
296   */
297   function clearApprovalAndTransfer(address _from, address _to, uint256 _tokenId) internal {
298     require(_to != address(0));
299     require(_to != ownerOf(_tokenId));
300     require(ownerOf(_tokenId) == _from);
301 
302     clearApproval(_from, _tokenId);
303     removeToken(_from, _tokenId);
304     addToken(_to, _tokenId);
305     emit Transfer(_from, _to, _tokenId);
306   }
307 
308   /**
309   * @dev Internal function to clear current approval of a given token ID
310   * @param _tokenId uint256 ID of the token to be transferred
311   */
312   function clearApproval(address _owner, uint256 _tokenId) private {
313     require(ownerOf(_tokenId) == _owner);
314     tokenApprovals[_tokenId] = 0;
315     emit Approval(_owner, 0, _tokenId);
316   }
317 
318   /**
319   * @dev Internal function to add a token ID to the list of a given address
320   * @param _to address representing the new owner of the given token ID
321   * @param _tokenId uint256 ID of the token to be added to the tokens list of the given address
322   */
323   function addToken(address _to, uint256 _tokenId) private {
324     require(tokenOwner[_tokenId] == address(0));
325     tokenOwner[_tokenId] = _to;
326     uint256 length = balanceOf(_to);
327     ownedTokens[_to].push(_tokenId);
328     ownedTokensIndex[_tokenId] = length;
329     totalTokens = totalTokens.add(1);
330   }
331 
332   /**
333   * @dev Internal function to remove a token ID from the list of a given address
334   * @param _from address representing the previous owner of the given token ID
335   * @param _tokenId uint256 ID of the token to be removed from the tokens list of the given address
336   */
337   function removeToken(address _from, uint256 _tokenId) private {
338     require(ownerOf(_tokenId) == _from);
339 
340     uint256 tokenIndex = ownedTokensIndex[_tokenId];
341     uint256 lastTokenIndex = balanceOf(_from).sub(1);
342     uint256 lastToken = ownedTokens[_from][lastTokenIndex];
343 
344     tokenOwner[_tokenId] = 0;
345     ownedTokens[_from][tokenIndex] = lastToken;
346     ownedTokens[_from][lastTokenIndex] = 0;
347     // Note that this will handle single-element arrays. In that case, both tokenIndex and lastTokenIndex are going to
348     // be zero. Then we can make sure that we will remove _tokenId from the ownedTokens list since we are first swapping
349     // the lastToken to the first position, and then dropping the element placed in the last position of the list
350 
351     ownedTokens[_from].length--;
352     ownedTokensIndex[_tokenId] = 0;
353     ownedTokensIndex[lastToken] = tokenIndex;
354     totalTokens = totalTokens.sub(1);
355   }
356 }
357 
358 /**
359  * @title Contracts that should be able to recover tokens
360  * @author SylTi
361  * @dev This allow a contract to recover any ERC20 token received in a contract by transferring the balance to the contract owner.
362  * This will prevent any accidental loss of tokens.
363  */
364 contract CanReclaimToken is Ownable {
365   using SafeERC20 for ERC20Basic;
366 
367   /**
368    * @dev Reclaim all ERC20Basic compatible tokens
369    * @param token ERC20Basic The address of the token contract
370    */
371   function reclaimToken(ERC20Basic token) external onlyOwner {
372     uint256 balance = token.balanceOf(this);
373     token.safeTransfer(owner, balance);
374   }
375 
376 }
377 
378 contract HeroesToken is ERC721Token, CanReclaimToken {
379     using SafeMath for uint256;
380 
381     event Bought (uint256 indexed _tokenId, address indexed _owner, uint256 _price);
382     event Sold (uint256 indexed _tokenId, address indexed _owner, uint256 _price);
383 
384     uint256[] private listedTokens;
385     mapping (uint256 => uint256) private priceOfToken;
386 
387     uint256[4] private limits = [0.05 ether, 0.5 ether, 5.0 ether];
388 
389     uint256[4] private fees = [6, 5, 4, 3]; // 6%, 5%; 4%, 3%
390     uint256[4] private increases = [200, 150, 130, 120]; // +100%, +50%; +30%, +20%
391 
392     function HeroesToken() ERC721Token() public {}
393 
394     function mint(address _to, uint256 _tokenId, uint256 _price) public onlyOwner {
395         require(_to != address(this));
396 
397         super._mint(_to, _tokenId);
398         listedTokens.push(_tokenId);
399         priceOfToken[_tokenId] = _price;
400     }
401 
402     function priceOf(uint256 _tokenId) public view returns (uint256) {
403         return priceOfToken[_tokenId];
404     }
405 
406     function calculateFee(uint256 _price) public view returns (uint256) {
407         if (_price < limits[0]) {
408             return _price.mul(fees[0]).div(100);
409         } else if (_price < limits[1]) {
410             return _price.mul(fees[1]).div(100);
411         } else if (_price < limits[2]) {
412             return _price.mul(fees[2]).div(100);
413         } else {
414             return _price.mul(fees[3]).div(100);
415         }
416     }
417 
418     function calculatePrice(uint256 _price) public view returns (uint256) {
419         if (_price < limits[0]) {
420             return _price.mul(increases[0]).div(100 - fees[0]);
421         } else if (_price < limits[1]) {
422             return _price.mul(increases[1]).div(100 - fees[1]);
423         } else if (_price < limits[2]) {
424             return _price.mul(increases[2]).div(100 - fees[2]);
425         } else {
426             return _price.mul(increases[3]).div(100 - fees[3]);
427         }
428     }
429 
430     function buy(uint256 _tokenId) public payable {
431         require(priceOf(_tokenId) > 0);
432         require(ownerOf(_tokenId) != address(0));
433         require(msg.value >= priceOf(_tokenId));
434         require(ownerOf(_tokenId) != msg.sender);
435         require(!isContract(msg.sender));
436         require(msg.sender != address(0));
437 
438         address oldOwner = ownerOf(_tokenId);
439         address newOwner = msg.sender;
440         uint256 price = priceOf(_tokenId);
441         uint256 excess = msg.value.sub(price);
442 
443         super.clearApprovalAndTransfer(oldOwner, newOwner, _tokenId);
444         priceOfToken[_tokenId] = calculatePrice(price);
445 
446         emit Bought(_tokenId, newOwner, price);
447         emit Sold(_tokenId, oldOwner, price);
448 
449         uint256 fee = calculateFee(price);
450         oldOwner.transfer(price.sub(fee));
451 
452         if (excess > 0) {
453             newOwner.transfer(excess);
454         }
455     }
456 
457     function withdrawAll() public onlyOwner {
458         owner.transfer(address(this).balance);
459     }
460 
461     function withdrawAmount(uint256 _amount) public onlyOwner {
462         owner.transfer(_amount);
463     }
464 
465     function listedTokensAsBytes(uint256 _from, uint256 _to) public constant returns (bytes) {
466         require(_from >= 0);
467         require(_to >= _from);
468         require(_to < listedTokens.length);
469       
470         // Size of bytes
471         uint256 size = 32 * (_to - _from + 1);
472         uint256 counter = 0;
473         bytes memory b = new bytes(size);
474         for (uint256 x = _from; x < _to + 1; x++) {
475             uint256 elem = listedTokens[x];
476             for (uint y = 0; y < 32; y++) {
477                 b[counter] = byte(uint8(elem / (2 ** (8 * (31 - y)))));
478                 counter++;
479             }
480         }
481         return b;
482     }
483 
484     function isContract(address _addr) internal view returns (bool) {
485         uint size;
486         assembly { size := extcodesize(_addr) }
487         return size > 0;
488     }
489 }