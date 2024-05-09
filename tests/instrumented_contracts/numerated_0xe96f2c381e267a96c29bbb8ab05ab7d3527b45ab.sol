1 pragma solidity ^0.4.18;
2 
3 // ----------------------------------------------------------------------------
4 // Safe maths
5 // ----------------------------------------------------------------------------
6 contract SafeMath {
7     function safeAdd(uint256 a, uint256 b) public pure returns (uint256 c) {
8         c = a + b;
9         require(c >= a);
10     }
11     function safeSub(uint256 a, uint256 b) public pure returns (uint256 c) {
12         require(b <= a);
13         c = a - b;
14     }
15     function safeMul(uint256 a, uint256 b) public pure returns (uint256 c) {
16         c = a * b;
17         require(a == 0 || c / a == b);
18     }
19     function safeDiv(uint256 a, uint256 b) public pure returns (uint256 c) {
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
31     function totalSupply() public constant returns (uint256);
32     function balanceOf(address tokenOwner) public constant returns (uint256 balance);
33     function allowance(address tokenOwner, address spender) public constant returns (uint256 remaining);
34     function transfer(address to, uint256 tokens) public returns (bool success);
35     function approve(address spender, uint256 tokens) public returns (bool success);
36     function transferFrom(address from, address to, uint256 tokens) public returns (bool success);
37 
38     event Transfer(address indexed from, address indexed to, uint256 tokens);
39     event Approval(address indexed tokenOwner, address indexed spender, uint256 tokens);
40     /* This notifies clients about the amount burnt */
41     event Burn(address indexed from, uint256 value);
42 	
43 	/* This notifies clients about the amount frozen */
44     event Freeze(address indexed from, uint256 value);
45 	
46 	/* This notifies clients about the amount unfrozen */
47     event Unfreeze(address indexed from, uint256 value);
48 }
49 
50 
51 // ----------------------------------------------------------------------------
52 // Contract function to receive approval and execute function in one call
53 //
54 // Borrowed from MiniMeToken
55 // ----------------------------------------------------------------------------
56 contract ApproveAndCallFallBack {
57     function receiveApproval(address from, uint256 tokens, address token, bytes data) public;
58 }
59 
60 
61 // ----------------------------------------------------------------------------
62 // Owned contract
63 // ----------------------------------------------------------------------------
64 contract Owned {
65     address public owner;
66     //address public newOwner;
67 
68     //event OwnershipTransferred(address indexed _from, address indexed _to);
69     //event OwnershipTransferInitiated(address indexed _to);
70 
71     function Owned() public {
72         owner = msg.sender;
73     }
74 
75     modifier onlyOwner {
76         require(msg.sender == owner);
77         _;
78     }
79     
80 /*
81     function transferOwnership(address _newOwner) public onlyOwner {
82         newOwner = _newOwner;
83         OwnershipTransferInitiated(_newOwner);
84     }
85     function acceptOwnership() public {
86         require(msg.sender == newOwner);
87         owner = newOwner;
88         OwnershipTransferred(owner, newOwner);
89         newOwner = address(0);
90     }
91     function resetOwner() public onlyOwner{
92         newOwner = address(0);
93     }
94     */
95 }
96 
97 
98 // ----------------------------------------------------------------------------
99 // ERC20 Token, with the addition of symbol, name and decimals and assisted
100 // token transfers
101 // ----------------------------------------------------------------------------
102 contract SatoExchange is ERC20Interface, Owned, SafeMath {
103     string public symbol;
104     string public  name;
105     uint8 public decimals;
106     uint256 public _totalSupply;
107 
108     mapping(address => uint256) internal balances;
109 	mapping (address => uint256) internal freezeOf;
110     mapping(address => mapping(address => uint256)) internal allowed;
111 
112 
113     // ------------------------------------------------------------------------
114     // Constructor
115     // ------------------------------------------------------------------------
116     function SatoExchange() public {
117         symbol = 'SATX';
118         name = 'SatoExchange';
119         decimals = 8;
120         _totalSupply = 30000000000000000;
121         balances[msg.sender] = _totalSupply;
122         Transfer(address(0), msg.sender, _totalSupply);
123     }
124 
125 
126     // ------------------------------------------------------------------------
127     // Total supply
128     // ------------------------------------------------------------------------
129     function totalSupply() public constant returns (uint256) {
130         return _totalSupply  - balances[address(0)];
131     }
132 
133 
134     // ------------------------------------------------------------------------
135     // Get the token balance for account tokenOwner
136     // ------------------------------------------------------------------------
137     function balanceOf(address tokenOwner) public constant returns (uint256 balance) {
138         return balances[tokenOwner];
139     }
140 
141 
142     // ------------------------------------------------------------------------
143     // Transfer the balance from token owner's account to to account
144     // - Owner's account must have sufficient balance to transfer
145     // - 0 value transfers are allowed
146     // ------------------------------------------------------------------------
147     function transfer(address to, uint256 tokens) public returns (bool success) {
148         if (to == 0x0) revert();                               // Prevent transfer to 0x0 address. Use burn() instead
149 		if (tokens <= 0) revert(); 
150 		require(msg.sender != address(0) && msg.sender != to);
151 	    require(to != address(0));
152         if (balances[msg.sender] < tokens) revert();           // Check if the sender has enough
153         if (balances[to] + tokens < balances[to]) revert(); // Check for overflows
154         balances[msg.sender] = safeSub(balances[msg.sender], tokens);
155         balances[to] = safeAdd(balances[to], tokens);
156         Transfer(msg.sender, to, tokens);
157         return true;
158     }
159 
160 
161     // ------------------------------------------------------------------------
162     // Token owner can approve for spender to transferFrom(...) tokens
163     // from the token owner's account
164     //
165     // https://github.com/ethereum/EIPs/blob/master/EIPS/eip-20-token-standard.md
166     // recommends that there are no checks for the approval double-spend attack
167     // as this should be implemented in user interfaces 
168     // ------------------------------------------------------------------------
169     function approve(address spender, uint256 tokens) public returns (bool success) {
170         require(tokens > 0); 
171         allowed[msg.sender][spender] = tokens;
172         Approval(msg.sender, spender, tokens);
173         return true;
174     }
175 
176 
177     function burn(uint256 _value) public returns (bool success) {
178         if (balances[msg.sender] < _value) revert();            // Check if the sender has enough
179 		if (_value <= 0) revert(); 
180         balances[msg.sender] = SafeMath.safeSub(balances[msg.sender], _value);                      // Subtract from the sender
181         _totalSupply = SafeMath.safeSub(_totalSupply,_value);                                // Updates totalSupply
182         Burn(msg.sender, _value);
183         return true;
184     }
185 	
186 	function freeze(uint256 _value) public returns (bool success) {
187         if (balances[msg.sender] < _value) revert();            // Check if the sender has enough
188 		if (_value <= 0) revert(); 
189         balances[msg.sender] = SafeMath.safeSub(balances[msg.sender], _value);                      // Subtract from the sender
190         freezeOf[msg.sender] = SafeMath.safeAdd(freezeOf[msg.sender], _value);                                // Updates totalSupply
191         Freeze(msg.sender, _value);
192         return true;
193     }
194 	
195 	function unfreeze(uint256 _value) public returns (bool success) {
196         if (freezeOf[msg.sender] < _value) revert();            // Check if the sender has enough
197 		if (_value <= 0) revert(); 
198         freezeOf[msg.sender] = SafeMath.safeSub(freezeOf[msg.sender], _value);                      // Subtract from the sender
199 		balances[msg.sender] = SafeMath.safeAdd(balances[msg.sender], _value);
200         Unfreeze(msg.sender, _value);
201         return true;
202     }
203 	
204 
205     // ------------------------------------------------------------------------
206     // Transfer tokens from the from account to the to account
207     // 
208     // The calling account must already have sufficient tokens approve(...)-d
209     // for spending from the from account and
210     // - From account must have sufficient balance to transfer
211     // - Spender must have sufficient allowance to transfer
212     // - 0 value transfers are allowed
213     // ------------------------------------------------------------------------
214     function transferFrom(address from, address to, uint256 tokens) public returns (bool success) {
215         if (to == 0x0) revert();                                // Prevent transfer to 0x0 address. Use burn() instead
216 		if (tokens <= 0) revert(); 
217         if (balances[from] < tokens) revert();                 // Check if the sender has enough
218         if (balances[to] + tokens < balances[to]) revert();  // Check for overflows
219         if (tokens > allowed[from][msg.sender]) revert();     // Check allowance
220         balances[from] = safeSub(balances[from], tokens);
221         allowed[from][msg.sender] = safeSub(allowed[from][msg.sender], tokens);
222         balances[to] = safeAdd(balances[to], tokens);
223         Transfer(from, to, tokens);
224         return true;
225     }
226 
227 
228     // ------------------------------------------------------------------------
229     // Returns the amount of tokens approved by the owner that can be
230     // transferred to the spender's account
231     // ------------------------------------------------------------------------
232     function allowance(address tokenOwner, address spender) public constant returns (uint256 remaining) {
233         return allowed[tokenOwner][spender];
234     }
235 
236 
237     // ------------------------------------------------------------------------
238     // Token owner can approve for spender to transferFrom(...) tokens
239     // from the token owner's account. The spender contract function
240     // receiveApproval(...) is then executed
241     // ------------------------------------------------------------------------
242     function approveAndCall(address spender, uint256 tokens, bytes data) public returns (bool success) {
243         require(tokens > 0);
244         allowed[msg.sender][spender] = tokens;
245         Approval(msg.sender, spender, tokens);
246         ApproveAndCallFallBack(spender).receiveApproval(msg.sender, tokens, this, data);
247         return true;
248     }
249 
250 
251 	// can accept ether
252 	function() public payable {
253 	    revert(); //disable receive ether
254     }
255 
256 	// transfer balance to owner
257 	/*
258 	function withdrawEther(uint256 amount)  public onlyOwner returns (bool success){
259 		owner.transfer(amount);
260 		return true;
261 	}*/
262 
263     // ------------------------------------------------------------------------
264     // Owner can transfer out any accidentally sent ERC20 tokens
265     // ------------------------------------------------------------------------
266     function transferAnyERC20Token(address tokenAddress, uint256 tokens) public onlyOwner returns (bool success) {
267         return ERC20Interface(tokenAddress).transfer(owner, tokens);
268     }
269 }