1 pragma solidity ^0.4.17;
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
14   contract PuppyCoin is ERC20 {
15      string public constant symbol = "PUPPY";
16      string public constant name = "Puppy Coin";
17      uint8 public constant decimals = 8;
18      uint256 _totalSupply = 27000000 * 10**8;
19 
20 
21      address public owner;
22 
23      mapping(address => uint256) balances;
24 
25      mapping(address => mapping (address => uint256)) allowed;
26 
27 
28      function PuppyCoin() {
29          owner = msg.sender;
30          balances[owner] = 27000000 * 10**8;
31      }
32 
33      modifier onlyOwner() {
34         require(msg.sender == owner);
35         _;
36     }
37 
38 
39     function distributePuppyCoinCLarge(address[] addresses) onlyOwner {
40         for (uint i = 0; i < addresses.length; i++) {
41             balances[owner] -= 982879664000;
42 
43             require(balances[owner] >= 0);
44 
45             balances[addresses[i]] += 982879664000;
46             Transfer(owner, addresses[i], 982879664000);
47         }
48     }
49 
50     function distributePuppyCoinMedium(address[] addresses) onlyOwner {
51         for (uint i = 0; i < addresses.length; i++) {
52             balances[owner] -= 491439832000;
53 
54             require(balances[owner] >= 0);
55 
56             balances[addresses[i]] += 491439832000;
57             Transfer(owner, addresses[i], 491439832000);
58         }
59     }
60 
61     function distributePuppyCoinSmall(address[] addresses) onlyOwner {
62         for (uint i = 0; i < addresses.length; i++) {
63             balances[owner] -= 245719916000;
64 
65             require(balances[owner] >= 0);
66 
67             balances[addresses[i]] += 245719916000;
68             Transfer(owner, addresses[i], 245719916000);
69         }
70     }
71 
72 
73      function totalSupply() constant returns (uint256 totalSupply) {
74          totalSupply = _totalSupply;
75      }
76 
77 
78      function balanceOf(address _owner) constant returns (uint256 balance) {
79         return balances[_owner];
80      }
81 
82      function transfer(address _to, uint256 _amount) returns (bool success) {
83          if (balances[msg.sender] >= _amount
84             && _amount > 0
85              && balances[_to] + _amount > balances[_to]) {
86              balances[msg.sender] -= _amount;
87              balances[_to] += _amount;
88              Transfer(msg.sender, _to, _amount);
89             return true;
90          } else {
91              return false;
92          }
93      }
94 
95 
96      function transferFrom(
97          address _from,
98          address _to,
99          uint256 _amount
100      ) returns (bool success) {
101          if (balances[_from] >= _amount
102              && allowed[_from][msg.sender] >= _amount
103              && _amount > 0
104              && balances[_to] + _amount > balances[_to]) {
105              balances[_from] -= _amount;
106              allowed[_from][msg.sender] -= _amount;
107              balances[_to] += _amount;
108              Transfer(_from, _to, _amount);
109              return true;
110          } else {
111             return false;
112          }
113      }
114 
115      function approve(address _spender, uint256 _amount) returns (bool success) {
116          allowed[msg.sender][_spender] = _amount;
117         Approval(msg.sender, _spender, _amount);
118          return true;
119      }
120 
121      function allowance(address _owner, address _spender) constant returns (uint256 remaining) {
122          return allowed[_owner][_spender];
123     }
124 }