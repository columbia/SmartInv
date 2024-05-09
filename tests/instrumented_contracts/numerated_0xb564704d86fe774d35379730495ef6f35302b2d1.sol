1 pragma solidity ^0.4.18;
2 
3 
4 /**
5  * @title ERC20Basic
6  * @dev Simpler version of ERC20 interface
7  * @dev see https://github.com/ethereum/EIPs/issues/179
8  */
9 contract ERC20Basic {
10     function totalSupply() public view returns (uint256);
11     function balanceOf(address who) public view returns (uint256);
12     function transfer(address to, uint256 value) public returns (bool);
13     event Transfer(address indexed from, address indexed to, uint256 value);
14 }
15 
16 
17 /**
18  * @title SafeMath
19  * @dev Math operations with safety checks that throw on error
20  */
21 library SafeMath {
22 
23   /**
24   * @dev Multiplies two numbers, throws on overflow.
25   */
26   function mul(uint256 a, uint256 b) internal pure returns (uint256) {
27     if (a == 0) {
28       return 0;
29     }
30     uint256 c = a * b;
31     assert(c / a == b);
32     return c;
33   }
34 
35   /**
36   * @dev Integer division of two numbers, truncating the quotient.
37   */
38   function div(uint256 a, uint256 b) internal pure returns (uint256) {
39     // assert(b > 0); // Solidity automatically throws when dividing by 0
40     uint256 c = a / b;
41     // assert(a == b * c + a % b); // There is no case in which this doesn't hold
42     return c;
43   }
44 
45   /**
46   * @dev Substracts two numbers, throws on overflow (i.e. if subtrahend is greater than minuend).
47   */
48   function sub(uint256 a, uint256 b) internal pure returns (uint256) {
49     assert(b <= a);
50     return a - b;
51   }
52 
53   /**
54   * @dev Adds two numbers, throws on overflow.
55   */
56   function add(uint256 a, uint256 b) internal pure returns (uint256) {
57     uint256 c = a + b;
58     assert(c >= a);
59     return c;
60   }
61 }
62 
63 
64 /**
65  * @title Basic token
66  * @dev Basic version of StandardToken, with no allowances.
67  */
68 contract BasicToken is ERC20Basic {
69     using SafeMath for uint256;
70 
71     mapping(address => uint256) balances;
72 
73     uint256 totalSupply_;
74 
75     function totalSupply() public view returns (uint256) {
76         return totalSupply_;
77     }
78 
79     function transfer(address _to, uint256 _value) public returns (bool) {
80         require(_to != address(0));
81         require(_value <= balances[msg.sender]);
82 
83         // SafeMath.sub will throw if there is not enough balance.
84         balances[msg.sender] = balances[msg.sender].sub(_value);
85         balances[_to] = balances[_to].add(_value);
86         Transfer(msg.sender, _to, _value);
87         return true;
88     }
89 
90     function balanceOf(address _owner) public view returns (uint256 balance) {
91         return balances[_owner];
92     }
93 
94 }
95 
96 
97 /**
98  * @title Burnable Token
99  * @dev Token that can be irreversibly burned (destroyed).
100  */
101 contract BurnableToken is BasicToken {
102 
103     event Burn(address indexed burner, uint256 value);
104 
105 
106     function burn(uint256 _value) public {
107         require(_value <= balances[msg.sender]);
108         // no need to require value <= totalSupply, since that would imply the
109         // sender's balance is greater than the totalSupply, which *should* be an assertion failure
110 
111         address burner = msg.sender;
112         balances[burner] = balances[burner].sub(_value);
113         totalSupply_ = totalSupply_.sub(_value);
114         Burn(burner, _value);
115         Transfer(burner, address(0), _value);
116     }
117 }
118 
119 
120 /**
121  * @title ERC20 interface
122  */
123 contract ERC20 is ERC20Basic {
124     function allowance(address owner, address spender) public view returns (uint256);
125     function transferFrom(address from, address to, uint256 value) public returns (bool);
126     function approve(address spender, uint256 value) public returns (bool);
127     event Approval(address indexed owner, address indexed spender, uint256 value);
128 }
129 
130 
131 /**
132    @title ERC827 interface, an extension of ERC20 token standard
133    Interface of a ERC827 token, following the ERC20 standard with extra
134    methods to transfer value and data and execute calls in transfers and
135    approvals.
136  */
137 contract ERC827 is ERC20 {
138 
139     function approve( address _spender, uint256 _value, bytes _data ) public returns (bool);
140     function transfer( address _to, uint256 _value, bytes _data ) public returns (bool);
141     function transferFrom( address _from, address _to, uint256 _value, bytes _data ) public returns (bool);
142 
143 }
144 
145 
146 /**
147  * @title Standard ERC20 token
148  *
149  * @dev Implementation of the basic standard token.
150  */
151 contract StandardToken is ERC20, BasicToken {
152 
153     mapping (address => mapping (address => uint256)) internal allowed;
154 
155 
156     function transferFrom(address _from, address _to, uint256 _value) public returns (bool) {
157         require(_to != address(0));
158         require(_value <= balances[_from]);
159         require(_value <= allowed[_from][msg.sender]);
160 
161         balances[_from] = balances[_from].sub(_value);
162         balances[_to] = balances[_to].add(_value);
163         allowed[_from][msg.sender] = allowed[_from][msg.sender].sub(_value);
164         Transfer(_from, _to, _value);
165         return true;
166     }
167 
168     function approve(address _spender, uint256 _value) public returns (bool) {
169         allowed[msg.sender][_spender] = _value;
170         Approval(msg.sender, _spender, _value);
171         return true;
172     }
173 
174     function allowance(address _owner, address _spender) public view returns (uint256) {
175         return allowed[_owner][_spender];
176     }
177 
178     function increaseApproval(address _spender, uint _addedValue) public returns (bool) {
179         allowed[msg.sender][_spender] = allowed[msg.sender][_spender].add(_addedValue);
180         Approval(msg.sender, _spender, allowed[msg.sender][_spender]);
181         return true;
182     }
183 
184     function decreaseApproval(address _spender, uint _subtractedValue) public returns (bool) {
185         uint oldValue = allowed[msg.sender][_spender];
186         if (_subtractedValue > oldValue) {
187             allowed[msg.sender][_spender] = 0;
188         } else {
189             allowed[msg.sender][_spender] = oldValue.sub(_subtractedValue);
190         }
191         Approval(msg.sender, _spender, allowed[msg.sender][_spender]);
192         return true;
193     }
194 
195 }
196 
197 
198 /**
199    @title ERC827, an extension of ERC20 token standard
200    Implementation the ERC827, following the ERC20 standard with extra
201    methods to transfer value and data and execute calls in transfers and
202    approvals.
203  */
204 contract ERC827Token is ERC827, StandardToken {
205 
206     function approve(address _spender, uint256 _value, bytes _data) public returns (bool) {
207         require(_spender != address(this));
208 
209         super.approve(_spender, _value);
210 
211         require(_spender.call(_data));
212 
213         return true;
214     }
215 
216     function transfer(address _to, uint256 _value, bytes _data) public returns (bool) {
217         require(_to != address(this));
218 
219         super.transfer(_to, _value);
220 
221         require(_to.call(_data));
222         return true;
223     }
224 
225     function transferFrom(address _from, address _to, uint256 _value, bytes _data) public returns (bool) {
226         require(_to != address(this));
227 
228         super.transferFrom(_from, _to, _value);
229 
230         require(_to.call(_data));
231         return true;
232     }
233 
234     function increaseApproval(address _spender, uint _addedValue, bytes _data) public returns (bool) {
235         require(_spender != address(this));
236 
237         super.increaseApproval(_spender, _addedValue);
238 
239         require(_spender.call(_data));
240 
241         return true;
242     }
243 
244     function decreaseApproval(address _spender, uint _subtractedValue, bytes _data) public returns (bool) {
245         require(_spender != address(this));
246 
247         super.decreaseApproval(_spender, _subtractedValue);
248 
249         require(_spender.call(_data));
250 
251         return true;
252     }
253 
254 }
255 
256 
257 /**
258  * @title Ownable
259  * @dev The Ownable contract has an owner address, and provides basic authorization control
260  * functions, this simplifies the implementation of "user permissions".
261  */
262 contract Ownable {
263     address public owner;
264 
265 
266     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
267 
268 
269     /**
270      * @dev The Ownable constructor sets the original `owner` of the contract to the sender
271      * account.
272      */
273     function Ownable() public {
274         owner = msg.sender;
275     }
276 
277     /**
278      * @dev Throws if called by any account other than the owner.
279      */
280     modifier onlyOwner() {
281         require(msg.sender == owner);
282         _;
283     }
284 
285     /**
286      * @dev Allows the current owner to transfer control of the contract to a newOwner.
287      * @param newOwner The address to transfer ownership to.
288      */
289     function transferOwnership(address newOwner) public onlyOwner {
290         require(newOwner != address(0));
291         OwnershipTransferred(owner, newOwner);
292         owner = newOwner;
293     }
294 
295 }
296 
297 
298 /**
299  * @title Pausable
300  * @dev Base contract which allows children to implement an emergency stop mechanism.
301  */
302 contract Pausable is Ownable {
303     event Pause();
304     event Unpause();
305 
306     bool public paused = false;
307 
308 
309     /**
310      * @dev Modifier to make a function callable only when the contract is not paused.
311      */
312     modifier whenNotPaused() {
313         require(!paused);
314         _;
315     }
316 
317     /**
318      * @dev Modifier to make a function callable only when the contract is paused.
319      */
320     modifier whenPaused() {
321         require(paused);
322         _;
323     }
324 
325     /**
326      * @dev called by the owner to pause, triggers stopped state
327      */
328     function pause() onlyOwner whenNotPaused public {
329         paused = true;
330         Pause();
331     }
332 
333     /**
334      * @dev called by the owner to unpause, returns to normal state
335      */
336     function unpause() onlyOwner whenPaused public {
337         paused = false;
338         Unpause();
339     }
340 }
341 
342 
343 /**
344  * @title Pausable token
345  * @dev StandardToken modified with pausable transfers.
346  **/
347 contract PausableToken is StandardToken, Pausable {
348 
349     function transfer(address _to, uint256 _value) public whenNotPaused returns (bool) {
350         return super.transfer(_to, _value);
351     }
352 
353     function transferFrom(address _from, address _to, uint256 _value) public whenNotPaused returns (bool) {
354         return super.transferFrom(_from, _to, _value);
355     }
356 
357     function approve(address _spender, uint256 _value) public whenNotPaused returns (bool) {
358         return super.approve(_spender, _value);
359     }
360 
361     function increaseApproval(address _spender, uint _addedValue) public whenNotPaused returns (bool success) {
362         return super.increaseApproval(_spender, _addedValue);
363     }
364 
365     function decreaseApproval(address _spender, uint _subtractedValue) public whenNotPaused returns (bool success) {
366         return super.decreaseApproval(_spender, _subtractedValue);
367     }
368 }
369 
370 
371 /**
372  * @title Pausable ERC827 token
373  * @dev ERC827 token modified with pausable functions.
374  **/
375 contract PausableERC827Token is ERC827Token, PausableToken {
376 
377     function transfer(address _to, uint256 _value, bytes _data) public whenNotPaused returns (bool) {
378         return super.transfer(_to, _value, _data);
379     }
380 
381     function transferFrom(address _from, address _to, uint256 _value, bytes _data) public whenNotPaused returns (bool) {
382         return super.transferFrom(_from, _to, _value, _data);
383     }
384 
385     function approve(address _spender, uint256 _value, bytes _data) public whenNotPaused returns (bool) {
386         return super.approve(_spender, _value, _data);
387     }
388 
389     function increaseApproval(address _spender, uint _addedValue, bytes _data) public whenNotPaused returns (bool) {
390         return super.increaseApproval(_spender, _addedValue, _data);
391     }
392 
393     function decreaseApproval(address _spender, uint _subtractedValue, bytes _data) public whenNotPaused returns (bool) {
394         return super.decreaseApproval(_spender, _subtractedValue, _data);
395     }
396 }
397 
398 
399 contract COOPToken is PausableERC827Token, BurnableToken {
400 
401     string public constant name = "Cooperative Exchange Token";
402     string public constant symbol = "COOP";
403     uint32 public constant decimals = 14;
404 
405     function COOPToken() public {
406         totalSupply_ = 12000000E14;
407         balances[owner] = totalSupply_; // Add all tokens to issuer balance (crowdsale in this case)
408     }
409 
410 }