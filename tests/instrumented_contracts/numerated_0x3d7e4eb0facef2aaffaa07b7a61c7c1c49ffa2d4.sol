1 pragma solidity ^0.4.17;
2 
3  contract tokenRecipient { function receiveApproval(address _from, uint256 _value, address _token, bytes _extraData); }
4 
5  
6 
7 contract KEKEcon{
8     /* Public variables of the token */
9     string public name;
10     string public symbol;
11     uint8 public decimals;
12     uint256 public totalSupply;
13 
14     /* This creates an array with all balances */
15     mapping (address => uint256) public balanceOf;
16     mapping (address => mapping (address => uint256)) public allowance;
17 
18     /* This generates a public event on the blockchain that will notify clients */
19     event Transfer(address indexed from, address indexed to, uint256 value);
20 
21     /* This notifies clients about the amount burnt */
22     event Burn(address indexed from, uint256 value);
23 
24     /* Initializes contract with initial supply tokens to the creator of the contract */
25     function KEKEcon(){
26         balanceOf[msg.sender] = 100000000000000000; // Give the creator all initial tokens
27         totalSupply = 100000000000000000;                        // Update total supply
28         name = "KEKEcon";                                   // Set the name for display purposes
29         symbol = "KEKEcon";                             // Set the symbol for display purposes
30         decimals = 8;                            // Amount of decimals for display purposes
31     }
32 
33     /* Internal transfer, only can be called by this contract */
34     function _transfer(address _from, address _to, uint _value) internal {
35         require (_to != 0x0);                               // Prevent transfer to 0x0 address. Use burn() instead
36         require (balanceOf[_from] >= _value);                // Check if the sender has enough
37         require (balanceOf[_to] + _value > balanceOf[_to]); // Check for overflows
38         balanceOf[_from] -= _value;                         // Subtract from the sender
39         balanceOf[_to] += _value;                            // Add the same to the recipient
40         Transfer(_from, _to, _value);
41     }
42 
43     /// @notice Send `_value` tokens to `_to` from your account
44     /// @param _to The address of the recipient
45     /// @param _value the amount to send
46     function transfer(address _to, uint256 _value) {
47         _transfer(msg.sender, _to, _value);
48     }
49 
50     /// @notice Send `_value` tokens to `_to` in behalf of `_from`
51     /// @param _from The address of the sender
52     /// @param _to The address of the recipient
53     /// @param _value the amount to send
54     function transferFrom(address _from, address _to, uint256 _value) returns (bool success) {
55         require (_value <= allowance[_from][msg.sender]);     // Check allowance
56         allowance[_from][msg.sender] -= _value;
57         _transfer(_from, _to, _value);
58         return true;
59     }
60 
61     /// @notice Allows `_spender` to spend no more than `_value` tokens in your behalf
62     /// @param _spender The address authorized to spend
63     /// @param _value the max amount they can spend
64     function approve(address _spender, uint256 _value)
65         returns (bool success) {
66         allowance[msg.sender][_spender] = _value;
67         return true;
68     }
69 
70     /// @notice Allows `_spender` to spend no more than `_value` tokens in your behalf, and then ping the contract about it
71     /// @param _spender The address authorized to spend
72     /// @param _value the max amount they can spend
73     /// @param _extraData some extra information to send to the approved contract
74     function approveAndCall(address _spender, uint256 _value, bytes _extraData)
75         returns (bool success) {
76         tokenRecipient spender = tokenRecipient(_spender);
77         if (approve(_spender, _value)) {
78             spender.receiveApproval(msg.sender, _value, this, _extraData);
79             return true;
80         }
81     }
82 
83     /// @notice Remove `_value` tokens from the system irreversibly
84     /// @param _value the amount of money to burn
85     function burn(uint256 _value) returns (bool success) {
86         require (balanceOf[msg.sender] >= _value);            // Check if the sender has enough
87         balanceOf[msg.sender] -= _value;                      // Subtract from the sender
88         totalSupply -= _value;                                // Updates totalSupply
89         Burn(msg.sender, _value);
90         return true;
91     }
92 
93     function burnFrom(address _from, uint256 _value) returns (bool success) {
94         require(balanceOf[_from] >= _value);                // Check if the targeted balance is enough
95         require(_value <= allowance[_from][msg.sender]);    // Check allowance
96         balanceOf[_from] -= _value;                         // Subtract from the targeted balance
97         allowance[_from][msg.sender] -= _value;             // Subtract from the sender's allowance
98         totalSupply -= _value;                              // Update totalSupply
99         Burn(_from, _value);
100         return true;
101     }
102 
103    function getBalance(address addr) public view returns(uint256) {
104         return balanceOf[addr];
105     }
106     
107 }