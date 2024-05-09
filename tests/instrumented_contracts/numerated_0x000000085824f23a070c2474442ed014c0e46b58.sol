1 pragma solidity 0.5.8;
2 
3 // ----------------------------------------------------------------------------
4 // NRM token main contract (2019)
5 //
6 // Symbol       : NRM
7 // Name         : Neuromachine Eternal
8 // Total supply : 4.958.333.333 (burnable)
9 // Decimals     : 18
10 //
11 // Telegram @SergeyKalich
12 // ----------------------------------------------------------------------------
13 
14 library SafeMath {
15     function add(uint a, uint b) internal pure returns (uint c) { c = a + b; require(c >= a); }
16     function sub(uint a, uint b) internal pure returns (uint c) { require(b <= a); c = a - b; }
17     function mul(uint a, uint b) internal pure returns (uint c) { c = a * b; require(a == 0 || c / a == b); }
18     function div(uint a, uint b) internal pure returns (uint c) { require(b > 0); c = a / b; }
19 }
20 
21 // ----------------------------------------------------------------------------
22 // ERC Token Standard #20 Interface
23 // https://github.com/ethereum/EIPs/blob/master/EIPS/eip-20-token-standard.md
24 // ----------------------------------------------------------------------------
25 
26 contract ERC20Interface {
27     function totalSupply() public view returns (uint);
28     function balanceOf(address tokenOwner) public view returns (uint balance);
29     function allowance(address tokenOwner, address spender) public view returns (uint remaining);
30     function transfer(address to, uint tokens) public returns (bool success);
31     function approve(address spender, uint tokens) public returns (bool success);
32     function transferFrom(address from, address to, uint tokens) public returns (bool success);
33 
34     event Transfer(address indexed from, address indexed to, uint tokens);
35     event Approval(address indexed tokenOwner, address indexed spender, uint tokens);
36 }
37 
38 // ----------------------------------------------------------------------------
39 // Contract function to receive approval and execute function in one call
40 // ----------------------------------------------------------------------------
41 contract ApproveAndCallFallBack {
42     function receiveApproval(address from, uint tokens, address token, bytes memory data) public;
43 }
44 
45 // ----------------------------------------------------------------------------
46 // Owned contract
47 // ----------------------------------------------------------------------------
48 contract Owned {
49     address public owner;
50     address public newOwner;
51 
52     event OwnershipTransferred(address indexed from, address indexed to);
53 
54     constructor() public {
55         owner = msg.sender;
56     }
57 
58     modifier onlyOwner {
59         require(msg.sender == owner);
60         _;
61     }
62 
63     function transferOwnership(address transferOwner) public onlyOwner {
64         require(transferOwner != newOwner);
65         newOwner = transferOwner;
66     }
67 
68     function acceptOwnership() public {
69         require(msg.sender == newOwner);
70         emit OwnershipTransferred(owner, newOwner);
71         owner = newOwner;
72         newOwner = address(0);
73     }
74 }
75 
76 // ----------------------------------------------------------------------------
77 // NRM ERC20 Token - Neuromachine token contract
78 // ----------------------------------------------------------------------------
79 contract NRM is ERC20Interface, Owned {
80     using SafeMath for uint;
81 
82     bool public running = true;
83     string public symbol;
84     string public name;
85     uint8 public decimals;
86     uint _totalSupply;
87 
88     mapping(address => uint) balances;
89     mapping(address => mapping(address => uint)) allowed;
90 
91     address FreezeAddress = address(7);
92     uint FreezeTokens;
93     uint FreezeTokensReleaseTime = 1580169600;
94 
95     // ------------------------------------------------------------------------
96     // Contract init. Set symbol, name, decimals and initial fixed supply
97     // ------------------------------------------------------------------------
98     constructor() public {
99         symbol = "NRM";
100         name = "Neuromachine Eternal";
101         decimals = 18;
102         _totalSupply = 4958333333 * 10**uint(decimals);
103         balances[owner] = _totalSupply;
104         emit Transfer(address(0), owner, _totalSupply);
105 
106     // ------------------------------------------------------------------------
107     // Freeze team tokens until January 28, 2020
108     // ------------------------------------------------------------------------
109         FreezeTokens = _totalSupply.mul(30).div(100);
110         balances[owner] = balances[owner].sub(FreezeTokens);
111         balances[FreezeAddress] = balances[FreezeAddress].add(FreezeTokens);
112         emit Transfer(owner, FreezeAddress, FreezeTokens);
113     }
114 
115     // ------------------------------------------------------------------------
116     // Unfreeze team tokens after January 28, 2020
117     // ------------------------------------------------------------------------
118     function unfreezeTeamTokens(address unFreezeAddress) public onlyOwner returns (bool success) {
119         require(now >= FreezeTokensReleaseTime);
120         balances[FreezeAddress] = balances[FreezeAddress].sub(FreezeTokens);
121         balances[unFreezeAddress] = balances[unFreezeAddress].add(FreezeTokens);
122         emit Transfer(FreezeAddress, unFreezeAddress, FreezeTokens);
123         return true;
124     }
125 
126     // ------------------------------------------------------------------------
127     // Start-stop contract functions:
128     // transfer, approve, transferFrom, approveAndCall
129     // ------------------------------------------------------------------------
130     modifier isRunning {
131         require(running);
132         _;
133     }
134 
135     function startStop () public onlyOwner returns (bool success) {
136         if (running) { running = false; } else { running = true; }
137         return true;
138     }
139 
140     // ------------------------------------------------------------------------
141     // Total supply
142     // ------------------------------------------------------------------------
143     function totalSupply() public view returns (uint) {
144         return _totalSupply;
145     }
146 
147     // ------------------------------------------------------------------------
148     // Get the token balance for account `tokenOwner`
149     // ------------------------------------------------------------------------
150     function balanceOf(address tokenOwner) public view returns (uint balance) {
151         return balances[tokenOwner];
152     }
153 
154     // ------------------------------------------------------------------------
155     // Transfer the balance from token owner's account to `to` account
156     // ------------------------------------------------------------------------
157     function transfer(address to, uint tokens) public isRunning returns (bool success) {
158         require(tokens <= balances[msg.sender]);
159         require(to != address(0));
160         balances[msg.sender] = balances[msg.sender].sub(tokens);
161         balances[to] = balances[to].add(tokens);
162         emit Transfer(msg.sender, to, tokens);
163         return true;
164     }
165 
166     // ------------------------------------------------------------------------
167     // Token owner can approve for `spender` to transferFrom(...) `tokens`
168     // from the token owner's account
169     //
170     // https://github.com/ethereum/EIPs/blob/master/EIPS/eip-20-token-standard.md
171     // recommends that there are no checks for the approval double-spend attack
172     // as this should be implemented in user interfaces
173     // ------------------------------------------------------------------------
174     function approve(address spender, uint tokens) public isRunning returns (bool success) {
175         _approve(msg.sender, spender, tokens);
176         return true;
177     }
178 
179     // ------------------------------------------------------------------------
180     // Increase the amount of tokens that an owner allowed to a spender.
181     // ------------------------------------------------------------------------
182     function increaseAllowance(address spender, uint addedTokens) public isRunning returns (bool success) {
183         _approve(msg.sender, spender, allowed[msg.sender][spender].add(addedTokens));
184         return true;
185     }
186 
187     // ------------------------------------------------------------------------
188     // Decrease the amount of tokens that an owner allowed to a spender.
189     // ------------------------------------------------------------------------
190     function decreaseAllowance(address spender, uint subtractedTokens) public isRunning returns (bool success) {
191         _approve(msg.sender, spender, allowed[msg.sender][spender].sub(subtractedTokens));
192         return true;
193     }
194 
195     // ------------------------------------------------------------------------
196     // Token owner can approve for `spender` to transferFrom(...) `tokens`
197     // from the token owner's account. The `spender` contract function
198     // `receiveApproval(...)` is then executed
199     // ------------------------------------------------------------------------
200     function approveAndCall(address spender, uint tokens, bytes memory data) public isRunning returns (bool success) {
201         _approve(msg.sender, spender, tokens);
202         ApproveAndCallFallBack(spender).receiveApproval(msg.sender, tokens, address(this), data);
203         return true;
204     }
205 
206     // ------------------------------------------------------------------------
207     // Approve an address to spend another addresses' tokens.
208     // ------------------------------------------------------------------------
209     function _approve(address owner, address spender, uint256 value) internal {
210         require(owner != address(0));
211         require(spender != address(0));
212         allowed[owner][spender] = value;
213         emit Approval(owner, spender, value);
214     }
215 
216     // ------------------------------------------------------------------------
217     // Transfer `tokens` from the `from` account to the `to` account
218     // ------------------------------------------------------------------------
219     function transferFrom(address from, address to, uint tokens) public isRunning returns (bool success) {
220         require(to != address(0));
221         balances[from] = balances[from].sub(tokens);
222         _approve(from, msg.sender, allowed[from][msg.sender].sub(tokens));
223         balances[to] = balances[to].add(tokens);
224         emit Transfer(from, to, tokens);
225         return true;
226     }
227 
228     // ------------------------------------------------------------------------
229     // Returns the amount of tokens approved by the owner that can be
230     // transferred to the spender's account
231     // ------------------------------------------------------------------------
232     function allowance(address tokenOwner, address spender) public view returns (uint remaining) {
233         return allowed[tokenOwner][spender];
234     }
235 
236     // ------------------------------------------------------------------------
237     // Owner can transfer out any accidentally sent ERC20 tokens
238     // ------------------------------------------------------------------------
239     function transferAnyERC20Token(address tokenAddress, uint tokens) public onlyOwner returns (bool success) {
240         return ERC20Interface(tokenAddress).transfer(owner, tokens);
241     }
242 
243     // ------------------------------------------------------------------------
244     // Tokens burn
245     // ------------------------------------------------------------------------
246     function burnTokens(uint tokens) public returns (bool success) {
247         require(tokens <= balances[msg.sender]);
248         balances[msg.sender] = balances[msg.sender].sub(tokens);
249         _totalSupply = _totalSupply.sub(tokens);
250         emit Transfer(msg.sender, address(0), tokens);
251         return true;
252     }
253 
254     // ------------------------------------------------------------------------
255     // Tokens multisend from owner only by owner
256     // ------------------------------------------------------------------------
257     function multisend(address[] memory to, uint[] memory values) public onlyOwner returns (uint) {
258         require(to.length == values.length);
259         require(to.length < 100);
260         uint sum;
261         for (uint j; j < values.length; j++) {
262             sum += values[j];
263         }
264         balances[owner] = balances[owner].sub(sum);
265         for (uint i; i < to.length; i++) {
266             balances[to[i]] = balances[to[i]].add(values[i]);
267             emit Transfer(owner, to[i], values[i]);
268         }
269         return(to.length);
270     }
271 }