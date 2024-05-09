1 pragma solidity ^0.4.18;
2 
3 // ----------------------------------------------------------------------------
4 // 'CTSC Token' token contract
5 //
6 // Deployed to : 0x83d9675D2C603f3F3Be7CE0379b7e74FD75a923f
7 // Symbol      : CTSC
8 // Name        : CTSC Token
9 // Total supply: 1,250,000,000.000000000000000000
10 // Decimals    : 18
11 //
12 // (c) CTSC Token 2018
13 // ----------------------------------------------------------------------------
14 
15 
16 // ----------------------------------------------------------------------------
17 // Safe maths
18 // ----------------------------------------------------------------------------
19 contract SafeMath {
20     function safeAdd(uint a, uint b) public pure returns (uint c) {
21         c = a + b;
22         require(c >= a);
23     }
24     function safeSub(uint a, uint b) public pure returns (uint c) {
25         require(b <= a);
26         c = a - b;
27     }
28     function safeMul(uint a, uint b) public pure returns (uint c) {
29         c = a * b;
30         require(a == 0 || c / a == b);
31     }
32     function safeDiv(uint a, uint b) public pure returns (uint c) {
33         require(b > 0);
34         c = a / b;
35     }
36 }
37 
38 
39 // ----------------------------------------------------------------------------
40 // ERC Token Standard #20 Interface
41 // ----------------------------------------------------------------------------
42 contract ERC20Interface {
43     function totalSupply() public constant returns (uint);
44     function balanceOf(address tokenOwner) public constant returns (uint balance);
45     function allowance(address tokenOwner, address spender) public constant returns (uint remaining);
46     function transfer(address to, uint tokens) public returns (bool success);
47     function approve(address spender, uint tokens) public returns (bool success);
48     function transferFrom(address from, address to, uint tokens) public returns (bool success);
49 
50     event Transfer(address indexed from, address indexed to, uint tokens);
51     event Approval(address indexed tokenOwner, address indexed spender, uint tokens);
52 }
53 
54 
55 // ----------------------------------------------------------------------------
56 // Contract function to receive approval and execute function in one call
57 //
58 // Borrowed from MiniMeToken
59 // ----------------------------------------------------------------------------
60 contract ApproveAndCallFallBack {
61     function receiveApproval(address from, uint256 tokens, address token, bytes data) public;
62 }
63 
64 
65 // ----------------------------------------------------------------------------
66 // Owned contract
67 // ----------------------------------------------------------------------------
68 contract Owned {
69     address public owner;
70     address public newOwner;
71 
72     event OwnershipTransferred(address indexed _from, address indexed _to);
73 
74     function Owned() public {
75         owner = msg.sender;
76     }
77 
78     modifier onlyOwner {
79         require(msg.sender == owner);
80         _;
81     }
82 
83     function transferOwnership(address _newOwner) public onlyOwner {
84         newOwner = _newOwner;
85     }
86     function acceptOwnership() public {
87         require(msg.sender == newOwner);
88         OwnershipTransferred(owner, newOwner);
89         owner = newOwner;
90         newOwner = address(0);
91     }
92 }
93 
94 
95 // ----------------------------------------------------------------------------
96 // ERC20 Token
97 // ----------------------------------------------------------------------------
98 contract CTSCToken is ERC20Interface, Owned, SafeMath {
99     string public symbol;
100     string public  name;
101     uint8 public decimals;
102     uint public _totalSupply;
103 
104     mapping(address => uint) balances;
105     mapping(address => mapping(address => uint)) allowed;
106 
107 
108     // ------------------------------------------------------------------------
109     // Constructor
110     // ------------------------------------------------------------------------
111     function CTSCToken() public {
112         symbol = "CTSC";
113         name = "CTSC Token";
114         decimals = 18;
115         _totalSupply = 1250000000000000000000000000;
116         balances[0x83d9675D2C603f3F3Be7CE0379b7e74FD75a923f] = _totalSupply;
117         Transfer(address(0), 0x83d9675D2C603f3F3Be7CE0379b7e74FD75a923f, _totalSupply);
118     }
119 
120 
121     // ------------------------------------------------------------------------
122     // Total supply
123     // ------------------------------------------------------------------------
124     function totalSupply() public constant returns (uint) {
125         return _totalSupply  - balances[address(0)];
126     }
127 
128 
129     // ------------------------------------------------------------------------
130     // Get the token balance for account tokenOwner
131     // ------------------------------------------------------------------------
132     function balanceOf(address tokenOwner) public constant returns (uint balance) {
133         return balances[tokenOwner];
134     }
135 
136 
137     // ------------------------------------------------------------------------
138     // Transfer the balance from token owner's account to to account
139     // - Owner's account must have sufficient balance to transfer
140     // - 0 value transfers are allowed
141     // ------------------------------------------------------------------------
142     function transfer(address to, uint tokens) public returns (bool success) {
143         balances[msg.sender] = safeSub(balances[msg.sender], tokens);
144         balances[to] = safeAdd(balances[to], tokens);
145         Transfer(msg.sender, to, tokens);
146         return true;
147     }
148 
149 
150     // ------------------------------------------------------------------------
151     // Token owner can approve for spender to transferFrom(...) tokens
152     // from the token owner's account
153     // ------------------------------------------------------------------------
154     function approve(address spender, uint tokens) public returns (bool success) {
155         allowed[msg.sender][spender] = tokens;
156         Approval(msg.sender, spender, tokens);
157         return true;
158     }
159 
160 
161     // ------------------------------------------------------------------------
162     // Transfer tokens from the from account to the to account
163     // 
164     // The calling account must already have sufficient tokens approve(...)-d
165     // for spending from the from account and
166     // - From account must have sufficient balance to transfer
167     // - Spender must have sufficient allowance to transfer
168     // - 0 value transfers are allowed
169     // ------------------------------------------------------------------------
170     function transferFrom(address from, address to, uint tokens) public returns (bool success) {
171         balances[from] = safeSub(balances[from], tokens);
172         allowed[from][msg.sender] = safeSub(allowed[from][msg.sender], tokens);
173         balances[to] = safeAdd(balances[to], tokens);
174         Transfer(from, to, tokens);
175         return true;
176     }
177 
178 
179     // ------------------------------------------------------------------------
180     // Returns the amount of tokens approved by the owner that can be
181     // transferred to the spender's account
182     // ------------------------------------------------------------------------
183     function allowance(address tokenOwner, address spender) public constant returns (uint remaining) {
184         return allowed[tokenOwner][spender];
185     }
186 
187 
188     // ------------------------------------------------------------------------
189     // Token owner can approve for spender to transferFrom(...) tokens
190     // from the token owner's account. The spender contract function
191     // receiveApproval(...) is then executed
192     // ------------------------------------------------------------------------
193     function approveAndCall(address spender, uint tokens, bytes data) public returns (bool success) {
194         allowed[msg.sender][spender] = tokens;
195         Approval(msg.sender, spender, tokens);
196         ApproveAndCallFallBack(spender).receiveApproval(msg.sender, tokens, this, data);
197         return true;
198     }
199 
200 
201     // ------------------------------------------------------------------------
202     // Don't accept ETH
203     // ------------------------------------------------------------------------
204     function () public payable {
205         revert();
206     }
207 
208 
209     // ------------------------------------------------------------------------
210     // Owner can transfer out any accidentally sent ERC20 tokens
211     // ------------------------------------------------------------------------
212     function transferAnyERC20Token(address tokenAddress, uint tokens) public onlyOwner returns (bool success) {
213         return ERC20Interface(tokenAddress).transfer(owner, tokens);
214     }
215 }