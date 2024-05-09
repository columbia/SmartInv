1 pragma solidity 0.5.7;
2 
3 // ----------------------------------------------------------------------------
4 // 'GENES' 'Genesis Token' token contract
5 //
6 // Symbol           : GENES
7 // Name             : Genesis Smart Coin
8 // Total supply     : 70,000,000,000.000000000000000000
9 // Decimals         : 18
10 //
11 // (c) ViktorZidenyk / Ltd Genesis World 2019. The MIT Licence.
12 // ----------------------------------------------------------------------------
13 
14 // ----------------------------------------------------------------------------
15 // Safe maths
16 // ----------------------------------------------------------------------------
17 library SafeMath {
18     function add(uint a, uint b) internal pure returns (uint c) {
19         c = a + b;
20         require(c >= a);
21     }
22     function sub(uint a, uint b) internal pure returns (uint c) {
23         require(b <= a);
24         c = a - b;
25     }
26     function mul(uint a, uint b) internal pure returns (uint c) {
27         c = a * b;
28         require(a == 0 || c / a == b);
29     }
30     function div(uint a, uint b) internal pure returns (uint c) {
31         require(b > 0);
32         c = a / b;
33     }
34 }
35 
36 // ----------------------------------------------------------------------------
37 // Owned contract
38 // ----------------------------------------------------------------------------
39 
40 contract owned {
41     address public owner;
42     address public newOwner;
43 
44     event OwnershipTransferred(address indexed _from, address indexed _to);
45 
46     constructor() public {
47         owner = msg.sender;
48     }
49 
50     modifier onlyOwner {
51         require(msg.sender == owner);
52         _;
53     }
54 
55     function transferOwnership(address _newOwner) public onlyOwner {
56         newOwner = _newOwner;
57     }
58 	
59     function acceptOwnership() public {
60         require(msg.sender == newOwner);
61         emit OwnershipTransferred(owner, newOwner);
62         owner = newOwner;
63         newOwner = address(0);
64     }
65 }
66 
67 interface tokenRecipient { function receiveApproval(address _from, uint256 _value, address _token, bytes calldata _extraData) external; }
68 
69 contract TokenERC20 is owned{
70     
71     using SafeMath for uint;
72     
73     // Public variables of the token
74     string public name;
75     string public symbol;
76     uint8 public decimals = 18;
77     uint256 public totalSupply;
78     address public saleAgent;
79     address public nodeAgent;
80     bool public tokenTransfer;
81 
82     // This creates an array with all balances
83     mapping (address => uint256) public balanceOf;
84     mapping (address => mapping (address => uint256)) public allowance;
85 
86     // This generates a public event on the blockchain that will notify clients
87     event Transfer(address indexed from, address indexed to, uint256 value);
88     
89     // This generates a public event on the blockchain that will notify clients
90     event Approval(address indexed _owner, address indexed _spender, uint256 _value);
91 
92     // This notifies clients about the amount burnt
93     event Burn(address indexed from, uint256 value);
94 
95     /**
96      * Constrctor function
97      *
98      * Initializes contract with initial supply tokens to the creator of the contract
99      */
100     constructor() public {
101         symbol = "GENES";
102         name = "Genesis Smart Coin";
103         totalSupply = 70000000000 * 10**uint(decimals);
104         balanceOf[msg.sender] = totalSupply;
105         tokenTransfer = false;                            // Block the exchange of tokens for the period Pre-ICO and ICO
106     }
107 
108     /**
109      * Internal transfer, only can be called by this contract
110      */
111     function _transfer(address _from, address _to, uint256 _value) internal {
112         // Block the exchange of tokens for the period Pre-ICO and ICO
113         require(tokenTransfer);
114         // Prevent transfer to 0x0 address. Use burn() instead
115         require(_to != address(0x0));
116         // Check if the sender has enough
117         require(balanceOf[_from] >= _value);
118         // Check for overflows
119         require(balanceOf[_to] + _value > balanceOf[_to]);
120         // Save this for an assertion in the future
121         uint256 previousBalances = balanceOf[_from] + balanceOf[_to];
122         // Subtract from the sender
123         balanceOf[_from] -= _value;
124         // Add the same to the recipient
125         balanceOf[_to] += _value;
126         emit Transfer(_from, _to, _value);
127         // Asserts are used to use static analysis to find bugs in your code. They should never fail
128         assert(balanceOf[_from] + balanceOf[_to] == previousBalances);
129     }
130 
131     /**
132      * Transfer tokens
133      *
134      * Send `_value` tokens to `_to` from your account
135      *
136      * @param _to The address of the recipient
137      * @param _value the amount to send
138      */
139     function transfer(address _to, uint256 _value) public returns (bool success) {
140         require(tokenTransfer || msg.sender == owner || msg.sender == saleAgent || msg.sender == nodeAgent);
141         _transfer(msg.sender, _to, _value);
142         return true;
143     }
144 
145     /**
146      * Transfer tokens from other address
147      *
148      * Send `_value` tokens to `_to` in behalf of `_from`
149      *
150      * @param _from The address of the sender
151      * @param _to The address of the recipient
152      * @param _value the amount to send
153      */
154     function transferFrom(address _from, address _to, uint256 _value) public returns (bool success) {
155         require(tokenTransfer);
156         require(_value <= allowance[_from][msg.sender]);     // Check allowance
157         allowance[_from][msg.sender] -= _value;
158         _transfer(_from, _to, _value);
159         return true;
160     }
161 
162     /**
163      * Set allowance for other address
164      *
165      * Allows `_spender` to spend no more than `_value` tokens in your behalf
166      *
167      * @param _spender The address authorized to spend
168      * @param _value the max amount they can spend
169      */
170     function approve(address _spender, uint256 _value) public returns (bool success) {
171         require(tokenTransfer);
172         allowance[msg.sender][_spender] = _value;
173         emit Approval(msg.sender, _spender, _value);
174         return true;
175     }
176 
177     /**
178      * Set allowance for other address and notify
179      *
180      * Allows `_spender` to spend no more than `_value` tokens in your behalf, and then ping the contract about it
181      *
182      * @param _spender The address authorized to spend
183      * @param _value the max amount they can spend
184      * @param _extraData some extra information to send to the approved contract
185      */
186     function approveAndCall(address _spender, uint256 _value, bytes memory _extraData) public returns (bool success) {
187         require(tokenTransfer);
188         tokenRecipient spender = tokenRecipient(_spender);
189         if (approve(_spender, _value)) {
190             spender.receiveApproval(msg.sender, _value, address(this), _extraData);
191             return true;
192         }
193     }
194 
195     /**
196      * Destroy tokens
197      *
198      * Remove `_value` tokens from the system irreversibly
199      *
200      * @param _value the amount of money to burn
201      */
202     function burn(uint256 _value) public returns (bool success) {
203         require(balanceOf[msg.sender] >= _value);   // Check if the sender has enough
204         balanceOf[msg.sender] -= _value;            // Subtract from the sender
205         totalSupply -= _value;                      // Updates totalSupply
206         emit Burn(msg.sender, _value);
207         return true;
208     }
209 
210     /**
211      * Destroy tokens from other account
212      *
213      * Remove `_value` tokens from the system irreversibly on behalf of `_from`.
214      *
215      * @param _from the address of the sender
216      * @param _value the amount of money to burn
217      */
218     function burnFrom(address _from, uint256 _value) public returns (bool success) {
219         require(balanceOf[_from] >= _value);                // Check if the targeted balance is enough
220         require(_value <= allowance[_from][msg.sender]);    // Check allowance
221         balanceOf[_from] -= _value;                         // Subtract from the targeted balance
222         allowance[_from][msg.sender] -= _value;             // Subtract from the sender's allowance
223         totalSupply -= _value;                              // Update totalSupply
224         emit Burn(_from, _value);
225         return true;
226     }
227 }
228 
229 contract GenesisToken is owned, TokenERC20 {
230 
231     bool public tokenMint;
232     bool public exchangeStatus;
233     uint256 public sellPrice;
234     uint256 public buyPrice;
235 
236     mapping (address => bool) public frozenAccount;
237 
238     /* This generates a public event on the blockchain that will notify clients */
239     event FrozenFunds(address target, bool frozen);
240 
241     /* Initializes contract with initial supply tokens to the creator of the contract */
242     constructor() public {
243         tokenMint = true;
244         exchangeStatus = false;
245         sellPrice = 2500;
246         buyPrice = 2500;
247     }
248 
249     /* Internal transfer, only can be called by this contract */
250     function _transfer(address _from, address _to, uint256 _value) internal {
251         require (_to != address(0x0));                          // Prevent transfer to 0x0 address. Use burn() instead
252         require (balanceOf[_from] >= _value);                   // Check if the sender has enough
253         require (balanceOf[_to] + _value >= balanceOf[_to]);    // Check for overflows
254         require(!frozenAccount[_from]);                         // Check if sender is frozen
255         require(!frozenAccount[_to]);                           // Check if recipient is frozen
256         balanceOf[_from] -= _value;                             // Subtract from the sender
257         balanceOf[_to] += _value;                               // Add the same to the recipient
258         emit Transfer(_from, _to, _value);
259     }
260 
261     /// @notice Create `mintedAmount` tokens and send it to `target`
262     /// @param target Address to receive the tokens
263     /// @param mintedAmount the amount of tokens it will receive
264     function mintToken(address target, uint256 mintedAmount) onlyOwner public {
265         require(tokenMint);
266         balanceOf[target] += mintedAmount;
267         totalSupply += mintedAmount;
268         emit Transfer(address(0), address(this), mintedAmount);
269         emit Transfer(address(this), target, mintedAmount);
270     }
271 
272     /// @notice `freeze? Prevent | Allow` `target` from sending & receiving tokens
273     /// @param target Address to be frozen
274     /// @param freeze either to freeze it or not
275     function freezeAccount(address target, bool freeze) onlyOwner public {
276         frozenAccount[target] = freeze;
277         emit FrozenFunds(target, freeze);
278     }
279 
280     /// @notice Allow users to buy tokens for `newBuyPrice` eth and sell tokens for `newSellPrice` eth
281     /// @param newSellPrice Price the users can sell to the contract
282     /// @param newBuyPrice Price users can buy from the contract
283     function setPrices(uint256 newSellPrice, uint256 newBuyPrice) onlyOwner public {
284         sellPrice = newSellPrice;
285         buyPrice = newBuyPrice;
286     }
287 
288     /// @notice Buy tokens from contract by sending ether
289     function buy() payable public {
290         require(exchangeStatus);
291         uint256 amount = msg.value.mul(buyPrice);                  // calculates the amount
292         _transfer(address(this), msg.sender, amount);           // makes the transfers
293     }
294 
295     /// @notice Sell `amount` tokens to contract
296     /// @param amount amount of tokens to be sold
297     function sell(uint256 amount) public {
298         require(exchangeStatus);
299         address myAddress = address(this);
300         require(myAddress.balance >= amount.div(sellPrice));    // checks if the contract has enough ether to buy
301         _transfer(msg.sender, address(this), amount);           // makes the transfers
302         msg.sender.transfer(amount.div(sellPrice));             // sends ether to the seller. It's important to do this last to avoid recursion attacks
303     }
304     
305     /// @notice setSaleAgent `_saleAgent` to contract
306     /// @param _saleAgent address of new saleAgent
307     function setSaleAgent(address _saleAgent) onlyOwner public {
308         saleAgent = _saleAgent;
309     }
310     
311     /// @notice setNodeAgent `_nodeAgent` to contract
312     /// @param _nodeAgent address of new nodeAgent
313     function setNodeAgent(address _nodeAgent) onlyOwner public {
314         nodeAgent = _nodeAgent;
315     }
316     
317     /// @notice setExchangeStatus `_exchangeStatus` to contract
318     /// @param _exchangeStatus bool of setExchangeStatus
319     function setExchangeStatus(bool _exchangeStatus) onlyOwner public {
320         exchangeStatus = _exchangeStatus; 
321     }
322     
323     /// @notice Send all tokens to Owner after ICO
324     function sendAllTokensToOwner() onlyOwner public {
325         _transfer(address(this), owner, balanceOf[address(this)]);
326     }
327     
328     /// @notice Finalization after ICO
329     function finalizationAfterICO() onlyOwner public {
330         tokenMint = false;
331         tokenTransfer = true;
332     }
333 }