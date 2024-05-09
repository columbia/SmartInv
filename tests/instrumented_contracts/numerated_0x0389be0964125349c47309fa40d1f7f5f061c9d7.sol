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
79   /**
80    * @dev 
81    */
82     constructor() public {
83         ceoAddress = msg.sender;
84         cfoAddress = msg.sender;
85         cooAddress = msg.sender;
86     }
87 
88     modifier onlyCEO() {
89         require(msg.sender == ceoAddress);
90         _;
91     }
92   
93     modifier onlyCFO() {
94         require(msg.sender == cfoAddress);
95         _;
96     }
97     
98     modifier onlyCOO() {
99         require(msg.sender == cooAddress);
100         _;
101     }
102     
103     modifier whenNotPaused() {
104         require(enablecontrol);
105         _;
106     }
107     
108 
109     function setCEO(address _newCEO) external onlyCEO {
110         require(_newCEO != address(0));
111 
112         ceoAddress = _newCEO;
113     }
114     
115     function setCFO(address _newCFO) external onlyCEO {
116         require(_newCFO != address(0));
117 
118         cfoAddress = _newCFO;
119     }
120     
121     function setCOO(address _newCOO) external onlyCEO {
122         require(_newCOO != address(0));
123 
124         cooAddress = _newCOO;
125     }
126     
127     function enableControl(bool _enable) public onlyCEO{
128         enablecontrol = _enable;
129     }
130 
131   
132 }
133 
134 /**
135  * @title Standard ERC20 token
136  *
137  * @dev Implementation of the basic standard token.
138  * @dev https://github.com/ethereum/EIPs/issues/20
139  * @dev Based on code by FirstBlood: https://github.com/Firstbloodio/token/blob/master/smart_contract/FirstBloodToken.sol
140  */
141 contract StandardToken is ERC20Basic {
142 
143     using SafeMath for uint256;
144 
145     mapping(address => uint256) balances;
146 
147     uint256 totalSupply_;
148 
149     /**
150     * @dev Total number of tokens in existence
151     */
152     function totalSupply() public view returns (uint256) {
153         return totalSupply_;
154     }
155 
156     /**
157     * @dev Transfer token for a specified address
158     * @param _to The address to transfer to.
159     * @param _value The amount to be transferred.
160     */
161     function transfer(address _to, uint256 _value) public returns (bool) {
162         require(_value <= balances[msg.sender]);
163         require(_to != address(0));
164 
165         balances[msg.sender] = balances[msg.sender].sub(_value);
166         balances[_to] = balances[_to].add(_value);
167         emit Transfer(msg.sender, _to, _value);
168         return true;
169     }
170 
171     /**
172     * @dev Gets the balance of the specified address.
173     * @param _owner The address to query the the balance of.
174     * @return An uint256 representing the amount owned by the passed address.
175     */
176     function balanceOf(address _owner) public view returns (uint256) {
177         return balances[_owner];
178     }
179 
180     mapping (address => mapping (address => uint256)) internal allowed;
181 
182 
183     /**
184     * @dev Transfer tokens from one address to another
185     * @param _from address The address which you want to send tokens from
186     * @param _to address The address which you want to transfer to
187     * @param _value uint256 the amount of tokens to be transferred
188     */
189     function transferFrom(
190         address _from,
191         address _to,
192         uint256 _value
193     )
194         public
195         returns (bool)
196     {
197         require(_value <= balances[_from]);
198         require(_value <= allowed[_from][msg.sender]);
199         require(_to != address(0));
200 
201         balances[_from] = balances[_from].sub(_value);
202         balances[_to] = balances[_to].add(_value);
203         allowed[_from][msg.sender] = allowed[_from][msg.sender].sub(_value);
204         emit Transfer(_from, _to, _value);
205         return true;
206     }
207 
208     /**
209     * @dev Approve the passed address to spend the specified amount of tokens on behalf of msg.sender.
210     * Beware that changing an allowance with this method brings the risk that someone may use both the old
211     * and the new allowance by unfortunate transaction ordering. One possible solution to mitigate this
212     * race condition is to first reduce the spender's allowance to 0 and set the desired value afterwards:
213     * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
214     * @param _spender The address which will spend the funds.
215     * @param _value The amount of tokens to be spent.
216     */
217     function approve(address _spender, uint256 _value) public returns (bool) {
218         allowed[msg.sender][_spender] = _value;
219         emit Approval(msg.sender, _spender, _value);
220         return true;
221     }
222 
223     /**
224     * @dev Function to check the amount of tokens that an owner allowed to a spender.
225     * @param _owner address The address which owns the funds.
226     * @param _spender address The address which will spend the funds.
227     * @return A uint256 specifying the amount of tokens still available for the spender.
228     */
229     function allowance(
230         address _owner,
231         address _spender
232     )
233         public
234         view
235         returns (uint256)
236     {
237         return allowed[_owner][_spender];
238     }
239 
240     /**
241     * @dev Increase the amount of tokens that an owner allowed to a spender.
242     * approve should be called when allowed[_spender] == 0. To increment
243     * allowed value is better to use this function to avoid 2 calls (and wait until
244     * the first transaction is mined)
245     * From MonolithDAO Token.sol
246     * @param _spender The address which will spend the funds.
247     * @param _addedValue The amount of tokens to increase the allowance by.
248     */
249     function increaseApproval(
250         address _spender,
251         uint256 _addedValue
252     )
253         public
254         returns (bool)
255     {
256         allowed[msg.sender][_spender] = (
257         allowed[msg.sender][_spender].add(_addedValue));
258         emit Approval(msg.sender, _spender, allowed[msg.sender][_spender]);
259         return true;
260     }
261 
262     /**
263     * @dev Decrease the amount of tokens that an owner allowed to a spender.
264     * approve should be called when allowed[_spender] == 0. To decrement
265     * allowed value is better to use this function to avoid 2 calls (and wait until
266     * the first transaction is mined)
267     * From MonolithDAO Token.sol
268     * @param _spender The address which will spend the funds.
269     * @param _subtractedValue The amount of tokens to decrease the allowance by.
270     */
271     function decreaseApproval(
272         address _spender,
273         uint256 _subtractedValue
274     )
275         public
276         returns (bool)
277     {
278         uint256 oldValue = allowed[msg.sender][_spender];
279         if (_subtractedValue >= oldValue) {
280             allowed[msg.sender][_spender] = 0;
281         } else {
282             allowed[msg.sender][_spender] = oldValue.sub(_subtractedValue);
283         }
284         emit Approval(msg.sender, _spender, allowed[msg.sender][_spender]);
285         return true;
286     }
287 }
288 
289 /**
290  * @title Burnable Token
291  * @dev Token that can be irreversibly burned (destroyed).
292  */
293 contract BurnableToken is StandardToken, TokenControl {
294 
295     event Burn(address indexed burner, uint256 value);
296 
297  
298     /**
299     * @dev Burns a specific amount of tokens.
300     * @param _value The amount of token to be burned.
301     */
302     function burn(uint256 _value) onlyCOO whenNotPaused public {
303         _burn(_value);
304     }
305 
306     function _burn( uint256 _value) internal {
307         require(_value <= balances[cfoAddress]);
308         // no need to require value <= totalSupply, since that would imply the
309         // sender's balance is greater than the totalSupply, which *should* be an assertion failure
310 
311         balances[cfoAddress] = balances[cfoAddress].sub(_value);
312         totalSupply_ = totalSupply_.sub(_value);
313         emit Burn(cfoAddress, _value);
314         emit Transfer(cfoAddress, address(0), _value);
315     }
316 }
317 
318 contract MintableToken is StandardToken, TokenControl {
319     event Mint(address indexed to, uint256 amount);
320     
321 
322      /**
323     * @dev Mints a specific amount of tokens.
324     * @param _value The amount of token to be Minted.
325     */
326     function mint(uint256 _value) onlyCOO whenNotPaused  public {
327         _mint(_value);
328     }
329 
330     function _mint( uint256 _value) internal {
331         
332         balances[cfoAddress] = balances[cfoAddress].add(_value);
333         totalSupply_ = totalSupply_.add(_value);
334         emit Mint(cfoAddress, _value);
335         emit Transfer(address(0), cfoAddress, _value);
336     }
337 
338 }
339 
340 /**
341  * @title Pausable token
342  *
343  * @dev StandardToken modified with pausable transfers.
344  **/
345 
346 contract PausableToken is StandardToken, TokenControl {
347     
348      // Flag that determines if the token is transferable or not.
349     bool public transferEnabled = true;
350     
351     // 控制交易锁
352     function enableTransfer(bool _enable) public onlyCEO{
353         transferEnabled = _enable;
354     }
355     
356     modifier transferAllowed() {
357          // flase抛异常，并扣除gas消耗
358         assert(transferEnabled);
359         _;
360     }
361     
362 
363     function transfer(address _to, uint256 _value) public transferAllowed() returns (bool) {
364         return super.transfer(_to, _value);
365     }
366 
367     function transferFrom(address _from, address _to, uint256 _value) public transferAllowed() returns (bool) {
368         return super.transferFrom(_from, _to, _value);
369     }
370 
371     function approve(address _spender, uint256 _value) public transferAllowed() returns (bool) {
372         return super.approve(_spender, _value);
373     }
374 }
375 
376 contract NVFY is BurnableToken, MintableToken, PausableToken {
377     
378     // Public variables of the token
379     string public name;
380     string public symbol;
381     // decimals is the strongly suggested default, avoid changing it
382     uint8 public decimals;
383 
384     constructor() public {
385         name = "T-NVFY";
386         symbol = "T-NVFY";
387         decimals = 8;
388         
389         // 0000000000f
390         totalSupply_ = 5000;
391         // Allocate initial balance to the owner
392         balances[cfoAddress] = totalSupply_;
393     }
394 
395     
396     // can accept ether
397     function() payable public { }
398 }