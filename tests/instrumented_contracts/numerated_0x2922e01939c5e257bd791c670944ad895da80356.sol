1 pragma solidity ^0.5.7;
2 
3 interface tokenRecipient { 
4     function receiveApproval(address _from, uint256 _value, address _token, bytes calldata _extraData) external; 
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
44     /**
45      * Internal transfer, only can be called by this contract
46      */
47     function _transfer(address _from, address _to, uint _value) internal {
48         // Prevent transfer to 0x0 address. Use burn() instead
49         require(_to != address(0x0));
50         // Check if the sender has enough
51         require(balanceOf[_from] >= _value);
52         // Check for overflows
53         require(balanceOf[_to] + _value >= balanceOf[_to]);
54         // Save this for an assertion in the future
55         uint previousBalances = balanceOf[_from] + balanceOf[_to];
56         // Subtract from the sender
57         balanceOf[_from] -= _value;
58         // Add the same to the recipient
59         balanceOf[_to] += _value;
60         emit Transfer(_from, _to, _value);
61         // Asserts are used to use static analysis to find bugs in your code. They should never fail
62         assert(balanceOf[_from] + balanceOf[_to] == previousBalances);
63     }
64 
65     /**
66      * Transfer tokens
67      *
68      * Send `_value` tokens to `_to` from your account
69      *
70      * @param _to The address of the recipient
71      * @param _value the amount to send
72      */
73 
74     function transfer(address _to, uint256 _value) public returns (bool success) {
75     if (balanceOf[msg.sender] >= _value && _value > 0) {
76         balanceOf[msg.sender] -= _value;
77         balanceOf[_to] += _value;
78         _transfer(msg.sender, _to, _value);
79         return true;
80     }   else { return false; }
81 }
82     /**
83      * Transfer tokens from other address
84      *
85      * Send `_value` tokens to `_to` on behalf of `_from`
86      *
87      * @param _from The address of the sender
88      * @param _to The address of the recipient
89      * @param _value the amount to send
90      */
91     function transferFrom(address _from, address _to, uint256 _value) public returns (bool success) {
92         require(_value <= allowance[_from][msg.sender]);     // Check allowance
93         allowance[_from][msg.sender] -= _value;
94         _transfer(_from, _to, _value);
95         return true;
96     }
97 
98     /**
99      * Set allowance for other address
100      *
101      * Allows `_spender` to spend no more than `_value` tokens on your behalf
102      *
103      * @param _spender The address authorized to spend
104      * @param _value the max amount they can spend
105      */
106     function approve(address _spender, uint256 _value) public
107         returns (bool success) {
108         require((_value == 0) || (allowance[msg.sender][_spender] == 0));    
109         allowance[msg.sender][_spender] = _value;
110         emit Approval(msg.sender, _spender, _value);
111         return true;
112     }
113 
114     /**
115      * Set allowance for other address and notify
116      *
117      * Allows `_spender` to spend no more than `_value` tokens on your behalf, and then ping the contract about it
118      *
119      * @param _spender The address authorized to spend
120      * @param _value the max amount they can spend
121      * @param _extraData some extra information to send to the approved contract
122      */
123     function approveAndCall(address _spender, uint256 _value, bytes memory _extraData)
124         public
125         returns (bool success) {
126         tokenRecipient spender = tokenRecipient(_spender);
127         if (approve(_spender, _value)) {
128             spender.receiveApproval(msg.sender, _value, address(this), _extraData);
129             return true;
130         }
131     }
132 
133     /**
134      * Destroy tokens
135      *
136      * Remove `_value` tokens from the system irreversibly
137      *
138      * @param _value the amount of money to burn
139      */
140     function burn(uint256 _value) public returns (bool success) {
141         require(balanceOf[msg.sender] >= _value);   // Check if the sender has enough
142         balanceOf[msg.sender] -= _value;            // Subtract from the sender
143         totalSupply -= _value;                      // Updates totalSupply
144         emit Burn(msg.sender, _value);
145         return true;
146     }
147 
148     /**
149      * Destroy tokens from other account
150      *
151      * Remove `_value` tokens from the system irreversibly on behalf of `_from`.
152      *
153      * @param _from the address of the sender
154      * @param _value the amount of money to burn
155      */
156     function burnFrom(address _from, uint256 _value) public returns (bool success) {
157         require(balanceOf[_from] >= _value);                // Check if the targeted balance is enough
158         require(_value <= allowance[_from][msg.sender]);    // Check allowance
159         balanceOf[_from] -= _value;                         // Subtract from the targeted balance
160         allowance[_from][msg.sender] -= _value;             // Subtract from the sender's allowance
161         totalSupply -= _value;                              // Update totalSupply
162         emit Burn(_from, _value);
163         return true;
164     }
165 }