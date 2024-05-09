1 pragma solidity ^0.4.25;
2 
3 contract SenbitTokenVision{
4     /* Public variables of the token */
5     string public name;
6     string public symbol;
7     uint8 public decimals;
8     uint256 public totalSupply;
9 
10     /* This creates an array with all balances */
11     mapping (address => uint256) public balanceOf;
12     mapping (address => mapping (address => uint256)) public allowance;
13 
14     /* This generates a public event on the blockchain that will notify clients */
15     event Transfer(address indexed from, address indexed to, uint256 value);
16     event Approval(address indexed _owner, address indexed _spender, uint256 _value);
17     
18     /* This notifies clients about the amount burnt */
19     event Burn(address indexed from, uint256 value);
20 
21     /* Initializes contract with initial supply tokens to the creator of the contract */
22     function SenbitTokenVision() public{
23         balanceOf[msg.sender] = 300000000 * (10**18); // Give the creator all initial tokens
24         totalSupply = 300000000 * (10**18);          // Update total supply
25         name = "Senbit Token Vision";            // Set the name for display purposes
26         symbol = "STV";                               // Set the symbol for display purposes
27         decimals = 18;                            // Amount of decimals for display purposes
28     }
29 
30     /* Internal transfer, only can be called by this contract */
31     function _transfer(address _from, address _to, uint _value) internal {
32         require (_to != 0x0);                               // Prevent transfer to 0x0 address. Use burn() instead
33         require (balanceOf[_from] >= _value);                // Check if the sender has enough
34         require (balanceOf[_to] + _value > balanceOf[_to]); // Check for overflows
35         balanceOf[_from] -= _value;                         // Subtract from the sender
36         balanceOf[_to] += _value;                            // Add the same to the recipient
37         Transfer(_from, _to, _value);
38     }
39 
40     /// @notice Send `_value` tokens to `_to` from your account
41     /// @param _to The address of the recipient
42     /// @param _value the amount to send
43     function transfer(address _to, uint256 _value) public{
44         _transfer(msg.sender, _to, _value);
45     }
46 
47     /// @notice Send `_value` tokens to `_to` in behalf of `_from`
48     /// @param _from The address of the sender
49     /// @param _to The address of the recipient
50     /// @param _value the amount to send
51     function transferFrom(address _from, address _to, uint256 _value) public  returns (bool success) {
52         require (_value <= allowance[_from][msg.sender]);     // Check allowance
53         allowance[_from][msg.sender] -= _value;
54         _transfer(_from, _to, _value);
55         return true;
56     }
57 
58     /// @notice Allows `_spender` to spend no more than `_value` tokens in your behalf
59     /// @param _spender The address authorized to spend
60     /// @param _value the max amount they can spend
61     function approve(address _spender, uint256 _value) public returns (bool success) {
62         allowance[msg.sender][_spender] = _value;
63         Approval(msg.sender, _spender, _value);
64         return true;
65     }
66 
67 
68     /// @notice Remove `_value` tokens from the system irreversibly
69     /// @param _value the amount of money to burn
70     function burn(uint256 _value) public returns (bool success) {
71         require (balanceOf[msg.sender] >= _value);            // Check if the sender has enough
72         balanceOf[msg.sender] -= _value;                      // Subtract from the sender
73         totalSupply -= _value;                                // Updates totalSupply
74         Burn(msg.sender, _value);
75         return true;
76     }
77 
78     function burnFrom(address _from, uint256 _value) public returns (bool success) {
79         require(balanceOf[_from] >= _value);                // Check if the targeted balance is enough
80         require(_value <= allowance[_from][msg.sender]);    // Check allowance
81         balanceOf[_from] -= _value;                         // Subtract from the targeted balance
82         allowance[_from][msg.sender] -= _value;             // Subtract from the sender's allowance
83         totalSupply -= _value;                              // Update totalSupply
84         Burn(_from, _value);
85         return true;
86     }
87 }