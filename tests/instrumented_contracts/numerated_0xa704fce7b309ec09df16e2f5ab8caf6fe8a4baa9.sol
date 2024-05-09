1 pragma solidity ^0.4.24;
2 
3 // ----------------------------------------------------------------------------
4 // 'AGRI' - AgriChain Utility Token Contract
5 //
6 // Symbol           : AGRI
7 // Name             : AgriChain Utility Token
8 // Max Total supply : 1,000,000,000.000000000000000000 (1 billion)
9 // Decimals         : 18
10 //
11 // Company          : AgriChain Pty Ltd (trading as BlockGrain)
12 //                  : https://agrichain.com
13 // Version          : 2.1 
14 // Author           : Martin Halford <cto@agrichain.com>
15 // Published        : 15 Aug 2018
16 //
17 // ----------------------------------------------------------------------------
18 
19 
20 // ----------------------------------------------------------------------------
21 // Safe Maths
22 // ----------------------------------------------------------------------------
23 library SafeMath {
24     
25     function mul(uint256 _a, uint256 _b) internal pure returns (uint256) {
26         if (_a == 0) {
27             return 0;
28         }
29         uint256 c = _a * _b;
30         require(c / _a == _b, "Muliply overflow error.");
31         return c;
32     }
33 
34     function div(uint256 _a, uint256 _b) internal pure returns (uint256) {
35         require(_b > 0, "Divide by zero error."); 
36         uint256 c = _a / _b;
37         return c;
38     }
39 
40     function sub(uint256 _a, uint256 _b) internal pure returns (uint256) {
41         require(_b <= _a, "Subtraction overflow error.");
42         uint256 c = _a - _b;
43         return c;
44     }
45 
46     function add(uint256 _a, uint256 _b) internal pure returns (uint256) {
47         uint256 c = _a + _b;
48         require(c >= _a, "Addition overflow error.");
49         return c;
50     }
51 
52     function mod(uint256 a, uint256 b) internal pure returns (uint256) {
53         require(b != 0, "Mod overflow error");
54         return a % b;
55     }
56 }
57 
58 
59 // ----------------------------------------------------------------------------
60 // ERC Token Standard #20 Interface
61 // ----------------------------------------------------------------------------
62 contract ERC20Interface {
63 
64     function totalSupply() public view returns (uint);
65     function balanceOf(address tokenOwner) public view returns (uint balance);
66     function allowance(address tokenOwner, address spender) public view returns (uint remaining);
67     function transfer(address to, uint tokens) public returns (bool success);
68     function approve(address spender, uint tokens) public returns (bool success);
69     function transferFrom(address from, address to, uint tokens) public returns (bool success);
70 
71     event Transfer(address indexed from, address indexed to, uint tokens);
72     event Approval(address indexed tokenOwner, address indexed spender, uint tokens);
73 }
74 
75 
76 // ----------------------------------------------------------------------------
77 // Contract function to receive approval and execute function in one call
78 // ----------------------------------------------------------------------------
79 contract ApproveAndCallFallBack {
80     function receiveApproval(address from, uint256 tokens, address token, bytes data) public;
81 }
82 
83 
84 // ----------------------------------------------------------------------------
85 // Owned contract
86 // ----------------------------------------------------------------------------
87 contract Owned {
88 
89     address public owner;
90     address public newOwner;
91 
92     event OwnershipTransferred(address indexed _from, address indexed _to);
93 
94     constructor() public {
95         owner = msg.sender;
96     }
97 
98     modifier onlyOwner {
99         require(msg.sender == owner, "Not contract owner.");
100         _;
101     }
102 
103     function transferOwnership(address _newOwner) public onlyOwner {
104         newOwner = _newOwner;
105     }
106     function acceptOwnership() public {
107         require(msg.sender == newOwner, "Not new contract owner.");
108         emit OwnershipTransferred(owner, newOwner);
109         owner = newOwner;
110         newOwner = address(0);
111     }
112 }
113 
114 
115 // ----------------------------------------------------------------------------
116 // Agri Token
117 // ----------------------------------------------------------------------------
118 contract AgriChainToken is ERC20Interface, Owned {
119     
120     using SafeMath for uint;
121 
122     uint256 constant public MAX_SUPPLY = 1000000000000000000000000000; // 1 billion Agri 
123 
124     string public symbol;
125     string public  name;
126     uint8 public decimals;
127     uint256 _totalSupply;
128 
129     mapping(address => uint) balances;
130     mapping(address => mapping(address => uint)) allowed;
131 
132     // Flag to allow or disallow transfers
133     bool public isAllowingTransfers;
134 
135     // List of admins who can mint, burn and allow transfers of tokens
136     mapping (address => bool) public administrators;
137 
138     // modifier to check if transfers being allowed
139     modifier allowingTransfers() {
140         require(isAllowingTransfers, "Contract currently not allowing transfers.");
141         _;
142     }
143 
144     // modifier to check admin status
145     modifier onlyAdmin() {
146         require(administrators[msg.sender], "Not contract administrator.");
147         _;
148     }
149 
150     // This notifies clients about the amount burnt, only admins can burn tokens
151     event Burn(address indexed burner, uint256 value); 
152 
153     // This notifies clients about the transfers being allowed or disallowed
154     event AllowTransfers ();
155     event DisallowTransfers ();
156 
157     // ------------------------------------------------------------------------
158     // Constructor
159     // ------------------------------------------------------------------------
160     constructor(uint initialTokenSupply) public {
161         symbol = "AGRI";
162         name = "AgriChain Utility Token";
163         decimals = 18;
164         _totalSupply = initialTokenSupply * 10**uint(decimals);
165 
166         balances[owner] = _totalSupply;
167         emit Transfer(address(0), owner, _totalSupply);
168     }
169 
170     // ------------------------------------------------------------------------
171     // Total supply
172     // ------------------------------------------------------------------------
173     function totalSupply() public view returns (uint) {
174         return _totalSupply.sub(balances[address(0)]);
175     }
176 
177     // ------------------------------------------------------------------------
178     // Get the token balance for account `tokenOwner`
179     // ------------------------------------------------------------------------
180     function balanceOf(address tokenOwner) public view returns (uint balance) {
181         return balances[tokenOwner];
182     }
183 
184     // ------------------------------------------------------------------------
185     // Transfer the balance from token owner's account to `to` account
186     // - Owner's account must have sufficient balance to transfer
187     // - 0 value transfers are allowed
188     // ------------------------------------------------------------------------
189     function transfer(address to, uint tokens) public allowingTransfers returns (bool success) {
190         balances[msg.sender] = balances[msg.sender].sub(tokens);
191         balances[to] = balances[to].add(tokens);
192         emit Transfer(msg.sender, to, tokens);
193         return true;
194     }
195 
196     // ------------------------------------------------------------------------
197     // Token owner can approve for `spender` to transferFrom(...) `tokens`
198     // from the token owner's account
199     // ------------------------------------------------------------------------
200     function approve(address spender, uint tokens) public returns (bool success) {
201         allowed[msg.sender][spender] = tokens;
202         emit Approval(msg.sender, spender, tokens);
203         return true;
204     }
205 
206     // ------------------------------------------------------------------------
207     // Transfer `tokens` from the `from` account to the `to` account
208     // 
209     // The calling account must already have sufficient tokens approve(...)-d
210     // for spending from the `from` account and
211     // - From account must have sufficient balance to transfer
212     // - Spender must have sufficient allowance to transfer
213     // - 0 value transfers are allowed
214     // ------------------------------------------------------------------------
215     function transferFrom(address from, address to, uint tokens) public allowingTransfers returns (bool success) {
216         balances[from] = balances[from].sub(tokens);
217         allowed[from][msg.sender] = allowed[from][msg.sender].sub(tokens);
218         balances[to] = balances[to].add(tokens);
219         emit Transfer(from, to, tokens);
220         return true;
221     }
222 
223     // ------------------------------------------------------------------------
224     // Returns the amount of tokens approved by the owner that can be
225     // transferred to the spender's account
226     // ------------------------------------------------------------------------
227     function allowance(address tokenOwner, address spender) public view returns (uint remaining) {
228         return allowed[tokenOwner][spender];
229     }
230 
231     // ------------------------------------------------------------------------
232     // Token owner can approve for `spender` to transferFrom(...) `tokens`
233     // from the token owner's account. The `spender` contract function
234     // `receiveApproval(...)` is then executed
235     // ------------------------------------------------------------------------
236     function approveAndCall(address spender, uint tokens, bytes data) public returns (bool success) {
237         allowed[msg.sender][spender] = tokens;
238         emit Approval(msg.sender, spender, tokens);
239         ApproveAndCallFallBack(spender).receiveApproval(msg.sender, tokens, this, data);
240         return true;
241     }
242 
243     // ------------------------------------------------------------------------
244     // Don't accept ETH
245     // ------------------------------------------------------------------------
246     function () public payable {
247         revert("Contract does not accept ETH.");
248     }
249 
250     // ------------------------------------------------------------------------
251     // Owner can transfer out any accidentally sent ERC20 tokens
252     // ------------------------------------------------------------------------
253     function transferAnyERC20Token(address tokenAddress, uint tokens) public onlyAdmin returns (bool success) {
254         return ERC20Interface(tokenAddress).transfer(owner, tokens);
255     }
256 
257     // ------------------------------------------------------------------------
258     // Administrator can mint additional tokens 
259     // Do ** NOT ** let totalSupply exceed MAX_SUPPLY
260     // ------------------------------------------------------------------------
261     function mintTokens(uint256 _value) public onlyAdmin {
262         require(_totalSupply.add(_value) <= MAX_SUPPLY, "Cannot mint greater than maximum supply.");
263         balances[msg.sender] = balances[msg.sender].add(_value);
264         _totalSupply = _totalSupply.add(_value);
265         emit Transfer(0, msg.sender, _value);      
266     }    
267 
268     // ------------------------------------------------------------------------
269     // Administrator can burn tokens
270     // ------------------------------------------------------------------------
271     function burn(uint256 _value) public onlyAdmin {
272         require(_value <= balances[msg.sender], "Burn value exceeds balance.");
273         address burner = msg.sender;
274         balances[burner] = balances[burner].sub(_value);
275         _totalSupply = _totalSupply.sub(_value);
276         emit Burn(burner, _value);
277     }
278 
279     // ------------------------------------------------------------------------
280     // Administrator can allow transfer of tokens
281     // ------------------------------------------------------------------------
282     function allowTransfers() public onlyAdmin {
283         isAllowingTransfers = true;
284         emit AllowTransfers();
285     }
286 
287     // ------------------------------------------------------------------------
288     // Administrator can disallow transfer of tokens
289     // ------------------------------------------------------------------------
290     function disallowTransfers() public onlyAdmin {
291         isAllowingTransfers = false;
292         emit DisallowTransfers();
293     }
294 
295     // ------------------------------------------------------------------------
296     // Owner can add administrators of tokens
297     // ------------------------------------------------------------------------
298     function addAdministrator(address _admin) public onlyOwner {
299         administrators[_admin] = true;
300     }
301 
302     // ------------------------------------------------------------------------
303     // Owner can remove administrators of tokens
304     // ------------------------------------------------------------------------
305     function removeAdministrator(address _admin) public onlyOwner {
306         administrators[_admin] = false;
307     }
308 }