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
87 contract BBT is ERC20Interface, Owned {
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
118     // ------------------------------------------------------------------------
119     // airdrop params
120     // ------------------------------------------------------------------------
121     uint256 public _airdropAmount;
122     uint256 public _airdropTotal;
123     uint256 public _airdropSupply;
124     uint256 public _totalRemaining;
125 
126     mapping(address => bool) initialized;
127     bool public distributionFinished = false;
128     mapping (address => bool) public blacklist;
129 
130     event Distr(address indexed to, uint256 amount);
131     event DistrFinished();
132 
133     // ------------------------------------------------------------------------
134     // Constructor
135     // ------------------------------------------------------------------------
136     constructor() public {
137         symbol = "BBT";
138         name = "BiBox";
139         decimals = 18;
140         _totalSupply = 1000000000 * 10 ** uint256(decimals);
141         _airdropAmount = 35000 * 10 ** uint256(decimals);
142         _airdropSupply =  300000000 * 10 ** uint256(decimals);
143         _totalRemaining = _airdropSupply;
144         balances[owner] = _totalSupply.sub(_airdropSupply);
145 
146         emit Transfer(address(0), owner, _totalSupply);
147     }
148 
149 
150     // ------------------------------------------------------------------------
151     // Total supply
152     // ------------------------------------------------------------------------
153     function totalSupply() public view returns (uint) {
154         return _totalSupply.sub(balances[address(0)]);
155     }
156 
157     // ------------------------------------------------------------------------
158     // Get the token balance for account `tokenOwner`
159     // ------------------------------------------------------------------------
160     function balanceOf(address tokenOwner) public view returns (uint balance) {
161         return balances[tokenOwner];
162     }
163 
164     // ------------------------------------------------------------------------
165     // Transfer the balance from token owner's account to `to` account
166     // - Owner's account must have sufficient balance to transfer
167     // - 0 value transfers are allowed
168     // ------------------------------------------------------------------------
169     function transfer(address to, uint tokens) onlyPayloadSize(2 * 32) public returns (bool success) {
170         require(to != address(0));
171         require(tokens <= balances[msg.sender]);
172 
173         balances[msg.sender] = balances[msg.sender].sub(tokens);
174         balances[to] = balances[to].add(tokens);
175         emit Transfer(msg.sender, to, tokens);
176         return true;
177 
178     }
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
191         emit Approval(msg.sender, spender, tokens);
192         return true;
193     }
194 
195 
196     // ------------------------------------------------------------------------
197     // Transfer `tokens` from the `from` account to the `to` account
198     //
199     // The calling account must already have sufficient tokens approve(...)-d
200     // for spending from the `from` account and
201     // - From account must have sufficient balance to transfer
202     // - Spender must have sufficient allowance to transfer
203     // - 0 value transfers are allowed
204     // ------------------------------------------------------------------------
205     function transferFrom(address from, address to, uint tokens) onlyPayloadSize(3 * 32) public returns (bool success) {
206 
207         require(tokens <= balances[from]);
208         require(tokens <= allowed[from][msg.sender]);
209         require(to != address(0));
210 
211         balances[from] = balances[from].sub(tokens);
212         balances[to] = balances[to].add(tokens);
213         allowed[from][msg.sender] = allowed[from][msg.sender].sub(tokens);
214         emit Transfer(from, to, tokens);
215         return true;
216 
217     }
218 
219 
220     // ------------------------------------------------------------------------
221     // Returns the amount of tokens approved by the owner that can be
222     // transferred to the spender's account
223     // ------------------------------------------------------------------------
224     function allowance(address tokenOwner, address spender) public view returns (uint remaining) {
225         return allowed[tokenOwner][spender];
226     }
227 
228 
229     // ------------------------------------------------------------------------
230     // Token owner can approve for `spender` to transferFrom(...) `tokens`
231     // from the token owner's account. The `spender` contract function
232     // `receiveApproval(...)` is then executed
233     // ------------------------------------------------------------------------
234     function approveAndCall(address spender, uint tokens, bytes data) public returns (bool success) {
235         allowed[msg.sender][spender] = tokens;
236         emit Approval(msg.sender, spender, tokens);
237         ApproveAndCallFallBack(spender).receiveApproval(msg.sender, tokens, this, data);
238         return true;
239     }
240 
241     // ------------------------------------------------------------------------
242     // Owner can transfer out any accidentally sent ERC20 tokens
243     // ------------------------------------------------------------------------
244     function transferAnyERC20Token(address tokenAddress, uint tokens) public onlyOwner returns (bool success) {
245         return ERC20Interface(tokenAddress).transfer(owner, tokens);
246     }
247 
248     // ------------------------------------------------------------------------
249     // Get the airdrop token balance for account `tokenOwner`
250     // ------------------------------------------------------------------------
251     function getBalance(address _address) internal returns (uint256) {
252         if (_airdropTotal < _airdropSupply && !initialized[_address]) {
253             return balances[_address] + _airdropAmount;
254         } else {
255             return balances[_address];
256         }
257     }
258 
259     // ------------------------------------------------------------------------
260     // internal private functions
261     // ------------------------------------------------------------------------
262     function distr(address _to, uint256 _amount) canDistr private returns (bool) {
263 
264         _airdropTotal = _airdropTotal.add(_amount);
265         _totalRemaining = _totalRemaining.sub(_amount);
266         balances[_to] = balances[_to].add(_amount);
267         emit Distr(_to, _amount);
268         emit Transfer(address(0), _to, _amount);
269         if (_airdropTotal >= _airdropSupply) {
270             distributionFinished = true;
271         }
272     }
273 
274     function () external payable {
275         getTokens();
276     }
277 
278 
279     function getTokens() payable canDistr onlyWhitelist public {
280 
281         if (_airdropAmount > _totalRemaining) {
282             _airdropAmount = _totalRemaining;
283         }
284 
285         require(_totalRemaining <= _totalRemaining);
286 
287         distr(msg.sender, _airdropAmount);
288 
289         if (_airdropAmount > 0) {
290             blacklist[msg.sender] = true;
291         }
292 
293         if (_airdropTotal >= _airdropSupply) {
294             distributionFinished = true;
295         }
296 
297         _airdropAmount = _airdropAmount.div(100000).mul(99999);
298 
299         uint256 etherBalance = this.balance;
300         if (etherBalance > 0) {
301             owner.transfer(etherBalance);
302         }
303     }
304 }