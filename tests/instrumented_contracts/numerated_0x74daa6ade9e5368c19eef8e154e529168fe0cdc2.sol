1 pragma solidity ^0.4.23;
2 /**
3  * @title Sajulmala Token Project
4  * @dev credit to Coinmonks at medium
5  */
6 /**
7  * @title SafeMath
8  * @dev Math operations with safety checks that throw on error
9  */
10 library SafeMath {
11     /**
12      * @dev Multiplies two numbers, throws on overflow.
13      **/
14     function mul(uint256 a, uint256 b) internal pure returns (uint256 c) {
15         if (a == 0) {
16             return 0;
17         }
18         c = a * b;
19         assert(c / a == b);
20         return c;
21     }
22     
23     /**
24      * @dev Integer division of two numbers, truncating the quotient.
25      **/
26     function div(uint256 a, uint256 b) internal pure returns (uint256) {
27         // assert(b > 0); // Solidity automatically throws when dividing by 0
28         // uint256 c = a / b;
29         // assert(a == b * c + a % b); // There is no case in which this doesn't hold
30         return a / b;
31     }
32     
33     /**
34      * @dev Subtracts two numbers, throws on overflow (i.e. if subtrahend is greater than minuend).
35      **/
36     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
37         assert(b <= a);
38         return a - b;
39     }
40     
41     /**
42      * @dev Adds two numbers, throws on overflow.
43      **/
44     function add(uint256 a, uint256 b) internal pure returns (uint256 c) {
45         c = a + b;
46         assert(c >= a);
47         return c;
48     }
49 }
50 /**
51  * @title Ownable
52  * @dev The Ownable contract has an owner address, and provides basic authorization control
53  * functions, this simplifies the implementation of "user permissions".
54  **/
55  
56 contract Ownable {
57     address public owner;
58     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
59 /**
60      * @dev The Ownable constructor sets the original `owner` of the contract to the sender account.
61      **/
62    constructor() public {
63       owner = msg.sender;
64     }
65     
66     /**
67      * @dev Throws if called by any account other than the owner.
68      **/
69     modifier onlyOwner() {
70       require(msg.sender == owner);
71       _;
72     }
73     
74     /**
75      * @dev Allows the current owner to transfer control of the contract to a newOwner.
76      * @param newOwner The address to transfer ownership to.
77      **/
78     function transferOwnership(address newOwner) public onlyOwner {
79       require(newOwner != address(0));
80       emit OwnershipTransferred(owner, newOwner);
81       owner = newOwner;
82     }
83 }
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
94 /**
95  * @title ERC20 interface
96  * @dev see https://github.com/ethereum/EIPs/issues/20
97  **/
98 contract ERC20 is ERC20Basic {
99     function allowance(address owner, address spender) public view returns (uint256);
100     function transferFrom(address from, address to, uint256 value) public returns (bool);
101     function approve(address spender, uint256 value) public returns (bool);
102     event Approval(address indexed owner, address indexed spender, uint256 value);
103 }
104 /**
105  * @title Basic token
106  * @dev Basic version of StandardToken, with no allowances.
107  **/
108 contract BasicToken is ERC20Basic {
109     using SafeMath for uint256;
110     mapping(address => uint256) balances;
111     uint256 totalSupply_;
112     
113     /**
114      * @dev total number of tokens in existence
115      **/
116     function totalSupply() public view returns (uint256) {
117         return totalSupply_;
118     }
119     
120     /**
121      * @dev transfer token for a specified address
122      * @param _to The address to transfer to.
123      * @param _value The amount to be transferred.
124      **/
125     function transfer(address _to, uint256 _value) public returns (bool) {
126         require(_to != address(0));
127         require(_value <= balances[msg.sender]);
128         
129         balances[msg.sender] = balances[msg.sender].sub(_value);
130         balances[_to] = balances[_to].add(_value);
131         emit Transfer(msg.sender, _to, _value);
132         return true;
133     }
134     
135     /**
136      * @dev Gets the balance of the specified address.
137      * @param _owner The address to query the the balance of.
138      * @return An uint256 representing the amount owned by the passed address.
139      **/
140     function balanceOf(address _owner) public view returns (uint256) {
141         return balances[_owner];
142     }
143 }
144 contract StandardToken is ERC20, BasicToken {
145     mapping (address => mapping (address => uint256)) internal allowed;
146     /**
147      * @dev Transfer tokens from one address to another
148      * @param _from address The address which you want to send tokens from
149      * @param _to address The address which you want to transfer to
150      * @param _value uint256 the amount of tokens to be transferred
151      **/
152     function transferFrom(address _from, address _to, uint256 _value) public returns (bool) {
153         require(_to != address(0));
154         require(_value <= balances[_from]);
155         require(_value <= allowed[_from][msg.sender]);
156     
157         balances[_from] = balances[_from].sub(_value);
158         balances[_to] = balances[_to].add(_value);
159         allowed[_from][msg.sender] = allowed[_from][msg.sender].sub(_value);
160         
161         emit Transfer(_from, _to, _value);
162         return true;
163     }
164     
165     /**
166      * @dev Approve the passed address to spend the specified amount of tokens on behalf of msg.sender.
167      *
168      * Beware that changing an allowance with this method brings the risk that someone may use both the old
169      * and the new allowance by unfortunate transaction ordering. One possible solution to mitigate this
170      * race condition is to first reduce the spender's allowance to 0 and set the desired value afterwards:
171      * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
172      * @param _spender The address which will spend the funds.
173      * @param _value The amount of tokens to be spent.
174      **/
175     function approve(address _spender, uint256 _value) public returns (bool) {
176         allowed[msg.sender][_spender] = _value;
177         emit Approval(msg.sender, _spender, _value);
178         return true;
179     }
180     
181     /**
182      * @dev Function to check the amount of tokens that an owner allowed to a spender.
183      * @param _owner address The address which owns the funds.
184      * @param _spender address The address which will spend the funds.
185      * @return A uint256 specifying the amount of tokens still available for the spender.
186      **/
187     function allowance(address _owner, address _spender) public view returns (uint256) {
188         return allowed[_owner][_spender];
189     }
190     
191     /**
192      * @dev Increase the amount of tokens that an owner allowed to a spender.
193      *
194      * approve should be called when allowed[_spender] == 0. To increment
195      * allowed value is better to use this function to avoid 2 calls (and wait until
196      * the first transaction is mined)
197      * From MonolithDAO Token.sol
198      * @param _spender The address which will spend the funds.
199      * @param _addedValue The amount of tokens to increase the allowance by.
200      **/
201     function increaseApproval(address _spender, uint _addedValue) public returns (bool) {
202         allowed[msg.sender][_spender] = allowed[msg.sender][_spender].add(_addedValue);
203         emit Approval(msg.sender, _spender, allowed[msg.sender][_spender]);
204         return true;
205     }
206     
207     /**
208      * @dev Decrease the amount of tokens that an owner allowed to a spender.
209      *
210      * approve should be called when allowed[_spender] == 0. To decrement
211      * allowed value is better to use this function to avoid 2 calls (and wait until
212      * the first transaction is mined)
213      * From MonolithDAO Token.sol
214      * @param _spender The address which will spend the funds.
215      * @param _subtractedValue The amount of tokens to decrease the allowance by.
216      **/
217     function decreaseApproval(address _spender, uint _subtractedValue) public returns (bool) {
218         uint oldValue = allowed[msg.sender][_spender];
219         if (_subtractedValue > oldValue) {
220             allowed[msg.sender][_spender] = 0;
221         } else {
222             allowed[msg.sender][_spender] = oldValue.sub(_subtractedValue);
223         }
224         emit Approval(msg.sender, _spender, allowed[msg.sender][_spender]);
225         return true;
226     }
227 }
228 /**
229  * @title Configurable
230  * @dev Configurable varriables of the contract
231  **/
232 contract Configurable {
233     uint256 public constant cap = 5000000000*10**18;
234     uint256 public constant basePrice = 50000000*10**18; // tokens per 1 ether
235     uint256 public tokensSold = 0;
236     
237     uint256 public constant tokenReserve = 1000000000*10**18;
238     uint256 public remainingTokens = 0;
239     uint256 public minContribute = 0.02 ether; // Minimum investment allowed
240 }
241 /**
242  * @title CrowdsaleToken 
243  * @dev Contract to preform crowd sale with token
244  **/
245 contract CrowdsaleToken is StandardToken, Configurable, Ownable {
246     /**
247      * @dev enum of current crowd sale state
248      **/
249      enum Stages {
250         none,
251         icoStart, 
252         icoEnd
253     }
254     
255     Stages currentStage;
256   
257     /**
258      * @dev constructor of CrowdsaleToken
259      **/
260     constructor() public {
261         currentStage = Stages.none;
262         balances[owner] = balances[owner].add(tokenReserve);
263         totalSupply_ = totalSupply_.add(tokenReserve);
264         remainingTokens = cap;
265         emit Transfer(address(this), owner, tokenReserve);
266     }
267     
268     /**
269      * @dev fallback function to send ether to for Crowd sale
270      **/
271     function () public payable {
272         require(currentStage == Stages.icoStart);
273         require(msg.value > 0);
274         require(remainingTokens > 0);
275         
276         
277         uint256 weiAmount = msg.value; // Calculate tokens to sell
278         uint256 tokens = weiAmount.mul(basePrice).div(1 ether);
279         uint256 returnWei = 0;
280         
281         if(tokensSold.add(tokens) > cap){
282             uint256 newTokens = cap.sub(tokensSold);
283             uint256 newWei = newTokens.div(basePrice).mul(1 ether);
284             returnWei = weiAmount.sub(newWei);
285             weiAmount = newWei;
286             tokens = newTokens;
287         }
288         
289         tokensSold = tokensSold.add(tokens); // Increment raised amount
290         remainingTokens = cap.sub(tokensSold);
291         if(returnWei > 0){
292             msg.sender.transfer(returnWei);
293             emit Transfer(address(this), msg.sender, returnWei);
294         }
295         
296         balances[msg.sender] = balances[msg.sender].add(tokens);
297         emit Transfer(address(this), msg.sender, tokens);
298         totalSupply_ = totalSupply_.add(tokens);
299         owner.transfer(weiAmount);// Send money to owner
300     }
301 /**
302      * @dev startIco starts the public ICO
303      **/
304     function startIco() public onlyOwner {
305         require(currentStage != Stages.icoEnd);
306         currentStage = Stages.icoStart;
307     }
308 /**
309      * @dev endIco closes down the ICO 
310      **/
311     function endIco() internal {
312         currentStage = Stages.icoEnd;
313         // Transfer any remaining tokens
314         if(remainingTokens > 0)
315             balances[owner] = balances[owner].add(remainingTokens);
316         // transfer any remaining ETH balance in the contract to the owner
317         owner.transfer(address(this).balance); 
318     }
319 /**
320      * @dev finalizeIco closes down the ICO and sets needed varriables
321      **/
322     function finalizeIco() public onlyOwner {
323         require(currentStage != Stages.icoEnd);
324         endIco();
325     }
326     
327 }
328 /**
329  * @title SajulmalaToken 
330  * @dev Contract to create the Sajul Ma'la Token
331  **/
332 contract SajulmalaToken is CrowdsaleToken {
333     string public constant name = "Sajul Ma'la Token";
334     string public constant symbol = "SJML";
335     uint32 public constant decimals = 18;
336 }