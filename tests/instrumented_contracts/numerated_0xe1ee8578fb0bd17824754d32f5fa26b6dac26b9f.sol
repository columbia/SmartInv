1 pragma solidity ^0.4.16;
2 library SafeMath {
3   function mul(uint256 a, uint256 b) internal pure returns (uint256) {
4     if (a == 0) {
5       return 0;
6     }
7     uint256 c = a * b;
8     assert(c / a == b);
9     return c;
10   }
11 
12   function div(uint256 a, uint256 b) internal pure returns (uint256) {
13     uint256 c = a / b;
14     return c;
15   }
16 
17   function sub(uint256 a, uint256 b) internal pure returns (uint256) {
18     assert(b <= a);
19     return a - b;
20   }
21 
22   function add(uint256 a, uint256 b) internal pure returns (uint256) {
23     uint256 c = a + b;
24     assert(c >= a);
25     return c;
26   }
27 }
28 
29 
30  contract ERC20Interface {
31      function totalSupply() constant returns (uint256 totalSupply);
32      function balanceOf(address _owner) constant returns (uint256 balance);
33      function transfer(address _to, uint256 _value) returns (bool success);
34      function transferFrom(address _from, address _to, uint256 _value) returns (bool success);
35      function approve(address _spender, uint256 _value) returns (bool success);
36      function allowance(address _owner, address _spender) constant returns (uint256 remaining);
37      event Transfer(address indexed _from, address indexed _to, uint256 _value);
38      event Approval(address indexed _owner, address indexed _spender, uint256 _value);
39  }
40   
41  contract MyToken is ERC20Interface {
42       string public constant symbol = "FOD"; 
43       string public constant name = "fodcreate";   
44       uint8 public constant decimals = 18;
45       uint256 _totalSupply = 2000000000000000000000000000; 
46      
47       address public owner;
48   
49       mapping(address => uint256) balances;
50   
51       mapping(address => mapping (address => uint256)) allowed;
52   
53       function MyToken() {
54           owner = msg.sender;
55           balances[owner] = _totalSupply;
56       }
57   
58       function totalSupply() constant returns (uint256 totalSupply) {
59          totalSupply = _totalSupply;
60       }
61   
62       // What is the balance of a particular account?
63       function balanceOf(address _owner) constant returns (uint256 balance) {
64          return balances[_owner];
65       }
66    
67       // Transfer the balance from owner's account to another account
68       function transfer(address _to, uint256 _amount) returns (bool success) {
69          if (balances[msg.sender] >= _amount) {
70             balances[msg.sender] = SafeMath.sub(balances[msg.sender],_amount);
71             balances[_to] = SafeMath.add(balances[_to],_amount);
72             
73             return true;
74          }
75          
76          return false;
77       }
78       
79       function transferFrom(
80           address _from,
81           address _to,
82          uint256 _amount
83     ) returns (bool success) {
84          require(_to != address(0));
85     
86          if (balances[_from] >= _amount) {
87             balances[_from] = SafeMath.sub(balances[_from],_amount);
88             balances[_to] = SafeMath.add(balances[_to],_amount);
89             
90             return true;
91          }
92          
93          return false;
94      }
95   
96      function approve(address _spender, uint256 _amount) returns (bool success) {
97          allowed[msg.sender][_spender] = _amount;
98          Approval(msg.sender, _spender, _amount);
99          return true;
100      }
101   
102      function allowance(address _owner, address _spender) constant returns (uint256 remaining) {
103          return allowed[_owner][_spender];
104      }
105 }