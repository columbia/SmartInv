1 pragma solidity ^0.4.11;
2 
3 /**
4  * @title SafeMath
5  * @dev Math operations with safety checks that throw on error
6  */
7 library SafeMath {
8   function mul(uint256 a, uint256 b) internal returns (uint256) {
9     if (a == 0) {
10       return 0;
11     }
12     uint256 c = a * b;
13     assert(c / a == b);
14     return c;
15   }
16 
17   function div(uint256 a, uint256 b) internal returns (uint256) {
18     // assert(b > 0); // Solidity automatically throws when dividing by 0
19     uint256 c = a / b;
20     // assert(a == b * c + a % b); // There is no case in which this doesn't hold
21     return c;
22   }
23 
24   function sub(uint256 a, uint256 b) internal returns (uint256) {
25     assert(b <= a);
26     return a - b;
27   }
28 
29   function add(uint256 a, uint256 b) internal returns (uint256) {
30     uint256 c = a + b;
31     assert(c >= a);
32     return c;
33   }
34 }
35 
36 contract IFcoin {
37     
38     uint private constant _totalSupply = 2500000000000000000000000;
39  
40     using SafeMath for uint256;
41  
42     string public constant symbol = "IFC";
43     string public constant name = "IFcoin";
44     uint8 public constant decimals = 18;
45     
46     mapping(address => uint256) balances;
47     mapping(address => mapping(address => uint256)) allowed;
48     
49     function IFcoin() {
50         balances[msg.sender] = _totalSupply;
51     }
52  
53     function totalSupply() constant returns (uint256 totalSupply) {
54         return _totalSupply;
55     }
56  
57     function balanceOf(address _owner) constant returns (uint256 balance) {
58         return balances[_owner];
59     }
60     
61     function transfer(address _to, uint256 _value) returns (bool success) {
62         require(
63             balances[msg.sender] >= _value
64             && _value > 0 
65             );
66             balances[msg.sender] -= _value;
67             balances[_to] += _value;
68             Transfer(msg.sender, _to, _value);
69             return true;
70     }
71     
72     function transferFrom(address _from, address _to, uint _value) returns (bool success) {
73         require(
74             allowed[_from][msg.sender] >= _value
75             && balances[_from] >= _value
76             && _value > 0 
77         );
78         balances[_from] -= _value;
79         balances[_to] += _value;
80         allowed[_from][msg.sender] -= _value;
81         Transfer(_from, _to, _value);
82         return true;
83     }
84     
85     function approve(address _spender, uint256 _value) returns (bool success) {
86         allowed[msg.sender][_spender] = _value;
87         Approval(msg.sender, _spender, _value);
88         return true;
89     }
90     
91     function allowance(address _owner, address _spender) constant returns (uint256 remaining) {
92         return allowed[_owner][_spender];
93     } 
94     
95     
96     
97     event Transfer(address indexed_from, address indexed _to, uint256 _value);
98     event Approval(address indexed_owner,address indexed_spender, uint256 _value);
99     
100 }