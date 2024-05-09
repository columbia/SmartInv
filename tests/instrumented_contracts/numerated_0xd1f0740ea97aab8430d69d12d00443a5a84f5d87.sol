1 pragma solidity ^0.4.13;
2 
3 contract tokenRecipient { function receiveApproval(address _from, uint256 _value, address _token, bytes _extraData); }
4 
5 contract owned {
6     address public owner;
7 
8     function owned() {
9         owner = msg.sender;
10     }
11 
12     modifier onlyOwner {
13         require(msg.sender == owner);
14         _;
15     }
16 
17     function transferOwnership(address newOwner) onlyOwner {
18         owner = newOwner;
19     }
20 }
21 
22 contract MyToken is owned {
23     /* Public variables of the token */
24     string public name;
25     string public symbol;
26     uint8 public decimals;
27     uint256 public totalSupply;
28 
29     /* This creates an array with all balances */
30     mapping (address => uint256) public balanceOf;
31     mapping (address => mapping (address => uint256)) public allowance;
32     mapping (address => bool) public frozenAccount;
33 
34     /* This generates a public event on the blockchain that will notify clients */
35     event Transfer(address indexed from, address indexed to, uint256 value);
36 
37     /* This notifies clients about the amount burnt */
38     event Burn(address indexed from, uint256 value);
39 
40     /* This generates a public event on the blockchain that will notify clients */
41     event FrozenFunds(address target, bool frozen);
42 
43     /* Initializes contract with initial supply tokens to the creator of the contract */
44     function MyToken(
45         uint256 initialSupply,
46         string tokenName,
47         uint8 decimalUnits,
48         string tokenSymbol
49         ) {
50         balanceOf[msg.sender] = initialSupply;              // Give the creator all initial tokens
51         totalSupply = initialSupply;                        // Update total supply
52         name = tokenName;                                   // Set the name for display purposes
53         symbol = tokenSymbol;                               // Set the symbol for display purposes
54         decimals = decimalUnits;                            // Amount of decimals for display purposes
55     }
56 
57     /* Internal transfer, only can be called by this contract */
58     function _transfer(address _from, address _to, uint _value) internal {
59         require (_to != 0x0);                               // Prevent transfer to 0x0 address. Use burn() instead
60         require (balanceOf[_from] > _value);                // Check if the sender has enough
61         require (balanceOf[_to] + _value > balanceOf[_to]); // Check for overflows
62         balanceOf[_from] -= _value;                         // Subtract from the sender
63         balanceOf[_to] += _value;                            // Add the same to the recipient
64         Transfer(_from, _to, _value);
65     }
66 
67 
68     function mintToken(address target, uint256 mintedAmount) onlyOwner {
69         balanceOf[target] += mintedAmount;
70         totalSupply += mintedAmount;
71         Transfer(0, this, mintedAmount);
72         Transfer(this, target, mintedAmount);
73   }
74 
75   /// @notice `freeze? Prevent | Allow` `target` from sending & receiving tokens
76   /// @param target Address to be frozen
77   /// @param freeze either to freeze it or not
78   function freezeAccount(address target, bool freeze) onlyOwner {
79       frozenAccount[target] = freeze;
80       FrozenFunds(target, freeze);
81   }
82 
83     /// @notice Send `_value` tokens to `_to` from your account
84     /// @param _to The address of the recipient
85     /// @param _value the amount to send
86     function transfer(address _to, uint256 _value) {
87         _transfer(msg.sender, _to, _value);
88     }
89 
90     /// @notice Send `_value` tokens to `_to` in behalf of `_from`
91     /// @param _from The address of the sender
92     /// @param _to The address of the recipient
93     /// @param _value the amount to send
94     function transferFrom(address _from, address _to, uint256 _value) returns (bool success) {
95         require (_value < allowance[_from][msg.sender]);     // Check allowance
96         allowance[_from][msg.sender] -= _value;
97         _transfer(_from, _to, _value);
98         return true;
99     }
100 
101     /// @notice Allows `_spender` to spend no more than `_value` tokens in your behalf
102     /// @param _spender The address authorized to spend
103     /// @param _value the max amount they can spend
104     function approve(address _spender, uint256 _value)
105         returns (bool success) {
106         allowance[msg.sender][_spender] = _value;
107         return true;
108     }
109 
110     /// @notice Allows `_spender` to spend no more than `_value` tokens in your behalf, and then ping the contract about it
111     /// @param _spender The address authorized to spend
112     /// @param _value the max amount they can spend
113     /// @param _extraData some extra information to send to the approved contract
114     function approveAndCall(address _spender, uint256 _value, bytes _extraData)
115         returns (bool success) {
116         tokenRecipient spender = tokenRecipient(_spender);
117         if (approve(_spender, _value)) {
118             spender.receiveApproval(msg.sender, _value, this, _extraData);
119             return true;
120         }
121     }        
122 
123     /// @notice Remove `_value` tokens from the system irreversibly
124     /// @param _value the amount of money to burn
125     function burn(uint256 _value) returns (bool success) {
126         require (balanceOf[msg.sender] > _value);            // Check if the sender has enough
127         balanceOf[msg.sender] -= _value;                      // Subtract from the sender
128         totalSupply -= _value;                                // Updates totalSupply
129         Burn(msg.sender, _value);
130         return true;
131     }
132 
133     function burnFrom(address _from, uint256 _value) returns (bool success) {
134         require(balanceOf[_from] >= _value);                // Check if the targeted balance is enough
135         require(_value <= allowance[_from][msg.sender]);    // Check allowance
136         balanceOf[_from] -= _value;                         // Subtract from the targeted balance
137         allowance[_from][msg.sender] -= _value;             // Subtract from the sender's allowance
138         totalSupply -= _value;                              // Update totalSupply
139         Burn(_from, _value);
140         return true;
141     }
142 }