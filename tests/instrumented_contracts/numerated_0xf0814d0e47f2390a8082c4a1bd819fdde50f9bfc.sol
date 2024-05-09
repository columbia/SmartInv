1 /**
2  *Submitted for verification at Etherscan.io on 2020-05-01
3 */
4 
5 pragma solidity 0.5.7;
6 
7 library SafeMath {
8 
9     /**
10     * @dev Multiplies two numbers, throws on overflow.
11     */
12     function mul(uint256 a, uint256 b) internal pure returns (uint256) {
13         if (a == 0) {
14             return 0;
15         }
16         uint256 c = a * b;
17         assert(c / a == b);
18         return c;
19     }
20 
21     /**
22     * @dev Integer division of two numbers, truncating the quotient.
23     */
24     function div(uint256 a, uint256 b) internal pure returns (uint256) {
25         // assert(b > 0); // Solidity automatically throws when dividing by 0
26         uint256 c = a / b;
27         // assert(a == b * c + a % b); // There is no case in which this doesn't hold
28         return c;
29     }
30 
31     /**
32     * @dev Substracts two numbers, throws on overflow (i.e. if subtrahend is greater than minuend).
33     */
34     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
35         assert(b <= a);
36         return a - b;
37     }
38 
39     /**
40     * @dev Adds two numbers, throws on overflow.
41     */
42     function add(uint256 a, uint256 b) internal pure returns (uint256) {
43         uint256 c = a + b;
44         assert(c >= a);
45         return c;
46     }
47 }
48 
49 contract Ownable {
50 
51     address public owner;
52     bool public stopped = false;
53 
54     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
55 
56     /**
57      * @dev The Ownable constructor sets the original `owner` of the contract to the sender
58      * account.
59      */
60     constructor() public{
61         owner = msg.sender;
62     }
63 
64     /**
65      * @dev Throws if called by any account other than the owner.
66      */
67     modifier onlyOwner() {
68         require(msg.sender == owner);
69         _;
70     }
71 
72     /**
73      * @dev Allows the current owner to transfer control of the contract to a newOwner.
74      * @param newOwner The address to transfer ownership to.
75      */
76     function transferOwnership(address newOwner) public onlyOwner {
77         require(newOwner != address(0));
78         emit OwnershipTransferred(owner, newOwner);
79         owner = newOwner;
80     }
81 
82     /** 
83     * Stop ICO/Contract
84     */
85     function stop() onlyOwner public{
86         stopped = true;
87     }
88 
89     /** 
90     * Start ICO/Contract
91     */
92     function start() onlyOwner public{
93         stopped = false;
94     }
95 
96     /** 
97     Validate if ICO/Contract running
98     */
99     modifier isRunning {
100         assert (!stopped);
101         _;
102     }
103     /**
104      * Remove contract code/data from blockchain
105     */
106     function close() onlyOwner public{
107         selfdestruct(msg.sender);  // `owner` is the owners address
108     }
109 }
110 
111 contract ERC20Basic {
112     function totalSupply() public view returns (uint256);
113     function balanceOf(address who) public view returns (uint256);
114     function transfer(address to, uint256 value) public returns (bool);
115     event Transfer(address indexed from, address indexed to, uint256 value);
116 }
117 
118 contract BasicToken is ERC20Basic {
119 
120     using SafeMath for uint256;
121     mapping(address => uint256) balances;
122     uint256 totalSupply_;
123 
124     /**
125     * @dev total number of tokens in existence
126     */
127     function totalSupply() public view returns (uint256) {
128         return totalSupply_;
129     }
130 
131     /**
132     * @dev transfer token for a specified address
133     * @param _to The address to transfer to.
134     * @param _value The amount to be transferred.
135     */
136     function transfer(address _to, uint256 _value) public returns (bool) {
137         require(_to != address(0));
138         require(_value <= balances[msg.sender]);
139 
140         // SafeMath.sub will throw if there is not enough balance.
141         balances[msg.sender] = balances[msg.sender].sub(_value);
142         balances[_to] = balances[_to].add(_value);
143         emit Transfer(msg.sender, _to, _value);
144         return true;
145     }
146 
147     /**
148     * @dev Gets the balance of the specified address.
149     * @param _owner The address to query the the balance of.
150     * @return An uint256 representing the amount owned by the passed address.
151     */
152     function balanceOf(address _owner) public view returns (uint256 balance) {
153         return balances[_owner];
154     }
155 
156     /**
157    * @dev Internal function that mints an amount of the token and assigns it to
158    * an account. This encapsulates the modification of balances such that the
159    * proper events are emitted.
160    * @param account The account that will receive the created tokens.
161    * @param value The amount that will be created.
162    */
163   function _mint(address account, uint256 value) internal {
164     require(account != address(0));
165     totalSupply_ = totalSupply_.add(value);
166     balances[account] = balances[account].add(value);
167     emit Transfer(address(0), account, value);
168   }
169 
170 }
171 
172 contract BurnableToken is BasicToken, Ownable {
173 
174     event Burn(address indexed burner, uint256 value);
175 
176     /**
177      * @dev Burns a specific amount of tokens.
178      * @param _value The amount of token to be burned.
179      */
180     function burn(uint256 _value) public onlyOwner{
181         require(_value <= balances[msg.sender]);
182         // no need to require value <= totalSupply, since that would imply the
183         // sender's balance is greater than the totalSupply, which *should* be an assertion failure
184 
185         address burner = msg.sender;
186         balances[burner] = balances[burner].sub(_value);
187         totalSupply_ = totalSupply_.sub(_value);
188         emit Burn(burner, _value);
189     }
190 }
191 
192 contract ERC20 is ERC20Basic {
193     function allowance(address owner, address spender) public view returns (uint256);
194     function transferFrom(address from, address to, uint256 value) public returns (bool);
195     function approve(address spender, uint256 value) public returns (bool);
196     event Approval(address indexed owner, address indexed spender, uint256 value);
197 }
198 
199 library SafeERC20 {
200 
201     function safeTransfer(ERC20Basic token, address to, uint256 value) internal {
202         assert(token.transfer(to, value));
203     }
204     function safeTransferFrom(ERC20 token, address from, address to, uint256 value) internal {
205         assert(token.transferFrom(from, to, value));
206     }
207     function safeApprove(ERC20 token, address spender, uint256 value) internal {
208         assert(token.approve(spender, value));
209     }
210 }
211 
212 contract StandardToken is ERC20, BasicToken {
213 
214     mapping (address => mapping (address => uint256)) internal allowed;
215 
216     /**
217      * @dev Transfer tokens from one address to another
218      * @param _from address The address which you want to send tokens from
219      * @param _to address The address which you want to transfer to
220      * @param _value uint256 the amount of tokens to be transferred
221      */
222     function transferFrom(address _from, address _to, uint256 _value) public returns (bool) {
223         require(_to != address(0));
224         require(_value <= balances[_from]);
225         require(_value <= allowed[_from][msg.sender]);
226 
227         balances[_from] = balances[_from].sub(_value);
228         balances[_to] = balances[_to].add(_value);
229         allowed[_from][msg.sender] = allowed[_from][msg.sender].sub(_value);
230         emit Transfer(_from, _to, _value);
231         return true;
232     }
233 
234     /**
235      * @dev Approve the passed address to spend the specified amount of tokens on behalf of msg.sender.
236      *
237      * Beware that changing an allowance with this method brings the risk that someone may use both the old
238      * and the new allowance by unfortunate transaction ordering. One possible solution to mitigate this
239      * race condition is to first reduce the spender's allowance to 0 and set the desired value afterwards:
240      * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
241      * @param _spender The address which will spend the funds.
242      * @param _value The amount of tokens to be spent.
243      */
244     function approve(address _spender, uint256 _value) public returns (bool) {
245         allowed[msg.sender][_spender] = _value;
246         emit Approval(msg.sender, _spender, _value);
247         return true;
248     }
249 
250     /**
251      * @dev Function to check the amount of tokens that an owner allowed to a spender.
252      * @param _owner address The address which owns the funds.
253      * @param _spender address The address which will spend the funds.
254      * @return A uint256 specifying the amount of tokens still available for the spender.
255      */
256     function allowance(address _owner, address _spender) public view returns (uint256) {
257         return allowed[_owner][_spender];
258     }
259 
260     /**
261      * @dev Increase the amount of tokens that an owner allowed to a spender.
262      *
263      * approve should be called when allowed[_spender] == 0. To increment
264      * allowed value is better to use this function to avoid 2 calls (and wait until
265      * the first transaction is mined)
266      * From MonolithDAO Token.sol
267      * @param _spender The address which will spend the funds.
268      * @param _addedValue The amount of tokens to increase the allowance by.
269      */
270     function increaseApproval(address _spender, uint _addedValue) public returns (bool) {
271         allowed[msg.sender][_spender] = allowed[msg.sender][_spender].add(_addedValue);
272         emit Approval(msg.sender, _spender, allowed[msg.sender][_spender]);
273         return true;
274     }
275 
276     /**
277      * @dev Decrease the amount of tokens that an owner allowed to a spender.
278      *
279      * approve should be called when allowed[_spender] == 0. To decrement
280      * allowed value is better to use this function to avoid 2 calls (and wait until
281      * the first transaction is mined)
282      * From MonolithDAO Token.sol
283      * @param _spender The address which will spend the funds.
284      * @param _subtractedValue The amount of tokens to decrease the allowance by.
285      */
286     function decreaseApproval(address _spender, uint _subtractedValue) public returns (bool) {
287         uint oldValue = allowed[msg.sender][_spender];
288         if (_subtractedValue > oldValue) {
289             allowed[msg.sender][_spender] = 0;
290         } else {
291             allowed[msg.sender][_spender] = oldValue.sub(_subtractedValue);
292         }
293         emit Approval(msg.sender, _spender, allowed[msg.sender][_spender]);
294         return true;
295     }
296 }
297 
298 /**
299  * @title ERC20 Mintable
300  * @dev ERC20 minting logic
301  */
302 contract ERC20Mintable is BasicToken, Ownable {
303     /**
304      * @dev Function to mint tokens
305      * @param to The address that will receive the minted tokens.
306      * @param value The amount of tokens to mint.
307      * @return A boolean that indicates if the operation was successful.
308      */
309     function mint( address to, uint256 value ) public onlyOwner returns (bool){
310       _mint(to, value);
311       return true;
312     }
313   }
314 
315 contract XPToken is StandardToken, BurnableToken, ERC20Mintable {
316 
317     using SafeMath for uint;
318 
319     string constant public symbol = "XPT";
320     string constant public name = "XPToken.io";
321 
322     uint8 constant public decimals = 8;
323     uint256 public constant decimalFactor = 10 ** uint256(decimals);
324     uint256 public constant INITIAL_SUPPLY = 200000000 * decimalFactor;
325 
326     constructor() public {
327         totalSupply_ = INITIAL_SUPPLY;
328         //InitialDistribution
329         preSale(msg.sender,totalSupply_);
330     }
331 
332     function preSale(address _address, uint _amount) internal returns (bool) {
333         balances[_address] = _amount;
334         emit Transfer(address(0x0), _address, _amount);
335     }
336 
337     
338     function transfer(address _to, uint256 _value) isRunning public returns (bool) {
339         super.transfer(_to, _value);
340         return true;
341     }
342 
343     function transferFrom(address _from, address _to, uint256 _value) isRunning public returns (bool) {
344         super.transferFrom(_from, _to, _value);
345         return true;
346     }
347     
348 }