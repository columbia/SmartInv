1 pragma solidity ^0.4.2;
2 /**
3  * @title Contract for object that have an owner
4  */
5 contract Owned {
6     /**
7      * Contract owner address
8      */
9     address public owner;
10 
11     /**
12      * @dev Store owner on creation
13      */
14     function Owned() { owner = msg.sender; }
15 
16     /**
17      * @dev Delegate contract to another person
18      * @param _owner is another person address
19      */
20     function delegate(address _owner) onlyOwner
21     { owner = _owner; }
22 
23     /**
24      * @dev Owner check modifier
25      */
26     modifier onlyOwner { if (msg.sender != owner) throw; _; }
27 }
28 /**
29  * @title Token contract represents any asset in digital economy
30  */
31 contract Token is Owned {
32     event Transfer(address indexed _from,  address indexed _to,      uint256 _value);
33     event Approval(address indexed _owner, address indexed _spender, uint256 _value);
34 
35     /* Short description of token */
36     string public name;
37     string public symbol;
38 
39     /* Total count of tokens exist */
40     uint public totalSupply;
41 
42     /* Fixed point position */
43     uint8 public decimals;
44     
45     /* Token approvement system */
46     mapping(address => uint) public balanceOf;
47     mapping(address => mapping(address => uint)) public allowance;
48  
49     /**
50      * @return available balance of `sender` account (self balance)
51      */
52     function getBalance() constant returns (uint)
53     { return balanceOf[msg.sender]; }
54  
55     /**
56      * @dev This method returns non zero result when sender is approved by
57      *      argument address and target address have non zero self balance
58      * @param _address target address 
59      * @return available for `sender` balance of given address
60      */
61     function getBalance(address _address) constant returns (uint) {
62         return allowance[_address][msg.sender]
63              > balanceOf[_address] ? balanceOf[_address]
64                                    : allowance[_address][msg.sender];
65     }
66  
67     /* Token constructor */
68     function Token(string _name, string _symbol, uint8 _decimals, uint _count) {
69         name     = _name;
70         symbol   = _symbol;
71         decimals = _decimals;
72         totalSupply           = _count;
73         balanceOf[msg.sender] = _count;
74     }
75  
76     /**
77      * @dev Transfer self tokens to given address
78      * @param _to destination address
79      * @param _value amount of token values to send
80      * @notice `_value` tokens will be sended to `_to`
81      * @return `true` when transfer done
82      */
83     function transfer(address _to, uint _value) returns (bool) {
84         if (balanceOf[msg.sender] >= _value) {
85             balanceOf[msg.sender] -= _value;
86             balanceOf[_to]        += _value;
87             Transfer(msg.sender, _to, _value);
88             return true;
89         }
90         return false;
91     }
92 
93     /**
94      * @dev Transfer with approvement mechainsm
95      * @param _from source address, `_value` tokens shold be approved for `sender`
96      * @param _to destination address
97      * @param _value amount of token values to send 
98      * @notice from `_from` will be sended `_value` tokens to `_to`
99      * @return `true` when transfer is done
100      */
101     function transferFrom(address _from, address _to, uint _value) returns (bool) {
102         var avail = allowance[_from][msg.sender]
103                   > balanceOf[_from] ? balanceOf[_from]
104                                      : allowance[_from][msg.sender];
105         if (avail >= _value) {
106             allowance[_from][msg.sender] -= _value;
107             balanceOf[_from] -= _value;
108             balanceOf[_to]   += _value;
109             Transfer(_from, _to, _value);
110             return true;
111         }
112         return false;
113     }
114 
115     /**
116      * @dev Give to target address ability for self token manipulation without sending
117      * @param _address target address
118      * @param _value amount of token values for approving
119      */
120     function approve(address _address, uint _value) {
121         allowance[msg.sender][_address] += _value;
122         Approval(msg.sender, _address, _value);
123     }
124 
125     /**
126      * @dev Reset count of tokens approved for given address
127      * @param _address target address
128      */
129     function unapprove(address _address)
130     { allowance[msg.sender][_address] = 0; }
131 }
132 /**
133  * @title Ethereum crypto currency extention for Token contract
134  */
135 contract TokenEther is Token {
136     function TokenEther(string _name, string _symbol)
137              Token(_name, _symbol, 18, 0)
138     {}
139 
140     /**
141      * @dev This is the way to withdraw money from token
142      * @param _value how many tokens withdraw from balance
143      */
144     function withdraw(uint _value) {
145         if (balanceOf[msg.sender] >= _value) {
146             balanceOf[msg.sender] -= _value;
147             totalSupply           -= _value;
148             if(!msg.sender.send(_value)) throw;
149         }
150     }
151 
152     /**
153      * @dev This is the way to refill your token balance by ethers
154      */
155     function refill() payable returns (bool) {
156         balanceOf[msg.sender] += msg.value;
157         totalSupply           += msg.value;
158         return true;
159     }
160 
161     /**
162      * @dev This method is called when money sended to contract address,
163      *      a synonym for refill()
164      */
165     function () payable {
166         balanceOf[msg.sender] += msg.value;
167         totalSupply           += msg.value;
168     }
169 }
170 contract AiraEtherFunds is TokenEther {
171     function AiraEtherFunds(string _name, string _symbol) TokenEther(_name, _symbol) {}
172 
173     /**
174      * @dev Event spawned when activation request received
175      */
176     event ActivationRequest(address indexed sender, bytes32 indexed code);
177 
178     /**
179      * @dev String to bytes32 conversion helper
180      */
181     function stringToBytes32(string memory source) constant returns (bytes32 result)
182     { assembly { result := mload(add(source, 32)) } }
183 
184     // Balance limit
185     uint public limit;
186     
187     function setLimit(uint _limit) onlyOwner
188     { limit = _limit; }
189 
190     // Account activation fee
191     uint public fee;
192     
193     function setFee(uint _fee) onlyOwner
194     { fee = _fee; }
195 
196     // AiraEtherBot
197     address public bot;
198 
199     function setBot(address _bot) onlyOwner
200     { bot = _bot; }
201 
202     modifier onlyBot { if (msg.sender != bot) throw; _; }
203 
204     /**
205      * @dev Refill balance and activate it by code
206      * @param _code is activation code
207      */
208     function activate(string _code) payable {
209         var value = msg.value;
210  
211         // Get a fee
212         if (fee > 0) {
213             if (value < fee) throw;
214             balanceOf[owner] += fee;
215             value            -= fee;
216         }
217 
218         // Refund over limit
219         if (limit > 0 && value > limit) {
220             var refund = value - limit;
221             if (!msg.sender.send(refund)) throw;
222             value = limit;
223         }
224 
225         // Refill account balance
226         balanceOf[msg.sender] += value;
227         totalSupply           += value;
228 
229         // Activation event
230         ActivationRequest(msg.sender, stringToBytes32(_code));
231     }
232 
233     /**
234      * @dev This is the way to refill your token balance by ethers
235      */
236     function refill() payable returns (bool) {
237         // Throw when over limit
238         if (balanceOf[msg.sender] + msg.value > limit) throw;
239 
240         // Refill
241         balanceOf[msg.sender] += msg.value;
242         totalSupply           += msg.value;
243         return true;
244     }
245 
246     /**
247      * @dev This method is called when money sended to contract address,
248      *      a synonym for refill()
249      */
250     function () payable {
251         // Throw when over limit
252         if (balanceOf[msg.sender] + msg.value > limit) throw;
253 
254         // Refill
255         balanceOf[msg.sender] += msg.value;
256         totalSupply           += msg.value;
257     }
258 
259     /**
260      * @dev Internal transfer for AIRA
261      * @param _from source address
262      * @param _to destination address
263      * @param _value amount of token values to send 
264      */
265     function airaTransfer(address _from, address _to, uint _value) onlyBot {
266         if (balanceOf[_from] >= _value) {
267             balanceOf[_from] -= _value;
268             balanceOf[_to]   += _value;
269             Transfer(_from, _to, _value);
270         }
271     }
272 
273     /**
274      * @dev Outgoing transfer for AIRA
275      * @param _from source address
276      * @param _to destination address
277      * @param _value amount of token values to send 
278      */
279     function airaSend(address _from, address _to, uint _value) onlyBot {
280         if (balanceOf[_from] >= _value) {
281             balanceOf[_from] -= _value;
282             totalSupply      -= _value;
283             Transfer(_from, _to, _value);
284             if (!_to.send(_value)) throw;
285         }
286     }
287 }