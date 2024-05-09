1 pragma solidity ^0.4.18;
2 
3 interface tokenRecipient { function receiveApproval(address _from, uint256 _value, address _token, bytes _extraData) external; }
4 
5 contract INVECHCOIN {
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
16 
17  
18     event Transfer(address indexed from, address indexed to, uint256 value);
19     
20     
21     event Approval(address indexed _owner, address indexed _spender, uint256 _value);
22 
23    
24     event Burn(address indexed from, uint256 value);
25 
26     
27     constructor(
28         uint256 initialSupply,
29         string tokenName,
30         string tokenSymbol
31     ) public {
32         totalSupply = initialSupply * 10 ** uint256(decimals); 
33         balanceOf[msg.sender] = totalSupply;                
34         name = tokenName;                                   
35         symbol = tokenSymbol;                               
36     }
37 
38    
39     function _transfer(address _from, address _to, uint _value) internal {
40         require(_to != 0x0);
41        
42         require(balanceOf[_from] >= _value);
43        
44         require(balanceOf[_to] + _value >= balanceOf[_to]);
45         
46         uint previousBalances = balanceOf[_from] + balanceOf[_to];
47         
48         balanceOf[_from] -= _value;
49         
50         balanceOf[_to] += _value;
51         emit Transfer(_from, _to, _value);
52         
53         assert(balanceOf[_from] + balanceOf[_to] == previousBalances);
54     }
55 
56    
57     function transfer(address _to, uint256 _value) public returns (bool success) {
58         _transfer(msg.sender, _to, _value);
59         return true;
60     }
61 
62    
63     function transferFrom(address _from, address _to, uint256 _value) public returns (bool success) {
64         require(_value <= allowance[_from][msg.sender]);     // Check allowance
65         allowance[_from][msg.sender] -= _value;
66         _transfer(_from, _to, _value);
67         return true;
68     }
69 
70    
71     function approve(address _spender, uint256 _value) public
72         returns (bool success) {
73         allowance[msg.sender][_spender] = _value;
74         emit Approval(msg.sender, _spender, _value);
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
94         emit Burn(msg.sender, _value);
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
105         emit Burn(_from, _value);
106         return true;
107     }
108 }