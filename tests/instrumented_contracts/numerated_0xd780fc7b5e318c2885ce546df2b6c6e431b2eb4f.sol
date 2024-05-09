1 pragma solidity ^0.4.23;
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
28 // https://github.com/ethereum/EIPs/blob/master/EIPS/eip-20-token-standard.md
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
42 // ----------------------------------------------------------------------------
43 // Owned contract
44 // ----------------------------------------------------------------------------
45 contract Owned {
46     address public owner;
47     address newOwner;
48 
49     event OwnershipTransferred(address indexed _from, address indexed _to);
50 
51     function Owned() public {
52         owner = msg.sender;
53     }
54 
55     modifier onlyOwner {
56         require(msg.sender == owner);
57         _;
58     }
59 
60     function transferOwnership(address _newOwner) public onlyOwner {
61         require(_newOwner != address(0));
62         emit OwnershipTransferred(owner, _newOwner);
63         owner = _newOwner;
64     }
65 }
66 
67 contract Pausable is Owned {
68     event Pause();
69     event Unpause();
70 
71     bool public paused = false;
72 
73 
74     /**
75     * @dev Modifier to make a function callable only when the contract is not paused.
76     */
77     modifier whenNotPaused() {
78         require(!paused);
79         _;
80     }
81 
82     /**
83     * @dev Modifier to make a function callable only when the contract is paused.
84     */
85     modifier whenPaused() {
86         require(paused);
87         _;
88     }
89 
90     /**
91     * @dev called by the owner to pause, triggers stopped state
92     */
93     function pause() onlyOwner whenNotPaused public {
94         paused = true;
95         emit Pause();
96     }
97 
98     /**
99     * @dev called by the owner to unpause, returns to normal state
100     */
101     function unpause() onlyOwner whenPaused public {
102         paused = false;
103         emit Unpause();
104     }
105 }
106 
107 // ----------------------------------------------------------------------------
108 // ERC20 Token, with the addition of symbol, name and decimals and an
109 // initial fixed supply
110 // ----------------------------------------------------------------------------
111 contract NUC is ERC20Interface, Pausable {
112     using SafeMath for uint;
113 
114     string public symbol;
115     string public  name;
116     uint8 public decimals;
117     uint _totalSupply;
118 
119     mapping(address => uint) balances;
120     mapping(address => mapping(address => uint)) allowed;
121 
122 
123     // ------------------------------------------------------------------------
124     // Constructor
125     // ------------------------------------------------------------------------
126     function NUC() public {
127         symbol = "NUC";
128         name = "NUC Token";
129         decimals = 18;
130         _totalSupply = 21 * 1000 * 1000 * 1000 * 10**uint(decimals);
131         balances[owner] = _totalSupply;
132         emit Transfer(address(0), owner, _totalSupply);
133     }
134 
135 
136     // ------------------------------------------------------------------------
137     // Total supply
138     // ------------------------------------------------------------------------
139     function totalSupply() public constant returns (uint) {
140         return _totalSupply;
141     }
142 
143 
144     // ------------------------------------------------------------------------
145     // Get the token balance for account `tokenOwner`
146     // ------------------------------------------------------------------------
147     function balanceOf(address tokenOwner) public constant returns (uint balance) {
148         return balances[tokenOwner];
149     }
150 
151 
152     // ------------------------------------------------------------------------
153     // Transfer the balance from token owner's account to `to` account
154     // - Owner's account must have sufficient balance to transfer
155     // - 0 value transfers are allowed
156     // ------------------------------------------------------------------------
157     function transfer(address to, uint tokens) public whenNotPaused returns (bool success) {
158         require(to != address(0));
159         require(tokens <= balances[msg.sender]);
160 
161         balances[msg.sender] = balances[msg.sender].sub(tokens);
162         balances[to] = balances[to].add(tokens);
163         emit Transfer(msg.sender, to, tokens);
164         return true;
165     }
166 
167 
168     // ------------------------------------------------------------------------
169     // Token owner can approve for `spender` to transferFrom(...) `tokens`
170     // from the token owner's account
171     //
172     // https://github.com/ethereum/EIPs/blob/master/EIPS/eip-20-token-standard.md
173     // recommends that there are no checks for the approval double-spend attack
174     // as this should be implemented in user interfaces 
175     // ------------------------------------------------------------------------
176     function approve(address spender, uint tokens) public whenNotPaused returns (bool success) {
177         require(tokens == 0 || allowed[msg.sender][spender] == 0);
178         allowed[msg.sender][spender] = tokens;
179         emit Approval(msg.sender, spender, tokens);
180         return true;
181     }
182 
183 
184     // ------------------------------------------------------------------------
185     // Transfer `tokens` from the `from` account to the `to` account
186     // 
187     // The calling account must already have sufficient tokens approve(...)-d
188     // for spending from the `from` account and
189     // - From account must have sufficient balance to transfer
190     // - Spender must have sufficient allowance to transfer
191     // - 0 value transfers are allowed
192     // ------------------------------------------------------------------------
193     function transferFrom(address from, address to, uint tokens) public whenNotPaused returns (bool success) {
194         require(to != address(0));
195         require(tokens <= balances[from]);
196         require(tokens <= allowed[from][msg.sender]);
197 
198         balances[from] = balances[from].sub(tokens);
199         allowed[from][msg.sender] = allowed[from][msg.sender].sub(tokens);
200         balances[to] = balances[to].add(tokens);
201         emit Transfer(from, to, tokens);
202         return true;
203     }
204 
205 
206     // ------------------------------------------------------------------------
207     // Returns the amount of tokens approved by the owner that can be
208     // transferred to the spender's account
209     // ------------------------------------------------------------------------
210     function allowance(address tokenOwner, address spender) public constant returns (uint remaining) {
211         return allowed[tokenOwner][spender];
212     }
213 
214     // ------------------------------------------------------------------------
215     // Don't accept ETH
216     // ------------------------------------------------------------------------
217     function () public payable {
218         revert();
219     }
220 
221 }