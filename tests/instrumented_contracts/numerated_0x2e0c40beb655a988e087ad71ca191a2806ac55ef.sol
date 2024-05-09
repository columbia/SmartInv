1 pragma solidity ^0.4.21;
2 
3 library SafeMath {
4   function mul(uint256 a, uint256 b) internal pure returns (uint256) {
5     if (a == 0) {
6       return 0;
7     }
8     uint256 c = a * b;
9     assert(c / a == b);
10     return c;
11   }
12 
13   function div(uint256 a, uint256 b) internal pure returns (uint256) {
14     // assert(b > 0); // Solidity automatically throws when dividing by 0
15     uint256 c = a / b;
16     // assert(a == b * c + a % b); // There is no case in which this doesn't hold
17     return c;
18   }
19 
20   function sub(uint256 a, uint256 b) internal pure returns (uint256) {
21     assert(b <= a);
22     return a - b;
23   }
24 
25   function add(uint256 a, uint256 b) internal pure returns (uint256) {
26     uint256 c = a + b;
27     assert(c >= a);
28     return c;
29   }
30 }
31 
32 contract Token {
33 
34     uint256 public totalSupply;
35     function balanceOf(address _owner) public view returns (uint256 balance);
36 	function transfer(address _to, uint256 _value) public returns (bool success);
37 	function transferFrom(address _from, address _to, uint256 _value) public returns (bool success);
38 	function approve(address _spender, uint256 _value) public returns (bool success);
39 	function allowance(address _owner, address _spender) public view returns (uint256 remaining);
40 	event Transfer(address indexed _from, address indexed _to, uint256 _value);
41 	event Approval(address indexed _owner, address indexed _spender, uint256 _value);
42 }
43 
44 
45 /*  ERC 20 token */
46 contract StandardToken is Token {
47  
48 
49     function transfer(address _to, uint256 _value) returns (bool success) {
50         if (balances[msg.sender] >= _value && _value > 0) {
51             balances[msg.sender] -= _value;
52             balances[_to] += _value;
53             Transfer(msg.sender, _to, _value);
54             return true;
55         } else {
56             return false;
57         }
58     }
59  
60     function transferFrom(address _from, address _to, uint256 _value) returns (bool success) {
61         if (balances[_from] >= _value && allowed[_from][msg.sender] >= _value && _value > 0) {
62             balances[_to] += _value;
63             balances[_from] -= _value;
64             allowed[_from][msg.sender] -= _value;
65             Transfer(_from, _to, _value);
66             return true;
67         } else {
68             return false;
69         }
70     }
71  
72     function balanceOf(address _owner) constant returns (uint256 balance) {
73         return balances[_owner];
74     }
75  
76     function approve(address _spender, uint256 _value) returns (bool success) {
77         allowed[msg.sender][_spender] = _value;
78         Approval(msg.sender, _spender, _value);
79         return true;
80     }
81  
82     function allowance(address _owner, address _spender) constant returns (uint256 remaining) {
83         return allowed[_owner][_spender];
84     }
85  
86     mapping (address => uint256) balances;
87     mapping (address => mapping (address => uint256)) allowed;
88 }
89 
90 contract CarNomicToken is StandardToken {
91 
92 	using SafeMath for uint;
93 	
94     string public constant name = "CarNomic Token";
95     string public constant symbol = "CARM";
96     uint public constant decimals = 18;
97 
98     address public target;    
99 
100     /**
101      * CONSTRUCTOR 
102      * 
103      * @dev Initialize the CarNomicToken
104      */
105     function CarNomicToken(address _target) {
106         target = _target;
107         totalSupply = 10 * 10 ** 9 * 10 ** uint256(decimals); // 10B
108         balances[target] = totalSupply;
109     }   
110 }