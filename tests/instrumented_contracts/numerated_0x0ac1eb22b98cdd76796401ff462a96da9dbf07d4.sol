1 pragma solidity ^0.4.18;
2 
3 // File: contracts/SafeMath.sol
4 
5 /**
6  * @title SafeMath
7  * @dev Math operations with safety checks that throw on error
8  */
9 library SafeMath {
10   function mul(uint256 a, uint256 b) pure internal  returns (uint256) {
11     uint256 c = a * b;
12     assert(a == 0 || c / a == b);
13     return c;
14   }
15 
16   function div(uint256 a, uint256 b) pure internal  returns (uint256) {
17     // assert(b > 0); // Solidity automatically throws when dividing by 0
18     uint256 c = a / b;
19     // assert(a == b * c + a % b); // There is no case in which this doesn't hold
20     return c;
21   }
22 
23   function sub(uint256 a, uint256 b) pure internal  returns (uint256) {
24     assert(b <= a);
25     return a - b;
26   }
27 
28   function add(uint256 a, uint256 b) pure internal  returns (uint256) {
29     uint256 c = a + b;
30     assert(c >= a);
31     return c;
32   }
33 }
34 
35 // File: contracts/Token.sol
36 
37 // Abstract contract for the full ERC 20 Token standard
38 // https://github.com/ethereum/EIPs/issues/20
39 pragma solidity ^0.4.8;
40 
41 contract Token {
42     /* This is a slight change to the ERC20 base standard.
43     function totalSupply() constant returns (uint256 supply);
44     is replaced with:
45     uint256 public totalSupply;
46     This automatically creates a getter function for the totalSupply.
47     This is moved to the base contract since public getter functions are not
48     currently recognised as an implementation of the matching abstract
49     function by the compiler.
50     */
51     /// total amount of tokens
52     uint256 public totalSupply;
53     address public sale;
54     bool public transfersAllowed;
55     
56     /// @param _owner The address from which the balance will be retrieved
57     /// @return The balance
58     function balanceOf(address _owner) constant public returns (uint256 balance);
59 
60     /// @notice send `_value` token to `_to` from `msg.sender`
61     /// @param _to The address of the recipient
62     /// @param _value The amount of token to be transferred
63     /// @return Whether the transfer was successful or not
64     function transfer(address _to, uint256 _value) public returns (bool success);
65 
66     /// @notice send `_value` token to `_to` from `_from` on the condition it is approved by `_from`
67     /// @param _from The address of the sender
68     /// @param _to The address of the recipient
69     /// @param _value The amount of token to be transferred
70     /// @return Whether the transfer was successful or not
71     function transferFrom(address _from, address _to, uint256 _value) public returns (bool success);
72 
73     /// @notice `msg.sender` approves `_spender` to spend `_value` tokens
74     /// @param _spender The address of the account able to transfer the tokens
75     /// @param _value The amount of tokens to be approved for transfer
76     /// @return Whether the approval was successful or not
77     function approve(address _spender, uint256 _value) public returns (bool success);
78 
79     /// @param _owner The address of the account owning tokens
80     /// @param _spender The address of the account able to transfer the tokens
81     /// @return Amount of remaining tokens allowed to spent
82     function allowance(address _owner, address _spender) constant public returns (uint256 remaining);
83 
84     event Transfer(address indexed _from, address indexed _to, uint256 _value);
85     event Approval(address indexed _owner, address indexed _spender, uint256 _value);
86 }
87 
88 // File: contracts/Disbursement.sol
89 
90 // NOTE: ORIGINALLY THIS WAS "TOKENS/ABSTRACTTOKEN.SOL"... CHECK THAT
91 
92 
93 /// @title Disbursement contract - allows to distribute tokens over time
94 /// @author Stefan George - <stefan@gnosis.pm>
95 contract Disbursement {
96 
97     /*
98      *  Storage
99      */
100     address public owner;
101     address public receiver;
102     uint public disbursementPeriod;
103     uint public startDate;
104     uint public withdrawnTokens;
105     Token public token;
106 
107     /*
108      *  Modifiers
109      */
110     modifier isOwner() {
111         if (msg.sender != owner)
112             // Only owner is allowed to proceed
113             revert();
114         _;
115     }
116 
117     modifier isReceiver() {
118         if (msg.sender != receiver)
119             // Only receiver is allowed to proceed
120             revert();
121         _;
122     }
123 
124     modifier isSetUp() {
125         if (address(token) == 0)
126             // Contract is not set up
127             revert();
128         _;
129     }
130 
131     /*
132      *  Public functions
133      */
134     /// @dev Constructor function sets contract owner
135     /// @param _receiver Receiver of vested tokens
136     /// @param _disbursementPeriod Vesting period in seconds
137     /// @param _startDate Start date of disbursement period (cliff)
138     function Disbursement(address _receiver, uint _disbursementPeriod, uint _startDate)
139         public
140     {
141         if (_receiver == 0 || _disbursementPeriod == 0)
142             // Arguments are null
143             revert();
144         owner = msg.sender;
145         receiver = _receiver;
146         disbursementPeriod = _disbursementPeriod;
147         startDate = _startDate;
148         if (startDate == 0)
149             startDate = now;
150     }
151 
152     /// @dev Setup function sets external contracts' addresses
153     /// @param _token Token address
154     function setup(Token _token)
155         public
156         isOwner
157     {
158         if (address(token) != 0 || address(_token) == 0)
159             // Setup was executed already or address is null
160             revert();
161         token = _token;
162     }
163 
164     /// @dev Transfers tokens to a given address
165     /// @param _to Address of token receiver
166     /// @param _value Number of tokens to transfer
167     function withdraw(address _to, uint256 _value)
168         public
169         isReceiver
170         isSetUp
171     {
172         uint maxTokens = calcMaxWithdraw();
173         if (_value > maxTokens)
174             revert();
175         withdrawnTokens = SafeMath.add(withdrawnTokens, _value);
176         token.transfer(_to, _value);
177     }
178 
179     /// @dev Calculates the maximum amount of vested tokens
180     /// @return Number of vested tokens to withdraw
181     function calcMaxWithdraw()
182         public
183         constant
184         returns (uint)
185     {
186         uint maxTokens = SafeMath.mul(SafeMath.add(token.balanceOf(this), withdrawnTokens), SafeMath.sub(now,startDate)) / disbursementPeriod;
187         //uint maxTokens = (token.balanceOf(this) + withdrawnTokens) * (now - startDate) / disbursementPeriod;
188         if (withdrawnTokens >= maxTokens || startDate > now)
189             return 0;
190         if (SafeMath.sub(maxTokens, withdrawnTokens) > token.totalSupply())
191             return token.totalSupply();
192         return SafeMath.sub(maxTokens, withdrawnTokens);
193     }
194 }
195 
196 // File: contracts/Owned.sol
197 
198 contract Owned {
199   event OwnerAddition(address indexed owner);
200 
201   event OwnerRemoval(address indexed owner);
202 
203   // owner address to enable admin functions
204   mapping (address => bool) public isOwner;
205 
206   address[] public owners;
207 
208   address public operator;
209 
210   modifier onlyOwner {
211 
212     require(isOwner[msg.sender]);
213     _;
214   }
215 
216   modifier onlyOperator {
217     require(msg.sender == operator);
218     _;
219   }
220 
221   function setOperator(address _operator) external onlyOwner {
222     require(_operator != address(0));
223     operator = _operator;
224   }
225 
226   function removeOwner(address _owner) public onlyOwner {
227     require(owners.length > 1);
228     isOwner[_owner] = false;
229     for (uint i = 0; i < owners.length - 1; i++) {
230       if (owners[i] == _owner) {
231         owners[i] = owners[SafeMath.sub(owners.length, 1)];
232         break;
233       }
234     }
235     owners.length = SafeMath.sub(owners.length, 1);
236     OwnerRemoval(_owner);
237   }
238 
239   function addOwner(address _owner) external onlyOwner {
240     require(_owner != address(0));
241     if(isOwner[_owner]) return;
242     isOwner[_owner] = true;
243     owners.push(_owner);
244     OwnerAddition(_owner);
245   }
246 
247   function setOwners(address[] _owners) internal {
248     for (uint i = 0; i < _owners.length; i++) {
249       require(_owners[i] != address(0));
250       isOwner[_owners[i]] = true;
251       OwnerAddition(_owners[i]);
252     }
253     owners = _owners;
254   }
255 
256   function getOwners() public constant returns (address[])  {
257     return owners;
258   }
259 
260 }
261 
262 // File: contracts/TokenLock.sol
263 
264 /**
265 this contract should be the address for disbursement contract.
266 It should not allow to disburse any token for a given time "initialLockTime"
267 lock "50%" of tokens for 10 years.
268 transfer 50% of tokens to a given address.
269 */
270 contract TokenLock is Owned {
271   using SafeMath for uint;
272 
273   uint public shortLock;
274 
275   uint public longLock;
276 
277   uint public shortShare;
278 
279   address public levAddress;
280 
281   address public disbursement;
282 
283   uint public longTermTokens;
284 
285   modifier validAddress(address _address){
286     require(_address != 0);
287     _;
288   }
289 
290   function TokenLock(address[] _owners, uint _shortLock, uint _longLock, uint _shortShare) public {
291     require(_longLock > _shortLock);
292     require(_shortLock > 0);
293     require(_shortShare <= 100);
294     setOwners(_owners);
295     shortLock = block.timestamp.add(_shortLock);
296     longLock = block.timestamp.add(_longLock);
297     shortShare = _shortShare;
298   }
299 
300   function setup(address _disbursement, address _levToken) public onlyOwner {
301     require(_disbursement != address(0));
302     require(_levToken != address(0));
303     disbursement = _disbursement;
304     levAddress = _levToken;
305   }
306 
307   function transferShortTermTokens(address _wallet) public validAddress(_wallet) onlyOwner {
308     require(now > shortLock);
309     uint256 tokenBalance = Token(levAddress).balanceOf(disbursement);
310     // long term tokens can be set only once.
311     if (longTermTokens == 0) {
312       longTermTokens = tokenBalance.mul(100 - shortShare).div(100);
313     }
314     require(tokenBalance > longTermTokens);
315     uint256 amountToSend = tokenBalance.sub(longTermTokens);
316     Disbursement(disbursement).withdraw(_wallet, amountToSend);
317   }
318 
319   function transferLongTermTokens(address _wallet) public validAddress(_wallet) onlyOwner {
320     require(now > longLock);
321     // 1. Get how many tokens this contract has with a token instance and check this token balance
322     uint256 tokenBalance = Token(levAddress).balanceOf(disbursement);
323 
324     // 2. Transfer those tokens with the _shortShare percentage
325     Disbursement(disbursement).withdraw(_wallet, tokenBalance);
326   }
327 }