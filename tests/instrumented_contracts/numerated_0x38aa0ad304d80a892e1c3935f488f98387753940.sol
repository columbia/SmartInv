1 pragma solidity 0.5.3;
2 
3 
4 
5 
6 
7 
8 
9 /**
10  * @title Ownable
11  * @dev The Ownable contract has an owner address, and provides basic authorization control
12  * functions, this simplifies the implementation of "user permissions".
13  */
14 contract Ownable {
15     address private _owner;
16 
17     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
18 
19     /**
20      * @dev The Ownable constructor sets the original `owner` of the contract to the sender
21      * account.
22      */
23     constructor () internal {
24         _owner = msg.sender;
25         emit OwnershipTransferred(address(0), _owner);
26     }
27 
28     /**
29      * @return the address of the owner.
30      */
31     function owner() public view returns (address) {
32         return _owner;
33     }
34 
35     /**
36      * @dev Throws if called by any account other than the owner.
37      */
38     modifier onlyOwner() {
39         require(isOwner());
40         _;
41     }
42 
43     /**
44      * @return true if `msg.sender` is the owner of the contract.
45      */
46     function isOwner() public view returns (bool) {
47         return msg.sender == _owner;
48     }
49 
50     /**
51      * @dev Allows the current owner to relinquish control of the contract.
52      * It will not be possible to call the functions with the `onlyOwner`
53      * modifier anymore.
54      * @notice Renouncing ownership will leave the contract without an owner,
55      * thereby removing any functionality that is only available to the owner.
56      */
57     function renounceOwnership() public onlyOwner {
58         emit OwnershipTransferred(_owner, address(0));
59         _owner = address(0);
60     }
61 
62     /**
63      * @dev Allows the current owner to transfer control of the contract to a newOwner.
64      * @param newOwner The address to transfer ownership to.
65      */
66     function transferOwnership(address newOwner) public onlyOwner {
67         _transferOwnership(newOwner);
68     }
69 
70     /**
71      * @dev Transfers control of the contract to a newOwner.
72      * @param newOwner The address to transfer ownership to.
73      */
74     function _transferOwnership(address newOwner) internal {
75         require(newOwner != address(0));
76         emit OwnershipTransferred(_owner, newOwner);
77         _owner = newOwner;
78     }
79 }
80 
81 
82 /**
83  * @title Secondary
84  * @dev A Secondary contract can only be used by its primary account (the one that created it)
85  */
86 contract OwnableSecondary is Ownable {
87   address private _primary;
88 
89   event PrimaryTransferred(
90     address recipient
91   );
92 
93   /**
94    * @dev Sets the primary account to the one that is creating the Secondary contract.
95    */
96   constructor() internal {
97     _primary = msg.sender;
98     emit PrimaryTransferred(_primary);
99   }
100 
101   /**
102    * @dev Reverts if called from any account other than the primary or the owner.
103    */
104    modifier onlyPrimaryOrOwner() {
105      require(msg.sender == _primary || msg.sender == owner(), "not the primary user nor the owner");
106      _;
107    }
108 
109    /**
110     * @dev Reverts if called from any account other than the primary.
111     */
112   modifier onlyPrimary() {
113     require(msg.sender == _primary, "not the primary user");
114     _;
115   }
116 
117   /**
118    * @return the address of the primary.
119    */
120   function primary() public view returns (address) {
121     return _primary;
122   }
123 
124   /**
125    * @dev Transfers contract to a new primary.
126    * @param recipient The address of new primary.
127    */
128   function transferPrimary(address recipient) public onlyOwner {
129     require(recipient != address(0), "new primary address is null");
130     _primary = recipient;
131     emit PrimaryTransferred(_primary);
132   }
133 }
134 
135 
136 contract StatementRegisteryInterface is OwnableSecondary {
137   /********************/
138   /** PUBLIC - WRITE **/
139   /********************/
140   function recordStatement(string calldata buildingPermitId, uint[] calldata statementDataLayout, bytes calldata statementData) external returns(bytes32);
141 
142   /*******************/
143   /** PUBLIC - READ **/
144   /*******************/
145   function statementIdsByBuildingPermit(string calldata id) external view returns(bytes32[] memory);
146 
147   function statementExists(bytes32 statementId) public view returns(bool);
148 
149   function getStatementString(bytes32 statementId, string memory key) public view returns(string memory);
150 
151   function getStatementPcId(bytes32 statementId) external view returns (string memory);
152 
153   function getStatementAcquisitionDate(bytes32 statementId) external view returns (string memory);
154 
155   function getStatementRecipient(bytes32 statementId) external view returns (string memory);
156 
157   function getStatementArchitect(bytes32 statementId) external view returns (string memory);
158 
159   function getStatementCityHall(bytes32 statementId) external view returns (string memory);
160 
161   function getStatementMaximumHeight(bytes32 statementId) external view returns (string memory);
162 
163   function getStatementDestination(bytes32 statementId) external view returns (string memory);
164 
165   function getStatementSiteArea(bytes32 statementId) external view returns (string memory);
166 
167   function getStatementBuildingArea(bytes32 statementId) external view returns (string memory);
168 
169   function getStatementNearImage(bytes32 statementId) external view returns(string memory);
170 
171   function getStatementFarImage(bytes32 statementId) external view returns(string memory);
172 
173   function getAllStatements() external view returns(bytes32[] memory);
174 }
175 
176 
177 
178 
179 
180 contract OwnablePausable is Ownable {
181 
182   event Paused();
183   event Unpaused();
184   bool private _paused;
185 
186   constructor() internal {
187     _paused = false;
188     emit Unpaused();
189   }
190 
191   /**
192    * @return true if the contract is paused, false otherwise.
193    */
194   function paused() public view returns (bool) {
195       return _paused;
196   }
197 
198   /**
199    * @dev Modifier to make a function callable only when the contract is not paused.
200    */
201   modifier whenNotPaused() {
202       require(!_paused);
203       _;
204   }
205 
206   /**
207    * @dev Modifier to make a function callable only when the contract is paused.
208    */
209   modifier whenPaused() {
210       require(_paused);
211       _;
212   }
213 
214   /**
215    * @dev called by the owner to pause, triggers stopped state
216    */
217   function pause() public onlyOwner whenNotPaused {
218       _paused = true;
219       emit Paused();
220   }
221 
222   /**
223    * @dev called by the owner to unpause, returns to normal state
224    */
225   function unpause() public onlyOwner whenPaused {
226       _paused = false;
227       emit Unpaused();
228   }
229 }
230 
231 
232 contract Controller is OwnablePausable {
233   StatementRegisteryInterface public registery;
234   uint public price = 0;
235   address payable private _wallet;
236   address private _serverSide;
237 
238   event LogEvent(string content);
239   event NewStatementEvent(string indexed buildingPermitId, bytes32 statementId);
240 
241   /********************/
242   /** PUBLIC - WRITE **/
243   /********************/
244   constructor(address registeryAddress, address payable walletAddr, address serverSideAddr) public {
245     require(registeryAddress != address(0), "null registery address");
246     require(walletAddr != address(0), "null wallet address");
247     require(serverSideAddr != address(0), "null server side address");
248 
249     registery = StatementRegisteryInterface(registeryAddress);
250     _wallet = walletAddr;
251     _serverSide = serverSideAddr;
252   }
253 
254   /* The price of the service offered by this smart contract is to be updated freely
255   by IMMIRIS. It is also updated on a daily basis by the server to reflect the current
256   EUR/ETH exchange rate */
257   function setPrice(uint priceInWei) external whenNotPaused {
258     require(msg.sender == owner() || msg.sender == _serverSide);
259 
260     price = priceInWei;
261   }
262 
263   function setWallet(address payable addr) external onlyOwner whenNotPaused {
264     require(addr != address(0), "null wallet address");
265 
266     _wallet = addr;
267   }
268 
269   function setServerSide(address payable addr) external onlyOwner whenNotPaused {
270     require(addr != address(0), "null server side address");
271 
272     _serverSide = addr;
273   }
274 
275   /* record a statement for a given price or for free if the request comes from the server.
276   builidngPermitId: the id of the building permit associated with this statement. More than one statement can be recorded for a given permit id
277   statementDataLayout: an array containing the length of each string packed in the bytes array, such as [string1Length, string2Length,...]
278   statementData: all the strings packed as bytes by the D-App in javascript */
279   function recordStatement(string calldata buildingPermitId, uint[] calldata statementDataLayout, bytes calldata statementData) external payable whenNotPaused returns(bytes32) {
280       if(msg.sender != owner() && msg.sender != _serverSide) {
281         require(msg.value >= price, "received insufficient value");
282 
283         uint refund = msg.value - price;
284 
285         _wallet.transfer(price); // ETH TRANSFER
286 
287         if(refund > 0) {
288           msg.sender.transfer(refund); // ETH TRANSFER
289         }
290       }
291 
292       bytes32 statementId = registery.recordStatement(
293         buildingPermitId,
294         statementDataLayout,
295         statementData
296       );
297 
298       emit NewStatementEvent(buildingPermitId, statementId);
299 
300       return statementId;
301   }
302 
303   /*******************/
304   /** PUBLIC - READ **/
305   /*******************/
306   function wallet() external view returns (address) {
307     return _wallet;
308   }
309 
310   function serverSide() external view returns (address) {
311     return _serverSide;
312   }
313 
314   function statementExists(bytes32 statementId) external view returns (bool) {
315     return registery.statementExists(statementId);
316   }
317 
318   function getStatementIdsByBuildingPermit(string calldata buildingPermitId) external view returns(bytes32[] memory) {
319     return registery.statementIdsByBuildingPermit(buildingPermitId);
320   }
321 
322   function getAllStatements() external view returns(bytes32[] memory) {
323     return registery.getAllStatements();
324   }
325 
326   function getStatementPcId(bytes32 statementId) external view returns (string memory) {
327     return registery.getStatementPcId(statementId);
328   }
329 
330   function getStatementAcquisitionDate(bytes32 statementId) external view returns (string memory) {
331     return registery.getStatementAcquisitionDate(statementId);
332   }
333 
334   function getStatementRecipient(bytes32 statementId) external view returns (string memory) {
335     return registery.getStatementRecipient(statementId);
336   }
337 
338   function getStatementArchitect(bytes32 statementId) external view returns (string memory) {
339     return registery.getStatementArchitect(statementId);
340   }
341 
342   function getStatementCityHall(bytes32 statementId) external view returns (string memory) {
343     return registery.getStatementCityHall(statementId);
344   }
345 
346   function getStatementMaximumHeight(bytes32 statementId) external view returns (string memory) {
347     return registery.getStatementMaximumHeight(statementId);
348   }
349 
350   function getStatementDestination(bytes32 statementId) external view returns (string memory) {
351     return registery.getStatementDestination(statementId);
352   }
353 
354   function getStatementSiteArea(bytes32 statementId) external view returns (string memory) {
355     return registery.getStatementSiteArea(statementId);
356   }
357 
358   function getStatementBuildingArea(bytes32 statementId) external view returns (string memory) {
359     return registery.getStatementBuildingArea(statementId);
360   }
361 
362   function getStatementNearImage(bytes32 statementId) external view returns(string memory) {
363     return registery.getStatementNearImage(statementId);
364   }
365 
366   function getStatementFarImage(bytes32 statementId) external view returns(string memory) {
367     return registery.getStatementFarImage(statementId);
368   }
369 }