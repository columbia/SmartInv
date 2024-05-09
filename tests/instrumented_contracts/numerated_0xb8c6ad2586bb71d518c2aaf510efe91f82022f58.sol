1 pragma solidity ^0.5.7;
2 
3 
4 /**
5  * @title ERC20 interface
6  * @dev see https://github.com/ethereum/EIPs/issues/20
7  */
8 contract ERC20 {
9     function totalSupply() public view returns (uint256);
10     function balanceOf(address _who) public view returns (uint256);
11     function allowance(address _owner, address _spender) public view returns (uint256);
12     function transfer(address _to, uint256 _value) public returns (bool);
13     function approve(address _spender, uint256 _value) public returns (bool);
14     function transferFrom(address _from, address _to, uint256 _value) public returns (bool);
15 
16     event Transfer(address indexed from, address indexed to, uint256 value);
17     event Approval(address indexed owner, address indexed spender, uint256 value);
18 }
19 
20 
21 /**
22  * @title SafeMath
23  * @dev Math operations with safety checks that revert on error
24  */
25 library SafeMath {
26     /**
27     * @dev Multiplies two numbers, reverts on overflow.
28     */
29     function mul(uint256 _a, uint256 _b) internal pure returns (uint256) {
30         uint256 c = _a * _b;
31         require(_a == 0 || c / _a == _b);
32 
33         return c;
34     }
35 
36     /**
37     * @dev Integer division of two numbers truncating the quotient, reverts on division by zero.
38     */
39     function div(uint256 _a, uint256 _b) internal pure returns (uint256) {
40         uint256 c = _a / _b;
41         return c;
42     }
43 
44     /**
45     * @dev Subtracts two numbers, reverts on overflow (i.e. if subtrahend is greater than minuend).
46     */
47     function sub(uint256 _a, uint256 _b) internal pure returns (uint256) {
48         require(_b <= _a);
49         uint256 c = _a - _b;
50 
51         return c;
52     }
53 
54     /**
55     * @dev Adds two numbers, reverts on overflow.
56     */
57     function add(uint256 _a, uint256 _b) internal pure returns (uint256) {
58         uint256 c = _a + _b;
59         require(c >= _a);
60 
61         return c;
62     }
63 }
64 
65 
66 /**
67  * @title Ownable
68  * @dev The Ownable contract has an owner address, and provides basic authorization control
69  * functions, this simplifies the implementation of "user permissions".
70  */
71 contract Ownable {
72     address public owner;
73 
74     event OwnershipRenounced(address indexed previousOwner);
75     event OwnershipTransferred(address indexed previousOwner,address indexed newOwner);
76 
77     /**
78     * @dev The Ownable constructor sets the original `owner` of the contract to the sender
79     * account.
80     */
81     constructor() public {
82         owner = msg.sender;
83     }
84 
85     /**
86     * @dev Throws if called by any account other than the owner.
87     */
88     modifier onlyOwner() {
89         require(msg.sender == owner);
90         _;
91     }
92 
93     /**
94     * @dev Allows the current owner to relinquish control of the contract.
95     * @notice Renouncing to ownership will leave the contract without an owner.
96     * It will not be possible to call the functions with the `onlyOwner`
97     * modifier anymore.
98     */
99     function renounceOwnership() public onlyOwner {
100         emit OwnershipRenounced(owner);
101         owner = address(0);
102     }
103 
104     /**
105     * @dev Allows the current owner to transfer control of the contract to a newOwner.
106     * @param _newOwner The address to transfer ownership to.
107     */
108     function transferOwnership(address _newOwner) public onlyOwner {
109 		require(_newOwner != address(0), "New owner cannot be address(0)");
110 		emit OwnershipTransferred(owner, _newOwner);
111         owner = _newOwner;
112     }
113 }
114 
115 /**
116  * @title Administator
117  * @dev  This contract has a group of administrators who can add/remove any account to/from blacklist. 
118 */
119 contract Administrator is Ownable {
120     mapping (address=>bool) public admin;
121     
122     // Current number of members of the administrator group
123     uint    public   adminLength;   
124     // The maximum number of members of the administrator group, which is specified in the constructor
125     uint    public   adminMaxLength;      
126     
127     event   AddAdmin(address indexed _address);
128     event   RemoveAdmin(address indexed _address);
129     
130     constructor (uint _len) public {        
131         adminMaxLength = _len;
132     }
133     
134     modifier isAdmin(address _addr) {
135         require(admin[_addr], "Not administrator");
136         _;
137     }
138     
139     modifier isNotAdmin(address _addr) {
140         require(!admin[_addr], "Is administrator");
141         _;        
142     }
143     
144     /**
145      * @dev Modifier: Limit that only the contract owner or administrator can execute the function
146     */
147 	modifier onlyOwnerOrAdmin() {
148 		require(msg.sender == owner || admin[msg.sender], "msg.sender is nether owner nor administator");
149 		_;
150 	}
151     
152     /**
153      * @dev Add a member to the Administrators group
154     */
155     function addAdmin(address _addr) onlyOwner isNotAdmin(_addr) public returns (bool) {
156         require(_addr != address(0), "Administrator cannot be address(0)");
157         require(_addr != owner, "Administrator cannot be owner");
158         require(adminLength < adminMaxLength, "Exceeded the maximum number of administrators");
159         
160         admin[_addr] = true;
161         adminLength++; 
162         
163         emit AddAdmin(_addr);
164         return true;
165     } 
166     
167     /**
168      * @dev Remove a member from the Administrators group
169     */
170     function removeAdmin(address _addr) onlyOwner isAdmin(_addr) public returns (bool) {
171         delete admin[_addr];
172         adminLength--;
173         
174         emit RemoveAdmin(_addr);
175         return true;
176     }
177 }
178 
179 /**
180 * @title Blacklisted
181 * @dev allow contract owner or administator to add/remove address to/from the blacklist
182 */
183 contract Blacklisted is Administrator {
184 	mapping (address => bool) public blacklist;
185 
186 	event SetBlacklist(address indexed _address, bool _bool);
187 
188 	/**
189 	* @dev Modifier: throw if _address is in the blacklist
190 	*/
191 	modifier notInBlacklist(address _address) {
192 		require(!blacklist[_address], "Is in Blacklist");
193 		_;
194 	}
195 
196 	/**
197 	* @dev call by the owner, set/unset single _address into the blacklist
198 	*/
199 	function setBlacklist(address _address, bool _bool) public onlyOwnerOrAdmin {
200 		require(_address != address(0));
201 		
202 		if(_bool) {
203 		    require(!blacklist[_address], "Already in blacklist");
204 		} else {
205 		    require(blacklist[_address], "Not in blacklist yet");
206 		}
207 		
208 		blacklist[_address] = _bool;
209 		emit SetBlacklist(_address, _bool);
210 	}
211 }
212 
213 /**
214  * @title Pausable
215  * @dev Base contract which allows children to implement an emergency stop mechanism.
216  */
217 contract Pausable is Ownable {
218     event Pause();
219     event Unpause();
220 
221     bool public paused = false;
222 
223     /**
224     * @dev Modifier to make a function callable only when the contract is not paused.
225     */
226     modifier whenNotPaused() {
227         require(!paused);
228         _;
229     }
230 
231     /**
232     * @dev Modifier to make a function callable only when the contract is paused.
233     */
234     modifier whenPaused() {
235         require(paused);
236         _;
237     }
238 
239     /**
240     * @dev called by the owner to pause, triggers stopped state
241     */
242     function pause() public onlyOwner whenNotPaused {
243         paused = true;
244         emit Pause();
245     }
246 
247     /**
248     * @dev called by the owner to unpause, returns to normal state
249     */
250     function unpause() public onlyOwner whenPaused {
251         paused = false;
252         emit Unpause();
253     }
254 }
255 
256 
257 /**
258  * @title Standard ERC20 token
259  *
260  * @dev Implementation of the basic standard token.
261  * https://github.com/ethereum/EIPs/issues/20
262  */
263 contract StandardToken is ERC20, Pausable, Blacklisted {
264     using SafeMath for uint256;
265 
266     mapping(address => uint256) balances;
267 
268     mapping (address => mapping (address => uint256)) internal allowed;
269 
270     uint256 totalSupply_;
271 
272     /**
273     * @dev Total number of tokens in existence
274     */
275     function totalSupply() public view returns (uint256) {
276         return totalSupply_;
277     }
278 
279     /**
280     * @dev Gets the balance of the specified address.
281     * @param _owner The address to query the the balance of.
282     * @return An uint256 representing the amount owned by the passed address.
283     */
284     function balanceOf(address _owner) public view returns (uint256) {
285         return balances[_owner];
286     }
287 
288     /**
289     * @dev Function to check the amount of tokens that an owner allowed to a spender.
290     * @param _owner address The address which owns the funds.
291     * @param _spender address The address which will spend the funds.
292     * @return A uint256 specifying the amount of tokens still available for the spender.
293     */
294     function allowance(address _owner, address _spender) public view returns (uint256) {
295         return allowed[_owner][_spender];
296     }
297 
298     /**
299     * @dev Transfer token for a specified address
300     * @param _to The address to transfer to.
301     * @param _value The amount to be transferred.
302     */
303     function transfer(address _to, uint256 _value) whenNotPaused notInBlacklist(msg.sender) notInBlacklist(_to) public returns (bool) {
304         require(_to != address(0));
305 
306         balances[msg.sender] = balances[msg.sender].sub(_value);
307         balances[_to] = balances[_to].add(_value);
308 
309         emit Transfer(msg.sender, _to, _value);
310         return true;
311     }
312 
313 
314     /**
315     * @dev Transfer tokens from one address to another
316     * @param _from address The address which you want to send tokens from
317     * @param _to address The address which you want to transfer to
318     * @param _value uint256 the amount of tokens to be transferred
319     */
320     function transferFrom(address _from, address _to, uint256 _value) whenNotPaused notInBlacklist(msg.sender) notInBlacklist(_from) notInBlacklist(_to) public returns (bool) {
321         require(_to != address(0));
322 
323         balances[_from] = balances[_from].sub(_value);
324         balances[_to] = balances[_to].add(_value);
325         allowed[_from][msg.sender] = allowed[_from][msg.sender].sub(_value);
326 
327         emit Transfer(_from, _to, _value);
328         return true;
329     }
330 
331 
332     /**
333     * @dev Approve the passed address to spend the specified amount of tokens on behalf of msg.sender.
334     * @param _spender The address which will spend the funds.
335     * @param _value The amount of tokens to be spent.
336     */
337     function approve(address _spender, uint256 _value) whenNotPaused public returns (bool) {
338 		require(_value == 0 || allowed[msg.sender][_spender] == 0 );
339         allowed[msg.sender][_spender] = _value;
340 
341         emit Approval(msg.sender, _spender, _value);
342         return true;
343     }
344 
345 
346     /**
347     * @dev Increase the amount of tokens that an owner allowed to a spender.
348     * approve should be called when allowed[_spender] == 0. To increment
349     * allowed value is better to use this function to avoid 2 calls (and wait until
350     * the first transaction is mined)
351     * @param _spender The address which will spend the funds.
352     * @param _addedValue The amount of tokens to increase the allowance by.
353     */
354     function increaseApproval(address _spender, uint256 _addedValue) whenNotPaused public returns (bool) {
355         allowed[msg.sender][_spender] = (allowed[msg.sender][_spender].add(_addedValue));
356 
357         emit Approval(msg.sender, _spender, allowed[msg.sender][_spender]);
358         return true;
359     }
360 
361     /**
362     * @dev Decrease the amount of tokens that an owner allowed to a spender.
363     * approve should be called when allowed[_spender] == 0. To decrement
364     * allowed value is better to use this function to avoid 2 calls (and wait until
365     * the first transaction is mined)
366     * @param _spender The address which will spend the funds.
367     * @param _subtractedValue The amount of tokens to decrease the allowance by.
368     */
369     function decreaseApproval(address _spender, uint256 _subtractedValue) whenNotPaused public returns (bool) {
370         uint256 oldValue = allowed[msg.sender][_spender];
371         if (_subtractedValue >= oldValue) {
372             allowed[msg.sender][_spender] = 0;
373         } else {
374             allowed[msg.sender][_spender] = oldValue.sub(_subtractedValue);
375         }
376 
377         emit Approval(msg.sender, _spender, allowed[msg.sender][_spender]);
378         return true;
379     }
380 }
381 
382 
383 
384 /**
385 * @title GomicsToken
386 * @dev	GomicsToken main contract 
387 */
388 contract GomicsToken is StandardToken {
389     string public constant name = "Gomics";
390     string public constant symbol = "GOM";
391     uint8 public constant decimals = 18;
392     uint256 public constant INITIAL_SUPPLY = 75000000;
393     
394     constructor() Administrator(3) public {
395         totalSupply_ = INITIAL_SUPPLY * (10 ** uint256(decimals));
396         balances[msg.sender] = totalSupply_;
397         emit Transfer(address(0), msg.sender, totalSupply_);
398     }
399 }