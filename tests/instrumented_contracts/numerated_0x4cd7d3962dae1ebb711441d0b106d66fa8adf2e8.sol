1 pragma solidity 0.4.21;
2 contract Owned {
3     address public owner;
4 
5     function Owned() public {
6         owner = msg.sender;
7     }
8 
9     modifier onlyOwner {
10         require(msg.sender == owner);
11         _;
12     }
13 }
14 
15 library SafeMath {
16     function mul(uint256 a, uint256 b) internal pure returns (uint256) {
17         uint256 c = a * b;
18         require(a == 0 || c / a == b);
19         return c;
20     }
21 
22     function div(uint256 a, uint256 b) internal pure returns (uint256) {
23         // assert(b > 0); // Solidity automatically throws when dividing by 0
24         uint256 c = a / b;
25         // assert(a == b * c + a % b); // There is no case in which this doesn't hold
26         return c;
27     }
28 
29     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
30         require(b <= a);
31         return a - b;
32     }
33 
34     function add(uint256 a, uint256 b) internal pure returns (uint256) {
35         uint256 c = a + b;
36         require(c >= a);
37         return c;
38     }
39 }
40 
41 /**
42  * @title ERC20Basic
43  * @dev Simpler version of ERC20 interface
44  * @dev see https://github.com/ethereum/EIPs/issues/179
45  */
46 contract ERC20Basic {
47     function balanceOf(address who) public view returns (uint256);
48     function transfer(address to, uint256 value) public returns (bool);
49     event Transfer(address indexed from, address indexed to, uint256 value);
50 }
51 
52 /**
53  * @title ERC20 interface
54  * @dev see https://github.com/ethereum/EIPs/issues/20
55  */
56 contract ERC20 is ERC20Basic {
57     function allowance(address owner, address spender) public view returns (uint256);
58     function transferFrom(address from, address to, uint256 value) public returns (bool);
59     function approve(address spender, uint256 value) public returns (bool);
60     event Approval(address indexed owner, address indexed spender, uint256 value);
61 }
62 
63 /**
64  * @title Basic token
65  * @dev Basic version of StandardToken, with no allowances.
66  */
67 contract BasicToken is ERC20Basic {
68     using SafeMath for uint256;
69 
70     mapping(address => uint256) public balances;
71 
72     /**
73     * @dev transfer token for a specified address
74     * @param _to The address to transfer to.
75     * @param _value The amount to be transferred.
76     */
77     function transfer(address _to, uint256 _value) public returns (bool) {
78         require(_to != address(0));
79         require(_value <= balances[msg.sender]);
80 
81         // SafeMath.sub will throw if there is not enough balance.
82         balances[msg.sender] = balances[msg.sender].sub(_value);
83         balances[_to] = balances[_to].add(_value);
84         emit Transfer(msg.sender, _to, _value);
85         return true;
86     }
87 
88     /**
89     * @dev Gets the balance of the specified address.
90     * @param _owner The address to query the the balance of.
91     * @return An uint256 representing the amount owned by the passed address.
92     */
93     function balanceOf(address _owner) public view returns (uint256 balance) {
94         return balances[_owner];
95     }
96 
97 }
98 
99 /**
100  * @title Standard ERC20 token
101  *
102  * @dev Implementation of the basic standard token.
103  * @dev https://github.com/ethereum/EIPs/issues/20
104  * @dev Based on code by FirstBlood: https://github.com/Firstbloodio/token/blob/master/smart_contract/FirstBloodToken.sol
105  */
106 contract StandardToken is ERC20, BasicToken {
107 
108     mapping (address => mapping (address => uint256)) internal allowed;
109 
110     /**
111      * @dev Transfer tokens from one address to another
112      * @param _from address The address which you want to send tokens from
113      * @param _to address The address which you want to transfer to
114      * @param _value uint256 the amount of tokens to be transferred
115      */
116     function transferFrom(address _from, address _to, uint256 _value) public returns (bool) {
117         require(_to != address(0));
118         require(_value <= balances[_from]);
119         require(_value <= allowed[_from][msg.sender]);
120 
121         balances[_from] = balances[_from].sub(_value);
122         balances[_to] = balances[_to].add(_value);
123         allowed[_from][msg.sender] = allowed[_from][msg.sender].sub(_value);
124         emit Transfer(_from, _to, _value);
125         return true;
126     }
127 
128     /**
129      * @dev Approve the passed address to spend the specified amount of tokens on behalf of msg.sender.
130      *
131      * Beware that changing an allowance with this method brings the risk that someone may use both the old
132      * and the new allowance by unfortunate transaction ordering. One possible solution to mitigate this
133      * race condition is to first reduce the spender's allowance to 0 and set the desired value afterwards:
134      * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
135      * @param _spender The address which will spend the funds.
136      * @param _value The amount of tokens to be spent.
137      */
138     function approve(address _spender, uint256 _value) public returns (bool) {
139         allowed[msg.sender][_spender] = _value;
140         emit Approval(msg.sender, _spender, _value);
141         return true;
142     }
143 
144     /**
145      * @dev Function to check the amount of tokens that an owner allowed to a spender.
146      * @param _owner address The address which owns the funds.
147      * @param _spender address The address which will spend the funds.
148      * @return A uint256 specifying the amount of tokens still available for the spender.
149      */
150     function allowance(address _owner, address _spender) public view returns (uint256 remaining) {
151         return allowed[_owner][_spender];
152     }
153 
154     /**
155      * approve should be called when allowed[_spender] == 0. To increment
156      * allowed value is better to use this function to avoid 2 calls (and wait until
157      * the first transaction is mined)
158      * From MonolithDAO Token.sol
159      */
160     function increaseApproval (address _spender, uint _addedValue) public returns (bool success) {
161         allowed[msg.sender][_spender] = allowed[msg.sender][_spender].add(_addedValue);
162         emit Approval(msg.sender, _spender, allowed[msg.sender][_spender]);
163         return true;
164     }
165 
166     function decreaseApproval (address _spender, uint _subtractedValue) public returns (bool success) {
167         uint oldValue = allowed[msg.sender][_spender];
168         if (_subtractedValue > oldValue) {
169             allowed[msg.sender][_spender] = 0;
170         } else {
171             allowed[msg.sender][_spender] = oldValue.sub(_subtractedValue);
172         }
173         emit Approval(msg.sender, _spender, allowed[msg.sender][_spender]);
174         return true;
175     }
176 
177 }
178 
179 contract BBTCToken is StandardToken, Owned {
180 
181     /* Constants */
182 
183     // Token Name
184     string public constant name = "BloxOffice token";
185     // Ticker Symbol
186     string public constant symbol = "BBTC";
187     // Decimals
188     uint8 public constant decimals = 18;
189 
190     bool public tokenSaleClosed = false;
191 
192 
193 
194     /* Owners */
195 
196     // Ethereum fund owner wallet
197     address public _fundowner = 0x761cE04C269314fAfCC545301414BfDA21539A75;
198 
199     // Dev Team multisig wallet
200     address public _devteam = 0xb3871355181558059fB22ae7AfAd415499ae6f1E;
201 
202     // Advisors & Mentors multisig wallet
203     address public _mentors = 0x589789B67aE612f47503E80ED14A18593C1C79BE;
204 
205     //Bounty address
206     address public _bounty = 0x923A03dE5816CCB29684F6D420e774d721Ac6962;
207 
208     //private Sale; multisig wallet
209     address public _privateSale = 0x90aBD12D92c0E5f5BcD2195ee3C6C15026506B96;
210 
211     /* Token Distribution */
212 
213     // Total supply of Tokens 999 Million
214     uint256 public totalSupply = 999999999 * 10**uint256(decimals);
215 
216     // CrowdSale hard cap
217     uint256 public TOKENS_SALE_HARD_CAP = 669999999 * 10**uint256(decimals);
218 
219     //Dev Team
220     uint256 public DEV_TEAM = 160000000 * 10**uint256(decimals);
221 
222     //Mentors
223     uint256 public MENTORS = 80000000 * 10**uint256(decimals);
224 
225     //Bounty
226     uint256 public BOUNTY = 20000000 * 10**uint256(decimals);
227 
228     //Private Sale
229     uint256 public PRIVATE = 70000000 * 10**uint256(decimals);
230 
231     /* Current max supply */
232     uint256 public currentSupply;
233 
234 
235     //Dates
236     //Private Sale
237     uint64 private constant privateSaleDate = 1519756200;
238 
239     //Pre-sale Start Date 15 April
240     uint64 private constant presaleStartDate = 1523730600;
241     //Pre-sale End Date 15 May
242     uint64 private constant presaleEndDate = 1526408999;
243 
244 
245     //CrowdSale Start Date 22-May
246     uint64 private constant crowdSaleStart = 1526927400;
247     //CrowdSale End Date 6 July
248     uint64 private constant crowdSaleEnd = 1530901799;
249 
250 
251     /* Base exchange rate is set to 1 ETH = 2500 BBTC */
252     uint256 public constant BASE_RATE = 2500;
253 
254     /* Constructor */
255     function BBTCToken(){
256       //Assign the initial tokens
257       //For dev team
258       balances[_devteam] = DEV_TEAM;
259 
260       //For mentors
261       balances[_mentors] = MENTORS;
262 
263       //For bounty
264       balances[_bounty] = BOUNTY;
265 
266       //For private
267       balances[_privateSale] = PRIVATE;
268 
269     }
270 
271     /// start Token sale
272     function startSale () public onlyOwner{
273       tokenSaleClosed = false;
274     }
275 
276     //stop Token sale
277     function stopSale () public onlyOwner {
278       tokenSaleClosed = true;
279     }
280 
281     /// @return if the token sale is finished
282       function saleDue() public view returns (bool) {
283           return crowdSaleEnd < uint64(block.timestamp);
284       }
285 
286     modifier inProgress {
287         require(currentSupply < TOKENS_SALE_HARD_CAP
288                 && !tokenSaleClosed
289                 && !saleDue());
290         _;
291     }
292 
293     /// @dev This default function allows token to be purchased by directly
294     /// sending ether to this smart contract.
295     function () public payable {
296         purchaseTokens(msg.sender);
297     }
298 
299     /// @dev Issue token based on Ether received.
300     /// @param _beneficiary Address that newly issued token will be sent to.
301     function purchaseTokens(address _beneficiary) internal inProgress {
302 
303         uint256 tokens = computeTokenAmount(msg.value);
304 
305         balances[_beneficiary] = balances[_beneficiary].add(tokens);
306 
307         /// forward the raised funds to the fund address
308         _fundowner.transfer(msg.value);
309     }
310 
311 
312     /// @dev Compute the amount of ING token that can be purchased.
313     /// @param ethAmount Amount of Ether to purchase ING.
314     /// @return Amount of ING token to purchase
315     function computeTokenAmount(uint256 ethAmount) internal view returns (uint256 tokens) {
316         /// the percentage value (0-100) of the discount for each tier
317         uint64 discountPercentage = currentTierDiscountPercentage();
318 
319         uint256 tokenBase = ethAmount.mul(BASE_RATE);
320         uint256 tokenBonus = tokenBase.mul(discountPercentage).div(100);
321 
322         tokens = tokenBase.add(tokenBonus);
323     }
324 
325 
326     /// @dev Determine the current sale tier.
327       /// @return the index of the current sale tier.
328       function currentTierDiscountPercentage() internal view returns (uint64) {
329           uint64 _now = uint64(block.timestamp);
330 
331           if(_now > crowdSaleStart) return 0;
332           if(_now > presaleStartDate) return 10;
333           if(_now > privateSaleDate) return 15;
334           return 0;
335       }
336 
337     /// @dev issue tokens for a single buyer
338     /// @param _beneficiary addresses that the tokens will be sent to.
339     /// @param _tokensAmount the amount of tokens, with decimals expanded (full).
340     function doIssueTokens(address _beneficiary, uint256 _tokensAmount) public {
341         require(_beneficiary != address(0));
342 
343         // compute without actually increasing it
344         uint256 increasedTotalSupply = currentSupply.add(_tokensAmount);
345         // roll back if hard cap reached
346         require(increasedTotalSupply <= TOKENS_SALE_HARD_CAP);
347 
348         // increase token total supply
349           currentSupply = increasedTotalSupply;
350         // update the buyer's balance to number of tokens sent
351         balances[_beneficiary] = balances[_beneficiary].add(_tokensAmount);
352     }
353 
354 
355     /// @dev Returns the current price.
356     function price() public view returns (uint256 tokens) {
357       return computeTokenAmount(1 ether);
358     }
359   }