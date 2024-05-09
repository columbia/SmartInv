1 // SPDX-License-Identifier: NONE
2 
3 pragma solidity 0.5.17;
4 
5 
6 
7 // Part: tokenRecipient
8 
9 interface tokenRecipient { 
10     function receiveApproval(address _from, uint256 _value, address _token, bytes calldata _extraData) external; 
11 }
12 
13 // File: TokenERC20.sol
14 
15 contract TokenERC20 {
16     // Public variables of the token
17     string public name;
18     string public symbol;
19     uint8 public decimals = 18;
20     // 18 decimals is the strongly suggested default, avoid changing it
21     uint256 public totalSupply;
22 
23     // This creates an array with all balances
24     mapping (address => uint256) public balanceOf;
25     mapping (address => mapping (address => uint256)) public allowance;
26 
27     // This generates a public event on the blockchain that will notify clients
28     event Transfer(address indexed from, address indexed to, uint256 value);
29     
30     // This generates a public event on the blockchain that will notify clients
31     event Approval(address indexed _owner, address indexed _spender, uint256 _value);
32 
33     // This notifies clients about the amount burnt
34     event Burn(address indexed from, uint256 value);
35 
36     /**
37      * Constructor function
38      *
39      * Initializes contract with initial supply tokens to the creator of the contract
40      */
41     constructor(
42         uint256 initialSupply,
43         string memory tokenName,
44         string memory tokenSymbol
45     ) public {
46         totalSupply = initialSupply * 10 ** uint256(decimals);  // Update total supply with the decimal amount
47         balanceOf[msg.sender] = totalSupply;                // Give the creator all initial tokens
48         name = tokenName;                                   // Set the name for display purposes
49         symbol = tokenSymbol;                               // Set the symbol for display purposes
50     }
51 
52     /**
53      * Internal transfer, only can be called by this contract
54      */
55     function _transfer(address _from, address _to, uint _value) internal {
56         // Prevent transfer to 0x0 address. Use burn() instead
57         require(_to != address(0x0));
58         // Check if the sender has enough
59         require(balanceOf[_from] >= _value);
60         // Check for overflows
61         require(balanceOf[_to] + _value >= balanceOf[_to]);
62         // Save this for an assertion in the future
63         uint previousBalances = balanceOf[_from] + balanceOf[_to];
64         // Subtract from the sender
65         balanceOf[_from] -= _value;
66         // Add the same to the recipient
67         balanceOf[_to] += _value;
68         emit Transfer(_from, _to, _value);
69         // Asserts are used to use static analysis to find bugs in your code. They should never fail
70         assert(balanceOf[_from] + balanceOf[_to] == previousBalances);
71     }
72 
73     /**
74      * Transfer tokens
75      *
76      * Send `_value` tokens to `_to` from your account
77      *
78      * @param _to The address of the recipient
79      * @param _value the amount to send
80      */
81     function transfer(address _to, uint256 _value) public returns (bool success) {
82         _transfer(msg.sender, _to, _value);
83         return true;
84     }
85 
86     /**
87      * Transfer tokens from other address
88      *
89      * Send `_value` tokens to `_to` on behalf of `_from`
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
105      * Allows `_spender` to spend no more than `_value` tokens on your behalf
106      *
107      * @param _spender The address authorized to spend
108      * @param _value the max amount they can spend
109      */
110     function approve(address _spender, uint256 _value) public
111         returns (bool success) {
112         allowance[msg.sender][_spender] = _value;
113         emit Approval(msg.sender, _spender, _value);
114         return true;
115     }
116 
117     /**
118      * Set allowance for other address and notify
119      *
120      * Allows `_spender` to spend no more than `_value` tokens on your behalf, and then ping the contract about it
121      *
122      * @param _spender The address authorized to spend
123      * @param _value the max amount they can spend
124      * @param _extraData some extra information to send to the approved contract
125      */
126     function approveAndCall(address _spender, uint256 _value, bytes memory _extraData)
127         public
128         returns (bool success) {
129         tokenRecipient spender = tokenRecipient(_spender);
130         if (approve(_spender, _value)) {
131             spender.receiveApproval(msg.sender, _value, address(this), _extraData);
132             return true;
133         }
134     }
135 
136     /**
137      * Destroy tokens
138      *
139      * Remove `_value` tokens from the system irreversibly
140      *
141      * @param _value the amount of money to burn
142      */
143     function burn(uint256 _value) public returns (bool success) {
144         require(balanceOf[msg.sender] >= _value);   // Check if the sender has enough
145         balanceOf[msg.sender] -= _value;            // Subtract from the sender
146         totalSupply -= _value;                      // Updates totalSupply
147         emit Burn(msg.sender, _value);
148         return true;
149     }
150 
151     /**
152      * Destroy tokens from other account
153      *
154      * Remove `_value` tokens from the system irreversibly on behalf of `_from`.
155      *
156      * @param _from the address of the sender
157      * @param _value the amount of money to burn
158      */
159     function burnFrom(address _from, uint256 _value) public returns (bool success) {
160         require(balanceOf[_from] >= _value);                // Check if the targeted balance is enough
161         require(_value <= allowance[_from][msg.sender]);    // Check allowance
162         balanceOf[_from] -= _value;                         // Subtract from the targeted balance
163         allowance[_from][msg.sender] -= _value;             // Subtract from the sender's allowance
164         totalSupply -= _value;                              // Update totalSupply
165         emit Burn(_from, _value);
166         return true;
167     }
168 }
