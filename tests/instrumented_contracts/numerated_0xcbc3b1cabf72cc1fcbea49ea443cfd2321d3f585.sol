1 pragma solidity ^0.4.19;
2 
3 // Abstract contract for the full ERC 20 Token standard
4 // https://github.com/ethereum/EIPs/issues/20
5 
6 library SafeMath {
7  function mul(uint256 a, uint256 b) internal pure returns (uint256) {
8     if (a == 0) {
9         return 0;
10     }
11     uint256 c = a * b;
12     assert(c / a == b);
13     return c;
14     }
15 
16   function div(uint256 a, uint256 b) internal pure returns (uint256) {
17     // assert(b > 0); // Solidity automatically throws when dividing by 0
18     uint256 c = a / b;
19     // assert(a == b * c + a % b); // There is no case in which this doesn't hold
20     return c;
21   }
22 
23  function sub(uint256 a, uint256 b) internal pure returns (uint256) {
24     assert(b <= a);
25     return a - b;
26   }
27 
28   function add(uint256 a, uint256 b) internal pure returns (uint256) {
29     uint256 c = a + b;
30     assert(c >= a);
31     return c;
32   }
33 }
34 
35 
36 contract Token {
37     /* This is a slight change to the ERC20 base standard.
38     function totalSupply() constant returns (uint256 supply);
39     is replaced with:
40     uint256 public totalSupply;
41     This automatically creates a getter function for the totalSupply.
42     This is moved to the base contract since public getter functions are not
43     currently recognised as an implementation of the matching abstract
44     function by the compiler.
45     */
46     /// total amount of tokens
47     uint256 public totalSupply;
48 
49     /// @param _owner The address from which the balance will be retrieved
50     /// @return The balance
51     function balanceOf(address _owner) constant public returns (uint256 balance);
52 
53     /// @notice send `_value` token to `_to` from `msg.sender`
54     /// @param _to The address of the recipient
55     /// @param _value The amount of token to be transferred
56     /// @return Whether the transfer was successful or not
57     function transfer(address _to, uint256 _value) public returns (bool success);
58 
59     /// @notice send `_value` token to `_to` from `_from` on the condition it is approved by `_from`
60     /// @param _from The address of the sender
61     /// @param _to The address of the recipient
62     /// @param _value The amount of token to be transferred
63     /// @return Whether the transfer was successful or not
64     function transferFrom(address _from, address _to, uint256 _value) public returns (bool success);
65 
66     /// @notice `msg.sender` approves `_spender` to spend `_value` tokens
67     /// @param _spender The address of the account able to transfer the tokens
68     /// @param _value The amount of tokens to be approved for transfer
69     /// @return Whether the approval was successful or not
70     function approve(address _spender, uint256 _value) public returns (bool success);
71 
72     /// @param _owner The address of the account owning tokens
73     /// @param _spender The address of the account able to transfer the tokens
74     /// @return Amount of remaining tokens allowed to spent
75     function allowance(address _owner, address _spender) constant public returns (uint256 remaining);
76 
77     event Transfer(address indexed _from, address indexed _to, uint256 _value);
78     event Approval(address indexed _owner, address indexed _spender, uint256 _value);
79 }
80 
81 /*
82 You should inherit from StandardToken or, for a token like you would want to
83 deploy in something like Mist, see HumanStandardToken.sol.
84 (This implements ONLY the standard functions and NOTHING else.
85 If you deploy this, you won't have anything useful.)
86 
87 Implements ERC 20 Token standard: https://github.com/ethereum/EIPs/issues/20
88 .*/
89 
90 contract StandardToken is Token {
91     using SafeMath for uint256;
92 
93     function transfer(address _to, uint256 _value) public returns (bool success) {
94         require(_to != address(0));
95         require(_value <= balances[msg.sender]);
96 
97         // SafeMath.sub will throw if there is not enough balance.
98         balances[msg.sender] = balances[msg.sender].sub(_value);
99         balances[_to] = balances[_to].add(_value);
100         Transfer(msg.sender, _to, _value);
101         return true;
102 
103     }
104 
105     function transferFrom(address _from, address _to, uint256 _value) public returns (bool success) {
106         require(_to != address(0));
107         require(_value <= balances[_from]);
108         require(_value <= allowed[_from][msg.sender]);
109 
110         balances[_from] = balances[_from].sub(_value);
111         balances[_to] = balances[_to].add(_value);
112         allowed[_from][msg.sender] = allowed[_from][msg.sender].sub(_value);
113         Transfer(_from, _to, _value);
114         return true;
115     }
116 
117     function balanceOf(address _owner) constant public returns (uint256 balance) {
118         return balances[_owner];
119     }
120 
121     function approve(address _spender, uint256 _value) public returns (bool success) {
122         allowed[msg.sender][_spender] = _value;
123         Approval(msg.sender, _spender, _value);
124         return true;
125     }
126 
127     function allowance(address _owner, address _spender) constant public returns (uint256 remaining) {
128       return allowed[_owner][_spender];
129     }
130 
131     /**
132    * approve should be called when allowed[_spender] == 0. To increment
133    * allowed value is better to use this function to avoid 2 calls (and wait until
134    * the first transaction is mined)
135    */
136   function increaseApproval(address _spender, uint _addedValue) public returns (bool) {
137     allowed[msg.sender][_spender] = allowed[msg.sender][_spender].add(_addedValue);
138     Approval(msg.sender, _spender, allowed[msg.sender][_spender]);
139     return true;
140   }
141 
142   function decreaseApproval(address _spender, uint _subtractedValue) public returns (bool) {
143     uint oldValue = allowed[msg.sender][_spender];
144     if (_subtractedValue > oldValue) {
145         allowed[msg.sender][_spender] = 0;
146     } else {
147         allowed[msg.sender][_spender] = oldValue.sub(_subtractedValue);
148     }
149     Approval(msg.sender, _spender, allowed[msg.sender][_spender]);
150     return true;
151    }
152 
153 
154     mapping (address => uint256) balances;
155     mapping (address => mapping (address => uint256)) allowed;
156 }
157 
158 contract HumanStandardToken is StandardToken {
159 
160     function () public {
161         //if ether is sent to this address, send it back.
162         throw;
163     }
164 
165     /* Public variables of the token */
166 
167     /*
168     NOTE:
169     The following variables are OPTIONAL vanities. One does not have to include them.
170     They allow one to customise the token contract & in no way influences the core functionality.
171     Some wallets/interfaces might not even bother to look at this information.
172     */
173     string public name;                   //fancy name: eg YEE: a Token for Yee Ecosystem.
174     uint8 public decimals;                //How many decimals to show. ie. There could 1000 base units with 3 decimals. Meaning 0.980 YEE = 980 base units. It's like comparing 1 wei to 1 ether.
175     string public symbol;                 //An identifier: eg YEE
176     string public version = 'H0.1';       //human 0.1 standard. Just an arbitrary versioning scheme.
177 
178     function HumanStandardToken (
179         uint256 _initialAmount,
180         string _tokenName,
181         uint8 _decimalUnits,
182         string _tokenSymbol
183         ) internal {
184         balances[msg.sender] = _initialAmount;               // Give the creator all initial tokens
185         totalSupply = _initialAmount;                        // Update total supply
186         name = _tokenName;                                   // Set the name for display purposes
187         decimals = _decimalUnits;                            // Amount of decimals for display purposes
188         symbol = _tokenSymbol;                               // Set the symbol for display purposes
189     }
190 
191     /* Approves and then calls the receiving contract */
192     function approveAndCall(address _spender, uint256 _value, bytes _extraData) public returns (bool success) {
193         allowed[msg.sender][_spender] = _value;
194         Approval(msg.sender, _spender, _value);
195 
196         //call the receiveApproval function on the contract you want to be notified. This crafts the function signature manually so one doesn't have to include a contract in here just for this.
197         //receiveApproval(address _from, uint256 _value, address _tokenContract, bytes _extraData)
198         //it is assumed that when does this that the call *should* succeed, otherwise one would use vanilla approve instead.
199         if(!_spender.call(bytes4(bytes32(keccak256("receiveApproval(address,uint256,address,bytes)"))), msg.sender, _value, this, _extraData)) { throw; }
200         return true;
201     }
202 }
203 
204 contract YEEToken is HumanStandardToken(10000000000000000000000000000,"Yee - A Blockchain-powered & Cloud-based Social Ecosystem",18,"YEE"){
205  function () public {
206         //if ether is sent to this address, send it back.
207         throw;
208     }
209  
210  function YEEToken () public {
211   
212     }
213 }
214 
215 contract YeeLockerForYeePartner {
216     address public accountLocked;   //the acount been locked
217     uint256 public timeLockedStart;      //locked time 
218     uint256 public amountNeedToBeLock;  //total amount need lock
219     uint256 public unlockPeriod;      //month, quarter or year 
220     uint256 public unlockPeriodNum;   //number of period for unlock
221     
222     address  private yeeTokenAddress = 0x922105fAd8153F516bCfB829f56DC097a0E1D705;
223     YEEToken private yeeToken = YEEToken(yeeTokenAddress);
224     
225     event EvtUnlock(address lockAccount, uint256 value);
226     
227     function _balance() public view returns(uint256 amount){
228         return yeeToken.balanceOf(this);
229     }
230     
231     function unlockCurrentAvailableFunds() public returns(bool result){
232         uint256 amount = getCurrentAvailableFunds();
233         if ( amount == 0 ){
234             return false;
235         }
236         else{
237             bool ret = yeeToken.transfer(accountLocked, amount);
238             EvtUnlock(accountLocked, amount);
239             return ret;
240         }
241     }
242     
243     function getNeedLockFunds() public view returns(uint256 needLockFunds){
244         uint256 count = (now - timeLockedStart)/unlockPeriod + 1; //if first unlock is at period begin, then +1 here
245         if ( count > unlockPeriodNum ){
246             return 0;
247         }
248         else{
249             uint256 needLock = amountNeedToBeLock / unlockPeriodNum * (unlockPeriodNum - count );
250             return needLock;
251         }
252     }
253 
254     function getCurrentAvailableFunds() public view returns(uint256 availableFunds){
255         uint256 balance = yeeToken.balanceOf(this);
256         uint256 needLock = getNeedLockFunds();
257         if ( balance > needLock ){
258             return balance - needLock;
259         }
260         else{
261             return 0;
262         }
263     }
264     
265     function getNeedLockFundsFromPeriod(uint256 endTime, uint256 startTime) public view returns(uint256 needLockFunds){
266         uint256 count = (endTime - startTime)/unlockPeriod + 1; //if first unlock is at period begin, then +1 here
267         if ( count > unlockPeriodNum ){
268             return 0;
269         }
270         else{
271             uint256 needLock = amountNeedToBeLock / unlockPeriodNum * (unlockPeriodNum - count );
272             return needLock;
273         }
274     }
275     
276     function YeeLockerForYeePartner() public {
277         //Total 1.0 billion YEE to be locked
278         //Unlock 1/20 at begin of every quarter
279         accountLocked = msg.sender;
280         uint256 base = 1000000000000000000;
281         amountNeedToBeLock = 1000000000 * base; //1.0 billion
282         unlockPeriod = 91 days;
283         unlockPeriodNum = 20;
284         timeLockedStart = now;
285     }
286 }