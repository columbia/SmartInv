1 pragma solidity ^0.4.24;
2 
3 // ----------------------------------------------------------------------------
4 // Ownership functionality for authorization controls and user permissions
5 // ----------------------------------------------------------------------------
6 contract Owned {
7     address public owner;
8     address public newOwner;
9 
10     event OwnershipTransferred(address indexed _from, address indexed _to);
11 
12     constructor() public {
13         owner = msg.sender;
14     }
15 
16     modifier onlyOwner {
17         require(msg.sender == owner);
18         _;
19     }
20 
21     function transferOwnership(address _newOwner) public onlyOwner {
22         newOwner = _newOwner;
23     }
24     function acceptOwnership() public {
25         require(msg.sender == newOwner);
26         emit OwnershipTransferred(owner, newOwner);
27         owner = newOwner;
28         newOwner = address(0);
29     }
30 }
31 
32 
33 // ----------------------------------------------------------------------------
34 // Pause functionality
35 // ----------------------------------------------------------------------------
36 contract Pausable is Owned {
37   event Pause();
38   event Unpause();
39 
40   bool public paused = false;
41 
42 
43   // Modifier to make a function callable only when the contract is not paused.
44   modifier whenNotPaused() {
45     require(!paused);
46     _;
47   }
48 
49   // Modifier to make a function callable only when the contract is paused.
50   modifier whenPaused() {
51     require(paused);
52     _;
53   }
54 
55   // Called by the owner to pause, triggers stopped state
56   function pause() onlyOwner whenNotPaused public {
57     paused = true;
58     emit Pause();
59   }
60 
61   // Called by the owner to unpause, returns to normal state
62   function unpause() onlyOwner whenPaused public {
63     paused = false;
64     emit Unpause();
65   }
66 }
67 
68 // ----------------------------------------------------------------------------
69 // Safe maths
70 // ----------------------------------------------------------------------------
71 contract SafeMath {
72     function safeAdd(uint a, uint b) public pure returns (uint c) {
73         c = a + b;
74         require(c >= a);
75     }
76     function safeSub(uint a, uint b) public pure returns (uint c) {
77         require(b <= a);
78         c = a - b;
79     }
80     function safeMul(uint a, uint b) public pure returns (uint c) {
81         c = a * b;
82         require(a == 0 || c / a == b);
83     }
84     function safeDiv(uint a, uint b) public pure returns (uint c) {
85         require(b > 0);
86         c = a / b;
87     }
88 }
89 
90 
91 // ----------------------------------------------------------------------------
92 // ERC20 Standard Interface
93 // ----------------------------------------------------------------------------
94 contract ERC20 {
95     function totalSupply() public constant returns (uint);
96     function balanceOf(address tokenOwner) public constant returns (uint balance);
97     function allowance(address tokenOwner, address spender) public constant returns (uint remaining);
98     function transfer(address to, uint tokens) public returns (bool success);
99     function approve(address spender, uint tokens) public returns (bool success);
100     function transferFrom(address from, address to, uint tokens) public returns (bool success);
101 
102     event Transfer(address indexed from, address indexed to, uint tokens);
103     event Approval(address indexed tokenOwner, address indexed spender, uint tokens);
104 }
105 
106 
107 // ----------------------------------------------------------------------------
108 // 'GOLF' 'Golfcoin' token contract
109 // Symbol      : GOLF
110 // Name        : Golfcoin
111 // Total supply: 100,000,000,000
112 // Decimals    : 18
113 // ----------------------------------------------------------------------------
114 
115 
116 // ----------------------------------------------------------------------------
117 // ERC20 Token. Specifies symbol, name, decimals, and total supply
118 // ----------------------------------------------------------------------------
119 contract Golfcoin is Pausable, SafeMath, ERC20 {
120 	string public symbol;
121     string public  name;
122     uint8 public decimals;
123     uint public _totalSupply;
124 
125 
126 
127     mapping(address => uint) public balances;
128     mapping(address => mapping(address => uint)) internal allowed;
129 
130     event Burned(address indexed burner, uint256 value);
131     event Mint(address indexed to, uint256 amount);
132 
133 
134     // ------------------------------------------------------------------------
135     // Constructor
136     // ------------------------------------------------------------------------
137     constructor() public {
138         symbol = "GOLF";
139         name = "Golfcoin";
140         decimals = 18;
141         _totalSupply = 100000000000 * 10**uint(decimals);
142         balances[owner] = _totalSupply;
143         emit Transfer(address(0), owner, _totalSupply);
144     }
145 
146     // ------------------------------------------------------------------------
147     // Total supply
148     // ------------------------------------------------------------------------
149     function totalSupply() public constant returns (uint) {
150         return _totalSupply;
151     }
152 
153     // ------------------------------------------------------------------------
154     // Get the token balance for account `tokenOwner`
155     // ------------------------------------------------------------------------
156     function balanceOf(address tokenOwner) public constant returns (uint balance) {
157         return balances[tokenOwner];
158     }
159 
160     // ------------------------------------------------------------------------
161     // Transfer the balance from token owner's account to `to` account
162     // - Owner's account must have sufficient balance to transfer
163     // - 0 value transfers are allowed
164     // ------------------------------------------------------------------------
165     function transfer(address to, uint tokens) public whenNotPaused returns (bool success) {
166         require(to != address(this)); //make sure we're not transfering to this contract
167 
168         //check edge cases
169         if (balances[msg.sender] >= tokens
170             && tokens > 0) {
171 
172                 //update balances
173                 balances[msg.sender] = safeSub(balances[msg.sender], tokens);
174                 balances[to] = safeAdd(balances[to], tokens);
175 
176                 //log event
177                 emit Transfer(msg.sender, to, tokens);
178                 return true;
179         }
180         else {
181             return false;
182         }
183     }
184 
185     // ------------------------------------------------------------------------
186     // Token owner can approve for `spender` to transferFrom(...) `tokens`
187     // from the token owner's account
188     // ------------------------------------------------------------------------
189     function approve(address spender, uint tokens) public whenNotPaused returns (bool success) {
190         allowed[msg.sender][spender] = tokens;
191         emit Approval(msg.sender, spender, tokens);
192         return true;
193     }
194 
195     // ------------------------------------------------------------------------
196     // Transfer `tokens` from the `from` account to the `to` account
197     //
198     // The calling account must already have sufficient tokens approve(...)-d
199     // for spending from the `from` account and
200     // - From account must have sufficient balance to transfer
201     // - Spender must have sufficient allowance to transfer
202     // ------------------------------------------------------------------------
203     function transferFrom(address from, address to, uint tokens) public whenNotPaused returns (bool success) {
204         require(to != address(this));
205 
206         //check edge cases
207         if (allowed[from][msg.sender] >= tokens
208             && balances[from] >= tokens
209             && tokens > 0) {
210 
211             //update balances and allowances
212             balances[from] = safeSub(balances[from], tokens);
213             allowed[from][msg.sender] = safeSub(allowed[from][msg.sender], tokens);
214             balances[to] = safeAdd(balances[to], tokens);
215 
216             //log event
217             emit Transfer(from, to, tokens);
218             return true;
219         }
220         else {
221             return false;
222         }
223     }
224 
225     // ------------------------------------------------------------------------
226     // Returns the amount of tokens approved by the owner that can be
227     // transferred to the spender's account
228     // ------------------------------------------------------------------------
229     function allowance(address tokenOwner, address spender) public constant returns (uint remaining) {
230         return allowed[tokenOwner][spender];
231     }
232 
233 
234     // ------------------------------------------------------------------------
235     // Burns a specific number of tokens
236     // ------------------------------------------------------------------------
237     function burn(uint256 _value) public onlyOwner {
238         require(_value > 0);
239 
240         address burner = msg.sender;
241         balances[burner] = safeSub(balances[burner], _value);
242         _totalSupply = safeSub(_totalSupply, _value);
243         emit Burned(burner, _value);
244     }
245 
246 
247     // ------------------------------------------------------------------------
248     // Mints a specific number of tokens to a wallet address
249     // ------------------------------------------------------------------------
250     function mint(address _to, uint256 _amount) public onlyOwner returns (bool) {
251     	_totalSupply = safeAdd(_totalSupply, _amount);
252     	balances[_to] = safeAdd(balances[_to], _amount);
253     	
254     	emit Mint(_to, _amount);
255     	emit Transfer(address(0), _to, _amount);
256     	
257     	return true;
258     }
259 
260 
261     // ------------------------------------------------------------------------
262     // Doesn't Accept Eth
263     // ------------------------------------------------------------------------
264     function () public payable {
265         revert();
266     }
267 }