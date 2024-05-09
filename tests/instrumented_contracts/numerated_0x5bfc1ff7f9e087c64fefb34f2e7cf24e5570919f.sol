1 // ----------------------------------------------------------------------------
2 // Safe maths
3 // ----------------------------------------------------------------------------
4 pragma solidity 0.4.26;
5 
6 contract SafeMath {
7     function safeAdd(uint a, uint b) public pure returns (uint c) {
8         c = a + b;
9         require(c >= a);
10     }
11     function safeSub(uint a, uint b) public pure returns (uint c) {
12         require(b <= a);
13         c = a - b;
14     }
15     function safeMul(uint a, uint b) public pure returns (uint c) {
16         c = a * b;
17         require(a == 0 || c / a == b);
18     }
19     function safeDiv(uint a, uint b) public pure returns (uint c) {
20         require(b > 0);
21         c = a / b;
22     }
23 }
24 
25 
26 // ----------------------------------------------------------------------------
27 // ERC Token Standard #20 Interface
28 // https://github.com/ethereum/EIPs/blob/master/EIPS/eip-20-token-standard.md
29 // ----------------------------------------------------------------------------
30 contract ERC20Interface {
31     function totalSupply() public constant returns (uint);
32     function balanceOf(address tokenOwner) public constant returns (uint balance);
33     function allowance(address tokenOwner, address spender) public constant returns (uint remaining);
34     function transfer(address to, uint tokens) public returns (bool success);
35     function approve(address spender, uint tokens) public returns (bool success);
36     function transferFrom(address from, address to, uint tokens) public returns (bool success);
37 
38     event Transfer(address indexed from, address indexed to, uint tokens);
39     event Approval(address indexed tokenOwner, address indexed spender, uint tokens);
40 }
41 
42 
43 // ----------------------------------------------------------------------------
44 // Contract function to receive approval and execute function in one call
45 //
46 // Borrowed from MiniMeToken
47 // ----------------------------------------------------------------------------
48 contract ApproveAndCallFallBack {
49     function receiveApproval(address from, uint256 tokens, address token, bytes data) public;
50 }
51 
52 
53 // ----------------------------------------------------------------------------
54 // Owned contract
55 // ----------------------------------------------------------------------------
56 contract Owned {
57     address public owner;
58     address public newOwner;
59 
60     event OwnershipTransferred(address indexed _from, address indexed _to);
61 
62     function Owned() public {
63         owner = msg.sender;
64     }
65 
66     modifier onlyOwner {
67         require(msg.sender == owner);
68         _;
69     }
70 
71     function transferOwnership(address _newOwner) public onlyOwner {
72         newOwner = _newOwner;
73     }
74     function acceptOwnership() public {
75         require(msg.sender == newOwner);
76         emit OwnershipTransferred(owner, newOwner);
77         owner = newOwner;
78         newOwner = address(0);
79     }
80 }
81 
82 
83 // ----------------------------------------------------------------------------
84 // ERC20 Token, with the addition of symbol, name and decimals and assisted
85 // token transfers
86 // ----------------------------------------------------------------------------
87 contract Habitus is ERC20Interface, Owned, SafeMath {
88     string public symbol;
89     string public  name;
90     uint8 public decimals;
91     uint public _totalSupply;
92 
93 
94     mapping(address => uint) balances;
95     mapping(address => mapping(address => uint)) allowed;
96 
97 
98     // ------------------------------------------------------------------------
99     // Constructor
100     // ------------------------------------------------------------------------
101     function Habitus() public {
102         symbol = "HABS";
103         name = "Habitus";
104         decimals = 18;
105         _totalSupply = 500000000000 * 10**18;
106         balances[0x9230bde0EfC57Bc6E69213cFBBA837Ec6ce91F53] = _totalSupply;
107         emit Transfer(address(0), 0x9230bde0EfC57Bc6E69213cFBBA837Ec6ce91F53, _totalSupply);
108     }
109 
110 
111     // ------------------------------------------------------------------------
112     // Total supply
113     // ------------------------------------------------------------------------
114     function totalSupply() public constant returns (uint) {
115         return _totalSupply  - balances[address(0)];
116     }
117 
118 
119     // ------------------------------------------------------------------------
120     // Get the token balance for account tokenOwner
121     // ------------------------------------------------------------------------
122     function balanceOf(address tokenOwner) public constant returns (uint balance) {
123         return balances[tokenOwner];
124     }
125 
126 
127     // ------------------------------------------------------------------------
128     // Transfer the balance from token owner's account to to account
129     // - Owner's account must have sufficient balance to transfer
130     // - 0 value transfers are allowed
131     // ------------------------------------------------------------------------
132     function transfer(address to, uint tokens) public returns (bool success) {
133         balances[msg.sender] = safeSub(balances[msg.sender], tokens);
134         balances[to] = safeAdd(balances[to], tokens);
135         emit Transfer(msg.sender, to, tokens);
136         return true;
137     }
138 
139 
140     // ------------------------------------------------------------------------
141     // Token owner can approve for spender to transferFrom(...) tokens
142     // from the token owner's account
143     //
144     // https://github.com/ethereum/EIPs/blob/master/EIPS/eip-20-token-standard.md
145     // recommends that there are no checks for the approval double-spend attack
146     // as this should be implemented in user interfaces 
147     // ------------------------------------------------------------------------
148     function approve(address spender, uint tokens) public returns (bool success) {
149         allowed[msg.sender][spender] = tokens;
150         emit Approval(msg.sender, spender, tokens);
151         return true;
152     }
153 
154 
155     // ------------------------------------------------------------------------
156     // Transfer tokens from the from account to the to account
157     // 
158     // The calling account must already have sufficient tokens approve(...)-d
159     // for spending from the from account and
160     // - From account must have sufficient balance to transfer
161     // - Spender must have sufficient allowance to transfer
162     // - 0 value transfers are allowed
163     // ------------------------------------------------------------------------
164     function transferFrom(address from, address to, uint tokens) public returns (bool success) {
165         balances[from] = safeSub(balances[from], tokens);
166         allowed[from][msg.sender] = safeSub(allowed[from][msg.sender], tokens);
167         balances[to] = safeAdd(balances[to], tokens);
168         emit Transfer(from, to, tokens);
169         return true;
170     }
171 
172 
173     // ------------------------------------------------------------------------
174     // Returns the amount of tokens approved by the owner that can be
175     // transferred to the spender's account
176     // ------------------------------------------------------------------------
177     function allowance(address tokenOwner, address spender) public constant returns (uint remaining) {
178         return allowed[tokenOwner][spender];
179     }
180 
181 
182     // ------------------------------------------------------------------------
183     // Token owner can approve for spender to transferFrom(...) tokens
184     // from the token owner's account. The spender contract function
185     // receiveApproval(...) is then executed
186     // ------------------------------------------------------------------------
187     function approveAndCall(address spender, uint tokens, bytes data) public returns (bool success) {
188         allowed[msg.sender][spender] = tokens;
189         emit Approval(msg.sender, spender, tokens);
190         ApproveAndCallFallBack(spender).receiveApproval(msg.sender, tokens, this, data);
191         return true;
192     }
193 
194 
195     // ------------------------------------------------------------------------
196     // Don't accept ETH
197     // ------------------------------------------------------------------------
198     function () public payable {
199         revert();
200     }
201 
202 
203     // ------------------------------------------------------------------------
204     // Owner can transfer out any accidentally sent ERC20 tokens
205     // ------------------------------------------------------------------------
206     function transferAnyERC20Token(address tokenAddress, uint tokens) public onlyOwner returns (bool success) {
207         return ERC20Interface(tokenAddress).transfer(owner, tokens);
208     }
209 }