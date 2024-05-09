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
56     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
57 
58 /**
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
147 contract StandardToken is ERC20, BasicToken {
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
230 }
231 
232 /**
233  * @title Configurable
234  * @dev Configurable varriables of the contract
235  **/
236 contract Configurable {
237     uint256 public constant cap = 1000000*10**18;
238     uint256 public constant basePrice = 100*10**18; // tokens per 1 ether
239     uint256 public tokensSold = 0;
240     
241     uint256 public constant tokenReserve = 1000000*10**18;
242     uint256 public remainingTokens = 0;
243 }
244 
245 /**
246  * @title CrowdsaleToken 
247  * @dev Contract to preform crowd sale with token
248  **/
249 contract CrowdsaleToken is StandardToken, Configurable, Ownable {
250     /**
251      * @dev enum of current crowd sale state
252      **/
253      enum Stages {
254         none,
255         icoStart, 
256         icoEnd
257     }
258     
259     Stages currentStage;
260   
261     /**
262      * @dev constructor of CrowdsaleToken
263      **/
264     constructor() public {
265         currentStage = Stages.none;
266         balances[owner] = balances[owner].add(tokenReserve);
267         totalSupply_ = totalSupply_.add(tokenReserve);
268         remainingTokens = cap;
269         emit Transfer(address(this), owner, tokenReserve);
270     }
271     
272     /**
273      * @dev fallback function to send ether to for Crowd sale
274      **/
275     function () public payable {
276         require(currentStage == Stages.icoStart);
277         require(msg.value > 0);
278         require(remainingTokens > 0);
279         
280         
281         uint256 weiAmount = msg.value; // Calculate tokens to sell
282         uint256 tokens = weiAmount.mul(basePrice).div(1 ether);
283         uint256 returnWei = 0;
284         
285         if(tokensSold.add(tokens) > cap){
286             uint256 newTokens = cap.sub(tokensSold);
287             uint256 newWei = newTokens.div(basePrice).mul(1 ether);
288             returnWei = weiAmount.sub(newWei);
289             weiAmount = newWei;
290             tokens = newTokens;
291         }
292         
293         tokensSold = tokensSold.add(tokens); // Increment raised amount
294         remainingTokens = cap.sub(tokensSold);
295         if(returnWei > 0){
296             msg.sender.transfer(returnWei);
297             emit Transfer(address(this), msg.sender, returnWei);
298         }
299         
300         balances[msg.sender] = balances[msg.sender].add(tokens);
301         emit Transfer(address(this), msg.sender, tokens);
302         totalSupply_ = totalSupply_.add(tokens);
303         owner.transfer(weiAmount);// Send money to owner
304     }
305 
306 /**
307      * @dev startIco starts the public ICO
308      **/
309     function startIco() public onlyOwner {
310         require(currentStage != Stages.icoEnd);
311         currentStage = Stages.icoStart;
312     }
313 
314 /**
315      * @dev endIco closes down the ICO 
316      **/
317     function endIco() internal {
318         currentStage = Stages.icoEnd;
319         // Transfer any remaining tokens
320         if(remainingTokens > 0)
321             balances[owner] = balances[owner].add(remainingTokens);
322         // transfer any remaining ETH balance in the contract to the owner
323         owner.transfer(address(this).balance); 
324     }
325 
326 /**
327      * @dev finalizeIco closes down the ICO and sets needed varriables
328      **/
329     function finalizeIco() public onlyOwner {
330         require(currentStage != Stages.icoEnd);
331         endIco();
332     }
333     
334 }
335 
336 /**
337  * @title Bala7aCoin 
338  * @dev Contract to create the Kimera Token
339  **/
340 contract Bala7aCoin is CrowdsaleToken {
341     string public constant name = "Bala7aCoin";
342     string public constant symbol = "BL7";
343     uint32 public constant decimals = 18;
344 }