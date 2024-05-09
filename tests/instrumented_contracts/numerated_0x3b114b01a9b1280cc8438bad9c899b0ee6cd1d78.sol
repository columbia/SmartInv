1 pragma solidity ^0.4.23;
2 /**
3  * @title SafeMath
4  * @dev Math operations with safety checks that throw on error
5  */
6 library SafeMath {
7     /**
8      * @dev Multiplies two numbers, throws on overflow.
9      **/
10     function mul(uint256 a, uint256 b) internal pure returns (uint256 c) {
11         if (a == 0) {
12             return 0;
13         }
14         c = a * b;
15         assert(c / a == b);
16         return c;
17     }
18     
19     /**
20      * @dev Integer division of two numbers, truncating the quotient.
21      **/
22     function div(uint256 a, uint256 b) internal pure returns (uint256) {
23         // assert(b > 0); // Solidity automatically throws when dividing by 0
24         // uint256 c = a / b;
25         // assert(a == b * c + a % b); // There is no case in which this doesn't hold
26         return a / b;
27     }
28     
29     /**
30      * @dev Subtracts two numbers, throws on overflow (i.e. if subtrahend is greater than minuend).
31      **/
32     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
33         assert(b <= a);
34         return a - b;
35     }
36     
37     /**
38      * @dev Adds two numbers, throws on overflow.
39      **/
40     function add(uint256 a, uint256 b) internal pure returns (uint256 c) {
41         c = a + b;
42         assert(c >= a);
43         return c;
44     }
45 }
46 /**
47  * @title Ownable
48  * @dev The Ownable contract has an owner address, and provides basic authorization control
49  * functions, this simplifies the implementation of "user permissions".
50  **/
51  
52 contract Ownable {
53     address public owner;
54     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
55 /**
56      * @dev The Ownable constructor sets the original `owner` of the contract to the sender account.
57      **/
58    constructor() public {
59       owner = msg.sender;
60     }
61     
62     /**
63      * @dev Throws if called by any account other than the owner.
64      **/
65     modifier onlyOwner() {
66       require(msg.sender == owner);
67       _;
68     }
69     
70     /**
71      * @dev Allows the current owner to transfer control of the contract to a newOwner.
72      * @param newOwner The address to transfer ownership to.
73      **/
74     function transferOwnership(address newOwner) public onlyOwner {
75       require(newOwner != address(0));
76       emit OwnershipTransferred(owner, newOwner);
77       owner = newOwner;
78     }
79 }
80 /**
81  * @title ERC20Basic interface
82  * @dev Basic ERC20 interface
83  **/
84 contract ERC20Basic {
85     function totalSupply() public view returns (uint256);
86     function balanceOf(address who) public view returns (uint256);
87     function transfer(address to, uint256 value) public returns (bool);
88     event Transfer(address indexed from, address indexed to, uint256 value);
89 }
90 /**
91  * @title ERC20 interface
92  **/
93 contract ERC20 is ERC20Basic {
94     function allowance(address owner, address spender) public view returns (uint256);
95     function transferFrom(address from, address to, uint256 value) public returns (bool);
96     function approve(address spender, uint256 value) public returns (bool);
97     event Approval(address indexed owner, address indexed spender, uint256 value);
98 }
99 /**
100  * @title Basic token
101  * @dev Basic version of StandardToken, with no allowances.
102  **/
103 contract BasicToken is ERC20Basic {
104     using SafeMath for uint256;
105     mapping(address => uint256) balances;
106     uint256 totalSupply_;
107     
108     /**
109      * @dev total number of tokens in existence
110      **/
111     function totalSupply() public view returns (uint256) {
112         return totalSupply_;
113     }
114     
115     /**
116      * @dev transfer token for a specified address
117      * @param _to The address to transfer to.
118      * @param _value The amount to be transferred.
119      **/
120     function transfer(address _to, uint256 _value) public returns (bool) {
121         require(_to != address(0));
122         require(_value <= balances[msg.sender]);
123         
124         balances[msg.sender] = balances[msg.sender].sub(_value);
125         balances[_to] = balances[_to].add(_value);
126         emit Transfer(msg.sender, _to, _value);
127         return true;
128     }
129     
130     /**
131      * @dev Gets the balance of the specified address.
132      * @param _owner The address to query the the balance of.
133      * @return An uint256 representing the amount owned by the passed address.
134      **/
135     function balanceOf(address _owner) public view returns (uint256) {
136         return balances[_owner];
137     }
138 }
139 contract StandardToken is ERC20, BasicToken {
140     mapping (address => mapping (address => uint256)) internal allowed;
141     /**
142      * @dev Transfer tokens from one address to another
143      * @param _from address The address which you want to send tokens from
144      * @param _to address The address which you want to transfer to
145      * @param _value uint256 the amount of tokens to be transferred
146      **/
147     function transferFrom(address _from, address _to, uint256 _value) public returns (bool) {
148         require(_to != address(0));
149         require(_value <= balances[_from]);
150         require(_value <= allowed[_from][msg.sender]);
151     
152         balances[_from] = balances[_from].sub(_value);
153         balances[_to] = balances[_to].add(_value);
154         allowed[_from][msg.sender] = allowed[_from][msg.sender].sub(_value);
155         
156         emit Transfer(_from, _to, _value);
157         return true;
158     }
159     
160     /**
161      * @dev Approve the passed address to spend the specified amount of tokens on behalf of msg.sender.
162      *
163      * Beware that changing an allowance with this method brings the risk that someone may use both the old
164      * and the new allowance by unfortunate transaction ordering. One possible solution to mitigate this
165      * race condition is to first reduce the spender's allowance to 0 and set the desired value afterwards:
166      * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
167      * @param _spender The address which will spend the funds.
168      * @param _value The amount of tokens to be spent.
169      **/
170     function approve(address _spender, uint256 _value) public returns (bool) {
171         allowed[msg.sender][_spender] = _value;
172         emit Approval(msg.sender, _spender, _value);
173         return true;
174     }
175     
176     /**
177      * @dev Function to check the amount of tokens that an owner allowed to a spender.
178      * @param _owner address The address which owns the funds.
179      * @param _spender address The address which will spend the funds.
180      * @return A uint256 specifying the amount of tokens still available for the spender.
181      **/
182     function allowance(address _owner, address _spender) public view returns (uint256) {
183         return allowed[_owner][_spender];
184     }
185     
186     /**
187      * @dev Increase the amount of tokens that an owner allowed to a spender.
188      *
189      * approve should be called when allowed[_spender] == 0. To increment
190      * allowed value is better to use this function to avoid 2 calls (and wait until
191      * the first transaction is mined)
192      * From MonolithDAO Token.sol
193      * @param _spender The address which will spend the funds.
194      * @param _addedValue The amount of tokens to increase the allowance by.
195      **/
196     function increaseApproval(address _spender, uint _addedValue) public returns (bool) {
197         allowed[msg.sender][_spender] = allowed[msg.sender][_spender].add(_addedValue);
198         emit Approval(msg.sender, _spender, allowed[msg.sender][_spender]);
199         return true;
200     }
201     
202     /**
203      * @dev Decrease the amount of tokens that an owner allowed to a spender.
204      *
205      * approve should be called when allowed[_spender] == 0. To decrement
206      * allowed value is better to use this function to avoid 2 calls (and wait until
207      * the first transaction is mined)
208      * From MonolithDAO Token.sol
209      * @param _spender The address which will spend the funds.
210      * @param _subtractedValue The amount of tokens to decrease the allowance by.
211      **/
212     function decreaseApproval(address _spender, uint _subtractedValue) public returns (bool) {
213         uint oldValue = allowed[msg.sender][_spender];
214         if (_subtractedValue > oldValue) {
215             allowed[msg.sender][_spender] = 0;
216         } else {
217             allowed[msg.sender][_spender] = oldValue.sub(_subtractedValue);
218         }
219         emit Approval(msg.sender, _spender, allowed[msg.sender][_spender]);
220         return true;
221     }
222 }
223 /**
224  * @title Configurable
225  * @dev Configurable varriables of the contract
226  **/
227 contract Configurable {
228     uint256 public constant cap = 1500000000*10**18;
229     uint256 public constant basePrice = 78000*10**18; // tokens per 1 ether
230     uint256 public tokensSold = 0;
231     
232     uint256 public constant tokenReserve = 1500000000*10**18;
233     uint256 public remainingTokens = 0;
234 }
235 /**
236  * @title CrowdsaleToken 
237  * @dev Contract to preform crowd sale with token
238  **/
239 contract CrowdsaleToken is StandardToken, Configurable, Ownable {
240     /**
241      * @dev enum of current crowd sale state
242      **/
243      enum Stages {
244         none,
245         icoStart, 
246         icoEnd
247     }
248     
249     Stages currentStage;
250   
251     /**
252      * @dev constructor of CrowdsaleToken
253      **/
254     constructor() public {
255         currentStage = Stages.none;
256         balances[owner] = balances[owner].add(tokenReserve);
257         totalSupply_ = totalSupply_.add(tokenReserve);
258         remainingTokens = cap;
259         emit Transfer(address(this), owner, tokenReserve);
260     }
261     
262     /**
263      * @dev fallback function to send ether to for Crowd sale
264      **/
265     function () public payable {
266         require(currentStage == Stages.icoStart);
267         require(msg.value > 0);
268         require(remainingTokens > 0);
269         
270         
271         uint256 weiAmount = msg.value; // Calculate tokens to sell
272         uint256 tokens = weiAmount.mul(basePrice).div(1 ether);
273         uint256 returnWei = 0;
274         
275         if(tokensSold.add(tokens) > cap){
276             uint256 newTokens = cap.sub(tokensSold);
277             uint256 newWei = newTokens.div(basePrice).mul(1 ether);
278             returnWei = weiAmount.sub(newWei);
279             weiAmount = newWei;
280             tokens = newTokens;
281         }
282         
283         tokensSold = tokensSold.add(tokens); // Increment raised amount
284         remainingTokens = cap.sub(tokensSold);
285         if(returnWei > 0){
286             msg.sender.transfer(returnWei);
287             emit Transfer(address(this), msg.sender, returnWei);
288         }
289         
290         balances[msg.sender] = balances[msg.sender].add(tokens);
291         emit Transfer(address(this), msg.sender, tokens);
292         totalSupply_ = totalSupply_.add(tokens);
293         owner.transfer(weiAmount);// Send money to owner
294     }
295 /**
296      * @dev startIco starts the public ICO
297      **/
298     function startIco() public onlyOwner {
299         require(currentStage != Stages.icoEnd);
300         currentStage = Stages.icoStart;
301     }
302 /**
303      * @dev endIco closes down the ICO 
304      **/
305     function endIco() internal {
306         currentStage = Stages.icoEnd;
307         // Transfer any remaining tokens
308         if(remainingTokens > 0)
309             balances[owner] = balances[owner].add(remainingTokens);
310         // transfer any remaining ETH balance in the contract to the owner
311         owner.transfer(address(this).balance); 
312     }
313 /**
314      * @dev finalizeIco closes down the ICO and sets needed varriables
315      **/
316     function finalizeIco() public onlyOwner {
317         require(currentStage != Stages.icoEnd);
318         endIco();
319     }
320     
321 }
322 /**
323  * @title BitpascalToken 
324  **/
325 contract BitpascalToken is CrowdsaleToken {
326     string public constant name = "Bitpascal";
327     string public constant symbol = "BPC";
328     uint32 public constant decimals = 18;
329 }