1 pragma solidity ^0.4.16;
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
22 contract TokenERC20 {
23     // Public variables of the token
24     string public name;
25     string public symbol;
26     uint8 public decimals = 18;
27     // 18 decimals is the strongly suggested default, avoid changing it
28     uint256 public totalSupply;
29 
30     // This creates an array with all balances
31     mapping (address => uint256) public balanceOf;
32     mapping (address => mapping (address => uint256)) public allowance;
33 
34     // This generates a public event on the blockchain that will notify clients
35     event Transfer(address indexed from, address indexed to, uint256 value);
36 
37     /**
38      * Constrctor function
39      *
40      * Initializes contract with initial supply tokens to the creator of the contract
41      */
42     function TokenERC20(
43         uint256 initialSupply,
44         string tokenName,
45         string tokenSymbol
46     ) public {
47         totalSupply = initialSupply * 10 ** uint256(decimals);  // Update total supply with the decimal amount
48         balanceOf[msg.sender] = totalSupply;                // Give the creator all initial tokens
49         name = tokenName;                                   // Set the name for display purposes
50         symbol = tokenSymbol;                               // Set the symbol for display purposes
51     }
52 
53     /**
54      * Internal transfer, only can be called by this contract
55      */
56     function _transfer(address _from, address _to, uint _value) internal {
57         // Prevent transfer to 0x0 address. Use burn() instead
58         require(_to != 0x0);
59         // Check if the sender has enough
60         require(balanceOf[_from] >= _value);
61         // Check for overflows
62         require(balanceOf[_to] + _value > balanceOf[_to]);
63         // Save this for an assertion in the future
64         uint previousBalances = balanceOf[_from] + balanceOf[_to];
65         // Subtract from the sender
66         balanceOf[_from] -= _value;
67         // Add the same to the recipient
68         balanceOf[_to] += _value;
69         Transfer(_from, _to, _value);
70         // Asserts are used to use static analysis to find bugs in your code. They should never fail
71         assert(balanceOf[_from] + balanceOf[_to] == previousBalances);
72     }
73 
74     /**
75      * Transfer tokens
76      *
77      * Send `_value` tokens to `_to` from your account
78      *
79      * @param _to The address of the recipient
80      * @param _value the amount to send
81      */
82     function transfer(address _to, uint256 _value) public {
83         _transfer(msg.sender, _to, _value);
84     }
85 
86     /**
87      * Transfer tokens from other address
88      *
89      * Send `_value` tokens to `_to` in behalf of `_from`
90      *
91      * @param _from The address of the sender
92      * @param _to The address of the recipient
93      * @param _value the amount to send
94      */
95     function transferFrom(address _from, address _to, uint256 _value) public returns (bool success) {
96         require(_value <= allowance[_from][msg.sender]);     // Check allowance
97         allowance[_from][msg.sender] -= _value;
98         _transfer(_from, _to, _value);
99         return true;
100     }
101 
102     /**
103      * Set allowance for other address
104      *
105      * Allows `_spender` to spend no more than `_value` tokens in your behalf
106      *
107      * @param _spender The address authorized to spend
108      * @param _value the max amount they can spend
109      */
110     function approve(address _spender, uint256 _value) public
111         returns (bool success) {
112         allowance[msg.sender][_spender] = _value;
113         return true;
114     }
115 
116     /**
117      * Set allowance for other address and notify
118      *
119      * Allows `_spender` to spend no more than `_value` tokens in your behalf, and then ping the contract about it
120      *
121      * @param _spender The address authorized to spend
122      * @param _value the max amount they can spend
123      * @param _extraData some extra information to send to the approved contract
124      */
125     function approveAndCall(address _spender, uint256 _value, bytes _extraData)
126         public
127         returns (bool success) {
128         tokenRecipient spender = tokenRecipient(_spender);
129         if (approve(_spender, _value)) {
130             spender.receiveApproval(msg.sender, _value, this, _extraData);
131             return true;
132         }
133     }
134 }
135 
136 
137 contract CDonateToken is owned, TokenERC20 {
138 
139     /* Initializes contract with initial supply tokens to the creator of the contract */
140     function CDonateToken(
141         uint256 initialSupply,
142         string tokenName,
143         string tokenSymbol
144     ) TokenERC20(initialSupply, tokenName, tokenSymbol) public {}
145 }