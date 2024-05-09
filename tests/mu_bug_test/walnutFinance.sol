1 // SPDX-License-Identifier: MIT
2 pragma solidity ^0.8.0;
3 
4 contract WUSDMaster is Ownable, Withdrawable, ReentrancyGuard {
5     using SafeERC20 for IERC20;
6     
7     IWUSD public immutable wusd;
8     IERC20 public usdt;
9     IERC20 public wex;
10     IWswapRouter public immutable wswapRouter;
11     address public treasury;
12     address public strategist;
13     
14     address[] public swapPath;
15     
16     uint public wexPermille = 100;
17     uint public treasuryPermille = 7;
18     uint public feePermille = 0;
19     
20     uint256 public maxStakeAmount;
21     
22     event Stake(address indexed user, uint256 amount);
23     event Redeem(address indexed user, uint256 amount);
24     event UsdtWithdrawn(uint256 amount);
25     event WexWithdrawn(uint256 amount);
26     event SwapPathChanged(address[] swapPath);
27     event WexPermilleChanged(uint256 wexPermille);
28     event TreasuryPermilleChanged(uint256 treasuryPermille);
29     event FeePermilleChanged(uint256 feePermille);
30     event TreasuryAddressChanged(address treasury);
31     event StrategistAddressChanged(address strategist);
32     event MaxStakeAmountChanged(uint256 maxStakeAmount);
33     
34     constructor(IWUSD _wusd, IERC20 _usdt, IERC20 _wex, IWswapRouter _wswapRouter, address _treasury, uint256 _maxStakeAmount) {
35         require(
36             address(_wusd) != address(0) &&
37             address(_usdt) != address(0) &&
38             address(_wex) != address(0) &&
39             address(_wswapRouter) != address(0) &&
40             _treasury != address(0),
41             "zero address in constructor"
42         );
43         wusd = _wusd;
44         usdt = _usdt;
45         wex = _wex;
46         wswapRouter = _wswapRouter;
47         treasury = _treasury;
48         swapPath = [address(usdt), address(wex)];
49         maxStakeAmount = _maxStakeAmount;
50     }
51     
52     function setSwapPath(address[] calldata _swapPath) external onlyOwner {
53         swapPath = _swapPath;
54         
55         emit SwapPathChanged(swapPath);
56     }
57     
58     function setWexPermille(uint _wexPermille) external onlyOwner {
59         require(_wexPermille <= 500, 'wexPermille too high!');
60         wexPermille = _wexPermille;
61         
62         emit WexPermilleChanged(wexPermille);
63     }
64     
65     function setTreasuryPermille(uint _treasuryPermille) external onlyOwner {
66         require(_treasuryPermille <= 50, 'treasuryPermille too high!');
67         treasuryPermille = _treasuryPermille;
68         
69         emit TreasuryPermilleChanged(treasuryPermille);
70     }
71     
72     function setFeePermille(uint _feePermille) external onlyOwner {
73         require(_feePermille <= 20, 'feePermille too high!');
74         feePermille = _feePermille;
75         
76         emit FeePermilleChanged(feePermille);
77     }
78     
79     function setTreasuryAddress(address _treasury) external onlyOwner {
80         treasury = _treasury;
81         
82         emit TreasuryAddressChanged(treasury);
83     }
84     
85     function setStrategistAddress(address _strategist) external onlyOwner {
86         strategist = _strategist;
87         
88         emit StrategistAddressChanged(strategist);
89     }
90     
91     function setMaxStakeAmount(uint256 _maxStakeAmount) external onlyOwner {
92         maxStakeAmount = _maxStakeAmount;
93         
94         emit MaxStakeAmountChanged(maxStakeAmount);
95     }
96     
97     function stake(uint256 amount) external nonReentrant {
98         require(amount <= maxStakeAmount, 'amount too high');
99         usdt.safeTransferFrom(msg.sender, address(this), amount);
100         if(feePermille > 0) {
101             uint256 feeAmount = amount * feePermille / 1000;
102             usdt.safeTransfer(treasury, feeAmount);
103             amount = amount - feeAmount;
104         }
105         uint256 wexAmount = amount * wexPermille / 1000;
106         usdt.approve(address(wswapRouter), wexAmount);
107         wswapRouter.swapExactTokensForTokensSupportingFeeOnTransferTokens(
108             wexAmount,
109             0,
110             swapPath,
111             address(this),
112             block.timestamp
113         );
114         wusd.mint(msg.sender, amount);
115         
116         emit Stake(msg.sender, amount);
117     }
118     
119     function redeem(uint256 amount) external nonReentrant {
120         uint256 usdtTransferAmount = amount * (1000 - wexPermille - treasuryPermille) / 1000;
121         uint256 usdtTreasuryAmount = amount * treasuryPermille / 1000;
122         uint256 wexTransferAmount = wex.balanceOf(address(this)) * amount / wusd.totalSupply();
123         wusd.burn(msg.sender, amount);
124         usdt.safeTransfer(treasury, usdtTreasuryAmount);
125         usdt.safeTransfer(msg.sender, usdtTransferAmount);
126         wex.safeTransfer(msg.sender, wexTransferAmount);
127         
128         emit Redeem(msg.sender, amount);
129     }
130     
131     function withdrawUsdt(uint256 amount) external onlyOwner {
132         require(strategist != address(0), 'strategist not set');
133         usdt.safeTransfer(strategist, amount);
134         
135         emit UsdtWithdrawn(amount);
136     }
137     
138     function withdrawWex(uint256 amount) external onlyWithdrawer {
139         wex.safeTransfer(msg.sender, amount);
140         
141         emit WexWithdrawn(amount);
142     }