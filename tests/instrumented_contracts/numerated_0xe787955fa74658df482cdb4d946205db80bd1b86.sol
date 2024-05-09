1 // SPDX-License-Identifier: MIT
2 
3 pragma solidity 0.8.1;
4 
5 /**
6  * @dev Contract module which provides a basic access control mechanism, where
7  * there is an account (an owner) that can be granted exclusive access to
8  * specific functions.
9  *
10  * This module is used through inheritance. It will make available the modifier
11  * `onlyOwner`, which can be applied to your functions to restrict their use to
12  * the owner.
13  *
14  * In order to transfer ownership, a recipient must be specified, at which point
15  * the specified recipient can call `acceptOwnership` and take ownership.
16  */
17 
18 contract TwoStepOwnable {
19   address private _owner;
20 
21   address private _newPotentialOwner;
22 
23   event OwnershipTransferred(
24     address indexed previousOwner,
25     address indexed newOwner
26   );
27 
28   /**
29    * @dev Initialize contract by setting transaction submitter as initial owner.
30    */
31   constructor() {
32     _owner = tx.origin;
33     emit OwnershipTransferred(address(0), _owner);
34   }
35 
36   /**
37    * @dev Returns the address of the current owner.
38    */
39   function owner() public view returns (address) {
40     return _owner;
41   }
42 
43   /**
44    * @dev Throws if called by any account other than the owner.
45    */
46   modifier onlyOwner() {
47     require(isOwner(), "TwoStepOwnable: caller is not the owner.");
48     _;
49   }
50 
51   /**
52    * @dev Returns true if the caller is the current owner.
53    */
54   function isOwner() public view returns (bool) {
55     return msg.sender == _owner;
56   }
57 
58   /**
59    * @dev Allows a new account (`newOwner`) to accept ownership.
60    * Can only be called by the current owner.
61    */
62   function transferOwnership(address newOwner) public onlyOwner {
63     require(
64       newOwner != address(0),
65       "TwoStepOwnable: new potential owner is the zero address."
66     );
67 
68     _newPotentialOwner = newOwner;
69   }
70 
71   /**
72    * @dev Cancel a transfer of ownership to a new account.
73    * Can only be called by the current owner.
74    */
75   function cancelOwnershipTransfer() public onlyOwner {
76     delete _newPotentialOwner;
77   }
78 
79   /**
80    * @dev Transfers ownership of the contract to the caller.
81    * Can only be called by a new potential owner set by the current owner.
82    */
83   function acceptOwnership() public {
84     require(
85       msg.sender == _newPotentialOwner,
86       "TwoStepOwnable: current owner must set caller as new potential owner."
87     );
88 
89     delete _newPotentialOwner;
90 
91     emit OwnershipTransferred(_owner, msg.sender);
92 
93     _owner = msg.sender;
94   }
95 }
96 
97 interface IReserveRoleV1 {
98   // events
99   event AddedAccount(address account);
100   event RemovedAccount(address account);
101   event CallTradeReserve(bytes data, bool ok, bytes returnData);
102   event Call(address target, uint256 amount, bytes data, bool ok, bytes returnData);
103 
104 
105   // callable by accounts
106   function callTradeReserve(
107     bytes calldata data
108   ) external returns (bool ok, bytes memory returnData);
109 
110   // only callable by owner
111   function addAccount(address account) external;
112   function removeAccount(address account) external;
113   function callAny(
114     address payable target, uint256 amount, bytes calldata data
115   ) external returns (bool ok, bytes memory returnData);
116 
117   // view functions
118   function getAccounts() external view returns (address[] memory);
119   function getTradeReserve() external view returns (address tradeReserve);
120 }
121 
122 
123 contract ReserveActioner is TwoStepOwnable, IReserveRoleV1 {
124   // Track all authorized accounts.
125   address[] private _accounts;
126 
127   // Indexes start at 1, as 0 signifies non-inclusion
128   mapping (address => uint256) private _accountIndices;
129 
130   address private immutable _TRADE_RESERVE;
131 
132   constructor(address tradeReserve, address[] memory initialAccounts) {
133     _TRADE_RESERVE = tradeReserve;
134     for (uint256 i; i < initialAccounts.length; i++) {
135       address account = initialAccounts[i];
136       _addAccount(account);
137     }
138   }
139 
140   function addAccount(address account) external override onlyOwner {
141     _addAccount(account);
142   }
143 
144   function removeAccount(address account) external override onlyOwner {
145     _removeAccount(account);
146   }
147 
148   function callTradeReserve(
149     bytes calldata data
150   ) external override returns (bool ok, bytes memory returnData) {
151     require(
152     _accountIndices[msg.sender] != 0,
153       "Only authorized accounts may trigger calls."
154     );
155 
156     // Call the Trade Serve and supply the specified amount and data.
157     (ok, returnData) = _TRADE_RESERVE.call(data);
158 
159     if (!ok) {
160       assembly {
161         revert(add(returnData, 32), returndatasize())
162       }
163     }
164 
165     emit CallTradeReserve(data, ok, returnData);
166   }
167 
168   function callAny(
169     address payable target, uint256 amount, bytes calldata data
170   ) external override onlyOwner returns (bool ok, bytes memory returnData) {
171     // Call the specified target and supply the specified amount and data.
172     (ok, returnData) = target.call{value: amount}(data);
173 
174     emit Call(target, amount, data, ok, returnData);
175   }
176 
177   function getAccounts() external view override returns (address[] memory) {
178     return _accounts;
179   }
180 
181   function getTradeReserve() external view override returns (address tradeReserve) {
182     return _TRADE_RESERVE;
183   }
184 
185   function _addAccount(address account) internal {
186     require(
187     _accountIndices[account] == 0,
188       "Account matching the provided account already exists."
189     );
190     _accounts.push(account);
191     _accountIndices[account] = _accounts.length;
192 
193     emit AddedAccount(account);
194   }
195 
196   function _removeAccount(address account) internal {
197     uint256 removedAccountIndex = _accountIndices[account];
198     require(
199       removedAccountIndex != 0,
200       "No account found matching the provided account."
201     );
202 
203     // swap account to remove with the last one then pop from the array.
204     address lastAccount = _accounts[_accounts.length - 1];
205     _accounts[removedAccountIndex - 1] = lastAccount;
206     _accountIndices[lastAccount] = removedAccountIndex;
207     _accounts.pop();
208     delete _accountIndices[account];
209 
210     emit RemovedAccount(account);
211   }
212 }