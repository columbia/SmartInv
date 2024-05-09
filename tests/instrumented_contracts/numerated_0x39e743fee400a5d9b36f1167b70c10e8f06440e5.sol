1 pragma solidity >=0.4.22 <0.6.0;
2 
3 interface tokenRecipient { 
4     function receiveApproval(address _from, uint256 _value, address _token, bytes _extraData) external; 
5 }
6 
7 contract TNCGroupToken {
8     // Public variables of the token
9     string public name;
10     string public symbol;
11     uint8 public decimals = 18;
12     // 18 decimals is the strongly suggested default, avoid changing it
13     uint256 public totalSupply;
14 
15     // This creates an array with all balances
16     mapping (address => uint256) public balanceOf;
17     mapping (address => mapping (address => uint256)) public allowance;
18 
19     // This generates a public event on the blockchain that will notify clients
20     event Transfer(address indexed from, address indexed to, uint256 value);
21     
22     // This generates a public event on the blockchain that will notify clients
23     event Approval(address indexed _owner, address indexed _spender, uint256 _value);
24 
25     // This notifies clients about the amount burnt
26     event Burn(address indexed from, uint256 value);
27 
28     /**
29      * Constructor function
30      *
31      * Initializes contract with initial supply tokens to the creator of the contract
32      */
33     constructor(
34         uint256 initialSupply,
35         string memory tokenName,
36         string memory tokenSymbol
37     ) public {
38         totalSupply = initialSupply * 10 ** uint256(decimals);  // Update total supply with the decimal amount
39         balanceOf[msg.sender] = totalSupply;                // Give the creator all initial tokens
40         name = tokenName;                                   // Set the name for display purposes
41         symbol = tokenSymbol;                               // Set the symbol for display purposes
42     }
43 
44 
45     /**
46      * Transfer tokens
47      *
48      * Send `_value` tokens to `_to` from your account
49      *
50      * @param _to The address of the recipient
51      * @param _value the amount to send
52      */
53     function transfer(address _to, uint256 _value) public returns (bool success) {
54         _transfer(msg.sender, _to, _value);
55         return true;
56     }
57 
58 
59         /**
60      * Internal transfer, only can be called by this contract
61      */
62     function _transfer(address _from, address _to, uint _value) internal {
63         // Prevent transfer to 0x0 address. Use burn() instead
64         require(_to != address(0x0));
65         // Check if the sender has enough
66         require(balanceOf[_from] >= _value);
67         // Check for overflows
68         require(balanceOf[_to] + _value >= balanceOf[_to]);
69         // Save this for an assertion in the future
70         uint previousBalances = balanceOf[_from] + balanceOf[_to];
71         // Subtract from the sender
72         balanceOf[_from] -= _value;
73         // Add the same to the recipient
74         balanceOf[_to] += _value;
75         emit Transfer(_from, _to, _value);
76         // Asserts are used to use static analysis to find bugs in your code. They should never fail
77         assert(balanceOf[_from] + balanceOf[_to] == previousBalances);
78     }
79 
80 
81 
82 
83     /**
84      * Set allowance for other address
85      *
86      * Allows `_spender` to spend no more than `_value` tokens on your behalf
87      *
88      * @param _spender The address authorized to spend
89      * @param _value the max amount they can spend
90      */
91     function approve(address _spender, uint256 _value) public
92         returns (bool success) {
93         require (_spender != address(0x0));
94         allowance[msg.sender][_spender] = _value;
95         emit Approval(msg.sender, _spender, _value);
96         return true;
97     }
98 
99     /**
100      * Set allowance for other address and notify
101      *
102      * Allows `_spender` to spend no more than `_value` tokens on your behalf, and then ping the contract about it
103      *
104      * @param _spender The address authorized to spend
105      * @param _value the max amount they can spend
106      * @param _extraData some extra information to send to the approved contract
107      */
108     function approveAndCall(address _spender, uint256 _value, bytes memory _extraData)
109         public
110         returns (bool success) {
111         tokenRecipient spender = tokenRecipient(_spender);
112         if (approve(_spender, _value)) {
113             spender.receiveApproval(msg.sender, _value, address(this), _extraData);
114             return true;
115         }
116     }
117 
118         /**
119      * Transfer tokens from other address
120      *
121      * Send `_value` tokens to `_to` on behalf of `_from`
122      *
123      * @param _from The address of the sender
124      * @param _to The address of the recipient
125      * @param _value the amount to send
126      */
127     function transferFrom(address _from, address _to, uint256 _value) public returns (bool success) {
128         require(_value <= allowance[_from][msg.sender]);     // Check allowance
129         allowance[_from][msg.sender] -= _value;
130         _transfer(_from, _to, _value);
131         return true;
132     }
133 
134     /**
135      * Destroy tokens
136      *
137      * Remove `_value` tokens from the system irreversibly
138      *
139      * @param _value the amount of money to burn
140      */
141     function burn(uint256 _value) public returns (bool success) {
142         require(balanceOf[msg.sender] >= _value);   // Check if the sender has enough
143         balanceOf[msg.sender] -= _value;            // Subtract from the sender
144         totalSupply -= _value;                      // Updates totalSupply
145         emit Burn(msg.sender, _value);
146         emit Transfer(msg.sender, address(0x0), _value);
147         return true;
148     }
149 
150 }