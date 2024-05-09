1 pragma solidity ^0.4.24;
2 
3 /**
4 
5 * Audited by VZ Chains (vzchains.com)
6 
7 * HashRushICO.sol creates the client's token for crowdsale and allows for subsequent token sales and minting of tokens
8 
9 *   Crowdsale contracts edited from original contract code at https://www.ethereum.org/crowdsale#crowdfund-your-idea
10 
11 *   Additional crowdsale contracts, functions, libraries from OpenZeppelin
12 
13 *       at https://github.com/OpenZeppelin/zeppelin-solidity/tree/master/contracts/token
14 
15 *   Token contract edited from original contract code at https://www.ethereum.org/token
16 
17 *   ERC20 interface and certain token functions adapted from https://github.com/ConsenSys/Tokens
18 
19 **/
20 
21 /**
22  * @title ERC20 interface
23  * @dev see https://github.com/ethereum/EIPs/issues/20
24  */
25 contract ERC20 {
26     //Sets events and functions for ERC20 token
27     event Approval(address indexed _owner, address indexed _spender, uint256 _value);
28     event Transfer(address indexed _from, address indexed _to, uint256 _value);
29 
30     function totalSupply() public view returns (uint256);
31     function balanceOf(address _owner) public view returns (uint256);
32     function transfer(address _to, uint256 _value) public returns (bool);
33 
34     function allowance(address _owner, address _spender) public view returns (uint256);
35     function approve(address _spender, uint256 _value) public returns (bool);
36     function transferFrom(address _from, address _to, uint256 _value) public returns (bool);
37 }
38 
39 /**
40  * @title Owned
41  * @dev The Owned contract has an owner address, and provides basic authorization control
42  * functions, this simplifies the implementation of "user permissions".
43  */
44 contract Owned {
45     address public owner;
46 
47     /**
48      * @dev The Ownable constructor sets the original `owner` of the contract to the sender
49      * account.
50      */
51     constructor() public {
52         owner = msg.sender;
53     }
54 
55     /**
56      * @dev Throws if called by any account other than the owner.
57      */
58     modifier onlyOwner {
59         require(msg.sender == owner);
60         _;
61     }
62 
63     /**
64      * @dev Allows the current owner to transfer control of the contract to a newOwner.
65      * @param newOwner The address to transfer ownership to.
66      */
67     function transferOwnership(address newOwner) onlyOwner public {
68         owner = newOwner;
69     }
70 }
71 
72 
73 library SafeMath {
74     function add(uint256 a, uint256 b) internal pure returns (uint256) {
75         uint256 c = a + b;
76         assert(c >= a);
77         return c;
78     }
79 
80     function div(uint256 a, uint256 b) internal pure returns (uint256) {
81         require(b > 0); // Solidity only automatically asserts when dividing by 0
82         uint256 c = a / b;
83         // assert(a == b * c + a % b); // There is no case in which this doesn't hold
84         return c;
85     }
86 
87     function max64(uint64 a, uint64 b) internal pure returns (uint64) {
88         return a >= b ? a : b;
89     }
90 
91     function max256(uint256 a, uint256 b) internal pure returns (uint256) {
92         return a >= b ? a : b;
93     }
94 
95     function min64(uint64 a, uint64 b) internal pure returns (uint64) {
96         return a < b ? a : b;
97     }
98 
99     function min256(uint256 a, uint256 b) internal pure returns (uint256) {
100         return a < b ? a : b;
101     }
102 
103     function mul(uint256 a, uint256 b) internal pure returns (uint256) {
104         if (a == 0) {
105             return 0;
106         }
107 
108         uint256 c = a * b;
109         assert(c / a == b);
110         return c;
111     }
112 
113     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
114         assert(b <= a);
115         uint256 c = a - b;
116 
117         return c;
118     }
119 }
120 
121 
122 contract HashRush is ERC20, Owned {
123     // Applies SafeMath library to uint256 operations
124     using SafeMath for uint256;
125 
126     // Public variables
127     string public name;
128     string public symbol;
129     uint256 public decimals;
130 
131     // Variables
132     uint256 totalSupply_;
133     uint256 multiplier;
134 
135     // Arrays for balances & allowance
136     mapping (address => uint256) balance;
137     mapping (address => mapping (address => uint256)) allowed;
138 
139     // Modifier to prevent short address attack
140     modifier onlyPayloadSize(uint size) {
141         if(msg.data.length < size.add(4)) revert();
142         _;
143     }
144 
145     constructor(string tokenName, string tokenSymbol, uint8 decimalUnits, uint256 decimalMultiplier) public {
146         name = tokenName;
147         symbol = tokenSymbol;
148         decimals = decimalUnits;
149         multiplier = decimalMultiplier;
150     }
151 
152     /**
153     * @dev Total number of tokens in existence
154     */
155     function totalSupply() public view returns (uint256) {
156         return totalSupply_;
157     }
158 
159     /**
160      * @dev Function to check the amount of tokens that an owner allowed to a spender.
161      * @param _owner address The address which owns the funds.
162      * @param _spender address The address which will spend the funds.
163      * @return A uint256 specifying the amount of tokens still available for the spender.
164      */
165     function allowance(address _owner, address _spender) public view returns (uint256) {
166         return allowed[_owner][_spender];
167     }
168 
169     /**
170      * @dev Approve the passed address to spend the specified amount of tokens on behalf of msg.sender.
171      * @param _spender The address which will spend the funds.
172      * @param _value The amount of tokens to be spent.
173      */
174     function approve(address _spender, uint256 _value) public returns (bool) {
175         allowed[msg.sender][_spender] = _value;
176         emit Approval(msg.sender, _spender, _value);
177         return true;
178     }
179 
180     /**
181      * @dev Gets the balance of the specified address.
182      * @param _owner The address to query the the balance of.
183      * @return An uint256 representing the amount owned by the passed address.
184      */
185     function balanceOf(address _owner) public view returns (uint256) {
186         return balance[_owner];
187     }
188 
189     /**
190      * @dev Transfer token to a specified address
191      * @param _to The address to transfer to.
192      * @param _value The amount to be transferred.
193      */
194     function transfer(address _to, uint256 _value) onlyPayloadSize(2 * 32) public returns (bool) {
195         require(_to != address(0));
196         require(_value <= balance[msg.sender]);
197 
198         if ((balance[msg.sender] >= _value)
199             && (balance[_to].add(_value) > balance[_to])
200         ) {
201             balance[msg.sender] = balance[msg.sender].sub(_value);
202             balance[_to] = balance[_to].add(_value);
203             emit Transfer(msg.sender, _to, _value);
204             return true;
205         } else {
206             return false;
207         }
208     }
209 
210     /**
211      * @dev Transfer tokens from one address to another
212      * @param _from address The address which you want to send tokens from
213      * @param _to address The address which you want to transfer to
214      * @param _value uint256 the amount of tokens to be transferred
215      */
216     function transferFrom(address _from, address _to, uint256 _value) onlyPayloadSize(3 * 32) public returns (bool) {
217         require(_to != address(0));
218         require(_value <= balance[_from]);
219         require(_value <= allowed[_from][msg.sender]);
220 
221         if ((balance[_from] >= _value) && (allowed[_from][msg.sender] >= _value) && (balance[_to].add(_value) > balance[_to])) {
222             balance[_to] = balance[_to].add(_value);
223             balance[_from] = balance[_from].sub(_value);
224             allowed[_from][msg.sender] = allowed[_from][msg.sender].sub(_value);
225             emit Transfer(_from, _to, _value);
226             return true;
227         } else {
228             return false;
229         }
230     }
231 }
232 
233 
234 contract HashRushICO is Owned, HashRush {
235     // Applies SafeMath library to uint256 operations
236     using SafeMath for uint256;
237 
238     // Public Variables
239     address public multiSigWallet;
240     uint256 public amountRaised;
241     uint256 public startTime;
242     uint256 public stopTime;
243     uint256 public fixedTotalSupply;
244     uint256 public price;
245     uint256 public minimumInvestment;
246     uint256 public crowdsaleTarget;
247 
248     // Variables
249     bool crowdsaleClosed = true;
250     string tokenName = "HashRush";
251     string tokenSymbol = "RUSH";
252     uint256 multiplier = 100000000;
253     uint8 decimalUnits = 8;
254 
255     // Initializes the token
256     constructor()
257         HashRush(tokenName, tokenSymbol, decimalUnits, multiplier) public {
258             multiSigWallet = msg.sender;
259             fixedTotalSupply = 70000000;
260             fixedTotalSupply = fixedTotalSupply.mul(multiplier);
261     }
262 
263     /**
264      * @dev Fallback function creates tokens and sends to investor when crowdsale is open
265      */
266     function () public payable {
267         require(!crowdsaleClosed
268             && (now < stopTime)
269             && (msg.value >= minimumInvestment)
270             && (amountRaised.add(msg.value.div(1 ether)) <= crowdsaleTarget)
271         );
272 
273         amountRaised = amountRaised.add(msg.value.div(1 ether));
274 
275         multiSigWallet.transfer(msg.value);
276     }
277 
278     /**
279      * @dev Function to mint tokens
280      * @param target The address that will receive the minted tokens.
281      * @param amount The amount of tokens to mint.
282      * @return A boolean that indicates if the operation was successful.
283      */
284     function mintToken(address target, uint256 amount) onlyOwner public returns (bool) {
285         require(amount > 0);
286         require(totalSupply_.add(amount) <= fixedTotalSupply);
287         uint256 addTokens = amount;
288         balance[target] = balance[target].add(addTokens);
289         totalSupply_ = totalSupply_.add(addTokens);
290         emit Transfer(0, target, addTokens);
291         return true;
292     }
293 
294     /**
295      * @dev Function to set token price
296      * @param newPriceperEther New price.
297      * @return A boolean that indicates if the operation was successful.
298      */
299     function setPrice(uint256 newPriceperEther) onlyOwner public returns (uint256) {
300         require(newPriceperEther > 0);
301         price = newPriceperEther;
302         return price;
303     }
304 
305     /**
306      * @dev Function to set the multisig wallet for a crowdsale
307      * @param wallet Wallet address.
308      * @return A boolean that indicates if the operation was successful.
309      */
310     function setMultiSigWallet(address wallet) onlyOwner public returns (bool) {
311         multiSigWallet = wallet;
312         return true;
313     }
314 
315     /**
316      * @dev Function to set the minimum investment to participate in crowdsale
317      * @param minimum minimum amount in wei.
318      * @return A boolean that indicates if the operation was successful.
319      */
320     function setMinimumInvestment(uint256 minimum) onlyOwner public returns (bool) {
321         minimumInvestment = minimum;
322         return true;
323     }
324 
325     /**
326      * @dev Function to set the crowdsale target
327      * @param target Target amount in ETH.
328      * @return A boolean that indicates if the operation was successful.
329      */
330     function setCrowdsaleTarget(uint256 target) onlyOwner public returns (bool) {
331         crowdsaleTarget = target;
332         return true;
333     }
334 
335     /**
336      * @dev Function to start the crowdsale specifying startTime and stopTime
337      * @param saleStart Sale start timestamp.
338      * @param saleStop Sale stop timestamo.
339      * @param salePrice Token price per ether.
340      * @param setBeneficiary Beneficiary address.
341      * @param minInvestment Minimum investment to participate in crowdsale (wei).
342      * @param saleTarget Crowdsale target in ETH
343      * @return A boolean that indicates if the operation was successful.
344      */
345     function startSale(uint256 saleStart, uint256 saleStop, uint256 salePrice, address setBeneficiary, uint256 minInvestment, uint256 saleTarget) onlyOwner public returns (bool) {
346         require(saleStop > now);
347         startTime = saleStart;
348         stopTime = saleStop;
349         amountRaised = 0;
350         crowdsaleClosed = false;
351         setPrice(salePrice);
352         setMultiSigWallet(setBeneficiary);
353         setMinimumInvestment(minInvestment);
354         setCrowdsaleTarget(saleTarget);
355         return true;
356     }
357 
358     /**
359      * @dev Function that allows owner to stop the crowdsale immediately
360      * @return A boolean that indicates if the operation was successful.
361      */
362     function stopSale() onlyOwner public returns (bool) {
363         stopTime = now;
364         crowdsaleClosed = true;
365         return true;
366     }
367 }