1 // SPDX-License-Identifier: GPL-3.0-or-later
2 pragma solidity ^0.8.0;
3 
4 import "../PCVDeposit.sol";
5 import "./IBAMM.sol";
6 import "@openzeppelin/contracts/token/ERC20/utils/SafeERC20.sol";
7 import "@openzeppelin/contracts/utils/math/Math.sol";
8 
9 /// @title BAMMDeposit
10 /// @author Fei Protocol
11 /// @notice a contract to read manipulation resistant LUSD from BAMM
12 contract BAMMDeposit is PCVDeposit {
13     using SafeERC20 for IERC20;
14 
15     /// @notice B. Protocol BAMM address
16     IBAMM public constant BAMM = IBAMM(0x0d3AbAA7E088C2c82f54B2f47613DA438ea8C598);
17 
18     /// @notice Liquity Stability pool address
19     IStabilityPool public immutable stabilityPool = BAMM.SP();
20 
21     uint256 public constant PRECISION = 1e18;
22 
23     constructor(address core) CoreRef(core) {}
24 
25     receive() external payable {}
26 
27     /// @notice deposit into B Protocol BAMM
28     function deposit() external override whenNotPaused {
29         IERC20 lusd = IERC20(balanceReportedIn());
30         uint256 amount = lusd.balanceOf(address(this));
31 
32         lusd.safeApprove(address(BAMM), amount);
33         BAMM.deposit(amount);
34     }
35 
36     /// @notice withdraw LUSD from B Protocol BAMM
37     function withdraw(address to, uint256 amount) external override onlyPCVController {
38         uint256 totalSupply = BAMM.totalSupply();
39         uint256 lusdValue = stabilityPool.getCompoundedLUSDDeposit(address(BAMM));
40         uint256 shares = ((amount * totalSupply) / lusdValue) + 1; // extra unit to prevent truncation errors
41 
42         // Withdraw the LUSD from BAMM (also withdraws LQTY and dust ETH)
43         BAMM.withdraw(shares);
44 
45         IERC20(balanceReportedIn()).safeTransfer(to, amount);
46         emit Withdrawal(msg.sender, to, amount);
47     }
48 
49     /// @notice LUSD, the reported token for BAMM
50     function balanceReportedIn() public pure override returns (address) {
51         return address(0x5f98805A4E8be255a32880FDeC7F6728C6568bA0);
52     }
53 
54     /// @notice report LUSD balance of BAMM
55     // proportional amount of BAMM USD value held by this contract
56     function balance() public view override returns (uint256) {
57         uint256 ethBalance = stabilityPool.getDepositorETHGain(address(BAMM));
58 
59         uint256 eth2usdPrice = BAMM.fetchPrice();
60         require(eth2usdPrice != 0, "chainlink is down");
61 
62         uint256 ethUsdValue = (ethBalance * eth2usdPrice) / PRECISION;
63 
64         uint256 bammLusdValue = stabilityPool.getCompoundedLUSDDeposit(address(BAMM));
65         return ((bammLusdValue + ethUsdValue) * BAMM.balanceOf(address(this))) / BAMM.totalSupply();
66     }
67 
68     function claimRewards() public {
69         BAMM.withdraw(0); // Claim LQTY
70     }
71 }
