1 // SPDX-License-Identifier: GPL-3.0-or-later
2 pragma solidity ^0.8.4;
3 
4 import "@openzeppelin/contracts/proxy/utils/Initializable.sol";
5 import "./Permissions.sol";
6 import "./ICore.sol";
7 import "../fei/Fei.sol";
8 import "../tribe/Tribe.sol";
9 
10 /// @title Source of truth for Fei Protocol
11 /// @author Fei Protocol
12 /// @notice maintains roles, access control, fei, tribe, genesisGroup, and the TRIBE treasury
13 contract Core is ICore, Permissions, Initializable {
14     /// @notice the address of the FEI contract
15     IFei public override fei;
16 
17     /// @notice the address of the TRIBE contract
18     IERC20 public override tribe;
19 
20     function init() external override initializer {
21         _setupGovernor(msg.sender);
22 
23         Fei _fei = new Fei(address(this));
24         _setFei(address(_fei));
25 
26         Tribe _tribe = new Tribe(address(this), msg.sender);
27         _setTribe(address(_tribe));
28     }
29 
30     /// @notice sets Fei address to a new address
31     /// @param token new fei address
32     function setFei(address token) external override onlyGovernor {
33         _setFei(token);
34     }
35 
36     /// @notice sets Tribe address to a new address
37     /// @param token new tribe address
38     function setTribe(address token) external override onlyGovernor {
39         _setTribe(token);
40     }
41 
42     /// @notice sends TRIBE tokens from treasury to an address
43     /// @param to the address to send TRIBE to
44     /// @param amount the amount of TRIBE to send
45     function allocateTribe(address to, uint256 amount) external override onlyGovernor {
46         IERC20 _tribe = tribe;
47         require(_tribe.balanceOf(address(this)) >= amount, "Core: Not enough Tribe");
48 
49         _tribe.transfer(to, amount);
50 
51         emit TribeAllocation(to, amount);
52     }
53 
54     function _setFei(address token) internal {
55         fei = IFei(token);
56         emit FeiUpdate(token);
57     }
58 
59     function _setTribe(address token) internal {
60         tribe = IERC20(token);
61         emit TribeUpdate(token);
62     }
63 }
