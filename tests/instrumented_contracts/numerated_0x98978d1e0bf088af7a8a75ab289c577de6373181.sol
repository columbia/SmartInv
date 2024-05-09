1 pragma solidity ^0.4.16;
2 
3 interface tokenRecipient { function receiveApproval(address _from, uint256 _value, address _token, bytes _extraData) public; }
4 
5 contract MatocolToken {
6 
7     string public name;							
8     string public symbol;						
9     uint8  public decimals = 18;			
10     uint256 public totalSupply;			
11 
12     
13    
14     mapping (address => uint256) public balanceOf;
15     mapping (address => mapping (address => uint256)) public allowance;
16   
17     event Transfer(address indexed from, address indexed to, uint256 value);
18 
19     event Burn(address indexed from, uint256 value);
20 
21    
22     function MatocolToken (
23         uint256 initialSupply,
24         string tokenName,
25         string tokenSymbol
26     ) public {
27         totalSupply = initialSupply * 10 ** uint256(decimals); 
28         balanceOf[msg.sender] = totalSupply;                		
29         name = tokenName;                                   		
30         symbol = tokenSymbol;                               		
31     }
32 
33    
34     function _transfer(address _from, address _to, uint _value) internal {
35     
36         
37         require(_to != 0x0);
38         
39 
40         require(balanceOf[_from] >= _value);
41         
42 
43         require(balanceOf[_to] + _value > balanceOf[_to]);
44         
45 
46         uint previousBalances = balanceOf[_from] + balanceOf[_to];
47         
48 
49         balanceOf[_from] -= _value;
50         
51 
52         balanceOf[_to] += _value;
53         
54 
55         Transfer(_from, _to, _value);
56         
57 
58         assert(balanceOf[_from] + balanceOf[_to] == previousBalances);
59     }
60 
61     
62 
63     function transfer(address _to, uint256 _value) public {
64         _transfer(msg.sender, _to, _value);
65     }
66 
67 
68     function transferFrom(address _from, address _to, uint256 _value) public returns (bool success) {
69         require(_value <= allowance[_from][msg.sender]);   
70         allowance[_from][msg.sender] -= _value;
71         _transfer(_from, _to, _value);
72         return true;
73     }
74 
75 
76     function approve(address _spender, uint256 _value) public
77         returns (bool success) {
78         allowance[msg.sender][_spender] = _value;
79         return true;
80     }
81 
82 
83     function approveAndCall(address _spender, uint256 _value, bytes _extraData)
84         public
85         returns (bool success) {
86         tokenRecipient spender = tokenRecipient(_spender);
87         if (approve(_spender, _value)) {
88             spender.receiveApproval(msg.sender, _value, this, _extraData);
89             return true;
90         }
91     }
92 
93 
94     function burn(uint256 _value) public returns (bool success) {
95         require(balanceOf[msg.sender] >= _value);   
96         balanceOf[msg.sender] -= _value;           
97         totalSupply -= _value;                     
98         Burn(msg.sender, _value);
99         return true;
100     }
101 
102 
103     function burnFrom(address _from, uint256 _value) public returns (bool success) {
104         require(balanceOf[_from] >= _value);                
105         require(_value <= allowance[_from][msg.sender]);    
106         balanceOf[_from] -= _value;                         
107         allowance[_from][msg.sender] -= _value;             
108         totalSupply -= _value;                              
109         Burn(_from, _value);
110         return true;
111     }
112 }