1 pragma solidity ^0.4.11;
2 
3 contract ERC20Interface {
4     // Get the total token supply
5     function totalSupply() constant returns (uint256);
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
24     // Triggered when tokens are transferred.
25     event Transfer(address indexed _from, address indexed _to, uint256 _value);
26  
27     // Triggered whenever approve(address _spender, uint256 _value) is called.
28     event Approval(address indexed _owner, address indexed _spender, uint256 _value);
29 }
30  
31 contract DatCoin is ERC20Interface {
32     uint8 public constant decimals = 5;
33     string public constant symbol = "DTC";
34     string public constant name = "DatCoin";
35 
36     uint public _totalSupply = 10 ** 14;
37     uint public _originalBuyPrice = 10 ** 10;
38     uint public _minimumBuyAmount = 10 ** 17;
39     uint public _thresholdOne = 9 * (10 ** 13);
40     uint public _thresholdTwo = 85 * (10 ** 12);
41    
42     // Owner of this contract
43     address public owner;
44  
45     // Balances for each account
46     mapping(address => uint256) balances;
47  
48     // Owner of account approves the transfer of an amount to another account
49     mapping(address => mapping (address => uint256)) allowed;
50 
51     // Functions with this modifier can only be executed by the owner
52     modifier onlyOwner() {
53         if (msg.sender != owner) {
54             revert();
55         }
56         _;
57     }
58 
59     modifier thresholdTwo() {
60         if (msg.value < _minimumBuyAmount || balances[owner] <= _thresholdTwo) {
61             revert();
62         }
63         _;
64     }
65  
66     // Constructor
67     function DatCoin() {
68         owner = msg.sender;
69         balances[owner] = _totalSupply;
70     }
71  
72     function totalSupply() constant returns (uint256) {
73         return _totalSupply;
74     }
75  
76     // What is the balance of a particular account?
77     function balanceOf(address _owner) constant returns (uint256) {
78         return balances[_owner];
79     }
80  
81     // Transfer the balance from sender's account to another account
82     function transfer(address _to, uint256 _amount) returns (bool) {
83         if (balances[msg.sender] >= _amount
84             && _amount > 0
85             && balances[_to] + _amount > balances[_to]) {
86             balances[msg.sender] -= _amount;
87             balances[_to] += _amount;
88             Transfer(msg.sender, _to, _amount);
89             return true;
90         } else {
91             return false;
92         }
93     }
94  
95     // Send _value amount of tokens from address _from to address _to
96     // The transferFrom method is used for a withdraw workflow, allowing contracts to send
97     // tokens on your behalf, for example to "deposit" to a contract address and/or to charge
98     // fees in sub-currencies; the command should fail unless the _from account has
99     // deliberately authorized the sender of the message via some mechanism; we propose
100     // these standardized APIs for approval:
101     function transferFrom(
102         address _from,
103         address _to,
104         uint256 _amount
105     ) returns (bool) {
106         if (balances[_from] >= _amount
107             && allowed[_from][msg.sender] >= _amount
108             && _amount > 0
109             && balances[_to] + _amount > balances[_to]) {
110             balances[_from] -= _amount;
111             allowed[_from][msg.sender] -= _amount;
112             balances[_to] += _amount;
113             Transfer(_from, _to, _amount);
114             return true;
115         } else {
116             return false;
117         }
118     }
119  
120     // Allow _spender to withdraw from your account, multiple times, up to the _value amount.
121     // If this function is called again it overwrites the current allowance with _value.
122     function approve(address _spender, uint256 _amount) returns (bool) {
123         allowed[msg.sender][_spender] = _amount;
124         Approval(msg.sender, _spender, _amount);
125         return true;
126     }
127  
128     function allowance(address _owner, address _spender) constant returns (uint256) {
129         return allowed[_owner][_spender];
130     }
131     
132     // Buy DatCoin by sending Ether
133     function buy() payable thresholdTwo returns (uint256 amount) {
134         uint value = msg.value;
135         amount = value / _originalBuyPrice;
136         
137         if (balances[owner] <= _thresholdOne + amount) {
138             uint temp = 0;
139             if (balances[owner] > _thresholdOne)
140                 temp = balances[owner] - _thresholdOne;
141             amount = temp + (amount - temp) * 10 / 13;
142             if (balances[owner] < amount) {
143                 temp = (amount - balances[owner]) * (_originalBuyPrice * 13 / 10);
144                 msg.sender.transfer(temp);
145                 amount = balances[owner];
146                 value -= temp;
147             }
148         }
149 
150         owner.transfer(value);
151         balances[msg.sender] += amount;
152         balances[owner] -= amount;
153         Transfer(owner, msg.sender, amount);
154         return amount;
155     }
156     
157     // Owner withdraws Ether in contract
158     function withdraw() onlyOwner returns (bool) {
159         return owner.send(this.balance);
160     }
161 }