1 pragma solidity ^0.4.16;
2 
3 interface tokenRecipient { function receiveApproval(address _from, uint256 _value, address _token, bytes _extraData) external; }
4 
5 contract EvolutionCoin {
6     // Public variables of the token
7     string public name;
8     string public symbol;
9     uint8 public decimals = 3;
10     // 3 decimals is the strongly suggested default, avoid changing it
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
24      * Constructor function
25      *
26      * Initializes contract with initial supply tokens to the creator of the contract
27      */
28     function TokenERC20(
29         uint256 initialSupply,
30         string tokenName,
31         string tokenSymbol
32     ) public {
33         totalSupply = 8000000;  // Update total supply with the decimal amount
34         balanceOf[msg.sender] = totalSupply;                // Give the creator all initial tokens
35         name = "EvolutionCoin";                                   // Set the name for display purposes
36         symbol = "ELC";                               // Set the symbol for display purposes
37     }
38 
39     /**
40      * Internal transfer, only can be called by this contract
41      */
42     function _transfer(address _from, address _to, uint _value) internal {
43         // Prevent transfer to 0x0 address. Use burn() instead
44         require(_to != 0x0);
45         // Check if the sender has enough
46         require(balanceOf[_from] >= _value);
47         // Check for overflows
48         require(balanceOf[_to] + _value >= balanceOf[_to]);
49         // Save this for an assertion in the future
50         uint previousBalances = balanceOf[_from] + balanceOf[_to];
51         // Subtract from the sender
52         balanceOf[_from] -= _value;
53         // Add the same to the recipient
54         balanceOf[_to] += _value;
55         // Asserts are used to use static analysis to find bugs in your code. They should never fail
56         assert(balanceOf[_from] + balanceOf[_to] == previousBalances);
57     }
58 
59     /**
60      * Transfer tokens
61      *
62      * Send `_value` tokens to `_to` from your account
63      *
64      * @param _to The address of the recipient
65      * @param _value the amount to send
66      */
67     function transfer(address _to, uint256 _value) public {
68         _transfer(msg.sender, _to, _value);
69     }
70 
71     /**
72      * Transfer tokens from other address
73      *
74      * Send `_value` tokens to `_to` on behalf of `_from`
75      *
76      * @param _from The address of the sender
77      * @param _to The address of the recipient
78      * @param _value the amount to send
79      */
80     function transferFrom(address _from, address _to, uint256 _value) public returns (bool success) {
81         require(_value <= allowance[_from][msg.sender]);     // Check allowance
82         allowance[_from][msg.sender] -= _value;
83         _transfer(_from, _to, _value);
84         return true;
85     }
86 
87     /**
88      * Set allowance for other address
89      *
90      * Allows `_spender` to spend no more than `_value` tokens on your behalf
91      *
92      * @param _spender The address authorized to spend
93      * @param _value the max amount they can spend
94      */
95     function approve(address _spender, uint256 _value) public
96         returns (bool success) {
97         allowance[msg.sender][_spender] = _value;
98         return true;
99     }
100 
101     /**
102      * Set allowance for other address and notify
103      *
104      * Allows `_spender` to spend no more than `_value` tokens on your behalf, and then ping the contract about it
105      *
106      * @param _spender The address authorized to spend
107      * @param _value the max amount they can spend
108      * @param _extraData some extra information to send to the approved contract
109      */
110     function approveAndCall(address _spender, uint256 _value, bytes _extraData)
111         public
112         returns (bool success) {
113         tokenRecipient spender = tokenRecipient(_spender);
114         if (approve(_spender, _value)) {
115             spender.receiveApproval(msg.sender, _value, this, _extraData);
116             return true;
117         }
118     }
119 
120     /**
121      * Destroy tokens
122      *
123      * Remove `_value` tokens from the system irreversibly
124      *
125      * @param _value the amount of money to burn
126      */
127     function burn(uint256 _value) public returns (bool success) {
128         require(balanceOf[msg.sender] >= _value);   // Check if the sender has enough
129         balanceOf[msg.sender] -= _value;            // Subtract from the sender
130         totalSupply -= _value;                      // Updates totalSupply
131         return true;
132     }
133 
134     /**
135      * Destroy tokens from other account
136      *
137      * Remove `_value` tokens from the system irreversibly on behalf of `_from`.
138      *
139      * @param _from the address of the sender
140      * @param _value the amount of money to burn
141      */
142     function burnFrom(address _from, uint256 _value) public returns (bool success) {
143         require(balanceOf[_from] >= _value);                // Check if the targeted balance is enough
144         require(_value <= allowance[_from][msg.sender]);    // Check allowance
145         balanceOf[_from] -= _value;                         // Subtract from the targeted balance
146         allowance[_from][msg.sender] -= _value;             // Subtract from the sender's allowance
147         totalSupply -= _value;                              // Update totalSupp
148         return true;
149     }
150 }