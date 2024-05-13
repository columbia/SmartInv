1 // SPDX-License-Identifier: GPL-3.0-or-later
2 pragma solidity ^0.8.4;
3 
4 import "@openzeppelin/contracts/token/ERC20/utils/SafeERC20.sol";
5 import "./MockERC20.sol";
6 import "./MockAnglePoolManager.sol";
7 
8 contract MockAngleStableMaster {
9     using SafeERC20 for IERC20;
10 
11     MockERC20 public agToken;
12     uint256 public usdPerAgToken;
13     uint256 public feeBp = 30; // 0.3% fee
14 
15     constructor(MockERC20 _agToken, uint256 _usdPerAgToken) {
16         agToken = _agToken;
17         usdPerAgToken = _usdPerAgToken;
18     }
19 
20     function setFee(uint256 _fee) public {
21         feeBp = _fee;
22     }
23 
24     function mint(
25         uint256 amount,
26         address user,
27         address poolManager,
28         uint256 minStableAmount
29     ) external {
30         uint256 amountAfterFee = (amount * (10_000 - feeBp)) / (usdPerAgToken * 10_000);
31         require(amountAfterFee >= minStableAmount, "15");
32         // in reality, assets should go to the poolManager, but for this mock purpose, tokens
33         // are held on the stablemaster
34         IERC20(MockAnglePoolManager(poolManager).token()).safeTransferFrom(msg.sender, address(this), amount);
35         agToken.mint(user, amountAfterFee);
36     }
37 
38     function burn(
39         uint256 amount,
40         address burner,
41         address dest,
42         address poolManager,
43         uint256 minCollatAmount
44     ) external {
45         uint256 amountAfterFee = (amount * usdPerAgToken * (10_000 - feeBp)) / 10_000;
46         require(amountAfterFee >= minCollatAmount, "15");
47         IERC20(MockAnglePoolManager(poolManager).token()).transfer(dest, amountAfterFee);
48         agToken.mockBurn(burner, amount);
49     }
50 }
