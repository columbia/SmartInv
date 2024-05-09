1 pragma solidity ^0.4.16;
2 
3 interface tokenRecipient { function receiveApproval(address _from, uint256 _value, address _token, bytes _extraData) external; }
4 
5 contract FowinToken {
6     string public name;
7     string public symbol;
8     uint8 public decimals = 18;
9     uint256 public totalSupply;
10 
11     mapping (address => uint256) public balanceOf;
12     mapping (address => mapping (address => uint256)) public allowance;
13 
14     // This generates a public event on the blockchain that will notify clients
15     event Transfer(address indexed from, address indexed to, uint256 value);
16 
17     // This notifies clients about the amount burnt
18     event Burn(address indexed from, uint256 value);
19 
20     /**
21      * Constrctor function
22      *
23      * Initializes contract with initial supply tokens to the creator of the contract
24      */
25     constructor(
26         uint256 initialSupply,
27         string tokenName,
28         string tokenSymbol
29     ) public {
30         totalSupply = initialSupply * 10 ** uint256(decimals);  // Update total supply with the decimal amount
31         balanceOf[msg.sender] = totalSupply;                // Give the creator all initial tokens
32         name = tokenName;                                   // Set the name for display purposes
33         symbol = tokenSymbol;                               // Set the symbol for display purposes
34     }
35 
36     /**
37      * Internal transfer, only can be called by this contract
38      */
39     function _transfer(address _from, address _to, uint _value) internal {
40         // Prevent transfer to 0x0 address. Use burn() instead
41         require(_to != 0x0);
42         // Check if the sender has enough
43         require(balanceOf[_from] >= _value);
44         // Check for overflows
45         require(balanceOf[_to] + _value > balanceOf[_to]);
46         // Save this for an assertion in the future
47         uint previousBalances = balanceOf[_from] + balanceOf[_to];
48         // Subtract from the sender
49         balanceOf[_from] -= _value;
50         // Add the same to the recipient
51         balanceOf[_to] += _value;
52         emit Transfer(_from, _to, _value);
53         // Asserts are used to use static analysis to find bugs in your code. They should never fail
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
79         require(_value <= allowance[_from][msg.sender]);     // Check allowance
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
129         emit Burn(msg.sender, _value);
130         return true;
131     }
132 
133     /**
134      * Destroy tokens from other ccount
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
147         emit Burn(_from, _value);
148         return true;
149     }
150 }