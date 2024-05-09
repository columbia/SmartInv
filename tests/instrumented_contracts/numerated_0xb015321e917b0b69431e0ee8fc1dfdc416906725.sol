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
35 contract ekkoBlock1 is SafeMath {
36     string public name;
37     string public symbol;
38     uint8 public decimals;
39     uint256 public totalSupply;
40 	  address public owner;
41 
42     mapping (address => uint256) public balanceOf;
43     mapping (address => uint256) public freezeOf;
44     mapping (address => mapping (address => uint256)) public allowance;
45 
46     event Transfer(address indexed from, address indexed to, uint256 value);
47     event Freeze(address indexed from, uint256 value);
48     event Unfreeze(address indexed from, uint256 value);
49     
50     function ekkoBlock1(
51         uint256 initialSupply,
52         string tokenName,
53         uint8 decimalUnits,
54         string tokenSymbol
55         ) public  {
56         balanceOf[msg.sender] = initialSupply;              
57         totalSupply = initialSupply;                        
58         name = tokenName;                                   
59         symbol = tokenSymbol;                               
60         decimals = decimalUnits;                    
61 		owner = msg.sender;
62     }
63 
64 
65     function transfer(address _to, uint256 _value) public {
66         if (_to == 0x0)  revert();                               
67 		if (_value <= 0)  revert(); 
68         if (balanceOf[msg.sender] < _value)  revert();           
69         if (balanceOf[_to] + _value < balanceOf[_to])  revert(); 
70         balanceOf[msg.sender] = SafeMath.safeSub(balanceOf[msg.sender], _value);                    
71         balanceOf[_to] = SafeMath.safeAdd(balanceOf[_to], _value);                           
72         Transfer(msg.sender, _to, _value);                  
73     }
74 
75     function transferFrom(address _from, address _to, uint256 _value) public returns (bool success) {
76         if (_to == 0x0)  revert();                                
77 		if (_value <= 0)  revert(); 
78         if (balanceOf[_from] < _value)  revert();                 
79         if (balanceOf[_to] + _value < balanceOf[_to])  revert();  
80         if (_value > allowance[_from][msg.sender])  revert();     
81         balanceOf[_from] = SafeMath.safeSub(balanceOf[_from], _value);                           
82         balanceOf[_to] = SafeMath.safeAdd(balanceOf[_to], _value);                
83         allowance[_from][msg.sender] = SafeMath.safeSub(allowance[_from][msg.sender], _value);
84         Transfer(_from, _to, _value);
85         return true;
86     }
87     
88     function freeze(address _target, uint256 _value) public returns (bool success) {
89         if(msg.sender != owner) revert();
90         if (balanceOf[_target] < _value)  revert();            // Check if the _target has enough
91 		    if (_value <= 0)  revert(); 
92         balanceOf[_target] = SafeMath.safeSub(balanceOf[_target], _value);                      // Subtract from the sender
93         freezeOf[_target] = SafeMath.safeAdd(freezeOf[_target], _value);                                // Updates totalSupply
94         Freeze(_target, _value);
95         return true;
96     }
97 	
98 	  function unfreeze(address _target, uint256 _value) public returns (bool success) {
99         if(msg.sender != owner) revert();
100         if (freezeOf[_target] < _value)  revert();            // Check if the _target has enough
101         if (_value <= 0)  revert(); 
102         freezeOf[_target] = SafeMath.safeSub(freezeOf[_target], _value);                      // Subtract from the sender
103         balanceOf[_target] = SafeMath.safeAdd(balanceOf[_target], _value);
104         Unfreeze(_target, _value);
105         return true;
106     }
107 
108 }