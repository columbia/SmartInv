1 pragma solidity ^0.4.10;
2 
3 contract SafeMath {
4 
5     function safeAdd(uint256 x, uint256 y) internal returns(uint256) {
6       uint256 z = x + y;
7       assert((z >= x) && (z >= y));
8       return z;
9     }
10 
11     function safeSubtract(uint256 x, uint256 y) internal returns(uint256) {
12       assert(x >= y);
13       uint256 z = x - y;
14       return z;
15     }
16 
17     function safeMult(uint256 x, uint256 y) internal returns(uint256) {
18       uint256 z = x * y;
19       assert((x == 0)||(z/x == y));
20       return z;
21     }
22     
23     function safeDiv(uint256 a, uint256 b) internal returns (uint256) {
24       assert(b > 0);
25       uint c = a / b;
26       assert(a == b * c + a % b);
27       return c;
28     }
29 
30 }
31 
32 contract Token {
33     uint256 public totalSupply;
34     function balanceOf(address _owner) constant returns (uint256 balance);
35     function transfer(address _to, uint256 _value) returns (bool success);
36     function transferFrom(address _from, address _to, uint256 _value) returns (bool success);
37     function approve(address _spender, uint256 _value) returns (bool success);
38     function allowance(address _owner, address _spender) constant returns (uint256 remaining);
39     event Transfer(address indexed _from, address indexed _to, uint256 _value);
40     event Approval(address indexed _owner, address indexed _spender, uint256 _value);
41 }
42 
43 contract StandardToken is Token {
44 
45     function transfer(address _to, uint256 _value) returns (bool success) {
46       if (balances[msg.sender] >= _value && _value > 0) {
47         balances[msg.sender] -= _value;
48         balances[_to] += _value;
49         Transfer(msg.sender, _to, _value);
50         return true;
51       } else {
52         return false;
53       }
54     }
55 
56     function transferFrom(address _from, address _to, uint256 _value) returns (bool success) {
57       if (balances[_from] >= _value && allowed[_from][msg.sender] >= _value && _value > 0) {
58         balances[_to] += _value;
59         balances[_from] -= _value;
60         allowed[_from][msg.sender] -= _value;
61         Transfer(_from, _to, _value);
62         return true;
63       } else {
64         return false;
65       }
66     }
67 
68     function balanceOf(address _owner) constant returns (uint256 balance) {
69         return balances[_owner];
70     }
71 
72     function approve(address _spender, uint256 _value) returns (bool success) {
73         allowed[msg.sender][_spender] = _value;
74         Approval(msg.sender, _spender, _value);
75         return true;
76     }
77 
78     function allowance(address _owner, address _spender) constant returns (uint256 remaining) {
79       return allowed[_owner][_spender];
80     }
81 
82     mapping (address => uint256) balances;
83     mapping (address => mapping (address => uint256)) allowed;
84 }
85 
86 contract Karma is SafeMath, StandardToken {
87 
88     string public constant name = "Karma PreSale Token";
89     string public constant symbol = "KRMP";
90     uint256 public constant decimals = 18;
91     uint256 public constant tokenCreationCap =  5000*10**decimals;
92 
93     address public multiSigWallet;
94     address public owner;
95 
96     // 1 ETH = 300 USD Date: 11.08.2017
97     uint public oneTokenInWei = 333333333333333000;
98 
99     modifier onlyOwner {
100         if(owner!=msg.sender) revert();
101         _;
102     }
103 
104     event CreateKRM(address indexed _to, uint256 _value);
105 
106     function Karma(address _SigWallet, address _owner) {
107         multiSigWallet = _SigWallet;
108         owner = _owner;
109         
110         balances[0xDe9a1a8CC771C12D4D85b32742688D3EC955167c] = 1900 * 10**decimals;
111         balances[0x707Db60b19Cfc5d525DD2359D6181248aa0A518d] = 2900 * 10**decimals;
112         balances[0xbfe3d6da33616Ae044c17e203969d37ED5aDF651] = 100 * 10**decimals;
113         balances[0x45d6B3Ed3375B114F3ecD3ac5D7E9Bd2154a1E89] = 100 * 10**decimals;
114     }
115 
116     function () payable {
117         createTokens();
118     }
119 
120     function createTokens() internal {
121         if (msg.value <= 0) revert();
122 
123         uint multiplier = 10 ** decimals;
124         uint256 tokens = safeMult(msg.value, multiplier) / oneTokenInWei;
125 
126         uint256 checkedSupply = safeAdd(totalSupply, tokens);
127         if (tokenCreationCap < checkedSupply) revert();
128 
129         balances[msg.sender] += tokens;
130         totalSupply = safeAdd(totalSupply, tokens);
131     }
132 
133     function finalize() external onlyOwner {
134         multiSigWallet.transfer(this.balance);
135     }
136     
137     // add call to oracle 
138     function setEthPrice(uint _etherPrice) onlyOwner {
139         oneTokenInWei = 1 ether / _etherPrice / 100;
140     }
141 
142 }