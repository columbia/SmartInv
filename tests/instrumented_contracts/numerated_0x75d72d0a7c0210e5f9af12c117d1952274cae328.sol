1 pragma solidity ^0.4.24;
2 
3 contract ACLCERC20{
4     /* Public variables of the token */
5     string public name;
6     string public symbol;
7     uint8 public decimals = 18 ; // Amount of decimals for display purposes
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
22     constructor() public{
23         totalSupply = 10000000000 * (10**18); // Update total supply
24         balanceOf[msg.sender] = totalSupply; // Give the creator all initial tokens
25         name = "accounting ledger coin";    // Set the name for display purposes
26         symbol = "ACLC";                   // Set the symbol for display purposes                 
27     }
28 
29     /* Internal transfer, only can be called by this contract */
30     function _transfer(address _from, address _to, uint _value) internal {
31         require (_to != address(0x0));                               // Prevent transfer to 0x0 address. Use burn() instead
32         require (balanceOf[_from] >= _value);                // Check if the sender has enough
33         require (balanceOf[_to] + _value > balanceOf[_to]); // Check for overflows
34         uint previousBalances = balanceOf[_from] + balanceOf[_to]; // Save this for an assertion in the future
35         balanceOf[_from] -= _value;                         // Subtract from the sender
36         balanceOf[_to] += _value;                            // Add the same to the recipient
37         emit Transfer(_from, _to, _value);
38         assert(balanceOf[_from] + balanceOf[_to] == previousBalances); // Asserts are used to use static analysis to find bugs in your code. They should never fail
39     }
40 
41     /// @notice Send `_value` tokens to `_to` from your account
42     /// @param _to The address of the recipient
43     /// @param _value the amount to send
44     function transfer(address _to, uint256 _value) public{
45         _transfer(msg.sender, _to, _value);
46     }
47 
48     /// @notice Send `_value` tokens to `_to` in behalf of `_from`
49     /// @param _from The address of the sender
50     /// @param _to The address of the recipient
51     /// @param _value the amount to send
52     function transferFrom(address _from, address _to, uint256 _value) public  returns (bool success) {
53         require (_value <= allowance[_from][msg.sender]);     // Check allowance
54         allowance[_from][msg.sender] -= _value;
55         _transfer(_from, _to, _value);
56         return true;
57     }
58 
59     /// @notice Allows `_spender` to spend no more than `_value` tokens in your behalf
60     /// @param _spender The address authorized to spend
61     /// @param _value the max amount they can spend
62     function approve(address _spender, uint256 _value) public returns (bool success) {
63         allowance[msg.sender][_spender] = _value;
64         emit Approval(msg.sender, _spender, _value);
65         return true;
66     }
67 
68 
69     /// @notice Remove `_value` tokens from the system irreversibly
70     /// @param _value the amount of money to burn
71     function burn(uint256 _value) public returns (bool success) {
72         require (balanceOf[msg.sender] >= _value);            // Check if the sender has enough
73         balanceOf[msg.sender] -= _value;                      // Subtract from the sender
74         totalSupply -= _value;                                // Updates totalSupply
75         emit Burn(msg.sender, _value);
76         return true;
77     }
78 
79     function burnFrom(address _from, uint256 _value) public returns (bool success) {
80         require(balanceOf[_from] >= _value);                // Check if the targeted balance is enough
81         require(_value <= allowance[_from][msg.sender]);    // Check allowance
82         balanceOf[_from] -= _value;                         // Subtract from the targeted balance
83         allowance[_from][msg.sender] -= _value;             // Subtract from the sender's allowance
84         totalSupply -= _value;                              // Update totalSupply
85         emit Burn(_from, _value);
86         return true;
87     }
88 }