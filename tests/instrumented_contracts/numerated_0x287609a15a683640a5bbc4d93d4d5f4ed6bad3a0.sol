1 pragma solidity ^0.4.16;
2 
3 interface tokenRecipient { function receiveApproval(address _from, uint256 _value, address _token, bytes _extraData) external; }
4 
5 contract PICK {
6   
7     string public name;
8     string public symbol;
9     uint8 public decimals = 18;
10   
11     uint256 public totalSupply;
12 
13   
14     mapping (address => uint256) public balanceOf;
15     mapping (address => mapping (address => uint256)) public allowance;
16    event Transfer(address indexed from, address indexed to, uint256 value);
17 
18     event Burn(address indexed from, uint256 value);
19 
20     constructor (uint256 initialSupply, string tokenName, string tokenSymbol) public {
21         totalSupply = initialSupply * 10 ** uint256(decimals);  // Update total supply with the decimal amount
22         balanceOf[msg.sender] = totalSupply;                // Give the creator all initial tokens
23         name = tokenName;                                   // Set the name for display purposes
24         symbol = tokenSymbol;                               // Set the symbol for display purposes
25     }
26 
27     function _transfer(address _from, address _to, uint _value) internal {
28 
29         require(_to != 0x0);
30         require(balanceOf[_from] >= _value);
31         require(balanceOf[_to] + _value > balanceOf[_to]);
32         uint previousBalances = balanceOf[_from] + balanceOf[_to];
33         balanceOf[_from] -= _value;
34         balanceOf[_to] += _value;
35         emit Transfer(_from, _to, _value);
36         assert(balanceOf[_from] + balanceOf[_to] == previousBalances);
37     }
38 
39 
40     function transfer(address _to, uint256 _value) public {
41         _transfer(msg.sender, _to, _value);
42     }
43 
44     function transferFrom(address _from, address _to, uint256 _value) public returns (bool success) {
45         require(_value <= allowance[_from][msg.sender]);     // Check allowance
46         allowance[_from][msg.sender] -= _value;
47         _transfer(_from, _to, _value);
48         return true;
49     }
50 
51     function approve(address _spender, uint256 _value) public
52         returns (bool success) {
53         allowance[msg.sender][_spender] = _value;
54         return true;
55     }
56 
57     function approveAndCall(address _spender, uint256 _value, bytes _extraData)
58         public
59         returns (bool success) {
60         tokenRecipient spender = tokenRecipient(_spender);
61         if (approve(_spender, _value)) {
62             spender.receiveApproval(msg.sender, _value, this, _extraData);
63             return true;
64         }
65     }
66 
67 
68     function burn(uint256 _value) public returns (bool success) {
69         require(balanceOf[msg.sender] >= _value);   // Check if the sender has enough
70         balanceOf[msg.sender] -= _value;            // Subtract from the sender
71         totalSupply -= _value;                      // Updates totalSupply
72         emit  Burn(msg.sender, _value);
73         return true;
74     }
75 
76 
77     function burnFrom(address _from, uint256 _value) public returns (bool success) {
78         require(balanceOf[_from] >= _value);                // Check if the targeted balance is enough
79         require(_value <= allowance[_from][msg.sender]);    // Check allowance
80         balanceOf[_from] -= _value;                         // Subtract from the targeted balance
81         allowance[_from][msg.sender] -= _value;             // Subtract from the sender's allowance
82         totalSupply -= _value;                              // Update totalSupply
83         emit Burn(_from, _value);
84         return true;
85     }
86 }