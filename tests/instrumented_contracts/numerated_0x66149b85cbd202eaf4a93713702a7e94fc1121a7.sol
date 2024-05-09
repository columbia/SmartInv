1 pragma solidity 0.5.2;
2 
3 library SafeMath {
4 
5     /**
6     * @dev Multiplies two numbers, throws on overflow.
7     */
8     function mul(uint256 a, uint256 b) internal pure returns (uint256) {
9         if (a == 0) {
10             return 0;
11         }
12         uint256 c = a * b;
13         assert(c / a == b);
14         return c;
15     }
16 
17     /**
18     * @dev Integer division of two numbers, truncating the quotient.
19     */
20     function div(uint256 a, uint256 b) internal pure returns (uint256) {
21         // assert(b > 0); // Solidity automatically throws when dividing by 0
22         uint256 c = a / b;
23         // assert(a == b * c + a % b); // There is no case in which this doesn't hold
24         return c;
25     }
26 
27     /**
28     * @dev Substracts two numbers, throws on overflow (i.e. if subtrahend is greater than minuend).
29     */
30     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
31         assert(b <= a);
32         return a - b;
33     }
34 
35     /**
36     * @dev Adds two numbers, throws on overflow.
37     */
38     function add(uint256 a, uint256 b) internal pure returns (uint256) {
39         uint256 c = a + b;
40         assert(c >= a);
41         return c;
42     }
43 }
44 
45 contract Ownable {
46 
47     address public owner;
48     bool public stopped = false;
49 
50     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
51 
52     /**
53      * @dev The Ownable constructor sets the original `owner` of the contract to the sender
54      * account.
55      */
56     constructor() public{
57         owner = msg.sender;
58     }
59 
60     /**
61      * @dev Throws if called by any account other than the owner.
62      */
63     modifier onlyOwner() {
64         require(msg.sender == owner);
65         _;
66     }
67 
68     /**
69      * @dev Allows the current owner to transfer control of the contract to a newOwner.
70      * @param newOwner The address to transfer ownership to.
71      */
72     function transferOwnership(address newOwner) public onlyOwner {
73         require(newOwner != address(0));
74         emit OwnershipTransferred(owner, newOwner);
75         owner = newOwner;
76     }
77 
78     /** 
79     * Stop ICO contract
80     */
81     function stop() onlyOwner public{
82         stopped = true;
83     }
84 
85     /** 
86     * Start ICO contract
87     */
88     function start() onlyOwner public{
89         stopped = false;
90     }
91 
92     /** 
93     Validate if ICO running
94     */
95     modifier isRunning {
96         assert (!stopped);
97         _;
98     }
99 }
100 
101 contract ERC20Basic {
102     function totalSupply() public view returns (uint256);
103     function balanceOf(address who) public view returns (uint256);
104     function transfer(address to, uint256 value) public returns (bool);
105     event Transfer(address indexed from, address indexed to, uint256 value);
106 }
107 
108 contract BasicToken is ERC20Basic {
109 
110     using SafeMath for uint256;
111     mapping(address => uint256) balances;
112     uint256 totalSupply_;
113 
114     /**
115     * @dev total number of tokens in existence
116     */
117     function totalSupply() public view returns (uint256) {
118         return totalSupply_;
119     }
120 
121     /**
122     * @dev transfer token for a specified address
123     * @param _to The address to transfer to.
124     * @param _value The amount to be transferred.
125     */
126     function transfer(address _to, uint256 _value) public returns (bool) {
127         require(_to != address(0));
128         require(_value <= balances[msg.sender]);
129 
130         // SafeMath.sub will throw if there is not enough balance.
131         balances[msg.sender] = balances[msg.sender].sub(_value);
132         balances[_to] = balances[_to].add(_value);
133         emit Transfer(msg.sender, _to, _value);
134         return true;
135     }
136 
137     /**
138     * @dev Gets the balance of the specified address.
139     * @param _owner The address to query the the balance of.
140     * @return An uint256 representing the amount owned by the passed address.
141     */
142     function balanceOf(address _owner) public view returns (uint256 balance) {
143         return balances[_owner];
144     }
145 
146     /**
147    * @dev Internal function that mints an amount of the token and assigns it to
148    * an account. This encapsulates the modification of balances such that the
149    * proper events are emitted.
150    * @param account The account that will receive the created tokens.
151    * @param value The amount that will be created.
152    */
153   function _mint(address account, uint256 value) internal {
154     require(account != address(0));
155     totalSupply_ = totalSupply_.add(value);
156     balances[account] = balances[account].add(value);
157     emit Transfer(address(0), account, value);
158   }
159 
160 }
161 
162 contract BurnableToken is BasicToken, Ownable {
163 
164     event Burn(address indexed burner, uint256 value);
165 
166     /**
167      * @dev Burns a specific amount of tokens.
168      * @param _value The amount of token to be burned.
169      */
170     function burn(uint256 _value) public onlyOwner{
171         require(_value <= balances[msg.sender]);
172         // no need to require value <= totalSupply, since that would imply the
173         // sender's balance is greater than the totalSupply, which *should* be an assertion failure
174 
175         address burner = msg.sender;
176         balances[burner] = balances[burner].sub(_value);
177         totalSupply_ = totalSupply_.sub(_value);
178         emit Burn(burner, _value);
179     }
180 }
181 
182 contract ERC20 is ERC20Basic {
183     function allowance(address owner, address spender) public view returns (uint256);
184     function transferFrom(address from, address to, uint256 value) public returns (bool);
185     function approve(address spender, uint256 value) public returns (bool);
186     event Approval(address indexed owner, address indexed spender, uint256 value);
187 }
188 
189 library SafeERC20 {
190 
191     function safeTransfer(ERC20Basic token, address to, uint256 value) internal {
192         assert(token.transfer(to, value));
193     }
194     function safeTransferFrom(ERC20 token, address from, address to, uint256 value) internal {
195         assert(token.transferFrom(from, to, value));
196     }
197     function safeApprove(ERC20 token, address spender, uint256 value) internal {
198         assert(token.approve(spender, value));
199     }
200 }
201 
202 contract StandardToken is ERC20, BasicToken {
203 
204     mapping (address => mapping (address => uint256)) internal allowed;
205 
206     /**
207      * @dev Transfer tokens from one address to another
208      * @param _from address The address which you want to send tokens from
209      * @param _to address The address which you want to transfer to
210      * @param _value uint256 the amount of tokens to be transferred
211      */
212     function transferFrom(address _from, address _to, uint256 _value) public returns (bool) {
213         require(_to != address(0));
214         require(_value <= balances[_from]);
215         require(_value <= allowed[_from][msg.sender]);
216 
217         balances[_from] = balances[_from].sub(_value);
218         balances[_to] = balances[_to].add(_value);
219         allowed[_from][msg.sender] = allowed[_from][msg.sender].sub(_value);
220         emit Transfer(_from, _to, _value);
221         return true;
222     }
223 
224     /**
225      * @dev Approve the passed address to spend the specified amount of tokens on behalf of msg.sender.
226      *
227      * Beware that changing an allowance with this method brings the risk that someone may use both the old
228      * and the new allowance by unfortunate transaction ordering. One possible solution to mitigate this
229      * race condition is to first reduce the spender's allowance to 0 and set the desired value afterwards:
230      * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
231      * @param _spender The address which will spend the funds.
232      * @param _value The amount of tokens to be spent.
233      */
234     function approve(address _spender, uint256 _value) public returns (bool) {
235         allowed[msg.sender][_spender] = _value;
236         emit Approval(msg.sender, _spender, _value);
237         return true;
238     }
239 
240     /**
241      * @dev Function to check the amount of tokens that an owner allowed to a spender.
242      * @param _owner address The address which owns the funds.
243      * @param _spender address The address which will spend the funds.
244      * @return A uint256 specifying the amount of tokens still available for the spender.
245      */
246     function allowance(address _owner, address _spender) public view returns (uint256) {
247         return allowed[_owner][_spender];
248     }
249 
250     /**
251      * @dev Increase the amount of tokens that an owner allowed to a spender.
252      *
253      * approve should be called when allowed[_spender] == 0. To increment
254      * allowed value is better to use this function to avoid 2 calls (and wait until
255      * the first transaction is mined)
256      * From MonolithDAO Token.sol
257      * @param _spender The address which will spend the funds.
258      * @param _addedValue The amount of tokens to increase the allowance by.
259      */
260     function increaseApproval(address _spender, uint _addedValue) public returns (bool) {
261         allowed[msg.sender][_spender] = allowed[msg.sender][_spender].add(_addedValue);
262         emit Approval(msg.sender, _spender, allowed[msg.sender][_spender]);
263         return true;
264     }
265 
266     /**
267      * @dev Decrease the amount of tokens that an owner allowed to a spender.
268      *
269      * approve should be called when allowed[_spender] == 0. To decrement
270      * allowed value is better to use this function to avoid 2 calls (and wait until
271      * the first transaction is mined)
272      * From MonolithDAO Token.sol
273      * @param _spender The address which will spend the funds.
274      * @param _subtractedValue The amount of tokens to decrease the allowance by.
275      */
276     function decreaseApproval(address _spender, uint _subtractedValue) public returns (bool) {
277         uint oldValue = allowed[msg.sender][_spender];
278         if (_subtractedValue > oldValue) {
279             allowed[msg.sender][_spender] = 0;
280         } else {
281             allowed[msg.sender][_spender] = oldValue.sub(_subtractedValue);
282         }
283         emit Approval(msg.sender, _spender, allowed[msg.sender][_spender]);
284         return true;
285     }
286 }
287 
288 /**
289  * @title ERC20 Mintable
290  * @dev ERC20 minting logic
291  */
292 contract ERC20Mintable is BasicToken, Ownable {
293     /**
294      * @dev Function to mint tokens
295      * @param to The address that will receive the minted tokens.
296      * @param value The amount of tokens to mint.
297      * @return A boolean that indicates if the operation was successful.
298      */
299     function mint( address to, uint256 value ) public onlyOwner returns (bool){
300       _mint(to, value);
301       return true;
302     }
303   }
304 
305 contract CryptoxygenToken is StandardToken, BurnableToken, ERC20Mintable {
306 
307     using SafeMath for uint;
308 
309     string constant public symbol = "OXY2";
310     string constant public name = "Cryptoxygen";
311 
312     uint8 constant public decimals = 5;
313     uint256 public constant decimalFactor = 10 ** uint256(decimals);
314     uint256 public constant INITIAL_SUPPLY = 250000000 * decimalFactor;
315 
316     uint constant ITSStartTime = 1547553600;  // Tuesday, 15 January 2019 12:00:00
317     uint constant ITSEndTime = 1553256000;    // Friday, 22 March 2019 12:00:00
318     uint constant unlockTimeF1 = 1558440000; // Tuesday, 21 May 2019 12:00:00
319     uint constant unlockTimeF2 = 1561118400;  // Friday, 21 June 2019 12:00:00
320 
321     uint256 constant publicTokens  = 150000000 * decimalFactor;
322     uint256 constant devTokens = 45000000 * decimalFactor;
323     uint256 constant investorTokens= 15000000 * decimalFactor;
324     uint256 constant founderTokens1 = 20000000 * decimalFactor;
325     uint256 constant founderTokens2 = 10000000 * decimalFactor;
326     uint256 constant founderTokens3 = 10000000 * decimalFactor;
327 
328     address constant adrDev = 0xF14Eb018a5cAa6b22B67FFFfA61c9B78aB3957d2;
329     address constant adrInvestor = 0x2A7B09b90f8bDD22a9d66c83aDa49961827C1Dbe;
330     address constant adrFounder1 = 0x68293d5F4826E200A33055d183E73F4227ecEd99;
331     address constant adrFounder2 = 0xaE4dA48373f8CD3d54Dd3a8AAAa9aEc568ef29C6;
332     address constant adrFounder3 = 0x77264564D740245E377E263675bdDA2D23baaC97;
333 
334     constructor(address ownerAdrs) public {
335         totalSupply_ = INITIAL_SUPPLY;
336         //InitialDistribution
337         preSale(ownerAdrs,publicTokens);
338         
339         preSale(adrDev,devTokens);
340         preSale(adrInvestor,investorTokens);
341         preSale(adrFounder1,founderTokens1);
342         preSale(adrFounder2,founderTokens2);
343         preSale(adrFounder3,founderTokens3);
344     }
345 
346     function preSale(address _address, uint _amount) internal returns (bool) {
347         balances[_address] = _amount;
348         emit Transfer(address(0x0), _address, _amount);
349     }
350 
351     function checkPermissions(address _address) internal view returns (bool) {
352 
353         if( ( block.timestamp < unlockTimeF1 ) && ( _address == adrFounder1 || _address == adrFounder2 || _address == adrFounder3 ) ){
354             return false;
355         }else if( ( block.timestamp < unlockTimeF2 ) && ( _address == adrDev || _address == adrInvestor ) ){
356             return false;
357         }else if ( _address == owner ){
358             return true;
359         }else if( block.timestamp < ITSEndTime ){
360             return false;
361         }else{
362             return true;
363         }
364     }
365 
366     function transfer(address _to, uint256 _value) isRunning public returns (bool) {
367         require(checkPermissions(msg.sender));
368         super.transfer(_to, _value);
369         return true;
370     }
371 
372     function transferFrom(address _from, address _to, uint256 _value) isRunning public returns (bool) {
373         require(checkPermissions(_from));
374         super.transferFrom(_from, _to, _value);
375         return true;
376     }
377     
378 }