1 pragma solidity ^0.5.4;
2 
3 contract ERC20Basic {
4     function totalSupply() public view returns (uint256);
5     function balanceOf(address who) public view returns (uint256);
6     function transfer(address to, uint256 value) public returns (bool);
7     event Transfer(address indexed from, address indexed to, uint256 value);
8 }
9 
10 contract ERC20 is ERC20Basic {
11     function allowance(address owner, address spender) public view returns (uint256);
12     function transferFrom(address from, address to, uint256 value) public returns (bool);
13     function approve(address spender, uint256 value) public returns (bool);
14     event Approval(address indexed owner, address indexed spender, uint256 value);
15 }
16 
17 contract BasicToken is ERC20Basic {
18     using SafeMath for uint256;
19 
20     mapping(address => uint256) balances;
21 
22     uint256 totalSupply_;
23 
24     /**
25     * @dev total number of tokens in existence
26     */
27     function totalSupply() public view returns (uint256) {
28         return totalSupply_;
29     }
30 
31     /**
32     * @dev transfer token for a specified address
33     * @param _to The address to transfer to.
34     * @param _value The amount to be transferred.
35     */
36     function transfer(address _to, uint256 _value) public returns (bool) {
37         require(_to != address(0));
38         require(_value <= balances[msg.sender]);
39 
40         // SafeMath.sub will throw if there is not enough balance.
41         balances[msg.sender] = balances[msg.sender].sub(_value);
42         balances[_to] = balances[_to].add(_value);
43         emit Transfer(msg.sender, _to, _value);
44         return true;
45     }
46 
47     /**
48     * @dev Gets the balance of the specified address.
49     * @param _owner The address to query the the balance of.
50     * @return An uint256 representing the amount owned by the passed address.
51     */
52     function balanceOf(address _owner) public view returns (uint256 balance) {
53         return balances[_owner];
54     }
55 
56 }
57 contract Ownable {
58     address public owner;
59 
60 
61     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
62 
63 
64     /**
65      * @dev The Ownable constructor sets the original `owner` of the contract to the sender
66      * account.
67      */
68     constructor() public {
69         owner = msg.sender;
70     }
71 
72     /**
73      * @dev Throws if called by any account other than the owner.
74      */
75     modifier onlyOwner() {
76         require(msg.sender == owner);
77         _;
78     }
79 
80     /**
81      * @dev Allows the current owner to transfer control of the contract to a newOwner.
82      * @param newOwner The address to transfer ownership to.
83      */
84     function transferOwnership(address newOwner) public onlyOwner {
85         require(newOwner != address(0));
86         emit OwnershipTransferred(owner, newOwner);
87         owner = newOwner;
88     }
89 
90 }
91 library SafeMath {
92 
93     /**
94     * @dev Multiplies two numbers, throws on overflow.
95     */
96     function mul(uint256 a, uint256 b) internal pure returns (uint256 c) {
97         if (a == 0) {
98             return 0;
99         }
100         c = a * b;
101         assert(c / a == b);
102         return c;
103     }
104 
105     /**
106     * @dev Integer division of two numbers, truncating the quotient.
107     */
108     function div(uint256 a, uint256 b) internal pure returns (uint256) {
109         // assert(b > 0); // Solidity automatically throws when dividing by 0
110         // uint256 c = a / b;
111         // assert(a == b * c + a % b); // There is no case in which this doesn't hold
112         return a / b;
113     }
114 
115     /**
116     * @dev Subtracts two numbers, throws on overflow (i.e. if subtrahend is greater than minuend).
117     */
118     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
119         assert(b <= a);
120         return a - b;
121     }
122 
123     /**
124     * @dev Adds two numbers, throws on overflow.
125     */
126     function add(uint256 a, uint256 b) internal pure returns (uint256 c) {
127         c = a + b;
128         assert(c >= a);
129         return c;
130     }
131 }
132 contract StandardToken is ERC20, BasicToken {
133 
134     mapping (address => mapping (address => uint256)) internal allowed;
135 
136 
137     /**
138      * @dev Transfer tokens from one address to another
139      * @param _from address The address which you want to send tokens from
140      * @param _to address The address which you want to transfer to
141      * @param _value uint256 the amount of tokens to be transferred
142      */
143     function transferFrom(address _from, address _to, uint256 _value) public returns (bool) {
144         require(_to != address(0));
145         require(_value <= balances[_from]);
146         require(_value <= allowed[_from][msg.sender]);
147 
148         balances[_from] = balances[_from].sub(_value);
149         balances[_to] = balances[_to].add(_value);
150         allowed[_from][msg.sender] = allowed[_from][msg.sender].sub(_value);
151         emit Transfer(_from, _to, _value);
152         return true;
153     }
154 
155     /**
156      * @dev Approve the passed address to spend the specified amount of tokens on behalf of msg.sender.
157      *
158      * Beware that changing an allowance with this method brings the risk that someone may use both the old
159      * and the new allowance by unfortunate transaction ordering. One possible solution to mitigate this
160      * race condition is to first reduce the spender's allowance to 0 and set the desired value afterwards:
161      * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
162      * @param _spender The address which will spend the funds.
163      * @param _value The amount of tokens to be spent.
164      */
165     function approve(address _spender, uint256 _value) public returns (bool) {
166         allowed[msg.sender][_spender] = _value;
167         emit Approval(msg.sender, _spender, _value);
168         return true;
169     }
170 
171     /**
172      * @dev Function to check the amount of tokens that an owner allowed to a spender.
173      * @param _owner address The address which owns the funds.
174      * @param _spender address The address which will spend the funds.
175      * @return A uint256 specifying the amount of tokens still available for the spender.
176      */
177     function allowance(address _owner, address _spender) public view returns (uint256) {
178         return allowed[_owner][_spender];
179     }
180 
181     /**
182      * @dev Increase the amount of tokens that an owner allowed to a spender.
183      *
184      * approve should be called when allowed[_spender] == 0. To increment
185      * allowed value is better to use this function to avoid 2 calls (and wait until
186      * the first transaction is mined)
187      * From MonolithDAO Token.sol
188      * @param _spender The address which will spend the funds.
189      * @param _addedValue The amount of tokens to increase the allowance by.
190      */
191     function increaseApproval(address _spender, uint _addedValue) public returns (bool) {
192         allowed[msg.sender][_spender] = allowed[msg.sender][_spender].add(_addedValue);
193         emit Approval(msg.sender, _spender, allowed[msg.sender][_spender]);
194         return true;
195     }
196 
197     /**
198      * @dev Decrease the amount of tokens that an owner allowed to a spender.
199      *
200      * approve should be called when allowed[_spender] == 0. To decrement
201      * allowed value is better to use this function to avoid 2 calls (and wait until
202      * the first transaction is mined)
203      * From MonolithDAO Token.sol
204      * @param _spender The address which will spend the funds.
205      * @param _subtractedValue The amount of tokens to decrease the allowance by.
206      */
207     function decreaseApproval(address _spender, uint _subtractedValue) public returns (bool) {
208         uint oldValue = allowed[msg.sender][_spender];
209         if (_subtractedValue > oldValue) {
210             allowed[msg.sender][_spender] = 0;
211         } else {
212             allowed[msg.sender][_spender] = oldValue.sub(_subtractedValue);
213         }
214         emit Approval(msg.sender, _spender, allowed[msg.sender][_spender]);
215         return true;
216     }
217 
218 }
219 contract KrpToken is StandardToken, Ownable {
220 
221     string public constant name = "Kryptoin Blockchain 10 ETF";
222     string public constant symbol = "ETF";
223     uint8 public constant decimals = 18;
224 
225     event Mint(address indexed to, uint256 amount);
226     event MintStopped();
227     event MintStarted();
228     bool public mintingStopped = false;
229     bool public tradeOn = true;
230 
231     address mintManager;
232 
233     modifier canMint() {
234         require(msg.sender == owner || msg.sender == mintManager);
235         require(!mintingStopped);
236         _;
237     }
238 
239     modifier isTradeOn() {
240         require(tradeOn == true);
241         _;
242     }
243 
244     function setMintManager(address _mintManager) public onlyOwner {
245         mintManager = _mintManager;
246     }
247 
248     /**
249     * @dev Internal function that mints an amount of the token and assigns it to
250     * an account.
251     * @param account The account that will receive the created tokens.
252     * @param amount The amount that will be created.
253     */
254     function mint(address account, uint256 amount) public canMint() returns(bool) {
255         require(account != address(0));
256         totalSupply_ = totalSupply_.add(amount);
257         balances[account] = balances[account].add(amount);
258         emit Mint(account, amount);
259         emit Transfer(address(0), account, amount);
260         return true;
261     }
262 
263     /**
264      * @dev Function to stop minting new tokens.
265      * @return True if the operation was successful.
266      */
267     function stopMinting() onlyOwner public returns (bool) {
268         mintingStopped = true;
269         emit MintStopped();
270         return true;
271     }
272 
273     function startMinting() onlyOwner public returns (bool) {
274         mintingStopped = false;
275         emit MintStarted();
276         return true;
277     }
278 
279     event Burn(address indexed account, uint256 value);
280 
281     /**
282      * @dev Function that burns an amount of the token of a given
283      * account.
284      * @param account The account whose tokens will be burnt.
285      * @param amount The amount that will be burnt.
286      */
287     function burn(address account, uint256 amount) public canMint() {
288         require(account != address(0));
289         require(amount <= balances[account]);
290 
291         totalSupply_ = totalSupply_.sub(amount);
292         balances[account] = balances[account].sub(amount);
293         emit Burn(account, amount);
294         emit Transfer(account, address(0), amount);
295     }
296 
297     // Overrided to put modifier
298     function transfer(address _to, uint256 _value) public isTradeOn returns (bool) {
299         super.transfer(_to, _value);
300     }
301 
302     // Overrided to put modifier
303     function transferFrom(address _from, address _to, uint256 _value) public isTradeOn returns (bool) {
304         super.transferFrom(_from, _to, _value);
305     }
306 
307     // Toggle trade on/off
308     function toggleTradeOn() public onlyOwner{
309         tradeOn = !tradeOn;
310     }
311 }