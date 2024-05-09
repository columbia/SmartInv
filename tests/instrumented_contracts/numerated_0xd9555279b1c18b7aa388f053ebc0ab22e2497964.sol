1 pragma solidity ^0.4.18;
2 
3 // ----------------------------------------------------------------------------
4 // 'Reactioon' token contract
5 //
6 // Deployed to : 0xD516B196C474a6b6fbF3FF7d44031a39BdB894E9
7 // Symbol      : RCTN
8 // Name        : Reactioon Token
9 // Total supply: 21000000
10 // Decimals    : 0
11 // 
12 // Description : Reactioon is a tool to check signals to trade assets in multiple exchanges.
13 //               
14 //               Create your free account now: www.reactioon.com
15 // 
16 //               Enjoy!
17 //
18 // 
19 // @2018
20 // Reactioon Token by José Wilker
21 // 
22 // ----------------------------------------------------------------------------
23 
24 
25 // ----------------------------------------------------------------------------
26 // Safe maths
27 // ----------------------------------------------------------------------------
28 contract SafeMath {
29     function safeAdd(uint a, uint b) public pure returns (uint c) {
30         c = a + b;
31         require(c >= a);
32     }
33     function safeSub(uint a, uint b) public pure returns (uint c) {
34         require(b <= a);
35         c = a - b;
36     }
37     function safeMul(uint a, uint b) public pure returns (uint c) {
38         c = a * b;
39         require(a == 0 || c / a == b);
40     }
41     function safeDiv(uint a, uint b) public pure returns (uint c) {
42         require(b > 0);
43         c = a / b;
44     }
45 }
46 
47 
48 // ----------------------------------------------------------------------------
49 // ERC Token Standard #20 Interface
50 // https://github.com/ethereum/EIPs/blob/master/EIPS/eip-20-token-standard.md
51 // ----------------------------------------------------------------------------
52 contract ERC20Interface {
53     function totalSupply() public constant returns (uint);
54     function balanceOf(address tokenOwner) public constant returns (uint balance);
55     function allowance(address tokenOwner, address spender) public constant returns (uint remaining);
56     function transfer(address to, uint tokens) public returns (bool success);
57     function approve(address spender, uint tokens) public returns (bool success);
58     function transferFrom(address from, address to, uint tokens) public returns (bool success);
59 
60     event Transfer(address indexed from, address indexed to, uint tokens);
61     event Approval(address indexed tokenOwner, address indexed spender, uint tokens);
62 }
63 
64 
65 // ----------------------------------------------------------------------------
66 // Contract function to receive approval and execute function in one call
67 //
68 // Borrowed from MiniMeToken
69 // ----------------------------------------------------------------------------
70 contract ApproveAndCallFallBack {
71     function receiveApproval(address from, uint256 tokens, address token, bytes data) public;
72 }
73 
74 
75 // ----------------------------------------------------------------------------
76 // Owned contract
77 // ----------------------------------------------------------------------------
78 contract Owned {
79 
80     address public owner;
81     address public newOwner;
82 
83     event OwnershipTransferred(address indexed _from, address indexed _to);
84 
85     function Owned() public {
86         owner = msg.sender;
87     }
88 
89     modifier onlyOwner {
90         require(msg.sender == owner);
91         _;
92     }
93 
94     function transferOwnership(address _newOwner) public onlyOwner {
95         newOwner = _newOwner;
96     }
97 
98     function acceptOwnership() public {
99         require(msg.sender == newOwner);
100         OwnershipTransferred(owner, newOwner);
101         owner = newOwner;
102         newOwner = address(0);
103     }
104 
105 }
106 
107 
108 // ----------------------------------------------------------------------------
109 // ERC20 Token, with the addition of symbol, name and decimals and assisted
110 // token transfers
111 // ----------------------------------------------------------------------------
112 contract ReactioonToken is ERC20Interface, Owned, SafeMath {
113 
114     string public symbol;
115     string public  name;
116     uint8 public decimals;
117     uint public _totalSupply;
118 
119     mapping(address => uint) balances;
120     mapping(address => mapping(address => uint)) allowed;
121 
122 
123     // ------------------------------------------------------------------------
124     // Constructor
125     // ------------------------------------------------------------------------
126     function ReactioonToken() public {
127 
128         symbol = "RTN";
129         name = "Reactioon";
130         decimals = 0;
131 
132         _totalSupply = 21000000;
133         balances[0x414D077412920A134529631a5b8f31c128AC37bD] = _totalSupply;
134 
135         Transfer(address(0), 0x414D077412920A134529631a5b8f31c128AC37bD, _totalSupply);
136 
137     }
138 
139 
140     // ------------------------------------------------------------------------
141     // Total supply
142     // ------------------------------------------------------------------------
143     function totalSupply() public constant returns (uint) {
144         return _totalSupply  - balances[address(0)];
145     }
146 
147 
148     // ------------------------------------------------------------------------
149     // Get the token balance for account tokenOwner
150     // ------------------------------------------------------------------------
151     function balanceOf(address tokenOwner) public constant returns (uint balance) {
152         return balances[tokenOwner];
153     }
154 
155 
156     // ------------------------------------------------------------------------
157     // Transfer the balance from token owner's account to to account
158     // - Owner's account must have sufficient balance to transfer
159     // - 0 value transfers are allowed
160     // ------------------------------------------------------------------------
161     function transfer(address to, uint tokens) public returns (bool success) {
162         balances[msg.sender] = safeSub(balances[msg.sender], tokens);
163         balances[to] = safeAdd(balances[to], tokens);
164         Transfer(msg.sender, to, tokens);
165         return true;
166     }
167 
168 
169     // ------------------------------------------------------------------------
170     // Token owner can approve for spender to transferFrom(...) tokens
171     // from the token owner's account
172     //
173     // https://github.com/ethereum/EIPs/blob/master/EIPS/eip-20-token-standard.md
174     // recommends that there are no checks for the approval double-spend attack
175     // as this should be implemented in user interfaces
176     // ------------------------------------------------------------------------
177     function approve(address spender, uint tokens) public returns (bool success) {
178         allowed[msg.sender][spender] = tokens;
179         Approval(msg.sender, spender, tokens);
180         return true;
181     }
182 
183 
184     // ------------------------------------------------------------------------
185     // Transfer tokens from the from account to the to account
186     //
187     // The calling account must already have sufficient tokens approve(...)-d
188     // for spending from the from account and
189     // - From account must have sufficient balance to transfer
190     // - Spender must have sufficient allowance to transfer
191     // - 0 value transfers are allowed
192     // ------------------------------------------------------------------------
193     function transferFrom(address from, address to, uint tokens) public returns (bool success) {
194         balances[from] = safeSub(balances[from], tokens);
195         allowed[from][msg.sender] = safeSub(allowed[from][msg.sender], tokens);
196         balances[to] = safeAdd(balances[to], tokens);
197         Transfer(from, to, tokens);
198         return true;
199     }
200 
201 
202     // ------------------------------------------------------------------------
203     // Returns the amount of tokens approved by the owner that can be
204     // transferred to the spender's account
205     // ------------------------------------------------------------------------
206     function allowance(address tokenOwner, address spender) public constant returns (uint remaining) {
207         return allowed[tokenOwner][spender];
208     }
209 
210 
211     // ------------------------------------------------------------------------
212     // Token owner can approve for spender to transferFrom(...) tokens
213     // from the token owner's account. The spender contract function
214     // receiveApproval(...) is then executed
215     // ------------------------------------------------------------------------
216     function approveAndCall(address spender, uint tokens, bytes data) public returns (bool success) {
217         allowed[msg.sender][spender] = tokens;
218         Approval(msg.sender, spender, tokens);
219         ApproveAndCallFallBack(spender).receiveApproval(msg.sender, tokens, this, data);
220         return true;
221     }
222 
223 
224     // ------------------------------------------------------------------------
225     // Don't accept ETH
226     // ------------------------------------------------------------------------
227     function () public payable {
228         revert();
229     }
230 
231 
232     // ------------------------------------------------------------------------
233     // Owner can transfer out any accidentally sent ERC20 tokens
234     // ------------------------------------------------------------------------
235     function transferAnyERC20Token(address tokenAddress, uint tokens) public onlyOwner returns (bool success) {
236         return ERC20Interface(tokenAddress).transfer(owner, tokens);
237     }
238 }