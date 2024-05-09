1 pragma solidity ^0.4.24;
2 
3 
4 /**
5 * @title SafeMath
6 * @dev Math operations with safety checks that throw on error
7 */
8 
9 library SafeMath {
10 /**
11 * @dev Multiplies two numbers, throws on overflow.
12 */
13 
14     function mul(uint256 _a, uint256 _b) internal pure returns (uint256) {
15     if (_a == 0) {
16     return 0;
17     }
18     uint256 c = _a * _b;
19     assert(c / _a == _b);
20     return c;
21     }
22     
23     
24     /**
25     * @dev Integer division of two numbers, truncating the quotient.
26     */
27     function div(uint256 _a, uint256 _b) internal pure returns (uint256) {
28     // assert(_b > 0); // Solidity automatically throws when dividing by 0
29     uint256 c = _a / _b;
30     // assert(_a == _b * c + _a % _b); // There is no case in which this doesn't hold
31     return c;
32     }
33     
34      
35     
36     /**
37     * @dev Substracts two numbers, throws on overflow (i.e. if subtrahend is greater than minuend).
38     */
39     function sub(uint256 _a, uint256 _b) internal pure returns (uint256) {
40     assert(_b <= _a);
41     return _a - _b;
42     }
43     
44     /**
45     * @dev Adds two numbers, throws on overflow.
46     */
47     function add(uint256 _a, uint256 _b) internal pure returns (uint256) {
48     uint256 c = _a + _b;
49     assert(c >= _a);
50     return c;
51     }
52 }
53 
54  
55 
56 contract Ownable {
57     address public owner;
58     address public newOwner;
59     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
60 
61     constructor() public {
62     owner = msg.sender;
63     newOwner = address(0);
64     }
65 
66     modifier onlyOwner() {
67     require(msg.sender == owner);
68     _;
69     }
70 
71     modifier onlyNewOwner() {
72     require(msg.sender != address(0));
73     require(msg.sender == newOwner);
74     _;
75     }
76 
77     function transferOwnership(address _newOwner) public onlyOwner {
78     require(_newOwner != address(0));
79     newOwner = _newOwner;
80     }
81     
82     function acceptOwnership() public onlyNewOwner returns(bool) {
83     emit OwnershipTransferred(owner, newOwner);
84     owner = newOwner;
85     }
86 }
87 
88 
89 contract Pausable is Ownable {
90     event Pause();
91     event Unpause();
92     bool public paused = false;
93     
94     modifier whenNotPaused() {
95     require(!paused);
96     _;
97     }
98     modifier whenPaused() {
99     require(paused);
100     _;
101     }
102 
103     
104     function pause() onlyOwner whenNotPaused public {
105     paused = true;
106     emit Pause();
107     }
108     
109     
110     function unpause() onlyOwner whenPaused public {
111     paused = false;
112     emit Unpause();
113     }
114 
115 }
116 
117  
118 
119 contract ERC20 {
120     function totalSupply() public view returns (uint256);
121     function balanceOf(address who) public view returns (uint256);
122     function allowance(address owner, address spender) public view returns (uint256);
123     function transfer(address to, uint256 value) public returns (bool);
124     function transferFrom(address from, address to, uint256 value) public returns (bool);
125     function approve(address spender, uint256 value) public returns (bool);
126     event Approval(address indexed owner, address indexed spender, uint256 value);
127     event Transfer(address indexed from, address indexed to, uint256 value);
128 }
129 
130  
131 
132 interface TokenRecipient {
133  function receiveApproval(address _from, uint256 _value, address _token, bytes _extraData) external;
134 }
135 
136  
137 
138 contract YYYYYYCoin is ERC20, Ownable, Pausable {
139     uint128 internal MONTH = 30 * 24 * 3600; // 1 month
140     using SafeMath for uint256;
141     
142     
143     struct LockupInfo {
144     uint256 releaseTime;
145     uint256 termOfRound;
146     uint256 unlockAmountPerRound;
147     uint256 lockupBalance;
148     }
149     
150     string public name;
151     string public symbol;
152     uint8 public decimals;
153     uint256 internal initialSupply;
154     uint256 internal totalSupply_;
155     
156     mapping(address => uint256) internal balances;
157     mapping(address => bool) public frozen;
158     mapping(address => mapping(address => uint256)) internal allowed;
159     event Burn(address indexed owner, uint256 value);
160     event Mint(uint256 value);
161     event Freeze(address indexed holder);
162     event Unfreeze(address indexed holder);
163     
164     modifier notFrozen(address _holder) {
165     require(!frozen[_holder]);
166     _;
167     }
168 
169     constructor() public {
170     name = "YYYYYYCoin";
171     symbol = "YYC";
172     decimals = 0;
173     initialSupply = 10000000000;
174     totalSupply_ = 10000000000;
175     balances[owner] = totalSupply_;
176     emit Transfer(address(0), owner, totalSupply_);
177     }
178 
179     function () public payable {
180     revert();
181     }
182 
183     function totalSupply() public view returns (uint256) {
184     return totalSupply_;
185     }
186 
187  
188 
189 /**
190      * Internal transfer, only can be called by this contract
191      */
192     function _transfer(address _from, address _to, uint _value) internal {
193         // Prevent transfer to 0x0 address. Use burn() instead
194        
195         require(_to != address(0));
196         require(_value <= balances[_from]);
197         require(_value <= allowed[_from][msg.sender]);
198     
199        balances[_from] = balances[_from].sub(_value);
200        balances[_to] = balances[_to].add(_value);
201       allowed[_from][msg.sender] = allowed[_from][msg.sender].sub(_value);
202       emit Transfer(_from, _to, _value);
203     }
204     
205     function transfer(address _to, uint256 _value) public whenNotPaused notFrozen(msg.sender) returns (bool) {
206     require(_to != address(0));
207     require(_value <= balances[msg.sender]);
208     
209     // SafeMath.sub will throw if there is not enough balance.
210     balances[msg.sender] = balances[msg.sender].sub(_value);
211     balances[_to] = balances[_to].add(_value);
212     emit Transfer(msg.sender, _to, _value);
213     return true;
214     }
215 
216 
217     function balanceOf(address _holder) public view returns (uint256 balance) {
218     return balances[_holder];
219     }
220     
221      
222     function transferFrom(address _from, address _to, uint256 _value) public whenNotPaused notFrozen(_from)returns (bool) {
223 
224     require(_to != address(0));
225     require(_value <= balances[_from]);
226     require(_value <= allowed[_from][msg.sender]);
227 
228     _transfer(_from, _to, _value);
229     
230     return true;
231     }
232     
233     
234 
235     function approve(address _spender, uint256 _value) public whenNotPaused returns (bool) {
236     allowed[msg.sender][_spender] = _value;
237     emit Approval(msg.sender, _spender, _value);
238     return true;
239     }
240 
241 
242  
243     function allowance(address _holder, address _spender) public view returns (uint256) {
244     return allowed[_holder][_spender];
245     }
246 
247  
248  
249     function freezeAccount(address _holder) public onlyOwner returns (bool) {
250     require(!frozen[_holder]);
251     frozen[_holder] = true;
252     emit Freeze(_holder);
253     return true;
254     }
255 
256  
257 
258     function unfreezeAccount(address _holder) public onlyOwner returns (bool) {
259     require(frozen[_holder]);
260     frozen[_holder] = false;
261     emit Unfreeze(_holder);
262     return true;
263     }
264 
265  
266    function burn(uint256 _value) public onlyOwner returns (bool success) {
267     require(_value <= balances[msg.sender]);
268     address burner = msg.sender;
269     balances[burner] = balances[burner].sub(_value);
270     totalSupply_ = totalSupply_.sub(_value);
271     emit Burn(burner, _value);
272     return true;
273     }
274 
275  
276     function mint( uint256 _amount) onlyOwner public returns (bool) {
277     totalSupply_ = totalSupply_.add(_amount);
278     balances[owner] = balances[owner].add(_amount);
279     
280     emit Transfer(address(0), owner, _amount);
281     return true;
282     }    
283 }