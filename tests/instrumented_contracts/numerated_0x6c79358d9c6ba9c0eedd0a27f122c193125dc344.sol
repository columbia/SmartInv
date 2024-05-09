1 pragma solidity ^0.4.16;
2 
3 interface tokenRecipient { function receiveApproval(address _from, uint256 _value, address _token, bytes _extraData) public; }
4 
5 contract Tacoin {
6     string public name = "Tacoin"; 
7     string public symbol = "TACO"; 
8     uint8 public decimals = 18;
9     uint256 public totalSupply = 10000000000000000000000000;
10 
11     mapping (address => uint256) public balanceOf;
12     mapping (address => mapping (address => uint256)) public allowance;
13 
14     event Transfer(address indexed from, address indexed to, uint256 value);
15 
16     event Burn(address indexed from, uint256 value);
17 
18     function Tacoin (
19         uint256 initialSupply, 
20         string tokenName,
21         string tokenSymbol
22     ) public {
23         totalSupply = initialSupply * 10000000000000000000000000  ** uint256(18);  
24         balanceOf[msg.sender] = totalSupply = 10000000000000000000000000;                
25         name = tokenName = "Tacoin";                                   
26         symbol = tokenSymbol = "TACO";                               
27     }
28 
29     function _transfer(address _from, address _to, uint _value) internal {
30         
31         require(_to != 0x0);
32         
33         require(balanceOf[_from] >= _value);
34         
35         require(balanceOf[_to] + _value > balanceOf[_to]);
36         
37         uint previousBalances = balanceOf[_from] + balanceOf[_to];
38         
39         balanceOf[_from] -= _value;
40         
41         balanceOf[_to] += _value;
42         Transfer(_from, _to, _value);
43         
44         assert(balanceOf[_from] + balanceOf[_to] == previousBalances);
45     }
46 
47     
48     function transfer(address _to, uint256 _value) public {
49         _transfer(msg.sender, _to, _value);
50     }
51 
52     
53     function transferFrom(address _from, address _to, uint256 _value) public returns (bool success) {
54         require(_value <= allowance[_from][msg.sender]);     
55         allowance[_from][msg.sender] -= _value;
56         _transfer(_from, _to, _value);
57         return true;
58     }
59 
60     
61     function approve(address _spender, uint256 _value) public
62         returns (bool success) {
63         allowance[msg.sender][_spender] = _value;
64         return true;
65     }
66 
67     
68     function approveAndCall(address _spender, uint256 _value, bytes _extraData)
69         public
70         returns (bool success) {
71         tokenRecipient spender = tokenRecipient(_spender);
72         if (approve(_spender, _value)) {
73             spender.receiveApproval(msg.sender, _value, this, _extraData);
74             return true;
75         }
76     }
77 
78     
79     function burn(uint256 _value) public returns (bool success) {
80         require(balanceOf[msg.sender] >= _value);   
81         balanceOf[msg.sender] -= _value;            
82         totalSupply -= _value;                      
83         Burn(msg.sender, _value);
84         return true;
85     }
86 
87     
88     function burnFrom(address _from, uint256 _value) public returns (bool success) {
89         require(balanceOf[_from] >= _value);                
90         require(_value <= allowance[_from][msg.sender]);    
91         balanceOf[_from] -= _value;                         
92         allowance[_from][msg.sender] -= _value;             
93         totalSupply -= _value;                              
94         Burn(_from, _value);
95         return true;
96     }
97 }