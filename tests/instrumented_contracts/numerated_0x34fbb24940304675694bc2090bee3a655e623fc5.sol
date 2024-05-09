1 pragma solidity ^0.4.21;
2 
3 interface tokenRecipient { function receiveApproval(address _from, uint256 _value, address _token, bytes _extraData) external; }
4 
5 contract TokeniVOX {
6     
7     string public name;
8     string public symbol;
9     uint8 public decimals = 8;
10     
11     uint256 public totalSupply;
12    
13     mapping (address => uint256) public balanceOf;
14     mapping (address => mapping (address => uint256)) public allowance;
15     
16     event Transfer(address indexed from, address indexed to, uint256 value);
17 
18     event Burn(address indexed from, uint256 value);
19 
20     function TokeniVOX(
21         uint256 initialSupply,
22         string tokenName,
23         string tokenSymbol
24     ) public {
25         totalSupply = initialSupply * 10 ** uint256(decimals);  // Update total supply with the decimal amount
26         balanceOf[msg.sender] = totalSupply;                // Give the creator all initial tokens
27         name = tokenName;                                   // Set the name for display purposes
28         symbol = tokenSymbol;                               // Set the symbol for display purposes
29     }
30     function _transfer(address _from, address _to, uint _value) internal {
31         // Prevent transfer to 0x0 address. Use burn() instead
32         require(_to != 0x0);
33         // Check if the sender has enough
34         require(balanceOf[_from] >= _value);
35         // Check for overflows
36         require(balanceOf[_to] + _value >= balanceOf[_to]);
37         // Save this for an assertion in the future
38         uint previousBalances = balanceOf[_from] + balanceOf[_to];
39         // Subtract from the sender
40         balanceOf[_from] -= _value;
41         // Add the same to the recipient
42         balanceOf[_to] += _value;
43         emit Transfer(_from, _to, _value);
44         // Asserts are used to use static analysis to find bugs in your code. They should never fail
45         assert(balanceOf[_from] + balanceOf[_to] == previousBalances);
46     }
47     function transfer(address _to, uint256 _value) public {
48         _transfer(msg.sender, _to, _value);
49     }
50     function transferFrom(address _from, address _to, uint256 _value) public returns (bool success) {
51         require(_value <= allowance[_from][msg.sender]);     // Check allowance
52         allowance[_from][msg.sender] -= _value;
53         _transfer(_from, _to, _value);
54         return true;
55     }
56 
57    
58     
59     function approve(address _spender, uint256 _value) public
60         returns (bool success) {
61         allowance[msg.sender][_spender] = _value;
62         return true;
63     }
64 
65    
66     function approveAndCall(address _spender, uint256 _value, bytes _extraData)
67         public
68         returns (bool success) {
69         tokenRecipient spender = tokenRecipient(_spender);
70         if (approve(_spender, _value)) {
71             spender.receiveApproval(msg.sender, _value, this, _extraData);
72             return true;
73         }
74     }
75     function burn(uint256 _value) public returns (bool success) {
76         require(balanceOf[msg.sender] >= _value);   // Check if the sender has enough
77         balanceOf[msg.sender] -= _value;            // Subtract from the sender
78         totalSupply -= _value;                      // Updates totalSupply
79         emit Burn(msg.sender, _value);
80         return true;
81     }
82     function burnFrom(address _from, uint256 _value) public returns (bool success) {
83         require(balanceOf[_from] >= _value);                // Check if the targeted balance is enough
84         require(_value <= allowance[_from][msg.sender]);    // Check allowance
85         balanceOf[_from] -= _value;                         // Subtract from the targeted balance
86         allowance[_from][msg.sender] -= _value;             // Subtract from the sender's allowance
87         totalSupply -= _value;                              // Update totalSupply
88         emit Burn(_from, _value);
89         return true;
90     }
91 }