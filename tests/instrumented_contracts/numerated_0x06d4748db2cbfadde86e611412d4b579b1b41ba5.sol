1 pragma solidity ^0.5.10;
2 
3 // GOA TOKEN 
4 
5 /* 
6 
7 Deflationary token to be used in the Eggoa game (name TBD) to be released on Ethereum by mid-2020.
8 
9 When the Eggoa game releases, token holders will be able to mint unique NFTs by destroying Goa tokens.
10 (1 GOA = 1 NFT)
11 Additionally, Goa tokens may be used as voting rights, as well as other game advantages.
12 
13 Goa tokens can be bought directly from the contract, for a rising price proportional to the number of tokens sold.
14 Each Goa token costs +0.0000002 ETH.
15 Token #10000 will cost 0.002 ETH, token #30000 will cost 0.006 ETH, token #180000 will cost 0.036 ETH, and so on.
16 Goa tokens can only be bought as integers. Secondary markets between owners can take care of decimal trades.
17 
18 ----------------------------------------------------------------------------
19 Goa Token URL = https://eggforce.github.io/goatoken (subject to change)
20 Discord link = https://discord.gg/JU8P4Ru (probably permanent)
21 Tweet @ me and take credit for being the one guy who reads smart contracts = @eskaroy
22 ----------------------------------------------------------------------------
23 
24 */
25 
26 library SafeMath {
27 
28     function add(uint a, uint b) internal pure returns (uint c) {
29         c = a + b;
30         require(c >= a);
31     }
32 
33     function sub(uint a, uint b) internal pure returns (uint c) {
34         require(b <= a);
35         c = a - b;
36     }
37 
38     function mul(uint a, uint b) internal pure returns (uint c) {
39         c = a * b;
40         require(a == 0 || c / a == b);
41     }
42 
43     function div(uint a, uint b) internal pure returns (uint c) {
44         require(b > 0);
45         c = a / b;
46     }
47 }
48 
49 // ----------------------------------------------------------------------------
50 // ERC Token Standard #20 Interface
51 // https://github.com/ethereum/EIPs/blob/master/EIPS/eip-20.md
52 // ----------------------------------------------------------------------------
53 
54 contract ERC20Interface {
55 
56     function totalSupply() public view returns (uint);
57     function balanceOf(address tokenOwner) public view returns (uint balance);
58     function allowance(address tokenOwner, address spender) public view returns (uint remaining);
59     function transfer(address to, uint tokens) public returns (bool success);
60     function approve(address spender, uint tokens) public returns (bool success);
61     function transferFrom(address from, address to, uint tokens) public returns (bool success);
62 
63     event Transfer(address indexed from, address indexed to, uint tokens);
64     event Approval(address indexed tokenOwner, address indexed spender, uint tokens);
65 }
66 
67 // ----------------------------------------------------------------------------
68 // Contract function to receive approval and execute function in one call
69 // ----------------------------------------------------------------------------
70 
71 contract ApproveAndCallFallBack {
72     function receiveApproval(address from, uint256 tokens, address token, bytes memory data) public;
73 }
74 
75 // ----------------------------------------------------------------------------
76 // Owned contract
77 // ----------------------------------------------------------------------------
78 
79 contract Owned {
80 
81     address payable public owner;
82     address payable public newOwner;
83 
84     event OwnershipTransferred(address indexed _from, address indexed _to);
85 
86     constructor() public {
87         owner = msg.sender;
88     }
89 
90     modifier onlyOwner {
91         require(msg.sender == owner);
92         _;
93     }
94 
95     function transferOwnership(address payable _newOwner) public onlyOwner {
96         newOwner = _newOwner;
97     }
98 
99     function acceptOwnership() public {
100         require(msg.sender == newOwner);
101         
102         owner = newOwner;
103         newOwner = address(0);
104 
105         emit OwnershipTransferred(owner, newOwner);
106     }
107 }
108 
109 // ----------------------------------------------------------------------------
110 // Standard ERC20 Token contract, with extra functions for minting new tokens
111 // ----------------------------------------------------------------------------
112 
113 contract GoaToken is ERC20Interface, Owned {
114 
115     using SafeMath for uint;
116 
117     string constant public symbol       = "GOA";
118     string constant public name         = "Goa Token";
119     uint constant public decimals       = 18;
120     uint constant public MAX_SUPPLY     = 1000000 * 10 ** decimals;
121     uint constant public ETH_PER_TOKEN  = 0.0000002 ether;
122     
123     uint _totalSupply; //initially set to 0, tokens are minted through buying from the contract
124 
125     mapping(address => uint) balances; // token balance
126     mapping(address => mapping(address => uint)) allowed;
127     
128     event Minted(address indexed newHolder, uint eth, uint tokens);
129 
130     //-- constructor
131     constructor() public {
132     }
133 
134     //-- totalSupply
135     // Return current total supply (which can change but never exceed 1M)
136 
137     function totalSupply() public view returns (uint) {
138         return _totalSupply;
139     }
140 
141     //-- balanceOf
142     // Get token balance for account "tokenOwner"
143 
144     function balanceOf(address tokenOwner) public view returns (uint balance) {
145         return balances[tokenOwner];
146     }
147 
148     //-- transfer
149     // Transfer "tokens" from token owner's account to "to" account
150     // Owner's account must have sufficient balance to transfer
151     // 0 value transfers are allowed
152 
153     function transfer(address to, uint tokens) public returns (bool success) {
154         balances[msg.sender] = balances[msg.sender].sub(tokens);
155         balances[to] = balances[to].add(tokens);
156 
157         emit Transfer(msg.sender, to, tokens);
158 
159         return true;
160     }
161 
162     //-- approve
163     // Token owner can approve for "spender" to transferFrom(...) "tokens" tokens
164     // from the token owner's account
165     // https://github.com/ethereum/EIPs/blob/master/EIPS/eip-20-token-standard.md
166     // recommends that there are no checks for the approval double-spend attack
167     // as this should be implemented in user interfaces
168 
169     function approve(address spender, uint tokens) public returns (bool success) {
170         allowed[msg.sender][spender] = tokens;
171 
172         emit Approval(msg.sender, spender, tokens);
173 
174         return true;
175     }
176 
177     //-- transferFrom
178     // Transfer "tokens" tokens from the "from" account to the "to" account
179     // From account must have sufficient balance to transfer
180     // Spender must have sufficient allowance to transfer
181     // 0 value transfers are allowed
182 
183     function transferFrom(address from, address to, uint tokens) public returns (bool success) {
184         balances[from] = balances[from].sub(tokens);
185         allowed[from][msg.sender] = allowed[from][msg.sender].sub(tokens);
186         balances[to] = balances[to].add(tokens);
187 
188         emit Transfer(from, to, tokens);
189 
190         return true;
191     }
192 
193     //-- allowance
194     // Return the amount of tokens approved by the owner that can be
195     // transferred to the spender's account
196 
197     function allowance(address tokenOwner, address spender) public view returns (uint remaining) {
198         return allowed[tokenOwner][spender];
199     }
200 
201     //-- approveAndCall
202     // Token owner can approve for "spender" to transferFrom(...) "tokens" tokens
203     // from the token owner's account. The "spender" contract function
204     // "receiveApproval(...)"" is then executed
205 
206     function approveAndCall(address spender, uint tokens, bytes memory data) public returns (bool success) {
207         allowed[msg.sender][spender] = tokens;
208 
209         emit Approval(msg.sender, spender, tokens);
210 
211         ApproveAndCallFallBack(spender).receiveApproval(msg.sender, tokens, address(this), data);
212 
213         return true;
214     }
215 
216     //-- mint
217     // Transfer ETH to receive a given amount of tokens in exchange
218     // Token amount must be integers, no decimals
219     // Current token cost is determined through computeCost, frontend sets the proper ETH amount to send
220 
221     function mint(uint fullToken) public payable {
222         uint _token = fullToken.mul(10 ** decimals);
223         uint _newSupply = _totalSupply.add(_token);
224         require(_newSupply <= MAX_SUPPLY, "supply cannot go over 1M");
225 
226         uint _ethCost = computeCost(fullToken);
227         require(msg.value == _ethCost, "wrong ETH amount for tokens");
228         
229         owner.transfer(msg.value);
230         _totalSupply = _newSupply;
231         balances[msg.sender] = balances[msg.sender].add(_token);
232         
233         emit Minted(msg.sender, msg.value, fullToken);
234     }
235     
236     //-- computeSum
237     // Return (n * n+1) / 2 sum starting at a and ending at b, excluding a
238     
239     function computeSum(uint256 a, uint256 b) public pure returns(uint256) {
240         uint256 _sumA = a.mul(a.add(1)).div(2);
241         uint256 _sumB = b.mul(b.add(1)).div(2);
242         return _sumB.sub(_sumA);
243     }
244     
245     //-- computeCost
246     // Return ETH cost to buy given amount of full tokens (no decimals)
247     
248     function computeCost(uint256 fullToken) public view returns(uint256) {
249         uint256 _intSupply = _totalSupply.div(10 ** decimals);
250         uint256 _current = fullToken.add(_intSupply);
251         uint256 _sum = computeSum(_intSupply, _current);
252         return ETH_PER_TOKEN.mul(_sum);
253     }
254         
255     //-- transferAnyERC20Token
256     // Owner can transfer out any accidentally sent ERC20 tokens
257 
258     function transferAnyERC20Token(address tokenAddress, uint tokens) public onlyOwner returns (bool success) {
259         return ERC20Interface(tokenAddress).transfer(owner, tokens);
260     }
261 }