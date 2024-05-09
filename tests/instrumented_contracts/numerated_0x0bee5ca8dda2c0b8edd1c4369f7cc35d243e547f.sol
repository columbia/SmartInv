1 pragma solidity ^0.4.19;
2 
3 /**
4  * Virtual Cash (VCA) Token 
5  *
6  * This is a very simple token with the following properties:
7  *  - 20.000.000 tokens maximum supply
8  *  - 15.000.000 crowdsale allocation
9  *  - 5.000.000 initial supply to be use for Bonus, Airdrop, Marketing, Ads, Bounty, Future Dev, Reserved tokens
10  *  - Investor receives bonus tokens from Company Wallet during bonus phases
11  * 
12  * Visit https://virtualcash.shop for more information and token holder benefits.
13  */
14 
15 	/**
16 	* @title SafeMath
17 	* @dev Math operations with safety checks that throw on error
18 	*/
19 library SafeMath {
20   function mul(uint256 a, uint256 b) internal pure returns (uint256) {
21     uint256 c = a * b;
22     assert(a == 0 || c / a == b);
23     return c;
24   }
25 
26   function div(uint256 a, uint256 b) internal pure returns (uint256) {
27     // assert(b > 0); // Solidity automatically throws when dividing by 0
28     uint256 c = a / b;
29     // assert(a == b * c + a % b); // There is no case in which this doesn't hold
30     return c;
31   }
32 
33   function sub(uint256 a, uint256 b) internal pure returns (uint256) {
34     assert(b <= a);
35     return a - b;
36   }
37 
38   function add(uint256 a, uint256 b) internal pure returns (uint256) {
39     uint256 c = a + b;
40     assert(c >= a);
41     return c;
42   }
43 }
44 
45 	/**
46 	* @title ERC20Basic
47 	* @dev Simpler version of ERC20 interface
48 	* @dev see https://github.com/ethereum/EIPs/issues/179
49 	*/
50 contract ERC20Basic {
51   uint256 public totalSupply;
52   function balanceOf(address who) public view returns (uint256);
53   function transfer(address to, uint256 value) public returns (bool);
54   event Transfer(address indexed from, address indexed to, uint256 value);
55 }
56 
57 	/**
58 	* @title Basic token
59 	* @dev Basic version of StandardToken, with no allowances.
60 	*/
61 contract BasicToken is ERC20Basic {
62   using SafeMath for uint256;
63 
64   mapping(address => uint256) balances;
65 
66 	/**
67 	* @dev transfer token for a specified address
68 	* @param _to The address to transfer to.
69 	* @param _value The amount to be transferred.
70 	*/
71   function transfer(address _to, uint256 _value) public returns (bool) {
72     require(_to != address(0));
73     require(_value <= balances[msg.sender]);
74 
75     // SafeMath.sub will throw if there is not enough balance.
76     balances[msg.sender] = balances[msg.sender].sub(_value);
77     balances[_to] = balances[_to].add(_value);
78     Transfer(msg.sender, _to, _value);
79     return true;
80   }
81 
82 	/**
83 	* @dev Gets the balance of the specified address.
84 	* @param _owner The address to query the the balance of.
85 	* @return An uint256 representing the amount owned by the passed address.
86 	*/
87   function balanceOf(address _owner) public view returns (uint256 balance) {
88     return balances[_owner];
89   }
90 
91 }
92 
93 	/**
94 	* @title ERC20 interface
95 	* @dev see https://github.com/ethereum/EIPs/issues/20
96 	*/
97 contract ERC20 is ERC20Basic {
98   function allowance(address owner, address spender) public view returns (uint256);
99   function transferFrom(address from, address to, uint256 value) public returns (bool);
100   function approve(address spender, uint256 value) public returns (bool);
101   event Approval(address indexed owner, address indexed spender, uint256 value);
102 }
103 
104 	/**
105 	* @title Standard ERC20 token
106 	*
107 	* @dev Implementation of the basic standard token.
108 	* @dev https://github.com/ethereum/EIPs/issues/20
109 	* @dev Based on code by FirstBlood: https://github.com/Firstbloodio/token/blob/master/smart_contract/FirstBloodToken.sol
110 	*/
111 contract StandardToken is ERC20, BasicToken {
112 
113   mapping (address => mapping (address => uint256)) internal allowed;
114 
115 	/**
116 	* @dev Transfer tokens from one address to another
117 	* @param _from address The address which you want to send tokens from
118 	* @param _to address The address which you want to transfer to
119 	* @param _value uint256 the amount of tokens to be transferred
120 	*/
121   function transferFrom(address _from, address _to, uint256 _value) public returns (bool) {
122     require(_to != address(0));
123     require(_value <= balances[_from]);
124     require(_value <= allowed[_from][msg.sender]);
125 
126     balances[_from] = balances[_from].sub(_value);
127     balances[_to] = balances[_to].add(_value);
128     allowed[_from][msg.sender] = allowed[_from][msg.sender].sub(_value);
129     Transfer(_from, _to, _value);
130     return true;
131   }
132 
133 	/**
134 	* @dev Approve the passed address to spend the specified amount of tokens on behalf of msg.sender.
135 	*
136 	* Beware that changing an allowance with this method brings the risk that someone may use both the old
137 	* and the new allowance by unfortunate transaction ordering. One possible solution to mitigate this
138 	* race condition is to first reduce the spender's allowance to 0 and set the desired value afterwards:
139 	* https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
140 	* @param _spender The address which will spend the funds.
141 	* @param _value The amount of tokens to be spent.
142 	*/
143   function approve(address _spender, uint256 _value) public returns (bool) {
144     allowed[msg.sender][_spender] = _value;
145     Approval(msg.sender, _spender, _value);
146     return true;
147   }
148 
149 	/**
150 	* @dev Function to check the amount of tokens that an owner allowed to a spender.
151 	* @param _owner address The address which owns the funds.
152 	* @param _spender address The address which will spend the funds.
153 	* @return A uint256 specifying the amount of tokens still available for the spender.
154 	*/
155   function allowance(address _owner, address _spender) public view returns (uint256) {
156     return allowed[_owner][_spender];
157   }
158 
159 	/**
160 	* approve should be called when allowed[_spender] == 0. To increment
161 	* allowed value is better to use this function to avoid 2 calls (and wait until
162 	* the first transaction is mined)
163 	* From MonolithDAO Token.sol
164 	*/
165   function increaseApproval(address _spender, uint _addedValue) public returns (bool) {
166     allowed[msg.sender][_spender] = allowed[msg.sender][_spender].add(_addedValue);
167     Approval(msg.sender, _spender, allowed[msg.sender][_spender]);
168     return true;
169   }
170 
171   function decreaseApproval(address _spender, uint _subtractedValue) public returns (bool) {
172     uint oldValue = allowed[msg.sender][_spender];
173     if (_subtractedValue > oldValue) {
174       allowed[msg.sender][_spender] = 0;
175     } else {
176       allowed[msg.sender][_spender] = oldValue.sub(_subtractedValue);
177     }
178     Approval(msg.sender, _spender, allowed[msg.sender][_spender]);
179     return true;
180   }
181 
182 }
183 
184 	/**
185 	* @title Ownable
186 	* @dev The Ownable contract has an owner address, and provides basic authorization control
187 	* functions, this simplifies the implementation of "user permissions".
188 	*/
189 contract Ownable {
190   address public owner;
191 
192 
193   event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
194 
195 	/**
196 	* @dev The Ownable constructor sets the original `owner` of the contract to the sender
197 	* account.
198 	*/
199   function Ownable() public {
200     owner = msg.sender;
201   }
202 
203 	/**
204 	* @dev Throws if called by any account other than the owner.
205 	*/
206   modifier onlyOwner() {
207     require(msg.sender == owner);
208     _;
209   }
210 
211 	/**
212 	* @dev Allows the current owner to transfer control of the contract to a newOwner.
213 	* @param newOwner The address to transfer ownership to.
214 	*/
215   function transferOwnership(address newOwner) public onlyOwner {
216     require(newOwner != address(0));
217     OwnershipTransferred(owner, newOwner);
218     owner = newOwner;
219   }
220 
221 }
222 
223 	/**
224 	* @dev VCA_Token is StandardToken, Ownable
225 	*/
226 contract VCA_Token is StandardToken, Ownable {
227   string public constant name = "Virtual Cash";
228   string public constant symbol = "VCA";
229   uint256 public constant decimals = 8;
230 
231   uint256 public constant UNIT = 10 ** decimals;
232 
233   address public companyWallet;
234   address public admin;
235 
236   uint256 public tokenPrice = 0.00025 ether;
237   uint256 public maxSupply = 20000000 * UNIT;
238   uint256 public totalSupply = 0;
239   uint256 public totalWeiReceived = 0;
240 
241   uint256 startDate  = 1517443260; //	12:01 GMT February 1 2018
242   uint256 endDate    = 1522537260; //	12:00 GMT March 15 2018
243 
244   uint256 bonus35end = 1517702460; //	12:01 GMT February 4 2018
245   uint256 bonus32end = 1517961660; //	12:01 GMT February 7 2018
246   uint256 bonus29end = 1518220860; //	12:01 GMT February 10 2018
247   uint256 bonus26end = 1518480060; //	12:01 GMT February 13 2018
248   uint256 bonus23end = 1518825660; //	12:01 GMT February 17 2018
249   uint256 bonus20end = 1519084860; //	12:01 GMT February 20 2018
250   uint256 bonus17end = 1519344060; //	12:01 GMT February 23 2018
251   uint256 bonus14end = 1519603260; //	12:01 GMT February 26 2018
252   uint256 bonus11end = 1519862460; //	12:01 GMT March 1 2018
253   uint256 bonus09end = 1520121660; //	12:01 GMT March 4 2018
254   uint256 bonus06end = 1520380860; //	12:01 GMT March 7 2018
255   uint256 bonus03end = 1520640060; //	12:01 GMT March 10 2018
256 
257 	/**
258 	* event for token purchase logging
259 	* @param purchaser - who paid for the tokens
260 	* @param beneficiary - who got the tokens
261 	* @param value - weis paid for purchase
262 	* @param amount - amount of tokens purchased
263 	*/
264   event TokenPurchase(address indexed purchaser, address indexed beneficiary, uint256 value, uint256 amount);
265 
266   event NewSale();
267 
268   modifier onlyAdmin() {
269     require(msg.sender == admin);
270     _;
271   }
272 
273   function VCA_Token(address _companyWallet, address _admin) public {
274     companyWallet = _companyWallet;
275     admin = _admin;
276     balances[companyWallet] = 5000000 * UNIT;
277     totalSupply = totalSupply.add(5000000 * UNIT);
278     Transfer(address(0x0), _companyWallet, 5000000 * UNIT);
279   }
280 
281   function setAdmin(address _admin) public onlyOwner {
282     admin = _admin;
283   }
284 
285   function calcBonus(uint256 _amount) internal view returns (uint256) {
286 	              uint256 bonusPercentage = 35;
287     if (now > bonus35end) bonusPercentage = 32;
288     if (now > bonus32end) bonusPercentage = 29;
289     if (now > bonus29end) bonusPercentage = 26;
290     if (now > bonus26end) bonusPercentage = 23;
291     if (now > bonus23end) bonusPercentage = 20;
292     if (now > bonus20end) bonusPercentage = 17;
293     if (now > bonus17end) bonusPercentage = 14;
294     if (now > bonus14end) bonusPercentage = 11;
295     if (now > bonus11end) bonusPercentage = 9;
296     if (now > bonus09end) bonusPercentage = 6;
297     if (now > bonus06end) bonusPercentage = 3;
298     if (now > bonus03end) bonusPercentage = 0;
299     return _amount * bonusPercentage / 100;
300   }
301 
302   function buyTokens() public payable {
303     require(now < endDate);
304     require(now >= startDate);
305     require(msg.value > 0);
306 
307     uint256 amount = msg.value * UNIT / tokenPrice;
308     uint256 bonus = calcBonus(msg.value) * UNIT / tokenPrice;
309     
310     totalSupply = totalSupply.add(amount);
311     
312     require(totalSupply <= maxSupply);
313 
314     totalWeiReceived = totalWeiReceived.add(msg.value);
315 
316     balances[msg.sender] = balances[msg.sender].add(amount);
317     
318     TokenPurchase(msg.sender, msg.sender, msg.value, amount);
319     
320     Transfer(address(0x0), msg.sender, amount);
321 
322     if (bonus > 0) {
323       Transfer(companyWallet, msg.sender, bonus);
324       balances[companyWallet] -= bonus;
325       balances[msg.sender] = balances[msg.sender].add(bonus);
326     }
327 
328     companyWallet.transfer(msg.value);
329   }
330 
331   function() public payable {
332     buyTokens();
333   }
334 
335 	/***
336 	* This function is used to transfer tokens that have been bought through other means (credit card, bitcoin, etc), and to burn tokens after the sale.
337 	*/
338   function sendTokens(address receiver, uint256 tokens) public onlyAdmin {
339     require(now < endDate);
340     require(now >= startDate);
341     require(totalSupply + tokens * UNIT <= maxSupply);
342 
343     uint256 amount = tokens * UNIT;
344     balances[receiver] += amount;
345     totalSupply += amount;
346     Transfer(address(0x0), receiver, amount);
347   }
348 
349 }