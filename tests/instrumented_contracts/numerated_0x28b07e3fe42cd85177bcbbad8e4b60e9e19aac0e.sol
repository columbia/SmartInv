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
49         balanceOf[msg.sender] = totalSupply;                // Give the creator all initial tokens
50         name = tokenName;                                   // Set the name for display purposes
51         symbol = tokenSymbol;                               // Set the symbol for display purposes
52     }
53 	
54     function balanceOf(address _owner) public constant returns (uint256 balance) {
55         return balanceOf[_owner];
56     }
57 
58     /**
59      * Internal transfer, only can be called by this contract
60      */
61     function _transfer(address _from, address _to, uint _value) internal {
62         // Prevent transfer to 0x0 address. Use burn() instead
63         require(_to != 0x0);
64         // Check if the sender has enough
65         require(balanceOf[_from] >= _value);
66         // Check for overflows
67         require(balanceOf[_to] + _value > balanceOf[_to]);
68         // Save this for an assertion in the future
69         uint previousBalances = balanceOf[_from] + balanceOf[_to];
70         // Subtract from the sender
71         balanceOf[_from] -= _value;
72         // Add the same to the recipient
73         balanceOf[_to] += _value;
74         Transfer(_from, _to, _value);
75         // Asserts are used to use static analysis to find bugs in your code. They should never fail
76         assert(balanceOf[_from] + balanceOf[_to] == previousBalances);
77     }
78 
79     /**
80      * Transfer tokens
81      *
82      * Send `_value` tokens to `_to` from your account
83      *
84      * @param _to The address of the recipient
85      * @param _value the amount to send
86      */
87     function transfer(address _to, uint256 _value) public {
88         _transfer(msg.sender, _to, _value);
89     }
90 
91     /**
92      * Transfer tokens from other address
93      *
94      * Send `_value` tokens to `_to` in behalf of `_from`
95      *
96      * @param _from The address of the sender
97      * @param _to The address of the recipient
98      * @param _value the amount to send
99      */
100     function transferFrom(address _from, address _to, uint256 _value) public returns (bool success) {
101         require(_value <= allowance[_from][msg.sender]);     // Check allowance
102         allowance[_from][msg.sender] -= _value;
103         _transfer(_from, _to, _value);
104         return true;
105     }
106 
107     /**
108      * Set allowance for other address
109      *
110      * Allows `_spender` to spend no more than `_value` tokens in your behalf
111      *
112      * @param _spender The address authorized to spend
113      * @param _value the max amount they can spend
114      */
115     function approve(address _spender, uint256 _value) public
116         returns (bool success) {
117         allowance[msg.sender][_spender] = _value;
118         return true;
119     }
120 
121     /**
122      * Set allowance for other address and notify
123      *
124      * Allows `_spender` to spend no more than `_value` tokens in your behalf, and then ping the contract about it
125      *
126      * @param _spender The address authorized to spend
127      * @param _value the max amount they can spend
128      * @param _extraData some extra information to send to the approved contract
129      */
130     function approveAndCall(address _spender, uint256 _value, bytes _extraData)
131         public
132         returns (bool success) {
133         tokenRecipient spender = tokenRecipient(_spender);
134         if (approve(_spender, _value)) {
135             spender.receiveApproval(msg.sender, _value, this, _extraData);
136             return true;
137         }
138     }
139 	
140 	function allowance(address _owner, address _spender) public constant returns (uint256 remaining) {
141         return allowance[_owner][_spender];
142     }
143 }
144 
145 /******************************************/
146 /*       ADVANCED TOKEN STARTS HERE       */
147 /******************************************/
148 
149 contract MyAdvancedToken is owned, TokenERC20 {
150 
151     uint256 public sellPrice;
152     uint256 public buyPrice;
153 
154     mapping (address => bool) public frozenAccount;
155 
156     /* This generates a public event on the blockchain that will notify clients */
157     event FrozenFunds(address target, bool frozen);
158 
159     /* Initializes contract with initial supply tokens to the creator of the contract */
160     function MyAdvancedToken(
161         uint256 initialSupply,
162         string tokenName,
163         string tokenSymbol
164     ) TokenERC20(initialSupply, tokenName, tokenSymbol) public {}
165 
166     /* Internal transfer, only can be called by this contract */
167     function _transfer(address _from, address _to, uint _value) internal {
168         require (_to != 0x0);                               // Prevent transfer to 0x0 address. Use burn() instead
169         require (balanceOf[_from] >= _value);               // Check if the sender has enough
170         require (balanceOf[_to] + _value > balanceOf[_to]); // Check for overflows
171         require(!frozenAccount[_from]);                     // Check if sender is frozen
172         require(!frozenAccount[_to]);                       // Check if recipient is frozen
173         balanceOf[_from] -= _value;                         // Subtract from the sender
174         balanceOf[_to] += _value;                           // Add the same to the recipient
175         Transfer(_from, _to, _value);
176     }
177 }