1 pragma solidity ^0.4.23;
2 
3 library SafeMath {
4     /**
5      * @dev Multiplies two numbers, throws on overflow.
6      **/
7     function mul(uint256 a, uint256 b) internal pure returns (uint256 c) {
8         if (a == 0) {
9             return 0;
10         }
11         c = a * b;
12         assert(c / a == b);
13         return c;
14     }
15     
16     /**
17      * @dev Integer division of two numbers, truncating the quotient.
18      **/
19     function div(uint256 a, uint256 b) internal pure returns (uint256) {
20         // assert(b > 0); // Solidity automatically throws when dividing by 0
21 /**
22  * @title SafeMath
23  * @dev Math operations with safety checks that throw on error
24  */
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
56     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
57 
58     /**
59      * @dev The Ownable constructor sets the original `owner` of the contract to the sender account.
60      **/
61    constructor() public {
62       owner = msg.sender;
63     }
64     
65     /**
66      * @dev Throws if called by any account other than the owner.
67      **/
68     modifier onlyOwner() {
69       require(msg.sender == owner);
70       _;
71     }
72     
73     /**
74      * @dev Allows the current owner to transfer control of the contract to a newOwner.
75      * @param newOwner The address to transfer ownership to.
76      **/
77     function transferOwnership(address newOwner) public onlyOwner {
78       require(newOwner != address(0));
79       emit OwnershipTransferred(owner, newOwner);
80       owner = newOwner;
81     }
82 }
83 
84 /**
85  * @title ERC20Basic interface
86  * @dev Basic ERC20 interface
87  **/
88 contract ERC20Basic {
89     function totalSupply() public view returns (uint256);
90     function balanceOf(address who) public view returns (uint256);
91     function transfer(address to, uint256 value) public returns (bool);
92     event Transfer(address indexed from, address indexed to, uint256 value);
93 }
94 
95 /**
96  * @title ERC20 interface
97  * @dev see https://github.com/ethereum/EIPs/issues/20
98  **/
99 contract ERC20 is ERC20Basic {
100     function allowance(address owner, address spender) public view returns (uint256);
101     function transferFrom(address from, address to, uint256 value) public returns (bool);
102     function approve(address spender, uint256 value) public returns (bool);
103     event Approval(address indexed owner, address indexed spender, uint256 value);
104 }
105 
106 /**
107  * @title Basic token
108  * @dev Basic version of StandardToken, with no allowances.
109  **/
110 contract BasicToken is ERC20Basic {
111     using SafeMath for uint256;
112     mapping(address => uint256) balances;
113     uint256 totalSupply_;
114     
115     /**
116      * @dev total number of tokens in existence
117      **/
118     function totalSupply() public view returns (uint256) {
119         return totalSupply_;
120     }
121     
122     /**
123      * @dev transfer token for a specified address
124      * @param _to The address to transfer to.
125      * @param _value The amount to be transferred.
126      **/
127     function transfer(address _to, uint256 _value) public returns (bool) {
128         require(_to != address(0));
129         require(_value <= balances[msg.sender]);
130         
131         balances[msg.sender] = balances[msg.sender].sub(_value);
132         balances[_to] = balances[_to].add(_value);
133         emit Transfer(msg.sender, _to, _value);
134         return true;
135     }
136     
137     /**
138      * @dev Gets the balance of the specified address.
139      * @param _owner The address to query the the balance of.
140      * @return An uint256 representing the amount owned by the passed address.
141      **/
142     function balanceOf(address _owner) public view returns (uint256) {
143         return balances[_owner];
144     }
145 }
146 
147 contract StandardToken is ERC20, BasicToken,Ownable{
148     mapping (address => mapping (address => uint256)) internal allowed;
149     /**
150      * @dev Transfer tokens from one address to another
151      * @param _from address The address which you want to send tokens from
152      * @param _to address The address which you want to transfer to
153      * @param _value uint256 the amount of tokens to be transferred
154      **/
155     function transferFrom(address _from, address _to, uint256 _value) public returns (bool) {
156         require(_to != address(0));
157         require(_value <= balances[_from]);
158         require(_value <= allowed[_from][msg.sender]);
159     
160         balances[_from] = balances[_from].sub(_value);
161         balances[_to] = balances[_to].add(_value);
162         allowed[_from][msg.sender] = allowed[_from][msg.sender].sub(_value);
163         
164         emit Transfer(_from, _to, _value);
165         return true;
166     }
167     
168     /**
169      * @dev Approve the passed address to spend the specified amount of tokens on behalf of msg.sender.
170      *
171      * Beware that changing an allowance with this method brings the risk that someone may use both the old
172      * and the new allowance by unfortunate transaction ordering. One possible solution to mitigate this
173      * race condition is to first reduce the spender's allowance to 0 and set the desired value afterwards:
174      * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
175      * @param _spender The address which will spend the funds.
176      * @param _value The amount of tokens to be spent.
177      **/
178     function approve(address _spender, uint256 _value) public returns (bool) {
179         allowed[msg.sender][_spender] = _value;
180         emit Approval(msg.sender, _spender, _value);
181         return true;
182     }
183     
184     /**
185      * @dev Function to check the amount of tokens that an owner allowed to a spender.
186      * @param _owner address The address which owns the funds.
187      * @param _spender address The address which will spend the funds.
188      * @return A uint256 specifying the amount of tokens still available for the spender.
189      **/
190     function allowance(address _owner, address _spender) public view returns (uint256) {
191         return allowed[_owner][_spender];
192     }
193     
194     /**
195      * @dev Increase the amount of tokens that an owner allowed to a spender.
196      *
197      * approve should be called when allowed[_spender] == 0. To increment
198      * allowed value is better to use this function to avoid 2 calls (and wait until
199      * the first transaction is mined)
200      * From MonolithDAO Token.sol
201      * @param _spender The address which will spend the funds.
202      * @param _addedValue The amount of tokens to increase the allowance by.
203      **/
204     function increaseApproval(address _spender, uint _addedValue) public returns (bool) {
205         allowed[msg.sender][_spender] = allowed[msg.sender][_spender].add(_addedValue);
206         emit Approval(msg.sender, _spender, allowed[msg.sender][_spender]);
207         return true;
208     }
209     
210     /**
211      * @dev Decrease the amount of tokens that an owner allowed to a spender.
212      *
213      * approve should be called when allowed[_spender] == 0. To decrement
214      * allowed value is better to use this function to avoid 2 calls (and wait until
215      * the first transaction is mined)
216      * From MonolithDAO Token.sol
217      * @param _spender The address which will spend the funds.
218      * @param _subtractedValue The amount of tokens to decrease the allowance by.
219      **/
220     function decreaseApproval(address _spender, uint _subtractedValue) public returns (bool) {
221         uint oldValue = allowed[msg.sender][_spender];
222         if (_subtractedValue > oldValue) {
223             allowed[msg.sender][_spender] = 0;
224         } else {
225             allowed[msg.sender][_spender] = oldValue.sub(_subtractedValue);
226         }
227         emit Approval(msg.sender, _spender, allowed[msg.sender][_spender]);
228         return true;
229     }
230    
231 }
232 
233 
234 /**
235  * @title Configurable
236  * @dev Configurable varriables of the contract
237  **/
238 contract Configurable is StandardToken{
239     uint256 constant cap =2000000000*10**18;
240     uint256 basePrice = 5000*10**18; // tokens per 1 ether
241     uint256 public tokensSold = 0;
242     uint public tokensToSell=0;
243     uint256 public constant tokenReserve = 1000000000*10**18;
244     uint256 public remainingTokens = 0;
245 }
246 
247 /**
248  * @title CrowdsaleToken 
249  * @dev Contract to preform crowd sale with token
250  **/
251 contract CrowdsaleToken is Configurable{
252     /**
253      * @dev enum of current crowd sale state
254      * 
255      **/
256      uint256 public basePriceRound1=basePrice;
257      uint256 public basePriceRound2=4000*10**18;
258      uint256 public basePriceRound3=3500*10**18;
259      enum Stages {
260         none,
261         round1, 
262         round2,
263         round3,
264         icoEnd
265     }
266     
267     Stages currentStage;
268     
269     modifier checkValidation{
270         require(currentStage != Stages.none && currentStage!=Stages.icoEnd);
271         require(msg.value>=0.5 ether);
272         require(remainingTokens > 0);
273         _;
274     }
275   
276     /**
277      * @dev constructor of CrowdsaleToken
278      **/
279     constructor() public {
280         currentStage = Stages.none;
281         balances[owner] = balances[owner].add(tokenReserve);
282         totalSupply_ = totalSupply_.add(cap);
283         tokensToSell=totalSupply_.sub(tokenReserve);
284         remainingTokens =totalSupply_.sub(tokenReserve);
285         emit Transfer(address(this), owner, tokenReserve);
286     }
287     
288     /**
289      * @dev fallback function to send ether to for Crowd sale
290      **/
291     function () public payable checkValidation{
292         uint256 weiAmount = msg.value; // Calculate tokens to sell
293         uint256 tokens = weiAmount.mul(basePrice).div(1 ether);
294         uint256 returnWei = 0;
295         
296         if(tokensSold.add(tokens) > cap){
297             uint256 newTokens = cap.sub(tokensSold);
298             uint256 newWei = newTokens.div(basePrice).mul(1 ether);
299             returnWei = weiAmount.sub(newWei);
300             weiAmount = newWei;
301             tokens = newTokens;
302         }
303         
304         tokensSold = tokensSold.add(tokens); // Increment raised amount
305         remainingTokens = tokensToSell.sub(tokensSold);
306         if(returnWei > 0){
307             msg.sender.transfer(returnWei);
308             emit Transfer(address(this), msg.sender, returnWei);
309         }
310         
311         balances[msg.sender] = balances[msg.sender].add(tokens);
312         emit Transfer(address(this), msg.sender, tokens);
313         
314         owner.transfer(weiAmount);// Send money to owner
315     }
316     
317 
318     /**
319      * @dev startIco starts the public ICO
320      **/
321     function startRound1() public onlyOwner {
322         require(currentStage == Stages.none);
323         currentStage = Stages.round1;
324     }
325     
326      function startRound2() public onlyOwner {
327         require(currentStage == Stages.round1);
328         currentStage = Stages.round1;
329         basePrice = 4000*10**18;
330     }
331     
332      function startRound3() public onlyOwner {
333         require(currentStage == Stages.round2);
334         currentStage = Stages.round1;
335         basePrice = 3500*10**18;
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
348         //owner.transfer(address(this).balance); 
349         selfdestruct(owner);
350     }
351 
352     /**
353      * @dev finalizeIco closes down the ICO and sets needed varriables
354      **/
355     function finalizeIco() public onlyOwner {
356         require(currentStage == Stages.round3);
357         endIco();
358     }
359     
360 }
361 
362 /**
363  * @title LavevelToken 
364  * @dev Contract to create the Carati Token
365  **/
366 contract BlueQbit is CrowdsaleToken {
367     string public constant name = "Carati";
368     string public constant symbol = "24Car";
369     uint32 public constant decimals = 18;
370     function burn(address _owner,uint256 amount) onlyOwner public returns (bool){
371          require(_owner != 0);
372          require(amount <= balances[_owner]);
373          totalSupply_ = totalSupply_.sub(amount);
374          balances[_owner] =balances[_owner].sub(amount);
375    
376         return true;
377     
378     }
379 }