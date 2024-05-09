1 pragma solidity ^0.4.9;
2 
3 contract ERC223 {
4   uint public totalSupply;
5   function balanceOf(address who) constant returns (uint);
6   
7   function name() constant returns (string _name);
8   function symbol() constant returns (string _symbol);
9   function decimals() constant returns (uint8 _decimals);
10   function totalSupply() constant returns (uint256 _supply);
11 
12   function transfer(address to, uint value) returns (bool ok);
13   function transfer(address to, uint value, bytes data) returns (bool ok);
14   event Transfer(address indexed from, address indexed to, uint value, bytes indexed data);
15   event Transfer(address indexed from, address indexed to, uint value);
16 }
17 
18 contract ContractReceiver {
19      
20     struct TKN {
21         address sender;
22         uint value;
23         bytes data;
24         bytes4 sig;
25     }
26     
27     
28     function tokenFallback(address _from, uint _value, bytes _data){
29       TKN memory tkn;
30       tkn.sender = _from;
31       tkn.value = _value;
32       tkn.data = _data;
33       uint32 u = uint32(_data[3]) + (uint32(_data[2]) << 8) + (uint32(_data[1]) << 16) + (uint32(_data[0]) << 24);
34       tkn.sig = bytes4(u);
35       
36       /* tkn variable is analogue of msg variable of Ether transaction
37       *  tkn.sender is person who initiated this token transaction   (analogue of msg.sender)
38       *  tkn.value the number of tokens that were sent   (analogue of msg.value)
39       *  tkn.data is data of token transaction   (analogue of msg.data)
40       *  tkn.sig is 4 bytes signature of function
41       *  if data of token transaction is a function execution
42       */
43     }
44 }
45  /**
46  * ERC23 token by Dexaran
47  *
48  * https://github.com/Dexaran/ERC23-tokens
49  */
50  
51  
52  /* https://github.com/LykkeCity/EthereumApiDotNetCore/blob/master/src/ContractBuilder/contracts/token/SafeMath.sol */
53 contract SafeMath {
54     uint256 constant public MAX_UINT256 =
55     0xFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF;
56 
57     function safeAdd(uint256 x, uint256 y) constant internal returns (uint256 z) {
58         assert(x <= MAX_UINT256 - y);
59         return x + y;
60     }
61 
62     function safeSub(uint256 x, uint256 y) constant internal returns (uint256 z) {
63         assert(x >= y);
64         return x - y;
65     }
66 
67     function safeMul(uint256 x, uint256 y) constant internal returns (uint256 z) {
68         if (y == 0) return 0;
69         assert(x <= MAX_UINT256 / y);
70         return x * y;
71     }
72 }
73  
74 /*
75  * Ownable
76  *
77  * Base contract with an owner.
78  * Provides onlyOwner modifier, which prevents function from running if it is called by anyone other than the owner.
79  */
80 contract Ownable {
81   address public owner;
82 
83   function Ownable() {
84     owner = msg.sender;
85   }
86 
87   modifier onlyOwner() {
88     assert(msg.sender == owner);
89     _;
90   }
91 
92   function transferOwnership(address newOwner) onlyOwner {
93     if (newOwner != address(0)) {
94       owner = newOwner;
95     }
96   }
97 
98 }
99 
100 contract Haltable is Ownable {
101   bool public halted;
102 
103   modifier stopInEmergency {
104     assert(!halted);
105     _;
106   }
107 
108   modifier onlyInEmergency {
109     assert(halted);
110     _;
111   }
112 
113   // called by the owner on emergency, triggers stopped state
114   function halt() external onlyOwner {
115     halted = true;
116   }
117 
118   // called by the owner on end of emergency, returns to normal state
119   function unhalt() external onlyOwner onlyInEmergency {
120     halted = false;
121   }
122 
123 }
124 
125 contract ERC223Token is ERC223, SafeMath, Haltable {
126 
127   mapping(address => uint) balances;
128   
129   string public name;
130   string public symbol;
131   uint8 public decimals;
132   uint256 public totalSupply;
133   
134   
135   // Function to access name of token .
136   function name() constant returns (string _name) {
137       return name;
138   }
139   // Function to access symbol of token .
140   function symbol() constant returns (string _symbol) {
141       return symbol;
142   }
143   // Function to access decimals of token .
144   function decimals() constant returns (uint8 _decimals) {
145       return decimals;
146   }
147   // Function to access total supply of tokens .
148   function totalSupply() constant returns (uint256 _totalSupply) {
149       return totalSupply;
150   }
151   
152   
153 
154   // Function that is called when a user or another contract wants to transfer funds .
155   function transfer(address _to, uint _value, bytes _data) returns (bool success) {
156       
157     if(isContract(_to)) {
158         return transferToContract(_to, _value, _data);
159     }
160     else {
161         return transferToAddress(_to, _value, _data);
162     }
163 }
164   
165   // Standard function transfer similar to ERC20 transfer with no _data .
166   // Added due to backwards compatibility reasons .
167   function transfer(address _to, uint _value) returns (bool success) {
168       
169     //standard function transfer similar to ERC20 transfer with no _data
170     //added due to backwards compatibility reasons
171     bytes memory empty;
172     if(isContract(_to)) {
173         return transferToContract(_to, _value, empty);
174     }
175     else {
176         return transferToAddress(_to, _value, empty);
177     }
178 }
179 
180 //assemble the given address bytecode. If bytecode exists then the _addr is a contract.
181   function isContract(address _addr) private returns (bool is_contract) {
182       uint length;
183       assembly {
184             //retrieve the size of the code on target address, this needs assembly
185             length := extcodesize(_addr)
186         }
187         if(length>0) {
188             return true;
189         }
190         else {
191             return false;
192         }
193     }
194 
195   //function that is called when transaction target is an address
196   function transferToAddress(address _to, uint _value, bytes _data) private returns (bool success) {
197     assert(balanceOf(msg.sender) >= _value);
198     balances[msg.sender] = safeSub(balanceOf(msg.sender), _value);
199     balances[_to] = safeAdd(balanceOf(_to), _value);
200     Transfer(msg.sender, _to, _value, _data);
201     Transfer(msg.sender, _to, _value);
202     return true;
203   }
204   
205   //function that is called when transaction target is a contract
206   function transferToContract(address _to, uint _value, bytes _data) private returns (bool success) {
207     assert(balanceOf(msg.sender) >= _value);
208     balances[msg.sender] = safeSub(balanceOf(msg.sender), _value);
209     balances[_to] = safeAdd(balanceOf(_to), _value);
210     ContractReceiver reciever = ContractReceiver(_to);
211     reciever.tokenFallback(msg.sender, _value, _data);
212     Transfer(msg.sender, _to, _value, _data);
213     Transfer(msg.sender, _to, _value);
214     return true;
215 }
216 
217 
218   function balanceOf(address _owner) constant returns (uint balance) {
219     return balances[_owner];
220   }
221   
222   
223 }
224 
225 contract ZontoToken is ERC223Token {
226 
227     address public beneficiary;
228     event Buy(address indexed participant, uint tokens, uint eth);
229     event GoalReached(uint amountRaised);
230 
231     uint public cap = 20000000000000;
232     uint public price;
233     uint public collectedTokens;
234     uint public collectedEthers;
235 
236     uint public tokensSold = 0;
237     uint public weiRaised = 0;
238     uint public investorCount = 0;
239 
240     uint public startTime;
241     uint public endTime;
242 
243     bool public presaleFinished = false;
244 
245   /**
246    * @dev Contructor that gives msg.sender all of existing tokens. 
247    */
248     function ZontoToken() {
249             
250         name = "ZONTO Token";
251         symbol = "ZONTO";
252         decimals = 8;
253         totalSupply = 500000000000000;
254     
255         balances[msg.sender] = totalSupply;
256         
257         beneficiary = 0x0980eaD74d176025F2962f8b5535346c77ffd2f5;
258         price = 150;
259         startTime = 1502706677;
260         endTime = startTime + 14 * 1 days;
261         
262     }
263     
264     modifier onlyAfter(uint time) {
265         assert(now >= time);
266         _;
267     }
268 
269     modifier onlyBefore(uint time) {
270         assert(now <= time);
271         _;
272     }
273     
274     function () payable stopInEmergency {
275         assert(msg.value >= 0.01 * 1 ether);
276         doPurchase();
277     }
278     
279     function doPurchase() private onlyAfter(startTime) onlyBefore(endTime) {
280 
281         assert(!presaleFinished);
282         
283         uint tokens = msg.value * price / 10000000000;
284 
285         if (balanceOf(msg.sender) == 0) investorCount++;
286         
287         balances[owner] -= tokens;
288         balances[msg.sender] += tokens;
289         
290         collectedTokens = safeAdd(collectedTokens, tokens);
291         collectedEthers = safeAdd(collectedEthers, msg.value);
292         
293         weiRaised = safeAdd(weiRaised, msg.value);
294         tokensSold = safeAdd(tokensSold, tokens);
295         
296         bytes memory empty;
297         Transfer(owner, msg.sender, tokens, empty);
298         Transfer(owner, msg.sender, tokens);
299         
300         Buy(msg.sender, tokens, msg.value);
301         
302         if (collectedTokens >= cap) {
303             GoalReached(collectedTokens);
304         }
305 
306     }
307     
308     function withdraw() onlyOwner onlyAfter(endTime) returns (bool) {
309         if (!beneficiary.send(collectedEthers)) {
310             return false;
311         }
312         presaleFinished = true;
313         return true;
314     }
315     
316     
317 }