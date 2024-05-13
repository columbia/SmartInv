1 // SPDX-License-Identifier: GPL-3.0-or-later
2 pragma solidity 0.8.9;
3 
4 import "@openzeppelin/contracts/token/ERC20/utils/SafeERC20.sol";
5 import "@openzeppelin/contracts/token/ERC20/IERC20.sol";
6 
7 import "../../interfaces/IVaultReserve.sol";
8 import "../../libraries/Errors.sol";
9 
10 import "../access/Authorization.sol";
11 import "../vault/Vault.sol";
12 
13 /**
14  * @notice Contract holding vault reserves
15  * @dev ETH reserves are stored under address(0)
16  */
17 contract VaultReserve is IVaultReserve, Authorization {
18     using SafeERC20 for IERC20;
19 
20     uint256 internal constant _INITIAL_WITHDRAWAL_DELAY = 3 days;
21 
22     mapping(address => mapping(address => uint256)) private _balances;
23     mapping(address => uint256) private _lastWithdrawal;
24 
25     uint256 public minWithdrawalDelay;
26 
27     modifier onlyVault() {
28         require(_roleManager().hasRole(Roles.VAULT, msg.sender), Error.UNAUTHORIZED_ACCESS);
29         _;
30     }
31 
32     constructor(IRoleManager roleManager) Authorization(roleManager) {
33         minWithdrawalDelay = _INITIAL_WITHDRAWAL_DELAY;
34     }
35 
36     /**
37      * @notice Deposit funds into vault reserve.
38      * @notice Only callable by a whitelisted vault.
39      * @param token Token to deposit.
40      * @param amount Amount to deposit.
41      * @return True if deposit was successful.
42      */
43     function deposit(address token, uint256 amount)
44         external
45         payable
46         override
47         onlyVault
48         returns (bool)
49     {
50         if (token == address(0)) {
51             require(msg.value == amount, Error.INVALID_AMOUNT);
52             _balances[msg.sender][token] += msg.value;
53             return true;
54         }
55         uint256 balance = IERC20(token).balanceOf(address(this));
56         IERC20(token).safeTransferFrom(msg.sender, address(this), amount);
57         uint256 newBalance = IERC20(token).balanceOf(address(this));
58         uint256 received = newBalance - balance;
59         require(received >= amount, Error.INVALID_AMOUNT);
60         _balances[msg.sender][token] += received;
61         emit Deposit(msg.sender, token, amount);
62         return true;
63     }
64 
65     /**
66      * @notice Withdraw funds from vault reserve.
67      * @notice Only callable by a whitelisted vault.
68      * @param token Token to withdraw.
69      * @param amount Amount to withdraw.
70      * @return True if withdrawal was successful.
71      */
72     function withdraw(address token, uint256 amount) external override onlyVault returns (bool) {
73         require(canWithdraw(msg.sender), Error.RESERVE_ACCESS_EXCEEDED);
74         uint256 accountBalance = _balances[msg.sender][token];
75         require(accountBalance >= amount, Error.INSUFFICIENT_BALANCE);
76 
77         _balances[msg.sender][token] -= amount;
78         _lastWithdrawal[msg.sender] = block.timestamp;
79 
80         if (token == address(0)) {
81             payable(msg.sender).transfer(amount);
82         } else {
83             IERC20(token).safeTransfer(msg.sender, amount);
84         }
85         emit Withdraw(msg.sender, token, amount);
86         return true;
87     }
88 
89     /**
90      * @notice Check token balance of a specific vault.
91      * @param vault Vault to check balance of.
92      * @param token Token to check balance in.
93      * @return Token balance of vault.
94      */
95     function getBalance(address vault, address token) public view override returns (uint256) {
96         return _balances[vault][token];
97     }
98 
99     /**
100      * @notice returns true if the vault is allowed to withdraw from the reserve
101      */
102     function canWithdraw(address vault) public view returns (bool) {
103         return block.timestamp >= _lastWithdrawal[vault] + minWithdrawalDelay;
104     }
105 }
