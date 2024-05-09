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
88 contract _365USDToken is TokenERC20, Owned, SafeMath {
89     string public symbol;
90     string public  name;
91     uint8 public decimals;
92     uint public _totalSupply;
93   
94 
95     mapping(address => uint) public balances;
96     mapping(address => mapping(address => uint)) public allowed;
97     mapping (address => bool) public frozenAccount;
98 
99      /* This generates a public event on the blockchain that will notify clients */
100     event FrozenFunds(address target, bool frozen);
101 
102      // This notifies clients about the amount burnt
103     event Burn(address indexed from, uint256 value);
104     /**
105     * @dev Fix for the ERC20 short address attack.
106     */
107     modifier onlyPayloadSize(uint size) {
108         assert(msg.data.length >= size + 4);
109         _;
110     } 
111 
112 
113     // ------------------------------------------------------------------------
114     // Constructor
115     // ------------------------------------------------------------------------
116     constructor() public {
117         symbol = "365USD";
118         name = "365USD";
119         decimals = 8;
120         _totalSupply = 10000000000 * 10**uint(decimals);
121         owner = 0x1ac6bc75a9e1d32a91e025257eaefc0e8965a16f;
122         balances[owner] = _totalSupply;
123         emit Transfer(address(0), owner, _totalSupply);
124     }
125 
126 
127     // ------------------------------------------------------------------------
128     // Total supply
129     // ------------------------------------------------------------------------
130     function totalSupply() public view returns (uint) {
131         return safeSub(_totalSupply , balances[address(0)]);
132     }
133 
134 
135     // ------------------------------------------------------------------------
136     // Get the token balance for account `tokenOwner`
137     // ------------------------------------------------------------------------
138     function balanceOf(address tokenOwner) public view returns (uint balance) {
139         return balances[tokenOwner];
140     }
141 
142    
143 
144 
145     // ------------------------------------------------------------------------
146     // Transfer the balance from token owner's account to `to` account
147     // - Owner's account must have sufficient balance to transfer
148     // - 0 value transfers are allowed
149     // ------------------------------------------------------------------------
150     function transfer(address to, uint tokens) onlyPayloadSize(safeMul(2,32)) public  returns (bool success) {
151         _transfer(msg.sender, to, tokens);              // makes the transfers
152         return true;
153     }
154 
155 
156     // ------------------------------------------------------------------------
157     // Token owner can approve for `spender` to transferFrom(...) `tokens`
158     // from the token owner's account
159     // recommends that there are no checks for the approval double-spend attack
160     // as this should be implemented in user interfaces 
161     // ------------------------------------------------------------------------
162     function approve(address spender, uint tokens) public returns (bool success) {
163         allowed[msg.sender][spender] = tokens;
164         emit Approval(msg.sender, spender, tokens);
165         return true;
166     }
167 
168 
169     // ------------------------------------------------------------------------
170     // Transfer `tokens` from the `from` account to the `to` account
171     // 
172     // The calling account must already have sufficient tokens approve(...)-d
173     // for spending from the `from` account and
174     // - From account must have sufficient balance to transfer
175     // - Spender must have sufficient allowance to transfer
176     // - 0 value transfers are allowed
177     // ------------------------------------------------------------------------
178     function transferFrom(address from, address to, uint tokens)  onlyPayloadSize(safeMul(3,32)) public returns (bool success) {
179 
180         require (to != 0x0);                               // Prevent transfer to 0x0 address. Use burn() instead
181         require (balances[from] >= tokens);               // Check if the sender has enough
182         require (safeAdd(balances[to] , tokens) >= balances[to]); // Check for overflows
183         require(!frozenAccount[from]);                     // Check if sender is frozen
184         require(!frozenAccount[to]);                       // Check if recipient is frozen
185 
186         balances[from] = safeSub(balances[from], tokens);
187         allowed[from][msg.sender] = safeSub(allowed[from][msg.sender], tokens);
188         balances[to] = safeAdd(balances[to], tokens);
189         emit Transfer(from, to, tokens);
190         return true;
191     }
192 
193 
194     // ------------------------------------------------------------------------
195     // Returns the amount of tokens approved by the owner that can be
196     // transferred to the spender's account
197     // ------------------------------------------------------------------------
198     function allowance(address tokenOwner, address spender) public view returns (uint remaining) {
199         return allowed[tokenOwner][spender];
200     }
201 
202 
203     // ------------------------------------------------------------------------
204     // Token owner can approve for `spender` to transferFrom(...) `tokens`
205     // from the token owner's account. The `spender` contract function
206     // `receiveApproval(...)` is then executed
207     // ------------------------------------------------------------------------
208     function approveAndCall(address spender, uint tokens, bytes data) public returns (bool success) {
209         allowed[msg.sender][spender] = tokens;
210         emit Approval(msg.sender, spender, tokens);
211         ApproveAndCallFallBack(spender).receiveApproval(msg.sender, tokens, this, data);
212         return true;
213     }
214 
215 
216 
217      /// @notice `freeze? Prevent | Allow` `from` from sending & receiving tokens
218     /// @param from Address to be frozen
219     /// @param freeze either to freeze it or not
220     function freezeAccount(address from, bool freeze) onlyOwner public {
221         frozenAccount[from] = freeze;
222         emit FrozenFunds(from, freeze);
223     }
224     
225 
226     /* Internal transfer, only can be called by this contract */
227     function _transfer(address _from, address _to, uint _value) internal {
228         require (_to != 0x0);                               // Prevent transfer to 0x0 address. Use burn() instead
229         require (balances[_from] >= _value);               // Check if the sender has enough
230         require (safeAdd(balances[_to] , _value) >= balances[_to]); // Check for overflows
231         require(!frozenAccount[_from]);                     // Check if sender is frozen
232         require(!frozenAccount[_to]);                       // Check if recipient is frozen
233         
234         balances[_from] = safeSub(balances[_from], _value);
235         balances[_to] = safeAdd(balances[_to], _value);              
236         emit Transfer(_from, _to, _value);
237     }
238 
239     /**
240      * Destroy tokens
241      *
242      * Remove `_value` tokens from the system irreversibly
243      *
244      * @param _value the amount of money to burn
245      */
246     function burn(uint256 _value) public returns (bool success) {
247         require(balances[msg.sender] >= _value);   // Check if the sender has enough
248         balances[msg.sender] = safeSub(balances[msg.sender], _value); // Subtract from the sender
249         _totalSupply = safeSub(_totalSupply, _value); // Updates totalSupply
250                      
251         emit Burn(msg.sender, _value);
252         return true;
253     }
254 
255     /**
256      * Destroy tokens from other account
257      *
258      * Remove `_value` tokens from the system irreversibly on behalf of `_from`.
259      *
260      * @param _from the address of the sender
261      * @param _value the amount of money to burn
262      */
263     function burnFrom(address _from, uint256 _value) public returns (bool success) {
264         require(balances[_from] >= _value);                // Check if the targeted balance is enough
265         require(_value <= allowed[_from][msg.sender]);    // Check allowance
266         balances[_from] = safeSub(balances[_from], _value); // Subtract from the targeted balance
267         allowed[_from][msg.sender] = safeSub(allowed[_from][msg.sender], _value); // Subtract from the sender's allowance
268         _totalSupply = safeSub(_totalSupply, _value);  // Update totalSupply
269         emit Burn(_from, _value);
270         return true;
271     }
272 
273 }