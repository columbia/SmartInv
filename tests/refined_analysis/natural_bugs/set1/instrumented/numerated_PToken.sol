1 // SPDX-License-Identifier: GPL-2.0-or-later
2 
3 pragma solidity ^0.8.0;
4 
5 import "./Interfaces.sol";
6 import "./Utils.sol";
7 
8 /// @notice Protected Tokens are simple wrappers for tokens, allowing you to use tokens as collateral without permitting borrowing
9 contract PToken {
10     address immutable euler;
11     address immutable underlyingToken;
12 
13     constructor(address euler_, address underlying_) {
14         euler = euler_;
15         underlyingToken = underlying_;
16     }
17 
18 
19     mapping(address => uint) balances;
20     mapping(address => mapping(address => uint)) allowances;
21     uint totalBalances;
22 
23 
24     event Approval(address indexed owner, address indexed spender, uint value);
25     event Transfer(address indexed from, address indexed to, uint value);
26 
27 
28     /// @notice PToken name, ie "Euler Protected DAI"
29     function name() external view returns (string memory) {
30         return string(abi.encodePacked("Euler Protected ", IERC20(underlyingToken).name()));
31     }
32 
33     /// @notice PToken symbol, ie "pDAI"
34     function symbol() external view returns (string memory) {
35         return string(abi.encodePacked("p", IERC20(underlyingToken).symbol()));
36     }
37 
38     /// @notice Number of decimals, which is same as the underlying's
39     function decimals() external view returns (uint8) {
40         return IERC20(underlyingToken).decimals();
41     }
42 
43     /// @notice Address of the underlying asset
44     function underlying() external view returns (address) {
45         return underlyingToken;
46     }
47 
48 
49     /// @notice Balance of an account's wrapped tokens
50     function balanceOf(address who) external view returns (uint) {
51         return balances[who];
52     }
53 
54     /// @notice Sum of all wrapped token balances
55     function totalSupply() external view returns (uint) {
56         return totalBalances;
57     }
58 
59     /// @notice Retrieve the current allowance
60     /// @param holder Address giving permission to access tokens
61     /// @param spender Trusted address
62     function allowance(address holder, address spender) external view returns (uint) {
63         return allowances[holder][spender];
64     }
65 
66 
67     /// @notice Transfer your own pTokens to another address
68     /// @param recipient Recipient address
69     /// @param amount Amount of wrapped token to transfer
70     function transfer(address recipient, uint amount) external returns (bool) {
71         return transferFrom(msg.sender, recipient, amount);
72     }
73 
74     /// @notice Transfer pTokens from one address to another. The euler address is automatically granted approval.
75     /// @param from This address must've approved the to address
76     /// @param recipient Recipient address
77     /// @param amount Amount to transfer
78     function transferFrom(address from, address recipient, uint amount) public returns (bool) {
79         require(balances[from] >= amount, "insufficient balance");
80         if (from != msg.sender && msg.sender != euler && allowances[from][msg.sender] != type(uint).max) {
81             require(allowances[from][msg.sender] >= amount, "insufficient allowance");
82             allowances[from][msg.sender] -= amount;
83             emit Approval(from, msg.sender, allowances[from][msg.sender]);
84         }
85         balances[from] -= amount;
86         balances[recipient] += amount;
87         emit Transfer(from, recipient, amount);
88         return true;
89     }
90 
91     /// @notice Allow spender to access an amount of your pTokens. It is not necessary to approve the euler address.
92     /// @param spender Trusted address
93     /// @param amount Use max uint256 for "infinite" allowance
94     function approve(address spender, uint amount) external returns (bool) {
95         allowances[msg.sender][spender] = amount;
96         emit Approval(msg.sender, spender, amount);
97         return true;
98     }
99 
100 
101 
102     /// @notice Convert underlying tokens to pTokens
103     /// @param amount In underlying units (which are equivalent to pToken units)
104     function wrap(uint amount) external {
105         Utils.safeTransferFrom(underlyingToken, msg.sender, address(this), amount);
106         claimSurplus(msg.sender);
107     }
108 
109     /// @notice Convert pTokens to underlying tokens
110     /// @param amount In pToken units (which are equivalent to underlying units)
111     function unwrap(uint amount) external {
112         doUnwrap(msg.sender, amount);
113     }
114 
115     // Only callable by the euler contract:
116     function forceUnwrap(address who, uint amount) external {
117         require(msg.sender == euler, "permission denied");
118         doUnwrap(who, amount);
119     }
120 
121     /// @notice Claim any surplus tokens held by the PToken contract. This should only be used by contracts.
122     /// @param who Beneficiary to be credited for the surplus token amount
123     function claimSurplus(address who) public {
124         uint currBalance = IERC20(underlyingToken).balanceOf(address(this));
125         require(currBalance > totalBalances, "no surplus balance to claim");
126 
127         uint amount = currBalance - totalBalances;
128 
129         totalBalances += amount;
130         balances[who] += amount;
131         emit Transfer(address(0), who, amount);
132     }
133 
134 
135     // Internal shared:
136 
137     function doUnwrap(address who, uint amount) private {
138         require(balances[who] >= amount, "insufficient balance");
139 
140         totalBalances -= amount;
141         balances[who] -= amount;
142 
143         Utils.safeTransfer(underlyingToken, who, amount);
144         emit Transfer(who, address(0), amount);
145     }
146 }
