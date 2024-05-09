1 pragma solidity ^0.4.25;
2 
3 interface tokenRecipient { function receiveApproval(address _from, uint256 _value, address _token, bytes _extraData) public; }
4 
5 contract TokenERC20 {
6     string public name; // ERC20
7     string public symbol; // ERC20
8     uint8 public decimals = 18;  // ERC20 ，decimals You can have the number of decimal points, the smallest token unit. 18 is the recommended default
9     uint256 public totalSupply; // ERC20 Total supply
10 
11     // Using mapping to save the balance erc20 standard corresponding to each address
12     mapping (address => uint256) public balanceOf;
13     //Storage control of account erc20 standard
14     mapping (address => mapping (address => uint256)) public allowance;
15 
16     // Event to notify the client of erc20
17     event Transfer(address indexed from, address indexed to, uint256 value);
18 
19     // Event to notify the client that the token is consumed by erc20 standard
20     event Burn(address indexed from, uint256 value);
21 
22     /**
23      * Initialize construction
24      */
25     function TokenERC20(uint256 initialSupply, string tokenName, string tokenSymbol) public {
26         totalSupply = initialSupply * 10 ** uint256(decimals);  // Share of supply, which is related to the smallest token unit, share = number of coins * 10 * * decimals.。
27         balanceOf[msg.sender] = totalSupply;                // Creator owns all tokens
28         name = tokenName;                                   // Token name
29         symbol = tokenSymbol;                               // Token symbol
30     }
31 
32     /**
33      * Internal realization of token transaction transfer
34      */
35     function _transfer(address _from, address _to, uint _value) internal {
36         // Make sure the destination address is not 0x0 because 0x0 addresses represent destruction
37         require(_to != 0x0);
38         // Check sender balance
39         require(balanceOf[_from] >= _value);
40         // Make sure the transfer is positive
41         require(balanceOf[_to] + _value > balanceOf[_to]);
42 
43         // The following are used to check transactions,
44         uint previousBalances = balanceOf[_from] + balanceOf[_to];
45         // Subtract from the sender
46         balanceOf[_from] -= _value;
47         // Add the same to the recipient
48         balanceOf[_to] += _value;
49         Transfer(_from, _to, _value);
50 
51         // Use assert to check the code logic.
52         assert(balanceOf[_from] + balanceOf[_to] == previousBalances);
53     }
54 
55     /**
56      *  Token transaction transfer
57      *  Send from your (create trader) account`_ Value token to`_ To account
58      * ERC20 standard
59      * @param _to Recipient address
60      * @param _value Transfer amount
61      */
62     function transfer(address _to, uint256 _value) public {
63         _transfer(msg.sender, _to, _value);
64     }
65 
66     /**
67      * Transfer of token transactions between account numbers
68      * ERC20
69      * @param _from 
70      * @param _to 
71      * @param _value 
72      */
73     function transferFrom(address _from, address _to, uint256 _value) public returns (bool success) {
74         require(_value <= allowance[_from][msg.sender]);     // Check allowance
75         allowance[_from][msg.sender] -= _value;
76         _transfer(_from, _to, _value);
77         return true;
78     }
79 
80     /**
81      * Set the number of tokens that an address (contract) can use to create a trader's name.
82      *
83      * Allow sender`_ Spender costs no more than`_ Value tokens
84      * ERC20
85      * @param _spender The address authorized to spend
86      * @param _value the max amount they can spend
87      */
88     function approve(address _spender, uint256 _value) public
89     returns (bool success) {
90         allowance[msg.sender][_spender] = _value;
91         return true;
92     }
93 
94     /**
95      * Set the maximum number of tokens that an address (contract) can spend in my name (create trader).
96      
97      * @param _spender 
98      * @param _value 
99      * @param _extraData 
100      */
101     function approveAndCall(address _spender, uint256 _value, bytes _extraData)
102     public
103     returns (bool success) {
104         tokenRecipient spender = tokenRecipient(_spender);
105         if (approve(_spender, _value)) {
106           
107             spender.receiveApproval(msg.sender, _value, this, _extraData);
108             return true;
109         }
110     }
111 
112     /**
113      * Destroy the tokens specified in my (create trader) account
114      *-wrong ERC20
115      */
116     function burn(uint256 _value) public returns (bool success) {
117         require(balanceOf[msg.sender] >= _value);   // Check if the sender has enough
118         balanceOf[msg.sender] -= _value;            // Subtract from the sender
119         totalSupply -= _value;                      // Updates totalSupply
120         Burn(msg.sender, _value);
121         return true;
122     }
123 
124     /**
125      * Destroy the specified token in the user account
126      *-wrong ERC20 
127      * Remove `_value` tokens from the system irreversibly on behalf of `_from`.
128      *
129      * @param _from the address of the sender
130      * @param _value the amount of money to burn
131      */
132     function burnFrom(address _from, uint256 _value) public returns (bool success) {
133         require(balanceOf[_from] >= _value);                // Check if the targeted balance is enough
134         require(_value <= allowance[_from][msg.sender]);    // Check allowance
135         balanceOf[_from] -= _value;                         // Subtract from the targeted balance
136         allowance[_from][msg.sender] -= _value;             // Subtract from the sender's allowance
137         totalSupply -= _value;                              // Update totalSupply
138         Burn(_from, _value);
139         return true;
140     }
141 }