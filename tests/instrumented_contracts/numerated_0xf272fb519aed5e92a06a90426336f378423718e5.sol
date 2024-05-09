1 pragma solidity ^0.4.16;
2 
3 contract owned {
4     address public owner;
5 
6     function owned() public { owner = msg.sender; }
7 
8     modifier onlyOwner {
9         require(msg.sender == owner);
10         _;
11     }
12 
13     function transferOwnership(address newOwner) onlyOwner public {
14         owner = newOwner;
15     }
16 }
17 
18 interface tokenRecipient { function receiveApproval(address _from, uint256 _value, address _token, bytes _extraData) public; }
19 
20 contract TokenERC20 {
21     uint256 public totalSupply;
22     string public name;
23     string public symbol;
24     uint8 public decimals = 18;
25 
26     // This creates an array with all balances
27     mapping (address => uint256) public balanceOf;
28     mapping (address => mapping (address => uint256)) public allowance;
29 
30     // Event which is triggered to log all transfers to this contract's event log
31     event Transfer(address indexed from, address indexed to, uint256 value);
32     // Event which is triggered whenever an owner approves a new allowance for a spender.
33     event Approval(address indexed owner, address indexed spender, uint256 value);
34     // This notifies clients about the amount burnt
35     event Burn(address indexed from, uint256 value);
36 
37     /**
38      * Initialization Construction
39      */
40     function TokenERC20(uint256 _initialSupply, string _tokenName, string _tokenSymbol) public {
41         totalSupply = _initialSupply * 10 ** uint256(decimals);  // Update total supply with the decimal amount
42         balanceOf[msg.sender] = totalSupply;                     // Give the creator all initial tokens
43         name = _tokenName;                                       // Set the name for display purposes
44         symbol = _tokenSymbol;                                   // Set the symbol for display purposes
45     }
46 
47     /**
48      * Internal Realization of Token Transaction Transfer
49      */
50     function _transfer(address _from, address _to, uint _value) internal {
51         require(_to != 0x0);                                            // Prevent transfer to 0x0 address. Use burn() instead
52         require(balanceOf[_from] >= _value);                            // Check if the sender has enough    
53         require(balanceOf[_to] + _value > balanceOf[_to]);              // Check for overflows
54 
55         uint previousBalances = balanceOf[_from] + balanceOf[_to];      // Save this for an assertion in the future
56         balanceOf[_from] -= _value;                                     // Subtract from the sender
57         balanceOf[_to] += _value;                                       // Add the same to the recipient
58         Transfer(_from, _to, _value);                                   // Notify anyone listening that this transfer took place
59 
60         assert(balanceOf[_from] + balanceOf[_to] == previousBalances);  // Use assert to check code logic
61     }
62 
63     /**
64      * Transfer tokens
65      * Send `_value` tokens to `_to` from your account
66      *
67      * @param _to     The address of the recipient
68      * @param _value  The amount to send
69      */
70     function transfer(address _to, uint256 _value) public {
71         _transfer(msg.sender, _to, _value);
72     }
73 
74     /**
75      * Transfer tokens from other address
76      * Send `_value` tokens to `_to` in behalf of `_from`
77      *
78      * @param _from   The address of the sender
79      * @param _to     The address of the recipient
80      * @param _value  The amount to send
81      */
82     function transferFrom(address _from, address _to, uint256 _value) public returns (bool success) {
83         require(_value <= allowance[_from][msg.sender]);    // Check allowance
84         allowance[_from][msg.sender] -= _value;
85         _transfer(_from, _to, _value);
86         return true;
87     }
88 
89     /**
90      * Set allowance for other address
91      * Allows `_spender` to spend no more than `_value` tokens in your behalf
92      *
93      * @param _spender  The address authorized to spend
94      * @param _value    The max amount they can spend
95      */
96     function approve(address _spender, uint256 _value) public returns (bool success) {
97         allowance[msg.sender][_spender] = _value;
98         return true;
99     }
100 
101     /**
102      * Set allowance for other address and notify
103      * Allows `_spender` to spend no more than `_value` tokens in your behalf, and then ping the contract about it
104      *
105      * @param _spender    The address authorized to spend
106      * @param _value      The max amount they can spend
107      * @param _extraData  Some extra information to send to the approved contract
108      */
109     function approveAndCall(address _spender, uint256 _value, bytes _extraData) public returns (bool success) {
110         tokenRecipient spender = tokenRecipient(_spender);
111         if (approve(_spender, _value)) {
112             spender.receiveApproval(msg.sender, _value, this, _extraData);
113             return true;
114         }
115     }
116 
117     /**
118      * Destroy tokens
119      * Remove `_value` tokens from the system irreversibly
120      *
121      * @param _value  The amount of money to burn
122      */
123     function burn(uint256 _value) public returns (bool success) {
124         require(balanceOf[msg.sender] >= _value);   // Check if the sender has enough
125         balanceOf[msg.sender] -= _value;            // Subtract from the sender
126         totalSupply -= _value;                      // Updates totalSupply
127         Burn(msg.sender, _value);
128         return true;
129     }
130 
131     /**
132      * Destroy tokens from other account
133      * Remove `_value` tokens from the system irreversibly on behalf of `_from`.
134      *
135      * @param _from   The address of the sender
136      * @param _value  The amount of money to burn
137      */
138     function burnFrom(address _from, uint256 _value) public returns (bool success) {
139         require(balanceOf[_from] >= _value);                // Check if the targeted balance is enough
140         require(_value <= allowance[_from][msg.sender]);    // Check allowance
141         balanceOf[_from] -= _value;                         // Subtract from the targeted balance
142         allowance[_from][msg.sender] -= _value;             // Subtract from the sender's allowance
143         totalSupply -= _value;                              // Update totalSupply
144         Burn(_from, _value);
145         return true;
146     }
147 }