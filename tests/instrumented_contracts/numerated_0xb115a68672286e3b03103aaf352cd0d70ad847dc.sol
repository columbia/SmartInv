1 pragma solidity ^0.4.19;
2 
3 // ----------------------------------------------------------------------------
4 // 'CI10' token contract
5 //
6 // Symbol      : CI10
7 // Name        : Compound Interest 10x per Year
8 // Total supply: 1,000,000.000000000000000000
9 // Decimals    : 10
10 //
11 // based on the 'FIXED' example from https://theethereum.wiki/w/index.php/ERC20_Token_Standard
12 // (c) BokkyPooBah / Bok Consulting Pty Ltd 2017. The MIT Licence.
13 // ----------------------------------------------------------------------------
14 
15 
16 // ----------------------------------------------------------------------------
17 // Safe maths
18 // ----------------------------------------------------------------------------
19 library SafeMath {
20     function add(uint a, uint b) internal pure returns (uint c) {
21         c = a + b;
22         require(c >= a);
23     }
24     function sub(uint a, uint b) internal pure returns (uint c) {
25         require(b <= a);
26         c = a - b;
27     }
28     function mul(uint a, uint b) internal pure returns (uint c) {
29         c = a * b;
30         require(a == 0 || c / a == b);
31     }
32     function div(uint a, uint b) internal pure returns (uint c) {
33         require(b > 0);
34         c = a / b;
35     }
36 }
37 
38 
39 // ----------------------------------------------------------------------------
40 // ERC Token Standard #20 Interface
41 // https://github.com/ethereum/EIPs/blob/master/EIPS/eip-20-token-standard.md
42 // ----------------------------------------------------------------------------
43 contract ERC20Interface {
44     function totalSupply() public constant returns (uint);
45     function balanceOf(address tokenOwner) public constant returns (uint balance);
46     function allowance(address tokenOwner, address spender) public constant returns (uint remaining);
47     function transfer(address to, uint tokens) public returns (bool success);
48     function approve(address spender, uint tokens) public returns (bool success);
49     function transferFrom(address from, address to, uint tokens) public returns (bool success);
50 
51     event Transfer(address indexed from, address indexed to, uint tokens);
52     event Approval(address indexed tokenOwner, address indexed spender, uint tokens);
53 }
54 
55 
56 // ----------------------------------------------------------------------------
57 // Contract function to receive approval and execute function in one call
58 //
59 // Borrowed from MiniMeToken
60 // ----------------------------------------------------------------------------
61 contract ApproveAndCallFallBack {
62     function receiveApproval(address from, uint256 tokens, address token, bytes data) public;
63 }
64 
65 
66 // ----------------------------------------------------------------------------
67 // Owned contract
68 // ----------------------------------------------------------------------------
69 contract Owned {
70     address public owner;
71     address public newOwner;
72 
73     event OwnershipTransferred(address indexed _from, address indexed _to);
74 
75     function Owned() public {
76         owner = msg.sender;
77     }
78 
79     modifier onlyOwner {
80         require(msg.sender == owner);
81         _;
82     }
83 
84     function transferOwnership(address _newOwner) public onlyOwner {
85         newOwner = _newOwner;
86     }
87     function acceptOwnership() public {
88         require(msg.sender == newOwner);
89         OwnershipTransferred(owner, newOwner);
90         owner = newOwner;
91         newOwner = address(0);
92     }
93 }
94 
95 
96 // ----------------------------------------------------------------------------
97 // ERC20 Token, with the addition of symbol, name and decimals and an
98 // initial fixed supply
99 // ----------------------------------------------------------------------------
100 contract CI10Token is ERC20Interface, Owned {
101     using SafeMath for uint;
102 
103     string public symbol;
104     string public  name;
105     uint8 public decimals;
106     uint public _totalSupply;
107 
108     mapping(address => uint) startBalances;
109     mapping(address => uint) startBlocks;
110     mapping(address => mapping(address => uint)) allowed;
111 
112 
113     // ------------------------------------------------------------------------
114     // Constructor
115     // ------------------------------------------------------------------------
116     function CI10Token() public {
117         symbol = "CI10";
118         name = "Compound Interest 10x per Year";
119         decimals = 10;
120         _totalSupply = 1000000 * 10**uint(decimals);
121         startBalances[owner] = _totalSupply;
122         startBlocks[owner] = block.number;
123         Transfer(address(0), owner, _totalSupply);
124     }
125 
126 
127     // ------------------------------------------------------------------------
128     // Total supply
129     // ------------------------------------------------------------------------
130     function totalSupply() public constant returns (uint) {
131         return _totalSupply;
132     }
133 
134 
135     // ------------------------------------------------------------------------
136     // Computes `k * (1+1/q) ^ N`, with precision `p`. The higher
137     // the precision, the higher the gas cost. It should be
138     // something around the log of `n`. When `p == n`, the
139     // precision is absolute (sans possible integer overflows). <edit: NOT true, see comments>
140     // Much smaller values are sufficient to get a great approximation.
141     // from https://ethereum.stackexchange.com/questions/10425/is-there-any-efficient-way-to-compute-the-exponentiation-of-a-fraction-and-an-in
142     // ------------------------------------------------------------------------
143     function fracExp(uint k, uint q, uint n, uint p) pure public returns (uint) {
144         uint s = 0;
145         uint N = 1;
146         uint B = 1;
147         for (uint i = 0; i < p; ++i) {
148             s += k * N / B / (q**i);
149             N = N * (n-i);
150             B = B * (i+1);
151         }
152         return s;
153     }
154 
155 
156     // ------------------------------------------------------------------------
157     // Computes the compound interest for an account since the block stored in startBlock
158     // about factor 10 for 2 million blocks
159     // ------------------------------------------------------------------------
160     function compoundInterest(address tokenOwner) view public returns (uint) {
161         require(startBlocks[tokenOwner] > 0);
162         uint startBlock = startBlocks[tokenOwner];
163         uint currentBlock = block.number;
164         uint blockCount = currentBlock - startBlock;
165         uint balance = startBalances[tokenOwner];
166         return fracExp(balance, 867598, blockCount, 8).sub(balance);
167     }
168 
169 
170     // ------------------------------------------------------------------------
171     // Get the token balance for account `tokenOwner`
172     // ------------------------------------------------------------------------
173     function balanceOf(address tokenOwner) public constant returns (uint balance) {
174         return startBalances[tokenOwner] + compoundInterest(tokenOwner);
175     }
176 
177     
178     // ------------------------------------------------------------------------
179     // Add the compound interest to the startBalance, update the start block,
180     // and update totalSupply
181     // ------------------------------------------------------------------------
182     function updateBalance(address tokenOwner) private {
183         if (startBlocks[tokenOwner] == 0) {
184             startBlocks[tokenOwner] = block.number;
185         }
186         uint ci = compoundInterest(tokenOwner);
187         startBalances[tokenOwner] = startBalances[tokenOwner].add(ci);
188         _totalSupply = _totalSupply.add(ci);
189         startBlocks[tokenOwner] = block.number;
190     }
191     
192     
193     // ------------------------------------------------------------------------
194     // Transfer the balance from token owner's account to `to` account
195     // - Owner's account must have sufficient balance to transfer
196     // - 0 value transfers are allowed
197     // ------------------------------------------------------------------------
198     function transfer(address to, uint tokens) public returns (bool success) {
199         updateBalance(msg.sender);
200         updateBalance(to);
201         startBalances[msg.sender] = startBalances[msg.sender].sub(tokens);
202         startBalances[to] = startBalances[to].add(tokens);
203         Transfer(msg.sender, to, tokens);
204         return true;
205     }
206 
207 
208     // ------------------------------------------------------------------------
209     // Token owner can approve for `spender` to transferFrom(...) `tokens`
210     // from the token owner's account
211     //
212     // https://github.com/ethereum/EIPs/blob/master/EIPS/eip-20-token-standard.md
213     // recommends that there are no checks for the approval double-spend attack
214     // as this should be implemented in user interfaces 
215     // ------------------------------------------------------------------------
216     function approve(address spender, uint tokens) public returns (bool success) {
217         allowed[msg.sender][spender] = tokens;
218         Approval(msg.sender, spender, tokens);
219         return true;
220     }
221 
222 
223     // ------------------------------------------------------------------------
224     // Transfer `tokens` from the `from` account to the `to` account
225     // 
226     // The calling account must already have sufficient tokens approve(...)-d
227     // for spending from the `from` account and
228     // - From account must have sufficient balance to transfer
229     // - Spender must have sufficient allowance to transfer
230     // - 0 value transfers are allowed
231     // ------------------------------------------------------------------------
232     function transferFrom(address from, address to, uint tokens) public returns (bool success) {
233         updateBalance(from);
234         updateBalance(to);
235         startBalances[from] = startBalances[from].sub(tokens);
236         allowed[from][msg.sender] = allowed[from][msg.sender].sub(tokens);
237         startBalances[to] = startBalances[to].add(tokens);
238         Transfer(from, to, tokens);
239         return true;
240     }
241 
242 
243     // ------------------------------------------------------------------------
244     // Returns the amount of tokens approved by the owner that can be
245     // transferred to the spender's account
246     // ------------------------------------------------------------------------
247     function allowance(address tokenOwner, address spender) public constant returns (uint remaining) {
248         return allowed[tokenOwner][spender];
249     }
250 
251 
252     // ------------------------------------------------------------------------
253     // Token owner can approve for `spender` to transferFrom(...) `tokens`
254     // from the token owner's account. The `spender` contract function
255     // `receiveApproval(...)` is then executed
256     // ------------------------------------------------------------------------
257     function approveAndCall(address spender, uint tokens, bytes data) public returns (bool success) {
258         allowed[msg.sender][spender] = tokens;
259         Approval(msg.sender, spender, tokens);
260         ApproveAndCallFallBack(spender).receiveApproval(msg.sender, tokens, this, data);
261         return true;
262     }
263 
264 
265     // ------------------------------------------------------------------------
266     // Don't accept ETH
267     // ------------------------------------------------------------------------
268     function () public payable {
269         revert();
270     }
271 
272 
273     // ------------------------------------------------------------------------
274     // Owner can transfer out any accidentally sent ERC20 tokens
275     // ------------------------------------------------------------------------
276     function transferAnyERC20Token(address tokenAddress, uint tokens) public onlyOwner returns (bool success) {
277         return ERC20Interface(tokenAddress).transfer(owner, tokens);
278     }
279 }