1 pragma solidity ^0.4.15;
2 
3 contract tokenRecipient { function receiveApproval(address _from, uint256 _value, address _token, bytes _extraData); }
4 
5 contract SchmeckleToken {
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
23     function SchmeckleToken() {
24         uint initialSupply = 28000000000000000000000000;
25         balanceOf[msg.sender] = initialSupply;              // Give the creator all initial tokens
26         totalSupply = initialSupply;                        // Update total supply
27         name = "Schmeckle Token";                                   // Set the name for display purposes
28         symbol = "SHM";                               // Set the symbol for display purposes
29         decimals = 18;                            // Amount of decimals for display purposes
30     }
31 
32     /* Internal transfer, only can be called by this contract */
33     function _transfer(address _from, address _to, uint _value) internal {
34         require (_to != 0x0);                               // Prevent transfer to 0x0 address. Use burn() instead
35         require (balanceOf[_from] > _value);                // Check if the sender has enough
36         require (balanceOf[_to] + _value > balanceOf[_to]); // Check for overflows
37         balanceOf[_from] -= _value;                         // Subtract from the sender
38         balanceOf[_to] += _value;                            // Add the same to the recipient
39         Transfer(_from, _to, _value);
40     }
41 
42     /// @notice Send `_value` tokens to `_to` from your account
43     /// @param _to The address of the recipient
44     /// @param _value the amount to send
45     function transfer(address _to, uint256 _value) {
46         _transfer(msg.sender, _to, _value);
47     }
48 
49     /// @notice Send `_value` tokens to `_to` in behalf of `_from`
50     /// @param _from The address of the sender
51     /// @param _to The address of the recipient
52     /// @param _value the amount to send
53     function transferFrom(address _from, address _to, uint256 _value) returns (bool success) {
54         require (_value < allowance[_from][msg.sender]);     // Check allowance
55         allowance[_from][msg.sender] -= _value;
56         _transfer(_from, _to, _value);
57         return true;
58     }
59 
60     /// @notice Allows `_spender` to spend no more than `_value` tokens in your behalf
61     /// @param _spender The address authorized to spend
62     /// @param _value the max amount they can spend
63     function approve(address _spender, uint256 _value)
64         returns (bool success) {
65         allowance[msg.sender][_spender] = _value;
66         return true;
67     }
68 
69     /// @notice Allows `_spender` to spend no more than `_value` tokens in your behalf, and then ping the contract about it
70     /// @param _spender The address authorized to spend
71     /// @param _value the max amount they can spend
72     /// @param _extraData some extra information to send to the approved contract
73     function approveAndCall(address _spender, uint256 _value, bytes _extraData)
74         returns (bool success) {
75         tokenRecipient spender = tokenRecipient(_spender);
76         if (approve(_spender, _value)) {
77             spender.receiveApproval(msg.sender, _value, this, _extraData);
78             return true;
79         }
80     }        
81 
82     /// @notice Remove `_value` tokens from the system irreversibly
83     /// @param _value the amount of money to burn
84     function burn(uint256 _value) returns (bool success) {
85         require (balanceOf[msg.sender] > _value);            // Check if the sender has enough
86         balanceOf[msg.sender] -= _value;                      // Subtract from the sender
87         totalSupply -= _value;                                // Updates totalSupply
88         Burn(msg.sender, _value);
89         return true;
90     }
91 
92     function burnFrom(address _from, uint256 _value) returns (bool success) {
93         require(balanceOf[_from] >= _value);                // Check if the targeted balance is enough
94         require(_value <= allowance[_from][msg.sender]);    // Check allowance
95         balanceOf[_from] -= _value;                         // Subtract from the targeted balance
96         allowance[_from][msg.sender] -= _value;             // Subtract from the sender's allowance
97         totalSupply -= _value;                              // Update totalSupply
98         Burn(_from, _value);
99         return true;
100     }
101 }