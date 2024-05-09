1 pragma solidity ^0.4.20;
2 
3 contract owned {
4     address public owner;
5 
6     constructor() public {
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
20 interface tokenRecipient { function receiveApproval(address _from, uint256 _value, address _token, bytes _extraData) external; }
21 
22 contract TokenERC20 {
23     // Public variables of the token
24     string public name;
25     string public symbol;
26     uint8 public decimals = 18;
27     // 18 decimals is the strongly suggested default, avoid changing it
28     uint256 public totalSupply;
29 
30     // This creates an array with all balances
31     mapping (address => uint256) public balanceOf;
32     mapping (address => mapping (address => uint256)) public allowance;
33 
34     // This generates a public event on the blockchain that will notify clients
35     event Transfer(address indexed from, address indexed to, uint256 value);
36 
37     // This generates a public event on the blockchain that will notify clients
38     event Approval(address indexed _owner, address indexed _spender, uint256 _value);
39 
40     // This notifies clients about the amount burnt
41     event Burn(address indexed from, uint256 value);
42 
43 
44     /**
45      * Internal transfer, only can be called by this contract
46      */
47     function _transfer(address _from, address _to, uint _value) internal {
48         // Prevent transfer to 0x0 address. Use burn() instead
49         require(_to != 0x0);
50         // Check if the sender has enough
51         require(balanceOf[_from] >= _value);
52         // Check for overflows
53         require(balanceOf[_to] + _value > balanceOf[_to]);
54         // Save this for an assertion in the future
55         uint previousBalances = balanceOf[_from] + balanceOf[_to];
56         // Subtract from the sender
57         balanceOf[_from] -= _value;
58         // Add the same to the recipient
59         balanceOf[_to] += _value;
60         emit Transfer(_from, _to, _value);
61         // Asserts are used to use static analysis to find bugs in your code. They should never fail
62         assert(balanceOf[_from] + balanceOf[_to] == previousBalances);
63     }
64 
65     function totalSupply() public view returns (uint256) {
66         return totalSupply;
67     }
68 
69     function balanceOf(address _who) public view returns (uint256) {
70         return balanceOf[_who];
71     }
72 
73     /**
74      * Transfer tokens
75      *
76      * Send `_value` tokens to `_to` from your account
77      *
78      * @param _to The address of the recipient
79      * @param _value the amount to send
80      */
81     function transfer(address _to, uint256 _value) public returns (bool success) {
82         _transfer(msg.sender, _to, _value);
83         return true;
84     }
85 
86     /**
87      * Transfer tokens from other address
88      *
89      * Send `_value` tokens to `_to` in behalf of `_from`
90      *
91      * @param _from The address of the sender
92      * @param _to The address of the recipient
93      * @param _value the amount to send
94      */
95     function transferFrom(address _from, address _to, uint256 _value) public returns (bool success) {
96         require(_value <= allowance[_from][msg.sender]);     // Check allowance
97         allowance[_from][msg.sender] -= _value;
98         _transfer(_from, _to, _value);
99         return true;
100     }
101 
102     /**
103      * Set allowance for other address
104      *
105      * Allows `_spender` to spend no more than `_value` tokens in your behalf
106      *
107      * @param _spender The address authorized to spend
108      * @param _value the max amount they can spend
109      */
110     function approve(address _spender, uint256 _value) public
111     returns (bool success) {
112         allowance[msg.sender][_spender] = _value;
113         emit Approval(msg.sender, _spender, _value);
114         return true;
115     }
116 
117     /**
118      * Set allowance for other address and notify
119      *
120      * Allows `_spender` to spend no more than `_value` tokens in your behalf, and then ping the contract about it
121      *
122      * @param _spender The address authorized to spend
123      * @param _value the max amount they can spend
124      * @param _extraData some extra information to send to the approved contract
125      */
126     function approveAndCall(address _spender, uint256 _value, bytes _extraData)
127     public
128     returns (bool success) {
129         tokenRecipient spender = tokenRecipient(_spender);
130         if (approve(_spender, _value)) {
131             spender.receiveApproval(msg.sender, _value, this, _extraData);
132             return true;
133         }
134     }
135 
136     /**
137      * Destroy tokens
138      *
139      * Remove `_value` tokens from the system irreversibly
140      *
141      * @param _value the amount of money to burn
142      */
143     function burn(uint256 _value) public returns (bool success) {
144         require(balanceOf[msg.sender] >= _value);   // Check if the sender has enough
145         balanceOf[msg.sender] -= _value;            // Subtract from the sender
146         totalSupply -= _value;                      // Updates totalSupply
147         emit Burn(msg.sender, _value);
148         return true;
149     }
150 
151     /**
152      * Destroy tokens from other account
153      *
154      * Remove `_value` tokens from the system irreversibly on behalf of `_from`.
155      *
156      * @param _from the address of the sender
157      * @param _value the amount of money to burn
158      */
159     function burnFrom(address _from, uint256 _value) public returns (bool success) {
160         require(balanceOf[_from] >= _value);                // Check if the targeted balance is enough
161         require(_value <= allowance[_from][msg.sender]);    // Check allowance
162         balanceOf[_from] -= _value;                         // Subtract from the targeted balance
163         allowance[_from][msg.sender] -= _value;             // Subtract from the sender's allowance
164         totalSupply -= _value;                              // Update totalSupply
165         emit Burn(_from, _value);
166         return true;
167     }
168 }
169 
170 /******************************************/
171 /*       Business Union Chain      */
172 /******************************************/
173 
174 contract BUB is owned, TokenERC20 {
175 
176     uint256 public sellPrice;
177     uint256 public buyPrice;
178 
179     mapping (address => bool) public frozenAccount;
180 
181     /* This generates a public event on the blockchain that will notify clients */
182     event FrozenFunds(address target, bool frozen);
183 
184     /* Initializes contract with initial supply tokens to the creator of the contract */
185     constructor() public {
186 
187         name = "Business Union Chain";
188         symbol = "BUB";
189         totalSupply = 1000000000 * 10 ** uint256(decimals);  // Update total supply with the decimal amount
190         balanceOf[msg.sender] = totalSupply;                // Give the creator all initial tokens
191 
192     }
193 
194     /// @notice Create `mintedAmount` tokens and send it to `target`
195     /// @param target Address to receive the tokens
196     /// @param mintedAmount the amount of tokens it will receive
197     function mintToken(address target, uint256 mintedAmount) onlyOwner public {
198         balanceOf[target] += mintedAmount;
199         totalSupply += mintedAmount;
200         emit Transfer(0, this, mintedAmount);
201         emit Transfer(this, target, mintedAmount);
202     }
203 
204     /// @notice `freeze? Prevent | Allow` `target` from sending & receiving tokens
205     /// @param target Address to be frozen
206     /// @param freeze either to freeze it or not
207     function freezeAccount(address target, bool freeze) onlyOwner public {
208         frozenAccount[target] = freeze;
209         emit FrozenFunds(target, freeze);
210     }
211 
212     /// @notice Allow users to buy tokens for `newBuyPrice` eth and sell tokens for `newSellPrice` eth
213     /// @param newSellPrice Price the users can sell to the contract
214     /// @param newBuyPrice Price users can buy from the contract
215     function setPrices(uint256 newSellPrice, uint256 newBuyPrice) onlyOwner public {
216         sellPrice = newSellPrice;
217         buyPrice = newBuyPrice;
218     }
219 
220     /// @notice Buy tokens from contract by sending ether
221     function buy() payable public {
222         uint amount = msg.value / buyPrice;               // calculates the amount
223         _transfer(this, msg.sender, amount);              // makes the transfers
224     }
225 
226     /// @notice Sell `amount` tokens to contract
227     /// @param amount amount of tokens to be sold
228     function sell(uint256 amount) public {
229         address myAddress = this;
230         require(myAddress.balance >= amount * sellPrice);      // checks if the contract has enough ether to buy
231         _transfer(msg.sender, this, amount);              // makes the transfers
232         msg.sender.transfer(amount * sellPrice);          // sends ether to the seller. It's important to do this last to avoid recursion attacks
233     }
234 }