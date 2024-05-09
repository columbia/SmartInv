1 pragma solidity ^0.4.11;
2 
3 /*
4 --------------------------------------------------------------------------------
5 The MobileGo [MGO] Token Smart Contract
6 
7 Credit:
8 Stefan Crnojević scrnojevic@protonmail.ch
9 MobileGo Inc, Game Credits Inc
10 
11 ERC20: https://github.com/ethereum/EIPs/issues/20
12 ERC223: https://github.com/ethereum/EIPs/issues/223
13 
14 MIT Licence
15 --------------------------------------------------------------------------------
16 */
17 
18 /*
19 * Contract that is working with ERC223 tokens
20 */
21 
22 contract ContractReceiver {
23   function tokenFallback(address _from, uint _value, bytes _data) {
24     /* Fix for Mist warning */
25     _from;
26     _value;
27     _data;
28   }
29 }
30 
31 
32 contract MobileGoToken {
33     /* Contract Constants */
34     string public constant _name = "MobileGo Token";
35     string public constant _symbol = "MGO";
36     uint8 public constant _decimals = 8;
37 
38     /* The supply is initially 100,000,000MGO to the precision of 8 decimals */
39     uint256 public constant _initialSupply = 10000000000000000;
40 
41     /* Contract Variables */
42     address public owner;
43     uint256 public _currentSupply;
44     mapping(address => uint256) public balances;
45     mapping(address => mapping (address => uint256)) public allowed;
46 
47     /* Constructor initializes the owner's balance and the supply  */
48     function MobileGoToken() {
49         owner = msg.sender;
50         _currentSupply = _initialSupply;
51         balances[owner] = _initialSupply;
52     }
53 
54     /* ERC20 Events */
55     event Transfer(address indexed from, address indexed to, uint256 value);
56     event Approval(address indexed from, address indexed to, uint256 value);
57 
58     /* ERC223 Events */
59     event Transfer(address indexed from, address indexed to, uint value, bytes data);
60 
61     /* Non-ERC Events */
62     event Burn(address indexed from, uint256 amount, uint256 currentSupply, bytes data);
63 
64     /* ERC20 Functions */
65     /* Return current supply in smallest denomination (1MGO = 100000000) */
66     function totalSupply() constant returns (uint256 totalSupply) {
67         return _initialSupply;
68     }
69 
70     /* Returns the balance of a particular account */
71     function balanceOf(address _address) constant returns (uint256 balance) {
72         return balances[_address];
73     }
74 
75     /* Transfer the balance from the sender's address to the address _to */
76     function transfer(address _to, uint _value) returns (bool success) {
77         if (balances[msg.sender] >= _value
78             && _value > 0
79             && balances[_to] + _value > balances[_to]) {
80             bytes memory empty;
81             if(isContract(_to)) {
82                 return transferToContract(_to, _value, empty);
83             } else {
84                 return transferToAddress(_to, _value, empty);
85             }
86         } else {
87             return false;
88         }
89     }
90 
91     /* Withdraws to address _to form the address _from up to the amount _value */
92     function transferFrom(address _from, address _to, uint256 _value) returns (bool success) {
93         if (balances[_from] >= _value
94             && allowed[_from][msg.sender] >= _value
95             && _value > 0
96             && balances[_to] + _value > balances[_to]) {
97             balances[_from] -= _value;
98             allowed[_from][msg.sender] -= _value;
99             balances[_to] += _value;
100             Transfer(_from, _to, _value);
101             return true;
102         } else {
103             return false;
104         }
105     }
106 
107     /* Allows _spender to withdraw the _allowance amount form sender */
108     function approve(address _spender, uint256 _allowance) returns (bool success) {
109         if (_allowance <= _currentSupply) {
110             allowed[msg.sender][_spender] = _allowance;
111             Approval(msg.sender, _spender, _allowance);
112             return true;
113         } else {
114             return false;
115         }
116     }
117 
118     /* Checks how much _spender can withdraw from _owner */
119     function allowance(address _owner, address _spender) constant returns (uint256 remaining) {
120         return allowed[_owner][_spender];
121     }
122 
123     /* ERC223 Functions */
124     /* Get the contract constant _name */
125     function name() constant returns (string name) {
126         return _name;
127     }
128 
129     /* Get the contract constant _symbol */
130     function symbol() constant returns (string symbol) {
131         return _symbol;
132     }
133 
134     /* Get the contract constant _decimals */
135     function decimals() constant returns (uint8 decimals) {
136         return _decimals;
137     }
138 
139     /* Transfer the balance from the sender's address to the address _to with data _data */
140     function transfer(address _to, uint _value, bytes _data) returns (bool success) {
141         if (balances[msg.sender] >= _value
142             && _value > 0
143             && balances[_to] + _value > balances[_to]) {
144             if(isContract(_to)) {
145                 return transferToContract(_to, _value, _data);
146             } else {
147                 return transferToAddress(_to, _value, _data);
148             }
149         } else {
150             return false;
151         }
152     }
153 
154     /* Transfer function when _to represents a regular address */
155     function transferToAddress(address _to, uint _value, bytes _data) internal returns (bool success) {
156         balances[msg.sender] -= _value;
157         balances[_to] += _value;
158         Transfer(msg.sender, _to, _value);
159         Transfer(msg.sender, _to, _value, _data);
160         return true;
161     }
162 
163     /* Transfer function when _to represents a contract address, with the caveat
164     that the contract needs to implement the tokenFallback function in order to receive tokens */
165     function transferToContract(address _to, uint _value, bytes _data) internal returns (bool success) {
166         balances[msg.sender] -= _value;
167         balances[_to] += _value;
168         ContractReceiver receiver = ContractReceiver(_to);
169         receiver.tokenFallback(msg.sender, _value, _data);
170         Transfer(msg.sender, _to, _value);
171         Transfer(msg.sender, _to, _value, _data);
172         return true;
173     }
174 
175     /* Infers if whether _address is a contract based on the presence of bytecode */
176     function isContract(address _address) internal returns (bool is_contract) {
177         uint length;
178         if (_address == 0) return false;
179         assembly {
180             length := extcodesize(_address)
181         }
182         if(length > 0) {
183             return true;
184         } else {
185             return false;
186         }
187     }
188 
189     /* Non-ERC Functions */
190     /* Remove the specified amount of the tokens from the supply permanently */
191     function burn(uint256 _value, bytes _data) returns (bool success) {
192         if (balances[msg.sender] >= _value
193             && _value > 0) {
194             balances[msg.sender] -= _value;
195             _currentSupply -= _value;
196             Burn(msg.sender, _value, _currentSupply, _data);
197             return true;
198         } else {
199             return false;
200         }
201     }
202 
203     /* Returns the total amount of tokens in supply */
204     function currentSupply() constant returns (uint256 currentSupply) {
205         return _currentSupply;
206     }
207 
208     /* Returns the total amount of tokens ever burned */
209     function amountBurned() constant returns (uint256 amountBurned) {
210         return _initialSupply - _currentSupply;
211     }
212 
213     /* Stops any attempt to send Ether to this contract */
214     function () {
215         throw;
216     }
217 }