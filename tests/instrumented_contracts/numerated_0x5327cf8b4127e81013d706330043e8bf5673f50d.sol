1 // File: openzeppelin-solidity/contracts/ownership/Ownable.sol
2 
3 pragma solidity ^0.4.24;
4 
5 
6 /**
7  * @title Ownable
8  * @dev The Ownable contract has an owner address, and provides basic authorization control
9  * functions, this simplifies the implementation of "user permissions".
10  */
11 contract Ownable {
12   address public owner;
13 
14 
15   event OwnershipRenounced(address indexed previousOwner);
16   event OwnershipTransferred(
17     address indexed previousOwner,
18     address indexed newOwner
19   );
20 
21 
22   /**
23    * @dev The Ownable constructor sets the original `owner` of the contract to the sender
24    * account.
25    */
26   constructor() public {
27     owner = msg.sender;
28   }
29 
30   /**
31    * @dev Throws if called by any account other than the owner.
32    */
33   modifier onlyOwner() {
34     require(msg.sender == owner);
35     _;
36   }
37 
38   /**
39    * @dev Allows the current owner to relinquish control of the contract.
40    * @notice Renouncing to ownership will leave the contract without an owner.
41    * It will not be possible to call the functions with the `onlyOwner`
42    * modifier anymore.
43    */
44   function renounceOwnership() public onlyOwner {
45     emit OwnershipRenounced(owner);
46     owner = address(0);
47   }
48 
49   /**
50    * @dev Allows the current owner to transfer control of the contract to a newOwner.
51    * @param _newOwner The address to transfer ownership to.
52    */
53   function transferOwnership(address _newOwner) public onlyOwner {
54     _transferOwnership(_newOwner);
55   }
56 
57   /**
58    * @dev Transfers control of the contract to a newOwner.
59    * @param _newOwner The address to transfer ownership to.
60    */
61   function _transferOwnership(address _newOwner) internal {
62     require(_newOwner != address(0));
63     emit OwnershipTransferred(owner, _newOwner);
64     owner = _newOwner;
65   }
66 }
67 
68 // File: openzeppelin-solidity/contracts/lifecycle/Pausable.sol
69 
70 pragma solidity ^0.4.24;
71 
72 
73 
74 /**
75  * @title Pausable
76  * @dev Base contract which allows children to implement an emergency stop mechanism.
77  */
78 contract Pausable is Ownable {
79   event Pause();
80   event Unpause();
81 
82   bool public paused = false;
83 
84 
85   /**
86    * @dev Modifier to make a function callable only when the contract is not paused.
87    */
88   modifier whenNotPaused() {
89     require(!paused);
90     _;
91   }
92 
93   /**
94    * @dev Modifier to make a function callable only when the contract is paused.
95    */
96   modifier whenPaused() {
97     require(paused);
98     _;
99   }
100 
101   /**
102    * @dev called by the owner to pause, triggers stopped state
103    */
104   function pause() public onlyOwner whenNotPaused {
105     paused = true;
106     emit Pause();
107   }
108 
109   /**
110    * @dev called by the owner to unpause, returns to normal state
111    */
112   function unpause() public onlyOwner whenPaused {
113     paused = false;
114     emit Unpause();
115   }
116 }
117 
118 // File: openzeppelin-solidity/contracts/math/SafeMath.sol
119 
120 pragma solidity ^0.4.24;
121 
122 
123 /**
124  * @title SafeMath
125  * @dev Math operations with safety checks that throw on error
126  */
127 library SafeMath {
128 
129   /**
130   * @dev Multiplies two numbers, throws on overflow.
131   */
132   function mul(uint256 _a, uint256 _b) internal pure returns (uint256 c) {
133     // Gas optimization: this is cheaper than asserting 'a' not being zero, but the
134     // benefit is lost if 'b' is also tested.
135     // See: https://github.com/OpenZeppelin/openzeppelin-solidity/pull/522
136     if (_a == 0) {
137       return 0;
138     }
139 
140     c = _a * _b;
141     assert(c / _a == _b);
142     return c;
143   }
144 
145   /**
146   * @dev Integer division of two numbers, truncating the quotient.
147   */
148   function div(uint256 _a, uint256 _b) internal pure returns (uint256) {
149     // assert(_b > 0); // Solidity automatically throws when dividing by 0
150     // uint256 c = _a / _b;
151     // assert(_a == _b * c + _a % _b); // There is no case in which this doesn't hold
152     return _a / _b;
153   }
154 
155   /**
156   * @dev Subtracts two numbers, throws on overflow (i.e. if subtrahend is greater than minuend).
157   */
158   function sub(uint256 _a, uint256 _b) internal pure returns (uint256) {
159     assert(_b <= _a);
160     return _a - _b;
161   }
162 
163   /**
164   * @dev Adds two numbers, throws on overflow.
165   */
166   function add(uint256 _a, uint256 _b) internal pure returns (uint256 c) {
167     c = _a + _b;
168     assert(c >= _a);
169     return c;
170   }
171 }
172 
173 // File: contracts/v2/interfaces/IKODAV2Controls.sol
174 
175 pragma solidity 0.4.24;
176 
177 /**
178 * Minimal interface definition for KODA V2 contract calls
179 *
180 * https://www.knownorigin.io/
181 */
182 interface IKODAV2Controls {
183   function mint(address _to, uint256 _editionNumber) external returns (uint256);
184 
185   function editionActive(uint256 _editionNumber) external view returns (bool);
186 
187   function artistCommission(uint256 _editionNumber) external view returns (address _artistAccount, uint256 _artistCommission);
188 
189   function updatePriceInWei(uint256 _editionNumber, uint256 _priceInWei) external;
190 
191   function updateActive(uint256 _editionNumber, bool _active) external;
192 }
193 
194 // File: contracts/v2/artist-controls/ArtistEditionControlsV2.sol
195 
196 pragma solidity 0.4.24;
197 
198 
199 
200 
201 
202 /**
203 * @title Artists self minting for KnownOrigin (KODA)
204 *
205 * Allows for the edition artists to mint there own assets and control the price of an edition
206 *
207 * https://www.knownorigin.io/
208 *
209 * BE ORIGINAL. BUY ORIGINAL.
210 */
211 contract ArtistEditionControlsV2 is Ownable, Pausable {
212   using SafeMath for uint256;
213 
214   // Interface into the KODA world
215   IKODAV2Controls public kodaAddress;
216 
217   event PriceChanged(
218     uint256 indexed _editionNumber,
219     address indexed _artist,
220     uint256 _priceInWei
221   );
222 
223   event EditionGifted(
224     uint256 indexed _editionNumber,
225     address indexed _artist,
226     uint256 indexed _tokenId
227   );
228 
229   event EditionDeactivated(
230     uint256 indexed _editionNumber
231   );
232 
233   bool public deactivationPaused = false;
234 
235   modifier whenDeactivationNotPaused() {
236     require(!deactivationPaused);
237     _;
238   }
239 
240   constructor(IKODAV2Controls _kodaAddress) public {
241     kodaAddress = _kodaAddress;
242   }
243 
244   /**
245    * @dev Ability to gift new NFTs to an address, from a KODA edition
246    * @dev Only callable from edition artists defined in KODA NFT contract
247    * @dev Only callable when contract is not paused
248    * @dev Reverts if edition is invalid
249    * @dev Reverts if edition is not active in KDOA NFT contract
250    */
251   function gift(address _receivingAddress, uint256 _editionNumber)
252   external
253   whenNotPaused
254   returns (uint256)
255   {
256     require(_receivingAddress != address(0), "Unable to send to zero address");
257 
258     (address artistAccount, uint256 _) = kodaAddress.artistCommission(_editionNumber);
259     require(msg.sender == artistAccount || msg.sender == owner, "Only from the edition artist account");
260 
261     bool isActive = kodaAddress.editionActive(_editionNumber);
262     require(isActive, "Only when edition is active");
263 
264     uint256 tokenId = kodaAddress.mint(_receivingAddress, _editionNumber);
265 
266     emit EditionGifted(_editionNumber, msg.sender, tokenId);
267 
268     return tokenId;
269   }
270 
271   /**
272    * @dev Sets the price of the provided edition in the WEI
273    * @dev Only callable from edition artists defined in KODA NFT contract
274    * @dev Only callable when contract is not paused
275    * @dev Reverts if edition is invalid
276    */
277   function updateEditionPrice(uint256 _editionNumber, uint256 _priceInWei)
278   external
279   whenNotPaused
280   returns (bool)
281   {
282     (address artistAccount, uint256 _) = kodaAddress.artistCommission(_editionNumber);
283     require(msg.sender == artistAccount || msg.sender == owner, "Only from the edition artist account");
284 
285     kodaAddress.updatePriceInWei(_editionNumber, _priceInWei);
286 
287     emit PriceChanged(_editionNumber, msg.sender, _priceInWei);
288 
289     return true;
290   }
291 
292   /**
293    * @dev Sets provided edition to deactivated so it does not appear on the platform
294    * @dev Only callable from edition artists defined in KODA NFT contract
295    * @dev Only callable when contract is not paused
296    * @dev Reverts if edition is invalid
297    * @dev Reverts if edition is not active in KDOA NFT contract
298    */
299   function deactivateEdition(uint256 _editionNumber)
300   external
301   whenNotPaused
302   whenDeactivationNotPaused
303   returns (bool)
304   {
305     (address artistAccount, uint256 _) = kodaAddress.artistCommission(_editionNumber);
306     require(msg.sender == artistAccount || msg.sender == owner, "Only from the edition artist account");
307 
308     // Only allow them to be disabled if we have not already done it already
309     bool isActive = kodaAddress.editionActive(_editionNumber);
310     require(isActive, "Only when edition is active");
311 
312     kodaAddress.updateActive(_editionNumber, false);
313 
314     emit EditionDeactivated(_editionNumber);
315 
316     return true;
317   }
318 
319   /**
320    * @dev Sets the KODA address
321    * @dev Only callable from owner
322    */
323   function setKodavV2(IKODAV2Controls _kodaAddress) onlyOwner public {
324     kodaAddress = _kodaAddress;
325   }
326 
327   /**
328    * @dev Disables the ability to deactivate editions from the this contract
329    * @dev Only callable from owner
330    */
331   function pauseDeactivation() onlyOwner public {
332     deactivationPaused = true;
333   }
334 
335   /**
336    * @dev Enables the ability to deactivate editions from the this contract
337    * @dev Only callable from owner
338    */
339   function enablesDeactivation() onlyOwner public {
340     deactivationPaused = false;
341   }
342 
343 }