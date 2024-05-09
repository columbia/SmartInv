1 pragma solidity ^0.4.22;
2 
3 interface tokenRecipient { function receiveApproval(address _from, uint256 _value, address _token, bytes _extraData) external; }
4 
5 
6 contract token {
7     string public name; 
8     string public symbol; 
9     uint8 public decimals = 18;
10     uint256 public totalSupply;
11 
12     mapping (address => uint256) public balanceOf;
13     mapping (address => mapping (address => uint256)) public allowance;
14 
15     event Transfer(address indexed from, address indexed to, uint256 value);
16     event Burn(address indexed from, uint256 value);
17 
18     constructor(uint256 initialSupply, string tokenName, string tokenSymbol) public {
19 
20         totalSupply = initialSupply * 10 ** uint256(decimals); 
21 
22         balanceOf[msg.sender] = totalSupply;
23 
24         name = tokenName;
25         symbol = tokenSymbol;
26 
27     }
28 
29 
30     function _transfer(address _from, address _to, uint256 _value) internal {
31 
32       require(_to != 0x0);
33 
34       require(balanceOf[_from] >= _value);
35 
36       require(balanceOf[_to] + _value > balanceOf[_to]);
37 
38       uint previousBalances = balanceOf[_from] + balanceOf[_to];
39 
40       balanceOf[_from] -= _value;
41 
42       balanceOf[_to] += _value;
43 
44       emit Transfer(_from, _to, _value);
45 
46       assert(balanceOf[_from] + balanceOf[_to] == previousBalances);
47 
48     }
49 
50     function transfer(address _to, uint256 _value) public {
51         _transfer(msg.sender, _to, _value);
52     }
53 
54     function transferFrom(address _from, address _to, uint256 _value) public returns (bool success) {
55         require(_value <= allowance[_from][msg.sender]);   // Check allowance
56 
57         allowance[_from][msg.sender] -= _value;
58 
59         _transfer(_from, _to, _value);
60 
61         return true;
62     }
63 
64 
65     function approve(address _spender, uint256 _value) public returns (bool success) {
66         allowance[msg.sender][_spender] = _value;
67         return true;
68     }
69 
70     function approveAndCall(address _spender, uint256 _value, bytes _extraData) public returns (bool success) {
71         tokenRecipient spender = tokenRecipient(_spender);
72         if (approve(_spender, _value)) {
73             spender.receiveApproval(msg.sender, _value, this, _extraData);
74             return true;
75         }
76     }
77 
78     function burn(uint256 _value) public returns (bool success) {
79         require(balanceOf[msg.sender] >= _value);   // Check if the sender has enough
80 
81         balanceOf[msg.sender] -= _value;
82 
83         totalSupply -= _value;
84 
85         emit Burn(msg.sender, _value);
86         return true;
87     }
88 
89    
90     function burnFrom(address _from, uint256 _value) public returns (bool success) {
91 
92         require(balanceOf[_from] >= _value);
93 
94         require(_value <= allowance[_from][msg.sender]);
95 
96         balanceOf[_from] -= _value;
97         allowance[_from][msg.sender] -= _value;
98 
99         totalSupply -= _value;
100         emit Burn(_from, _value);
101         return true;
102     }
103 
104 }