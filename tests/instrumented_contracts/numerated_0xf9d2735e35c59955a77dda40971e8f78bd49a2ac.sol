1 pragma solidity 0.4.21;
2 
3 // ----------------------------------------------------------------------------
4 // 'ANDRS' 'Andreis Token' token contract
5 //
6 // Symbol      : INO8
7 // Name        : AndreisToken
8 // Total supply: Generated from contributions
9 // Decimals    : 18
10 //
11 //
12 // ----------------------------------------------------------------------------
13 
14 
15 // ----------------------------------------------------------------------------
16 // Safe maths
17 // ----------------------------------------------------------------------------
18 contract SafeMath {
19     function safeAdd(uint a, uint b) public pure returns (uint c) {
20         c = a + b;
21         require(c >= a);
22     }
23     function safeSub(uint a, uint b) public pure returns (uint c) {
24         require(b <= a);
25         c = a - b;
26     }
27     function safeMul(uint a, uint b) public pure returns (uint c) {
28         c = a * b;
29         require(a == 0 || c / a == b);
30     }
31     function safeDiv(uint a, uint b) public pure returns (uint c) {
32         require(b > 0);
33         c = a / b;
34     }
35 }
36 
37 
38 // ----------------------------------------------------------------------------
39 // ERC Token Standard #20 Interface
40 // https://github.com/ethereum/EIPs/blob/master/EIPS/eip-20-token-standard.md
41 // ----------------------------------------------------------------------------
42 contract ERC20Interface {
43     function totalSupply() public view returns (uint);
44     function balanceOf(address tokenOwner) public view returns (uint balance);
45     function allowance(address tokenOwner, address spender) public view returns (uint remaining);
46     function transfer(address to, uint tokens) public returns (bool success);
47     function approve(address spender, uint tokens) public returns (bool success);
48     function transferFrom(address from, address to, uint tokens) public returns (bool success);
49 
50     event Transfer(address indexed from, address indexed to, uint tokens);
51     event Approval(address indexed tokenOwner, address indexed spender, uint tokens);
52 }
53 
54 
55 // ----------------------------------------------------------------------------
56 // Contract function to receive approval and execute function in one call
57 //
58 // Borrowed from MiniMeToken
59 // ----------------------------------------------------------------------------
60 contract ApproveAndCallFallBack {
61     function receiveApproval(address from, uint256 tokens, address token, bytes data) public;
62 }
63 
64 
65 // ----------------------------------------------------------------------------
66 // Owned contract
67 // ----------------------------------------------------------------------------
68 contract Owned {
69     address public owner;
70     address public newOwner;
71 
72     event OwnershipTransferred(address indexed _from, address indexed _to);
73 
74     function Owned() public {
75         owner = msg.sender;
76     }
77 
78     modifier onlyOwner {
79         require(msg.sender == owner);
80         _;
81     }
82 
83     function transferOwnership(address _newOwner) public onlyOwner {
84         newOwner = _newOwner;
85     }
86     function acceptOwnership() public {
87         require(msg.sender == newOwner);
88         emit OwnershipTransferred(owner, newOwner);
89         owner = newOwner;
90         newOwner = address(0);
91     }
92 }
93 
94 
95 // ----------------------------------------------------------------------------
96 // ERC20 Token, with the addition of symbol, name and decimals
97 // Receives ETH and generates tokens
98 // ----------------------------------------------------------------------------
99 contract AndreisToken is ERC20Interface, Owned, SafeMath {
100     string public symbol;
101     string public  name;
102     uint8 public decimals;
103     uint public _totalSupply;
104   
105 
106     uint256 public sellPrice;
107     uint256 public buyPrice;
108 
109 
110     mapping(address => uint) public balances;
111     mapping(address => mapping(address => uint)) public allowed;
112     mapping (address => bool) public frozenAccount;
113 
114      /* This generates a public event on the blockchain that will notify clients */
115     event FrozenFunds(address target, bool frozen);
116 
117      // This notifies clients about the amount burnt
118     event Burn(address indexed from, uint256 value);
119     /**
120     * @dev Fix for the ERC20 short address attack.
121     */
122     modifier onlyPayloadSize(uint size) {
123         assert(msg.data.length >= size + 4);
124         _;
125     } 
126 
127 
128     // ------------------------------------------------------------------------
129     // Constructor
130     // ------------------------------------------------------------------------
131     function AndreisToken() public {
132         symbol = "ANDRS";
133         name = "AndreisToken";
134         decimals = 18;
135         _totalSupply = 250000000 * 10**uint(decimals);
136         balances[owner] = _totalSupply;
137         emit Transfer(address(0), owner, _totalSupply);
138     }
139 
140 
141     // ------------------------------------------------------------------------
142     // Total supply
143     // ------------------------------------------------------------------------
144     function totalSupply() public view returns (uint) {
145         return safeSub(_totalSupply , balances[address(0)]);
146     }
147 
148 
149     // ------------------------------------------------------------------------
150     // Get the token balance for account `tokenOwner`
151     // ------------------------------------------------------------------------
152     function balanceOf(address tokenOwner) public view returns (uint balance) {
153         return balances[tokenOwner];
154     }
155 
156    
157 
158 
159     // ------------------------------------------------------------------------
160     // Transfer the balance from token owner's account to `to` account
161     // - Owner's account must have sufficient balance to transfer
162     // - 0 value transfers are allowed
163     // ------------------------------------------------------------------------
164     function transfer(address to, uint tokens) onlyPayloadSize(safeMul(2,32)) public  returns (bool success) {
165         _transfer(msg.sender, to, tokens);              // makes the transfers
166         return true;
167     }
168 
169 
170     // ------------------------------------------------------------------------
171     // Token owner can approve for `spender` to transferFrom(...) `tokens`
172     // from the token owner's account
173     //
174     // https://github.com/ethereum/EIPs/blob/master/EIPS/eip-20-token-standard.md
175     // recommends that there are no checks for the approval double-spend attack
176     // as this should be implemented in user interfaces 
177     // ------------------------------------------------------------------------
178     function approve(address spender, uint tokens) public returns (bool success) {
179         allowed[msg.sender][spender] = tokens;
180         emit Approval(msg.sender, spender, tokens);
181         return true;
182     }
183 
184 
185     // ------------------------------------------------------------------------
186     // Transfer `tokens` from the `from` account to the `to` account
187     // 
188     // The calling account must already have sufficient tokens approve(...)-d
189     // for spending from the `from` account and
190     // - From account must have sufficient balance to transfer
191     // - Spender must have sufficient allowance to transfer
192     // - 0 value transfers are allowed
193     // ------------------------------------------------------------------------
194     function transferFrom(address from, address to, uint tokens)  onlyPayloadSize(safeMul(3,32)) public returns (bool success) {
195 
196         require (to != 0x0);                               // Prevent transfer to 0x0 address. Use burn() instead
197         require (balances[from] >= tokens);               // Check if the sender has enough
198         require (safeAdd(balances[to] , tokens) >= balances[to]); // Check for overflows
199         require(!frozenAccount[from]);                     // Check if sender is frozen
200         require(!frozenAccount[to]);                       // Check if recipient is frozen
201 
202         balances[from] = safeSub(balances[from], tokens);
203         allowed[from][msg.sender] = safeSub(allowed[from][msg.sender], tokens);
204         balances[to] = safeAdd(balances[to], tokens);
205         emit Transfer(from, to, tokens);
206         return true;
207     }
208 
209 
210     // ------------------------------------------------------------------------
211     // Returns the amount of tokens approved by the owner that can be
212     // transferred to the spender's account
213     // ------------------------------------------------------------------------
214     function allowance(address tokenOwner, address spender) public view returns (uint remaining) {
215         return allowed[tokenOwner][spender];
216     }
217 
218 
219     // ------------------------------------------------------------------------
220     // Token owner can approve for `spender` to transferFrom(...) `tokens`
221     // from the token owner's account. The `spender` contract function
222     // `receiveApproval(...)` is then executed
223     // ------------------------------------------------------------------------
224     function approveAndCall(address spender, uint tokens, bytes data) public returns (bool success) {
225         allowed[msg.sender][spender] = tokens;
226         emit Approval(msg.sender, spender, tokens);
227         ApproveAndCallFallBack(spender).receiveApproval(msg.sender, tokens, this, data);
228         return true;
229     }
230 
231 
232 
233      /// @notice Create `mintedAmount` tokens and send it to `target`
234     /// @param target Address to receive the tokens
235     /// @param mintedAmount the amount of tokens it will receive
236     function mintToken(address target, uint256 mintedAmount) onlyOwner public {
237         balances[target] = safeAdd(balances[target], mintedAmount);    
238         _totalSupply = safeAdd(_totalSupply, mintedAmount);
239         emit Transfer(0, this, mintedAmount);
240         emit Transfer(this, target, mintedAmount);
241     }
242 
243      /// @notice `freeze? Prevent | Allow` `from` from sending & receiving tokens
244     /// @param from Address to be frozen
245     /// @param freeze either to freeze it or not
246     function freezeAccount(address from, bool freeze) onlyOwner public {
247         frozenAccount[from] = freeze;
248         emit FrozenFunds(from, freeze);
249     }
250     
251 
252     /* Internal transfer, only can be called by this contract */
253     function _transfer(address _from, address _to, uint _value) internal {
254         require (_to != 0x0);                               // Prevent transfer to 0x0 address. Use burn() instead
255         require (balances[_from] >= _value);               // Check if the sender has enough
256         require (safeAdd(balances[_to] , _value) >= balances[_to]); // Check for overflows
257         require(!frozenAccount[_from]);                     // Check if sender is frozen
258         require(!frozenAccount[_to]);                       // Check if recipient is frozen
259         
260         balances[_from] = safeSub(balances[_from], _value);
261         balances[_to] = safeAdd(balances[_to], _value);              
262         emit Transfer(_from, _to, _value);
263     }
264 
265 
266     /// @notice Allow users to buy tokens for `newBuyPrice` eth and sell tokens for `newSellPrice` eth
267     /// @param newSellPrice Price the users can sell to the contract
268     /// @param newBuyPrice Price users can buy from the contract
269     function setPrices(uint256 newSellPrice, uint256 newBuyPrice) onlyOwner public {
270         sellPrice = newSellPrice;
271         buyPrice = newBuyPrice;
272     }
273 
274     /// @notice Buy tokens from contract by sending ether
275     function buy() payable public {
276         uint amount = safeDiv(msg.value , buyPrice);               // calculates the amount
277         _transfer(this, msg.sender, amount);              // makes the transfers
278     }
279 
280     /// @notice Sell `amount` tokens to contract
281     /// @param amount amount of tokens to be sold
282     function sell(uint256 amount) public {
283         require(address(this).balance >= safeMul(amount ,sellPrice));      // checks if the contract has enough ether to buy
284         _transfer(msg.sender, this, amount);              // makes the transfers
285         msg.sender.transfer(safeMul(amount ,sellPrice));          // sends ether to the seller. It's important to do this last to avoid recursion attacks
286     }
287 
288     /**
289      * Destroy tokens
290      *
291      * Remove `_value` tokens from the system irreversibly
292      *
293      * @param _value the amount of money to burn
294      */
295     function burn(uint256 _value) public returns (bool success) {
296         require(balances[msg.sender] >= _value);   // Check if the sender has enough
297         balances[msg.sender] = safeSub(balances[msg.sender], _value); // Subtract from the sender
298         _totalSupply = safeSub(_totalSupply, _value); // Updates totalSupply
299                      
300         emit Burn(msg.sender, _value);
301         return true;
302     }
303 
304     /**
305      * Destroy tokens from other account
306      *
307      * Remove `_value` tokens from the system irreversibly on behalf of `_from`.
308      *
309      * @param _from the address of the sender
310      * @param _value the amount of money to burn
311      */
312     function burnFrom(address _from, uint256 _value) public returns (bool success) {
313         require(balances[_from] >= _value);                // Check if the targeted balance is enough
314         require(_value <= allowed[_from][msg.sender]);    // Check allowance
315         balances[_from] = safeSub(balances[_from], _value); // Subtract from the targeted balance
316         allowed[_from][msg.sender] = safeSub(allowed[_from][msg.sender], _value); // Subtract from the sender's allowance
317         _totalSupply = safeSub(_totalSupply, _value);  // Update totalSupply
318         emit Burn(_from, _value);
319         return true;
320     }
321 
322 
323     // ------------------------------------------------------------------------
324     // Owner can transfer out any accidentally sent ERC20 tokens
325     // ------------------------------------------------------------------------
326     function transferAnyERC20Token(address tokenAddress, uint tokens) public onlyOwner returns (bool success) {
327         return ERC20Interface(tokenAddress).transfer(owner, tokens);
328     }
329 }