1 pragma solidity ^0.4.16;
2 
3 interface tokenRecipient { function receiveApproval(address _from, uint256 _value, address _token, bytes _extraData) external; }
4 
5 contract CIBSToken {
6 
7     string public name;
8 
9     string public symbol;
10 
11     uint8 public decimals = 18; 
12 
13     uint256 public totalSupply;
14 
15     mapping (address => uint256) public balanceOf;
16 
17     mapping (address => mapping (address => uint256)) public allowance;
18 
19     event Transfer(address indexed from, address indexed to, uint256 value);
20 
21     event Burn(address indexed from, uint256 value);
22 
23     function CIBSToken (
24         uint256 initialSupply,
25         string tokenName,
26         string tokenSymbol
27     ) public {
28         totalSupply = initialSupply * 10 ** uint256(decimals);  
29         balanceOf[msg.sender] = totalSupply;                
30         name = tokenName;                                  
31         symbol = tokenSymbol;                              
32     }
33 
34     function _transfer(address _from, address _to, uint _value) internal {
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
45     function transfer(address _to, uint256 _value) public {
46         _transfer(msg.sender, _to, _value);
47     }
48 
49     function transferFrom(address _from, address _to, uint256 _value) public returns (bool success) {
50         require(_value <= allowance[_from][msg.sender]);    
51         allowance[_from][msg.sender] -= _value;
52         _transfer(_from, _to, _value);
53         return true;
54     }
55 
56     function approve(address _spender, uint256 _value) public
57         returns (bool success) {
58         allowance[msg.sender][_spender] = _value;
59         return true;
60     }
61 
62     function approveAndCall(address _spender, uint256 _value, bytes _extraData)
63         public
64         returns (bool success) {
65         tokenRecipient spender = tokenRecipient(_spender);
66         if (approve(_spender, _value)) {
67             spender.receiveApproval(msg.sender, _value, this, _extraData);
68             return true;
69         }
70     }
71 
72     function burn(uint256 _value) public returns (bool success) {
73         require(balanceOf[msg.sender] >= _value); 
74         balanceOf[msg.sender] -= _value;            
75         totalSupply -= _value;                      
76         emit Burn(msg.sender, _value);
77         return true;
78     }
79 
80     function burnFrom(address _from, uint256 _value) public returns (bool success) {
81         require(balanceOf[_from] >= _value);                
82         require(_value <= allowance[_from][msg.sender]);    
83         balanceOf[_from] -= _value;                        
84         allowance[_from][msg.sender] -= _value;            
85         totalSupply -= _value;                              
86         emit Burn(_from, _value);
87         return true;
88     }
89 
90     function transferArray(address[] _to, uint256[] _value) public {
91         for(uint256 i = 0; i < _to.length; i++){
92             _transfer(msg.sender, _to[i], _value[i]);
93         }
94     }
95 }