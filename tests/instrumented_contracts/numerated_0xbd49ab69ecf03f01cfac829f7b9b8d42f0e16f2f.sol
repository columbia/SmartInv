1 pragma solidity ^0.4.25;
2 
3 // ----------------------------------------------------------------------------
4 // 'Dronair' token contract
5 //
6 // Symbol                        : DAIR
7 // Name                          : Dronair
8 // Total supply                  : 140*10^9
9 //Token for public sale          : 56*10^9   (40%)
10 //Token for private sale         : 28*10^9   (20%)
11 //Token for Team-Adv             : 14*10^9   (10%)
12 //Token for Marketing & Adoption : 25.2*10^9 (18%)
13 //Token for Foundation           : 16.8*10^9 (12%)
14 // Decimals                      : 18
15 //
16 // Enjoy.
17 //
18 //
19 // ----------------------------------------------------------------------------
20 
21 
22 // ----------------------------------------------------------------------------
23 // Safe maths
24 // ----------------------------------------------------------------------------
25 
26 library SafeMath {
27     /**
28      * @dev Multiplies two numbers, throws on overflow.
29      **/
30     function mul(uint256 a, uint256 b) internal pure returns (uint256 c) {
31         if (a == 0) {
32             return 0;
33         }
34         c = a * b;
35         assert(c / a == b);
36         return c;
37     }
38 
39     /**
40      * @dev Integer division of two numbers, truncating the quotient.
41      **/
42     function div(uint256 a, uint256 b) internal pure returns (uint256) {
43         // assert(b > 0); // Solidity automatically throws when dividing by 0
44 /**
45  * @title SafeMath
46  * @dev Math operations with safety checks that throw on error
47  */
48         // uint256 c = a / b;
49         // assert(a == b * c + a % b); // There is no case in which this doesn't hold
50         return a / b;
51     }
52 
53     /**
54      * @dev Subtracts two numbers, throws on overflow (i.e. if subtrahend is greater than minuend).
55      **/
56     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
57         assert(b <= a);
58         return a - b;
59     }
60 
61     /**
62      * @dev Adds two numbers, throws on overflow.
63      **/
64     function add(uint256 a, uint256 b) internal pure returns (uint256 c) {
65         c = a + b;
66         assert(c >= a);
67         return c;
68     }
69 }
70 
71 /**
72  * @title Ownable
73  * @dev The Ownable contract has an owner address, and provides basic authorization control
74  * functions, this simplifies the implementation of "user permissions".
75  **/
76 
77 contract Ownable {
78     address public owner;
79     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
80 
81     /**
82      * @dev The Ownable constructor sets the original `owner` of the contract to the sender account.
83      **/
84    constructor() public {
85       owner = msg.sender;
86     }
87 
88     /**
89      * @dev Throws if called by any account other than the owner.
90      **/
91     modifier onlyOwner() {
92       require(msg.sender == owner);
93       _;
94     }
95 
96     /**
97      * @dev Allows the current owner to transfer control of the contract to a newOwner.
98      * @param newOwner The address to transfer ownership to.
99      **/
100     function transferOwnership(address newOwner) public onlyOwner {
101       require(newOwner != address(0));
102       emit OwnershipTransferred(owner, newOwner);
103       owner = newOwner;
104     }
105 }
106 
107 /**
108  * @title ERC20Basic interface
109  * @dev Basic ERC20 interface
110  **/
111 contract ERC20Basic {
112     function totalSupply() public view returns (uint256);
113     function balanceOf(address who) public view returns (uint256);
114     function transfer(address to, uint256 value) public returns (bool);
115     event Transfer(address indexed from, address indexed to, uint256 value);
116 }
117 
118 /**
119  * @title ERC20 interface
120  * @dev see https://github.com/ethereum/EIPs/issues/20
121  **/
122 contract ERC20 is ERC20Basic {
123     function allowance(address owner, address spender) public view returns (uint256);
124     function transferFrom(address from, address to, uint256 value) public returns (bool);
125     function approve(address spender, uint256 value) public returns (bool);
126     event Approval(address indexed owner, address indexed spender, uint256 value);
127 }
128 
129 /**
130  * @title Basic token
131  * @dev Basic version of StandardToken, with no allowances.
132  **/
133 contract BasicToken is ERC20Basic {
134     using SafeMath for uint256;
135     mapping(address => uint256) balances;
136     uint256 totalSupply_ = 140*10**27;
137 
138     /**
139      * @dev total number of tokens in existence
140      **/
141     function totalSupply() public view returns (uint256) {
142         return totalSupply_;
143     }
144 
145     /**
146      * @dev transfer token for a specified address
147      * @param _to The address to transfer to.
148      * @param _value The amount to be transferred.
149      **/
150     function transfer(address _to, uint256 _value) public returns (bool) {
151         require(_to != address(0));
152         require(_value <= balances[msg.sender]);
153 
154         balances[msg.sender] = balances[msg.sender].sub(_value);
155         balances[_to] = balances[_to].add(_value);
156         emit Transfer(msg.sender, _to, _value);
157         return true;
158     }
159 
160     /**
161      * @dev Gets the balance of the specified address.
162      * @param _owner The address to query the the balance of.
163      * @return An uint256 representing the amount owned by the passed address.
164      **/
165     function balanceOf(address _owner) public view returns (uint256) {
166         return balances[_owner];
167     }
168 }
169 
170 contract StandardToken is ERC20, BasicToken {
171     mapping (address => mapping (address => uint256)) internal allowed;
172     /**
173      * @dev Transfer tokens from one address to another
174      * @param _from address The address which you want to send tokens from
175      * @param _to address The address which you want to transfer to
176      * @param _value uint256 the amount of tokens to be transferred
177      **/
178     function transferFrom(address _from, address _to, uint256 _value) public returns (bool) {
179         require(_to != address(0));
180         require(_value <= balances[_from]);
181         require(_value <= allowed[_from][msg.sender]);
182 
183         balances[_from] = balances[_from].sub(_value);
184         balances[_to] = balances[_to].add(_value);
185         allowed[_from][msg.sender] = allowed[_from][msg.sender].sub(_value);
186 
187         emit Transfer(_from, _to, _value);
188         return true;
189     }
190 
191     /**
192      * @dev Approve the passed address to spend the specified amount of tokens on behalf of msg.sender.
193      *
194      * Beware that changing an allowance with this method brings the risk that someone may use both the old
195      * and the new allowance by unfortunate transaction ordering. One possible solution to mitigate this
196      * race condition is to first reduce the spender's allowance to 0 and set the desired value afterwards:
197      * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
198      * @param _spender The address which will spend the funds.
199      * @param _value The amount of tokens to be spent.
200      **/
201     function approve(address _spender, uint256 _value) public returns (bool) {
202         allowed[msg.sender][_spender] = _value;
203         emit Approval(msg.sender, _spender, _value);
204         return true;
205     }
206 
207     /**
208      * @dev Function to check the amount of tokens that an owner allowed to a spender.
209      * @param _owner address The address which owns the funds.
210      * @param _spender address The address which will spend the funds.
211      * @return A uint256 specifying the amount of tokens still available for the spender.
212      **/
213     function allowance(address _owner, address _spender) public view returns (uint256) {
214         return allowed[_owner][_spender];
215     }
216 
217     /**
218      * @dev Increase the amount of tokens that an owner allowed to a spender.
219      *
220      * approve should be called when allowed[_spender] == 0. To increment
221      * allowed value is better to use this function to avoid 2 calls (and wait until
222      * the first transaction is mined)
223      * From MonolithDAO Token.sol
224      * @param _spender The address which will spend the funds.
225      * @param _addedValue The amount of tokens to increase the allowance by.
226      **/
227     function increaseApproval(address _spender, uint _addedValue) public returns (bool) {
228         allowed[msg.sender][_spender] = allowed[msg.sender][_spender].add(_addedValue);
229         emit Approval(msg.sender, _spender, allowed[msg.sender][_spender]);
230         return true;
231     }
232 
233     /**
234      * @dev Decrease the amount of tokens that an owner allowed to a spender.
235      *
236      * approve should be called when allowed[_spender] == 0. To decrement
237      * allowed value is better to use this function to avoid 2 calls (and wait until
238      * the first transaction is mined)
239      * From MonolithDAO Token.sol
240      * @param _spender The address which will spend the funds.
241      * @param _subtractedValue The amount of tokens to decrease the allowance by.
242      **/
243     function decreaseApproval(address _spender, uint _subtractedValue) public returns (bool) {
244         uint oldValue = allowed[msg.sender][_spender];
245         if (_subtractedValue > oldValue) {
246             allowed[msg.sender][_spender] = 0;
247         } else {
248             allowed[msg.sender][_spender] = oldValue.sub(_subtractedValue);
249         }
250         emit Approval(msg.sender, _spender, allowed[msg.sender][_spender]);
251         return true;
252     }
253 }
254 
255 
256 /**
257  * @title Configurable
258  * @dev Configurable varriables of the contract
259  **/
260 contract Configurable {
261     uint256 public constant cap = 56*10**27;
262     uint256 public constant basePrice = 322*10**22; // tokens per 1 ether
263     uint256 public tokensSold = 0;
264     uint256 public constant tokenReserve = 84*10**27;
265     uint256 public remainingTokens = 0;
266 }
267 
268 /**
269  * @title CrowdsaleToken
270  * @dev Contract to preform crowd sale with token
271  **/
272 contract CrowdsaleToken is StandardToken, Configurable, Ownable {
273     /**
274      * @dev enum of current crowd sale state
275      **/
276      enum Stages {
277         none,
278         icoStart,
279         icoEnd
280     }
281 
282     Stages currentStage;
283 
284     /**
285      * @dev constructor of CrowdsaleToken
286      **/
287     constructor() public {
288         currentStage = Stages.none;
289         balances[owner] = balances[owner].add(tokenReserve);
290         totalSupply_ = totalSupply_.add(tokenReserve);
291         remainingTokens = cap;
292         emit Transfer(address(this), owner, tokenReserve);
293     }
294 
295     /**
296      * @dev fallback function to send ether to for Crowd sale
297      **/
298     function () public payable {
299         require(currentStage == Stages.icoStart);
300         require(msg.value > 0);
301         require(remainingTokens > 0);
302 
303 
304         uint256 weiAmount = msg.value; // Calculate tokens to sell
305         uint256 tokens = weiAmount.mul(basePrice).div(1 ether);
306         uint256 returnWei = 0;
307 
308         if(tokensSold.add(tokens) > cap){
309             uint256 newTokens = cap.sub(tokensSold);
310             uint256 newWei = newTokens.div(basePrice).mul(1 ether);
311             returnWei = weiAmount.sub(newWei);
312             weiAmount = newWei;
313             tokens = newTokens;
314         }
315 
316         tokensSold = tokensSold.add(tokens); // Increment raised amount
317         remainingTokens = cap.sub(tokensSold);
318         if(returnWei > 0){
319             msg.sender.transfer(returnWei);
320             emit Transfer(address(this), msg.sender, returnWei);
321         }
322 
323         balances[msg.sender] = balances[msg.sender].add(tokens);
324         emit Transfer(address(this), msg.sender, tokens);
325         //totalSupply_ = totalSupply_.add(tokens);
326         owner.transfer(weiAmount);// Send money to owner
327     }
328 
329 
330     /**
331      * @dev startIco starts the public ICO
332      **/
333     function startIco() public onlyOwner {
334         require(currentStage != Stages.icoEnd);
335         currentStage = Stages.icoStart;
336     }
337 
338 
339     /**
340      * @dev endIco closes down the ICO
341      **/
342     function endIco() internal {
343         currentStage = Stages.icoEnd;
344         // Transfer any remaining tokens
345         if(remainingTokens > 0)
346             balances[owner] = balances[owner].add(remainingTokens);
347         // transfer any remaining ETH balance in the contract to the owner
348         owner.transfer(address(this).balance);
349     }
350 
351     /**
352      * @dev finalizeIco closes down the ICO and sets needed varriables
353      **/
354     function finalizeIco() public onlyOwner {
355         require(currentStage != Stages.icoEnd);
356         endIco();
357     }
358 
359 }
360 
361 /**
362  * @title DronairToken
363  * @dev Contract to create the Lavevel Token
364  **/
365 contract DronairToken is CrowdsaleToken {
366     string public constant name = "TDronair";
367     string public constant symbol = "TDAIR";
368     uint32 public constant decimals = 18;
369 }