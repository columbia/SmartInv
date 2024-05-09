1 pragma solidity ^0.4.20;
2 
3 /******************************************/
4 /*       Netkiller ADVANCED TOKEN         */
5 /******************************************/
6 /* Author netkiller <netkiller@msn.com>   */
7 /* Home http://www.netkiller.cn           */
8 /* Version 2018-03-05                     */
9 /******************************************/
10 
11 interface tokenRecipient { function receiveApproval(address _from, uint256 _value, address _token, bytes _extraData) public; }
12 
13 contract NetkillerAdvancedToken {
14     address public owner;
15     // Public variables of the token
16     string public name;
17     string public symbol;
18     uint8 public decimals = 18;
19     // 18 decimals is the strongly suggested default, avoid changing it
20     uint256 public totalSupply;
21     
22     uint256 public sellPrice;
23     uint256 public buyPrice;
24 
25     // This creates an array with all balances
26     mapping (address => uint256) public balanceOf;
27     mapping (address => mapping (address => uint256)) public allowance;
28 
29     // This generates a public event on the blockchain that will notify clients
30     event Transfer(address indexed from, address indexed to, uint256 value);
31 
32     // This notifies clients about the amount burnt
33     event Burn(address indexed from, uint256 value);
34     event Approval(address indexed owner, address indexed spender, uint256 value);
35     
36     mapping (address => bool) public frozenAccount;
37 
38     /* This generates a public event on the blockchain that will notify clients */
39     event FrozenFunds(address target, bool frozen);
40 
41     /**
42      * Constrctor function
43      *
44      * Initializes contract with initial supply tokens to the creator of the contract
45      */
46     function NetkillerAdvancedToken(
47         uint256 initialSupply,
48         string tokenName,
49         string tokenSymbol
50     ) public {
51         owner = msg.sender;
52         totalSupply = initialSupply * 10 ** uint256(decimals);  // Update total supply with the decimal amount
53         balanceOf[msg.sender] = totalSupply;                // Give the creator all initial tokens
54         name = tokenName;                                   // Set the name for display purposes
55         symbol = tokenSymbol;                               // Set the symbol for display purposes
56     }
57 
58     modifier onlyOwner {
59         require(msg.sender == owner);
60         _;
61     }
62     function transferOwnership(address newOwner) onlyOwner public {
63         owner = newOwner;
64     }
65  
66     /* Internal transfer, only can be called by this contract */
67     function _transfer(address _from, address _to, uint _value) internal {
68         require (_to != 0x0);                               // Prevent transfer to 0x0 address. Use burn() instead
69         require (balanceOf[_from] >= _value);               // Check if the sender has enough
70         require (balanceOf[_to] + _value > balanceOf[_to]); // Check for overflows
71         require(!frozenAccount[_from]);                     // Check if sender is frozen
72         require(!frozenAccount[_to]);                       // Check if recipient is frozen
73         balanceOf[_from] -= _value;                         // Subtract from the sender
74         balanceOf[_to] += _value;                           // Add the same to the recipient
75         Transfer(_from, _to, _value);
76     }
77 
78     /**
79      * Transfer tokens
80      *
81      * Send `_value` tokens to `_to` from your account
82      *
83      * @param _to The address of the recipient
84      * @param _value the amount to send
85      */
86     function transfer(address _to, uint256 _value) public {
87         _transfer(msg.sender, _to, _value);
88     }
89 
90     /**
91      * Transfer tokens from other address
92      *
93      * Send `_value` tokens to `_to` in behalf of `_from`
94      *
95      * @param _from The address of the sender
96      * @param _to The address of the recipient
97      * @param _value the amount to send
98      */
99     function transferFrom(address _from, address _to, uint256 _value) public returns (bool success) {
100         require(_value <= allowance[_from][msg.sender]);     // Check allowance
101         allowance[_from][msg.sender] -= _value;
102         _transfer(_from, _to, _value);
103         return true;
104     }
105 
106     /**
107      * Set allowance for other address
108      *
109      * Allows `_spender` to spend no more than `_value` tokens in your behalf
110      *
111      * @param _spender The address authorized to spend
112      * @param _value the max amount they can spend
113      */
114     function approve(address _spender, uint256 _value) public
115         returns (bool success) {
116         allowance[msg.sender][_spender] = _value;
117         Approval(msg.sender, _spender, _value);
118         return true;
119     }
120 
121     /**
122      * Set allowance for other address and notify
123      *
124      * Allows `_spender` to spend no more than `_value` tokens in your behalf, and then ping the contract about it
125      *
126      * @param _spender The address authorized to spend
127      * @param _value the max amount they can spend
128      * @param _extraData some extra information to send to the approved contract
129      */
130     function approveAndCall(address _spender, uint256 _value, bytes _extraData)
131         public
132         returns (bool success) {
133         tokenRecipient spender = tokenRecipient(_spender);
134         if (approve(_spender, _value)) {
135             spender.receiveApproval(msg.sender, _value, this, _extraData);
136             return true;
137         }
138     }
139 
140     /**
141      * Destroy tokens
142      *
143      * Remove `_value` tokens from the system irreversibly
144      *
145      * @param _value the amount of money to burn
146      */
147     function burn(uint256 _value) onlyOwner public returns (bool success) {
148         require(balanceOf[msg.sender] >= _value);   // Check if the sender has enough
149         balanceOf[msg.sender] -= _value;            // Subtract from the sender
150         totalSupply -= _value;                      // Updates totalSupply
151         Burn(msg.sender, _value);
152         return true;
153     }
154 
155     /**
156      * Destroy tokens from other account
157      *
158      * Remove `_value` tokens from the system irreversibly on behalf of `_from`.
159      *
160      * @param _from the address of the sender
161      * @param _value the amount of money to burn
162      */
163     function burnFrom(address _from, uint256 _value) onlyOwner public returns (bool success) {
164         require(balanceOf[_from] >= _value);                // Check if the targeted balance is enough
165         require(_value <= allowance[_from][msg.sender]);    // Check allowance
166         balanceOf[_from] -= _value;                         // Subtract from the targeted balance
167         allowance[_from][msg.sender] -= _value;             // Subtract from the sender's allowance
168         totalSupply -= _value;                              // Update totalSupply
169         Burn(_from, _value);
170         return true;
171     }
172 
173     /// @notice Create `mintedAmount` tokens and send it to `target`
174     /// @param target Address to receive the tokens
175     /// @param mintedAmount the amount of tokens it will receive
176     function mintToken(address target, uint256 mintedAmount) onlyOwner public {
177         balanceOf[target] += mintedAmount;
178         totalSupply += mintedAmount;
179         Transfer(0, this, mintedAmount);
180         Transfer(this, target, mintedAmount);
181     }
182 
183     /// @notice `freeze? Prevent | Allow` `target` from sending & receiving tokens
184     /// @param target Address to be frozen
185     /// @param freeze either to freeze it or not
186     function freezeAccount(address target, bool freeze) onlyOwner public {
187         frozenAccount[target] = freeze;
188         FrozenFunds(target, freeze);
189     }
190 
191     /// @notice Allow users to buy tokens for `newBuyPrice` eth and sell tokens for `newSellPrice` eth
192     /// @param newSellPrice Price the users can sell to the contract
193     /// @param newBuyPrice Price users can buy from the contract
194     function setPrices(uint256 newSellPrice, uint256 newBuyPrice) onlyOwner public {
195         sellPrice = newSellPrice;
196         buyPrice = newBuyPrice;
197     }
198 
199     /// @notice Buy tokens from contract by sending ether
200     function buy() payable public {
201         uint amount = msg.value / buyPrice;               // calculates the amount
202         _transfer(this, msg.sender, amount);              // makes the transfers
203     }
204 
205     /// @notice Sell `amount` tokens to contract
206     /// @param amount amount of tokens to be sold
207     function sell(uint256 amount) public {
208         require(this.balance >= amount * sellPrice);      // checks if the contract has enough ether to buy
209         _transfer(msg.sender, this, amount);              // makes the transfers
210         msg.sender.transfer(amount * sellPrice);          // sends ether to the seller. It's important to do this last to avoid recursion attacks
211     }
212     
213   function transfer(address _to, uint256 _value, bytes _data) public returns (bool) {
214     require(_to != address(this));
215     transfer(_to, _value);
216     require(_to.call(_data));
217     return true;
218   }
219 
220   function transferFrom(address _from, address _to, uint256 _value, bytes _data) public returns (bool) {
221     require(_to != address(this));
222 
223     transferFrom(_from, _to, _value);
224 
225     require(_to.call(_data));
226     return true;
227   }
228 
229   function approve(address _spender, uint256 _value, bytes _data) public returns (bool) {
230     require(_spender != address(this));
231 
232     approve(_spender, _value);
233 
234     require(_spender.call(_data));
235 
236     return true;
237   }
238     
239 }