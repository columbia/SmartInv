1 pragma solidity ^0.4.24;
2 
3 
4 /**
5 * @title SafeMath
6 * @dev Math operations with safety checks that throw on error
7 */
8 library SafeMath {
9 
10     /**
11     * @dev Subtracts two numbers, throws on overflow (i.e. if subtrahend is greater than minuend).
12     */
13     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
14         assert(b <= a);
15         return a - b;
16     }
17 
18     /**
19     * @dev Adds two numbers, throws on overflow.
20     */
21     function add(uint256 a, uint256 b) internal pure returns (uint256 c) {
22         c = a + b;
23         assert(c >= a);
24         return c;
25     }
26 }
27 
28 /**
29 * @title Ownable
30 * @dev The Ownable contract has an owner address, and provides basic authorization control
31 * functions, this simplifies the implementation of "user permissions".
32 */
33 contract Ownable {
34     address public owner;
35     event OwnershipRenounced(address indexed previousOwner);
36     event OwnershipTransferred(
37         address indexed previousOwner,
38         address indexed newOwner
39     );
40 
41 
42     /**
43     * @dev The Ownable constructor sets the original `owner` of the contract to the sender
44     * account.
45     */
46     constructor() public {
47         owner = msg.sender;
48     }
49 
50     /**
51     * @dev Throws if called by any account other than the owner.
52     */
53     modifier onlyOwner() {
54         require(msg.sender == owner);
55         _;
56     }
57 
58     /**
59     * @dev Allows the current owner to transfer control of the contract to a newOwner.
60     * @param _newOwner The address to transfer ownership to.
61     */
62     function transferOwnership(address _newOwner) public onlyOwner {
63         _transferOwnership(_newOwner);
64     }
65 
66     /**
67     * @dev Transfers control of the contract to a newOwner.
68     * @param _newOwner The address to transfer ownership to.
69     */
70     function _transferOwnership(address _newOwner) internal {
71         require(_newOwner != address(0));
72         emit OwnershipTransferred(owner, _newOwner);
73         owner = _newOwner;
74     }
75 }
76 
77    
78 /**
79 * @title ERC20Basic
80 * @dev Simpler version of ERC20 interface
81 * @dev see https://github.com/ethereum/EIPs/issues/179
82 */
83 contract ERC20Basic {
84     function totalSupply() public view returns (uint256);
85     function balanceOf(address who) public view returns (uint256);
86     function transfer(address to, uint256 value) public returns (bool);
87     event Transfer(address indexed from, address indexed to, uint256 value);
88 }
89 
90 /**
91 * @title Basic token
92 * @dev Basic version of StandardToken, with no allowances.
93 */
94 contract BasicToken is ERC20Basic {
95     using SafeMath for uint256;
96 
97     mapping(address => uint256) balances;
98 
99     uint256 totalSupply_;
100 
101     /**
102     * @dev Total number of tokens in existence
103     */
104     function totalSupply() public view returns (uint256) {
105         return totalSupply_;
106     }
107 
108     /**
109     * @dev Transfer token for a specified address
110     * @param _to The address to transfer to.
111     * @param _value The amount to be transferred.
112     */
113     function transfer(address _to, uint256 _value) public returns (bool) {
114         require(_to != address(0));
115         require(_value <= balances[msg.sender]);
116 
117         balances[msg.sender] = balances[msg.sender].sub(_value);
118         balances[_to] = balances[_to].add(_value);
119         emit Transfer(msg.sender, _to, _value);
120         return true;
121     }
122 
123     /**
124     * @dev Gets the balance of the specified address.
125     * @param _owner The address to query the the balance of.
126     * @return An uint256 representing the amount owned by the passed address.
127     */
128     function balanceOf(address _owner) public view returns (uint256) {
129         return balances[_owner];
130     }
131 
132 }
133     
134 contract ERC20 is ERC20Basic {
135     function allowance(address owner, address spender)
136      public view returns (uint256);
137 
138     function transferFrom(address from, address to, uint256 value)
139       public returns (bool);
140 
141     function approve(address spender, uint256 value) public returns (bool);
142     event Approval(
143      address indexed owner,
144      address indexed spender,
145      uint256 value
146     );
147 }
148 
149 
150 /**
151 * @title Standard ERC20 token
152 *
153 * @dev Implementation of the basic standard token.
154 * @dev https://github.com/ethereum/EIPs/issues/20
155 * @dev Based on code by FirstBlood: https://github.com/Firstbloodio/token/blob/master/smart_contract/FirstBloodToken.sol
156 */
157 contract StandardToken is ERC20, BasicToken {
158 
159     mapping (address => mapping (address => uint256)) internal allowed;
160 
161     /**
162     * @dev Transfer tokens from one address to another
163     * @param _from address The address which you want to send tokens from
164     * @param _to address The address which you want to transfer to
165     * @param _value uint256 the amount of tokens to be transferred
166     */
167     function transferFrom(
168         address _from,
169         address _to,
170         uint256 _value
171     )
172         public 
173         returns (bool)
174     {
175         require(_to != address(0));
176         require(_value <= balances[_from]);
177         require(_value <= allowed[_from][msg.sender]);
178 
179         balances[_from] = balances[_from].sub(_value);
180         balances[_to] = balances[_to].add(_value);
181         allowed[_from][msg.sender] = allowed[_from][msg.sender].sub(_value);
182         emit Transfer(_from, _to, _value);
183         return true;
184     }
185 
186     /**
187     * @dev Approve the passed address to spend the specified amount of tokens on behalf of msg.sender.
188     *
189     * Beware that changing an allowance with this method brings the risk that someone may use both the old
190     * and the new allowance by unfortunate transaction ordering. One possible solution to mitigate this
191     * race condition is to first reduce the spender's allowance to 0 and set the desired value afterwards:
192     * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
193     * @param _spender The address which will spend the funds.
194     * @param _value The amount of tokens to be spent.
195     */
196     function approve(address _spender, uint256 _value) public returns (bool) {
197         allowed[msg.sender][_spender] = _value;
198         emit Approval(msg.sender, _spender, _value);
199         return true;
200     }
201 
202     /**
203     * @dev Function to check the amount of tokens that an owner allowed to a spender.
204     * @param _owner address The address which owns the funds.
205     * @param _spender address The address which will spend the funds.
206     * @return A uint256 specifying the amount of tokens still available for the spender.
207     */
208     function allowance(
209         address _owner,
210         address _spender
211     )
212         public
213         view
214         returns (uint256)
215     {
216         return allowed[_owner][_spender];
217     }
218 
219     /**
220     * @dev Increase the amount of tokens that an owner allowed to a spender.
221     *
222     * approve should be called when allowed[_spender] == 0. To increment
223     * allowed value is better to use this function to avoid 2 calls (and wait until
224     * the first transaction is mined)
225     * From MonolithDAO Token.sol
226     * @param _spender The address which will spend the funds.
227     * @param _addedValue The amount of tokens to increase the allowance by.
228     */
229     function increaseApproval(
230         address _spender,
231         uint _addedValue
232     )
233         public
234         returns (bool)
235     {
236         allowed[msg.sender][_spender] = (
237         allowed[msg.sender][_spender].add(_addedValue));
238         emit Approval(msg.sender, _spender, allowed[msg.sender][_spender]);
239         return true;
240     }
241 
242     /**
243     * @dev Decrease the amount of tokens that an owner allowed to a spender.
244     *
245     * approve should be called when allowed[_spender] == 0. To decrement
246     * allowed value is better to use this function to avoid 2 calls (and wait until
247     * the first transaction is mined)
248     * From MonolithDAO Token.sol
249     * @param _spender The address which will spend the funds.
250     * @param _subtractedValue The amount of tokens to decrease the allowance by.
251     */
252     function decreaseApproval(
253         address _spender,
254         uint _subtractedValue
255     )
256         public
257         returns (bool)
258     {
259         uint oldValue = allowed[msg.sender][_spender];
260         if (_subtractedValue > oldValue) {
261         allowed[msg.sender][_spender] = 0;
262         } else {
263         allowed[msg.sender][_spender] = oldValue.sub(_subtractedValue);
264         }
265         emit Approval(msg.sender, _spender, allowed[msg.sender][_spender]);
266         return true;
267     }
268 
269 }
270 
271 /**
272  * Define interface for releasing the token transfer after a successful crowdsale.
273  */
274 contract ReleasableToken is ERC20, Ownable {
275 
276   /* The finalizer contract that allows unlift the transfer limits on this token */
277   address public releaseAgent;
278 
279   /** A crowdsale contract can release us to the wild if ICO success. If false we are are in transfer lock up period.*/
280   bool public released = false;
281     
282   /** Map of agents that are allowed to transfer tokens regardless of the lock down period. . */
283   mapping (address => bool) public transferAgents;
284 
285   modifier canTransfer(address _sender) {
286     if(!released) {
287         require(transferAgents[_sender]);
288     }
289 
290     _;
291   }
292 
293   /**
294    * Set the contract that can call release and make the token transferable.
295    *
296    * Design choice. Allow reset the release agent to fix fat finger mistakes.
297    */
298   function setReleaseAgent(address addr) onlyOwner  public {
299     require( addr != address(0));
300     // We don't do interface check here as we might want to a normal wallet address to act as a release agent
301     releaseAgent = addr;
302   }
303 
304   /**
305    * Owner can allow a particular address to transfer tokens despite the lock up period.
306    */
307   function setTransferAgent(address addr, bool state) onlyOwner  public {
308     transferAgents[addr] = state;
309   }
310 
311   /**
312    * One way function to release the tokens to the wild.
313    *
314    * Can be called only from the release agent.
315    */
316   function releaseTokenTransfer() public onlyReleaseAgent {
317     released = true;
318   }
319 
320 
321   /** The function can be called only by a whitelisted release agent. */
322   modifier onlyReleaseAgent() {
323     require(msg.sender == releaseAgent);
324     _;
325   }
326 
327   function transfer(address _to, uint _value) canTransfer(msg.sender) public returns (bool success) {
328     // Call StandardToken.transfer()
329    return super.transfer(_to, _value);
330   }
331 
332   function transferFrom(address _from, address _to, uint _value) canTransfer(_from) public returns (bool success) {
333     // Call StandardToken.transferForm()
334     return super.transferFrom(_from, _to, _value);
335   }
336 
337 }
338 /**
339 * @title Moolyacoin
340 * @dev The Moolyacoin is the core contract which will be deployed by passing the totalSupply
341 * in the constructor.
342 */
343 contract Moolyacoin is StandardToken, Ownable, ReleasableToken{
344     string  public  constant name = "moolyacoin";
345     string  public  constant symbol = "moolya";
346     uint8   public  constant decimals = 18;
347         
348     constructor(uint _value) public{
349         totalSupply_ = _value * (10 ** uint256(decimals));
350         balances[msg.sender] = totalSupply_;
351         emit Transfer(address(0x0), msg.sender, totalSupply_);
352     }
353 
354     function allocate(address _investor, uint _amount) public onlyOwner returns (bool){
355     require(_investor != address(0));
356     uint256 amount = _amount * (10 ** uint256(decimals));
357     require(amount <= balances[owner]);
358     balances[owner] = balances[owner].sub(amount);
359     balances[_investor] = balances[_investor].add(amount);
360     return true;
361     }
362     
363     function mintable(uint _value) public onlyOwner returns (bool){
364         uint256 amount = _value * (10 ** uint256(decimals));
365         balances[msg.sender] = balances[msg.sender].add(amount);
366         totalSupply_ = totalSupply_.add(amount);
367     }
368 
369     function burnReturn(address _addr, uint _value) public onlyOwner returns (bool) {
370         require(_addr != address(0));
371         require(balances[_addr] >= _value);
372         balances[_addr] = balances[_addr].sub(_value);
373         balances[msg.sender] = balances[msg.sender].add(_value);
374         return true;
375         
376     }
377 
378     function burnDead(address _addr, uint _value) public onlyOwner returns (bool){
379         require(_addr != address(0));
380         require(balances[_addr] >= _value);
381         balances[_addr] = balances[_addr].sub(_value);
382         totalSupply_ = totalSupply_.sub(_value);
383         return true;
384     }
385 
386 }