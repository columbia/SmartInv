1 pragma solidity ^0.4.18;
2 
3 
4 
5 
6 // ----------------------------------------------------------------------------
7 // Safe maths
8 // ----------------------------------------------------------------------------
9 contract SafeMath {
10     function safeAdd(uint a, uint b) public pure returns (uint c) {
11         c = a + b;
12         require(c >= a);
13     }
14     function safeSub(uint a, uint b) public pure returns (uint c) {
15         require(b <= a);
16         c = a - b;
17     }
18     function safeMul(uint a, uint b) public pure returns (uint c) {
19         c = a * b;
20         require(a == 0 || c / a == b);
21     }
22     function safeDiv(uint a, uint b) public pure returns (uint c) {
23         require(b > 0);
24         c = a / b;
25     }
26 }
27 
28 
29 // ----------------------------------------------------------------------------
30 // ERC Token Standard #20 Interface
31 // https://github.com/ethereum/EIPs/blob/master/EIPS/eip-20-token-standard.md
32 // ----------------------------------------------------------------------------
33 contract ERC20Interface {
34     function totalSupply() public constant returns (uint);
35     function balanceOf(address tokenOwner) public constant returns (uint balance);
36     function allowance(address tokenOwner, address spender) public constant returns (uint remaining);
37     function transfer(address to, uint tokens) public returns (bool success);
38     function approve(address spender, uint tokens) public returns (bool success);
39     function transferFrom(address from, address to, uint tokens) public returns (bool success);
40 
41     event Transfer(address indexed from, address indexed to, uint tokens);
42     event Approval(address indexed tokenOwner, address indexed spender, uint tokens);
43 }
44 
45 
46 // ----------------------------------------------------------------------------
47 // Contract function to receive approval and execute function in one call
48 //
49 // Borrowed from MiniMeToken
50 // ----------------------------------------------------------------------------
51 contract ApproveAndCallFallBack {
52     function receiveApproval(address from, uint256 tokens, address token, bytes data) public;
53 }
54 
55 
56 // ----------------------------------------------------------------------------
57 // Owned contract
58 // ----------------------------------------------------------------------------
59 contract Owned {
60     address public owner;
61     address public newOwner;
62 
63     event OwnershipTransferred(address indexed _from, address indexed _to);
64 
65     function Owned() public {
66         owner = msg.sender;
67     }
68 
69     modifier onlyOwner {
70         require(msg.sender == owner);
71         _;
72     }
73 
74     function transferOwnership(address _newOwner) public onlyOwner {
75         newOwner = _newOwner;
76     }
77     function acceptOwnership() public {
78         require(msg.sender == newOwner);
79         OwnershipTransferred(owner, newOwner);
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
90 contract SparksterToken is ERC20Interface, Owned, SafeMath {
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
103     function SparksterToken() public {
104         symbol = "SPRK";
105         name = "Sparkster Token";
106         decimals = 18;
107         _totalSupply = 435000000000000000000000000;
108         balances[0x17BB6EF5e6868f52b7f00CaAaEa63fa8cF367A79] = _totalSupply;
109         Transfer(address(0), 0x17BB6EF5e6868f52b7f00CaAaEa63fa8cF367A79, _totalSupply);
110         
111     }
112 
113 
114     // ------------------------------------------------------------------------
115     // Total supply
116     // ------------------------------------------------------------------------
117     function totalSupply() public constant returns (uint) {
118         return _totalSupply  - balances[address(0)];
119     }
120 
121 
122     // ------------------------------------------------------------------------
123     // Get the token balance for account tokenOwner
124     // ------------------------------------------------------------------------
125     function balanceOf(address tokenOwner) public constant returns (uint balance) {
126         return balances[tokenOwner];
127     }
128 
129 
130     // ------------------------------------------------------------------------
131     // Transfer the balance from token owner's account to to account
132     // - Owner's account must have sufficient balance to transfer
133     // - 0 value transfers are allowed
134     // ------------------------------------------------------------------------
135     function transfer(address to, uint tokens) public returns (bool success) {
136         balances[msg.sender] = safeSub(balances[msg.sender], tokens);
137         balances[to] = safeAdd(balances[to], tokens);
138         Transfer(msg.sender, to, tokens);
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
153         Approval(msg.sender, spender, tokens);
154         return true;
155     }
156 
157 
158     // ------------------------------------------------------------------------
159     // Transfer tokens from the from account to the to account
160     // 
161     // The calling account must already have sufficient tokens approve(...)-d
162     // for spending from the from account and
163     // - From account must have sufficient balance to transfer
164     // - Spender must have sufficient allowance to transfer
165     // - 0 value transfers are allowed
166     // ------------------------------------------------------------------------
167     function transferFrom(address from, address to, uint tokens) public returns (bool success) {
168         balances[from] = safeSub(balances[from], tokens);
169         allowed[from][msg.sender] = safeSub(allowed[from][msg.sender], tokens);
170         balances[to] = safeAdd(balances[to], tokens);
171         Transfer(from, to, tokens);
172         return true;
173     }
174 
175 
176     // ------------------------------------------------------------------------
177     // Returns the amount of tokens approved by the owner that can be
178     // transferred to the spender's account
179     // ------------------------------------------------------------------------
180     function allowance(address tokenOwner, address spender) public constant returns (uint remaining) {
181         return allowed[tokenOwner][spender];
182     }
183 
184 
185     // ------------------------------------------------------------------------
186     // Token owner can approve for spender to transferFrom(...) tokens
187     // from the token owner's account. The spender contract function
188     // receiveApproval(...) is then executed
189     // ------------------------------------------------------------------------
190     function approveAndCall(address spender, uint tokens, bytes data) public returns (bool success) {
191         allowed[msg.sender][spender] = tokens;
192         Approval(msg.sender, spender, tokens);
193         ApproveAndCallFallBack(spender).receiveApproval(msg.sender, tokens, this, data);
194         return true;
195     }
196 
197 
198     // ------------------------------------------------------------------------
199     // Don't accept ETH
200     // ------------------------------------------------------------------------
201     function () public payable {    
202         revert();
203     }
204 
205 
206     // ------------------------------------------------------------------------
207     // Owner can transfer out any accidentally sent ERC20 tokens
208     // ------------------------------------------------------------------------
209     function transferAnyERC20Token(address tokenAddress, uint tokens) public onlyOwner returns (bool success) {
210         return ERC20Interface(tokenAddress).transfer(owner, tokens);
211     }
212 }