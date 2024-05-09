1 pragma solidity ^0.4.21;
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
20 contract TokenERC20 is owned {
21     // Public variables of the token
22     string public name;
23     string public symbol;
24     uint8 public decimals = 18;
25     // 18 decimals is the strongly suggested default, avoid changing it
26     uint256 public totalSupply;
27 
28     // This creates an array with all balances
29     mapping (address => uint256) public balanceOf;
30     mapping (address => mapping (address => uint256)) public allowance;
31 
32     // This generates a public event on the blockchain that will notify clients
33     event Transfer(address indexed from, address indexed to, uint256 value);
34 
35     // This notifies clients about the amount burnt
36     event Burn(address indexed from, uint256 value);
37 
38     /**
39      * Constrctor function
40      *
41      * Initializes contract with initial supply tokens to the creator of the contract
42      */
43     function TokenERC20() public {
44         totalSupply = 20000000000000000000000000;  // Update total supply with the decimal amount
45         balanceOf[msg.sender] = totalSupply;                // Give the creator all initial tokens
46         name = "MSX";                                   // Set the name for display purposes
47         symbol = "Missimx.com Dollar";                               // Set the symbol for display purposes
48     }
49 
50     /**
51      * Internal transfer, only can be called by this contract
52      */
53     function _transfer(address _from, address _to, uint _value) internal {
54         // Prevent transfer to 0x0 address. Use burn() instead
55         require(_to != 0x0);
56         // Check if the sender has enough
57         require(balanceOf[_from] >= _value);
58         // Check for overflows
59         require(balanceOf[_to] + _value > balanceOf[_to]);
60         // Save this for an assertion in the future
61         uint previousBalances = balanceOf[_from] + balanceOf[_to];
62         // Subtract from the sender
63         balanceOf[_from] -= _value;
64         // Add the same to the recipient
65         balanceOf[_to] += _value;
66         emit Transfer(_from, _to, _value);
67         // Asserts are used to use static analysis to find bugs in your code. They should never fail
68         assert(balanceOf[_from] + balanceOf[_to] == previousBalances);
69     }
70 
71     /**
72      * Transfer tokens
73      *
74      * Send `_value` tokens to `_to` from your account
75      *
76      * @param _to The address of the recipient
77      * @param _value the amount to send
78      */
79     function transfer(address _to, uint256 _value) onlyOwner public {
80         _transfer(msg.sender, _to, _value);
81     }
82 
83     /**
84      * Transfer tokens from other address
85      *
86      * Send `_value` tokens to `_to` in behalf of `_from`
87      *
88      * @param _from The address of the sender
89      * @param _to The address of the recipient
90      * @param _value the amount to send
91      */
92     function transferFrom(address _from, address _to, uint256 _value) onlyOwner public returns (bool success) {
93         require(_value <= allowance[_from][msg.sender]);     // Check allowance
94         allowance[_from][msg.sender] -= _value;
95         _transfer(_from, _to, _value);
96         return true;
97     }
98 
99     /**
100      * Set allowance for other address
101      *
102      * Allows `_spender` to spend no more than `_value` tokens in your behalf
103      *
104      * @param _spender The address authorized to spend
105      * @param _value the max amount they can spend
106      */
107     function approve(address _spender, uint256 _value) onlyOwner public
108         returns (bool success) {
109         allowance[msg.sender][_spender] = _value;
110         return true;
111     }
112 
113     /**
114      * Destroy tokens
115      *
116      * Remove `_value` tokens from the system irreversibly
117      *
118      * @param _value the amount of money to burn
119      */
120     function burn(uint256 _value) onlyOwner public returns (bool success) {
121         require(balanceOf[msg.sender] >= _value);   // Check if the sender has enough
122         balanceOf[msg.sender] -= _value;            // Subtract from the sender
123         totalSupply -= _value;                      // Updates totalSupply
124         emit Burn(msg.sender, _value);
125         return true;
126     }
127 
128     /**
129      * Destroy tokens from other account
130      *
131      * Remove `_value` tokens from the system irreversibly on behalf of `_from`.
132      *
133      * @param _from the address of the sender
134      * @param _value the amount of money to burn
135      */
136     function burnFrom(address _from, uint256 _value) onlyOwner public returns (bool success) {
137         require(balanceOf[_from] >= _value);                // Check if the targeted balance is enough
138         require(_value <= allowance[_from][msg.sender]);    // Check allowance
139         balanceOf[_from] -= _value;                         // Subtract from the targeted balance
140         allowance[_from][msg.sender] -= _value;             // Subtract from the sender's allowance
141         totalSupply -= _value;                              // Update totalSupply
142         emit Burn(_from, _value);
143         return true;
144     }
145     
146     /// @notice Create `mintedAmount` tokens and send it to `target`
147     /// @param target Address to receive the tokens
148     /// @param mintedAmount the amount of tokens it will receive
149     function mintToken(address target, uint256 mintedAmount)  onlyOwner public {
150         balanceOf[target] += mintedAmount;
151         totalSupply += mintedAmount;
152         emit Transfer(0, this, mintedAmount);
153         emit Transfer(this, target, mintedAmount);
154     }
155     
156     mapping (address => bool) public frozenAccount;
157 
158     /* This generates a public event on the blockchain that will notify clients */
159     event FrozenFunds(address target, bool frozen);
160     
161     /* Internal transfer, only can be called by this contract */
162     /* function _transfer(address _from, address _to, uint _value) internal {
163         require (_to != 0x0);                               // Prevent transfer to 0x0 address. Use burn() instead
164         require (balanceOf[_from] >= _value);               // Check if the sender has enough
165         require (balanceOf[_to] + _value >= balanceOf[_to]); // Check for overflows
166         require(!frozenAccount[_from]);                     // Check if sender is frozen
167         require(!frozenAccount[_to]);                       // Check if recipient is frozen
168         balanceOf[_from] -= _value;                         // Subtract from the sender
169         balanceOf[_to] += _value;                           // Add the same to the recipient
170         emit Transfer(_from, _to, _value);
171     } */
172     
173     /// @notice `freeze? Prevent | Allow` `target` from sending & receiving tokens
174     /// @param target Address to be frozen
175     /// @param freeze either to freeze it or not
176     function freezeAccount(address target, bool freeze) onlyOwner public {
177         frozenAccount[target] = freeze;
178         emit FrozenFunds(target, freeze);
179     }
180     
181     uint256 public sellPrice;
182     uint256 public buyPrice;
183     
184     /// @notice Buy tokens from contract by sending ether
185     function buy() payable onlyOwner public {
186         uint amount = msg.value / buyPrice;               // calculates the amount
187         _transfer(this, msg.sender, amount);              // makes the transfers
188     }
189 
190     /// @notice Sell `amount` tokens to contract
191     /// @param amount amount of tokens to be sold
192     function sell(uint256 amount) onlyOwner public {
193         address myAddress = this;
194         require(myAddress.balance >= amount * sellPrice);      // checks if the contract has enough ether to buy
195         _transfer(msg.sender, this, amount);              // makes the transfers
196         msg.sender.transfer(amount * sellPrice);          // sends ether to the seller. It's important to do this last to avoid recursion attacks
197     }
198 }