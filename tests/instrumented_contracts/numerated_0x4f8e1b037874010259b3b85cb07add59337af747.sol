1 pragma solidity ^0.4.18;
2 
3 interface tokenRecipient { function receiveApproval(address _from, uint256 _value, address _token, bytes _extraData) public; }
4 
5 contract NOBAR {
6     string public name;
7     string public symbol;
8     uint8 public decimals = 2;
9     uint256 public totalSupply;
10 
11     mapping (address => uint256) public balanceOf;
12     mapping (address => mapping (address => uint256)) public allowance;
13 
14     event Transfer(address indexed from, address indexed to, uint256 value);
15 
16     event Burn(address indexed from, uint256 value);
17 
18     function NOBAR(
19         uint256 initialSupply,
20         string tokenName,
21         string tokenSymbol
22     ) public {
23         totalSupply = initialSupply * 10 ** uint256(decimals);  
24         balanceOf[msg.sender] = totalSupply;                
25         name = tokenName;                                   
26         symbol = tokenSymbol;                               
27     }
28 
29 
30     function _transfer(address _from, address _to, uint _value) internal {
31         require(_to != 0x0);
32         require(balanceOf[_from] >= _value);
33         require(balanceOf[_to] + _value > balanceOf[_to]);
34         uint previousBalances = balanceOf[_from] + balanceOf[_to];
35         balanceOf[_from] -= _value;
36         balanceOf[_to] += _value;
37         Transfer(_from, _to, _value);
38         assert(balanceOf[_from] + balanceOf[_to] == previousBalances);
39     }
40 
41 
42     function transfer(address _to, uint256 _value) public {
43         _transfer(msg.sender, _to, _value);
44     }
45 
46 
47     function transferFrom(address _from, address _to, uint256 _value) public returns (bool success) {
48         require(_value <= allowance[_from][msg.sender]);
49         allowance[_from][msg.sender] -= _value;
50         _transfer(_from, _to, _value);
51         return true;
52     }
53 
54     function approve(address _spender, uint256 _value) public
55         returns (bool success) {
56         allowance[msg.sender][_spender] = _value;
57         return true;
58     }
59 
60     function approveAndCall(address _spender, uint256 _value, bytes _extraData)
61         public
62         returns (bool success) {
63         tokenRecipient spender = tokenRecipient(_spender);
64         if (approve(_spender, _value)) {
65             spender.receiveApproval(msg.sender, _value, this, _extraData);
66             return true;
67         }
68     }
69 
70  
71     function burn(uint256 _value) public returns (bool success) {
72         require(balanceOf[msg.sender] >= _value);   
73         balanceOf[msg.sender] -= _value;            
74         totalSupply -= _value;                  
75         Burn(msg.sender, _value);
76         return true;
77     }
78 
79   
80     function burnFrom(address _from, uint256 _value) public returns (bool success) {
81         require(balanceOf[_from] >= _value);                
82         require(_value <= allowance[_from][msg.sender]);    
83         balanceOf[_from] -= _value;                         
84         allowance[_from][msg.sender] -= _value;             
85         totalSupply -= _value;                              
86         Burn(_from, _value);
87         return true;
88     }
89 }