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
61     constructor() public {
62       owner = msg.sender;
63     }
64     
65     /**
66      * @dev Throws if called by any account other than the owner.
67      **/
68     modifier onlyOwner {
69       require(msg.sender == owner);
70       _;
71     }
72     
73     /**
74      * @dev Allows the current owner to transfer control of the contract to a newOwner.
75      * @param newOwner The address to transfer ownership to.
76      **/
77     function transferOwnership(address newOwner) public onlyOwner {
78       require(msg.sender == owner);
79       require(newOwner != address(0));
80       emit OwnershipTransferred(owner, newOwner);
81       owner = newOwner;
82     }
83 }
84 
85 /**
86  * @title ERC20Basic interface
87  * @dev Basic ERC20 interface
88  **/
89 contract ERC20Basic {
90     function totalSupply() public view returns (uint256);
91     function balanceOf(address who) public view returns (uint256);
92     function transfer(address to, uint256 value) public returns (bool);
93     event Transfer(address indexed from, address indexed to, uint256 value);
94 }
95 
96 /**
97  * @title ERC20 interface
98  * @dev see https://github.com/ethereum/EIPs/issues/20
99  **/
100 contract ERC20 is ERC20Basic {
101     function allowance(address owner, address spender) public view returns (uint256);
102     function transferFrom(address from, address to, uint256 value) public returns (bool);
103     function approve(address spender, uint256 value) public returns (bool);
104     event Approval(address indexed owner, address indexed spender, uint256 value);
105 }
106 
107 /**
108  * @title Basic token
109  * @dev Basic version of StandardToken, with no allowances.
110  **/
111 contract BasicToken is ERC20Basic {
112     using SafeMath for uint256;
113     mapping(address => uint256) balances;
114     uint256 totalSupply_;
115     
116     /**
117      * @dev total number of tokens in existence
118      **/
119     function totalSupply() public view returns (uint256) {
120         return totalSupply_;
121     }
122     
123     /**
124      * @dev transfer token for a specified address
125      * @param _to The address to transfer to.
126      * @param _value The amount to be transferred.
127      **/
128     function transfer(address _to, uint256 _value) public returns (bool) {
129         require(_to != address(0));
130         require(_value <= balances[msg.sender]);
131         
132         balances[msg.sender] = balances[msg.sender].sub(_value);
133         balances[_to] = balances[_to].add(_value);
134         emit Transfer(msg.sender, _to, _value);
135         return true;
136     }
137     
138     /**
139      * @dev Gets the balance of the specified address.
140      * @param _owner The address to query the the balance of.
141      * @return An uint256 representing the amount owned by the passed address.
142      **/
143     function balanceOf(address _owner) public view returns (uint256) {
144         return balances[_owner];
145     }
146 }
147 
148 contract StandardToken is ERC20, BasicToken {
149     mapping (address => mapping (address => uint256)) internal allowed;
150     /**
151      * @dev Transfer tokens from one address to another
152      * @param _from address The address which you want to send tokens from
153      * @param _to address The address which you want to transfer to
154      * @param _value uint256 the amount of tokens to be transferred
155      **/
156     function transferFrom(address _from, address _to, uint256 _value) public returns (bool) {
157         require(_to != address(0));
158         require(_value <= balances[_from]);
159         require(_value <= allowed[_from][msg.sender]);
160     
161         balances[_from] = balances[_from].sub(_value);
162         balances[_to] = balances[_to].add(_value);
163         allowed[_from][msg.sender] = allowed[_from][msg.sender].sub(_value);
164         
165         emit Transfer(_from, _to, _value);
166         return true;
167     }
168     
169     /**
170      * @dev Approve the passed address to spend the specified amount of tokens on behalf of msg.sender.
171      *
172      * Beware that changing an allowance with this method brings the risk that someone may use both the old
173      * and the new allowance by unfortunate transaction ordering. One possible solution to mitigate this
174      * race condition is to first reduce the spender's allowance to 0 and set the desired value afterwards:
175      * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
176      * @param _spender The address which will spend the funds.
177      * @param _value The amount of tokens to be spent.
178      **/
179     function approve(address _spender, uint256 _value) public returns (bool) {
180         allowed[msg.sender][_spender] = _value;
181         emit Approval(msg.sender, _spender, _value);
182         return true;
183     }
184     
185     /**
186      * @dev Function to check the amount of tokens that an owner allowed to a spender.
187      * @param _owner address The address which owns the funds.
188      * @param _spender address The address which will spend the funds.
189      * @return A uint256 specifying the amount of tokens still available for the spender.
190      **/
191     function allowance(address _owner, address _spender) public view returns (uint256) {
192         return allowed[_owner][_spender];
193     }
194     
195     /**
196      * @dev Increase the amount of tokens that an owner allowed to a spender.
197      *
198      * approve should be called when allowed[_spender] == 0. To increment
199      * allowed value is better to use this function to avoid 2 calls (and wait until
200      * the first transaction is mined)
201      * From MonolithDAO Token.sol
202      * @param _spender The address which will spend the funds.
203      * @param _addedValue The amount of tokens to increase the allowance by.
204      **/
205     function increaseApproval(address _spender, uint _addedValue) public returns (bool) {
206         allowed[msg.sender][_spender] = allowed[msg.sender][_spender].add(_addedValue);
207         emit Approval(msg.sender, _spender, allowed[msg.sender][_spender]);
208         return true;
209     }
210     
211     /**
212      * @dev Decrease the amount of tokens that an owner allowed to a spender.
213      *
214      * approve should be called when allowed[_spender] == 0. To decrement
215      * allowed value is better to use this function to avoid 2 calls (and wait until
216      * the first transaction is mined)
217      * From MonolithDAO Token.sol
218      * @param _spender The address which will spend the funds.
219      * @param _subtractedValue The amount of tokens to decrease the allowance by.
220      **/
221     function decreaseApproval(address _spender, uint _subtractedValue) public returns (bool) {
222         uint oldValue = allowed[msg.sender][_spender];
223         if (_subtractedValue > oldValue) {
224             allowed[msg.sender][_spender] = 0;
225         } else {
226             allowed[msg.sender][_spender] = oldValue.sub(_subtractedValue);
227         }
228         emit Approval(msg.sender, _spender, allowed[msg.sender][_spender]);
229         return true;
230     }
231 }
232 
233 
234 /**
235  * @title Configurable
236  * @dev Configurable varriables of the contract
237  **/
238 contract Configurable {
239     uint256 public constant cap = 1000000*10**18;
240     uint256 public constant basePrice = 100*10**18; // tokens per 1 ether
241     uint256 public tokensSold = 0;
242     
243     uint256 public constant tokenReserve = 1000000*10**18;
244     uint256 public remainingTokens = 0;
245 }
246 
247 /**
248  * @title CrowdsaleToken 
249  * @dev Contract to preform crowd sale with token
250  **/
251 contract CrowdsaleToken is StandardToken, Configurable, Ownable {
252     /**
253      * @dev enum of current crowd sale state
254      **/
255      enum Stages {
256         none,
257         icoStart, 
258         icoEnd
259     }
260     
261     Stages currentStage;
262   
263     /**
264      * @dev constructor of CrowdsaleToken
265      **/
266     constructor() public {
267         currentStage = Stages.none;
268         balances[owner] = balances[owner].add(tokenReserve);
269         totalSupply_ = totalSupply_.add(tokenReserve);
270         remainingTokens = cap;
271         emit Transfer(address(this), owner, tokenReserve);
272     }
273     
274     /**
275      * @dev fallback function to send ether to for Crowd sale
276      **/
277     function () public payable {
278         require(currentStage == Stages.icoStart);
279         require(msg.value > 0);
280         require(remainingTokens > 0);
281         
282         
283         uint256 weiAmount = msg.value; // Calculate tokens to sell
284         uint256 tokens = weiAmount.mul(basePrice).div(1 ether);
285         uint256 returnWei = 0;
286         
287         if(tokensSold.add(tokens) > cap){
288             uint256 newTokens = cap.sub(tokensSold);
289             uint256 newWei = newTokens.div(basePrice).mul(1 ether);
290             returnWei = weiAmount.sub(newWei);
291             weiAmount = newWei;
292             tokens = newTokens;
293         }
294         
295         tokensSold = tokensSold.add(tokens); // Increment raised amount
296         remainingTokens = cap.sub(tokensSold);
297         if(returnWei > 0){
298             msg.sender.transfer(returnWei);
299             emit Transfer(address(this), msg.sender, returnWei);
300         }
301         
302         balances[msg.sender] = balances[msg.sender].add(tokens);
303         emit Transfer(address(this), msg.sender, tokens);
304         totalSupply_ = totalSupply_.add(tokens);
305         owner.transfer(weiAmount);// Send money to owner
306     }
307     
308 
309     /**
310      * @dev startIco starts the public ICO
311      **/
312     function startIco() public onlyOwner {
313         require(currentStage != Stages.icoEnd);
314         currentStage = Stages.icoStart;
315     }
316     
317 
318     /**
319      * @dev endIco closes down the ICO 
320      **/
321     function endIco() internal {
322         currentStage = Stages.icoEnd;
323         // Transfer any remaining tokens
324         if(remainingTokens > 0)
325             balances[owner] = balances[owner].add(remainingTokens);
326         // transfer any remaining ETH balance in the contract to the owner
327         owner.transfer(address(this).balance); 
328     }
329 
330     /**
331      * @dev finalizeIco closes down the ICO and sets needed varriables
332      **/
333     function finalizeIco() public onlyOwner {
334         require(currentStage != Stages.icoEnd);
335         endIco();
336     }
337     
338 }
339 
340 /**
341  * @title GooglierToken 
342  * @dev Contract to create the Lavevel Token
343  **/
344 contract GooglierToken is CrowdsaleToken {
345     string public constant name = "Googlier";
346     string public constant symbol = "googlier";
347     uint32 public constant decimals = 18;
348 }