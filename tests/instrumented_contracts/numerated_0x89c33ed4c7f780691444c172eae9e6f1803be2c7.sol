1 pragma solidity ^0.4.16;
2 
3 interface tokenRecipient { function receiveApproval(address _from, uint256 _value, address _token, bytes _extraData) external; }
4 
5 contract BRAAI {
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
20     uint256 initialSupply=120000000;
21         string tokenName = "BRAAI";
22         string tokenSymbol = "BRAAI";
23 
24     constructor(
25         
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
36         require(_to != 0x0);
37         require(balanceOf[_from] >= _value);
38         require(balanceOf[_to] + _value >= balanceOf[_to]);
39         uint previousBalances = balanceOf[_from] + balanceOf[_to];
40         balanceOf[_from] -= _value;
41         balanceOf[_to] += _value;
42         emit Transfer(_from, _to, _value);
43         assert(balanceOf[_from] + balanceOf[_to] == previousBalances);
44     }
45 
46 
47     function transfer(address _to, uint256 _value) public {
48         _transfer(msg.sender, _to, _value);
49     }
50 
51 
52     function transferFrom(address _from, address _to, uint256 _value) public returns (bool success) {
53         require(_value <= allowance[_from][msg.sender]);  
54         allowance[_from][msg.sender] -= _value;
55         _transfer(_from, _to, _value);
56         return true;
57     }
58 
59     
60     function approve(address _spender, uint256 _value) public
61         returns (bool success) {
62         allowance[msg.sender][_spender] = _value;
63         return true;
64     }
65 
66 
67     function approveAndCall(address _spender, uint256 _value, bytes _extraData)
68         public
69         returns (bool success) {
70         tokenRecipient spender = tokenRecipient(_spender);
71         if (approve(_spender, _value)) {
72             spender.receiveApproval(msg.sender, _value, this, _extraData);
73             return true;
74         }
75     }
76 
77     function burn(uint256 _value) public returns (bool success) {
78         require(balanceOf[msg.sender] >= _value);   
79         balanceOf[msg.sender] -= _value;          
80         totalSupply -= _value;                      
81         emit Burn(msg.sender, _value);
82         return true;
83     }
84 
85 
86     function burnFrom(address _from, uint256 _value) public returns (bool success) {
87         require(balanceOf[_from] >= _value);                
88         require(_value <= allowance[_from][msg.sender]);    
89         balanceOf[_from] -= _value;                         
90         allowance[_from][msg.sender] -= _value;             
91         totalSupply -= _value;                              
92         emit Burn(_from, _value);
93         return true;
94     }
95 }