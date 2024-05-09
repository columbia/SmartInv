1 pragma solidity 0.4.24;
2 
3 // File: openzeppelin-solidity/contracts/ownership/Ownable.sol
4 
5 /**
6  * @title Ownable
7  * @dev The Ownable contract has an owner address, and provides basic authorization control
8  * functions, this simplifies the implementation of "user permissions".
9  */
10 contract Ownable {
11   address public owner;
12 
13 
14   event OwnershipRenounced(address indexed previousOwner);
15   event OwnershipTransferred(
16     address indexed previousOwner,
17     address indexed newOwner
18   );
19 
20 
21   /**
22    * @dev The Ownable constructor sets the original `owner` of the contract to the sender
23    * account.
24    */
25   constructor() public {
26     owner = msg.sender;
27   }
28 
29   /**
30    * @dev Throws if called by any account other than the owner.
31    */
32   modifier onlyOwner() {
33     require(msg.sender == owner);
34     _;
35   }
36 
37   /**
38    * @dev Allows the current owner to relinquish control of the contract.
39    * @notice Renouncing to ownership will leave the contract without an owner.
40    * It will not be possible to call the functions with the `onlyOwner`
41    * modifier anymore.
42    */
43   function renounceOwnership() public onlyOwner {
44     emit OwnershipRenounced(owner);
45     owner = address(0);
46   }
47 
48   /**
49    * @dev Allows the current owner to transfer control of the contract to a newOwner.
50    * @param _newOwner The address to transfer ownership to.
51    */
52   function transferOwnership(address _newOwner) public onlyOwner {
53     _transferOwnership(_newOwner);
54   }
55 
56   /**
57    * @dev Transfers control of the contract to a newOwner.
58    * @param _newOwner The address to transfer ownership to.
59    */
60   function _transferOwnership(address _newOwner) internal {
61     require(_newOwner != address(0));
62     emit OwnershipTransferred(owner, _newOwner);
63     owner = _newOwner;
64   }
65 }
66 
67 // File: openzeppelin-solidity/contracts/lifecycle/Pausable.sol
68 
69 /**
70  * @title Pausable
71  * @dev Base contract which allows children to implement an emergency stop mechanism.
72  */
73 contract Pausable is Ownable {
74   event Pause();
75   event Unpause();
76 
77   bool public paused = false;
78 
79 
80   /**
81    * @dev Modifier to make a function callable only when the contract is not paused.
82    */
83   modifier whenNotPaused() {
84     require(!paused);
85     _;
86   }
87 
88   /**
89    * @dev Modifier to make a function callable only when the contract is paused.
90    */
91   modifier whenPaused() {
92     require(paused);
93     _;
94   }
95 
96   /**
97    * @dev called by the owner to pause, triggers stopped state
98    */
99   function pause() public onlyOwner whenNotPaused {
100     paused = true;
101     emit Pause();
102   }
103 
104   /**
105    * @dev called by the owner to unpause, returns to normal state
106    */
107   function unpause() public onlyOwner whenPaused {
108     paused = false;
109     emit Unpause();
110   }
111 }
112 
113 // File: openzeppelin-solidity/contracts/math/SafeMath.sol
114 
115 /**
116  * @title SafeMath
117  * @dev Math operations with safety checks that throw on error
118  */
119 library SafeMath {
120 
121   /**
122   * @dev Multiplies two numbers, throws on overflow.
123   */
124   function mul(uint256 _a, uint256 _b) internal pure returns (uint256 c) {
125     // Gas optimization: this is cheaper than asserting 'a' not being zero, but the
126     // benefit is lost if 'b' is also tested.
127     // See: https://github.com/OpenZeppelin/openzeppelin-solidity/pull/522
128     if (_a == 0) {
129       return 0;
130     }
131 
132     c = _a * _b;
133     assert(c / _a == _b);
134     return c;
135   }
136 
137   /**
138   * @dev Integer division of two numbers, truncating the quotient.
139   */
140   function div(uint256 _a, uint256 _b) internal pure returns (uint256) {
141     // assert(_b > 0); // Solidity automatically throws when dividing by 0
142     // uint256 c = _a / _b;
143     // assert(_a == _b * c + _a % _b); // There is no case in which this doesn't hold
144     return _a / _b;
145   }
146 
147   /**
148   * @dev Subtracts two numbers, throws on overflow (i.e. if subtrahend is greater than minuend).
149   */
150   function sub(uint256 _a, uint256 _b) internal pure returns (uint256) {
151     assert(_b <= _a);
152     return _a - _b;
153   }
154 
155   /**
156   * @dev Adds two numbers, throws on overflow.
157   */
158   function add(uint256 _a, uint256 _b) internal pure returns (uint256 c) {
159     c = _a + _b;
160     assert(c >= _a);
161     return c;
162   }
163 }
164 
165 // File: contracts/v2/tools/ArtistEditionControls.sol
166 
167 /**
168 * Minimal interface definition for KODA V2 contract calls
169 *
170 * https://www.knownorigin.io/
171 */
172 interface IKODAV2Controls {
173   function mint(address _to, uint256 _editionNumber) external returns (uint256);
174 
175   function editionActive(uint256 _editionNumber) external view returns (bool);
176 
177   function artistCommission(uint256 _editionNumber) external view returns (address _artistAccount, uint256 _artistCommission);
178 
179   function updatePriceInWei(uint256 _editionNumber, uint256 _priceInWei) external;
180 }
181 
182 /**
183 * @title Artists self minting for KnownOrigin (KODA)
184 *
185 * Allows for the edition artists to mint there own assets and control the price of an edition
186 *
187 * https://www.knownorigin.io/
188 *
189 * BE ORIGINAL. BUY ORIGINAL.
190 */
191 contract ArtistEditionControls is Ownable, Pausable {
192   using SafeMath for uint256;
193 
194   // Interface into the KODA world
195   IKODAV2Controls public kodaAddress;
196 
197   event PriceChanged(
198     uint256 indexed _editionNumber,
199     address indexed _artist,
200     uint256 _priceInWei
201   );
202 
203   constructor(IKODAV2Controls _kodaAddress) public {
204     kodaAddress = _kodaAddress;
205   }
206 
207   /**
208    * @dev Ability to gift new NFTs to an address, from a KODA edition
209    * @dev Only callable from edition artists defined in KODA NFT contract
210    * @dev Only callable when contract is not paused
211    * @dev Reverts if edition is invalid
212    * @dev Reverts if edition is not active in KDOA NFT contract
213    */
214   function gift(address _receivingAddress, uint256 _editionNumber)
215   external
216   whenNotPaused
217   returns (uint256)
218   {
219     require(_receivingAddress != address(0), "Unable to send to zero address");
220 
221     address artistAccount;
222     uint256 artistCommission;
223     (artistAccount, artistCommission) = kodaAddress.artistCommission(_editionNumber);
224     require(msg.sender == artistAccount || msg.sender == owner, "Only from the edition artist account");
225 
226     bool isActive = kodaAddress.editionActive(_editionNumber);
227     require(isActive, "Only when edition is active");
228 
229     return kodaAddress.mint(_receivingAddress, _editionNumber);
230   }
231 
232   /**
233    * @dev Sets the price of the provided edition in the WEI
234    * @dev Only callable from edition artists defined in KODA NFT contract
235    * @dev Only callable when contract is not paused
236    * @dev Reverts if edition is invalid
237    * @dev Reverts if edition is not active in KDOA NFT contract
238    */
239   function updateEditionPrice(uint256 _editionNumber, uint256 _priceInWei)
240   external
241   whenNotPaused
242   returns (bool)
243   {
244     address artistAccount;
245     uint256 artistCommission;
246     (artistAccount, artistCommission) = kodaAddress.artistCommission(_editionNumber);
247     require(msg.sender == artistAccount || msg.sender == owner, "Only from the edition artist account");
248 
249     bool isActive = kodaAddress.editionActive(_editionNumber);
250     require(isActive, "Only when edition is active");
251 
252     kodaAddress.updatePriceInWei(_editionNumber, _priceInWei);
253 
254     emit PriceChanged(_editionNumber, msg.sender, _priceInWei);
255 
256     return true;
257   }
258 
259   /**
260    * @dev Sets the KODA address
261    * @dev Only callable from owner
262    */
263   function setKodavV2(IKODAV2Controls _kodaAddress) onlyOwner public {
264     kodaAddress = _kodaAddress;
265   }
266 }