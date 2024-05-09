1 pragma solidity ^0.4.16;
2 interface tokenRecipient { function receiveApproval(address _from, uint256 _value, address _token, bytes _extraData) public; }
3 contract Fpgcchain{
4     // Public variables of the token
5     string public name;
6     string public symbol;
7     uint8 public decimals = 18;
8     // 18 decimals is the strongly suggested default, avoid changing it
9     uint256 public totalSupply;
10 
11     // This creates an array with all balances
12     mapping (address => uint256) public balanceOf;
13     mapping (address => mapping (address => uint256)) public allowance;
14 
15     // This generates a public event on the blockchain that will notify clients
16     event Transfer(address indexed from, address indexed to, uint256 value);
17 
18     // This notifies clients about the amount burnt
19     event Burn(address indexed from, uint256 value);
20 
21     /**
22      * Constrctor function
23      *
24      * Initializes contract with initial supply tokens to the creator of the contract
25      */
26     function Fpgcchain(
27         uint256 initialSupply,
28         string tokenName,
29         string tokenSymbol
30     ) public {
31         totalSupply = initialSupply * 10 ** uint256(decimals);  // Update total supply with the decimal amount
32         balanceOf[msg.sender] = totalSupply;                // Give the creator all initial tokens
33         name = tokenName;                                   // Set the name for display purposes
34         symbol = tokenSymbol;                               // Set the symbol for display purposes
35     }
36 
37     /**
38      * Internal transfer, only can be called by this contract
39      */
40     function _transfer(address _from, address _to, uint _value) internal {
41         // Prevent transfer to 0x0 address. Use burn() instead
42         require(_to != 0x0);
43         // Check if the sender has enough
44         require(balanceOf[_from] >= _value);
45         // Check for overflows
46         require(balanceOf[_to] + _value > balanceOf[_to]);
47         // Save this for an assertion in the future
48         uint previousBalances = balanceOf[_from] + balanceOf[_to];
49         // Subtract from the sender
50         balanceOf[_from] -= _value;
51         // Add the same to the recipient
52         balanceOf[_to] += _value;
53         Transfer(_from, _to, _value);
54         // Asserts are used to use static analysis to find bugs in your code. They should never fail
55         assert(balanceOf[_from] + balanceOf[_to] == previousBalances);
56     }
57 
58     /**
59      * Transfer tokens
60      *
61      * Send `_value` tokens to `_to` from your account
62      *
63      * @param _to The address of the recipient
64      * @param _value the amount to send
65      */
66     function transfer(address _to, uint256 _value) public {
67         _transfer(msg.sender, _to, _value);
68     }
69 
70     /**
71      * Transfer tokens from other address
72      *
73      * Send `_value` tokens to `_to` in behalf of `_from`
74      *
75      * @param _from The address of the sender
76      * @param _to The address of the recipient
77      * @param _value the amount to send
78      */
79     function transferFrom(address _from, address _to, uint256 _value) public returns (bool success) {
80         require(_value <= allowance[_from][msg.sender]);     // Check allowance
81         allowance[_from][msg.sender] -= _value;
82         _transfer(_from, _to, _value);
83         return true;
84     }
85 
86     /**
87      * Set allowance for other address
88      *
89      * Allows `_spender` to spend no more than `_value` tokens in your behalf
90      *
91      * @param _spender The address authorized to spend
92      * @param _value the max amount they can spend
93      */
94     function approve(address _spender, uint256 _value) public
95         returns (bool success) {
96         allowance[msg.sender][_spender] = _value;
97         return true;
98     }
99 
100     /**
101      * Set allowance for other address and notify
102      *
103      * Allows `_spender` to spend no more than `_value` tokens in your behalf, and then ping the contract about it
104      *
105      * @param _spender The address authorized to spend
106      * @param _value the max amount they can spend
107      * @param _extraData some extra information to send to the approved contract
108      */
109     function approveAndCall(address _spender, uint256 _value, bytes _extraData)
110         public
111         returns (bool success) {
112         tokenRecipient spender = tokenRecipient(_spender);
113         if (approve(_spender, _value)) {
114             spender.receiveApproval(msg.sender, _value, this, _extraData);
115             return true;
116         }
117     }
118 
119     /**
120      * Destroy tokens
121      *
122      * Remove `_value` tokens from the system irreversibly
123      *
124      * @param _value the amount of money to burn
125      */
126     function burn(uint256 _value) public returns (bool success) {
127         require(balanceOf[msg.sender] >= _value);   // Check if the sender has enough
128         balanceOf[msg.sender] -= _value;            // Subtract from the sender
129         totalSupply -= _value;                      // Updates totalSupply
130         Burn(msg.sender, _value);
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
147         totalSupply -= _value;                              // Update totalSupply
148         Burn(_from, _value);
149         return true;
150     }
151 }