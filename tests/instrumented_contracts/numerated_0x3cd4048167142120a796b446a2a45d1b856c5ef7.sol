1 pragma solidity ^0.4.13;
2 
3 contract Token {
4  
5   /// total amount of tokens
6   uint256 public totalSupply;
7 
8   function balanceOf(address _owner) constant returns (uint256 balance);
9 
10   
11   function transfer(address _to, uint256 _value) returns (bool success);
12 
13  
14   function transferFrom(address _from, address _to, uint256 _value) returns (bool success);
15 
16   
17   function approve(address _spender, uint256 _value) returns (bool success);
18 
19   
20   function allowance(address _owner, address _spender) constant returns (uint256 remaining);
21 
22   event Transfer(address indexed _from, address indexed _to, uint256 _value);
23   event Approval(address indexed _owner, address indexed _spender, uint256 _value);
24 }
25 
26 contract StandardToken is Token {
27 
28   function transfer(address _to, uint256 _value) returns (bool success) {
29     
30     //if (balances[msg.sender] >= _value && balances[_to] + _value > balances[_to]) {
31     if (balances[msg.sender] >= _value && _value > 0) {
32       balances[msg.sender] -= _value;
33       balances[_to] += _value;
34       Transfer(msg.sender, _to, _value);
35       return true;
36     } else { return false; }
37   }
38 
39   function transferFrom(address _from, address _to, uint256 _value) returns (bool success) {
40    
41     //if (balances[_from] >= _value && allowed[_from][msg.sender] >= _value && balances[_to] + _value > balances[_to]) {
42     if (balances[_from] >= _value && allowed[_from][msg.sender] >= _value && _value > 0) {
43       balances[_to] += _value;
44       balances[_from] -= _value;
45       allowed[_from][msg.sender] -= _value;
46       Transfer(_from, _to, _value);
47       return true;
48     } else { return false; }
49   }
50 
51   function balanceOf(address _owner) constant returns (uint256 balance) {
52     return balances[_owner];
53   }
54 
55   function approve(address _spender, uint256 _value) returns (bool success) {
56     allowed[msg.sender][_spender] = _value;
57     Approval(msg.sender, _spender, _value);
58     return true;
59   }
60 
61   function allowance(address _owner, address _spender) constant returns (uint256 remaining) {
62     return allowed[_owner][_spender];
63   }
64 
65   mapping (address => uint256) balances;
66   mapping (address => mapping (address => uint256)) allowed;
67 }
68 
69 contract DAFZOToken is StandardToken {
70 
71   string public constant name = "DAFZO";
72   string public constant symbol = "DFZ";
73   uint8 public constant decimals = 18;
74 
75   function DAFZOToken(address _icoAddress,
76                          address _preIcoAddress,
77                          address _dafzoWalletAddress,
78                          address _bountyWalletAddress) {
79     require(_icoAddress != 0x0);
80     require(_preIcoAddress != 0x0);
81     require(_dafzoWalletAddress != 0x0);
82     require(_bountyWalletAddress != 0x0);
83 
84     totalSupply = 70000000 * 10**18;                     // 70000000 DFZ
85 
86     uint256 icoTokens = 18956000  * 10**18;               
87 
88     uint256 preIcoTokens = 28434000 * 10**18;
89     
90      uint256 bountyTokens = 1610000 * 10**18;
91 
92     uint256 DAFZOTokens = 21000000 * 10**18;            // Dafzo Funds        
93                                                                       
94 
95     assert(icoTokens + preIcoTokens + DAFZOTokens + bountyTokens == totalSupply);
96 
97     balances[_icoAddress] = icoTokens;
98     Transfer(0, _icoAddress, icoTokens);
99 
100     balances[_preIcoAddress] = preIcoTokens;
101     Transfer(0, _preIcoAddress, preIcoTokens);
102 
103     balances[_dafzoWalletAddress] = DAFZOTokens;
104     Transfer(0, _dafzoWalletAddress, DAFZOTokens);
105 
106     balances[_bountyWalletAddress] = bountyTokens;
107     Transfer(0, _bountyWalletAddress, bountyTokens);
108   }
109 
110   function burn(uint256 _value) returns (bool success) {
111     if (balances[msg.sender] >= _value && _value > 0) {
112       balances[msg.sender] -= _value;
113       totalSupply -= _value;
114       Transfer(msg.sender, 0x0, _value);
115       return true;
116     } else {
117       return false;
118     }
119   }
120 }