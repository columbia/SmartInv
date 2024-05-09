1 pragma solidity ^0.4.16;
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
16         owner = newOwner;
17     }
18 }
19 
20 
21 contract ERC20Basic {
22     function totalSupply() public constant returns (uint supply);
23     function balanceOf( address who ) public constant returns (uint value);
24     function allowance( address owner, address spender ) public constant returns (uint _allowance);
25 
26     function transfer( address to, uint value) public returns (bool ok);
27     function transferFrom( address from, address to, uint value) public returns (bool ok);
28     function approve( address spender, uint value ) public returns (bool ok);
29 
30     // This generates a public event on the blockchain that will notify clients
31     event Transfer(address indexed from, address indexed to, uint256 value);
32     event Approval( address indexed owner, address indexed spender, uint value);
33     // This notifies clients about the amount burnt
34     event Burn(address indexed from, uint256 value);
35 }
36 
37 contract TokenERC20  is ERC20Basic{
38     // Public variables of the token
39     string public name;
40     string public symbol;
41     uint8 public decimals = 4;
42     uint256 _supply;
43     mapping (address => uint256)   _balances;
44     mapping (address => mapping (address => uint256)) _allowance;
45 
46     /**
47      * Constrctor function
48      *
49      * Initializes contract with initial supply tokens to the creator of the contract
50      */
51     function TokenERC20(
52         uint256 initialSupply,
53         string tokenName,
54         string tokenSymbol,
55         uint8 decimal
56     ) public {
57         _supply = initialSupply * 10 ** uint256(decimal);  // Update total supply with the decimal amount
58         _balances[msg.sender] = _supply;                // Give the creator all initial tokens
59         name = tokenName;                                   // Set the name for display purposes
60         symbol = tokenSymbol;                               // Set the symbol for display purposes
61         decimals = decimal;
62     }
63     function totalSupply() public constant returns (uint256) {
64         return _supply;
65     }
66     function balanceOf(address src) public constant returns (uint256) {
67         return _balances[src];
68     }
69     function allowance(address src, address guy) public constant returns (uint256) {
70         return _allowance[src][guy];
71     }
72     /**
73      * Internal transfer, only can be called by this contract
74      */
75     function _transfer(address _from, address _to, uint _value) internal {
76         // Prevent transfer to 0x0 address. Use burn() instead
77         require(_to != 0x0);
78         // Check if the sender has enough
79         require(_balances[_from] >= _value);
80         // Check for overflows
81         require(_balances[_to] + _value > _balances[_to]);
82         // Save this for an assertion in the future
83         uint previousBalances = _balances[_from] + _balances[_to];
84         // Subtract from the sender
85         _balances[_from] -= _value;
86         // Add the same to the recipient
87         _balances[_to] += _value;
88         Transfer(_from, _to, _value);
89         // Asserts are used to use static analysis to find bugs in your code. They should never fail
90         assert(_balances[_from] + _balances[_to] == previousBalances);
91     }
92 
93     /**
94      * Transfer tokens
95      *
96      * Send `_value` tokens to `_to` from your account
97      *
98      * @param _to The address of the recipient
99      * @param _value the amount to send
100      */
101     function transfer(address _to, uint256 _value) public returns (bool){
102         _transfer(msg.sender, _to, _value);
103         return true;
104     }
105 
106     /**
107      * Transfer tokens from other address
108      *
109      * Send `_value` tokens to `_to` in behalf of `_from`
110      *
111      * @param _from The address of the sender
112      * @param _to The address of the recipient
113      * @param _value the amount to send
114      */
115     function transferFrom(address _from, address _to, uint256 _value) public returns (bool success) {
116         require(_value <= _allowance[_from][msg.sender]);     // Check allowance
117         _allowance[_from][msg.sender] -= _value;
118         _transfer(_from, _to, _value);
119         return true;
120     }
121 
122     /**
123      * Set allowance for other address
124      *
125      * Allows `_spender` to spend no more than `_value` tokens in your behalf
126      *
127      * @param _spender The address authorized to spend
128      * @param _value the max amount they can spend
129      */
130     function approve(address _spender, uint256 _value) public returns (bool success) {
131         _allowance[msg.sender][_spender] = _value;
132         return true;
133     }
134 
135     /**
136      * Set allowance for other address and notify
137      *
138      * Allows `_spender` to spend no more than `_value` tokens in your behalf, and then ping the contract about it
139      *
140      * @param _spender The address authorized to spend
141      * @param _value the max amount they can spend
142      */
143     function approveAndCall(address _spender, uint256 _value)
144         public returns (bool success) {
145         if (approve(_spender, _value)) {
146             Approval(msg.sender, _spender, _value);
147             return true;
148         }
149     }
150 
151     /**
152      * Destroy tokens
153      *
154      * Remove `_value` tokens from the system irreversibly
155      *
156      * @param _value the amount of money to burn
157      */
158     function burn(uint256 _value) public returns (bool success) {
159         require(_balances[msg.sender] >= _value);   // Check if the sender has enough
160         _balances[msg.sender] -= _value;            // Subtract from the sender
161         _supply -= _value;                      // Updates totalSupply
162         Burn(msg.sender, _value);
163         return true;
164     }
165 
166     /**
167      * Destroy tokens from other account
168      *
169      * Remove `_value` tokens from the system irreversibly on behalf of `_from`.
170      *
171      * @param _from the address of the sender
172      * @param _value the amount of money to burn
173      */
174     function burnFrom(address _from, uint256 _value) public returns (bool success) {
175         require(_balances[_from] >= _value);                // Check if the targeted balance is enough
176         require(_value <= _allowance[_from][msg.sender]);    // Check allowance
177         _balances[_from] -= _value;                         // Subtract from the targeted balance
178         _allowance[_from][msg.sender] -= _value;             // Subtract from the sender's allowance
179         _supply -= _value;                              // Update totalSupply
180         Burn(_from, _value);
181         return true;
182     }
183 }
184 
185 /******************************************/
186 /*       ADVANCED TOKEN STARTS HERE       */
187 /******************************************/
188 
189 contract DYITToken is owned, TokenERC20 {
190 
191     uint256 public sellPrice = 0.00000001 ether ; //设置代币的卖的价格等于一个以太币
192     uint256 public buyPrice = 0.00000001 ether ;//设置代币的买的价格等于一个以太币
193     
194     mapping (address => bool) public _frozenAccount;
195 
196     /* This generates a public event on the blockchain that will notify clients */
197     event FrozenFunds(address target, bool frozen);
198 
199     /* Initializes contract with initial supply tokens to the creator of the contract */
200    function DYITToken(
201         uint256 initialSupply,
202         string tokenName,
203         string tokenSymbol,
204         uint8 decimal
205     ) TokenERC20(initialSupply, tokenName, tokenSymbol,decimal) public {
206         _balances[msg.sender] = _supply;  
207     }
208     
209     /* Internal transfer, only can be called by this contract */
210     function _transfer(address _from, address _to, uint _value) internal {
211         require (_to != 0x0);                               // Prevent transfer to 0x0 address. Use burn() instead
212         require (_balances[_from] >= _value);               // Check if the sender has enough
213         require (_balances[_to] + _value > _balances[_to]); // Check for overflows
214         require(!_frozenAccount[_from]);                     // Check if sender is frozen
215         require(!_frozenAccount[_to]);                       // Check if recipient is frozen
216         _balances[_from] -= _value;                         // Subtract from the sender
217         _balances[_to] += _value;                           // Add the same to the recipient
218         Transfer(_from, _to, _value);
219     }
220 
221     /// @notice Create `mintedAmount` tokens and send it to `target`
222     /// @param target Address to receive the tokens
223     /// @param mintedAmount the amount of tokens it will receive
224     function mintToken(address target, uint256 mintedAmount) onlyOwner public {
225         _balances[target] += mintedAmount;
226         _supply += mintedAmount;
227         Transfer(0, owner, mintedAmount);
228         Transfer(owner, target, mintedAmount);
229     }
230 
231     /// @notice `freeze? Prevent | Allow` `target` from sending & receiving tokens
232     /// @param target Address to be frozen
233     /// @param freeze either to freeze it or not
234     function freezeAccount(address target, bool freeze) onlyOwner public {
235         _frozenAccount[target] = freeze;
236         FrozenFunds(target, freeze);
237     }
238     /**
239      * 实现账户间，代币的转移
240      * @param _to The address of the recipient
241      * @param _value the amount to send
242      */
243     function transfer(address _to, uint256 _value) public returns (bool){
244         _transfer(msg.sender, _to, _value);
245         return true;
246     }
247     
248     /// @notice Allow users to buy tokens for `newBuyPrice` eth and sell tokens for `newSellPrice` eth
249     /// @param newSellPrice Price the users can sell to the contract
250     /// @param newBuyPrice Price users can buy from the contract
251     function setPrices(uint256 newSellPrice, uint256 newBuyPrice) onlyOwner public {
252         sellPrice = newSellPrice;
253         buyPrice = newBuyPrice;
254     }
255 
256     /// @notice Buy tokens from contract by sending ether
257     function buy() payable public {
258         uint amount = msg.value / buyPrice;               // calculates the amount
259         _transfer(owner, msg.sender, amount);              // makes the transfers
260     }
261 
262     /// @notice Sell `amount` tokens to contract
263     /// @param amount amount of tokens to be sold
264     function sell(uint256 amount) public {
265         require(owner.balance >= amount * sellPrice);      // checks if the contract has enough ether to buy
266         _transfer(msg.sender, owner, amount);              // makes the transfers
267         msg.sender.transfer(amount * sellPrice);          // sends ether to the seller. It's important to do this last to avoid recursion attacks
268     }
269 }