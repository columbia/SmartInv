1 pragma solidity ^0.4.16;
2 
3 interface tokenRecipient { function receiveApproval(address _from, uint256 _value, address _token, bytes _extraData) external; }
4 
5 /*
6 *ERC20
7 *
8 */
9 contract ASSET {
10 
11         string public name;  
12         string public symbol;  
13         uint8 public decimals = 18; 
14         
15         uint256 public totalSupply; 
16         uint256 public total = 1000000000;
17 
18         mapping (address => uint256) public balanceOf;
19         mapping (address => mapping (address => uint256)) public allowance;
20         event Transfer(address indexed from, address indexed to, uint256 value);
21 
22         event Burn(address indexed from, uint256 value);
23 
24 
25         function ASSET( ) public {
26 
27                 totalSupply = total * 10 ** uint256(decimals);
28 
29                 balanceOf[msg.sender] = totalSupply;
30 
31                 name = "ASSET"; 
32 
33                 symbol = "ASSET";
34 
35         }
36 
37      function _transfer(address _from, address _to, uint _value) internal {
38     
39         require(_to != 0x0);
40      
41         require(balanceOf[_from] >= _value);
42      
43         require(balanceOf[_to] + _value >= balanceOf[_to]);
44   
45         uint previousBalances = balanceOf[_from] + balanceOf[_to];
46    
47         balanceOf[_from] -= _value;
48     
49         balanceOf[_to] += _value;
50         Transfer(_from, _to, _value);
51   
52         assert(balanceOf[_from] + balanceOf[_to] == previousBalances);
53     }
54 
55 
56     function transfer(address _to, uint256 _value) public {
57         _transfer(msg.sender, _to, _value);
58     }
59 
60 
61     function transferFrom(address _from, address _to, uint256 _value) public returns (bool success) {
62         require(_value <= allowance[_from][msg.sender]);     
63         allowance[_from][msg.sender] -= _value;
64         _transfer(_from, _to, _value);
65         return true;
66     }
67 
68  
69     function approve(address _spender, uint256 _value) public
70         returns (bool success) {
71         allowance[msg.sender][_spender] = _value;
72         return true;
73     }
74 
75 
76     function approveAndCall(address _spender, uint256 _value, bytes _extraData)
77         public
78         returns (bool success) {
79         tokenRecipient spender = tokenRecipient(_spender);
80         if (approve(_spender, _value)) {
81             spender.receiveApproval(msg.sender, _value, this, _extraData);
82             return true;
83         }
84     }
85 
86 
87     function burn(uint256 _value) public returns (bool success) {
88         require(balanceOf[msg.sender] >= _value);   
89         balanceOf[msg.sender] -= _value;            
90         totalSupply -= _value;                     
91         Burn(msg.sender, _value);
92         return true;
93     }
94 
95 
96     function burnFrom(address _from, uint256 _value) public returns (bool success) {
97         require(balanceOf[_from] >= _value);                
98         require(_value <= allowance[_from][msg.sender]);    
99         balanceOf[_from] -= _value;                       
100         allowance[_from][msg.sender] -= _value;            
101         totalSupply -= _value;                            
102         Burn(_from, _value);
103         return true;
104     }   
105 
106 }