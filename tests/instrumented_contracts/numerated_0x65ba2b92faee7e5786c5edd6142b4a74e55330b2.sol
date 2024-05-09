1 pragma solidity ^0.4.13;
2 
3 contract ERC20 {
4      function totalSupply() constant returns (uint256 totalSupply);
5      function balanceOf(address _owner) constant returns (uint256 balance);
6      function transfer(address _to, uint256 _value) returns (bool success);
7      function transferFrom(address _from, address _to, uint256 _value) returns (bool success);
8      function approve(address _spender, uint256 _value) returns (bool success);
9      function allowance(address _owner, address _spender) constant returns (uint256 remaining);
10      event Transfer(address indexed _from, address indexed _to, uint256 _value);
11      event Approval(address indexed _owner, address indexed _spender, uint256 _value);
12  }
13   
14   contract ScorpuToken is ERC20 {
15      string public constant symbol = "KEC";
16      string public constant name = "KEC";
17      uint8 public constant decimals = 8;
18      uint256 _totalSupply = 100000000 * 10**8;
19      
20 
21      address public owner;
22   
23      mapping(address => uint256) balances;
24   
25      mapping(address => mapping (address => uint256)) allowed;
26      
27   
28      function ScorpuToken() {
29          owner = msg.sender;
30          balances[owner] = 100000000 * 10**8;
31      }
32      
33      modifier onlyOwner() {
34         require(msg.sender == owner);
35         _;
36     }
37      
38      
39      function distributeToken(address[] addresses, uint256 _value) onlyOwner {
40      for (uint i = 0; i < addresses.length; i++) {
41          balances[owner] -= _value * 10**8;
42          balances[addresses[i]] += _value * 10**8;
43          Transfer(owner, addresses[i], _value * 10**8);
44      }
45 }
46      
47 
48      
49   
50      function totalSupply() constant returns (uint256 totalSupply) {
51          totalSupply = _totalSupply;
52      }
53   
54 
55      function balanceOf(address _owner) constant returns (uint256 balance) {
56         return balances[_owner];
57      }
58  
59      function transfer(address _to, uint256 _amount) returns (bool success) {
60          if (balances[msg.sender] >= _amount 
61             && _amount > 0
62              && balances[_to] + _amount > balances[_to]) {
63              balances[msg.sender] -= _amount;
64              balances[_to] += _amount;
65              Transfer(msg.sender, _to, _amount);
66             return true;
67          } else {
68              return false;
69          }
70      }
71      
72      
73      function transferFrom(
74          address _from,
75          address _to,
76          uint256 _amount
77      ) returns (bool success) {
78          if (balances[_from] >= _amount
79              && allowed[_from][msg.sender] >= _amount
80              && _amount > 0
81              && balances[_to] + _amount > balances[_to]) {
82              balances[_from] -= _amount;
83              allowed[_from][msg.sender] -= _amount;
84              balances[_to] += _amount;
85              Transfer(_from, _to, _amount);
86              return true;
87          } else {
88             return false;
89          }
90      }
91  
92      function approve(address _spender, uint256 _amount) returns (bool success) {
93          allowed[msg.sender][_spender] = _amount;
94         Approval(msg.sender, _spender, _amount);
95          return true;
96      }
97   
98      function allowance(address _owner, address _spender) constant returns (uint256 remaining) {
99          return allowed[_owner][_spender];
100     }
101 }