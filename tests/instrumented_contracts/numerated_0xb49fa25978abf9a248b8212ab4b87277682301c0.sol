1 pragma solidity ^0.4.26;
2 // ----------------------------------------------------------------------------
3 // ERC Token Standard #20 Interface
4 // https://github.com/ethereum/EIPs/blob/master/EIPS/eip-20-token-standard.md
5 // ----------------------------------------------------------------------------
6 contract ERC20Interface {
7   function totalSupply() public constant returns (uint);
8   function balanceOf(address tokenOwner) public constant returns (uint balance);
9   function allowance(address tokenOwner, address spender) public constant returns (uint remaining);
10   function transfer(address to, uint tokens) public returns (bool success);
11   function approve(address spender, uint tokens) public returns (bool success);
12   function transferFrom(address from, address to, uint tokens) public returns (bool success);
13 
14   event Transfer(address indexed from, address indexed to, uint tokens);
15   event Approval(address indexed tokenOwner, address indexed spender, uint tokens);
16 }
17 
18 // ----------------------------------------------------------------------------
19 // Contract function to receive approval and execute function in one call
20 //
21 // Borrowed from MiniMeToken
22 // ----------------------------------------------------------------------------
23 contract ApproveAndCallFallBack {
24   function receiveApproval(address from, uint256 tokens, address token, bytes data) public;
25 }
26 
27 // ----------------------------------------------------------------------------
28 // Safe maths
29 // ----------------------------------------------------------------------------
30 library SafeMath {
31   function add(uint a, uint b) internal pure returns (uint c) {
32     c = a + b;
33     require(c >= a);
34   }
35   function sub(uint a, uint b) internal pure returns (uint c) {
36     require(b <= a);
37     c = a - b;
38   }
39   function mul(uint a, uint b) internal pure returns (uint c) {
40     c = a * b;
41     require(a == 0 || c / a == b); // the same as: if (a !=0 && c / a != b) {throw;}
42   }
43   function div(uint a, uint b) internal pure returns (uint c) {
44     require(b > 0);
45     c = a / b;
46   }
47 }
48 
49 // ----------------------------------------------------------------------------
50 // ERC20 Token, with the addition of symbol, name and decimals and an
51 // initial fixed supply
52 // ----------------------------------------------------------------------------
53 contract RaiFinance is ERC20Interface {
54   using SafeMath for uint;
55 
56   string public symbol;
57   string public  name;
58   uint8 public decimals;
59   uint _totalSupply;
60 
61   mapping(address => uint) balances;
62   mapping(address => mapping(address => uint)) allowed;
63 
64 
65   // ------------------------------------------------------------------------
66   // Constructor
67   // ------------------------------------------------------------------------
68   constructor() public {
69     symbol = "SOFI";
70     name = "Rai.Finance";
71     decimals = 18;
72     _totalSupply = 1000000000 * 10**uint(decimals);
73     balances[msg.sender] = _totalSupply;
74     emit Transfer(address(0), msg.sender, _totalSupply);
75   }
76 
77   // ------------------------------------------------------------------------
78   // Total supply
79   // ------------------------------------------------------------------------
80   function totalSupply() public constant returns (uint) {
81     return _totalSupply  - balances[address(0)];
82   }
83 
84   // ------------------------------------------------------------------------
85   // Get the token balance for account `tokenOwner`
86   // ------------------------------------------------------------------------
87   function balanceOf(address tokenOwner) public constant returns (uint balance) {
88     return balances[tokenOwner];
89   }
90 
91   // ------------------------------------------------------------------------
92   // Transfer the balance from token owner's account to `to` account
93   // - Owner's account must have sufficient balance to transfer
94   // - 0 value transfers are allowed
95   // ------------------------------------------------------------------------
96   function transfer(address to, uint tokens) public returns (bool success) {
97     balances[msg.sender] = balances[msg.sender].sub(tokens);
98     balances[to] = balances[to].add(tokens);
99     emit Transfer(msg.sender, to, tokens);
100     return true;
101   }
102 
103   // ------------------------------------------------------------------------
104   // Token owner can approve for `spender` to transferFrom(...) `tokens`
105   // from the token owner's account
106   //
107   // https://github.com/ethereum/EIPs/blob/master/EIPS/eip-20-token-standard.md
108   // recommends that there are no checks for the approval double-spend attack
109   // as this should be implemented in user interfaces
110   // ------------------------------------------------------------------------
111   function approve(address spender, uint tokens) public returns (bool success) {
112     allowed[msg.sender][spender] = tokens;
113     emit Approval(msg.sender, spender, tokens);
114     return true;
115   }
116 
117   // ------------------------------------------------------------------------
118   // Transfer `tokens` from the `from` account to the `to` account
119   //
120   // The calling account must already have sufficient tokens approve(...)-d
121   // for spending from the `from` account and
122   // - From account must have sufficient balance to transfer
123   // - Spender must have sufficient allowance to transfer
124   // - 0 value transfers are allowed
125   // ------------------------------------------------------------------------
126   function transferFrom(address from, address to, uint tokens) public returns (bool success) {
127     balances[from] = balances[from].sub(tokens);
128     allowed[from][msg.sender] = allowed[from][msg.sender].sub(tokens);
129     balances[to] = balances[to].add(tokens);
130     emit Transfer(from, to, tokens);
131     return true;
132   }
133 
134   // ------------------------------------------------------------------------
135   // Returns the amount of tokens approved by the owner that can be
136   // transferred to the spender's account
137   // ------------------------------------------------------------------------
138   function allowance(address tokenOwner, address spender) public constant returns (uint remaining) {
139     return allowed[tokenOwner][spender];
140   }
141 
142   // ------------------------------------------------------------------------
143   // Token owner can approve for `spender` to transferFrom(...) `tokens`
144   // from the token owner's account. The `spender` contract function
145   // `receiveApproval(...)` is then executed
146   // ------------------------------------------------------------------------
147   function approveAndCall(address spender, uint tokens, bytes data) public returns (bool success) {
148     allowed[msg.sender][spender] = tokens;
149     emit Approval(msg.sender, spender, tokens);
150     ApproveAndCallFallBack(spender).receiveApproval(msg.sender, tokens, this, data);
151     return true;
152   }
153 
154 
155   // ------------------------------------------------------------------------
156   // Don't accept ETH
157   // ------------------------------------------------------------------------
158   function () public payable {
159     revert();
160   }
161 }