1 // File: contracts\interfaces\IPoolToken.sol
2 
3 pragma solidity >=0.5.0;
4 
5 interface IPoolToken {
6 
7 	/*** Impermax ERC20 ***/
8 	
9 	event Transfer(address indexed from, address indexed to, uint value);
10 	event Approval(address indexed owner, address indexed spender, uint value);
11 	
12 	function name() external pure returns (string memory);
13 	function symbol() external pure returns (string memory);
14 	function decimals() external pure returns (uint8);
15 	function totalSupply() external view returns (uint);
16 	function balanceOf(address owner) external view returns (uint);
17 	function allowance(address owner, address spender) external view returns (uint);
18 	function approve(address spender, uint value) external returns (bool);
19 	function transfer(address to, uint value) external returns (bool);
20 	function transferFrom(address from, address to, uint value) external returns (bool);
21 	
22 	function DOMAIN_SEPARATOR() external view returns (bytes32);
23 	function PERMIT_TYPEHASH() external pure returns (bytes32);
24 	function nonces(address owner) external view returns (uint);
25 	function permit(address owner, address spender, uint value, uint deadline, uint8 v, bytes32 r, bytes32 s) external;
26 	
27 	/*** Pool Token ***/
28 	
29 	event Mint(address indexed sender, address indexed minter, uint mintAmount, uint mintTokens);
30 	event Redeem(address indexed sender, address indexed redeemer, uint redeemAmount, uint redeemTokens);
31 	event Sync(uint totalBalance);
32 	
33 	function underlying() external view returns (address);
34 	function factory() external view returns (address);
35 	function totalBalance() external view returns (uint);
36 	function MINIMUM_LIQUIDITY() external pure returns (uint);
37 
38 	function exchangeRate() external returns (uint);
39 	function mint(address minter) external returns (uint mintTokens);
40 	function redeem(address redeemer) external returns (uint redeemAmount);
41 	function skim(address to) external;
42 	function sync() external;
43 	
44 	function _setFactory() external;
45 }
46 
47 // File: contracts\interfaces\IERC20.sol
48 
49 pragma solidity >=0.5.0;
50 
51 interface IERC20 {
52     event Approval(address indexed owner, address indexed spender, uint value);
53     event Transfer(address indexed from, address indexed to, uint value);
54 
55     function name() external view returns (string memory);
56     function symbol() external view returns (string memory);
57     function decimals() external view returns (uint8);
58     function totalSupply() external view returns (uint);
59     function balanceOf(address owner) external view returns (uint);
60     function allowance(address owner, address spender) external view returns (uint);
61 
62     function approve(address spender, uint value) external returns (bool);
63     function transfer(address to, uint value) external returns (bool);
64     function transferFrom(address from, address to, uint value) external returns (bool);
65 }
66 
67 // File: contracts\interfaces\IReservesDistributor.sol
68 
69 pragma solidity >=0.5.0;
70 
71 interface IReservesDistributor {
72 	function imx() external view returns (address);
73 	function xImx() external view returns (address);
74 	function periodLength() external view returns (uint);
75 	function lastClaim() external view returns (uint);
76 	
77     event Claim(uint previousBalance, uint timeElapsed, uint amount);
78     event NewPeriodLength(uint oldPeriodLength, uint newPeriodLength);
79     event Withdraw(uint previousBalance, uint amount);
80 
81 	function claim() external returns (uint amount);
82 	function setPeriodLength(uint newPeriodLength) external;
83 	function withdraw(uint amount) external;
84 }
85 
86 // File: contracts\interfaces\IStakingRouter.sol
87 
88 pragma solidity >=0.5.0;
89 
90 interface IStakingRouter {
91 	function imx() external view returns (address);
92 	function xImx() external view returns (address);
93 	function reservesDistributor() external view returns (address);
94 	
95 	function stakeNoClaim(uint amount) external returns (uint tokens);
96 	function stake(uint amount) external returns (uint tokens);
97 	function unstakeNoClaim(uint tokens) external returns (uint amount);
98 	function unstake(uint tokens) external returns (uint amount);
99 }
100 
101 // File: contracts\StakingRouter.sol
102 
103 pragma solidity =0.5.16;
104 
105 
106 
107 
108 
109 contract StakingRouter is IStakingRouter {
110 	address public imx;
111 	address public xImx;
112 	address public reservesDistributor;
113 
114 	constructor(address _imx, address _xImx, address _reservesDistributor) public {
115 		imx = _imx;
116 		xImx = _xImx;
117 		reservesDistributor = _reservesDistributor;
118 	}
119 
120 	function stakeNoClaim(uint amount) public returns (uint tokens) {
121 		IERC20(imx).transferFrom(msg.sender, xImx, amount);
122 		tokens = IPoolToken(xImx).mint(msg.sender);
123 	}
124 	
125 	function stake(uint amount) external returns (uint tokens) {
126 		tokens = stakeNoClaim(amount);
127 		IReservesDistributor(reservesDistributor).claim();
128 	}
129 	
130 	function unstakeNoClaim(uint tokens) public returns (uint amount) {
131 		IERC20(xImx).transferFrom(msg.sender, xImx, tokens);
132 		amount = IPoolToken(xImx).redeem(msg.sender);
133 	}
134 	
135 	function unstake(uint tokens) external returns (uint amount) {
136 		IReservesDistributor(reservesDistributor).claim();
137 		amount = unstakeNoClaim(tokens);
138 	}
139 }