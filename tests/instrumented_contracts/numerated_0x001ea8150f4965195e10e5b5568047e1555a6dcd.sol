1 pragma solidity ^0.4.11;
2 
3 interface IERC20{
4    function totalSupply() constant returns (uint256 totalSupply);
5    function balanceOf(address _owner) constant returns (uint256 balance);
6    function transfer(address _to, uint256 _value) returns (bool success);
7    function transferFrom(address _from, address _to, uint256 _value) returns (bool success);
8    function approve(address _spender, uint256 _value) returns (bool success);
9    function allowance(address _owner, address _spender) constant returns (uint256 remaining);
10    event Transfer(address indexed _from, address indexed _to, uint256 _value);
11    event Approval(address indexed _owner, address indexed _spender, uint256 _value);
12 }
13 
14 /**
15  * @title SafeMath
16  * @dev Math operations with safety checks that throw on error
17  */
18 library SafeMath {
19   function mul(uint256 a, uint256 b) internal constant returns (uint256) {
20     uint256 c = a * b;
21     assert(a == 0 || c / a == b);
22     return c;
23   }
24 
25   function div(uint256 a, uint256 b) internal constant returns (uint256) {
26     // assert(b > 0); // Solidity automatically throws when dividing by 0
27     uint256 c = a / b;
28     // assert(a == b * c + a % b); // There is no case in which this doesn't hold
29     return c;
30   }
31 
32   function sub(uint256 a, uint256 b) internal constant returns (uint256) {
33     assert(b <= a);
34     return a - b;
35   }
36 
37   function add(uint256 a, uint256 b) internal constant returns (uint256) {
38     uint256 c = a + b;
39     assert(c >= a);
40     return c;
41   }
42 }
43 
44 
45 contract SenseProtocol is IERC20 {
46 
47 using SafeMath for uint256;
48 
49 uint public _totalSupply = 0;
50 
51 string public constant symbol = "SENSE";
52 string public constant name = "Sense";
53 uint8 public constant decimals = 18;
54 
55 // 1 ETH = 1000 Simple
56 uint256 public constant RATE = 500;
57 
58 // Sets Maximum Tokens to be Created
59 uint256 public constant maxTokens = 40000000000000000000000000;
60 
61 address public owner;
62 
63 mapping (address => uint256) public balances;
64 mapping(address => mapping(address => uint256)) allowed;
65 
66 function () payable{
67     createTokens();
68 }
69 
70 function SenseProtocol(){
71     owner = msg.sender;
72 }
73 
74 function createTokens() payable{
75     require(msg.value > 0);
76     uint256 tokens = msg.value.mul(RATE);
77     require(_totalSupply.add(tokens) <= maxTokens);
78     balances[msg.sender] = balances[msg.sender].add(tokens);
79     _totalSupply = _totalSupply.add(tokens);
80     owner.transfer(msg.value);
81 }
82 
83 function totalSupply() public constant returns (uint256 totalSupply) {
84     return _totalSupply;
85 }
86 
87 function balanceOf(address _owner) public constant returns (uint256 balance) {
88     return balances[_owner];
89 }
90 
91 function transfer(address _to, uint256 _value) public returns (bool success) {
92     require(balances[msg.sender] >= _value && _value > 0);
93     balances[msg.sender] = balances[msg.sender].sub(_value);
94     balances[_to] = balances[_to].add(_value);
95     Transfer(msg.sender, _to, _value);
96     return true;
97 }
98 
99 function transferFrom(address _from, address _to, uint256 _value) public returns (bool success) {
100     require(allowed[_from][msg.sender] >= _value && balances[_from] >= _value && _value > 0);
101     balances[_from] = balances[msg.sender].sub(_value);
102     balances[_to] = balances[_to].add(_value);
103     allowed[_from][msg.sender] = allowed[_from][msg.sender].sub(_value);
104     Transfer(_from, _to, _value);
105     return true;
106 }
107 
108 function approve(address _spender, uint256 _value) public returns (bool success) {
109     allowed[msg.sender][_spender] = _value;
110     Approval(msg.sender, _spender, _value);
111     return true;
112 }
113 
114 function allowance(address _owner, address _spender) public constant returns (uint256 remaining) {
115     return allowed[_owner][_spender];
116 }
117 
118 event Transfer(address indexed _from, address indexed _to, uint256 _value);
119 
120 event Approval(address indexed _owner, address indexed _spender, uint256 _value);
121 
122 }