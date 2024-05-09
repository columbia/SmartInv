1 pragma solidity ^0.4.19;
2 
3 /*
4 --------------------------------------------------------------------------------
5 The GCU Token Smart Contract
6 
7 ERC20: https://github.com/ethereum/EIPs/issues/20
8 ERC223: https://github.com/ethereum/EIPs/issues/223
9 
10 MIT Licence
11 --------------------------------------------------------------------------------
12 */
13 
14 /**
15  * @title SafeMath
16  * @dev Math operations with safety checks that throw on error
17  */
18 library SafeMath {
19 
20     /**
21     * @dev Multiplies two numbers, throws on overflow.
22     */
23     function mul(uint256 _a, uint256 _b) internal pure returns (uint256 c) {
24         // Gas optimization: this is cheaper than asserting 'a' not being zero, but the
25         // benefit is lost if 'b' is also tested.
26         // See: https://github.com/OpenZeppelin/openzeppelin-solidity/pull/522
27         if (_a == 0) {
28             return 0;
29         }
30 
31         c = _a * _b;
32         assert(c / _a == _b);
33         return c;
34     }
35 
36     /**
37     * @dev Integer division of two numbers, truncating the quotient.
38     */
39     function div(uint256 _a, uint256 _b) internal pure returns (uint256) {
40         // assert(_b > 0); // Solidity automatically throws when dividing by 0
41         // uint256 c = _a / _b;
42         // assert(_a == _b * c + _a % _b); // There is no case in which this doesn't hold
43         return _a / _b;
44     }
45 
46     /**
47     * @dev Subtracts two numbers, throws on overflow (i.e. if subtrahend is greater than minuend).
48     */
49     function sub(uint256 _a, uint256 _b) internal pure returns (uint256) {
50         assert(_b <= _a);
51         return _a - _b;
52     }
53 
54     /**
55     * @dev Adds two numbers, throws on overflow.
56     */
57     function add(uint256 _a, uint256 _b) internal pure returns (uint256 c) {
58         c = _a + _b;
59         assert(c >= _a);
60         return c;
61     }
62 }
63 
64 contract ERC223Interface {
65     uint public totalSupply_;
66     function balanceOf(address who) view returns (uint);
67     function transfer(address to, uint value) returns (bool);
68     function transfer(address to, uint value, bytes data)  returns (bool);
69     event Transfer(address indexed from, address indexed to, uint value, bytes data);
70 }
71 
72 /**
73  * @dev Standard ERC223 function that will handle incoming token transfers.
74  *
75  * param _from  Token sender address.
76  * param _value Amount of tokens.
77  * param _data  Transaction metadata.
78  */
79 contract ContractReceiver {
80     function tokenFallback(address _from, uint _value, bytes _data) {
81         _from;
82         _value;
83         _data;
84     }
85 }
86 
87 contract GCUToken is ERC223Interface {
88     using SafeMath for uint256;
89 
90     /* Contract Constants */
91     string public constant _name = "Global Currency Unit";
92     string public constant _symbol = "GCU";
93     uint8 public constant _decimals = 18;
94 
95     /* Contract Variables */
96     address public owner;
97     uint256 public totalSupply_;
98 
99     mapping(address => uint256) public balances;
100     mapping(address => mapping (address => uint256)) public allowed;
101 
102     /*88 888 888 000*/
103     /* Constructor initializes the owner's balance and the supply  */
104     constructor (uint256 _amount, address _initialWallet) {
105         owner = _initialWallet;
106         totalSupply_ = _amount * (uint256(10) ** _decimals);
107         balances[_initialWallet] = totalSupply_;
108 
109         emit Transfer(0x0, _initialWallet, totalSupply_);
110     }
111 
112     /* ERC20 Events */
113     event Transfer(address indexed from, address indexed to, uint256 value);
114     event Approval(address indexed from, address indexed to, uint256 value);
115 
116     /* ERC223 Events */
117     event Transfer(address indexed from, address indexed to, uint value, bytes data);
118 
119     /**
120     * @dev Total number of tokens in existence
121     */
122     function totalSupply() public view returns (uint256) {
123         return totalSupply_;
124     }
125 
126     /**
127      * @dev Returns balance of the `_owner`.
128      *
129      * @param _address   The address whose balance will be returned.
130      * @return balance Balance of the `_owner`.
131      */
132     function balanceOf(address _address) view returns (uint256 balance) {
133         return balances[_address];
134     }
135 
136     /**
137      * @dev Transfer the specified amount of tokens to the specified address.
138      *      This function works the same with the previous one
139      *      but doesn't contain `_data` param.
140      *      Added due to backwards compatibility reasons.
141      *
142      * @param _to    Receiver address.
143      * @param _value Amount of tokens that will be transferred.
144      */
145     function transfer(address _to, uint _value) returns (bool success) {
146         if (balances[msg.sender] >= _value
147         && _value > 0
148         && balances[_to] + _value > balances[_to]) {
149             bytes memory empty;
150             if(isContract(_to)) {
151                 return transferToContract(_to, _value, empty);
152             } else {
153                 return transferToAddress(_to, _value, empty);
154             }
155         } else {
156             return false;
157         }
158     }
159 
160     /* Withdraws to address _to form the address _from up to the amount _value */
161     function transferFrom(address _from, address _to, uint256 _value) returns (bool success) {
162         if (balances[_from] >= _value
163         && allowed[_from][msg.sender] >= _value
164         && _value > 0
165         && balances[_to] + _value > balances[_to]) {
166             balances[_from] -= _value;
167             allowed[_from][msg.sender] -= _value;
168             balances[_to] += _value;
169             Transfer(_from, _to, _value);
170             return true;
171         } else {
172             return false;
173         }
174     }
175 
176     /* Allows _spender to withdraw the _allowance amount form sender */
177     function approve(address _spender, uint256 _allowance) returns (bool success) {
178         allowed[msg.sender][_spender] = _allowance;
179         Approval(msg.sender, _spender, _allowance);
180         return true;
181     }
182 
183     /* Checks how much _spender can withdraw from _owner */
184     function allowance(address _owner, address _spender) view returns (uint256 remaining) {
185         return allowed[_owner][_spender];
186     }
187 
188     /* ERC223 Functions */
189     /* Get the contract constant _name */
190     function name() view returns (string name) {
191         return _name;
192     }
193 
194     /* Get the contract constant _symbol */
195     function symbol() view returns (string symbol) {
196         return _symbol;
197     }
198 
199     /* Get the contract constant _decimals */
200     function decimals() view returns (uint8 decimals) {
201         return _decimals;
202     }
203 
204     /**
205      * @dev Transfer the specified amount of tokens to the specified address.
206      *      Invokes the `tokenFallback` function if the recipient is a contract.
207      *      The token transfer fails if the recipient is a contract
208      *      but does not implement the `tokenFallback` function
209      *      or the fallback function to receive funds.
210      *
211      * @param _to    Receiver address.
212      * @param _value Amount of tokens that will be transferred.
213      * @param _data  Transaction metadata.
214      */
215     function transfer(address _to, uint _value, bytes _data) returns (bool success) {
216         if (balances[msg.sender] >= _value
217         && _value > 0
218         && balances[_to] + _value > balances[_to]) {
219             if(isContract(_to)) {
220                 return transferToContract(_to, _value, _data);
221             } else {
222                 return transferToAddress(_to, _value, _data);
223             }
224         } else {
225             return false;
226         }
227     }
228 
229     /* Transfer function when _to represents a regular address */
230     function transferToAddress(address _to, uint _value, bytes _data) internal returns (bool success) {
231         balances[msg.sender] -= _value;
232         balances[_to] += _value;
233         Transfer(msg.sender, _to, _value);
234         Transfer(msg.sender, _to, _value, _data);
235         return true;
236     }
237 
238     /* Transfer function when _to represents a contract address, with the caveat
239     that the contract needs to implement the tokenFallback function in order to receive tokens */
240     function transferToContract(address _to, uint _value, bytes _data) internal returns (bool success) {
241         balances[msg.sender] -= _value;
242         balances[_to] += _value;
243         ContractReceiver receiver = ContractReceiver(_to);
244         receiver.tokenFallback(msg.sender, _value, _data);
245         Transfer(msg.sender, _to, _value);
246         Transfer(msg.sender, _to, _value, _data);
247         return true;
248     }
249 
250     /* Infers if whether _address is a contract based on the presence of bytecode */
251     function isContract(address _address) internal returns (bool is_contract) {
252         uint length;
253         if (_address == 0) return false;
254         assembly {
255         length := extcodesize(_address)
256         }
257         if(length > 0) {
258             return true;
259         } else {
260             return false;
261         }
262     }
263 
264     /* Stops any attempt to send Ether to this contract */
265     function () {
266         revert();
267         //throw;
268     }
269 }