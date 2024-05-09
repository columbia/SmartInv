1 pragma solidity ^0.4.24;
2 /**
3 * Audited by VZ Chains (vzchains.com)
4 * HashRushICO.sol creates the client's token for crowdsale and allows for subsequent token sales and minting of tokens
5 *   Crowdsale contracts edited from original contract code at https://www.ethereum.org/crowdsale#crowdfund-your-idea
6 *   Additional crowdsale contracts, functions, libraries from OpenZeppelin
7 *       at https://github.com/OpenZeppelin/zeppelin-solidity/tree/master/contracts/token
8 *   Token contract edited from original contract code at https://www.ethereum.org/token
9 *   ERC20 interface and certain token functions adapted from https://github.com/ConsenSys/Tokens
10 **/
11 /**
12  * @title ERC20 interface
13  * @dev see https://github.com/ethereum/EIPs/issues/20
14  */
15 contract ERC20 {
16     //Sets events and functions for ERC20 token
17     event Approval(address indexed _owner, address indexed _spender, uint256 _value);
18     event Transfer(address indexed _from, address indexed _to, uint256 _value);
19     function totalSupply() public view returns (uint256);
20     function balanceOf(address _owner) public view returns (uint256);
21     function transfer(address _to, uint256 _value) public returns (bool);
22     function allowance(address _owner, address _spender) public view returns (uint256);
23     function approve(address _spender, uint256 _value) public returns (bool);
24     function transferFrom(address _from, address _to, uint256 _value) public returns (bool);
25 }
26 /**
27  * @title Owned
28  * @dev The Owned contract has an owner address, and provides basic authorization control
29  * functions, this simplifies the implementation of "user permissions".
30  */
31 contract Owned {
32     address public owner;
33     /**
34      * @dev The Ownable constructor sets the original `owner` of the contract to the sender
35      * account.
36      */
37     constructor() public {
38         owner = msg.sender;
39     }
40     /**
41      * @dev Throws if called by any account other than the owner.
42      */
43     modifier onlyOwner {
44         require(msg.sender == owner);
45         _;
46     }
47     /**
48      * @dev Allows the current owner to transfer control of the contract to a newOwner.
49      * @param newOwner The address to transfer ownership to.
50      */
51     function transferOwnership(address newOwner) onlyOwner public {
52         owner = newOwner;
53     }
54 }
55 library SafeMath {
56     function add(uint256 a, uint256 b) internal pure returns (uint256) {
57         uint256 c = a + b;
58         assert(c >= a);
59         return c;
60     }
61     function div(uint256 a, uint256 b) internal pure returns (uint256) {
62         require(b > 0); // Solidity only automatically asserts when dividing by 0
63         uint256 c = a / b;
64         // assert(a == b * c + a % b); // There is no case in which this doesn't hold
65         return c;
66     }
67     function max64(uint64 a, uint64 b) internal pure returns (uint64) {
68         return a >= b ? a : b;
69     }
70     function max256(uint256 a, uint256 b) internal pure returns (uint256) {
71         return a >= b ? a : b;
72     }
73     function min64(uint64 a, uint64 b) internal pure returns (uint64) {
74         return a < b ? a : b;
75     }
76     function min256(uint256 a, uint256 b) internal pure returns (uint256) {
77         return a < b ? a : b;
78     }
79     function mul(uint256 a, uint256 b) internal pure returns (uint256) {
80         if (a == 0) {
81             return 0;
82         }
83         uint256 c = a * b;
84         assert(c / a == b);
85         return c;
86     }
87     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
88         assert(b <= a);
89         uint256 c = a - b;
90         return c;
91     }
92 }
93 contract HashRush is ERC20, Owned {
94     // Applies SafeMath library to uint256 operations
95     using SafeMath for uint256;
96     // Public variables
97     string public name;
98     string public symbol;
99     uint256 public decimals;
100     // Variables
101     uint256 totalSupply_;
102     uint256 multiplier;
103     // Arrays for balances & allowance
104     mapping (address => uint256) balance;
105     mapping (address => mapping (address => uint256)) allowed;
106     // Modifier to prevent short address attack
107     modifier onlyPayloadSize(uint size) {
108         if(msg.data.length < size.add(4)) revert();
109         _;
110     }
111     constructor(string tokenName, string tokenSymbol, uint8 decimalUnits, uint256 decimalMultiplier) public {
112         name = tokenName;
113         symbol = tokenSymbol;
114         decimals = decimalUnits;
115         multiplier = decimalMultiplier;
116     }
117     /**
118     * @dev Total number of tokens in existence
119     */
120     function totalSupply() public view returns (uint256) {
121         return totalSupply_;
122     }
123     /**
124      * @dev Function to check the amount of tokens that an owner allowed to a spender.
125      * @param _owner address The address which owns the funds.
126      * @param _spender address The address which will spend the funds.
127      * @return A uint256 specifying the amount of tokens still available for the spender.
128      */
129     function allowance(address _owner, address _spender) public view returns (uint256) {
130         return allowed[_owner][_spender];
131     }
132     /**
133      * @dev Approve the passed address to spend the specified amount of tokens on behalf of msg.sender.
134      * @param _spender The address which will spend the funds.
135      * @param _value The amount of tokens to be spent.
136      */
137     function approve(address _spender, uint256 _value) public returns (bool) {
138         allowed[msg.sender][_spender] = _value;
139         emit Approval(msg.sender, _spender, _value);
140         return true;
141     }
142     /**
143      * @dev Gets the balance of the specified address.
144      * @param _owner The address to query the the balance of.
145      * @return An uint256 representing the amount owned by the passed address.
146      */
147     function balanceOf(address _owner) public view returns (uint256) {
148         return balance[_owner];
149     }
150     /**
151      * @dev Transfer token to a specified address
152      * @param _to The address to transfer to.
153      * @param _value The amount to be transferred.
154      */
155     function transfer(address _to, uint256 _value) onlyPayloadSize(2 * 32) public returns (bool) {
156         require(_to != address(0));
157         require(_value <= balance[msg.sender]);
158         if ((balance[msg.sender] >= _value)
159             && (balance[_to].add(_value) > balance[_to])
160         ) {
161             balance[msg.sender] = balance[msg.sender].sub(_value);
162             balance[_to] = balance[_to].add(_value);
163             emit Transfer(msg.sender, _to, _value);
164             return true;
165         } else {
166             return false;
167         }
168     }
169     /**
170      * @dev Transfer tokens from one address to another
171      * @param _from address The address which you want to send tokens from
172      * @param _to address The address which you want to transfer to
173      * @param _value uint256 the amount of tokens to be transferred
174      */
175     function transferFrom(address _from, address _to, uint256 _value) onlyPayloadSize(3 * 32) public returns (bool) {
176         require(_to != address(0));
177         require(_value <= balance[_from]);
178         require(_value <= allowed[_from][msg.sender]);
179         if ((balance[_from] >= _value) && (allowed[_from][msg.sender] >= _value) && (balance[_to].add(_value) > balance[_to])) {
180             balance[_to] = balance[_to].add(_value);
181             balance[_from] = balance[_from].sub(_value);
182             allowed[_from][msg.sender] = allowed[_from][msg.sender].sub(_value);
183             emit Transfer(_from, _to, _value);
184             return true;
185         } else {
186             return false;
187         }
188     }
189 }
190 contract HashRushICO is Owned, HashRush {
191     // Applies SafeMath library to uint256 operations
192     using SafeMath for uint256;
193     // Public Variables
194     address public multiSigWallet;
195     uint256 public amountRaised;
196     uint256 public startTime;
197     uint256 public stopTime;
198     uint256 public fixedTotalSupply;
199     uint256 public price;
200     uint256 public minimumInvestment;
201     uint256 public crowdsaleTarget;
202     // Variables
203     bool crowdsaleClosed = true;
204     string tokenName = "HashRush";
205     string tokenSymbol = "RUSH";
206     uint256 multiplier = 100000000;
207     uint8 decimalUnits = 8;
208     // Initializes the token
209     constructor()
210         HashRush(tokenName, tokenSymbol, decimalUnits, multiplier) public {
211             multiSigWallet = msg.sender;
212             fixedTotalSupply = 70000000;
213             fixedTotalSupply = fixedTotalSupply.mul(multiplier);
214     }
215     /**
216      * @dev Fallback function creates tokens and sends to investor when crowdsale is open
217      */
218     function () public payable {
219         require(!crowdsaleClosed
220             && (now < stopTime)
221             && (msg.value >= minimumInvestment)
222             && (totalSupply_.add(msg.value.mul(price).mul(multiplier).div(1 ether)) <= fixedTotalSupply)
223             && (amountRaised.add(msg.value.div(1 ether)) <= crowdsaleTarget)
224         );
225         address recipient = msg.sender;
226         amountRaised = amountRaised.add(msg.value.div(1 ether));
227         uint256 tokens = msg.value.mul(price).mul(multiplier).div(1 ether);
228         totalSupply_ = totalSupply_.add(tokens);
229     }
230     /**
231      * @dev Function to mint tokens
232      * @param target The address that will receive the minted tokens.
233      * @param amount The amount of tokens to mint.
234      * @return A boolean that indicates if the operation was successful.
235      */
236     function mintToken(address target, uint256 amount) onlyOwner public returns (bool) {
237         require(amount > 0);
238         require(totalSupply_.add(amount) <= fixedTotalSupply);
239         uint256 addTokens = amount;
240         balance[target] = balance[target].add(addTokens);
241         totalSupply_ = totalSupply_.add(addTokens);
242         emit Transfer(0, target, addTokens);
243         return true;
244     }
245     /**
246      * @dev Function to set token price
247      * @param newPriceperEther New price.
248      * @return A boolean that indicates if the operation was successful.
249      */
250     function setPrice(uint256 newPriceperEther) onlyOwner public returns (uint256) {
251         require(newPriceperEther > 0);
252         price = newPriceperEther;
253         return price;
254     }
255     /**
256      * @dev Function to set the multisig wallet for a crowdsale
257      * @param wallet Wallet address.
258      * @return A boolean that indicates if the operation was successful.
259      */
260     function setMultiSigWallet(address wallet) onlyOwner public returns (bool) {
261         multiSigWallet = wallet;
262         return true;
263     }
264     /**
265      * @dev Function to set the minimum investment to participate in crowdsale
266      * @param minimum minimum amount in wei.
267      * @return A boolean that indicates if the operation was successful.
268      */
269     function setMinimumInvestment(uint256 minimum) onlyOwner public returns (bool) {
270         minimumInvestment = minimum;
271         return true;
272     }
273     /**
274      * @dev Function to set the crowdsale target
275      * @param target Target amount in ETH.
276      * @return A boolean that indicates if the operation was successful.
277      */
278     function setCrowdsaleTarget(uint256 target) onlyOwner public returns (bool) {
279         crowdsaleTarget = target;
280         return true;
281     }
282     /**
283      * @dev Function to start the crowdsale specifying startTime and stopTime
284      * @param saleStart Sale start timestamp.
285      * @param saleStop Sale stop timestamo.
286      * @param salePrice Token price per ether.
287      * @param setBeneficiary Beneficiary address.
288      * @param minInvestment Minimum investment to participate in crowdsale (wei).
289      * @param saleTarget Crowdsale target in ETH
290      * @return A boolean that indicates if the operation was successful.
291      */
292     function startSale(uint256 saleStart, uint256 saleStop, uint256 salePrice, address setBeneficiary, uint256 minInvestment, uint256 saleTarget) onlyOwner public returns (bool) {
293         require(saleStop > now);
294         startTime = saleStart;
295         stopTime = saleStop;
296         amountRaised = 0;
297         crowdsaleClosed = false;
298         setPrice(salePrice);
299         setMultiSigWallet(setBeneficiary);
300         setMinimumInvestment(minInvestment);
301         setCrowdsaleTarget(saleTarget);
302         return true;
303     }
304     /**
305      * @dev Function that allows owner to stop the crowdsale immediately
306      * @return A boolean that indicates if the operation was successful.
307      */
308     function stopSale() onlyOwner public returns (bool) {
309         stopTime = now;
310         crowdsaleClosed = true;
311         return true;
312     }
313 }