1 pragma solidity ^0.4.16;
2 
3 interface tokenRecipient { function receiveApproval(address _from, uint256 _value, address _token, bytes _extraData) external; }
4 
5 contract GTokenContract {
6     string public name;
7     string public symbol;
8     uint8 public decimals = 18;
9     uint256 public totalSupply;
10 
11     mapping (address => uint256) public balanceOf;
12     mapping (address => mapping (address => uint256)) public allowance;
13 
14     event Transfer(address indexed from, address indexed to, uint256 value);
15     event Burn(address indexed from, uint256 value);
16 
17 
18     function GTokenContract(
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
29     function _transfer(address _from, address _to, uint _value) internal {
30         require(_to != 0x0);
31         require(balanceOf[_from] >= _value);
32         require(balanceOf[_to] + _value >= balanceOf[_to]);
33         uint previousBalances = balanceOf[_from] + balanceOf[_to];
34         balanceOf[_from] -= _value;
35         balanceOf[_to] += _value;
36         emit Transfer(_from, _to, _value);
37         assert(balanceOf[_from] + balanceOf[_to] == previousBalances);
38     }
39 
40     function transfer(address _to, uint256 _value) public {
41         _transfer(msg.sender, _to, _value);
42     }
43 	
44     function transferFrom(address _from, address _to, uint256 _value) public returns (bool success) {
45         require(_value <= allowance[_from][msg.sender]);     // Check allowance
46         allowance[_from][msg.sender] -= _value;
47         _transfer(_from, _to, _value);
48         return true;
49     }
50 
51     function approve(address _spender, uint256 _value) public
52         returns (bool success) {
53         allowance[msg.sender][_spender] = _value;
54         return true;
55     }
56 
57     function approveAndCall(address _spender, uint256 _value, bytes _extraData)
58         public
59         returns (bool success) {
60         tokenRecipient spender = tokenRecipient(_spender);
61         if (approve(_spender, _value)) {
62             spender.receiveApproval(msg.sender, _value, this, _extraData);
63             return true;
64         }
65     }
66 
67 
68     function burn(uint256 _value) public returns (bool success) {
69         require(balanceOf[msg.sender] >= _value);   
70         balanceOf[msg.sender] -= _value;  
71         totalSupply -= _value;              
72         emit Burn(msg.sender, _value);
73         return true;
74     }
75 
76 
77     function burnFrom(address _from, uint256 _value) public returns (bool success) {
78         require(balanceOf[_from] >= _value);                
79         require(_value <= allowance[_from][msg.sender]);    
80         balanceOf[_from] -= _value;                         
81         allowance[_from][msg.sender] -= _value;        
82         totalSupply -= _value;                             
83         emit Burn(_from, _value);
84         return true;
85     }
86 }