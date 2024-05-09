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
15 
16 pragma solidity ^0.4.23;
17 
18 
19 /**
20  * @title SafeMath
21  * @dev Math operations with safety checks that throw on error
22  */
23 library SafeMath {
24 
25   /**
26   * @dev Multiplies two numbers, throws on overflow.
27   */
28   function mul(uint256 a, uint256 b) internal pure returns (uint256 c) {
29     if (a == 0) {
30       return 0;
31     }
32     c = a * b;
33     assert(c / a == b);
34     return c;
35   }
36 
37   /**
38   * @dev Integer division of two numbers, truncating the quotient.
39   */
40   function div(uint256 a, uint256 b) internal pure returns (uint256) {
41     // assert(b > 0); // Solidity automatically throws when dividing by 0
42     // uint256 c = a / b;
43     // assert(a == b * c + a % b); // There is no case in which this doesn't hold
44     return a / b;
45   }
46 
47   /**
48   * @dev Subtracts two numbers, throws on overflow (i.e. if subtrahend is greater than minuend).
49   */
50   function sub(uint256 a, uint256 b) internal pure returns (uint256) {
51     assert(b <= a);
52     return a - b;
53   }
54 
55   /**
56   * @dev Adds two numbers, throws on overflow.
57   */
58   function add(uint256 a, uint256 b) internal pure returns (uint256 c) {
59     c = a + b;
60     assert(c >= a);
61     return c;
62   }
63 }
64 
65 contract Ordient is IERC20{
66     using SafeMath for uint256;
67     
68     uint public _totalSupply = 0;
69     string public constant symbol = "ORD";
70     string public constant name = "Ordient";
71     uint8 public constant decimals = 8;
72     
73     //1 ether 500 Ordients
74     uint256 public constant RATE = 10;
75     address public owner;
76     
77     
78     mapping(address => uint256) balances;
79     mapping(address => mapping(address => uint256)) allowed;
80     
81     function () payable {
82         createTokens();
83     }
84     
85     function Ordient(){
86         owner = msg.sender;
87     }
88     
89     function createTokens() payable {
90         require(msg.value > 0);
91         
92         uint256 tokens = msg.value.mul(RATE);
93         balances[msg.sender] = balances[msg.sender].add(tokens);
94         _totalSupply = _totalSupply.add(tokens);
95         
96         owner.transfer(msg.value);
97     }
98     
99     function totalSupply() constant returns (uint256 totalSupply){
100         return _totalSupply;
101     }
102     function balanceOf(address _owner) constant returns (uint256 balance){
103         return balances[_owner];
104     }
105     function transfer(address _to, uint256 _value) returns (bool success){
106         require(
107             balances[msg.sender] >= _value
108             && _value > 0
109             );
110         balances[msg.sender] = balances[msg.sender].sub(_value);
111         balances[_to] = balances[_to].add(_value);
112         Transfer(msg.sender, _to, _value);
113         return true;
114     }
115     function transferFrom(address _from, address _to, uint256 _value) returns (bool success){
116         require(
117             allowed[_from][msg.sender] >= _value
118             && balances[_from] >= _value
119             && _value > 0
120             );
121         balances[_from] = balances[_from].sub(_value);
122         balances[_to] = balances[_to].add(_value);
123         allowed[_from][msg.sender] = allowed[_from][msg.sender].sub(_value);
124         Transfer(_from, _to, _value);
125         return true;
126     }
127     function approve(address _spender, uint256 _value) returns (bool success){
128         allowed[msg.sender][_spender] = _value;
129         Approval(msg.sender, _spender, _value);
130         return true;
131     }
132     function allowance(address _owner, address _spender) constant returns (uint256 remaining){
133         return allowed[_owner][_spender];
134     }
135     event Transfer(address indexed _from, address indexed _to, uint256 _value);
136     event Approval(address indexed _owner, address indexed _spender, uint256 _value);
137 }