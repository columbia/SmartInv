1 pragma solidity ^ 0.4.19;
2 
3 interface IERC20 {
4     function totalSupply() constant returns(uint256 totalSupply);
5     function balanceOf(address _owner) constant returns(uint256 balance);
6     function transfer(address _to, uint256 _value) returns(bool success);
7     function transferFrom(address _from, address _to, uint256 _value) returns(bool success);
8     function approve(address _spender, uint256 _value) returns(bool success);
9     function allowance(address _owner, address _spender) constant returns(uint256 remaining);
10     event Transfer(address indexed _from, address indexed _to, uint256 _value);
11     event Approval(address indexed _owner, address indexed _spender, uint256 _value);
12 }
13 
14 library SafeMath {
15     function mul(uint256 a, uint256 b) internal pure returns(uint256) {
16         if (a == 0) {
17             return 0;
18         }
19         uint256 c = a * b;
20         assert(c / a == b);
21         return c;
22     }
23 
24     function div(uint256 a, uint256 b) internal pure returns(uint256) {
25         uint256 c = a / b;
26         return c;
27     }
28 
29     function sub(uint256 a, uint256 b) internal pure returns(uint256) {
30         assert(b <= a);
31         return a - b;
32     }
33 
34     function add(uint256 a, uint256 b) internal pure returns(uint256) {
35         uint256 c = a + b;
36         assert(c >= a);
37         return c;
38     }
39 }
40 
41 contract KeenFutureToken is IERC20 {
42 
43     using SafeMath
44     for uint256;
45 
46     uint public constant _totalSupply = 10500000;
47 
48     string public constant symbol = "KFT";
49     string public constant name = "Keen Future Token";
50     uint8 public constant decimals = 0;
51 
52     mapping(address => uint256) balances;
53     mapping(address => mapping(address => uint256)) allowed;
54 
55     function KeenFutureToken() {
56         balances[msg.sender] = _totalSupply;
57     }
58 
59     function totalSupply() constant returns(uint256 totalSupply) {
60         return _totalSupply;
61     }
62 
63     function balanceOf(address _owner) constant returns(uint256 balance) {
64         return balances[_owner];
65     }
66 
67     function transfer(address _to, uint256 _value) returns(bool success) {
68         require(
69             balances[msg.sender] >= _value &&
70             _value > 0
71         );
72         balances[msg.sender] = balances[msg.sender].sub(_value);
73         balances[_to] = balances[_to].add(_value);
74         Transfer(msg.sender, _to, _value);
75         return true;
76 
77     }
78 
79     function transferFrom(address _from, address _to, uint256 _value) returns(bool success) {
80         require(
81             allowed[_from][msg.sender] >= _value &&
82             balances[_from] >= _value &&
83             _value > 0
84         );
85         balances[_from] = balances[_from].sub(_value);
86         balances[_to] = balances[_to].add(_value);
87         allowed[_from][msg.sender] = allowed[_from][msg.sender].sub(_value);
88         Transfer(_from, _to, _value);
89         return true;
90     }
91 
92     function approve(address _spender, uint256 _value) returns(bool success) {
93         allowed[msg.sender][_spender] = _value;
94         Approval(msg.sender, _spender, _value);
95         return true;
96     }
97 
98     function allowance(address _owner, address _spender) constant returns(uint256 remaining) {
99         return allowed[_owner][_spender];
100     }
101 
102 }