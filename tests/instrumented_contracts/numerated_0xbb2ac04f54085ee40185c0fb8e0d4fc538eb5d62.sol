1 pragma solidity ^0.4.13;
2 
3 contract tokenRecipientInterface {
4   function receiveApproval(address _from, uint256 _value, address _token, bytes _extraData);
5 }
6 
7 contract ERC20TokenInterface {
8   function totalSupply() public constant returns (uint256 _totalSupply);
9   function balanceOf(address _owner) public constant returns (uint256 balance);
10   function transfer(address _to, uint256 _value) public returns (bool success);
11   function transferFrom(address _from, address _to, uint256 _value) public returns (bool success);
12   function approve(address _spender, uint256 _value) public returns (bool success);
13   function allowance(address _owner, address _spender) public constant returns (uint256 remaining);
14 
15   event Transfer(address indexed _from, address indexed _to, uint256 _value);
16   event Approval(address indexed _owner, address indexed _spender, uint256 _value);
17 }
18 
19 contract SafeMath {
20     
21     uint256 constant public MAX_UINT256 = 0xFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF;
22 
23     function safeAdd(uint256 x, uint256 y) constant internal returns (uint256 z) {
24         require(x <= MAX_UINT256 - y);
25         return x + y;
26     }
27 
28     function safeSub(uint256 x, uint256 y) constant internal returns (uint256 z) {
29         require(x >= y);
30         return x - y;
31     }
32 
33     function safeMul(uint256 x, uint256 y) constant internal returns (uint256 z) {
34         if (y == 0) {
35             return 0;
36         }
37         require(x <= (MAX_UINT256 / y));
38         return x * y;
39     }
40 }
41 
42 contract Owned {
43     address public owner;
44     address public newOwner;
45 
46     function Owned() {
47         owner = msg.sender;
48     }
49 
50     modifier onlyOwner {
51         assert(msg.sender == owner);
52         _;
53     }
54 
55     function transferOwnership(address _newOwner) public onlyOwner {
56         require(_newOwner != owner);
57         newOwner = _newOwner;
58     }
59 
60     function acceptOwnership() public {
61         require(msg.sender == newOwner);
62         OwnerUpdate(owner, newOwner);
63         owner = newOwner;
64         newOwner = 0x0;
65     }
66 
67     event OwnerUpdate(address _prevOwner, address _newOwner);
68 }
69 
70 contract Lockable is Owned {
71 
72     uint256 public lockedUntilBlock;
73 
74     event ContractLocked(uint256 _untilBlock, string _reason);
75 
76     modifier lockAffected {
77         require(block.number > lockedUntilBlock);
78         _;
79     }
80 
81     function lockFromSelf(uint256 _untilBlock, string _reason) internal {
82         lockedUntilBlock = _untilBlock;
83         ContractLocked(_untilBlock, _reason);
84     }
85 
86 
87     function lockUntil(uint256 _untilBlock, string _reason) onlyOwner public {
88         lockedUntilBlock = _untilBlock;
89         ContractLocked(_untilBlock, _reason);
90     }
91 }
92 
93 contract ERC20Token is ERC20TokenInterface, SafeMath, Owned, Lockable {
94 
95     // Name of token
96     string public name;
97     // Abbreviation of tokens name
98     string public symbol;
99     // Number of decimals token has
100     uint8 public decimals;
101     // Maximum tokens that can be minted
102     uint256 public totalSupplyLimit;
103 
104     // Current supply of tokens
105     uint256 supply = 0;
106     // Map of users balances
107     mapping (address => uint256) balances;
108     // Map of users allowances
109     mapping (address => mapping (address => uint256)) allowances;
110 
111     // Event that shows that new tokens were created
112     event Mint(address indexed _to, uint256 _value);
113     // Event that shows that old tokens were destroyed
114     event Burn(address indexed _from, uint _value);
115 
116     /**
117     * @dev Returns number of tokens in circulation
118     *
119     * @return total number od tokens
120     */
121     function totalSupply() public constant returns (uint256) {
122         return supply;
123     }
124 
125     /**
126     * @dev Returns the balance of specific account
127     *
128     * @param _owner The account that caller wants to querry
129     * @return the balance on this account
130     */
131     function balanceOf(address _owner) public constant returns (uint256 balance) {
132         return balances[_owner];
133     }
134 
135     /**
136     * @dev User can transfer tokens with this method, method is disabled if emergencyLock is activated
137     *
138     * @param _to Reciever of tokens
139     * @param _value The amount of tokens that will be sent 
140     * @return if successful returns true
141     */
142     function transfer(address _to, uint256 _value) lockAffected public returns (bool success) {
143         require(_to != 0x0 && _to != address(this));
144         balances[msg.sender] = safeSub(balanceOf(msg.sender), _value);
145         balances[_to] = safeAdd(balanceOf(_to), _value);
146         Transfer(msg.sender, _to, _value);
147         return true;
148     }
149 
150     /**
151     * @dev This is used to allow some account to utilise transferFrom and sends tokens on your behalf, this method is disabled if emergencyLock is activated
152     *
153     * @param _spender Who can send tokens on your behalf
154     * @param _value The amount of tokens that are allowed to be sent 
155     * @return if successful returns true
156     */
157     function approve(address _spender, uint256 _value) lockAffected public returns (bool success) {
158         allowances[msg.sender][_spender] = _value;
159         Approval(msg.sender, _spender, _value);
160         return true;
161     }
162 
163     /**
164     * @dev This is used to send tokens and execute code on other smart contract, this method is disabled if emergencyLock is activated
165     *
166     * @param _spender Contract that is receiving tokens
167     * @param _value The amount that msg.sender is sending
168     * @param _extraData Additional params that can be used on reciving smart contract
169     * @return if successful returns true
170     */
171     function approveAndCall(address _spender, uint256 _value, bytes _extraData) lockAffected public returns (bool success) {
172         tokenRecipientInterface spender = tokenRecipientInterface(_spender);
173         approve(_spender, _value);
174         spender.receiveApproval(msg.sender, _value, this, _extraData);
175         return true;
176     }
177 
178     /**
179     * @dev Sender can transfer tokens on others behalf, this method is disabled if emergencyLock is activated
180     *
181     * @param _from The account that will send tokens
182     * @param _to Account that will recive the tokens
183     * @param _value The amount that msg.sender is sending
184     * @return if successful returns true
185     */
186     function transferFrom(address _from, address _to, uint256 _value) lockAffected public returns (bool success) {
187         require(_to != 0x0 && _to != address(this));
188         balances[_from] = safeSub(balanceOf(_from), _value);
189         balances[_to] = safeAdd(balanceOf(_to), _value);
190         allowances[_from][msg.sender] = safeSub(allowances[_from][msg.sender], _value);
191         Transfer(_from, _to, _value);
192         return true;
193     }
194 
195     /**
196     * @dev Returns the amount od tokens that can be sent from this addres by spender
197     *
198     * @param _owner Account that has tokens
199     * @param _spender Account that can spend tokens
200     * @return remaining balance to spend
201     */
202     function allowance(address _owner, address _spender) public constant returns (uint256 remaining) {
203         return allowances[_owner][_spender];
204     }
205 
206     /**
207     * @dev Creates new tokens as long as total supply does not reach limit
208     *
209     * @param _to Reciver od newly created tokens
210     * @param _amount Amount of tokens to be created;
211     */
212     function mintTokens(address _to, uint256 _amount) onlyOwner public {
213         require(supply + _amount <= totalSupplyLimit);
214         supply = safeAdd(supply, _amount);
215         balances[_to] = safeAdd(balances[_to], _amount);
216         Mint(_to, _amount);
217         Transfer(0x0, _to, _amount);
218     }
219 
220     /**
221     * @dev Destroys the amount of tokens and lowers total supply
222     *
223     * @param _amount Number of tokens user wants to destroy
224     */
225     function burn(uint _amount) public {
226         balances[msg.sender] = safeSub(balanceOf(msg.sender), _amount);
227         supply = safeSub(supply, _amount);
228         Burn(msg.sender, _amount);
229         Transfer(msg.sender, 0x0, _amount);
230     }
231 
232     /**
233     * @dev Saves exidentaly sent tokens to this contract, can be used only by owner
234     *
235     * @param _tokenAddress Address of tokens smart contract
236     * @param _to Where to send the tokens
237     * @param _amount The amount of tokens that we are salvaging
238     */
239     function salvageTokensFromContract(address _tokenAddress, address _to, uint _amount) onlyOwner public {
240         ERC20TokenInterface(_tokenAddress).transfer(_to, _amount);
241     }
242 
243     /**
244     * @dev Disables the contract and wipes all the balances, can be used only by owner
245     */
246     function killContract() public onlyOwner {
247         selfdestruct(owner);
248     }
249 }
250 
251 contract MedicoHealthContract is ERC20Token {
252 
253     /**
254     * @dev Intialises token and all the necesary variable
255     */
256     function MedicoHealthContract() {
257         name = "MedicoHealth";
258         symbol = "MHP";
259         decimals = 18;
260         totalSupplyLimit = 500000000 * 10**18;
261         lockFromSelf(0, "Lock before crowdsale starts");
262     }
263 }