1 pragma solidity ^0.4.18;
2 /*
3  * Math operations with safety checks
4  */
5 contract SafeMath {
6   function safeMul(uint256 a, uint256 b) internal pure returns (uint256) {
7     if (a == 0) {
8     return 0;
9     }
10     uint256 c = a * b;
11     assert(c / a == b);
12     return c;
13   }
14 
15   function safeDiv(uint256 a, uint256 b) internal pure returns (uint256) {
16     // assert(b > 0); // Solidity automatically throws when dividing by 0
17     uint256 c = a / b;
18     // assert(a == b * c + a % b); // There is no case in which this doesn't hold
19     return c;
20   }
21 
22   function safeSub(uint256 a, uint256 b) internal pure returns (uint256) {
23     assert(b <= a);
24     return a - b;
25   }
26 
27   function safeAdd(uint256 a, uint256 b) internal pure returns (uint256) {
28     uint256 c = a + b;
29     assert(c >= a);
30     return c;
31   }
32 }
33 
34 
35 contract NewToken is SafeMath {
36     string public name;
37     string public symbol;
38     uint8 public decimals;
39     uint256 public totalSupply;
40 	address public owner;
41 
42     mapping (address => uint256) public balanceOf;
43     mapping (address => mapping (address => uint256)) public allowance;
44 
45     event Transfer(address indexed from, address indexed to, uint256 value);
46 
47     function NewToken(
48         uint256 initialSupply,
49         string tokenName,
50         uint8 decimalUnits,
51         string tokenSymbol
52         ) public  {
53         balanceOf[msg.sender] = initialSupply;              
54         totalSupply = initialSupply;                        
55         name = tokenName;                                   
56         symbol = tokenSymbol;                               
57         decimals = decimalUnits;                    
58 		owner = msg.sender;
59     }
60 
61 
62     function transfer(address _to, uint256 _value) public {
63         if (_to == 0x0)  revert();                               
64 		if (_value <= 0)  revert(); 
65         if (balanceOf[msg.sender] < _value)  revert();           
66         if (balanceOf[_to] + _value < balanceOf[_to])  revert(); 
67         balanceOf[msg.sender] = SafeMath.safeSub(balanceOf[msg.sender], _value);                    
68         balanceOf[_to] = SafeMath.safeAdd(balanceOf[_to], _value);                           
69         Transfer(msg.sender, _to, _value);                  
70     }
71 
72     function transferFrom(address _from, address _to, uint256 _value) public returns (bool success) {
73         if (_to == 0x0)  revert();                                
74 		if (_value <= 0)  revert(); 
75         if (balanceOf[_from] < _value)  revert();                 
76         if (balanceOf[_to] + _value < balanceOf[_to])  revert();  
77         if (_value > allowance[_from][msg.sender])  revert();     
78         balanceOf[_from] = SafeMath.safeSub(balanceOf[_from], _value);                           
79         balanceOf[_to] = SafeMath.safeAdd(balanceOf[_to], _value);                
80         allowance[_from][msg.sender] = SafeMath.safeSub(allowance[_from][msg.sender], _value);
81         Transfer(_from, _to, _value);
82         return true;
83     }
84 
85 }