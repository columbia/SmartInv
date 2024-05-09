1 pragma solidity 0.6.12;
2 pragma experimental ABIEncoderV2;
3 
4 
5 interface TradeBotCommanderV2Interface {
6     // events
7     event AddedAccount(address account);
8     event RemovedAccount(address account);
9     event Call(address target, uint256 amount, bytes data, bool ok, bytes returnData);
10     
11     // callable by accounts
12     function processLimitOrder(
13         DharmaTradeBotV1Interface.LimitOrderArguments calldata args,
14         DharmaTradeBotV1Interface.LimitOrderExecutionArguments calldata executionArgs
15     ) external returns (bool ok, uint256 amountReceived);
16 
17     function deployAndProcessLimitOrder(
18         address initialSigningKey, // the initial key on the keyring
19         address keyRing,
20         DharmaTradeBotV1Interface.LimitOrderArguments calldata args,
21         DharmaTradeBotV1Interface.LimitOrderExecutionArguments calldata executionArgs
22     ) external returns (bool ok, bytes memory returnData);
23 
24     // only callable by owner
25     function addAccount(address account) external;
26     function removeAccount(address account) external;
27     function callAny(
28         address payable target, uint256 amount, bytes calldata data
29     ) external returns (bool ok, bytes memory returnData);
30 
31     // view functions
32     function getAccounts() external view returns (address[] memory);
33     function getTradeBot() external view returns (address tradeBot);
34 }
35 
36 
37 interface DharmaTradeBotV1Interface {
38   struct LimitOrderArguments {
39     address account;
40     address assetToSupply;        // Ether = address(0)
41     address assetToReceive;       // Ether = address(0)
42     uint256 maximumAmountToSupply;
43     uint256 maximumPriceToAccept; // represented as a mantissa (n * 10^18)
44     uint256 expiration;
45     bytes32 salt;
46   }
47 
48   struct LimitOrderExecutionArguments {
49     uint256 amountToSupply; // will be lower than maximum for partial fills
50     bytes signatures;
51     address tradeTarget;
52     bytes tradeData;
53   }
54 
55   function processLimitOrder(
56     LimitOrderArguments calldata args,
57     LimitOrderExecutionArguments calldata executionArgs
58   ) external returns (uint256 amountReceived);
59 }
60 
61 
62 interface DharmaSmartWalletFactoryV1Interface {
63   function newSmartWallet(
64     address userSigningKey
65   ) external returns (address wallet);
66   
67   function getNextSmartWallet(
68     address userSigningKey
69   ) external view returns (address wallet);
70 }
71 
72 interface DharmaKeyRingFactoryV2Interface {
73   function newKeyRing(
74     address userSigningKey, address targetKeyRing
75   ) external returns (address keyRing);
76 
77   function getNextKeyRing(
78     address userSigningKey
79   ) external view returns (address targetKeyRing);
80 }
81 
82 
83 contract TwoStepOwnable {
84   address private _owner;
85 
86   address private _newPotentialOwner;
87 
88   event OwnershipTransferred(
89     address indexed previousOwner,
90     address indexed newOwner
91   );
92 
93   /**
94    * @dev Initialize contract by setting transaction submitter as initial owner.
95    */
96   constructor() internal {
97     _owner = tx.origin;
98     emit OwnershipTransferred(address(0), _owner);
99   }
100 
101   /**
102    * @dev Returns the address of the current owner.
103    */
104   function owner() public view returns (address) {
105     return _owner;
106   }
107 
108   /**
109    * @dev Throws if called by any account other than the owner.
110    */
111   modifier onlyOwner() {
112     require(isOwner(), "TwoStepOwnable: caller is not the owner.");
113     _;
114   }
115 
116   /**
117    * @dev Returns true if the caller is the current owner.
118    */
119   function isOwner() public view returns (bool) {
120     return msg.sender == _owner;
121   }
122 
123   /**
124    * @dev Allows a new account (`newOwner`) to accept ownership.
125    * Can only be called by the current owner.
126    */
127   function transferOwnership(address newOwner) public onlyOwner {
128     require(
129       newOwner != address(0),
130       "TwoStepOwnable: new potential owner is the zero address."
131     );
132 
133     _newPotentialOwner = newOwner;
134   }
135 
136   /**
137    * @dev Cancel a transfer of ownership to a new account.
138    * Can only be called by the current owner.
139    */
140   function cancelOwnershipTransfer() public onlyOwner {
141     delete _newPotentialOwner;
142   }
143 
144   /**
145    * @dev Transfers ownership of the contract to the caller.
146    * Can only be called by a new potential owner set by the current owner.
147    */
148   function acceptOwnership() public {
149     require(
150       msg.sender == _newPotentialOwner,
151       "TwoStepOwnable: current owner must set caller as new potential owner."
152     );
153 
154     delete _newPotentialOwner;
155 
156     emit OwnershipTransferred(_owner, msg.sender);
157 
158     _owner = msg.sender;
159   }
160 }
161 
162 
163 contract TradeBotCommanderV2 is TradeBotCommanderV2Interface, TwoStepOwnable {
164     // Track all authorized accounts.
165     address[] private _accounts;
166 
167     // Indexes start at 1, as 0 signifies non-inclusion
168     mapping (address => uint256) private _accountIndexes;
169     
170     DharmaTradeBotV1Interface private immutable _TRADE_BOT;
171 
172     DharmaSmartWalletFactoryV1Interface private immutable _WALLET_FACTORY;
173   
174     DharmaKeyRingFactoryV2Interface private immutable _KEYRING_FACTORY;
175 
176     constructor(address walletFactory, address keyRingFactory, address tradeBot, address[] memory initialAccounts) public {
177         require(
178             walletFactory != address(0) &&
179             keyRingFactory != address(0) &&
180             tradeBot != address(0),
181             "Missing required constructor arguments."
182         );
183         _WALLET_FACTORY = DharmaSmartWalletFactoryV1Interface(walletFactory);
184         _KEYRING_FACTORY = DharmaKeyRingFactoryV2Interface(keyRingFactory);
185         _TRADE_BOT = DharmaTradeBotV1Interface(tradeBot);
186         for (uint256 i; i < initialAccounts.length; i++) {
187             address account = initialAccounts[i];
188             _addAccount(account);
189         }
190     }
191     
192     function processLimitOrder(
193         DharmaTradeBotV1Interface.LimitOrderArguments calldata args,
194         DharmaTradeBotV1Interface.LimitOrderExecutionArguments calldata executionArgs
195     ) external override returns (bool ok, uint256 amountReceived) {
196         require(
197             _accountIndexes[msg.sender] != 0,
198             "Only authorized accounts may trigger limit orders."
199         );
200         
201         amountReceived = _TRADE_BOT.processLimitOrder(
202             args, executionArgs
203         );
204 
205         ok = true;
206     }
207 
208     // Deploy a key ring and a smart wallet, then process the limit order.
209     function deployAndProcessLimitOrder(
210         address initialSigningKey, // the initial key on the keyring
211         address keyRing,
212         DharmaTradeBotV1Interface.LimitOrderArguments calldata args,
213         DharmaTradeBotV1Interface.LimitOrderExecutionArguments calldata executionArgs
214     ) external override returns (bool ok, bytes memory returnData) {
215         require(
216             _accountIndexes[msg.sender] != 0,
217             "Only authorized accounts may trigger limit orders."
218         );
219         
220         _deployNewKeyRingIfNeeded(initialSigningKey, keyRing);
221         _deployNewSmartWalletIfNeeded(keyRing, args.account);
222         
223         try _TRADE_BOT.processLimitOrder(args, executionArgs) returns (uint256 amountReceived) {
224             return (true, abi.encode(amountReceived));
225         } catch (bytes memory revertData) {
226             return (false, revertData);
227         }
228   }
229 
230     function addAccount(address account) external override onlyOwner {
231         _addAccount(account);
232     }
233 
234     function removeAccount(address account) external override onlyOwner {
235         _removeAccount(account);
236     }
237 
238     function callAny(
239         address payable target, uint256 amount, bytes calldata data
240     ) external override onlyOwner returns (bool ok, bytes memory returnData) {
241         // Call the specified target and supply the specified amount and data.
242         (ok, returnData) = target.call{value: amount}(data);
243 
244         emit Call(target, amount, data, ok, returnData);
245     }
246 
247     function getAccounts() external view override returns (address[] memory) {
248         return _accounts;
249     }
250 
251     function getTradeBot() external view override returns (address tradeBot) {
252         return address(_TRADE_BOT);
253     }
254 
255   function _deployNewKeyRingIfNeeded(
256     address initialSigningKey, address expectedKeyRing
257   ) internal returns (address keyRing) {
258     // Only deploy if a contract doesn't already exist at expected address.
259     bytes32 size;
260     assembly { size := extcodesize(expectedKeyRing) }
261     if (size == 0) {
262       require(
263         _KEYRING_FACTORY.getNextKeyRing(initialSigningKey) == expectedKeyRing,
264         "Key ring to be deployed does not match expected key ring."
265       );
266       keyRing = _KEYRING_FACTORY.newKeyRing(initialSigningKey, expectedKeyRing);
267     } else {
268       // Note: the key ring at the expected address may have been modified so that
269       // the supplied user signing key is no longer a valid key - therefore, treat
270       // this helper as a way to protect against race conditions, not as a primary
271       // mechanism for interacting with key ring contracts.
272       keyRing = expectedKeyRing;
273     }
274   }
275   
276   function _deployNewSmartWalletIfNeeded(
277     address userSigningKey, // the key ring
278     address expectedSmartWallet
279   ) internal returns (address smartWallet) {
280     // Only deploy if a contract doesn't already exist at expected address.
281     bytes32 size;
282     assembly { size := extcodesize(expectedSmartWallet) }
283     if (size == 0) {
284       require(
285         _WALLET_FACTORY.getNextSmartWallet(userSigningKey) == expectedSmartWallet,
286         "Smart wallet to be deployed does not match expected smart wallet."
287       );
288       smartWallet = _WALLET_FACTORY.newSmartWallet(userSigningKey);
289     } else {
290       // Note: the smart wallet at the expected address may have been modified
291       // so that the supplied user signing key is no longer a valid key.
292       // Therefore, treat this helper as a way to protect against race
293       // conditions, not as a primary mechanism for interacting with smart
294       // wallet contracts.
295       smartWallet = expectedSmartWallet;
296     }
297   }
298 
299     function _addAccount(address account) internal {
300         require(
301             _accountIndexes[account] == 0,
302             "Account matching the provided account already exists."
303         );
304         _accounts.push(account);
305         _accountIndexes[account] = _accounts.length;
306 
307         emit AddedAccount(account);
308     }
309     
310     function _removeAccount(address account) internal {
311         uint256 removedAccountIndex = _accountIndexes[account];
312         require(
313             removedAccountIndex != 0,
314             "No account found matching the provided account."
315         );
316 
317         // swap account to remove with the last one then pop from the array.
318         address lastAccount = _accounts[_accounts.length - 1];
319         _accounts[removedAccountIndex - 1] = lastAccount;
320         _accountIndexes[lastAccount] = removedAccountIndex;
321         _accounts.pop();
322         delete _accountIndexes[account];
323 
324         emit RemovedAccount(account); 
325     }
326 }