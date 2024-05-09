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
56 
57  contract GenesisToken is ERC20Interface {
58      
59      using SafeMath for uint256;
60      
61      string public constant symbol = "GEN";
62      string public constant name = "Genesis";
63      uint8 public constant decimals = 18;
64      uint256 _totalSupply = 16000000000000000000000000;
65      
66      address public owner;
67  
68     mapping(address => uint256) balances;
69     
70     mapping(address => mapping (address => uint256)) allowed;
71     
72     modifier onlyOwner() {
73          if (msg.sender != owner) {
74              revert();
75          }
76          _;
77      }
78      
79     function GenesisToken() {
80         owner = msg.sender;
81         balances[owner] = _totalSupply;
82     } 
83     
84     function balanceOf(address _owner) constant returns (uint256 balance) {
85         return balances[_owner];
86     }
87     
88     function transfer(address _to, uint256 _amount) returns (bool success) {
89         if (balances[msg.sender] >= _amount 
90              && _amount > 0
91              && balances[_to] + _amount > balances[_to]) {
92              balances[msg.sender] = balances[msg.sender].sub(_amount);
93              balances[_to] = balances[_to].add(_amount);
94              Transfer(msg.sender, _to, _amount);
95              return true;
96          } else {
97              return false;
98          }
99     }
100     
101     function transferFrom(
102             address _from,
103             address _to,
104             uint256 _amount
105         )   returns (bool success) {
106             if (balances[_from] >= _amount
107              && allowed[_from][msg.sender] >= _amount
108              && _amount > 0
109              && balances[_to] + _amount > balances[_to]) {
110              balances[_from] = balances[_from].sub(_amount);
111              allowed[_from][msg.sender] = allowed[_from][msg.sender].sub(_amount);
112              balances[_to] = balances[_to].add(_amount);
113              Transfer(_from, _to, _amount);
114              return true;
115          }  else {
116              return false;
117          }
118     }
119     
120     function approve(address _spender, uint256 _amount) returns (bool success) {
121          allowed[msg.sender][_spender] = _amount;
122          Approval(msg.sender, _spender, _amount);
123          return true;
124     }
125     
126     function allowance(address _owner, address _spender) constant returns (uint256 remaining) {
127          return allowed[_owner][_spender];
128     }
129 	
130 	function airdrop(uint256 amount, address[] addresses) onlyOwner {
131     for (uint i = 0; i < addresses.length; i++) {
132       balances[owner].sub(amount);
133       balances[addresses[i]].add(amount);
134       Transfer(owner, addresses[i], amount);
135     }
136   }
137     
138     event Transfer(address indexed _from, address indexed _to, uint256 _value);
139     event Approval(address indexed _owner, address indexed _spender, uint256 _value);
140     
141 }