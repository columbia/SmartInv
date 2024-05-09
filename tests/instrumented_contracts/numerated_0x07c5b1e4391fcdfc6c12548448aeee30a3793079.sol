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
14 /**
15  * Math operations with safety checks
16  */
17 library SafeMath {
18   function mul(uint256 a, uint256 b) internal returns (uint256) {
19     uint256 c = a * b;
20     assert(a == 0 || c / a == b);
21     return c;
22   }
23 
24   function div(uint256 a, uint256 b) internal returns (uint256) {
25     // assert(b > 0); // Solidity automatically throws when dividing by 0
26     uint256 c = a / b;
27     // assert(a == b * c + a % b); // There is no case in which this doesn't hold
28     return c;
29   }
30 
31   function sub(uint256 a, uint256 b) internal constant returns (uint256) {
32     assert(b <= a);
33     return a - b;
34   }
35 
36   function add(uint256 a, uint256 b) internal returns (uint256) {
37     uint256 c = a + b;
38     assert(c >= a);
39     return c;
40   }
41   
42   function max64(uint64 a, uint64 b) internal constant returns (uint64) {
43       return a >= b ? a : b;
44   }
45   
46   function min64(uint64 a, uint64 b) internal constant returns (uint256) {
47       return a < b ? a : b;
48   }
49   
50   function max256(uint256 a, uint256 b) internal constant returns (uint256) {
51       return a >= b ? a : b;
52   }
53   
54   function min256(uint256 a, uint256 b)  internal constant returns (uint256) {
55       return a < b ? a : b;
56   }
57   
58 }
59 
60 contract YOLOCOIN is IERC20 {
61     
62     uint public constant _totalSupply = 28888888888;
63 
64     string public constant symbol = "YOLO";
65     string public constant name = "YOLOCOIN";
66     uint8 public constant decimals = 0;
67     
68     mapping(address => uint256) balances;
69     mapping(address => mapping(address => uint256)) allowed;
70     
71     function YOLOCOIN() {
72         balances[msg.sender] = _totalSupply;
73     }
74     
75     function totalSupply() constant returns (uint256 _totalSupply) {
76         return _totalSupply;
77     }
78     
79     function balanceOf(address _owner) constant returns (uint256 balance) {
80         return balances[_owner];
81     }
82     
83     function transfer(address _to, uint256 _value) returns (bool success) {
84         require(
85             balances[msg.sender] >= _value
86             && _value > 0
87         );
88         balances[msg.sender] -= _value;
89         balances[_to] += _value;
90         Transfer(msg.sender, _to, _value);
91         return true;
92     }
93     
94     function transferFrom(address _from, address _to, uint256 _value) returns (bool success) {
95         require(
96             allowed[_from][msg.sender] >= _value
97             && balances[_from] >= _value
98             && _value > 0
99         );
100         balances[_from] -= _value;
101         balances[_to] += _value;
102         allowed[_from][msg.sender] -= _value;
103         Transfer(_from, _to, _value);
104         return true;
105     }
106     
107     function approve(address _spender, uint256 _value) returns (bool success) {
108         allowed[msg.sender][_spender] = _value;
109         Approval(msg.sender, _spender, _value);
110         return true;
111     }
112     
113     function allowance(address _owner, address _spender) constant returns (uint256 remaining) {
114         return allowed[_owner][_spender];
115     }
116 
117     event Transfer(address indexed _from, address indexed _to, uint256 _value);
118     event approval(address indexed _owner, address indexed _spender, uint256 _value);
119 }