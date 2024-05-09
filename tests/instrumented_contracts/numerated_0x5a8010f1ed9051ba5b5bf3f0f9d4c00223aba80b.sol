1 pragma solidity ^0.4.16;
2 
3 interface tokenRecipient { function receiveApproval(address _from, uint256 _value, address _token, bytes _extraData) external; }
4 
5 contract NAIRADIGITALTETHER {
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
22         uint256 initialSupply,
23         string tokenName,
24         string tokenSymbol
25     ) public {
26         totalSupply = initialSupply * 10 ** uint256(decimals);  
27         balanceOf[msg.sender] = totalSupply;               
28         name = tokenName;                                  
29         symbol = tokenSymbol;                               
30     }
31 
32 
33     function _transfer(address _from, address _to, uint _value) internal {
34 
35         require(_to != 0x0);
36         require(balanceOf[_from] >= _value);
37         require(balanceOf[_to] + _value >= balanceOf[_to]);
38         uint previousBalances = balanceOf[_from] + balanceOf[_to];
39         balanceOf[_from] -= _value;
40         balanceOf[_to] += _value;
41         emit Transfer(_from, _to, _value);
42         assert(balanceOf[_from] + balanceOf[_to] == previousBalances);
43     }
44 
45 
46     function transfer(address _to, uint256 _value) public {
47         _transfer(msg.sender, _to, _value);
48     }
49 
50 
51     function transferFrom(address _from, address _to, uint256 _value) public returns (bool success) {
52         require(_value <= allowance[_from][msg.sender]);  
53         allowance[_from][msg.sender] -= _value;
54         _transfer(_from, _to, _value);
55         return true;
56     }
57 
58     
59     function approve(address _spender, uint256 _value) public
60         returns (bool success) {
61         allowance[msg.sender][_spender] = _value;
62         return true;
63     }
64 
65 
66     function approveAndCall(address _spender, uint256 _value, bytes _extraData)
67         public
68         returns (bool success) {
69         tokenRecipient spender = tokenRecipient(_spender);
70         if (approve(_spender, _value)) {
71             spender.receiveApproval(msg.sender, _value, this, _extraData);
72             return true;
73         }
74     }
75 
76     function burn(uint256 _value) public returns (bool success) {
77         require(balanceOf[msg.sender] >= _value);   
78         balanceOf[msg.sender] -= _value;          
79         totalSupply -= _value;                      
80         emit Burn(msg.sender, _value);
81         return true;
82     }
83 
84 
85     function burnFrom(address _from, uint256 _value) public returns (bool success) {
86         require(balanceOf[_from] >= _value);                
87         require(_value <= allowance[_from][msg.sender]);    
88         balanceOf[_from] -= _value;                         
89         allowance[_from][msg.sender] -= _value;             
90         totalSupply -= _value;                              
91         emit Burn(_from, _value);
92         return true;
93     }
94 }