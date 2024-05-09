1 pragma solidity ^0.4.11;
2 
3 interface IERC20 {
4     function totalSupply() constant returns (uint totalSupply);
5     function balanceOf(address _owner) constant returns (uint balance);
6     function transfer(address _to, uint _value) returns (bool success);
7     function transferFrom(address _from, address _to, uint _value) returns (bool success);
8     function approve(address _spender, uint _value) returns (bool success);
9     function allowance(address _owner, address _spender) constant returns (uint remaining);
10     event Transfer(address indexed _from, address indexed _to, uint _value);
11     event Approval(address indexed _owner, address indexed _spender, uint _value);
12 }
13 
14 /**
15  * @title SafeMath
16  * @dev Math operations with safety checks that throw on error
17  */
18 library SafeMath {
19   function mul(uint256 a, uint256 b) internal returns (uint256) {
20     uint256 c = a * b;
21     assert(a == 0 || c / a == b);
22     return c;
23   }
24 
25   function div(uint256 a, uint256 b) internal returns (uint256) {
26     // assert(b > 0); // Solidity automatically throws when dividing by 0
27     uint256 c = a / b;
28     // assert(a == b * c + a % b); // There is no case in which this doesn't hold
29     return c;
30   }
31 
32   function sub(uint256 a, uint256 b) internal returns (uint256) {
33     assert(b <= a);
34     return a - b;
35   }
36 
37   function add(uint256 a, uint256 b) internal returns (uint256) {
38     uint256 c = a + b;
39     assert(c >= a);
40     return c;
41   }
42 }
43 
44 
45 contract LamboToken is IERC20 {
46     
47     using SafeMath for uint256;
48     
49     uint public _totalSupply = 0;
50     
51     string public constant symbol = "LAMBO";
52     string public constant name = "Lambo Token";
53     uint8 public constant decimals = 18;
54     
55     uint256 public constant RATE = 500;
56     
57     address public owner;
58     
59     mapping(address => uint256) balances;
60     mapping(address => mapping(address =>uint256)) allowed;
61     
62     function () payable {
63         createTokens();
64     }
65     
66    function LamboToken() {
67        owner = msg.sender;
68    }
69     
70     function createTokens() payable {
71         require(msg.value > 0);
72         
73         uint256 tokens = msg.value.mul(RATE);
74         balances[msg.sender] = balances [msg.sender].add(tokens);
75         _totalSupply = _totalSupply.add(tokens);
76         owner.transfer(msg.value);
77     }
78     
79     function totalSupply() constant returns (uint256 totalSupply) {
80         return _totalSupply;
81     }
82 
83     function balanceOf(address _owner) constant returns (uint256 balance) {
84 
85         return balances[_owner];
86         
87     }
88     
89      function transfer(address _to, uint256 _value) returns (bool success) {
90         
91         require(
92             balances[msg.sender] >= _value
93             && _value > 0
94             ); 
95             
96             balances[msg.sender] = balances[msg.sender].sub(_value);
97             balances[_to] = balances[_to].add(_value);
98             Transfer(msg.sender, _to, _value);
99             return true;
100         }
101      
102 
103     function transferFrom(address _from, address _to, uint256 _value) returns (bool success){
104         require(
105             allowed[_from][msg.sender] >= _value
106             && balances[_from] >= _value
107             && _value > 0
108         );
109         balances[_from] = balances[_from].sub(_value);
110         balances[_to] = balances[_to].add(_value);
111         allowed[_from][msg.sender] = allowed[_from][msg.sender].sub(_value);
112         Transfer(_from, _to, _value);
113         return true;
114     }     
115               
116     function approve(address _spender, uint256 _value) returns (bool success) {
117      
118         allowed[msg.sender][_spender] = _value;
119         Approval(msg.sender, _spender, _value);
120         return true;
121     }
122         
123     function allowance(address _owner, address _spender) constant returns (uint256 remaining){
124         return allowed [_owner][_spender];
125         
126     }
127 
128 
129     
130     event Transfer(address indexed _from, address indexed _to, uint256 _value);
131     event Approval(address indexed _owner, address indexed _spender, uint256 _value);
132 }