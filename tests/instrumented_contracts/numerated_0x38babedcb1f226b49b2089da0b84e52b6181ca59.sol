1 // SPDX-License-Identifier: WTFPL
2 pragma solidity >=0.8.0;
3 
4 
5 /**
6      ██████╗ ██████╗ ███╗   ██╗ ██████╗ █████╗ ██╗   ██╗██████╗
7     ██╔════╝██╔═══██╗████╗  ██║██╔════╝██╔══██╗██║   ██║╚════██╗
8     ██║     ██║   ██║██╔██╗ ██║██║     ███████║██║   ██║ █████╔╝
9     ██║     ██║   ██║██║╚██╗██║██║     ██╔══██║╚██╗ ██╔╝ ╚═══██╗
10     ╚██████╗╚██████╔╝██║ ╚████║╚██████╗██║  ██║ ╚████╔╝ ██████╔╝
11      ╚═════╝ ╚═════╝ ╚═╝  ╚═══╝ ╚═════╝╚═╝  ╚═╝  ╚═══╝  ╚═════╝
12     Concave
13 */
14 
15 // OpenZeppelin Contracts (last updated v4.5.0) (token/ERC20/IERC20.sol)
16 
17 
18 
19 /**
20  * @dev Interface of the ERC20 standard as defined in the EIP.
21  */
22 interface IERC20 {
23     /**
24      * @dev Returns the amount of tokens in existence.
25      */
26     function totalSupply() external view returns (uint256);
27 
28     /**
29      * @dev Returns the amount of tokens owned by `account`.
30      */
31     function balanceOf(address account) external view returns (uint256);
32 
33     /**
34      * @dev Moves `amount` tokens from the caller's account to `to`.
35      *
36      * Returns a boolean value indicating whether the operation succeeded.
37      *
38      * Emits a {Transfer} event.
39      */
40     function transfer(address to, uint256 amount) external returns (bool);
41 
42     /**
43      * @dev Returns the remaining number of tokens that `spender` will be
44      * allowed to spend on behalf of `owner` through {transferFrom}. This is
45      * zero by default.
46      *
47      * This value changes when {approve} or {transferFrom} are called.
48      */
49     function allowance(address owner, address spender) external view returns (uint256);
50 
51     /**
52      * @dev Sets `amount` as the allowance of `spender` over the caller's tokens.
53      *
54      * Returns a boolean value indicating whether the operation succeeded.
55      *
56      * IMPORTANT: Beware that changing an allowance with this method brings the risk
57      * that someone may use both the old and the new allowance by unfortunate
58      * transaction ordering. One possible solution to mitigate this race
59      * condition is to first reduce the spender's allowance to 0 and set the
60      * desired value afterwards:
61      * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
62      *
63      * Emits an {Approval} event.
64      */
65     function approve(address spender, uint256 amount) external returns (bool);
66 
67     /**
68      * @dev Moves `amount` tokens from `from` to `to` using the
69      * allowance mechanism. `amount` is then deducted from the caller's
70      * allowance.
71      *
72      * Returns a boolean value indicating whether the operation succeeded.
73      *
74      * Emits a {Transfer} event.
75      */
76     function transferFrom(
77         address from,
78         address to,
79         uint256 amount
80     ) external returns (bool);
81 
82     /**
83      * @dev Emitted when `value` tokens are moved from one account (`from`) to
84      * another (`to`).
85      *
86      * Note that `value` may be zero.
87      */
88     event Transfer(address indexed from, address indexed to, uint256 value);
89 
90     /**
91      * @dev Emitted when the allowance of a `spender` for an `owner` is set by
92      * a call to {approve}. `value` is the new allowance.
93      */
94     event Approval(address indexed owner, address indexed spender, uint256 value);
95 }
96 
97 contract aCNVRedemption {
98 
99     event Redemption(address indexed redeemer, uint256 output);
100 
101     /* -------------------------------------------------------------------------- */
102     /*                                   STORAGE                                  */
103     /* -------------------------------------------------------------------------- */
104 
105     IERC20 public constant CNV = IERC20(0x000000007a58f5f58E697e51Ab0357BC9e260A04);
106 
107     IERC20 public constant aCNV = IERC20(0x6Ff0106D34FEEe8A8aCF2e7b9168480f86B82E2f);
108 
109     mapping(address => bool) hasRedeemed;
110 
111     /* -------------------------------------------------------------------------- */
112     /*                                REDEEM LOGIC                                */
113     /* -------------------------------------------------------------------------- */
114 
115     // @notice This contract is minted aCNV's totalSupply at CNV launch,
116     // redemption rate is 1:1
117     function redeem(address to) external returns (uint256 output) {
118 
119         require(hasRedeemed[msg.sender] == false, "!ALREADY_REDEEMED");
120 
121         output = aCNV.balanceOf(msg.sender);
122 
123         hasRedeemed[msg.sender] = true;
124 
125         CNV.transfer(to, output);
126 
127         emit Redemption(msg.sender, output);
128     }
129 }