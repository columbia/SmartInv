1 pragma solidity ^0.4.15;
2 
3 interface tokenRecipient { function receiveApproval(address _from, uint256 _value, address _token, bytes _extraData) public; }
4 contract TokenERC20 {
5     // Public variables of the token
6     string public name = "VOXXO";
7     string public symbol = "VOXXO";
8     uint8 public decimals = 4;
9     uint256 public totalSupply = 1000000000000;
10 
11     // This creates an array with all balances
12     mapping (address => uint256) public balanceOf;
13     mapping (address => mapping (address => uint256)) public allowance;
14 
15     // This generates a public event on the blockchain that will notify clients
16     event Transfer(address indexed from, address indexed to, uint256 value);
17 
18     // This notifies clients about the amount burnt
19     event Burn(address indexed from, uint256 value);
20 
21   
22     function TokenERC20() public {
23         totalSupply = totalSupply;        // Update total supply with the decimal amount
24         balanceOf[msg.sender] = totalSupply;                // Give the creator all initial tokens
25         name = name;                                   // Set the name for display purposes
26         symbol = symbol;                               // Set the symbol for display purposes
27     }
28  
29     function _transfer(address _from, address _to, uint _value) internal {
30         // Prevent transfer to 0x0 address. Use burn() instead
31         require(_to != 0x0);
32         // Check if the sender has enough
33         require(balanceOf[_from] >= _value);
34         // Check for overflows
35         require(balanceOf[_to] + _value > balanceOf[_to]);
36         // Save this for an assertion in the future
37         uint previousBalances = balanceOf[_from] + balanceOf[_to];
38         // Subtract from the sender
39         balanceOf[_from] -= _value;
40         // Add the same to the recipient
41         balanceOf[_to] += _value;
42         Transfer(_from, _to, _value);
43         // Asserts are used to use static analysis to find bugs in your code. They should never fail
44         assert(balanceOf[_from] + balanceOf[_to] == previousBalances);
45     }
46 
47     function transfer(address _to, uint256 _value) public {
48         _transfer(msg.sender, _to, _value);
49     }
50 
51     function transferFrom(address _from, address _to, uint256 _value) public returns (bool success) {
52         require(_value <= allowance[_from][msg.sender]);     // Check allowance
53         allowance[_from][msg.sender] -= _value;
54         _transfer(_from, _to, _value);
55         return true;
56     }
57 
58     function approve(address _spender, uint256 _value) public
59         returns (bool success) {
60         allowance[msg.sender][_spender] = _value;
61         return true;
62     }
63 
64     function approveAndCall(address _spender, uint256 _value, bytes _extraData)
65         public
66         returns (bool success) {
67         tokenRecipient spender = tokenRecipient(_spender);
68         if (approve(_spender, _value)) {
69             spender.receiveApproval(msg.sender, _value, this, _extraData);
70             return true;
71         }
72     }
73 
74     function burn(uint256 _value) public returns (bool success) {
75         require(balanceOf[msg.sender] >= _value);   // Check if the sender has enough
76         balanceOf[msg.sender] -= _value;            // Subtract from the sender
77         totalSupply -= _value;                      // Updates totalSupply
78         Burn(msg.sender, _value);
79         return true;
80     }
81 
82     function burnFrom(address _from, uint256 _value) public returns (bool success) {
83         require(balanceOf[_from] >= _value);                // Check if the targeted balance is enough
84         require(_value <= allowance[_from][msg.sender]);    // Check allowance
85         balanceOf[_from] -= _value;                         // Subtract from the targeted balance
86         allowance[_from][msg.sender] -= _value;             // Subtract from the sender's allowance
87         totalSupply -= _value;                              // Update totalSupply
88         Burn(_from, _value);
89         return true;
90     }
91 }