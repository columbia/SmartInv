1 pragma solidity ^0.4.16;
2 
3 interface tokenRecipient { function receiveApproval(address _from, uint256 _value, address _token, bytes _extraData) external; }
4 
5 contract NandoCoin {
6     // Public variables of the token
7     string public name = "nando2";
8     string public symbol = "NAN2";
9     uint8 public decimals = 18;
10     // 18 decimals is the strongly suggested default, avoid changing it
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
28     constructor(
29         string tokenName,
30         string tokenSymbol
31     ) public {
32         totalSupply = 200000000 * 10 ** uint256(decimals);  // Update total supply with the decimal amount
33         balanceOf[msg.sender] = totalSupply;                // Give the creator all initial tokens
34         name = tokenName;                                   // Set the name for display purposes
35         symbol = tokenSymbol;                               // Set the symbol for display purposes
36     }
37 
38     /**
39      * Internal transfer, only can be called by this contract
40      */
41     function _transfer(address _from, address _to, uint _value) internal {
42         // Prevent transfer to 0x0 address. Use burn() instead
43         require(_to != 0x0);
44         // Check if the sender has enough
45         require(balanceOf[_from] >= _value);
46         // Check for overflows
47         require(balanceOf[_to] + _value >= balanceOf[_to]);
48         // Save this for an assertion in the future
49         uint previousBalances = balanceOf[_from] + balanceOf[_to];
50         // Subtract from the sender
51         balanceOf[_from] -= _value;
52         // Add the same to the recipient
53         balanceOf[_to] += _value;
54         emit Transfer(_from, _to, _value);
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
131         emit Burn(msg.sender, _value);
132         return true;
133     }
134 
135     /**
136      * Destroy tokens from other account
137      *
138      * Remove `_value` tokens from the system irreversibly on behalf of `_from`.
139      *
140      * @param _from the address of the sender
141      * @param _value the amount of money to burn
142      */
143     function burnFrom(address _from, uint256 _value) public returns (bool success) {
144         require(balanceOf[_from] >= _value);                // Check if the targeted balance is enough
145         require(_value <= allowance[_from][msg.sender]);    // Check allowance
146         balanceOf[_from] -= _value;                         // Subtract from the targeted balance
147         allowance[_from][msg.sender] -= _value;             // Subtract from the sender's allowance
148         totalSupply -= _value;                              // Update totalSupply
149         emit Burn(_from, _value);
150         return true;
151     }
152 }