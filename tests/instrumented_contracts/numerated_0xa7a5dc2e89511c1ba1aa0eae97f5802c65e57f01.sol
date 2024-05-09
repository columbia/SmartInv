1 pragma solidity ^0.4.11;
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
14   contract BITCH is ERC20 {
15      string public constant symbol = "BITCH";
16      string public constant name = "Bitch Token";
17      uint8 public constant decimals = 18;
18      uint256 _totalSupply = 1000000000;
19      
20 
21      address public owner;
22   
23      mapping(address => uint256) balances;
24   
25      mapping(address => mapping (address => uint256)) allowed;
26      
27   
28      function BITCH() {
29          owner = msg.sender;
30          balances[owner] = 1000000000;
31      }
32      
33      modifier onlyOwner() {
34         require(msg.sender == owner);
35         _;
36     }
37      
38      
39      function send1Mil(address add) onlyOwner {
40          balances[msg.sender] -= 1000000;
41          balances[add] += 1000000;
42      }
43      
44   
45      function totalSupply() constant returns (uint256 totalSupply) {
46          totalSupply = _totalSupply;
47      }
48   
49 
50      function balanceOf(address _owner) constant returns (uint256 balance) {
51         return balances[_owner];
52      }
53  
54      function transfer(address _to, uint256 _amount) returns (bool success) {
55          if (balances[msg.sender] >= _amount 
56             && _amount > 0
57              && balances[_to] + _amount > balances[_to]) {
58              balances[msg.sender] -= _amount;
59              balances[_to] += _amount;
60              Transfer(msg.sender, _to, _amount);
61             return true;
62          } else {
63              return false;
64          }
65      }
66      
67      
68      function transferFrom(
69          address _from,
70          address _to,
71          uint256 _amount
72      ) returns (bool success) {
73          if (balances[_from] >= _amount
74              && allowed[_from][msg.sender] >= _amount
75              && _amount > 0
76              && balances[_to] + _amount > balances[_to]) {
77              balances[_from] -= _amount;
78              allowed[_from][msg.sender] -= _amount;
79              balances[_to] += _amount;
80              Transfer(_from, _to, _amount);
81              return true;
82          } else {
83             return false;
84          }
85      }
86  
87      function approve(address _spender, uint256 _amount) returns (bool success) {
88          allowed[msg.sender][_spender] = _amount;
89         Approval(msg.sender, _spender, _amount);
90          return true;
91      }
92   
93      function allowance(address _owner, address _spender) constant returns (uint256 remaining) {
94          return allowed[_owner][_spender];
95     }
96 }