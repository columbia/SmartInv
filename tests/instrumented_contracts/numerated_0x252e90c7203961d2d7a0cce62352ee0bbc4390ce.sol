1 pragma solidity ^0.4.18;
2 
3 // ----------------------------------------------------------------------------
4 
5 // (c) by Moritz Neto with BokkyPooBah / Bok Consulting Pty Ltd Au 2017. The MIT Licence.
6 // ----------------------------------------------------------------------------
7 
8 
9 // ----------------------------------------------------------------------------
10 // Safe maths
11 // ----------------------------------------------------------------------------
12 contract SafeMath {
13     function safeAdd(uint a, uint b) public pure returns (uint c) {
14         c = a + b;
15         require(c >= a);
16     }
17     function safeSub(uint a, uint b) public pure returns (uint c) {
18         require(b <= a);
19         c = a - b;
20     }
21     function safeMul(uint a, uint b) public pure returns (uint c) {
22         c = a * b;
23         require(a == 0 || c / a == b);
24     }
25     function safeDiv(uint a, uint b) public pure returns (uint c) {
26         require(b > 0);
27         c = a / b;
28     }
29 }
30 
31 
32 // ----------------------------------------------------------------------------
33 // ERC Token Standard #20 Interface
34 // https://github.com/ethereum/EIPs/blob/master/EIPS/eip-20-token-standard.md
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
50 // Contract function to receive approval and execute function in one call
51 //
52 // Borrowed from MiniMeToken
53 // ----------------------------------------------------------------------------
54 contract ApproveAndCallFallBack {
55     function receiveApproval(address from, uint256 tokens, address token, bytes data) public;
56 }
57 
58 
59 // ----------------------------------------------------------------------------
60 // Owned contract
61 // ----------------------------------------------------------------------------
62 contract Owned {
63     address public owner;
64     address public newOwner;
65 
66     event OwnershipTransferred(address indexed _from, address indexed _to);
67 
68     function Owned() public {
69         owner = msg.sender;
70     }
71 
72     modifier onlyOwner {
73         require(msg.sender == owner);
74         _;
75     }
76 
77     function transferOwnership(address _newOwner) public onlyOwner {
78         newOwner = _newOwner;
79     }
80     function acceptOwnership() public {
81         require(msg.sender == newOwner);
82         OwnershipTransferred(owner, newOwner);
83         owner = newOwner;
84         newOwner = address(0);
85     }
86 }
87 
88 
89 // ----------------------------------------------------------------------------
90 // ERC20 Token, with the addition of symbol, name and decimals and assisted
91 // token transfers
92 // ----------------------------------------------------------------------------
93 contract Charity is ERC20Interface, Owned, SafeMath {
94     string public symbol;
95     string public  name;
96     uint8 public decimals;
97     uint public _totalSupply;
98 
99     mapping(address => uint) balances;
100     mapping(address => mapping(address => uint)) allowed;
101 
102 
103     // ------------------------------------------------------------------------
104     // Constructor
105     // ------------------------------------------------------------------------
106     function Charity() public {
107         symbol = "CHA";
108         name = "Charity";
109         decimals = 18;
110         _totalSupply = 84000000000000000000000000;
111         balances[0xFe905C1CC0395240317F4e5A6ff22823f9B1DD3c] = _totalSupply;
112         Transfer(address(0), 0xFe905C1CC0395240317F4e5A6ff22823f9B1DD3c, _totalSupply);
113     }
114 
115 
116     // ------------------------------------------------------------------------
117     // Total supply
118     // ------------------------------------------------------------------------
119     function totalSupply() public constant returns (uint) {
120         return _totalSupply  - balances[address(0)];
121     }
122 
123 
124     // ------------------------------------------------------------------------
125     // Get the token balance for account tokenOwner
126     // ------------------------------------------------------------------------
127     function balanceOf(address tokenOwner) public constant returns (uint balance) {
128         return balances[tokenOwner];
129     }
130 
131 
132     // ------------------------------------------------------------------------
133     // Transfer the balance from token owner's account to to account
134     // - Owner's account must have sufficient balance to transfer
135     // - 0 value transfers are allowed
136     // ------------------------------------------------------------------------
137     function transfer(address to, uint tokens) public returns (bool success) {
138         balances[msg.sender] = safeSub(balances[msg.sender], tokens);
139         balances[to] = safeAdd(balances[to], tokens);
140         Transfer(msg.sender, to, tokens);
141         return true;
142     }
143 
144 
145     // ------------------------------------------------------------------------
146     // Token owner can approve for spender to transferFrom(...) tokens
147     // from the token owner's account
148     //
149     // https://github.com/ethereum/EIPs/blob/master/EIPS/eip-20-token-standard.md
150     // recommends that there are no checks for the approval double-spend attack
151     // as this should be implemented in user interfaces 
152     // ------------------------------------------------------------------------
153     function approve(address spender, uint tokens) public returns (bool success) {
154         allowed[msg.sender][spender] = tokens;
155         Approval(msg.sender, spender, tokens);
156         return true;
157     }
158 
159 
160     // ------------------------------------------------------------------------
161     // Transfer tokens from the from account to the to account
162     // 
163     // The calling account must already have sufficient tokens approve(...)-d
164     // for spending from the from account and
165     // - From account must have sufficient balance to transfer
166     // - Spender must have sufficient allowance to transfer
167     // - 0 value transfers are allowed
168     // ------------------------------------------------------------------------
169     function transferFrom(address from, address to, uint tokens) public returns (bool success) {
170         balances[from] = safeSub(balances[from], tokens);
171         allowed[from][msg.sender] = safeSub(allowed[from][msg.sender], tokens);
172         balances[to] = safeAdd(balances[to], tokens);
173         Transfer(from, to, tokens);
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
194         Approval(msg.sender, spender, tokens);
195         ApproveAndCallFallBack(spender).receiveApproval(msg.sender, tokens, this, data);
196         return true;
197     }
198 
199 
200     // ------------------------------------------------------------------------
201     // Don't accept ETH
202     // ------------------------------------------------------------------------
203     function () public payable {
204         revert();
205     }
206 
207 
208     // ------------------------------------------------------------------------
209     // Owner can transfer out any accidentally sent ERC20 tokens
210     // ------------------------------------------------------------------------
211     function transferAnyERC20Token(address tokenAddress, uint tokens) public onlyOwner returns (bool success) {
212         return ERC20Interface(tokenAddress).transfer(owner, tokens);
213     }
214 }