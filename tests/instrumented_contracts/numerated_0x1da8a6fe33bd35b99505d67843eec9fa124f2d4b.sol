1 // SPDX-License-Identifier: MIT
2 pragma solidity 0.8.6;
3 
4 library Math {
5     function min(uint256 a, uint256 b) internal pure returns (uint256) {
6         return a < b ? a : b;
7     }
8 }
9 
10 interface erc20 {
11     function transfer(address recipient, uint256 amount) external returns (bool);
12     function decimals() external view returns (uint8);
13     function balanceOf(address) external view returns (uint);
14     function transferFrom(address sender, address recipient, uint256 amount) external returns (bool);
15     function approve(address spender, uint value) external returns (bool);
16 }
17 
18 interface ve {
19     function locked__end(address) external view returns (uint);
20     function deposit_for(address, uint) external;
21 }
22 
23 contract distribution {
24     address constant _ibff = 0xb347132eFf18a3f63426f4988ef626d2CbE274F5;
25     address constant _ibeurlp = 0xa2D81bEdf22201A77044CDF3Ab4d9dC1FfBc391B;
26     address constant _veibff = 0x4D0518C9136025903751209dDDdf6C67067357b1;
27     address constant _vedist = 0x83893c4A42F8654c2dd4FF7b4a7cd0e33ae8C859;
28     
29     uint constant DURATION = 7 days;
30     uint constant PRECISION = 10 ** 18;
31     uint constant MAXTIME = 4 * 365 * 86400;
32     
33     uint rewardRate;
34     uint periodFinish;
35     uint lastUpdateTime;
36     uint rewardPerTokenStored;
37     
38     mapping(address => uint256) public userRewardPerTokenPaid;
39     mapping(address => uint256) public rewards;
40     
41     uint public totalSupply;
42     mapping(address => uint) public balanceOf;
43 
44     function lastTimeRewardApplicable() public view returns (uint) {
45         return Math.min(block.timestamp, periodFinish);
46     }
47 
48     function rewardPerToken() public view returns (uint) {
49         if (totalSupply == 0) {
50             return rewardPerTokenStored;
51         }
52         return rewardPerTokenStored + ((lastTimeRewardApplicable() - lastUpdateTime) * rewardRate * PRECISION / totalSupply);
53     }
54 
55     function earned(address account) public view returns (uint) {
56         return (balanceOf[account] * (rewardPerToken() - userRewardPerTokenPaid[account]) / PRECISION) + rewards[account];
57     }
58 
59     function getRewardForDuration() external view returns (uint) {
60         return rewardRate * DURATION;
61     }
62 
63     function deposit(uint amount) external update(msg.sender) {
64         totalSupply += amount;
65         balanceOf[msg.sender] += amount;
66         safeTransferFrom(_ibeurlp, amount);
67     }
68 
69     function withdraw(uint amount) public update(msg.sender) {
70         totalSupply -= amount;
71         balanceOf[msg.sender] -= amount;
72         safeTransfer(_ibeurlp, msg.sender, amount);
73     }
74 
75     function getReward() public update(msg.sender) {
76         uint _reward = rewards[msg.sender];
77         uint _user_lock = ve(_veibff).locked__end(msg.sender);
78         uint _adj = Math.min(_reward * _user_lock / (block.timestamp + MAXTIME), _reward);
79         if (_adj > 0) {
80             rewards[msg.sender] = 0;
81             erc20(_ibff).approve(_veibff, _adj);
82             safeTransfer(_ibff, msg.sender, _adj);
83             ve(_veibff).deposit_for(msg.sender, _adj);
84             safeTransfer(_ibff, _vedist, _reward - _adj);
85         }
86     }
87 
88     function exit() external {
89         withdraw(balanceOf[msg.sender]);
90         getReward();
91     }
92     
93     function notify(uint amount) external update(address(0)) {
94         safeTransferFrom(_ibff, amount);
95         if (block.timestamp >= periodFinish) {
96             rewardRate = amount / DURATION;
97         } else {
98             uint _remaining = periodFinish - block.timestamp;
99             uint _leftover = _remaining * rewardRate;
100             rewardRate = (amount + _leftover) / DURATION;
101         }
102         
103         lastUpdateTime = block.timestamp;
104         periodFinish = block.timestamp + DURATION;
105     }
106 
107     modifier update(address account) {
108         rewardPerTokenStored = rewardPerToken();
109         lastUpdateTime = lastTimeRewardApplicable();
110         if (account != address(0)) {
111             rewards[account] = earned(account);
112             userRewardPerTokenPaid[account] = rewardPerTokenStored;
113         }
114         _;
115     }
116     
117     function safeTransfer(
118         address token,
119         address to,
120         uint256 value
121     ) internal {
122         (bool success, bytes memory data) =
123             token.call(abi.encodeWithSelector(erc20.transfer.selector, to, value));
124         require(success && (data.length == 0 || abi.decode(data, (bool))));
125     }
126     
127     function safeTransferFrom(address token, uint256 value) internal {
128         (bool success, bytes memory data) =
129             token.call(abi.encodeWithSelector(erc20.transferFrom.selector, msg.sender, address(this), value));
130         require(success && (data.length == 0 || abi.decode(data, (bool))));
131     }
132 }