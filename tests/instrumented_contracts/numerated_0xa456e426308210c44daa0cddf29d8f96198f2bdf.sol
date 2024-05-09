1 // File: openzeppelin-solidity-v1.12.0/contracts/ownership/Ownable.sol
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
68 // File: openzeppelin-solidity-v1.12.0/contracts/ownership/Claimable.sol
69 
70 pragma solidity ^0.4.24;
71 
72 
73 
74 /**
75  * @title Claimable
76  * @dev Extension for the Ownable contract, where the ownership needs to be claimed.
77  * This allows the new owner to accept the transfer.
78  */
79 contract Claimable is Ownable {
80   address public pendingOwner;
81 
82   /**
83    * @dev Modifier throws if called by any account other than the pendingOwner.
84    */
85   modifier onlyPendingOwner() {
86     require(msg.sender == pendingOwner);
87     _;
88   }
89 
90   /**
91    * @dev Allows the current owner to set the pendingOwner address.
92    * @param newOwner The address to transfer ownership to.
93    */
94   function transferOwnership(address newOwner) public onlyOwner {
95     pendingOwner = newOwner;
96   }
97 
98   /**
99    * @dev Allows the pendingOwner address to finalize the transfer.
100    */
101   function claimOwnership() public onlyPendingOwner {
102     emit OwnershipTransferred(owner, pendingOwner);
103     owner = pendingOwner;
104     pendingOwner = address(0);
105   }
106 }
107 
108 // File: contracts/utils/Adminable.sol
109 
110 pragma solidity 0.4.25;
111 
112 
113 /**
114  * @title Adminable.
115  */
116 contract Adminable is Claimable {
117     address[] public adminArray;
118 
119     struct AdminInfo {
120         bool valid;
121         uint256 index;
122     }
123 
124     mapping(address => AdminInfo) public adminTable;
125 
126     event AdminAccepted(address indexed _admin);
127     event AdminRejected(address indexed _admin);
128 
129     /**
130      * @dev Reverts if called by any account other than one of the administrators.
131      */
132     modifier onlyAdmin() {
133         require(adminTable[msg.sender].valid, "caller is illegal");
134         _;
135     }
136 
137     /**
138      * @dev Accept a new administrator.
139      * @param _admin The administrator's address.
140      */
141     function accept(address _admin) external onlyOwner {
142         require(_admin != address(0), "administrator is illegal");
143         AdminInfo storage adminInfo = adminTable[_admin];
144         require(!adminInfo.valid, "administrator is already accepted");
145         adminInfo.valid = true;
146         adminInfo.index = adminArray.length;
147         adminArray.push(_admin);
148         emit AdminAccepted(_admin);
149     }
150 
151     /**
152      * @dev Reject an existing administrator.
153      * @param _admin The administrator's address.
154      */
155     function reject(address _admin) external onlyOwner {
156         AdminInfo storage adminInfo = adminTable[_admin];
157         require(adminArray.length > adminInfo.index, "administrator is already rejected");
158         require(_admin == adminArray[adminInfo.index], "administrator is already rejected");
159         // at this point we know that adminArray.length > adminInfo.index >= 0
160         address lastAdmin = adminArray[adminArray.length - 1]; // will never underflow
161         adminTable[lastAdmin].index = adminInfo.index;
162         adminArray[adminInfo.index] = lastAdmin;
163         adminArray.length -= 1; // will never underflow
164         delete adminTable[_admin];
165         emit AdminRejected(_admin);
166     }
167 
168     /**
169      * @dev Get an array of all the administrators.
170      * @return An array of all the administrators.
171      */
172     function getAdminArray() external view returns (address[] memory) {
173         return adminArray;
174     }
175 
176     /**
177      * @dev Get the total number of administrators.
178      * @return The total number of administrators.
179      */
180     function getAdminCount() external view returns (uint256) {
181         return adminArray.length;
182     }
183 }
184 
185 // File: contracts/authorization/interfaces/IAuthorizationDataSource.sol
186 
187 pragma solidity 0.4.25;
188 
189 /**
190  * @title Authorization Data Source Interface.
191  */
192 interface IAuthorizationDataSource {
193     /**
194      * @dev Get the authorized action-role of a wallet.
195      * @param _wallet The address of the wallet.
196      * @return The authorized action-role of the wallet.
197      */
198     function getAuthorizedActionRole(address _wallet) external view returns (bool, uint256);
199 
200     /**
201      * @dev Get the trade-limit and trade-class of a wallet.
202      * @param _wallet The address of the wallet.
203      * @return The trade-limit and trade-class of the wallet.
204      */
205     function getTradeLimitAndClass(address _wallet) external view returns (uint256, uint256);
206 }
207 
208 // File: contracts/authorization/AuthorizationDataSource.sol
209 
210 pragma solidity 0.4.25;
211 
212 
213 
214 /**
215  * Details of usage of licenced software see here: https://www.saga.org/software/readme_v1
216  */
217 
218 /**
219  * @title Authorization Data Source.
220  */
221 contract AuthorizationDataSource is IAuthorizationDataSource, Adminable {
222     string public constant VERSION = "1.0.0";
223 
224     uint256 public walletCount;
225 
226     struct WalletInfo {
227         uint256 sequenceNum;
228         bool isWhitelisted;
229         uint256 actionRole;
230         uint256 tradeLimit;
231         uint256 tradeClass;
232     }
233 
234     mapping(address => WalletInfo) public walletTable;
235 
236     event WalletSaved(address indexed _wallet);
237     event WalletDeleted(address indexed _wallet);
238     event WalletNotSaved(address indexed _wallet);
239     event WalletNotDeleted(address indexed _wallet);
240 
241     /**
242      * @dev Get the authorized action-role of a wallet.
243      * @param _wallet The address of the wallet.
244      * @return The authorized action-role of the wallet.
245      */
246     function getAuthorizedActionRole(address _wallet) external view returns (bool, uint256) {
247         WalletInfo storage walletInfo = walletTable[_wallet];
248         return (walletInfo.isWhitelisted, walletInfo.actionRole);
249     }
250 
251     /**
252      * @dev Get the trade-limit and trade-class of a wallet.
253      * @param _wallet The address of the wallet.
254      * @return The trade-limit and trade-class of the wallet.
255      */
256     function getTradeLimitAndClass(address _wallet) external view returns (uint256, uint256) {
257         WalletInfo storage walletInfo = walletTable[_wallet];
258         return (walletInfo.tradeLimit, walletInfo.tradeClass);
259     }
260 
261     /**
262      * @dev Insert or update a wallet.
263      * @param _wallet The address of the wallet.
264      * @param _sequenceNum The sequence-number of the operation.
265      * @param _isWhitelisted The authorization of the wallet.
266      * @param _actionRole The action-role of the wallet.
267      * @param _tradeLimit The trade-limit of the wallet.
268      * @param _tradeClass The trade-class of the wallet.
269      */
270     function upsertOne(address _wallet, uint256 _sequenceNum, bool _isWhitelisted, uint256 _actionRole, uint256 _tradeLimit, uint256 _tradeClass) external onlyAdmin {
271         _upsert(_wallet, _sequenceNum, _isWhitelisted, _actionRole, _tradeLimit, _tradeClass);
272     }
273 
274     /**
275      * @dev Remove a wallet.
276      * @param _wallet The address of the wallet.
277      */
278     function removeOne(address _wallet) external onlyAdmin {
279         _remove(_wallet);
280     }
281 
282     /**
283      * @dev Insert or update a list of wallets with the same params.
284      * @param _wallets The addresses of the wallets.
285      * @param _sequenceNum The sequence-number of the operation.
286      * @param _isWhitelisted The authorization of all the wallets.
287      * @param _actionRole The action-role of all the the wallets.
288      * @param _tradeLimit The trade-limit of all the wallets.
289      * @param _tradeClass The trade-class of all the wallets.
290      */
291     function upsertAll(address[] _wallets, uint256 _sequenceNum, bool _isWhitelisted, uint256 _actionRole, uint256 _tradeLimit, uint256 _tradeClass) external onlyAdmin {
292         for (uint256 i = 0; i < _wallets.length; i++)
293             _upsert(_wallets[i], _sequenceNum, _isWhitelisted, _actionRole, _tradeLimit, _tradeClass);
294     }
295 
296     /**
297      * @dev Remove a list of wallets.
298      * @param _wallets The addresses of the wallets.
299      */
300     function removeAll(address[] _wallets) external onlyAdmin {
301         for (uint256 i = 0; i < _wallets.length; i++)
302             _remove(_wallets[i]);
303     }
304 
305     /**
306      * @dev Insert or update a wallet.
307      * @param _wallet The address of the wallet.
308      * @param _sequenceNum The sequence-number of the operation.
309      * @param _isWhitelisted The authorization of the wallet.
310      * @param _actionRole The action-role of the wallet.
311      * @param _tradeLimit The trade-limit of the wallet.
312      * @param _tradeClass The trade-class of the wallet.
313      */
314     function _upsert(address _wallet, uint256 _sequenceNum, bool _isWhitelisted, uint256 _actionRole, uint256 _tradeLimit, uint256 _tradeClass) private {
315         require(_wallet != address(0), "wallet is illegal");
316         WalletInfo storage walletInfo = walletTable[_wallet];
317         if (walletInfo.sequenceNum < _sequenceNum) {
318             if (walletInfo.sequenceNum == 0) // increment the wallet-count only when a new wallet is inserted
319                 walletCount += 1; // will never overflow because the number of different wallets = 2^160 < 2^256
320             walletInfo.sequenceNum = _sequenceNum;
321             walletInfo.isWhitelisted = _isWhitelisted;
322             walletInfo.actionRole = _actionRole;
323             walletInfo.tradeLimit = _tradeLimit;
324             walletInfo.tradeClass = _tradeClass;
325             emit WalletSaved(_wallet);
326         }
327         else {
328             emit WalletNotSaved(_wallet);
329         }
330     }
331 
332     /**
333      * @dev Remove a wallet.
334      * @param _wallet The address of the wallet.
335      */
336     function _remove(address _wallet) private {
337         require(_wallet != address(0), "wallet is illegal");
338         WalletInfo storage walletInfo = walletTable[_wallet];
339         if (walletInfo.sequenceNum > 0) { // decrement the wallet-count only when an existing wallet is removed
340             walletCount -= 1; // will never underflow because every decrement follows a corresponding increment
341             delete walletTable[_wallet];
342             emit WalletDeleted(_wallet);
343         }
344         else {
345             emit WalletNotDeleted(_wallet);
346         }
347     }
348 }