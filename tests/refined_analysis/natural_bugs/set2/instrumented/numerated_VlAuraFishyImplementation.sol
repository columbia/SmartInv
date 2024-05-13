1 // SPDX-License-Identifier: GPL-3.0-or-later
2 pragma solidity ^0.8.0;
3 
4 import "./IAuraLocker.sol";
5 import "@openzeppelin/contracts/token/ERC20/IERC20.sol";
6 import "@openzeppelin/contracts/token/ERC20/extensions/ERC20Votes.sol";
7 
8 // Hidden Hand Aura bribe contract
9 interface IAuraBribe {
10     function setRewardForwarding(address to) external;
11 
12     function getBribe(
13         bytes32 proposal,
14         uint256 proposalDeadline,
15         address token
16     ) external view returns (address bribeToken, uint256 bribeAmount);
17 }
18 
19 /// @author eswak
20 contract VlAuraFishyImplementation {
21     address public constant AURA = 0xC0c293ce456fF0ED870ADd98a0828Dd4d2903DBF;
22     address public constant VLAURA = 0x3Fa73f1E5d8A792C80F426fc8F84FBF7Ce9bBCAC;
23 
24     // TODO: Update this before deploying, Fishy.
25     address public constant OWNER = 0x6ef71cA9cD708883E129559F5edBFb9d9D5C6148;
26 
27     modifier onlyOwner() {
28         require(msg.sender == OWNER, "!OWNER");
29         _;
30     }
31 
32     /// @notice delegate vlAURA voting power to an address
33     function delegate(address delegatee) external onlyOwner {
34         ERC20Votes(VLAURA).delegate(delegatee);
35     }
36 
37     /// @notice returns the balance of locked + unlocked AURA
38     function balances() external view returns (uint256 balanceLocked, uint256 balanceUnlocked) {
39         balanceLocked = IERC20(VLAURA).balanceOf(address(this));
40         balanceUnlocked = IERC20(AURA).balanceOf(address(this));
41         return (balanceLocked, balanceUnlocked);
42     }
43 
44     /// @notice exit lock after it has expired
45     function unlock() external onlyOwner {
46         IAuraLocker(VLAURA).processExpiredLocks(false);
47     }
48 
49     /// @notice emergency withdraw if system is shut down
50     function emergencyWithdraw() external onlyOwner {
51         IAuraLocker(VLAURA).emergencyWithdraw();
52     }
53 
54     /// @notice get rewards & stake them (rewards claiming is permissionless)
55     function getReward() external {
56         IAuraLocker(VLAURA).getReward(address(this), true);
57     }
58 
59     /// @notice withdraw ERC20 from the contract
60     function sweep(
61         address token,
62         address to,
63         uint256 amount
64     ) external onlyOwner {
65         IERC20(token).transfer(to, amount);
66     }
67 
68     /// @notice forward rewards to an eoa on Hidden Hand
69     function setRewardForwarding(address briber, address to) external onlyOwner {
70         // note: briber for aura is currently 0x642c59937A62cf7dc92F70Fd78A13cEe0aa2Bd9c
71         IAuraBribe(briber).setRewardForwarding(to);
72     }
73 
74     /// @notice arbitrary call
75     function call(
76         address to,
77         uint256 value,
78         bytes calldata data
79     ) external onlyOwner {
80         (bool success, ) = payable(to).call{value: value}(data);
81         require(success, "Error in external call");
82     }
83 }
