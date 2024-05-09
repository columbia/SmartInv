1 pragma solidity ^0.4.16;
2 
3 interface tokenRecipient { function receiveApproval(address _from, uint256 _value, address _token, bytes _extraData) external; }
4 
5 /*
6 *ERC20
7 *
8 */
9 contract ASSET {
10 
11         string public name;  
12         string public symbol;  
13         uint8 public decimals = 18; 
14         uint256 public total = 1000000000;
15         uint256 public totalSupply; 
16 
17         mapping (address => uint256) public balanceOf;
18         mapping (address => mapping (address => uint256)) public allowance;
19         event Transfer(address indexed from, address indexed to, uint256 value);
20 
21         event Burn(address indexed from, uint256 value);
22 
23 
24         function ASSET( ) public {
25 
26                 totalSupply = total * 10 ** uint256(decimals);
27 
28                 balanceOf[msg.sender] = totalSupply;
29 
30                 name = "ASSET"; 
31 
32                 symbol = "ASSET";
33 
34         }
35 
36      function _transfer(address _from, address _to, uint _value) internal {
37     
38         require(_to != 0x0);
39      
40         require(balanceOf[_from] >= _value);
41      
42         require(balanceOf[_to] + _value >= balanceOf[_to]);
43   
44         uint previousBalances = balanceOf[_from] + balanceOf[_to];
45    
46         balanceOf[_from] -= _value;
47     
48         balanceOf[_to] += _value;
49         Transfer(_from, _to, _value);
50   
51         assert(balanceOf[_from] + balanceOf[_to] == previousBalances);
52     }
53 
54 
55     function transfer(address _to, uint256 _value) public {
56         _transfer(msg.sender, _to, _value);
57     }
58 
59 
60     function transferFrom(address _from, address _to, uint256 _value) public returns (bool success) {
61         require(_value <= allowance[_from][msg.sender]);     
62         allowance[_from][msg.sender] -= _value;
63         _transfer(_from, _to, _value);
64         return true;
65     }
66 
67  
68     function approve(address _spender, uint256 _value) public
69         returns (bool success) {
70         allowance[msg.sender][_spender] = _value;
71         return true;
72     }
73 
74 
75     function approveAndCall(address _spender, uint256 _value, bytes _extraData)
76         public
77         returns (bool success) {
78         tokenRecipient spender = tokenRecipient(_spender);
79         if (approve(_spender, _value)) {
80             spender.receiveApproval(msg.sender, _value, this, _extraData);
81             return true;
82         }
83     }
84 
85 
86     function burn(uint256 _value) public returns (bool success) {
87         require(balanceOf[msg.sender] >= _value);   
88         balanceOf[msg.sender] -= _value;            
89         totalSupply -= _value;                     
90         Burn(msg.sender, _value);
91         return true;
92     }
93 
94 
95     function burnFrom(address _from, uint256 _value) public returns (bool success) {
96         require(balanceOf[_from] >= _value);                
97         require(_value <= allowance[_from][msg.sender]);    
98         balanceOf[_from] -= _value;                       
99         allowance[_from][msg.sender] -= _value;            
100         totalSupply -= _value;                            
101         Burn(_from, _value);
102         return true;
103     }   
104 
105 }