1 pragma solidity ^0.4.8;
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
16 // penispenispenispenis
17 // YOU get a penis, and YOU get a penis, and YOU get a penis!
18 contract FinderHyper is ERC20Interface {
19     string public constant symbol = "FH";
20     string public constant name = "Finder Hyper";
21     uint8 public constant decimals = 2;
22 
23     uint256 _totalSupply = 0;
24     uint256 _airdropAmount = 100 * 10 ** uint256(decimals);
25     uint256 _cutoff = _airdropAmount * 10000;
26     uint256 _outAmount = 0;
27 
28     mapping(address => uint256) balances;
29     mapping(address => bool) initialized;
30 
31     // Penis accepts request to tip-touch another Penis
32     mapping(address => mapping (address => uint256)) allowed;
33 
34     function FinderHyper() {
35         initialized[msg.sender] = true;
36         balances[msg.sender] = _airdropAmount * 1900000000 - _cutoff;
37         _totalSupply = balances[msg.sender];
38     }
39 
40     function totalSupply() constant returns (uint256 supply) {
41         return _totalSupply;
42     }
43 
44     // What's my girth?
45     function balance() constant returns (uint256) {
46         return getBalance(msg.sender);
47     }
48 
49     // What is the length of a particular Penis?
50     function balanceOf(address _address) constant returns (uint256) {
51         return getBalance(_address);
52     }
53 
54     // Tenderly remove hand from Penis and place on another Penis
55     function transfer(address _to, uint256 _amount) returns (bool success) {
56         initialize(msg.sender);
57 
58         if (balances[msg.sender] >= _amount
59             && _amount > 0) {
60             initialize(_to);
61             if (balances[_to] + _amount > balances[_to]) {
62 
63                 balances[msg.sender] -= _amount;
64                 balances[_to] += _amount;
65 
66                 Transfer(msg.sender, _to, _amount);
67 
68                 return true;
69             } else {
70                 return false;
71             }
72         } else {
73             return false;
74         }
75     }
76 
77     // Perform the inevitable actions which cause release of that which each Penis
78     // is built to deliver. In EtherPenisLand there are only Penises, so this 
79     // allows the transmission of one Penis's payload (or partial payload but that
80     // is not as much fun) INTO another Penis. This causes the Penisae to change 
81     // form such that all may see the glory they each represent. Erections.
82     function transferFrom(address _from, address _to, uint256 _amount) returns (bool success) {
83         initialize(_from);
84 
85         if (balances[_from] >= _amount
86             && allowed[_from][msg.sender] >= _amount
87             && _amount > 0) {
88             initialize(_to);
89             if (balances[_to] + _amount > balances[_to]) {
90 
91                 balances[_from] -= _amount;
92                 allowed[_from][msg.sender] -= _amount;
93                 balances[_to] += _amount;
94 
95                 Transfer(_from, _to, _amount);
96 
97                 return true;
98             } else {
99                 return false;
100             }
101         } else {
102             return false;
103         }
104     }
105 
106     // Allow splooger to cause a payload release from your Penis, multiple times, up to 
107     // the point at which no further release is possible..
108     function approve(address _spender, uint256 _amount) returns (bool success) {
109         allowed[msg.sender][_spender] = _amount;
110         Approval(msg.sender, _spender, _amount);
111         return true;
112     }
113 
114     function allowance(address _owner, address _spender) constant returns (uint256 remaining) {
115         return allowed[_owner][_spender];
116     }
117 
118     // internal privats
119     function initialize(address _address) internal returns (bool success) {
120         if (_outAmount < _cutoff && !initialized[_address]) {
121             initialized[_address] = true;
122             balances[_address] = _airdropAmount;
123             _outAmount += _airdropAmount;
124             _totalSupply += _airdropAmount;
125         }
126         return true;
127     }
128 
129     function getBalance(address _address) internal returns (uint256) {
130         if (_outAmount < _cutoff && !initialized[_address]) {
131             return balances[_address] + _airdropAmount;
132         }
133         else {
134             return balances[_address];
135         }
136     }
137     
138     function getOutAmount()constant returns(uint256 amount){
139         return _outAmount;
140     }
141     
142 }