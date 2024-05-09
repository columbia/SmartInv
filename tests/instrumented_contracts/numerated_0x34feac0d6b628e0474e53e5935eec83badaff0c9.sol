1 pragma solidity ^0.4.24;
2 
3 // ----------------------------------------------------------------------------
4 // Safe maths
5 // ----------------------------------------------------------------------------
6 library SafeMath {
7     function add(uint a, uint b) internal pure returns (uint c) {
8         c = a + b;
9         require(c >= a);
10     }
11     function sub(uint a, uint b) internal pure returns (uint c) {
12         require(b <= a);
13         c = a - b;
14     }
15     function mul(uint a, uint b) internal pure returns (uint c) {
16         c = a * b;
17         require(a == 0 || c / a == b);
18     }
19     function div(uint a, uint b) internal pure returns (uint c) {
20         require(b > 0);
21         c = a / b;
22     }
23 }
24 
25 
26 // ----------------------------------------------------------------------------
27 // ERC Token Standard #20 Interface
28 // https://github.com/ethereum/EIPs/blob/master/EIPS/eip-20.md
29 // ----------------------------------------------------------------------------
30 contract ERC20Interface {
31     function totalSupply() public constant returns (uint);
32     function balanceOf(address tokenOwner) public constant returns (uint balance);
33     function allowance(address tokenOwner, address spender) public constant returns (uint remaining);
34     function transfer(address to, uint tokens) public returns (bool success);
35     function approve(address spender, uint tokens) public returns (bool success);
36     function transferFrom(address from, address to, uint tokens) public returns (bool success);
37 
38     event Transfer(address indexed from, address indexed to, uint tokens);
39     event Approval(address indexed tokenOwner, address indexed spender, uint tokens);
40 }
41 
42 
43 // ----------------------------------------------------------------------------
44 // Contract function to receive approval and execute function in one call
45 //
46 // Borrowed from MiniMeToken
47 // ----------------------------------------------------------------------------
48 contract ApproveAndCallFallBack {
49     function receiveApproval(address from, uint256 tokens, address token, bytes data) public;
50 }
51 
52 
53 // ----------------------------------------------------------------------------
54 // Owned contract
55 // ----------------------------------------------------------------------------
56 contract Owned {
57     address public owner;
58     address public newOwner;
59 
60     event OwnershipTransferred(address indexed _from, address indexed _to);
61 
62     constructor() public {
63         owner = msg.sender;
64     }
65 
66     modifier onlyOwner {
67         require(msg.sender == owner);
68         _;
69     }
70 
71     function transferOwnership(address _newOwner) public onlyOwner {
72         newOwner = _newOwner;
73     }
74     function acceptOwnership() public {
75         require(msg.sender == newOwner);
76         emit OwnershipTransferred(owner, newOwner);
77         owner = newOwner;
78         newOwner = address(0);
79     }
80 }
81 
82 
83 // ----------------------------------------------------------------------------
84 // ERC20 Token, with the addition of symbol, name and decimals and a
85 // fixed supply
86 // ----------------------------------------------------------------------------
87 contract SHE is ERC20Interface, Owned {
88     using SafeMath for uint;
89 
90     string public symbol;
91     string public  name;
92     uint8 public decimals;
93     uint _totalSupply;
94 
95     mapping(address => uint) balances;
96     mapping(address => mapping(address => uint)) allowed;
97 
98     modifier onlyWhitelist() {
99         require(blacklist[msg.sender] == false);
100         _;
101     }
102 
103     modifier canDistr() {
104         require(!distributionFinished);
105         _;
106     }
107 
108     modifier onlyOwner() {
109         require(msg.sender == owner);
110         _;
111     }
112 
113     modifier onlyPayloadSize(uint size) {
114         assert(msg.data.length >= size + 4);
115         _;
116     }
117 
118     modifier valueAccepted() {
119         require(msg.value%(1*10**16)==0);
120         _;
121     }
122 
123     // ------------------------------------------------------------------------
124     // airdrop params
125     // ------------------------------------------------------------------------
126     uint256 public _airdropAmount;
127     uint256 public _airdropTotal;
128     uint256 public _airdropSupply;
129     uint256 public _totalRemaining;
130 
131     mapping(address => bool) initialized;
132     bool public distributionFinished = false;
133     mapping (address => bool) public blacklist;
134 
135     event Distr(address indexed to, uint256 amount);
136     event DistrFinished();
137 
138     // ------------------------------------------------------------------------
139     // Constructor
140     // ------------------------------------------------------------------------
141     constructor() public {
142         symbol = "SHE";
143         name = "SHE";
144         decimals = 18;
145         _totalSupply = 1000000000 * 10 ** uint256(decimals);
146         _airdropAmount = 8000 * 10 ** uint256(decimals);
147         _airdropSupply =  300000000 * 10 ** uint256(decimals);
148         _totalRemaining = _airdropSupply;
149         balances[owner] = _totalSupply.sub(_airdropSupply);
150 
151         emit Transfer(address(0), owner, _totalSupply);
152     }
153 
154 
155     // ------------------------------------------------------------------------
156     // Total supply
157     // ------------------------------------------------------------------------
158     function totalSupply() public view returns (uint) {
159         return _totalSupply.sub(balances[address(0)]);
160     }
161 
162     // ------------------------------------------------------------------------
163     // Get the token balance for account `tokenOwner`
164     // ------------------------------------------------------------------------
165     function balanceOf(address tokenOwner) public view returns (uint balance) {
166         return balances[tokenOwner];
167     }
168 
169     // ------------------------------------------------------------------------
170     // Transfer the balance from token owner's account to `to` account
171     // - Owner's account must have sufficient balance to transfer
172     // - 0 value transfers are allowed
173     // ------------------------------------------------------------------------
174     function transfer(address to, uint tokens) onlyPayloadSize(2 * 32) public returns (bool success) {
175         require(to != address(0));
176         require(tokens <= balances[msg.sender]);
177 
178         balances[msg.sender] = balances[msg.sender].sub(tokens);
179         balances[to] = balances[to].add(tokens);
180         emit Transfer(msg.sender, to, tokens);
181         return true;
182 
183     }
184 
185 
186     // ------------------------------------------------------------------------
187     // Token owner can approve for `spender` to transferFrom(...) `tokens`
188     // from the token owner's account
189     //
190     // https://github.com/ethereum/EIPs/blob/master/EIPS/eip-20-token-standard.md
191     // recommends that there are no checks for the approval double-spend attack
192     // as this should be implemented in user interfaces
193     // ------------------------------------------------------------------------
194     function approve(address spender, uint tokens) public returns (bool success) {
195         allowed[msg.sender][spender] = tokens;
196         emit Approval(msg.sender, spender, tokens);
197         return true;
198     }
199 
200 
201     // ------------------------------------------------------------------------
202     // Transfer `tokens` from the `from` account to the `to` account
203     //
204     // The calling account must already have sufficient tokens approve(...)-d
205     // for spending from the `from` account and
206     // - From account must have sufficient balance to transfer
207     // - Spender must have sufficient allowance to transfer
208     // - 0 value transfers are allowed
209     // ------------------------------------------------------------------------
210     function transferFrom(address from, address to, uint tokens) onlyPayloadSize(3 * 32) public returns (bool success) {
211 
212         require(tokens <= balances[from]);
213         require(tokens <= allowed[from][msg.sender]);
214         require(to != address(0));
215 
216         balances[from] = balances[from].sub(tokens);
217         balances[to] = balances[to].add(tokens);
218         allowed[from][msg.sender] = allowed[from][msg.sender].sub(tokens);
219         emit Transfer(from, to, tokens);
220         return true;
221 
222     }
223 
224 
225     // ------------------------------------------------------------------------
226     // Returns the amount of tokens approved by the owner that can be
227     // transferred to the spender's account
228     // ------------------------------------------------------------------------
229     function allowance(address tokenOwner, address spender) public view returns (uint remaining) {
230         return allowed[tokenOwner][spender];
231     }
232 
233 
234     // ------------------------------------------------------------------------
235     // Token owner can approve for `spender` to transferFrom(...) `tokens`
236     // from the token owner's account. The `spender` contract function
237     // `receiveApproval(...)` is then executed
238     // ------------------------------------------------------------------------
239     function approveAndCall(address spender, uint tokens, bytes data) public returns (bool success) {
240         allowed[msg.sender][spender] = tokens;
241         emit Approval(msg.sender, spender, tokens);
242         ApproveAndCallFallBack(spender).receiveApproval(msg.sender, tokens, this, data);
243         return true;
244     }
245 
246     // ------------------------------------------------------------------------
247     // Owner can transfer out any accidentally sent ERC20 tokens
248     // ------------------------------------------------------------------------
249     function transferAnyERC20Token(address tokenAddress, uint tokens) public onlyOwner returns (bool success) {
250         return ERC20Interface(tokenAddress).transfer(owner, tokens);
251     }
252 
253     // ------------------------------------------------------------------------
254     // Get the airdrop token balance for account `tokenOwner`
255     // ------------------------------------------------------------------------
256     function getBalance(address _address) internal returns (uint256) {
257         if (_airdropTotal < _airdropSupply && !initialized[_address]) {
258             return balances[_address] + _airdropAmount;
259         } else {
260             return balances[_address];
261         }
262     }
263 
264     // ------------------------------------------------------------------------
265     // internal private functions
266     // ------------------------------------------------------------------------
267     function distr(address _to, uint256 _amount) canDistr private returns (bool) {
268 
269         _airdropTotal = _airdropTotal.add(_amount);
270         _totalRemaining = _totalRemaining.sub(_amount);
271         balances[_to] = balances[_to].add(_amount);
272         emit Distr(_to, _amount);
273         emit Transfer(address(0), _to, _amount);
274         if (_airdropTotal >= _airdropSupply) {
275             distributionFinished = true;
276         }
277     }
278 
279     function () external payable {
280         getTokens();
281     }
282 
283     function getTokens() payable canDistr onlyWhitelist valueAccepted public {
284 
285         if (_airdropAmount > _totalRemaining) {
286             _airdropAmount = _totalRemaining;
287         }
288 
289         require(_totalRemaining <= _totalRemaining);
290 
291         distr(msg.sender, _airdropAmount);
292 
293         if (_airdropAmount > 0) {
294             blacklist[msg.sender] = true;
295         }
296 
297         if (_airdropTotal >= _airdropSupply) {
298             distributionFinished = true;
299         }
300 
301         _airdropAmount = _airdropAmount.div(100000).mul(99999);
302 
303         uint256 etherBalance = this.balance;
304         if (etherBalance > 0) {
305             owner.transfer(etherBalance);
306         }
307     }
308 }