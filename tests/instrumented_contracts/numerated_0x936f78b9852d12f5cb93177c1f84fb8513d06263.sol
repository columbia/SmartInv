1 pragma solidity ^0.4.4;
2 
3 // ERC20-compliant wrapper token for GNT
4 // adapted from code provided by u/JonnyLatte
5 
6 contract TokenInterface {
7     mapping (address => uint256) balances;
8     mapping (address => mapping (address => uint256)) allowed;
9 
10     uint256 public totalSupply;
11 
12     function balanceOf(address _owner) constant returns (uint256 balance);
13     function transfer(address _to, uint256 _amount) returns (bool success);
14     function transferFrom(
15         address _from, address _to, uint256 _amount) returns (bool success);
16     function approve(address _spender, uint256 _amount) returns (bool success);
17     function allowance(
18         address _owner, address _spender) constant returns (uint256 remaining);
19 
20     event Transfer(address indexed _from, address indexed _to, uint256 _amount);
21     event Approval(
22         address indexed _owner, address indexed _spender, uint256 _amount);
23 }
24 
25 contract Token is TokenInterface {
26     function balanceOf(address _owner) constant returns (uint256 balance) {
27         return balances[_owner];
28     }
29 
30     function _transfer(address _to,
31                        uint256 _amount) internal returns (bool success) {
32         if (balances[msg.sender] >= _amount && _amount > 0) {
33             balances[msg.sender] -= _amount;
34             balances[_to] += _amount;
35             Transfer(msg.sender, _to, _amount);
36             return true;
37         } else {
38            return false;
39         }
40     }
41 
42     function _transferFrom(address _from,
43                            address _to,
44                            uint256 _amount) internal returns (bool success) {
45         if (balances[_from] >= _amount
46             && allowed[_from][msg.sender] >= _amount
47             && _amount > 0) {
48 
49             balances[_to] += _amount;
50             balances[_from] -= _amount;
51             allowed[_from][msg.sender] -= _amount;
52             Transfer(_from, _to, _amount);
53             return true;
54         } else {
55             return false;
56         }
57     }
58 
59     function approve(address _spender, uint256 _amount) returns (bool success) {
60         allowed[msg.sender][_spender] = _amount;
61         Approval(msg.sender, _spender, _amount);
62         return true;
63     }
64 
65     function allowance(address _owner,
66                        address _spender) constant returns (uint256 remaining) {
67         return allowed[_owner][_spender];
68     }
69 }
70 
71 contract DepositSlot {
72     address public constant GNT = 0xa74476443119A942dE498590Fe1f2454d7D4aC0d;
73 
74     address public wrapper;
75 
76     modifier onlyWrapper {
77         if (msg.sender != wrapper) throw;
78         _;
79     }
80 
81     function DepositSlot(address _wrapper) {
82         wrapper = _wrapper;
83     }
84 
85     function collect() onlyWrapper {
86         uint amount = TokenInterface(GNT).balanceOf(this);
87         if (amount == 0) throw;
88 
89         TokenInterface(GNT).transfer(wrapper, amount);
90     }
91 }
92 
93 contract GolemNetworkTokenWrapped is Token {
94     string public constant standard = "Token 0.1";
95     string public constant name = "Golem Network Token Wrapped";
96     string public constant symbol = "GNTW";
97     uint8 public constant decimals = 18;     // same as GNT
98 
99     address public constant GNT = 0xa74476443119A942dE498590Fe1f2454d7D4aC0d;
100 
101     mapping (address => address) depositSlots;
102 
103     function createPersonalDepositAddress() returns (address depositAddress) {
104         if (depositSlots[msg.sender] == 0) {
105             depositSlots[msg.sender] = new DepositSlot(this);
106         }
107 
108         return depositSlots[msg.sender];
109     }
110 
111     function getPersonalDepositAddress(
112                 address depositer) constant returns (address depositAddress) {
113         return depositSlots[depositer];
114     }
115 
116     function processDeposit() {
117         address depositSlot = depositSlots[msg.sender];
118         if (depositSlot == 0) throw;
119 
120         DepositSlot(depositSlot).collect();
121 
122         uint balance = TokenInterface(GNT).balanceOf(this);
123         if (balance <= totalSupply) throw;
124 
125         uint freshGNTW = balance - totalSupply;
126         totalSupply += freshGNTW;
127         balances[msg.sender] += freshGNTW;
128         Transfer(address(this), msg.sender, freshGNTW);
129     }
130 
131     function transfer(address _to,
132                       uint256 _amount) returns (bool success) {
133         if (_to == address(this)) {
134             withdrawGNT(_amount);   // convert back to GNT
135             return true;
136         } else {
137             return _transfer(_to, _amount);     // standard transfer
138         }
139     }
140 
141     function transferFrom(address _from,
142                           address _to,
143                           uint256 _amount) returns (bool success) {
144         if (_to == address(this)) throw;        // not supported
145         return _transferFrom(_from, _to, _amount);
146     }
147 
148 
149     function withdrawGNT(uint amount) internal {
150         if (balances[msg.sender] < amount) throw;
151 
152         balances[msg.sender] -= amount;
153         totalSupply -= amount;
154         Transfer(msg.sender, address(this), amount);
155 
156         TokenInterface(GNT).transfer(msg.sender, amount);
157     }
158 }