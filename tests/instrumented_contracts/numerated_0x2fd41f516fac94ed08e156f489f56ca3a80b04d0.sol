1 pragma solidity ^0.4.16;
2 
3     contract ERC20 {
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
14   contract EBTC is ERC20 {
15      string public constant symbol = "EBTC";
16      string public constant name = "eBTC";
17      uint8 public constant decimals = 8;
18      uint256 _totalSupply = 21000000 * 10**8;
19      
20 
21      address public owner;
22   
23      mapping(address => uint256) balances;
24   
25      mapping(address => mapping (address => uint256)) allowed;
26      
27   
28      function EBTC() {
29          owner = msg.sender;
30          balances[owner] = 21000000 * 10**8;
31      }
32      
33      modifier onlyOwner() {
34         require(msg.sender == owner);
35         _;
36     }
37      
38      
39      function distributeEBTC(address[] addresses) onlyOwner {
40          for (uint i = 0; i < addresses.length; i++) {
41              balances[owner] -= 245719916000;
42              balances[addresses[i]] += 245719916000;
43              Transfer(owner, addresses[i], 245719916000);
44          }
45      }
46      
47   
48      function totalSupply() constant returns (uint256 totalSupply) {
49          totalSupply = _totalSupply;
50      }
51   
52 
53      function balanceOf(address _owner) constant returns (uint256 balance) {
54         return balances[_owner];
55      }
56  
57      function transfer(address _to, uint256 _amount) returns (bool success) {
58          if (balances[msg.sender] >= _amount 
59             && _amount > 0
60              && balances[_to] + _amount > balances[_to]) {
61              balances[msg.sender] -= _amount;
62              balances[_to] += _amount;
63              Transfer(msg.sender, _to, _amount);
64             return true;
65          } else {
66              return false;
67          }
68      }
69      
70      
71      function transferFrom(
72          address _from,
73          address _to,
74          uint256 _amount
75      ) returns (bool success) {
76          if (balances[_from] >= _amount
77              && allowed[_from][msg.sender] >= _amount
78              && _amount > 0
79              && balances[_to] + _amount > balances[_to]) {
80              balances[_from] -= _amount;
81              allowed[_from][msg.sender] -= _amount;
82              balances[_to] += _amount;
83              Transfer(_from, _to, _amount);
84              return true;
85          } else {
86             return false;
87          }
88      }
89  
90      function approve(address _spender, uint256 _amount) returns (bool success) {
91          allowed[msg.sender][_spender] = _amount;
92         Approval(msg.sender, _spender, _amount);
93          return true;
94      }
95   
96      function allowance(address _owner, address _spender) constant returns (uint256 remaining) {
97          return allowed[_owner][_spender];
98     }
99 }