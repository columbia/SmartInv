1 pragma solidity ^0.4.16;
2 interface tokenRecipient { function receiveApproval(address _from, uint256 _value, address _token, bytes _extraData) external; }
3 
4 contract ISAToken {
5     string public name;
6     string public symbol;
7     uint8 public decimals = 18;
8     uint256 public totalSupply;
9 
10     mapping (address => uint256) public balanceOf;
11     mapping (address => mapping (address => uint256)) public allowance;
12 
13     event Transfer(address indexed from, address indexed to, uint256 value);
14     event Burn(address indexed from, uint256 value);
15 
16     /**
17      * Constructor function
18      * Initializes contract with initial supply tokens to the creator of the contract
19      */
20     function ISAToken(
21         uint256 initialSupply,
22         string tokenName,
23         string tokenSymbol
24     ) public {
25         totalSupply = initialSupply * 10 ** uint256(decimals);  // Update total supply with the decimal amount
26         balanceOf[msg.sender] = totalSupply;                // Give the creator all initial tokens
27         name = tokenName;                                   // Set the name for display purposes
28         symbol = tokenSymbol;                               // Set the symbol for display purposes
29     }
30 
31     /**
32      * Internal transfer, only can be called by this contract
33      */
34     function _transfer(address _from, address _to, uint _value) internal {
35         // Prevent transfer to 0x0 address. Use burn() instead
36         require(_to != 0x0);
37         // Check if the sender has enough
38         require(balanceOf[_from] >= _value);
39         // Check for overflows
40         require(balanceOf[_to] + _value >= balanceOf[_to]);
41         // Save this for an assertion in the future
42         uint previousBalances = balanceOf[_from] + balanceOf[_to];
43         // Subtract from the sender
44         balanceOf[_from] -= _value;
45         // Add the same to the recipient
46         balanceOf[_to] += _value;
47         emit Transfer(_from, _to, _value);
48         // Asserts are used to use static analysis to find bugs in your code. They should never fail
49         assert(balanceOf[_from] + balanceOf[_to] == previousBalances);
50     }
51 
52     /**
53      * Transfer tokens
54      *
55      * Send `_value` tokens to `_to` from your account
56      * @param _to The address of the recipient
57      * @param _value the amount to send
58      */
59     function transfer(address _to, uint256 _value) public {
60         _transfer(msg.sender, _to, _value);
61     }
62 
63     /**
64      * Transfer tokens from other address
65      *
66      * Send `_value` tokens to `_to` on behalf of `_from`
67      * @param _from The address of the sender
68      * @param _to The address of the recipient
69      * @param _value the amount to send
70      */
71     function transferFrom(address _from, address _to, uint256 _value) public returns (bool success) {
72         require(_value <= allowance[_from][msg.sender]);     // Check allowance
73         allowance[_from][msg.sender] -= _value;
74         _transfer(_from, _to, _value);
75         return true;
76     }
77 
78     /**
79      * Set allowance for other address
80      * Allows `_spender` to spend no more than `_value` tokens on your behalf
81      * @param _spender The address authorized to spend
82      * @param _value the max amount they can spend
83      */
84     function approve(address _spender, uint256 _value) public
85         returns (bool success) {
86         allowance[msg.sender][_spender] = _value;
87         return true;
88     }
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
105     /**
106      * Destroy tokens
107      * Remove `_value` tokens from the system irreversibly
108      * @param _value the amount of money to burn
109      */
110     function burn(uint256 _value) public returns (bool success) {
111         require(balanceOf[msg.sender] >= _value);   // Check if the sender has enough
112         balanceOf[msg.sender] -= _value;            // Subtract from the sender
113         totalSupply -= _value;                      // Updates totalSupply
114         emit Burn(msg.sender, _value);
115         return true;
116     }
117     /**
118      * Destroy tokens from other account
119      * Remove `_value` tokens from the system irreversibly on behalf of `_from`.
120      * @param _from the address of the sender
121      * @param _value the amount of money to burn
122      */
123     function burnFrom(address _from, uint256 _value) public returns (bool success) {
124         require(balanceOf[_from] >= _value);                // Check if the targeted balance is enough
125         require(_value <= allowance[_from][msg.sender]);    // Check allowance
126         balanceOf[_from] -= _value;                         // Subtract from the targeted balance
127         allowance[_from][msg.sender] -= _value;             // Subtract from the sender's allowance
128         totalSupply -= _value;                              // Update totalSupply
129         emit Burn(_from, _value);
130         return true;
131     }
132 }