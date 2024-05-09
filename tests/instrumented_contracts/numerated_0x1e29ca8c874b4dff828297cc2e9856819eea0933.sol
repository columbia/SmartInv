1 pragma solidity ^0.4.16;
2 
3 contract owned {
4     address public owner;
5 
6     function owned() public {
7         owner = msg.sender;
8     }
9 
10     modifier onlyOwner {
11         require(msg.sender == owner);
12         _;
13     }
14 
15     function transferOwnership(address newOwner) onlyOwner public {
16         owner = newOwner;
17     }
18 }
19 
20 interface tokenRecipient { function receiveApproval(address _from, uint256 _value, address _token, bytes _extraData) external; }
21 
22 contract TOURISTOKEN {
23     string public name;
24     string public symbol;
25     uint8 public decimals = 18;
26     uint256 public totalSupply;
27 
28     mapping (address => uint256) public balanceOf;
29     mapping (address => mapping (address => uint256)) public allowance;
30 
31     event Transfer(address indexed from, address indexed to, uint256 value);
32 
33     event Burn(address indexed from, uint256 value);
34 
35     /**
36      * Constrctor function
37      *
38      * Initializes contract with initial supply tokens to the creator of the contract
39      */
40     function TokenERC20(
41         uint256 initialSupply,
42         string tokenName,
43         string tokenSymbol
44     ) public {
45         totalSupply = 777777777000000000000000000;  
46         balanceOf[msg.sender] = totalSupply;               
47         name = "TOURISTOKEN";                                   
48         symbol = "TOU";                               
49     }
50 
51     /**
52      * Internal transfer, only can be called by this contract
53      */
54     function _transfer(address _from, address _to, uint _value) internal {
55         require(_to != 0x0);
56         require(balanceOf[_from] >= _value);
57         require(balanceOf[_to] + _value > balanceOf[_to]);
58         uint previousBalances = balanceOf[_from] + balanceOf[_to];
59         balanceOf[_from] -= _value;
60         balanceOf[_to] += _value;
61         emit Transfer(_from, _to, _value);
62         assert(balanceOf[_from] + balanceOf[_to] == previousBalances);
63     }
64 
65     /**
66      * Transfer tokens
67      *
68      * Send `_value` tokens to `_to` from your account
69      *
70      * @param _to The address of the recipient
71      * @param _value the amount to send
72      */
73     function transfer(address _to, uint256 _value) public returns (bool success) {
74         _transfer(msg.sender, _to, _value);
75         return true;
76     }
77 
78     /**
79      * Transfer tokens from other address
80      *
81      * Send `_value` tokens to `_to` in behalf of `_from`
82      *
83      * @param _from The address of the sender
84      * @param _to The address of the recipient
85      * @param _value the amount to send
86      */
87     function transferFrom(address _from, address _to, uint256 _value) public returns (bool success) {
88         require(_value <= allowance[_from][msg.sender]);    
89         allowance[_from][msg.sender] -= _value;
90         _transfer(_from, _to, _value);
91         return true;
92     }
93 
94     /**
95      * Set allowance for other address
96      *
97      * Allows `_spender` to spend no more than `_value` tokens in your behalf
98      *
99      * @param _spender The address authorized to spend
100      * @param _value the max amount they can spend
101      */
102     function approve(address _spender, uint256 _value) public
103         returns (bool success) {
104         allowance[msg.sender][_spender] = _value;
105         return true;
106     }
107 
108     /**
109      * Set allowance for other address and notify
110      *
111      * Allows `_spender` to spend no more than `_value` tokens in your behalf, and then ping the contract about it
112      *
113      * @param _spender The address authorized to spend
114      * @param _value the max amount they can spend
115      * @param _extraData some extra information to send to the approved contract
116      */
117     function approveAndCall(address _spender, uint256 _value, bytes _extraData)
118         public
119         returns (bool success) {
120         tokenRecipient spender = tokenRecipient(_spender);
121         if (approve(_spender, _value)) {
122             spender.receiveApproval(msg.sender, _value, this, _extraData);
123             return true;
124         }
125     }
126 
127     /**
128      * Destroy tokens
129      *
130      * Remove `_value` tokens from the system irreversibly
131      *
132      * @param _value the amount of money to burn
133      */
134     function burn(uint256 _value) public returns (bool success) {
135         require(balanceOf[msg.sender] >= _value);   
136         balanceOf[msg.sender] -= _value;            
137         totalSupply -= _value;                      
138         emit Burn(msg.sender, _value);
139         return true;
140     }
141 
142     /**
143      * Destroy tokens from other account
144      *
145      * Remove `_value` tokens from the system irreversibly on behalf of `_from`.
146      *
147      * @param _from the address of the sender
148      * @param _value the amount of money to burn
149      */
150     function burnFrom(address _from, uint256 _value) public returns (bool success) {
151         require(balanceOf[_from] >= _value);                
152         require(_value <= allowance[_from][msg.sender]);    
153         balanceOf[_from] -= _value;                         
154         allowance[_from][msg.sender] -= _value;             
155         totalSupply -= _value;                              
156         emit Burn(_from, _value);
157         return true;
158     }
159 }
160 
161 contract MyAdvancedToken is owned, TOURISTOKEN {
162 
163     uint256 public sellPrice;
164     uint256 public buyPrice;
165 
166     mapping (address => bool) public frozenAccount;
167 
168     event FrozenFunds(address target, bool frozen);
169 
170     function MyAdvancedToken(
171         uint256 initialSupply,
172         string tokenName,
173         string tokenSymbol
174      )MyAdvancedToken(initialSupply, tokenName, tokenSymbol) public {}
175 
176     function _transfer(address _from, address _to, uint _value) internal {
177         require (_to != 0x0);                               
178         require (balanceOf[_from] >= _value);              
179         require (balanceOf[_to] + _value >= balanceOf[_to]); 
180         require(!frozenAccount[_from]);                     
181         require(!frozenAccount[_to]);                       
182         balanceOf[_from] -= _value;                         
183         balanceOf[_to] += _value;                           
184         emit Transfer(_from, _to, _value);
185     }
186 
187     function mint(address target, uint256 mintedAmount) onlyOwner public {
188         balanceOf[target] += mintedAmount;
189         totalSupply += mintedAmount;
190         emit Transfer(0, this, mintedAmount);
191         emit Transfer(this, target, mintedAmount);
192     }
193 
194     
195     function freezeAccount(address target, bool freeze) onlyOwner public {
196         frozenAccount[target] = freeze;
197         emit FrozenFunds(target, freeze);
198     }
199 
200     
201     function setPrices(uint256 newSellPrice, uint256 newBuyPrice) onlyOwner public {
202         sellPrice = newSellPrice;
203         buyPrice = newBuyPrice;
204     }
205 
206     
207     function buy() payable public {
208         uint amount = msg.value /buyPrice ;              
209         _transfer(this, msg.sender, amount);              
210     }
211 
212     
213     function sell(uint256 amount) public {
214         address myAddress = this;
215         require(myAddress.balance >= amount * sellPrice);      
216         _transfer(msg.sender, this, amount);              
217         msg.sender.transfer(amount * sellPrice);          
218     }
219 }
220 
221 
222 /**
223  * @title SafeMath
224  * @dev Math operations with safety checks that throw on error
225  */
226 library SafeMath {
227   function mul(uint256 a, uint256 b) internal pure returns (uint256) {
228     if (a == 0) {
229       return 0;
230     }
231     uint256 c = a * b;
232     assert(c / a == b);
233     return c;
234   }
235 
236   function div(uint256 a, uint256 b) internal pure returns (uint256) {
237     uint256 c = a / b;
238     return c;
239   }
240 
241   function sub(uint256 a, uint256 b) internal pure returns (uint256) {
242     assert(b <= a);
243     return a - b;
244   }
245 
246   function add(uint256 a, uint256 b) internal pure returns (uint256) {
247     uint256 c = a + b;
248     assert(c >= a);
249     return c;
250   }
251 }
252 /**
253  * Constrctor function
254   function totalSupply() public constant returns (uint256 supply);
255 
256   function balanceOf(address _owner) public constant returns (uint256 balance);
257 
258   function transfer(address _to, uint256 _value) public returns (bool success);
259 
260   function transferFrom(address _from, address _to, uint256 _value) public returns (bool success);
261 
262   function approve(address _spender, uint256 _value) public returns (bool success);
263 
264   function allowance(address _owner, address _spender) public constant returns (uint256 remaining);
265 
266   event Transfer(address indexed _from, address indexed _to, uint256 _value);
267   event Approval(address indexed _owner, address indexed _spender, uint256 _value);
268 
269   uint public decimals;
270   string public name;
271 }
272 
273 /**
274  * @title Ownable
275  * @dev The Ownable contract has an owner address, and provides basic authorization control
276  * functions, this simplifies the implementation of "user permissions".
277  */
278 contract Ownable {
279     
280   address public owner;
281 
282   /**
283    * @dev The Ownable constructor sets the original `owner` of the contract to the sender
284    * account.
285    */
286   constructor() public {
287     owner = msg.sender;
288   }
289 
290   /**
291    * @dev Throws if called by any account other than the owner.
292    */
293   modifier onlyOwner() {
294     require(msg.sender == owner);
295     _;
296   }
297 
298   /**
299    * @dev Allows the current owner to transfer control of the contract to a newOwner.
300    * @param newOwner The address to transfer ownership to.
301    */
302   function transferOwnership(address newOwner) onlyOwner public {
303     require(newOwner != address(0));      
304     owner = newOwner;
305   }
306 
307 }
308 contract Gateway is Ownable{
309     using SafeMath for uint;
310     address public feeAccount1 = 0xcAc496756f98a4E6e4e56f14e46A6824608a29a2; 
311     address public feeAccount2 = 0xE4BD9Cb073A247911A520BbDcBE0e8C2492be346; 
312     address public feeAccountToken = 0x5D151cdD1833237ACb2Fef613F560221230D77c5;
313     
314     struct BuyInfo {
315       address buyerAddress; 
316       address sellerAddress;
317       uint value;
318       address currency;
319     }
320     
321     mapping(address => mapping(uint => BuyInfo)) public payment;
322    
323     uint balanceFee;
324     uint public feePercent;
325     uint public maxFee;
326     constructor() public{
327        feePercent = 1500000; 
328        maxFee = 3000000; 
329     }
330     
331     
332     function getBuyerAddressPayment(address _sellerAddress, uint _orderId) public view returns(address){
333       return  payment[_sellerAddress][_orderId].buyerAddress;
334     }    
335     function getSellerAddressPayment(address _sellerAddress, uint _orderId) public view returns(address){
336       return  payment[_sellerAddress][_orderId].sellerAddress;
337     }    
338     
339     function getValuePayment(address _sellerAddress, uint _orderId) public view returns(uint){
340       return  payment[_sellerAddress][_orderId].value;
341     }    
342     
343     function getCurrencyPayment(address _sellerAddress, uint _orderId) public view returns(address){
344       return  payment[_sellerAddress][_orderId].currency;
345     }
346     
347     
348     function setFeeAccount1(address _feeAccount1) onlyOwner public{
349       feeAccount1 = _feeAccount1;  
350     }
351     function setFeeAccount2(address _feeAccount2) onlyOwner public{
352       feeAccount2 = _feeAccount2;  
353     }
354     function setFeeAccountToken(address _feeAccountToken) onlyOwner public{
355       feeAccountToken = _feeAccountToken;  
356     }    
357     function setFeePercent(uint _feePercent) onlyOwner public{
358       require(_feePercent <= maxFee);
359       feePercent = _feePercent;  
360     }    
361     function payToken(address _tokenAddress, address _sellerAddress, uint _orderId,  uint _value) public returns (bool success){
362       require(_tokenAddress != address(0));
363       require(_sellerAddress != address(0)); 
364       require(_value > 0);
365       TOURISTOKEN token = TOURISTOKEN(_tokenAddress);
366       require(token.allowance(msg.sender, this) >= _value);
367       token.transferFrom(msg.sender, feeAccountToken, _value.mul(feePercent).div(100000000));
368       token.transferFrom(msg.sender, _sellerAddress, _value.sub(_value.mul(feePercent).div(100000000)));
369       payment[_sellerAddress][_orderId] = BuyInfo(msg.sender, _sellerAddress, _value, _tokenAddress);
370       success = true;
371     }
372     function payEth(address _sellerAddress, uint _orderId, uint _value) internal returns  (bool success){
373       require(_sellerAddress != address(0)); 
374       require(_value > 0);
375       uint fee = _value.mul(feePercent).div(100000000);
376       _sellerAddress.transfer(_value.sub(fee));
377       balanceFee = balanceFee.add(fee);
378       payment[_sellerAddress][_orderId] = BuyInfo(msg.sender, _sellerAddress, _value, 0x0000000000000000000000000000000000000001);    
379       success = true;
380     }
381     function transferFee() onlyOwner public{
382       uint valfee1 = balanceFee.div(2);
383       feeAccount1.transfer(valfee1);
384       balanceFee = balanceFee.sub(valfee1);
385       feeAccount2.transfer(balanceFee);
386       balanceFee = 0;
387     }
388     function balanceOfToken(address _tokenAddress, address _Address) public view returns (uint) {
389       TOURISTOKEN token = TOURISTOKEN(_tokenAddress);
390       return token.balanceOf(_Address);
391     }
392     function balanceOfEthFee() public view returns (uint) {
393       return balanceFee;
394     }
395     function bytesToAddress(bytes source) internal pure returns(address) {
396       uint result;
397       uint mul = 1;
398       for(uint i = 20; i > 0; i--) {
399         result += uint8(source[i-1])*mul;
400         mul = mul*256;
401       }
402       return address(result);
403     }
404     function() external payable {
405       require(msg.data.length == 20); 
406       require(msg.value > 99999999999);
407       address sellerAddress = bytesToAddress(bytes(msg.data));
408       uint value = msg.value.div(10000000000).mul(10000000000);
409       uint orderId = msg.value.sub(value);
410       balanceFee = balanceFee.add(orderId);
411       payEth(sellerAddress, orderId, value);
412   }
413 }