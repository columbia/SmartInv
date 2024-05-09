1 pragma solidity ^0.5.0;
2 
3 /**
4  * @dev Interface of the ERC20 standard as defined in the EIP. Does not include
5  * the optional functions; to access them see `ERC20Detailed`.
6  */
7 interface IERC20 {
8     /**
9      * @dev Returns the amount of tokens in existence.
10      */
11     function totalSupply() external view returns (uint256);
12 
13     /**
14      * @dev Returns the amount of tokens owned by `account`.
15      */
16     function balanceOf(address account) external view returns (uint256);
17 
18     /**
19      * @dev Moves `amount` tokens from the caller's account to `recipient`.
20      *
21      * Returns a boolean value indicating whether the operation succeeded.
22      *
23      * Emits a `Transfer` event.
24      */
25     function transfer(address recipient, uint256 amount) external returns (bool);
26 
27     /**
28      * @dev Returns the remaining number of tokens that `spender` will be
29      * allowed to spend on behalf of `owner` through `transferFrom`. This is
30      * zero by default.
31      *
32      * This value changes when `approve` or `transferFrom` are called.
33      */
34     function allowance(address owner, address spender) external view returns (uint256);
35 
36     /**
37      * @dev Sets `amount` as the allowance of `spender` over the caller's tokens.
38      *
39      * Returns a boolean value indicating whether the operation succeeded.
40      *
41      * > Beware that changing an allowance with this method brings the risk
42      * that someone may use both the old and the new allowance by unfortunate
43      * transaction ordering. One possible solution to mitigate this race
44      * condition is to first reduce the spender's allowance to 0 and set the
45      * desired value afterwards:
46      * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
47      *
48      * Emits an `Approval` event.
49      */
50     function approve(address spender, uint256 amount) external returns (bool);
51 
52     /**
53      * @dev Moves `amount` tokens from `sender` to `recipient` using the
54      * allowance mechanism. `amount` is then deducted from the caller's
55      * allowance.
56      *
57      * Returns a boolean value indicating whether the operation succeeded.
58      *
59      * Emits a `Transfer` event.
60      */
61     function transferFrom(address sender, address recipient, uint256 amount) external returns (bool);
62 
63     /**
64      * @dev Emitted when `value` tokens are moved from one account (`from`) to
65      * another (`to`).
66      *
67      * Note that `value` may be zero.
68      */
69     event Transfer(address indexed from, address indexed to, uint256 value);
70 
71     /**
72      * @dev Emitted when the allowance of a `spender` for an `owner` is set by
73      * a call to `approve`. `value` is the new allowance.
74      */
75     event Approval(address indexed owner, address indexed spender, uint256 value);
76 }
77 
78 
79 
80 library SafeERC20Detailed {
81 
82     function safeDecimals(address token) internal returns (uint256 decimals) {
83 
84         (bool success, bytes memory data) = address(token).call(abi.encodeWithSignature("decimals()"));
85 
86         if (!success) {
87             (success, data) = address(token).call(abi.encodeWithSignature("Decimals()"));
88         }
89 
90         if (!success) {
91             (success, data) = address(token).call(abi.encodeWithSignature("DECIMALS()"));
92         }
93 
94         if (!success) {
95             return 18;
96         }
97 
98         assembly {
99             decimals := mload(add(data, 32))
100         }
101     }
102 
103     function safeSymbol(address token) internal returns(bytes32 symbol) {
104 
105         (bool success, bytes memory data) = token.call(abi.encodeWithSignature("symbol()"));
106 
107         if (!success) {
108             (success, data) = token.call(abi.encodeWithSignature("Symbol()"));
109         }
110 
111         if (!success) {
112             (success, data) = token.call(abi.encodeWithSignature("SYMBOL()"));
113         }
114 
115         if (!success) {
116             return 0;
117         }
118 
119         uint256 dataLength = data.length;
120         assembly {
121             symbol := mload(add(data, dataLength))
122         }
123     }
124 }
125 
126 
127 
128 contract Approved {
129 
130     using SafeERC20Detailed for address;
131 
132     function allowances(
133         address source,
134         address[] calldata tokens,
135         address[] calldata spenders
136     )
137         external
138         returns(
139             uint256[] memory results,
140             uint256[] memory decimals,
141             bytes32[] memory symbols
142         )
143     {
144         require(tokens.length == spenders.length, "Invalid argument array lengths");
145 
146         results = new uint256[](tokens.length);
147         decimals = new uint256[](tokens.length);
148         symbols = new bytes32[](tokens.length);
149 
150         for (uint i = 0; i < tokens.length; i++) {
151 
152             results[i] = IERC20(tokens[i]).allowance(source, spenders[i]);
153             decimals[i] = tokens[i].safeDecimals();
154             symbols[i] = tokens[i].safeSymbol();
155         }
156     }
157 }
