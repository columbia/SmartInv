1 contract Token {
2     /* This is a slight change to the ERC20 base standard.
3     function totalSupply() constant returns (uint256 supply);
4     is replaced with:
5     uint256 public totalSupply;
6     This automatically creates a getter function for the totalSupply.
7     This is moved to the base contract since public getter functions are not
8     currently recognised as an implementation of the matching abstract
9     function by the compiler.
10     */
11     /// total amount of tokens
12     uint256 public totalSupply;
13 
14     /// @param _owner The address from which the balance will be retrieved
15     /// @return The balance
16     function balanceOf(address _owner) public view returns (uint256 balance);
17 
18     /// @notice send `_value` token to `_to` from `_from` on the condition it is approved by `_from`
19     /// @param _from The address of the sender
20     /// @param _to The address of the recipient
21     /// @param _value The amount of token to be transferred
22     /// @return Whether the transfer was successful or not
23     function transferFrom(address _from, address _to, uint256 _value) public returns (bool success);
24 
25     /// @notice `msg.sender` approves `_spender` to spend `_value` tokens
26     /// @param _spender The address of the account able to transfer the tokens
27     /// @param _value The amount of tokens to be approved for transfer
28     /// @return Whether the approval was successful or not
29     function approve(address _spender, uint256 _value) public returns (bool success);
30 
31     /// @param _owner The address of the account owning tokens
32     /// @param _spender The address of the account able to transfer the tokens
33     /// @return Amount of remaining tokens allowed to spent
34     function allowance(address _owner, address _spender) public view returns (uint256 remaining);
35 
36     event Transfer(address indexed _from, address indexed _to, uint256 _value);
37     event Approval(address indexed _owner, address indexed _spender, uint256 _value);
38 }
39 
40 contract StandardToken is Token {
41 
42     uint256 constant MAX_UINT256 = 2**256 - 1;
43 
44     function transferFrom(address _from, address _to, uint256 _value) public returns (bool success) {
45         uint256 allowance = allowed[_from][msg.sender];
46         require(balances[_from] >= _value && allowance >= _value);
47         balances[_to] += _value;
48         balances[_from] -= _value;
49         if (allowance < MAX_UINT256) {
50             allowed[_from][msg.sender] -= _value;
51         }
52         Transfer(_from, _to, _value);
53         return true;
54     }
55 
56     function balanceOf(address _owner) view public returns (uint256 balance) {
57         return balances[_owner];
58     }
59 
60     function approve(address _spender, uint256 _value) public returns (bool success) {
61         allowed[msg.sender][_spender] = _value;
62         Approval(msg.sender, _spender, _value);
63         return true;
64     }
65 
66     function allowance(address _owner, address _spender) view public returns (uint256 remaining) {
67       return allowed[_owner][_spender];
68     }
69 
70     mapping (address => uint256) balances;
71     mapping (address => mapping (address => uint256)) allowed;
72 }
73 
74 contract ERC223ReceivingContract {
75 /**
76  * @dev Standard ERC223 function that will handle incoming token transfers.
77  *
78  * @param _from  Token sender address.
79  * @param _value Amount of tokens.
80  * @param _data  Transaction metadata.
81  */
82     function tokenFallback(address _from, uint _value, bytes _data) public;
83 }
84 
85 contract ERC223Interface {
86     function transfer(address _to, uint _value) public returns (bool success);
87     function transfer(address _to, uint _value, bytes _data) public returns (bool success);
88     event ERC223Transfer(address indexed _from, address indexed _to, uint _value, bytes _data);
89 }
90 
91 contract HumanStandardToken is ERC223Interface, StandardToken {
92     using SafeMath for uint256;
93 
94     /* approveAndCall */
95     function approveAndCall(address _spender, uint256 _value, bytes _extraData) public returns (bool success) {
96         allowed[msg.sender][_spender] = _value;
97         Approval(msg.sender, _spender, _value);
98 
99         //call the receiveApproval function on the contract you want to be notified. This crafts the function signature manually so one doesn't have to include a contract in here just for this.
100         //receiveApproval(address _from, uint256 _value, address _tokenContract, bytes _extraData)
101         //it is assumed when one does this that the call *should* succeed, otherwise one would use vanilla approve instead.
102         require(_spender.call(bytes4(bytes32(keccak256("receiveApproval(address,uint256,address,bytes)"))), msg.sender, _value, this, _extraData));
103         return true;
104     }
105 
106     /* ERC223 */
107     function transfer(address _to, uint _value, bytes _data) public returns (bool success) {
108       // Standard function transfer similar to ERC20 transfer with no _data .
109       // Added due to backwards compatibility reasons .
110       uint codeLength;
111 
112       assembly {
113         // Retrieve the size of the code on target address, this needs assembly .
114         codeLength := extcodesize(_to)
115       }
116 
117       balances[msg.sender] = balances[msg.sender].sub(_value);
118       balances[_to] = balances[_to].add(_value);
119       if(codeLength>0) {
120         ERC223ReceivingContract receiver = ERC223ReceivingContract(_to);
121         receiver.tokenFallback(msg.sender, _value, _data);
122       }
123       Transfer(msg.sender, _to, _value);
124       ERC223Transfer(msg.sender, _to, _value, _data);
125       return true;
126     }
127 
128     function transfer(address _to, uint _value) public returns (bool success) {
129         uint codeLength;
130         bytes memory empty;
131 
132         assembly {
133             // Retrieve the size of the code on target address, this needs assembly .
134             codeLength := extcodesize(_to)
135         }
136 
137         balances[msg.sender] = balances[msg.sender].sub(_value);
138         balances[_to] = balances[_to].add(_value);
139         if(codeLength>0) {
140             ERC223ReceivingContract receiver = ERC223ReceivingContract(_to);
141             receiver.tokenFallback(msg.sender, _value, empty);
142         }
143         Transfer(msg.sender, _to, _value);
144         ERC223Transfer(msg.sender, _to, _value, empty);
145         return true;
146     }
147 }
148 
149 library SafeMath {
150   function mul(uint256 a, uint256 b) internal pure returns (uint256) {
151     if (a == 0) {
152       return 0;
153     }
154     uint256 c = a * b;
155     assert(c / a == b);
156     return c;
157   }
158 
159   function div(uint256 a, uint256 b) internal pure returns (uint256) {
160     // assert(b > 0); // Solidity automatically throws when dividing by 0
161     uint256 c = a / b;
162     // assert(a == b * c + a % b); // There is no case in which this doesn't hold
163     return c;
164   }
165 
166   function sub(uint256 a, uint256 b) internal pure returns (uint256) {
167     assert(b <= a);
168     return a - b;
169   }
170 
171   function add(uint256 a, uint256 b) internal pure returns (uint256) {
172     uint256 c = a + b;
173     assert(c >= a);
174     return c;
175   }
176 }
177 
178 contract LunetToken is HumanStandardToken {
179     using SafeMath for uint256;
180 
181     string public name = "Lunet";
182     string public symbol= "LUNET";
183     uint8 public decimals = 18;
184 
185     uint256 public tokenCreationCap = 1000000000000000000000000000; // 1 billion LUNETS
186     uint256 public lunetReserve = 50000000000000000000000000; // 50 million LUNETS - 5% of LUNETS
187 
188     event CreateLUNETS(address indexed _to, uint256 _value, uint256 _timestamp);
189     event Staked(address indexed _from, uint256 _value, uint256 _timestamp);
190     event Withdraw(address indexed _from, uint256 _value, uint256 _timestamp);
191 
192     struct Stake {
193       uint256 amount;
194       uint256 timestamp;
195     }
196 
197     mapping (address => Stake) public stakes;
198 
199     function LunetToken() public {
200        totalSupply = lunetReserve;
201        balances[msg.sender] = lunetReserve;
202        CreateLUNETS(msg.sender, lunetReserve, now);
203     }
204 
205     function stake() external payable {
206       require(msg.value > 0);
207 
208       // get stake
209       Stake storage stake = stakes[msg.sender];
210 
211       uint256 amount = stake.amount.add(msg.value);
212 
213       // update stake
214       stake.amount = amount;
215       stake.timestamp = now;
216 
217       // fire off stake event
218       Staked(msg.sender, amount, now);
219     }
220 
221     function withdraw() public {
222       // get stake
223       Stake storage stake = stakes[msg.sender];
224 
225       // check the stake is non-zero
226       require(stake.amount > 0);
227 
228       // copy amount
229       uint256 amount = stake.amount;
230 
231       // reset stake amount
232       stake.amount = 0;
233 
234       // send amount to staker
235       if (!msg.sender.send(amount)) revert();
236 
237       // fire off withdraw event
238       Withdraw(msg.sender, amount, now);
239     }
240 
241     function claim() public {
242       // get reward
243       uint256 reward = getReward(msg.sender);
244 
245       // check that the reward is non-zero
246       if (reward > 0) {
247         // reset the timestamp
248         Stake storage stake = stakes[msg.sender];
249         stake.timestamp = now;
250 
251         uint256 checkedSupply = totalSupply.add(reward);
252         if (tokenCreationCap < checkedSupply) revert();
253 
254         // update totalSupply of LUNETS
255         totalSupply = checkedSupply;
256 
257         // update LUNETS balance
258         balances[msg.sender] += reward;
259 
260         // create LUNETS
261         CreateLUNETS(msg.sender, reward, now);
262       }
263 
264     }
265 
266     function claimAndWithdraw() external {
267       claim();
268       withdraw();
269     }
270 
271     function getReward(address staker) public constant returns (uint256) {
272       // get stake
273       Stake memory stake = stakes[staker];
274 
275       // need greater precision
276       uint256 precision = 100000;
277 
278       // get difference between now and initial stake timestamp
279       uint256 difference = now.sub(stake.timestamp).mul(precision);
280 
281       // get the total number of days ETH has been locked up
282       uint totalDays = difference.div(1 days);
283 
284       // calculate reward
285       uint256 reward = stake.amount.mul(totalDays).div(precision);
286 
287       return reward;
288     }
289 
290     function getStake(address staker) external constant returns (uint256, uint256) {
291       Stake memory stake = stakes[staker];
292       return (stake.amount, stake.timestamp);
293     }
294 }