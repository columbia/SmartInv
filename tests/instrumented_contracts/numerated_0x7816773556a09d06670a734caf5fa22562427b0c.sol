1 pragma solidity ^0.4.11;
2 
3 
4 /**
5  * Math operations with safety checks
6  */
7 library SafeMath {
8   function mul(uint256 a, uint256 b) internal constant returns (uint256) {
9     uint256 c = a * b;
10     assert(a == 0 || c / a == b);
11     return c;
12   }
13 
14   function div(uint256 a, uint256 b) internal constant returns (uint256) {
15     // assert(b > 0); // Solidity automatically throws when dividing by 0
16     uint256 c = a / b;
17     // assert(a == b * c + a % b); // There is no case in which this doesn't hold
18     return c;
19   }
20 
21   function sub(uint256 a, uint256 b) internal constant returns (uint256) {
22     assert(b <= a);
23     return a - b;
24   }
25 
26   function add(uint256 a, uint256 b) internal constant returns (uint256) {
27     uint256 c = a + b;
28     assert(c >= a);
29     return c;
30   }
31 }
32 
33 
34 /**
35  * @title Ownable
36  * @dev The Ownable contract has an owner address, and provides basic authorization control
37  * functions, this simplifies the implementation of "user permissions".
38  */
39 contract Ownable {
40   address public owner;
41   event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
42 
43   function Ownable() {
44     owner = msg.sender;
45   }
46   modifier onlyOwner() {
47     require(msg.sender == owner);
48     _;
49   }
50   function transferOwnership(address newOwner) onlyOwner public {
51     require(newOwner != address(0));
52     OwnershipTransferred(owner, newOwner);
53     owner = newOwner;
54   }
55 }
56 
57 
58 contract ERC20Basic {
59   uint256 public totalSupply;
60   function balanceOf(address who) public constant returns (uint256);
61   function transfer(address to, uint256 value) public returns (bool);
62   event Transfer(address indexed from, address indexed to, uint256 value);
63 }
64 
65 contract ERC20 is ERC20Basic {
66   function allowance(address owner, address spender) public constant returns (uint256);
67   function transferFrom(address from, address to, uint256 value) public returns (bool);
68   function approve(address spender, uint256 value) public returns (bool);
69   event Approval(address indexed owner, address indexed spender, uint256 value);
70 }
71 
72 
73 /**
74  * @title Basic token
75  * @dev Basic version of StandardToken, with no allowances.
76  */
77 contract BasicToken is ERC20Basic {
78   using SafeMath for uint256;
79 
80   mapping(address => uint256) balances;
81 
82   /**
83   * @dev transfer token for a specified address
84   * @param _to The address to transfer to.
85   * @param _value The amount to be transferred.
86   */
87   function transfer(address _to, uint256 _value) public returns (bool) {
88     require(_to != address(0));
89 
90     // SafeMath.sub will throw if there is not enough balance.
91     balances[msg.sender] = balances[msg.sender].sub(_value);
92     balances[_to] = balances[_to].add(_value);
93     Transfer(msg.sender, _to, _value);
94     return true;
95   }
96 
97   /**
98   * @dev Gets the balance of the specified address.
99   * @param _owner The address to query the the balance of.
100   * @return An uint256 representing the amount owned by the passed address.
101   */
102   function balanceOf(address _owner) public constant returns (uint256 balance) {
103     return balances[_owner];
104   }
105 
106 }
107 
108 
109 /**
110  * @title Standard ERC20 token
111  *
112  * @dev Implementation of the basic standard token.
113  * @dev https://github.com/ethereum/EIPs/issues/20
114  */
115 contract StandardToken is ERC20, BasicToken {
116 
117   mapping (address => mapping (address => uint256)) internal allowed;
118 
119 
120   /**
121    * @dev Transfer tokens from one address to another
122    * @param _from address The address which you want to send tokens from
123    * @param _to address The address which you want to transfer to
124    * @param _value uint256 the amount of tokens to be transferred
125    */
126   function transferFrom(address _from, address _to, uint256 _value) public returns (bool) {
127     require(_to != address(0));
128 
129     uint256 _allowance = allowed[_from][msg.sender];
130 
131     // Check is not needed because sub(_allowance, _value) will already throw if this condition is not met
132     // require (_value <= _allowance);
133 
134     balances[_from] = balances[_from].sub(_value);
135     balances[_to] = balances[_to].add(_value);
136     allowed[_from][msg.sender] = _allowance.sub(_value);
137     Transfer(_from, _to, _value);
138     return true;
139   }
140 
141   /**
142    * @dev Approve the passed address to spend the specified amount of tokens on behalf of msg.sender.
143    *
144    * Beware that changing an allowance with this method brings the risk that someone may use both the old
145    * and the new allowance by unfortunate transaction ordering. One possible solution to mitigate this
146    * race condition is to first reduce the spender's allowance to 0 and set the desired value afterwards:
147    * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
148    * @param _spender The address which will spend the funds.
149    * @param _value The amount of tokens to be spent.
150    */
151   function approve(address _spender, uint256 _value) public returns (bool) {
152     allowed[msg.sender][_spender] = _value;
153     Approval(msg.sender, _spender, _value);
154     return true;
155   }
156 
157   /**
158    * @dev Function to check the amount of tokens that an owner allowed to a spender.
159    * @param _owner address The address which owns the funds.
160    * @param _spender address The address which will spend the funds.
161    * @return A uint256 specifying the amount of tokens still available for the spender.
162    */
163   function allowance(address _owner, address _spender) public constant returns (uint256 remaining) {
164     return allowed[_owner][_spender];
165   }
166 
167   /**
168    * approve should be called when allowed[_spender] == 0. To increment
169    * allowed value is better to use this function to avoid 2 calls (and wait until
170    * the first transaction is mined)
171    */
172   function increaseApproval (address _spender, uint _addedValue) public returns (bool success) {
173     allowed[msg.sender][_spender] = allowed[msg.sender][_spender].add(_addedValue);
174     Approval(msg.sender, _spender, allowed[msg.sender][_spender]);
175     return true;
176   }
177 
178   function decreaseApproval (address _spender, uint _subtractedValue) public returns (bool success) {
179     uint oldValue = allowed[msg.sender][_spender];
180     if (_subtractedValue > oldValue) {
181       allowed[msg.sender][_spender] = 0;
182     } else {
183       allowed[msg.sender][_spender] = oldValue.sub(_subtractedValue);
184     }
185     Approval(msg.sender, _spender, allowed[msg.sender][_spender]);
186     return true;
187   }
188 
189 }
190 
191 
192 /**
193  * @title Kitchan Network Token
194  * Implements ERC 20 Token standard: https://github.com/ethereum/EIPs/issues/20 with the addition 
195  * of ownership, a lock and issuing.
196  */
197 contract KitchanNetworkToken is Ownable, StandardToken {
198 
199     using SafeMath for uint256;
200     
201 	// metadata
202     string public constant name = "Kitchan Network";
203     string public constant symbol = "KCN";
204     uint256 public constant decimals = 18;
205     uint256 public constant INITIAL_SUPPLY = 600 * (10**6) * 10**decimals; // Total 600m KCN
206 	uint256 public totalSale;
207 
208     // crowdsale parameters
209     bool public isFinalized;              // switched to true in operational state
210 
211     // Sale period.
212     uint256 public startDate;
213     
214     // 2017.10.10 02:00 UTC 
215     uint256 public constant startIco = 1507600800;
216     
217     uint256 public constant tokenRatePre = 15000; // 15000 KCN tokens per 1 ETH when Pre-ICO
218     uint256 public constant tokenRate1 = 13000; // 13000 KCN tokens per 1 ETH when week 1
219     uint256 public constant tokenRate2 = 12000; // 12000 KCN tokens per 1 ETH when week 2
220     uint256 public constant tokenRate3 = 11000; // 11000 KCN tokens per 1 ETH when week 3
221     uint256 public constant tokenRate4 = 10000; // 10000 KCN tokens per 1 ETH when week 4
222 
223     uint256 public constant tokenForTeam    = 100 * (10**6) * 10**decimals;
224     uint256 public constant tokenForAdvisor = 60 * (10**6) * 10**decimals;
225     uint256 public constant tokenForBounty  = 20 * (10**6) * 10**decimals;
226     uint256 public constant tokenForSale    = 420 * (10**6) * 10**decimals;
227 
228 	// Address received Token
229     address public constant ethFundAddress = 0xc73a39834a14D91eCB701aEf41F5C71A0E95fB10;      // deposit address for ETH 
230 	address public constant teamAddress = 0x689ab85eBFF451f661665114Abb6EF7109175F9D;
231 	address public constant advisorAddress = 0xe7F74ee4e03C14144936BF738c12865C489aF8A7;
232 	address public constant bountyAddress = 0x65E5F11D845ecb2b7104Ad163B0B957Ed14D6EEF;
233   
234 
235     // constructor
236     function KitchanNetworkToken() {
237       	isFinalized = false;                   //controls pre through crowdsale state      	
238       	totalSale = 0;
239       	startDate = getCurrent();
240       	balances[teamAddress] = tokenForTeam;   
241       	balances[advisorAddress] = tokenForAdvisor;
242       	balances[bountyAddress] = tokenForBounty;
243     }
244 
245     function getCurrent() internal returns (uint256) {
246         return now;
247     }
248     
249 
250     function getRateTime(uint256 at) internal returns (uint256) {
251         if (at < (startIco)) {
252             return tokenRatePre;
253         } else if (at < (startIco + 7 days)) {
254             return tokenRate1;
255         } else if (at < (startIco + 14 days)) {
256             return tokenRate2;
257         } else if (at < (startIco + 21 days)) {
258             return tokenRate3;
259         }
260         return tokenRate4;
261     }
262     
263     // Fallback function can be used to buy tokens
264     function () payable {
265         buyTokens(msg.sender, msg.value);
266     }
267     	
268     // @dev Accepts ether and creates new KCN tokens.
269     function buyTokens(address sender, uint256 value) internal {
270         require(!isFinalized);
271         require(value > 0 ether);
272 
273         // Calculate token  to be purchased
274         uint256 tokenRateNow = getRateTime(getCurrent());
275       	uint256 tokens = value * tokenRateNow; // check that we're not over totals
276       	uint256 checkedSupply = totalSale + tokens;
277       	
278        	// return money if something goes wrong
279       	require(tokenForSale >= checkedSupply);  // odd fractions won't be found     	
280 
281         // Transfer
282         balances[sender] += tokens;
283 
284         // Update total sale.
285         totalSale = checkedSupply;
286 
287         // Forward the fund to fund collection wallet.
288         ethFundAddress.transfer(value);
289     }
290 
291     /// @dev Ends the funding period
292     function finalize() onlyOwner {
293         require(!isFinalized);
294     	require(msg.sender == ethFundAddress);
295     	require(tokenForSale > totalSale);
296     	
297         balances[ethFundAddress] += (tokenForSale - totalSale);
298            	      	
299       	// move to operational
300       	isFinalized = true;
301 
302     }
303     
304 }