1 pragma solidity ^0.4.15;
2 
3 contract ERC20Interface {
4     // Get the total token supply
5     function totalSupply() constant returns (uint256 tS);
6  
7     // Get the account balance of another account with address _owner
8     function balanceOf(address _owner) constant returns (uint256 balance);
9  
10     // Send _value amount of tokens to address _to
11     function transfer(address _to, uint256 _value) returns (bool success);
12  
13     // Send _value amount of tokens from address _from to address _to
14     function transferFrom(address _from, address _to, uint256 _value) returns (bool success);
15  
16     // Allow _spender to withdraw from your account, multiple times, up to the _value amount.
17     // If this function is called again it overwrites the current allowance with _value.
18     // this function is required for some DEX functionality
19     function approve(address _spender, uint256 _value) returns (bool success);
20  
21     // Returns the amount which _spender is still allowed to withdraw from _owner
22     function allowance(address _owner, address _spender) constant returns (uint256 remaining);
23 
24     // Used only once for burning excess tokens after ICO.
25     function burnExcess(uint256 _value) returns (bool success);
26 
27     // Used for burning 100 tokens for every completed poll up to maximum of 10% of totalSupply.
28     function burnPoll(uint256 _value) returns (bool success);
29  
30     // Triggered when tokens are transferred.
31     event Transfer(address indexed _from, address indexed _to, uint256 _value);
32  
33     // Triggered whenever approve(address _spender, uint256 _value) is called.
34     event Approval(address indexed _owner, address indexed _spender, uint256 _value);
35 
36     // Triggered whenever tokens are destroyed
37     event Burn(address indexed from, uint256 value);
38 }
39  
40 contract POLLToken is ERC20Interface {
41 
42     string public constant symbol = "POLL";
43     string public constant name = "ClearPoll Token";
44     uint8 public constant decimals = 18;
45     uint256 _totalSupply = 10000000 * 10 ** uint256(decimals);
46     
47     address public owner;
48     
49     bool public excessTokensBurnt = false;
50 
51     uint256 public pollCompleted = 0;
52     
53     uint256 public pollBurnInc = 100 * 10 ** uint256(decimals);
54 
55     uint256 public pollBurnQty = 0;
56 
57     bool public pollBurnCompleted = false;
58 
59     uint256 public pollBurnQtyMax;
60 
61     mapping(address => uint256) balances;
62  
63     mapping(address => mapping (address => uint256)) allowed;
64 
65     // Handle ether mistakenly sent to contract
66     function () payable {
67       if (msg.value > 0) {
68           if (!owner.send(msg.value)) revert();
69       }
70     }
71 
72     function POLLToken() {
73         owner = msg.sender;
74         balances[owner] = _totalSupply;
75     }
76 
77     // Get the total token supply
78     function totalSupply() constant returns (uint256 tS) {
79         tS = _totalSupply;
80     }
81  
82     // What is the balance of a particular account?
83     function balanceOf(address _owner) constant returns (uint256 balance) {
84         return balances[_owner];
85     }
86  
87     // Transfer the balance from owner's account to another account
88     function transfer(address _to, uint256 _amount) returns (bool success) {
89         if (balances[msg.sender] >= _amount 
90             && _amount > 0
91             && balances[_to] + _amount > balances[_to]) {
92             balances[msg.sender] -= _amount;
93             balances[_to] += _amount;
94             Transfer(msg.sender, _to, _amount);
95             return true;
96         } else {
97             return false;
98         }
99     }
100  
101     // Send _value amount of tokens from address _from to address _to
102     // The transferFrom method is used for a withdraw workflow, allowing contracts to send
103     // tokens on your behalf, for example to "deposit" to a contract address and/or to charge
104     // fees in sub-currencies; the command should fail unless the _from account has
105     // deliberately authorized the sender of the message via some mechanism; we propose
106     // these standardized APIs for approval:
107     function transferFrom(
108         address _from, address _to, uint256 _amount) returns (bool success) {
109         if (balances[_from] >= _amount
110             && allowed[_from][msg.sender] >= _amount
111             && _amount > 0
112             && balances[_to] + _amount > balances[_to]) {
113             balances[_from] -= _amount;
114             allowed[_from][msg.sender] -= _amount;
115             balances[_to] += _amount;
116             Transfer(_from, _to, _amount);
117             return true;
118         } else {
119             return false;
120         }
121     }
122  
123     // Allow _spender to withdraw from your account, multiple times, up to the _value amount.
124     // If this function is called again it overwrites the current allowance with _value.
125     function approve(address _spender, uint256 _amount) returns (bool success) {
126         allowed[msg.sender][_spender] = _amount;
127         Approval(msg.sender, _spender, _amount);
128         return true;
129     }
130  
131     function allowance(address _owner, address _spender) constant returns (uint256 remaining) {
132         return allowed[_owner][_spender];
133     }
134 
135     // Used only once for burning excess tokens after ICO.
136     function burnExcess(uint256 _value) public returns (bool success) {
137         require(balanceOf(msg.sender) >= _value && msg.sender == owner && !excessTokensBurnt);
138         balances[msg.sender] -= _value;
139         _totalSupply -= _value;
140         Burn(msg.sender, _value);
141         pollBurnQtyMax = totalSupply() / 10;
142         excessTokensBurnt = true;
143         return true;
144     }   
145 
146     // Used for burning 100 tokens for every completed poll up to maximum of 10% of totalSupply.
147     function burnPoll(uint256 _value) public returns (bool success) {    	
148         require(msg.sender == owner && excessTokensBurnt && _value > pollCompleted && !pollBurnCompleted);
149         uint256 burnQty;
150         if ((_value * pollBurnInc) <= pollBurnQtyMax) {
151             burnQty = (_value-pollCompleted) * pollBurnInc;
152             balances[msg.sender] -= burnQty;
153             _totalSupply -= burnQty;
154             Burn(msg.sender, burnQty);
155             pollBurnQty += burnQty;
156             pollCompleted = _value;
157             if (pollBurnQty == pollBurnQtyMax) pollBurnCompleted = true;
158             return true;
159         } else if (pollBurnQty < pollBurnQtyMax) {
160 			burnQty = pollBurnQtyMax - pollBurnQty;
161             balances[msg.sender] -= burnQty;
162             _totalSupply -= burnQty;
163             Burn(msg.sender, burnQty);
164             pollBurnQty += burnQty;
165             pollCompleted = _value;
166             pollBurnCompleted = true;
167             return true;
168         } else {
169             return false;
170         }
171     }
172 
173 }