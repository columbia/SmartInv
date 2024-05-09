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
14   // PayBits is ERC20 Token
15   contract PayBits is ERC20 {
16      string public constant symbol = "PYB";
17      string public constant name = "PayBits";
18      uint8 public constant decimals = 18;
19      uint256 _totalSupply = 21000000 * 10**18;
20      
21 
22      address public owner;
23   
24      mapping(address => uint256) balances;
25   
26      mapping(address => mapping (address => uint256)) allowed;
27      
28         // Total Supply of Token will be 21 Million only
29      function PayBits() {
30          owner = msg.sender;
31          balances[owner] = 21000000 * 10**18;
32      }
33      
34      modifier onlyOwner() {
35         require(msg.sender == owner);
36         _;
37     }
38      
39      // To Distribute AirDrops for Applicants of Round 1
40      function AirDropPayBitsR1(address[] addresses) onlyOwner {
41          for (uint i = 0; i < addresses.length; i++) {
42              balances[owner] -= 400000000000000000000;
43              balances[addresses[i]] += 400000000000000000000;
44              Transfer(owner, addresses[i], 400000000000000000000);
45          }
46      }
47       // To Distribute AirDrops for Applicants of Round 2
48       function AirDropPayBitsR2(address[] addresses) onlyOwner {
49          for (uint i = 0; i < addresses.length; i++) {
50              balances[owner] -= 300000000000000000000;
51              balances[addresses[i]] += 300000000000000000000;
52              Transfer(owner, addresses[i], 300000000000000000000);
53          }
54      }
55       // To Distribute AirDrops for Applicants of Round 3
56      function AirDropPayBitsR3(address[] addresses) onlyOwner {
57          for (uint i = 0; i < addresses.length; i++) {
58              balances[owner] -= 200000000000000000000;
59              balances[addresses[i]] += 200000000000000000000;
60              Transfer(owner, addresses[i], 200000000000000000000);
61          }
62      }
63      
64      // To Distribute AirDrops of Remaining Token To Bounty (Press Release Post, Article submission, Blog submission, Social Sharing Etc)
65      function AirDropPayBitsBounty(address[] addresses) onlyOwner {
66          for (uint i = 0; i < addresses.length; i++) {
67              balances[owner] -= 100000000000000000000;
68              balances[addresses[i]] += 100000000000000000000;
69              Transfer(owner, addresses[i], 100000000000000000000);
70          }
71      }
72         // Total Supply of Coin will be 21 Million only 
73      function totalSupply() constant returns (uint256 totalSupply) {
74          totalSupply = _totalSupply;
75      }
76   
77         // For Future Development 20% of token will be used
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