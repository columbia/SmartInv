1 pragma solidity ^0.4.11;
2 
3 interface IERC20 {
4     function totalSupply() constant returns (uint256 totalSupply);
5     function balanceOf(address _owner) constant returns (uint256 balance);
6     function transfer(address _to, uint256 _value) returns (bool success);
7     function transferFrom(address _from, address _to, uint256 _value) returns (bool success);
8     function approve(address _spender, uint256 _value) returns (bool success);
9     function allowance(address _owner, address _spender) constant returns (uint256 remaining);
10     event Transfer(address indexed _from, address indexed _to, uint256 _value);
11     event Approval(address indexed _owner, address indexed _spender, uint256 _value);
12 }
13 
14 pragma solidity ^0.4.18;
15 
16 /**
17  * @title SafeMath
18  * @dev Math operations with safety checks that throw on error
19  */
20 library SafeMath {
21   function mul(uint256 a, uint256 b) internal pure returns (uint256) {
22     if (a == 0) {
23       return 0;
24     }
25     uint256 c = a * b;
26     assert(c / a == b);
27     return c;
28   }
29 
30   function div(uint256 a, uint256 b) internal pure returns (uint256) {
31     // assert(b > 0); // Solidity automatically throws when dividing by 0
32     uint256 c = a / b;
33     // assert(a == b * c + a % b); // There is no case in which this doesn't hold
34     return c;
35   }
36 
37   function sub(uint256 a, uint256 b) internal pure returns (uint256) {
38     assert(b <= a);
39     return a - b;
40   }
41 
42   function add(uint256 a, uint256 b) internal pure returns (uint256) {
43     uint256 c = a + b;
44     assert(c >= a);
45     return c;
46   }
47 }
48 
49 contract FuckTrumpCoin is IERC20 {
50     
51     using SafeMath for uint256;
52     
53     uint public constant _totalSupply = 73500000;
54     
55     string public constant symbol = "FTC";
56     string public constant name = "Fuck Trump Coin";
57     uint8 public constant decimals = 0;
58     
59     mapping(address => uint256) balances;
60     mapping(address => mapping(address => uint256)) allowed;
61     
62     function FuckTrumpCoin() {
63         balances[msg.sender] = _totalSupply;
64     }
65     
66     function totalSupply() constant returns (uint256 totalSupply) { 
67         return _totalSupply;
68     }
69     
70     function balanceOf(address _owner) constant  returns (uint256 balance) {
71         return balances[_owner];
72     }
73     
74     function transfer(address _to, uint256 _value) returns (bool success) {
75         require(
76             balances[msg.sender] >= _value
77             && _value > 0 
78             );
79             balances[msg.sender] = balances[msg.sender].sub(_value);
80             balances[_to] = balances[_to].add(_value);
81             Transfer(msg.sender, _to, _value);
82             return true;
83     }
84     
85     function transferFrom(address _from, address _to, uint256 _value) returns (bool success) {
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
96         }
97         
98         function approve(address _spender, uint256 _value) returns (bool success) {
99             allowed[msg.sender][_spender] = _value;
100             Approval(msg.sender, _spender, _value);
101             return true;
102         }
103         
104         function allowance(address _owner, address _spender) constant returns (uint256 remaining) {
105             return allowed[_owner][_spender];
106         }
107         
108         event Transfer(address indexed _from, address indexed _to, uint256 _value);
109         event Approval(address indexed _owner, address indexed _spender, uint256 _value);
110 }