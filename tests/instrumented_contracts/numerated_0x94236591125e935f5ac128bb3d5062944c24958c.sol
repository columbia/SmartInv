1 pragma solidity ^0.4.23;
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
46     address public owner;
47     bool public stopped = false;
48 
49     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
50 
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
109     using SafeMath for uint256;
110 
111     mapping(address => uint256) balances;
112 
113     uint256 totalSupply_;
114 
115     /**
116     * @dev total number of tokens in existence
117     */
118     function totalSupply() public view returns (uint256) {
119         return totalSupply_;
120     }
121 
122     /**
123     * @dev transfer token for a specified address
124     * @param _to The address to transfer to.
125     * @param _value The amount to be transferred.
126     */
127     function transfer(address _to, uint256 _value) public returns (bool) {
128         require(_to != address(0));
129         require(_value <= balances[msg.sender]);
130 
131         // SafeMath.sub will throw if there is not enough balance.
132         balances[msg.sender] = balances[msg.sender].sub(_value);
133         balances[_to] = balances[_to].add(_value);
134         emit Transfer(msg.sender, _to, _value);
135         return true;
136     }
137 
138     /**
139     * @dev Gets the balance of the specified address.
140     * @param _owner The address to query the the balance of.
141     * @return An uint256 representing the amount owned by the passed address.
142     */
143     function balanceOf(address _owner) public view returns (uint256 balance) {
144         return balances[_owner];
145     }
146 
147 }
148 
149 contract BurnableToken is BasicToken, Ownable {
150 
151     event Burn(address indexed burner, uint256 value);
152 
153     /**
154      * @dev Burns a specific amount of tokens.
155      * @param _value The amount of token to be burned.
156      */
157     function burn(uint256 _value) public onlyOwner{
158         require(_value <= balances[msg.sender]);
159         // no need to require value <= totalSupply, since that would imply the
160         // sender's balance is greater than the totalSupply, which *should* be an assertion failure
161 
162         address burner = msg.sender;
163         balances[burner] = balances[burner].sub(_value);
164         totalSupply_ = totalSupply_.sub(_value);
165         emit Burn(burner, _value);
166     }
167 }
168 
169 contract ERC20 is ERC20Basic {
170     function allowance(address owner, address spender) public view returns (uint256);
171     function transferFrom(address from, address to, uint256 value) public returns (bool);
172     function approve(address spender, uint256 value) public returns (bool);
173     event Approval(address indexed owner, address indexed spender, uint256 value);
174 }
175 
176 library SafeERC20 {
177     function safeTransfer(ERC20Basic token, address to, uint256 value) internal {
178         assert(token.transfer(to, value));
179     }
180 
181     function safeTransferFrom(ERC20 token, address from, address to, uint256 value) internal {
182         assert(token.transferFrom(from, to, value));
183     }
184 
185     function safeApprove(ERC20 token, address spender, uint256 value) internal {
186         assert(token.approve(spender, value));
187     }
188 }
189 
190 contract StandardToken is ERC20, BasicToken {
191 
192     mapping (address => mapping (address => uint256)) internal allowed;
193 
194     /**
195      * @dev Transfer tokens from one address to another
196      * @param _from address The address which you want to send tokens from
197      * @param _to address The address which you want to transfer to
198      * @param _value uint256 the amount of tokens to be transferred
199      */
200     function transferFrom(address _from, address _to, uint256 _value) public returns (bool) {
201         require(_to != address(0));
202         require(_value <= balances[_from]);
203         require(_value <= allowed[_from][msg.sender]);
204 
205         balances[_from] = balances[_from].sub(_value);
206         balances[_to] = balances[_to].add(_value);
207         allowed[_from][msg.sender] = allowed[_from][msg.sender].sub(_value);
208         emit Transfer(_from, _to, _value);
209         return true;
210     }
211 
212     /**
213      * @dev Approve the passed address to spend the specified amount of tokens on behalf of msg.sender.
214      *
215      * Beware that changing an allowance with this method brings the risk that someone may use both the old
216      * and the new allowance by unfortunate transaction ordering. One possible solution to mitigate this
217      * race condition is to first reduce the spender's allowance to 0 and set the desired value afterwards:
218      * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
219      * @param _spender The address which will spend the funds.
220      * @param _value The amount of tokens to be spent.
221      */
222     function approve(address _spender, uint256 _value) public returns (bool) {
223         allowed[msg.sender][_spender] = _value;
224         emit Approval(msg.sender, _spender, _value);
225         return true;
226     }
227 
228     /**
229      * @dev Function to check the amount of tokens that an owner allowed to a spender.
230      * @param _owner address The address which owns the funds.
231      * @param _spender address The address which will spend the funds.
232      * @return A uint256 specifying the amount of tokens still available for the spender.
233      */
234     function allowance(address _owner, address _spender) public view returns (uint256) {
235         return allowed[_owner][_spender];
236     }
237 
238     /**
239      * @dev Increase the amount of tokens that an owner allowed to a spender.
240      *
241      * approve should be called when allowed[_spender] == 0. To increment
242      * allowed value is better to use this function to avoid 2 calls (and wait until
243      * the first transaction is mined)
244      * From MonolithDAO Token.sol
245      * @param _spender The address which will spend the funds.
246      * @param _addedValue The amount of tokens to increase the allowance by.
247      */
248     function increaseApproval(address _spender, uint _addedValue) public returns (bool) {
249         allowed[msg.sender][_spender] = allowed[msg.sender][_spender].add(_addedValue);
250         emit Approval(msg.sender, _spender, allowed[msg.sender][_spender]);
251         return true;
252     }
253 
254     /**
255      * @dev Decrease the amount of tokens that an owner allowed to a spender.
256      *
257      * approve should be called when allowed[_spender] == 0. To decrement
258      * allowed value is better to use this function to avoid 2 calls (and wait until
259      * the first transaction is mined)
260      * From MonolithDAO Token.sol
261      * @param _spender The address which will spend the funds.
262      * @param _subtractedValue The amount of tokens to decrease the allowance by.
263      */
264     function decreaseApproval(address _spender, uint _subtractedValue) public returns (bool) {
265         uint oldValue = allowed[msg.sender][_spender];
266         if (_subtractedValue > oldValue) {
267             allowed[msg.sender][_spender] = 0;
268         } else {
269             allowed[msg.sender][_spender] = oldValue.sub(_subtractedValue);
270         }
271         emit Approval(msg.sender, _spender, allowed[msg.sender][_spender]);
272         return true;
273     }
274 }
275 
276 contract VGWToken is StandardToken, BurnableToken {
277 
278     using SafeMath for uint;    
279 
280     string constant public symbol = "VGW";
281     string constant public name = "VegaWallet";
282 
283     uint8 constant public decimals = 5;    
284     uint256 public constant decimalFactor = 10 ** uint256(decimals);
285     uint256 public constant INITIAL_SUPPLY = 200000000 * decimalFactor;
286 
287     uint constant ITSStartTime = 1537185600;  // Monday, Sep 17, 2018 12:00:00 AM
288     uint constant ITSEndTime = 1542369600;    // Friday, Nov 16, 2018 12:00:00 PM
289     uint constant unlockTimeF1 = 1550125800;  // Thursday, Feb 14, 2019 12.00.00 PM
290     uint constant unlockTimeF2 = 1565937000;  // Friday, August 16, 2019 12.00.00 PM
291 
292     uint256 constant publicTokens = 120000000 * decimalFactor;
293     uint256 constant investorTokens = 20000000 * decimalFactor;
294     uint256 constant founderTokens1 = 8750000 * decimalFactor;
295     uint256 constant founderTokens2 = 26250000 * decimalFactor;
296     uint256 constant devTokens = 25000000 * decimalFactor;
297 
298     address constant adrInvestor = 0x23Ce1F8d4926bd6d768815Cc45B1D4Fc7B920efB;
299     address constant adrFounder1 = 0xf56E5B449f2966fc3718AD6d44B9e75a94B6852b;
300     address constant adrFounder2 = 0x73EE65A92f551D613b77Ab6D72Ee08570cfC8Dc6;
301     address constant adrDevTeam = 0x8856D5434602a65933DBbb0636a19953AA5dcCa1;
302 
303     constructor(address owner) public {
304         totalSupply_ = INITIAL_SUPPLY;
305         //InitialDistribution
306         preSale(owner,publicTokens);
307         preSale(adrInvestor,investorTokens);
308         preSale(adrFounder1,founderTokens1);
309         preSale(adrFounder2,founderTokens2);
310         preSale(adrDevTeam,devTokens);
311     }
312 
313     function preSale(address _address, uint _amount) internal returns (bool) {
314         balances[_address] = _amount;
315         emit Transfer(address(0x0), _address, _amount);
316     }
317 
318     function checkPermissions(address _address) internal view returns (bool) {
319 
320         if( ( _address == adrInvestor || _address == adrDevTeam ) && ( block.timestamp < ITSEndTime ) ){
321             return false;
322         }else if( ( block.timestamp < unlockTimeF1 ) && ( _address == adrFounder1 ) ){
323             return false;
324         }else if( ( block.timestamp < unlockTimeF2 ) && ( _address == adrFounder2 ) ){
325             return false;
326         }else if ( _address == owner ){
327             return true;
328         }else if( block.timestamp < ITSEndTime ){
329             return false;
330         }else{
331             return true;
332         }
333     }
334 
335     function transfer(address _to, uint256 _value) isRunning public returns (bool) {
336 
337         require(checkPermissions(msg.sender));
338         super.transfer(_to, _value);
339     }
340 
341     function transferFrom(address _from, address _to, uint256 _value) isRunning public returns (bool) {
342 
343         require(checkPermissions(_from));
344         super.transferFrom(_from, _to, _value);
345     }
346 
347     function () public payable {
348         require(msg.value >= 1e16);
349         owner.transfer(msg.value);
350     }
351 }