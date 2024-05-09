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
22 contract TokenERC20 is owned {
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
37     // This notifies clients about the amount burnt
38     event Burn(address indexed from, uint256 value);
39 
40     /**
41      * Constrctor function
42      *
43      * Initializes contract with initial supply tokens to the creator of the contract
44      */
45     function TokenERC20(
46         uint256 initialSupply,
47         string tokenName,
48         string tokenSymbol
49     ) public {
50         totalSupply = initialSupply * 10 ** uint256(decimals);  // Update total supply with the decimal amount
51         balanceOf[msg.sender] = totalSupply;                // Give the creator all initial tokens
52         name = tokenName;                                   // Set the name for display purposes
53         symbol = tokenSymbol;                               // Set the symbol for display purposes
54     }
55 
56     /**
57      * Internal transfer, only can be called by this contract
58      */
59     function _transfer(address _from, address _to, uint _value) internal {
60         // Prevent transfer to 0x0 address. Use burn() instead
61         require(_to != 0x0);
62         // Check if the sender has enough
63         require(balanceOf[_from] >= _value);
64         // Check for overflows
65         require(balanceOf[_to] + _value > balanceOf[_to]);
66         // Save this for an assertion in the future
67         uint previousBalances = balanceOf[_from] + balanceOf[_to];
68         // Subtract from the sender
69         balanceOf[_from] -= _value;
70         // Add the same to the recipient
71         balanceOf[_to] += _value;
72         Transfer(_from, _to, _value);
73         // Asserts are used to use static analysis to find bugs in your code. They should never fail
74         assert(balanceOf[_from] + balanceOf[_to] == previousBalances);
75     }
76     /**
77      * Transfer tokens
78      *
79      * Send `_value` tokens to `_to` from your account
80      *
81      * @param _to The address of the recipient
82      * @param _value the amount to send
83      */
84     function transfer(address _to, uint256 _value) public {
85         _transfer(msg.sender, _to, _value);
86     }
87     /**
88      * Transfer tokens from other address
89      *
90      * Send `_value` tokens to `_to` in behalf of `_from`
91      *
92      * @param _from The address of the sender
93      * @param _to The address of the recipient
94      * @param _value the amount to send
95      */
96     function transferFrom(address _from, address _to, uint256 _value) public returns (bool success) {
97         require(_value <= allowance[_from][msg.sender]);     // Check allowance
98         allowance[_from][msg.sender] -= _value;
99         _transfer(_from, _to, _value);
100         return true;
101     }
102 
103     /**
104      * Set allowance for other address
105      *
106      * Allows `_spender` to spend no more than `_value` tokens in your behalf
107      *
108      * @param _spender The address authorized to spend
109      * @param _value the max amount they can spend
110      */
111     function approve(address _spender, uint256 _value) public
112     returns (bool success) {
113         allowance[msg.sender][_spender] = _value;
114         return true;
115     }
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
126     public
127     returns (bool success) {
128         tokenRecipient spender = tokenRecipient(_spender);
129         if (approve(_spender, _value)) {
130             spender.receiveApproval(msg.sender, _value, this, _extraData);
131             return true;
132         }
133     }
134     /**
135      * Destroy tokens
136      *
137      * Remove `_value` tokens from the system irreversibly
138      *
139      * @param _value the amount of money to burn
140      */
141     function burn(uint256 _value) onlyOwner public returns (bool success)  {
142         require(balanceOf[msg.sender] >= _value);   // Check if the sender has enough
143         balanceOf[msg.sender] -= _value;            // Subtract from the sender
144         totalSupply -= _value;                      // Updates totalSupply
145         Burn(msg.sender, _value);
146         return true;
147     }
148 }