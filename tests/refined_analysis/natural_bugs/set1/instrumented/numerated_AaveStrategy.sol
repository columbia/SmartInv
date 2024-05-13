1 // SPDX-License-Identifier: GPL-2.0-or-later
2 pragma solidity 0.8.10;
3 
4 /******************************************************************************\
5 * Author: Evert Kors <dev@sherlock.xyz> (https://twitter.com/evert0x)
6 * Sherlock Protocol: https://sherlock.xyz
7 /******************************************************************************/
8 
9 import './base/BaseStrategy.sol';
10 
11 import '../interfaces/aaveV2/ILendingPool.sol';
12 import '../interfaces/aaveV2/ILendingPoolAddressesProvider.sol';
13 import '../interfaces/aaveV2/IAaveIncentivesController.sol';
14 import '../interfaces/aaveV2/IStakeAave.sol';
15 import '../interfaces/aaveV2/IAToken.sol';
16 
17 // This contract contains logic for depositing staker funds into Aave as a yield strategy
18 
19 contract AaveStrategy is BaseStrategy {
20   using SafeERC20 for IERC20;
21 
22   // Need to call a provider because Aave has the ability to change the lending pool address
23   ILendingPoolAddressesProvider public constant LP_ADDRESS_PROVIDER =
24     ILendingPoolAddressesProvider(0xB53C1a33016B2DC2fF3653530bfF1848a515c8c5);
25 
26   // Aave contract that controls stkAAVE rewards
27   IAaveIncentivesController public immutable aaveIncentivesController;
28 
29   // This is the receipt token Aave gives in exchange for a token deposit (aUSDC)
30   IAToken public immutable aWant;
31 
32   // Address to receive stkAAVE rewards
33   address public immutable aaveLmReceiver;
34 
35   // Constructor takes the aUSDC address and the rewards receiver address (a Sherlock address) as args
36   /// @param _initialParent Contract that will be the parent in the tree structure
37   /// @param _aWant aUSDC addresss
38   /// @param _aaveLmReceiver Receiving address of the stkAAVE tokens earned by staking
39   constructor(
40     IMaster _initialParent,
41     IAToken _aWant,
42     address _aaveLmReceiver
43   ) BaseNode(_initialParent) {
44     if (address(_aWant) == address(0)) revert ZeroArg();
45     if (_aaveLmReceiver == address(0)) revert ZeroArg();
46 
47     aWant = _aWant;
48     // Gets the specific rewards controller for this token type
49     aaveIncentivesController = _aWant.getIncentivesController();
50 
51     aaveLmReceiver = _aaveLmReceiver;
52   }
53 
54   /// @notice Signal if strategy is ready to be used
55   /// @return Boolean indicating if strategy is ready
56   function setupCompleted() external view override returns (bool) {
57     return true;
58   }
59 
60   /// @return The current Aave lending pool address that should be used
61   function getLp() internal view returns (ILendingPool) {
62     return ILendingPool(LP_ADDRESS_PROVIDER.getLendingPool());
63   }
64 
65   /// @notice View the current balance of this strategy in USDC
66   /// @dev Will return wrong balance if this contract somehow has USDC instead of only aUSDC
67   /// @return Amount of USDC in this strategy
68   function _balanceOf() internal view override returns (uint256) {
69     // 1 aUSDC = 1 USDC
70     return aWant.balanceOf(address(this));
71   }
72 
73   /// @notice Deposits all USDC held in this contract into Aave's lending pool
74   /// @notice Works under the assumption this contract contains USDC
75   function _deposit() internal override whenNotPaused {
76     ILendingPool lp = getLp();
77     // Checking the USDC balance of this contract
78     uint256 amount = want.balanceOf(address(this));
79     if (amount == 0) revert InvalidState();
80 
81     // If allowance for this contract is too low, approve the max allowance
82     // Will occur if the `lp` address changes
83     if (want.allowance(address(this), address(lp)) < amount) {
84       // `safeIncreaseAllowance` can fail if it adds `type(uint256).max` to a non-zero value
85       // This is very unlikely as we have to have an ungodly amount of USDC pass this system for
86       // The allowance to reach a human interpretable number
87       want.safeIncreaseAllowance(address(lp), type(uint256).max);
88     }
89 
90     // Deposits the full balance of USDC held in this contract into Aave's lending pool
91     lp.deposit(address(want), amount, address(this), 0);
92   }
93 
94   /// @notice Withdraws all USDC from Aave's lending pool back into core
95   /// @return Amount of USDC withdrawn
96   function _withdrawAll() internal override returns (uint256) {
97     ILendingPool lp = getLp();
98     if (_balanceOf() == 0) {
99       return 0;
100     }
101     // Withdraws all USDC from Aave's lending pool and sends it to core
102     return lp.withdraw(address(want), type(uint256).max, core);
103   }
104 
105   /// @notice Withdraws a specific amount of USDC from Aave's lending pool back into core
106   /// @param _amount Amount of USDC to withdraw
107   function _withdraw(uint256 _amount) internal override {
108     // Ensures that it doesn't execute a withdrawAll() call
109     // AAVE uses uint256.max as a magic number to withdraw max amount
110     if (_amount == type(uint256).max) revert InvalidArg();
111 
112     ILendingPool lp = getLp();
113     // Withdraws _amount of USDC and sends it to core
114     // If the amount withdrawn is not equal to _amount, it reverts
115     if (lp.withdraw(address(want), _amount, core) != _amount) revert InvalidState();
116   }
117 
118   // Claims the stkAAVE rewards and sends them to the receiver address
119   function claimReward() external {
120     // Creates an array with one slot
121     address[] memory assets = new address[](1);
122     // Sets the slot equal to the address of aUSDC
123     assets[0] = address(aWant);
124 
125     // Claims all the rewards on aUSDC and sends them to the aaveLmReceiver (an address controlled by governance)
126     // Tokens are NOT meant to be (directly) distributed to stakers.
127     aaveIncentivesController.claimRewards(assets, type(uint256).max, aaveLmReceiver);
128   }
129 }
