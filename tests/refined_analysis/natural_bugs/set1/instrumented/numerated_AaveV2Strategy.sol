1 // SPDX-License-Identifier: GPL-2.0-or-later
2 pragma solidity 0.8.10;
3 
4 /******************************************************************************\
5 * Author: Evert Kors <dev@sherlock.xyz> (https://twitter.com/evert0x)
6 * Sherlock Protocol: https://sherlock.xyz
7 /******************************************************************************/
8 
9 import './Manager.sol';
10 import '../interfaces/managers/IStrategyManager.sol';
11 
12 import '../interfaces/aaveV2/ILendingPool.sol';
13 import '../interfaces/aaveV2/ILendingPoolAddressesProvider.sol';
14 import '../interfaces/aaveV2/IAaveIncentivesController.sol';
15 import '../interfaces/aaveV2/IStakeAave.sol';
16 import '../interfaces/aaveV2/IAToken.sol';
17 
18 // This contract contains logic for depositing staker funds into Aave V2 as a yield strategy
19 
20 contract AaveV2Strategy is IStrategyManager, Manager {
21   using SafeERC20 for IERC20;
22 
23   // Need to call a provider because Aave has the ability to change the lending pool address
24   ILendingPoolAddressesProvider public constant LP_ADDRESS_PROVIDER =
25     ILendingPoolAddressesProvider(0xB53C1a33016B2DC2fF3653530bfF1848a515c8c5);
26 
27   // Aave contract that controls stkAAVE rewards
28   IAaveIncentivesController public immutable aaveIncentivesController;
29 
30   // This is the token being deposited (USDC)
31   IERC20 public immutable override want;
32   // This is the receipt token Aave gives in exchange for a token deposit (aUSDC)
33   IAToken public immutable aWant;
34 
35   // Address to receive stkAAVE rewards
36   address public immutable aaveLmReceiver;
37 
38   // Constructor takes the aUSDC address and the rewards receiver address (a Sherlock address) as args
39   constructor(IAToken _aWant, address _aaveLmReceiver) {
40     if (address(_aWant) == address(0)) revert ZeroArgument();
41     if (_aaveLmReceiver == address(0)) revert ZeroArgument();
42 
43     aWant = _aWant;
44     // This gets the underlying token associated with aUSDC (USDC)
45     want = IERC20(_aWant.UNDERLYING_ASSET_ADDRESS());
46     // Gets the specific rewards controller for this token type
47     aaveIncentivesController = _aWant.getIncentivesController();
48 
49     aaveLmReceiver = _aaveLmReceiver;
50   }
51 
52   // Returns the current Aave lending pool address that should be used
53   function getLp() internal view returns (ILendingPool) {
54     return ILendingPool(LP_ADDRESS_PROVIDER.getLendingPool());
55   }
56 
57   /// @notice Checks the aUSDC balance in this contract
58   function balanceOf() public view override returns (uint256) {
59     return aWant.balanceOf(address(this));
60   }
61 
62   /// @notice Deposits all USDC held in this contract into Aave's lending pool
63   function deposit() external override whenNotPaused {
64     ILendingPool lp = getLp();
65     // Checking the USDC balance of this contract
66     uint256 amount = want.balanceOf(address(this));
67     if (amount == 0) revert InvalidConditions();
68 
69     // If allowance for this contract is too low, approve the max allowance
70     if (want.allowance(address(this), address(lp)) < amount) {
71       want.safeIncreaseAllowance(address(lp), type(uint256).max);
72     }
73 
74     // Deposits the full balance of USDC held in this contract into Aave's lending pool
75     lp.deposit(address(want), amount, address(this), 0);
76   }
77 
78   /// @notice Withdraws all USDC from Aave's lending pool back into the Sherlock core contract
79   /// @dev Only callable by the Sherlock core contract
80   /// @return The final amount withdrawn
81   function withdrawAll() external override onlySherlockCore returns (uint256) {
82     ILendingPool lp = getLp();
83     if (balanceOf() == 0) {
84       return 0;
85     }
86     // Withdraws all USDC from Aave's lending pool and sends it to the Sherlock core contract (msg.sender)
87     return lp.withdraw(address(want), type(uint256).max, msg.sender);
88   }
89 
90   /// @notice Withdraws a specific amount of USDC from Aave's lending pool back into the Sherlock core contract
91   /// @param _amount Amount of USDC to withdraw
92   function withdraw(uint256 _amount) external override onlySherlockCore {
93     // Ensures that it doesn't execute a withdrawAll() call
94     // AAVE V2 uses uint256.max as a magic number to withdraw max amount
95     if (_amount == type(uint256).max) revert InvalidArgument();
96 
97     ILendingPool lp = getLp();
98     // Withdraws _amount of USDC and sends it to the Sherlock core contract
99     // If the amount withdrawn is not equal to _amount, it reverts
100     if (lp.withdraw(address(want), _amount, msg.sender) != _amount) revert InvalidConditions();
101   }
102 
103   // Claims the stkAAVE rewards and sends them to the receiver address
104   function claimRewards() external whenNotPaused {
105     // Creates an array with one slot
106     address[] memory assets = new address[](1);
107     // Sets the slot equal to the address of aUSDC
108     assets[0] = address(aWant);
109 
110     // Claims all the rewards on aUSDC and sends them to the aaveLmReceiver (an address controlled by governance)
111     // Tokens are NOT meant to be (directly) distributed to stakers.
112     aaveIncentivesController.claimRewards(assets, type(uint256).max, aaveLmReceiver);
113   }
114 
115   /// @notice Function used to check if this is the current active yield strategy
116   /// @return Boolean indicating it's active
117   /// @dev If inactive the owner can pull all ERC20s and ETH
118   /// @dev Will be checked by calling the sherlock contract
119   function isActive() public view returns (bool) {
120     return address(sherlockCore.yieldStrategy()) == address(this);
121   }
122 
123   // Only contract owner can call this
124   // Sends all specified tokens in this contract to the receiver's address (as well as ETH)
125   function sweep(address _receiver, IERC20[] memory _extraTokens) external onlyOwner {
126     if (_receiver == address(0)) revert ZeroArgument();
127     // This contract must NOT be the current assigned yield strategy contract
128     if (isActive()) revert InvalidConditions();
129     // Executes the sweep for ERC-20s specified in _extraTokens as well as for ETH
130     _sweep(_receiver, _extraTokens);
131   }
132 }
