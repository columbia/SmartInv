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
31 contract RoseCoin is ERC20Interface {
32     uint8 public constant decimals = 5;
33     string public constant symbol = "RSC";
34     string public constant name = "RoseCoin";
35 
36     uint public _level = 0;
37     bool public _selling = true;
38     uint public _totalSupply = 10 ** 14;
39     uint public _originalBuyPrice = 10 ** 10;
40     uint public _minimumBuyAmount = 10 ** 17;
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
51     uint public _icoSupply = _totalSupply;
52     uint[4] public ratio = [12, 10, 10, 13];
53     uint[4] public threshold = [95000000000000, 85000000000000, 0, 80000000000000];
54 
55     // Functions with this modifier can only be executed by the owner
56     modifier onlyOwner() {
57         if (msg.sender != owner) {
58             revert();
59         }
60         _;
61     }
62 
63     modifier onlyNotOwner() {
64         if (msg.sender == owner) {
65             revert();
66         }
67         _;
68     }
69 
70     modifier thresholdAll() {
71         if (!_selling || msg.value < _minimumBuyAmount || _icoSupply <= threshold[3]) { //
72             revert();
73         }
74         _;
75     }
76  
77     // Constructor
78     function RoseCoin() {
79         owner = msg.sender;
80         balances[owner] = _totalSupply;
81     }
82  
83     function totalSupply() constant returns (uint256) {
84         return _totalSupply;
85     }
86  
87     // What is the balance of a particular account?
88     function balanceOf(address _owner) constant returns (uint256) {
89         return balances[_owner];
90     }
91  
92     // Transfer the balance from sender's account to another account
93     function transfer(address _to, uint256 _amount) returns (bool) {
94         if (balances[msg.sender] >= _amount
95             && _amount > 0
96             && balances[_to] + _amount > balances[_to]) {
97             balances[msg.sender] -= _amount;
98             balances[_to] += _amount;
99             Transfer(msg.sender, _to, _amount);
100             return true;
101         } else {
102             return false;
103         }
104     }
105  
106     // Send _value amount of tokens from address _from to address _to
107     // The transferFrom method is used for a withdraw workflow, allowing contracts to send
108     // tokens on your behalf, for example to "deposit" to a contract address and/or to charge
109     // fees in sub-currencies; the command should fail unless the _from account has
110     // deliberately authorized the sender of the message via some mechanism; we propose
111     // these standardized APIs for approval:
112     function transferFrom(
113         address _from,
114         address _to,
115         uint256 _amount
116     ) returns (bool) {
117         if (balances[_from] >= _amount
118             && allowed[_from][msg.sender] >= _amount
119             && _amount > 0
120             && balances[_to] + _amount > balances[_to]) {
121             balances[_from] -= _amount;
122             allowed[_from][msg.sender] -= _amount;
123             balances[_to] += _amount;
124             Transfer(_from, _to, _amount);
125             return true;
126         } else {
127             return false;
128         }
129     }
130  
131     // Allow _spender to withdraw from your account, multiple times, up to the _value amount.
132     // If this function is called again it overwrites the current allowance with _value.
133     function approve(address _spender, uint256 _amount) returns (bool) {
134         allowed[msg.sender][_spender] = _amount;
135         Approval(msg.sender, _spender, _amount);
136         return true;
137     }
138  
139     function allowance(address _owner, address _spender) constant returns (uint256) {
140         return allowed[_owner][_spender];
141     }
142 
143 
144     function toggleSale() onlyOwner {
145         _selling = !_selling;
146     }
147 
148     function setBuyPrice(uint newBuyPrice) onlyOwner {
149         _originalBuyPrice = newBuyPrice;
150     }
151     
152     // Buy RoseCoin by sending Ether    
153     function buy() payable onlyNotOwner thresholdAll returns (uint256 amount) {
154         amount = 0;
155         uint remain = msg.value / _originalBuyPrice;
156         
157         while (remain > 0 && _level < 3) { //
158             remain = remain * ratio[_level] / ratio[_level+1];
159             if (_icoSupply <= remain + threshold[_level]) {
160                 remain = (remain + threshold[_level] - _icoSupply) * ratio[_level+1] / ratio[_level];
161                 amount += _icoSupply - threshold[_level];
162                 _icoSupply = threshold[_level];
163                 _level += 1;
164             }
165             else {
166                 _icoSupply -= remain;
167                 amount += remain;
168                 remain = 0;
169                 break;
170             }
171         }
172         
173         if (balances[owner] < amount)
174             revert();
175         
176         if (remain > 0) {
177             remain *= _originalBuyPrice;
178             msg.sender.transfer(remain);
179         }
180         
181         balances[owner] -= amount;
182         balances[msg.sender] += amount;
183         owner.transfer(msg.value - remain);
184         Transfer(owner, msg.sender, amount);
185         return amount;
186     }
187     
188     // Owner withdraws Ether in contract
189     function withdraw() onlyOwner returns (bool) {
190         return owner.send(this.balance);
191     }
192 }
193 
194 contract BuyRoseCoin {
195     
196     event Purchase(address _buyer, uint _value);
197     event TransferBack(address _buyer, uint _amount, uint _value);
198     RoseCoin roseCoin = RoseCoin(0x5c457eA26f82Df1FcA1a8844804a7A89F56dd5e5);
199     
200     function BuyRoseCoin() {}
201     
202     function() payable {
203         buy();
204     }
205     
206     function buy() payable {
207         roseCoin.buy.value(msg.value)();
208         Purchase(this, msg.value);
209         uint amount = roseCoin.balanceOf(this);
210         roseCoin.transfer(msg.sender, amount);
211         TransferBack(msg.sender, amount, this.balance);
212     }
213 }