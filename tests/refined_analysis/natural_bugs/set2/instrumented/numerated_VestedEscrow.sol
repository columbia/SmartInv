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
11 */
12 
13 import "@openzeppelin/contracts/token/ERC20/IERC20.sol";
14 import "@openzeppelin/contracts/token/ERC20/utils/SafeERC20.sol";
15 import "@openzeppelin/contracts/utils/math/Math.sol";
16 import "@openzeppelin/contracts/security/ReentrancyGuard.sol";
17 
18 import "../../libraries/Errors.sol";
19 
20 contract EscrowTokenHolder {
21     constructor(address rewardToken_) {
22         IERC20(rewardToken_).approve(msg.sender, type(uint256).max);
23     }
24 }
25 
26 contract VestedEscrow is ReentrancyGuard {
27     using SafeERC20 for IERC20;
28 
29     struct FundingAmount {
30         address recipient;
31         uint256 amount;
32     }
33 
34     IERC20 public immutable rewardToken;
35     address public admin;
36     address public fundAdmin;
37 
38     uint256 public immutable startTime;
39     uint256 public immutable endTime;
40     uint256 public totalTime;
41     uint256 public initialLockedSupply;
42     uint256 public unallocatedSupply;
43     bool public initializedSupply;
44 
45     mapping(address => uint256) public initialLocked;
46     mapping(address => uint256) public totalClaimed;
47     mapping(address => address) public holdingContract;
48 
49     event Fund(address indexed recipient, uint256 reward);
50     event Claim(address indexed user, uint256 amount);
51 
52     constructor(
53         address rewardToken_,
54         uint256 starttime_,
55         uint256 endtime_,
56         address fundAdmin_
57     ) {
58         require(starttime_ >= block.timestamp, "start must be future");
59         require(endtime_ > starttime_, "end must be greater");
60 
61         rewardToken = IERC20(rewardToken_);
62         startTime = starttime_;
63         endTime = endtime_;
64         totalTime = endtime_ - starttime_;
65         admin = msg.sender;
66         fundAdmin = fundAdmin_;
67     }
68 
69     function setAdmin(address _admin) external {
70         require(msg.sender == admin, Error.UNAUTHORIZED_ACCESS);
71         admin = _admin;
72     }
73 
74     function setFundAdmin(address _fundadmin) external {
75         require(msg.sender == admin, Error.UNAUTHORIZED_ACCESS);
76         fundAdmin = _fundadmin;
77     }
78 
79     function initializeUnallocatedSupply() external returns (bool) {
80         require(msg.sender == admin, Error.UNAUTHORIZED_ACCESS);
81         require(!initializedSupply, "Supply already initialized once");
82         unallocatedSupply = rewardToken.balanceOf(address(this));
83         require(unallocatedSupply > 0, "No reward tokens in contract");
84         initializedSupply = true;
85         return true;
86     }
87 
88     function fund(FundingAmount[] calldata amounts) external nonReentrant returns (bool) {
89         require(msg.sender == fundAdmin || msg.sender == admin, Error.UNAUTHORIZED_ACCESS);
90         require(initializedSupply, "Supply must be initialized");
91 
92         uint256 totalAmount = 0;
93         for (uint256 i = 0; i < amounts.length; i++) {
94             uint256 amount = amounts[i].amount;
95             address holdingAddress = holdingContract[amounts[i].recipient];
96             if (holdingAddress == address(0)) {
97                 holdingAddress = address(new EscrowTokenHolder(address(rewardToken)));
98                 holdingContract[amounts[i].recipient] = holdingAddress;
99             }
100             rewardToken.safeTransfer(holdingAddress, amount);
101             initialLocked[amounts[i].recipient] = initialLocked[amounts[i].recipient] + amount;
102             totalAmount = totalAmount + amount;
103             emit Fund(amounts[i].recipient, amount);
104         }
105 
106         initialLockedSupply = initialLockedSupply + totalAmount;
107         unallocatedSupply = unallocatedSupply - totalAmount;
108         return true;
109     }
110 
111     function claim() external virtual {
112         _claimUntil(msg.sender, block.timestamp);
113     }
114 
115     function vestedSupply() external view returns (uint256) {
116         return _totalVested();
117     }
118 
119     function lockedSupply() external view returns (uint256) {
120         return initialLockedSupply - _totalVested();
121     }
122 
123     function vestedOf(address _recipient) external view virtual returns (uint256) {
124         return _totalVestedOf(_recipient, block.timestamp);
125     }
126 
127     function balanceOf(address _recipient) external view virtual returns (uint256) {
128         return _balanceOf(_recipient, block.timestamp);
129     }
130 
131     function lockedOf(address _recipient) external view virtual returns (uint256) {
132         uint256 vested = _totalVestedOf(_recipient, block.timestamp);
133         return initialLocked[_recipient] - vested;
134     }
135 
136     function claim(address _recipient) public virtual nonReentrant {
137         _claimUntil(_recipient, block.timestamp);
138     }
139 
140     function _claimUntil(address _recipient, uint256 _time) internal {
141         uint256 claimable = _balanceOf(msg.sender, _time);
142         if (claimable == 0) return;
143         totalClaimed[msg.sender] = totalClaimed[msg.sender] + claimable;
144         rewardToken.safeTransferFrom(holdingContract[msg.sender], _recipient, claimable);
145 
146         emit Claim(msg.sender, claimable);
147     }
148 
149     function _computeVestedAmount(uint256 locked, uint256 _time) internal view returns (uint256) {
150         if (_time < startTime) {
151             return 0;
152         }
153         uint256 elapsed = _time - startTime;
154         return Math.min((locked * elapsed) / totalTime, locked);
155     }
156 
157     function _totalVestedOf(address _recipient, uint256 _time) internal view returns (uint256) {
158         return _computeVestedAmount(initialLocked[_recipient], _time);
159     }
160 
161     function _totalVested() internal view returns (uint256) {
162         return _computeVestedAmount(initialLockedSupply, block.timestamp);
163     }
164 
165     function _balanceOf(address _recipient, uint256 _time) internal view returns (uint256) {
166         uint256 vested = _totalVestedOf(_recipient, _time);
167         return vested - totalClaimed[_recipient];
168     }
169 }
