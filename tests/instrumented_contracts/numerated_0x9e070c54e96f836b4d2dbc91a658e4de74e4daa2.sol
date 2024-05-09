1 pragma solidity ^0.4.25;
2 
3 /**
4  * @title SafeMath
5  * @dev Math operations with safety checks that throw on error
6  */
7 library SafeMath {
8 
9     /**
10     * @dev Multiplies two numbers, throws on overflow.
11     */
12     function mul(uint256 a, uint256 b) internal pure returns (uint256) {
13         if (a == 0) {
14             return 0;
15         }
16         uint256 c = a * b;
17         assert(c / a == b);
18         return c;
19     }
20 
21     /**
22     * @dev Integer division of two numbers, truncating the quotient.
23     */
24     function div(uint256 a, uint256 b) internal pure returns (uint256) {
25         // assert(b > 0); // Solidity automatically throws when dividing by 0
26         uint256 c = a / b;
27         // assert(a == b * c + a % b); // There is no case in which this doesn't hold
28         return c;
29     }
30 
31     /**
32     * @dev Substracts two numbers, throws on overflow (i.e. if subtrahend is greater than minuend).
33     */
34     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
35         assert(b <= a);
36         return a - b;
37     }
38 
39     /**
40     * @dev Adds two numbers, throws on overflow.
41     */
42     function add(uint256 a, uint256 b) internal pure returns (uint256) {
43         uint256 c = a + b;
44         assert(c >= a);
45         return c;
46     }
47 }
48 
49 
50 /**
51  * @title Ownable
52  * @dev The Ownable contract has an owner address, and provides basic authorization control
53  * functions, this simplifies the implementation of "user permissions".
54  */
55 
56 contract owned {
57     address public owner;
58 
59     modifier onlyOwner {
60         require(msg.sender == owner);
61         _;
62     }
63 
64     function transferOwnership(address newOwner) onlyOwner public {
65         owner = newOwner;
66     }
67 }
68 
69 interface tokenRecipient { function receiveApproval(address _from, uint256 _value, address _token, bytes _extraData) external; }
70 
71 contract ERC20 is owned {
72     
73     using SafeMath for uint;
74     // Public variables of the token
75     string public name = "Diamondsplash Token";
76     string public symbol = "DST";
77     uint8 public decimals = 8;
78     uint256 public totalSupply = 500000000 * 10 ** uint256(decimals);
79     
80      bool public released = false;
81 
82     /// the price of tokenBuy
83     uint256 public TokenPerETHBuy = 5000;
84     
85     /// the price of tokenSell
86     uint256 public TokenPerETHSell = 5000;
87 
88     // This creates an array with all balances
89     mapping (address => uint256) public balanceOf;
90     mapping (address => mapping (address => uint256)) public allowance;
91     mapping (address => bool) public frozenAccount;
92    
93     // This generates a public event on the blockchain that will notify clients
94     event Transfer(address indexed from, address indexed to, uint256 value);
95     
96     /* This generates a public event on the blockchain that will notify clients */
97     event FrozenFunds(address target, bool frozen);
98     
99     // This notifies clients about the amount burnt
100     event Burn(address indexed from, uint256 value);
101     
102     /// This notifies clients about the new Buy price
103     event BuyRateChanged(uint256 oldValue, uint256 newValue);
104     
105     /// This notifies clients about the new Sell price
106     event SellRateChanged(uint256 oldValue, uint256 newValue);
107     
108     /// This notifies clients about the Buy Token
109     event BuyToken(address user, uint256 eth, uint256 token);
110     
111     /// This notifies clients about the Sell Token
112     event SellToken(address user, uint256 eth, uint256 token);
113     
114     /// Log the event about a deposit being made by an address and its amount
115     event LogDepositMade(address indexed accountAddress, uint amount);
116     
117     modifier canTransfer() {
118         require(released ||  msg.sender == owner);
119        _;
120      }
121 
122     function releaseToken() public onlyOwner {
123         released = true;
124     }
125 
126     /**
127      * Constrctor function
128      *
129      * Initializes contract with initial supply tokens to the creator of the contract
130      */
131     constructor (address _owner) public {
132         owner = _owner;
133         balanceOf[owner] = totalSupply;
134     }
135   
136 
137     /**
138      * Internal transfer, only can be called by this contract
139      */
140     function _transfer(address _from, address _to, uint256 _value) canTransfer internal {
141         // Prevent transfer to 0x0 address. Use burn() instead
142         require(_to != 0x0);
143         // Check if the sender has enough
144         require(balanceOf[_from] >= _value);
145         // Check for overflows
146         require(balanceOf[_to] + _value > balanceOf[_to]);
147         // Check if sender is frozen
148         require(!frozenAccount[_from]);
149         // Check if recipient is frozen
150         require(!frozenAccount[_to]);
151         // Save this for an assertion in the future
152         uint256 previousBalances = balanceOf[_from] + balanceOf[_to];
153         // Subtract from the sender
154         balanceOf[_from] -= _value;
155         // Add the same to the recipient
156         balanceOf[_to] += _value;
157         emit Transfer(_from, _to, _value);
158         // Asserts are used to use static analysis to find bugs in your code. They should never fail
159         assert(balanceOf[_from] + balanceOf[_to] == previousBalances);
160     }
161 
162     /**
163      * Transfer tokens
164      *
165      * Send `_value` tokens to `_to` from your account
166      *
167      * @param _to The address of the recipient
168      * @param _value the amount to send
169      */
170     function transfer(address _to, uint256 _value) public {
171         _transfer(msg.sender, _to, _value);
172     }
173 
174     /**
175      * Transfer tokens from other address
176      *
177      * Send `_value` tokens to `_to` in behalf of `_from`
178      *
179      * @param _from The address of the sender
180      * @param _to The address of the recipient
181      * @param _value the amount to send
182      */
183     function transferFrom(address _from, address _to, uint256 _value) public returns (bool success) {
184         require(_value <= allowance[_from][msg.sender]);     // Check allowance
185         allowance[_from][msg.sender] -= _value;
186         _transfer(_from, _to, _value);
187         return true;
188     }
189 
190     /**
191      * Set allowance for other address
192      *
193      * Allows `_spender` to spend no more than `_value` tokens in your behalf
194      *
195      * @param _spender The address authorized to spend
196      * @param _value the max amount they can spend
197      */
198     function approve(address _spender, uint256 _value) public
199         returns (bool success) {
200         allowance[msg.sender][_spender] = _value;
201         return true;
202     }
203 
204     /**
205      * Set allowance for other address and notify
206      *
207      * Allows `_spender` to spend no more than `_value` tokens in your behalf, and then ping the contract about it
208      *
209      * @param _spender The address authorized to spend
210      * @param _value the max amount they can spend
211      * @param _extraData some extra information to send to the approved contract
212      */
213     function approveAndCall(address _spender, uint256 _value, bytes _extraData)
214         public
215         returns (bool success) {
216         tokenRecipient spender = tokenRecipient(_spender);
217         if (approve(_spender, _value)) {
218             spender.receiveApproval(msg.sender, _value, this, _extraData);
219             return true;
220         }
221     }
222 
223     /// @notice `freeze? Prevent | Allow` `target` from sending & receiving tokens
224     /// @param target Address to be frozen
225     /// @param freeze either to freeze it or not
226     function freezeAccount(address target, bool freeze) onlyOwner public {
227         frozenAccount[target] = freeze;
228         emit FrozenFunds(target, freeze);
229     }
230     
231      /// @notice Create `mintedAmount` tokens and send it to `target`
232     /// @param target Address to receive the tokens
233     /// @param mintedAmount the amount of tokens it will receive
234     function mintToken(address target, uint256 mintedAmount) onlyOwner public {
235         balanceOf[target] += mintedAmount;
236         totalSupply += mintedAmount;
237         emit Transfer(this, target, mintedAmount);
238     }
239      /**
240      * Destroy tokens
241      *
242      * Remove `_value` tokens from the system irreversibly
243      *
244      * @param _value the amount of money to burn
245      */
246     function burn(uint256 _value) public returns (bool success) {
247         require(balanceOf[msg.sender] >= _value);   // Check if the sender has enough
248         balanceOf[msg.sender] -= _value;            // Subtract from the sender
249         totalSupply -= _value;                      // Updates totalSupply
250         emit Burn(msg.sender, _value);
251         return true;
252     }
253 
254     /**
255      * Destroy tokens from other account
256      *
257      * Remove `_value` tokens from the system irreversibly on behalf of `_from`.
258      *
259      * @param _from the address of the sender
260      * @param _value the amount of money to burn
261      */
262     function burnFrom(address _from, uint256 _value) public returns (bool success) {
263         require(balanceOf[_from] >= _value);                // Check if the targeted balance is enough
264         require(_value <= allowance[_from][msg.sender]);    // Check allowance
265         balanceOf[_from] -= _value;                         // Subtract from the targeted balance
266         allowance[_from][msg.sender] -= _value;             // Subtract from the sender's allowance
267         totalSupply -= _value;                              // Update totalSupply
268         emit Burn(_from, _value);
269         return true;
270     }
271     
272      /**
273      * Set price function for Buy
274      *
275      * @param value the amount new Buy Price
276      */
277     
278     function setBuyRate(uint256 value) onlyOwner public {
279         require(value > 0);
280         emit BuyRateChanged(TokenPerETHBuy, value);
281         TokenPerETHBuy = value;
282     }
283     
284      /**
285      * Set price function for Sell
286      *
287      * @param value the amount new Sell Price
288      */
289     
290     function setSellRate(uint256 value) onlyOwner public {
291         require(value > 0);
292         emit SellRateChanged(TokenPerETHSell, value);
293         TokenPerETHSell = value;
294     }
295     
296     /**
297     *  function for Buy Token
298     */
299     
300     function buy() payable public returns (uint amount){
301           require(msg.value > 0);
302           amount = ((msg.value.mul(TokenPerETHBuy)).mul( 10 ** uint256(decimals))).div(1 ether);
303           balanceOf[this] -= amount;                        // adds the amount to owner's balance
304           balanceOf[msg.sender] += amount; 
305           emit BuyToken(msg.sender,msg.value,amount);
306           return amount;
307     }
308     
309     /**
310     *  function for Sell Token
311     */
312     
313     function sell(uint amount) public returns (uint revenue){
314         
315         require(balanceOf[msg.sender] >= amount);         // checks if the sender has enough to sell
316         balanceOf[this] += amount;                        // adds the amount to owner's balance
317         balanceOf[msg.sender] -= amount;                  // subtracts the amount from seller's balance
318         revenue = (amount.mul(1 ether)).div(TokenPerETHSell.mul(10 ** uint256(decimals))) ;
319         msg.sender.transfer(revenue);                     // sends ether to the seller: it's important to do this last to prevent recursion attacks
320         emit Transfer(msg.sender, this, amount);               // executes an event reflecting on the change
321         return revenue;                                   // ends function and returns
322         
323     }
324     
325     /**
326     * Deposit Ether in owner account, requires method is "payable"
327     */
328     
329     function deposit() public payable  {
330        
331     }
332     
333     /**
334     *@notice Withdraw for Ether
335     */
336      function withdraw(uint withdrawAmount) onlyOwner public  {
337           if (withdrawAmount <= address(this).balance) {
338             owner.transfer(withdrawAmount);
339         }
340         
341      }
342     
343     function () public payable {
344         buy();
345     }
346     
347   
348 }