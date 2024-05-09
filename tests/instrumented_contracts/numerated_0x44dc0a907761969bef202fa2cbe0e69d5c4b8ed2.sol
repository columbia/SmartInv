1 pragma solidity ^0.4.23;
2 
3 
4 // ----------------------------------------------------------------------------
5 // 'IRP' 'Investor PreSale Berechtigung' token contract
6 //
7 // Symbol      : IRP
8 // Name        : Investor PreSale Berechtigung
9 // Total supply: 100.000000000000000000
10 // Decimals    : 18
11 //
12 // Enjoy.
13 //
14 // (c) BokkyPooBah / Bok Consulting Pty Ltd 2017. The MIT Licence.
15 // (c) Smart Contract Solution UG 2018
16 //      
17 // ----------------------------------------------------------------------------
18 
19 
20 
21 // ----------------------------------------------------------------------------
22 // Safe maths
23 // ----------------------------------------------------------------------------
24 
25 library SafeMath {
26     function add(uint a, uint b) internal pure returns (uint c) {
27         c = a + b;
28         require(c >= a);
29     }
30 
31     function sub(uint a, uint b) internal pure returns (uint c) {
32         require(b <= a);
33         c = a - b;
34     }
35 
36     function mul(uint a, uint b) internal pure returns (uint c) {
37         c = a * b;
38         require(a == 0 || c / a == b);
39     }
40 
41     function div(uint a, uint b) internal pure returns (uint c) {
42         require(b > 0);
43         c = a / b;
44     }
45 }
46 
47 
48 
49 // ----------------------------------------------------------------------------
50 // ERC Token Standard #20 Interface
51 // https://github.com/ethereum/EIPs/blob/master/EIPS/eip-20-token-standard.md
52 // ----------------------------------------------------------------------------
53 
54 contract ERC20Interface {
55     function totalSupply() public constant returns (uint);
56     function balanceOf(address tokenOwner) public constant returns (uint balance);
57     function allowance(address tokenOwner, address spender) public constant returns (uint remaining);
58     function transfer(address to, uint tokens) public returns (bool success);
59     function approve(address spender, uint tokens) public returns (bool success);
60     function transferFrom(address from, address to, uint tokens) public returns (bool success);
61 
62     event Transfer(address indexed from, address indexed to, uint tokens);
63     event Approval(address indexed tokenOwner, address indexed spender, uint tokens);
64 }
65 
66 
67 
68 // ----------------------------------------------------------------------------
69 // Contract function to receive approval and execute function in one call
70 //
71 // Borrowed from MiniMeToken
72 // ---------------------------------------------------------------------------
73 contract ApproveAndCallFallBack {
74     function receiveApproval(address from, uint256 tokens, address token, bytes data) public;
75 }
76 
77 
78 
79 // ----------------------------------------------------------------------------
80 
81 // Owned contract
82 
83 // ----------------------------------------------------------------------------
84 
85 contract Owned {
86 
87     address public owner;
88     address public newOwner;
89 
90     event OwnershipTransferred(address indexed _from, address indexed _to);
91 
92     function Owned() public {
93         owner = msg.sender;
94     }
95 
96 
97     modifier onlyOwner {
98         require(msg.sender == owner);
99         _;
100     }
101 
102 
103     function transferOwnership(address _newOwner) public onlyOwner {
104         newOwner = _newOwner;
105     }
106 
107     function acceptOwnership() public {
108         require(msg.sender == newOwner);
109         OwnershipTransferred(owner, newOwner);
110         owner = newOwner;
111         newOwner = address(0);
112     }
113 
114 }
115 
116 
117 
118 // ----------------------------------------------------------------------------
119 // ERC20 Token, with the addition of symbol, name and decimals and an
120 // initial fixed supply
121 // ----------------------------------------------------------------------------
122 contract IRPToken is ERC20Interface, Owned {
123 
124     using SafeMath for uint;
125 
126     string public symbol;
127     string public  name;
128     uint8 public decimals;
129     uint public _totalSupply;
130 
131     mapping(address => uint) balances;
132     mapping(address => mapping(address => uint)) allowed;
133 
134 
135     // ------------------------------------------------------------------------
136     // Constructor
137     // ------------------------------------------------------------------------
138     function IRPToken() public {
139         symbol = "IRP";
140         name = "Investor PreSale Berechtigung";
141         decimals = 18;
142         _totalSupply = 100 * 10**uint(decimals);
143         balances[owner] = _totalSupply;
144         Transfer(address(0), owner, _totalSupply);
145     }
146 
147 
148 
149     // ------------------------------------------------------------------------
150     // Total supply
151     // ------------------------------------------------------------------------
152     function totalSupply() public constant returns (uint) {
153         return _totalSupply  - balances[address(0)];
154     }
155 
156 
157 
158     // ------------------------------------------------------------------------
159     // Get the token balance for account `tokenOwner`
160     // ------------------------------------------------------------------------
161     function balanceOf(address tokenOwner) public constant returns (uint balance) {
162         return balances[tokenOwner];
163     }
164 
165 
166 
167     // ------------------------------------------------------------------------
168     // Transfer the balance from token owner's account to `to` account
169     // - Owner's account must have sufficient balance to transfer
170     // - 0 value transfers are allowed
171     // ------------------------------------------------------------------------
172     function transfer(address to, uint tokens) public returns (bool success) {
173         balances[msg.sender] = balances[msg.sender].sub(tokens);
174         balances[to] = balances[to].add(tokens);
175         Transfer(msg.sender, to, tokens);
176         return true;
177     }
178 
179 
180 
181     // ------------------------------------------------------------------------
182     // Token owner can approve for `spender` to transferFrom(...) `tokens`
183     // from the token owner's account
184     //
185     // https://github.com/ethereum/EIPs/blob/master/EIPS/eip-20-token-standard.md
186     // recommends that there are no checks for the approval double-spend attack
187     // as this should be implemented in user interfaces 
188     // ------------------------------------------------------------------------
189     function approve(address spender, uint tokens) public returns (bool success) {
190         allowed[msg.sender][spender] = tokens;
191         Approval(msg.sender, spender, tokens);
192         return true;
193     }
194 
195 
196 
197     // ------------------------------------------------------------------------
198     // Transfer `tokens` from the `from` account to the `to` account
199     // 
200     // The calling account must already have sufficient tokens approve(...)-d
201     // for spending from the `from` account and
202     // - From account must have sufficient balance to transfer
203     // - Spender must have sufficient allowance to transfer
204     // - 0 value transfers are allowed
205     // ------------------------------------------------------------------------
206     function transferFrom(address from, address to, uint tokens) public returns (bool success) {
207         balances[from] = balances[from].sub(tokens);
208         allowed[from][msg.sender] = allowed[from][msg.sender].sub(tokens);
209         balances[to] = balances[to].add(tokens);
210         Transfer(from, to, tokens);
211         return true;
212     }
213 
214 
215 
216     // ------------------------------------------------------------------------
217     // Returns the amount of tokens approved by the owner that can be
218     // transferred to the spender's account
219     // ------------------------------------------------------------------------
220 
221     function allowance(address tokenOwner, address spender) public constant returns (uint remaining) {
222         return allowed[tokenOwner][spender];
223     }
224 
225 
226 
227     // ------------------------------------------------------------------------
228     // Token owner can approve for `spender` to transferFrom(...) `tokens`
229     // from the token owner's account. The `spender` contract function
230     // `receiveApproval(...)` is then executed
231     // ------------------------------------------------------------------------
232     function approveAndCall(address spender, uint tokens, bytes data) public returns (bool success) {
233         allowed[msg.sender][spender] = tokens;
234         Approval(msg.sender, spender, tokens);
235         ApproveAndCallFallBack(spender).receiveApproval(msg.sender, tokens, this, data);
236         return true;
237     }
238 
239 
240 
241     // ------------------------------------------------------------------------
242     // Don't accept ETH
243     // ------------------------------------------------------------------------
244     function () public payable {
245         revert();
246     }
247 
248 
249 
250     // ------------------------------------------------------------------------
251     // Owner can transfer out any accidentally sent ERC20 tokens
252     // ------------------------------------------------------------------------
253     function transferAnyERC20Token(address tokenAddress, uint tokens) public onlyOwner returns (bool success) {
254         return ERC20Interface(tokenAddress).transfer(owner, tokens);
255     }
256 
257 }