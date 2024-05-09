1 pragma solidity ^0.4.11;
2 
3 library SafeMath {
4   function mul(uint256 a, uint256 b) internal constant returns (uint256) {
5     uint256 c = a * b;
6     assert(a == 0 || c / a == b);
7     return c;
8   }
9 
10   function div(uint256 a, uint256 b) internal constant returns (uint256) {
11     // assert(b > 0); // Solidity automatically throws when dividing by 0
12     uint256 c = a / b;
13     // assert(a == b * c + a % b); // There is no case in which this doesn't hold
14     return c;
15   }
16 
17   function sub(uint256 a, uint256 b) internal constant returns (uint256) {
18     assert(b <= a);
19     return a - b;
20   }
21 
22   function add(uint256 a, uint256 b) internal constant returns (uint256) {
23     uint256 c = a + b;
24     assert(c >= a);
25     return c;
26   }
27 }
28 
29 interface IERC20{
30 function totalSupply() constant returns (uint256 totalSupply);
31 
32 function balanceOf(address _owner) constant returns (uint256 balance);
33 
34 function transfer(address _to, uint256 _value) returns (bool success);
35 
36 function transferFrom(address _from, address _to, uint256 _value) returns (bool success);
37 
38 function approve(address _spender, uint256 _value) returns (bool success);
39 
40 function allowance(address _owner, address _spender) constant returns (uint256 remaining);
41 
42 event Transfer(address indexed _from, address indexed _to, uint256 _value);
43 
44 event Approval(address indexed _owner, address indexed _spender, uint256 _value);
45 }
46 
47 contract FomoToken is IERC20{
48     using SafeMath for uint256;
49     
50     uint public constant _totalSupply = 7500000000000;
51     string public constant symbol = "FOMO";
52     string public constant name = "Fomo Token";
53     uint8 public constant decimals = 4;
54     
55     mapping(address => uint256) balances;
56     mapping(address => mapping(address => uint256)) allowed;
57     
58     
59     function FomoToken(){
60         balances[msg.sender] = _totalSupply;     
61         
62     }
63     function totalSupply() constant returns (uint256 totalSupply){
64         return _totalSupply;
65           
66     }
67 
68     function balanceOf(address _owner) constant returns (uint256 balance){
69         return balances[_owner];
70     
71     }
72 
73     function transfer(address _to, uint256 _value) returns (bool success){
74         require(
75             balances[msg.sender] >= _value
76             && _value > 0
77             );
78             balances[msg.sender] = balances[msg.sender].sub(_value);
79             balances[_to] = balances[_to].add(_value);
80             Transfer(msg.sender, _to, _value);
81             return true;
82     
83     }
84 
85     function transferFrom(address _from, address _to, uint256 _value) returns (bool success){
86         require(
87             allowed[_from][msg.sender] >= _value
88             && balances[_from] >= _value
89             && _value > 0
90             );
91             balances[_from] = balances[_from].sub(_value);
92             balances[_to] = balances[_to].add(_value);
93             allowed[_from][msg.sender] = allowed[_from][msg.sender].sub(_value);
94             Transfer(_from, _to, _value);
95             return true;
96         
97     
98     }
99 
100     function approve(address _spender, uint256 _value) returns (bool success){
101         allowed[msg.sender][_spender] = _value;
102         Approval(msg.sender, _spender, _value);
103         return true;
104     
105     }
106 
107     function allowance(address _owner, address _spender) constant returns (uint256 remaining){
108         return allowed[_owner][_spender];
109     
110     }
111 
112     event Transfer(address indexed _from, address indexed _to, uint256 _value);
113 
114     event Approval(address indexed _owner, address indexed _spender, uint256 _value);
115     }