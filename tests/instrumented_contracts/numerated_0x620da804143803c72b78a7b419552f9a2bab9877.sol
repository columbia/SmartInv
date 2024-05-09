1 pragma solidity ^0.4.13;
2 
3 library SafeMath {
4     function mul(uint256 a, uint256 b) internal constant returns(uint256) {
5         uint256 c = a * b;
6         assert(a == 0 || c / a == b);
7         return c;
8     }
9 
10     function div(uint256 a, uint256 b) internal constant returns(uint256) {
11         uint256 c = a / b;
12         return c;
13     }
14 
15     function sub(uint256 a, uint256 b) internal constant returns(uint256) {
16         assert(b <= a);
17         return a - b;
18     }
19 
20     function add(uint256 a, uint256 b) internal constant returns(uint256) {
21         uint256 c = a + b;
22         assert(c >= a);
23         return c;
24     }
25 }
26 contract Forus{
27      string public constant symbol = "FRS";
28      string public constant name = "Forus";
29      uint8 public constant decimals = 12;
30      uint256 _totalSupply = 220000000000000000000;
31      event Transfer(address indexed from, address indexed to, uint256 value);
32      event Approval(address indexed _owner, address indexed spender, uint256 value);
33    
34        address public owner;
35   
36      mapping(address => uint256) balances;
37   
38      mapping(address => mapping (address => uint256)) allowed;
39      
40   
41      function Forus() {
42          owner = msg.sender;
43          balances[owner] = 220000000000000000000;
44      }
45      
46      modifier onlyOwner() {
47         require(msg.sender == owner);
48         _;
49     }
50      
51      function totalSupply() constant returns (uint256 totalSupply) {
52          totalSupply = _totalSupply;
53      }
54   
55 
56      function balanceOf(address _owner) constant returns (uint256 balance) {
57         return balances[_owner];
58      }
59  
60      function transfer(address _to, uint256 _amount) returns (bool success) {
61          if (balances[msg.sender] >= _amount 
62             && _amount > 0
63              && balances[_to] + _amount > balances[_to]) {
64              balances[msg.sender] -= _amount;
65              balances[_to] += _amount;
66              Transfer(msg.sender, _to, _amount);
67             return true;
68          } else {
69              return false;
70          }
71      }
72      
73      
74      function transferFrom(
75          address _from,
76          address _to,
77          uint256 _amount
78      ) returns (bool success) {
79          if (balances[_from] >= _amount
80              && allowed[_from][msg.sender] >= _amount
81              && _amount > 0
82              && balances[_to] + _amount > balances[_to]) {
83              balances[_from] -= _amount;
84              allowed[_from][msg.sender] -= _amount;
85              balances[_to] += _amount;
86              Transfer(_from, _to, _amount);
87              return true;
88          } else {
89             return false;
90          }
91      }
92  
93      function approve(address _spender, uint256 _amount) returns (bool success) {
94          allowed[msg.sender][_spender] = _amount;
95         Approval(msg.sender, _spender, _amount);
96          return true;
97      }
98   
99      function allowance(address _owner, address _spender) constant returns (uint256 remaining) {
100          return allowed[_owner][_spender];
101     }
102 }