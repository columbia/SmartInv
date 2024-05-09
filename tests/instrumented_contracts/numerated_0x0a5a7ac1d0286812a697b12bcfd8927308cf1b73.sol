1 pragma solidity ^0.4.11;
2 
3 /*
4 --------------------------------------------------------------------------------
5 The TBBT [TBBT] Token Smart Contract
6 
7 Credit:
8 Stefan Crnojević scrnojevic@protonmail.ch
9 TBBT Inc, Game Credits Inc
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
31 contract TBBToken {
32     /* Contract Constants */
33     string public constant _name = "TBBT Token";
34     string public constant _symbol = "TBBT";
35     uint8 public constant _decimals = 8;
36 
37     /* The supply is initially 500,000,000TBBT to the precision of 8 decimals */
38     uint256 public constant _initialSupply = 50000000000000000;
39 
40     /* Contract Variables */
41     address public owner;
42     uint256 public _currentSupply;
43     mapping(address => uint256) public balances;
44     mapping(address => mapping (address => uint256)) public allowed;
45 
46     /* Constructor initializes the owner's balance and the supply  */
47     function TBBToken() {
48         owner = msg.sender;
49         _currentSupply = _initialSupply;
50         balances[owner] = _initialSupply;
51     }
52 
53     /* ERC20 Events */
54     event Transfer(address indexed from, address indexed to, uint256 value);
55     event Approval(address indexed from, address indexed to, uint256 value);
56 
57     /* ERC223 Events */
58     event Transfer(address indexed from, address indexed to, uint value, bytes data);
59 
60     /* Non-ERC Events */
61     event Burn(address indexed from, uint256 amount, uint256 currentSupply, bytes data);
62 
63     /* ERC20 Functions */
64     /* Return current supply in smallest denomination (1TBBT = 100000000) */
65     function totalSupply() constant returns (uint256 totalSupply) {
66         return _initialSupply;
67     }
68 
69     /* Returns the balance of a particular account */
70     function balanceOf(address _address) constant returns (uint256 balance) {
71         return balances[_address];
72     }
73 
74     /* Transfer the balance from the sender's address to the address _to */
75     function transfer(address _to, uint _value) returns (bool success) {
76         if (balances[msg.sender] >= _value
77             && _value > 0
78             && balances[_to] + _value > balances[_to]) {
79             bytes memory empty;
80             if(isContract(_to)) {
81                 return transferToContract(_to, _value, empty);
82             } else {
83                 return transferToAddress(_to, _value, empty);
84             }
85         } else {
86             return false;
87         }
88     }
89 
90     /* Withdraws to address _to form the address _from up to the amount _value */
91     function transferFrom(address _from, address _to, uint256 _value) returns (bool success) {
92         if (balances[_from] >= _value
93             && allowed[_from][msg.sender] >= _value
94             && _value > 0
95             && balances[_to] + _value > balances[_to]) {
96             balances[_from] -= _value;
97             allowed[_from][msg.sender] -= _value;
98             balances[_to] += _value;
99             Transfer(_from, _to, _value);
100             return true;
101         } else {
102             return false;
103         }
104     }
105 
106     /* Allows _spender to withdraw the _allowance amount form sender */
107     function approve(address _spender, uint256 _allowance) returns (bool success) {
108         if (_allowance <= _currentSupply) {
109             allowed[msg.sender][_spender] = _allowance;
110             Approval(msg.sender, _spender, _allowance);
111             return true;
112         } else {
113             return false;
114         }
115     }
116 
117     /* Checks how much _spender can withdraw from _owner */
118     function allowance(address _owner, address _spender) constant returns (uint256 remaining) {
119         return allowed[_owner][_spender];
120     }
121 
122     /* ERC223 Functions */
123     /* Get the contract constant _name */
124     function name() constant returns (string name) {
125         return _name;
126     }
127 
128     /* Get the contract constant _symbol */
129     function symbol() constant returns (string symbol) {
130         return _symbol;
131     }
132 
133     /* Get the contract constant _decimals */
134     function decimals() constant returns (uint8 decimals) {
135         return _decimals;
136     }
137 
138     /* Transfer the balance from the sender's address to the address _to with data _data */
139     function transfer(address _to, uint _value, bytes _data) returns (bool success) {
140         if (balances[msg.sender] >= _value
141             && _value > 0
142             && balances[_to] + _value > balances[_to]) {
143             if(isContract(_to)) {
144                 return transferToContract(_to, _value, _data);
145             } else {
146                 return transferToAddress(_to, _value, _data);
147             }
148         } else {
149             return false;
150         }
151     }
152 
153     /* Transfer function when _to represents a regular address */
154     function transferToAddress(address _to, uint _value, bytes _data) internal returns (bool success) {
155         balances[msg.sender] -= _value;
156         balances[_to] += _value;
157         Transfer(msg.sender, _to, _value);
158         Transfer(msg.sender, _to, _value, _data);
159         return true;
160     }
161 
162     /* Transfer function when _to represents a contract address, with the caveat
163     that the contract needs to implement the tokenFallback function in order to receive tokens */
164     function transferToContract(address _to, uint _value, bytes _data) internal returns (bool success) {
165         balances[msg.sender] -= _value;
166         balances[_to] += _value;
167         ContractReceiver receiver = ContractReceiver(_to);
168         receiver.tokenFallback(msg.sender, _value, _data);
169         Transfer(msg.sender, _to, _value);
170         Transfer(msg.sender, _to, _value, _data);
171         return true;
172     }
173 
174     /* Infers if whether _address is a contract based on the presence of bytecode */
175     function isContract(address _address) internal returns (bool is_contract) {
176         uint length;
177         if (_address == 0) return false;
178         assembly {
179             length := extcodesize(_address)
180         }
181         if(length > 0) {
182             return true;
183         } else {
184             return false;
185         }
186     }
187 
188     /* Non-ERC Functions */
189     /* Remove the specified amount of the tokens from the supply permanently */
190     function burn(uint256 _value, bytes _data) returns (bool success) {
191         if (balances[msg.sender] >= _value
192             && _value > 0) {
193             balances[msg.sender] -= _value;
194             _currentSupply -= _value;
195             Burn(msg.sender, _value, _currentSupply, _data);
196             return true;
197         } else {
198             return false;
199         }
200     }
201 
202     /* Returns the total amount of tokens in supply */
203     function currentSupply() constant returns (uint256 currentSupply) {
204         return _currentSupply;
205     }
206 
207     /* Returns the total amount of tokens ever burned */
208     function amountBurned() constant returns (uint256 amountBurned) {
209         return _initialSupply - _currentSupply;
210     }
211 
212     /* Stops any attempt to send Ether to this contract */
213     function () {
214         throw;
215     }
216 }