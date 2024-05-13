1 // SPDX-License-Identifier: BUSL-1.1
2 
3 pragma solidity 0.8.6;
4 
5 import "@yield-protocol/vault-interfaces/ICauldron.sol";
6 import "@yield-protocol/vault-interfaces/DataTypes.sol";
7 import "./ConvexStakingWrapper.sol";
8 
9 /// @title Convex staking wrapper for Yield platform
10 /// @notice Enables use of convex LP positions as collateral while still receiving rewards
11 contract ConvexYieldWrapper is ConvexStakingWrapper {
12     using TransferHelper for IERC20;
13 
14     /// @notice Mapping to keep track of the user & their vaults
15     mapping(address => bytes12[]) public vaults;
16 
17     ICauldron public cauldron;
18 
19     /// @notice Event called when a vault is added for a user
20     /// @param account The account for which vault is added
21     /// @param vaultId The vaultId to be added
22     event VaultAdded(address indexed account, bytes12 indexed vaultId);
23 
24     /// @notice Event called when a vault is removed for a user
25     /// @param account The account for which vault is removed
26     /// @param vaultId The vaultId to be removed
27     event VaultRemoved(address indexed account, bytes12 indexed vaultId);
28 
29     /// @notice Event called when tokens are rescued from the contract
30     /// @param token Address of the token being rescued
31     /// @param amount Amount of the token being rescued
32     /// @param destination Address to which the rescued tokens have been sent
33     event Recovered(address indexed token, uint256 amount, address indexed destination);
34 
35     constructor(
36         address curveToken_,
37         address convexToken_,
38         address convexPool_,
39         uint256 poolId_,
40         address join_,
41         ICauldron cauldron_,
42         string memory name,
43         string memory symbol,
44         uint8 decimals
45     ) ConvexStakingWrapper(curveToken_, convexToken_, convexPool_, poolId_, join_, name, symbol, decimals) {
46         cauldron = cauldron_;
47     }
48 
49     /// @notice Points the collateral vault to the join storing the wrappedConvex
50     /// @param join_ Join which will store the wrappedConvex of the user
51     function point(address join_) external auth {
52         collateralVault = join_;
53     }
54 
55     /// @notice Adds a vault to the user's vault list
56     /// @param vaultId The id of the vault being added
57     function addVault(bytes12 vaultId) external {
58         address account = cauldron.vaults(vaultId).owner;
59         require(account != address(0), "No owner for the vault");
60         bytes12[] storage vaults_ = vaults[account];
61         uint256 vaultsLength = vaults_.length;
62 
63         for (uint256 i = 0; i < vaultsLength; i++) {
64             require(vaults_[i] != vaultId, "Vault already added");
65         }
66         vaults_.push(vaultId);
67         vaults[account] = vaults_;
68         emit VaultAdded(account, vaultId);
69     }
70 
71     /// @notice Remove a vault from the user's vault list
72     /// @param vaultId The id of the vault being removed
73     /// @param account The user from whom the vault needs to be removed
74     function removeVault(bytes12 vaultId, address account) public {
75         address owner = cauldron.vaults(vaultId).owner;
76         if (account != owner) {
77             bytes12[] storage vaults_ = vaults[account];
78             uint256 vaultsLength = vaults_.length;
79             bool found;
80             for (uint256 i = 0; i < vaultsLength; i++) {
81                 if (vaults_[i] == vaultId) {
82                     bool isLast = i == vaultsLength - 1;
83                     if (!isLast) {
84                         vaults_[i] = vaults_[vaultsLength - 1];
85                     }
86                     vaults_.pop();
87                     found = true;
88                     emit VaultRemoved(account, vaultId);
89                     break;
90                 }
91             }
92             require(found, "Vault not found");
93             vaults[account] = vaults_;
94         }
95     }
96 
97     /// @notice Get user's balance of collateral deposited in various vaults
98     /// @param account_ User's address for which balance is requested
99     /// @return User's balance of collateral
100     function _getDepositedBalance(address account_) internal view override returns (uint256) {
101         if (account_ == address(0) || account_ == collateralVault) {
102             return 0;
103         }
104 
105         bytes12[] memory userVault = vaults[account_];
106 
107         //add up all balances of all vaults registered in the wrapper and owned by the account
108         uint256 collateral;
109         DataTypes.Balances memory balance;
110         uint256 userVaultLength = userVault.length;
111         for (uint256 i = 0; i < userVaultLength; i++) {
112             if (cauldron.vaults(userVault[i]).owner == account_) {
113                 balance = cauldron.balances(userVault[i]);
114                 collateral = collateral + balance.ink;
115             }
116         }
117 
118         //add to balance of this token
119         return _balanceOf[account_] + collateral;
120     }
121 
122     /// @dev Wrap convex token held by this contract and forward it to the `to` address
123     /// @param to_ Address to send the wrapped token to
124     /// @param from_ Address of the user whose token is being wrapped
125     function wrap(address to_, address from_) external {
126         require(!isShutdown, "shutdown");
127         uint256 amount_ = IERC20(convexToken).balanceOf(address(this));
128         require(amount_ > 0, "No convex token to wrap");
129 
130         _checkpoint([address(0), from_]);
131         _mint(to_, amount_);
132         IRewardStaking(convexPool).stake(amount_);
133 
134         emit Deposited(msg.sender, to_, amount_, false);
135     }
136 
137     /// @dev Unwrap Wrapped convex token held by this contract, and send the unwrapped convex token to the `to` address
138     /// @param to_ Address to send the unwrapped convex token to
139     function unwrap(address to_) external {
140         require(!isShutdown, "shutdown");
141         uint256 amount_ = _balanceOf[address(this)];
142         require(amount_ > 0, "No wrapped convex token");
143 
144         _checkpoint([address(0), to_]);
145         _burn(address(this), amount_);
146         IRewardStaking(convexPool).withdraw(amount_, false);
147         IERC20(convexToken).safeTransfer(to_, amount_);
148 
149         emit Withdrawn(to_, amount_, false);
150     }
151 
152     /// @notice A simple function to recover any ERC20 tokens
153     /// @param token_ Address of the token being rescued
154     /// @param amount_ Amount of the token being rescued
155     /// @param destination_ Address to which the rescued tokens have been sent
156     function recoverERC20(
157         address token_,
158         uint256 amount_,
159         address destination_
160     ) external auth {
161         require(amount_ != 0, "amount is 0");
162         IERC20(token_).safeTransfer(destination_, amount_);
163         emit Recovered(token_, amount_, destination_);
164     }
165 
166     /// @notice A function to shutdown the contract & withdraw the staked convex tokens & transfer rewards
167     /// @param rescueAddress_ Address to which the rescued tokens would be sent to
168     function shutdownAndRescue(address rescueAddress_) external auth {
169         uint256 balance_ = IRewardStaking(convexPool).balanceOf(address(this));
170 
171         if (balance_ != 0) {
172             // Withdraw the convex tokens from the convex pool
173             IRewardStaking(convexPool).withdraw(balance_, true);
174 
175             // Transfer the withdrawn convex tokens to rescue address
176             IERC20(convexToken).safeTransfer(rescueAddress_, balance_);
177         }
178         // Shutdown the contract
179         isShutdown = true;
180     }
181 }
