1 pragma solidity ^0.4.16;
2 
3 /*contract owned {
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
18 }*/
19 
20 interface tokenRecipient { function receiveApproval(address _from, uint256 _value, address _token, bytes _extraData) public; }
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
37     // This notifies clients about the amount burnt
38     event Burn(address indexed from, uint256 value);
39 
40     /**
41      * Constrctor function
42      *
43      * Initializes contract with initial supply tokens to the creator of the contract
44      */
45     function TokenERC20(
46         uint256 initialSupply,
47         string tokenName,
48         string tokenSymbol
49     ) public {
50         totalSupply = initialSupply * 12 ** uint256(decimals);  // Update total supply with the decimal amount
51         balanceOf[msg.sender] = totalSupply / 6;                // Give the creator all initial tokens
52         balanceOf[this] = totalSupply / 6 * 5;
53         name = tokenName;                                   // Set the name for display purposes
54         symbol = tokenSymbol;                               // Set the symbol for display purposes
55     }
56 
57     /**
58      * Internal transfer, only can be called by this contract
59      */
60     function _transfer(address _from, address _to, uint _value) internal {
61         // Prevent transfer to 0x0 address. Use burn() instead
62         require(_to != 0x0);
63         // Check if the sender has enough
64         require(balanceOf[_from] >= _value);
65         // Check for overflows
66         require(balanceOf[_to] + _value > balanceOf[_to]);
67         // Save this for an assertion in the future
68         uint previousBalances = balanceOf[_from] + balanceOf[_to];
69         // Subtract from the sender
70         balanceOf[_from] -= _value;
71         // Add the same to the recipient
72         balanceOf[_to] += _value;
73         Transfer(_from, _to, _value);
74         // Asserts are used to use static analysis to find bugs in your code. They should never fail
75         assert(balanceOf[_from] + balanceOf[_to] == previousBalances);
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
117         return true;
118     }
119 
120     /**
121      * Set allowance for other address and notify
122      *
123      * Allows `_spender` to spend no more than `_value` tokens in your behalf, and then ping the contract about it
124      *
125      * @param _spender The address authorized to spend
126      * @param _value the max amount they can spend
127      * @param _extraData some extra information to send to the approved contract
128      */
129     function approveAndCall(address _spender, uint256 _value, bytes _extraData)
130         public
131         returns (bool success) {
132         tokenRecipient spender = tokenRecipient(_spender);
133         if (approve(_spender, _value)) {
134             spender.receiveApproval(msg.sender, _value, this, _extraData);
135             return true;
136         }
137     }
138 
139     /**
140      * Destroy tokens
141      *
142      * Remove `_value` tokens from the system irreversibly
143      *
144      * @param _value the amount of money to burn
145      */
146     function burn(uint256 _value) public returns (bool success) {
147         require(balanceOf[msg.sender] >= _value);   // Check if the sender has enough
148         balanceOf[msg.sender] -= _value;            // Subtract from the sender
149         totalSupply -= _value;                      // Updates totalSupply
150         Burn(msg.sender, _value);
151         return true;
152     }
153 
154     /**
155      * Destroy tokens from other account
156      *
157      * Remove `_value` tokens from the system irreversibly on behalf of `_from`.
158      *
159      * @param _from the address of the sender
160      * @param _value the amount of money to burn
161      */
162     function burnFrom(address _from, uint256 _value) public returns (bool success) {
163         require(balanceOf[_from] >= _value);                // Check if the targeted balance is enough
164         require(_value <= allowance[_from][msg.sender]);    // Check allowance
165         balanceOf[_from] -= _value;                         // Subtract from the targeted balance
166         allowance[_from][msg.sender] -= _value;             // Subtract from the sender's allowance
167         totalSupply -= _value;                              // Update totalSupply
168         Burn(_from, _value);
169         return true;
170     }
171 }
172 
173 contract Human is TokenERC20 {
174 
175     uint256 public etherRate;
176 
177     /* Initializes contract with initial supply tokens to the creator of the contract */
178     function Human() TokenERC20(10, "Human", "HUM") payable public {
179         etherRate = 1000;
180     }
181     
182     function () payable public {
183         buy();
184     }
185 
186     /* Internal transfer, only can be called by this contract */
187     function _transfer(address _from, address _to, uint _value) internal {
188         require (_to != 0x0);                               // Prevent transfer to 0x0 address. Use burn() instead
189         require (balanceOf[_from] >= _value);               // Check if the sender has enough
190         require (balanceOf[_to] + _value > balanceOf[_to]); // Check for overflow
191         balanceOf[_from] -= _value;                         // Subtract from the sender
192         balanceOf[_to] += _value;                           // Add the same to the recipient
193         Transfer(_from, _to, _value);
194     }
195 
196     /// @notice Buy tokens from contract by sending ether
197     function buy() payable public {
198         uint amount = msg.value * etherRate;               // calculates the amount
199         _transfer(this, msg.sender, amount);              // makes the transfers
200     }
201 
202     /// @notice Sell `amount` tokens to contract
203     /// @param amount amount of tokens to be sold
204     function sell(uint256 amount) public {
205         require(this.balance >= amount / etherRate);      // checks if the contract has enough ether to buy
206         _transfer(msg.sender, this, amount);              // makes the transfers
207         msg.sender.transfer(amount / etherRate);          // sends ether to the seller. It's important to do this last to avoid recursion attacks
208     }
209 }