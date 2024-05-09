1 pragma solidity ^0.4.18;
2 
3 
4 // ----------------------------------------------------------------------------
5 // 'FIXED' 'Example Fixed Supply Token' token contract
6 //
7 // Symbol      : FIXED
8 // Name        : Example Fixed Supply Token
9 // Total supply: 1,000,000.000000000000000000
10 // Decimals    : 18
11 //
12 // Enjoy.
13 //
14 // (c) BokkyPooBah / Bok Consulting Pty Ltd 2017. The MIT Licence.
15 // ----------------------------------------------------------------------------
16 
17 
18 
19 // ----------------------------------------------------------------------------
20 // Safe maths
21 // ----------------------------------------------------------------------------
22 
23 library SafeMath {
24     function add(uint a, uint b) internal pure returns (uint c) {
25         c = a + b;
26         require(c >= a);
27     }
28 
29     function sub(uint a, uint b) internal pure returns (uint c) {
30         require(b <= a);
31         c = a - b;
32     }
33 
34     function mul(uint a, uint b) internal pure returns (uint c) {
35         c = a * b;
36         require(a == 0 || c / a == b);
37     }
38 
39     function div(uint a, uint b) internal pure returns (uint c) {
40         require(b > 0);
41         c = a / b;
42     }
43 }
44 
45 
46 
47 // ----------------------------------------------------------------------------
48 // ERC Token Standard #20 Interface
49 // https://github.com/ethereum/EIPs/blob/master/EIPS/eip-20-token-standard.md
50 // ----------------------------------------------------------------------------
51 
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
65 
66 // ----------------------------------------------------------------------------
67 // Contract function to receive approval and execute function in one call
68 //
69 // Borrowed from MiniMeToken
70 // ---------------------------------------------------------------------------
71 contract ApproveAndCallFallBack {
72     function receiveApproval(address from, uint256 tokens, address token, bytes data) public;
73 }
74 
75 
76 
77 // ----------------------------------------------------------------------------
78 
79 // Owned contract
80 
81 // ----------------------------------------------------------------------------
82 
83 contract Owned {
84 
85     address public owner;
86     address public newOwner;
87 
88     event OwnershipTransferred(address indexed _from, address indexed _to);
89 
90     function Owned() public {
91         owner = msg.sender;
92     }
93 
94 
95     modifier onlyOwner {
96         require(msg.sender == owner);
97         _;
98     }
99 
100 
101     function transferOwnership(address _newOwner) public onlyOwner {
102         newOwner = _newOwner;
103     }
104 
105     function acceptOwnership() public {
106         require(msg.sender == newOwner);
107         OwnershipTransferred(owner, newOwner);
108         owner = newOwner;
109         newOwner = address(0);
110     }
111 
112 }
113 
114 
115 
116 // ----------------------------------------------------------------------------
117 // ERC20 Token, with the addition of symbol, name and decimals and an
118 // initial fixed supply
119 // ----------------------------------------------------------------------------
120 contract FixedSupplyToken is ERC20Interface, Owned {
121 
122     using SafeMath for uint;
123 
124     string public symbol;
125     string public  name;
126     uint8 public decimals;
127     uint public _totalSupply;
128 
129     mapping(address => uint) balances;
130     mapping(address => mapping(address => uint)) allowed;
131 
132 
133     // ------------------------------------------------------------------------
134     // Constructor
135     // ------------------------------------------------------------------------
136     function FixedSupplyToken() public {
137         symbol = "WT1";
138         name = "WorkToken";
139         decimals = 18;
140         _totalSupply = 300 * 10**uint(decimals);
141         balances[owner] = _totalSupply;
142         Transfer(address(0), owner, _totalSupply);
143     }
144 
145 
146 
147     // ------------------------------------------------------------------------
148     // Total supply
149     // ------------------------------------------------------------------------
150     function totalSupply() public constant returns (uint) {
151         return _totalSupply  - balances[address(0)];
152     }
153 
154 
155 
156     // ------------------------------------------------------------------------
157     // Get the token balance for account `tokenOwner`
158     // ------------------------------------------------------------------------
159     function balanceOf(address tokenOwner) public constant returns (uint balance) {
160         return balances[tokenOwner];
161     }
162 
163 
164 
165     // ------------------------------------------------------------------------
166     // Transfer the balance from token owner's account to `to` account
167     // - Owner's account must have sufficient balance to transfer
168     // - 0 value transfers are allowed
169     // ------------------------------------------------------------------------
170     function transfer(address to, uint tokens) public returns (bool success) {
171         balances[msg.sender] = balances[msg.sender].sub(tokens);
172         balances[to] = balances[to].add(tokens);
173         Transfer(msg.sender, to, tokens);
174         return true;
175     }
176 
177 
178 
179     // ------------------------------------------------------------------------
180     // Token owner can approve for `spender` to transferFrom(...) `tokens`
181     // from the token owner's account
182     //
183     // https://github.com/ethereum/EIPs/blob/master/EIPS/eip-20-token-standard.md
184     // recommends that there are no checks for the approval double-spend attack
185     // as this should be implemented in user interfaces 
186     // ------------------------------------------------------------------------
187     function approve(address spender, uint tokens) public returns (bool success) {
188         allowed[msg.sender][spender] = tokens;
189         Approval(msg.sender, spender, tokens);
190         return true;
191     }
192 
193 
194 
195     // ------------------------------------------------------------------------
196     // Transfer `tokens` from the `from` account to the `to` account
197     // 
198     // The calling account must already have sufficient tokens approve(...)-d
199     // for spending from the `from` account and
200     // - From account must have sufficient balance to transfer
201     // - Spender must have sufficient allowance to transfer
202     // - 0 value transfers are allowed
203     // ------------------------------------------------------------------------
204     function transferFrom(address from, address to, uint tokens) public returns (bool success) {
205         balances[from] = balances[from].sub(tokens);
206         allowed[from][msg.sender] = allowed[from][msg.sender].sub(tokens);
207         balances[to] = balances[to].add(tokens);
208         Transfer(from, to, tokens);
209         return true;
210     }
211 
212 
213 
214     // ------------------------------------------------------------------------
215     // Returns the amount of tokens approved by the owner that can be
216     // transferred to the spender's account
217     // ------------------------------------------------------------------------
218 
219     function allowance(address tokenOwner, address spender) public constant returns (uint remaining) {
220         return allowed[tokenOwner][spender];
221     }
222 
223 
224 
225     // ------------------------------------------------------------------------
226     // Token owner can approve for `spender` to transferFrom(...) `tokens`
227     // from the token owner's account. The `spender` contract function
228     // `receiveApproval(...)` is then executed
229     // ------------------------------------------------------------------------
230     function approveAndCall(address spender, uint tokens, bytes data) public returns (bool success) {
231         allowed[msg.sender][spender] = tokens;
232         Approval(msg.sender, spender, tokens);
233         ApproveAndCallFallBack(spender).receiveApproval(msg.sender, tokens, this, data);
234         return true;
235     }
236 
237 
238 
239     // ------------------------------------------------------------------------
240     // Don't accept ETH
241     // ------------------------------------------------------------------------
242     function () public payable {
243         revert();
244     }
245 
246 
247 
248     // ------------------------------------------------------------------------
249     // Owner can transfer out any accidentally sent ERC20 tokens
250     // ------------------------------------------------------------------------
251     function transferAnyERC20Token(address tokenAddress, uint tokens) public onlyOwner returns (bool success) {
252         return ERC20Interface(tokenAddress).transfer(owner, tokens);
253     }
254 
255 }