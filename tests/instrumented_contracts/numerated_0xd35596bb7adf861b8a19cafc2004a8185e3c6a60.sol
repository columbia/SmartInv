1 pragma solidity ^0.4.24;
2 
3 contract UsdPrice {
4     function USD(uint _id) constant returns (uint256);
5 }
6 
7 /**
8  * @title SafeMath
9  * @dev Math operations with safety checks that throw on error
10  */
11 library SafeMath {
12 
13   /**
14   * @dev Multiplies two numbers, throws on overflow.
15   */
16   function mul(uint256 a, uint256 b) internal pure returns (uint256 c) {
17     if (a == 0) {
18       return 0;
19     }
20     c = a * b;
21     assert(c / a == b);
22     return c;
23   }
24   
25 
26   /**
27   * @dev Integer division of two numbers, truncating the quotient.
28   */
29   function div(uint256 a, uint256 b) internal pure returns (uint256) {
30     // assert(b > 0); // Solidity automatically throws when dividing by 0
31     // uint256 c = a / b;
32     // assert(a == b * c + a % b); // There is no case in which this doesn't hold
33     return a / b;
34   }
35 
36   /**
37   * @dev Subtracts two numbers, throws on overflow (i.e. if subtrahend is greater than minuend).
38   */
39   function sub(uint256 a, uint256 b) internal pure returns (uint256) {
40     assert(b <= a);
41     return a - b;
42   }
43   
44 
45   /**
46   * @dev Adds two numbers, throws on overflow.
47   */
48   function add(uint256 a, uint256 b) internal pure returns (uint256 c) {
49     c = a + b;
50     assert(c >= a);
51     return c;
52   }
53 }
54 
55 
56 /**
57  * @title Ownable
58  * @dev The Ownable contract has an owner address, and provides basic authorization control
59  * functions, this simplifies the implementation of "user permissions".
60  */
61 contract Ownable {
62     
63   address public owner;
64 
65   event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
66 
67 
68   /**
69    * @dev The Ownable constructor sets the original `owner` of the contract to the sender
70    * account.
71    */
72   function Ownable() public {
73     owner = msg.sender;
74   }
75 
76 
77   /**
78    * @dev Throws if called by any account other than the owner.
79    */
80   modifier onlyOwner() {
81     require(msg.sender == owner);
82     _;
83   }
84 
85 
86   /**
87    * @dev Allows the current owner to transfer control of the contract to a newOwner.
88    * @param newOwner The address to transfer ownership to.
89    */
90   function transferOwnership(address newOwner) public onlyOwner {
91     require(newOwner != address(0));
92     OwnershipTransferred(owner, newOwner);
93     owner = newOwner;
94   }
95 }
96 
97 
98 /**
99  * @title ERC20Basic
100  * @dev Simpler version of ERC20 interface
101  * @dev see https://github.com/ethereum/EIPs/issues/179
102  */
103 contract ERC20Basic {
104  // function totalSupply() public view returns (uint256);
105   function balanceOf(address who) public view returns (uint256);
106   function transfer(address to, uint256 value) public returns (bool);
107   event Transfer(address indexed from, address indexed to, uint256 value);
108   string public  name;
109   string public symbol;
110   uint8 public decimals;
111   uint256 public totalSupply;
112 }
113 
114 
115 /**
116  * @title ERC20 interface
117  * @dev see https://github.com/ethereum/EIPs/issues/20
118  */
119 contract ERC20 is ERC20Basic {
120   function allowance(address owner, address spender) public view returns (uint256);
121   function transferFrom(address from, address to, uint256 value) public returns (bool);
122   function approve(address spender, uint256 value) public returns (bool);
123   event Approval(address indexed owner, address indexed spender, uint256 value);
124 }
125 
126 
127 /**
128  * @title Basic token
129  * @dev Basic version of StandardToken, with no allowances.
130  */
131 contract BasicToken is ERC20Basic {
132     
133   using SafeMath for uint256;
134 
135   mapping(address => uint256) balances;
136 
137   uint256 totalSupply_;
138   
139 
140   /**
141   * @dev transfer token for a specified address
142   * @param _to The address to transfer to.
143   * @param _value The amount to be transferred.
144   */
145   function transfer(address _to, uint256 _value) public returns (bool) {
146     require(_to != address(0));
147     require(_value <= balances[msg.sender]);
148 
149     balances[msg.sender] = balances[msg.sender].sub(_value);
150     balances[_to] = balances[_to].add(_value);
151     Transfer(msg.sender, _to, _value);
152     return true;
153   }
154 
155 
156   /**
157   * @dev Gets the balance of the specified address.
158   * @param _owner The address to query the the balance of.
159   * @return An uint256 representing the amount owned by the passed address.
160   */
161   function balanceOf(address _owner) public view returns (uint256) {
162     return balances[_owner];
163   }
164 }
165 
166 
167 /**
168  * @title Standard ERC20 token
169  *
170  * @dev Implementation of the basic standard token.
171  * @dev https://github.com/ethereum/EIPs/issues/20
172  * @dev Based on code by FirstBlood: https://github.com/Firstbloodio/token/blob/master/smart_contract/FirstBloodToken.sol
173  */
174 contract StandardToken is ERC20, BasicToken, Ownable {
175 
176   mapping (address => mapping (address => uint256)) internal allowed;
177 
178 
179   /**
180    * @dev Transfer tokens from one address to another
181    * @param _from address The address which you want to send tokens from
182    * @param _to address The address which you want to transfer to
183    * @param _value uint256 the amount of tokens to be transferred
184    */
185   function transferFrom(address _from, address _to, uint256 _value) public returns (bool) {
186     require(_to != address(0));
187     require(_value <= balances[_from]);
188     require(_value <= allowed[_from][msg.sender]);
189 
190     balances[_from] = balances[_from].sub(_value);
191     balances[_to] = balances[_to].add(_value);
192     allowed[_from][msg.sender] = allowed[_from][msg.sender].sub(_value);
193     Transfer(_from, _to, _value);
194     return true;
195   }
196 
197 
198   /**
199    * @dev Approve the passed address to spend the specified amount of tokens on behalf of msg.sender.
200    *
201    * Beware that changing an allowance with this method brings the risk that someone may use both the old
202    * and the new allowance by unfortunate transaction ordering. One possible solution to mitigate this
203    * race condition is to first reduce the spender's allowance to 0 and set the desired value afterwards:
204    * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
205    * @param _spender The address which will spend the funds.
206    * @param _value The amount of tokens to be spent.
207    */
208   function approve(address _spender, uint256 _value) public returns (bool) {
209     allowed[msg.sender][_spender] = _value;
210     Approval(msg.sender, _spender, _value);
211     return true;
212   }
213   
214 
215   /**
216    * @dev Function to check the amount of tokens that an owner allowed to a spender.
217    * @param _owner address The address which owns the funds.
218    * @param _spender address The address which will spend the funds.
219    * @return A uint256 specifying the amount of tokens still available for the spender.
220    */
221   function allowance(address _owner, address _spender) public view returns (uint256) {
222     return allowed[_owner][_spender];
223   }
224   
225 
226   /**
227    * @dev Increase the amount of tokens that an owner allowed to a spender.
228    *
229    * approve should be called when allowed[_spender] == 0. To increment
230    * allowed value is better to use this function to avoid 2 calls (and wait until
231    * the first transaction is mined)
232    * From MonolithDAO Token.sol
233    * @param _spender The address which will spend the funds.
234    * @param _addedValue The amount of tokens to increase the allowance by.
235    */
236   function increaseApproval(address _spender, uint _addedValue) public returns (bool) {
237     allowed[msg.sender][_spender] = allowed[msg.sender][_spender].add(_addedValue);
238     Approval(msg.sender, _spender, allowed[msg.sender][_spender]);
239     return true;
240   }
241 
242 
243   /**
244    * @dev Decrease the amount of tokens that an owner allowed to a spender.
245    *
246    * approve should be called when allowed[_spender] == 0. To decrement
247    * allowed value is better to use this function to avoid 2 calls (and wait until
248    * the first transaction is mined)
249    * From MonolithDAO Token.sol
250    * @param _spender The address which will spend the funds.
251    * @param _subtractedValue The amount of tokens to decrease the allowance by.
252    */
253   function decreaseApproval(address _spender, uint _subtractedValue) public returns (bool) {
254     uint oldValue = allowed[msg.sender][_spender];
255     if (_subtractedValue > oldValue) {
256       allowed[msg.sender][_spender] = 0;
257     } else {
258       allowed[msg.sender][_spender] = oldValue.sub(_subtractedValue);
259     }
260     Approval(msg.sender, _spender, allowed[msg.sender][_spender]);
261     return true;
262   }
263 }
264 
265 
266 contract MintableToken is StandardToken {
267     
268     event TokensMinted(address indexed to, uint256 value);
269     
270     function mintTokens(address _addr, uint256 _value) public onlyOwner returns(bool) {
271         totalSupply = totalSupply.add(_value);
272         balances[_addr] = balances[_addr].add(_value);
273         emit Transfer(owner, _addr, _value);
274         emit TokensMinted(_addr, _value);
275     }
276 }
277 
278 
279 contract Titanization is MintableToken {
280     
281     function Titanization() public {
282         name = "Titanization";
283         symbol = "TXDM";
284         decimals = 0;
285         totalSupply = 0;
286         balances[owner] = totalSupply;
287         Transfer(address(this), owner, totalSupply);
288     }
289 }
290 
291 
292 
293 contract ICO is Ownable {
294     
295     using SafeMath for uint256;
296     
297     Titanization public TXDM;
298     
299     UsdPrice public constant FIAT = UsdPrice(0x8055d0504666e2B6942BeB8D6014c964658Ca591);
300     address public constant RESERVE_ADDRESS = 0xF21DAa0CeC36C0d8dC64B5351119888c5a7CFc4d;
301     
302     uint256 private minTokenPurchase;
303     uint256 private tokensSold;
304     uint256 private hardCap;
305     uint256 private softCap;
306     bool private IcoTerminated;
307     uint256 private tokenPrice;
308     
309     
310     constructor() public {
311         TXDM = new Titanization();
312         minTokenPurchase = 50;
313         hardCap = 65000000;
314         softCap = 10000000;
315         IcoTerminated = false;
316         tokenPrice = 500;
317     }
318     
319     function terminateICO() public onlyOwner returns(bool) {
320         require(!IcoTerminated);
321         IcoTerminated = true;
322         return true;
323     }
324     
325     function activateICO() public onlyOwner returns(bool) {
326         require(IcoTerminated);
327         IcoTerminated = false;
328         return true;
329     }
330     
331     function IcoActive() public view returns(bool) {
332         return (!IcoTerminated);
333     }
334     
335     function getHardCap() public view returns(uint256) {
336         return hardCap;
337     }
338     
339     function changeHardCap(uint256 _newHardCap) public onlyOwner returns(bool) {
340         require(hardCap != _newHardCap && _newHardCap >= tokensSold && _newHardCap > softCap);
341         hardCap = _newHardCap;
342         return true;
343     }
344     
345     function getSoftCap() public view returns(uint256) {
346         return softCap;
347     }
348     
349     function changeSoftCap(uint256 _newSoftCap) public onlyOwner returns(bool) {
350         require(_newSoftCap != softCap && _newSoftCap < hardCap);
351         softCap = _newSoftCap;
352         return true;
353     }
354     
355     function getTokensSold() public view returns(uint256) {
356         return tokensSold;
357     }
358     
359     function changeTokenPrice(uint256 _newTokenPrice) public onlyOwner returns(bool) {
360         tokenPrice = _newTokenPrice;
361         return true;
362     }
363     
364     function getTokenPrice() public view returns(uint256) {
365         return FIAT.USD(0).mul(tokenPrice);
366     }
367     
368     function getMinInvestment() public view returns(uint256) {
369         return getTokenPrice().mul(minTokenPurchase);
370     }
371     
372     function getMinTokenPurchase() public view returns(uint256) {
373         return minTokenPurchase;
374     }
375     
376     function setMinTokenPurchase(uint256 _minTokens) public onlyOwner returns(bool) {
377         require(minTokenPurchase != _minTokens);
378         minTokenPurchase = _minTokens;
379         return true;
380     }
381     
382     function() public payable {
383         buyTokens(msg.sender);
384     }
385     
386     function buyTokens(address _addr) public payable returns(bool) {
387         uint256 tokenPrice = getTokenPrice();
388         require(
389             msg.value >= getMinInvestment() && msg.value % tokenPrice == 0
390             || TXDM.balanceOf(msg.sender) >= minTokenPurchase && msg.value % tokenPrice == 0
391         );
392         require(tokensSold.add(msg.value.div(tokenPrice)) <= hardCap);
393         require(!IcoTerminated);
394         TXDM.mintTokens(_addr, msg.value.div(tokenPrice));
395         tokensSold = tokensSold.add(msg.value.div(tokenPrice));
396         owner.transfer(msg.value);
397         return true;
398     }
399     
400     function claimReserveTokens(uint256 _value) public onlyOwner returns(bool) {
401         TXDM.mintTokens(RESERVE_ADDRESS, _value);
402         return true;
403     }
404     
405     function transferTokenOwnership(address _newOwner) public onlyOwner returns(bool) {
406         TXDM.transferOwnership(_newOwner);
407     }
408 }