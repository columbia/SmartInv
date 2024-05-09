1 /**
2  *Submitted for verification at Etherscan.io on 2021-05-15
3 */
4 
5 pragma solidity ^0.4.23;
6 
7 /**
8  * 
9 Welcome to Yorkshire Inu Token Smart Contract
10 URL: yorkshireinu.com
11 Total Supply: 100,000,000,000,000,000
12 •	ICO(Crowdsale): Reserved upto 20% Unsold token will be paid for referral program and subject to burn for the rest
13 •	Company 2%
14 •	Team 1.5%
15 •	Marketing 1.5%
16 •	Initial Burn to address 0x000dead 30%
17 •	45% will be added to Liquidity and lock in 5 Years
18  * 
19  */
20 /**
21  * @title SafeMath
22  * @dev Math operations with safety checks that throw on error
23  */
24 library SafeMath {
25     /**
26      * @dev Multiplies two numbers, throws on overflow.
27      **/
28     function mul(uint256 a, uint256 b) internal pure returns (uint256 c) {
29         if (a == 0) {
30             return 0;
31         }
32         c = a * b;
33         assert(c / a == b);
34         return c;
35     }
36     
37     /**
38      * @dev Integer division of two numbers, truncating the quotient.
39      **/
40     function div(uint256 a, uint256 b) internal pure returns (uint256) {
41         // assert(b > 0); // Solidity automatically throws when dividing by 0
42         // uint256 c = a / b;
43         // assert(a == b * c + a % b); // There is no case in which this doesn't hold
44         return a / b;
45     }
46     
47     /**
48      * @dev Subtracts two numbers, throws on overflow (i.e. if subtrahend is greater than minuend).
49      **/
50     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
51         assert(b <= a);
52         return a - b;
53     }
54     
55     /**
56      * @dev Adds two numbers, throws on overflow.
57      **/
58     function add(uint256 a, uint256 b) internal pure returns (uint256 c) {
59         c = a + b;
60         assert(c >= a);
61         return c;
62     }
63 }
64 /**
65  * @title Ownable
66  * @dev The Ownable contract has an owner address, and provides basic authorization control
67  * functions, this simplifies the implementation of "user permissions".
68  **/
69  
70 contract Ownable {
71     address public owner;
72     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
73 /**
74      * @dev The Ownable constructor sets the original `owner` of the contract to the sender account.
75      **/
76    constructor() public {
77       owner = msg.sender;
78     }
79     
80     /**
81      * @dev Throws if called by any account other than the owner.
82      **/
83     modifier onlyOwner() {
84       require(msg.sender == owner);
85       _;
86     }
87     
88     /**
89      * @dev Allows the current owner to transfer control of the contract to a newOwner.
90      * @param newOwner The address to transfer ownership to.
91      **/
92     function transferOwnership(address newOwner) public onlyOwner {
93       require(newOwner != address(0));
94       emit OwnershipTransferred(owner, newOwner);
95       owner = newOwner;
96     }
97 }
98 /**
99  * @title ERC20Basic interface
100  * @dev Basic ERC20 interface
101  **/
102 contract ERC20Basic {
103     function totalSupply() public view returns (uint256);
104     function balanceOf(address who) public view returns (uint256);
105     function transfer(address to, uint256 value) public returns (bool);
106     event Transfer(address indexed from, address indexed to, uint256 value);
107 }
108 /**
109  * @title ERC20 interface
110  * @dev see https://github.com/ethereum/EIPs/issues/20
111  **/
112 contract ERC20 is ERC20Basic {
113     function allowance(address owner, address spender) public view returns (uint256);
114     function transferFrom(address from, address to, uint256 value) public returns (bool);
115     function approve(address spender, uint256 value) public returns (bool);
116     event Approval(address indexed owner, address indexed spender, uint256 value);
117 }
118 /**
119  * @title Basic token
120  * @dev Basic version of YorkshireInuToken, with no allowances.
121  **/
122 contract BasicToken is ERC20Basic {
123     using SafeMath for uint256;
124     mapping(address => uint256) balances;
125     uint256 totalSupply_;
126     
127     /**
128      * @dev total number of tokens in existence
129      **/
130     function totalSupply() public view returns (uint256) {
131         return totalSupply_;
132     }
133     
134     /**
135      * @dev transfer token for a specified address
136      * @param _to The address to transfer to.
137      * @param _value The amount to be transferred.
138      **/
139     function transfer(address _to, uint256 _value) public returns (bool) {
140         require(_to != address(0));
141         require(_value <= balances[msg.sender]);
142         
143         balances[msg.sender] = balances[msg.sender].sub(_value);
144         balances[_to] = balances[_to].add(_value);
145         emit Transfer(msg.sender, _to, _value);
146         return true;
147     }
148     
149     /**
150      * @dev Gets the balance of the specified address.
151      * @param _owner The address to query the the balance of.
152      * @return An uint256 representing the amount owned by the passed address.
153      **/
154     function balanceOf(address _owner) public view returns (uint256) {
155         return balances[_owner];
156     }
157 }
158 contract YorkshireInuToken is ERC20, BasicToken {
159     mapping (address => mapping (address => uint256)) internal allowed;
160     /**
161      * @dev Transfer tokens from one address to another
162      * @param _from address The address which you want to send tokens from
163      * @param _to address The address which you want to transfer to
164      * @param _value uint256 the amount of tokens to be transferred
165      **/
166     function transferFrom(address _from, address _to, uint256 _value) public returns (bool) {
167         require(_to != address(0));
168         require(_value <= balances[_from]);
169         require(_value <= allowed[_from][msg.sender]);
170     
171         balances[_from] = balances[_from].sub(_value);
172         balances[_to] = balances[_to].add(_value);
173         allowed[_from][msg.sender] = allowed[_from][msg.sender].sub(_value);
174         
175         emit Transfer(_from, _to, _value);
176         return true;
177     }
178     
179     /**
180      * @dev Approve the passed address to spend the specified amount of tokens on behalf of msg.sender.
181      *
182      * Beware that changing an allowance with this method brings the risk that someone may use both the old
183      * and the new allowance by unfortunate transaction ordering. One possible solution to mitigate this
184      * race condition is to first reduce the spender's allowance to 0 and set the desired value afterwards:
185      * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
186      * @param _spender The address which will spend the funds.
187      * @param _value The amount of tokens to be spent.
188      **/
189     function approve(address _spender, uint256 _value) public returns (bool) {
190         allowed[msg.sender][_spender] = _value;
191         emit Approval(msg.sender, _spender, _value);
192         return true;
193     }
194     
195     /**
196      * @dev Function to check the amount of tokens that an owner allowed to a spender.
197      * @param _owner address The address which owns the funds.
198      * @param _spender address The address which will spend the funds.
199      * @return A uint256 specifying the amount of tokens still available for the spender.
200      **/
201     function allowance(address _owner, address _spender) public view returns (uint256) {
202         return allowed[_owner][_spender];
203     }
204     
205     /**
206      * @dev Increase the amount of tokens that an owner allowed to a spender.
207      *
208      * approve should be called when allowed[_spender] == 0. To increment
209      * allowed value is better to use this function to avoid 2 calls (and wait until
210      * the first transaction is mined)
211      * From MonolithDAO Token.sol
212      * @param _spender The address which will spend the funds.
213      * @param _addedValue The amount of tokens to increase the allowance by.
214      **/
215     function increaseApproval(address _spender, uint _addedValue) public returns (bool) {
216         allowed[msg.sender][_spender] = allowed[msg.sender][_spender].add(_addedValue);
217         emit Approval(msg.sender, _spender, allowed[msg.sender][_spender]);
218         return true;
219     }
220     
221     /**
222      * @dev Decrease the amount of tokens that an owner allowed to a spender.
223      *
224      * approve should be called when allowed[_spender] == 0. To decrement
225      * allowed value is better to use this function to avoid 2 calls (and wait until
226      * the first transaction is mined)
227      * From MonolithDAO Token.sol
228      * @param _spender The address which will spend the funds.
229      * @param _subtractedValue The amount of tokens to decrease the allowance by.
230      **/
231     function decreaseApproval(address _spender, uint _subtractedValue) public returns (bool) {
232         uint oldValue = allowed[msg.sender][_spender];
233         if (_subtractedValue > oldValue) {
234             allowed[msg.sender][_spender] = 0;
235         } else {
236             allowed[msg.sender][_spender] = oldValue.sub(_subtractedValue);
237         }
238         emit Approval(msg.sender, _spender, allowed[msg.sender][_spender]);
239         return true;
240     }
241 }
242 /**
243  * @title Configurable
244  * @dev Configurable varriables of the contract
245  **/
246 contract Configurable {
247     uint256 public constant cap = 20000000000000000*10**18;
248     uint256 public constant basePrice = 40000000000000*10**18; // tokens per 1 ether
249     uint256 public tokensSold = 0;
250     
251     uint256 public constant tokenReserve = 80000000000000000*10**18;
252     uint256 public remainingTokens = 0;
253 }
254 /**
255  * @title CrowdsaleToken 
256  * @dev Contract to preform crowd sale with token
257  **/
258 contract CrowdsaleToken is YorkshireInuToken, Configurable, Ownable {
259     /**
260      * @dev enum of current crowd sale state
261      **/
262      enum Stages {
263         none,
264         icoStart, 
265         icoEnd
266     }
267     
268     Stages currentStage;
269   
270     /**
271      * @dev constructor of CrowdsaleToken
272      **/
273     constructor() public {
274         currentStage = Stages.none;
275         balances[owner] = balances[owner].add(tokenReserve);
276         totalSupply_ = totalSupply_.add(tokenReserve);
277         remainingTokens = cap;
278         emit Transfer(address(this), owner, tokenReserve);
279     }
280     
281     /**
282      * @dev fallback function to send ether to for Crowd sale
283      **/
284     function () public payable {
285         require(currentStage == Stages.icoStart);
286         require(msg.value > 0);
287         require(remainingTokens > 0);
288         
289         
290         uint256 weiAmount = msg.value; // Calculate tokens to sell
291         uint256 tokens = weiAmount.mul(basePrice).div(1 ether);
292         uint256 returnWei = 0;
293         
294         if(tokensSold.add(tokens) > cap){
295             uint256 newTokens = cap.sub(tokensSold);
296             uint256 newWei = newTokens.div(basePrice).mul(1 ether);
297             returnWei = weiAmount.sub(newWei);
298             weiAmount = newWei;
299             tokens = newTokens;
300         }
301         
302         tokensSold = tokensSold.add(tokens); // Increment raised amount
303         remainingTokens = cap.sub(tokensSold);
304         if(returnWei > 0){
305             msg.sender.transfer(returnWei);
306             emit Transfer(address(this), msg.sender, returnWei);
307         }
308         
309         balances[msg.sender] = balances[msg.sender].add(tokens);
310         emit Transfer(address(this), msg.sender, tokens);
311         totalSupply_ = totalSupply_.add(tokens);
312         owner.transfer(weiAmount);// Send money to owner
313     }
314 /**
315      * @dev startIco starts the public ICO
316      **/
317     function startIco() public onlyOwner {
318         require(currentStage != Stages.icoEnd);
319         currentStage = Stages.icoStart;
320     }
321 /**
322      * @dev endIco closes down the ICO 
323      **/
324     function endIco() internal {
325         currentStage = Stages.icoEnd;
326         // Transfer any remaining tokens
327         if(remainingTokens > 0)
328             balances[owner] = balances[owner].add(remainingTokens);
329         // transfer any remaining ETH balance in the contract to the owner
330         owner.transfer(address(this).balance); 
331     }
332 /**
333      * @dev finalizeIco closes down the ICO and sets needed varriables
334      **/
335     function finalizeIco() public onlyOwner {
336         require(currentStage != Stages.icoEnd);
337         endIco();
338     }
339     
340 }
341 /**
342  * @title YorkshireInu 
343  * @dev Yorkshire Inu Inspiring Team
344  **/
345 contract YorkshireInu is CrowdsaleToken {
346     string public constant name = "Yorkshire Inu";
347     string public constant symbol = "YSI";
348     uint32 public constant decimals = 18;
349 }