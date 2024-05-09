1 /**
2  *Submitted for verification at Etherscan.io on 2019-04-26
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
103 }
104 
105 contract ERC20Basic {
106     function totalSupply() public view returns (uint256);
107     function balanceOf(address who) public view returns (uint256);
108     function transfer(address to, uint256 value) public returns (bool);
109     event Transfer(address indexed from, address indexed to, uint256 value);
110 }
111 
112 contract BasicToken is ERC20Basic {
113 
114     using SafeMath for uint256;
115     mapping(address => uint256) balances;
116     uint256 totalSupply_;
117 
118     /**
119     * @dev total number of tokens in existence
120     */
121     function totalSupply() public view returns (uint256) {
122         return totalSupply_;
123     }
124 
125     /**
126     * @dev transfer token for a specified address
127     * @param _to The address to transfer to.
128     * @param _value The amount to be transferred.
129     */
130     function transfer(address _to, uint256 _value) public returns (bool) {
131         require(_to != address(0));
132         require(_value <= balances[msg.sender]);
133 
134         // SafeMath.sub will throw if there is not enough balance.
135         balances[msg.sender] = balances[msg.sender].sub(_value);
136         balances[_to] = balances[_to].add(_value);
137         emit Transfer(msg.sender, _to, _value);
138         return true;
139     }
140 
141     /**
142     * @dev Gets the balance of the specified address.
143     * @param _owner The address to query the the balance of.
144     * @return An uint256 representing the amount owned by the passed address.
145     */
146     function balanceOf(address _owner) public view returns (uint256 balance) {
147         return balances[_owner];
148     }
149 
150     /**
151    * @dev Internal function that mints an amount of the token and assigns it to
152    * an account. This encapsulates the modification of balances such that the
153    * proper events are emitted.
154    * @param account The account that will receive the created tokens.
155    * @param value The amount that will be created.
156    */
157   function _mint(address account, uint256 value) internal {
158     require(account != address(0));
159     totalSupply_ = totalSupply_.add(value);
160     balances[account] = balances[account].add(value);
161     emit Transfer(address(0), account, value);
162   }
163 
164 }
165 
166 contract BurnableToken is BasicToken, Ownable {
167 
168     event Burn(address indexed burner, uint256 value);
169 
170     /**
171      * @dev Burns a specific amount of tokens.
172      * @param _value The amount of token to be burned.
173      */
174     function burn(uint256 _value) public onlyOwner{
175         require(_value <= balances[msg.sender]);
176         // no need to require value <= totalSupply, since that would imply the
177         // sender's balance is greater than the totalSupply, which *should* be an assertion failure
178 
179         address burner = msg.sender;
180         balances[burner] = balances[burner].sub(_value);
181         totalSupply_ = totalSupply_.sub(_value);
182         emit Burn(burner, _value);
183     }
184 }
185 
186 contract ERC20 is ERC20Basic {
187     function allowance(address owner, address spender) public view returns (uint256);
188     function transferFrom(address from, address to, uint256 value) public returns (bool);
189     function approve(address spender, uint256 value) public returns (bool);
190     event Approval(address indexed owner, address indexed spender, uint256 value);
191 }
192 
193 library SafeERC20 {
194 
195     function safeTransfer(ERC20Basic token, address to, uint256 value) internal {
196         assert(token.transfer(to, value));
197     }
198     function safeTransferFrom(ERC20 token, address from, address to, uint256 value) internal {
199         assert(token.transferFrom(from, to, value));
200     }
201     function safeApprove(ERC20 token, address spender, uint256 value) internal {
202         assert(token.approve(spender, value));
203     }
204 }
205 
206 contract StandardToken is ERC20, BasicToken {
207 
208     mapping (address => mapping (address => uint256)) internal allowed;
209 
210     /**
211      * @dev Transfer tokens from one address to another
212      * @param _from address The address which you want to send tokens from
213      * @param _to address The address which you want to transfer to
214      * @param _value uint256 the amount of tokens to be transferred
215      */
216     function transferFrom(address _from, address _to, uint256 _value) public returns (bool) {
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
229      * @dev Approve the passed address to spend the specified amount of tokens on behalf of msg.sender.
230      *
231      * Beware that changing an allowance with this method brings the risk that someone may use both the old
232      * and the new allowance by unfortunate transaction ordering. One possible solution to mitigate this
233      * race condition is to first reduce the spender's allowance to 0 and set the desired value afterwards:
234      * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
235      * @param _spender The address which will spend the funds.
236      * @param _value The amount of tokens to be spent.
237      */
238     function approve(address _spender, uint256 _value) public returns (bool) {
239         allowed[msg.sender][_spender] = _value;
240         emit Approval(msg.sender, _spender, _value);
241         return true;
242     }
243 
244     /**
245      * @dev Function to check the amount of tokens that an owner allowed to a spender.
246      * @param _owner address The address which owns the funds.
247      * @param _spender address The address which will spend the funds.
248      * @return A uint256 specifying the amount of tokens still available for the spender.
249      */
250     function allowance(address _owner, address _spender) public view returns (uint256) {
251         return allowed[_owner][_spender];
252     }
253 
254     /**
255      * @dev Increase the amount of tokens that an owner allowed to a spender.
256      *
257      * approve should be called when allowed[_spender] == 0. To increment
258      * allowed value is better to use this function to avoid 2 calls (and wait until
259      * the first transaction is mined)
260      * From MonolithDAO Token.sol
261      * @param _spender The address which will spend the funds.
262      * @param _addedValue The amount of tokens to increase the allowance by.
263      */
264     function increaseApproval(address _spender, uint _addedValue) public returns (bool) {
265         allowed[msg.sender][_spender] = allowed[msg.sender][_spender].add(_addedValue);
266         emit Approval(msg.sender, _spender, allowed[msg.sender][_spender]);
267         return true;
268     }
269 
270     /**
271      * @dev Decrease the amount of tokens that an owner allowed to a spender.
272      *
273      * approve should be called when allowed[_spender] == 0. To decrement
274      * allowed value is better to use this function to avoid 2 calls (and wait until
275      * the first transaction is mined)
276      * From MonolithDAO Token.sol
277      * @param _spender The address which will spend the funds.
278      * @param _subtractedValue The amount of tokens to decrease the allowance by.
279      */
280     function decreaseApproval(address _spender, uint _subtractedValue) public returns (bool) {
281         uint oldValue = allowed[msg.sender][_spender];
282         if (_subtractedValue > oldValue) {
283             allowed[msg.sender][_spender] = 0;
284         } else {
285             allowed[msg.sender][_spender] = oldValue.sub(_subtractedValue);
286         }
287         emit Approval(msg.sender, _spender, allowed[msg.sender][_spender]);
288         return true;
289     }
290 }
291 
292 /**
293  * @title ERC20 Mintable
294  * @dev ERC20 minting logic
295  */
296 contract ERC20Mintable is BasicToken, Ownable {
297     /**
298      * @dev Function to mint tokens
299      * @param to The address that will receive the minted tokens.
300      * @param value The amount of tokens to mint.
301      * @return A boolean that indicates if the operation was successful.
302      */
303     function mint( address to, uint256 value ) public onlyOwner returns (bool){
304       _mint(to, value);
305       return true;
306     }
307   }
308 
309 contract ResourcesToken is StandardToken, BurnableToken, ERC20Mintable {
310 
311     using SafeMath for uint;
312 
313     string constant public symbol = "RST";
314     string constant public name = "Resources Token";
315 
316     uint8 constant public decimals = 8;
317     uint256 public constant decimalFactor = 10 ** uint256(decimals);
318     uint256 public constant INITIAL_SUPPLY = 660000000 * decimalFactor;
319 
320     constructor(address ownerAdrs) public {
321         totalSupply_ = INITIAL_SUPPLY;
322         //InitialDistribution
323         preSale(ownerAdrs,totalSupply_);
324     }
325 
326     function preSale(address _address, uint _amount) internal returns (bool) {
327         balances[_address] = _amount;
328         emit Transfer(address(0x0), _address, _amount);
329     }
330 
331     
332     function transfer(address _to, uint256 _value) isRunning public returns (bool) {
333         super.transfer(_to, _value);
334         return true;
335     }
336 
337     function transferFrom(address _from, address _to, uint256 _value) isRunning public returns (bool) {
338         super.transferFrom(_from, _to, _value);
339         return true;
340     }
341     
342 }