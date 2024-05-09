1 pragma solidity ^0.4.19;
2 
3 interface tokenRecipientBYT { function receiveApproval(address _from, uint256 _value, address _token, bytes _extraData) public; }
4 
5 contract BythMoney {
6     string public name;
7     string public symbol;
8     uint256 public totalSupply;
9     uint8 public decimals;
10     mapping (address => uint256) public balanceOf;
11     mapping (address => mapping (address => uint256)) public allowance;
12     event Transfer(address indexed from, address indexed to, uint256 value);
13     event Burn(address indexed from, uint256 value);
14     
15     function BythMoney()
16     { 
17         
18         totalSupply = 1000000000; 
19         balanceOf[msg.sender] = totalSupply;                
20         name = "BythMoney";                                  
21         symbol = "BYT";                               
22         decimals = 2;
23     }
24 
25     function _transfer(address _from, address _to, uint _value) internal 
26     {
27         require(_to != 0x0);
28         require(balanceOf[_from] >= _value);
29         require(balanceOf[_to] + _value > balanceOf[_to]);
30         uint previousBalances = balanceOf[_from] + balanceOf[_to];
31         balanceOf[_from] -= _value;
32         balanceOf[_to] += _value;
33         Transfer(_from, _to, _value);
34         assert(balanceOf[_from] + balanceOf[_to] == previousBalances);
35     }
36 
37     function transfer(address _to, uint256 _value) public {
38         _transfer(msg.sender, _to, _value);
39     }
40 
41     function transferFrom(address _from, address _to, uint256 _value) public returns (bool success) {
42         require(_value <= allowance[_from][msg.sender]);     
43         allowance[_from][msg.sender] -= _value;
44         _transfer(_from, _to, _value);
45         return true;
46     }
47 
48     function approve(address _spender, uint256 _value) public
49         returns (bool success) {
50         allowance[msg.sender][_spender] = _value;
51         return true;
52     }
53 
54     function approveAndCall(address _spender, uint256 _value, bytes _extraData)
55         public
56         returns (bool success) {
57        tokenRecipientBYT spender = tokenRecipientBYT(_spender);
58         if (approve(_spender, _value)) {
59             spender.receiveApproval(msg.sender, _value, this, _extraData);
60             return true;
61         }
62     }
63 
64     function burn(uint256 _value) public returns (bool success) {
65         require(balanceOf[msg.sender] >= _value);   
66         balanceOf[msg.sender] -= _value;            
67         totalSupply -= _value;                      
68         Burn(msg.sender, _value);
69         return true;
70     }
71 
72    
73     function burnFrom(address _from, uint256 _value) public returns (bool success) {
74         require(balanceOf[_from] >= _value);                
75         require(_value <= allowance[_from][msg.sender]);    
76         balanceOf[_from] -= _value;                         
77         allowance[_from][msg.sender] -= _value;             
78         totalSupply -= _value;                              
79         Burn(_from, _value);
80         return true;
81     }
82 }