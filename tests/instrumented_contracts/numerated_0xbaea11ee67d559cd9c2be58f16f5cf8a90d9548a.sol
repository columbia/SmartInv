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
47 
48 contract CopyTokens is IERC20 {
49     
50     using SafeMath for uint256;
51     
52     uint public _totalSupply = 0;
53     
54     string public constant symbol = "COPY";
55     string public constant name = "Copy Tokens";
56     uint8 public constant decimals = 18;
57     
58     uint256 public constant RATE = 1000;
59     
60     address public owner;
61     
62     mapping(address => uint256) balances;
63     mapping(address => mapping(address =>uint256)) allowed;
64     
65     function () payable {
66         createTokens();
67     }
68     
69    function CopyTokens() {
70        owner = msg.sender;
71    }
72     
73     function createTokens() payable {
74         require(msg.value > 0);
75         
76         uint256 tokens = msg.value.mul(RATE);
77         balances[msg.sender] = balances [msg.sender].add(tokens);
78         _totalSupply = _totalSupply.add(tokens);
79         owner.transfer(msg.value);
80     }
81     
82     function totalSupply() constant returns (uint256 totalSupply) {
83         return _totalSupply;
84     }
85 
86     function balanceOf(address _owner) constant returns (uint256 balance) {
87 
88         return balances[_owner];
89         
90     }
91     
92      function transfer(address _to, uint256 _value) returns (bool success) {
93         
94         require(
95             balances[msg.sender] >= _value
96             && _value > 0
97             ); 
98             
99             balances[msg.sender] = balances[msg.sender].sub(_value);
100             balances[_to] = balances[_to].add(_value);
101             Transfer(msg.sender, _to, _value);
102             return true;
103         }
104      
105 
106     function transferFrom(address _from, address _to, uint256 _value) returns (bool success){
107         require(
108             allowed[_from][msg.sender] >= _value
109             && balances[_from] >= _value
110             && _value > 0
111         );
112         balances[_from] = balances[_from].sub(_value);
113         balances[_to] = balances[_to].add(_value);
114         allowed[_from][msg.sender] = allowed[_from][msg.sender].sub(_value);
115         Transfer(_from, _to, _value);
116         return true;
117     }     
118               
119     function approve(address _spender, uint256 _value) returns (bool success) {
120      
121         allowed[msg.sender][_spender] = _value;
122         Approval(msg.sender, _spender, _value);
123         return true;
124     }
125         
126     function allowance(address _owner, address _spender) constant returns (uint256 remaining){
127         return allowed [_owner][_spender];
128         
129     }
130 
131 
132     
133     event Transfer(address indexed _from, address indexed _to, uint256 _value);
134     event Approval(address indexed _owner, address indexed _spender, uint256 _value);
135 }