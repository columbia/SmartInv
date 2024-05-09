1 pragma solidity ^0.4.21;
2 
3 
4 // ----------------------------------------------------------------------------
5 // Safe maths
6 // ----------------------------------------------------------------------------
7 contract SafeMath {
8     function safeAdd(uint a, uint b) public pure returns (uint c) {
9         c = a + b;
10         require(c >= a);
11     }
12     function safeSub(uint a, uint b) public pure returns (uint c) {
13         require(b <= a);
14         c = a - b;
15     }
16     function safeMul(uint a, uint b) public pure returns (uint c) {
17         c = a * b;
18         require(a == 0 || c / a == b);
19     }
20     function safeDiv(uint a, uint b) public pure returns (uint c) {
21         require(b > 0);
22         c = a / b;
23     }
24 }
25 
26 
27 // ----------------------------------------------------------------------------
28 // ERC Token Standard #20 Interface
29 // https://github.com/ethereum/EIPs/blob/master/EIPS/eip-20-token-standard.md
30 // ----------------------------------------------------------------------------
31 contract ERC20Interface {
32     function totalSupply() public constant returns (uint);
33     function balanceOf(address tokenOwner) public constant returns (uint balance);
34     function allowance(address tokenOwner, address spender) public constant returns (uint remaining);
35     function transfer(address to, uint tokens) public returns (bool success);
36     function approve(address spender, uint tokens) public returns (bool success);
37     function transferFrom(address from, address to, uint tokens) public returns (bool success);
38 
39     event Transfer(address indexed from, address indexed to, uint tokens);
40     event Approval(address indexed tokenOwner, address indexed spender, uint tokens);
41 }
42 
43 
44 // ----------------------------------------------------------------------------
45 // Contract function to receive approval and execute function in one call
46 //
47 // Borrowed from MiniMeToken
48 // ----------------------------------------------------------------------------
49 contract ApproveAndCallFallBack {
50     function receiveApproval(address from, uint256 tokens, address token, bytes data) public;
51 }
52 
53 
54 // ----------------------------------------------------------------------------
55 // Owned contract
56 // ----------------------------------------------------------------------------
57 contract Owned {
58     address public owner;
59     address public newOwner;
60 
61     event OwnershipTransferred(address indexed _from, address indexed _to);
62 
63     constructor() public {
64         owner = msg.sender;
65     }
66 
67     modifier onlyOwner {
68         require(msg.sender == owner);
69         _;
70     }
71 
72     function transferOwnership(address _newOwner) public onlyOwner {
73         newOwner = _newOwner;
74     }
75     function acceptOwnership() public {
76         require(msg.sender == newOwner);
77         
78         emit OwnershipTransferred(owner, newOwner);
79         
80         owner = newOwner;
81         newOwner = address(0);
82     }
83 }
84 
85 
86 // ----------------------------------------------------------------------------
87 // ERC20 Token, with the addition of symbol, name and decimals and assisted
88 // token transfers
89 // ----------------------------------------------------------------------------
90 contract FCS is ERC20Interface, Owned, SafeMath {
91     string public symbol;
92     string public  name;
93     uint8 public decimals;
94     uint public _totalSupply;
95 
96     mapping(address => uint) balances;
97     mapping(address => mapping(address => uint)) allowed;
98 
99 
100     // ------------------------------------------------------------------------
101     // Constructor
102     // ------------------------------------------------------------------------
103     constructor() public {
104         symbol = "FCS";
105         name = "Five Color Stone";
106         decimals = 18;
107         _totalSupply = 2000000000000000000000000000;
108         
109         balances[0xa45760889D1c27804Dc6D6B89D4095e8Eb99ab72] = _totalSupply;
110         emit Transfer(address(0), 0xa45760889D1c27804Dc6D6B89D4095e8Eb99ab72, _totalSupply);
111     }
112 
113     // ------------------------------------------------------------------------
114     // Total supply
115     // ------------------------------------------------------------------------
116     function totalSupply() public constant returns (uint) {
117         return _totalSupply  - balances[address(0)];
118     }
119 
120 
121     // ------------------------------------------------------------------------
122     // Get the token balance for account tokenOwner
123     // ------------------------------------------------------------------------
124     function balanceOf(address tokenOwner) public constant returns (uint balance) {
125         return balances[tokenOwner];
126     }
127 
128 
129     // ------------------------------------------------------------------------
130     // Transfer the balance from token owner's account to to account
131     // - Owner's account must have sufficient balance to transfer
132     // - 0 value transfers are allowed
133     // ------------------------------------------------------------------------
134     function transfer(address to, uint tokens) public returns (bool success) {
135         balances[msg.sender] = safeSub(balances[msg.sender], tokens);
136         balances[to] = safeAdd(balances[to], tokens);
137         
138         emit Transfer(msg.sender, to, tokens);
139         return true;
140     }
141 
142 
143     // ------------------------------------------------------------------------
144     // Token owner can approve for spender to transferFrom(...) tokens
145     // from the token owner's account
146     //
147     // https://github.com/ethereum/EIPs/blob/master/EIPS/eip-20-token-standard.md
148     // recommends that there are no checks for the approval double-spend attack
149     // as this should be implemented in user interfaces 
150     // ------------------------------------------------------------------------
151     function approve(address spender, uint tokens) public returns (bool success) {
152         allowed[msg.sender][spender] = tokens;
153        
154         emit Approval(msg.sender, spender, tokens);
155         return true;
156     }
157 
158 
159     // ------------------------------------------------------------------------
160     // Transfer tokens from the from account to the to account
161     // 
162     // The calling account must already have sufficient tokens approve(...)-d
163     // for spending from the from account and
164     // - From account must have sufficient balance to transfer
165     // - Spender must have sufficient allowance to transfer
166     // - 0 value transfers are allowed
167     // ------------------------------------------------------------------------
168     function transferFrom(address from, address to, uint tokens) public returns (bool success) {
169         balances[from] = safeSub(balances[from], tokens);
170         allowed[from][msg.sender] = safeSub(allowed[from][msg.sender], tokens);
171         balances[to] = safeAdd(balances[to], tokens);
172         
173         emit Transfer(from, to, tokens);
174         return true;
175     }
176 
177 
178     // ------------------------------------------------------------------------
179     // Returns the amount of tokens approved by the owner that can be
180     // transferred to the spender's account
181     // ------------------------------------------------------------------------
182     function allowance(address tokenOwner, address spender) public constant returns (uint remaining) {
183         return allowed[tokenOwner][spender];
184     }
185 
186 
187     // ------------------------------------------------------------------------
188     // Token owner can approve for spender to transferFrom(...) tokens
189     // from the token owner's account. The spender contract function
190     // receiveApproval(...) is then executed
191     // ------------------------------------------------------------------------
192     function approveAndCall(address spender, uint tokens, bytes data) public returns (bool success) {
193         allowed[msg.sender][spender] = tokens;
194         
195         emit Approval(msg.sender, spender, tokens);
196         ApproveAndCallFallBack(spender).receiveApproval(msg.sender, tokens, this, data);
197         return true;
198     }
199 
200 
201     // ------------------------------------------------------------------------
202     // Owner can transfer out any accidentally sent ERC20 tokens
203     // ------------------------------------------------------------------------
204     function transferAnyERC20Token(address tokenAddress, uint tokens) public onlyOwner returns (bool success) {
205         return ERC20Interface(tokenAddress).transfer(owner, tokens);
206     }
207 }