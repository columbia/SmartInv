1 pragma solidity ^0.4.16;
2 
3 interface tokenRecipient { function receiveApproval(address _from, uint256 _value, address _token, bytes _extraData) external; }
4 
5 
6 contract Goldfinger {
7 
8         string public name;  
9         string public symbol;  
10         uint8 public decimals = 18; 
11         uint256 public total = 3190000000;
12         uint256 public totalSupply; 
13 
14         mapping (address => uint256) public balanceOf;
15         mapping (address => mapping (address => uint256)) public allowance;
16         event Transfer(address indexed from, address indexed to, uint256 value);
17 
18         event Burn(address indexed from, uint256 value);
19 
20 
21         function Goldfinger( ) public {
22 
23                 totalSupply = total * 10 ** uint256(decimals);
24 
25                 balanceOf[msg.sender] = totalSupply;
26 
27                 name = "Goldfinger"; 
28 
29                 symbol = "GFG";
30 
31         }
32 
33      function _transfer(address _from, address _to, uint _value) internal {
34     
35         require(_to != 0x0);
36      
37         require(balanceOf[_from] >= _value);
38      
39         require(balanceOf[_to] + _value >= balanceOf[_to]);
40   
41         uint previousBalances = balanceOf[_from] + balanceOf[_to];
42    
43         balanceOf[_from] -= _value;
44     
45         balanceOf[_to] += _value;
46         Transfer(_from, _to, _value);
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
58         require(_value <= allowance[_from][msg.sender]);     
59         allowance[_from][msg.sender] -= _value;
60         _transfer(_from, _to, _value);
61         return true;
62     }
63 
64  
65     function approve(address _spender, uint256 _value) public
66         returns (bool success) {
67         allowance[msg.sender][_spender] = _value;
68         return true;
69     }
70 
71 
72     function approveAndCall(address _spender, uint256 _value, bytes _extraData)
73         public
74         returns (bool success) {
75         tokenRecipient spender = tokenRecipient(_spender);
76         if (approve(_spender, _value)) {
77             spender.receiveApproval(msg.sender, _value, this, _extraData);
78             return true;
79         }
80     }
81 
82 
83     function burn(uint256 _value) public returns (bool success) {
84         require(balanceOf[msg.sender] >= _value);   
85         balanceOf[msg.sender] -= _value;            
86         totalSupply -= _value;                     
87         Burn(msg.sender, _value);
88         return true;
89     }
90 
91 
92     function burnFrom(address _from, uint256 _value) public returns (bool success) {
93         require(balanceOf[_from] >= _value);                
94         require(_value <= allowance[_from][msg.sender]);    
95         balanceOf[_from] -= _value;                       
96         allowance[_from][msg.sender] -= _value;            
97         totalSupply -= _value;                            
98         Burn(_from, _value);
99         return true;
100     }   
101 
102 }