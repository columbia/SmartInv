1 pragma solidity ^0.5.1;
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
53     address payable owner;
54     event OwnershipTransferred(address indexed previousOwner, address payable indexed newOwner);
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
74     function transferOwnership(address payable newOwner) public onlyOwner {
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
92  * @dev see https://github.com/ethereum/EIPs/issues/20
93  **/
94 contract ERC20 is ERC20Basic {
95     function allowance(address owner, address spender) public view returns (uint256);
96     function transferFrom(address from, address to, uint256 value) public returns (bool);
97     function approve(address spender, uint256 value) public returns (bool);
98     event Approval(address indexed owner, address indexed spender, uint256 value);
99 }
100 /**
101  * @title Basic token
102  * @dev Basic version of StandardToken, with no allowances.
103  **/
104 contract BasicToken is ERC20Basic {
105     using SafeMath for uint256;
106     mapping(address => uint256) balances;
107     uint256 totalSupply_;
108     
109     /**
110      * @dev total number of tokens in existence
111      **/
112     function totalSupply() public view returns (uint256) {
113         return totalSupply_;
114     }
115     
116     /**
117      * @dev transfer token for a specified address
118      * @param _to The address to transfer to.
119      * @param _value The amount to be transferred.
120      **/
121     function transfer(address _to, uint256 _value) public returns (bool) {
122         require(_to != address(0));
123         require(_value <= balances[msg.sender]);
124         
125         balances[msg.sender] = balances[msg.sender].sub(_value);
126         balances[_to] = balances[_to].add(_value);
127         emit Transfer(msg.sender, _to, _value);
128         return true;
129     }
130     
131     /**
132      * @dev Gets the balance of the specified address.
133      * @param _owner The address to query the the balance of.
134      * @return An uint256 representing the amount owned by the passed address.
135      **/
136     function balanceOf(address _owner) public view returns (uint256) {
137         return balances[_owner];
138     }
139 }
140 contract StandardToken is ERC20, BasicToken {
141     mapping (address => mapping (address => uint256)) internal allowed;
142     /**
143      * @dev Transfer tokens from one address to another
144      * @param _from address The address which you want to send tokens from
145      * @param _to address The address which you want to transfer to
146      * @param _value uint256 the amount of tokens to be transferred
147      **/
148     function transferFrom(address _from, address _to, uint256 _value) public returns (bool) {
149         require(_to != address(0));
150         require(_value <= balances[_from]);
151         require(_value <= allowed[_from][msg.sender]);
152     
153         balances[_from] = balances[_from].sub(_value);
154         balances[_to] = balances[_to].add(_value);
155         allowed[_from][msg.sender] = allowed[_from][msg.sender].sub(_value);
156         
157         emit Transfer(_from, _to, _value);
158         return true;
159     }
160     
161     /**
162      * @dev Approve the passed address to spend the specified amount of tokens on behalf of msg.sender.
163      *
164      * Beware that changing an allowance with this method brings the risk that someone may use both the old
165      * and the new allowance by unfortunate transaction ordering. One possible solution to mitigate this
166      * race condition is to first reduce the spender's allowance to 0 and set the desired value afterwards:
167      * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
168      * @param _spender The address which will spend the funds.
169      * @param _value The amount of tokens to be spent.
170      **/
171     function approve(address _spender, uint256 _value) public returns (bool) {
172         allowed[msg.sender][_spender] = _value;
173         emit Approval(msg.sender, _spender, _value);
174         return true;
175     }
176     
177     /**
178      * @dev Function to check the amount of tokens that an owner allowed to a spender.
179      * @param _owner address The address which owns the funds.
180      * @param _spender address The address which will spend the funds.
181      * @return A uint256 specifying the amount of tokens still available for the spender.
182      **/
183     function allowance(address _owner, address _spender) public view returns (uint256) {
184         return allowed[_owner][_spender];
185     }
186     
187     /**
188      * @dev Increase the amount of tokens that an owner allowed to a spender.
189      *
190      * approve should be called when allowed[_spender] == 0. To increment
191      * allowed value is better to use this function to avoid 2 calls (and wait until
192      * the first transaction is mined)
193      * From MonolithDAO Token.sol
194      * @param _spender The address which will spend the funds.
195      * @param _addedValue The amount of tokens to increase the allowance by.
196      **/
197     function increaseApproval(address _spender, uint _addedValue) public returns (bool) {
198         allowed[msg.sender][_spender] = allowed[msg.sender][_spender].add(_addedValue);
199         emit Approval(msg.sender, _spender, allowed[msg.sender][_spender]);
200         return true;
201     }
202     
203     /**
204      * @dev Decrease the amount of tokens that an owner allowed to a spender.
205      *
206      * approve should be called when allowed[_spender] == 0. To decrement
207      * allowed value is better to use this function to avoid 2 calls (and wait until
208      * the first transaction is mined)
209      * From MonolithDAO Token.sol
210      * @param _spender The address which will spend the funds.
211      * @param _subtractedValue The amount of tokens to decrease the allowance by.
212      **/
213     function decreaseApproval(address _spender, uint _subtractedValue) public returns (bool) {
214         uint oldValue = allowed[msg.sender][_spender];
215         if (_subtractedValue > oldValue) {
216             allowed[msg.sender][_spender] = 0;
217         } else {
218             allowed[msg.sender][_spender] = oldValue.sub(_subtractedValue);
219         }
220         emit Approval(msg.sender, _spender, allowed[msg.sender][_spender]);
221         return true;
222     }
223 }
224 /**
225  * @title Configurable
226  * @dev Configurable varriables of the contract
227  **/
228 contract Configurable {
229     uint256 public constant cap = 1000000;
230     uint256 public constant basePrice = 100*10**18; // tokens per 1 ether
231     uint256 public tokensSold = 0;
232     
233     uint256 public constant tokenReserve = 1000000*10**18;
234     uint256 public remainingTokens = 0;
235 }
236 /**
237  * @title CrowdsaleToken 
238  * @dev Contract to preform crowd sale with token
239  **/
240 contract CrowdsaleToken is StandardToken, Configurable, Ownable {
241     /**
242      * @dev enum of current crowd sale state
243      **/
244      enum Stages {
245         none,
246         icoStart, 
247         icoEnd
248     }
249     
250     Stages currentStage;
251   
252     /**
253      * @dev constructor of CrowdsaleToken
254      **/
255     constructor() public {
256         currentStage = Stages.none;
257         balances[owner] = balances[owner].add(tokenReserve);
258         totalSupply_ = totalSupply_.add(tokenReserve);
259         remainingTokens = cap;
260         emit Transfer(address(this), owner, tokenReserve);
261     }
262     
263     /**
264      * @dev fallback function to send ether to for Crowd sale
265      **/
266     function () external payable {
267         require(currentStage == Stages.icoStart);
268         require(msg.value > 0);
269         require(remainingTokens > 0);
270         
271         
272         uint256 weiAmount = msg.value; // Calculate tokens to sell
273         uint256 tokens = weiAmount.mul(basePrice).div(1 ether);
274         uint256 returnWei = 0;
275         
276         if(tokensSold.add(tokens) > cap){
277             uint256 newTokens = cap.sub(tokensSold);
278             uint256 newWei = newTokens.div(basePrice).mul(1 ether);
279             returnWei = weiAmount.sub(newWei);
280             weiAmount = newWei;
281             tokens = newTokens;
282         }
283         
284         tokensSold = tokensSold.add(tokens); // Increment raised amount
285         remainingTokens = cap.sub(tokensSold);
286         if(returnWei > 0){
287             msg.sender.transfer(returnWei);
288             emit Transfer(address(this), msg.sender, returnWei);
289         }
290         
291         balances[msg.sender] = balances[msg.sender].add(tokens);
292         emit Transfer(address(this), msg.sender, tokens);
293         totalSupply_ = totalSupply_.add(tokens);
294         owner.transfer(weiAmount);// Send money to owner
295     }
296 /**
297      * @dev startIco starts the public ICO
298      **/
299     function startIco() public onlyOwner {
300         require(currentStage != Stages.icoEnd);
301         currentStage = Stages.icoStart;
302     }
303 /**
304      * @dev endIco closes down the ICO 
305      **/
306     function endIco() internal {
307         currentStage = Stages.icoEnd;
308         // Transfer any remaining tokens
309         if(remainingTokens > 0)
310             balances[owner] = balances[owner].add(remainingTokens);
311         // transfer any remaining ETH balance in the contract to the owner
312         owner.transfer(address(this).balance); 
313     }
314 /**
315      * @dev finalizeIco closes down the ICO and sets needed varriables
316      **/
317     function finalizeIco() public onlyOwner {
318         require(currentStage != Stages.icoEnd);
319         endIco();
320     }
321     
322 }
323 /**
324  * @title LavevelToken 
325  * @dev Contract to create the Mangosteen Token
326  **/
327 contract Mangosteen is CrowdsaleToken {
328     string public constant name = "Mangosteen";
329     string public constant symbol = "MANG";
330     uint32 public constant decimals = 18;
331 }