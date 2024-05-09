1 pragma solidity ^0.4.10;
2 
3 pragma solidity ^0.4.11;
4 
5 
6 /**
7  * @title SafeMath
8  * @dev Math operations with safety checks that throw on error
9  */
10 library SafeMath {
11   function mul(uint256 a, uint256 b) internal returns (uint256) {
12     if (a == 0) {
13       return 0;
14     }
15     uint256 c = a * b;
16     assert(c / a == b);
17     return c;
18   }
19 
20   function div(uint256 a, uint256 b) internal returns (uint256) {
21     // assert(b > 0); // Solidity automatically throws when dividing by 0
22     uint256 c = a / b;
23     // assert(a == b * c + a % b); // There is no case in which this doesn't hold
24     return c;
25   }
26 
27   function sub(uint256 a, uint256 b) internal returns (uint256) {
28     assert(b <= a);
29     return a - b;
30   }
31 
32   function add(uint256 a, uint256 b) internal returns (uint256) {
33     uint256 c = a + b;
34     assert(c >= a);
35     return c;
36   }
37 }
38 
39 pragma solidity ^0.4.11;
40 
41 
42 /**
43  * @title Ownable
44  * @dev The Ownable contract has an owner address, and provides basic authorization control
45  * functions, this simplifies the implementation of "user permissions".
46  */
47 contract Ownable {
48   address public owner;
49 
50 
51   event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
52 
53 
54   /**
55    * @dev The Ownable constructor sets the original `owner` of the contract to the sender
56    * account.
57    */
58   function Ownable() {
59     owner = msg.sender;
60   }
61 
62 
63   /**
64    * @dev Throws if called by any account other than the owner.
65    */
66   modifier onlyOwner() {
67     require(msg.sender == owner);
68     _;
69   }
70 
71 
72   /**
73    * @dev Allows the current owner to transfer control of the contract to a newOwner.
74    * @param newOwner The address to transfer ownership to.
75    */
76   function transferOwnership(address newOwner) onlyOwner public {
77     require(newOwner != address(0));
78     OwnershipTransferred(owner, newOwner);
79     owner = newOwner;
80   }
81 
82 }
83 
84 pragma solidity ^0.4.11;
85 
86 
87 
88 /**
89  * @title Pausable
90  * @dev Base contract which allows children to implement an emergency stop mechanism.
91  */
92 contract Pausable is Ownable {
93   event Pause();
94   event Unpause();
95 
96   bool public paused = false;
97 
98 
99   /**
100    * @dev Modifier to make a function callable only when the contract is not paused.
101    */
102   modifier whenNotPaused() {
103     require(!paused);
104     _;
105   }
106 
107   /**
108    * @dev Modifier to make a function callable only when the contract is paused.
109    */
110   modifier whenPaused() {
111     require(paused);
112     _;
113   }
114 
115   modifier stopInEmergency {
116     if (paused) {
117       throw;
118     }
119     _;
120   }
121 
122   /**
123    * @dev called by the owner to pause, triggers stopped state
124    */
125   function pause() onlyOwner whenNotPaused public {
126     paused = true;
127     Pause();
128   }
129 
130   /**
131    * @dev called by the owner to unpause, returns to normal state
132    */
133   function unpause() onlyOwner whenPaused public {
134     paused = false;
135     Unpause();
136   }
137 }
138 
139 pragma solidity ^0.4.8;
140 
141 
142 contract Sales{
143 
144 	enum ICOSaleState{
145 		PrivateSale,
146 	    PreSale,
147 	    PublicSale,
148 	    Success,
149 	    Failed
150 	 }
151 }
152 
153 contract Token {
154     uint256 public totalSupply;
155     function balanceOf(address _owner) constant returns (uint256 balance);
156     function transfer(address _to, uint256 _value) returns (bool success);
157     function transferFrom(address _from, address _to, uint256 _value) returns (bool success);
158     function approve(address _spender, uint256 _value) returns (bool success);
159     function allowance(address _owner, address _spender) constant returns (uint256 remaining);
160     event Transfer(address indexed _from, address indexed _to, uint256 _value);
161     event Approval(address indexed _owner, address indexed _spender, uint256 _value);
162 }
163 
164 
165 /*  ERC 20 token */
166 contract GACToken is Token,Ownable,Sales {
167     string public constant name = "Gladage Care Token";
168     string public constant symbol = "GAC";
169     uint256 public constant decimals = 18;
170     string public version = "1.0";
171     uint public valueToBeSent = 1;
172 
173     bool public finalizedICO = false;
174 
175     uint256 public ethraised;
176     uint256 public btcraised;
177     uint256 public usdraised;
178 
179     bool public istransferAllowed;
180 
181     uint256 public constant GACFund = 5 * (10**8) * 10**decimals; 
182     uint256 public fundingStartBlock; // crowdsale start unix //now
183     uint256 public fundingEndBlock; // crowdsale end unix //1530403200 //07/01/2018 @ 12:00am (UTC)
184     uint256 public tokenCreationMax= 275 * (10**6) * 10**decimals;//TODO
185     mapping (address => bool) ownership;
186     uint256 public minCapUSD = 2000000;
187     uint256 public maxCapUSD = 20000000;
188 
189 
190     mapping (address => uint256) balances;
191     mapping (address => mapping (address => uint256)) allowed;
192 
193     modifier onlyPayloadSize(uint size) {
194         require(msg.data.length >= size + 4);
195         _;
196     }
197 
198     function transfer(address _to, uint256 _value) onlyPayloadSize(2 * 32) returns (bool success) {
199       if(!istransferAllowed) throw;
200       if (balances[msg.sender] >= _value && _value > 0) {
201         balances[msg.sender] -= _value;
202         balances[_to] += _value;
203         Transfer(msg.sender, _to, _value);
204         return true;
205       } else {
206         return false;
207       }
208     }
209 
210     function burnTokens(uint256 _value) public{
211         require(balances[msg.sender]>=_value);
212         balances[msg.sender] = SafeMath.sub(balances[msg.sender],_value);
213         totalSupply =SafeMath.sub(totalSupply,_value);
214     }
215 
216 
217     //this is the default constructor
218     function GACToken(uint256 _fundingStartBlock, uint256 _fundingEndBlock){
219         totalSupply = GACFund;
220         fundingStartBlock = _fundingStartBlock;
221         fundingEndBlock = _fundingEndBlock;
222     }
223 
224     ///change the funding end block
225     function changeEndBlock(uint256 _newFundingEndBlock) onlyOwner{
226         fundingEndBlock = _newFundingEndBlock;
227     }
228 
229     ///change the funding start block
230     function changeStartBlock(uint256 _newFundingStartBlock) onlyOwner{
231         fundingStartBlock = _newFundingStartBlock;
232     }
233 
234     ///the Min Cap USD 
235     ///function too chage the miin cap usd
236     function changeMinCapUSD(uint256 _newMinCap) onlyOwner{
237         minCapUSD = _newMinCap;
238     }
239 
240     ///fucntion to change the max cap usd
241     function changeMaxCapUSD(uint256 _newMaxCap) onlyOwner{
242         maxCapUSD = _newMaxCap;
243     }
244 
245 
246     function transferFrom(address _from, address _to, uint256 _value) onlyPayloadSize(3 * 32) returns (bool success) {
247       if(!istransferAllowed) throw;
248       if (balances[_from] >= _value && allowed[_from][msg.sender] >= _value && _value > 0) {
249         balances[_to] += _value;
250         balances[_from] -= _value;
251         allowed[_from][msg.sender] -= _value;
252         Transfer(_from, _to, _value);
253         return true;
254       } else {
255         return false;
256       }
257     }
258 
259 
260     function addToBalances(address _person,uint256 value) {
261         if(!ownership[msg.sender]) throw;
262         balances[_person] = SafeMath.add(balances[_person],value);
263         Transfer(address(this), _person, value);
264     }
265 
266     function addToOwnership(address owners) onlyOwner{
267         ownership[owners] = true;
268     }
269 
270     function balanceOf(address _owner) constant returns (uint256 balance) {
271         return balances[_owner];
272     }
273 
274     function approve(address _spender, uint256 _value) onlyPayloadSize(2 * 32) returns (bool success) {
275         require((_value == 0) || (allowed[msg.sender][_spender] == 0));
276         allowed[msg.sender][_spender] = _value;
277         Approval(msg.sender, _spender, _value);
278         return true;
279     }
280 
281     function allowance(address _owner, address _spender) constant returns (uint256 remaining) {
282       return allowed[_owner][_spender];
283     }
284 
285     function increaseEthRaised(uint256 value){
286         if(!ownership[msg.sender]) throw;
287         ethraised+=value;
288     }
289 
290     function increaseBTCRaised(uint256 value){
291         if(!ownership[msg.sender]) throw;
292         btcraised+=value;
293     }
294 
295     function increaseUSDRaised(uint256 value){
296         if(!ownership[msg.sender]) throw;
297         usdraised+=value;
298     }
299 
300     function finalizeICO(){
301         if(!ownership[msg.sender]) throw;
302 
303         if(usdraised<minCapUSD) throw;
304         finalizedICO = true;
305         istransferAllowed = true;
306     }
307 
308     function enableTransfers() public onlyOwner{
309         istransferAllowed = true;
310     }
311 
312     function disableTransfers() public onlyOwner{
313         istransferAllowed = false;
314     }
315 
316     //functiion to force finalize the ICO by the owner no checks called here
317     function finalizeICOOwner() onlyOwner{
318         finalizedICO = true;
319         istransferAllowed = true;
320     }
321 
322     function isValid() returns(bool){
323         if(now>=fundingStartBlock && now<fundingEndBlock ){
324             return true;
325         }else{
326             return false;
327         }
328         if(usdraised>maxCapUSD) throw;
329     }
330 
331     ///do not allow payments on this address
332 
333     function() payable{
334         throw;
335     }
336 }