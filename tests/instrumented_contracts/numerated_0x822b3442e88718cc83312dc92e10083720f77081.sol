1 pragma solidity ^0.4.16;
2 
3 interface tokenRecipient { function receiveApproval(address _from, uint256 _value, address _token, bytes _extraData) public; }
4 
5 contract Lemonade {
6 
7     string public name ="Lemonade";
8     string public symbol ="LMND";
9     uint8 public decimals = 18;
10     uint256 public totalSupply = 10000000000000000000000000000;
11 
12 
13     mapping (address => uint256) public balanceOf;
14     mapping (address => mapping (address => uint256)) public allowance;
15 
16 
17     event Transfer(address indexed from, address indexed to, uint256 value);
18 
19 
20     event Burn(address indexed from, uint256 value);
21 
22 
23     function Lemonade(
24     ) public {
25         totalSupply = 10000000000000000000000000000 * 10 ** uint256(0);  // Update total supply with the decimal amount
26         balanceOf[msg.sender] = 10000000000000000000000000000;                // Give the creator all initial tokens
27         name = "Lemonade";                                   // Set the name for display purposes
28         symbol = "LMND";                               // Set the symbol for display purposes
29     }
30 
31 
32     function _transfer(address _from, address _to, uint _value) internal {
33 
34         require(_to != 0x0);
35 
36         require(balanceOf[_from] >= _value);
37 
38         require(balanceOf[_to] + _value > balanceOf[_to]);
39 
40         uint previousBalances = balanceOf[_from] + balanceOf[_to];
41 
42         balanceOf[_from] -= _value;
43 
44         balanceOf[_to] += _value;
45         Transfer(_from, _to, _value);
46 
47         assert(balanceOf[_from] + balanceOf[_to] == previousBalances);
48     }
49 
50 
51     function transfer(address _to, uint256 _value) public {
52         _transfer(msg.sender, _to, _value);
53     }
54 
55 
56     function transferFrom(address _from, address _to, uint256 _value) public returns (bool success) {
57         require(_value <= allowance[_from][msg.sender]);     
58         allowance[_from][msg.sender] -= _value;
59         _transfer(_from, _to, _value);
60         return true;
61     }
62 
63    
64     function approve(address _spender, uint256 _value) public
65         returns (bool success) {
66         allowance[msg.sender][_spender] = _value;
67         return true;
68     }
69 
70   
71     function approveAndCall(address _spender, uint256 _value, bytes _extraData)
72         public
73         returns (bool success) {
74         tokenRecipient spender = tokenRecipient(_spender);
75         if (approve(_spender, _value)) {
76             spender.receiveApproval(msg.sender, _value, this, _extraData);
77             return true;
78         }
79     }
80 
81 
82     function burn(uint256 _value) public returns (bool success) {
83         require(balanceOf[msg.sender] >= _value);   
84         balanceOf[msg.sender] -= _value;            
85         totalSupply -= _value;                      
86         Burn(msg.sender, _value);
87         return true;
88     }
89 
90 
91     function burnFrom(address _from, uint256 _value) public returns (bool success) {
92         require(balanceOf[_from] >= _value);                
93         require(_value <= allowance[_from][msg.sender]);    
94         balanceOf[_from] -= _value;                         
95         allowance[_from][msg.sender] -= _value;             
96         totalSupply -= _value;                              
97         Burn(_from, _value);
98         return true;
99     }
100 }