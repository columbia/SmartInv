1 pragma solidity ^0.4.21;
2 
3 
4 
5 // ----------------------------------------------------------------------------
6 // Safe maths
7 // ----------------------------------------------------------------------------
8 contract SafeMath {
9     function safeAdd(uint a, uint b) public pure returns (uint c) {
10         c = a + b;
11         require(c >= a);
12     }
13     function safeSub(uint a, uint b) public pure returns (uint c) {
14         require(b <= a);
15         c = a - b;
16     }
17     function safeMul(uint a, uint b) public pure returns (uint c) {
18         c = a * b;
19         require(a == 0 || c / a == b);
20     }
21     function safeDiv(uint a, uint b) public pure returns (uint c) {
22         require(b > 0);
23         c = a / b;
24     }
25 }
26 
27 
28 // ----------------------------------------------------------------------------
29 // ERC Token Standard #20 Interface
30 // ----------------------------------------------------------------------------
31 contract TokenERC20 {
32     function totalSupply() public view returns (uint);
33     function balanceOf(address tokenOwner) public view returns (uint balance);
34     function allowance(address tokenOwner, address spender) public view returns (uint remaining);
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
63     constructor() public {
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
77         emit OwnershipTransferred(owner, newOwner);
78         owner = newOwner;
79         newOwner = address(0);
80     }
81 }
82 
83 
84 // ----------------------------------------------------------------------------
85 // ERC20 Token, with the addition of symbol, name and decimals
86 // Receives ETH and generates tokens
87 // ----------------------------------------------------------------------------
88 contract GIDToken is TokenERC20, Owned, SafeMath {
89     string public symbol;
90     string public  name;
91     uint8 public decimals;
92     uint public _totalSupply;
93    
94     mapping(address => uint) public balances;
95     mapping(address => mapping(address => uint)) public allowed;
96     mapping (address => bool) public frozenAccount;
97 
98      /* This generates a public event on the blockchain that will notify clients */
99     event FrozenFunds(address target, bool frozen);
100 
101      // This notifies clients about the amount burnt
102     event Burn(address indexed from, uint256 value);
103     /**
104     * @dev Fix for the ERC20 short address attack.
105     */
106     modifier onlyPayloadSize(uint size) {
107         assert(msg.data.length >= size + 4);
108         _;
109     } 
110 
111 
112     // ------------------------------------------------------------------------
113     // Constructor
114     // ------------------------------------------------------------------------
115     constructor() public {
116         
117         
118         symbol = "GIDT";
119         name = "GID";
120         decimals = 8;
121         _totalSupply = 1000000000 * 10**uint(decimals);
122         owner = 0xDAd085eB10FefC2c2ddac7dc9d22c7DBf1A78480;
123        
124         balances[owner] = _totalSupply;
125         emit Transfer(address(0), owner, _totalSupply);
126     }
127 
128 
129     // ------------------------------------------------------------------------
130     // Total supply
131     // ------------------------------------------------------------------------
132     function totalSupply() public view returns (uint) {
133         return safeSub(_totalSupply , balances[address(0)]);
134     }
135 
136 
137     // ------------------------------------------------------------------------
138     // Get the token balance for account `tokenOwner`
139     // ------------------------------------------------------------------------
140     function balanceOf(address tokenOwner) public view returns (uint balance) {
141         return balances[tokenOwner];
142     }
143 
144    
145 
146 
147     // ------------------------------------------------------------------------
148     // Transfer the balance from token owner's account to `to` account
149     // - Owner's account must have sufficient balance to transfer
150     // - 0 value transfers are allowed
151     // ------------------------------------------------------------------------
152     function transfer(address to, uint tokens) onlyPayloadSize(safeMul(2,32)) public  returns (bool success) {
153         _transfer(msg.sender, to, tokens);              // makes the transfers
154         return true;
155     }
156 
157 
158     // ------------------------------------------------------------------------
159     // Token owner can approve for `spender` to transferFrom(...) `tokens`
160     // from the token owner's account
161     // recommends that there are no checks for the approval double-spend attack
162     // as this should be implemented in user interfaces 
163     // ------------------------------------------------------------------------
164     function approve(address spender, uint tokens) public returns (bool success) {
165         allowed[msg.sender][spender] = tokens;
166         emit Approval(msg.sender, spender, tokens);
167         return true;
168     }
169 
170 
171     // ------------------------------------------------------------------------
172     // Transfer `tokens` from the `from` account to the `to` account
173     // 
174     // The calling account must already have sufficient tokens approve(...)-d
175     // for spending from the `from` account and
176     // - From account must have sufficient balance to transfer
177     // - Spender must have sufficient allowance to transfer
178     // - 0 value transfers are allowed
179     // ------------------------------------------------------------------------
180     function transferFrom(address from, address to, uint tokens)  onlyPayloadSize(safeMul(3,32)) public returns (bool success) {
181 
182         require (to != 0x0);                               // Prevent transfer to 0x0 address. Use burn() instead
183         require (balances[from] >= tokens);               // Check if the sender has enough
184         require (safeAdd(balances[to] , tokens) >= balances[to]); // Check for overflows
185         require(!frozenAccount[from]);                     // Check if sender is frozen
186         require(!frozenAccount[to]);                       // Check if recipient is frozen
187 
188         balances[from] = safeSub(balances[from], tokens);
189         allowed[from][msg.sender] = safeSub(allowed[from][msg.sender], tokens);
190         balances[to] = safeAdd(balances[to], tokens);
191         emit Transfer(from, to, tokens);
192         return true;
193     }
194 
195 
196     // ------------------------------------------------------------------------
197     // Returns the amount of tokens approved by the owner that can be
198     // transferred to the spender's account
199     // ------------------------------------------------------------------------
200     function allowance(address tokenOwner, address spender) public view returns (uint remaining) {
201         return allowed[tokenOwner][spender];
202     }
203 
204 
205     // ------------------------------------------------------------------------
206     // Token owner can approve for `spender` to transferFrom(...) `tokens`
207     // from the token owner's account. The `spender` contract function
208     // `receiveApproval(...)` is then executed
209     // ------------------------------------------------------------------------
210     function approveAndCall(address spender, uint tokens, bytes data) public returns (bool success) {
211         allowed[msg.sender][spender] = tokens;
212         emit Approval(msg.sender, spender, tokens);
213         ApproveAndCallFallBack(spender).receiveApproval(msg.sender, tokens, this, data);
214         return true;
215     }
216 
217 
218 
219      /// @notice `freeze? Prevent | Allow` `from` from sending & receiving tokens
220     /// @param from Address to be frozen
221     /// @param freeze either to freeze it or not
222     function freezeAccount(address from, bool freeze) onlyOwner public {
223         frozenAccount[from] = freeze;
224         emit FrozenFunds(from, freeze);
225     }
226     
227 
228     /* Internal transfer, only can be called by this contract */
229     function _transfer(address _from, address _to, uint _value) internal {
230         require (_to != 0x0);                               // Prevent transfer to 0x0 address. Use burn() instead
231         require (balances[_from] >= _value);               // Check if the sender has enough
232         require (safeAdd(balances[_to] , _value) >= balances[_to]); // Check for overflows
233         require(!frozenAccount[_from]);                     // Check if sender is frozen
234         require(!frozenAccount[_to]);                       // Check if recipient is frozen
235         
236         balances[_from] = safeSub(balances[_from], _value);
237         balances[_to] = safeAdd(balances[_to], _value);              
238         emit Transfer(_from, _to, _value);
239     }
240 
241     /**
242      * Destroy tokens
243      *
244      * Remove `_value` tokens from the system irreversibly
245      *
246      * @param _value the amount of money to burn
247      */
248     function burn(uint256 _value) public returns (bool success) {
249         require(balances[msg.sender] >= _value);   // Check if the sender has enough
250         balances[msg.sender] = safeSub(balances[msg.sender], _value); // Subtract from the sender
251         _totalSupply = safeSub(_totalSupply, _value); // Updates totalSupply
252                      
253         emit Burn(msg.sender, _value);
254         return true;
255     }
256 
257     /**
258      * Destroy tokens from other account
259      *
260      * Remove `_value` tokens from the system irreversibly on behalf of `_from`.
261      *
262      * @param _from the address of the sender
263      * @param _value the amount of money to burn
264      */
265     function burnFrom(address _from, uint256 _value) public returns (bool success) {
266         require(balances[_from] >= _value);                // Check if the targeted balance is enough
267         require(_value <= allowed[_from][msg.sender]);    // Check allowance
268         balances[_from] = safeSub(balances[_from], _value); // Subtract from the targeted balance
269         allowed[_from][msg.sender] = safeSub(allowed[_from][msg.sender], _value); // Subtract from the sender's allowance
270         _totalSupply = safeSub(_totalSupply, _value);  // Update totalSupply
271         emit Burn(_from, _value);
272         return true;
273     }
274 
275 }