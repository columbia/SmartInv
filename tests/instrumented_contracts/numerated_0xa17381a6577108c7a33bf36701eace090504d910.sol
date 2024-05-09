1 pragma solidity ^0.4.8;
2 
3 contract ERC20 {
4     uint256 public totalSupply;
5     function balanceOf(address _owner) constant returns (uint256 balance);
6     function transfer(address _to, uint256 _value) returns (bool success);
7     function transferFrom(address _from, address _to, uint256 _value) returns (bool success);
8     function approve(address _spender, uint256 _value) returns (bool success);
9     function allowance(address _owner, address _spender) constant returns (uint256 remaining);
10     
11     event Transfer(address indexed _from, address indexed _to, uint256 _value);
12     event Approval(address indexed _owner, address indexed _spender, uint256 _value);
13 }
14 
15 library SafeMath {
16   function mul(uint a, uint b) internal returns (uint) {
17     uint c = a * b;
18     assert(a == 0 || c / a == b);
19     return c;
20   }
21 
22   function div(uint a, uint b) internal returns (uint) {
23     uint c = a / b;
24     return c;
25   }
26 
27   function sub(uint a, uint b) internal returns (uint) {
28     assert(b <= a);
29     return a - b;
30   }
31 
32   function add(uint a, uint b) internal returns (uint) {
33     uint c = a + b;
34     assert(c >= a);
35     return c;
36   }
37 
38   function max64(uint64 a, uint64 b) internal constant returns (uint64) {
39     return a >= b ? a : b;
40   }
41 
42   function min64(uint64 a, uint64 b) internal constant returns (uint64) {
43     return a < b ? a : b;
44   }
45 
46   function max256(uint256 a, uint256 b) internal constant returns (uint256) {
47     return a >= b ? a : b;
48   }
49 
50   function min256(uint256 a, uint256 b) internal constant returns (uint256) {
51     return a < b ? a : b;
52   }
53 
54   function assert(bool assertion) internal {
55     if (!assertion) {
56       throw;
57     }
58   }
59 }
60 
61 contract Token is ERC20 {
62 
63     using SafeMath for uint;
64     mapping (address => uint256) balances;
65     mapping (address => mapping (address => uint256)) allowed;
66     
67     function balanceOf(address _owner) constant returns (uint256 balance) {
68         return balances[_owner];
69     }
70     
71     function transfer(address _to, uint256 _value) returns (bool success) {
72         if (balances[msg.sender] >= _value && _value > 0) {
73             balances[msg.sender] = balances[msg.sender].sub(_value);
74             balances[_to] = balances[_to].add(_value);
75             Transfer(msg.sender, _to, _value);
76             return true;
77         } else { return false; }
78     }
79 
80     function transferFrom(address _from, address _to, uint256 _value) returns (bool success) {
81         if (balances[_from] >= _value && allowed[_from][msg.sender] >= _value && _value > 0) {
82             var _allowance = allowed[_from][msg.sender];
83             balances[_to] = balances[_to].add(_value);
84             balances[_from] = balances[_from].sub(_value);
85             allowed[_from][msg.sender] = _allowance.sub(_value);
86             Transfer(_from, _to, _value);
87             return true;
88         } else { return false; }
89     }
90 
91     function approve(address _spender, uint256 _value) returns (bool success) {
92         if(_value >= 0) {
93           allowed[msg.sender][_spender] = _value;
94           Approval(msg.sender, _spender, _value);
95           return true;
96         } else { return false; }
97     }
98     
99     function allowance(address _owner, address _spender) constant returns (uint256 remaining) {
100       return allowed[_owner][_spender];
101     }
102 }
103 
104 contract OtcgateToken is Token {
105     
106     string public version = 'v1.0';
107     string public name;
108     uint8 public decimals;
109     string public symbol;
110     address public master;
111     
112     function OtcgateToken(uint256 _initialAmount, uint8 _decimalUnits, string _tokenName, string _tokenSymbol, address _master) {
113         decimals = _decimalUnits;
114         master = _master;
115         totalSupply = _initialAmount * 10**uint(decimals);
116         balances[master] = totalSupply;
117         name = _tokenName;
118         symbol = _tokenSymbol;
119     }
120     
121 }