1 pragma solidity ^0.4.18;
2 
3 contract owned {
4 	address public owner;
5 
6 	function owned() {
7 		owner = msg.sender;
8 	}
9 
10 	function changeOwner(address newOwner) onlyOwner {
11 		owner = newOwner;
12 	}
13 
14 	modifier onlyOwner {
15 		require(msg.sender == owner);
16 		_;
17 	}
18 }
19 
20 contract tokenRecipient { function receiveApproval(address _from, uint256 _value, address _token, bytes _extraData); }
21 
22 contract GoalToken is owned {
23     /* Public variables of the token */
24     string public name = "GOAL Bonanza";
25     string public symbol = "GOAL";
26     uint8 public decimals = 18;
27     uint256 public totalSupply = 0;
28 
29     /* This creates an array with all balances */
30     mapping (address => uint256) public balanceOf;
31     mapping (address => mapping (address => uint256)) public allowance;
32 
33     /* This generates a public event on the blockchain that will notify clients */
34     event Transfer(address indexed from, address indexed to, uint256 value);
35 
36     event Burn(address indexed from, uint256 value);
37 
38     /* Internal transfer, only can be called by this contract */
39     function _transfer(address _from, address _to, uint _value) internal {
40         require (_to != 0x0);                               // Prevent transfer to 0x0 address. Use burn() instead
41         require (balanceOf[_from] > _value);                // Check if the sender has enough
42         require (balanceOf[_to] + _value > balanceOf[_to]); // Check for overflows
43         balanceOf[_from] -= _value;                         // Subtract from the sender
44         balanceOf[_to] += _value;                            // Add the same to the recipient
45         Transfer(_from, _to, _value);
46     }
47 
48     /// @notice Send `_value` tokens to `_to` from your account
49     /// @param _to The address of the recipient
50     /// @param _value the amount to send
51     function transfer(address _to, uint256 _value) {
52         _transfer(msg.sender, _to, _value);
53     }
54 
55     /// @notice Send `_value` tokens to `_to` in behalf of `_from`
56     /// @param _from The address of the sender
57     /// @param _to The address of the recipient
58     /// @param _value the amount to send
59     function transferFrom(address _from, address _to, uint256 _value) returns (bool success) {
60         require (_value <= allowance[_from][msg.sender]);     // Check allowance
61         allowance[_from][msg.sender] -= _value;
62         _transfer(_from, _to, _value);
63         return true;
64     }
65 
66     /// @notice Allows `_spender` to spend no more than `_value` tokens in your behalf
67     /// @param _spender The address authorized to spend
68     /// @param _value the max amount they can spend
69     function approve(address _spender, uint256 _value)
70         returns (bool success) {
71         allowance[msg.sender][_spender] = _value;
72         return true;
73     }
74 
75     /// @notice Allows `_spender` to spend no more than `_value` tokens in your behalf, and then ping the contract about it
76     /// @param _spender The address authorized to spend
77     /// @param _value the max amount they can spend
78     /// @param _extraData some extra information to send to the approved contract
79     function approveAndCall(address _spender, uint256 _value, bytes _extraData)
80         returns (bool success) {
81         tokenRecipient spender = tokenRecipient(_spender);
82         if (approve(_spender, _value)) {
83             spender.receiveApproval(msg.sender, _value, this, _extraData);
84             return true;
85         }
86     }        
87 
88     /// @notice Remove `_value` tokens from the system irreversibly
89     /// @param _value the amount of money to burn
90     function burn(uint256 _value) returns (bool success) {
91         require (balanceOf[msg.sender] > _value);            // Check if the sender has enough
92         balanceOf[msg.sender] -= _value;                      // Subtract from the sender
93         totalSupply -= _value;                                // Updates totalSupply
94         Burn(msg.sender, _value);
95         return true;
96     }
97 
98     function burnFrom(address _from, uint256 _value) returns (bool success) {
99         require(balanceOf[_from] >= _value);                // Check if the targeted balance is enough
100         require(_value <= allowance[_from][msg.sender]);    // Check allowance
101         balanceOf[_from] -= _value;                         // Subtract from the targeted balance
102         allowance[_from][msg.sender] -= _value;             // Subtract from the sender's allowance
103         totalSupply -= _value;                              // Update totalSupply
104         Burn(_from, _value);
105         return true;
106     }
107 
108     function mintToken(address target, uint256 mintedAmount) onlyOwner {
109         balanceOf[target] += mintedAmount;
110         totalSupply += mintedAmount;
111         Transfer(this, target, mintedAmount);
112     }
113 }