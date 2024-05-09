1 pragma solidity ^0.4.24;
2 
3 // ----------------------------------------------------------------------------
4 // 'KKK' token contract
5 //
6 // Deployed to : 0x30027de761a3824fD67bC3fb8cC7Bad1963429bB
7 // Symbol      : KKK
8 // Name        : Triple K
9 // Total supply: 1000000000
10 // Decimals    : 2
11 //
12 // ----------------------------------------------------------------------------
13 // Safe maths
14 // ----------------------------------------------------------------------------
15 contract SafeMath {
16     function safeAdd(uint a, uint b) public pure returns (uint c) {
17         c = a + b;
18         require(c >= a);
19     }
20     function safeSub(uint a, uint b) public pure returns (uint c) {
21         require(b <= a);
22         c = a - b;
23     }
24     function safeMul(uint a, uint b) public pure returns (uint c) {
25         c = a * b;
26         require(a == 0 || c / a == b);
27     }
28     function safeDiv(uint a, uint b) public pure returns (uint c) {
29         require(b > 0);
30         c = a / b;
31     }
32 }
33 
34 
35 // ----------------------------------------------------------------------------
36 contract ERC20Interface {
37     function totalSupply() public constant returns (uint);
38     function balanceOf(address tokenOwner) public constant returns (uint balance);
39     function allowance(address tokenOwner, address spender) public constant returns (uint remaining);
40     function transfer(address to, uint tokens) public returns (bool success);
41     function approve(address spender, uint tokens) public returns (bool success);
42     function transferFrom(address from, address to, uint tokens) public returns (bool success);
43 
44     event Transfer(address indexed from, address indexed to, uint tokens);
45     event Approval(address indexed tokenOwner, address indexed spender, uint tokens);
46 }
47 
48 
49 // ----------------------------------------------------------------------------
50 contract ApproveAndCallFallBack {
51     function receiveApproval(address from, uint256 tokens, address token, bytes data) public;
52 }
53 
54 
55 // ----------------------------------------------------------------------------
56 // Owned contract
57 // ----------------------------------------------------------------------------
58 contract Owned {
59     address public owner;
60     address public newOwner;
61 
62     event OwnershipTransferred(address indexed _from, address indexed _to);
63 
64     constructor() public {
65         owner = msg.sender;
66     }
67 
68     modifier onlyOwner {
69         require(msg.sender == owner);
70         _;
71     }
72 
73     function transferOwnership(address _newOwner) public onlyOwner {
74         newOwner = _newOwner;
75     }
76     function acceptOwnership() public {
77         require(msg.sender == newOwner);
78         emit OwnershipTransferred(owner, newOwner);
79         owner = newOwner;
80         newOwner = address(0);
81     }
82 }
83 
84 
85 // ----------------------------------------------------------------------------
86 // ERC20 Token, with the addition of symbol, name and decimals and assisted
87 // token transfers
88 // ----------------------------------------------------------------------------
89 contract TripleK is ERC20Interface, Owned, SafeMath {
90     string public symbol;
91     string public name;
92     uint8 public decimals;
93     uint public _totalSupply;
94 
95     mapping(address => uint) balances;
96     mapping(address => mapping(address => uint)) allowed;
97 
98 
99     // ------------------------------------------------------------------------
100     // Constructor
101     // ------------------------------------------------------------------------
102     constructor() public {
103         symbol = "KKK";
104         name = "Triple K";
105         decimals = 2;   
106         _totalSupply = 100000000000;
107         balances[0x30027de761a3824fD67bC3fb8cC7Bad1963429bB] = _totalSupply;
108         emit Transfer(address(0), 0x30027de761a3824fD67bC3fb8cC7Bad1963429bB, _totalSupply);
109     }
110 
111 
112     // ------------------------------------------------------------------------
113     // Total supply
114     // ------------------------------------------------------------------------
115     function totalSupply() public constant returns (uint) {
116         return _totalSupply  - balances[address(0)];
117     }
118 
119 
120     // ------------------------------------------------------------------------
121     // Get the token balance for account tokenOwner
122     // ------------------------------------------------------------------------
123     function balanceOf(address tokenOwner) public constant returns (uint balance) {
124         return balances[tokenOwner];
125     }
126 
127 
128     // ------------------------------------------------------------------------
129     // Transfer the balance from token owner's account to to account
130     // - Owner's account must have sufficient balance to transfer
131     // - 0 value transfers are allowed
132     // ------------------------------------------------------------------------
133     function transfer(address to, uint tokens) public returns (bool success) {
134         balances[msg.sender] = safeSub(balances[msg.sender], tokens);
135         balances[to] = safeAdd(balances[to], tokens);
136         emit Transfer(msg.sender, to, tokens);
137         return true;
138     }
139 
140 
141     // ------------------------------------------------------------------------
142     // Token owner can approve for spender to transferFrom(...) tokens
143     // from the token owner's account
144     //
145     // https://github.com/ethereum/EIPs/blob/master/EIPS/eip-20-token-standard.md
146     // recommends that there are no checks for the approval double-spend attack
147     // as this should be implemented in user interfaces 
148     // ------------------------------------------------------------------------
149     function approve(address spender, uint tokens) public returns (bool success) {
150         allowed[msg.sender][spender] = tokens;
151         emit Approval(msg.sender, spender, tokens);
152         return true;
153     }
154 
155 
156     // ------------------------------------------------------------------------
157     // Transfer tokens from the from account to the to account
158     // 
159     // The calling account must already have sufficient tokens approve(...)-d
160     // for spending from the from account and
161     // - From account must have sufficient balance to transfer
162     // - Spender must have sufficient allowance to transfer
163     // - 0 value transfers are allowed
164     // ------------------------------------------------------------------------
165     function transferFrom(address from, address to, uint tokens) public returns (bool success) {
166         balances[from] = safeSub(balances[from], tokens);
167         allowed[from][msg.sender] = safeSub(allowed[from][msg.sender], tokens);
168         balances[to] = safeAdd(balances[to], tokens);
169         emit Transfer(from, to, tokens);
170         return true;
171     }
172 
173 
174     // ------------------------------------------------------------------------
175     // Returns the amount of tokens approved by the owner that can be
176     // transferred to the spender's account
177     // ------------------------------------------------------------------------
178     function allowance(address tokenOwner, address spender) public constant returns (uint remaining) {
179         return allowed[tokenOwner][spender];
180     }
181 
182 
183     // ------------------------------------------------------------------------
184     // Token owner can approve for spender to transferFrom(...) tokens
185     // from the token owner's account. The spender contract function
186     // receiveApproval(...) is then executed
187     // ------------------------------------------------------------------------
188     function approveAndCall(address spender, uint tokens, bytes data) public returns (bool success) {
189         allowed[msg.sender][spender] = tokens;
190         emit Approval(msg.sender, spender, tokens);
191         ApproveAndCallFallBack(spender).receiveApproval(msg.sender, tokens, this, data);
192         return true;
193     }
194 
195 
196     // ------------------------------------------------------------------------
197     // Don't accept ETH
198     // ------------------------------------------------------------------------
199     function () public payable {
200         revert();
201     }
202 
203 
204     // ------------------------------------------------------------------------
205     // Owner can transfer out any accidentally sent ERC20 tokens
206     // ------------------------------------------------------------------------
207     function transferAnyERC20Token(address tokenAddress, uint tokens) public onlyOwner returns (bool success) {
208         return ERC20Interface(tokenAddress).transfer(owner, tokens);
209     }
210 }