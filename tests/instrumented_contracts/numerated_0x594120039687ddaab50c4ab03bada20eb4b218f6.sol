1 pragma solidity ^0.4.19;
2 interface tokenRecipient { function receiveApproval(address _from, uint256 _value, address _token, bytes _extraData) public; }
3 contract GMVToken {
4     // Public variables of the token
5     string public name;
6     string public symbol;
7     uint8 public decimals = 8;
8     uint256 public totalSupply;
9 
10     //creates an array with all balances
11     mapping (address => uint256) public balanceOf;
12     mapping (address => mapping (address => uint256)) public allowance;
13 
14     // generates a public event on the blockchain that will notify clients
15     event Transfer(address indexed from, address indexed to, uint256 value);
16 
17     // This notifies clients about the amount burnt
18     event Burn(address indexed from, uint256 value);
19 
20     /**
21      * Constrctor function
22      */
23     function GMVToken() public {
24         totalSupply = 100000000 * 10 ** uint256(decimals); // Update total supply with the decimal amount
25         balanceOf[msg.sender] = totalSupply;                // ASSIGN the creator all initial tokens
26         name = "Green Movement";                                   // name for display
27         symbol = "GMV";                               // symbol for TOKEN
28     }
29 
30     /**
31      * Internal transfer, only can be called by this contract
32      */
33     function _transfer(address _from, address _to, uint _value) internal {
34         // Prevent transfer to 0x0 address. Use burn() instead
35         require(_to != 0x0);
36         // Check if the sender has enough
37         require(balanceOf[_from] >= _value);
38         // Check for overflows
39         require(balanceOf[_to] + _value > balanceOf[_to]);
40         // Save this for an assertion in the future
41         uint previousBalances = balanceOf[_from] + balanceOf[_to];
42         // Subtract from the sender
43         balanceOf[_from] -= _value;
44         // Add the same to the recipient
45         balanceOf[_to] += _value;
46         Transfer(_from, _to, _value);
47         // Asserts are used to use static analysis to find bugs in your code. Never fails
48         assert(balanceOf[_from] + balanceOf[_to] == previousBalances);
49     }
50 
51     /**
52      * Transfer tokens
53      *
54      * Send `_value` tokens to `_to` from your account
55      *
56      * @param _to The address of the recipient
57      * @param _value the amount to send
58      */
59     function transfer(address _to, uint256 _value) public {
60         _transfer(msg.sender, _to, _value);
61     }
62 
63     /**
64      * Transfer tokens from other address
65      * Send `_value` tokens to `_to` on behalf of `_from`
66      * @param _from The address of the sender
67      * @param _to The address of the recipient
68      * @param _value the amount to send
69      */
70     function transferFrom(address _from, address _to, uint256 _value) public returns (bool success) {
71         require(_value <= allowance[_from][msg.sender]);     // Check allowance
72         allowance[_from][msg.sender] -= _value;
73         _transfer(_from, _to, _value);
74         return true;
75     }
76 
77     /**
78      * Set allowance for other address
79      * Allows `_spender` to spend no more than `_value` tokens on your behalf
80      * @param _spender The address authorized to spend
81      * @param _value the max amount they can spend
82      */
83     function approve(address _spender, uint256 _value) public
84         returns (bool success) {
85         allowance[msg.sender][_spender] = _value;
86         return true;
87     }
88 
89     /**
90      * Set allowance for other address and notify
91      * Allows `_spender` to spend no more than `_value` tokens on your behalf, and then ping the contract about it
92      * @param _spender The address authorized to spend
93      * @param _value the max amount they can spend
94      * @param _extraData some extra information to send to the approved contract
95      */
96     function approveAndCall(address _spender, uint256 _value, bytes _extraData)
97         public
98         returns (bool success) {
99         tokenRecipient spender = tokenRecipient(_spender);
100         if (approve(_spender, _value)) {
101             spender.receiveApproval(msg.sender, _value, this, _extraData);
102             return true;
103         }
104     }
105 
106     /**
107      * Destroy tokens
108      * Remove `_value` tokens from the system irreversibly
109      * @param _value the amount of money to burn
110      */
111     function burn(uint256 _value) public returns (bool success) {
112         require(balanceOf[msg.sender] >= _value);   // sender has enough?
113         balanceOf[msg.sender] -= _value;            // Subtract from the sender
114         totalSupply -= _value;                      // Updates totalSupply
115         Burn(msg.sender, _value);
116         return true;
117     }
118 
119     /**
120      * Destroy tokens from other account
121      * Remove `_value` tokens from the system irreversibly on behalf of `_from`.
122      * @param _from the address of the sender
123      * @param _value the amount of money to burn
124      */
125     function burnFrom(address _from, uint256 _value) public returns (bool success) {
126         require(balanceOf[_from] >= _value);                // is the targeted balance is enough?
127         require(_value <= allowance[_from][msg.sender]);    // Check allowance
128         balanceOf[_from] -= _value;                         // Subtract from the targeted balance
129         allowance[_from][msg.sender] -= _value;             // Subtract from the sender's allowance
130         totalSupply -= _value;                              // Update totalSupply
131         Burn(_from, _value);
132         return true;
133     }
134 }