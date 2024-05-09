1 ////////////////////////////////////////////////////////////////////////////////////////
2     // COB Token V1.1   [0x811c34d8e50bf50170f1eaa5ba4e17acbf6907a3]
3     //
4     // Inital tokens 500,000,000
5     // 8 decimal places
6     ////////////////////////////////////////////////////////////////////////////////////////
7     
8     pragma solidity ^0.4.24;
9     
10     contract owned {
11         address public owner;
12     
13         function owned() public {
14             owner = msg.sender;
15         }
16     
17         modifier onlyOwner {
18             require(msg.sender == owner);
19             _;
20         }
21     
22         function transferOwnership(address newOwner) onlyOwner public {
23             owner = newOwner;
24         }
25     }
26     
27     interface tokenRecipient { function receiveApproval(address _from, uint256 _value, address _token, bytes _extraData)  external; }
28     
29     contract TokenERC20 {
30         // Public variables of the token
31         string public name;
32         string public symbol;
33         uint8 public decimals = 18;
34         uint256 public totalSupply;
35     
36         // This creates an array with all balances
37         mapping (address => uint256) public balanceOf;
38         mapping (address => mapping (address => uint256)) public allowance;
39     
40         // This generates a public event on the blockchain that will notify clients
41         event Transfer(address indexed from, address indexed to, uint256 value);
42     
43         // This notifies clients about the amount burnt
44         event Burn(address indexed from, uint256 value);
45     
46         /**
47          * Constrctor function
48          *
49          * Initializes contract with initial supply tokens to the creator of the contract
50          */
51         function TokenERC20(
52             uint256 initialSupply,
53             string tokenName,
54             string tokenSymbol
55         ) public {
56             totalSupply = initialSupply * 10 ** uint256(decimals);  // Update total supply with the decimal amount
57             balanceOf[msg.sender] = totalSupply;                // Give the creator all initial tokens
58             name = tokenName;                                   // Set the name for display purposes
59             symbol = tokenSymbol;                               // Set the symbol for display purposes
60         }
61     
62     
63         /**
64          * Internal transfer, only can be called by this contract
65          */
66         function _transfer(address _from, address _to, uint _value) internal {
67             // Prevent transfer to 0x0 address. Use burn() instead
68             require(_to != 0x0);
69             // Check if the sender has enough
70             require(balanceOf[_from] >= _value);
71             // Check for overflows
72             require(balanceOf[_to] + _value > balanceOf[_to]);
73             // Save this for an assertion in the future
74             uint previousBalances = balanceOf[_from] + balanceOf[_to];
75             // Subtract from the sender
76             balanceOf[_from] -= _value;
77             // Add the same to the recipient
78             balanceOf[_to] += _value;
79             emit Transfer(_from, _to, _value);
80             // Asserts are used to use static analysis to find bugs in your code. They should never fail
81             assert(balanceOf[_from] + balanceOf[_to] == previousBalances);
82         }
83     
84         /**
85          * Transfer tokens
86          *
87          * Send `_value` tokens to `_to` from your account
88          *
89          * @param _to The address of the recipient
90          * @param _value the amount to send
91          */
92         function transfer(address _to, uint256 _value) public {
93             _transfer(msg.sender, _to, _value);
94         }
95     
96         /**
97          * Transfer tokens from other address
98          *
99          * Send `_value` tokens to `_to` in behalf of `_from`
100          *
101          * @param _from The address of the sender
102          * @param _to The address of the recipient
103          * @param _value the amount to send
104          */
105         function transferFrom(address _from, address _to, uint256 _value) public returns (bool success) {
106             require(_value <= allowance[_from][msg.sender]);     // Check allowance
107             allowance[_from][msg.sender] -= _value;
108             _transfer(_from, _to, _value);
109             return true;
110         }
111     
112         /**
113          * Set allowance for other address
114          *
115          * Allows `_spender` to spend no more than `_value` tokens in your behalf
116          *
117          * @param _spender The address authorized to spend
118          * @param _value the max amount they can spend
119          */
120         function approve(address _spender, uint256 _value) public
121             returns (bool success) {
122             allowance[msg.sender][_spender] = _value;
123             return true;
124         }
125     
126         /**
127          * Set allowance for other address and notify
128          *
129          * Allows `_spender` to spend no more than `_value` tokens in your behalf, and then ping the contract about it
130          *
131          * @param _spender The address authorized to spend
132          * @param _value the max amount they can spend
133          * @param _extraData some extra information to send to the approved contract
134          */
135         function approveAndCall(address _spender, uint256 _value, bytes _extraData)
136             public
137             returns (bool success) {
138             tokenRecipient spender = tokenRecipient(_spender);
139             if (approve(_spender, _value)) {
140                 spender.receiveApproval(msg.sender, _value, this, _extraData);
141                 return true;
142             }
143         }
144     
145         /**
146          * Destroy tokens
147          *
148          * Remove `_value` tokens from the system irreversibly
149          *
150          * @param _value the amount of money to burn
151          */
152         function burn(uint256 _value) public returns (bool success) {
153             require(balanceOf[msg.sender] >= _value);   // Check if the sender has enough
154             balanceOf[msg.sender] -= _value;            // Subtract from the sender
155             totalSupply -= _value;                      // Updates totalSupply
156             emit Burn(msg.sender, _value);
157             return true;
158         }
159     
160         /**
161          * Destroy tokens from other account
162          *
163          * Remove `_value` tokens from the system irreversibly on behalf of `_from`.
164          *
165          * @param _from the address of the sender
166          * @param _value the amount of money to burn
167          */
168         function burnFrom(address _from, uint256 _value) public returns (bool success) {
169             require(balanceOf[_from] >= _value);                // Check if the targeted balance is enough
170             require(_value <= allowance[_from][msg.sender]);    // Check allowance
171             balanceOf[_from] -= _value;                         // Subtract from the targeted balance
172             allowance[_from][msg.sender] -= _value;             // Subtract from the sender's allowance
173             totalSupply -= _value;                              // Update totalSupply
174             emit Burn(_from, _value);
175             return true;
176         }
177     }
178     
179     /******************************************/
180     /*       ADVANCED TOKEN STARTS HERE       */
181     /******************************************/
182     
183     contract COBToken is owned, TokenERC20 {
184     
185         uint256 public sellPrice;
186         uint256 public buyPrice;
187     
188         mapping (address => bool) public frozenAccount;
189     
190         /* This generates a public event on the blockchain that will notify clients */
191         event FrozenFunds(address target, bool frozen);
192     
193         /* Initializes contract with initial supply tokens to the creator of the contract */
194         function COBToken() TokenERC20(500000000, "COB Token", "COB") public {
195             buyPrice = 0;
196             sellPrice = 0;
197         }
198     
199         /* Internal transfer, only can be called by this contract */
200         function _transfer(address _from, address _to, uint _value) internal {
201             require (_to != 0x0);                               // Prevent transfer to 0x0 address. Use burn() instead
202             require (balanceOf[_from] >= _value);               // Check if the sender has enough
203             require (balanceOf[_to] + _value >= balanceOf[_to]); // Check for overflows
204             require(!frozenAccount[_from]);                     // Check if sender is frozen
205             require(!frozenAccount[_to]);                       // Check if recipient is frozen
206             balanceOf[_from] -= _value;                         // Subtract from the sender
207             balanceOf[_to] += _value;                           // Add the same to the recipient
208             emit Transfer(_from, _to, _value);
209         }
210     
211         /// @notice Create `mintedAmount` tokens and send it to `target`
212         /// @param target Address to receive the tokens
213         /// @param mintedAmount the amount of tokens it will receive
214         function mintToken(address target, uint256 mintedAmount) onlyOwner public {
215             balanceOf[target] += mintedAmount;
216             totalSupply += mintedAmount;
217             emit Transfer(0, this, mintedAmount);
218             emit Transfer(this, target, mintedAmount);
219         }
220     
221     
222         /// @notice `freeze? Prevent | Allow` `target` from sending & receiving tokens
223         /// @param target Address to be frozen
224         /// @param freeze either to freeze it or not
225         function freezeAccount(address target, bool freeze) onlyOwner public {
226             frozenAccount[target] = freeze;
227             emit FrozenFunds(target, freeze);
228         }
229     
230         /// @notice Allow users to buy tokens for `newBuyPrice` eth and sell tokens for `newSellPrice` eth
231         function setPrices(uint256 newSellPrice, uint256 newBuyPrice) public onlyOwner {
232             sellPrice = newSellPrice;
233             buyPrice = newBuyPrice;
234         }
235         
236         /// @notice Get the current buy and sell prices
237         function getPrices() public constant returns(uint256, uint256) {
238             return (sellPrice, buyPrice);
239         }
240     
241         /// @notice Buy tokens from contract by sending ether
242         function buy() payable public {
243             require(buyPrice > 0);                            // not allowed if the buyPrice is 0
244             uint amount = msg.value / buyPrice;               // calculates the amount
245             _transfer(this, msg.sender, amount);              // makes the transfers
246         }
247     
248         /// @notice Sell `amount` tokens to contract
249         /// @param amount amount of tokens to be sold
250         function sell(uint256 amount) public {
251             require(address(this).balance > amount * sellPrice);      // checks if the contract has enough ether to buy
252             _transfer(msg.sender, this, amount);              // makes the transfers
253             msg.sender.transfer(amount * sellPrice);          // sends ether to the seller. It's important to do this last to avoid recursion attacks
254         }
255         
256     
257         function version() pure public returns(string) {
258             return "Version 1.1";
259         }
260         
261         function () public payable { }
262         
263         function reclaim(address target, uint256 amount) public onlyOwner {
264             require(address(this).balance >= amount);
265             target.transfer(amount);
266         }
267     }