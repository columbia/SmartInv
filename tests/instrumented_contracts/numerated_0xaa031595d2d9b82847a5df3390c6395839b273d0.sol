1 pragma solidity ^0.4.24;
2 
3 contract owned {
4     address public owner;
5 
6     function owned() public {
7         owner = msg.sender;
8     }
9 
10     modifier onlyOwner {
11         require(msg.sender == owner);
12         _;
13     }
14 
15     function transferOwnership(address newOwner) onlyOwner public {
16         // Prevent transfer to 0x0 address.
17         require(newOwner != 0x0);
18         owner = newOwner;
19     }
20 }
21 
22 // ----------------------------------------------------------------------------
23 // Safe maths
24 // ----------------------------------------------------------------------------
25 library SafeMath {
26     function add(uint a, uint b) internal pure returns (uint c) {
27         c = a + b;
28         require(c >= a);
29     }
30     function sub(uint a, uint b) internal pure returns (uint c) {
31         require(b <= a);
32         c = a - b;
33     }
34     function mul(uint a, uint b) internal pure returns (uint c) {
35         c = a * b;
36         require(a == 0 || c / a == b);
37     }
38     function div(uint a, uint b) internal pure returns (uint c) {
39         require(b > 0);
40         c = a / b;
41     }
42 }
43 
44 interface tokenRecipient { function receiveApproval(address _from, uint256 _value, address _token, bytes _extraData) external; }
45 
46 // ----------------------------------------------------------------------------
47 // ERC Token Standard #20 Interface
48 // https://github.com/ethereum/EIPs/blob/master/EIPS/eip-20-token-standard.md
49 // ----------------------------------------------------------------------------
50 contract ERC20Interface {
51     function totalSupply() public constant returns (uint);
52     function balanceOf(address tokenOwner) public constant returns (uint balance);
53     function allowance(address tokenOwner, address spender) public constant returns (uint remaining);
54     function transfer(address to, uint tokens) public returns (bool success);
55     function approve(address spender, uint tokens) public returns (bool success);
56     function transferFrom(address from, address to, uint tokens) public returns (bool success);
57 
58     event Transfer(address indexed from, address indexed to, uint tokens);
59     event Approval(address indexed tokenOwner, address indexed spender, uint tokens);
60 }
61 
62 contract TokenERC20 {
63     using SafeMath for uint;
64 
65     // Public variables of the token
66     string public name;
67     string public symbol;
68     uint8 public decimals = 18;
69     // 18 decimals is the strongly suggested default, avoid changing it
70     uint256 public totalSupply;
71 
72     // This creates an array with all balances
73     mapping (address => uint256) public balanceOf;
74     mapping (address => mapping (address => uint256)) public allowance;
75 
76     // This generates a public event on the blockchain that will notify clients
77     event Transfer(address indexed from, address indexed to, uint256 value);
78 
79     // This notifies clients about the amount burnt
80     event Burn(address indexed from, uint256 value);
81     
82     event Approval(address indexed tokenOwner, address indexed spender, uint value);
83 
84     /**
85      * Constrctor function
86      *
87      * Initializes contract with initial supply tokens to the creator of the contract
88      */
89     function TokenERC20() public {
90         totalSupply = 160000000 * 10 ** uint256(decimals);  // Update total supply with the decimal amount
91         balanceOf[msg.sender] = totalSupply;                // Give the creator all initial tokens
92         name = 'LEXIT';                                   // Set the name for display purposes
93         symbol = 'LXT';                               // Set the symbol for display purposes
94     }
95 
96     /**
97      * Internal transfer, only can be called by this contract
98      */
99     function _transfer(address _from, address _to, uint _value) internal {
100         // Prevent transfer to 0x0 address. Use burn() instead
101         require(_to != 0x0);
102         // Check if the sender has enough
103         require(balanceOf[_from] >= _value);
104         // Check for overflows
105         require(balanceOf[_to].add(_value) > balanceOf[_to]);
106         // Save this for an assertion in the future
107         uint previousBalances = balanceOf[_from].add(balanceOf[_to]);
108         // Subtract from the sender
109         balanceOf[_from] = balanceOf[_from].sub(_value);
110         // Add the same to the recipient
111         balanceOf[_to] = balanceOf[_to].add(_value);
112         emit Transfer(_from, _to, _value);
113         // Asserts are used to use static analysis to find bugs in your code. They should never fail
114         assert(balanceOf[_from].add(balanceOf[_to]) == previousBalances);
115     }
116 
117     /**
118      * Transfer tokens
119      *
120      * Send `_value` tokens to `_to` from your account
121      *
122      * @param _to The address of the recipient
123      * @param _value the amount to send
124      */
125     function transfer(address _to, uint256 _value) public returns (bool success) {
126         _transfer(msg.sender, _to, _value);
127         return true;
128     }
129 
130     /**
131      * Transfer tokens from other address
132      *
133      * Send `_value` tokens to `_to` in behalf of `_from`
134      *
135      * @param _from The address of the sender
136      * @param _to The address of the recipient
137      * @param _value the amount to send
138      */
139     function transferFrom(address _from, address _to, uint256 _value) public returns (bool success) {
140         require(_value <= allowance[_from][msg.sender]);     // Check allowance
141         allowance[_from][msg.sender] = allowance[_from][msg.sender].sub(_value);
142         _transfer(_from, _to, _value);
143         return true;
144     }
145 
146     /**
147      * Set allowance for other address
148      *
149      * Allows `_spender` to spend no more than `_value` tokens in your behalf
150      *
151      * @param _spender The address authorized to spend
152      * @param _value the max amount they can spend
153      */
154     function approve(address _spender, uint256 _value) public
155         returns (bool success) {
156         allowance[msg.sender][_spender] = _value;
157         emit Approval(msg.sender, _spender, _value);
158         return true;
159     }
160 
161     /**
162      * Set allowance for other address and notify
163      *
164      * Allows `_spender` to spend no more than `_value` tokens in your behalf, and then ping the contract about it
165      *
166      * @param _spender The address authorized to spend
167      * @param _value the max amount they can spend
168      * @param _extraData some extra information to send to the approved contract
169      */
170     function approveAndCall(address _spender, uint256 _value, bytes _extraData)
171         public
172         returns (bool success) {
173         tokenRecipient spender = tokenRecipient(_spender);
174         approve(_spender, _value);
175         spender.receiveApproval(msg.sender, _value, this, _extraData);
176         return true;
177     }
178 
179     /**
180      * Destroy tokens
181      *
182      * Remove `_value` tokens from the system irreversibly
183      *
184      * @param _value the amount of money to burn
185      */
186     function burn(uint256 _value) public returns (bool success) {
187         require(balanceOf[msg.sender] >= _value);   // Check if the sender has enough
188         balanceOf[msg.sender] = balanceOf[msg.sender].sub(_value);            // Subtract from the sender
189         totalSupply = totalSupply.sub(_value);                      // Updates totalSupply
190         emit Burn(msg.sender, _value);
191         return true;
192     }
193 
194     /**
195      * Destroy tokens from other account
196      *
197      * Remove `_value` tokens from the system irreversibly on behalf of `_from`.
198      *
199      * @param _from the address of the sender
200      * @param _value the amount of money to burn
201      */
202     function burnFrom(address _from, uint256 _value) public returns (bool success) {
203         require(balanceOf[_from] >= _value);                // Check if the targeted balance is enough
204         require(_value <= allowance[_from][msg.sender]);    // Check allowance
205         balanceOf[_from] = balanceOf[_from].sub(_value);                         // Subtract from the targeted balance
206         allowance[_from][msg.sender] = allowance[_from][msg.sender].sub(_value);             // Subtract from the sender's allowance
207         totalSupply = totalSupply.sub(_value);                              // Update totalSupply
208         emit Burn(_from, _value);
209         return true;
210     }
211 }
212 
213 /******************************************/
214 /*       LEXIT TOKEN STARTS HERE       */
215 /******************************************/
216 
217 contract LexitToken is owned, TokenERC20 {
218     using SafeMath for uint;
219 
220     uint256 public sellPrice;
221     uint256 public buyPrice;
222 
223     mapping (address => bool) public frozenAccount;
224 
225     /* This generates a public event on the blockchain that will notify clients */
226     event FrozenFunds(address target, bool frozen);
227 
228     /* Initializes contract with initial supply tokens to the creator of the contract */
229     function LexitToken() TokenERC20() public {
230         sellPrice = 1000 * 10 ** uint256(decimals);
231         buyPrice =  1 * 10 ** uint256(decimals);
232     }
233 
234     /* Internal transfer, only can be called by this contract */
235     function _transfer(address _from, address _to, uint _value) internal {
236         require (_to != 0x0);                               // Prevent transfer to 0x0 address. Use burn() instead
237         require (balanceOf[_from] >= _value);               // Check if the sender has enough
238         require (balanceOf[_to].add(_value) > balanceOf[_to]); // Check for overflows
239         require(!frozenAccount[_from]);                     // Check if sender is frozen
240         require(!frozenAccount[_to]);                       // Check if recipient is frozen
241         balanceOf[_from] = balanceOf[_from].sub(_value);                         // Subtract from the sender
242         balanceOf[_to] = balanceOf[_to].add(_value);                           // Add the same to the recipient
243         emit Transfer(_from, _to, _value);
244     }
245 
246     /// @notice Create `mintedAmount` tokens and send it to `target`
247     /// @param target Address to receive the tokens
248     /// @param mintedAmount the amount of tokens it will receive
249     function mintToken(address target, uint256 mintedAmount) onlyOwner public {
250         balanceOf[target] = balanceOf[target].add(mintedAmount);
251         totalSupply = totalSupply.add(mintedAmount);
252         emit Transfer(0, this, mintedAmount);
253         emit Transfer(this, target, mintedAmount);
254     }
255 
256     /// @notice `freeze? Prevent | Allow` `target` from sending & receiving tokens
257     /// @param target Address to be frozen
258     /// @param freeze either to freeze it or not
259     function freezeAccount(address target, bool freeze) onlyOwner public {
260         frozenAccount[target] = freeze;
261         emit FrozenFunds(target, freeze);
262     }
263 
264     /// @notice Allow users to buy tokens for `newBuyPrice` eth and sell tokens for `newSellPrice` eth
265     /// @param newSellPrice Price the users can sell to the contract
266     /// @param newBuyPrice Price users can buy from the contract
267     function setPrices(uint256 newSellPrice, uint256 newBuyPrice) onlyOwner public {
268         require(newSellPrice > 0);
269         require(newBuyPrice > 0);
270         sellPrice = newSellPrice;        
271         buyPrice = newBuyPrice;
272     }
273 
274     /// @notice Buy tokens from contract by sending ether
275     function buy() payable public {
276         uint amount = msg.value.div(buyPrice);               // calculates the amount
277         _transfer(this, msg.sender, amount);              // makes the transfers
278     }
279 
280     /// @notice Sell `amount` tokens to contract
281     /// @param amount amount of tokens to be sold
282     function sell(uint256 amount) public {
283         require(address(this).balance >= amount.mul(sellPrice));      // checks if the contract has enough ether to buy
284         _transfer(msg.sender, this, amount);              // makes the transfers
285         msg.sender.transfer(amount.mul(sellPrice));          // sends ether to the seller. It's important to do this last to avoid recursion attacks
286     }
287     
288     // ------------------------------------------------------------------------
289     // Owner can transfer out any accidentally sent ERC20 tokens
290     // ------------------------------------------------------------------------
291     function transferAnyERC20Token(address tokenAddress, uint tokens) public onlyOwner returns (bool success) {
292         return ERC20Interface(tokenAddress).transfer(owner, tokens);
293     }
294 }