1 pragma solidity 0.4.24;
2 
3 /**
4  * Pivot Token
5  * 
6  * Issued by PIVOT BLOCKCHAIN PTE. LTD.
7  */
8 
9 // -----------------------------------------------------------------------------
10 // An ERC20 Standard 
11 interface tokenRecipient { function receiveApproval(address _from, uint256 _value, address _token, bytes _extraData) external; }
12 
13 contract TokenERC20 {
14     // Public variables of the token
15     string public name;
16     string public symbol;
17     uint8 public decimals = 18;
18     // 18 decimals is the strongly suggested default, avoid changing it
19     uint256 public totalSupply;
20 
21     // This creates an array with all balances
22     mapping (address => uint256) public balanceOf;
23     mapping (address => mapping (address => uint256)) public allowance;
24 
25     // This generates a public event on the blockchain that will notify clients
26     event Transfer(address indexed from, address indexed to, uint256 value);
27     
28     // This generates a public event on the blockchain that will notify clients
29     event Approval(address indexed _owner, address indexed _spender, uint256 _value);
30 
31     // This notifies clients about the amount burnt
32     event Burn(address indexed from, uint256 value);
33 
34     /**
35      * Constructor function
36      *
37      * Initializes contract with initial supply tokens to the creator of the contract
38      */
39     constructor(
40         uint256 initialSupply,
41         string tokenName,
42         string tokenSymbol
43     ) public {
44         totalSupply = initialSupply * 10 ** uint256(decimals);  // Update total supply with the decimal amount
45         balanceOf[msg.sender] = totalSupply;                // Give the creator all initial tokens
46         name = tokenName;                                   // Set the name for display purposes
47         symbol = tokenSymbol;                               // Set the symbol for display purposes
48     }
49 
50     /**
51      * Internal transfer, only can be called by this contract
52      */
53     function _transfer(address _from, address _to, uint _value) internal {
54         // Prevent transfer to 0x0 address. Use burn() instead
55         require(_to != 0x0);
56         // Check if the sender has enough
57         require(balanceOf[_from] >= _value);
58         // Check for overflows
59         require(balanceOf[_to] + _value >= balanceOf[_to]);
60         // Save this for an assertion in the future
61         uint previousBalances = balanceOf[_from] + balanceOf[_to];
62         // Subtract from the sender
63         balanceOf[_from] -= _value;
64         // Add the same to the recipient
65         balanceOf[_to] += _value;
66         emit Transfer(_from, _to, _value);
67         // Asserts are used to use static analysis to find bugs in your code. They should never fail
68         assert(balanceOf[_from] + balanceOf[_to] == previousBalances);
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
124     function approveAndCall(address _spender, uint256 _value, bytes _extraData)
125         public
126         returns (bool success) {
127         tokenRecipient spender = tokenRecipient(_spender);
128         if (approve(_spender, _value)) {
129             spender.receiveApproval(msg.sender, _value, this, _extraData);
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
148 }
149 // -----------------------------------------------------------------------------
150 
151 contract PivotToken is TokenERC20 {
152     constructor() TokenERC20(31415926535, "Pivot Token", "PVT") public {
153     }
154 }