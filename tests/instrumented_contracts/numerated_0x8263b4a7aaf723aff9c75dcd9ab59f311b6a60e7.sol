1 pragma solidity ^0.4.24;
2 
3 /**
4  * @title SafeMath
5  * @dev Math operations with safety checks that throw on error
6  */
7 library SafeMath {
8 
9   /**
10   * @dev Multiplies two numbers, throws on overflow.
11   */
12   function mul(uint256 a, uint256 b) internal pure returns (uint256) {
13     if (a == 0) {
14       return 0;
15     }
16     uint256 c = a * b;
17     assert(c / a == b);
18     return c;
19   }
20 
21   /**
22   * @dev Integer division of two numbers, truncating the quotient.
23   */
24   function div(uint256 a, uint256 b) internal pure returns (uint256) {
25     // assert(b > 0); // Solidity automatically throws when dividing by 0
26     uint256 c = a / b;
27     // assert(a == b * c + a % b); // There is no case in which this doesn't hold
28     return c;
29   }
30 
31   /**
32   * @dev Subtracts two numbers, throws on overflow (i.e. if subtrahend is greater than minuend).
33   */
34   function sub(uint256 a, uint256 b) internal pure returns (uint256) {
35     assert(b <= a);
36     return a - b;
37   }
38 
39   /**
40   * @dev Adds two numbers, throws on overflow.
41   */
42   function add(uint256 a, uint256 b) internal pure returns (uint256) {
43     uint256 c = a + b;
44     assert(c >= a);
45     return c;
46   }
47 }
48 
49 /**
50  * @title ERC20Basic
51  * @dev Simpler version of ERC20 interface
52  * See https://github.com/ethereum/EIPs/issues/179
53  */
54 contract ERC20Basic {
55     function totalSupply() public view returns (uint256);
56     function balanceOf(address who) public view returns (uint256);
57     function transfer(address to, uint256 value) public returns (bool);
58     event Transfer(address indexed from, address indexed to, uint256 value);
59 
60     function allowance(address owner, address spender) public view returns (uint256);
61     function transferFrom(address from, address to, uint256 value) public returns (bool);
62     function approve(address spender, uint256 value) public returns (bool);
63     event Approval(address indexed owner, address indexed spender, uint256 value);
64 }
65 
66 
67 /**
68  * @title TokenControl
69  */
70 contract TokenControl {
71     // ceoAddress cfoAddress cooAddress 的地址;
72     address public ceoAddress;
73     address public cfoAddress;
74     address public cooAddress;
75 
76      // 控制是否可以焚毁和增加token
77     bool public enablecontrol = true;
78 
79 
80     modifier onlyCEO() {
81         require(msg.sender == ceoAddress);
82         _;
83     }
84   
85     modifier onlyCFO() {
86         require(msg.sender == cfoAddress);
87         _;
88     }
89     
90     modifier onlyCOO() {
91         require(msg.sender == cooAddress);
92         _;
93     }
94     
95     modifier whenNotPaused() {
96         require(enablecontrol);
97         _;
98     }
99     
100 
101     function setCEO(address _newCEO) external onlyCEO {
102         require(_newCEO != address(0));
103 
104         ceoAddress = _newCEO;
105     }
106     
107     function setCFO(address _newCFO) external onlyCEO {
108         require(_newCFO != address(0));
109 
110         cfoAddress = _newCFO;
111     }
112     
113     function setCOO(address _newCOO) external onlyCEO {
114         require(_newCOO != address(0));
115 
116         cooAddress = _newCOO;
117     }
118     
119     function enableControl(bool _enable) public onlyCEO{
120         enablecontrol = _enable;
121     }
122 
123   
124 }
125 
126 /**
127  * @title Standard ERC20 token
128  *
129  * @dev Implementation of the basic standard token.
130  * @dev https://github.com/ethereum/EIPs/issues/20
131  * @dev Based on code by FirstBlood: https://github.com/Firstbloodio/token/blob/master/smart_contract/FirstBloodToken.sol
132  */
133 contract StandardToken is ERC20Basic {
134 
135     using SafeMath for uint256;
136 
137     mapping(address => uint256) balances;
138 
139     uint256 totalSupply_;
140 
141     /**
142     * @dev Total number of tokens in existence
143     */
144     function totalSupply() public view returns (uint256) {
145         return totalSupply_;
146     }
147 
148     /**
149     * @dev Transfer token for a specified address
150     * @param _to The address to transfer to.
151     * @param _value The amount to be transferred.
152     */
153     function transfer(address _to, uint256 _value) public returns (bool) {
154         require(_value <= balances[msg.sender]);
155         require(_to != address(0));
156 
157         balances[msg.sender] = balances[msg.sender].sub(_value);
158         balances[_to] = balances[_to].add(_value);
159         emit Transfer(msg.sender, _to, _value);
160         return true;
161     }
162 
163     /**
164     * @dev Gets the balance of the specified address.
165     * @param _owner The address to query the the balance of.
166     * @return An uint256 representing the amount owned by the passed address.
167     */
168     function balanceOf(address _owner) public view returns (uint256) {
169         return balances[_owner];
170     }
171 
172     mapping (address => mapping (address => uint256)) internal allowed;
173 
174 
175     /**
176     * @dev Transfer tokens from one address to another
177     * @param _from address The address which you want to send tokens from
178     * @param _to address The address which you want to transfer to
179     * @param _value uint256 the amount of tokens to be transferred
180     */
181     function transferFrom(
182         address _from,
183         address _to,
184         uint256 _value
185     )
186         public
187         returns (bool)
188     {
189         require(_value <= balances[_from]);
190         require(_value <= allowed[_from][msg.sender]);
191         require(_to != address(0));
192 
193         balances[_from] = balances[_from].sub(_value);
194         balances[_to] = balances[_to].add(_value);
195         allowed[_from][msg.sender] = allowed[_from][msg.sender].sub(_value);
196         emit Transfer(_from, _to, _value);
197         return true;
198     }
199 
200     /**
201     * @dev Approve the passed address to spend the specified amount of tokens on behalf of msg.sender.
202     * Beware that changing an allowance with this method brings the risk that someone may use both the old
203     * and the new allowance by unfortunate transaction ordering. One possible solution to mitigate this
204     * race condition is to first reduce the spender's allowance to 0 and set the desired value afterwards:
205     * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
206     * @param _spender The address which will spend the funds.
207     * @param _value The amount of tokens to be spent.
208     */
209     function approve(address _spender, uint256 _value) public returns (bool) {
210         allowed[msg.sender][_spender] = _value;
211         emit Approval(msg.sender, _spender, _value);
212         return true;
213     }
214 
215     /**
216     * @dev Function to check the amount of tokens that an owner allowed to a spender.
217     * @param _owner address The address which owns the funds.
218     * @param _spender address The address which will spend the funds.
219     * @return A uint256 specifying the amount of tokens still available for the spender.
220     */
221     function allowance(
222         address _owner,
223         address _spender
224     )
225         public
226         view
227         returns (uint256)
228     {
229         return allowed[_owner][_spender];
230     }
231 
232     /**
233     * @dev Increase the amount of tokens that an owner allowed to a spender.
234     * approve should be called when allowed[_spender] == 0. To increment
235     * allowed value is better to use this function to avoid 2 calls (and wait until
236     * the first transaction is mined)
237     * From MonolithDAO Token.sol
238     * @param _spender The address which will spend the funds.
239     * @param _addedValue The amount of tokens to increase the allowance by.
240     */
241     function increaseApproval(
242         address _spender,
243         uint256 _addedValue
244     )
245         public
246         returns (bool)
247     {
248         allowed[msg.sender][_spender] = (
249         allowed[msg.sender][_spender].add(_addedValue));
250         emit Approval(msg.sender, _spender, allowed[msg.sender][_spender]);
251         return true;
252     }
253 
254     /**
255     * @dev Decrease the amount of tokens that an owner allowed to a spender.
256     * approve should be called when allowed[_spender] == 0. To decrement
257     * allowed value is better to use this function to avoid 2 calls (and wait until
258     * the first transaction is mined)
259     * From MonolithDAO Token.sol
260     * @param _spender The address which will spend the funds.
261     * @param _subtractedValue The amount of tokens to decrease the allowance by.
262     */
263     function decreaseApproval(
264         address _spender,
265         uint256 _subtractedValue
266     )
267         public
268         returns (bool)
269     {
270         uint256 oldValue = allowed[msg.sender][_spender];
271         if (_subtractedValue >= oldValue) {
272             allowed[msg.sender][_spender] = 0;
273         } else {
274             allowed[msg.sender][_spender] = oldValue.sub(_subtractedValue);
275         }
276         emit Approval(msg.sender, _spender, allowed[msg.sender][_spender]);
277         return true;
278     }
279 }
280 
281 /**
282  * @title Burnable Token
283  * @dev Token that can be irreversibly burned (destroyed).
284  */
285 contract BurnableToken is StandardToken, TokenControl {
286 
287     event Burn(address indexed burner, uint256 value);
288 
289  
290     /**
291     * @dev Burns a specific amount of tokens.
292     * @param _value The amount of token to be burned.
293     */
294     function burn(uint256 _value) onlyCOO whenNotPaused public {
295         _burn(_value);
296     }
297 
298     function _burn( uint256 _value) internal {
299         require(_value <= balances[cfoAddress]);
300         // no need to require value <= totalSupply, since that would imply the
301         // sender's balance is greater than the totalSupply, which *should* be an assertion failure
302 
303         balances[cfoAddress] = balances[cfoAddress].sub(_value);
304         totalSupply_ = totalSupply_.sub(_value);
305         emit Burn(cfoAddress, _value);
306         emit Transfer(cfoAddress, address(0), _value);
307     }
308 }
309 
310 contract MintableToken is StandardToken, TokenControl {
311     event Mint(address indexed to, uint256 amount);
312     
313 
314      /**
315     * @dev Mints a specific amount of tokens.
316     * @param _value The amount of token to be Minted.
317     */
318     function mint(uint256 _value) onlyCOO whenNotPaused  public {
319         _mint(_value);
320     }
321 
322     function _mint( uint256 _value) internal {
323         
324         balances[cfoAddress] = balances[cfoAddress].add(_value);
325         totalSupply_ = totalSupply_.add(_value);
326         emit Mint(cfoAddress, _value);
327         emit Transfer(address(0), cfoAddress, _value);
328     }
329 
330 }
331 
332 /**
333  * @title Pausable token
334  *
335  * @dev StandardToken modified with pausable transfers.
336  **/
337 
338 contract PausableToken is StandardToken, TokenControl {
339     
340      // Flag that determines if the token is transferable or not.
341     bool public transferEnabled = true;
342     
343     // 控制交易锁
344     function enableTransfer(bool _enable) public onlyCEO{
345         transferEnabled = _enable;
346     }
347     
348     modifier transferAllowed() {
349          // flase抛异常，并扣除gas消耗
350         assert(transferEnabled);
351         _;
352     }
353     
354 
355     function transfer(address _to, uint256 _value) public transferAllowed() returns (bool) {
356         return super.transfer(_to, _value);
357     }
358 
359     function transferFrom(address _from, address _to, uint256 _value) public transferAllowed() returns (bool) {
360         return super.transferFrom(_from, _to, _value);
361     }
362 
363     function approve(address _spender, uint256 _value) public transferAllowed() returns (bool) {
364         return super.approve(_spender, _value);
365     }
366 }
367 
368 contract MSFT is BurnableToken, MintableToken, PausableToken {
369     
370     // Public variables of the token
371     string public name;
372     string public symbol;
373     // decimals is the strongly suggested default, avoid changing it
374     uint8 public decimals;
375 
376     constructor(address _ceoAddress, address _cfoAddress, address _cooAddress)  public {
377         name = "T-MSFT";
378         symbol = "T-MSFT";
379         decimals = 8;
380         
381         ceoAddress = _ceoAddress;
382         cfoAddress = _cfoAddress;
383         cooAddress = _cooAddress;
384         // 0000000000f
385         totalSupply_ = 5000;
386         // Allocate initial balance to the owner
387         balances[cfoAddress] = totalSupply_;
388     }
389 
390     
391     // can accept ether
392     function() payable public { }
393 }