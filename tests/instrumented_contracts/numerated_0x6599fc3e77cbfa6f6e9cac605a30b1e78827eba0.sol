1 // SPDX-License-Identifier: MIT
2 
3 pragma solidity >=0.4.22 <0.7.0;
4 
5 contract TokenERC20 {
6     string public name;
7     string public symbol;
8     uint8 public decimals = 18;  
9     uint256 public totalSupply;
10 
11 
12     mapping (address => uint256) public balanceOf;
13 
14     mapping (address => mapping (address => uint256)) public allowance;
15 
16 
17     event Transfer(address indexed from, address indexed to, uint256 value);
18 
19 
20     event Burn(address indexed from, uint256 value);
21 
22 
23     constructor(uint256 initialSupply, string memory tokenName, string memory tokenSymbol) public {
24         totalSupply = initialSupply * 10 ** uint256(decimals);  
25         balanceOf[msg.sender] = totalSupply;                
26         name = tokenName;
27         symbol = tokenSymbol;
28     }
29 
30 
31     function _transfer(address _from, address _to, uint _value) internal {
32 
33         require(_to != address(0x0));
34 
35         require(balanceOf[_from] >= _value);
36 
37         require(balanceOf[_to] + _value > balanceOf[_to]);
38 
39 
40         uint previousBalances = balanceOf[_from] + balanceOf[_to];
41         // Subtract from the sender
42         balanceOf[_from] -= _value;
43         // Add the same to the recipient
44         balanceOf[_to] += _value;
45         emit Transfer(_from, _to, _value);
46 
47       
48         assert(balanceOf[_from] + balanceOf[_to] == previousBalances);
49     }
50 
51 
52     function transfer(address _to, uint256 _value) public {
53         _transfer(msg.sender, _to, _value);
54     }
55 
56    
57     function transferFrom(address _from, address _to, uint256 _value) public returns (bool success) {
58         require(_value <= allowance[_from][msg.sender]);     // Check allowance
59         allowance[_from][msg.sender] -= _value;
60         
61         _transfer(_from, _to, _value);
62         return true;
63     }
64 
65    
66     function approve(address _spender, uint256 _value) public returns (bool success) {
67         allowance[msg.sender][_spender] = _value;
68         return true;
69     }
70 
71     
72 
73     function burn(uint256 _value) public returns (bool success) {
74         require(balanceOf[msg.sender] >= _value);   // Check if the sender has enough
75         balanceOf[msg.sender] -= _value;            // Subtract from the sender
76         totalSupply -= _value;                      // Updates totalSupply
77         emit Burn(msg.sender, _value);
78         return true;
79     }
80 
81 
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