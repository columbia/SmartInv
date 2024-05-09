1 pragma solidity ^0.4.13;
2 
3 
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
53      
54     /// @notice Remove `_value` tokens from the system irreversibly
55     /// @param _value the amount of money to burn
56     function burn(uint256 _value) returns (bool success) {
57         require (balanceOf[msg.sender] > _value);            // Check if the sender has enough
58         balanceOf[msg.sender] -= _value;                      // Subtract from the sender
59         totalSupply -= _value;                                // Updates totalSupply
60         Burn(msg.sender, _value);
61         return true;
62     }
63 }