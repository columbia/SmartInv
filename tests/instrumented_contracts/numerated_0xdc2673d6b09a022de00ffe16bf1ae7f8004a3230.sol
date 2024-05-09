1 // Sources flattened with hardhat v2.6.8 https://hardhat.org
2 
3 // SPDX-License-Identifier: MIT
4 
5 // File @openzeppelin/contracts/utils/Context.sol@v3.4.1-solc-0.7-2
6 
7 pragma solidity >=0.6.0 <0.8.0;
8 
9 /*
10  * @dev Provides information about the current execution context, including the
11  * sender of the transaction and its data. While these are generally available
12  * via msg.sender and msg.data, they should not be accessed in such a direct
13  * manner, since when dealing with GSN meta-transactions the account sending and
14  * paying for execution may not be the actual sender (as far as an application
15  * is concerned).
16  *
17  * This contract is only required for intermediate, library-like contracts.
18  */
19 abstract contract Context {
20     function _msgSender() internal view virtual returns (address payable) {
21         return msg.sender;
22     }
23 
24     function _msgData() internal view virtual returns (bytes memory) {
25         this; // silence state mutability warning without generating bytecode - see https://github.com/ethereum/solidity/issues/2691
26         return msg.data;
27     }
28 }
29 
30 
31 // File @openzeppelin/contracts/access/Ownable.sol@v3.4.1-solc-0.7-2
32 
33 pragma solidity ^0.7.0;
34 
35 /**
36  * @dev Contract module which provides a basic access control mechanism, where
37  * there is an account (an owner) that can be granted exclusive access to
38  * specific functions.
39  *
40  * By default, the owner account will be the one that deploys the contract. This
41  * can later be changed with {transferOwnership}.
42  *
43  * This module is used through inheritance. It will make available the modifier
44  * `onlyOwner`, which can be applied to your functions to restrict their use to
45  * the owner.
46  */
47 abstract contract Ownable is Context {
48     address private _owner;
49 
50     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
51 
52     /**
53      * @dev Initializes the contract setting the deployer as the initial owner.
54      */
55     constructor () {
56         address msgSender = _msgSender();
57         _owner = msgSender;
58         emit OwnershipTransferred(address(0), msgSender);
59     }
60 
61     /**
62      * @dev Returns the address of the current owner.
63      */
64     function owner() public view virtual returns (address) {
65         return _owner;
66     }
67 
68     /**
69      * @dev Throws if called by any account other than the owner.
70      */
71     modifier onlyOwner() {
72         require(owner() == _msgSender(), "Ownable: caller is not the owner");
73         _;
74     }
75 
76     /**
77      * @dev Leaves the contract without owner. It will not be possible to call
78      * `onlyOwner` functions anymore. Can only be called by the current owner.
79      *
80      * NOTE: Renouncing ownership will leave the contract without an owner,
81      * thereby removing any functionality that is only available to the owner.
82      */
83     function renounceOwnership() public virtual onlyOwner {
84         emit OwnershipTransferred(_owner, address(0));
85         _owner = address(0);
86     }
87 
88     /**
89      * @dev Transfers ownership of the contract to a new account (`newOwner`).
90      * Can only be called by the current owner.
91      */
92     function transferOwnership(address newOwner) public virtual onlyOwner {
93         require(newOwner != address(0), "Ownable: new owner is the zero address");
94         emit OwnershipTransferred(_owner, newOwner);
95         _owner = newOwner;
96     }
97 }
98 
99 
100 // File contracts/interfaces/IVault.sol
101 
102 pragma solidity ^0.7.6;
103 
104 interface IVault {
105   function getRewardTokens() external view returns (address[] memory);
106 
107   function balance() external view returns (uint256);
108 
109   function balanceOf(address _user) external view returns (uint256);
110 
111   function deposit(uint256 _amount) external;
112 
113   function withdraw(uint256 _amount) external;
114 
115   function claim() external;
116 
117   function exit() external;
118 
119   function harvest() external;
120 }
121 
122 
123 // File contracts/interfaces/IRewardBondDepositor.sol
124 
125 pragma solidity ^0.7.6;
126 
127 interface IRewardBondDepositor {
128   function currentEpoch()
129     external
130     view
131     returns (
132       uint64 epochNumber,
133       uint64 startBlock,
134       uint64 nextBlock,
135       uint64 epochLength
136     );
137 
138   function rewardShares(uint256 _epoch, address _vault) external view returns (uint256);
139 
140   function getVaultsFromAccount(address _user) external view returns (address[] memory);
141 
142   function getAccountRewardShareSince(
143     uint256 _epoch,
144     address _user,
145     address _vault
146   ) external view returns (uint256[] memory);
147 
148   function bond(address _vault) external;
149 
150   function rebase() external;
151 
152   function notifyRewards(address _user, uint256[] memory _amounts) external;
153 }
154 
155 
156 // File contracts/Keeper.sol
157 
158 pragma solidity ^0.7.6;
159 
160 
161 contract Keeper is Ownable {
162   // The address of reward bond depositor.
163   address public immutable depositor;
164 
165   // Record whether an address can call bond or not
166   mapping(address => bool) public isBondWhitelist;
167   // Record whether an address can call rebase or not
168   mapping(address => bool) public isRebaseWhitelist;
169 
170   // A list of vaults. Push only, beware false-positives.
171   address[] public vaults;
172   // Record whether an address is vault or not.
173   mapping(address => bool) public isVault;
174 
175   /// @param _depositor The address of reward bond depositor.
176   constructor(address _depositor) {
177     depositor = _depositor;
178   }
179 
180   /// @dev bond ald for a list of vaults.
181   /// @param _vaults The address list of vaults.
182   function bond(address[] memory _vaults) external {
183     require(isBondWhitelist[msg.sender], "Keeper: only bond whitelist");
184 
185     for (uint256 i = 0; i < _vaults.length; i++) {
186       IRewardBondDepositor(depositor).bond(_vaults[i]);
187     }
188   }
189 
190   /// @dev bond ald for all supported vaults.
191   function bondAll() external {
192     require(isBondWhitelist[msg.sender], "Keeper: only bond whitelist");
193 
194     for (uint256 i = 0; i < vaults.length; i++) {
195       address _vault = vaults[i];
196       if (isVault[_vault]) {
197         IRewardBondDepositor(depositor).bond(_vault);
198       }
199     }
200   }
201 
202   /// @dev rebase ald
203   function rebase() external {
204     require(isRebaseWhitelist[msg.sender], "Keeper: only rebase whitelist");
205 
206     IRewardBondDepositor(depositor).rebase();
207   }
208 
209   /// @dev harvest reward for all supported vaults.
210   function harvestAll() external {
211     for (uint256 i = 0; i < vaults.length; i++) {
212       address _vault = vaults[i];
213       if (isVault[_vault]) {
214         IVault(_vault).harvest();
215       }
216     }
217   }
218 
219   /// @dev update the whitelist who can call bond.
220   /// @param _users The list of address.
221   /// @param status Whether to add or remove.
222   function updateBondWhitelist(address[] memory _users, bool status) external onlyOwner {
223     for (uint256 i = 0; i < _users.length; i++) {
224       isBondWhitelist[_users[i]] = status;
225     }
226   }
227 
228   /// @dev update the whitelist who can call rebase.
229   /// @param _users The list of address.
230   /// @param status Whether to add or remove.
231   function updateRebaseWhitelist(address[] memory _users, bool status) external onlyOwner {
232     for (uint256 i = 0; i < _users.length; i++) {
233       isRebaseWhitelist[_users[i]] = status;
234     }
235   }
236 
237   /// @dev update supported vault
238   /// @param _vault The address of vault.
239   /// @param status Whether it is add or remove vault.
240   function updateVault(address _vault, bool status) external onlyOwner {
241     if (status) {
242       require(!isVault[_vault], "Keeper: already added");
243       isVault[_vault] = true;
244       if (!_listContainsAddress(vaults, _vault)) {
245         vaults.push(_vault);
246       }
247     } else {
248       require(isVault[_vault], "Keeper: already removed");
249       isVault[_vault] = false;
250     }
251   }
252 
253   function _listContainsAddress(address[] storage _list, address _item) internal view returns (bool) {
254     uint256 length = _list.length;
255     for (uint256 i = 0; i < length; i++) {
256       if (_list[i] == _item) return true;
257     }
258     return false;
259   }
260 }