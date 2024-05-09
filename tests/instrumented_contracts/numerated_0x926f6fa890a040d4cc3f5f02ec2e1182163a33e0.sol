1 pragma solidity ^0.4.18;
2 
3 
4 /**
5  * @title SafeMath
6  * @dev Math operations with safety checks that throw on error
7  */
8 library SafeMath {
9 
10   /**
11   * @dev Multiplies two numbers, throws on overflow.
12   */
13   function mul(uint256 a, uint256 b) internal pure returns (uint256) {
14     if (a == 0) {
15       return 0;
16     }
17     uint256 c = a * b;
18     assert(c / a == b);
19     return c;
20   }
21 
22   /**
23   * @dev Integer division of two numbers, truncating the quotient.
24   */
25   function div(uint256 a, uint256 b) internal pure returns (uint256) {
26     // assert(b > 0); // Solidity automatically throws when dividing by 0
27     uint256 c = a / b;
28     // assert(a == b * c + a % b); // There is no case in which this doesn't hold
29     return c;
30   }
31 
32   /**
33   * @dev Substracts two numbers, throws on overflow (i.e. if subtrahend is greater than minuend).
34   */
35   function sub(uint256 a, uint256 b) internal pure returns (uint256) {
36     assert(b <= a);
37     return a - b;
38   }
39 
40   /**
41   * @dev Adds two numbers, throws on overflow.
42   */
43   function add(uint256 a, uint256 b) internal pure returns (uint256) {
44     uint256 c = a + b;
45     assert(c >= a);
46     return c;
47   }
48 }
49 
50 
51 /**
52  * @title ERC20Basic
53  * @dev Simpler version of ERC20 interface
54  * @dev see https://github.com/ethereum/EIPs/issues/179
55  */
56 contract ERC20Basic {
57   function totalSupply() public view returns (uint256);
58   function balanceOf(address who) public view returns (uint256);
59   function transfer(address to, uint256 value) public returns (bool);
60   event Transfer(address indexed from, address indexed to, uint256 value);
61 }
62 
63 
64 /**
65  * @title ERC20 interface
66  * @dev see https://github.com/ethereum/EIPs/issues/20
67  */
68 contract ERC20 is ERC20Basic {
69   function allowance(address owner, address spender) public view returns (uint256);
70   function transferFrom(address from, address to, uint256 value) public returns (bool);
71   function approve(address spender, uint256 value) public returns (bool);
72   event Approval(address indexed owner, address indexed spender, uint256 value);
73 }
74 
75 
76 
77 /**
78  * @title Basic token
79  * @dev Basic version of StandardToken, with no allowances.
80  */
81 contract BasicToken is ERC20Basic {
82   using SafeMath for uint256;
83 
84   mapping(address => uint256) balances;
85 
86   uint256 totalSupply_;
87 
88   /**
89   * @dev total number of tokens in existence
90   */
91   function totalSupply() public view returns (uint256) {
92     return totalSupply_;
93   }
94 
95   /**
96   * @dev transfer token for a specified address
97   * @param _to The address to transfer to.
98   * @param _value The amount to be transferred.
99   */
100   function transfer(address _to, uint256 _value) public returns (bool) {
101     require(_to != address(0));
102     require(_value <= balances[msg.sender]);
103 
104     // SafeMath.sub will throw if there is not enough balance.
105     balances[msg.sender] = balances[msg.sender].sub(_value);
106     balances[_to] = balances[_to].add(_value);
107     Transfer(msg.sender, _to, _value);
108     return true;
109   }
110 
111   /**
112   * @dev Gets the balance of the specified address.
113   * @param _owner The address to query the the balance of.
114   * @return An uint256 representing the amount owned by the passed address.
115   */
116   function balanceOf(address _owner) public view returns (uint256 balance) {
117     return balances[_owner];
118   }
119 
120 }
121 
122 
123 /**
124  * @title Ownable
125  * @dev The Ownable contract has an owner address, and provides basic authorization control
126  * functions, this simplifies the implementation of "user permissions".
127  */
128 contract Ownable {
129   address public owner;
130 
131 
132   event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
133 
134 
135   /**
136    * @dev The Ownable constructor sets the original `owner` of the contract to the sender
137    * account.
138    */
139   function Ownable() public {
140     owner = msg.sender;
141   }
142 
143   /**
144    * @dev Throws if called by any account other than the owner.
145    */
146   modifier onlyOwner() {
147     require(msg.sender == owner);
148     _;
149   }
150 
151   /**
152    * @dev Allows the current owner to transfer control of the contract to a newOwner.
153    * @param newOwner The address to transfer ownership to.
154    */
155   function transferOwnership(address newOwner) public onlyOwner {
156     require(newOwner != address(0));
157     OwnershipTransferred(owner, newOwner);
158     owner = newOwner;
159   }
160 
161 }
162 
163 
164 /**
165  * @title Standard ERC20 token
166  *
167  * @dev Implementation of the basic standard token.
168  * @dev https://github.com/ethereum/EIPs/issues/20
169  * @dev Based on code by FirstBlood: https://github.com/Firstbloodio/token/blob/master/smart_contract/FirstBloodToken.sol
170  */
171 contract StandardToken is ERC20, BasicToken {
172 
173   mapping (address => mapping (address => uint256)) internal allowed;
174 
175 
176   /**
177    * @dev Transfer tokens from one address to another
178    * @param _from address The address which you want to send tokens from
179    * @param _to address The address which you want to transfer to
180    * @param _value uint256 the amount of tokens to be transferred
181    */
182   function transferFrom(address _from, address _to, uint256 _value) public returns (bool) {
183     require(_to != address(0));
184     require(_value <= balances[_from]);
185     require(_value <= allowed[_from][msg.sender]);
186 
187     balances[_from] = balances[_from].sub(_value);
188     balances[_to] = balances[_to].add(_value);
189     allowed[_from][msg.sender] = allowed[_from][msg.sender].sub(_value);
190     Transfer(_from, _to, _value);
191     return true;
192   }
193 
194   /**
195    * @dev Approve the passed address to spend the specified amount of tokens on behalf of msg.sender.
196    *
197    * Beware that changing an allowance with this method brings the risk that someone may use both the old
198    * and the new allowance by unfortunate transaction ordering. One possible solution to mitigate this
199    * race condition is to first reduce the spender's allowance to 0 and set the desired value afterwards:
200    * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
201    * @param _spender The address which will spend the funds.
202    * @param _value The amount of tokens to be spent.
203    */
204   function approve(address _spender, uint256 _value) public returns (bool) {
205     allowed[msg.sender][_spender] = _value;
206     Approval(msg.sender, _spender, _value);
207     return true;
208   }
209 
210   /**
211    * @dev Function to check the amount of tokens that an owner allowed to a spender.
212    * @param _owner address The address which owns the funds.
213    * @param _spender address The address which will spend the funds.
214    * @return A uint256 specifying the amount of tokens still available for the spender.
215    */
216   function allowance(address _owner, address _spender) public view returns (uint256) {
217     return allowed[_owner][_spender];
218   }
219 
220   /**
221    * @dev Increase the amount of tokens that an owner allowed to a spender.
222    *
223    * approve should be called when allowed[_spender] == 0. To increment
224    * allowed value is better to use this function to avoid 2 calls (and wait until
225    * the first transaction is mined)
226    * From MonolithDAO Token.sol
227    * @param _spender The address which will spend the funds.
228    * @param _addedValue The amount of tokens to increase the allowance by.
229    */
230   function increaseApproval(address _spender, uint _addedValue) public returns (bool) {
231     allowed[msg.sender][_spender] = allowed[msg.sender][_spender].add(_addedValue);
232     Approval(msg.sender, _spender, allowed[msg.sender][_spender]);
233     return true;
234   }
235 
236   /**
237    * @dev Decrease the amount of tokens that an owner allowed to a spender.
238    *
239    * approve should be called when allowed[_spender] == 0. To decrement
240    * allowed value is better to use this function to avoid 2 calls (and wait until
241    * the first transaction is mined)
242    * From MonolithDAO Token.sol
243    * @param _spender The address which will spend the funds.
244    * @param _subtractedValue The amount of tokens to decrease the allowance by.
245    */
246   function decreaseApproval(address _spender, uint _subtractedValue) public returns (bool) {
247     uint oldValue = allowed[msg.sender][_spender];
248     if (_subtractedValue > oldValue) {
249       allowed[msg.sender][_spender] = 0;
250     } else {
251       allowed[msg.sender][_spender] = oldValue.sub(_subtractedValue);
252     }
253     Approval(msg.sender, _spender, allowed[msg.sender][_spender]);
254     return true;
255   }
256 }
257 
258 
259 contract OilVisionShare is StandardToken, Ownable {
260     using SafeMath for uint;
261 
262     string public name = "Oil Vision Share";
263     string public symbol = "OVS";
264 	
265     string public constant description = "http://oil.vision The oil.vision Project is an investment platform managed by the Japanese company eKen. We invest in the oil industry around the world. In our project we use both traditional investments in yen and modern investments in cryptocurrency.";
266 	
267     uint public decimals = 2;
268 	uint public constant INITIAL_SUPPLY = 1000000000 * 10**2 ;
269 
270 	/* Distributors */
271     mapping (address => bool) public distributors;
272 	/* Distributors amount */
273     mapping (address => uint) private distributorsAmount;
274 	
275 	address[] public distributorsList;
276 
277     bool public byuoutActive;
278     uint public byuoutCount;
279     uint public priceForBasePart;
280 
281     function OilVisionShare() public {
282         totalSupply_ = INITIAL_SUPPLY;
283         balances[msg.sender] = INITIAL_SUPPLY;
284     }
285 
286 	/* Token can receive ETH */
287     function() external payable {
288 
289     }
290 
291 	/* define who can transfer Tokens: owner and distributors */
292     modifier canTransfer() {
293         require(distributors[msg.sender] || msg.sender == owner);
294         _;
295     }
296 	
297 	/* set distributor for address: state true/false = on/off distributing */
298     function setDistributor(address distributor, bool state, uint amount) external onlyOwner{
299 		distributorsList.push(distributor);
300         distributors[distributor] = state;
301 		/* new */
302         distributorsAmount[distributor] = amount;
303     }
304 	/* set distributor for address: state true/false = on/off distributing */
305     function setDistributorAmount(address distributor, bool state, uint amount) external onlyOwner{
306         distributors[distributor] = state;
307         distributorsAmount[distributor] = amount;
308     }
309 	
310 	
311 	/* buyout mode is set to flag "status" value, true/false */
312     function setByuoutActive(bool status) public onlyOwner {
313         byuoutActive = status;
314     }
315 
316 	/* set Max token count to buyout */
317     function setByuoutCount(uint count) public onlyOwner {
318         byuoutCount = count;
319     }
320 
321 	/* set Token base-part prise in "wei" */
322     function setPriceForBasePart(uint newPriceForBasePart) public onlyOwner {
323         priceForBasePart = newPriceForBasePart;
324     }
325 
326 	/* send Tokens to any investor by owner or distributor */
327     function sendToInvestor(address investor, uint value) public canTransfer {
328         require(investor != 0x0 && value > 0);
329         require(value <= balances[owner]);
330 
331 		/* new */
332 		require(distributorsAmount[msg.sender] >= value && value > 0);
333 		distributorsAmount[msg.sender] = distributorsAmount[msg.sender].sub(value);
334 		
335         balances[owner] = balances[owner].sub(value);
336         balances[investor] = balances[investor].add(value);
337         addTokenHolder(investor);
338         Transfer(owner, investor, value);
339     }
340 
341 	/* transfer method, with byuout */
342     function transfer(address to, uint value) public returns (bool success) {
343         require(to != 0x0 && value > 0);
344 
345         if(to == owner && byuoutActive && byuoutCount > 0){
346             uint bonus = 0 ;
347             if(value > byuoutCount){
348                 bonus = byuoutCount.mul(priceForBasePart);
349                 byuoutCount = 0;
350             }else{
351                 bonus = value.mul(priceForBasePart);
352                 byuoutCount = byuoutCount.sub(value);
353             }
354             msg.sender.transfer(bonus);
355         }
356 
357         addTokenHolder(to);
358         return super.transfer(to, value);
359     }
360 
361     function transferFrom(address from, address to, uint value) public returns (bool success) {
362         require(to != 0x0 && value > 0);
363         addTokenHolder(to);
364         return super.transferFrom(from, to, value);
365     }
366 
367     /* Token holders */
368 
369     mapping(uint => address) public indexedTokenHolders;
370     mapping(address => uint) public tokenHolders;
371     uint public tokenHoldersCount = 0;
372 
373     function addTokenHolder(address investor) private {
374         if(investor != owner && indexedTokenHolders[0] != investor && tokenHolders[investor] == 0){
375             tokenHolders[investor] = tokenHoldersCount;
376             indexedTokenHolders[tokenHoldersCount] = investor;
377             tokenHoldersCount ++;
378         }
379     }
380 }