1 pragma solidity 0.4.25;
2 
3 // File: openzeppelin-solidity-v1.12.0/contracts/ownership/Ownable.sol
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
67 // File: openzeppelin-solidity-v1.12.0/contracts/ownership/Claimable.sol
68 
69 /**
70  * @title Claimable
71  * @dev Extension for the Ownable contract, where the ownership needs to be claimed.
72  * This allows the new owner to accept the transfer.
73  */
74 contract Claimable is Ownable {
75   address public pendingOwner;
76 
77   /**
78    * @dev Modifier throws if called by any account other than the pendingOwner.
79    */
80   modifier onlyPendingOwner() {
81     require(msg.sender == pendingOwner);
82     _;
83   }
84 
85   /**
86    * @dev Allows the current owner to set the pendingOwner address.
87    * @param newOwner The address to transfer ownership to.
88    */
89   function transferOwnership(address newOwner) public onlyOwner {
90     pendingOwner = newOwner;
91   }
92 
93   /**
94    * @dev Allows the pendingOwner address to finalize the transfer.
95    */
96   function claimOwnership() public onlyPendingOwner {
97     emit OwnershipTransferred(owner, pendingOwner);
98     owner = pendingOwner;
99     pendingOwner = address(0);
100   }
101 }
102 
103 // File: contracts/utils/Adminable.sol
104 
105 /**
106  * @title Adminable.
107  */
108 contract Adminable is Claimable {
109     address[] public adminArray;
110 
111     struct AdminInfo {
112         bool valid;
113         uint256 index;
114     }
115 
116     mapping(address => AdminInfo) public adminTable;
117 
118     event AdminAccepted(address indexed _admin);
119     event AdminRejected(address indexed _admin);
120 
121     /**
122      * @dev Reverts if called by any account other than one of the administrators.
123      */
124     modifier onlyAdmin() {
125         require(adminTable[msg.sender].valid, "caller is illegal");
126         _;
127     }
128 
129     /**
130      * @dev Accept a new administrator.
131      * @param _admin The administrator's address.
132      */
133     function accept(address _admin) external onlyOwner {
134         require(_admin != address(0), "administrator is illegal");
135         AdminInfo storage adminInfo = adminTable[_admin];
136         require(!adminInfo.valid, "administrator is already accepted");
137         adminInfo.valid = true;
138         adminInfo.index = adminArray.length;
139         adminArray.push(_admin);
140         emit AdminAccepted(_admin);
141     }
142 
143     /**
144      * @dev Reject an existing administrator.
145      * @param _admin The administrator's address.
146      */
147     function reject(address _admin) external onlyOwner {
148         AdminInfo storage adminInfo = adminTable[_admin];
149         require(adminArray.length > adminInfo.index, "administrator is already rejected");
150         require(_admin == adminArray[adminInfo.index], "administrator is already rejected");
151         // at this point we know that adminArray.length > adminInfo.index >= 0
152         address lastAdmin = adminArray[adminArray.length - 1]; // will never underflow
153         adminTable[lastAdmin].index = adminInfo.index;
154         adminArray[adminInfo.index] = lastAdmin;
155         adminArray.length -= 1; // will never underflow
156         delete adminTable[_admin];
157         emit AdminRejected(_admin);
158     }
159 
160     /**
161      * @dev Get an array of all the administrators.
162      * @return An array of all the administrators.
163      */
164     function getAdminArray() external view returns (address[] memory) {
165         return adminArray;
166     }
167 
168     /**
169      * @dev Get the total number of administrators.
170      * @return The total number of administrators.
171      */
172     function getAdminCount() external view returns (uint256) {
173         return adminArray.length;
174     }
175 }
176 
177 // File: contracts/authorization/interfaces/IAuthorizationDataSource.sol
178 
179 /**
180  * @title Authorization Data Source Interface.
181  */
182 interface IAuthorizationDataSource {
183     /**
184      * @dev Get the authorized action-role of a wallet.
185      * @param _wallet The address of the wallet.
186      * @return The authorized action-role of the wallet.
187      */
188     function getAuthorizedActionRole(address _wallet) external view returns (bool, uint256);
189 
190     /**
191      * @dev Get the authorized action-role and trade-class of a wallet.
192      * @param _wallet The address of the wallet.
193      * @return The authorized action-role and class of the wallet.
194      */
195     function getAuthorizedActionRoleAndClass(address _wallet) external view returns (bool, uint256, uint256);
196 
197     /**
198      * @dev Get all the trade-limits and trade-class of a wallet.
199      * @param _wallet The address of the wallet.
200      * @return The trade-limits and trade-class of the wallet.
201      */
202     function getTradeLimitsAndClass(address _wallet) external view returns (uint256, uint256, uint256);
203 
204 
205     /**
206      * @dev Get the buy trade-limit and trade-class of a wallet.
207      * @param _wallet The address of the wallet.
208      * @return The buy trade-limit and trade-class of the wallet.
209      */
210     function getBuyTradeLimitAndClass(address _wallet) external view returns (uint256, uint256);
211 
212     /**
213      * @dev Get the sell trade-limit and trade-class of a wallet.
214      * @param _wallet The address of the wallet.
215      * @return The sell trade-limit and trade-class of the wallet.
216      */
217     function getSellTradeLimitAndClass(address _wallet) external view returns (uint256, uint256);
218 }
219 
220 // File: contracts/authorization/AuthorizationDataSource.sol
221 
222 /**
223  * Details of usage of licenced software see here: https://www.saga.org/software/readme_v1
224  */
225 
226 /**
227  * @title Authorization Data Source.
228  */
229 contract AuthorizationDataSource is IAuthorizationDataSource, Adminable {
230     string public constant VERSION = "2.0.0";
231 
232     uint256 public walletCount;
233 
234     struct WalletInfo {
235         uint256 sequenceNum;
236         bool isWhitelisted;
237         uint256 actionRole;
238         uint256 buyLimit;
239         uint256 sellLimit;
240         uint256 tradeClass;
241     }
242 
243     mapping(address => WalletInfo) public walletTable;
244 
245     event WalletSaved(address indexed _wallet);
246     event WalletDeleted(address indexed _wallet);
247     event WalletNotSaved(address indexed _wallet);
248     event WalletNotDeleted(address indexed _wallet);
249 
250     /**
251      * @dev Get the authorized action-role of a wallet.
252      * @param _wallet The address of the wallet.
253      * @return The authorized action-role of the wallet.
254      */
255     function getAuthorizedActionRole(address _wallet) external view returns (bool, uint256) {
256         WalletInfo storage walletInfo = walletTable[_wallet];
257         return (walletInfo.isWhitelisted, walletInfo.actionRole);
258     }
259 
260     /**
261      * @dev Get the authorized action-role and trade-class of a wallet.
262      * @param _wallet The address of the wallet.
263      * @return The authorized action-role and class of the wallet.
264      */
265     function getAuthorizedActionRoleAndClass(address _wallet) external view returns (bool, uint256, uint256) {
266         WalletInfo storage walletInfo = walletTable[_wallet];
267         return (walletInfo.isWhitelisted, walletInfo.actionRole, walletInfo.tradeClass);
268     }
269 
270     /**
271      * @dev Get all the trade-limits and trade-class of a wallet.
272      * @param _wallet The address of the wallet.
273      * @return The trade-limits and trade-class of the wallet.
274      */
275     function getTradeLimitsAndClass(address _wallet) external view returns (uint256, uint256, uint256) {
276         WalletInfo storage walletInfo = walletTable[_wallet];
277         return (walletInfo.buyLimit, walletInfo.sellLimit, walletInfo.tradeClass);
278     }
279 
280     /**
281      * @dev Get the buy trade-limit and trade-class of a wallet.
282      * @param _wallet The address of the wallet.
283      * @return The buy trade-limit and trade-class of the wallet.
284      */
285     function getBuyTradeLimitAndClass(address _wallet) external view returns (uint256, uint256) {
286         WalletInfo storage walletInfo = walletTable[_wallet];
287         return (walletInfo.buyLimit, walletInfo.tradeClass);
288     }
289 
290     /**
291      * @dev Get the sell trade-limit and trade-class of a wallet.
292      * @param _wallet The address of the wallet.
293      * @return The sell trade-limit and trade-class of the wallet.
294      */
295     function getSellTradeLimitAndClass(address _wallet) external view returns (uint256, uint256) {
296         WalletInfo storage walletInfo = walletTable[_wallet];
297         return (walletInfo.sellLimit, walletInfo.tradeClass);
298     }
299 
300     /**
301      * @dev Insert or update a wallet.
302      * @param _wallet The address of the wallet.
303      * @param _sequenceNum The sequence-number of the operation.
304      * @param _isWhitelisted The authorization of the wallet.
305      * @param _actionRole The action-role of the wallet.
306      * @param _buyLimit The buy trade-limit of the wallet.
307      * @param _sellLimit The sell trade-limit of the wallet.
308      * @param _tradeClass The trade-class of the wallet.
309      */
310     function upsertOne(address _wallet, uint256 _sequenceNum, bool _isWhitelisted, uint256 _actionRole, uint256 _buyLimit, uint256 _sellLimit, uint256 _tradeClass) external onlyAdmin {
311         _upsert(_wallet, _sequenceNum, _isWhitelisted, _actionRole, _buyLimit, _sellLimit, _tradeClass);
312     }
313 
314     /**
315      * @dev Remove a wallet.
316      * @param _wallet The address of the wallet.
317      */
318     function removeOne(address _wallet) external onlyAdmin {
319         _remove(_wallet);
320     }
321 
322     /**
323      * @dev Insert or update a list of wallets with the same params.
324      * @param _wallets The addresses of the wallets.
325      * @param _sequenceNum The sequence-number of the operation.
326      * @param _isWhitelisted The authorization of all the wallets.
327      * @param _actionRole The action-role of all the the wallets.
328      * @param _buyLimit The buy trade-limit of all the wallets.
329      * @param _sellLimit The sell trade-limit of all the wallets.
330      * @param _tradeClass The trade-class of all the wallets.
331      */
332     function upsertAll(address[] _wallets, uint256 _sequenceNum, bool _isWhitelisted, uint256 _actionRole, uint256 _buyLimit, uint256 _sellLimit, uint256 _tradeClass) external onlyAdmin {
333         for (uint256 i = 0; i < _wallets.length; i++)
334             _upsert(_wallets[i], _sequenceNum, _isWhitelisted, _actionRole, _buyLimit, _sellLimit, _tradeClass);
335     }
336 
337     /**
338      * @dev Remove a list of wallets.
339      * @param _wallets The addresses of the wallets.
340      */
341     function removeAll(address[] _wallets) external onlyAdmin {
342         for (uint256 i = 0; i < _wallets.length; i++)
343             _remove(_wallets[i]);
344     }
345 
346     /**
347      * @dev Insert or update a wallet.
348      * @param _wallet The address of the wallet.
349      * @param _sequenceNum The sequence-number of the operation.
350      * @param _isWhitelisted The authorization of the wallet.
351      * @param _actionRole The action-role of the wallet.
352      * @param _buyLimit The buy trade-limit of the wallet.
353      * @param _sellLimit The sell trade-limit of the wallet.
354      * @param _tradeClass The trade-class of the wallet.
355      */
356     function _upsert(address _wallet, uint256 _sequenceNum, bool _isWhitelisted, uint256 _actionRole, uint256 _buyLimit, uint256 _sellLimit, uint256 _tradeClass) private {
357         require(_wallet != address(0), "wallet is illegal");
358         WalletInfo storage walletInfo = walletTable[_wallet];
359         if (walletInfo.sequenceNum < _sequenceNum) {
360             if (walletInfo.sequenceNum == 0) // increment the wallet-count only when a new wallet is inserted
361                 walletCount += 1; // will never overflow because the number of different wallets = 2^160 < 2^256
362             walletInfo.sequenceNum = _sequenceNum;
363             walletInfo.isWhitelisted = _isWhitelisted;
364             walletInfo.actionRole = _actionRole;
365             walletInfo.buyLimit = _buyLimit;
366             walletInfo.sellLimit = _sellLimit;
367             walletInfo.tradeClass = _tradeClass;
368             emit WalletSaved(_wallet);
369         }
370         else {
371             emit WalletNotSaved(_wallet);
372         }
373     }
374 
375     /**
376      * @dev Remove a wallet.
377      * @param _wallet The address of the wallet.
378      */
379     function _remove(address _wallet) private {
380         require(_wallet != address(0), "wallet is illegal");
381         WalletInfo storage walletInfo = walletTable[_wallet];
382         if (walletInfo.sequenceNum > 0) { // decrement the wallet-count only when an existing wallet is removed
383             walletCount -= 1; // will never underflow because every decrement follows a corresponding increment
384             delete walletTable[_wallet];
385             emit WalletDeleted(_wallet);
386         }
387         else {
388             emit WalletNotDeleted(_wallet);
389         }
390     }
391 }
