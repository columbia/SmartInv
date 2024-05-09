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
20 interface tokenRecipient { function receiveApproval(address _from, uint256 _value, address _token, bytes _extraData) public; }
21 
22 contract TokenSBT {
23     string public name;
24     string public symbol;
25     uint8 public decimals;
26     uint256 public totalSupply;
27 
28     mapping (address => uint256) public balanceOf;
29     mapping (address => mapping (address => uint256)) public allowance;
30 
31     event Transfer(address indexed from, address indexed to, uint256 value);
32 
33     event Burn(address indexed from, uint256 value);
34 
35     function TokenSBT() public {
36         decimals = 8;
37         totalSupply = 10000000000 * 10 ** uint256(decimals);  
38         balanceOf[msg.sender] = totalSupply;                
39         name = 'Sobit Token';                         
40         symbol = 'SBT';
41     }
42 
43     /**
44      * Internal transfer, only can be called by this contract
45      */
46     function _transfer(address _from, address _to, uint _value) internal {
47         require(_to != 0x0);
48         require(balanceOf[_from] >= _value);
49         require(balanceOf[_to] + _value > balanceOf[_to]);
50         uint previousBalances = balanceOf[_from] + balanceOf[_to];
51         balanceOf[_from] -= _value;
52         balanceOf[_to] += _value;
53         Transfer(_from, _to, _value);
54         assert(balanceOf[_from] + balanceOf[_to] == previousBalances);
55     }
56 
57     /**
58      * Transfer tokens
59      *
60      * Send `_value` tokens to `_to` from your account
61      *
62      * @param _to The address of the recipient
63      * @param _value the amount to send
64      */
65     function transfer(address _to, uint256 _value) public {
66         _transfer(msg.sender, _to, _value);
67     }
68 
69     /**
70      * Transfer tokens from other address
71      *
72      * Send `_value` tokens to `_to` in behalf of `_from`
73      *
74      * @param _from The address of the sender
75      * @param _to The address of the recipient
76      * @param _value the amount to send
77      */
78     function transferFrom(address _from, address _to, uint256 _value) public returns (bool success) {
79         require(_value <= allowance[_from][msg.sender]);   
80         allowance[_from][msg.sender] -= _value;
81         _transfer(_from, _to, _value);
82         return true;
83     }
84 
85     /**
86      * Set allowance for other address
87      *
88      * Allows `_spender` to spend no more than `_value` tokens in your behalf
89      *
90      * @param _spender The address authorized to spend
91      * @param _value the max amount they can spend
92      */
93     function approve(address _spender, uint256 _value) public
94         returns (bool success) {
95         allowance[msg.sender][_spender] = _value;
96         return true;
97     }
98 
99     /**
100      * Set allowance for other address and notify
101      *
102      * Allows `_spender` to spend no more than `_value` tokens in your behalf, and then ping the contract about it
103      *
104      * @param _spender The address authorized to spend
105      * @param _value the max amount they can spend
106      * @param _extraData some extra information to send to the approved contract
107      */
108     function approveAndCall(address _spender, uint256 _value, bytes _extraData)
109         public
110         returns (bool success) {
111         tokenRecipient spender = tokenRecipient(_spender);
112         if (approve(_spender, _value)) {
113             spender.receiveApproval(msg.sender, _value, this, _extraData);
114             return true;
115         }
116     }
117 
118     /**
119      * Destroy tokens
120      *
121      * Remove `_value` tokens from the system irreversibly
122      *
123      * @param _value the amount of money to burn
124      */
125     function burn(uint256 _value) public returns (bool success) {
126         require(balanceOf[msg.sender] >= _value);   // Check if the sender has enough
127         balanceOf[msg.sender] -= _value;            // Subtract from the sender
128         totalSupply -= _value;                      // Updates totalSupply
129         Burn(msg.sender, _value);
130         return true;
131     }
132 
133     /**
134      * Destroy tokens from other account
135      *
136      * Remove `_value` tokens from the system irreversibly on behalf of `_from`.
137      *
138      * @param _from the address of the sender
139      * @param _value the amount of money to burn
140      */
141     function burnFrom(address _from, uint256 _value) public returns (bool success) {
142         require(balanceOf[_from] >= _value);                // Check if the targeted balance is enough
143         require(_value <= allowance[_from][msg.sender]);    // Check allowance
144         balanceOf[_from] -= _value;                         // Subtract from the targeted balance
145         allowance[_from][msg.sender] -= _value;             // Subtract from the sender's allowance
146         totalSupply -= _value;                              // Update totalSupply
147         Burn(_from, _value);
148         return true;
149     }
150 }
151 
152 
153 
154 contract MyShareToken is owned, TokenSBT{
155 
156     uint256 public sellPrice;
157     uint256 public buyPrice;
158 
159     mapping (address => bool) public frozenAccount;
160 
161     /* This generates a public event on the blockchain that will notify clients */
162     event FrozenFunds(address target, bool frozen);
163 
164     /* Initializes contract with initial supply tokens to the creator of the contract */
165     function MyShareToken() TokenSBT() public {}
166 
167     /* Internal transfer, only can be called by this contract */
168     function _transfer(address _from, address _to, uint _value) internal {
169         require (_to != 0x0);                               // Prevent transfer to 0x0 address. Use burn() instead
170         require (balanceOf[_from] >= _value);               // Check if the sender has enough
171         require (balanceOf[_to] + _value > balanceOf[_to]); // Check for overflows
172         require(!frozenAccount[_from]);                     // Check if sender is frozen
173         require(!frozenAccount[_to]);                       // Check if recipient is frozen
174         balanceOf[_from] -= _value;                         // Subtract from the sender
175         balanceOf[_to] += _value;                           // Add the same to the recipient
176         Transfer(_from, _to, _value);
177     }
178 
179     /// @notice Create `mintedAmount` tokens and send it to `target`
180     /// @param target Address to receive the tokens
181     /// @param mintedAmount the amount of tokens it will receive
182     function mintToken(address target, uint256 mintedAmount) onlyOwner public {
183         balanceOf[target] += mintedAmount;
184         totalSupply += mintedAmount;
185         Transfer(0, this, mintedAmount);
186         Transfer(this, target, mintedAmount);
187     }
188 
189     /// @notice `freeze? Prevent | Allow` `target` from sending & receiving tokens
190     /// @param target Address to be frozen
191     /// @param freeze either to freeze it or not
192     function freezeAccount(address target, bool freeze) onlyOwner public {
193         frozenAccount[target] = freeze;
194         FrozenFunds(target, freeze);
195     }
196 
197     /// @notice Allow users to buy tokens for `newBuyPrice` eth and sell tokens for `newSellPrice` eth
198     /// @param newSellPrice Price the users can sell to the contract
199     /// @param newBuyPrice Price users can buy from the contract
200     function setPrices(uint256 newSellPrice, uint256 newBuyPrice) onlyOwner public {
201         sellPrice = newSellPrice;
202         buyPrice = newBuyPrice;
203     }
204 
205     /// @notice Buy tokens from contract by sending ether
206     function buy() payable public {
207         uint amount = msg.value / buyPrice;          
208         _transfer(this, msg.sender, amount);
209     }
210 
211     /// @notice Sell `amount` tokens to contract
212     /// @param amount amount of tokens to be sold
213     function sell(uint256 amount) public {
214         require(this.balance >= amount * sellPrice); 
215         _transfer(msg.sender, this, amount);    
216         msg.sender.transfer(amount * sellPrice); 
217     }
218 }