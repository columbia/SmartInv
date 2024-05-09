1 pragma solidity 0.6.12;
2 pragma experimental ABIEncoderV2;
3 
4 
5 interface AccountRecoveryManagerRecovererV1Interface {
6     // events
7     event AddedAccount(address account);
8     event RemovedAccount(address account);
9     event CallRecover(address wallet, address newUserSigningKey);
10     event Call(address target, uint256 amount, bytes data, bool ok, bytes returnData);
11 
12     
13     // callable by accounts
14     function callRecover(
15         address wallet, address newUserSigningKey
16     ) external;
17 
18     // only callable by owner
19     function addAccount(address account) external;
20     function removeAccount(address account) external;
21     function callAny(
22         address payable target, uint256 amount, bytes calldata data
23     ) external returns (bool ok, bytes memory returnData);
24 
25     // view functions
26     function getAccounts() external view returns (address[] memory);
27     function getAccountRecoveryManager() external view returns (address accountRecoveryManager);
28 }
29 
30 interface DharmaAccountRecoveryManagerV2Interface {
31   function recover(address wallet, address newUserSigningKey) external;
32 }
33 
34 contract TwoStepOwnable {
35   address private _owner;
36 
37   address private _newPotentialOwner;
38 
39   event OwnershipTransferred(
40     address indexed previousOwner,
41     address indexed newOwner
42   );
43 
44   /**
45    * @dev Initialize contract by setting transaction submitter as initial owner.
46    */
47   constructor() internal {
48     _owner = tx.origin;
49     emit OwnershipTransferred(address(0), _owner);
50   }
51 
52   /**
53    * @dev Returns the address of the current owner.
54    */
55   function owner() public view returns (address) {
56     return _owner;
57   }
58 
59   /**
60    * @dev Throws if called by any account other than the owner.
61    */
62   modifier onlyOwner() {
63     require(isOwner(), "TwoStepOwnable: caller is not the owner.");
64     _;
65   }
66 
67   /**
68    * @dev Returns true if the caller is the current owner.
69    */
70   function isOwner() public view returns (bool) {
71     return msg.sender == _owner;
72   }
73 
74   /**
75    * @dev Allows a new account (`newOwner`) to accept ownership.
76    * Can only be called by the current owner.
77    */
78   function transferOwnership(address newOwner) public onlyOwner {
79     require(
80       newOwner != address(0),
81       "TwoStepOwnable: new potential owner is the zero address."
82     );
83 
84     _newPotentialOwner = newOwner;
85   }
86 
87   /**
88    * @dev Cancel a transfer of ownership to a new account.
89    * Can only be called by the current owner.
90    */
91   function cancelOwnershipTransfer() public onlyOwner {
92     delete _newPotentialOwner;
93   }
94 
95   /**
96    * @dev Transfers ownership of the contract to the caller.
97    * Can only be called by a new potential owner set by the current owner.
98    */
99   function acceptOwnership() public {
100     require(
101       msg.sender == _newPotentialOwner,
102       "TwoStepOwnable: current owner must set caller as new potential owner."
103     );
104 
105     delete _newPotentialOwner;
106 
107     emit OwnershipTransferred(_owner, msg.sender);
108 
109     _owner = msg.sender;
110   }
111 }
112 
113 
114 contract AccountRecoveryManagerRecovererV1 is AccountRecoveryManagerRecovererV1Interface, TwoStepOwnable {
115     // Track all authorized accounts.
116     address[] private _accounts;
117 
118     // Indexes start at 1, as 0 signifies non-inclusion
119     mapping (address => uint256) private _accountIndexes;
120     
121     DharmaAccountRecoveryManagerV2Interface private immutable _ACCOUNT_RECOVERY_MANAGER;
122 
123     constructor(address accountRecoveryManager, address[] memory initialAccounts) public {
124         _ACCOUNT_RECOVERY_MANAGER = DharmaAccountRecoveryManagerV2Interface(accountRecoveryManager);
125         for (uint256 i; i < initialAccounts.length; i++) {
126             address account = initialAccounts[i];
127             _addAccount(account);
128         }
129     }
130 
131     function addAccount(address account) external override onlyOwner {
132         _addAccount(account);
133     }
134 
135     function removeAccount(address account) external override onlyOwner {
136         _removeAccount(account);
137     }
138 
139     function callRecover(
140         address wallet, address newUserSigningKey
141     ) external override {
142         require(
143             _accountIndexes[msg.sender] != 0,
144             "Only authorized accounts may trigger calls."
145         );
146         
147         // Call the recover function on the Account Recovery Manager
148         _ACCOUNT_RECOVERY_MANAGER.recover(wallet, newUserSigningKey);
149         
150         emit CallRecover(wallet, newUserSigningKey);
151     }
152 
153     function callAny(
154         address payable target, uint256 amount, bytes calldata data
155     ) external override onlyOwner returns (bool ok, bytes memory returnData) {
156         // Call the specified target and supply the specified amount and data.
157         (ok, returnData) = target.call{value: amount}(data);
158 
159         emit Call(target, amount, data, ok, returnData);
160     }
161     
162     function getAccounts() external view override returns (address[] memory) {
163         return _accounts;
164     }
165 
166     function getAccountRecoveryManager() external view override returns (address accountRecoveryManager) {
167         return address(_ACCOUNT_RECOVERY_MANAGER);
168     }
169 
170     function _addAccount(address account) internal {
171         require(
172             _accountIndexes[account] == 0,
173             "Account matching the provided account already exists."
174         );
175         _accounts.push(account);
176         _accountIndexes[account] = _accounts.length;
177 
178         emit AddedAccount(account);
179     }
180     
181     function _removeAccount(address account) internal {
182         uint256 removedAccountIndex = _accountIndexes[account];
183         require(
184             removedAccountIndex != 0,
185             "No account found matching the provided account."
186         );
187 
188         // swap account to remove with the last one then pop from the array.
189         address lastAccount = _accounts[_accounts.length - 1];
190         _accounts[removedAccountIndex - 1] = lastAccount;
191         _accountIndexes[lastAccount] = removedAccountIndex;
192         _accounts.pop();
193         delete _accountIndexes[account];
194 
195         emit RemovedAccount(account); 
196     }
197 }