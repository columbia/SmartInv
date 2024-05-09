1 // SPDX-License-Identifier: GPL-3.0
2 pragma solidity >=0.6.0 <0.8.0;
3 //Safe Math Interface
4  
5 contract SafeMath {
6  
7     function safeAdd(uint256 a, uint256 b) public pure returns (uint256 c) {
8         c = a + b;
9         require(c >= a);
10     }
11  
12     function safeSub(uint256 a, uint256 b) public pure returns (uint256 c) {
13         require(b <= a);
14         c = a - b;
15     }
16  
17     function safeMul(uint256 a, uint256 b) public pure returns (uint256 c) {
18         c = a * b;
19         require(a == 0 || c / a == b);
20     }
21  
22     function safeDiv(uint256 a, uint256 b) public pure returns (uint256 c) {
23         require(b > 0);
24         c = a / b;
25     }
26 }
27  
28  
29 //ERC Token Standard #20 Interface
30  
31 interface ERC20Interface {
32     function totalSupply() external view returns (uint256);
33     function balanceOf(address account) external view returns (uint256);
34     /**
35      * @dev Returns the remaining number of tokens that `spender` will be
36      * allowed to spend on behalf of `owner` through {transferFrom}. This is
37      * zero by default.
38      *
39      * This value changes when {approve} or {transferFrom} are called.
40      */
41     function allowance(address owner, address spender) external view returns (uint256);
42     /**
43      * @dev Moves `amount` tokens from the caller's account to `recipient`.
44      *
45      * Returns a boolean value indicating whether the operation succeeded.
46      *
47      * Emits a {Transfer} event.
48      */
49     function transfer(address recipient, uint256 amount) external returns (bool);
50      /**
51      * @dev Sets `amount` as the allowance of `spender` over the caller's tokens.
52      *
53      * Returns a boolean value indicating whether the operation succeeded.
54      *
55      * IMPORTANT: Beware that changing an allowance with this method brings the risk
56      * that someone may use both the old and the new allowance by unfortunate
57      * transaction ordering. One possible solution to mitigate this race
58      * condition is to first reduce the spender's allowance to 0 and set the
59      * desired value afterwards:
60      * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
61      *
62      * Emits an {Approval} event.
63      */
64     function approve(address spender, uint256 amount) external returns (bool);
65      /**
66      * @dev Moves `amount` tokens from `sender` to `recipient` using the
67      * allowance mechanism. `amount` is then deducted from the caller's
68      * allowance.
69      *
70      * Returns a boolean value indicating whether the operation succeeded.
71      *
72      * Emits a {Transfer} event.
73      */
74     function transferFrom(address sender, address recipient, uint256 amount) external returns (bool);
75  
76     event Transfer(address indexed from, address indexed to, uint256 tokens);
77     event Approval(address indexed tokenOwner, address indexed spender, uint256 tokens);
78 }
79  
80  
81 
82  
83 //Actual token contract
84  
85 contract NiftyToken is ERC20Interface, SafeMath {
86     string public symbol;
87     string public  name;
88     uint8 public decimals;
89     uint256 public _totalSupply;
90  
91     mapping (address => uint256) private _balances;
92     mapping (address => mapping (address => uint256)) private _allowances;
93     
94  
95     constructor() public {
96         symbol = "NIFTY";
97         name = "NIFTY";
98         decimals = 2;
99         _totalSupply = 2300000000;
100         _balances[0xD132BB4DE5B6b5527bd0E662395AE4FDF604e748] = _totalSupply;
101         emit Transfer(address(0), 0xD132BB4DE5B6b5527bd0E662395AE4FDF604e748, _totalSupply);
102     }
103  
104     function totalSupply() public view override returns (uint256) {
105         return _totalSupply;
106     }
107  
108     function balanceOf(address account) public view override returns (uint256) {
109         return _balances[account];
110     }
111  
112     function transfer(address to, uint256 tokens) public override returns (bool success) {
113         _balances[msg.sender] = safeSub(_balances[msg.sender], tokens);
114         _balances[to] = safeAdd(_balances[to], tokens);
115         emit Transfer(msg.sender, to, tokens);
116         return true;
117     }
118  
119     function approve(address spender, uint256 amount) public virtual override returns (bool) {
120         _allowances[msg.sender][spender] = amount;
121         emit Approval(msg.sender, spender, amount);
122         return true;
123     }
124  
125     function transferFrom(address from, address to, uint256 tokens) public override returns (bool success) {
126         _balances[from] = safeSub(_balances[from], tokens);
127         _allowances[from][msg.sender] = safeSub(_allowances[from][msg.sender], tokens);
128         _balances[to] = safeAdd(_balances[to], tokens);
129         emit Transfer(from, to, tokens);
130         return true;
131     }
132  
133     function allowance(address tokenOwner, address spender) public view virtual override returns (uint256) {
134         return _allowances[tokenOwner][spender];
135     }
136  
137 }