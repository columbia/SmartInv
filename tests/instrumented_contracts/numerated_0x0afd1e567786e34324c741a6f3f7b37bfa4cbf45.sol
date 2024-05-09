1 pragma solidity ^0.4.25;
2 
3   /**
4     * @title SafeMath
5     * @dev Math operations with safety checks that throw on error
6     */
7     library SafeMath {
8     
9     /**
10     * @dev Multiplies two numbers, throws on overflow.
11     */
12     function mul(uint256 a, uint256 b) internal pure returns (uint256) {
13       if (a == 0) {
14         return 0;
15       }
16       uint256 c = a * b;
17       assert(c / a == b);
18       return c;
19     }
20     
21     /**
22     * @dev Integer division of two numbers, truncating the quotient.
23     */
24     function div(uint256 a, uint256 b) internal pure returns (uint256) {
25       // assert(b > 0); // Solidity automatically throws when dividing by 0
26       uint256 c = a / b;
27       // assert(a == b * c + a % b); // There is no case in which this doesn't hold
28       return c;
29     }
30     
31     /**
32     * @dev Substracts two numbers, throws on overflow (i.e. if subtrahend is greater than minuend).
33     */
34     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
35       assert(b <= a);
36       return a - b;
37     }
38     
39     /**
40     * @dev Adds two numbers, throws on overflow.
41     */
42     function add(uint256 a, uint256 b) internal pure returns (uint256) {
43       uint256 c = a + b;
44       assert(c >= a);
45       return c;
46     }
47 }
48     
49     
50     /// @title Interface for contracts conforming to ERC-721: Non-Fungible Tokens
51     /// @author Dieter Shirley <dete@axiomzen.co> (https://github.com/dete)
52     contract ERC721 {
53     function totalSupply() external view returns (uint256 total);
54     function balanceOf(address _owner) external view returns (uint256 balance);
55     function ownerOf(string _diamondId) public view returns (address owner);
56     function approve(address _to, string _diamondId) external;
57     function transfer(address _to, string _diamondId) external;
58     function transferFrom(address _from, address _to, string _diamondId) external;
59     
60     // Events
61     event Transfer(address indexed from, address indexed to, string indexed diamondId);
62     event Approval(address indexed owner, address indexed approved, string indexed diamondId);
63     }
64     
65     contract DiamondAccessControl {
66     
67     address public CEO;
68     
69     mapping (address => bool) public admins;
70     
71     bool public paused = false;
72     
73     modifier onlyCEO() {
74       require(msg.sender == CEO);
75       _;
76     }
77     
78     modifier onlyAdmin() {
79       require(admins[msg.sender]);
80       _;
81     }
82     
83     /*** Pausable functionality adapted from OpenZeppelin ***/
84     
85     /// @dev Modifier to allow actions only when the contract IS NOT paused
86     modifier whenNotPaused() {
87       require(!paused);
88       _;
89     }
90     
91     modifier onlyAdminOrCEO() 
92 {      require(admins[msg.sender] || msg.sender == CEO);
93       _;
94     }
95     
96     /// @dev Modifier to allow actions only when the contract IS paused
97     modifier whenPaused {
98       require(paused);
99       _;
100     }
101     
102     function setCEO(address _newCEO) external onlyCEO {
103       require(_newCEO != address(0));
104       CEO = _newCEO;
105     }
106     
107     function setAdmin(address _newAdmin, bool isAdmin) external onlyCEO {
108       require(_newAdmin != address(0));
109       admins[_newAdmin] = isAdmin;
110     }
111     
112     /// @dev Called by any "C-level" role to pause the contract. Used only when
113     ///  a bug or exploit is detected and we need to limit damage.
114     function pause() external onlyAdminOrCEO whenNotPaused {
115       paused = true;
116     }
117     
118     /// @dev Unpauses the smart contract. Can only be called by the CEO, since
119     ///  one reason we may pause the contract is when admin account are
120     ///  compromised.
121     /// @notice This is public rather than external so it can be called by
122     ///  derived contracts.
123     function unpause() external onlyCEO whenPaused {
124       // can't unpause if contract was upgraded
125       paused = false;
126     }
127 }
128     
129 /// @title Base contract for CryptoKitties. Holds all common structs, events and base variables.
130 /// @author Axiom Zen (https://www.axiomzen.co)
131 /// @dev See the KittyCore contract documentation to understand how the various contract facets are arranged.
132 contract DiamondBase is DiamondAccessControl {
133     
134     using SafeMath for uint256;
135 
136     event Transfer(address indexed from, address indexed to, string indexed diamondId);
137     event TransactionHistory(  
138       string indexed _diamondId, 
139       address indexed _seller, 
140       string _sellerId, 
141       address indexed _buyer, 
142       string _buyerId, 
143       uint256 _usdPrice, 
144       uint256 _cedexPrice,
145       uint256 timestamp
146     );
147     
148     /*** DATA TYPE ***/
149     /// @dev The main Kitty struct. Every dimond is represented by a copy of this structure
150     struct Diamond {
151       string ownerId;
152       string status;
153       string gemCompositeScore;
154       string gemSubcategory;
155       string media;
156       string custodian;
157       uint256 arrivalTime;
158     }
159     
160     // variable to store total amount of diamonds
161     uint256 internal total;
162     
163     // Mapping for checking the existence of token with such diamond ID
164     mapping(string => bool) internal diamondExists;
165     
166     // Mapping from adress to number of diamonds owned by this address
167     mapping(address => uint) internal balances;
168     
169     // Mapping from diamond ID to owner address
170     mapping (string => address) internal diamondIdToOwner;
171     
172     // Mapping from diamond ID to metadata
173     mapping(string => Diamond) internal diamondIdToMetadata;
174     
175     // Mapping from diamond ID to an address that has been approved to call transferFrom()
176     mapping(string => address) internal diamondIdToApproved;
177     
178     //Status Constants
179     string constant STATUS_PENDING = "Pending";
180     string constant STATUS_VERIFIED = "Verified";
181     string constant STATUS_OUTSIDE  = "Outside";
182 
183     function _createDiamond(
184       string _diamondId, 
185       address _owner, 
186       string _ownerId, 
187       string _gemCompositeScore, 
188       string _gemSubcategory, 
189       string _media
190     )  
191       internal 
192     {
193       Diamond memory diamond;
194       
195       diamond.status = "Pending";
196       diamond.ownerId = _ownerId;
197       diamond.gemCompositeScore = _gemCompositeScore;
198       diamond.gemSubcategory = _gemSubcategory;
199       diamond.media = _media;
200       
201       diamondIdToMetadata[_diamondId] = diamond;
202     
203       _transfer(address(0), _owner, _diamondId);
204       total = total.add(1);
205       diamondExists[_diamondId] = true; 
206     }
207     
208     function _transferInternal(
209       string _diamondId, 
210       address _seller, 
211       string _sellerId, 
212       address _buyer, 
213       string _buyerId, 
214       uint256 _usdPrice, 
215       uint256 _cedexPrice
216     )   
217       internal 
218     {
219       Diamond storage diamond = diamondIdToMetadata[_diamondId];
220       diamond.ownerId = _buyerId;
221       _transfer(_seller, _buyer, _diamondId);   
222       emit TransactionHistory(_diamondId, _seller, _sellerId, _buyer, _buyerId, _usdPrice, _cedexPrice, now);
223     
224     }
225     
226     function _transfer(address _from, address _to, string _diamondId) internal {
227       if (_from != address(0)) {
228           balances[_from] = balances[_from].sub(1);
229       }
230       balances[_to] = balances[_to].add(1);
231       diamondIdToOwner[_diamondId] = _to;
232       delete diamondIdToApproved[_diamondId];
233       emit Transfer(_from, _to, _diamondId);
234     }
235     
236     function _burn(string _diamondId) internal {
237       address _from = diamondIdToOwner[_diamondId];
238       balances[_from] = balances[_from].sub(1);
239       total = total.sub(1);
240       delete diamondIdToOwner[_diamondId];
241       delete diamondIdToMetadata[_diamondId];
242       delete diamondExists[_diamondId];
243       delete diamondIdToApproved[_diamondId];
244       emit Transfer(_from, address(0), _diamondId);
245     }
246     
247     function _isDiamondOutside(string _diamondId) internal view returns (bool) {
248       require(diamondExists[_diamondId]);
249       return keccak256(diamondIdToMetadata[_diamondId].status) == keccak256(STATUS_OUTSIDE);
250     }
251     
252     function _isDiamondVerified(string _diamondId) internal view returns (bool) {
253       require(diamondExists[_diamondId]);
254       return keccak256(diamondIdToMetadata[_diamondId].status) == keccak256(STATUS_VERIFIED);
255     }
256 }
257     
258 /// @title The ontract that manages ownership, ERC-721 (draft) compliant.
259 contract DiamondBase721 is DiamondBase, ERC721 {
260     
261     function totalSupply() external view returns (uint256) {
262       return total;
263     }
264     
265     /**
266     * @dev Gets the balance of the specified address
267     * @param _owner address to query the balance of
268     * @return uint256 representing the amount owned by the passed address
269     */
270     function balanceOf(address _owner) external view returns (uint256) {
271       return balances[_owner];
272     
273     }
274     
275     /**
276     * @dev Gets the owner of the specified diamond ID
277     * @param _diamondId string ID of the diamond to query the owner of
278     * @return owner address currently marked as the owner of the given diamond ID
279     */
280     function ownerOf(string _diamondId) public view returns (address) {
281       require(diamondExists[_diamondId]);
282       return diamondIdToOwner[_diamondId];
283     }
284     
285     function approve(address _to, string _diamondId) external whenNotPaused {
286       require(_isDiamondOutside(_diamondId));
287       require(msg.sender == ownerOf(_diamondId));
288       diamondIdToApproved[_diamondId] = _to;
289       emit Approval(msg.sender, _to, _diamondId);
290     }
291     
292     /**
293     * @dev Transfers the ownership of a given diamond ID to another address
294     * @param _to address to receive the ownership of the given diamond ID
295     * @param _diamondId uint256 ID of the diamond to be transferred
296     */
297     function transfer(address _to, string _diamondId) external whenNotPaused {
298       require(_isDiamondOutside(_diamondId));
299       require(msg.sender == ownerOf(_diamondId));
300       require(_to != address(0));
301       require(_to != address(this));
302       require(_to != ownerOf(_diamondId));
303       _transfer(msg.sender, _to, _diamondId);
304     }
305     
306     function transferFrom(address _from, address _to,  string _diamondId)
307       external 
308       whenNotPaused 
309     {
310       require(_isDiamondOutside(_diamondId));
311       require(_from == ownerOf(_diamondId));
312       require(_to != address(0));
313       require(_to != address(this));
314       require(_to != ownerOf(_diamondId));
315       require(diamondIdToApproved[_diamondId] == msg.sender);
316       _transfer(_from, _to, _diamondId);
317     }
318     
319 }
320     
321 /// @dev The main contract, keeps track of diamonds.
322 contract DiamondCore is DiamondBase721 {
323 
324     /// @notice Creates the main Diamond smart contract instance.
325     constructor() public {
326       // the creator of the contract is the initial CEO
327       CEO = msg.sender;
328     }
329     
330     function createDiamond(
331       string _diamondId, 
332       address _owner, 
333       string _ownerId, 
334       string _gemCompositeScore, 
335       string _gemSubcategory, 
336       string _media
337     ) 
338       external 
339       onlyAdminOrCEO 
340       whenNotPaused 
341     {
342       require(!diamondExists[_diamondId]);
343       require(_owner != address(0));
344       require(_owner != address(this));
345       _createDiamond( 
346           _diamondId, 
347           _owner, 
348           _ownerId, 
349           _gemCompositeScore, 
350           _gemSubcategory, 
351           _media
352       );
353     }
354     
355     function updateDiamond(
356       string _diamondId, 
357       string _custodian, 
358       uint256 _arrivalTime
359     ) 
360       external 
361       onlyAdminOrCEO 
362       whenNotPaused 
363     {
364       require(!_isDiamondOutside(_diamondId));
365       
366       Diamond storage diamond = diamondIdToMetadata[_diamondId];
367       
368       diamond.status = "Verified";
369       diamond.custodian = _custodian;
370       diamond.arrivalTime = _arrivalTime;
371     }
372     
373     function transferInternal(
374       string _diamondId, 
375       address _seller, 
376       string _sellerId, 
377       address _buyer, 
378       string _buyerId, 
379       uint256 _usdPrice, 
380       uint256 _cedexPrice
381     ) 
382       external 
383       onlyAdminOrCEO                                                                                                                                                                                                                                              
384       whenNotPaused 
385     {
386       require(_isDiamondVerified(_diamondId));
387       require(_seller == ownerOf(_diamondId));
388       require(_buyer != address(0));
389       require(_buyer != address(this));
390       require(_buyer != ownerOf(_diamondId));
391       _transferInternal(_diamondId, _seller, _sellerId, _buyer, _buyerId, _usdPrice, _cedexPrice);
392     }
393     
394     function burn(string _diamondId) external onlyAdminOrCEO whenNotPaused {
395       require(!_isDiamondOutside(_diamondId));
396       _burn(_diamondId);
397     }
398     
399     function getDiamond(string _diamondId) 
400         external
401         view
402         returns(
403             string ownerId,
404             string status,
405             string gemCompositeScore,
406             string gemSubcategory,
407             string media,
408             string custodian,
409             uint256 arrivalTime
410         )
411     {
412         require(diamondExists[_diamondId]);
413         
414          ownerId = diamondIdToMetadata[_diamondId].ownerId;
415          status = diamondIdToMetadata[_diamondId].status;
416          gemCompositeScore = diamondIdToMetadata[_diamondId].gemCompositeScore;
417          gemSubcategory = diamondIdToMetadata[_diamondId].gemSubcategory;
418          media = diamondIdToMetadata[_diamondId].media;
419          custodian = diamondIdToMetadata[_diamondId].custodian;
420          arrivalTime = diamondIdToMetadata[_diamondId].arrivalTime;
421     }
422 }