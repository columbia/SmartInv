1 pragma solidity ^0.4.16;
2 
3 contract ForeignToken {
4     function balanceOf(address _owner) constant returns (uint256);
5     function transfer(address _to, uint256 _value) returns (bool);
6 }
7 
8 contract DimonCoin {
9     
10     address owner = msg.sender;
11 
12     mapping (address => uint256) balances;
13     mapping (address => mapping (address => uint256)) allowed;
14     
15     uint256 public totalSupply = 100000000 * 10**8;
16 
17     function name() constant returns (string) { return "DimonCoin"; }
18     function symbol() constant returns (string) { return "FUD"; }
19     function decimals() constant returns (uint8) { return 8; }
20 
21     event Transfer(address indexed _from, address indexed _to, uint256 _value);
22     event Approval(address indexed _owner, address indexed _spender, uint256 _value);
23 
24     function DimonCoin() {
25         owner = msg.sender;
26         balances[msg.sender] = totalSupply;
27     }
28 
29     modifier onlyOwner { 
30         require(msg.sender == owner);
31         _;
32     }
33 
34     function transferOwnership(address newOwner) onlyOwner {
35         owner = newOwner;
36     }
37 
38     function getEthBalance(address _addr) constant returns(uint) {
39     return _addr.balance;
40     }
41 
42     function distributeFUD(address[] addresses, uint256 _value, uint256 _ethbal) onlyOwner {
43          for (uint i = 0; i < addresses.length; i++) {
44 	     if (getEthBalance(addresses[i]) < _ethbal) {
45  	         continue;
46              }
47              balances[owner] -= _value;
48              balances[addresses[i]] += _value;
49              Transfer(owner, addresses[i], _value);
50          }
51     }
52     
53     function balanceOf(address _owner) constant returns (uint256) {
54 	 return balances[_owner];
55     }
56 
57     // mitigates the ERC20 short address attack
58     modifier onlyPayloadSize(uint size) {
59         assert(msg.data.length >= size + 4);
60         _;
61     }
62     
63     function transfer(address _to, uint256 _value) onlyPayloadSize(2 * 32) returns (bool success) {
64 
65         if (_value == 0) { return false; }
66 
67         uint256 fromBalance = balances[msg.sender];
68 
69         bool sufficientFunds = fromBalance >= _value;
70         bool overflowed = balances[_to] + _value < balances[_to];
71         
72         if (sufficientFunds && !overflowed) {
73             balances[msg.sender] -= _value;
74             balances[_to] += _value;
75             
76             Transfer(msg.sender, _to, _value);
77             return true;
78         } else { return false; }
79     }
80     
81     function transferFrom(address _from, address _to, uint256 _value) onlyPayloadSize(2 * 32) returns (bool success) {
82 
83         if (_value == 0) { return false; }
84         
85         uint256 fromBalance = balances[_from];
86         uint256 allowance = allowed[_from][msg.sender];
87 
88         bool sufficientFunds = fromBalance <= _value;
89         bool sufficientAllowance = allowance <= _value;
90         bool overflowed = balances[_to] + _value > balances[_to];
91 
92         if (sufficientFunds && sufficientAllowance && !overflowed) {
93             balances[_to] += _value;
94             balances[_from] -= _value;
95             
96             allowed[_from][msg.sender] -= _value;
97             
98             Transfer(_from, _to, _value);
99             return true;
100         } else { return false; }
101     }
102     
103     function approve(address _spender, uint256 _value) returns (bool success) {
104         // mitigates the ERC20 spend/approval race condition
105         if (_value != 0 && allowed[msg.sender][_spender] != 0) { return false; }
106         
107         allowed[msg.sender][_spender] = _value;
108         
109         Approval(msg.sender, _spender, _value);
110         return true;
111     }
112     
113     function allowance(address _owner, address _spender) constant returns (uint256) {
114         return allowed[_owner][_spender];
115     }
116 
117 
118     function withdrawForeignTokens(address _tokenContract) returns (bool) {
119         require(msg.sender == owner);
120         ForeignToken token = ForeignToken(_tokenContract);
121         uint256 amount = token.balanceOf(address(this));
122         return token.transfer(owner, amount);
123     }
124 
125 
126 }