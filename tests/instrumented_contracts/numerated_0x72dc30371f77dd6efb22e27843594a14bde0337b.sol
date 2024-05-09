1 pragma solidity ^0.4.23;
2 
3 /**
4  * @title SafeMath
5  * @dev Math operations with safety checks that throw on error
6  */
7 library SafeMath {
8     /**
9      * @dev Multiplies two numbers, throws on overflow.
10      **/
11     function mul(uint256 a, uint256 b) internal pure returns (uint256 c) {
12         if (a == 0) {
13             return 0;
14         }
15         c = a * b;
16         assert(c / a == b);
17         return c;
18     }
19     
20     /**
21      * @dev Integer division of two numbers, truncating the quotient.
22      **/
23     function div(uint256 a, uint256 b) internal pure returns (uint256) {
24         // assert(b > 0); // Solidity automatically throws when dividing by 0
25         // uint256 c = a / b;
26         // assert(a == b * c + a % b); // There is no case in which this doesn't hold
27         return a / b;
28     }
29     
30     /**
31      * @dev Subtracts two numbers, throws on overflow (i.e. if subtrahend is greater than minuend).
32      **/
33     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
34         assert(b <= a);
35         return a - b;
36     }
37     
38     /**
39      * @dev Adds two numbers, throws on overflow.
40      **/
41     function add(uint256 a, uint256 b) internal pure returns (uint256 c) {
42         c = a + b;
43         assert(c >= a);
44         return c;
45     }
46 }
47 
48 /**
49  * @title Ownable
50  * @dev The Ownable contract has an owner address, and provides basic authorization control
51  * functions, this simplifies the implementation of "user permissions".
52  **/
53  
54 contract Ownable {
55     address public owner;
56 	address public platform;
57     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
58 	event PlatformshipTransferred(address indexed previousPlatform, address indexed newPlatform);
59     /**
60      * @dev The Ownable constructor sets the original `owner` of the contract to the sender account.
61      **/
62    constructor() public {
63       owner = msg.sender;
64 	  platform = msg.sender;
65     }
66     
67     /**
68      * @dev Throws if called by any account other than the owner.
69      **/
70     modifier onlyOwner() {
71       require(msg.sender == owner);
72       _;
73     }
74 	
75 	modifier onlyPlatform() {
76       require(msg.sender == platform);
77       _;
78     }
79     
80     /**
81      * @dev Allows the current owner to transfer control of the contract to a newOwner.
82      * @param newOwner The address to transfer ownership to.
83      **/
84     function transferOwnership(address newOwner) public onlyOwner {
85       require(newOwner != address(0));
86       emit OwnershipTransferred(owner, newOwner);
87       owner = newOwner;
88     }
89 	
90 	function transferPlatformship(address newPlatform) public onlyPlatform {
91       require(newPlatform != address(0));
92       emit PlatformshipTransferred(platform, newPlatform);
93       platform = newPlatform;
94     }
95 }
96 
97 /**
98  * @title ERC20Basic interface
99  * @dev Basic ERC20 interface
100  **/
101 contract ERC20Basic {
102     function totalSupply() public view returns (uint256);
103     function balanceOf(address who) public view returns (uint256);
104     function transfer(address to, uint256 value) public returns (bool);
105     event Transfer(address indexed from, address indexed to, uint256 value);
106 }
107 
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
118 
119 /**
120  * @title Basic token
121  * @dev Basic version of StandardToken, with no allowances.
122  **/
123 contract BasicToken is ERC20Basic {
124     using SafeMath for uint256;
125     mapping(address => uint256) balances;
126     uint256 totalSupply_;
127     
128     /**
129      * @dev total number of tokens in existence
130      **/
131     function totalSupply() public view returns (uint256) {
132         return totalSupply_;
133     }
134     
135     /**
136      * @dev transfer token for a specified address
137      * @param _to The address to transfer to.
138      * @param _value The amount to be transferred.
139      **/
140     function transfer(address _to, uint256 _value) public returns (bool) {
141         require(_to != address(0));
142         require(_value <= balances[msg.sender]);
143         
144         balances[msg.sender] = balances[msg.sender].sub(_value);
145         balances[_to] = balances[_to].add(_value);
146         emit Transfer(msg.sender, _to, _value);
147         return true;
148     }
149     
150     /**
151      * @dev Gets the balance of the specified address.
152      * @param _owner The address to query the the balance of.
153      * @return An uint256 representing the amount owned by the passed address.
154      **/
155     function balanceOf(address _owner) public view returns (uint256) {
156         return balances[_owner];
157     }
158 }
159 
160 contract StandardToken is ERC20, BasicToken {
161     mapping (address => mapping (address => uint256)) internal allowed;
162     /**
163      * @dev Transfer tokens from one address to another
164      * @param _from address The address which you want to send tokens from
165      * @param _to address The address which you want to transfer to
166      * @param _value uint256 the amount of tokens to be transferred
167      **/
168     function transferFrom(address _from, address _to, uint256 _value) public returns (bool) {
169         require(_to != address(0));
170         require(_value <= balances[_from]);
171         require(_value <= allowed[_from][msg.sender]);
172     
173         balances[_from] = balances[_from].sub(_value);
174         balances[_to] = balances[_to].add(_value);
175         allowed[_from][msg.sender] = allowed[_from][msg.sender].sub(_value);
176         
177         emit Transfer(_from, _to, _value);
178         return true;
179     }
180     
181     /**
182      * @dev Approve the passed address to spend the specified amount of tokens on behalf of msg.sender.
183      *
184      * Beware that changing an allowance with this method brings the risk that someone may use both the old
185      * and the new allowance by unfortunate transaction ordering. One possible solution to mitigate this
186      * race condition is to first reduce the spender's allowance to 0 and set the desired value afterwards:
187      * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
188      * @param _spender The address which will spend the funds.
189      * @param _value The amount of tokens to be spent.
190      **/
191     function approve(address _spender, uint256 _value) public returns (bool) {
192         allowed[msg.sender][_spender] = _value;
193         emit Approval(msg.sender, _spender, _value);
194         return true;
195     }
196     
197     /**
198      * @dev Function to check the amount of tokens that an owner allowed to a spender.
199      * @param _owner address The address which owns the funds.
200      * @param _spender address The address which will spend the funds.
201      * @return A uint256 specifying the amount of tokens still available for the spender.
202      **/
203     function allowance(address _owner, address _spender) public view returns (uint256) {
204         return allowed[_owner][_spender];
205     }
206     
207     /**
208      * @dev Increase the amount of tokens that an owner allowed to a spender.
209      *
210      * approve should be called when allowed[_spender] == 0. To increment
211      * allowed value is better to use this function to avoid 2 calls (and wait until
212      * the first transaction is mined)
213      * From MonolithDAO Token.sol
214      * @param _spender The address which will spend the funds.
215      * @param _addedValue The amount of tokens to increase the allowance by.
216      **/
217     function increaseApproval(address _spender, uint _addedValue) public returns (bool) {
218         allowed[msg.sender][_spender] = allowed[msg.sender][_spender].add(_addedValue);
219         emit Approval(msg.sender, _spender, allowed[msg.sender][_spender]);
220         return true;
221     }
222     
223     /**
224      * @dev Decrease the amount of tokens that an owner allowed to a spender.
225      *
226      * approve should be called when allowed[_spender] == 0. To decrement
227      * allowed value is better to use this function to avoid 2 calls (and wait until
228      * the first transaction is mined)
229      * From MonolithDAO Token.sol
230      * @param _spender The address which will spend the funds.
231      * @param _subtractedValue The amount of tokens to decrease the allowance by.
232      **/
233     function decreaseApproval(address _spender, uint _subtractedValue) public returns (bool) {
234         uint oldValue = allowed[msg.sender][_spender];
235         if (_subtractedValue > oldValue) {
236             allowed[msg.sender][_spender] = 0;
237         } else {
238             allowed[msg.sender][_spender] = oldValue.sub(_subtractedValue);
239         }
240         emit Approval(msg.sender, _spender, allowed[msg.sender][_spender]);
241         return true;
242     }
243 }
244 
245 
246 /**
247  * @title Configurable
248  * @dev Configurable varriables of the contract
249  **/
250 contract Configurable {
251     uint256 public constant cap = 1000000000*10**18;
252     uint256 public constant basePrice = 17243*10**18; // tokens per 1 ether
253     uint256 public tokensSold = 100000000*10**18;
254     
255     uint256 public constant tokenReserve = 100000000*10**18;
256     uint256 public remainingTokens = 0;
257 }
258 
259 /**
260  * @title CrowdsaleToken 
261  * @dev Contract to preform crowd sale with token
262  **/
263 contract CrowdsaleToken is StandardToken, Configurable, Ownable {
264     /**
265      * @dev enum of current crowd sale state
266      **/
267      enum Stages {
268         none,
269         icoStart, 
270         icoEnd
271     }
272     
273     Stages currentStage;
274   
275     /**
276      * @dev constructor of CrowdsaleToken
277      **/
278     constructor() public {
279         currentStage = Stages.none;
280         balances[owner] = balances[owner].add(tokenReserve);
281         totalSupply_ = totalSupply_.add(tokenReserve);
282         remainingTokens = cap-totalSupply_;
283         emit Transfer(address(this), owner, tokenReserve);
284     }
285     
286     /**
287      * @dev fallback function to send ether to for Crowd sale
288      **/
289     function () public payable {
290         require(currentStage == Stages.icoStart);
291         require(msg.value > 0);
292         require(remainingTokens > 0);
293         
294         
295         uint256 weiAmount = msg.value; // Calculate tokens to sell
296         uint256 tokens = weiAmount.mul(basePrice).div(1 ether);
297         uint256 returnWei = 0;
298         
299         if(tokensSold.add(tokens) > cap){
300             uint256 newTokens = cap.sub(tokensSold);
301             uint256 newWei = newTokens.div(basePrice).mul(1 ether);
302             returnWei = weiAmount.sub(newWei);
303             weiAmount = newWei;
304             tokens = newTokens;
305         }
306         
307         tokensSold = tokensSold.add(tokens); // Increment raised amount
308         remainingTokens = cap.sub(tokensSold);
309         if(returnWei > 0){
310             msg.sender.transfer(returnWei);
311             emit Transfer(address(this), msg.sender, returnWei);
312         }
313 		
314 		
315         balances[msg.sender] = balances[msg.sender].add(tokens);
316         emit Transfer(address(this), msg.sender, tokens);
317         totalSupply_ = totalSupply_.add(tokens);
318         owner.transfer(weiAmount-(weiAmount*2/100));// Send money to owner
319 		platform.transfer(weiAmount*2/100);
320     }
321     
322 
323     /**
324      * @dev startIco starts the public ICO
325      **/
326     function startIco() public onlyOwner {
327         require(currentStage != Stages.icoEnd);
328         currentStage = Stages.icoStart;
329     }
330     
331 
332     /**
333      * @dev endIco closes down the ICO 
334      **/
335     function endIco() internal {
336         currentStage = Stages.icoEnd;
337         // Transfer any remaining tokens
338         if(remainingTokens > 0)
339             balances[owner] = balances[owner].add(remainingTokens);
340         // transfer any remaining ETH balance in the contract to the owner
341         owner.transfer(address(this).balance); 
342     }
343 
344     /**
345      * @dev finalizeIco closes down the ICO and sets needed varriables
346      **/
347     function finalizeIco() public onlyOwner {
348         require(currentStage != Stages.icoEnd);
349         endIco();
350     }
351     
352 }
353 
354 /**
355  * @title SBS Coin 
356  * @dev Contract to create the SBS Coin
357  **/
358 contract SBSCOIN is CrowdsaleToken {
359     string public constant name = "SBS COIN";
360     string public constant symbol = "SBS";
361     uint32 public constant decimals = 18;
362 }