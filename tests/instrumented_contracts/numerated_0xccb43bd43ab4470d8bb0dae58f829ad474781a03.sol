1 pragma solidity ^0.4.13;
2 
3 contract  mimonedarecipiente { function receiveApproval(address _from, uint256 _value, address _token, bytes _extraData); }
4 
5 contract  mimoneda {
6     /* Public variables of the token */
7     string public name;
8     string public symbol;
9     uint8 public decimals;
10     uint256 public totalSupply;
11     address public owner;
12 
13     /* This creates an array with all balances */
14     mapping (address => uint256) public balanceOf;
15     mapping (address => mapping (address => uint256)) public allowance;
16 
17     /* This generates a public event on the blockchain that will notify clients */
18     event Transfer(address indexed from, address indexed to, uint256 value);
19 
20     event Approval(address indexed _owner, address indexed spender, uint256 value);
21 
22     /* This notifies clients about the amount burnt */
23     event Burn(address indexed from, uint256 value);
24 
25     /* Initializes contract with initial supply tokens to the creator of the contract */
26     function  mimoneda(
27         uint256 initialSupply,
28         string tokenName,
29         uint8 decimalUnits,
30         string tokenSymbol
31         ) {
32         owner = msg.sender;
33         balanceOf[owner] = initialSupply;              // Give the creator all initial tokens
34         totalSupply = initialSupply;                        // Update total supply
35         name = tokenName;                                   // Set the name for display purposes
36         symbol = tokenSymbol;                               // Set the symbol for display purposes
37         decimals = decimalUnits;                            // Amount of decimals for display purposes
38     }
39 
40     /* Internal transfer, only can be called by this contract */
41     function _transfer(address _from, address _to, uint _value) internal {
42         require (_to != 0x0);                               // Prevent transfer to 0x0 address. Use burn() instead
43         require (balanceOf[_from] >= _value);                // Check if the sender has enough
44         require (balanceOf[_to] + _value > balanceOf[_to]); // Check for overflows
45         balanceOf[_from] -= _value;                         // Subtract from the sender
46         balanceOf[_to] += _value;                            // Add the same to the recipient
47         Transfer(_from, _to, _value);
48     }
49 
50     /// @notice Send `_value` tokens to `_to` from your account
51     /// @param _to The address of the recipient
52     /// @param _value the amount to send
53     function transfer(address _to, uint256 _value) {
54         require(msg.sender == owner || now > 1509467422);
55         _transfer(msg.sender, _to, _value);
56     }
57 
58     /// @notice Send `_value` tokens to `_to` in behalf of `_from`
59     /// @param _from The address of the sender
60     /// @param _to The address of the recipient
61     /// @param _value the amount to send
62     function transferFrom(address _from, address _to, uint256 _value) returns (bool success) {
63         require (msg.sender == owner || now > 1509467422);
64         require (_value <= allowance[_from][msg.sender]);     // Check allowance
65         allowance[_from][msg.sender] -= _value;
66         _transfer(_from, _to, _value);
67         return true;
68     }
69 
70     /// @notice Allows `_spender` to spend no more than `_value` tokens in your behalf
71     /// @param _spender The address authorized to spend
72     /// @param _value the max amount they can spend
73     function approve(address _spender, uint256 _value)
74         returns (bool success) {
75         allowance[msg.sender][_spender] = _value;
76         Approval(msg.sender, _spender, _value);
77         return true;
78     }
79 
80     /// @notice Allows `_spender` to spend no more than `_value` tokens in your behalf, and then ping the contract about it
81     /// @param _spender The address authorized to spend
82     /// @param _value the max amount they can spend
83     /// @param _extraData some extra information to send to the approved contract
84     function approveAndCall(address _spender, uint256 _value, bytes _extraData)
85         returns (bool success) {
86         mimonedarecipiente spender =  mimonedarecipiente(_spender);
87         if (approve(_spender, _value)) {
88             spender.receiveApproval(msg.sender, _value, this, _extraData);
89             return true;
90         }
91     }        
92 
93     /// @notice Remove `_value` tokens from the system irreversibly
94     /// @param _value the amount of money to burn
95     function burn(uint256 _value) returns (bool success) {
96         require (balanceOf[msg.sender] >= _value);            // Check if the sender has enough
97         balanceOf[msg.sender] -= _value;                      // Subtract from the sender
98         totalSupply -= _value;                                // Updates totalSupply
99         Burn(msg.sender, _value);
100         return true;
101     }
102 
103     function burnFrom(address _from, uint256 _value) returns (bool success) {
104         require(balanceOf[_from] >= _value);                // Check if the targeted balance is enough
105         require(_value <= allowance[_from][msg.sender]);    // Check allowance
106         balanceOf[_from] -= _value;                         // Subtract from the targeted balance
107         allowance[_from][msg.sender] -= _value;             // Subtract from the sender's allowance
108         totalSupply -= _value;                              // Update totalSupply
109         Burn(_from, _value);
110         return true;
111     }
112 }