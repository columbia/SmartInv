1 pragma solidity ^0.4.18;
2 
3 // ----------------------------------------------------------------------------
4 // (c) by Moritz Neto with BokkyPooBah / Bok Consulting Pty Ltd Au 2017. The MIT Licence.
5 // ----------------------------------------------------------------------------
6 
7 // ----------------------------------------------------------------------------
8 // Safe maths
9 // ----------------------------------------------------------------------------
10 contract SafeMath {
11     function safeAdd(uint a, uint b) public pure returns (uint c) {
12         c = a + b;
13         require(c >= a);
14     }
15     function safeSub(uint a, uint b) public pure returns (uint c) {
16         require(b <= a);
17         c = a - b;
18     }
19     function safeMul(uint a, uint b) public pure returns (uint c) {
20         c = a * b;
21         require(a == 0 || c / a == b);
22     }
23     function safeDiv(uint a, uint b) public pure returns (uint c) {
24         require(b > 0);
25         c = a / b;
26     }
27 }
28 
29 
30 // ----------------------------------------------------------------------------
31 // ERC Token Standard #20 Interface
32 // https://github.com/ethereum/EIPs/blob/master/EIPS/eip-20-token-standard.md
33 // ----------------------------------------------------------------------------
34 contract ERC20Interface {
35     function totalSupply() public constant returns (uint);
36     function balanceOf(address tokenOwner) public constant returns (uint balance);
37     function allowance(address tokenOwner, address spender) public constant returns (uint remaining);
38     function transfer(address to, uint tokens) public returns (bool success);
39     function approve(address spender, uint tokens) public returns (bool success);
40     function transferFrom(address from, address to, uint tokens) public returns (bool success);
41 
42     event Transfer(address indexed from, address indexed to, uint tokens);
43     event Approval(address indexed tokenOwner, address indexed spender, uint tokens);
44 }
45 
46 
47 // ----------------------------------------------------------------------------
48 // Contract function to receive approval and execute function in one call
49 //
50 // Borrowed from MiniMeToken
51 // ----------------------------------------------------------------------------
52 contract ApproveAndCallFallBack {
53     function receiveApproval(address from, uint256 tokens, address token, bytes data) public;
54 }
55 
56 
57 // ----------------------------------------------------------------------------
58 // Owned contract
59 // ----------------------------------------------------------------------------
60 contract Owned {
61     address public owner;
62     address public newOwner;
63 
64     event OwnershipTransferred(address indexed _from, address indexed _to);
65 
66     function Owned() public {
67         owner = msg.sender;
68     }
69 
70     modifier onlyOwner {
71         require(msg.sender == owner);
72         _;
73     }
74 
75     function transferOwnership(address _newOwner) public onlyOwner {
76         newOwner = _newOwner;
77     }
78     function acceptOwnership() public {
79         require(msg.sender == newOwner);
80         OwnershipTransferred(owner, newOwner);
81         owner = newOwner;
82         newOwner = address(0);
83     }
84 }
85 
86 
87 // ----------------------------------------------------------------------------
88 // ERC20 Token, with the addition of symbol, name and decimals and assisted
89 // token transfers
90 // ----------------------------------------------------------------------------
91 contract Silvereum is ERC20Interface, Owned, SafeMath {
92     string public symbol;
93     string public  name;
94     uint8 public decimals;
95     uint public _totalSupply;
96 
97     mapping(address => uint) balances;
98     mapping(address => mapping(address => uint)) allowed;
99 
100 
101     // ------------------------------------------------------------------------
102     // Constructor
103     // ------------------------------------------------------------------------
104     function Silvereum() public {
105         symbol = "SXM";
106         name = "Silvereum";
107         decimals = 7;
108         _totalSupply = 	230000000000000000;
109         balances[0xe5371c7cb3FB6322F4C8A936baDaC8A7Ef888B3D] = _totalSupply;
110         Transfer(address(0), 0xe5371c7cb3FB6322F4C8A936baDaC8A7Ef888B3D, _totalSupply);
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