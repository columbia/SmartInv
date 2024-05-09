1 pragma solidity ^0.4.18;
2 
3 contract owned {
4     address public owner;
5 
6     function owned() public {
7         owner = msg.sender;
8     }
9 
10     modifier onlyOwner {
11         require(msg.sender == owner);
12         _;
13     }
14 
15     function transferOwnership(address newOwner) onlyOwner public {
16         owner = newOwner;
17     }
18 }
19 
20 interface tokenRecipient { function receiveApproval(address _from, uint256 _value, address _token, bytes _extraData) public; }
21 
22 contract TokenERC20 is owned {
23     // Public variables of the token
24     string public name;
25     string public symbol;
26     uint8 public decimals = 18;
27     // 18 decimals is the strongly suggested default, avoid changing it
28     uint256 public totalSupply;
29 	uint256 public tokensPerEther;
30 
31     // This creates an array with all balances
32     mapping (address => uint256) public balanceOf;
33     mapping (address => mapping (address => uint256)) public allowance;
34 
35     // This generates a public event on the blockchain that will notify clients
36     event Transfer(address indexed from, address indexed to, uint256 value);
37 
38     /**
39      * Constrctor function
40      *
41      * Initializes contract with initial supply tokens to the creator of the contract
42      */
43     function TokenERC20(
44         uint256 initialSupply,
45         string tokenName,
46         string tokenSymbol
47     ) public {
48         totalSupply = initialSupply * 10 ** uint256(decimals);  // Update total supply with the decimal amount
49         //balanceOf[msg.sender] = totalSupply;                // Give the creator all initial tokens
50 		balanceOf[this] = totalSupply;                		// Give the contract all initial tokens
51         name = tokenName;                                   // Set the name for display purposes
52         symbol = tokenSymbol;                               // Set the symbol for display purposes
53     }
54 
55 	
56 	/* Internal transfer, only can be called by this contract */
57     function _transfer(address _from, address _to, uint _value) internal {
58         require (_to != 0x0);                               // Prevent transfer to 0x0 address.
59         require (balanceOf[_from] >= _value);               // Check if the sender has enough
60         require (balanceOf[_to] + _value > balanceOf[_to]); // Check for overflows
61         uint previousBalances = balanceOf[_from] + balanceOf[_to];	// Save this for an assertion in the future
62         balanceOf[_from] -= _value;                         // Subtract from the sender
63         balanceOf[_to] += _value;                           // Add the same to the recipient
64         Transfer(_from, _to, _value);
65 		assert(balanceOf[_from] + balanceOf[_to] == previousBalances);	// Asserts are used to use static analysis to find bugs in your code. They should never fail
66     }
67 
68 	
69     /**
70      * Transfer tokens
71      *
72      * Send `_value` tokens to `_to` from your account
73      *
74      * @param _to The address of the recipient
75      * @param _value the amount to send
76      */
77     function transfer(address _to, uint256 _value) public {
78         _transfer(msg.sender, _to, _value);
79     }
80 
81 	
82     /**
83      * Transfer tokens from other address
84      *
85      * Send `_value` tokens to `_to` in behalf of `_from`
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
98 	
99     /**
100      * Set allowance for other address
101      *
102      * Allows `_spender` to spend no more than `_value` tokens on your behalf
103      *
104      * @param _spender The address authorized to spend
105      * @param _value the max amount they can spend
106      */
107     function approve(address _spender, uint256 _value) public
108         returns (bool success) {
109         allowance[msg.sender][_spender] = _value;
110         return true;
111     }
112 
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
123     function approveAndCall(address _spender, uint256 _value, bytes _extraData)
124         public
125         returns (bool success) {
126         tokenRecipient spender = tokenRecipient(_spender);
127         if (approve(_spender, _value)) {
128             spender.receiveApproval(msg.sender, _value, this, _extraData);
129             return true;
130         }
131     }
132 	
133 	
134 	function withdrawEther(uint256 _value) onlyOwner public {
135 		msg.sender.transfer(_value);
136 	}
137 	
138 	function withdrawAllEther() onlyOwner public {
139 		msg.sender.transfer(this.balance);
140 	}
141 	
142     function sendTokens(address _to, uint256 _value) onlyOwner public {
143 		_transfer(this, _to, _value);
144     }
145 	
146 	function setTokensPerEther(uint256 newTokensPerEther) onlyOwner public {
147         tokensPerEther = newTokensPerEther;
148     }
149 
150     // @notice Fallback function to allow token buys with Ether
151 	function() payable public {
152         uint amount = (msg.value * tokensPerEther); 		// calculates the amount of tokens to send
153 		_transfer(this, msg.sender, amount);              	// Send token to depositor
154     }
155 }