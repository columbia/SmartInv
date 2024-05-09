1 pragma solidity ^0.4.13;
2 
3 contract tokenRecipient { function receiveApproval(address _from, uint256 _value, address _token, bytes _extraData); }
4 
5 contract MyToken {
6     /* Public variables of the token */
7     string public name;
8     string public symbol;
9     uint8 public decimals;
10     uint256 public totalSupply;
11 
12     /* This creates an array with all balances */
13     mapping (address => uint256) public balanceOf;
14     mapping (address => mapping (address => uint256)) public allowance;
15 
16     /* This generates a public event on the blockchain that will notify clients */
17     event Transfer(address indexed from, address indexed to, uint256 value);
18 
19     /* This notifies clients about the amount burnt */
20     event Burn(address indexed from, uint256 value);
21 
22     /* Initializes contract with initial supply tokens to the creator of the contract */
23     function MyToken(
24         uint256 initialSupply,
25         string tokenName,
26         uint8 decimalUnits,
27         string tokenSymbol
28         ) {
29         balanceOf[msg.sender] = initialSupply;              // Give the creator all initial tokens
30         totalSupply = initialSupply;                        // Update total supply
31         name = tokenName;                                   // Set the name for display purposes
32         symbol = tokenSymbol;                               // Set the symbol for display purposes
33         decimals = decimalUnits;                            // Amount of decimals for display purposes
34     }
35 
36     /* Internal transfer, only can be called by this contract */
37     function _transfer(address _from, address _to, uint _value) internal {
38         require (_to != 0x0);                               // Prevent transfer to 0x0 address. Use burn() instead
39         require (balanceOf[_from] > _value);                // Check if the sender has enough
40         require (balanceOf[_to] + _value > balanceOf[_to]); // Check for overflows
41         balanceOf[_from] -= _value;                         // Subtract from the sender
42         balanceOf[_to] += _value;                            // Add the same to the recipient
43         Transfer(_from, _to, _value);
44     }
45 
46     /// @notice Send `_value` tokens to `_to` from your account
47     /// @param _to The address of the recipient
48     /// @param _value the amount to send
49     function transfer(address _to, uint256 _value) {
50         _transfer(msg.sender, _to, _value);
51     }
52 
53     /// @notice Send `_value` tokens to `_to` in behalf of `_from`
54     /// @param _from The address of the sender
55     /// @param _to The address of the recipient
56     /// @param _value the amount to send
57     function transferFrom(address _from, address _to, uint256 _value) returns (bool success) {
58         require (_value < allowance[_from][msg.sender]);     // Check allowance
59         allowance[_from][msg.sender] -= _value;
60         _transfer(_from, _to, _value);
61         return true;
62     }
63 
64     /// @notice Allows `_spender` to spend no more than `_value` tokens in your behalf
65     /// @param _spender The address authorized to spend
66     /// @param _value the max amount they can spend
67     function approve(address _spender, uint256 _value)
68         returns (bool success) {
69         allowance[msg.sender][_spender] = _value;
70         return true;
71     }
72 
73     /// @notice Allows `_spender` to spend no more than `_value` tokens in your behalf, and then ping the contract about it
74     /// @param _spender The address authorized to spend
75     /// @param _value the max amount they can spend
76     /// @param _extraData some extra information to send to the approved contract
77     function approveAndCall(address _spender, uint256 _value, bytes _extraData)
78         returns (bool success) {
79         tokenRecipient spender = tokenRecipient(_spender);
80         if (approve(_spender, _value)) {
81             spender.receiveApproval(msg.sender, _value, this, _extraData);
82             return true;
83         }
84     }        
85 
86     /// @notice Remove `_value` tokens from the system irreversibly
87     /// @param _value the amount of money to burn
88     function burn(uint256 _value) returns (bool success) {
89         require (balanceOf[msg.sender] > _value);            // Check if the sender has enough
90         balanceOf[msg.sender] -= _value;                      // Subtract from the sender
91         totalSupply -= _value;                                // Updates totalSupply
92         Burn(msg.sender, _value);
93         return true;
94     }
95 
96     function burnFrom(address _from, uint256 _value) returns (bool success) {
97         require(balanceOf[_from] >= _value);                // Check if the targeted balance is enough
98         require(_value <= allowance[_from][msg.sender]);    // Check allowance
99         balanceOf[_from] -= _value;                         // Subtract from the targeted balance
100         allowance[_from][msg.sender] -= _value;             // Subtract from the sender's allowance
101         totalSupply -= _value;                              // Update totalSupply
102         Burn(_from, _value);
103         return true;
104     }
105 }