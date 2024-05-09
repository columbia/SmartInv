1 pragma solidity 0.6.12;
2 pragma experimental ABIEncoderV2;
3 
4 
5 interface ReserveTraderV1Interface {
6     // events
7     event AddedAccount(address account);
8     event RemovedAccount(address account);
9     event CallTradeReserve(bytes data, bool ok, bytes returnData);
10     event Call(address target, uint256 amount, bytes data, bool ok, bytes returnData);
11 
12     
13     // callable by accounts
14     function callTradeReserve(
15         bytes calldata data
16     ) external returns (bool ok, bytes memory returnData);
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
27     function getTradeReserve() external view returns (address tradeReserve);
28 }
29 
30 contract TwoStepOwnable {
31   address private _owner;
32 
33   address private _newPotentialOwner;
34 
35   event OwnershipTransferred(
36     address indexed previousOwner,
37     address indexed newOwner
38   );
39 
40   /**
41    * @dev Initialize contract by setting transaction submitter as initial owner.
42    */
43   constructor() internal {
44     _owner = tx.origin;
45     emit OwnershipTransferred(address(0), _owner);
46   }
47 
48   /**
49    * @dev Returns the address of the current owner.
50    */
51   function owner() public view returns (address) {
52     return _owner;
53   }
54 
55   /**
56    * @dev Throws if called by any account other than the owner.
57    */
58   modifier onlyOwner() {
59     require(isOwner(), "TwoStepOwnable: caller is not the owner.");
60     _;
61   }
62 
63   /**
64    * @dev Returns true if the caller is the current owner.
65    */
66   function isOwner() public view returns (bool) {
67     return msg.sender == _owner;
68   }
69 
70   /**
71    * @dev Allows a new account (`newOwner`) to accept ownership.
72    * Can only be called by the current owner.
73    */
74   function transferOwnership(address newOwner) public onlyOwner {
75     require(
76       newOwner != address(0),
77       "TwoStepOwnable: new potential owner is the zero address."
78     );
79 
80     _newPotentialOwner = newOwner;
81   }
82 
83   /**
84    * @dev Cancel a transfer of ownership to a new account.
85    * Can only be called by the current owner.
86    */
87   function cancelOwnershipTransfer() public onlyOwner {
88     delete _newPotentialOwner;
89   }
90 
91   /**
92    * @dev Transfers ownership of the contract to the caller.
93    * Can only be called by a new potential owner set by the current owner.
94    */
95   function acceptOwnership() public {
96     require(
97       msg.sender == _newPotentialOwner,
98       "TwoStepOwnable: current owner must set caller as new potential owner."
99     );
100 
101     delete _newPotentialOwner;
102 
103     emit OwnershipTransferred(_owner, msg.sender);
104 
105     _owner = msg.sender;
106   }
107 }
108 
109 
110 contract ReserveTraderV1 is ReserveTraderV1Interface, TwoStepOwnable {
111     // Track all authorized accounts.
112     address[] private _accounts;
113 
114     // Indexes start at 1, as 0 signifies non-inclusion
115     mapping (address => uint256) private _accountIndexes;
116     
117     address private immutable _TRADE_RESERVE;
118 
119     constructor(address tradeReserve, address[] memory initialAccounts) public {
120         _TRADE_RESERVE = tradeReserve;
121         for (uint256 i; i < initialAccounts.length; i++) {
122             address account = initialAccounts[i];
123             _addAccount(account);
124         }
125     }
126 
127     function addAccount(address account) external override onlyOwner {
128         _addAccount(account);
129     }
130 
131     function removeAccount(address account) external override onlyOwner {
132         _removeAccount(account);
133     }
134 
135     function callTradeReserve(
136         bytes calldata data
137     ) external override returns (bool ok, bytes memory returnData) {
138         require(
139             _accountIndexes[msg.sender] != 0,
140             "Only authorized accounts may trigger calls."
141         );
142         
143         // Call the Trade Serve and supply the specified amount and data.
144         (ok, returnData) = _TRADE_RESERVE.call(data);
145         
146         if (!ok) {
147             assembly {
148                 revert(add(returnData, 32), returndatasize())
149             }
150         }
151 
152         emit CallTradeReserve(data, ok, returnData);
153     }
154 
155     function callAny(
156         address payable target, uint256 amount, bytes calldata data
157     ) external override onlyOwner returns (bool ok, bytes memory returnData) {
158         // Call the specified target and supply the specified amount and data.
159         (ok, returnData) = target.call{value: amount}(data);
160 
161         emit Call(target, amount, data, ok, returnData);
162     }
163     
164     function getAccounts() external view override returns (address[] memory) {
165         return _accounts;
166     }
167 
168     function getTradeReserve() external view override returns (address tradeReserve) {
169         return _TRADE_RESERVE;
170     }
171 
172     function _addAccount(address account) internal {
173         require(
174             _accountIndexes[account] == 0,
175             "Account matching the provided account already exists."
176         );
177         _accounts.push(account);
178         _accountIndexes[account] = _accounts.length;
179 
180         emit AddedAccount(account);
181     }
182     
183     function _removeAccount(address account) internal {
184         uint256 removedAccountIndex = _accountIndexes[account];
185         require(
186             removedAccountIndex != 0,
187             "No account found matching the provided account."
188         );
189 
190         // swap account to remove with the last one then pop from the array.
191         address lastAccount = _accounts[_accounts.length - 1];
192         _accounts[removedAccountIndex - 1] = lastAccount;
193         _accountIndexes[lastAccount] = removedAccountIndex;
194         _accounts.pop();
195         delete _accountIndexes[account];
196 
197         emit RemovedAccount(account); 
198     }
199 }