1 pragma solidity ^0.4.11;
2 
3 pragma solidity ^0.4.11;
4 
5 interface IERC20 {
6     function totalSupply() constant returns (uint256 totalSupply);
7     function balanceOf(address _owner) constant returns (uint256 balance);
8     function transfer(address _to, uint256 _value) returns (bool success);
9     function transferFrom(address _from, address _to, uint256 _value) returns (bool success);
10     function approve(address _spender, uint256 _value) returns (bool success);
11     function allowance(address _owner, address _spender) constant returns (uint256 remaining);
12     event Transfer(address indexed _from, address indexed _to, uint256 _value);
13     event Approval(address indexed _owner, address indexed _spender, uint256 _value);
14 }
15 pragma solidity ^0.4.11;
16 
17 
18 /**
19  * @title SafeMath
20  * @dev Math operations with safety checks that throw on error
21  */
22 library SafeMath {
23   function mul(uint256 a, uint256 b) internal constant returns (uint256) {
24     uint256 c = a * b;
25     assert(a == 0 || c / a == b);
26     return c;
27   }
28 
29   function div(uint256 a, uint256 b) internal constant returns (uint256) {
30     // assert(b > 0); // Solidity automatically throws when dividing by 0
31     uint256 c = a / b;
32     // assert(a == b * c + a % b); // There is no case in which this doesn't hold
33     return c;
34   }
35 
36   function sub(uint256 a, uint256 b) internal constant returns (uint256) {
37     assert(b <= a);
38     return a - b;
39   }
40 
41   function add(uint256 a, uint256 b) internal constant returns (uint256) {
42     uint256 c = a + b;
43     assert(c >= a);
44     return c;
45   }
46 }
47 contract BDP is IERC20 {
48     
49     using SafeMath for uint256;
50     
51     uint public _totalSupply = 0;
52     
53     string public constant symbol = "BDP";
54     string public constant name = "BDP";
55     uint8 public constant decimals = 18;
56     
57     uint256 public constant RATE = 1300;
58     
59     address public owner;
60     
61     mapping(address => uint256) balances;
62     mapping(address => mapping(address =>uint256)) allowed;
63     
64     function () payable {
65         createTokens();
66     }
67     
68    function BDP() {
69        owner = msg.sender;
70    }
71     
72     function createTokens() payable {
73         require(msg.value > 0);
74         
75         uint256 tokens = msg.value.mul(RATE);
76         balances[msg.sender] = balances [msg.sender].add(tokens);
77         _totalSupply = _totalSupply.add(tokens);
78         owner.transfer(msg.value);
79     }
80     
81     function totalSupply() constant returns (uint256 totalSupply) {
82         return _totalSupply;
83     }
84 
85     function balanceOf(address _owner) constant returns (uint256 balance) {
86 
87         return balances[_owner];
88         
89     }
90     
91      function transfer(address _to, uint256 _value) returns (bool success) {
92         
93         require(
94             balances[msg.sender] >= _value
95             && _value > 0
96             ); 
97             
98             balances[msg.sender] = balances[msg.sender].sub(_value);
99             balances[_to] = balances[_to].add(_value);
100             Transfer(msg.sender, _to, _value);
101             return true;
102         }
103      
104 
105     function transferFrom(address _from, address _to, uint256 _value) returns (bool success){
106         require(
107             allowed[_from][msg.sender] >= _value
108             && balances[_from] >= _value
109             && _value > 0
110         );
111         balances[_from] = balances[_from].sub(_value);
112         balances[_to] = balances[_to].add(_value);
113         allowed[_from][msg.sender] = allowed[_from][msg.sender].sub(_value);
114         Transfer(_from, _to, _value);
115         return true;
116     }     
117               
118     function approve(address _spender, uint256 _value) returns (bool success) {
119      
120         allowed[msg.sender][_spender] = _value;
121         Approval(msg.sender, _spender, _value);
122         return true;
123     }
124         
125     function allowance(address _owner, address _spender) constant returns (uint256 remaining){
126         return allowed [_owner][_spender];
127         
128     }
129 
130 
131     
132     event Transfer(address indexed _from, address indexed _to, uint256 _value);
133     event Approval(address indexed _owner, address indexed _spender, uint256 _value);
134 }