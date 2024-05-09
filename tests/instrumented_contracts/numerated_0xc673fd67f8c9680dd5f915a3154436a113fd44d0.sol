1 pragma solidity ^0.4.11;
2 
3 /*
4 --------------------------------------------------------------------------------
5 
6 ERC20: https://github.com/ethereum/EIPs/issues/20
7 ERC223: https://github.com/ethereum/EIPs/issues/223
8 
9 MIT Licence
10 --------------------------------------------------------------------------------
11 */
12 
13 /*
14 * Contract that is working with ERC223 tokens
15 */
16 
17 contract ContractReceiver {
18   function tokenFallback(address _from, uint _value, bytes _data) {
19     /* Fix for Mist warning */
20     _from;
21     _value;
22     _data;
23   }
24 }
25 
26 
27 contract FLTToken {
28     /* Contract Constants */
29     string public constant _name = "FLTcoin";
30     string public constant _symbol = "FLT";
31     uint8 public constant _decimals = 8;
32 
33     /* The supply is initially 100,000,000MGO to the precision of 8 decimals */
34     uint256 public constant _initialSupply = 49800000000000000;
35 
36     /* Contract Variables */
37     address public owner;
38     uint256 public _currentSupply;
39     mapping(address => uint256) public balances;
40     mapping(address => mapping (address => uint256)) public allowed;
41 
42     /* Constructor initializes the owner's balance and the supply  */
43     function FLTToken() {
44         owner = msg.sender;
45         _currentSupply = _initialSupply;
46         balances[owner] = _initialSupply;
47     }
48 
49     /* ERC20 Events */
50     event Transfer(address indexed from, address indexed to, uint256 value);
51     event Approval(address indexed from, address indexed to, uint256 value);
52 
53     /* ERC223 Events */
54     event Transfer(address indexed from, address indexed to, uint value, bytes data);
55 
56     /* Non-ERC Events */
57     event Burn(address indexed from, uint256 amount, uint256 currentSupply, bytes data);
58 
59     /* ERC20 Functions */
60     /* Return current supply in smallest denomination (1MGO = 100000000) */
61     function totalSupply() constant returns (uint256 totalSupply) {
62         return _initialSupply;
63     }
64 
65     /* Returns the balance of a particular account */
66     function balanceOf(address _address) constant returns (uint256 balance) {
67         return balances[_address];
68     }
69 
70     /* Transfer the balance from the sender's address to the address _to */
71     function transfer(address _to, uint _value) returns (bool success) {
72         if (balances[msg.sender] >= _value
73             && _value > 0
74             && balances[_to] + _value > balances[_to]) {
75             bytes memory empty;
76             if(isContract(_to)) {
77                 return transferToContract(_to, _value, empty);
78             } else {
79                 return transferToAddress(_to, _value, empty);
80             }
81         } else {
82             return false;
83         }
84     }
85 
86     /* Withdraws to address _to form the address _from up to the amount _value */
87     function transferFrom(address _from, address _to, uint256 _value) returns (bool success) {
88         if (balances[_from] >= _value
89             && allowed[_from][msg.sender] >= _value
90             && _value > 0
91             && balances[_to] + _value > balances[_to]) {
92             balances[_from] -= _value;
93             allowed[_from][msg.sender] -= _value;
94             balances[_to] += _value;
95             Transfer(_from, _to, _value);
96             return true;
97         } else {
98             return false;
99         }
100     }
101 
102     /* Allows _spender to withdraw the _allowance amount form sender */
103     function approve(address _spender, uint256 _allowance) returns (bool success) {
104         if (_allowance <= _currentSupply) {
105             allowed[msg.sender][_spender] = _allowance;
106             Approval(msg.sender, _spender, _allowance);
107             return true;
108         } else {
109             return false;
110         }
111     }
112 
113     /* Checks how much _spender can withdraw from _owner */
114     function allowance(address _owner, address _spender) constant returns (uint256 remaining) {
115         return allowed[_owner][_spender];
116     }
117 
118     /* ERC223 Functions */
119     /* Get the contract constant _name */
120     function name() constant returns (string name) {
121         return _name;
122     }
123 
124     /* Get the contract constant _symbol */
125     function symbol() constant returns (string symbol) {
126         return _symbol;
127     }
128 
129     /* Get the contract constant _decimals */
130     function decimals() constant returns (uint8 decimals) {
131         return _decimals;
132     }
133 
134     /* Transfer the balance from the sender's address to the address _to with data _data */
135     function transfer(address _to, uint _value, bytes _data) returns (bool success) {
136         if (balances[msg.sender] >= _value
137             && _value > 0
138             && balances[_to] + _value > balances[_to]) {
139             if(isContract(_to)) {
140                 return transferToContract(_to, _value, _data);
141             } else {
142                 return transferToAddress(_to, _value, _data);
143             }
144         } else {
145             return false;
146         }
147     }
148 
149     /* Transfer function when _to represents a regular address */
150     function transferToAddress(address _to, uint _value, bytes _data) internal returns (bool success) {
151         balances[msg.sender] -= _value;
152         balances[_to] += _value;
153         Transfer(msg.sender, _to, _value);
154         Transfer(msg.sender, _to, _value, _data);
155         return true;
156     }
157 
158     /* Transfer function when _to represents a contract address, with the caveat
159     that the contract needs to implement the tokenFallback function in order to receive tokens */
160     function transferToContract(address _to, uint _value, bytes _data) internal returns (bool success) {
161         balances[msg.sender] -= _value;
162         balances[_to] += _value;
163         ContractReceiver receiver = ContractReceiver(_to);
164         receiver.tokenFallback(msg.sender, _value, _data);
165         Transfer(msg.sender, _to, _value);
166         Transfer(msg.sender, _to, _value, _data);
167         return true;
168     }
169 
170     /* Infers if whether _address is a contract based on the presence of bytecode */
171     function isContract(address _address) internal returns (bool is_contract) {
172         uint length;
173         if (_address == 0) return false;
174         assembly {
175             length := extcodesize(_address)
176         }
177         if(length > 0) {
178             return true;
179         } else {
180             return false;
181         }
182     }
183 
184     /* Non-ERC Functions */
185     /* Remove the specified amount of the tokens from the supply permanently */
186     function burn(uint256 _value, bytes _data) returns (bool success) {
187         if (balances[msg.sender] >= _value
188             && _value > 0) {
189             balances[msg.sender] -= _value;
190             _currentSupply -= _value;
191             Burn(msg.sender, _value, _currentSupply, _data);
192             return true;
193         } else {
194             return false;
195         }
196     }
197 
198     /* Returns the total amount of tokens in supply */
199     function currentSupply() constant returns (uint256 currentSupply) {
200         return _currentSupply;
201     }
202 
203     /* Returns the total amount of tokens ever burned */
204     function amountBurned() constant returns (uint256 amountBurned) {
205         return _initialSupply - _currentSupply;
206     }
207 
208     /* Stops any attempt to send Ether to this contract */
209     function () {
210         throw;
211     }
212 }