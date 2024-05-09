1 pragma solidity ^0.4.18;
2 
3 contract testmonedarecipientefinal { function receiveApproval(address _from, uint256 _value, address _token, bytes _extraData) public; }
4 
5 contract testmonedafinal {
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
26     function testmonedafinal(
27         uint256 initialSupply,
28         string tokenName,
29         uint8 decimalUnits,
30         string tokenSymbol
31         ) public {
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
53     function transfer(address _to, uint256 _value) public {
54         _transfer(msg.sender, _to, _value);
55     }
56 
57     /// @notice Send `_value` tokens to `_to` in behalf of `_from`
58     /// @param _from The address of the sender
59     /// @param _to The address of the recipient
60     /// @param _value the amount to send
61     function transferFrom(address _from, address _to, uint256 _value) public returns (bool success) {
62         require (_value <= allowance[_from][msg.sender]);     // Check allowance
63         allowance[_from][msg.sender] -= _value;
64         _transfer(_from, _to, _value);
65         return true;
66     }
67 
68     /// @notice Allows `_spender` to spend no more than `_value` tokens in your behalf
69     /// @param _spender The address authorized to spend
70     /// @param _value the max amount they can spend
71     function approve(address _spender, uint256 _value) public
72         returns (bool success) {
73         allowance[msg.sender][_spender] = _value;
74         Approval(msg.sender, _spender, _value);
75         return true;
76     }
77 
78     /// @notice Allows `_spender` to spend no more than `_value` tokens in your behalf, and then ping the contract about it
79     /// @param _spender The address authorized to spend
80     /// @param _value the max amount they can spend
81     /// @param _extraData some extra information to send to the approved contract
82     function approveAndCall(address _spender, uint256 _value, bytes _extraData)
83         public
84         returns (bool success) {
85         testmonedarecipientefinal spender = testmonedarecipientefinal(_spender);
86         if (approve(_spender, _value)) {
87             spender.receiveApproval(msg.sender, _value, this, _extraData);
88             return true;
89         }
90     }        
91 
92     /// @notice Remove `_value` tokens from the system irreversibly
93     /// @param _value the amount of money to burn
94     function burn(uint256 _value) public returns (bool success) {
95         require (balanceOf[msg.sender] >= _value);            // Check if the sender has enough
96         balanceOf[msg.sender] -= _value;                      // Subtract from the sender
97         totalSupply -= _value;                                // Updates totalSupply
98         Burn(msg.sender, _value);
99         return true;
100     }
101 
102     function burnFrom(address _from, uint256 _value) public returns (bool success) {
103         require(balanceOf[_from] >= _value);                // Check if the targeted balance is enough
104         require(_value <= allowance[_from][msg.sender]);    // Check allowance
105         balanceOf[_from] -= _value;                         // Subtract from the targeted balance
106         allowance[_from][msg.sender] -= _value;             // Subtract from the sender's allowance
107         totalSupply -= _value;                              // Update totalSupply
108         Burn(_from, _value);
109         return true;
110     }
111 }