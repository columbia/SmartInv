1 pragma solidity ^0.5.2;
2 /* version:0.5.7+commit.6da8b019.Emscripten.clang */
3 
4 
5 interface tokenRecipient { function receiveApproval(address _from, uint256 _value, address _token, bytes calldata _extraData) external; }
6 
7 contract TokenERC20 {
8     // Public variables of the token
9     string public name;
10     string public symbol;
11     uint8 public decimals=18;
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
22     // This notifies clients about the amount burnt
23     event Burn(address indexed from, uint256 value);
24 
25     /**
26      * Constructor function
27      *
28      * Initializes contract with initial supply tokens to the creator of the contract
29      */
30     constructor() public
31     {
32         uint256 initialSupply =2000000000;  
33         string memory tokenName ="GOLD Defi Token";
34         string memory tokenSymbol="GDT";    
35    
36         totalSupply = initialSupply * 10 ** uint256(decimals);  // Update total supply with the decimal amount
37         balanceOf[msg.sender] = totalSupply;                // Give the creator all initial tokens
38         name = tokenName;                                   // Set the name for display purposes
39         symbol = tokenSymbol;                               // Set the symbol for display purposes
40     }
41 
42     /**
43      * Internal transfer, only can be called by this contract
44      */
45     function _transfer(address _from, address _to, uint _value) internal {
46         // Prevent transfer to 0x0 address. Use burn() instead
47         require(_to != address(0));
48         // Check if the sender has enough
49         require(balanceOf[_from] >= _value);
50         // Check for overflows
51         require(balanceOf[_to] + _value >= balanceOf[_to]);
52         // Save this for an assertion in the future
53         uint previousBalances = balanceOf[_from] + balanceOf[_to];
54         // Subtract from the sender
55         balanceOf[_from] -= _value;
56         // Add the same to the recipient
57         balanceOf[_to] += _value;
58         emit Transfer(_from, _to, _value);
59         // Asserts are used to use static analysis to find bugs in your code. They should never fail
60         assert(balanceOf[_from] + balanceOf[_to] == previousBalances);
61     }
62 
63     /**
64      * Transfer tokens
65      *
66      * Send `_value` tokens to `_to` from your account
67      *
68      * @param _to The address of the recipient
69      * @param _value the amount to send
70      */
71     function transfer(address _to, uint256 _value) public {
72         _transfer(msg.sender, _to, _value);
73     }
74 
75     /**
76      * Transfer tokens from other address
77      *
78      * Send `_value` tokens to `_to` on behalf of `_from`
79      *
80      * @param _from The address of the sender
81      * @param _to The address of the recipient
82      * @param _value the amount to send
83      */
84     function transferFrom(address _from, address _to, uint256 _value) public returns (bool success) {
85         require(_value <= allowance[_from][msg.sender]);     // Check allowance
86         allowance[_from][msg.sender] -= _value;
87         _transfer(_from, _to, _value);
88         return true;
89     }
90 
91     /**
92      * Set allowance for other address
93      *
94      * Allows `_spender` to spend no more than `_value` tokens on your behalf
95      *
96      * @param _spender The address authorized to spend
97      * @param _value the max amount they can spend
98      */
99     function approve(address _spender, uint256 _value) public
100         returns (bool success) {
101         allowance[msg.sender][_spender] = _value;
102         return true;
103     }
104 
105     /**
106      * Set allowance for other address and notify
107      *
108      * Allows `_spender` to spend no more than `_value` tokens on your behalf, and then ping the contract about it
109      *
110      * @param _spender The address authorized to spend
111      * @param _value the max amount they can spend
112      * @param _extraData some extra information to send to the approved contract
113      */
114     function approveAndCall(address _spender, uint256 _value, bytes memory _extraData)
115         public
116         returns (bool success) {
117         tokenRecipient spender = tokenRecipient(_spender);
118         if (approve(_spender, _value)) {
119             spender.receiveApproval(msg.sender, _value, address(this), _extraData);
120             return true;
121         }
122     }
123 
124     /**
125      * Destroy tokens
126      *
127      * Remove `_value` tokens from the system irreversibly
128      *
129      * @param _value the amount of money to burn
130      */
131     function burn(uint256 _value) public returns (bool success) {
132         require(balanceOf[msg.sender] >= _value);   // Check if the sender has enough
133         balanceOf[msg.sender] -= _value;            // Subtract from the sender
134         totalSupply -= _value;                      // Updates totalSupply
135         emit Burn(msg.sender, _value);
136         return true;
137     }
138 
139     /**
140      * Destroy tokens from other account
141      *
142      * Remove `_value` tokens from the system irreversibly on behalf of `_from`.
143      *
144      * @param _from the address of the sender
145      * @param _value the amount of money to burn
146      */
147     function burnFrom(address _from, uint256 _value) public returns (bool success) {
148         require(balanceOf[_from] >= _value);                // Check if the targeted balance is enough
149         require(_value <= allowance[_from][msg.sender]);    // Check allowance
150         balanceOf[_from] -= _value;                         // Subtract from the targeted balance
151         allowance[_from][msg.sender] -= _value;             // Subtract from the sender's allowance
152         totalSupply -= _value;                              // Update totalSupply
153         emit Burn(_from, _value);
154         return true;
155     }
156 }