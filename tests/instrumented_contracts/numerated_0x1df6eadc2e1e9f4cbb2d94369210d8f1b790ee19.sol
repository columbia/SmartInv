1 pragma solidity ^0.4.11;
2 
3 
4 /**
5  * @title SafeMath
6  * @dev Math operations with safety checks that throw on error
7  */
8 library SafeMath {
9   function mul(uint256 a, uint256 b) internal returns (uint256) {
10     if (a == 0) {
11       return 0;
12     }
13     uint256 c = a * b;
14     assert(c / a == b);
15     return c;
16   }
17 
18   function div(uint256 a, uint256 b) internal returns (uint256) {
19     // assert(b > 0); // Solidity automatically throws when dividing by 0
20     uint256 c = a / b;
21     // assert(a == b * c + a % b); // There is no case in which this doesn't hold
22     return c;
23   }
24 
25   function sub(uint256 a, uint256 b) internal returns (uint256) {
26     assert(b <= a);
27     return a - b;
28   }
29 
30   function add(uint256 a, uint256 b) internal returns (uint256) {
31     uint256 c = a + b;
32     assert(c >= a);
33     return c;
34   }
35 }
36 
37 contract PinnacleToken {
38     
39     uint private constant _totalSupply = 100000000000000000000000000;
40  
41     using SafeMath for uint256;
42  
43     string public constant symbol = "PINN";
44     string public constant name = "Pinnacle Token";
45     uint8 public constant decimals = 18;
46     
47     mapping(address => uint256) balances;
48     mapping(address => mapping(address => uint256)) allowed;
49     
50     function PinnacleToken() {
51         balances[msg.sender] = _totalSupply;
52     }
53  
54     function totalSupply() constant returns (uint256 totalSupply) {
55         return _totalSupply;
56     }
57  
58     function balanceOf(address _owner) constant returns (uint256 balance) {
59         return balances[_owner];
60     }
61     
62     function transfer(address _to, uint256 _value) returns (bool success) {
63         require(
64             balances[msg.sender] >= _value
65             && _value > 0 
66             );
67             balances[msg.sender] -= _value;
68             balances[_to] += _value;
69             Transfer(msg.sender, _to, _value);
70             return true;
71     }
72     
73     function transferFrom(address _from, address _to, uint _value) returns (bool success) {
74         require(
75             allowed[_from][msg.sender] >= _value
76             && balances[_from] >= _value
77             && _value > 0 
78         );
79         balances[_from] -= _value;
80         balances[_to] += _value;
81         allowed[_from][msg.sender] -= _value;
82         Transfer(_from, _to, _value);
83         return true;
84     }
85     
86     function approve(address _spender, uint256 _value) returns (bool success) {
87         allowed[msg.sender][_spender] = _value;
88         Approval(msg.sender, _spender, _value);
89         return true;
90     }
91     
92     function allowance(address _owner, address _spender) constant returns (uint256 remaining) {
93         return allowed[_owner][_spender];
94     } 
95     
96     
97     
98     event Transfer(address indexed_from, address indexed _to, uint256 _value);
99     event Approval(address indexed_owner,address indexed_spender, uint256 _value);
100     
101 }