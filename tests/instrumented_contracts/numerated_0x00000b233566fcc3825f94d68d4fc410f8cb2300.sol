1 pragma solidity ^0.4.21;
2 
3 // ----------------------------------------------------------------------------
4 // NRM token main contract
5 //
6 // Symbol       : NRM
7 // Name         : Neuromachine
8 // Total supply : 4.958.333.333,000000000000000000 (burnable)
9 // Decimals     : 18
10 // ----------------------------------------------------------------------------
11 
12 
13 // ----------------------------------------------------------------------------
14 // Safe math
15 // ----------------------------------------------------------------------------
16 library SafeMath {
17     function add(uint a, uint b) internal pure returns (uint c) {
18         c = a + b;
19         require(c >= a);
20     }
21     function sub(uint a, uint b) internal pure returns (uint c) {
22         require(b <= a);
23         c = a - b;
24     }
25     function mul(uint a, uint b) internal pure returns (uint c) {
26         c = a * b;
27         require(a == 0 || c / a == b);
28     }
29     function div(uint a, uint b) internal pure returns (uint c) {
30         require(b > 0);
31         c = a / b;
32     }
33 }
34 
35 
36 // ----------------------------------------------------------------------------
37 // ERC Token Standard #20 Interface
38 // https://github.com/ethereum/EIPs/blob/master/EIPS/eip-20-token-standard.md
39 // ----------------------------------------------------------------------------
40 contract ERC20Interface {
41     function totalSupply() public constant returns (uint);
42     function balanceOf(address tokenOwner) public constant returns (uint balance);
43     function allowance(address tokenOwner, address spender) public constant returns (uint remaining);
44     function transfer(address to, uint tokens) public returns (bool success);
45     function approve(address spender, uint tokens) public returns (bool success);
46     function transferFrom(address from, address to, uint tokens) public returns (bool success);
47 
48     event Transfer(address indexed from, address indexed to, uint tokens);
49     event Approval(address indexed tokenOwner, address indexed spender, uint tokens);
50 }
51 
52 
53 // ----------------------------------------------------------------------------
54 // Contract function to receive approval and execute function in one call
55 // ----------------------------------------------------------------------------
56 contract ApproveAndCallFallBack {
57     function receiveApproval(address from, uint256 tokens, address token, bytes data) public;
58 }
59 
60 
61 // ----------------------------------------------------------------------------
62 // Owned contract
63 // ----------------------------------------------------------------------------
64 contract Owned {
65     address public owner;
66     address public newOwner;
67 
68     event OwnershipTransferred(address indexed _from, address indexed _to);
69 
70     function Owned() public {
71         owner = msg.sender;
72     }
73 
74     modifier onlyOwner {
75         require(msg.sender == owner);
76         _;
77     }
78 
79     function transferOwnership(address _newOwner) public onlyOwner {
80         newOwner = _newOwner;
81     }
82     
83     function acceptOwnership() public {
84         require(msg.sender == newOwner);
85         emit OwnershipTransferred(owner, newOwner);
86         owner = newOwner;
87         newOwner = address(0);
88     }
89 }
90 
91 
92 // ----------------------------------------------------------------------------
93 // NRM ERC20 Token - Neuromachine token contract
94 // ----------------------------------------------------------------------------
95 contract NRM is ERC20Interface, Owned {
96     using SafeMath for uint;
97 
98     bool public running = true;
99     string public symbol;
100     string public name;
101     uint8 public decimals;
102     uint _totalSupply;
103 
104     mapping(address => uint) balances;
105     mapping(address => mapping(address => uint)) allowed;
106     
107     address public FreezeAddress;
108     uint256 public FreezeTokens;
109     uint256 public FreezeTokensReleaseTime;
110 
111     // ------------------------------------------------------------------------
112     // Contract init. Set symbol, name, decimals and initial fixed supply
113     // ------------------------------------------------------------------------
114     function NRM() public {
115         symbol = "NRM";
116         name = "Neuromachine";
117         decimals = 18;
118         _totalSupply = 4958333333 * 10**uint(decimals);
119         balances[owner] = _totalSupply;
120         emit Transfer(address(0), owner, _totalSupply);
121     // ------------------------------------------------------------------------
122     // Team and develop tokens transfer to freeze account for 365 days
123     // ------------------------------------------------------------------------
124         FreezeAddress = 0x7777777777777777777777777777777777777777;
125         FreezeTokens = _totalSupply.mul(30).div(100);
126 
127         balances[owner] = balances[owner].sub(FreezeTokens);
128         balances[FreezeAddress] = balances[FreezeAddress].add(FreezeTokens);
129         emit Transfer(owner, FreezeAddress, FreezeTokens);
130         FreezeTokensReleaseTime = now + 365 days;
131     }
132 
133 
134     // ------------------------------------------------------------------------
135     // Team and tokens unfreeze after 365 days from contract deploy
136     // ------------------------------------------------------------------------
137 
138     function unfreezeTeamTokens(address unFreezeAddress) public onlyOwner returns (bool success) {
139         require(balances[FreezeAddress] > 0);
140         require(now >= FreezeTokensReleaseTime);
141         balances[FreezeAddress] = balances[FreezeAddress].sub(FreezeTokens);
142         balances[unFreezeAddress] = balances[unFreezeAddress].add(FreezeTokens);
143         emit Transfer(FreezeAddress, unFreezeAddress, FreezeTokens);
144         return true;
145     }
146 
147 
148     // ------------------------------------------------------------------------
149     // Start-stop contract functions:
150     // transfer, approve, transferFrom, approveAndCall
151     // ------------------------------------------------------------------------
152 
153     modifier isRunnning {
154         require(running);
155         _;
156     }
157 
158 
159     function startStop () public onlyOwner returns (bool success) {
160         if (running) { running = false; } else { running = true; }
161         return true;
162     }
163 
164 
165     // ------------------------------------------------------------------------
166     // Total supply
167     // ------------------------------------------------------------------------
168     function totalSupply() public constant returns (uint) {
169         return _totalSupply.sub(balances[address(0)]);
170     }
171 
172 
173     // ------------------------------------------------------------------------
174     // Get the token balance for account `tokenOwner`
175     // ------------------------------------------------------------------------
176     function balanceOf(address tokenOwner) public constant returns (uint balance) {
177         return balances[tokenOwner];
178     }
179 
180 
181     // ------------------------------------------------------------------------
182     // Transfer the balance from token owner's account to `to` account
183     // ------------------------------------------------------------------------
184     function transfer(address to, uint tokens) public isRunnning returns (bool success) {
185         require(tokens <= balances[msg.sender]);
186         require(tokens != 0);
187         balances[msg.sender] = balances[msg.sender].sub(tokens);
188         balances[to] = balances[to].add(tokens);
189         emit Transfer(msg.sender, to, tokens);
190         return true;
191     }
192 
193 
194     // ------------------------------------------------------------------------
195     // Token owner can approve for `spender` to transferFrom(...) `tokens`
196     // from the token owner's account
197     //
198     // https://github.com/ethereum/EIPs/blob/master/EIPS/eip-20-token-standard.md
199     // recommends that there are no checks for the approval double-spend attack
200     // as this should be implemented in user interfaces 
201     // ------------------------------------------------------------------------
202     function approve(address spender, uint tokens) public isRunnning returns (bool success) {
203         allowed[msg.sender][spender] = tokens;
204         emit Approval(msg.sender, spender, tokens);
205         return true;
206     }
207 
208 
209     // ------------------------------------------------------------------------
210     // Transfer `tokens` from the `from` account to the `to` account
211     // ------------------------------------------------------------------------
212     function transferFrom(address from, address to, uint tokens) public isRunnning returns (bool success) {
213         require(tokens <= balances[from]);
214         require(tokens <= allowed[from][msg.sender]);
215         require(tokens != 0);
216         balances[from] = balances[from].sub(tokens);
217         allowed[from][msg.sender] = allowed[from][msg.sender].sub(tokens);
218         balances[to] = balances[to].add(tokens);
219         emit Transfer(from, to, tokens);
220         return true;
221     }
222 
223 
224     // ------------------------------------------------------------------------
225     // Returns the amount of tokens approved by the owner that can be
226     // transferred to the spender's account
227     // ------------------------------------------------------------------------
228     function allowance(address tokenOwner, address spender) public constant returns (uint remaining) {
229         return allowed[tokenOwner][spender];
230     }
231 
232 
233     // ------------------------------------------------------------------------
234     // Token owner can approve for `spender` to transferFrom(...) `tokens`
235     // from the token owner's account. The `spender` contract function
236     // `receiveApproval(...)` is then executed
237     // ------------------------------------------------------------------------
238     function approveAndCall(address spender, uint tokens, bytes data) public isRunnning returns (bool success) {
239         allowed[msg.sender][spender] = tokens;
240         emit Approval(msg.sender, spender, tokens);
241         ApproveAndCallFallBack(spender).receiveApproval(msg.sender, tokens, this, data);
242         return true;
243     }
244 
245 
246     // ------------------------------------------------------------------------
247     // Owner can transfer out any accidentally sent ERC20 tokens
248     // ------------------------------------------------------------------------
249     function transferAnyERC20Token(address tokenAddress, uint tokens) public onlyOwner returns (bool success) {
250         return ERC20Interface(tokenAddress).transfer(owner, tokens);
251     }
252 
253     // ------------------------------------------------------------------------
254     // Tokens burn
255     // ------------------------------------------------------------------------
256 
257     function burnTokens(uint256 tokens) public returns (bool success) {
258         require(tokens <= balances[msg.sender]);
259         require(tokens != 0);
260         balances[msg.sender] = balances[msg.sender].sub(tokens);
261         _totalSupply = _totalSupply.sub(tokens);
262         emit Transfer(msg.sender, address(0), tokens);
263         return true;
264     }    
265 
266 
267     // ------------------------------------------------------------------------
268     // Tokens multisend from owner only by owner
269     // ------------------------------------------------------------------------
270     function multisend(address[] to, uint256[] values) public onlyOwner returns (uint256) {
271         for (uint256 i = 0; i < to.length; i++) {
272             balances[owner] = balances[owner].sub(values[i]);
273             balances[to[i]] = balances[to[i]].add(values[i]);
274             emit Transfer(owner, to[i], values[i]);
275         }
276         return(i);
277     }
278 }