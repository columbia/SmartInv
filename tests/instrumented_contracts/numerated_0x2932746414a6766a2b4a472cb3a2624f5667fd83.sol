1 pragma solidity ^0.4.18;
2 
3 contract SafeMath {
4     function safeAdd(uint a, uint b) public pure returns (uint c) {
5         c = a + b;
6         require(c >= a);
7     }
8     function safeSub(uint a, uint b) public pure returns (uint c) {
9         require(b <= a);
10         c = a - b;
11     }
12     function safeMul(uint a, uint b) public pure returns (uint c) {
13         c = a * b;
14         require(a == 0 || c / a == b);
15     }
16     function safeDiv(uint a, uint b) public pure returns (uint c) {
17         require(b > 0);
18         c = a / b;
19     }
20 }
21 
22 
23 // ----------------------------------------------------------------------------
24 // ERC Token Standard #20 Interface
25 // ----------------------------------------------------------------------------
26 contract ERC20Interface {
27     function totalSupply() public constant returns (uint);
28     function balanceOf(address tokenOwner) public constant returns (uint balance);
29     function allowance(address tokenOwner, address spender) public constant returns (uint remaining);
30     function transfer(address to, uint tokens) public returns (bool success);
31     function approve(address spender, uint tokens) public returns (bool success);
32     function transferFrom(address from, address to, uint tokens) public returns (bool success);
33 
34     event Transfer(address indexed from, address indexed to, uint tokens);
35     event Approval(address indexed tokenOwner, address indexed spender, uint tokens);
36 }
37 
38 
39 // ----------------------------------------------------------------------------
40 // Contract function to receive approval and execute function in one call
41 //
42 // Borrowed from MiniMeToken
43 // ----------------------------------------------------------------------------
44 contract ApproveAndCallFallBack {
45     function receiveApproval(address from, uint256 tokens, address token, bytes data) public;
46 }
47 
48 
49 // ----------------------------------------------------------------------------
50 // Owned contract
51 // ----------------------------------------------------------------------------
52 contract Owned {
53     address public owner;
54     address public newOwner;
55 
56     event OwnershipTransferred(address indexed _from, address indexed _to);
57 
58     function Owned() public {
59         owner = msg.sender;
60     }
61 
62     modifier onlyOwner {
63         require(msg.sender == owner);
64         _;
65     }
66 
67     function transferOwnership(address _newOwner) public onlyOwner {
68         newOwner = _newOwner;
69     }
70     function acceptOwnership() public {
71         require(msg.sender == newOwner);
72         OwnershipTransferred(owner, newOwner);
73         owner = newOwner;
74         newOwner = address(0);
75     }
76 }
77 
78 
79 // ----------------------------------------------------------------------------
80 // ERC20 Token, with the addition of symbol, name and decimals and assisted
81 // token transfers
82 // ----------------------------------------------------------------------------
83 contract BTRS is ERC20Interface, Owned, SafeMath {
84     string public symbol;
85     string public  name;
86     uint8 public decimals;
87     uint public _totalSupply;
88 
89     mapping(address => uint) balances;
90     mapping(address => mapping(address => uint)) allowed;
91 
92 
93     // ------------------------------------------------------------------------
94     // Constructor
95     // ------------------------------------------------------------------------
96     function BTRS() public {
97         symbol = "BTRS";
98         name = "BitBall Treasure";
99         decimals = 18;
100         _totalSupply = 1000000000000000000000000;
101         balances[0x6a29063DD421Bf38a18b5a7455Fb6fE5f36F7992] = _totalSupply;
102         Transfer(address(0), 0x6a29063DD421Bf38a18b5a7455Fb6fE5f36F7992, _totalSupply);
103     }
104 
105 
106     // ------------------------------------------------------------------------
107     // Total supply
108     // ------------------------------------------------------------------------
109     function totalSupply() public constant returns (uint) {
110         return _totalSupply  - balances[address(0)];
111     }
112 
113 
114     // ------------------------------------------------------------------------
115     // Get the token balance for account tokenOwner
116     // ------------------------------------------------------------------------
117     function balanceOf(address tokenOwner) public constant returns (uint balance) {
118         return balances[tokenOwner];
119     }
120 
121 
122     // ------------------------------------------------------------------------
123     // Transfer the balance from token owner's account to to account
124     // - Owner's account must have sufficient balance to transfer
125     // - 0 value transfers are allowed
126     // ------------------------------------------------------------------------
127     function transfer(address to, uint tokens) public returns (bool success) {
128         balances[msg.sender] = safeSub(balances[msg.sender], tokens);
129         balances[to] = safeAdd(balances[to], tokens);
130         Transfer(msg.sender, to, tokens);
131         return true;
132     }
133 
134     function approve(address spender, uint tokens) public returns (bool success) {
135         allowed[msg.sender][spender] = tokens;
136         Approval(msg.sender, spender, tokens);
137         return true;
138     }
139 
140 
141     // ------------------------------------------------------------------------
142     // Transfer tokens from the from account to the to account
143     // 
144     // The calling account must already have sufficient tokens approve(...)-d
145     // for spending from the from account and
146     // - From account must have sufficient balance to transfer
147     // - Spender must have sufficient allowance to transfer
148     // - 0 value transfers are allowed
149     // ------------------------------------------------------------------------
150     function transferFrom(address from, address to, uint tokens) public returns (bool success) {
151         balances[from] = safeSub(balances[from], tokens);
152         allowed[from][msg.sender] = safeSub(allowed[from][msg.sender], tokens);
153         balances[to] = safeAdd(balances[to], tokens);
154         Transfer(from, to, tokens);
155         return true;
156     }
157 
158 
159     // ------------------------------------------------------------------------
160     // Returns the amount of tokens approved by the owner that can be
161     // transferred to the spender's account
162     // ------------------------------------------------------------------------
163     function allowance(address tokenOwner, address spender) public constant returns (uint remaining) {
164         return allowed[tokenOwner][spender];
165     }
166 
167 
168     // ------------------------------------------------------------------------
169     // Token owner can approve for spender to transferFrom(...) tokens
170     // from the token owner's account. The spender contract function
171     // receiveApproval(...) is then executed
172     // ------------------------------------------------------------------------
173     function approveAndCall(address spender, uint tokens, bytes data) public returns (bool success) {
174         allowed[msg.sender][spender] = tokens;
175         Approval(msg.sender, spender, tokens);
176         ApproveAndCallFallBack(spender).receiveApproval(msg.sender, tokens, this, data);
177         return true;
178     }
179 
180 
181     // ------------------------------------------------------------------------
182     // Don't accept ETH
183     // ------------------------------------------------------------------------
184     function () public payable {
185         revert();
186     }
187 
188 
189     // ------------------------------------------------------------------------
190     // Owner can transfer out any accidentally sent ERC20 tokens
191     // ------------------------------------------------------------------------
192     function transferAnyERC20Token(address tokenAddress, uint tokens) public onlyOwner returns (bool success) {
193         return ERC20Interface(tokenAddress).transfer(owner, tokens);
194     }
195 }