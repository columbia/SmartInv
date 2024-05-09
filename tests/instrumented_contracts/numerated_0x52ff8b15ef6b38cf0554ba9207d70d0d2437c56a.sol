1 pragma solidity ^0.4.11;
2  
3 contract Token {
4     string public symbol = "711";
5     string public name = "711 token";
6     uint8 public constant decimals = 18;
7     uint256 _totalSupply = 711000000000000000000;
8     address owner = 0;
9     bool startDone = false;
10     uint public amountRaised;
11     uint public deadline;
12     uint public overRaisedUnsend = 0;
13     uint public backers = 0;
14     uint rate = 4;
15     uint successcoef = 2;
16     uint unreserved = 80;
17     uint _durationInMinutes = 0;
18     bool fundingGoalReached = false;
19     mapping(address => uint256) public balanceOf;
20 	
21     event Transfer(address indexed _from, address indexed _to, uint256 _value);
22     event Approval(address indexed _owner, address indexed _spender, uint256 _value);
23 
24     mapping(address => uint256) balances;
25  
26     mapping(address => mapping (address => uint256)) allowed;
27  
28     function Token(address adr) {
29 		owner = adr;        
30     }
31 	
32 	function StartICO(uint256 durationInMinutes)
33 	{
34 		if (msg.sender == owner && startDone == false)
35 		{
36 			balances[owner] = _totalSupply;
37 			_durationInMinutes = durationInMinutes;
38             deadline = now + durationInMinutes * 1 minutes;
39 			startDone = true;
40 		}
41 	}
42  
43     function totalSupply() constant returns (uint256 totalSupply) {        
44 		return _totalSupply;
45     }
46  
47     function balanceOf(address _owner) constant returns (uint256 balance) {
48         return balances[_owner];
49     }
50  
51     function transfer(address _to, uint256 _amount) returns (bool success) {
52         if (balances[msg.sender] >= _amount 
53             && _amount > 0
54             && balances[_to] + _amount > balances[_to]) {
55             balances[msg.sender] -= _amount;
56             balances[_to] += _amount;
57             Transfer(msg.sender, _to, _amount);
58             return true;
59         } else {
60             return false;
61         }
62     }
63  
64     function transferFrom(
65         address _from,
66         address _to,
67         uint256 _amount
68     ) returns (bool success) {
69         if (balances[_from] >= _amount
70             && allowed[_from][msg.sender] >= _amount
71             && _amount > 0
72             && balances[_to] + _amount > balances[_to]) {
73             balances[_from] -= _amount;
74             allowed[_from][msg.sender] -= _amount;
75             balances[_to] += _amount;
76             Transfer(_from, _to, _amount);
77             return true;
78         } else {
79             return false;
80         }
81     }
82     
83     function () payable {
84         uint _amount = msg.value;
85         uint amount = msg.value;
86         _amount = _amount * rate;
87         if (amountRaised + _amount <= _totalSupply * unreserved / 100
88             && balances[owner] >= _amount
89             && _amount > 0
90             && balances[msg.sender] + _amount > balances[msg.sender]
91             && now <= deadline
92             && !fundingGoalReached 
93             && startDone) {
94         backers += 1;
95         balances[msg.sender] += _amount;
96         balances[owner] -= _amount;
97         amountRaised += _amount;
98         Transfer(owner, msg.sender, _amount);
99         } else {
100             if (!msg.sender.send(amount)) {
101                 overRaisedUnsend += amount; 
102             }
103         }
104     }
105  
106     function approve(address _spender, uint256 _amount) returns (bool success) {
107         allowed[msg.sender][_spender] = _amount;
108         Approval(msg.sender, _spender, _amount);
109         return true;
110     }
111  
112     function allowance(address _owner, address _spender) constant returns (uint256 remaining) {
113         return allowed[_owner][_spender];
114     }
115     
116     modifier afterDeadline() { if (now > deadline || amountRaised >= _totalSupply / successcoef) _; }
117 
118     function safeWithdrawal() afterDeadline {
119 
120     if (amountRaised < _totalSupply / successcoef) {
121             uint _amount = balances[msg.sender];
122             balances[msg.sender] = 0;
123             if (_amount > 0) {
124                 if (msg.sender.send(_amount / rate)) {
125                     balances[owner] += _amount;
126                     amountRaised -= _amount;
127                     Transfer(msg.sender, owner, _amount);
128                 } else {
129                     balances[msg.sender] = _amount;
130                 }
131             }
132         }
133 
134     if (owner == msg.sender
135     	&& amountRaised >= _totalSupply / successcoef) {
136            if (owner.send(this.balance)) {
137                fundingGoalReached = true;
138             } 
139         }
140     }
141 }