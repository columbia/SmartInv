1 pragma solidity ^0.4.18;
2 
3 // ----------------------------------------------------------------------------
4 // 'Atman' token contract
5 //
6 // Deployed to : 
7 // Symbol      : ATMA
8 // Name        : Atman Token v0.01
9 // Total supply: 1000000000000
10 // Decimals    : 18
11 //
12 // Enjoy.
13 //
14 // Modified from (c) by Moritz Neto with BokkyPooBah / Bok Consulting Pty Ltd Au 2017. The MIT Licence.
15 // ----------------------------------------------------------------------------
16 
17 
18 // ----------------------------------------------------------------------------
19 // Safe maths
20 // ----------------------------------------------------------------------------
21 contract SafeMath {
22     function safeAdd(uint a, uint b) public pure returns (uint c) {
23         c = a + b;
24         require(c >= a);
25     }
26     function safeSub(uint a, uint b) public pure returns (uint c) {
27         require(b <= a);
28         c = a - b;
29     }
30     function safeMul(uint a, uint b) public pure returns (uint c) {
31         c = a * b;
32         require(a == 0 || c / a == b);
33     }
34     function safeDiv(uint a, uint b) public pure returns (uint c) {
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
59 // Contract function to receive approval and execute function in one call
60 //
61 // Borrowed from MiniMeToken
62 // ----------------------------------------------------------------------------
63 contract ApproveAndCallFallBack {
64     function receiveApproval(address from, uint256 tokens, address token, bytes data) public;
65 }
66 
67 
68 // ----------------------------------------------------------------------------
69 // Owned contract
70 // ----------------------------------------------------------------------------
71 contract Owned {
72     address public owner;
73     address public newOwner;
74 
75     event OwnershipTransferred(address indexed _from, address indexed _to);
76 
77     function Owned() public {
78         owner = msg.sender;
79     }
80 
81     modifier onlyOwner {
82         require(msg.sender == owner);
83         _;
84     }
85 
86     function transferOwnership(address _newOwner) public onlyOwner {
87         newOwner = _newOwner;
88     }
89     function acceptOwnership() public {
90         require(msg.sender == newOwner);
91         OwnershipTransferred(owner, newOwner);
92         owner = newOwner;
93         newOwner = address(0);
94     }
95 }
96 
97 
98 // ----------------------------------------------------------------------------
99 // ERC20 Token, with the addition of symbol, name and decimals and assisted
100 // token transfers
101 // ----------------------------------------------------------------------------
102 contract AtmanToken is ERC20Interface, Owned, SafeMath {
103     string public symbol;
104     string public  name;
105     uint8 public decimals;
106     uint public _totalSupply;
107 
108     mapping(address => uint) balances;
109     mapping(address => mapping(address => uint)) allowed;
110 
111     // ------------------------------------------------------------------------
112     // SELFDESTRUCT
113     // ------------------------------------------------------------------------
114     function shutdown() public onlyOwner {
115         selfdestruct(owner);
116     }
117 
118 
119     // ------------------------------------------------------------------------
120     // Constructor
121     // ------------------------------------------------------------------------
122     function AtmanToken() public {
123         symbol = "ATMA";
124         name = "Atman Token v0.01";
125         decimals = 18;
126         _totalSupply = 1000000000000000000000000000000;
127         balances[0xC369B30c8eC960260631E20081A32e4c61E5Ea9d] = _totalSupply;
128         Transfer(address(0), 0xC369B30c8eC960260631E20081A32e4c61E5Ea9d, _totalSupply);
129     }
130 
131 
132     // ------------------------------------------------------------------------
133     // Total supply
134     // ------------------------------------------------------------------------
135     function totalSupply() public constant returns (uint) {
136         return _totalSupply  - balances[address(0)];
137     }
138 
139 
140     // ------------------------------------------------------------------------
141     // Get the token balance for account tokenOwner
142     // ------------------------------------------------------------------------
143     function balanceOf(address tokenOwner) public constant returns (uint balance) {
144         return balances[tokenOwner];
145     }
146 
147 
148     // ------------------------------------------------------------------------
149     // Transfer the balance from token owner's account to to account
150     // - Owner's account must have sufficient balance to transfer
151     // - 0 value transfers are allowed
152     // ------------------------------------------------------------------------
153     function transfer(address to, uint tokens) public returns (bool success) {
154         balances[msg.sender] = safeSub(balances[msg.sender], tokens);
155         balances[to] = safeAdd(balances[to], tokens);
156         Transfer(msg.sender, to, tokens);
157         return true;
158     }
159 
160 
161     // ------------------------------------------------------------------------
162     // Token owner can approve for spender to transferFrom(...) tokens
163     // from the token owner's account
164     //
165     // https://github.com/ethereum/EIPs/blob/master/EIPS/eip-20-token-standard.md
166     // recommends that there are no checks for the approval double-spend attack
167     // as this should be implemented in user interfaces 
168     // ------------------------------------------------------------------------
169     function approve(address spender, uint tokens) public returns (bool success) {
170         allowed[msg.sender][spender] = tokens;
171         Approval(msg.sender, spender, tokens);
172         return true;
173     }
174 
175 
176     // ------------------------------------------------------------------------
177     // Transfer tokens from the from account to the to account
178     // 
179     // The calling account must already have sufficient tokens approve(...)-d
180     // for spending from the from account and
181     // - From account must have sufficient balance to transfer
182     // - Spender must have sufficient allowance to transfer
183     // - 0 value transfers are allowed
184     // ------------------------------------------------------------------------
185     function transferFrom(address from, address to, uint tokens) public returns (bool success) {
186         balances[from] = safeSub(balances[from], tokens);
187         allowed[from][msg.sender] = safeSub(allowed[from][msg.sender], tokens);
188         balances[to] = safeAdd(balances[to], tokens);
189         Transfer(from, to, tokens);
190         return true;
191     }
192 
193 
194     // ------------------------------------------------------------------------
195     // Returns the amount of tokens approved by the owner that can be
196     // transferred to the spender's account
197     // ------------------------------------------------------------------------
198     function allowance(address tokenOwner, address spender) public constant returns (uint remaining) {
199         return allowed[tokenOwner][spender];
200     }
201 
202 
203     // ------------------------------------------------------------------------
204     // Token owner can approve for spender to transferFrom(...) tokens
205     // from the token owner's account. The spender contract function
206     // receiveApproval(...) is then executed
207     // ------------------------------------------------------------------------
208     function approveAndCall(address spender, uint tokens, bytes data) public returns (bool success) {
209         allowed[msg.sender][spender] = tokens;
210         Approval(msg.sender, spender, tokens);
211         ApproveAndCallFallBack(spender).receiveApproval(msg.sender, tokens, this, data);
212         return true;
213     }
214 
215 
216     // ------------------------------------------------------------------------
217     // Don't accept ETH
218     // ------------------------------------------------------------------------
219     function () public payable {
220         revert();
221     }
222 
223 
224     // ------------------------------------------------------------------------
225     // Owner can transfer out any accidentally sent ERC20 tokens
226     // ------------------------------------------------------------------------
227     function transferAnyERC20Token(address tokenAddress, uint tokens) public onlyOwner returns (bool success) {
228         return ERC20Interface(tokenAddress).transfer(owner, tokens);
229     }
230 }