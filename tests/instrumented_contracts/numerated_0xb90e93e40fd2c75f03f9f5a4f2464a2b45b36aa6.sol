1 pragma solidity ^ 0.4 .11;
2 
3 contract ContractReceiver {
4     function tokenFallback(address _from, uint _value, bytes _data) {
5         _from;
6         _value;
7         _data;
8     }
9 }
10 
11 contract MYC {
12     /* Contract Constants */
13     string public constant _name = "MYC";
14     string public constant _symbol = "MYC";
15     uint8 public constant _decimals = 8;
16 
17     uint256 public constant _initialSupply = 36500000000000000;
18 
19     /* Contract Variables */
20     address public owner;
21     uint256 public _currentSupply;
22     mapping(address => uint256) public balances;
23     mapping(address => mapping(address => uint256)) public allowed;
24 
25     function MYC() {
26         owner = msg.sender;
27         _currentSupply = _initialSupply;
28         balances[owner] = _initialSupply;
29     }
30 
31     /* ERC20 Events */
32     event Transfer(address indexed from, address indexed to, uint256 value);
33     event Approval(address indexed from, address indexed to, uint256 value);
34 
35     /* ERC223 Events */
36     event Transfer(address indexed from, address indexed to, uint value, bytes data);
37 
38     /* Non-ERC Events */
39     event Burn(address indexed from, uint256 amount, uint256 currentSupply, bytes data);
40 
41     function totalSupply() constant returns(uint256 totalSupply) {
42         return _initialSupply;
43     }
44 
45     /* Returns the balance of a particular account */
46     function balanceOf(address _address) constant returns(uint256 balance) {
47         return balances[_address];
48     }
49 
50     /* Transfer the balance from the sender's address to the address _to */
51     function transfer(address _to, uint _value) returns(bool success) {
52         if (balances[msg.sender] >= _value &&
53             _value > 0 &&
54             balances[_to] + _value > balances[_to]) {
55             bytes memory empty;
56             if (isContract(_to)) {
57                 return transferToContract(_to, _value, empty);
58             } else {
59                 return transferToAddress(_to, _value, empty);
60             }
61         } else {
62             return false;
63         }
64     }
65 
66     /* Withdraws to address _to form the address _from up to the amount _value */
67     function transferFrom(address _from, address _to, uint256 _value) returns(bool success) {
68         if (balances[_from] >= _value &&
69             allowed[_from][msg.sender] >= _value &&
70             _value > 0 &&
71             balances[_to] + _value > balances[_to]) {
72             balances[_from] -= _value;
73             allowed[_from][msg.sender] -= _value;
74             balances[_to] += _value;
75             Transfer(_from, _to, _value);
76             return true;
77         } else {
78             return false;
79         }
80     }
81 
82     /* Allows _spender to withdraw the _allowance amount form sender */
83     function approve(address _spender, uint256 _allowance) returns(bool success) {
84         if (_allowance <= _currentSupply) {
85             allowed[msg.sender][_spender] = _allowance;
86             Approval(msg.sender, _spender, _allowance);
87             return true;
88         } else {
89             return false;
90         }
91     }
92 
93     /* Checks how much _spender can withdraw from _owner */
94     function allowance(address _owner, address _spender) constant returns(uint256 remaining) {
95         return allowed[_owner][_spender];
96     }
97 
98     /* ERC223 Functions */
99     /* Get the contract constant _name */
100     function name() constant returns(string name) {
101         return _name;
102     }
103 
104     /* Get the contract constant _symbol */
105     function symbol() constant returns(string symbol) {
106         return _symbol;
107     }
108 
109     /* Get the contract constant _decimals */
110     function decimals() constant returns(uint8 decimals) {
111         return _decimals;
112     }
113 
114     /* Transfer the balance from the sender's address to the address _to with data _data */
115     function transfer(address _to, uint _value, bytes _data) returns(bool success) {
116         if (balances[msg.sender] >= _value &&
117             _value > 0 &&
118             balances[_to] + _value > balances[_to]) {
119             if (isContract(_to)) {
120                 return transferToContract(_to, _value, _data);
121             } else {
122                 return transferToAddress(_to, _value, _data);
123             }
124         } else {
125             return false;
126         }
127     }
128 
129     /* Transfer function when _to represents a regular address */
130     function transferToAddress(address _to, uint _value, bytes _data) internal returns(bool success) {
131         balances[msg.sender] -= _value;
132         balances[_to] += _value;
133         Transfer(msg.sender, _to, _value);
134         Transfer(msg.sender, _to, _value, _data);
135         return true;
136     }
137 
138     /* Transfer function when _to represents a contract address, with the caveat
139     that the contract needs to implement the tokenFallback function in order to receive tokens */
140     function transferToContract(address _to, uint _value, bytes _data) internal returns(bool success) {
141         balances[msg.sender] -= _value;
142         balances[_to] += _value;
143         ContractReceiver receiver = ContractReceiver(_to);
144         receiver.tokenFallback(msg.sender, _value, _data);
145         Transfer(msg.sender, _to, _value);
146         Transfer(msg.sender, _to, _value, _data);
147         return true;
148     }
149 
150     /* Infers if whether _address is a contract based on the presence of bytecode */
151     function isContract(address _address) internal returns(bool is_contract) {
152         uint length;
153         if (_address == 0) return false;
154         assembly {
155             length: = extcodesize(_address)
156         }
157         if (length > 0) {
158             return true;
159         } else {
160             return false;
161         }
162     }
163 
164     /* Non-ERC Functions */
165     /* Remove the specified amount of the tokens from the supply permanently */
166     function burn(uint256 _value, bytes _data) returns(bool success) {
167         if (balances[msg.sender] >= _value &&
168             _value > 0) {
169             balances[msg.sender] -= _value;
170             _currentSupply -= _value;
171             Burn(msg.sender, _value, _currentSupply, _data);
172             return true;
173         } else {
174             return false;
175         }
176     }
177 
178     /* Returns the total amount of tokens in supply */
179     function currentSupply() constant returns(uint256 currentSupply) {
180         return _currentSupply;
181     }
182 
183     /* Returns the total amount of tokens ever burned */
184     function amountBurned() constant returns(uint256 amountBurned) {
185         return _initialSupply - _currentSupply;
186     }
187 
188     /* Stops any attempt to send Ether to this contract */
189     function() {
190         throw;
191     }
192 }