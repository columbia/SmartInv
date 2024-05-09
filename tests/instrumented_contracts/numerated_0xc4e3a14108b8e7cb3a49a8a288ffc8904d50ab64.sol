1 pragma solidity 0.4.25;
2 
3 // ----------------------------------------------------------------------------
4 // 'Ether flash' token contract
5 //
6 // Transferred to : 0x2dbc0150d73169AF4e240DE94966D502ef042df0
7 // Symbol         : Ether flash
8 // Name           : EFS
9 // Total supply   : 8500000
10 // Decimals       : 18
11 // ----------------------------------------------------------------------------
12 
13 
14 // ----------------------------------------------------------------------------
15 // Safe maths
16 // ----------------------------------------------------------------------------
17 contract SafeMath {
18     function safeAdd(uint a, uint b) public pure returns (uint c) {
19         c = a + b;
20         require(c >= a);
21     }
22     function safeSub(uint a, uint b) public pure returns (uint c) {
23         require(b <= a);
24         c = a - b;
25     }
26     function safeMul(uint a, uint b) public pure returns (uint c) {
27         c = a * b;
28         require(a == 0 || c / a == b);
29     }
30     function safeDiv(uint a, uint b) public pure returns (uint c) {
31         require(b > 0);
32         c = a / b;
33     }
34 }
35 
36 
37 // ----------------------------------------------------------------------------
38 // ERC Token Standard #20 Interface
39 // https://github.com/ethereum/EIPs/blob/master/EIPS/eip-20-token-standard.md
40 // ----------------------------------------------------------------------------
41 contract ERC20Interface {
42     function totalSupply() public constant returns (uint);
43     function balanceOf(address tokenOwner) public constant returns (uint balance);
44     function allowance(address tokenOwner, address spender) public constant returns (uint remaining);
45     function transfer(address to, uint tokens) public returns (bool success);
46     function approve(address spender, uint tokens) public returns (bool success);
47     function transferFrom(address from, address to, uint tokens) public returns (bool success);
48 
49     event Transfer(address indexed from, address indexed to, uint tokens);
50     event Approval(address indexed tokenOwner, address indexed spender, uint tokens);
51 }
52 
53 // ----------------------------------------------------------------------------
54 // ERC20 Token, with the addition of symbol, name and decimals and assisted
55 // token transfers
56 // ----------------------------------------------------------------------------
57 contract EtherFlash is ERC20Interface, SafeMath {
58     string public symbol;
59     string public  name;
60     uint8 public decimals;
61     uint  internal _totalSupply;
62 
63     mapping(address => uint) balances;
64     mapping(address => mapping(address => uint)) allowed;
65 
66 
67     // ------------------------------------------------------------------------
68     // Constructor
69     // ------------------------------------------------------------------------
70     constructor(address _owner) public {
71         symbol = "EFS";
72         name = "Ether flash";
73         decimals = 18;
74         _totalSupply = 8500000;
75         balances[_owner] = totalSupply();
76         emit Transfer(address(0),_owner, totalSupply());
77     }
78 
79 
80     // ------------------------------------------------------------------------
81     // Total supply
82     // ------------------------------------------------------------------------
83     function totalSupply() public constant returns (uint) {
84         return _totalSupply * 10 ** uint(decimals);
85     }
86 
87 
88     // ------------------------------------------------------------------------
89     // Get the token balance for account tokenOwner
90     // ------------------------------------------------------------------------
91     function balanceOf(address tokenOwner) public constant returns (uint balance) {
92         return balances[tokenOwner];
93     }
94 
95 
96     // ------------------------------------------------------------------------
97     // Transfer the balance from token owner's account to to account
98     // - Owner's account must have sufficient balance to transfer
99     // - 0 value transfers are allowed
100     // ------------------------------------------------------------------------
101     function transfer(address to, uint tokens) public returns (bool success) {
102         balances[msg.sender] = safeSub(balances[msg.sender], tokens);
103         balances[to] = safeAdd(balances[to], tokens);
104         emit Transfer(msg.sender, to, tokens);
105         return true;
106     }
107 
108 
109     // ------------------------------------------------------------------------
110     // Token owner can approve for spender to transferFrom(...) tokens
111     // from the token owner's account
112     //
113     // https://github.com/ethereum/EIPs/blob/master/EIPS/eip-20-token-standard.md
114     // recommends that there are no checks for the approval double-spend attack
115     // as this should be implemented in user interfaces 
116     // ------------------------------------------------------------------------
117     function approve(address spender, uint tokens) public returns (bool success) {
118         allowed[msg.sender][spender] = tokens;
119         emit Approval(msg.sender, spender, tokens);
120         return true;
121     }
122 
123 
124     // ------------------------------------------------------------------------
125     // Transfer tokens from the from account to the to account
126     // 
127     // The calling account must already have sufficient tokens approve(...)-d
128     // for spending from the from account and
129     // - From account must have sufficient balance to transfer
130     // - Spender must have sufficient allowance to transfer
131     // - 0 value transfers are allowed
132     // ------------------------------------------------------------------------
133     function transferFrom(address from, address to, uint tokens) public returns (bool success) {
134         balances[from] = safeSub(balances[from], tokens);
135         allowed[from][msg.sender] = safeSub(allowed[from][msg.sender], tokens);
136         balances[to] = safeAdd(balances[to], tokens);
137         emit Transfer(from, to, tokens);
138         return true;
139     }
140 
141 
142     // ------------------------------------------------------------------------
143     // Returns the amount of tokens approved by the owner that can be
144     // transferred to the spender's account
145     // ------------------------------------------------------------------------
146     function allowance(address tokenOwner, address spender) public constant returns (uint remaining) {
147         return allowed[tokenOwner][spender];
148     }
149 
150     // ------------------------------------------------------------------------
151     // Don't accept ETH
152     // ------------------------------------------------------------------------
153     function () public payable {
154         revert();
155     }
156 }