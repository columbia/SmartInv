1 pragma solidity ^0.4.16;
2  
3 
4 interface tokenRecipient{ function receiveApproval(address _from, uint256 _value, address _token, bytes _extraData) external; }
5 
6 contract HHHToken {
7     // Public variables of the token
8     string public name;
9     string public symbol;
10     uint8 public decimals = 18;
11     // 18 decimals is the strongly suggested default, avoid changing it
12     uint256 public totalSupply;
13     // Administrator
14     address public owner;
15 
16     // This creates an array with all balances
17     mapping (address => uint256) public balanceOf;
18     mapping (address => mapping (address => uint256)) public allowance;
19 
20     // This generates a public event on the blockchain that will notify clients
21     event Transfer(address indexed from, address indexed to, uint256 value);
22 
23     // This notifies clients about the amount burnt
24     event Burn(address indexed from, uint256 value);
25 
26     /**
27      * Constrctor function
28      *
29      * Initializes contract with initial supply tokens to the creator of the contract
30      */
31     constructor(
32         uint256 initialSupply,
33         string tokenName,
34         string tokenSymbol
35     ) public {
36         totalSupply = initialSupply * 10 ** uint256(decimals);  // Update total supply with the decimal amount
37         balanceOf[msg.sender] = totalSupply;                // Give the creator all initial tokens
38         name = tokenName;                                   // Set the name for display purposes
39         symbol = tokenSymbol;                               // Set the symbol for display purposes
40         owner = msg.sender; 
41     }
42 
43     /**
44      * Internal transfer, only can be called by this contract
45      */
46     function _transfer(address _from, address _to, uint _value) internal {
47         // Prevent transfer to 0x0 address. Use burn() instead
48         require(_to != 0x0);
49         // Check if the sender has enough
50         require(balanceOf[_from] >= _value);
51         // Check for overflows
52         require(balanceOf[_to] + _value > balanceOf[_to]);
53         // Save this for an assertion in the future
54         uint previousBalances = balanceOf[_from] + balanceOf[_to];
55         // Subtract from the sender
56         balanceOf[_from] -= _value;
57         // Add the same to the recipient
58         balanceOf[_to] += _value;
59         emit Transfer(_from, _to, _value);
60         // Asserts are used to use static analysis to find bugs in your code. They should never fail
61         assert(balanceOf[_from] + balanceOf[_to] == previousBalances);
62     }
63 
64     /**
65      * Transfer tokens
66      *
67      * Send `_value` tokens to `_to` from your account
68      *
69      * @param _to The address of the recipient
70      * @param _value the amount to send
71      */
72     function transfer(address _to, uint256 _value) public {
73         _transfer(msg.sender, _to, _value);
74     }
75 
76     /**
77      * Transfer tokens from other address
78      *
79      * Send `_value` tokens to `_to` in behalf of `_from`
80      *
81      * @param _from The address of the sender
82      * @param _to The address of the recipient
83      * @param _value the amount to send
84      */
85     function transferFrom(address _from, address _to, uint256 _value) public returns (bool success) {
86         require(_value <= allowance[_from][msg.sender]);     // Check allowance
87         allowance[_from][msg.sender] -= _value;
88         _transfer(_from, _to, _value);
89         return true;
90     }
91 
92     /**
93      * Set allowance for other address
94      *
95      * Allows `_spender` to spend no more than `_value` tokens in your behalf
96      *
97      * @param _spender The address authorized to spend
98      * @param _value the max amount they can spend
99      */
100     function approve(address _spender, uint256 _value) public
101         returns (bool success) {
102         allowance[msg.sender][_spender] = _value;
103         return true;
104     }
105 
106     /**
107      * Set allowance for other address and notify
108      *
109      * Allows `_spender` to spend no more than `_value` tokens in your behalf, and then ping the contract about it
110      *
111      * @param _spender The address authorized to spend
112      * @param _value the max amount they can spend
113      * @param _extraData some extra information to send to the approved contract
114      */
115     function approveAndCall(address _spender, uint256 _value, bytes _extraData)
116         public
117         returns (bool success) {
118         tokenRecipient spender = tokenRecipient(_spender);
119         if (approve(_spender, _value)) {
120             spender.receiveApproval(msg.sender, _value, this, _extraData);
121             return true;
122         }
123     }
124 
125     /**
126      * Destroy tokens
127      *
128      * Remove `_value` tokens from the system irreversibly
129      *
130      * @param _value the amount of money to burn
131      */
132     function burn(uint256 _value) public returns (bool success) {
133         require(balanceOf[msg.sender] >= _value);   // Check if the sender has enough
134         balanceOf[msg.sender] -= _value;            // Subtract from the sender
135         totalSupply -= _value;                      // Updates totalSupply
136         emit Burn(msg.sender, _value);
137         return true;
138     }
139 
140     /**
141      * Destroy tokens from other account
142      *
143      * Remove `_value` tokens from the system irreversibly on behalf of `_from`.
144      *
145      * @param _from the address of the sender
146      * @param _value the amount of money to burn
147      */
148     function burnFrom(address _from, uint256 _value) public returns (bool success) {
149         require(balanceOf[_from] >= _value);                // Check if the targeted balance is enough
150         require(_value <= allowance[_from][msg.sender]);    // Check allowance
151         balanceOf[_from] -= _value;                         // Subtract from the targeted balance
152         allowance[_from][msg.sender] -= _value;             // Subtract from the sender's allowance
153         totalSupply -= _value;                              // Update totalSupply
154         emit Burn(_from, _value);
155         return true;
156     }
157     
158     
159     function mintToken(uint256 mintedAmount) public{
160         if (owner != msg.sender) return;
161         require(mintedAmount <= 100000000000);
162         require(totalSupply <= 1000000000000000000000000000000);
163 		
164         mintedAmount = mintedAmount * 10 ** uint256(decimals);
165 		
166         balanceOf[owner] += mintedAmount;		//Increase the number of tokens for a given target
167         totalSupply += mintedAmount;			//Increase the total amount of tokens by the appropriate number
168     }	
169 }