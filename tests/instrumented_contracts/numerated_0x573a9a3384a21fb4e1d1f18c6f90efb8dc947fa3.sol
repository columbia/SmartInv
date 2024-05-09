1 pragma solidity ^0.4.18;
2 
3 // ----------------------------------------------------------------------------
4 // Simulacrum token - https://github.com/juliansharifi
5 // adapted from '0Fucks' token contract
6 // (c) by Moritz Neto with BokkyPooBah / Bok Consulting Pty Ltd Au 2017. The MIT Licence.
7 // ----------------------------------------------------------------------------
8 
9 
10 // ----------------------------------------------------------------------------
11 // Safe maths
12 // ----------------------------------------------------------------------------
13 contract SafeMath {
14     function safeAdd(uint a, uint b) public pure returns (uint c) {
15         c = a + b;
16         require(c >= a);
17     }
18     function safeSub(uint a, uint b) public pure returns (uint c) {
19         require(b <= a);
20         c = a - b;
21     }
22     function safeMul(uint a, uint b) public pure returns (uint c) {
23         c = a * b;
24         require(a == 0 || c / a == b);
25     }
26     function safeDiv(uint a, uint b) public pure returns (uint c) {
27         require(b > 0);
28         c = a / b;
29     }
30 }
31 
32 
33 // ----------------------------------------------------------------------------
34 // ERC Token Standard #20 Interface
35 // https://github.com/ethereum/EIPs/blob/master/EIPS/eip-20-token-standard.md
36 // ----------------------------------------------------------------------------
37 contract ERC20Interface {
38     function totalSupply() public view returns (uint);
39     function balanceOf(address tokenOwner) public view returns (uint balance);
40     function allowance(address tokenOwner, address spender) public view returns (uint remaining);
41     function transfer(address to, uint tokens) public returns (bool success);
42     function approve(address spender, uint tokens) public returns (bool success);
43     function transferFrom(address from, address to, uint tokens) public returns (bool success);
44 
45     event Transfer(address indexed from, address indexed to, uint tokens);
46     event Approval(address indexed tokenOwner, address indexed spender, uint tokens);
47 }
48 
49 
50 // ----------------------------------------------------------------------------
51 // Contract function to receive approval and execute function in one call
52 //
53 // Borrowed from MiniMeToken
54 // ----------------------------------------------------------------------------
55 contract ApproveAndCallFallBack {
56     function receiveApproval(address from, uint256 tokens, address token, bytes data) public;
57 }
58 
59 
60 // ----------------------------------------------------------------------------
61 // Owned contract
62 // ----------------------------------------------------------------------------
63 contract Owned {
64     address public owner;
65     address public newOwner;
66 
67     event OwnershipTransferred(address indexed _from, address indexed _to);
68 
69      constructor() public {
70         owner = msg.sender;
71     }
72 
73     modifier onlyOwner {
74         require(msg.sender == owner);
75         _;
76     }
77 
78     function transferOwnership(address _newOwner) public onlyOwner {
79         newOwner = _newOwner;
80     }
81     function acceptOwnership() public {
82         require(msg.sender == newOwner);
83         emit OwnershipTransferred(owner, newOwner);
84         owner = newOwner;
85         newOwner = address(0);
86     }
87 }
88 
89 
90 // ----------------------------------------------------------------------------
91 // ERC20 Token, with the addition of symbol, name and decimals and assisted
92 // token transfers
93 // ----------------------------------------------------------------------------
94 contract SimulacrumToken is ERC20Interface, Owned, SafeMath {
95     string public symbol;
96     string public  name;
97     uint8 public decimals;
98     uint public _totalSupply;
99 
100     mapping(address => uint) balances;
101     mapping(address => mapping(address => uint)) allowed;
102 
103 
104     // ------------------------------------------------------------------------
105     // Constructor
106     // ------------------------------------------------------------------------
107         constructor() public {
108         symbol = "∆";
109         name = "Simulacrum";
110         decimals = 18;
111         _totalSupply = 333000000000000000000000000;
112         balances[0x448578e0Ba4b1f95082a86c9Fc8D1196817cf33B] = _totalSupply;
113         emit Transfer(address(0), 0x448578e0Ba4b1f95082a86c9Fc8D1196817cf33B, _totalSupply);
114     }
115 
116 
117     // ------------------------------------------------------------------------
118     // Total supply
119     // ------------------------------------------------------------------------
120     function totalSupply() public view returns (uint) {
121         return _totalSupply  - balances[address(0)];
122     }
123 
124 
125     // ------------------------------------------------------------------------
126     // Get the token balance for account tokenOwner
127     // ------------------------------------------------------------------------
128     function balanceOf(address tokenOwner) public view returns (uint balance) {
129         return balances[tokenOwner];
130     }
131 
132 
133     // ------------------------------------------------------------------------
134     // Transfer the balance from token owner's account to to account
135     // - Owner's account must have sufficient balance to transfer
136     // - 0 value transfers are allowed
137     // ------------------------------------------------------------------------
138     function transfer(address to, uint tokens) public returns (bool success) {
139         balances[msg.sender] = safeSub(balances[msg.sender], tokens);
140         balances[to] = safeAdd(balances[to], tokens);
141         emit Transfer(msg.sender, to, tokens);
142         return true;
143     }
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
155         emit Approval(msg.sender, spender, tokens);
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
173         emit Transfer(from, to, tokens);
174         return true;
175     }
176 
177 
178     // ------------------------------------------------------------------------
179     // Returns the amount of tokens approved by the owner that can be
180     // transferred to the spender's account
181     // ------------------------------------------------------------------------
182     function allowance(address tokenOwner, address spender) public view returns (uint remaining) {
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
194         emit Approval(msg.sender, spender, tokens);
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