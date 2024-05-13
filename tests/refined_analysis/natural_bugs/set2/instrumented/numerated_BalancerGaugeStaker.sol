1 // SPDX-License-Identifier: GPL-3.0-or-later
2 pragma solidity ^0.8.0;
3 
4 import "../pcv/PCVDeposit.sol";
5 import "./utils/LiquidityGaugeManager.sol";
6 import "../external/balancer/IBalancerMinter.sol";
7 import "@openzeppelin/contracts/token/ERC20/utils/SafeERC20.sol";
8 
9 /// @title Deposit that can stake in Balancer gauges
10 /// @author Fei Protocol
11 contract BalancerGaugeStaker is PCVDeposit, LiquidityGaugeManager {
12     using SafeERC20 for IERC20;
13 
14     event BalancerMinterChanged(address indexed oldMinter, address indexed newMinter);
15 
16     address private constant BAL = 0xba100000625a3754423978a60c9317c58a424e3D;
17 
18     address public balancerMinter;
19 
20     /// @notice Balancer gauge staker
21     /// @param _core Fei Core for reference
22     constructor(
23         address _core,
24         address _gaugeController,
25         address _balancerMinter
26     ) CoreRef(_core) LiquidityGaugeManager(_gaugeController) {
27         balancerMinter = _balancerMinter;
28     }
29 
30     function initialize(
31         address _core,
32         address _gaugeController,
33         address _balancerMinter
34     ) external {
35         require(gaugeController == address(0), "BalancerGaugeStaker: initialized");
36         CoreRef._initialize(_core);
37         gaugeController = _gaugeController;
38         balancerMinter = _balancerMinter;
39     }
40 
41     /// @notice Set the balancer minter used to mint BAL
42     /// @param newMinter the new minter address
43     function setBalancerMinter(address newMinter) public onlyTribeRole(TribeRoles.METAGOVERNANCE_GAUGE_ADMIN) {
44         address currentMinter = balancerMinter; // cache to save 1 sload
45         require(currentMinter != newMinter, "BalancerGaugeStaker: same minter");
46 
47         emit BalancerMinterChanged(currentMinter, newMinter);
48         balancerMinter = newMinter;
49     }
50 
51     /// @notice returns total balance of PCV in the Deposit
52     function balance() public view override returns (uint256) {
53         return IERC20(BAL).balanceOf(address(this));
54     }
55 
56     /// @notice gets the token address in which this deposit returns its balance
57     function balanceReportedIn() public view virtual override returns (address) {
58         return BAL;
59     }
60 
61     /// @notice gets the resistant token balance and protocol owned fei of this deposit
62     function resistantBalanceAndFei() public view virtual override returns (uint256, uint256) {
63         return (balance(), 0);
64     }
65 
66     /// @notice noop
67     function deposit() external override {}
68 
69     /// @notice withdraw BAL held to another address
70     /// the BAL rewards accrue on this PCVDeposit when Gauge rewards are claimed.
71     function withdraw(address to, uint256 amount) public override onlyPCVController whenNotPaused {
72         IERC20(BAL).safeTransfer(to, amount);
73         emit Withdrawal(msg.sender, to, amount);
74     }
75 
76     /// @notice Mint everything which belongs to this contract in the given gauge
77     /// @param token whose gauge should be claimed
78     function mintGaugeRewards(address token) external whenNotPaused returns (uint256) {
79         // fetch gauge address from internal mapping to avoid this permissionless
80         // call to mint on any arbitrary gauge.
81         address gaugeAddress = tokenToGauge[token];
82         require(gaugeAddress != address(0), "BalancerGaugeStaker: token has no gauge configured");
83 
84         // emit the Deposit event because accounting is performed in BAL
85         // and that is what is claimed from the minter.
86         uint256 minted = IBalancerMinter(balancerMinter).mint(gaugeAddress);
87         emit Deposit(msg.sender, minted);
88 
89         return minted;
90     }
91 }
