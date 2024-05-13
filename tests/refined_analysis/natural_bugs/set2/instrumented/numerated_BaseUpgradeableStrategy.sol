1 // SPDX-License-Identifier: MIT
2 
3 pragma solidity 0.6.12;
4 
5 import "@openzeppelin/contracts-upgradeable/proxy/Initializable.sol";
6 import "./BaseUpgradeableStrategyStorage.sol";
7 import "../inheritance/ControllableInit.sol";
8 import "../interface/IController.sol";
9 import "@pancakeswap/pancake-swap-lib/contracts/token/BEP20/IBEP20.sol";
10 import "@pancakeswap/pancake-swap-lib/contracts/math/SafeMath.sol";
11 import "@pancakeswap/pancake-swap-lib/contracts/token/BEP20/SafeBEP20.sol";
12 
13 contract BaseUpgradeableStrategy is Initializable, ControllableInit, BaseUpgradeableStrategyStorage {
14   using SafeMath for uint256;
15   using SafeBEP20 for IBEP20;
16 
17   event ProfitsNotCollected(bool sell, bool floor);
18   event ProfitLogInReward(uint256 profitAmount, uint256 feeAmount, uint256 timestamp);
19 
20   modifier restricted() {
21     require(msg.sender == vault() || msg.sender == controller()
22       || msg.sender == governance(),
23       "The sender has to be the controller, governance, or vault");
24     _;
25   }
26 
27   // This is only used in `investAllUnderlying()`
28   // The user can still freely withdraw from the strategy
29   modifier onlyNotPausedInvesting() {
30     require(!pausedInvesting(), "Action blocked as the strategy is in emergency state");
31     _;
32   }
33 
34   constructor() public BaseUpgradeableStrategyStorage() {
35   }
36 
37   function initialize(
38     address _storage,
39     address _underlying,
40     address _vault,
41     address _rewardPool,
42     address _rewardToken,
43     uint256 _profitSharingNumerator,
44     uint256 _profitSharingDenominator,
45     bool _sell,
46     uint256 _sellFloor,
47     uint256 _implementationChangeDelay
48   ) public initializer {
49     ControllableInit.initialize(
50       _storage
51     );
52     _setUnderlying(_underlying);
53     _setVault(_vault);
54     _setRewardPool(_rewardPool);
55     _setRewardToken(_rewardToken);
56     _setProfitSharingNumerator(_profitSharingNumerator);
57     _setProfitSharingDenominator(_profitSharingDenominator);
58 
59     _setSell(_sell);
60     _setSellFloor(_sellFloor);
61     _setNextImplementationDelay(_implementationChangeDelay);
62     _setPausedInvesting(false);
63   }
64 
65   /**
66   * Schedules an upgrade for this vault's proxy.
67   */
68   function scheduleUpgrade(address impl) public onlyGovernance {
69     _setNextImplementation(impl);
70     _setNextImplementationTimestamp(block.timestamp.add(nextImplementationDelay()));
71   }
72 
73   function _finalizeUpgrade() internal {
74     _setNextImplementation(address(0));
75     _setNextImplementationTimestamp(0);
76   }
77 
78   function shouldUpgrade() external view returns (bool, address) {
79     return (
80       nextImplementationTimestamp() != 0
81         && block.timestamp > nextImplementationTimestamp()
82         && nextImplementation() != address(0),
83       nextImplementation()
84     );
85   }
86 
87   // reward notification
88 
89   function notifyProfitInRewardToken(uint256 _rewardBalance) internal {
90     if( _rewardBalance > 0 ){
91       uint256 feeAmount = _rewardBalance.mul(profitSharingNumerator()).div(profitSharingDenominator());
92       emit ProfitLogInReward(_rewardBalance, feeAmount, block.timestamp);
93       IBEP20(rewardToken()).safeApprove(controller(), 0);
94       IBEP20(rewardToken()).safeApprove(controller(), feeAmount);
95 
96       IController(controller()).notifyFee(
97         rewardToken(),
98         feeAmount
99       );
100     } else {
101       emit ProfitLogInReward(0, 0, block.timestamp);
102     }
103   }
104 }
