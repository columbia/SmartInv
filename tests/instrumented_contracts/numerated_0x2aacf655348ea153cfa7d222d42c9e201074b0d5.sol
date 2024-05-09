1 // Copyright © 2018 Demba Joob - Sunu Nataal
2 // Author - Fodé Diop : github.com/diop
3 
4 pragma solidity ^0.4.24;
5 
6 /**
7  * @title SafeMath
8  * @dev Math operations with safety checks that throw on error
9  */
10 library SafeMath {
11 
12     /**
13     * @dev Multiplies two numbers, throws on overflow.
14     */
15     function mul(uint256 a, uint256 b) internal pure returns (uint256 c) {
16         if (a == 0) {
17             return 0;
18         }
19         c = a * b;
20         assert(c / a == b);
21         return c;
22     }
23 
24     /**
25     * @dev Integer division of two numbers, truncating the quotient.
26     */
27     function div(uint256 a, uint256 b) internal pure returns (uint256) {
28         // assert(b > 0); // Solidity automatically throws when dividing by 0
29         // uint256 c = a / b;
30         // assert(a == b * c + a % b); // There is no case in which this doesn't hold
31         return a / b;
32     }
33 
34     /**
35     * @dev Subtracts two numbers, throws on overflow (i.e. if subtrahend is greater than minuend).
36     */
37     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
38         assert(b <= a);
39         return a - b;
40     }
41 
42     /**
43     * @dev Adds two numbers, throws on overflow.
44     */
45     function add(uint256 a, uint256 b) internal pure returns (uint256 c) {
46         c = a + b;
47         assert(c >= a);
48         return c;
49     }
50 }
51 
52 /**
53  * @title Ownable
54  * @dev The Ownable contract has an owner address, and provides basic authorization control
55  * functions, this simplifies the implementation of "user permissions".
56  */
57 contract Ownable {
58     address public owner;
59 
60 
61     event OwnershipRenounced(address indexed previousOwner);
62     event OwnershipTransferred(
63         address indexed previousOwner,
64         address indexed newOwner
65     );
66 
67 
68     /**
69     * @dev The Ownable constructor sets the original `owner` of the contract to the sender
70     * account.
71     */
72     constructor() public {
73         owner = msg.sender;
74     }
75 
76     /**
77     * @dev Throws if called by any account other than the owner.
78     */
79     modifier onlyOwner() {
80         require(msg.sender == owner);
81         _;
82     }
83 
84     /**
85     * @dev Allows the current owner to transfer control of the contract to a newOwner.
86     * @param newOwner The address to transfer ownership to.
87     */
88     function transferOwnership(address newOwner) public onlyOwner {
89         require(newOwner != address(0));
90         emit OwnershipTransferred(owner, newOwner);
91         owner = newOwner;
92     }
93 
94     /**
95     * @dev Allows the current owner to relinquish control of the contract.
96     */
97     function renounceOwnership() public onlyOwner {
98         emit OwnershipRenounced(owner);
99         owner = address(0);
100     }
101 }
102 
103 /**
104  * @title ERC20Basic
105  * @dev Simpler version of ERC20 interface
106  * @dev see https://github.com/ethereum/EIPs/issues/179
107  */
108 contract ERC20Basic {
109     function totalSupply() public view returns (uint256);
110     function balanceOf(address who) public view returns (uint256);
111     function transfer(address to, uint256 value) public returns (bool);
112     event Transfer(address indexed from, address indexed to, uint256 value);
113 }
114 
115 /**
116  * @title ERC20 interface
117  * @dev see https://github.com/ethereum/EIPs/issues/20
118  */
119 contract ERC20 is ERC20Basic {
120     function allowance(address owner, address spender)
121         public view returns (uint256);
122 
123     function transferFrom(address from, address to, uint256 value)
124         public returns (bool);
125 
126     function approve(address spender, uint256 value) public returns (bool);
127     event Approval(
128         address indexed owner,
129         address indexed spender,
130         uint256 value
131     );
132 }
133 
134 /**
135  * @title Basic token
136  * @dev Basic version of StandardToken, with no allowances.
137  */
138 contract BasicToken is ERC20Basic {
139     using SafeMath for uint256;
140 
141     mapping(address => uint256) balances;
142 
143     uint256 totalSupply_;
144 
145     /**
146     * @dev total number of tokens in existence
147     */
148     function totalSupply() public view returns (uint256) {
149         return totalSupply_;
150     }
151 
152     /**
153     * @dev transfer token for a specified address
154     * @param _to The address to transfer to.
155     * @param _value The amount to be transferred.
156     */
157     function transfer(address _to, uint256 _value) public returns (bool) {
158         require(_to != address(0));
159         require(_value <= balances[msg.sender]);
160 
161         balances[msg.sender] = balances[msg.sender].sub(_value);
162         balances[_to] = balances[_to].add(_value);
163         emit Transfer(msg.sender, _to, _value);
164         return true;
165     }
166 
167     /**
168     * @dev Gets the balance of the specified address.
169     * @param _owner The address to query the the balance of.
170     * @return An uint256 representing the amount owned by the passed address.
171     */
172     function balanceOf(address _owner) public view returns (uint256) {
173         return balances[_owner];
174     }
175 
176 }
177 
178 /**
179  * @title SafeERC20
180  * @dev Wrappers around ERC20 operations that throw on failure.
181  * To use this library you can add a `using SafeERC20 for ERC20;` statement to your contract,
182  * which allows you to call the safe operations as `token.safeTransfer(...)`, etc.
183  */
184 library SafeERC20 {
185     function safeTransfer(ERC20Basic token, address to, uint256 value) internal {
186         require(token.transfer(to, value));
187     }
188 
189     function safeTransferFrom(
190         ERC20 token,
191         address from,
192         address to,
193         uint256 value
194     )
195         internal
196     {
197         require(token.transferFrom(from, to, value));
198     }
199 
200     function safeApprove(ERC20 token, address spender, uint256 value) internal {
201         require(token.approve(spender, value));
202     }
203 }
204 
205 /**
206  * @title Standard ERC20 token
207  *
208  * @dev Implementation of the basic standard token.
209  * @dev https://github.com/ethereum/EIPs/issues/20
210  * @dev Based on code by FirstBlood: https://github.com/Firstbloodio/token/blob/master/smart_contract/FirstBloodToken.sol
211  */
212 contract StandardToken is ERC20, BasicToken {
213 
214     mapping (address => mapping (address => uint256)) internal allowed;
215 
216 
217     /**
218     * @dev Transfer tokens from one address to another
219     * @param _from address The address which you want to send tokens from
220     * @param _to address The address which you want to transfer to
221     * @param _value uint256 the amount of tokens to be transferred
222     */
223     function transferFrom(
224         address _from,
225         address _to,
226         uint256 _value
227     )
228         public
229         returns (bool)
230     {
231         require(_to != address(0));
232         require(_value <= balances[_from]);
233         require(_value <= allowed[_from][msg.sender]);
234 
235         balances[_from] = balances[_from].sub(_value);
236         balances[_to] = balances[_to].add(_value);
237         allowed[_from][msg.sender] = allowed[_from][msg.sender].sub(_value);
238         emit Transfer(_from, _to, _value);
239         return true;
240     }
241 
242     /**
243     * @dev Approve the passed address to spend the specified amount of tokens on behalf of msg.sender.
244     *
245     * Beware that changing an allowance with this method brings the risk that someone may use both the old
246     * and the new allowance by unfortunate transaction ordering. One possible solution to mitigate this
247     * race condition is to first reduce the spender's allowance to 0 and set the desired value afterwards:
248     * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
249     * @param _spender The address which will spend the funds.
250     * @param _value The amount of tokens to be spent.
251     */
252     function approve(address _spender, uint256 _value) public returns (bool) {
253         allowed[msg.sender][_spender] = _value;
254         emit Approval(msg.sender, _spender, _value);
255         return true;
256     }
257 
258     /**
259     * @dev Function to check the amount of tokens that an owner allowed to a spender.
260     * @param _owner address The address which owns the funds.
261     * @param _spender address The address which will spend the funds.
262     * @return A uint256 specifying the amount of tokens still available for the spender.
263     */
264     function allowance(
265         address _owner,
266         address _spender
267     )
268         public
269         view
270         returns (uint256)
271     {
272         return allowed[_owner][_spender];
273     }
274 
275     /**
276     * @dev Increase the amount of tokens that an owner allowed to a spender.
277     *
278     * approve should be called when allowed[_spender] == 0. To increment
279     * allowed value is better to use this function to avoid 2 calls (and wait until
280     * the first transaction is mined)
281     * From MonolithDAO Token.sol
282     * @param _spender The address which will spend the funds.
283     * @param _addedValue The amount of tokens to increase the allowance by.
284     */
285     function increaseApproval(
286         address _spender,
287         uint _addedValue
288     )
289         public
290         returns (bool)
291     {
292         allowed[msg.sender][_spender] = (
293         allowed[msg.sender][_spender].add(_addedValue));
294         emit Approval(msg.sender, _spender, allowed[msg.sender][_spender]);
295         return true;
296     }
297 
298     /**
299     * @dev Decrease the amount of tokens that an owner allowed to a spender.
300     *
301     * approve should be called when allowed[_spender] == 0. To decrement
302     * allowed value is better to use this function to avoid 2 calls (and wait until
303     * the first transaction is mined)
304     * From MonolithDAO Token.sol
305     * @param _spender The address which will spend the funds.
306     * @param _subtractedValue The amount of tokens to decrease the allowance by.
307     */
308     function decreaseApproval(
309         address _spender,
310         uint _subtractedValue
311     )
312         public
313         returns (bool)
314     {
315         uint oldValue = allowed[msg.sender][_spender];
316         if (_subtractedValue > oldValue) {
317             allowed[msg.sender][_spender] = 0;
318         } else {
319             allowed[msg.sender][_spender] = oldValue.sub(_subtractedValue);
320         }
321         emit Approval(msg.sender, _spender, allowed[msg.sender][_spender]);
322         return true;
323     }
324 
325 }
326 
327 interface ERC20Interface {
328     function totalSupply() external view returns (uint256 _totalSupply);
329     function balanceOf(address _owner) external view returns (uint256 balance);
330     function transfer(address _to, uint256 _value) external view returns (bool success);
331     function transferFrom(address _from, address _to, uint256 _value) external view returns (bool success);
332     function approve(address _spender, uint256 _value) external view returns (bool success);
333     function allowance(address _owner, address _spender) external view returns (uint256 remaining);
334     event Transfer(address indexed _from, address indexed _to, uint256 _value);
335     event Approval(address indexed _owner, address indexed _spender, uint256 _value);
336 }
337 
338 interface tokenRecipient {
339   function receiveApproval(address from, uint256 value, address token, bytes extraData) external;
340 }
341 
342 contract NataalCoin is Ownable, StandardToken {
343     using SafeMath for uint256;
344 
345     string public constant name = "NataalCoin";
346     string public constant symbol = "NTL";
347     uint8 public constant decimals = 18;
348     uint256 public constant INITIAL_SUPPLY = 100000000 * 10**uint(decimals);
349 
350     mapping(address => uint256) balances;
351 
352     mapping(address => mapping (address => uint256)) allowed;
353 
354     uint internal totalSupply_;
355 
356     address public owner;
357 
358     mapping(address => uint256) public balanceOf;
359 
360     event Transfer(address indexed from, address indexed to, uint tokens);
361     event Approval(address indexed tokenOwner, address indexed spender, uint tokens);
362     event OwnershipTransferred(address indexed from, address indexed to);
363 
364     constructor() public {
365         balances[msg.sender] = INITIAL_SUPPLY;
366         totalSupply_ = INITIAL_SUPPLY;
367         owner = msg.sender;
368 
369         emit Transfer(0x0, owner, totalSupply_);
370     }
371 
372     function totalSupply() public view returns (uint256 _totalSupply) {
373         return totalSupply_;
374     }
375 
376     function balanceOf(address tokenOwner) public view returns (uint256 balance) {
377         return balances[tokenOwner];
378     }
379 
380     function allowance(address tokenOwner, address spender) public view returns (uint remaining) {
381         return allowed[tokenOwner][spender];
382     }
383 
384     function approve(address spender, uint tokens) public returns (bool success) {
385         allowed[msg.sender][spender] = tokens;
386         emit Approval(msg.sender, spender, tokens);
387         success = true;
388     }
389 
390     function transfer(address to, uint tokens) public returns (bool success) {
391         require(to != 0x0);
392         require(tokens <= balances[msg.sender]);
393 
394         balances[msg.sender] = balances[msg.sender].sub(tokens);
395         balances[to] = balances[to].add(tokens);
396         emit Transfer(msg.sender, to, tokens);
397         success = true;
398     }
399 
400     function transferFrom(address from, address to, uint tokens) public returns (bool success) {
401         require(to != 0x0);
402         require(tokens <= balances[from]);
403         require(tokens <= allowed[from][msg.sender]);
404 
405         balances[from] = balances[from].sub(tokens);
406         allowed[from][msg.sender] = allowed[from][msg.sender].sub(tokens);
407         balances[to] = balances[to].add(tokens);
408         emit Transfer(from, to, tokens);
409         success = true;
410     }
411 
412     function withdrawEther(uint256 tokens) public {
413         if(msg.sender != owner) revert();
414         owner.transfer(tokens);
415     }
416 
417     function () public payable {
418         // This contract is payable. Any Ether sent will be used to support the Sunu Nataal photographers and creators.
419     }
420 
421 }