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
42    
43     // Owner of this contract
44     address public owner;
45  
46     // Balances for each account
47     mapping(address => uint256) balances;
48  
49     // Owner of account approves the transfer of an amount to another account
50     mapping(address => mapping (address => uint256)) allowed;
51 
52     // Functions with this modifier can only be executed by the owner
53     modifier onlyOwner() {
54         if (msg.sender != owner) {
55             revert();
56         }
57         _;
58     }
59 
60     modifier thresholdTwo() {
61         if (msg.value < _minimumBuyAmount || balances[owner] <= _thresholdTwo) {
62             revert();
63         }
64         _;
65     }
66  
67     // Constructor
68     function DatCoin() {
69         owner = msg.sender;
70         balances[owner] = _totalSupply;
71     }
72  
73     function totalSupply() constant returns (uint256) {
74         return _totalSupply;
75     }
76  
77     // What is the balance of a particular account?
78     function balanceOf(address _owner) constant returns (uint256) {
79         return balances[_owner];
80     }
81  
82     // Transfer the balance from sender's account to another account
83     function transfer(address _to, uint256 _amount) returns (bool) {
84         if (balances[msg.sender] >= _amount
85             && _amount > 0
86             && balances[_to] + _amount > balances[_to]) {
87             balances[msg.sender] -= _amount;
88             balances[_to] += _amount;
89             Transfer(msg.sender, _to, _amount);
90             return true;
91         } else {
92             return false;
93         }
94     }
95  
96     // Send _value amount of tokens from address _from to address _to
97     // The transferFrom method is used for a withdraw workflow, allowing contracts to send
98     // tokens on your behalf, for example to "deposit" to a contract address and/or to charge
99     // fees in sub-currencies; the command should fail unless the _from account has
100     // deliberately authorized the sender of the message via some mechanism; we propose
101     // these standardized APIs for approval:
102     function transferFrom(
103         address _from,
104         address _to,
105         uint256 _amount
106     ) returns (bool) {
107         if (balances[_from] >= _amount
108             && allowed[_from][msg.sender] >= _amount
109             && _amount > 0
110             && balances[_to] + _amount > balances[_to]) {
111             balances[_from] -= _amount;
112             allowed[_from][msg.sender] -= _amount;
113             balances[_to] += _amount;
114             Transfer(_from, _to, _amount);
115             return true;
116         } else {
117             return false;
118         }
119     }
120  
121     // Allow _spender to withdraw from your account, multiple times, up to the _value amount.
122     // If this function is called again it overwrites the current allowance with _value.
123     function approve(address _spender, uint256 _amount) returns (bool) {
124         allowed[msg.sender][_spender] = _amount;
125         Approval(msg.sender, _spender, _amount);
126         return true;
127     }
128  
129     function allowance(address _owner, address _spender) constant returns (uint256) {
130         return allowed[_owner][_spender];
131     }
132 	
133 	// Buy RoseCoin by sending Ether
134     function buy() payable thresholdTwo returns (uint256 amount) {
135         uint value = msg.value;
136         amount = value / _originalBuyPrice;
137         
138         if (balances[owner] <= _thresholdOne + amount) {
139             uint temp = 0;
140             if (balances[owner] > _thresholdOne)
141                 temp = balances[owner] - _thresholdOne;
142             amount = temp + (amount - temp) * 10 / 13;
143             if (balances[owner] < amount) {
144                 temp = (amount - balances[owner]) * (_originalBuyPrice * 13 / 10);
145                 msg.sender.transfer(temp);
146                 amount = balances[owner];
147                 value -= temp;
148             }
149         }
150 
151         owner.transfer(value);
152         balances[msg.sender] += amount;
153         balances[owner] -= amount;
154         Transfer(owner, msg.sender, amount);
155         return amount;
156     }
157 	
158 	// Owner withdraws Ether in contract
159     function withdraw() onlyOwner returns (bool) {
160         return owner.send(this.balance);
161     }
162 }