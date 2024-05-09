1 pragma solidity ^0.4.19;
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
13     function mul(uint256 a, uint256 b) internal pure returns (uint256) {
14         if (a == 0) {
15             return 0;
16         }
17         uint256 c = a * b;
18         assert(c / a == b);
19         return c;
20     }
21 
22   /**
23   * @dev Integer division of two numbers, truncating the quotient.
24   */
25     function div(uint256 a, uint256 b) internal pure returns (uint256) {
26     // assert(b > 0); // Solidity automatically throws when dividing by 0
27         uint256 c = a / b;
28     // assert(a == b * c + a % b); // There is no case in which this doesn't hold
29         return c;
30     }
31 
32   /**
33   * @dev Substracts two numbers, throws on overflow (i.e. if subtrahend is greater than minuend).
34   */
35     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
36         assert(b <= a);
37         return a - b;
38     }
39 
40   /**
41   * @dev Adds two numbers, throws on overflow.
42   */
43     function add(uint256 a, uint256 b) internal pure returns (uint256) {
44         uint256 c = a + b;
45         assert(c >= a);
46         return c;
47     }
48 }
49 
50 
51 contract Ownable {
52     address public owner;
53 
54 
55     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
56 
57   /**
58    * @dev The Ownable constructor sets the original `owner` of the contract to the sender
59    * account.
60    */
61     function Ownable() public {
62         owner = msg.sender;
63     }
64 
65   /**
66    * @dev Throws if called by any account other than the owner.
67    */
68     modifier onlyOwner() {
69         require(msg.sender == owner);
70         _;
71     }
72 
73   /**
74    * @dev Allows the current owner to transfer control of the contract to a newOwner.
75    * @param newOwner The address to transfer ownership to.
76    */
77     function transferOwnership(address newOwner) public onlyOwner {
78         require(newOwner != address(0));
79         OwnershipTransferred(owner, newOwner);
80         owner = newOwner;
81     }
82 
83 }
84 
85 
86 contract ERC721 {
87     event Transfer(address indexed _from, address indexed _to, uint256 _tokenId);
88     event Approval(address indexed _owner, address indexed _approved, uint256 _tokenId);
89 
90     function balanceOf(address _owner) public view returns (uint256 _balance);
91     function ownerOf(uint256 _tokenId) public view returns (address _owner);
92     function transfer(address _to, uint256 _tokenId) public;
93     function approve(address _to, uint256 _tokenId) public;
94     function takeOwnership(uint256 _tokenId) public;
95 }
96 
97 
98 contract ERC721Token is ERC721, Ownable {
99     using SafeMath for uint256;
100 
101     string public constant NAME = "ERC-ME Contribution";
102     string public constant SYMBOL = "MEC";
103 
104     // Total amount of tokens
105     uint256 private totalTokens;
106 
107     // Mapping from token ID to owner
108     mapping (uint256 => address) private tokenOwner;
109 
110     // Mapping from token ID to approved address
111     mapping (uint256 => address) private tokenApprovals;
112 
113     // Mapping from owner to list of owned token IDs
114     mapping (address => uint256[]) private ownedTokens;
115 
116     // Mapping from token ID to index of the owner tokens list
117     mapping(uint256 => uint256) private ownedTokensIndex;
118 
119     struct Contribution {
120         address contributor; // The address of the contributor in the crowdsale
121         uint256 contributionAmount; // The amount of the contribution
122         uint64 contributionTimestamp; // The time at which the contribution was made
123     }
124 
125     Contribution[] public contributions;
126 
127     event ContributionMinted(address indexed _minter, uint256 _contributionSent, uint256 _tokenId);
128 
129   /**
130   * @dev Guarantees msg.sender is owner of the given token
131   * @param _tokenId uint256 ID of the token to validate its ownership belongs to msg.sender
132   */
133     modifier onlyOwnerOf(uint256 _tokenId) {
134         require(ownerOf(_tokenId) == msg.sender);
135         _;
136     }
137 
138   /**
139   * @dev Gets the total amount of tokens stored by the contract
140   * @return uint256 representing the total amount of tokens
141   */
142     function totalSupply() public view returns (uint256) {
143         return contributions.length;
144     }
145 
146   /**
147   * @dev Gets the balance of the specified address
148   * @param _owner address to query the balance of
149   * @return uint256 representing the amount owned by the passed address
150   */
151     function balanceOf(address _owner) public view returns (uint256) {
152         return ownedTokens[_owner].length;
153     }
154 
155   /**
156   * @dev Gets the list of tokens owned by a given address
157   * @param _owner address to query the tokens of
158   * @return uint256[] representing the list of tokens owned by the passed address
159   */
160     function tokensOf(address _owner) public view returns (uint256[]) {
161         return ownedTokens[_owner];
162     }
163 
164   /**
165   * @dev Gets the owner of the specified token ID
166   * @param _tokenId uint256 ID of the token to query the owner of
167   * @return owner address currently marked as the owner of the given token ID
168   */
169     function ownerOf(uint256 _tokenId) public view returns (address) {
170         address owner = tokenOwner[_tokenId];
171         require(owner != address(0));
172         return owner;
173     }
174 
175   /**
176    * @dev Gets the approved address to take ownership of a given token ID
177    * @param _tokenId uint256 ID of the token to query the approval of
178    * @return address currently approved to take ownership of the given token ID
179    */
180     function approvedFor(uint256 _tokenId) public view returns (address) {
181         return tokenApprovals[_tokenId];
182     }
183 
184   /**
185   * @dev Transfers the ownership of a given token ID to another address
186   * @param _to address to receive the ownership of the given token ID
187   * @param _tokenId uint256 ID of the token to be transferred
188   */
189     function transfer(address _to, uint256 _tokenId) public onlyOwnerOf(_tokenId) {
190         clearApprovalAndTransfer(msg.sender, _to, _tokenId);
191     }
192 
193   /**
194   * @dev Approves another address to claim for the ownership of the given token ID
195   * @param _to address to be approved for the given token ID
196   * @param _tokenId uint256 ID of the token to be approved
197   */
198     function approve(address _to, uint256 _tokenId) public onlyOwnerOf(_tokenId) {
199         address owner = ownerOf(_tokenId);
200         require(_to != owner);
201         if (approvedFor(_tokenId) != 0 || _to != 0) {
202             tokenApprovals[_tokenId] = _to;
203             Approval(owner, _to, _tokenId);
204         }
205     }
206 
207   /**
208   * @dev Claims the ownership of a given token ID
209   * @param _tokenId uint256 ID of the token being claimed by the msg.sender
210   */
211     function takeOwnership(uint256 _tokenId) public {
212         require(isApprovedFor(msg.sender, _tokenId));
213         clearApprovalAndTransfer(ownerOf(_tokenId), msg.sender, _tokenId);
214     }
215 
216   /**
217   * @dev Mint token function
218   * @param _to The address that will own the minted token
219   */
220     function mint(address _to, uint256 _amount) public onlyOwner {
221         require(_to != address(0));
222 
223         Contribution memory contribution = Contribution({
224             contributor: _to,
225             contributionAmount: _amount,
226             contributionTimestamp: uint64(now)
227         });
228         uint256 tokenId = contributions.push(contribution) - 1;
229 
230         addToken(_to, tokenId);
231         Transfer(0x0, _to, tokenId);
232         ContributionMinted(_to, _amount, tokenId);
233     }
234 
235     function getContributor(uint256 _tokenId) public view returns(address contributor) {
236         Contribution memory contribution = contributions[_tokenId];
237         contributor = contribution.contributor;
238     }
239 
240     function getContributionAmount(uint256 _tokenId) public view returns(uint256 contributionAmount) {
241         Contribution memory contribution = contributions[_tokenId];
242         contributionAmount = contribution.contributionAmount;
243     }
244 
245     function getContributionTime(uint256 _tokenId) public view returns(uint64 contributionTimestamp) {
246         Contribution memory contribution = contributions[_tokenId];
247         contributionTimestamp = contribution.contributionTimestamp;
248     }
249 
250   /**
251   * @dev Burns a specific token
252   * @param _tokenId uint256 ID of the token being burned by the msg.sender
253   */
254     function _burn(uint256 _tokenId) internal onlyOwnerOf(_tokenId) {
255         if (approvedFor(_tokenId) != 0) {
256             clearApproval(msg.sender, _tokenId);
257         }
258         removeToken(msg.sender, _tokenId);
259         Transfer(msg.sender, 0x0, _tokenId);
260     }
261 
262   /**
263    * @dev Tells whether the msg.sender is approved for the given token ID or not
264    * This function is not private so it can be extended in further implementations like the operatable ERC721
265    * @param _owner address of the owner to query the approval of
266    * @param _tokenId uint256 ID of the token to query the approval of
267    * @return bool whether the msg.sender is approved for the given token ID or not
268    */
269     function isApprovedFor(address _owner, uint256 _tokenId) internal view returns (bool) {
270         return approvedFor(_tokenId) == _owner;
271     }
272 
273   /**
274   * @dev Internal function to clear current approval and transfer the ownership of a given token ID
275   * @param _from address which you want to send tokens from
276   * @param _to address which you want to transfer the token to
277   * @param _tokenId uint256 ID of the token to be transferred
278   */
279     function clearApprovalAndTransfer(address _from, address _to, uint256 _tokenId) internal {
280         require(_to != address(0));
281         require(_to != ownerOf(_tokenId));
282         require(ownerOf(_tokenId) == _from);
283 
284         clearApproval(_from, _tokenId);
285         removeToken(_from, _tokenId);
286         addToken(_to, _tokenId);
287         Transfer(_from, _to, _tokenId);
288     }
289 
290   /**
291   * @dev Internal function to clear current approval of a given token ID
292   * @param _tokenId uint256 ID of the token to be transferred
293   */
294     function clearApproval(address _owner, uint256 _tokenId) private {
295         require(ownerOf(_tokenId) == _owner);
296         tokenApprovals[_tokenId] = 0;
297         Approval(_owner, 0, _tokenId);
298     }
299 
300   /**
301   * @dev Internal function to add a token ID to the list of a given address
302   * @param _to address representing the new owner of the given token ID
303   * @param _tokenId uint256 ID of the token to be added to the tokens list of the given address
304   */
305     function addToken(address _to, uint256 _tokenId) private {
306         require(tokenOwner[_tokenId] == address(0));
307         tokenOwner[_tokenId] = _to;
308         uint256 length = balanceOf(_to);
309         ownedTokens[_to].push(_tokenId);
310         ownedTokensIndex[_tokenId] = length;
311         totalTokens = totalTokens.add(1);
312     }
313 
314   /**
315   * @dev Internal function to remove a token ID from the list of a given address
316   * @param _from address representing the previous owner of the given token ID
317   * @param _tokenId uint256 ID of the token to be removed from the tokens list of the given address
318   */
319     function removeToken(address _from, uint256 _tokenId) private {
320         require(ownerOf(_tokenId) == _from);
321 
322         uint256 tokenIndex = ownedTokensIndex[_tokenId];
323         uint256 lastTokenIndex = balanceOf(_from).sub(1);
324         uint256 lastToken = ownedTokens[_from][lastTokenIndex];
325 
326         tokenOwner[_tokenId] = 0;
327         ownedTokens[_from][tokenIndex] = lastToken;
328         ownedTokens[_from][lastTokenIndex] = 0;
329     // Note that this will handle single-element arrays. In that case, both tokenIndex and lastTokenIndex are going to
330     // be zero. Then we can make sure that we will remove _tokenId from the ownedTokens list since we are first swapping
331     // the lastToken to the first position, and then dropping the element placed in the last position of the list
332 
333         ownedTokens[_from].length--;
334         ownedTokensIndex[_tokenId] = 0;
335         ownedTokensIndex[lastToken] = tokenIndex;
336         totalTokens = totalTokens.sub(1);
337     }
338 }