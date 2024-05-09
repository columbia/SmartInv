1 pragma solidity ^0.4.18;
2 // ----------------------------------------------------------------------------
3 // ERC Token Standard #20 Interface
4 // https://github.com/ethereum/EIPs/blob/master/EIPS/eip-20-token-standard.md
5 // ----------------------------------------------------------------------------
6 contract ERC20Interface {
7     function totalSupply() public constant returns (uint);
8     function balanceOf(address tokenOwner) public constant returns (uint balance);
9     function allowance(address tokenOwner, address spender) public constant returns (uint remaining);
10     function transfer(address to, uint tokens) public returns (bool success);
11     function approve(address spender, uint tokens) public returns (bool success);
12     function transferFrom(address from, address to, uint tokens) public returns (bool success);
13 
14     event Transfer(address indexed from, address indexed to, uint tokens);
15     event Approval(address indexed tokenOwner, address indexed spender, uint tokens);
16 }
17 
18 // ----------------------------------------------------------------------------
19 // Contract function to receive approval and execute function in one call
20 //
21 // Borrowed from MiniMeToken
22 // ----------------------------------------------------------------------------
23 contract ApproveAndCallFallBack {
24     function receiveApproval(address from, uint256 tokens, address token, bytes data) public;
25 }
26 
27 // ----------------------------------------------------------------------------
28 // ERC20 Token, with the addition of symbol, name and decimals and assisted
29 // token transfers
30 // ----------------------------------------------------------------------------
31 contract MetamToken is ERC20Interface{
32     string public symbol;
33     string public  name;
34     uint8 public decimals;
35     uint public _totalSupply;
36 
37     mapping(address => uint) balances;
38     mapping(address => mapping(address => uint)) allowed;
39 
40 
41     // ------------------------------------------------------------------------
42     // Constructor
43     // ------------------------------------------------------------------------
44     constructor() public {
45         symbol = "MTMX";
46         name = "Metam";
47         decimals = 4;
48         _totalSupply = 1000000000000;
49         balances[0x5A86f0cafD4ef3ba4f0344C138afcC84bd1ED222] = _totalSupply;
50         emit Transfer(address(0), 0x5A86f0cafD4ef3ba4f0344C138afcC84bd1ED222, _totalSupply);
51     }
52 
53 
54     // ------------------------------------------------------------------------
55     // Total supply
56     // ------------------------------------------------------------------------
57     function totalSupply() public constant returns (uint) {
58         return _totalSupply  - balances[address(0)];
59     }
60 
61 
62     // ------------------------------------------------------------------------
63     // Get the token balance for account tokenOwner
64     // ------------------------------------------------------------------------
65     function balanceOf(address tokenOwner) public constant returns (uint balance) {
66         return balances[tokenOwner];
67     }
68 
69 
70     // ------------------------------------------------------------------------
71     // Transfer the balance from token owner's account to to account
72     // - Owner's account must have sufficient balance to transfer
73     // - 0 value transfers are allowed
74     // ------------------------------------------------------------------------
75     function transfer(address to, uint tokens) public returns (bool success) {
76         balances[msg.sender] = balances[msg.sender] - tokens;
77         balances[to] = balances[to] + tokens;
78         emit Transfer(msg.sender, to, tokens);
79         return true;
80     }
81 
82 
83     // ------------------------------------------------------------------------
84     // Token owner can approve for spender to transferFrom(...) tokens
85     // from the token owner's account
86     //
87     // https://github.com/ethereum/EIPs/blob/master/EIPS/eip-20-token-standard.md
88     // recommends that there are no checks for the approval double-spend attack
89     // as this should be implemented in user interfaces 
90     // ------------------------------------------------------------------------
91     function approve(address spender, uint tokens) public returns (bool success) {
92         allowed[msg.sender][spender] = tokens;
93         emit Approval(msg.sender, spender, tokens);
94         return true;
95     }
96 
97 
98     // ------------------------------------------------------------------------
99     // Transfer tokens from the from account to the to account
100     // 
101     // The calling account must already have sufficient tokens approve(...)-d
102     // for spending from the from account and
103     // - From account must have sufficient balance to transfer
104     // - Spender must have sufficient allowance to transfer
105     // - 0 value transfers are allowed
106     // ------------------------------------------------------------------------
107     function transferFrom(address from, address to, uint tokens) public returns (bool success) {
108         balances[from] = balances[from] - tokens;
109         allowed[from][msg.sender] = allowed[from][msg.sender] - tokens;
110         balances[to] = balances[to] + tokens;
111         emit Transfer(from, to, tokens);
112         return true;
113     }
114 
115 
116     // ------------------------------------------------------------------------
117     // Returns the amount of tokens approved by the owner that can be
118     // transferred to the spender's account
119     // ------------------------------------------------------------------------
120     function allowance(address tokenOwner, address spender) public constant returns (uint remaining) {
121         return allowed[tokenOwner][spender];
122     }
123 
124 
125     // ------------------------------------------------------------------------
126     // Token owner can approve for spender to transferFrom(...) tokens
127     // from the token owner's account. The spender contract function
128     // receiveApproval(...) is then executed
129     // ------------------------------------------------------------------------
130     function approveAndCall(address spender, uint tokens, bytes data) public returns (bool success) {
131         allowed[msg.sender][spender] = tokens;
132         emit Approval(msg.sender, spender, tokens);
133         ApproveAndCallFallBack(spender).receiveApproval(msg.sender, tokens, this, data);
134         return true;
135     }
136     // ------------------------------------------------------------------------
137     // Don't accept ETH
138     // ------------------------------------------------------------------------
139     function () public payable {
140         revert();
141     }
142 }