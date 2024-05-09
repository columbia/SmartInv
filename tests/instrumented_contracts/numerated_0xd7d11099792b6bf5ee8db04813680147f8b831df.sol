1 pragma solidity ^0.4.18;
2 
3 /**
4  * @title SafeMath
5  * @dev Math operations with safety checks that throw on error
6  */
7 library SafeMath {
8     function mul(uint256 a, uint256 b) internal pure returns (uint256) {
9         if (a == 0) {
10             return 0;
11         }
12         uint256 c = a * b;
13         assert(c / a == b);
14         return c;
15     }
16 
17     function div(uint256 a, uint256 b) internal pure returns (uint256) {
18         // assert(b > 0); // Solidity automatically throws when dividing by 0
19         uint256 c = a / b;
20         // assert(a == b * c + a % b); // There is no case in which this doesn't hold
21         return c;       
22     }       
23 
24     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
25         assert(b <= a);
26         return a - b;
27     }
28 
29     function add(uint256 a, uint256 b) internal pure returns (uint256) {
30         uint256 c = a + b;
31         assert(c >= a);
32         return c;
33     }
34 }
35 
36 
37 contract Ownable {
38     address public owner;
39     address public newOwner;
40 
41     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
42 
43     function Ownable() public {
44         owner = msg.sender;
45         newOwner = address(0);
46     }
47 
48     modifier onlyOwner() {
49         require(msg.sender == owner);
50         _;
51     }
52     modifier onlyNewOwner() {
53         require(msg.sender != address(0));
54         require(msg.sender == newOwner);
55         _;
56     }
57 
58     function transferOwnership(address _newOwner) public onlyOwner {
59         require(_newOwner != address(0));
60         newOwner = _newOwner;
61     }
62 
63     function acceptOwnership() public onlyNewOwner returns(bool) {
64         emit OwnershipTransferred(owner, newOwner);
65         owner = newOwner;
66     }
67 }
68 
69 /**
70  * @title ERC20 interface
71  * @dev see https://github.com/ethereum/EIPs/issues/20
72  */
73 contract ERC20 {
74     function totalSupply() public view returns (uint256);
75     function balanceOf(address who) public view returns (uint256);
76     function allowance(address owner, address spender) public view returns (uint256);
77     function transfer(address to, uint256 value) public returns (bool);
78     function transferFrom(address from, address to, uint256 value) public returns (bool);
79     function approve(address spender, uint256 value) public returns (bool);
80 
81     event Approval(address indexed owner, address indexed spender, uint256 value);
82     event Transfer(address indexed from, address indexed to, uint256 value);
83 }
84 
85 contract POPKOIN is ERC20, Ownable {
86 
87     using SafeMath for uint256;
88 
89     string public name;
90     string public symbol;
91     uint8 public decimals;
92     uint256 internal initialSupply;
93     uint256 internal _totalSupply;
94     
95                                  
96     uint256 internal LOCKUP_TERM = 6 * 30 * 24 * 3600;
97 
98     mapping(address => uint256) internal _balances;    
99     mapping(address => mapping(address => uint256)) internal _allowed;
100 
101     mapping(address => uint256) internal _lockupBalances;
102     mapping(address => uint256) internal _lockupExpireTime;
103 
104     function POPKOIN() public {
105         name = "POPKOIN";
106         symbol = "POPK";
107         decimals = 18;
108 
109 
110         //Total Supply  2,000,000,000
111         initialSupply = 2000000000;
112         _totalSupply = initialSupply * 10 ** uint(decimals);
113         _balances[owner] = _totalSupply;
114         emit Transfer(address(0), owner, _totalSupply);
115     }
116 
117     function totalSupply() public view returns (uint256) {
118         return _totalSupply;
119     }
120 
121     /**
122      * @dev transfer token for a specified address
123      * @param _to The address to transfer to.
124      * @param _value The amount to be transferred.
125      */
126     function transfer(address _to, uint256 _value) public returns (bool) {
127         require(_to != address(0));
128         require(_to != address(this));
129         require(msg.sender != address(0));
130         require(_value <= _balances[msg.sender]);
131 
132         // SafeMath.sub will throw if there is not enough balance.
133         _balances[msg.sender] = _balances[msg.sender].sub(_value);
134         _balances[_to] = _balances[_to].add(_value);
135         emit Transfer(msg.sender, _to, _value);
136         return true;
137     }
138 
139     /**
140     * @dev Gets the balance of the specified address.
141     * @param _holder The address to query the the balance of.
142     * @return An uint256 representing the amount owned by the passed address.
143     */
144     function balanceOf(address _holder) public view returns (uint256 balance) {
145         return _balances[_holder].add(_lockupBalances[_holder]);
146     }
147 
148     /**
149     * @dev Gets the locked balance of the specified address.
150     * @param _holder The address to query the the balance of.
151     * @return An uint256 representing the amount owned by the passed address.
152     */   
153     function lockupBalanceOf(address _holder) public view returns (uint256 balance) {
154         return _lockupBalances[_holder];
155     }
156 
157     /**
158     * @dev Gets the unlocked time of the specified address.
159     * @param _holder The address to query the the balance of.
160     * @return An uint256 representing the Locktime owned by the passed address.
161     */   
162     function unlockTimeOf(address _holder) public view returns (uint256 lockTime) {
163         return _lockupExpireTime[_holder];
164     }
165 
166     /**
167     * @dev Transfer tokens from one address to another
168     * @param _from address The address which you want to send tokens from
169     * @param _to address The address which you want to transfer to
170     * @param _value uint256 the amount of tokens to be transferred
171     */
172     function transferFrom(address _from, address _to, uint256 _value) public returns (bool) {
173         require(_from != address(0));
174         require(_to != address(0));
175         require(_to != address(this));
176         require(_value <= _balances[_from]);
177         require(_value <= _allowed[_from][msg.sender]);
178 
179         _balances[_from] = _balances[_from].sub(_value);
180         _balances[_to] = _balances[_to].add(_value);
181         _allowed[_from][msg.sender] = _allowed[_from][msg.sender].sub(_value);
182         emit Transfer(_from, _to, _value);
183         return true;
184     }
185 
186     /**
187     * @dev Approve the passed address to spend the specified amount of tokens on behalf of msg.sender.
188     * @param _spender The address which will spend the funds.
189     * @param _value The amount of tokens to be spent.
190     */
191     function approve(address _spender, uint256 _value) public returns (bool) {
192         require(_value > 0);
193         _allowed[msg.sender][_spender] = _value;
194         emit Approval(msg.sender, _spender, _value);
195         return true;
196     }
197 
198     /**
199     * @dev Function to check the amount of tokens that an owner allowed to a spender.
200     * @param _holder address The address which owns the funds.
201     * @param _spender address The address which will spend the funds.
202     * @return A uint256 specifying the amount of tokens still available for the spender.
203     */
204     function allowance(address _holder, address _spender) public view returns (uint256) {
205         return _allowed[_holder][_spender];
206     }
207 
208     /**
209     * @dev Do not allow contracts to accept Ether.
210     */
211     function () public payable {
212         revert();
213     }
214 
215     /**
216     * @dev The Owner destroys his own token.
217     * @param _value uint256 The quantity that needs to be destroyed.
218     */
219     function burn(uint256 _value) public onlyOwner returns (bool success) {
220         require(_value <= _balances[msg.sender]);
221         address burner = msg.sender;
222         _balances[burner] = _balances[burner].sub(_value);
223         _totalSupply = _totalSupply.sub(_value);
224         return true;
225     }
226 
227     /**
228     * @dev Function is used to distribute tokens and confirm the lock time.
229     * @param _to address The address which you want to transfer to
230     * @param _value uint256 The amount of tokens to be transferred
231     * @param _lockupRate uint256 The proportion of tokens that are expected to be locked.
232     * @notice If you lock 50%, the lockout time is six months.
233     *         If you lock 100%, the lockout time is one year.
234     */
235     function distribute(address _to, uint256 _value, uint256 _lockupRate) public onlyOwner returns (bool) {
236         require(_to != address(0));
237         require(_to != address(this));
238         //Do not allow multiple distributions of the same address. Avoid locking time reset.
239         require(_lockupBalances[_to] == 0);     
240         require(_value <= _balances[owner]);
241         require(_lockupRate == 50 || _lockupRate == 100);
242 
243         _balances[owner] = _balances[owner].sub(_value);
244 
245         uint256 lockupValue = _value.mul(_lockupRate).div(100);
246         uint256 givenValue = _value.sub(lockupValue);
247         uint256 ExpireTime = now + LOCKUP_TERM; //six months
248 
249         if (_lockupRate == 100) {
250             ExpireTime += LOCKUP_TERM;          //one year.
251         }
252         
253         _balances[_to] = _balances[_to].add(givenValue);
254         _lockupBalances[_to] = _lockupBalances[_to].add(lockupValue);
255         _lockupExpireTime[_to] = ExpireTime;
256 
257         emit Transfer(owner, _to, _value);
258         return true;
259     }
260 
261     /**
262     * @dev When the lock time expires, the user unlocks his own token.
263     */
264     function unlock() public returns(bool) {
265         address tokenHolder = msg.sender;
266         require(_lockupBalances[tokenHolder] > 0);
267         require(_lockupExpireTime[tokenHolder] <= now);
268 
269         uint256 value = _lockupBalances[tokenHolder];
270 
271         _balances[tokenHolder] = _balances[tokenHolder].add(value);  
272         _lockupBalances[tokenHolder] = 0;
273 
274         return true;
275     }
276 
277     /**
278     * @dev The new owner accepts the contract transfer request.
279     */
280     function acceptOwnership() public onlyNewOwner returns(bool) {
281         uint256 ownerAmount = _balances[owner];
282         _balances[owner] = _balances[owner].sub(ownerAmount);
283         _balances[newOwner] = _balances[newOwner].add(ownerAmount);
284         emit Transfer(owner, newOwner, ownerAmount);   
285         owner = newOwner;
286         newOwner = address(0);
287         emit OwnershipTransferred(owner, newOwner);
288 
289         return true;
290     }
291 }