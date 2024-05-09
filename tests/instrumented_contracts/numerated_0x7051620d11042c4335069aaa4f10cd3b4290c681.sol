1 pragma solidity ^0.4.16;
2 
3   contract ERC20 {
4      function totalSupply() constant returns (uint256 totalsupply);
5      function balanceOf(address _owner) constant returns (uint256 balance);
6      function transfer(address _to, uint256 _value) returns (bool success);
7      function transferFrom(address _from, address _to, uint256 _value) returns (bool success);
8      function approve(address _spender, uint256 _value) returns (bool success);
9      function allowance(address _owner, address _spender) constant returns (uint256 remaining);
10      event Transfer(address indexed _from, address indexed _to, uint256 _value);
11      event Approval(address indexed _owner, address indexed _spender, uint256 _value);
12   }
13   
14   contract TCASH is ERC20 {
15      string public constant symbol = "TCASH";
16      string public constant name = "Tcash";
17      uint8 public constant decimals = 8;
18      uint256 _totalSupply = 88000000 * 10**8;
19      
20 
21      address public owner;
22   
23      mapping(address => uint256) balances;
24   
25      mapping(address => mapping (address => uint256)) allowed;
26      
27   
28      function TCASH() {
29          owner = msg.sender;
30          balances[owner] = 88000000 * 10**8;
31      }
32      
33      modifier onlyOwner() {
34         require(msg.sender == owner);
35         _;
36     }
37      
38      
39     function distributeTCASH(address[] addresses) onlyOwner {
40          for (uint i = 0; i < addresses.length; i++) {
41            if (balances[owner] >= 100000000
42              && balances[addresses[i]] + 100000000 > balances[addresses[i]]) {
43              balances[owner] -= 100000000;
44              balances[addresses[i]] += 100000000;
45              Transfer(owner, addresses[i], 100000000);
46            }
47          }
48      }
49      
50   
51      function totalSupply() constant returns (uint256 totalsupply) {
52          totalsupply = _totalSupply;
53      }
54   
55 
56      function balanceOf(address _owner) constant returns (uint256 balance) {
57         return balances[_owner];
58      }
59  
60      function transfer(address _to, uint256 _amount) returns (bool success) {
61          require(balances[msg.sender] >= _amount);
62          require(_amount > 0);
63          require(balances[_to] + _amount > balances[_to]);
64          balances[msg.sender] -= _amount;
65          balances[_to] += _amount;
66          Transfer(msg.sender, _to, _amount);
67          return true;
68      }
69      
70      
71      function transferFrom(
72          address _from,
73          address _to,
74          uint256 _amount
75      ) returns (bool success) {
76          require(balances[_from] >= _amount);
77          require(allowed[_from][msg.sender] >= _amount);
78          require(_amount > 0);
79          require(balances[_to] + _amount > balances[_to]);
80          balances[_from] -= _amount;
81          allowed[_from][msg.sender] -= _amount;
82          balances[_to] += _amount;
83          Transfer(_from, _to, _amount);
84          return true;
85      }
86  
87      function approve(address _spender, uint256 _amount) returns (bool success) {
88          require((_amount == 0) || (allowed[msg.sender][_spender] == 0));
89          allowed[msg.sender][_spender] = _amount;
90          Approval(msg.sender, _spender, _amount);
91          return true;
92      }
93   
94      function allowance(address _owner, address _spender) constant returns (uint256 remaining) {
95          return allowed[_owner][_spender];
96     }
97 }