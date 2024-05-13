1 // SPDX-License-Identifier: MIT
2 pragma solidity 0.8.9;
3 
4 /*
5 Rewrite of Convex Finance's Vested Escrow
6 found at https://github.com/convex-eth/platform/blob/main/contracts/contracts/VestedEscrow.sol
7 Changes:
8 - remove safe math (default from Solidity >=0.8)
9 - remove claim and stake logic
10 - remove safeTransferFrom logic and add support for "airdropped" reward token
11 - add revoke logic to allow admin to stop vesting for a recipient
12 */
13 
14 import "@openzeppelin/contracts/token/ERC20/IERC20.sol";
15 import "@openzeppelin/contracts/token/ERC20/utils/SafeERC20.sol";
16 import "@openzeppelin/contracts/utils/math/Math.sol";
17 import "@openzeppelin/contracts/security/ReentrancyGuard.sol";
18 
19 import "../../libraries/Errors.sol";
20 
21 import "./VestedEscrow.sol";
22 
23 contract VestedEscrowRevocable is VestedEscrow {
24     using SafeERC20 for IERC20;
25 
26     address public immutable treasury;
27 
28     uint256 private _vestedBefore;
29 
30     mapping(address => uint256) public revokedTime;
31 
32     event Revoked(address indexed user, uint256 revokedAmount);
33 
34     constructor(
35         address rewardToken_,
36         uint256 starttime_,
37         uint256 endtime_,
38         address fundAdmin_,
39         address treasury_
40     ) VestedEscrow(rewardToken_, starttime_, endtime_, fundAdmin_) {
41         treasury = treasury_;
42         holdingContract[treasury_] = address(new EscrowTokenHolder(rewardToken_));
43     }
44 
45     function claim() external override {
46         claim(msg.sender);
47     }
48 
49     function revoke(address _recipient) external returns (bool) {
50         require(msg.sender == admin, Error.UNAUTHORIZED_ACCESS);
51         require(revokedTime[_recipient] == 0, "Recipient already revoked");
52         require(_recipient != treasury, "Treasury cannot be revoked!");
53         revokedTime[_recipient] = block.timestamp;
54         uint256 vested = _totalVestedOf(_recipient, block.timestamp);
55 
56         uint256 initialAmount = initialLocked[_recipient];
57         uint256 revokedAmount = initialAmount - vested;
58         rewardToken.safeTransferFrom(
59             holdingContract[_recipient],
60             holdingContract[treasury],
61             revokedAmount
62         );
63         initialLocked[treasury] += initialAmount;
64         totalClaimed[treasury] += vested;
65         _vestedBefore += vested;
66         emit Revoked(_recipient, revokedAmount);
67         return true;
68     }
69 
70     function vestedOf(address _recipient) external view override returns (uint256) {
71         if (_recipient == treasury) {
72             return _totalVestedOf(_recipient, block.timestamp) - _vestedBefore;
73         }
74 
75         uint256 timeRevoked = revokedTime[_recipient];
76         if (timeRevoked != 0) {
77             return _totalVestedOf(_recipient, timeRevoked);
78         }
79         return _totalVestedOf(_recipient, block.timestamp);
80     }
81 
82     function balanceOf(address _recipient) external view override returns (uint256) {
83         uint256 timestamp = block.timestamp;
84         uint256 timeRevoked = revokedTime[_recipient];
85         if (timeRevoked != 0) {
86             timestamp = timeRevoked;
87         }
88         return _balanceOf(_recipient, timestamp);
89     }
90 
91     function lockedOf(address _recipient) external view override returns (uint256) {
92         if (revokedTime[_recipient] != 0) {
93             return 0;
94         }
95         uint256 vested = _totalVestedOf(_recipient, block.timestamp);
96         return initialLocked[_recipient] - vested;
97     }
98 
99     function claim(address _recipient) public override nonReentrant {
100         uint256 timestamp = block.timestamp;
101         if (revokedTime[msg.sender] != 0) {
102             timestamp = revokedTime[msg.sender];
103         }
104         _claimUntil(_recipient, timestamp);
105     }
106 }
