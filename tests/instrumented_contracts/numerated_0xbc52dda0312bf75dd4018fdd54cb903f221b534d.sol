1 pragma solidity ^0.4.24;
2 
3 /**
4  * @title Ownable
5  */
6 contract Ownable {
7 
8     address public owner;
9   
10     constructor() public {
11 
12         owner = msg.sender;
13 
14     }
15    
16     modifier onlyOwner() {
17 
18         require(msg.sender == owner);
19         _;
20 
21     }
22 
23     function transferOwnership(address newOwner) onlyOwner public {
24         
25         if (newOwner != address(0)) {
26             owner = newOwner;
27         }
28 
29     }
30 
31 }
32 
33 /**
34  * @title SafeMath
35  */
36 library SafeMath {
37     
38     function mul(uint256 a, uint256 b) internal pure returns (uint256) {
39        
40         uint256 c = a * b;
41         assert(a == 0 || c / a == b);
42         return c;
43 
44     }
45 
46     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
47        
48         assert(b <= a);
49         return a - b;
50 
51     }
52 
53     function add(uint256 a, uint256 b) internal pure returns (uint256) {
54        
55         uint256 c = a + b;
56         assert(c >= a);
57         return c;
58 
59     }
60 
61 }
62 
63 /**
64  * @title tokenRecipient
65  */
66 interface tokenRecipient { function receiveApproval(address _from, uint256 _value, address _token, bytes _extraData) external; }
67 
68 
69 /**
70  * @title TokenERC20
71  */
72 contract TokenERC20 {
73 
74     using SafeMath for uint256;
75 
76     uint256 public totalSupply;
77 
78     mapping(address => uint256) public balances;
79     mapping(address => mapping(address => uint256)) public allowed;
80 
81     
82     event Burn(address indexed from, uint256 value);
83     event Transfer(address indexed from, address indexed to, uint256 value);
84     event Approval(address indexed owner, address indexed spender, uint256 value);
85 
86     function balanceOf(address _owner) view public returns(uint256) {
87       
88         return balances[_owner];
89 
90     }
91 
92     function allowance(address _owner, address _spender) view public returns(uint256) {
93         
94         return allowed[_owner][_spender];
95 
96     }
97 
98     
99     function _transfer(address _from, address _to, uint _value) internal {
100        
101         balances[_from] = balances[_from].sub(_value);
102         balances[_to] = balances[_to].add(_value);
103         emit Transfer( _from, _to, _value);
104 
105     }
106 
107   
108     function transfer(address _to, uint256 _value) public returns(bool) {
109       
110         _transfer(msg.sender, _to, _value);
111         return true;
112 
113     }
114 
115     
116     function transferFrom(address _from, address _to, uint256 _value) public returns(bool) {
117        
118         allowed[_from][msg.sender] = allowed[_from][msg.sender].sub(_value);
119         _transfer(_from, _to, _value);
120         return true;
121 
122     }
123 
124     
125     function approve(address _spender, uint256 _value) public returns(bool) {
126        
127         // Avoid the front-running attack
128         require((_value == 0) || (allowed[msg.sender][_spender] == 0));
129         allowed[msg.sender][_spender] = _value;
130         emit Approval(msg.sender, _spender, _value);
131         return true;
132 
133     }
134 
135     
136     function approveAndCall(address _spender, uint256 _value, bytes _extraData) public returns(bool) {
137        
138         tokenRecipient spender = tokenRecipient(_spender);
139         if (approve(_spender, _value)) {
140             spender.receiveApproval(msg.sender, _value, this, _extraData);
141             return true;
142         }
143         return false;
144 
145     }
146 
147     
148     function burn(uint256 _value) public returns(bool) {
149         
150         balances[msg.sender] = balances[msg.sender].sub(_value);
151         totalSupply = totalSupply.sub(_value);
152         emit Burn(msg.sender, _value);
153         return true;
154 
155     }
156 
157     
158     function burnFrom(address _from, uint256 _value) public returns(bool) {
159        
160         allowed[_from][msg.sender] = allowed[_from][msg.sender].sub(_value);
161         balances[_from] = balances[_from].sub(_value);
162         totalSupply = totalSupply.sub(_value);
163         emit Burn(_from, _value);
164         return true;
165 
166     }
167 
168     function transferMultiple(address[] _to, uint256[] _value) returns(bool) {
169         
170         require(_to.length == _value.length);
171         uint256 i = 0;
172         while (i < _to.length) {
173            _transfer(msg.sender, _to[i], _value[i]);
174            i += 1;
175         }
176         return true;
177 
178     }
179 
180 }
181 
182 /**
183  * @title RICToken
184  */
185 contract RICToken is TokenERC20, Ownable {
186     
187     using SafeMath for uint256;
188 
189     string public constant name = "RICToken";
190     string public constant symbol = "RIC";
191     uint8 public constant decimals = 6;
192 
193     event Mint(address indexed _to, uint256 _amount);
194 
195     function mint(address _to, uint256 _amount) public onlyOwner{
196         totalSupply = totalSupply.add(_amount);
197         balances[_to] = balances[_to].add(_amount);
198         emit Mint(_to, _amount);
199     }
200 
201 }
202 
203 
204 contract RICMiner is  RICToken{
205     
206     using SafeMath for uint256;
207     
208     struct Customer{
209        uint256 minerAmount; 
210        address customerAddr;
211        address customerEquity;
212        bool flag;  
213        uint256 buyGoods;
214     }
215 
216     struct Good{
217        string goodId;
218        uint256 price; 
219        string desc;
220        uint256 power;
221        address belong;
222     }
223 
224     event Records(address user,uint256 value);
225     event AddGood(address sender,bool isScuccess,string message);
226     event BuyGood(address sender,bool isSuccess,string message);
227     event ActiveMiner(address sender,bool isSuccess,string message);
228     event Transfer(address _from,address to,uint256);
229     
230     mapping (string=>Customer) customer;
231     mapping (string=>Good) good;
232     string[] goods;
233     string[] minerAmount; 
234     address[] purchasedOfUser; 
235     address[] activationMiner; 
236 
237     uint256  private rew; 
238     uint256 public sellPrice;
239     uint256 public buyPrice;
240 
241     function () public payable {
242 
243         require(msg.sender != 0x0);
244         require(msg.value != 0 ether);
245         emit Records(msg.sender,msg.value);
246 
247     }
248 
249     function enter() public  payable{
250 
251         require(msg.sender != 0x0);
252         require(msg.value != 0 ether);
253         emit Records(msg.sender,msg.value);
254 
255     }
256 
257     function transferETH()public onlyOwner{
258 
259         msg.sender.transfer(address(this).balance);
260 
261     }
262 
263     function  destroy()  public onlyOwner {
264 
265         selfdestruct(owner);
266 
267     }
268 
269     function getContractBalance() public constant returns (uint256) {
270        
271         return address(this).balance;
272 
273      }
274 
275      function setRew(uint256 _value) public onlyOwner {
276 
277         rew  = _value*10**5;
278 
279      }
280 
281     function setPrices(uint256 newSellPrice, uint256 newBuyPrice) onlyOwner public {
282         sellPrice = newSellPrice;
283         buyPrice = newBuyPrice;
284     }
285   
286     function buy() payable public {
287         uint amount = msg.value / buyPrice;                 
288         _transfer(address(this), msg.sender, amount);      
289     }
290 
291     function sell(uint256 amount) public {
292         address myAddress = address(this);
293         require(myAddress.balance >= amount * sellPrice);   
294         _transfer(msg.sender, address(this), amount);      
295         msg.sender.transfer(amount * sellPrice);           
296     }
297 
298     function createData(string _minerId,string _desc,uint256 _price,address _belong,uint256 _power)public  onlyOwner returns(bool){
299 
300         if(!isGoodAlreadyAdd(_minerId)){
301 
302             good[_minerId].goodId = _minerId;
303             good[_minerId].price = _price;
304             good[_minerId].desc = _desc;
305             good[_minerId].power = _power;
306             good[_minerId].belong = _belong;
307             goods.push(_minerId);
308             emit AddGood(msg.sender,true,"Miner added successfully");
309             return true;
310 
311         }else{
312 
313             emit AddGood(msg.sender,false,"The miner has been added!!!");
314             return false;
315 
316         }
317 
318 
319     }
320 
321     function isGoodAlreadyAdd(string _minerId) internal returns(bool){
322         
323        for(uint256 i= 0;i < goods.length;i++){
324             
325             if(keccak256(goods[i]) == keccak256(_minerId)){
326                 
327                 return true;
328 
329             }
330 
331         }
332 
333         return false;
334 
335     }
336 
337     function buyGood(string _minerId,address _user,uint256 _amount,address _customerEquity) public onlyOwner{
338 
339          if(isGoodAlreadyAdd(_minerId)){
340 
341             if( _amount != 0 ){
342                 
343                 purchasedOfUser.push(_user);
344                 customer[_minerId].minerAmount = _amount;
345                 customer[_minerId].customerAddr = _user;
346                 customer[_minerId].flag = false;
347                 customer[_minerId].customerEquity = _customerEquity;
348                 emit BuyGood(customer[_minerId].customerAddr,true,"Successful purchase of miner");
349                 return;         
350 
351             }else{
352 
353                 emit BuyGood(customer[_minerId].customerAddr,false,"Insufficient balance, failed to purchase miner!!!");
354                 return;
355 
356             }
357 
358         }else{
359 
360             emit BuyGood(customer[_minerId].customerAddr,false,"The miner is not released");
361             return;
362 
363         }
364 
365     }
366 
367   
368     function activeMiner(string _minerId,address _user,bool _flag)public  onlyOwner{
369      
370             customer[_minerId].flag = _flag;
371             activationMiner.push(_user);
372             minerAmount.push(_minerId);
373             emit ActiveMiner(_user,true,"Miner activated");
374             return;
375 
376     }
377 
378     function getMiner() public view returns(address[]){
379         
380         return purchasedOfUser;
381 
382     }
383 
384     function getActiveMiner() public view returns(address[]){
385         
386         return activationMiner; 
387 
388     }
389 
390     function getPersonPower(address _user,string _minerId) public view returns(uint256){
391 
392         uint256 minerIdPower;
393         if(customer[_minerId].customerAddr  == _user && customer[_minerId].flag  == true){
394 
395             minerIdPower += good[_minerId].power;
396             return minerIdPower;
397 
398         }
399          
400     }
401 
402     function getPersonPPP(address user) public view returns(uint256){
403 
404         uint256 person;
405 
406         for(uint256 i = 0;i < minerAmount.length;i++){
407            
408            if( customer[minerAmount[i]].customerAddr == user ){
409 
410              person += good[minerAmount[i]].power;
411 
412            }
413 
414         }
415 
416         return person;
417 
418     }
419 
420     function getTotalPower() public view returns(uint256){
421 
422         uint256 allPower;
423         for(uint256 i = 0;i < minerAmount.length;i++){
424             uint256 pre = getPersonPower(customer[minerAmount[i]].customerAddr,minerAmount[i]);
425             allPower += pre;
426         }
427 
428         return allPower;
429 
430     }
431 
432     function minerReward(string _minerId)public onlyOwner {
433             
434         _transfer(owner,customer[_minerId].customerEquity,rew);
435         emit Transfer(owner,customer[_minerId].customerEquity,rew);
436                       
437     }             
438                           
439 }