1 pragma solidity 0.4.24;
2 
3 
4 library SafeMath {
5 
6   /**
7   * @dev Multiplies two numbers, throws on overflow.
8   */
9   function mul(uint256 a, uint256 b) internal pure returns (uint256 c) {
10     if (a == 0) {
11       return 0;
12     }
13     c = a * b;
14     assert(c / a == b);
15     return c;
16   }
17 
18   /**
19   * @dev Integer division of two numbers, truncating the quotient.
20   */
21   function div(uint256 a, uint256 b) internal pure returns (uint256) {
22     // assert(b > 0); // Solidity automatically throws when dividing by 0
23     // uint256 c = a / b;
24     // assert(a == b * c + a % b); // There is no case in which this doesn't hold
25     return a / b;
26   }
27 
28   /**
29   * @dev Subtracts two numbers, throws on overflow (i.e. if subtrahend is greater than minuend).
30   */
31   function sub(uint256 a, uint256 b) internal pure returns (uint256) {
32     assert(b <= a);
33     return a - b;
34   }
35 
36   /**
37   * @dev Adds two numbers, throws on overflow.
38   */
39   function add(uint256 a, uint256 b) internal pure returns (uint256 c) {
40     c = a + b;
41     assert(c >= a);
42     return c;
43   }
44 }
45 
46 contract Ownable {
47     address public owner;
48     address public newOwner;
49 
50     event OwnershipTransferred(address indexed _from, address indexed _to);
51 
52     function Ownable() public {
53         owner = msg.sender;
54     }
55 
56     modifier onlyOwner {
57         require(msg.sender == owner);
58         _;
59     }
60 
61     function transferOwnership(address _newOwner) public onlyOwner {
62         newOwner = _newOwner;
63     }
64     function acceptOwnership() public {
65         require(msg.sender == newOwner);
66         emit OwnershipTransferred(owner, newOwner);
67         owner = newOwner;
68         newOwner = address(0);
69     }
70 }
71 
72 contract Pausable is Ownable {
73     event Pause();
74     event Unpause();
75 
76     bool public paused = false;
77 
78 
79     /**
80      * @dev modifier to allow actions only when the contract IS paused
81      */
82     modifier whenNotPaused() {
83         require(!paused);
84         _;
85     }
86 
87     /**
88      * @dev modifier to allow actions only when the contract IS NOT paused
89      */
90     modifier whenPaused {
91         require(paused);
92         _;
93     }
94 
95     /**
96      * @dev called by the owner to pause, triggers stopped state
97      */
98     function pause() onlyOwner whenNotPaused public returns (bool) {
99         paused = true;
100         emit Pause();
101         return true;
102     }
103 
104     /**
105      * @dev called by the owner to unpause, returns to normal state
106      */
107     function unpause() onlyOwner whenPaused public returns (bool) {
108         paused = false;
109         emit Unpause();
110         return true;
111     }
112 }
113 
114 // ----------------------------------------------------------------------------
115 // ERC Token Standard #20 Interface
116 // https://github.com/ethereum/EIPs/blob/master/EIPS/eip-20-token-standard.md
117 // ----------------------------------------------------------------------------
118 contract ERC20Interface {
119     function totalSupply() public constant returns (uint);
120     function balanceOf(address tokenOwner) public constant returns (uint balance);
121     function allowance(address tokenOwner, address spender) public constant returns (uint remaining);
122     function transfer(address to, uint tokens) public returns (bool success);
123     function approve(address spender, uint tokens) public returns (bool success);
124     function transferFrom(address from, address to, uint tokens) public returns (bool success);
125 
126     event Transfer(address indexed from, address indexed to, uint tokens);
127     event Approval(address indexed tokenOwner, address indexed spender, uint tokens);
128 }
129 
130 
131 // ----------------------------------------------------------------------------
132 // Contract function to receive approval and execute function in one call
133 //
134 // Borrowed from MiniMeToken
135 // ----------------------------------------------------------------------------
136 contract ApproveAndCallFallBack {
137     function receiveApproval(address from, uint256 tokens, address token, bytes data) public;
138 }
139 
140 
141 // ----------------------------------------------------------------------------
142 // ERC20 Token, with the addition of symbol, name and decimals and an
143 // initial fixed supply
144 // ----------------------------------------------------------------------------
145 contract NWT is ERC20Interface, Pausable {
146     using SafeMath for uint;
147 
148     string public symbol;
149     string public  name;
150     uint8 public decimals;
151     uint public _totalSupply;
152 
153     mapping(address => uint) balances;
154     mapping(address => mapping(address => uint)) allowed;
155 
156 
157     // ------------------------------------------------------------------------
158     // Constructor
159     // ------------------------------------------------------------------------
160     function NWT() public {
161         symbol = "NWT";
162         name = "Neoworld Token";
163         decimals = 4;
164         _totalSupply = 1000000 * 10**uint(decimals);
165         balances[owner] = _totalSupply;
166         emit Transfer(address(0), owner, _totalSupply);
167     }
168 
169 
170     // ------------------------------------------------------------------------
171     // Total supply
172     // ------------------------------------------------------------------------
173     function totalSupply() public constant returns (uint) {
174         return _totalSupply  - balances[address(0)];
175     }
176 
177     // ------------------------------------------------------------------------
178     // Get the token balance for account `tokenOwner`
179     // ------------------------------------------------------------------------
180     function balanceOf(address tokenOwner) public constant returns (uint balance) {
181         return balances[tokenOwner];
182     }
183 
184 
185     // ------------------------------------------------------------------------
186     // Transfer the balance from token owner's account to `to` account
187     // - Owner's account must have sufficient balance to transfer
188     // - 0 value transfers are allowed
189     // ------------------------------------------------------------------------
190     function transfer(address to, uint tokens) public whenNotPaused returns (bool success) {
191         require(canSend(to), "the receiver is not qualified investor");
192         balances[msg.sender] = balances[msg.sender].sub(tokens);
193         balances[to] = balances[to].add(tokens);
194         emit Transfer(msg.sender, to, tokens);
195         return true;
196     }
197 
198 
199     // ------------------------------------------------------------------------
200     // Token owner can approve for `spender` to transferFrom(...) `tokens`
201     // from the token owner's account
202     //
203     // https://github.com/ethereum/EIPs/blob/master/EIPS/eip-20-token-standard.md
204     // recommends that there are no checks for the approval double-spend attack
205     // as this should be implemented in user interfaces 
206     // ------------------------------------------------------------------------
207     function approve(address spender, uint tokens) public whenNotPaused returns (bool success) {
208         allowed[msg.sender][spender] = tokens;
209         emit Approval(msg.sender, spender, tokens);
210         return true;
211     }
212 
213     function increaseApproval (address _spender, uint _addedValue) public whenNotPaused
214         returns (bool success) {
215         allowed[msg.sender][_spender] = allowed[msg.sender][_spender].add(_addedValue);
216         emit Approval(msg.sender, _spender, allowed[msg.sender][_spender]);
217         return true;
218     }
219 
220     function decreaseApproval (address _spender, uint _subtractedValue) public whenNotPaused
221         returns (bool success) {
222         uint oldValue = allowed[msg.sender][_spender];
223         if (_subtractedValue > oldValue) {
224           allowed[msg.sender][_spender] = 0;
225         } else {
226           allowed[msg.sender][_spender] = oldValue.sub(_subtractedValue);
227         }
228         emit Approval(msg.sender, _spender, allowed[msg.sender][_spender]);
229         return true;
230     }
231 
232     // ------------------------------------------------------------------------
233     // Transfer `tokens` from the `from` account to the `to` account
234     // 
235     // The calling account must already have sufficient tokens approve(...)-d
236     // for spending from the `from` account and
237     // - From account must have sufficient balance to transfer
238     // - Spender must have sufficient allowance to transfer
239     // - 0 value transfers are allowed
240     // ------------------------------------------------------------------------
241     function transferFrom(address from, address to, uint tokens) public whenNotPaused returns (bool success) {
242         require(canSend(to), "the receiver is not qualified investor");
243         balances[from] = balances[from].sub(tokens);
244         allowed[from][msg.sender] = allowed[from][msg.sender].sub(tokens);
245         balances[to] = balances[to].add(tokens);
246         emit Transfer(from, to, tokens);
247         return true;
248     }
249 
250 
251     // ------------------------------------------------------------------------
252     // Returns the amount of tokens approved by the owner that can be
253     // transferred to the spender's account
254     // ------------------------------------------------------------------------
255     function allowance(address tokenOwner, address spender) public constant returns (uint remaining) {
256         return allowed[tokenOwner][spender];
257     }
258 
259 
260     // ------------------------------------------------------------------------
261     // Token owner can approve for `spender` to transferFrom(...) `tokens`
262     // from the token owner's account. The `spender` contract function
263     // `receiveApproval(...)` is then executed
264     // ------------------------------------------------------------------------
265     function approveAndCall(address spender, uint tokens, bytes data) public whenNotPaused returns (bool success) {
266         allowed[msg.sender][spender] = tokens;
267         emit Approval(msg.sender, spender, tokens);
268         ApproveAndCallFallBack(spender).receiveApproval(msg.sender, tokens, this, data);
269         return true;
270     }
271 
272 
273     // ------------------------------------------------------------------------
274     // Don't accept ETH
275     // ------------------------------------------------------------------------
276     function () public payable {
277         revert();
278     }
279 
280 
281     // ------------------------------------------------------------------------
282     // Owner can transfer out any accidentally sent ERC20 tokens
283     // ------------------------------------------------------------------------
284     function transferAnyERC20Token(address tokenAddress, uint tokens) public onlyOwner returns (bool success) {
285         return ERC20Interface(tokenAddress).transfer(owner, tokens);
286     }
287 
288 
289     mapping(address => bool) qualifiedInvestor;
290 
291     event QualifiedInvestorStatusChange(address indexed investor, bool isQualified);
292 
293     function canSend(address receiver) public view returns (bool success) {
294         return qualifiedInvestor[receiver];
295     }
296 
297     function setQualifiedInvestor(address target, bool isQualified) public onlyOwner {
298         qualifiedInvestor[target] = isQualified;
299         emit QualifiedInvestorStatusChange(target, isQualified);
300     }
301 }