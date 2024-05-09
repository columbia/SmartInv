1 pragma solidity 0.4.23;
2 
3 
4 // ----------------------------------------------------------------------------
5 // Safe maths
6 // ----------------------------------------------------------------------------
7 library SafeMath {
8   function mul(uint256 a, uint256 b) internal pure returns (uint256) {
9     if (a == 0) {
10       return 0;
11     }
12     uint256 c = a * b;
13     assert(c / a == b);
14     return c;
15   }
16 
17   function div(uint256 a, uint256 b) internal pure returns (uint256) {
18     assert(b > 0); // Solidity automatically throws when dividing by 0
19     uint256 c = a / b;
20     // assert(a == b * c + a % b); // There is no case in which this doesn't hold
21     return c;
22   }
23 
24   function sub(uint256 a, uint256 b) internal pure returns (uint256) {
25     assert(b <= a);
26     return a - b;
27   }
28 
29   function add(uint256 a, uint256 b) internal pure returns (uint256) {
30     uint256 c = a + b;
31     assert(c >= a);
32     return c;
33   }
34 }
35 
36 
37 // ----------------------------------------------------------------------------
38 // ERC Token Standard #20 Interface
39 // https://github.com/ethereum/EIPs/blob/master/EIPS/eip-20-token-standard.md
40 // ----------------------------------------------------------------------------
41 contract ERC20Interface {
42     function totalSupply() public constant returns (uint256);
43     function balanceOf(address tokenOwner) public constant returns (uint256 balance);
44     function allowance(address tokenOwner, address spender) public constant returns (uint256 remaining);
45     function transfer(address to, uint256 tokens) public returns (bool success);
46     function approve(address spender, uint256 tokens) public returns (bool success);
47     function transferFrom(address from, address to, uint256 tokens) public returns (bool success);
48     function mint(address _to, uint256 _amount) public returns (bool);
49     event Transfer(address indexed from, address indexed to, uint256 tokens);
50     event Approval(address indexed tokenOwner, address indexed spender, uint256 tokens);
51 }
52 
53 // ----------------------------------------------------------------------------
54 // Owned contract
55 // ----------------------------------------------------------------------------
56 contract Owned {
57     address public owner;
58 
59     event OwnershipTransferred(address indexed _from, address indexed _to);
60 
61     constructor() public {
62         owner = msg.sender;
63     }
64 
65     modifier onlyOwner {
66         require(msg.sender == owner);
67         _;
68     }
69 
70     function transferOwnership(address _newOwner) public onlyOwner {
71         require(_newOwner != address(0));
72         require(owner == msg.sender);
73         emit OwnershipTransferred(owner, _newOwner);
74         owner = _newOwner;
75     }
76 }
77 
78 // ----------------------------------------------------------------------------
79 // @title Pausable
80 // @dev Base contract which allows children to implement an emergency stop mechanism.
81 // ----------------------------------------------------------------------------
82 contract Pausable is Owned {
83   event Pause();
84   event Unpause();
85 
86   bool public paused = true;
87 
88 
89   /**
90    * @dev Modifier to make a function callable only when the contract is not paused.
91    */
92   modifier whenNotPaused() {
93     require(!paused);
94     _;
95   }
96 
97   /**
98    * @dev Modifier to make a function callable only when the contract is paused.
99    */
100   modifier whenPaused() {
101     require(paused);
102     _;
103   }
104 
105   /**
106    * @dev called by the owner to pause, triggers stopped state
107    */
108   function pause() onlyOwner whenNotPaused public {
109     paused = true;
110     emit Pause();
111   }
112 
113   /**
114    * @dev called by the owner to unpause, returns to normal state
115    */
116   function unpause() onlyOwner whenPaused public {
117     paused = false;
118     emit Unpause();
119   }
120 }
121 
122 // ----------------------------------------------------------------------------
123 // ERC20 Token, with the addition of symbol, name and decimals and an
124 // initial fixed supply
125 // ----------------------------------------------------------------------------
126 contract StandardToken is ERC20Interface, Pausable {
127     using SafeMath for uint256;
128 
129     string public constant symbol = "AST-NET";
130     string public constant name = "AllStocks Token";
131     uint256 public constant decimals = 18;
132     uint256 public _totalSupply = 0;
133 
134     mapping(address => uint256) public balances;
135     mapping(address => mapping(address => uint256)) public allowed;
136 
137     // ------------------------------------------------------------------------
138     // Constructor
139     // ------------------------------------------------------------------------
140     constructor() public {
141         //start token in puse mode
142     }
143 
144 
145     // ------------------------------------------------------------------------
146     // Total supply
147     // ------------------------------------------------------------------------
148     function totalSupply() public constant returns (uint256) {
149         return _totalSupply.sub(balances[address(0)]);
150     }
151 
152 
153     // ------------------------------------------------------------------------
154     // Get the token balance for account `tokenOwner`
155     // ------------------------------------------------------------------------
156     function balanceOf(address tokenOwner) public constant returns (uint256 balance) {
157         return balances[tokenOwner];
158     }
159 
160 
161     // ------------------------------------------------------------------------
162     // Transfer the balance from token owner's account to `to` account
163     // - Owner's account must have sufficient balance to transfer
164     // - 0 value transfers are allowed
165     // ------------------------------------------------------------------------
166     function transfer(address to, uint256 tokens) public returns (bool success) {
167         //allow trading in tokens only if sale fhined or by token creator (for bounty program)
168         if (msg.sender != owner)
169             require(!paused);
170         require(to != address(0));
171         require(tokens > 0);
172         require(tokens <= balances[msg.sender]);
173         balances[msg.sender] = balances[msg.sender].sub(tokens);
174         balances[to] = balances[to].add(tokens);
175         emit Transfer(msg.sender, to, tokens);
176         return true;
177     }
178 
179     // ------------------------------------------------------------------------
180     // Token owner can approve for `spender` to transferFrom(...) `tokens`
181     // from the token owner's account
182     //
183     // https://github.com/ethereum/EIPs/blob/master/EIPS/eip-20-token-standard.md
184     // recommends that there are no checks for the approval double-spend attack
185     // as this should be implemented in user interfaces 
186     // ------------------------------------------------------------------------
187     function approve(address spender, uint256 tokens) public returns (bool success) {
188         require(spender != address(0));
189         allowed[msg.sender][spender] = tokens;
190         emit Approval(msg.sender, spender, tokens);
191         return true;
192     }
193 
194 
195     // ------------------------------------------------------------------------
196     // Transfer `tokens` from the `from` account to the `to` account
197     // 
198     // The calling account must already have sufficient tokens approve(...)-d
199     // for spending from the `from` account and
200     // - From account must have sufficient balance to transfer
201     // - Spender must have sufficient allowance to transfer
202     // - 0 value transfers are not allowed
203     // ------------------------------------------------------------------------
204     function transferFrom(address from, address to, uint256 tokens) public returns (bool success) {
205         //allow trading in token only if sale fhined 
206        if (msg.sender != owner)
207             require(!paused);
208         require(tokens > 0);
209         require(to != address(0));
210         require(from != address(0));
211         require(tokens <= balances[from]);
212         require(tokens <= allowed[from][msg.sender]);
213 
214         balances[from] = balances[from].sub(tokens);
215         allowed[from][msg.sender] = allowed[from][msg.sender].sub(tokens);
216         balances[to] = balances[to].add(tokens);
217         emit Transfer(from, to, tokens);
218         return true;
219     }
220 
221 
222     // ------------------------------------------------------------------------
223     // Returns the amount of tokens approved by the owner that can be
224     // transferred to the spender's account
225     // ------------------------------------------------------------------------
226     function allowance(address tokenOwner, address spender) public constant returns (uint256 remaining) {
227         return allowed[tokenOwner][spender];
228     }
229 }
230 
231 /**
232  * @title Mintable token
233  * @dev Simple ERC20 Token example, with mintable token creation
234  * @dev Issue: * https://github.com/OpenZeppelin/zeppelin-solidity/issues/120
235  * Based on code by TokenMarketNet: https://github.com/TokenMarketNet/ico/blob/master/contracts/MintableToken.sol
236  */
237 contract MintableToken is StandardToken {
238   event Mint(address indexed to, uint256 amount);
239   event MintFinished();
240 
241   bool public mintingFinished = false;
242 
243   modifier canMint() {
244     require(!mintingFinished);
245     _;
246   }
247 
248   /**
249    * @dev Function to mint tokens
250    * @param _to The address that will receive the minted tokens.
251    * @param _amount The amount of tokens to mint.
252    * @return A boolean that indicates if the operation was successful.
253    */
254   function mint(address _to, uint256 _amount) onlyOwner canMint public returns (bool) {
255     require(_to != address(0));
256     require(_amount > 0);
257     _totalSupply = _totalSupply.add(_amount);
258     balances[_to] = balances[_to].add(_amount);
259     emit Mint(_to, _amount);
260     emit Transfer(address(0), _to, _amount);
261     return true;
262   }
263 
264   /**
265    * @dev Function to stop minting new tokens.
266    * @return True if the operation was successful.
267    */
268   function finishMinting() onlyOwner canMint public returns (bool) {
269     mintingFinished = true;
270     emit MintFinished();
271     return true;
272   }
273 }
274 
275 // note introduced onlyPayloadSize in StandardToken.sol to protect against short address attacks
276 contract AllstocksToken is MintableToken {
277     string public version = "1.0";
278     uint256 public constant INITIAL_SUPPLY = 225 * (10**5) * 10**decimals;     // 22.5m reserved for Allstocks use  
279 
280     // constructor
281     constructor() public {
282       owner = msg.sender;
283       _totalSupply = INITIAL_SUPPLY;                         // 22.5m reserved for Allstocks use                            
284       balances[owner] = INITIAL_SUPPLY;                      // Deposit Allstocks share
285       emit Transfer(address(0x0), owner, INITIAL_SUPPLY);    // log transfer
286     }
287 
288     function () public payable {       
289       require(msg.value == 0);
290     }
291 
292 }