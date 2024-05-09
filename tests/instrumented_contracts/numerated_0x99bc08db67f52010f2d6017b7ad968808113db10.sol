1 contract SafeMath {
2     
3     uint256 constant public MAX_UINT256 = 0xFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF;
4 
5     function safeAdd(uint256 x, uint256 y) constant internal returns (uint256 z) {
6         require(x <= MAX_UINT256 - y);
7         return x + y;
8     }
9 
10     function safeSub(uint256 x, uint256 y) constant internal returns (uint256 z) {
11         require(x >= y);
12         return x - y;
13     }
14 
15     function safeMul(uint256 x, uint256 y) constant internal returns (uint256 z) {
16         if (y == 0) {
17             return 0;
18         }
19         require(x <= (MAX_UINT256 / y));
20         return x * y;
21     }
22 }
23 
24 contract Owned {
25     address public owner;
26     address public newOwner;
27 
28     function Owned() {
29         owner = msg.sender;
30     }
31 
32     modifier onlyOwner {
33         assert(msg.sender == owner);
34         _;
35     }
36 
37     function transferOwnership(address _newOwner) public onlyOwner {
38         require(_newOwner != owner);
39         newOwner = _newOwner;
40     }
41 
42     function acceptOwnership() public {
43         require(msg.sender == newOwner);
44         OwnerUpdate(owner, newOwner);
45         owner = newOwner;
46         newOwner = 0x0;
47     }
48 
49     event OwnerUpdate(address _prevOwner, address _newOwner);
50 }
51 
52 contract Lockable is Owned {
53 
54     uint256 public lockedUntilBlock;
55 
56     event ContractLocked(uint256 _untilBlock, string _reason);
57 
58     modifier lockAffected {
59         require(block.number > lockedUntilBlock);
60         _;
61     }
62 
63     function lockFromSelf(uint256 _untilBlock, string _reason) internal {
64         lockedUntilBlock = _untilBlock;
65         ContractLocked(_untilBlock, _reason);
66     }
67 
68 
69     function lockUntil(uint256 _untilBlock, string _reason) onlyOwner public {
70         lockedUntilBlock = _untilBlock;
71         ContractLocked(_untilBlock, _reason);
72     }
73 }
74 
75 contract ERC20TokenInterface {
76   function totalSupply() public constant returns (uint256 _totalSupply);
77   function balanceOf(address _owner) public constant returns (uint256 balance);
78   function transfer(address _to, uint256 _value) public returns (bool success);
79   function transferFrom(address _from, address _to, uint256 _value) public returns (bool success);
80   function approve(address _spender, uint256 _value) public returns (bool success);
81   function allowance(address _owner, address _spender) public constant returns (uint256 remaining);
82 
83   event Transfer(address indexed _from, address indexed _to, uint256 _value);
84   event Approval(address indexed _owner, address indexed _spender, uint256 _value);
85 }
86 contract ERC20PrivateInterface {
87     uint256 supply;
88     mapping (address => uint256) balances;
89     mapping (address => mapping (address => uint256)) allowances;
90 
91     event Transfer(address indexed _from, address indexed _to, uint256 _value);
92     event Approval(address indexed _owner, address indexed _spender, uint256 _value);
93 }
94 
95 contract tokenRecipientInterface {
96   function receiveApproval(address _from, uint256 _value, address _token, bytes _extraData);
97 }
98 contract OwnedInterface {
99     address public owner;
100     address public newOwner;
101 
102     modifier onlyOwner {
103         _;
104     }
105 }
106 
107 contract ERC20Token is ERC20TokenInterface, SafeMath, Owned, Lockable {
108 
109     // Name of token
110     string public name;
111     // Abbreviation of tokens name
112     string public symbol;
113     // Number of decimals token has
114     uint8 public decimals;
115     // Address of the contract with minting logic
116     address public mintingContract;
117 
118     // Current supply of tokens
119     uint256 supply = 0;
120     // Map of users balances
121     mapping (address => uint256) balances;
122     // Map of users allowances
123     mapping (address => mapping (address => uint256)) allowances;
124 
125     // Event that shows that new tokens were created
126     event Mint(address indexed _to, uint256 _value);
127     // Event that shows that old tokens were destroyed
128     event Burn(address indexed _from, uint _value);
129 
130     /**
131     * @dev Returns number of tokens in circulation
132     *
133     * @return total number od tokens
134     */
135     function totalSupply() public constant returns (uint256) {
136         return supply;
137     }
138 
139     /**
140     * @dev Returns the balance of specific account
141     *
142     * @param _owner The account that caller wants to querry
143     * @return the balance on this account
144     */
145     function balanceOf(address _owner) public constant returns (uint256 balance) {
146         return balances[_owner];
147     }
148 
149     /**
150     * @dev User can transfer tokens with this method, method is disabled if emergencyLock is activated
151     *
152     * @param _to Reciever of tokens
153     * @param _value The amount of tokens that will be sent 
154     * @return if successful returns true
155     */
156     function transfer(address _to, uint256 _value) lockAffected public returns (bool success) {
157         require(_to != 0x0 && _to != address(this));
158         balances[msg.sender] = safeSub(balanceOf(msg.sender), _value);
159         balances[_to] = safeAdd(balanceOf(_to), _value);
160         emit Transfer(msg.sender, _to, _value);
161         return true;
162     }
163 
164     /**
165     * @dev This is used to allow some account to utilise transferFrom and sends tokens on your behalf, this method is disabled if emergencyLock is activated
166     *
167     * @param _spender Who can send tokens on your behalf
168     * @param _value The amount of tokens that are allowed to be sent 
169     * @return if successful returns true
170     */
171     function approve(address _spender, uint256 _value) lockAffected public returns (bool success) {
172         allowances[msg.sender][_spender] = _value;
173         emit Approval(msg.sender, _spender, _value);
174         return true;
175     }
176 
177     /**
178     * @dev This is used to send tokens and execute code on other smart contract, this method is disabled if emergencyLock is activated
179     *
180     * @param _spender Contract that is receiving tokens
181     * @param _value The amount that msg.sender is sending
182     * @param _extraData Additional params that can be used on reciving smart contract
183     * @return if successful returns true
184     */
185     function approveAndCall(address _spender, uint256 _value, bytes _extraData) lockAffected public returns (bool success) {
186         tokenRecipientInterface spender = tokenRecipientInterface(_spender);
187         approve(_spender, _value);
188         spender.receiveApproval(msg.sender, _value, this, _extraData);
189         return true;
190     }
191 
192     /**
193     * @dev Sender can transfer tokens on others behalf, this method is disabled if emergencyLock is activated
194     *
195     * @param _from The account that will send tokens
196     * @param _to Account that will recive the tokens
197     * @param _value The amount that msg.sender is sending
198     * @return if successful returns true
199     */
200     function transferFrom(address _from, address _to, uint256 _value) lockAffected public returns (bool success) {
201         require(_to != 0x0 && _to != address(this));
202         balances[_from] = safeSub(balanceOf(_from), _value);
203         balances[_to] = safeAdd(balanceOf(_to), _value);
204         allowances[_from][msg.sender] = safeSub(allowances[_from][msg.sender], _value);
205         emit Transfer(_from, _to, _value);
206         return true;
207     }
208 
209     /**
210     * @dev Returns the amount od tokens that can be sent from this addres by spender
211     *
212     * @param _owner Account that has tokens
213     * @param _spender Account that can spend tokens
214     * @return remaining balance to spend
215     */
216     function allowance(address _owner, address _spender) public constant returns (uint256 remaining) {
217         return allowances[_owner][_spender];
218     }
219 
220     /**
221     * @dev Creates new tokens as long as total supply does not reach limit
222     *
223     * @param _to Reciver od newly created tokens
224     * @param _amount Amount of tokens to be created;
225     */
226     function mint(address _to, uint256 _amount) public {
227         require(msg.sender == mintingContract);
228         supply = safeAdd(supply, _amount);
229         balances[_to] = safeAdd(balances[_to], _amount);
230         emit Mint(_to, _amount);
231         emit Transfer(0x0, _to, _amount);
232     }
233 
234     /**
235     * @dev Destroys the amount of tokens and lowers total supply
236     *
237     * @param _amount Number of tokens user wants to destroy
238     */
239     function burn(uint _amount) public {
240         balances[msg.sender] = safeSub(balanceOf(msg.sender), _amount);
241         supply = safeSub(supply, _amount);
242         emit Burn(msg.sender, _amount);
243         emit Transfer(msg.sender, 0x0, _amount);
244     }
245 
246     /**
247     * @dev Saves exidentaly sent tokens to this contract, can be used only by owner
248     *
249     * @param _tokenAddress Address of tokens smart contract
250     * @param _to Where to send the tokens
251     * @param _amount The amount of tokens that we are salvaging
252     */
253     function salvageTokensFromContract(address _tokenAddress, address _to, uint _amount) onlyOwner public {
254         ERC20TokenInterface(_tokenAddress).transfer(_to, _amount);
255     }
256 
257     /**
258     * @dev Disables the contract and wipes all the balances, can be used only by owner
259     */
260     function killContract() public onlyOwner {
261         selfdestruct(owner);
262     }
263 }
264 
265 
266 
267 
268 
269 
270 contract ApodTokenContract is ERC20Token {
271 
272     /**
273     * @dev Intialises token and all the necesary variable
274     */
275    function ApodTokenContract() public {
276         name = "Airpod token";
277         symbol = "APOD";
278         decimals = 18;
279         mintingContract = 0xE7c79DEB6A9b74F691D5F882B7C588BbA5db1A20; // TO-DO: Set contract that can mint tokens
280         lockFromSelf(0, "Lock before crowdsale starts");
281     }
282 }