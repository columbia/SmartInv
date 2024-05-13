1 // SPDX-License-Identifier: MIT
2 
3 pragma solidity 0.6.12;
4 pragma experimental ABIEncoderV2;
5 import "@boringcrypto/boring-solidity/contracts/interfaces/IERC20.sol";
6 import "@sushiswap/bentobox-sdk/contracts/IBentoBoxV1.sol";
7 import "./IOracle.sol";
8 import "./ISwapper.sol";
9 
10 interface IKashiPair {
11     event Approval(address indexed _owner, address indexed _spender, uint256 _value);
12     event LogAccrue(uint256 accruedAmount, uint256 feeFraction, uint64 rate, uint256 utilization);
13     event LogAddAsset(address indexed from, address indexed to, uint256 share, uint256 fraction);
14     event LogAddCollateral(address indexed from, address indexed to, uint256 share);
15     event LogBorrow(address indexed from, address indexed to, uint256 amount, uint256 part);
16     event LogExchangeRate(uint256 rate);
17     event LogFeeTo(address indexed newFeeTo);
18     event LogRemoveAsset(address indexed from, address indexed to, uint256 share, uint256 fraction);
19     event LogRemoveCollateral(address indexed from, address indexed to, uint256 share);
20     event LogRepay(address indexed from, address indexed to, uint256 amount, uint256 part);
21     event LogWithdrawFees(address indexed feeTo, uint256 feesEarnedFraction);
22     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
23     event Transfer(address indexed _from, address indexed _to, uint256 _value);
24 
25     function DOMAIN_SEPARATOR() external view returns (bytes32);
26 
27     function accrue() external;
28 
29     function accrueInfo()
30         external
31         view
32         returns (
33             uint64 interestPerBlock,
34             uint64 lastBlockAccrued,
35             uint128 feesEarnedFraction
36         );
37 
38     function addAsset(
39         address to,
40         bool skim,
41         uint256 share
42     ) external returns (uint256 fraction);
43 
44     function addCollateral(
45         address to,
46         bool skim,
47         uint256 share
48     ) external;
49 
50     function allowance(address, address) external view returns (uint256);
51 
52     function approve(address spender, uint256 amount) external returns (bool);
53 
54     function asset() external view returns (IERC20);
55 
56     function balanceOf(address) external view returns (uint256);
57 
58     function bentoBox() external view returns (IBentoBoxV1);
59 
60     function borrow(address to, uint256 amount) external returns (uint256 part, uint256 share);
61 
62     function claimOwnership() external;
63 
64     function collateral() external view returns (IERC20);
65 
66     function cook(
67         uint8[] calldata actions,
68         uint256[] calldata values,
69         bytes[] calldata datas
70     ) external payable returns (uint256 value1, uint256 value2);
71 
72     function decimals() external view returns (uint8);
73 
74     function exchangeRate() external view returns (uint256);
75 
76     function feeTo() external view returns (address);
77 
78     function getInitData(
79         IERC20 collateral_,
80         IERC20 asset_,
81         IOracle oracle_,
82         bytes calldata oracleData_
83     ) external pure returns (bytes memory data);
84 
85     function init(bytes calldata data) external payable;
86 
87     function isSolvent(address user, bool open) external view returns (bool);
88 
89     function liquidate(
90         address[] calldata users,
91         uint256[] calldata borrowParts,
92         address to,
93         ISwapper swapper,
94         bool open
95     ) external;
96 
97     function masterContract() external view returns (address);
98 
99     function name() external view returns (string memory);
100 
101     function nonces(address) external view returns (uint256);
102 
103     function oracle() external view returns (IOracle);
104 
105     function oracleData() external view returns (bytes memory);
106 
107     function owner() external view returns (address);
108 
109     function pendingOwner() external view returns (address);
110 
111     function permit(
112         address owner_,
113         address spender,
114         uint256 value,
115         uint256 deadline,
116         uint8 v,
117         bytes32 r,
118         bytes32 s
119     ) external;
120 
121     function removeAsset(address to, uint256 fraction) external returns (uint256 share);
122 
123     function removeCollateral(address to, uint256 share) external;
124 
125     function repay(
126         address to,
127         bool skim,
128         uint256 part
129     ) external returns (uint256 amount);
130 
131     function setFeeTo(address newFeeTo) external;
132 
133     function setSwapper(ISwapper swapper, bool enable) external;
134 
135     function swappers(ISwapper) external view returns (bool);
136 
137     function symbol() external view returns (string memory);
138 
139     function totalAsset() external view returns (uint128 elastic, uint128 base);
140 
141     function totalBorrow() external view returns (uint128 elastic, uint128 base);
142 
143     function totalCollateralShare() external view returns (uint256);
144 
145     function totalSupply() external view returns (uint256);
146 
147     function transfer(address to, uint256 amount) external returns (bool);
148 
149     function transferFrom(
150         address from,
151         address to,
152         uint256 amount
153     ) external returns (bool);
154 
155     function transferOwnership(
156         address newOwner,
157         bool direct,
158         bool renounce
159     ) external;
160 
161     function updateExchangeRate() external returns (bool updated, uint256 rate);
162 
163     function userBorrowPart(address) external view returns (uint256);
164 
165     function userCollateralShare(address) external view returns (uint256);
166 
167     function withdrawFees() external;
168 }
