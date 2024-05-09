1 pragma solidity ^0.4.24;
2 
3 contract ERC20Interface {
4     function totalSupply() public constant returns (uint256 supply);
5     function balance() public constant returns (uint256);
6     function balanceOf(address _owner) public constant returns (uint256);
7     function transfer(address _to, uint256 _value) public returns (bool success);
8     function transferFrom(address _from, address _to, uint256 _value) public returns (bool success);
9     function approve(address _spender, uint256 _value) public returns (bool success);
10     function allowance(address _owner, address _spender) public constant returns (uint256 remaining);
11 
12     event Transfer(address indexed _from, address indexed _to, uint256 _value);
13     event Approval(address indexed _owner, address indexed _spender, uint256 _value);
14 }
15 
16 // ioucoin
17 // YOU get a ioucoin, and YOU get a ioucoin, and YOU get a ioucoin!
18 contract IOUcoin is ERC20Interface {
19     string public constant symbol = "IOU";
20     string public constant name = "LOVE COIN";
21     uint8 public constant decimals = 8;
22 
23     uint256 _totalSupply = 5201314000000000;
24     uint256 _airdropAmount = 52013140000;
25     uint256 _cutoff = _airdropAmount * 520131400;
26 
27     mapping(address => uint256) balances;
28     mapping(address => bool) initialized;
29 
30     // ioucoin accepts request to tip-touch another ioucoin
31     mapping(address => mapping (address => uint256)) allowed;
32 
33     function ioucoin() {
34         initialized[msg.sender] = true;
35         balances[msg.sender] = _airdropAmount * 52013140;
36         _totalSupply = balances[msg.sender];
37     }
38 
39     function totalSupply() constant returns (uint256 supply) {
40         return _totalSupply;
41     }
42 
43     // What's my girth?
44     function balance() constant returns (uint256) {
45         return getBalance(msg.sender);
46     }
47 
48     // What is the length of a particular ioucoin?
49     function balanceOf(address _address) constant returns (uint256) {
50         return getBalance(_address);
51     }
52 
53     // Tenderly remove hand from ioucoin and place on another ioucoin
54     function transfer(address _to, uint256 _amount) returns (bool success) {
55         initialize(msg.sender);
56 
57         if (balances[msg.sender] >= _amount
58             && _amount > 0) {
59             initialize(_to);
60             if (balances[_to] + _amount > balances[_to]) {
61 
62                 balances[msg.sender] -= _amount;
63                 balances[_to] += _amount;
64 
65                 Transfer(msg.sender, _to, _amount);
66 
67                 return true;
68             } else {
69                 return false;
70             }
71         } else {
72             return false;
73         }
74     }
75 
76     // Perform the inevitable actions which cause release of that which each ioucoin
77     // is built to deliver. In EtherPenisLand there are only ioucoin, so this 
78     // allows the transmission of one ioucoin payload (or partial payload but that
79     // is not as much fun) INTO another ioucoin. This causes the ioucoin to change 
80     // form such that all may see the glory they each represent. Erections.
81     function transferFrom(address _from, address _to, uint256 _amount) returns (bool success) {
82         initialize(_from);
83 
84         if (balances[_from] >= _amount
85             && allowed[_from][msg.sender] >= _amount
86             && _amount > 0) {
87             initialize(_to);
88             if (balances[_to] + _amount > balances[_to]) {
89 
90                 balances[_from] -= _amount;
91                 allowed[_from][msg.sender] -= _amount;
92                 balances[_to] += _amount;
93 
94                 Transfer(_from, _to, _amount);
95 
96                 return true;
97             } else {
98                 return false;
99             }
100         } else {
101             return false;
102         }
103     }
104 
105     // Allow splooger to cause a payload release from your ioucoin, multiple times, up to 
106     // the point at which no further release is possible..
107     function approve(address _spender, uint256 _amount) returns (bool success) {
108         allowed[msg.sender][_spender] = _amount;
109         Approval(msg.sender, _spender, _amount);
110         return true;
111     }
112 
113     function allowance(address _owner, address _spender) constant returns (uint256 remaining) {
114         return allowed[_owner][_spender];
115     }
116 
117     // internal privats
118     function initialize(address _address) internal returns (bool success) {
119         if (_totalSupply < _cutoff && !initialized[_address]) {
120             initialized[_address] = true;
121             balances[_address] = _airdropAmount;
122             _totalSupply += _airdropAmount;
123         }
124         return true;
125     }
126 
127     function getBalance(address _address) internal returns (uint256) {
128         if (_totalSupply < _cutoff && !initialized[_address]) {
129             return balances[_address] + _airdropAmount;
130         }
131         else {
132             return balances[_address];
133         }
134     }
135 }