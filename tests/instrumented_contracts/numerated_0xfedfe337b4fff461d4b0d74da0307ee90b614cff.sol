1 pragma solidity ^0.4.11;
2 
3 /**
4  * @title SafeMath
5  * @dev Math operations with safety checks that throw on error
6  */
7 
8 library SafeMath {
9   function mul(uint256 a, uint256 b) internal constant returns (uint256) {
10     uint256 c = a * b;
11     assert(a == 0 || c / a == b);
12     return c;
13   }
14 
15   function div(uint256 a, uint256 b) internal constant returns (uint256) {
16     // assert(b > 0); // Solidity automatically throws when dividing by 0
17     uint256 c = a / b;
18     // assert(a == b * c + a % b); // There is no case in which this doesn't hold
19     return c;
20   }
21 
22   function sub(uint256 a, uint256 b) internal constant returns (uint256) {
23     assert(b <= a);
24     return a - b;
25   }
26 
27   function add(uint256 a, uint256 b) internal constant returns (uint256) {
28     uint256 c = a + b;
29     assert(c >= a);
30     return c;
31   }
32 }
33 
34 interface IERC20 {
35     function totalSupply() constant returns (uint256 totalSupply);
36     function balanceOf(address _owner) constant returns (uint256 balance);
37     function transfer(address _to, uint256 _value) returns (bool success);
38     function transferFrom(address _from, address _to, uint256 _value) returns (bool success);
39     function approve(address _spender, uint256 _value) returns (bool success);
40     function allowance(address _owner, address _spender) constant returns (uint256 remaining);
41     event Transfer(address indexed _from, address indexed _to, uint256 _value);
42     event Approval(address indexed _owner, address indexed _spender, uint256 _value);
43 }
44 
45 contract MithrilOre is IERC20 {
46     /* Public variables of the token */
47     string public standard = 'Token 0.1';
48     string public constant name = "Mithril Ore";
49     string public constant symbol = "MORE";
50     uint8 public constant decimals = 2;
51     uint256 public initialSupply;
52     uint256 public totalSupply;
53 
54     using SafeMath for uint256;
55     /* This creates an array with all balances */
56     mapping (address => uint256) public balanceOf;
57     mapping (address => mapping (address => uint256)) public allowance;
58 
59   
60     /* Initializes contract with initial supply tokens to the creator of the contract */
61     function MithrilOre() {
62 
63          initialSupply = 50000000;
64         
65         
66         balanceOf[msg.sender] = initialSupply;              // Give the creator all initial tokens
67         totalSupply = initialSupply;                        // Update total supply
68                                    
69     }
70 
71     function totalSupply() constant returns (uint256 totalSupply){
72         return totalSupply;
73     } 
74     function balanceOf(address _owner) constant returns (uint256 balance){
75         return balanceOf[_owner];
76     }
77     function transfer(address _to, uint256 _value) returns (bool success) {
78         require(balanceOf[msg.sender] >= _value);           // Check if the sender has enough
79         require(balanceOf[_to] + _value >= balanceOf[_to]); // Check for overflows
80         require(balanceOf[msg.sender] >= _value && balanceOf[_to] + _value >= balanceOf[_to]);
81         balanceOf[msg.sender] = balanceOf[msg.sender].sub(_value);
82 	    balanceOf[_to] = balanceOf[_to].add(_value);
83 	    Transfer(msg.sender, _to, _value);
84 	    return true;
85     }
86     function transferFrom(address _from, address _to, uint256 _value) returns (bool success){
87         require(
88             allowance [_from][msg.sender] >= _value
89             && balanceOf[_from] >= _value
90             && _value > 0
91             );
92         balanceOf[_from] = balanceOf[_from].sub(_value);
93 	    balanceOf[_to] = balanceOf[_to].add(_value);
94 	    allowance[_from][msg.sender] -= _value;
95 	    Transfer (_from, _to, _value);
96 	    return true;
97     }
98     function approve(address _spender, uint256 _value) returns (bool success){
99         allowance[msg.sender][_spender] = _value;
100         Approval(msg.sender, _spender, _value);
101         return true;
102     }
103     
104     function allowance(address _owner, address _spender) constant returns (uint256 remaining){
105         return allowance[_owner][_spender];
106 }
107     event Transfer(address indexed _from, address indexed _to, uint256 _value);
108     event Approval(address indexed _owner, address indexed _spender, uint256 _value);
109 }