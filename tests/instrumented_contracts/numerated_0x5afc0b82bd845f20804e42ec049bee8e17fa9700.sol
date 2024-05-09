1 pragma solidity ^0.4.11;
2 
3 
4 /**
5  * @title Ownable
6  * @dev The Ownable contract has an owner address, and provides basic authorization control
7  * functions, this simplifies the implementation of "user permissions".
8  */
9 contract Ownable {
10   address public owner;
11 
12 
13   event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
14 
15 
16   /**
17    * @dev The Ownable constructor sets the original `owner` of the contract to the sender
18    * account.
19    */
20   function Ownable() {
21     owner = msg.sender;
22   }
23 
24 
25   /**
26    * @dev Throws if called by any account other than the owner.
27    */
28   modifier onlyOwner() {
29     require(msg.sender == owner);
30     _;
31   }
32 
33 
34   /**
35    * @dev Allows the current owner to transfer control of the contract to a newOwner.
36    * @param newOwner The address to transfer ownership to.
37    */
38   function transferOwnership(address newOwner) onlyOwner public {
39     require(newOwner != address(0));
40     OwnershipTransferred(owner, newOwner);
41     owner = newOwner;
42   }
43 
44 }
45 
46 
47 
48 
49 /**
50  * @title SafeMath
51  * @dev Math operations with safety checks that throw on error
52  */
53 library SafeMath {
54   function mul(uint256 a, uint256 b) internal returns (uint256) {
55     if (a == 0) {
56       return 0;
57     }
58     uint256 c = a * b;
59     assert(c / a == b);
60     return c;
61   }
62 
63   function div(uint256 a, uint256 b) internal returns (uint256) {
64     // assert(b > 0); // Solidity automatically throws when dividing by 0
65     uint256 c = a / b;
66     // assert(a == b * c + a % b); // There is no case in which this doesn't hold
67     return c;
68   }
69 
70   function sub(uint256 a, uint256 b) internal returns (uint256) {
71     assert(b <= a);
72     return a - b;
73   }
74 
75   function add(uint256 a, uint256 b) internal returns (uint256) {
76     uint256 c = a + b;
77     assert(c >= a);
78     return c;
79   }
80 }
81 
82 
83 
84 
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
139 
140 contract Token {
141     uint256 public totalSupply;
142     function balanceOf(address _owner) constant returns (uint256 balance);
143     function transfer(address _to, uint256 _value) returns (bool success);
144     function transferFrom(address _from, address _to, uint256 _value) returns (bool success);
145     function approve(address _spender, uint256 _value) returns (bool success);
146     function allowance(address _owner, address _spender) constant returns (uint256 remaining);
147     event Transfer(address indexed _from, address indexed _to, uint256 _value);
148     event Approval(address indexed _owner, address indexed _spender, uint256 _value);
149 }
150 
151 
152 /*  ERC 20 token */
153 contract CevacToken is Token,Ownable {
154     string public constant name = "Cevac Token";
155     string public constant symbol = "CEVAC";
156     uint256 public constant decimals = 8;
157     string public version = "1.0";
158     uint public valueToBeSent = 1;
159 
160     bool public finalizedICO = false;
161 
162     uint256 public ethraised;
163     uint256 public btcraised;
164     uint256 public usdraised;
165 
166 
167     uint256 public numberOfBackers;
168 
169     bool public istransferAllowed;
170 
171     uint256 public constant CevacFund = 36 * (10**8) * 10**decimals; 
172     uint256 public fundingStartBlock; //start = 1533081600 //1 august 2018
173     uint256 public fundingEndBlock; ///end = 1585612800 ///31 march 2020
174     uint256 public tokenCreationMax= 1836 * (10**6) * 10**decimals;//TODO
175     mapping (address => bool) public ownership;
176     uint256 public minCapUSD = 210000000;
177     uint256 public maxCapUSD = 540000000;
178 
179     address public ownerWallet = 0x46F525e84B5C59CA63a5E1503fa82dF98fBb026b;
180 
181 
182     mapping (address => uint256) public balances;
183     mapping (address => mapping (address => uint256)) public allowed;
184 
185     modifier onlyPayloadSize(uint size) {
186         require(msg.data.length >= size + 4);
187         _;
188     }
189 
190     function transfer(address _to, uint256 _value) onlyPayloadSize(2 * 32) returns (bool success) {
191       if(!istransferAllowed) throw;
192       if (balances[msg.sender] >= _value && _value > 0) {
193         balances[msg.sender] -= _value;
194         balances[_to] += _value;
195         Transfer(msg.sender, _to, _value);
196         return true;
197       } else {
198         return false;
199       }
200     }
201 
202     function burnTokens(uint256 _value) public{
203         require(balances[msg.sender]>=_value);
204         balances[msg.sender] = SafeMath.sub(balances[msg.sender],_value);
205         totalSupply =SafeMath.sub(totalSupply,_value);
206     }
207 
208 
209     //this is the default constructor
210     function CevacToken(uint256 _fundingStartBlock, uint256 _fundingEndBlock){
211         balances[ownerWallet] = CevacFund;
212         totalSupply = CevacFund;
213         fundingStartBlock = _fundingStartBlock;
214         fundingEndBlock = _fundingEndBlock;
215        
216 
217     }
218 
219     ///change the funding end block
220     function changeEndBlock(uint256 _newFundingEndBlock) public onlyOwner{
221         fundingEndBlock = _newFundingEndBlock;
222     }
223 
224     ///change the funding start block
225     function changeStartBlock(uint256 _newFundingStartBlock) public onlyOwner{
226         fundingStartBlock = _newFundingStartBlock;
227     }
228 
229     ///the Min Cap USD 
230     ///function too chage the miin cap usd
231     function changeMinCapUSD(uint256 _newMinCap) public onlyOwner{
232         minCapUSD = _newMinCap;
233     }
234 
235 
236     ///fucntion to change the max cap usd
237     function changeMaxCapUSD(uint256 _newMaxCap) public onlyOwner{
238         maxCapUSD = _newMaxCap;
239     }
240 
241 
242     function transferFrom(address _from, address _to, uint256 _value) onlyPayloadSize(3 * 32) returns (bool success) {
243       if(!istransferAllowed) throw;
244       if (balances[_from] >= _value && allowed[_from][msg.sender] >= _value && _value > 0) {
245         balances[_to] += _value;
246         balances[_from] -= _value;
247         allowed[_from][msg.sender] -= _value;
248         Transfer(_from, _to, _value);
249         return true;
250       } else {
251         return false;
252       }
253     }
254 
255 
256     function addToBalances(address _person,uint256 value) {
257         if(!ownership[msg.sender]) throw;
258         balances[ownerWallet] = SafeMath.sub(balances[ownerWallet],value);
259         balances[_person] = SafeMath.add(balances[_person],value);
260         Transfer(address(this), _person, value);
261     }
262 
263     /**
264     This is to add the token sale platform ownership to send tokens
265     **/
266     function addToOwnership(address owners) onlyOwner{
267         ownership[owners] = true;
268     }
269 
270     /**
271     To be done after killing the old conttract else conflicts can take place
272     This is to remove the token sale platform ownership to send tokens
273     **/
274     function removeFromOwnership(address owners) onlyOwner{
275         ownership[owners] = false;
276     }
277 
278     function balanceOf(address _owner) view returns (uint256 balance) {
279         return balances[_owner];
280     }
281 
282     function approve(address _spender, uint256 _value) onlyPayloadSize(2 * 32) returns (bool success) {
283         require((_value == 0) || (allowed[msg.sender][_spender] == 0));
284         allowed[msg.sender][_spender] = _value;
285         Approval(msg.sender, _spender, _value);
286         return true;
287     }
288 
289     function allowance(address _owner, address _spender) view returns (uint256 remaining) {
290       return allowed[_owner][_spender];
291     }
292 
293     function increaseEthRaised(uint256 value){
294         require(ownership[msg.sender]);
295         ethraised+=value;
296     }
297 
298     function increaseBTCRaised(uint256 value){
299         require(ownership[msg.sender]);
300         btcraised+=value;
301     }
302 
303     function increaseUSDRaised(uint256 value){
304         require(ownership[msg.sender]);
305         usdraised+=value;
306     }
307 
308     function finalizeICO() public{
309     require(ownership[msg.sender]);
310     require(usdraised>=minCapUSD);
311     finalizedICO = true;
312     istransferAllowed = true;
313     }
314 
315     function enableTransfers() public onlyOwner{
316         istransferAllowed = true;
317     }
318 
319     function disableTransfers() public onlyOwner{
320         istransferAllowed = false;
321     }
322 
323     //functiion to force finalize the ICO by the owner no checks called here
324     function finalizeICOOwner() onlyOwner{
325         finalizedICO = true;
326         istransferAllowed = true;
327     }
328 
329     function isValid() returns(bool){
330         if(now>=fundingStartBlock && now<fundingEndBlock ){
331             return true;
332         }else{
333             return false;
334         }
335         if(usdraised>maxCapUSD) throw;
336     }
337 
338     ///do not allow payments on this address
339 
340     function() payable{
341         throw;
342     }
343 }