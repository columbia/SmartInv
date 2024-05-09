1 pragma solidity ^0.4.16;
2 
3 library SafeMath {
4   function mul(uint256 a, uint256 b) internal constant returns (uint256) {
5     uint256 c = a * b;
6     assert(a == 0 || c / a == b);
7     return c;
8   }
9 
10   function div(uint256 a, uint256 b) internal constant returns (uint256) {
11     // assert(b > 0); // Solidity automatically throws when dividing by 0
12     uint256 c = a / b;
13     // assert(a == b * c + a % b); // There is no case in which this doesn't hold
14     return c;
15   }
16 
17   function sub(uint256 a, uint256 b) internal constant returns (uint256) {
18     assert(b <= a);
19     return a - b;
20   }
21 
22   function add(uint256 a, uint256 b) internal constant returns (uint256) {
23     uint256 c = a + b;
24     assert(c >= a);
25     return c;
26   }
27   
28   function max64(uint64 a, uint64 b) internal constant returns (uint64) {
29     return a >= b ? a : b;
30   }
31 
32   function min64(uint64 a, uint64 b) internal constant returns (uint64) {
33     return a < b ? a : b;
34   }
35 
36   function max256(uint256 a, uint256 b) internal constant returns (uint256) {
37     return a >= b ? a : b;
38   }
39 
40   function min256(uint256 a, uint256 b) internal constant returns (uint256) {
41     return a < b ? a : b;
42   }
43 
44 }
45 
46  contract ERC20Interface {
47      function balanceOf(address _owner) constant returns (uint256 balance);
48      function transfer(address _to, uint256 _value) returns (bool success);
49      function transferFrom(address _from, address _to, uint256 _value) returns (bool success);
50      function approve(address _spender, uint256 _value) returns (bool success);
51      function allowance(address _owner, address _spender) constant returns (uint256 remaining);
52         
53      event Transfer(address indexed _from, address indexed _to, uint256 _value);
54      event Approval(address indexed _owner, address indexed _spender, uint256 _value);
55     }
56 contract Deluxo is ERC20Interface {
57      
58      using SafeMath for uint256;
59      
60      string public constant symbol = "DLUX";
61      string public constant name = "Deluxo";
62      uint8 public constant decimals = 18;
63      uint256 public _totalSupply = 4700000000000000000000000;
64      
65      address public owner;
66  
67     mapping(address => uint256) balances;
68     
69     mapping(address => mapping (address => uint256)) allowed;
70     
71     modifier onlyOwner() {
72          if (msg.sender != owner) {
73              revert();
74          }
75          _;
76      }
77      
78     function Deluxo() {
79         owner = msg.sender;
80         balances[owner] = _totalSupply;
81     } 
82     
83     function totalSupply() constant returns (uint256) {        
84 		return _totalSupply;
85     }
86     
87     function balanceOf(address _owner) constant returns (uint256 balance) {
88         return balances[_owner];
89     }
90     
91     function transfer(address _to, uint256 _amount) returns (bool success) {
92         if (balances[msg.sender] >= _amount 
93              && _amount > 0
94              && balances[_to] + _amount > balances[_to]) {
95              balances[msg.sender] = balances[msg.sender].sub(_amount);
96              balances[_to] = balances[_to].add(_amount);
97              Transfer(msg.sender, _to, _amount);
98              return true;
99          } else {
100              return false;
101          }
102     }
103     
104     function transferFrom(
105             address _from,
106             address _to,
107             uint256 _amount
108         )   returns (bool success) {
109             if (balances[_from] >= _amount
110              && allowed[_from][msg.sender] >= _amount
111              && _amount > 0
112              && balances[_to] + _amount > balances[_to]) {
113              balances[_from] = balances[_from].sub(_amount);
114              allowed[_from][msg.sender] = allowed[_from][msg.sender].sub(_amount);
115              balances[_to] = balances[_to].add(_amount);
116              Transfer(_from, _to, _amount);
117              return true;
118          }  else {
119              return false;
120          }
121     }
122     
123     function approve(address _spender, uint256 _amount) returns (bool success) {
124          allowed[msg.sender][_spender] = _amount;
125          Approval(msg.sender, _spender, _amount);
126          return true;
127     }
128     
129     function allowance(address _owner, address _spender) constant returns (uint256 remaining) {
130          return allowed[_owner][_spender];
131     }
132     
133     event Transfer(address indexed _from, address indexed _to, uint256 _value);
134     event Approval(address indexed _owner, address indexed _spender, uint256 _value);
135 }