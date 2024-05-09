1 pragma solidity ^0.4.11;
2 
3 
4 library SafeMath {
5   function mul(uint256 a, uint256 b) internal returns (uint256) {
6     if (a == 0) {
7       return 0;
8     }
9     uint256 c = a * b;
10     assert(c / a == b);
11     return c;
12   }
13 
14   function div(uint256 a, uint256 b) internal returns (uint256) {
15     // assert(b > 0); // Solidity automatically throws when dividing by 0
16     uint256 c = a / b;
17     // assert(a == b * c + a % b); // There is no case in which this doesn't hold
18     return c;
19   }
20 
21   function sub(uint256 a, uint256 b) internal returns (uint256) {
22     assert(b <= a);
23     return a - b;
24   }
25 
26   function add(uint256 a, uint256 b) internal returns (uint256) {
27     uint256 c = a + b;
28     assert(c >= a);
29     return c;
30   }
31 }
32 
33 
34 
35 
36 pragma solidity ^0.4.11;
37 
38 
39 /**
40  * @title Ownable
41  * @dev The Ownable contract has an owner address, and provides basic authorization control
42  * functions, this simplifies the implementation of "user permissions".
43  */
44 contract Ownable {
45   address public owner;
46 
47 
48   event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
49 
50 
51   /**
52    * @dev The Ownable constructor sets the original `owner` of the contract to the sender
53    * account.
54    */
55   function Ownable() {
56     owner = msg.sender;
57   }
58 
59 
60   /**
61    * @dev Throws if called by any account other than the owner.
62    */
63   modifier onlyOwner() {
64     require(msg.sender == owner);
65     _;
66   }
67 
68 
69   /**
70    * @dev Allows the current owner to transfer control of the contract to a newOwner.
71    * @param newOwner The address to transfer ownership to.
72    */
73   function transferOwnership(address newOwner) onlyOwner public {
74     require(newOwner != address(0));
75     OwnershipTransferred(owner, newOwner);
76     owner = newOwner;
77   }
78 
79 }
80 
81 
82 pragma solidity ^0.4.11;
83 
84 /**
85  * @title Pausable
86  * @dev Base contract which allows children to implement an emergency stop mechanism.
87  */
88 contract Pausable is Ownable {
89   event Pause();
90   event Unpause();
91 
92   bool public paused = false;
93 
94 
95   /**
96    * @dev Modifier to make a function callable only when the contract is not paused.
97    */
98   modifier whenNotPaused() {
99     require(!paused);
100     _;
101   }
102 
103   /**
104    * @dev Modifier to make a function callable only when the contract is paused.
105    */
106   modifier whenPaused() {
107     require(paused);
108     _;
109   }
110 
111   modifier stopInEmergency {
112     if (paused) {
113       throw;
114     }
115     _;
116   }
117 
118   /**
119    * @dev called by the owner to pause, triggers stopped state
120    */
121   function pause() onlyOwner whenNotPaused public {
122     paused = true;
123     Pause();
124   }
125 
126   /**
127    * @dev called by the owner to unpause, returns to normal state
128    */
129   function unpause() onlyOwner whenPaused public {
130     paused = false;
131     Unpause();
132   }
133 }
134 
135 
136 pragma solidity ^0.4.8;
137 
138 
139 contract Sales{
140 
141   enum ICOSaleState{
142     PrivateSale,
143       PreSale,
144       PublicSale,
145       Success,
146       Failed
147    }
148 }
149 
150 pragma solidity ^0.4.10;
151 
152 contract Token {
153     uint256 public totalSupply;
154     function balanceOf(address _owner) constant returns (uint256 balance);
155     function transfer(address _to, uint256 _value) returns (bool success);
156     function transferFrom(address _from, address _to, uint256 _value) returns (bool success);
157     function approve(address _spender, uint256 _value) returns (bool success);
158     function allowance(address _owner, address _spender) constant returns (uint256 remaining);
159     event Transfer(address indexed _from, address indexed _to, uint256 _value);
160     event Approval(address indexed _owner, address indexed _spender, uint256 _value);
161 }
162 
163 
164 /*  ERC 20 token */
165 contract BLMToken is Token,Ownable,Sales {
166     string public constant name = "Bloomatch Token";
167     string public constant symbol = "BLM";
168     uint256 public constant decimals = 18;
169     string public version = "1.0";
170 
171     uint public valueToBeSent = 1;
172     address personMakingTx;
173     //uint private output1,output2,output3,output4;
174     address public addr1;
175     address public txorigin;
176 
177     bool isTesting;
178     bytes32 testname;
179     address finalOwner;
180     bool public finalizedICO = false;
181 
182     uint256 public ethraised;
183     uint256 public btcraised;
184     uint256 public usdraised;
185 
186     bool public istransferAllowed;
187 
188     uint256 public constant BLMFund = 25 * (10**7) * 10**decimals; 
189     uint256 public fundingStartBlock; // crowdsale start block
190     uint256 public fundingEndBlock; // crowdsale end block
191     uint256 public tokenCreationMax= 10 * (10**7) * 10**decimals;
192     mapping (address => bool) ownership;
193     uint256 public minCapUSD = 2000000;
194     uint256 public maxCapUSD = 18000000;
195 
196 
197     mapping (address => uint256) balances;
198     mapping (address => mapping (address => uint256)) allowed;
199 
200     modifier onlyPayloadSize(uint size) {
201         require(msg.data.length >= size + 4);
202         _;
203     }
204 
205     function transfer(address _to, uint256 _value) onlyPayloadSize(2 * 32) returns (bool success) {
206       if(!istransferAllowed) throw;
207       if (balances[msg.sender] >= _value && _value > 0) {
208         balances[msg.sender] -= _value;
209         balances[_to] += _value;
210         Transfer(msg.sender, _to, _value);
211         return true;
212       } else {
213         return false;
214       }
215     }
216 
217     //this is the default constructor
218     function BLMToken(uint256 _fundingStartBlock, uint256 _fundingEndBlock){
219         totalSupply = BLMFund;
220         fundingStartBlock = _fundingStartBlock;
221         fundingEndBlock = _fundingEndBlock;
222     }
223 
224 
225 
226 
227     /***Event to be fired when the state of the sale of the ICO is changes**/
228     event stateChange(ICOSaleState state);
229 
230     function transferFrom(address _from, address _to, uint256 _value) onlyPayloadSize(3 * 32) returns (bool success) {
231         if(!istransferAllowed) throw;
232       if (balances[_from] >= _value && allowed[_from][msg.sender] >= _value && _value > 0) {
233         balances[_to] += _value;
234         balances[_from] -= _value;
235         allowed[_from][msg.sender] -= _value;
236         Transfer(_from, _to, _value);
237         return true;
238       } else {
239         return false;
240       }
241     }
242 
243     function addToBalances(address _person,uint256 value) {
244         if(!ownership[msg.sender]) throw;
245         balances[_person] = SafeMath.add(balances[_person],value);
246 
247     }
248 
249     function addToOwnership(address owners) onlyOwner{
250         ownership[owners] = true;
251     }
252 
253     function balanceOf(address _owner) constant returns (uint256 balance) {
254         return balances[_owner];
255     }
256 
257     function approve(address _spender, uint256 _value) onlyPayloadSize(2 * 32) returns (bool success) {
258         require((_value == 0) || (allowed[msg.sender][_spender] == 0));
259         allowed[msg.sender][_spender] = _value;
260         Approval(msg.sender, _spender, _value);
261         return true;
262     }
263 
264     function allowance(address _owner, address _spender) constant returns (uint256 remaining) {
265       return allowed[_owner][_spender];
266     }
267 
268     function increaseEthRaised(uint256 value){
269         if(!ownership[msg.sender]) throw;
270         ethraised+=value;
271     }
272 
273     function increaseBTCRaised(uint256 value){
274         if(!ownership[msg.sender]) throw;
275         btcraised+=value;
276     }
277 
278     function increaseUSDRaised(uint256 value){
279         if(!ownership[msg.sender]) throw;
280         usdraised+=value;
281     }
282 
283     function finalizeICO(){
284         if(!ownership[msg.sender]) throw;
285         if(usdraised<minCapUSD) throw;
286         finalizedICO = true;
287         istransferAllowed = true;
288     }
289 
290 
291     function isValid() returns(bool){
292         if(block.number>=fundingStartBlock && block.number<fundingEndBlock ){
293             return true;
294         }else{
295             return false;
296         }
297         if(usdraised>maxCapUSD) throw;
298     }
299 
300 
301     function() payable{
302         throw;
303     }
304 }