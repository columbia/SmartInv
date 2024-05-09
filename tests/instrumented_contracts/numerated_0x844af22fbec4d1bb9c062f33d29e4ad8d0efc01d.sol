1 pragma solidity ^0.4.13;
2 
3 interface tokenRecipient { function receiveApproval(address _from, uint256 _value, address _token, bytes _extraData) external; }
4 
5 contract TokenERC20 {
6     // Public variables of the token
7     string public name;
8     string public symbol;
9     uint8 public decimals;
10     
11     uint256 public totalSupply;
12 
13     // This creates an array with all balances
14     mapping (address => uint256) public balanceOf;
15     mapping (address => mapping (address => uint256)) public allowance;
16 
17     // This generates a public event on the blockchain that will notify clients
18     event Transfer(address indexed from, address indexed to, uint256 value);
19 
20     // This notifies clients about the amount burnt
21     event Burn(address indexed from, uint256 value);
22 
23     /**
24      * Constrctor function
25      *
26      * Initializes contract with initial supply tokens to the creator of the contract
27      */
28     constructor (uint256 initialSupply, string tokenName, string tokenSymbol, uint8 _decimals) public {
29         decimals = _decimals;
30         totalSupply = initialSupply * 10 ** uint256(decimals);  // Update total supply with the decimal amount
31         emit Transfer(this, this, totalSupply);
32         balanceOf[this] = totalSupply;                      // Give the contract all initial tokens
33         name = tokenName;                                   // Set the name for display purposes
34         symbol = tokenSymbol;                               // Set the symbol for display purposes
35     }
36 
37     /**
38      * Internal transfer, only can be called by this contract
39      */
40     function _transfer(address _from, address _to, uint _value) internal {
41         require(_to != 0x0, "Prevent transfer to 0x0 address. Use burn() instead");
42         require(balanceOf[_from] >= _value, "Check if the sender has enough");
43         require(balanceOf[_to] + _value > balanceOf[_to], "Check for overflows");
44 
45         // Save this for an assertion in the future
46         uint previousBalances = balanceOf[_from] + balanceOf[_to];
47         // Subtract from the sender
48         balanceOf[_from] -= _value;
49         // Add the same to the recipient
50         balanceOf[_to] += _value;
51         emit Transfer(_from, _to, _value);
52         // Asserts are used to use static analysis to find bugs in your code. They should never fail
53         assert(balanceOf[_from] + balanceOf[_to] == previousBalances);
54     }
55 
56     /**
57      * Transfer tokens
58      *
59      * Send `_value` tokens to `_to` from your account
60      *
61      * @param _to The address of the recipient
62      * @param _value the amount to send
63      */
64     function transfer(address _to, uint256 _value) public {
65         _transfer(msg.sender, _to, _value);
66     }
67 
68     /**
69      * Transfer tokens from other address
70      *
71      * Send `_value` tokens to `_to` in behalf of `_from`
72      *
73      * @param _from The address of the sender
74      * @param _to The address of the recipient
75      * @param _value the amount to send
76      */
77     function transferFrom(address _from, address _to, uint256 _value) public returns (bool success) {
78         require(_value <= allowance[_from][msg.sender], "allowance too low");     // Check allowance
79         allowance[_from][msg.sender] -= _value;
80         _transfer(_from, _to, _value);
81         return true;
82     }
83 
84     /**
85      * Set allowance for other address
86      *
87      * Allows `_spender` to spend no more than `_value` tokens in your behalf
88      *
89      * @param _spender The address authorized to spend
90      * @param _value the max amount they can spend
91      */
92     function approve(address _spender, uint256 _value) public returns (bool success) {
93         allowance[msg.sender][_spender] = _value;
94         return true;
95     }
96 
97     /**
98      * Set allowance for other address and notify
99      *
100      * Allows `_spender` to spend no more than `_value` tokens in your behalf, and then ping the contract about it
101      *
102      * @param _spender The address authorized to spend
103      * @param _value the max amount they can spend
104      * @param _extraData some extra information to send to the approved contract
105      */
106     function approveAndCall(address _spender, uint256 _value, bytes _extraData) public returns (bool success) {
107         tokenRecipient spender = tokenRecipient(_spender);
108         if (approve(_spender, _value)) {
109             spender.receiveApproval(msg.sender, _value, this, _extraData);
110             return true;
111         }
112     }
113 
114     /**
115      * Destroy tokens
116      *
117      * Remove `_value` tokens from the system irreversibly
118      *
119      * @param _value the amount of money to burn
120      */
121     function burn(uint256 _value) public returns (bool success) {
122         require(balanceOf[msg.sender] >= _value, "balance insufficient");   // Check if the sender has enough
123         balanceOf[msg.sender] -= _value;            // Subtract from the sender
124         totalSupply -= _value;                      // Updates totalSupply
125         emit Burn(msg.sender, _value);
126         return true;
127     }
128 
129     /**
130      * Destroy tokens from other account
131      *
132      * Remove `_value` tokens from the system irreversibly on behalf of `_from`.
133      *
134      * @param _from the address of the sender
135      * @param _value the amount of money to burn
136      */
137     function burnFrom(address _from, uint256 _value) public returns (bool success) {
138         require(balanceOf[_from] >= _value, "balance insufficient"); // Check if the targeted balance is enough
139         require(_value <= allowance[_from][msg.sender], "allowance too low");    // Check allowance
140         balanceOf[_from] -= _value;                         // Subtract from the targeted balance
141         allowance[_from][msg.sender] -= _value;             // Subtract from the sender's allowance
142         totalSupply -= _value;                              // Update totalSupply
143         emit Burn(_from, _value);
144         return true;
145     }
146 }
147 
148 contract owned {
149     address public owner;
150 
151     constructor() public {
152         owner = msg.sender;
153     }
154 
155     modifier onlyOwner {
156         require(msg.sender == owner, "not the owner");
157         _;
158     }
159 
160     function transferOwnership(address newOwner) public onlyOwner {
161         owner = newOwner;
162     }
163 }
164 
165 contract Germoney is owned, TokenERC20 {
166 
167     uint256 public price;
168 
169     /* Initializes contract with initial supply tokens to the creator of the contract */
170     constructor (uint256 _price) TokenERC20(13000000000, "Germoney", "GER", 2) public {
171         require (_price > 0, "price can not be 0");
172         price = _price;
173     }
174 
175     /* Internal transfer, only can be called by this contract */
176     function _transfer(address _from, address _to, uint _value) internal {
177         require (_to != 0x0, "not allowed. Use burn instead");      
178         require (balanceOf[_from] >= _value, "balance insufficient");
179         require (balanceOf[_to] + _value > balanceOf[_to], "overflow detected");
180         balanceOf[_from] -= _value;                         // Subtract from the sender
181         balanceOf[_to] += _value;                           // Add the same to the recipient
182         emit Transfer(_from, _to, _value);
183     }
184 
185     function _buy(uint256 ethToBuy) internal {
186         uint amount = ethToBuy / price;               
187         _transfer(this, msg.sender, amount);     
188     }
189     /// @notice Buy tokens from contract by sending ether
190     function buy() public payable {
191         _buy(msg.value);      
192     }
193 
194     function() public payable {
195         _buy(msg.value);      
196     }
197 
198     function withdraw(address _to) external onlyOwner {
199         _to.transfer(address(this).balance);
200     }
201 }