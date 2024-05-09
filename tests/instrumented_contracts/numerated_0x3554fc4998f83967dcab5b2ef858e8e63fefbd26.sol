1 // SPDX-License-Identifier: UNLICENSED
2 pragma solidity ^0.8.9;
3 
4 interface IERC20 {
5     function totalSupply() external view returns (uint256);
6     function balanceOf(address account) external view returns (uint256);
7     function transfer(address to, uint256 amount) external returns (bool);
8     function allowance(address owner, address spender) external view returns (uint256);
9     function approve(address spender, uint256 amount) external returns (bool);
10     function transferFrom(
11         address from,
12         address to,
13         uint256 amount
14     ) external returns (bool);
15     event Transfer(address indexed from, address indexed to, uint256 value);
16     event Approval(address indexed owner, address indexed spender, uint256 value);
17 }
18 
19 interface IDFV {
20     function deposit(uint256 numberRLP, uint256 numberDELTA) external;
21     function addNewRewards(uint256 amountDELTA, uint256 amountWETH) external;
22 }
23 
24 contract StableYield {
25 
26     address constant DEV_ADDRESS = 0x5A16552f59ea34E44ec81E58b3817833E9fD5436;
27     IERC20 constant DELTA = IERC20(0x9EA3b5b4EC044b70375236A281986106457b20EF);
28     address constant DFV_ADDRESS = 0x9fE9Bb6B66958f2271C4B0aD23F6E8DDA8C221BE;
29     IDFV constant DFV = IDFV(DFV_ADDRESS);
30 
31     address public dao_address;
32 
33     modifier onlyDev() {
34         require(msg.sender == DEV_ADDRESS || msg.sender == dao_address, "Nope");
35         _;
36     }
37 
38     uint256 weeklyDELTAToSend;
39     uint256 lastDistributionTime;
40     bool enabled;
41     uint256 constant MAX_INT = 0xffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffff;
42     uint256 constant SECONDS_PER_WEEK = 604800;
43 
44     uint256 weeklyTip; // Amount of DELTA you get per block for calling distribute()
45 
46     constructor() {
47         lastDistributionTime = 1645115480;
48         dao_address = msg.sender;
49     }
50 
51     function setDAO(address _dao_address) public onlyDev {
52         dao_address = _dao_address;
53     }
54 
55     function enableWithDefaults() external onlyDev {
56         enable(25000e18, 20e18);
57     }
58 
59     function enable(uint256 weeklyAmount, uint256 weeklyIncentiveAmount) public onlyDev {
60         weeklyDELTAToSend = weeklyAmount;
61         weeklyTip = weeklyIncentiveAmount;
62         enabled = true;
63     }
64     function approveDFV() external {
65         DELTA.approve(DFV_ADDRESS, MAX_INT);
66     }
67     function disable() external onlyDev {
68         enabled = false;
69     }
70 
71     function distribute() external {
72         require(block.timestamp > lastDistributionTime + 120, "Too soon");
73         require(enabled, "Distributions disabled");
74         uint256 timeDelta = block.timestamp - lastDistributionTime;
75         if(timeDelta >= SECONDS_PER_WEEK) {
76             // Capped at one week worth of rewards per distribution. Better call it :o
77             timeDelta = SECONDS_PER_WEEK;
78         }
79         uint256 percentageOfAWeekPassede4 = (timeDelta * 1e4) / SECONDS_PER_WEEK;
80         uint256 distribution = (weeklyDELTAToSend * percentageOfAWeekPassede4) / 1e4;
81         uint256 tip = (weeklyTip * percentageOfAWeekPassede4) / 1e4;
82         require(distribution > 0);
83         
84         DFV.addNewRewards(distribution, 0);
85         DELTA.transfer(msg.sender, tip);
86         DFV.deposit(0,1);
87         lastDistributionTime = block.timestamp;
88     }
89 
90     function recoverERC20(address tokenAddress, uint256 tokenAmount) external virtual onlyDev {
91         IERC20(tokenAddress).transfer(DEV_ADDRESS, tokenAmount);
92     }
93 
94     function die(uint256 nofuckery) external onlyDev payable {
95         require(nofuckery==175, "Oooops");
96         selfdestruct(payable(DEV_ADDRESS));
97     }
98     
99 }