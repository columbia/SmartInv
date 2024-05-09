1 /*
2  * 8th Continent Social Marketplace Token Smart Contract. Owner Seventh
3  * Continent Ltd. Company number: 07288379, UK  
4  */
5 
6 /*
7  * ERC-20 Standard Token Smart Contract Interface.
8  */
9 
10 pragma solidity ^0.4.13;
11 
12 contract tokenRecipient { function receiveApproval(address _from, uint256 _value, address _token, bytes _extraData); }
13 
14 contract EighthContinentSocialMarketplaceToken {
15     /* Public variables of the token */
16     string public name;
17     string public symbol;
18     uint8 public decimals;
19     uint256 public totalSupply;
20 
21     /* This creates an array with all balances */
22     mapping (address => uint256) public balanceOf;
23     mapping (address => mapping (address => uint256)) public allowance;
24 
25     /* This generates a public event on the blockchain that will notify clients */
26     event Transfer(address indexed from, address indexed to, uint256 value);
27 
28     /* This notifies clients about the amount burnt */
29     event Burn(address indexed from, uint256 value);
30 
31     /* Initializes contract with initial supply tokens to the creator of the contract */
32     function EighthContinentSocialMarketplaceToken(
33         uint256 initialSupply,
34         string tokenName,
35         uint8 decimalUnits,
36         string tokenSymbol
37         ) {
38         balanceOf[msg.sender] = initialSupply;              // Give the creator all initial tokens
39         totalSupply = initialSupply;                        // Update total supply
40         name = tokenName;                                   // Set the name for display purposes
41         symbol = tokenSymbol;                               // Set the symbol for display purposes
42         decimals = decimalUnits;                            // Amount of decimals for display purposes
43     }
44 
45     /* Internal transfer, only can be called by this contract */
46     function _transfer(address _from, address _to, uint _value) internal {
47         require (_to != 0x0);                               // Prevent transfer to 0x0 address. Use burn() instead
48         require (balanceOf[_from] > _value);                // Check if the sender has enough
49         require (balanceOf[_to] + _value > balanceOf[_to]); // Check for overflows
50         balanceOf[_from] -= _value;                         // Subtract from the sender
51         balanceOf[_to] += _value;                            // Add the same to the recipient
52         Transfer(_from, _to, _value);
53     }
54 
55     /// @notice Send `_value` tokens to `_to` from your account
56     /// @param _to The address of the recipient
57     /// @param _value the amount to send
58     function transfer(address _to, uint256 _value) {
59         _transfer(msg.sender, _to, _value);
60     }
61 
62     /// @notice Send `_value` tokens to `_to` in behalf of `_from`
63     /// @param _from The address of the sender
64     /// @param _to The address of the recipient
65     /// @param _value the amount to send
66     function transferFrom(address _from, address _to, uint256 _value) returns (bool success) {
67         require (_value < allowance[_from][msg.sender]);     // Check allowance
68         allowance[_from][msg.sender] -= _value;
69         _transfer(_from, _to, _value);
70         return true;
71     }
72 
73     /// @notice Allows `_spender` to spend no more than `_value` tokens in your behalf
74     /// @param _spender The address authorized to spend
75     /// @param _value the max amount they can spend
76     function approve(address _spender, uint256 _value)
77         returns (bool success) {
78         allowance[msg.sender][_spender] = _value;
79         return true;
80     }
81 
82     /// @notice Allows `_spender` to spend no more than `_value` tokens in your behalf, and then ping the contract about it
83     /// @param _spender The address authorized to spend
84     /// @param _value the max amount they can spend
85     /// @param _extraData some extra information to send to the approved contract
86     function approveAndCall(address _spender, uint256 _value, bytes _extraData)
87         returns (bool success) {
88         tokenRecipient spender = tokenRecipient(_spender);
89         if (approve(_spender, _value)) {
90             spender.receiveApproval(msg.sender, _value, this, _extraData);
91             return true;
92         }
93     }  
94 }