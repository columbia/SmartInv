1 contract IReceiver { 
2 /**
3  * @dev Standard ERC223 function that will handle incoming token transfers.
4  *
5  * @param _from  Token sender address.
6  * @param _value Amount of tokens.
7  * @param _data  Transaction metadata.
8  */
9     function tokenFallback(address _from, uint _value, bytes _data) public;
10 }
11 
12 /**
13  * @title SafeMath
14  * @dev Math operations with safety checks that throw on error
15  */
16 library LSafeMath {
17 
18     uint256 constant WAD = 1 ether;
19     
20     function mul(uint256 a, uint256 b) internal pure returns (uint256) {
21         if (a == 0) {
22             return 0;
23         }
24         uint256 c = a * b;
25         if (c / a == b)
26             return c;
27         revert();
28     }
29     
30     function div(uint256 a, uint256 b) internal pure returns (uint256) {
31         if (b > 0) { 
32             uint256 c = a / b;
33             return c;
34         }
35         revert();
36     }
37     
38     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
39         if (b <= a)
40             return a - b;
41         revert();
42     }
43     
44     function add(uint256 a, uint256 b) internal pure returns (uint256) {
45         uint256 c = a + b;
46         if (c >= a) 
47             return c;
48         revert();
49     }
50 
51     function wmul(uint a, uint b) internal pure returns (uint256) {
52         return add(mul(a, b), WAD / 2) / WAD;
53     }
54 
55     function wdiv(uint a, uint b) internal pure returns (uint256) {
56         return add(mul(a, WAD), b / 2) / b;
57     }
58 }
59 
60 contract Ownable {
61     address public owner;
62 
63     /**
64     * @dev The Ownable constructor sets the original `owner` of the contract to the sender
65     * account.
66     */
67     function Ownable() public {
68         owner = msg.sender;
69     }
70 
71     /**
72     * @dev Throws if called by any account other than the owner.
73     */
74     modifier onlyOwner() {
75         require(msg.sender == owner);
76         _;
77     }
78 
79     /**
80     * @dev Allows the current owner to transfer control of the contract to a newOwner.
81     * @param newOwner The address to transfer ownership to.
82     */
83     function transferOwnership(address newOwner) public onlyOwner {
84         if (newOwner != address(0)) {
85             owner = newOwner;
86         }
87     }
88 }
89 
90 
91 contract ERC20Basic {
92     uint256 public totalSupply;
93     function balanceOf(address who) public constant returns (uint256);
94     function transfer(address to, uint256 value) public returns (bool);
95     event Transfer(address indexed _from, address indexed _to, uint _value);
96 }
97 
98 
99 contract BasicToken is ERC20Basic {
100 
101     using LSafeMath for uint256;
102     mapping(address => uint256) balances;
103     bool public isFallbackAllowed;
104 
105     /**
106     * @dev transfer token for a specified address
107     * @param _to The address to transfer to.
108     * @param _value The amount to be transferred.
109     */
110     function transfer(address _to, uint256 _value) public returns (bool) {
111         bytes memory empty;
112         uint codeLength = 0;
113 
114         assembly {
115             // Retrieve the size of the code on target address, this needs assembly .
116             codeLength := extcodesize(_to)
117         }
118         
119         balances[msg.sender] = balances[msg.sender].sub(_value);
120         balances[_to] = balances[_to].add(_value);
121         if (codeLength > 0 && isFallbackAllowed)
122             IReceiver(_to).tokenFallback(msg.sender, _value, empty);
123         emit Transfer(msg.sender, _to, _value);
124         return true;
125     }
126     
127     /**
128     * @dev Gets the balance of the specified address.
129     * @param _owner The address to query the the balance of. 
130     * @return An uint256 representing the amount owned by the passed address.
131     */
132     function balanceOf(address _owner) public constant returns (uint256 balance) {
133         return balances[_owner];
134     }
135 
136 }
137 
138 
139 contract ERC20 is ERC20Basic {
140     function allowance(address owner, address spender) public constant returns (uint256);
141     function transferFrom(address from, address to, uint256 value) public  returns (bool);
142     function approve(address spender, uint256 value) public returns (bool);
143     event Approval(address indexed _owner, address indexed _spender, uint _value);
144 }
145 
146 
147 contract StandardToken is ERC20, BasicToken {
148 
149     mapping (address => mapping (address => uint256)) allowed;
150 
151     /**
152     * @dev Transfer tokens from one address to another
153     * @param _from address The address which you want to send tokens from
154     * @param _to address The address which you want to transfer to
155     * @param _value uint256 the amout of tokens to be transfered
156     */
157     function transferFrom(address _from, address _to, uint256 _value) public returns (bool) {
158         bytes memory empty;
159         uint256 _allowance = allowed[_from][msg.sender];
160         uint codeLength = 0;
161 
162         assembly {
163             // Retrieve the size of the code on target address, this needs assembly .
164             codeLength := extcodesize(_to)
165         }
166 
167         //code changed to comply with ERC20 standard
168         balances[_from] = balances[_from].sub(_value);
169         balances[_to] = balances[_to].add(_value);
170         //balances[_from] = balances[_from].sub(_value); // this was removed
171         allowed[_from][msg.sender] = _allowance.sub(_value);
172         if (codeLength > 0 && isFallbackAllowed) 
173             IReceiver(_to).tokenFallback(msg.sender, _value, empty);
174         emit Transfer(_from, _to, _value);
175         return true;
176     }
177 
178     /**
179     * @dev Aprove the passed address to spend the specified amount of tokens on behalf of msg.sender.
180     * @param _spender The address which will spend the funds.
181     * @param _value The amount of tokens to be spent.
182     */
183     function approve(address _spender, uint256 _value) public returns (bool) {
184 
185         // To change the approve amount you first have to reduce the addresses`
186         //  allowance to zero by calling `approve(_spender, 0)` if it is not
187         //  already 0 to mitigate the race condition described here:
188         //  https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
189         require((_value == 0) || (allowed[msg.sender][_spender] == 0));
190 
191         allowed[msg.sender][_spender] = _value;
192         emit Approval(msg.sender, _spender, _value);
193         return true;
194     }
195 
196     /**
197     * @dev Function to check the amount of tokens that an owner allowed to a spender.
198     * @param _owner address The address which owns the funds.
199     * @param _spender address The address which will spend the funds.
200     * @return A uint256 specifing the amount of tokens still avaible for the spender.
201     */
202     function allowance(address _owner, address _spender) public constant returns (uint256 remaining) {
203         return allowed[_owner][_spender];
204     }
205 
206 }
207 
208 
209 contract ARCXToken is StandardToken, Ownable {
210     string  public name;
211     string  public symbol;
212     uint    public constant decimals = 18;
213     uint    public INITIAL_SUPPLY;
214     address public crowdsaleContract;
215     bool    public transferEnabled;
216     uint public timeLock; 
217     mapping(address => bool) private ingnoreLocks;
218     mapping(address => uint) public lockedAddresses;
219 
220 
221     
222     event Burn(address indexed _burner, uint _value);
223 
224     modifier onlyWhenTransferEnabled() {
225         if (msg.sender != crowdsaleContract) {
226             require(transferEnabled);
227         } 
228         _;
229     }
230     
231     modifier checktimelock() {
232         require(now >= lockedAddresses[msg.sender] && (now >= timeLock || ingnoreLocks[msg.sender]));
233         _;
234     }
235     
236     function ARCXToken(uint time_lock, address crowdsale_contract, string _name, string _symbol, uint supply) public {
237         INITIAL_SUPPLY = supply;
238         name = _name;
239         symbol = _symbol;
240         address addr = (crowdsale_contract != address(0)) ? crowdsale_contract : msg.sender;
241         balances[addr] = INITIAL_SUPPLY; 
242         transferEnabled = true;
243         totalSupply = INITIAL_SUPPLY;
244         crowdsaleContract = addr; //initial by setting crowdsalecontract location to owner
245         timeLock = time_lock;
246         ingnoreLocks[addr] = true;
247         emit Transfer(address(0x0), addr, INITIAL_SUPPLY);
248     }
249 
250     function setupCrowdsale(address _contract, bool _transferAllowed) public onlyOwner {
251         crowdsaleContract = _contract;
252         transferEnabled = _transferAllowed;
253     }
254 
255     function transfer(address _to, uint _value) public
256         onlyWhenTransferEnabled
257         checktimelock
258         returns (bool) {
259             return super.transfer(_to, _value);
260         }
261 
262     function transferFrom(address _from, address _to, uint _value) public
263         onlyWhenTransferEnabled
264         checktimelock
265         returns (bool) {
266             return super.transferFrom(_from, _to, _value);
267         }
268 
269     function burn(uint _value) public
270         onlyWhenTransferEnabled
271         checktimelock
272         returns (bool) {
273             balances[msg.sender] = balances[msg.sender].sub(_value);
274             totalSupply = totalSupply.sub(_value);
275             emit Burn(msg.sender, _value);
276             emit Transfer(msg.sender, address(0x0), _value);
277             return true;
278         }
279 
280     // save some gas by making only one contract call
281     function burnFrom(address _from, uint256 _value) public
282         onlyWhenTransferEnabled
283         checktimelock
284         returns (bool) {
285             assert(transferFrom(_from, msg.sender, _value));
286             return burn(_value);
287         } 
288 
289     function emergencyERC20Drain(ERC20 token, uint amount ) public onlyOwner {
290         token.transfer(owner, amount);
291     }
292     
293     function ChangeTransferStatus() public onlyOwner {
294         if (transferEnabled == false) {
295             transferEnabled = true;
296         } else {
297             transferEnabled = false;
298         }
299     }
300     
301     function setupTimelock(uint _time) public onlyOwner {
302         timeLock = _time;
303     }
304     
305     function setLockedAddress(address _holder, uint _time) public onlyOwner {
306         lockedAddresses[_holder] = _time;
307     }
308     
309     function IgnoreTimelock(address _owner) public onlyOwner {
310         ingnoreLocks[_owner] = true;
311     }
312     
313     function allowFallback(bool allow) public onlyOwner {
314         isFallbackAllowed = allow;
315     }
316 
317 }