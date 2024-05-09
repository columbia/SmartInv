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
173 // File: contracts/v2/artist-controls/ArtistEditionBurner.sol
174 
175 pragma solidity 0.4.24;
176 
177 
178 
179 
180 interface IKODAV2ArtistBurner {
181   function editionActive(uint256 _editionNumber) external view returns (bool);
182 
183   function artistCommission(uint256 _editionNumber) external view returns (address _artistAccount, uint256 _artistCommission);
184 
185   function updateActive(uint256 _editionNumber, bool _active) external;
186 
187   function totalSupplyEdition(uint256 _editionNumber) external view returns (uint256);
188 
189   function totalRemaining(uint256 _editionNumber) external view returns (uint256);
190 
191   function updateTotalAvailable(uint256 _editionNumber, uint256 _totalAvailable) external;
192 }
193 
194 /**
195 * @title Artists burning contract for KnownOrigin (KODA)
196 *
197 * Allows for edition artists to burn unsold works or reduce the supply of sold tokens from editions
198 *
199 * https://www.knownorigin.io/
200 *
201 * BE ORIGINAL. BUY ORIGINAL.
202 */
203 contract ArtistEditionBurner is Ownable, Pausable {
204   using SafeMath for uint256;
205 
206   // Interface into the KODA world
207   IKODAV2ArtistBurner public kodaAddress;
208 
209   event EditionDeactivated(
210     uint256 indexed _editionNumber
211   );
212 
213   event EditionSupplyReduced(
214     uint256 indexed _editionNumber
215   );
216 
217   constructor(IKODAV2ArtistBurner _kodaAddress) public {
218     kodaAddress = _kodaAddress;
219   }
220 
221   /**
222    * @dev Sets the provided edition to either a deactivated state or reduces the available supply to zero
223    * @dev Only callable from edition artists defined in KODA NFT contract
224    * @dev Only callable when contract is not paused
225    * @dev Reverts if edition is invalid
226    * @dev Reverts if edition is not active in KDOA NFT contract
227    */
228   function deactivateOrReduceEditionSupply(uint256 _editionNumber) external whenNotPaused {
229     (address artistAccount, uint256 _) = kodaAddress.artistCommission(_editionNumber);
230     require(msg.sender == artistAccount || msg.sender == owner, "Only from the edition artist account");
231 
232     // only allow them to be disabled if we have not already done it already
233     bool isActive = kodaAddress.editionActive(_editionNumber);
234     require(isActive, "Only when edition is active");
235 
236     // only allow changes if not sold out
237     uint256 totalRemaining = kodaAddress.totalRemaining(_editionNumber);
238     require(totalRemaining > 0, "Only when edition not sold out");
239 
240     // total issued so far
241     uint256 totalSupply = kodaAddress.totalSupplyEdition(_editionNumber);
242 
243     // if no tokens issued, simply disable the edition, burn it!
244     if (totalSupply == 0) {
245       kodaAddress.updateActive(_editionNumber, false);
246       kodaAddress.updateTotalAvailable(_editionNumber, 0);
247       emit EditionDeactivated(_editionNumber);
248     }
249     // if some tokens issued, reduce ths supply so that no more can be issued
250     else {
251       kodaAddress.updateTotalAvailable(_editionNumber, totalSupply);
252       emit EditionSupplyReduced(_editionNumber);
253     }
254   }
255 
256   /**
257    * @dev Sets the KODA address
258    * @dev Only callable from owner
259    */
260   function setKodavV2(IKODAV2ArtistBurner _kodaAddress) onlyOwner public {
261     kodaAddress = _kodaAddress;
262   }
263 
264 }