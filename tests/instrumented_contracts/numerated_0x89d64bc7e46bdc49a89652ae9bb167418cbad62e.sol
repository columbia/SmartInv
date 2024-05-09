1 /*
2   live: 0x89d64bc7e46bdc49a89652ae9bb167418cbad62e
3 morden: 0xe379e36671acbcc87ec7b760c07e6e45a1294944
4   solc: v0.3.1-2016-04-12-3ad5e82 (optimization)
5 */
6 
7 contract tokenRecipient {
8     function receiveApproval(address _from, uint256 _value, address _token);
9 }
10 
11 contract Token {
12     event Transfer(address indexed _from, address indexed _to, uint256 _value);
13     event Approval(address indexed _owner, address indexed _spender, uint256 _value);
14 
15     function totalSupply() constant returns (uint256 supply);
16     function balanceOf(address _owner) constant returns (uint256 balance);
17     function transfer(address _to, uint256 _value) returns (bool success);
18     function transferFrom(address _from, address _to, uint256 _value) returns (bool success);
19     function approve(address _spender, uint256 _value) returns (bool success);
20     function approveAndCall(address _spender, uint256 _value) returns (bool success);
21     function allowance(address _owner, address _spender) constant returns (uint256 remaining);
22 }
23 
24 contract SafeAddSub {
25     function safeToAdd(uint a, uint b) internal returns (bool) {
26         return (a + b > a);
27     }
28 
29     function safeToSubtract(uint a, uint b) internal returns (bool) {
30         return (a >= b);
31     }
32 
33     function safeAdd(uint a, uint b) internal returns (uint256) {
34         if (!safeToAdd(a, b)) throw;
35         return a + b;
36     }
37 
38     function safeSubtract(uint a, uint b) internal returns (uint256) {
39         if (!safeToSubtract(a, b)) throw;
40         return a - b;
41     }
42 }
43 
44 contract EthToken is Token, SafeAddSub {
45     string public constant name = "Ether Token Proxy";
46     string public constant symbol = "ETH";
47     uint8   public constant decimals = 18;
48     uint256 public constant baseUnit = 10**18;
49     
50     mapping (address => uint256) _balanceOf;
51     mapping (address => mapping (address => uint256)) _allowance;
52 
53     event Deposit(address indexed owner, uint256 amount);
54     event Withdrawal(address indexed owner, uint256 amount);
55 
56     function totalSupply() constant returns (uint256 supply) {
57         return this.balance;
58     }
59     
60     function () {
61         deposit();
62     }
63     
64     function deposit() {
65         _balanceOf[msg.sender] = safeAdd(_balanceOf[msg.sender], msg.value);
66         Deposit(msg.sender, msg.value);
67     }
68     
69     function redeem() {
70         withdraw(_balanceOf[msg.sender]);
71     }
72     
73     function withdraw(uint256 _value) returns (bool success) {
74         _balanceOf[msg.sender] = safeSubtract(_balanceOf[msg.sender], _value);
75         if (!msg.sender.send(_value)) {
76             if (!msg.sender.call.gas(msg.gas).value(_value)()) throw;
77         }
78         Withdrawal(msg.sender, _value);
79         return true;
80     }
81     
82     function balanceOf(address _owner) constant returns (uint256 balance) {
83         return _balanceOf[_owner];
84     }
85     
86     function transfer(address _to, uint256 _value) returns (bool success) {
87         if (_to == address(this) || _to == 0) {
88             return withdraw(_value);
89         } else {
90             _balanceOf[msg.sender] = safeSubtract(_balanceOf[msg.sender], _value);
91             _balanceOf[_to] = safeAdd(_balanceOf[_to], _value);
92             Transfer(msg.sender, _to, _value);
93         }
94         return true;
95     }
96     
97     function transferFrom(address _from, address _to, uint256 _value) returns (bool success) {
98         if (!safeToSubtract(_allowance[_from][msg.sender], _value)) throw;
99         if (_to == address(this) || _to == 0) {
100             if (!transferFrom(_from, msg.sender, _value)) throw;
101             withdraw(_value);
102         } else {
103             _balanceOf[_from] = safeSubtract(_balanceOf[_from], _value);
104             _balanceOf[_to] = safeAdd(_balanceOf[_to], _value);
105             _allowance[_from][msg.sender] = safeSubtract(_allowance[_from][msg.sender], _value);
106             Transfer(_from, _to, _value);
107         }
108         return true;
109     }
110     
111     function approve(address _spender, uint256 _value) returns (bool success) {
112         _allowance[msg.sender][_spender] = _value;
113         Approval(msg.sender, _spender, _value);
114         return true;
115     }
116     
117     function approveAndCall(address _spender, uint256 _value) returns (bool success) {
118         if (approve(_spender, _value)) {
119             tokenRecipient(_spender).receiveApproval(msg.sender, _value, this);
120             return true;
121         }
122         throw;
123     }
124     
125     function allowance(address _owner, address _spender) constant returns (uint256 remaining) {
126         return _allowance[_owner][_spender];
127     }
128 }