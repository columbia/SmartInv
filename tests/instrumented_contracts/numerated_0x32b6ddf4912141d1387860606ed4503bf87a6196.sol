1 pragma solidity ^0.4.20;
2 
3 // ----------------------------------------------------------------------------
4 // 'TING' 'Simple Ting Token' contract
5 //
6 // Symbol      : TING
7 // Name        : Ting
8 // Total supply: 10,000,000.000000000000000000
9 // Decimals    : 18
10 //
11 // Enjoy.
12 //
13 // (c) BokkyPooBah / Bok Consulting Pty Ltd 2017, 2018. The MIT Licence.
14 // (c) The BlockZero Developers 2018.
15 // ----------------------------------------------------------------------------
16 
17 
18 // ----------------------------------------------------------------------------
19 // Safe maths
20 // ----------------------------------------------------------------------------
21 library SafeMath {
22     function add(uint a, uint b) internal pure returns (uint c) {
23         c = a + b;
24         require(c >= a);
25     }
26     function sub(uint a, uint b) internal pure returns (uint c) {
27         require(b <= a);
28         c = a - b;
29     }
30     function mul(uint a, uint b) internal pure returns (uint c) {
31         c = a * b;
32         require(a == 0 || c / a == b);
33     }
34     function div(uint a, uint b) internal pure returns (uint c) {
35         require(b > 0);
36         c = a / b;
37     }
38 }
39 
40 
41 // ----------------------------------------------------------------------------
42 // ERC Token Standard #20 Interface
43 // https://github.com/ethereum/EIPs/blob/master/EIPS/eip-20-token-standard.md
44 // ----------------------------------------------------------------------------
45 contract ERC20Interface {
46     function totalSupply() public constant returns (uint);
47     function balanceOf(address tokenOwner) public constant returns (uint balance);
48     function allowance(address tokenOwner, address spender) public constant returns (uint remaining);
49     function transfer(address to, uint tokens) public returns (bool success);
50     function approve(address spender, uint tokens) public returns (bool success);
51     function transferFrom(address from, address to, uint tokens) public returns (bool success);
52 
53     event Transfer(address indexed from, address indexed to, uint tokens);
54     event Approval(address indexed tokenOwner, address indexed spender, uint tokens);
55 }
56 
57 
58 // ----------------------------------------------------------------------------
59 // ERC20 Token, with the addition of symbol, name and decimals and an
60 // initial fixed supply
61 // ----------------------------------------------------------------------------
62 contract SimpleTingToken is ERC20Interface {
63     using SafeMath for uint;
64 
65     string public symbol;
66     string public  name;
67     uint8 public decimals;
68     uint public _totalSupply;
69 
70     mapping(address => uint) balances;
71     mapping(address => mapping(address => uint)) allowed;
72 
73 
74     // ------------------------------------------------------------------------
75     // Constructor
76     // ------------------------------------------------------------------------
77     function SimpleTingToken() public payable {
78         symbol = "TING";
79         name = "Ting";
80         decimals = 18;
81         _totalSupply = 10000000 * 10**uint(decimals);
82         balances[msg.sender] = _totalSupply;
83         Transfer(address(0), msg.sender, _totalSupply);
84     }
85 
86 
87     // ------------------------------------------------------------------------
88     // Total supply
89     // ------------------------------------------------------------------------
90     function totalSupply() public constant returns (uint) {
91         return _totalSupply  - balances[address(0)];
92     }
93 
94 
95     // ------------------------------------------------------------------------
96     // Get the token balance for account `tokenOwner`
97     // ------------------------------------------------------------------------
98     function balanceOf(address tokenOwner) public constant returns (uint balance) {
99         return balances[tokenOwner];
100     }
101 
102 
103     // ------------------------------------------------------------------------
104     // Transfer the balance from token owner's account to `to` account
105     // - Owner's account must have sufficient balance to transfer
106     // - 0 value transfers are allowed
107     // ------------------------------------------------------------------------
108     function transfer(address to, uint tokens) public returns (bool success) {
109         balances[msg.sender] = balances[msg.sender].sub(tokens);
110         balances[to] = balances[to].add(tokens);
111         Transfer(msg.sender, to, tokens);
112         return true;
113     }
114 
115 
116     // ------------------------------------------------------------------------
117     // Token owner can approve for `spender` to transferFrom(...) `tokens`
118     // from the token owner's account
119     //
120     // https://github.com/ethereum/EIPs/blob/master/EIPS/eip-20-token-standard.md
121     // recommends that there are no checks for the approval double-spend attack
122     // as this should be implemented in user interfaces 
123     // ------------------------------------------------------------------------
124     function approve(address spender, uint tokens) public returns (bool success) {
125         allowed[msg.sender][spender] = tokens;
126         Approval(msg.sender, spender, tokens);
127         return true;
128     }
129 
130 
131     // ------------------------------------------------------------------------
132     // Transfer `tokens` from the `from` account to the `to` account
133     // 
134     // The calling account must already have sufficient tokens approve(...)-d
135     // for spending from the `from` account and
136     // - From account must have sufficient balance to transfer
137     // - Spender must have sufficient allowance to transfer
138     // - 0 value transfers are allowed
139     // ------------------------------------------------------------------------
140     function transferFrom(address from, address to, uint tokens) public returns (bool success) {
141         balances[from] = balances[from].sub(tokens);
142         allowed[from][msg.sender] = allowed[from][msg.sender].sub(tokens);
143         balances[to] = balances[to].add(tokens);
144         Transfer(from, to, tokens);
145         return true;
146     }
147 
148 
149     // ------------------------------------------------------------------------
150     // Returns the amount of tokens approved by the owner that can be
151     // transferred to the spender's account
152     // ------------------------------------------------------------------------
153     function allowance(address tokenOwner, address spender) public constant returns (uint remaining) {
154         return allowed[tokenOwner][spender];
155     }
156 
157 
158     // ------------------------------------------------------------------------
159     // Don't accept ETH
160     // ------------------------------------------------------------------------
161     function () public payable {
162         revert();
163     }
164 }