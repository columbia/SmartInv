1 pragma solidity ^0.4.16;
2 
3 interface tokenRecipient { function receiveApproval(address _from, uint256 _value, address _token, bytes _extraData) external; }
4 
5 contract GHANIANCIDIDIGITALTETHER {
6 
7     string public name;
8     string public symbol;
9     uint8 public decimals = 18;
10     uint256 public totalSupply;
11 
12     mapping (address => uint256) public balanceOf;
13     mapping (address => mapping (address => uint256)) public allowance;
14 
15 
16     event Transfer(address indexed from, address indexed to, uint256 value);
17 
18 
19     event Burn(address indexed from, uint256 value);
20 
21     constructor(
22 
23     ) public {
24         totalSupply = 2000000000 * 10 ** uint256(decimals);  
25         balanceOf[msg.sender] = totalSupply;               
26         name = "GHANIAN CIDI DIGITAL TETHER";                                  
27         symbol = "GDT";                               
28     }
29 
30 
31     function _transfer(address _from, address _to, uint _value) internal {
32 
33         require(_to != 0x0);
34         require(balanceOf[_from] >= _value);
35         require(balanceOf[_to] + _value >= balanceOf[_to]);
36         uint previousBalances = balanceOf[_from] + balanceOf[_to];
37         balanceOf[_from] -= _value;
38         balanceOf[_to] += _value;
39         emit Transfer(_from, _to, _value);
40         assert(balanceOf[_from] + balanceOf[_to] == previousBalances);
41     }
42 
43 
44     function transfer(address _to, uint256 _value) public {
45         _transfer(msg.sender, _to, _value);
46     }
47 
48 
49     function transferFrom(address _from, address _to, uint256 _value) public returns (bool success) {
50         require(_value <= allowance[_from][msg.sender]);  
51         allowance[_from][msg.sender] -= _value;
52         _transfer(_from, _to, _value);
53         return true;
54     }
55 
56     
57     function approve(address _spender, uint256 _value) public
58         returns (bool success) {
59         allowance[msg.sender][_spender] = _value;
60         return true;
61     }
62 
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
75         require(balanceOf[msg.sender] >= _value);   
76         balanceOf[msg.sender] -= _value;          
77         totalSupply -= _value;                      
78         emit Burn(msg.sender, _value);
79         return true;
80     }
81 
82 
83     function burnFrom(address _from, uint256 _value) public returns (bool success) {
84         require(balanceOf[_from] >= _value);                
85         require(_value <= allowance[_from][msg.sender]);    
86         balanceOf[_from] -= _value;                         
87         allowance[_from][msg.sender] -= _value;             
88         totalSupply -= _value;                              
89         emit Burn(_from, _value);
90         return true;
91     }
92 }