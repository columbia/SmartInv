1 pragma solidity 0.5.7;
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
79     * Stop ICO/Contract
80     */
81     function stop() onlyOwner public{
82         stopped = true;
83     }
84 
85     /** 
86     * Start ICO/Contract
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
146 }
147 
148 contract BurnableToken is BasicToken, Ownable {
149 
150     event Burn(address indexed burner, uint256 value);
151 
152     /**
153      * @dev Burns a specific amount of tokens.
154      * @param _value The amount of token to be burned.
155      */
156     function burn(uint256 _value) public onlyOwner{
157         require(_value <= balances[msg.sender]);
158         // no need to require value <= totalSupply, since that would imply the
159         // sender's balance is greater than the totalSupply, which *should* be an assertion failure
160 
161         address burner = msg.sender;
162         balances[burner] = balances[burner].sub(_value);
163         totalSupply_ = totalSupply_.sub(_value);
164         emit Burn(burner, _value);
165     }
166 }
167 
168 contract ERC20 is ERC20Basic {
169     function allowance(address owner, address spender) public view returns (uint256);
170     function transferFrom(address from, address to, uint256 value) public returns (bool);
171     function approve(address spender, uint256 value) public returns (bool);
172     event Approval(address indexed owner, address indexed spender, uint256 value);
173 }
174 
175 library SafeERC20 {
176 
177     function safeTransfer(ERC20Basic token, address to, uint256 value) internal {
178         assert(token.transfer(to, value));
179     }
180     function safeTransferFrom(ERC20 token, address from, address to, uint256 value) internal {
181         assert(token.transferFrom(from, to, value));
182     }
183     function safeApprove(ERC20 token, address spender, uint256 value) internal {
184         assert(token.approve(spender, value));
185     }
186 }
187 
188 contract StandardToken is ERC20, BasicToken {
189 
190     mapping (address => mapping (address => uint256)) internal allowed;
191 
192     /**
193      * @dev Transfer tokens from one address to another
194      * @param _from address The address which you want to send tokens from
195      * @param _to address The address which you want to transfer to
196      * @param _value uint256 the amount of tokens to be transferred
197      */
198     function transferFrom(address _from, address _to, uint256 _value) public returns (bool) {
199         require(_to != address(0));
200         require(_value <= balances[_from]);
201         require(_value <= allowed[_from][msg.sender]);
202 
203         balances[_from] = balances[_from].sub(_value);
204         balances[_to] = balances[_to].add(_value);
205         allowed[_from][msg.sender] = allowed[_from][msg.sender].sub(_value);
206         emit Transfer(_from, _to, _value);
207         return true;
208     }
209 
210     /**
211      * @dev Approve the passed address to spend the specified amount of tokens on behalf of msg.sender.
212      *
213      * Beware that changing an allowance with this method brings the risk that someone may use both the old
214      * and the new allowance by unfortunate transaction ordering. One possible solution to mitigate this
215      * race condition is to first reduce the spender's allowance to 0 and set the desired value afterwards:
216      * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
217      * @param _spender The address which will spend the funds.
218      * @param _value The amount of tokens to be spent.
219      */
220     function approve(address _spender, uint256 _value) public returns (bool) {
221         allowed[msg.sender][_spender] = _value;
222         emit Approval(msg.sender, _spender, _value);
223         return true;
224     }
225 
226     /**
227      * @dev Function to check the amount of tokens that an owner allowed to a spender.
228      * @param _owner address The address which owns the funds.
229      * @param _spender address The address which will spend the funds.
230      * @return A uint256 specifying the amount of tokens still available for the spender.
231      */
232     function allowance(address _owner, address _spender) public view returns (uint256) {
233         return allowed[_owner][_spender];
234     }
235 
236     /**
237      * @dev Increase the amount of tokens that an owner allowed to a spender.
238      *
239      * approve should be called when allowed[_spender] == 0. To increment
240      * allowed value is better to use this function to avoid 2 calls (and wait until
241      * the first transaction is mined)
242      * From MonolithDAO Token.sol
243      * @param _spender The address which will spend the funds.
244      * @param _addedValue The amount of tokens to increase the allowance by.
245      */
246     function increaseApproval(address _spender, uint _addedValue) public returns (bool) {
247         allowed[msg.sender][_spender] = allowed[msg.sender][_spender].add(_addedValue);
248         emit Approval(msg.sender, _spender, allowed[msg.sender][_spender]);
249         return true;
250     }
251 
252     /**
253      * @dev Decrease the amount of tokens that an owner allowed to a spender.
254      *
255      * approve should be called when allowed[_spender] == 0. To decrement
256      * allowed value is better to use this function to avoid 2 calls (and wait until
257      * the first transaction is mined)
258      * From MonolithDAO Token.sol
259      * @param _spender The address which will spend the funds.
260      * @param _subtractedValue The amount of tokens to decrease the allowance by.
261      */
262     function decreaseApproval(address _spender, uint _subtractedValue) public returns (bool) {
263         uint oldValue = allowed[msg.sender][_spender];
264         if (_subtractedValue > oldValue) {
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
275 contract ExtoToken is StandardToken, BurnableToken {
276 
277     using SafeMath for uint;
278 
279     string constant public symbol = "EXTO";
280     string constant public name = "Exto";
281     uint8 constant public decimals = 18;
282     uint256 public constant decimalFactor = 10 ** uint256(decimals);
283     uint256 public constant INITIAL_SUPPLY = 200000000 * decimalFactor;
284 
285     constructor(address ownerAdrs) public {
286         totalSupply_ = INITIAL_SUPPLY;
287         //InitialDistribution
288         preSale(ownerAdrs,totalSupply_);
289     }
290 
291     function preSale(address _address, uint _amount) internal returns (bool) {
292         balances[_address] = _amount;
293         emit Transfer(address(0x0), _address, _amount);
294     }
295 
296     function transfer(address _to, uint256 _value) isRunning public returns (bool) {
297         super.transfer(_to, _value);
298         return true;
299     }
300 
301     function transferFrom(address _from, address _to, uint256 _value) isRunning public returns (bool) {
302         super.transferFrom(_from, _to, _value);
303         return true;
304     }
305     
306 }