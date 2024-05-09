1 pragma solidity ^0.4.10;
2 
3 contract tokenRecipient { function receiveApproval(address _from, uint256 _value, address _token, bytes _extraData); }
4 
5 contract PubliclyCoin{
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
23     function PubliclyCoin(){
24         balanceOf[msg.sender] = 90000000000000000; // Give the creator all initial tokens
25         totalSupply = 90000000000000000;                        // Update total supply
26         name = "PubliclyCoin";                                   // Set the name for display purposes
27         symbol = "PUBC";                             // Set the symbol for display purposes
28         decimals = 8;                            // Amount of decimals for display purposes
29     }
30 
31     /* Internal transfer, only can be called by this contract */
32     function _transfer(address _from, address _to, uint _value) internal {
33         require (_to != 0x0);                               // Prevent transfer to 0x0 address. Use burn() instead
34         require (balanceOf[_from] >= _value);                // Check if the sender has enough
35         require (balanceOf[_to] + _value > balanceOf[_to]); // Check for overflows
36         balanceOf[_from] -= _value;                         // Subtract from the sender
37         balanceOf[_to] += _value;                            // Add the same to the recipient
38         Transfer(_from, _to, _value);
39     }
40 
41     /// @notice Send `_value` tokens to `_to` from your account
42     /// @param _to The address of the recipient
43     /// @param _value the amount to send
44     function transfer(address _to, uint256 _value) {
45         _transfer(msg.sender, _to, _value);
46     }
47 
48     /// @notice Send `_value` tokens to `_to` in behalf of `_from`
49     /// @param _from The address of the sender
50     /// @param _to The address of the recipient
51     /// @param _value the amount to send
52     function transferFrom(address _from, address _to, uint256 _value) returns (bool success) {
53         require (_value <= allowance[_from][msg.sender]);     // Check allowance
54         allowance[_from][msg.sender] -= _value;
55         _transfer(_from, _to, _value);
56         return true;
57     }
58 
59     /// @notice Allows `_spender` to spend no more than `_value` tokens in your behalf
60     /// @param _spender The address authorized to spend
61     /// @param _value the max amount they can spend
62     function approve(address _spender, uint256 _value)
63         returns (bool success) {
64         allowance[msg.sender][_spender] = _value;
65         return true;
66     }
67 
68     /// @notice Allows `_spender` to spend no more than `_value` tokens in your behalf, and then ping the contract about it
69     /// @param _spender The address authorized to spend
70     /// @param _value the max amount they can spend
71     /// @param _extraData some extra information to send to the approved contract
72     function approveAndCall(address _spender, uint256 _value, bytes _extraData)
73         returns (bool success) {
74         tokenRecipient spender = tokenRecipient(_spender);
75         if (approve(_spender, _value)) {
76             spender.receiveApproval(msg.sender, _value, this, _extraData);
77             return true;
78         }
79     }        
80 
81     /// @notice Remove `_value` tokens from the system irreversibly
82     /// @param _value the amount of money to burn
83     function burn(uint256 _value) returns (bool success) {
84         require (balanceOf[msg.sender] >= _value);            // Check if the sender has enough
85         balanceOf[msg.sender] -= _value;                      // Subtract from the sender
86         totalSupply -= _value;                                // Updates totalSupply
87         Burn(msg.sender, _value);
88         return true;
89     }
90 
91     function burnFrom(address _from, uint256 _value) returns (bool success) {
92         require(balanceOf[_from] >= _value);                // Check if the targeted balance is enough
93         require(_value <= allowance[_from][msg.sender]);    // Check allowance
94         balanceOf[_from] -= _value;                         // Subtract from the targeted balance
95         allowance[_from][msg.sender] -= _value;             // Subtract from the sender's allowance
96         totalSupply -= _value;                              // Update totalSupply
97         Burn(_from, _value);
98         return true;
99     }
100 }