1 pragma solidity ^0.4.16;
2 
3 interface tokenRecipient { function receiveApproval(address _from, uint256 _value, address _token, bytes _extraData) external; }
4 
5 contract LegionToken {
6    
7     string public name;
8     string public symbol;
9     uint8 public decimals = 18;
10     
11     uint256 public totalSupply;
12 
13     mapping (address => uint256) public balanceOf;
14     mapping (address => mapping (address => uint256)) public allowance;
15 
16     event Transfer(address indexed from, address indexed to, uint256 value);
17 
18     event Burn(address indexed from, uint256 value);
19 
20     function LegionToken(
21         uint256 initialSupply,
22         string tokenName,
23         string tokenSymbol
24     ) public {
25         totalSupply = initialSupply * 10 ** uint256(decimals);  
26         balanceOf[msg.sender] = totalSupply;               
27         name = tokenName;                                  
28         symbol = tokenSymbol;                              
29     }
30 
31 
32     function _transfer(address _from, address _to, uint _value) internal {
33        
34         require(_to != 0x0);
35         require(balanceOf[_from] >= _value);
36         require(balanceOf[_to] + _value >= balanceOf[_to]);
37         uint previousBalances = balanceOf[_from] + balanceOf[_to];
38         balanceOf[_from] -= _value;
39         balanceOf[_to] += _value;
40         emit Transfer(_from, _to, _value);
41         assert(balanceOf[_from] + balanceOf[_to] == previousBalances);
42     }
43 
44     function transfer(address _to, uint256 _value) public {
45         _transfer(msg.sender, _to, _value);
46     }
47 
48     function transferFrom(address _from, address _to, uint256 _value) public returns (bool success) {
49         require(_value <= allowance[_from][msg.sender]);    
50         allowance[_from][msg.sender] -= _value;
51         _transfer(_from, _to, _value);
52         return true;
53     }
54 
55     function approve(address _spender, uint256 _value) public
56         returns (bool success) {
57         allowance[msg.sender][_spender] = _value;
58         return true;
59     }
60 
61     function approveAndCall(address _spender, uint256 _value, bytes _extraData)
62         public
63         returns (bool success) {
64         tokenRecipient spender = tokenRecipient(_spender);
65         if (approve(_spender, _value)) {
66             spender.receiveApproval(msg.sender, _value, this, _extraData);
67             return true;
68         }
69     }
70 
71     function burn(uint256 _value) public returns (bool success) {
72         require(balanceOf[msg.sender] >= _value);   
73         balanceOf[msg.sender] -= _value;           
74         totalSupply -= _value;                      
75         emit Burn(msg.sender, _value);
76         return true;
77     }
78 
79     function burnFrom(address _from, uint256 _value) public returns (bool success) {
80         require(balanceOf[_from] >= _value);                
81         require(_value <= allowance[_from][msg.sender]);    
82         balanceOf[_from] -= _value;                         
83         allowance[_from][msg.sender] -= _value;            
84         totalSupply -= _value;                              
85         emit Burn(_from, _value);
86         return true;
87     }
88 }