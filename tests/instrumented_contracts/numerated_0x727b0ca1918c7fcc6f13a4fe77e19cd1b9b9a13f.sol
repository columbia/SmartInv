1 pragma solidity ^0.4.25;
2 
3   /**
4  * @title SafeMath
5  * @dev Math operations with safety checks that revert on error
6  */
7 library SafeMath {
8 
9   /**
10   * @dev Multiplies two numbers, reverts on overflow.
11   */
12   function mul(uint256 a, uint256 b) internal pure returns (uint256) {
13     // Gas optimization: this is cheaper than requiring 'a' not being zero, but the
14     // benefit is lost if 'b' is also tested.
15     // See: https://github.com/OpenZeppelin/openzeppelin-solidity/pull/522
16     if (a == 0) {
17       return 0;
18     }
19 
20     uint256 c = a * b;
21     require(c / a == b);
22 
23     return c;
24   }
25 
26   /**
27   * @dev Integer division of two numbers truncating the quotient, reverts on division by zero.
28   */
29   function div(uint256 a, uint256 b) internal pure returns (uint256) {
30     require(b > 0); // Solidity only automatically asserts when dividing by 0
31     uint256 c = a / b;
32     // assert(a == b * c + a % b); // There is no case in which this doesn't hold
33 
34     return c;
35   }
36 
37   /**
38   * @dev Subtracts two numbers, reverts on overflow (i.e. if subtrahend is greater than minuend).
39   */
40   function sub(uint256 a, uint256 b) internal pure returns (uint256) {
41     require(b <= a);
42     uint256 c = a - b;
43 
44     return c;
45   }
46 
47   /**
48   * @dev Adds two numbers, reverts on overflow.
49   */
50   function add(uint256 a, uint256 b) internal pure returns (uint256) {
51     uint256 c = a + b;
52     require(c >= a);
53 
54     return c;
55   }
56 
57   /**
58   * @dev Divides two numbers and returns the remainder (unsigned integer modulo),
59   * reverts when dividing by zero.
60   */
61   function mod(uint256 a, uint256 b) internal pure returns (uint256) {
62     require(b != 0);
63     return a % b;
64   }
65 }
66     
67     
68     /// @title Interface for contracts conforming to ERC-721: Non-Fungible Tokens
69     /// @author Dieter Shirley <dete@axiomzen.co> (https://github.com/dete)
70     contract ERC721 {
71     function totalSupply() external view returns (uint256 total);
72     function balanceOf(address _owner) external view returns (uint256 balance);
73     function ownerOf(string _diamondId) public view returns (address owner);
74     function approve(address _to, string _diamondId) external;
75     function transfer(address _to, string _diamondId) external;
76     function transferFrom(address _from, address _to, string _diamondId) external;
77     
78     // Events
79     event Transfer(address indexed from, address indexed to, string indexed diamondId);
80     event Approval(address indexed owner, address indexed approved, string indexed diamondId);
81     }
82     
83     contract DiamondAccessControl {
84     
85     address public CEO;
86     
87     mapping (address => bool) public admins;
88     
89     bool public paused = false;
90     
91     modifier onlyCEO() {
92       require(msg.sender == CEO);
93       _;
94     }
95     
96     modifier onlyAdmin() {
97       require(admins[msg.sender]);
98       _;
99     }
100     
101     /*** Pausable functionality adapted from OpenZeppelin ***/
102     
103     /// @dev Modifier to allow actions only when the contract IS NOT paused
104     modifier whenNotPaused() {
105       require(!paused);
106       _;
107     }
108     
109     modifier onlyAdminOrCEO() 
110 {      require(admins[msg.sender] || msg.sender == CEO);
111       _;
112     }
113     
114     /// @dev Modifier to allow actions only when the contract IS paused
115     modifier whenPaused {
116       require(paused);
117       _;
118     }
119     
120     function setCEO(address _newCEO) external onlyCEO {
121       require(_newCEO != address(0));
122       CEO = _newCEO;
123     }
124     
125     function setAdmin(address _newAdmin, bool isAdmin) external onlyCEO {
126       require(_newAdmin != address(0));
127       admins[_newAdmin] = isAdmin;
128     }
129     
130     /// @dev Called by any "C-level" role to pause the contract. Used only when
131     ///  a bug or exploit is detected and we need to limit damage.
132     function pause() external onlyAdminOrCEO whenNotPaused {
133       paused = true;
134     }
135     
136     /// @dev Unpauses the smart contract. Can only be called by the CEO, since
137     ///  one reason we may pause the contract is when admin account are
138     ///  compromised.
139     /// @notice This is public rather than external so it can be called by
140     ///  derived contracts.
141     function unpause() external onlyCEO whenPaused {
142       // can't unpause if contract was upgraded
143       paused = false;
144     }
145 }
146     
147 /// @title Base contract for CryptoDiamond. Holds all common structs, events and base variables.
148 contract DiamondBase is DiamondAccessControl {
149     
150     using SafeMath for uint256;
151 
152     event Transfer(address indexed from, address indexed to, string indexed diamondId);
153     event TransactionHistory(  
154       string indexed _diamondId, 
155       address indexed _seller, 
156       string _sellerId, 
157       address indexed _buyer, 
158       string _buyerId, 
159       uint256 _usdPrice, 
160       uint256 _cedexPrice,
161       uint256 timestamp
162     );
163     
164     /*** DATA TYPE ***/
165     /// @dev The main Diamond struct. Every dimond is represented by a copy of this structure
166     struct Diamond {
167       string ownerId;
168       string status;
169       string gemCompositeScore;
170       string gemSubcategory;
171       string media;
172       string custodian;
173       uint256 arrivalTime;
174     }
175     
176     // variable to store total amount of diamonds
177     uint256 internal total;
178     
179     // Mapping for checking the existence of token with such diamond ID
180     mapping(string => bool) internal diamondExists;
181     
182     // Mapping from adress to number of diamonds owned by this address
183     mapping(address => uint256) internal balances;
184     
185     // Mapping from diamond ID to owner address
186     mapping (string => address) internal diamondIdToOwner;
187     
188     // Mapping from diamond ID to metadata
189     mapping(string => Diamond) internal diamondIdToMetadata;
190     
191     // Mapping from diamond ID to an address that has been approved to call transferFrom()
192     mapping(string => address) internal diamondIdToApproved;
193     
194     //Status Constants
195     string constant STATUS_PENDING = "Pending";
196     string constant STATUS_VERIFIED = "Verified";
197     string constant STATUS_OUTSIDE  = "Outside";
198 
199     function _createDiamond(
200       string _diamondId, 
201       address _owner, 
202       string _ownerId, 
203       string _gemCompositeScore, 
204       string _gemSubcategory, 
205       string _media
206     )  
207       internal 
208     {
209       Diamond memory diamond;
210       
211       diamond.status = "Pending";
212       diamond.ownerId = _ownerId;
213       diamond.gemCompositeScore = _gemCompositeScore;
214       diamond.gemSubcategory = _gemSubcategory;
215       diamond.media = _media;
216       
217       diamondIdToMetadata[_diamondId] = diamond;
218 
219       total = total.add(1); 
220       diamondExists[_diamondId] = true;
221     
222       _transfer(address(0), _owner, _diamondId); 
223     }
224     
225     function _transferInternal(
226       string _diamondId, 
227       address _seller, 
228       string _sellerId, 
229       address _buyer, 
230       string _buyerId, 
231       uint256 _usdPrice, 
232       uint256 _cedexPrice
233     )   
234       internal 
235     {
236       Diamond storage diamond = diamondIdToMetadata[_diamondId];
237       diamond.ownerId = _buyerId;
238       _transfer(_seller, _buyer, _diamondId);   
239       emit TransactionHistory(_diamondId, _seller, _sellerId, _buyer, _buyerId, _usdPrice, _cedexPrice, now);
240     
241     }
242     
243     function _transfer(address _from, address _to, string _diamondId) internal {
244       if (_from != address(0)) {
245           balances[_from] = balances[_from].sub(1);
246       }
247       balances[_to] = balances[_to].add(1);
248       diamondIdToOwner[_diamondId] = _to;
249       delete diamondIdToApproved[_diamondId];
250       emit Transfer(_from, _to, _diamondId);
251     }
252     
253     function _burn(string _diamondId) internal {
254       address _from = diamondIdToOwner[_diamondId];
255       balances[_from] = balances[_from].sub(1);
256       total = total.sub(1);
257       delete diamondIdToOwner[_diamondId];
258       delete diamondIdToMetadata[_diamondId];
259       delete diamondExists[_diamondId];
260       delete diamondIdToApproved[_diamondId];
261       emit Transfer(_from, address(0), _diamondId);
262     }
263     
264     function _isDiamondOutside(string _diamondId) internal view returns (bool) {
265       require(diamondExists[_diamondId]);
266       return keccak256(abi.encodePacked(diamondIdToMetadata[_diamondId].status)) == keccak256(abi.encodePacked(STATUS_OUTSIDE));
267     }
268     
269     function _isDiamondVerified(string _diamondId) internal view returns (bool) {
270       require(diamondExists[_diamondId]);
271       return keccak256(abi.encodePacked(diamondIdToMetadata[_diamondId].status)) == keccak256(abi.encodePacked(STATUS_VERIFIED));
272     }
273 }
274     
275 /// @title The ontract that manages ownership, ERC-721 (draft) compliant.
276 contract DiamondBase721 is DiamondBase, ERC721 {
277     
278     function totalSupply() external view returns (uint256) {
279       return total;
280     }
281     
282     /**
283     * @dev Gets the balance of the specified address
284     * @param _owner address to query the balance of
285     * @return uint256 representing the amount owned by the passed address
286     */
287     function balanceOf(address _owner) external view returns (uint256) {
288       return balances[_owner];
289     
290     }
291     
292     /**
293     * @dev Gets the owner of the specified diamond ID
294     * @param _diamondId string ID of the diamond to query the owner of
295     * @return owner address currently marked as the owner of the given diamond ID
296     */
297     function ownerOf(string _diamondId) public view returns (address) {
298       require(diamondExists[_diamondId]);
299       return diamondIdToOwner[_diamondId];
300     }
301     
302     function approve(address _to, string _diamondId) external whenNotPaused {
303       require(_isDiamondOutside(_diamondId));
304       require(msg.sender == ownerOf(_diamondId));
305       diamondIdToApproved[_diamondId] = _to;
306       emit Approval(msg.sender, _to, _diamondId);
307     }
308     
309     /**
310     * @dev Transfers the ownership of a given diamond ID to another address
311     * @param _to address to receive the ownership of the given diamond ID
312     * @param _diamondId uint256 ID of the diamond to be transferred
313     */
314     function transfer(address _to, string _diamondId) external whenNotPaused {
315       require(_isDiamondOutside(_diamondId));
316       require(msg.sender == ownerOf(_diamondId));
317       require(_to != address(0));
318       require(_to != address(this));
319       require(_to != ownerOf(_diamondId));
320       _transfer(msg.sender, _to, _diamondId);
321     }
322     
323     function transferFrom(address _from, address _to,  string _diamondId)
324       external 
325       whenNotPaused 
326     {
327       require(_isDiamondOutside(_diamondId));
328       require(_from == ownerOf(_diamondId));
329       require(_to != address(0));
330       require(_to != address(this));
331       require(_to != ownerOf(_diamondId));
332       require(diamondIdToApproved[_diamondId] == msg.sender);
333       _transfer(_from, _to, _diamondId);
334     }
335     
336 }
337     
338 /// @dev The main contract, keeps track of diamonds.
339 contract DiamondCore is DiamondBase721 {
340 
341     /// @notice Creates the main Diamond smart contract instance.
342     constructor() public {
343       // the creator of the contract is the initial CEO
344       CEO = msg.sender;
345     }
346     
347     function createDiamond(
348       string _diamondId, 
349       address _owner, 
350       string _ownerId, 
351       string _gemCompositeScore, 
352       string _gemSubcategory, 
353       string _media
354     ) 
355       external 
356       onlyAdminOrCEO 
357       whenNotPaused 
358     {
359       require(!diamondExists[_diamondId]);
360       require(_owner != address(0));
361       require(_owner != address(this));
362       _createDiamond( 
363           _diamondId, 
364           _owner, 
365           _ownerId, 
366           _gemCompositeScore, 
367           _gemSubcategory, 
368           _media
369       );
370     }
371     
372     function updateDiamond(
373       string _diamondId, 
374       string _custodian, 
375       uint256 _arrivalTime
376     ) 
377       external 
378       onlyAdminOrCEO 
379       whenNotPaused 
380     {
381       require(!_isDiamondOutside(_diamondId));
382       
383       Diamond storage diamond = diamondIdToMetadata[_diamondId];
384       
385       diamond.status = "Verified";
386       diamond.custodian = _custodian;
387       diamond.arrivalTime = _arrivalTime;
388     }
389     
390     function transferInternal(
391       string _diamondId, 
392       address _seller, 
393       string _sellerId, 
394       address _buyer, 
395       string _buyerId, 
396       uint256 _usdPrice, 
397       uint256 _cedexPrice
398     ) 
399       external 
400       onlyAdminOrCEO                                                                                                                                                                                                                                              
401       whenNotPaused 
402     {
403       require(_isDiamondVerified(_diamondId));
404       require(_seller == ownerOf(_diamondId));
405       require(_buyer != address(0));
406       require(_buyer != address(this));
407       require(_buyer != ownerOf(_diamondId));
408       _transferInternal(_diamondId, _seller, _sellerId, _buyer, _buyerId, _usdPrice, _cedexPrice);
409     }
410     
411     function burn(string _diamondId) external onlyAdminOrCEO whenNotPaused {
412       require(!_isDiamondOutside(_diamondId));
413       _burn(_diamondId);
414     }
415     
416     function getDiamond(string _diamondId) 
417         external
418         view
419         returns(
420             string ownerId,
421             string status,
422             string gemCompositeScore,
423             string gemSubcategory,
424             string media,
425             string custodian,
426             uint256 arrivalTime
427         )
428     {
429         require(diamondExists[_diamondId]);
430         
431          ownerId = diamondIdToMetadata[_diamondId].ownerId;
432          status = diamondIdToMetadata[_diamondId].status;
433          gemCompositeScore = diamondIdToMetadata[_diamondId].gemCompositeScore;
434          gemSubcategory = diamondIdToMetadata[_diamondId].gemSubcategory;
435          media = diamondIdToMetadata[_diamondId].media;
436          custodian = diamondIdToMetadata[_diamondId].custodian;
437          arrivalTime = diamondIdToMetadata[_diamondId].arrivalTime;
438     }
439 }