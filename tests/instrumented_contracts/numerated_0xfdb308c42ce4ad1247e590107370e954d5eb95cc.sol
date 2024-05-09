1 pragma solidity ^0.4.18;
2 
3 /**
4  * @title SafeMath
5  * @dev Math operations with safety checks that throw on error
6  */
7 library SafeMath {
8     function add(uint256 x, uint256 y) pure internal returns (uint256) {
9         uint256 z = x + y;
10         assert((z >= x) && (z >= y));
11         return z;
12     }
13 
14     function sub(uint256 x, uint256 y) pure internal returns (uint256) {
15         assert(x >= y);
16         uint256 z = x - y;
17         return z;
18     }
19 
20     function mul(uint256 x, uint256 y) pure internal returns (uint256) {
21         uint256 z = x * y;
22         assert((x == 0) || (z / x == y));
23         return z;
24     }
25 }
26 
27 
28 /**
29  * @title Ownable
30  * @dev The Ownable contract has an owner address, and provides basic authorization control
31  * functions, this simplifies the implementation of "user permissions".
32  */
33 contract Ownable {
34   address public owner;
35 
36 
37   /**
38    * @dev The Ownable constructor sets the original `owner` of the contract to the sender
39    * account.
40    */
41   function Ownable() public {
42     owner = msg.sender;
43   }
44 
45 
46   /**
47    * @dev Throws if called by any account other than the owner.
48    */
49   modifier onlyOwner() {
50     require(msg.sender == owner);
51     _;
52   }
53 }
54 /*
55  * Haltable
56  *
57  * Abstract contract that allows children to implement an
58  * emergency stop mechanism. Differs from Pausable by causing a throw when in halt mode.
59  *
60  *
61  * Originally envisioned in FirstBlood ICO contract.
62  */
63 contract Haltable is Ownable {
64   bool public halted;
65 
66   modifier stopInEmergency {
67     require (!halted);
68     _;
69   }
70 
71   modifier onlyInEmergency {
72     require (halted);
73     _;
74   }
75 
76   // called by the owner on emergency, triggers stopped state
77   function halt() external onlyOwner {
78     halted = true;
79   }
80 
81   // called by the owner on end of emergency, returns to normal state
82   function unhalt() external onlyOwner onlyInEmergency {
83     halted = false;
84   }
85 
86 }
87 
88 /**
89  * @title ERC20Basic
90  * @dev Simpler version of ERC20 interface
91  * @dev see https://github.com/ethereum/EIPs/issues/179
92  */
93 contract ERC20Basic {
94   uint256 public totalSupply;
95   function balanceOf(address who) public constant returns (uint256);
96   function transfer(address to, uint256 value) public returns (bool);
97   event Transfer(address indexed from, address indexed to, uint256 value);
98 }
99 
100 
101 /**
102  * @title ERC20 interface
103  * @dev see https://github.com/ethereum/EIPs/issues/20
104  */
105 contract ERC20 is ERC20Basic {
106   function allowance(address owner, address spender) public constant returns (uint256);
107   function transferFrom(address from, address to, uint256 value) public returns (bool);
108   function approve(address spender, uint256 value) public returns (bool);
109   event Approval(address indexed owner, address indexed spender, uint256 value);
110 }
111 
112 
113 
114 /**
115  * @title Basic token
116  * @dev Basic version of StandardToken, with no allowances. 
117  */
118 contract BasicToken is ERC20Basic {
119   using SafeMath for uint256;
120 
121   mapping(address => uint256) balances;
122 
123   /**
124   * @dev transfer token for a specified address
125   * @param _to The address to transfer to.
126   * @param _value The amount to be transferred.
127   */
128   function transfer(address _to, uint256 _value) public returns (bool) {
129     balances[msg.sender] = balances[msg.sender].sub(_value);
130     balances[_to] = balances[_to].add(_value);
131     Transfer(msg.sender, _to, _value);
132     return true;
133   }
134 
135   /**
136   * @dev Gets the balance of the specified address.
137   * @param _owner The address to query the the balance of. 
138   * @return An uint256 representing the amount owned by the passed address.
139   */
140   function balanceOf(address _owner) public constant returns (uint256 balance) {
141     return balances[_owner];
142   }
143 
144 }
145 
146 /**
147  * @title Standard ERC20 token
148  *
149  * @dev Implementation of the basic standard token.
150  * @dev https://github.com/ethereum/EIPs/issues/20
151  * @dev Based on code by FirstBlood: https://github.com/Firstbloodio/token/blob/master/smart_contract/FirstBloodToken.sol
152  */
153 contract StandardToken is ERC20, BasicToken {
154 
155   mapping (address => mapping (address => uint256)) allowed;
156 
157 
158   /**
159    * @dev Transfer tokens from one address to another
160    * @param _from address The address which you want to send tokens from
161    * @param _to address The address which you want to transfer to
162    * @param _value uint256 the amout of tokens to be transfered
163    */
164   function transferFrom(address _from, address _to, uint256 _value) public returns (bool) {
165     var _allowance = allowed[_from][msg.sender];
166 
167     // Check is not needed because sub(_allowance, _value) will already throw if this condition is not met
168     // require (_value <= _allowance);
169 
170     balances[_to] = balances[_to].add(_value);
171     balances[_from] = balances[_from].sub(_value);
172     allowed[_from][msg.sender] = _allowance.sub(_value);
173     Transfer(_from, _to, _value);
174     return true;
175   }
176 
177   /**
178    * @dev Aprove the passed address to spend the specified amount of tokens on behalf of msg.sender.
179    * @param _spender The address which will spend the funds.
180    * @param _value The amount of tokens to be spent.
181    */
182   function approve(address _spender, uint256 _value) public returns (bool) {
183 
184     // To change the approve amount you first have to reduce the addresses`
185     //  allowance to zero by calling `approve(_spender, 0)` if it is not
186     //  already 0 to mitigate the race condition described here:
187     //  https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
188     require((_value == 0) || (allowed[msg.sender][_spender] == 0));
189 
190     allowed[msg.sender][_spender] = _value;
191     Approval(msg.sender, _spender, _value);
192     return true;
193   }
194 
195   /**
196    * @dev Function to check the amount of tokens that an owner allowed to a spender.
197    * @param _owner address The address which owns the funds.
198    * @param _spender address The address which will spend the funds.
199    * @return A uint256 specifing the amount of tokens still available for the spender.
200    */
201   function allowance(address _owner, address _spender) public constant returns (uint256 remaining) {
202     return allowed[_owner][_spender];
203   }
204 
205 }
206 
207 contract WWWToken is StandardToken {
208     using SafeMath for uint256;
209 
210     /*/ Public variables of the token /*/
211     string public constant name = "Wowander WWW Token";
212     string public constant symbol = "WWW";
213     uint8 public decimals = 8;
214     uint256 public totalSupply = 100 * 0.1 finney;
215 
216     /*/ Initializes contract with initial supply tokens to the creator of the contract /*/
217     function WWWToken() public
218     {
219         balances[msg.sender] = totalSupply;              // Give the creator all initial tokens
220     }
221 }
222 
223 
224 contract WowanderICOPrivateCrowdSale is Haltable{
225     using SafeMath for uint;
226     string public name = "Wowander Private Sale ITO";
227 
228     address public beneficiary;
229     uint public startTime;
230     uint public duration;
231     uint public tokensContractBalance;
232     uint public price; 
233     uint public discountPrice; 
234     WWWToken public tokenReward;
235 
236     mapping(address => uint256) public balanceOf;
237     mapping(address => bool) public whiteList;
238 
239     event FundTransfer(address backer, uint amount, bool isContribution);
240     
241     bool public crowdsaleClosed = false;
242     uint public tokenOwnerNumber = 0;
243     //uint public constant tokenOwnerNumberMax = 120;
244     uint public constant tokenOwnerNumberMax = 3;  // TODO remove
245     uint public constant minPurchase = 0.01 * 1 ether;
246     uint public constant discountValue = 1.0 * 1 ether;
247 
248     /*  at initialization, setup the owner */
249     function WowanderICOPrivateCrowdSale(
250         address addressOfTokenUsedAsReward,
251 		address addressOfBeneficiary
252     ) public
253     {
254         beneficiary = addressOfBeneficiary;
255         //startTime = 1516021200;
256         startTime = 1516021200 - 3600 * 24; // TODO remove
257         duration = 744 hours;
258 		tokensContractBalance =  5 * 0.1 finney;
259         price = 0.000000000005 * 1 ether;
260         discountPrice = 0.000000000005 * 1 ether * 0.9;
261         tokenReward = WWWToken(addressOfTokenUsedAsReward);
262     }
263 
264     modifier onlyAfterStart() {
265         require (now >= startTime);
266         _;
267     }
268 
269     modifier onlyBeforeEnd() {
270         require (now <= startTime + duration);
271         _;
272     }
273 
274     /* The function without name is the default function that is called whenever anyone sends funds to a contract */
275     function () payable stopInEmergency onlyAfterStart onlyBeforeEnd public
276     {
277         require (msg.value >= minPurchase);
278         require (crowdsaleClosed == false);
279         require (tokensContractBalance > 0);
280         require (whiteList[msg.sender] == true);
281 		
282 		uint currentPrice = price;
283 		
284         if (balanceOf[msg.sender] == 0)
285         {
286             require (tokenOwnerNumber < tokenOwnerNumberMax);
287             tokenOwnerNumber++;
288         }
289 
290         if (msg.value >= discountValue)
291         {
292             currentPrice = discountPrice;
293         }		
294 		
295 		uint amountSendTokens = msg.value / currentPrice;
296 		
297 		if (amountSendTokens > tokensContractBalance)
298 		{
299 			uint refund = msg.value - (tokensContractBalance * currentPrice);
300 			amountSendTokens = tokensContractBalance;
301 			msg.sender.transfer(refund);
302 			FundTransfer(msg.sender, refund, true);
303 			balanceOf[msg.sender] += (msg.value - refund);
304 		}
305 		else 
306 		{
307 			balanceOf[msg.sender] += msg.value;
308 		}
309 		
310 		tokenReward.transfer(msg.sender, amountSendTokens);
311 		FundTransfer(msg.sender, amountSendTokens, true);
312 		
313 		tokensContractBalance -= amountSendTokens;
314 
315     }
316 
317     function joinWhiteList (address _address) public onlyOwner
318     {
319         if (_address != address(0)) 
320         {
321             whiteList[_address] = true;
322         }
323     }
324 	
325     function finalizeSale () public onlyOwner
326     {
327        require (crowdsaleClosed == false);
328        crowdsaleClosed = true;
329     }
330 
331     function reopenSale () public onlyOwner
332     {
333        crowdsaleClosed = false;
334     }
335 
336     function setPrice (uint _price) public onlyOwner
337     {
338         if (_price != 0)
339         {
340             price = _price;
341         }
342     }
343 
344     function setDiscount (uint _discountPrice) public onlyOwner
345     {
346         if (_discountPrice != 0)
347         {
348             discountPrice = _discountPrice;
349         }
350     }
351 	
352     function fundWithdrawal (uint _amount) public onlyOwner
353     {
354         beneficiary.transfer(_amount);
355     }
356    
357     function tokenWithdrawal (uint _amount) public onlyOwner
358     {
359         tokenReward.transfer(beneficiary, _amount);
360     }
361 	
362     function changeBeneficiary(address _newBeneficiary) public onlyOwner 
363 	{
364         if (_newBeneficiary != address(0)) {
365             beneficiary = _newBeneficiary;
366         }
367 	}	
368 }