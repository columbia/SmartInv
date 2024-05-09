1 pragma solidity ^0.4.24;
2 
3 contract Ownable {
4     address public owner;
5 
6     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
7     /**
8      * @dev The Ownable constructor sets the original `owner` of the contract to the sender
9      * account.
10      */
11     constructor() public {
12         owner = msg.sender;
13     }
14     /**
15      * @dev Throws if called by any account other than the owner.
16      */
17     modifier onlyOwner() {
18         require(msg.sender == owner);
19         _;
20     }
21     /**
22     * @dev Allows the current owner to transfer control of the contract to a newOwner.
23     * @param newOwner The address to transfer ownership to.
24     */
25     function transferOwnership(address newOwner) public onlyOwner {
26         require(newOwner != address(0));
27         emit OwnershipTransferred(owner, newOwner);
28         owner = newOwner;
29     }
30 }
31 
32 library SafeMath {
33     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
34         require(b <= a);
35         return a - b;
36     }
37 
38     function add(uint256 a, uint256 b) internal pure returns (uint256) {
39         uint256 c = a + b;
40         require(c >= a);
41         return c;
42     }
43 }
44 
45 /**
46  * @title tokenRecipient
47  * @dev An interface capable of calling `receiveApproval`, which is used by `approveAndCall` to notify the contract from this interface
48  */
49 interface tokenRecipient { function receiveApproval(address from, uint256 value, address token, bytes extraData) external; }
50 
51 /**
52  * @title TokenERC20
53  * @dev A simple ERC20 standard token with burnable function
54  */
55 contract TokenERC20 {
56     using SafeMath for uint256;
57 
58     // Total number of tokens in existence
59     uint256 public totalSupply;
60 
61     // This creates an array with all balances
62     mapping(address => uint256) internal balances;
63     mapping(address => mapping(address => uint256)) internal allowed;
64 
65     // This notifies clients about the amount burnt/transferred/approved
66     event Burn(address indexed from, uint256 value);
67     event Transfer(address indexed from, address indexed to, uint256 value);
68     event Approval(address indexed owner, address indexed spender, uint256 value);
69 
70     /**
71      * @dev Gets the balance of the specified address
72      * @param _owner The address to query
73      * @return Token balance of `_owner`
74      */
75     function balanceOf(address _owner) view public returns(uint256) {
76         return balances[_owner];
77     }
78 
79     /**
80      * @dev Gets a spender's allowance from a token holder
81      * @param _owner The address which allows spender to spend
82      * @param _spender The address being allowed
83      * @return Approved amount for `spender` to spend from `_owner`
84      */
85     function allowance(address _owner, address _spender) view public returns(uint256) {
86         return allowed[_owner][_spender];
87     }
88 
89     /**
90      * @dev Basic transfer of all transfer-related functions
91      * @param _from The address of sender
92      * @param _to The address of recipient
93      * @param _value The amount sender want to transfer to recipient
94      */
95     function _transfer(address _from, address _to, uint _value) internal {
96         balances[_from] = balances[_from].sub(_value);
97         balances[_to] = balances[_to].add(_value);
98         emit Transfer( _from, _to, _value);
99     }
100 
101     /**
102      * @notice Transfer tokens
103      * @dev Send `_value` tokens to `_to` from your account
104      * @param _to The address of the recipient
105      * @param _value The amount to send
106      * @return True if the transfer is done without error
107      */
108     function transfer(address _to, uint256 _value) public returns(bool) {
109         _transfer(msg.sender, _to, _value);
110         return true;
111     }
112 
113     /**
114      * @notice Transfer tokens from other address
115      * @dev Send `_value` tokens to `_to` on behalf of `_from`
116      * @param _from The address of the sender
117      * @param _to The address of the recipient
118      * @param _value The amount to send
119      * @return True if the transfer is done without error
120      */
121     function transferFrom(address _from, address _to, uint256 _value) public returns(bool) {
122         allowed[_from][msg.sender] = allowed[_from][msg.sender].sub(_value);
123         _transfer(_from, _to, _value);
124         return true;
125     }
126 
127     /**
128      * @notice Set allowance for other address
129      * @dev Allows `_spender` to spend no more than `_value` tokens on your behalf
130      * @param _spender The address authorized to spend
131      * @param _value the max amount they can spend
132      * @return True if the approval is done without error
133      */
134     function approve(address _spender, uint256 _value) public returns(bool) {
135         allowed[msg.sender][_spender] = _value;
136         emit Approval(msg.sender, _spender, _value);
137         return true;
138     }
139 
140     /**
141      * @notice Set allowance for other address and notify
142      * @dev Allows contract `_spender` to spend no more than `_value` tokens on your behalf, and then ping the contract about it
143      * @param _spender The contract address authorized to spend
144      * @param _value the max amount they can spend
145      * @param _extraData some extra information to send to the approved contract
146      * @return True if it is done without error
147      */
148     function approveAndCall(address _spender, uint256 _value, bytes _extraData) public returns(bool) {
149         tokenRecipient spender = tokenRecipient(_spender);
150         if (approve(_spender, _value)) {
151             spender.receiveApproval(msg.sender, _value, this, _extraData);
152             return true;
153         }
154         return false;
155     }
156 
157     /**
158      * @notice Destroy tokens
159      * @dev Remove `_value` tokens from the system irreversibly
160      * @param _value The amount of money will be burned
161      * @return True if `_value` is burned successfully
162      */
163     function burn(uint256 _value) public returns(bool) {
164         balances[msg.sender] = balances[msg.sender].sub(_value);
165         totalSupply = totalSupply.sub(_value);
166         emit Burn(msg.sender, _value);
167         return true;
168     }
169 
170     /**
171      * @notice Destroy tokens from other account
172      * @dev Remove `_value` tokens from the system irreversibly on behalf of `_from`.
173      * @param _from The address of the burner
174      * @param _value The amount of token will be burned
175      * @return True if `_value` is burned successfully
176      */
177     function burnFrom(address _from, uint256 _value) public returns(bool) {
178         allowed[_from][msg.sender] = allowed[_from][msg.sender].sub(_value);
179         balances[_from] = balances[_from].sub(_value);
180         totalSupply = totalSupply.sub(_value);
181         emit Burn(_from, _value);
182         return true;
183     }
184 
185     /**
186      * @notice Transfer tokens to multiple account
187      * @dev Send `_value` tokens to corresponding `_to` from your account
188      * @param _to The array of ddress of the recipients
189      * @param _value The array of amount to send
190      * @return True if the transfer is done without error
191      */
192     function transferMultiple(address[] _to, uint256[] _value) external returns(bool) {
193         require(_to.length == _value.length);
194         uint256 i = 0;
195         while (i < _to.length) {
196            _transfer(msg.sender, _to[i], _value[i]);
197            i += 1;
198         }
199         return true;
200     }
201 }
202 
203 /**
204  * @title EventSponsorshipToken
205  * @author Ping Chen
206  */
207 contract EventSponsorshipToken is TokenERC20 {
208     using SafeMath for uint256;
209 
210     // Token Info.
211     string public constant name = "EventSponsorshipToken";
212     string public constant symbol = "EST";
213     uint8 public constant decimals = 18;
214 
215     /**
216      * @dev contract constructor
217      * @param _wallet The address where initial supply goes to
218      * @param _totalSupply initial supply
219      */
220     constructor(address _wallet, uint256 _totalSupply) public {
221         totalSupply = _totalSupply;
222         balances[_wallet] = _totalSupply;
223     }
224 
225 }
226 
227 contract ESTVault is Ownable {
228     using SafeMath for uint256;
229 
230     struct vault {
231         uint256 amount;
232         uint256 unlockTime;
233         bool claimed;
234     }
235 
236     mapping(address => vault[]) public vaults;
237 
238     EventSponsorshipToken EST = EventSponsorshipToken(0xD427c628C5f72852965fADAf1231b618c0C82395);
239 
240     event Lock(address to, uint256 value, uint256 time);
241     event Revoke(address to, uint256 index);
242     event Redeem(address to, uint256 index);
243 
244     function lock(address to, uint256 value, uint256 time) external {
245         _lock(to, value, time);
246     }
247 
248     function lockMultiple(address[] to, uint256[] value, uint256[] time) external {
249         require(to.length == value.length && to.length == time.length);
250         for(uint256 i = 0 ; i < to.length ; i++)
251             _lock(to[i], value[i], time[i]);
252     }
253 
254     function revoke(address to, uint256 index) public onlyOwner {
255         vault storage v = vaults[to][index];
256         require(now >= v.unlockTime);
257         require(!v.claimed);
258         v.claimed = true;
259         require(EST.transfer(msg.sender, v.amount));
260         emit Revoke(to, index);
261     }
262 
263     function _lock(address to, uint256 value, uint256 time) internal {
264         require(EST.transferFrom(msg.sender, address(this), value));
265         vault memory v;
266         v.amount = value;
267         v.unlockTime = time;
268         vaults[to].push(v);
269         emit Lock(to, value, time);
270     }
271 
272     function redeem(uint256 index) external {
273         vault storage v = vaults[msg.sender][index];
274         require(now >= v.unlockTime);
275         require(!v.claimed);
276         v.claimed = true;
277         require(EST.transfer(msg.sender, v.amount));
278         emit Redeem(msg.sender, index);
279     }
280 
281 }