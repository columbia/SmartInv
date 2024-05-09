1 pragma solidity ^0.5.0;
2 
3 
4 library SafeMath {
5 
6     uint256 constant internal MAX_UINT = 2 ** 256 - 1; // max uint256
7 
8     /**
9      * @dev Multiplies two numbers, reverts on overflow.
10      */
11     function mul(uint256 _a, uint256 _b) internal pure returns(uint256) {
12         if (_a == 0) {
13             return 0;
14         }
15         require(MAX_UINT / _a >= _b);
16         return _a * _b;
17     }
18 
19     /**
20      * @dev Integer division of two numbers truncating the quotient, reverts on division by zero.
21      */
22     function div(uint256 _a, uint256 _b) internal pure returns(uint256) {
23         require(_b != 0);
24         return _a / _b;
25     }
26 
27     /**
28      * @dev Subtracts two numbers, reverts on overflow (i.e. if subtrahend is greater than minuend).
29      */
30     function sub(uint256 _a, uint256 _b) internal pure returns(uint256) {
31         require(_b <= _a);
32         return _a - _b;
33     }
34 
35     /**
36      * @dev Adds two numbers, reverts on overflow.
37      */
38     function add(uint256 _a, uint256 _b) internal pure returns(uint256) {
39         require(MAX_UINT - _a >= _b);
40         return _a + _b;
41     }
42 
43 }
44 
45 
46 contract Ownable {
47     address public owner;
48 
49     event OwnershipTransferred(
50         address indexed previousOwner,
51         address indexed newOwner
52     );
53 
54     /**
55      * @dev Throws if called by any account other than the owner.
56      */
57     modifier onlyOwner() {
58         require(msg.sender == owner);
59         _;
60     }
61 
62     /**
63      * @dev Allows the current owner to transfer control of the contract to a newOwner.
64      * @param _newOwner The address to transfer ownership to.
65      */
66     function transferOwnership(address _newOwner) public onlyOwner {
67         _transferOwnership(_newOwner);
68     }
69 
70     /**
71      * @dev Transfers control of the contract to a newOwner.
72      * @param _newOwner The address to transfer ownership to.
73      */
74     function _transferOwnership(address _newOwner) internal {
75         require(_newOwner != address(0));
76         emit OwnershipTransferred(owner, _newOwner);
77         owner = _newOwner;
78     }
79 }
80 
81 contract Pausable is Ownable {
82     event Pause();
83     event Unpause();
84 
85     bool public paused = false;
86 
87     /**
88      * @dev Modifier to make a function callable only when the contract is not paused.
89      */
90     modifier whenNotPaused() {
91         require(!paused);
92         _;
93     }
94 
95     /**
96      * @dev Modifier to make a function callable only when the contract is paused.
97      */
98     modifier whenPaused() {
99         require(paused);
100         _;
101     }
102 
103     /**
104      * @dev called by the owner to pause, triggers stopped state
105      */
106     function pause() public onlyOwner whenNotPaused {
107         paused = true;
108         emit Pause();
109     }
110 
111     /**
112      * @dev called by the owner to unpause, returns to normal state
113      */
114     function unpause() public onlyOwner whenPaused {
115         paused = false;
116         emit Unpause();
117     }
118 }
119 
120 
121 contract StandardToken {
122     using SafeMath for uint256;
123 
124     mapping(address => uint256) internal balances;
125 
126     mapping(address => mapping(address => uint256)) internal allowed;
127 
128     uint256 internal totalSupply_;
129 
130     event Transfer(
131         address indexed from,
132         address indexed to,
133         uint256 value
134     );
135 
136     event Approval(
137         address indexed owner,
138         address indexed spender,
139         uint256 vaule
140     );
141 
142     /**
143      * @dev Total number of tokens in existence
144      */
145     function totalSupply() public view returns(uint256) {
146         return totalSupply_;
147     }
148 
149     /**
150      * @dev Gets the balance of the specified address.
151      * @param _owner The address to query the the balance of.
152      * @return An uint256 representing the amount owned by the passed address.
153      */
154     function balanceOf(address _owner) public view returns(uint256) {
155         return balances[_owner];
156     }
157 
158     /**
159      * @dev Function to check the amount of tokens that an owner allowed to a spender.
160      * @param _owner address The address which owns the funds.
161      * @param _spender address The address which will spend the funds.
162      * @return A uint256 specifying the amount of tokens still available for the spender.
163      */
164     function allowance(
165         address _owner,
166         address _spender
167     )
168     public
169     view
170     returns(uint256) {
171         return allowed[_owner][_spender];
172     }
173 
174     /**
175      * @dev Transfer token for a specified address
176      * @param _to The address to transfer to.
177      * @param _value The amount to be transferred.
178      */
179     function transfer(address _to, uint256 _value) public returns(bool) {
180         require(_to != address(0));
181         require(_value <= balances[msg.sender]);
182 
183         balances[msg.sender] = balances[msg.sender].sub(_value);
184         balances[_to] = balances[_to].add(_value);
185         emit Transfer(msg.sender, _to, _value);
186         return true;
187     }
188 
189     /**
190      * @dev Approve the passed address to spend the specified amount of tokens on behalf of msg.sender.
191      * Beware that changing an allowance with this method brings the risk that someone may use both the old
192      * and the new allowance by unfortunate transaction ordering. One possible solution to mitigate this
193      * race condition is to first reduce the spender's allowance to 0 and set the desired value afterwards:
194      * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
195      * @param _spender The address which will spend the funds.
196      * @param _value The amount of tokens to be spent.
197      */
198     function approve(address _spender, uint256 _value) public returns(bool) {
199         allowed[msg.sender][_spender] = _value;
200         emit Approval(msg.sender, _spender, _value);
201         return true;
202     }
203 
204     /**
205      * @dev Transfer tokens from one address to another
206      * @param _from address The address which you want to send tokens from
207      * @param _to address The address which you want to transfer to
208      * @param _value uint256 the amount of tokens to be transferred
209      */
210     function transferFrom(
211         address _from,
212         address _to,
213         uint256 _value
214     )
215     public
216     returns(bool) {
217         require(_to != address(0));
218         require(_value <= balances[_from]);
219         require(_value <= allowed[_from][msg.sender]);
220 
221         balances[_from] = balances[_from].sub(_value);
222         balances[_to] = balances[_to].add(_value);
223         allowed[_from][msg.sender] = allowed[_from][msg.sender].sub(_value);
224         emit Transfer(_from, _to, _value);
225         return true;
226     }
227 
228     /**
229      * @dev Increase the amount of tokens that an owner allowed to a spender.
230      * approve should be called when allowed[_spender] == 0. To increment
231      * allowed value is better to use this function to avoid 2 calls (and wait until
232      * the first transaction is mined)
233      * From MonolithDAO Token.sol
234      * @param _spender The address which will spend the funds.
235      * @param _addedValue The amount of tokens to increase the allowance by.
236      */
237     function increaseApproval(
238         address _spender,
239         uint256 _addedValue
240     )
241     public
242     returns(bool) {
243         allowed[msg.sender][_spender] = allowed[msg.sender][_spender].add(_addedValue);
244         emit Approval(msg.sender, _spender, allowed[msg.sender][_spender]);
245         return true;
246     }
247 
248     /**
249      * @dev Decrease the amount of tokens that an owner allowed to a spender.
250      * approve should be called when allowed[_spender] == 0. To decrement
251      * allowed value is better to use this function to avoid 2 calls (and wait until
252      * the first transaction is mined)
253      * From MonolithDAO Token.sol
254      * @param _spender The address which will spend the funds.
255      * @param _subtractedValue The amount of tokens to decrease the allowance by.
256      */
257     function decreaseApproval(
258         address _spender,
259         uint256 _subtractedValue
260     )
261     public
262     returns(bool) {
263         uint256 oldValue = allowed[msg.sender][_spender];
264         if (_subtractedValue >= oldValue) {
265             allowed[msg.sender][_spender] = 0;
266         } else {
267             allowed[msg.sender][_spender] = oldValue.sub(_subtractedValue);
268         }
269         emit Approval(msg.sender, _spender, allowed[msg.sender][_spender]);
270         return true;
271     }
272 }
273 
274 
275 contract BurnableToken is StandardToken, Ownable {
276 
277     /**
278      * @dev Internal function that burns an amount of the token of a given
279      * account. Uses the internal burn function.
280      * @param account The account whose tokens will be burnt.
281      * @param value The amount that will be burnt.
282      */
283     function _burn(address account, uint256 value) internal {
284         require(account != address(0)); 
285         totalSupply_ = totalSupply_.sub(value);
286         balances[account] = balances[account].sub(value);
287         emit Transfer(account, address(0), value);
288     }
289 
290     /**
291      * @dev Burns a specific amount of tokens.
292      * @param value The amount of token to be burned.
293      */
294     function burn(uint256 value) public onlyOwner{
295         _burn(msg.sender, value);
296     }
297 }
298 
299 
300 contract PausableToken is StandardToken, Pausable {
301 
302     function transfer(
303         address _to,
304         uint256 _value
305     )
306     public
307     whenNotPaused
308     returns(bool) {
309         return super.transfer(_to, _value);
310     }
311 
312     function transferFrom(
313         address _from,
314         address _to,
315         uint256 _value
316     )
317     public
318     whenNotPaused
319     returns(bool) {
320         return super.transferFrom(_from, _to, _value);
321     }
322 
323     function approve(
324         address _spender,
325         uint256 _value
326     )
327     public
328     whenNotPaused
329     returns(bool) {
330         return super.approve(_spender, _value);
331     }
332 
333     function increaseApproval(
334         address _spender,
335         uint _addedValue
336     )
337     public
338     whenNotPaused
339     returns(bool success) {
340         return super.increaseApproval(_spender, _addedValue);
341     }
342 
343     function decreaseApproval(
344         address _spender,
345         uint _subtractedValue
346     )
347     public
348     whenNotPaused
349     returns(bool success) {
350         return super.decreaseApproval(_spender, _subtractedValue);
351     }
352 }
353 
354 
355 /**
356  * @title ZBMegaToken token
357  * @dev Initialize the basic information of ZBMegaToken.
358  */
359 contract ZBMegaToken is PausableToken, BurnableToken {
360     string public constant name = "ZB Mega"; // name of Token
361     string public constant symbol = "ZM"; // symbol of Token
362     uint8 public constant decimals = 18; // decimals of Token
363     uint256 constant _INIT_TOTALSUPPLY = 860000000;
364 
365   /**
366    * @dev constructor Initialize the basic information.
367    */
368     constructor() public {
369         totalSupply_ = _INIT_TOTALSUPPLY * 10 ** uint256(decimals);
370         owner = 0x1Acfb5Fb2aa33C0fc0d7f94A4099aff6EA8d368C;
371         balances[owner] = totalSupply_;
372     }
373 }