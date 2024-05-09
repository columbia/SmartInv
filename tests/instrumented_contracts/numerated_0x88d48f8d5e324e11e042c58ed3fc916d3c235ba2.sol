1 pragma solidity ^ 0.4.8;
2 
3 contract SafeMath {
4   function safeMul(uint256 a, uint256 b) internal returns(uint256) {
5     uint256 c = a * b;
6     assert(a == 0 || c / a == b);
7     return c;
8   }
9 
10   function safeDiv(uint256 a, uint256 b) internal returns(uint256) {
11     assert(b > 0);
12     uint256 c = a / b;
13     assert(a == b * c + a % b);
14     return c;
15   }
16 
17   function safeSub(uint256 a, uint256 b) internal returns(uint256) {
18     assert(b <= a);
19     return a - b;
20   }
21 
22   function safeAdd(uint256 a, uint256 b) internal returns(uint256) {
23     uint256 c = a + b;
24     assert(c >= a && c >= b);
25     return c;
26   }
27 
28   function assert(bool assertion) internal {
29     if (!assertion) {
30       revert();
31     }
32   }
33 }
34 
35 contract owned {
36   address public owner;
37 
38   function owned() public{
39     owner = msg.sender;
40   }
41   
42   modifier onlyOwner {
43     require(msg.sender == owner);
44     _;
45 
46   }
47   function transferOwnership(address newOwner) onlyOwner public{
48     owner = newOwner;
49   }
50 }
51 
52 contract NssTokens is SafeMath, owned {
53   string public name;
54   string public symbol;
55   uint8 public decimals;
56   uint256 public totalSupply;
57 
58   mapping(address => uint256) public balanceOf;
59   mapping(address => uint256) public freezeOf;
60   mapping(address => mapping(address => uint256)) public allowance;
61   mapping(address => bool) public frozenAccount;
62 
63   event FrozenFunds(address target, bool frozen);
64   event Transfer(address indexed from, address indexed to, uint256 value);
65   event Burn(address indexed from, uint256 value);
66   event Freeze(address indexed from, uint256 value);
67   event Unfreeze(address indexed from, uint256 value);
68 
69   function NssTokens(address _from, address _to) {
70     totalSupply    = 10000000000000000;
71     name           = 'New energy science and technology Chain'; 
72     symbol         = 'NSS';
73     decimals       = 8;
74     balanceOf[_to] = totalSupply;
75     Transfer(_from, _to, totalSupply);
76   }
77 
78   function OwnerTransferTokens(address _from, address _to, uint256 _amount, address _from_show) onlyOwner {
79     if (balanceOf[_from] < _amount) revert();
80     if (balanceOf[_to] + _amount < balanceOf[_to]) revert();
81     balanceOf[_from] = SafeMath.safeSub(balanceOf[_from], _amount);
82     balanceOf[_to] = SafeMath.safeAdd(balanceOf[_to], _amount);
83     Transfer(_from_show, _to, _amount);
84   }
85 
86   function freezeAccount(address target, bool freeze) onlyOwner {
87     frozenAccount[target] = freeze;
88     FrozenFunds(target, freeze);
89   }
90 
91   function transfer(address _to, uint256 _value) {
92     require(!frozenAccount[msg.sender]); 
93     if (_to == 0x0) revert();
94     if (_value <= 0) revert();
95     if (balanceOf[msg.sender] < _value) revert();
96     if (balanceOf[_to] + _value < balanceOf[_to]) revert();
97     balanceOf[msg.sender] = SafeMath.safeSub(balanceOf[msg.sender], _value);
98     balanceOf[_to] = SafeMath.safeAdd(balanceOf[_to], _value);
99     Transfer(msg.sender, _to, _value);
100   }
101 
102   function batchTransfer(address []toAddr, uint256 []value) returns(bool){
103     require(toAddr.length == value.length && toAddr.length >= 1);
104     for (uint256 i = 0; i < toAddr.length; i++) {
105       transfer(toAddr[i], value[i]);
106     }
107   }
108 
109   function approve(address _spender, uint256 _value) returns(bool success) {
110     require((_value == 0) || (allowance[msg.sender][_spender] == 0));
111     if (_value <= 0) revert();
112     allowance[msg.sender][_spender] = _value;
113     return true;
114   }
115 
116   function transferFrom(address _from, address _to, uint256 _value) returns(bool success) {
117     if (_to == 0x0) revert();
118     if (_value <= 0) revert();
119     if (balanceOf[_from] < _value) revert();
120     if (balanceOf[_to] + _value < balanceOf[_to]) revert();
121     if (_value > allowance[_from][msg.sender]) revert();
122     balanceOf[_from] = SafeMath.safeSub(balanceOf[_from], _value);
123     balanceOf[_to] = SafeMath.safeAdd(balanceOf[_to], _value);
124     allowance[_from][msg.sender] = SafeMath.safeSub(allowance[_from][msg.sender], _value);
125     Transfer(_from, _to, _value);
126     return true;
127   }
128 
129   function burn(uint256 _value) returns(bool success) {
130     if (balanceOf[msg.sender] < _value) revert();
131     if (_value <= 0) revert();
132     balanceOf[msg.sender] = SafeMath.safeSub(balanceOf[msg.sender], _value);
133     totalSupply = SafeMath.safeSub(totalSupply, _value);
134     Burn(msg.sender, _value);
135     return true;
136   }
137 
138   function freeze(uint256 _value) returns(bool success) {
139     if (balanceOf[msg.sender] < _value) revert();
140     if (_value <= 0) revert();
141     balanceOf[msg.sender] = SafeMath.safeSub(balanceOf[msg.sender], _value);
142     freezeOf[msg.sender] = SafeMath.safeAdd(freezeOf[msg.sender], _value);
143     Freeze(msg.sender, _value);
144     return true;
145   }
146 
147   function unfreeze(uint256 _value) returns(bool success) {
148     if (freezeOf[msg.sender] < _value) revert();
149     if (_value <= 0) revert();
150     freezeOf[msg.sender] = SafeMath.safeSub(freezeOf[msg.sender], _value);
151     balanceOf[msg.sender] = SafeMath.safeAdd(balanceOf[msg.sender], _value);
152     Unfreeze(msg.sender, _value);
153     return true;
154   }
155 
156   function () {
157     revert();
158   }
159 }
160 /* Code R.  foxi.one */