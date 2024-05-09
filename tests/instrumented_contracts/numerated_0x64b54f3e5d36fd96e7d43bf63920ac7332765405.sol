1 pragma solidity ^0.4.13;
2 
3 
4 contract Emoji {
5     /* Public variables of the token */
6     string public name;
7     string public standard = 'Token 0.1';
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
19    
20 
21     /* Initializes contract with initial supply tokens to the creator of the contract */
22     function Emoji () {
23         totalSupply = 600600600600600600600600600;                        // Update total supply
24         name = "Emoji";                                   // Set the name for display purposes
25         symbol = ":)";                               // Set the symbol for display purposes
26         decimals = 3;                            // Amount of decimals for display purposes
27         balanceOf[msg.sender] = totalSupply;              // Give the creator all initial tokens
28     }
29 
30     /* Internal transfer, only can be called by this contract */
31     function _transfer(address _from, address _to, uint _value) internal {
32         require (_to != 0x0);                               // Prevent transfer to 0x0 address. Use burn() instead
33         require (balanceOf[_from] > _value);                // Check if the sender has enough
34         require (balanceOf[_to] + _value > balanceOf[_to]); // Check for overflows
35         balanceOf[_from] -= _value;                         // Subtract from the sender
36         balanceOf[_to] += _value;                            // Add the same to the recipient
37         Transfer(_from, _to, _value);
38     }
39 
40     /// @notice Send `_value` tokens to `_to` from your account
41     /// @param _to The address of the recipient
42     /// @param _value the amount to send
43     function transfer(address _to, uint256 _value) {
44         _transfer(msg.sender, _to, _value);
45     }
46 
47     /// @notice Send `_value` tokens to `_to` in behalf of `_from`
48     /// @param _from The address of the sender
49     /// @param _to The address of the recipient
50     /// @param _value the amount to send
51     function transferFrom(address _from, address _to, uint256 _value) returns (bool success) {
52         require (_value < allowance[_from][msg.sender]);     // Check allowance
53         allowance[_from][msg.sender] -= _value;
54         _transfer(_from, _to, _value);
55         return true;
56     }
57 
58     /// @notice Allows `_spender` to spend no more than `_value` tokens in your behalf
59     /// @param _spender The address authorized to spend
60     /// @param _value the max amount they can spend
61     function approve(address _spender, uint256 _value)
62         returns (bool success) {
63         allowance[msg.sender][_spender] = _value;
64         return true;
65     }
66 
67 }