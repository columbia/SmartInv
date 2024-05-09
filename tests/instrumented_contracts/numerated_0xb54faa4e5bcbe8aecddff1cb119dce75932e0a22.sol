1 /**
2  *Submitted for verification at Etherscan.io on 2018-07-29
3 */
4 
5 pragma solidity ^0.4.16;
6 
7 interface tokenRecipient { function receiveApproval(address _from, uint256 _value, address _token, bytes _extraData) external; }
8 
9 /*
10 *ERC20
11 *
12 */
13 contract ShiquChain {
14 
15         string public name;  
16         string public symbol;  
17         uint8 public decimals = 18; 
18         uint256 public total = 10000000000;
19         uint256 public totalSupply; 
20 
21         mapping (address => uint256) public balanceOf;
22         mapping (address => mapping (address => uint256)) public allowance;
23         event Transfer(address indexed from, address indexed to, uint256 value);
24 
25         event Burn(address indexed from, uint256 value);
26 
27 
28         function ShiquChain( ) public {
29 
30                 totalSupply = total * 10 ** uint256(decimals);
31 
32                 balanceOf[msg.sender] = totalSupply;
33 
34                 name = "ShiquChain"; 
35 
36                 symbol = "SQC";
37 
38         }
39 
40      function _transfer(address _from, address _to, uint _value) internal {
41     
42         require(_to != 0x0);
43      
44         require(balanceOf[_from] >= _value);
45      
46         require(balanceOf[_to] + _value >= balanceOf[_to]);
47   
48         uint previousBalances = balanceOf[_from] + balanceOf[_to];
49    
50         balanceOf[_from] -= _value;
51     
52         balanceOf[_to] += _value;
53         Transfer(_from, _to, _value);
54   
55         assert(balanceOf[_from] + balanceOf[_to] == previousBalances);
56     }
57 
58 
59     function transfer(address _to, uint256 _value) public {
60         _transfer(msg.sender, _to, _value);
61     }
62 
63 
64     function transferFrom(address _from, address _to, uint256 _value) public returns (bool success) {
65         require(_value <= allowance[_from][msg.sender]);     
66         allowance[_from][msg.sender] -= _value;
67         _transfer(_from, _to, _value);
68         return true;
69     }
70 
71  
72     function approve(address _spender, uint256 _value) public
73         returns (bool success) {
74         allowance[msg.sender][_spender] = _value;
75         return true;
76     }
77 
78 
79     function approveAndCall(address _spender, uint256 _value, bytes _extraData)
80         public
81         returns (bool success) {
82         tokenRecipient spender = tokenRecipient(_spender);
83         if (approve(_spender, _value)) {
84             spender.receiveApproval(msg.sender, _value, this, _extraData);
85             return true;
86         }
87     }
88 
89 
90     function burn(uint256 _value) public returns (bool success) {
91         require(balanceOf[msg.sender] >= _value);   
92         balanceOf[msg.sender] -= _value;            
93         totalSupply -= _value;                     
94         Burn(msg.sender, _value);
95         return true;
96     }
97 
98 
99     function burnFrom(address _from, uint256 _value) public returns (bool success) {
100         require(balanceOf[_from] >= _value);                
101         require(_value <= allowance[_from][msg.sender]);    
102         balanceOf[_from] -= _value;                       
103         allowance[_from][msg.sender] -= _value;            
104         totalSupply -= _value;                            
105         Burn(_from, _value);
106         return true;
107     }   
108 
109 }