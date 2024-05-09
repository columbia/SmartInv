1 library SafeMath {
2   function mul(uint256 a, uint256 b) pure internal  returns (uint256) {
3     uint256 c = a * b;
4     assert(a == 0 || c / a == b);
5     return c;
6   }
7 
8   function div(uint256 a, uint256 b) pure internal  returns (uint256) {
9     // assert(b > 0); // Solidity automatically throws when dividing by 0
10     uint256 c = a / b;
11     // assert(a == b * c + a % b); // There is no case in which this doesn't hold
12     return c;
13   }
14 
15   function sub(uint256 a, uint256 b) pure internal  returns (uint256) {
16     assert(b <= a);
17     return a - b;
18   }
19 
20   function add(uint256 a, uint256 b) pure internal  returns (uint256) {
21     uint256 c = a + b;
22     assert(c >= a);
23     return c;
24   }
25 }
26 
27 contract Token {
28     /* This is a slight change to the ERC20 base standard.
29     function totalSupply() constant returns (uint256 supply);
30     is replaced with:
31     uint256 public totalSupply;
32     This automatically creates a getter function for the totalSupply.
33     This is moved to the base contract since public getter functions are not
34     currently recognised as an implementation of the matching abstract
35     function by the compiler.
36     */
37     /// total amount of tokens
38     uint256 public totalSupply;
39     address public sale;
40     bool public transfersAllowed;
41     
42     /// @param _owner The address from which the balance will be retrieved
43     /// @return The balance
44     function balanceOf(address _owner) constant public returns (uint256 balance);
45 
46     /// @notice send `_value` token to `_to` from `msg.sender`
47     /// @param _to The address of the recipient
48     /// @param _value The amount of token to be transferred
49     /// @return Whether the transfer was successful or not
50     function transfer(address _to, uint256 _value) public returns (bool success);
51 
52     /// @notice send `_value` token to `_to` from `_from` on the condition it is approved by `_from`
53     /// @param _from The address of the sender
54     /// @param _to The address of the recipient
55     /// @param _value The amount of token to be transferred
56     /// @return Whether the transfer was successful or not
57     function transferFrom(address _from, address _to, uint256 _value) public returns (bool success);
58 
59     /// @notice `msg.sender` approves `_spender` to spend `_value` tokens
60     /// @param _spender The address of the account able to transfer the tokens
61     /// @param _value The amount of tokens to be approved for transfer
62     /// @return Whether the approval was successful or not
63     function approve(address _spender, uint256 _value) public returns (bool success);
64 
65     /// @param _owner The address of the account owning tokens
66     /// @param _spender The address of the account able to transfer the tokens
67     /// @return Amount of remaining tokens allowed to spent
68     function allowance(address _owner, address _spender) constant public returns (uint256 remaining);
69 
70     event Transfer(address indexed _from, address indexed _to, uint256 _value);
71     event Approval(address indexed _owner, address indexed _spender, uint256 _value);
72 }
73 
74 contract StandardToken is Token {
75 
76     function transfer(address _to, uint256 _value)
77         public
78         validTransfer
79        	returns (bool success) 
80     {
81         //Default assumes totalSupply can't be over max (2^256 - 1).
82         //If your token leaves out totalSupply and can issue more tokens as time goes on, you need to check if it doesn't wrap.
83         //Replace the if with this one instead.
84         //require(balances[msg.sender] >= _value && balances[_to] + _value > balances[_to]);
85     	require(balances[msg.sender] >= _value);
86         balances[msg.sender] = SafeMath.sub(balances[msg.sender], _value);
87         balances[_to] = SafeMath.add(balances[_to],_value);
88         Transfer(msg.sender, _to, _value);
89         return true;
90     }
91 
92     function transferFrom(address _from, address _to, uint256 _value)
93         public
94         validTransfer
95       	returns (bool success)
96       {
97         //same as above. Replace this line with the following if you want to protect against wrapping uints.
98         //require(balances[_from] >= _value && allowed[_from][msg.sender] >= _value && balances[_to] + _value > balances[_to]);
99 	    require(balances[_from] >= _value && allowed[_from][msg.sender] >= _value);
100         balances[_to] = SafeMath.add(balances[_to], _value);
101         balances[_from] = SafeMath.sub(balances[_from], _value);
102         allowed[_from][msg.sender] = SafeMath.sub(allowed[_from][msg.sender], _value);
103         Transfer(_from, _to, _value);
104         return true;
105     }
106 
107     function balanceOf(address _owner) public constant returns (uint256 balance) {
108         return balances[_owner];
109     }
110 
111     function approve(address _spender, uint256 _value) public returns (bool success) {
112         require(balances[msg.sender] >= _value);
113         allowed[msg.sender][_spender] = _value;
114         Approval(msg.sender, _spender, _value);
115         return true;
116     }
117 
118     function allowance(address _owner, address _spender) public constant returns (uint256 remaining) {
119       return allowed[_owner][_spender];
120     }
121 
122     mapping (address => uint256) balances;
123     mapping (address => mapping (address => uint256)) allowed;
124 
125     modifier validTransfer()
126     {
127         require(msg.sender == sale || transfersAllowed);
128         _;
129     }   
130 }
131 
132 contract HumanStandardToken is StandardToken {
133 
134     /* Public variables of the token */
135 
136     /*
137     NOTE:
138     The following variables are OPTIONAL vanities. One does not have to include them.
139     They allow one to customise the token contract & in no way influences the core functionality.
140     Some wallets/interfaces might not even bother to look at this information.
141     */
142     string public name;                   //fancy name: eg Simon Bucks
143     uint8 public decimals;                //How many decimals to show. ie. There could 1000 base units with 3 decimals. Meaning 0.980 SBX = 980 base units. It's like comparing 1 wei to 1 ether.
144     string public symbol;                 //An identifier: eg SBX
145     string public version = 'H0.1';       //human 0.1 standard. Just an arbitrary versioning scheme.
146 
147     function HumanStandardToken(
148         uint256 _initialAmount,
149         string _tokenName,
150         uint8 _decimalUnits,
151         string _tokenSymbol,
152         address _sale)
153         public
154     {
155         balances[msg.sender] = _initialAmount;               // Give the creator all initial tokens
156         totalSupply = _initialAmount;                        // Update total supply
157         name = _tokenName;                                   // Set the name for display purposes
158         decimals = _decimalUnits;                            // Amount of decimals for display purposes
159         symbol = _tokenSymbol;                               // Set the symbol for display purposes
160         sale = _sale;
161         transfersAllowed = false;
162     }
163 
164     /* Approves and then calls the receiving contract */
165     function approveAndCall(address _spender, uint256 _value, bytes _extraData) public returns (bool success) {
166         allowed[msg.sender][_spender] = _value;
167         Approval(msg.sender, _spender, _value);
168 
169         //call the receiveApproval function on the contract you want to be notified. This crafts the function signature manually so one doesn't have to include a contract in here just for this.
170         //receiveApproval(address _from, uint256 _value, address _tokenContract, bytes _extraData)
171         //it is assumed that when does this that the call *should* succeed, otherwise one would use vanilla approve instead.
172         require(_spender.call(bytes4(bytes32(keccak256("receiveApproval(address,uint256,address,bytes)"))), msg.sender, _value, this, _extraData));
173         return true;
174     }
175 
176     function reversePurchase(address _tokenHolder)
177         public
178         onlySale
179     {
180         require(!transfersAllowed);
181         uint value = balances[_tokenHolder];
182         balances[_tokenHolder] = SafeMath.sub(balances[_tokenHolder], value);
183         balances[sale] = SafeMath.add(balances[sale], value);
184         Transfer(_tokenHolder, sale, value);
185     }
186 
187     function removeTransferLock()
188         public
189         onlySale
190     {
191         transfersAllowed = true;
192     }
193 
194     modifier onlySale()
195     {
196         require(msg.sender == sale);
197         _;
198     }
199 }
200 
201 contract Disbursement {
202 
203     /*
204      *  Storage
205      */
206     address public owner;
207     address public receiver;
208     uint public disbursementPeriod;
209     uint public startDate;
210     uint public withdrawnTokens;
211     Token public token;
212 
213     /*
214      *  Modifiers
215      */
216     modifier isOwner() {
217         if (msg.sender != owner)
218             // Only owner is allowed to proceed
219             revert();
220         _;
221     }
222 
223     modifier isReceiver() {
224         if (msg.sender != receiver)
225             // Only receiver is allowed to proceed
226             revert();
227         _;
228     }
229 
230     modifier isSetUp() {
231         if (address(token) == 0)
232             // Contract is not set up
233             revert();
234         _;
235     }
236 
237     /*
238      *  Public functions
239      */
240     /// @dev Constructor function sets contract owner
241     /// @param _receiver Receiver of vested tokens
242     /// @param _disbursementPeriod Vesting period in seconds
243     /// @param _startDate Start date of disbursement period (cliff)
244     function Disbursement(address _receiver, uint _disbursementPeriod, uint _startDate)
245         public
246     {
247         if (_receiver == 0 || _disbursementPeriod == 0)
248             // Arguments are null
249             revert();
250         owner = msg.sender;
251         receiver = _receiver;
252         disbursementPeriod = _disbursementPeriod;
253         startDate = _startDate;
254         if (startDate == 0)
255             startDate = now;
256     }
257 
258     /// @dev Setup function sets external contracts' addresses
259     /// @param _token Token address
260     function setup(Token _token)
261         public
262         isOwner
263     {
264         if (address(token) != 0 || address(_token) == 0)
265             // Setup was executed already or address is null
266             revert();
267         token = _token;
268     }
269 
270     /// @dev Transfers tokens to a given address
271     /// @param _to Address of token receiver
272     /// @param _value Number of tokens to transfer
273     function withdraw(address _to, uint256 _value)
274         public
275         isReceiver
276         isSetUp
277     {
278         uint maxTokens = calcMaxWithdraw();
279         if (_value > maxTokens)
280             revert();
281         withdrawnTokens = SafeMath.add(withdrawnTokens, _value);
282         token.transfer(_to, _value);
283     }
284 
285     /// @dev Calculates the maximum amount of vested tokens
286     /// @return Number of vested tokens to withdraw
287     function calcMaxWithdraw()
288         public
289         constant
290         returns (uint)
291     {
292         uint maxTokens = SafeMath.mul(SafeMath.add(token.balanceOf(this), withdrawnTokens), SafeMath.sub(now,startDate)) / disbursementPeriod;
293         //uint maxTokens = (token.balanceOf(this) + withdrawnTokens) * (now - startDate) / disbursementPeriod;
294         if (withdrawnTokens >= maxTokens || startDate > now)
295             return 0;
296         if (SafeMath.sub(maxTokens, withdrawnTokens) > token.totalSupply())
297             return token.totalSupply();
298         return SafeMath.sub(maxTokens, withdrawnTokens);
299     }
300 }