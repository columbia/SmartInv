1 pragma solidity ^0.4.24;
2 
3 
4 /**
5  * @title ERC20 interface
6  * @dev see https://github.com/ethereum/EIPs/issues/20
7  */
8 contract ERC20 {
9     function totalSupply() public view returns (uint256);
10 
11     function balanceOf(address _who) public view returns (uint256);
12 
13     function allowance(address _owner, address _spender)
14         public view returns (uint256);
15 
16     function transfer(address _to, uint256 _value) public returns (bool);
17 
18     function approve(address _spender, uint256 _value)
19         public returns (bool);
20 
21     function transferFrom(address _from, address _to, uint256 _value)
22         public returns (bool);
23 
24     event Transfer(
25         address indexed from,
26         address indexed to,
27         uint256 value
28     );
29 
30     event Approval(
31         address indexed owner,
32         address indexed spender,
33         uint256 value
34     );
35 }
36 
37 
38 /**
39  * @title SafeMath
40  * @dev Math operations with safety checks that revert on error
41  */
42 library SafeMath {
43 
44     /**
45     * @dev Multiplies two numbers, reverts on overflow.
46     */
47     function mul(uint256 _a, uint256 _b) internal pure returns (uint256) {
48         // Gas optimization: this is cheaper than requiring 'a' not being zero, but the
49         // benefit is lost if 'b' is also tested.
50         // See: https://github.com/OpenZeppelin/openzeppelin-solidity/pull/522
51         if (_a == 0) {
52             return 0;
53         }
54 
55         uint256 c = _a * _b;
56         require(c / _a == _b);
57 
58         return c;
59     }
60 
61     /**
62     * @dev Integer division of two numbers truncating the quotient, reverts on division by zero.
63     */
64     function div(uint256 _a, uint256 _b) internal pure returns (uint256) {
65         require(_b > 0); // Solidity only automatically asserts when dividing by 0
66         uint256 c = _a / _b;
67         // assert(_a == _b * c + _a % _b); // There is no case in which this doesn't hold
68 
69         return c;
70     }
71 
72     /**
73     * @dev Subtracts two numbers, reverts on overflow (i.e. if subtrahend is greater than minuend).
74     */
75     function sub(uint256 _a, uint256 _b) internal pure returns (uint256) {
76         require(_b <= _a);
77         uint256 c = _a - _b;
78 
79         return c;
80     }
81 
82     /**
83     * @dev Adds two numbers, reverts on overflow.
84     */
85     function add(uint256 _a, uint256 _b) internal pure returns (uint256) {
86         uint256 c = _a + _b;
87         require(c >= _a);
88 
89         return c;
90     }
91 }
92 
93 /**
94  * @title Ownable
95  * @dev The Ownable contract has an owner address, and provides basic authorization control
96  * functions, this simplifies the implementation of "user permissions".
97  */
98 contract Ownable {
99     address public owner;
100 
101     event OwnershipTransferred(
102         address indexed previousOwner,
103         address indexed newOwner
104     );
105 
106 
107     /**
108     * @dev The Ownable constructor sets the original `owner` of the contract to the sender
109     * account.
110     */
111     constructor() public {
112         owner = msg.sender;
113     }
114 
115     /**
116     * @dev Throws if called by any account other than the owner.
117     */
118     modifier onlyOwner() {
119         require(msg.sender == owner);
120         _;
121     }
122 
123     /**
124     * @dev Allows the current owner to transfer control of the contract to a newOwner.
125     * @param _newOwner The address to transfer ownership to.
126     */
127     function transferOwnership(address _newOwner) public onlyOwner {
128         _transferOwnership(_newOwner);
129     }
130 
131     /**
132     * @dev Transfers control of the contract to a newOwner.
133     * @param _newOwner The address to transfer ownership to.
134     */
135     function _transferOwnership(address _newOwner) internal {
136         require(_newOwner != address(0));
137         emit OwnershipTransferred(owner, _newOwner);
138         owner = _newOwner;
139     }
140 }
141 
142 /**
143  * @title Pausable
144  * @dev Base contract which allows children to implement an emergency stop mechanism.
145  */
146 contract Pausable is Ownable {
147     event Pause();
148     event Unpause();
149 
150     bool public paused = false;
151 
152     /**
153     * @dev Modifier to make a function callable only when the contract is not paused.
154     */
155     modifier whenNotPaused() {
156         require(!paused);
157         _;
158     }
159 
160     /**
161     * @dev Modifier to make a function callable only when the contract is paused.
162     */
163     modifier whenPaused() {
164         require(paused);
165         _;
166     }
167 
168     /**
169     * @dev called by the owner to pause, triggers stopped state
170     */
171     function pause() public onlyOwner whenNotPaused {
172         paused = true;
173         emit Pause();
174     }
175 
176     /**
177     * @dev called by the owner to unpause, returns to normal state
178     */
179     function unpause() public onlyOwner whenPaused {
180         paused = false;
181         emit Unpause();
182     }
183 }
184 
185 
186 /**
187  * @title Standard ERC20 token
188  *
189  * @dev Implementation of the basic standard token.
190  * https://github.com/ethereum/EIPs/issues/20
191  * Based on code by FirstBlood: https://github.com/Firstbloodio/token/blob/master/smart_contract/FirstBloodToken.sol
192  */
193 contract StandardToken is ERC20,Pausable {
194     using SafeMath for uint256;
195 
196     mapping(address => uint256) balances;
197 
198     mapping (address => mapping (address => uint256)) internal allowed;
199 
200     uint256 totalSupply_;
201 
202     /**
203     * @dev Total number of tokens in existence
204     */
205     function totalSupply() public view returns (uint256) {
206         return totalSupply_;
207     }
208 
209     /**
210     * @dev Gets the balance of the specified address.
211     * @param _owner The address to query the the balance of.
212     * @return An uint256 representing the amount owned by the passed address.
213     */
214     function balanceOf(address _owner) public view returns (uint256) {
215         return balances[_owner];
216     }
217 
218     /**
219     * @dev Function to check the amount of tokens that an owner allowed to a spender.
220     * @param _owner address The address which owns the funds.
221     * @param _spender address The address which will spend the funds.
222     * @return A uint256 specifying the amount of tokens still available for the spender.
223     */
224     function allowance(
225         address _owner,
226         address _spender
227     )
228         public
229         view
230         returns (uint256)
231     {
232         return allowed[_owner][_spender];
233     }
234 
235     /**
236     * @dev Transfer token for a specified address
237     * @param _to The address to transfer to.
238     * @param _value The amount to be transferred.
239     */
240     function transfer(address _to, uint256 _value) whenNotPaused public returns (bool) {
241         require(_value <= balances[msg.sender]);
242         require(_to != address(0));
243 
244         balances[msg.sender] = balances[msg.sender].sub(_value);
245         balances[_to] = balances[_to].add(_value);
246         emit Transfer(msg.sender, _to, _value);
247         return true;
248     }
249 
250     /**
251     * @dev Transfer tokens from one address to another
252     * @param _from address The address which you want to send tokens from
253     * @param _to address The address which you want to transfer to
254     * @param _value uint256 the amount of tokens to be transferred
255     */
256     function transferFrom(
257         address _from,
258         address _to,
259         uint256 _value
260     )   
261         whenNotPaused
262         public
263         returns (bool)
264     {
265         require(_value <= balances[_from]);
266         require(_value <= allowed[_from][msg.sender]);
267         require(_to != address(0));
268 
269         balances[_from] = balances[_from].sub(_value);
270         balances[_to] = balances[_to].add(_value);
271         allowed[_from][msg.sender] = allowed[_from][msg.sender].sub(_value);
272         emit Transfer(_from, _to, _value);
273         return true;
274     }
275 
276     /**
277     * @dev Approve the passed address to spend the specified amount of tokens on behalf of msg.sender.
278     * Beware that changing an allowance with this method brings the risk that someone may use both the old
279     * and the new allowance by unfortunate transaction ordering. One possible solution to mitigate this
280     * race condition is to first reduce the spender's allowance to 0 and set the desired value afterwards:
281     * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
282     * @param _spender The address which will spend the funds.
283     * @param _value The amount of tokens to be spent.
284     */
285     function approve(address _spender, uint256 _value) whenNotPaused public returns (bool) {
286         require(_value == 0 || (allowed[msg.sender][_spender] == 0));
287         
288         allowed[msg.sender][_spender] = _value;
289         emit Approval(msg.sender, _spender, _value);
290         return true;
291     }
292 
293     /**
294     * @dev Increase the amount of tokens that an owner allowed to a spender.
295     * approve should be called when allowed[_spender] == 0. To increment
296     * allowed value is better to use this function to avoid 2 calls (and wait until
297     * the first transaction is mined)
298     * From MonolithDAO Token.sol
299     * @param _spender The address which will spend the funds.
300     * @param _addedValue The amount of tokens to increase the allowance by.
301     */
302     function increaseApproval(
303         address _spender,
304         uint256 _addedValue
305     )   
306         whenNotPaused
307         public
308         returns (bool)
309     {
310         allowed[msg.sender][_spender] = (
311         allowed[msg.sender][_spender].add(_addedValue));
312         emit Approval(msg.sender, _spender, allowed[msg.sender][_spender]);
313         return true;
314     }
315 
316     /**
317     * @dev Decrease the amount of tokens that an owner allowed to a spender.
318     * approve should be called when allowed[_spender] == 0. To decrement
319     * allowed value is better to use this function to avoid 2 calls (and wait until
320     * the first transaction is mined)
321     * From MonolithDAO Token.sol
322     * @param _spender The address which will spend the funds.
323     * @param _subtractedValue The amount of tokens to decrease the allowance by.
324     */
325     function decreaseApproval(
326         address _spender,
327         uint256 _subtractedValue
328     )
329         whenNotPaused
330         public
331         returns (bool)
332     {
333         uint256 oldValue = allowed[msg.sender][_spender];
334         if (_subtractedValue >= oldValue) {
335             allowed[msg.sender][_spender] = 0;
336         } else {
337             allowed[msg.sender][_spender] = oldValue.sub(_subtractedValue);
338         }
339         emit Approval(msg.sender, _spender, allowed[msg.sender][_spender]);
340         return true;
341     }
342 }
343 
344 /**
345  * @title Burnable Token
346  * @dev Token that can be irreversibly burned (destroyed).
347  */
348 contract BurnableToken is StandardToken {
349 
350     event Burn(address indexed burner, uint256 value);
351 
352     /**
353     * @dev Burns a specific amount of tokens.
354     * @param _value The amount of token to be burned.
355     */
356     function burn(uint256 _value) public {
357         _burn(msg.sender, _value);
358     }
359 
360     /**
361     * @dev Burns a specific amount of tokens from the target address and decrements allowance
362     * @param _from address The address which you want to send tokens from
363     * @param _value uint256 The amount of token to be burned
364     */
365     function burnFrom(address _from, uint256 _value) public {
366         require(_value <= allowed[_from][msg.sender]);
367         // Should https://github.com/OpenZeppelin/zeppelin-solidity/issues/707 be accepted,
368         // this function needs to emit an event with the updated approval.
369         allowed[_from][msg.sender] = allowed[_from][msg.sender].sub(_value);
370         _burn(_from, _value);
371     }
372 
373     function _burn(address _who, uint256 _value) internal {
374         require(_value <= balances[_who]);
375         // no need to require value <= totalSupply, since that would imply the
376         // sender's balance is greater than the totalSupply, which *should* be an assertion failure
377 
378         balances[_who] = balances[_who].sub(_value);
379         totalSupply_ = totalSupply_.sub(_value);
380         emit Burn(_who, _value);
381         emit Transfer(_who, address(0), _value);
382     }
383 }
384 
385 contract HBC is BurnableToken {
386     // If ether is sent to this address, send it back.
387     function () public {
388         revert();
389     }
390 
391     string public constant name = "HBTC Chain";
392     string public constant symbol = "HBC";
393     uint8 public constant decimals = 18;
394     uint256 public constant INITIAL_SUPPLY = 21000000;
395     
396     /**
397     * @dev Constructor that gives msg.sender all of existing tokens.
398     */
399     constructor() public {
400         totalSupply_ = INITIAL_SUPPLY * (10 ** uint256(decimals));
401         balances[msg.sender] = totalSupply_;
402         emit Transfer(address(0), msg.sender, totalSupply_);
403     }
404 }