1 /**
2  *Submitted for verification at Etherscan.io on 2018-07-16
3 */
4 
5 pragma solidity ^0.4.16;
6 
7 interface tokenRecipient { function receiveApproval(address _from, uint256 _value, address _token, bytes _extraData) external; }
8 
9 contract TokenERC20 {
10     // Public variables of the token
11     string public name;
12     string public symbol;
13     uint8 public decimals = 18;
14     // 18 decimals is the strongly suggested default, avoid changing it
15     uint256 public totalSupply;
16 
17     // This creates an array with all balances
18     mapping (address => uint256) public balanceOf;
19     mapping (address => mapping (address => uint256)) public allowance;
20 
21     // This generates a public event on the blockchain that will notify clients
22     event Transfer(address indexed from, address indexed to, uint256 value);
23     
24     // This generates a public event on the blockchain that will notify clients
25     event Approval(address indexed _owner, address indexed _spender, uint256 _value);
26 
27     // This notifies clients about the amount burnt
28     event Burn(address indexed from, uint256 value);
29 
30     /**
31      * Constructor function
32      *
33      * Initializes contract with initial supply tokens to the creator of the contract
34      */
35     constructor (
36         uint256 initialSupply,
37         string tokenName,
38         string tokenSymbol
39     ) public {
40         totalSupply = initialSupply * 10 ** uint256(decimals);  // Update total supply with the decimal amount
41         balanceOf[msg.sender] = totalSupply;                // Give the creator all initial tokens
42         name = tokenName;                                   // Set the name for display purposes
43         symbol = tokenSymbol;                               // Set the symbol for display purposes
44     }
45 
46     /**
47      * Internal transfer, only can be called by this contract
48      */
49     function _transfer(address _from, address _to, uint _value) internal {
50         // Prevent transfer to 0x0 address. Use burn() instead
51         require(_to != 0x0);
52         // Check if the sender has enough
53         require(balanceOf[_from] >= _value);
54         // Check for overflows
55         require(balanceOf[_to] + _value >= balanceOf[_to]);
56         // Save this for an assertion in the future
57         uint previousBalances = balanceOf[_from] + balanceOf[_to];
58         // Subtract from the sender
59         balanceOf[_from] -= _value;
60         // Add the same to the recipient
61         balanceOf[_to] += _value;
62         emit Transfer(_from, _to, _value);
63         // Asserts are used to use static analysis to find bugs in your code. They should never fail
64         assert(balanceOf[_from] + balanceOf[_to] == previousBalances);
65     }
66 
67     /**
68      * Transfer tokens
69      *
70      * Send `_value` tokens to `_to` from your account
71      *
72      * @param _to The address of the recipient
73      * @param _value the amount to send
74      */
75     function transfer(address _to, uint256 _value) public returns (bool success) {
76         _transfer(msg.sender, _to, _value);
77         return true;
78     }
79 
80     /**
81      * Transfer tokens from other address
82      *
83      * Send `_value` tokens to `_to` on behalf of `_from`
84      *
85      * @param _from The address of the sender
86      * @param _to The address of the recipient
87      * @param _value the amount to send
88      */
89     function transferFrom(address _from, address _to, uint256 _value) public returns (bool success) {
90         require(_value <= allowance[_from][msg.sender]);     // Check allowance
91         allowance[_from][msg.sender] -= _value;
92         _transfer(_from, _to, _value);
93         return true;
94     }
95 
96     /**
97      * Set allowance for other address
98      *
99      * Allows `_spender` to spend no more than `_value` tokens on your behalf
100      *
101      * @param _spender The address authorized to spend
102      * @param _value the max amount they can spend
103      */
104     function approve(address _spender, uint256 _value) public
105         returns (bool success) {
106         allowance[msg.sender][_spender] = _value;
107         emit Approval(msg.sender, _spender, _value);
108         return true;
109     }
110 
111     /**
112      * Set allowance for other address and notify
113      *
114      * Allows `_spender` to spend no more than `_value` tokens on your behalf, and then ping the contract about it
115      *
116      * @param _spender The address authorized to spend
117      * @param _value the max amount they can spend
118      * @param _extraData some extra information to send to the approved contract
119      */
120     function approveAndCall(address _spender, uint256 _value, bytes _extraData)
121         public
122         returns (bool success) {
123         tokenRecipient spender = tokenRecipient(_spender);
124         if (approve(_spender, _value)) {
125             spender.receiveApproval(msg.sender, _value, this, _extraData);
126             return true;
127         }
128     }
129 
130     /**
131      * Destroy tokens
132      *
133      * Remove `_value` tokens from the system irreversibly
134      *
135      * @param _value the amount of money to burn
136      */
137     function burn(uint256 _value) public returns (bool success) {
138         require(balanceOf[msg.sender] >= _value);   // Check if the sender has enough
139         balanceOf[msg.sender] -= _value;            // Subtract from the sender
140         totalSupply -= _value;                      // Updates totalSupply
141         emit Burn(msg.sender, _value);
142         return true;
143     }
144 
145     /**
146      * Destroy tokens from other account
147      *
148      * Remove `_value` tokens from the system irreversibly on behalf of `_from`.
149      *
150      * @param _from the address of the sender
151      * @param _value the amount of money to burn
152      */
153     function burnFrom(address _from, uint256 _value) public returns (bool success) {
154         require(balanceOf[_from] >= _value);                // Check if the targeted balance is enough
155         require(_value <= allowance[_from][msg.sender]);    // Check allowance
156         balanceOf[_from] -= _value;                         // Subtract from the targeted balance
157         allowance[_from][msg.sender] -= _value;             // Subtract from the sender's allowance
158         totalSupply -= _value;                              // Update totalSupply
159         emit Burn(_from, _value);
160         return true;
161     }
162 }