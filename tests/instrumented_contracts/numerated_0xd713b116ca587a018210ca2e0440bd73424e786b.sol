1 pragma solidity >=0.4.22 <0.6.0;
2 
3 interface tokenRecipient { 
4     function receiveApproval(address _from, uint256 _value, address _token, bytes calldata_extraData) external; 
5 }
6 
7 contract TokenERC20 {
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
46      * Internal transfer, only can be called by this contract
47      */
48     function _transfer(address _from, address _to, uint _value) internal {
49         // Prevent transfer to 0x0 address. Use burn() instead
50         require(_to != address(0x0));
51         
52         require(balanceOf[_from] >= _value);
53        
54         // Check for overflows
55         require(balanceOf[_to] + _value >= balanceOf[_to]);
56         
57         uint previousBalances  = balanceOf[_from] + balanceOf[_to];
58         
59         
60 		balanceOf[_from] -= _value;
61 		
62         
63         // Add the same to the recipient
64         balanceOf[_to] += _value;
65         
66         emit Transfer(_from, _to, _value);
67         // Asserts are used to use static analysis to find bugs in your code. They should never fail
68         assert(balanceOf[_from] + balanceOf[_to]  == previousBalances);
69     }
70 
71     /**
72      * Transfer tokens
73      *
74      * Send `_value` tokens to `_to` from your account
75      *
76      * @param _to The address of the recipient
77      * @param _value the amount to send
78      */
79     function transfer(address _to, uint256 _value) public returns (bool success) {
80         _transfer(msg.sender, _to, _value);
81         return true;
82     }
83 
84     /**
85      * Transfer tokens from other address
86      *
87      * Send `_value` tokens to `_to` on behalf of `_from`
88      *
89      * @param _from The address of the sender
90      * @param _to The address of the recipient
91      * @param _value the amount to send
92      */
93     function transferFrom(address _from, address _to, uint256 _value) public returns (bool success) {
94         require(_value <= allowance[_from][msg.sender]);     // Check allowance
95         allowance[_from][msg.sender] -= _value;
96         _transfer(_from, _to, _value);
97         return true;
98     }
99 
100     /**
101      * Set allowance for other address
102      *
103      * Allows `_spender` to spend no more than `_value` tokens on your behalf
104      *
105      * @param _spender The address authorized to spend
106      * @param _value the max amount they can spend
107      */
108     function approve(address _spender, uint256 _value) public
109         returns (bool success) {
110         allowance[msg.sender][_spender] = _value;
111         emit Approval(msg.sender, _spender, _value);
112         return true;
113     }
114 
115     /**
116      * Set allowance for other address and notify
117      *
118      * Allows `_spender` to spend no more than `_value` tokens on your behalf, and then ping the contract about it
119      *
120      * @param _spender The address authorized to spend
121      * @param _value the max amount they can spend
122      * @param _extraData some extra information to send to the approved contract
123      */
124     function approveAndCall(address _spender, uint256 _value, bytes memory _extraData)
125         public
126         returns (bool success) {
127         tokenRecipient spender = tokenRecipient(_spender);
128         if (approve(_spender, _value)) {
129             spender.receiveApproval(msg.sender, _value, address(this), _extraData);
130             return true;
131         }
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
146         return true;
147     }
148 
149     /**
150      * Destroy tokens from other account
151      *
152      * Remove `_value` tokens from the system irreversibly on behalf of `_from`.
153      *
154      * @param _from the address of the sender
155      * @param _value the amount of money to burn
156      */
157     function burnFrom(address _from, uint256 _value) public returns (bool success) {
158         require(balanceOf[_from] >= _value);                // Check if the targeted balance is enough
159         require(_value <= allowance[_from][msg.sender]);    // Check allowance
160         balanceOf[_from] -= _value;                         // Subtract from the targeted balance
161         allowance[_from][msg.sender] -= _value;             // Subtract from the sender's allowance
162         totalSupply -= _value;                              // Update totalSupply
163         emit Burn(_from, _value);
164         return true;
165     }
166 }