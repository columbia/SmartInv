1 pragma solidity ^0.4.24;
2 
3 // File: contracts/Owned.sol
4 
5 // ----------------------------------------------------------------------------
6 // Ownership functionality for authorization controls and user permissions
7 // ----------------------------------------------------------------------------
8 contract Owned {
9     address public owner;
10     address public newOwner;
11 
12     event OwnershipTransferred(address indexed _from, address indexed _to);
13 
14     constructor() public {
15         owner = msg.sender;
16     }
17 
18     modifier onlyOwner {
19         require(msg.sender == owner);
20         _;
21     }
22 
23     function transferOwnership(address _newOwner) public onlyOwner {
24         newOwner = _newOwner;
25     }
26     function acceptOwnership() public {
27         require(msg.sender == newOwner);
28         emit OwnershipTransferred(owner, newOwner);
29         owner = newOwner;
30         newOwner = address(0);
31     }
32 }
33 
34 // File: contracts/Pausable.sol
35 
36 // ----------------------------------------------------------------------------
37 // Pause functionality
38 // ----------------------------------------------------------------------------
39 contract Pausable is Owned {
40   event Pause();
41   event Unpause();
42 
43   bool public paused = false;
44 
45 
46   // Modifier to make a function callable only when the contract is not paused.
47   modifier whenNotPaused() {
48     require(!paused);
49     _;
50   }
51 
52   // Modifier to make a function callable only when the contract is paused.
53   modifier whenPaused() {
54     require(paused);
55     _;
56   }
57 
58   // Called by the owner to pause, triggers stopped state
59   function pause() onlyOwner whenNotPaused public {
60     paused = true;
61     emit Pause();
62   }
63 
64   // Called by the owner to unpause, returns to normal state
65   function unpause() onlyOwner whenPaused public {
66     paused = false;
67     emit Unpause();
68   }
69 }
70 
71 // File: contracts/SafeMath.sol
72 
73 // ----------------------------------------------------------------------------
74 // Safe maths
75 // ----------------------------------------------------------------------------
76 contract SafeMath {
77     function safeAdd(uint a, uint b) public pure returns (uint c) {
78         c = a + b;
79         require(c >= a);
80     }
81     function safeSub(uint a, uint b) public pure returns (uint c) {
82         require(b <= a);
83         c = a - b;
84     }
85     function safeMul(uint a, uint b) public pure returns (uint c) {
86         c = a * b;
87         require(a == 0 || c / a == b);
88     }
89     function safeDiv(uint a, uint b) public pure returns (uint c) {
90         require(b > 0);
91         c = a / b;
92     }
93 }
94 
95 // File: contracts/ERC20.sol
96 
97 // ----------------------------------------------------------------------------
98 // ERC20 Standard Interface
99 // ----------------------------------------------------------------------------
100 contract ERC20 {
101     function totalSupply() public constant returns (uint);
102     function balanceOf(address tokenOwner) public constant returns (uint balance);
103     function allowance(address tokenOwner, address spender) public constant returns (uint remaining);
104     function transfer(address to, uint tokens) public returns (bool success);
105     function approve(address spender, uint tokens) public returns (bool success);
106     function transferFrom(address from, address to, uint tokens) public returns (bool success);
107 
108     event Transfer(address indexed from, address indexed to, uint tokens);
109     event Approval(address indexed tokenOwner, address indexed spender, uint tokens);
110 }
111 
112 // File: contracts/UncToken.sol
113 
114 // ----------------------------------------------------------------------------
115 // 'UNC' 'Uncloak' token contract
116 // Symbol      : UNC
117 // Name        : Uncloak
118 // Total supply: 4,200,000,000
119 // Decimals    : 18
120 // ----------------------------------------------------------------------------
121 
122 
123 // ----------------------------------------------------------------------------
124 // ERC20 Token, with the addition of symbol, name and decimals
125 // Receives ETH and generates tokens
126 // ----------------------------------------------------------------------------
127 contract UncToken is SafeMath, Owned, ERC20 {
128     string public symbol;
129     string public  name;
130     uint8 public decimals;
131     uint public _totalSupply;
132 
133     // Track whether the coin can be transfered
134     bool private transferEnabled = false;
135 
136     // track addresses that can transfer regardless of whether transfers are enables
137     mapping(address => bool) public transferAdmins;
138 
139     mapping(address => uint) public balances;
140     mapping(address => mapping(address => uint)) internal allowed;
141 
142     event Burned(address indexed burner, uint256 value);
143 
144     // Check if transfer is valid
145     modifier canTransfer(address _sender) {
146         require(transferEnabled || transferAdmins[_sender]);
147         _;
148     }
149 
150     // ------------------------------------------------------------------------
151     // Constructor
152     // ------------------------------------------------------------------------
153     constructor() public {
154         symbol = "UNC";
155         name = "Uncloak";
156         decimals = 18;
157         _totalSupply = 150000000 * 10**uint(decimals);
158         transferAdmins[owner] = true; // Enable transfers for owner
159         balances[owner] = _totalSupply;
160         emit Transfer(address(0), owner, _totalSupply);
161     }
162 
163     // ------------------------------------------------------------------------
164     // Total supply
165     // ------------------------------------------------------------------------
166     function totalSupply() public constant returns (uint) {
167         return _totalSupply;
168     }
169 
170     // ------------------------------------------------------------------------
171     // Get the token balance for account `tokenOwner`
172     // ------------------------------------------------------------------------
173     function balanceOf(address tokenOwner) public constant returns (uint balance) {
174         return balances[tokenOwner];
175     }
176 
177     // ------------------------------------------------------------------------
178     // Transfer the balance from token owner's account to `to` account
179     // - Owner's account must have sufficient balance to transfer
180     // - 0 value transfers are allowed
181     // ------------------------------------------------------------------------
182     function transfer(address to, uint tokens) canTransfer (msg.sender) public returns (bool success) {
183         require(to != address(this)); //make sure we're not transfering to this contract
184 
185         //check edge cases
186         if (balances[msg.sender] >= tokens
187             && tokens > 0) {
188 
189                 //update balances
190                 balances[msg.sender] = safeSub(balances[msg.sender], tokens);
191                 balances[to] = safeAdd(balances[to], tokens);
192 
193                 //log event
194                 emit Transfer(msg.sender, to, tokens);
195                 return true;
196         }
197         else {
198             return false;
199         }
200     }
201 
202     // ------------------------------------------------------------------------
203     // Token owner can approve for `spender` to transferFrom(...) `tokens`
204     // from the token owner's account
205     // ------------------------------------------------------------------------
206     function approve(address spender, uint tokens) public returns (bool success) {
207         // Ownly allow changes to or from 0. Mitigates vulnerabiilty of race description
208         // described here: https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
209         require((tokens == 0) || (allowed[msg.sender][spender] == 0));
210 
211         allowed[msg.sender][spender] = tokens;
212         emit Approval(msg.sender, spender, tokens);
213         return true;
214     }
215 
216     // ------------------------------------------------------------------------
217     // Transfer `tokens` from the `from` account to the `to` account
218     //
219     // The calling account must already have sufficient tokens approve(...)-d
220     // for spending from the `from` account and
221     // - From account must have sufficient balance to transfer
222     // - Spender must have sufficient allowance to transfer
223     // - 0 value transfers are allowed
224     // ------------------------------------------------------------------------
225     function transferFrom(address from, address to, uint tokens) canTransfer(from) public returns (bool success) {
226         require(to != address(this));
227 
228         //check edge cases
229         if (allowed[from][msg.sender] >= tokens
230             && balances[from] >= tokens
231             && tokens > 0) {
232 
233             //update balances and allowances
234             balances[from] = safeSub(balances[from], tokens);
235             allowed[from][msg.sender] = safeSub(allowed[from][msg.sender], tokens);
236             balances[to] = safeAdd(balances[to], tokens);
237 
238             //log event
239             emit Transfer(from, to, tokens);
240             return true;
241         }
242         else {
243             return false;
244         }
245     }
246 
247     // ------------------------------------------------------------------------
248     // Returns the amount of tokens approved by the owner that can be
249     // transferred to the spender's account
250     // ------------------------------------------------------------------------
251     function allowance(address tokenOwner, address spender) public constant returns (uint remaining) {
252         return allowed[tokenOwner][spender];
253     }
254 
255 
256     // Owner can allow transfers for a particular address. Use for crowdsale contract.
257     function setTransferAdmin(address _addr, bool _canTransfer) onlyOwner public {
258         transferAdmins[_addr] = _canTransfer;
259     }
260 
261     // Enable transfers for token holders
262     function enablesTransfers() public onlyOwner {
263         transferEnabled = true;
264     }
265 
266     // ------------------------------------------------------------------------
267     // Burns a specific number of tokens
268     // ------------------------------------------------------------------------
269     function burn(uint256 _value) public onlyOwner {
270         require(_value > 0);
271 
272         address burner = msg.sender;
273         balances[burner] = safeSub(balances[burner], _value);
274         _totalSupply = safeSub(_totalSupply, _value);
275         emit Burned(burner, _value);
276     }
277 
278     // ------------------------------------------------------------------------
279     // Doesn't Accept Eth
280     // ------------------------------------------------------------------------
281     function () public payable {
282         revert();
283     }
284 }