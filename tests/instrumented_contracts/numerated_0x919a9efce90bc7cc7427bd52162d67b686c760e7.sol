1 pragma solidity ^0.4.24;
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
104 
105     // This notifies clients about the amount burnt
106     event Burn(address indexed from, uint256 value);
107 }
108 
109 /**
110  * @title Basic token
111  * @dev Basic version of StandardToken, with no allowances.
112  **/
113 contract BasicToken is ERC20Basic {
114     using SafeMath for uint256;
115     mapping(address => uint256) balances;
116     uint256 totalSupply_;
117     
118     /**
119      * @dev total number of tokens in existence
120      **/
121     function totalSupply() public view returns (uint256) {
122         return totalSupply_;
123     }
124     
125     /**
126      * @dev transfer token for a specified address
127      * @param _to The address to transfer to.
128      * @param _value The amount to be transferred.
129      **/
130     function transfer(address _to, uint256 _value) public returns (bool) {
131         require(_to != address(0));
132         require(_value <= balances[msg.sender]);
133         
134         balances[msg.sender] = balances[msg.sender].sub(_value);
135         balances[_to] = balances[_to].add(_value);
136         emit Transfer(msg.sender, _to, _value);
137         return true;
138     }
139     
140     /**
141      * @dev Gets the balance of the specified address.
142      * @param _owner The address to query the the balance of.
143      * @return An uint256 representing the amount owned by the passed address.
144      **/
145     function balanceOf(address _owner) public view returns (uint256) {
146         return balances[_owner];
147     }
148 }
149 
150 contract StandardToken is ERC20, BasicToken {
151     mapping (address => mapping (address => uint256)) internal allowed;
152     /**
153      * @dev Transfer tokens from one address to another
154      * @param _from address The address which you want to send tokens from
155      * @param _to address The address which you want to transfer to
156      * @param _value uint256 the amount of tokens to be transferred
157      **/
158     function transferFrom(address _from, address _to, uint256 _value) public returns (bool) {
159         require(_to != address(0));
160         require(_value <= balances[_from]);
161         require(_value <= allowed[_from][msg.sender]);
162     
163         balances[_from] = balances[_from].sub(_value);
164         balances[_to] = balances[_to].add(_value);
165         allowed[_from][msg.sender] = allowed[_from][msg.sender].sub(_value);
166         
167         emit Transfer(_from, _to, _value);
168         return true;
169     }
170     
171     /**
172      * @dev Approve the passed address to spend the specified amount of tokens on behalf of msg.sender.
173      *
174      * Beware that changing an allowance with this method brings the risk that someone may use both the old
175      * and the new allowance by unfortunate transaction ordering. One possible solution to mitigate this
176      * race condition is to first reduce the spender's allowance to 0 and set the desired value afterwards:
177      * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
178      * @param _spender The address which will spend the funds.
179      * @param _value The amount of tokens to be spent.
180      **/
181     function approve(address _spender, uint256 _value) public returns (bool) {
182         allowed[msg.sender][_spender] = _value;
183         emit Approval(msg.sender, _spender, _value);
184         return true;
185     }
186     
187     /**
188      * @dev Function to check the amount of tokens that an owner allowed to a spender.
189      * @param _owner address The address which owns the funds.
190      * @param _spender address The address which will spend the funds.
191      * @return A uint256 specifying the amount of tokens still available for the spender.
192      **/
193     function allowance(address _owner, address _spender) public view returns (uint256) {
194         return allowed[_owner][_spender];
195     }
196     
197     /**
198      * @dev Increase the amount of tokens that an owner allowed to a spender.
199      *
200      * approve should be called when allowed[_spender] == 0. To increment
201      * allowed value is better to use this function to avoid 2 calls (and wait until
202      * the first transaction is mined)
203      * From MonolithDAO Token.sol
204      * @param _spender The address which will spend the funds.
205      * @param _addedValue The amount of tokens to increase the allowance by.
206      **/
207     function increaseApproval(address _spender, uint _addedValue) public returns (bool) {
208         allowed[msg.sender][_spender] = allowed[msg.sender][_spender].add(_addedValue);
209         emit Approval(msg.sender, _spender, allowed[msg.sender][_spender]);
210         return true;
211     }
212     
213     /**
214      * @dev Decrease the amount of tokens that an owner allowed to a spender.
215      *
216      * approve should be called when allowed[_spender] == 0. To decrement
217      * allowed value is better to use this function to avoid 2 calls (and wait until
218      * the first transaction is mined)
219      * From MonolithDAO Token.sol
220      * @param _spender The address which will spend the funds.
221      * @param _subtractedValue The amount of tokens to decrease the allowance by.
222      **/
223     function decreaseApproval(address _spender, uint _subtractedValue) public returns (bool) {
224         uint oldValue = allowed[msg.sender][_spender];
225         if (_subtractedValue > oldValue) {
226             allowed[msg.sender][_spender] = 0;
227         } else {
228             allowed[msg.sender][_spender] = oldValue.sub(_subtractedValue);
229         }
230         emit Approval(msg.sender, _spender, allowed[msg.sender][_spender]);
231         return true;
232     }
233     
234     /**
235      * Destroy tokens
236      * Remove `_value` tokens from the system irreversibly
237      * @param _value the amount of money to burn
238      **/
239 
240     function burn(uint256 _value) public returns (bool success) {
241         require(balances[msg.sender] >= _value);   // Check if the sender has enough
242         balances[msg.sender] -= _value;            // Subtract from the sender
243         totalSupply_ -= _value;                      // Updates totalSupply
244         emit Burn(msg.sender, _value);
245         return true;
246     }
247 
248     /**
249      * Destroy tokens from other account
250      * Remove `_value` tokens from the system irreversibly on behalf of `_from`.
251      * @param _from the address of the sender
252      * @param _value the amount of money to burn
253      **/
254     function burnFrom(address _from, uint256 _value) public returns (bool success) {
255         require(balances[_from] >= _value);                
256         require(_value <= allowed[_from][msg.sender]);    
257         balances[_from] -= _value;                         
258         allowed[_from][msg.sender] -= _value;             
259         totalSupply_ -= _value;                              
260         emit Burn(_from, _value);
261         return true;
262     }
263 }
264 
265 
266 /**
267  * @title Configurable
268  * @dev Configurable varriables of the contract
269  **/
270 contract Configurable {
271     uint256 public constant cap = 4800000000*10**18;
272     uint256 public constant basePrice = 10000*10**18; // tokens per 1 ether
273     uint256 public tokensSold = 0;
274     
275     uint256 public constant tokenReserve = 7200000000*10**18;
276     uint256 public remainingTokens = 0;
277 }
278 
279 /**
280  * @title CrowdsaleToken 
281  * @dev Contract to preform crowd sale with token
282  **/
283 contract CrowdsaleToken is StandardToken, Configurable, Ownable {
284     /**
285      * @dev enum of current crowd sale state
286      **/
287      enum Stages {
288         none,
289         icoStart, 
290         icoEnd
291     }
292     
293     Stages currentStage;
294   
295     /**
296      * @dev constructor of CrowdsaleToken
297      **/
298     constructor() public {
299         currentStage = Stages.none;
300         balances[owner] = balances[owner].add(tokenReserve);
301         totalSupply_ = totalSupply_.add(tokenReserve);
302         remainingTokens = cap;
303         emit Transfer(address(this), owner, tokenReserve);
304     }
305     
306     /**
307      * @dev fallback function to send ether to for Crowd sale
308      **/
309     function () public payable {
310         require(currentStage == Stages.icoStart);
311         require(msg.value > 0);
312         require(remainingTokens > 0);
313         
314         
315         uint256 weiAmount = msg.value; // Calculate tokens to sell
316         uint256 tokens = weiAmount.mul(basePrice).div(1 ether);
317         uint256 returnWei = 0;
318         
319         if(tokensSold.add(tokens) > cap){
320             uint256 newTokens = cap.sub(tokensSold);
321             uint256 newWei = newTokens.div(basePrice).mul(1 ether);
322             returnWei = weiAmount.sub(newWei);
323             weiAmount = newWei;
324             tokens = newTokens;
325         }
326         
327         tokensSold = tokensSold.add(tokens); // Increment raised amount
328         remainingTokens = cap.sub(tokensSold);
329         if(returnWei > 0){
330             msg.sender.transfer(returnWei);
331             emit Transfer(address(this), msg.sender, returnWei);
332         }
333         
334         balances[msg.sender] = balances[msg.sender].add(tokens);
335         emit Transfer(address(this), msg.sender, tokens);
336         totalSupply_ = totalSupply_.add(tokens);
337         owner.transfer(weiAmount);// Send money to owner
338     }
339     
340 
341     /**
342      * @dev startIco starts the public ICO
343      **/
344     function startIco() public onlyOwner {
345         require(currentStage != Stages.icoEnd);
346         currentStage = Stages.icoStart;
347     }
348     
349 
350     /**
351      * @dev endIco closes down the ICO 
352      **/
353     function endIco() internal {
354         currentStage = Stages.icoEnd;
355         // Transfer any remaining tokens
356         if(remainingTokens > 0)
357             balances[owner] = balances[owner].add(remainingTokens);
358         // transfer any remaining ETH balance in the contract to the owner
359         owner.transfer(address(this).balance); 
360     }
361 
362     /**
363      * @dev finalizeIco closes down the ICO and sets needed varriables
364      **/
365     function finalizeIco() public onlyOwner {
366         require(currentStage != Stages.icoEnd);
367         endIco();
368     }
369     
370 }
371 
372 /**
373  * @title MGC 
374  * @dev Contract to create the Token
375  **/
376 contract MGCToken is CrowdsaleToken {
377     string public constant name = "Mango Coin";
378     string public constant symbol = "MGC";
379     uint32 public constant decimals = 18;
380 }