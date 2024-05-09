1 pragma solidity ^0.4.18;
2 
3 
4 // ----------------------------------------------------------------------------
5 // Safe maths
6 // ----------------------------------------------------------------------------
7 contract SafeMath {
8     function safeAdd(uint a, uint b) internal pure returns (uint c) {
9         c = a + b;
10         require(c >= a);
11     }
12     function safeSub(uint a, uint b) internal pure returns (uint c) {
13         require(b <= a);
14         c = a - b;
15     }
16     function safeMul(uint a, uint b) internal pure returns (uint c) {
17         c = a * b;
18         require(a == 0 || c / a == b);
19     }
20     function safeDiv(uint a, uint b) internal pure returns (uint c) {
21         require(b > 0);
22         c = a / b;
23     }
24 }
25 
26 
27 // ----------------------------------------------------------------------------
28 // ERC Token Standard #20 Interface
29 // https://github.com/ethereum/EIPs/blob/master/EIPS/eip-20-token-standard.md
30 // ----------------------------------------------------------------------------
31 contract ERC20Interface {
32     function totalSupply() public constant returns (uint);
33     function balanceOf(address tokenOwner) public constant returns (uint balance);
34     function allowance(address tokenOwner, address spender) public constant returns (uint remaining);
35     function transfer(address to, uint tokens) public returns (bool success);
36     function approve(address spender, uint tokens) public returns (bool success);
37     function transferFrom(address from, address to, uint tokens) public returns (bool success);
38 
39     event Transfer(address indexed from, address indexed to, uint tokens);
40     event Approval(address indexed tokenOwner, address indexed spender, uint tokens);
41 }
42 
43 
44 // ----------------------------------------------------------------------------
45 // Contract function to receive approval and execute function in one call
46 //
47 // Borrowed from MiniMeToken
48 // ----------------------------------------------------------------------------
49 contract ApproveAndCallFallBack {
50     function receiveApproval(address from, uint256 tokens, address token, bytes data) public;
51 }
52 
53 
54 // ----------------------------------------------------------------------------
55 // Owned contract
56 // ----------------------------------------------------------------------------
57 contract Owned {
58     address public owner;
59     address public newOwner;
60 
61     event OwnershipTransferred(address indexed _from, address indexed _to);
62 
63     function Owned() public {
64         owner = msg.sender;
65     }
66 
67     modifier onlyOwner {
68         require(msg.sender == owner);
69         _;
70     }
71 
72     function transferOwnership(address _newOwner) public onlyOwner {
73         newOwner = _newOwner;
74     }
75     function acceptOwnership() public {
76         require(msg.sender == newOwner);
77         OwnershipTransferred(owner, newOwner);
78         owner = newOwner;
79         newOwner = address(0);
80     }
81 }
82 
83 
84 // ----------------------------------------------------------------------------
85 // ERC20 Token, with the addition of symbol, name and decimals and assisted
86 // token transfers
87 // ----------------------------------------------------------------------------
88 contract EOSPlusToken is ERC20Interface, Owned, SafeMath {
89     string public symbol;
90     string public  name;
91     uint8 public decimals;
92     uint public _totalSupply;
93 
94     mapping(address => uint) balances;
95     mapping(address => mapping(address => uint)) allowed;
96     
97     uint256 internal constant INITIAL_SUPPLY = 1000000000 * 10**uint(decimals);
98 
99     /**
100     * @dev Fix for the ERC20 short address attack.
101     */
102     modifier onlyPayloadSize(uint size) {
103      require(msg.data.length >= size + 4);
104      _;
105     }
106 
107     // ------------------------------------------------------------------------
108     // Constructor
109     // ------------------------------------------------------------------------
110     function EOSPlusToken() public {
111         decimals = 18;                            // Amount of decimals for display purposes
112         balances[msg.sender] = INITIAL_SUPPLY;               // Give the creator all initial tokens (100000 for example)
113         _totalSupply = INITIAL_SUPPLY;                        //total supply (there are 1.2 billion tokens going to 18DP)
114         name = "EOS+";                                   // Set the name for display purposes
115         symbol = "EOS+";                               // Set the symbol for display purposes
116     }
117 
118 
119     // ------------------------------------------------------------------------
120     // Total supply
121     // ------------------------------------------------------------------------
122     function totalSupply() public constant returns (uint) {
123         return _totalSupply  - balances[address(0)];
124     }
125 
126 
127     // ------------------------------------------------------------------------
128     // Get the token balance for account tokenOwner
129     // ------------------------------------------------------------------------
130     function balanceOf(address tokenOwner) public constant returns (uint balance) {
131         return balances[tokenOwner];
132     }
133 
134 
135     // ------------------------------------------------------------------------
136     // Transfer the balance from token owner's account to to account
137     // - Owner's account must have sufficient balance to transfer
138     // - 0 value transfers are allowed
139     // ------------------------------------------------------------------------
140     function transfer(address to, uint tokens) onlyPayloadSize(2 * 32) public returns (bool success) {
141         require (to != address(0));
142         require (balances[msg.sender] >= tokens); // Check if the sender has enough
143         require (balances[to] + tokens > balances[to]); // Check for overflows
144 
145         balances[msg.sender] = safeSub(balances[msg.sender], tokens);
146         balances[to] = safeAdd(balances[to], tokens);
147         Transfer(msg.sender, to, tokens);
148         return true;
149     }
150 
151     function transferbatch(address[] to, uint[] tokens) onlyPayloadSize(to.length * 32) public returns (bool success) {
152         for(uint i = 0; i < to.length; i++) {
153             address _to = to[i];
154             uint _tokens = tokens[i];
155             require (_to != address(0));
156             require (balances[msg.sender] >= _tokens); // Check if the sender has enough
157             require (balances[_to] + _tokens > balances[_to]); // Check for overflows
158 
159             balances[msg.sender] = safeSub(balances[msg.sender], _tokens);
160             balances[_to] = safeAdd(balances[_to], _tokens);
161             Transfer(msg.sender, _to, _tokens);
162         }
163         return true;
164     }
165 
166 
167     // ------------------------------------------------------------------------
168     // Token owner can approve for spender to transferFrom(...) tokens
169     // from the token owner's account
170     //
171     // https://github.com/ethereum/EIPs/blob/master/EIPS/eip-20-token-standard.md
172     // recommends that there are no checks for the approval double-spend attack
173     // as this should be implemented in user interfaces 
174     // ------------------------------------------------------------------------
175     function approve(address spender, uint tokens) public returns (bool success) {
176   
177         allowed[msg.sender][spender] = tokens;
178         Approval(msg.sender, spender, tokens);
179         return true;
180     }
181 
182 
183     // ------------------------------------------------------------------------
184     // Transfer tokens from the from account to the to account
185     // 
186     // The calling account must already have sufficient tokens approve(...)-d
187     // for spending from the from account and
188     // - From account must have sufficient balance to transfer
189     // - Spender must have sufficient allowance to transfer
190     // - 0 value transfers are allowed
191     // ------------------------------------------------------------------------
192     function transferFrom(address from, address to, uint tokens)  onlyPayloadSize(3 * 32) public returns (bool success) {
193         require(to != address(0));
194         require (balances[from] >= tokens); // Check if the sender has enough
195         require (balances[to] + tokens > balances[to]); // Check for overflows
196         require (tokens <= allowed[from][msg.sender]); // Check allowance  
197 
198         balances[from] = safeSub(balances[from], tokens);
199         allowed[from][msg.sender] = safeSub(allowed[from][msg.sender], tokens);
200         balances[to] = safeAdd(balances[to], tokens);
201         Transfer(from, to, tokens);
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
214 
215     // ------------------------------------------------------------------------
216     // Token owner can approve for spender to transferFrom(...) tokens
217     // from the token owner's account. The spender co··ntract function
218     // receiveApproval(...) is then executed
219     // ------------------------------------------------------------------------
220     function approveAndCall(address spender, uint tokens, bytes data) public returns (bool success) {
221         allowed[msg.sender][spender] = tokens;
222         Approval(msg.sender, spender, tokens);
223         ApproveAndCallFallBack(spender).receiveApproval(msg.sender, tokens, this, data);
224         return true;
225     }
226 
227 
228     // ------------------------------------------------------------------------
229     // Don't accept ETH
230     // ------------------------------------------------------------------------
231     function () public payable {
232         revert();
233     }
234 
235 
236     // ------------------------------------------------------------------------
237     // Owner can transfer out any accidentally sent ERC20 tokens
238     // ------------------------------------------------------------------------
239     function transferAnyERC20Token(address tokenAddress, uint tokens) public onlyOwner returns (bool success) {
240         return ERC20Interface(tokenAddress).transfer(owner, tokens);
241     }
242 
243     // ------------------------------------------------------------------------
244     // Optional token name
245     // ------------------------------------------------------------------------
246     function setName(string _name)  public onlyOwner {
247         name = _name;
248     }
249 
250     // ------------------------------------------------------------------------
251     // Optional token symbol
252     // ------------------------------------------------------------------------
253     function setSymbol(string _symbol) public onlyOwner {
254         symbol = _symbol;
255     }
256 }