1 pragma solidity ^0.4.21;
2 
3 contract Owned {
4     
5     /// 'owner' is the only address that can call a function with 
6     /// this modifier
7     address public owner;
8     address internal newOwner;
9     
10     ///@notice The constructor assigns the message sender to be 'owner'
11     function Owned() public {
12         owner = msg.sender;
13     }
14     
15     modifier onlyOwner() {
16         require(msg.sender == owner);
17         _;
18     }
19     
20     event updateOwner(address _oldOwner, address _newOwner);
21     
22     ///change the owner
23     function changeOwner(address _newOwner) public onlyOwner returns(bool) {
24         require(owner != _newOwner);
25         newOwner = _newOwner;
26         return true;
27     }
28     
29     /// accept the ownership
30     function acceptNewOwner() public returns(bool) {
31         require(msg.sender == newOwner);
32         emit updateOwner(owner, newOwner);
33         owner = newOwner;
34         return true;
35     }
36     
37 }
38 
39 // Safe maths, borrowed from OpenZeppelin
40 library SafeMath {
41 
42     function mul(uint a, uint b) internal pure returns (uint) {
43         uint c = a * b;
44         assert(a == 0 || c / a == b);
45         return c;
46     }
47     
48     function div(uint a, uint b) internal pure returns (uint) {
49         // assert(b > 0); // Solidity automatically throws when dividing by 0
50         uint c = a / b;
51         return c;
52     }
53     
54     function sub(uint a, uint b) internal pure returns (uint) {
55         assert(b <= a);
56         return a - b;
57     }
58     
59     function add(uint a, uint b) internal pure returns (uint) {
60         uint c = a + b;
61         assert(c >= a);
62         return c;
63     }
64 }
65 
66 contract ERC20Token {
67     /* This is a slight change to the ERC20 base standard.
68     function totalSupply() constant returns (uint256 supply);
69     is replaced with:
70     uint256 public totalSupply;
71     This automatically creates a getter function for the totalSupply.
72     This is moved to the base contract since public getter functions are not
73     currently recognised as an implementation of the matching abstract
74     function by the compiler.
75     */
76     /// total amount of tokens
77     uint256 public totalSupply;
78     
79     /// user tokens
80     mapping (address => uint256) public balances;
81     
82     /// @param _owner The address from which the balance will be retrieved
83     /// @return The balance
84     function balanceOf(address _owner) constant public returns (uint256 balance);
85 
86     /// @notice send `_value` token to `_to` from `msg.sender`
87     /// @param _to The address of the recipient
88     /// @param _value The amount of token to be transferred
89     /// @return Whether the transfer was successful or not
90     function transfer(address _to, uint256 _value) public returns (bool success);
91     
92     /// @notice send `_value` token to `_to` from `_from` on the condition it is approved by `_from`
93     /// @param _from The address of the sender
94     /// @param _to The address of the recipient
95     /// @param _value The amount of token to be transferred
96     /// @return Whether the transfer was successful or not
97     function transferFrom(address _from, address _to, uint256 _value) public returns (bool success);
98 
99     /// @notice `msg.sender` approves `_spender` to spend `_value` tokens
100     /// @param _spender The address of the account able to transfer the tokens
101     /// @param _value The amount of tokens to be approved for transfer
102     /// @return Whether the approval was successful or not
103     function approve(address _spender, uint256 _value) public returns (bool success);
104 
105     /// @param _owner The address of the account owning tokens
106     /// @param _spender The address of the account able to transfer the tokens
107     /// @return Amount of remaining tokens allowed to spent
108     function allowance(address _owner, address _spender) constant public returns (uint256 remaining);
109 
110     event Transfer(address indexed _from, address indexed _to, uint256 _value);
111     event Approval(address indexed _owner, address indexed _spender, uint256 _value);
112 }
113 
114 contract Controlled is Owned, ERC20Token {
115     using SafeMath for uint;
116     uint256 public releaseStartTime;
117     uint256 oneMonth = 3600 * 24 * 30;
118     
119     // Flag that determines if the token is transferable or not
120     bool  public emergencyStop = false;
121     
122     struct userToken {
123         uint256 UST;
124         uint256 addrLockType;
125     }
126     mapping (address => userToken) public userReleaseToken;
127     
128     modifier canTransfer {
129         require(emergencyStop == false);
130         _;
131     }
132     
133     modifier releaseTokenValid(address _user, uint256 _time, uint256 _value) {
134 		uint256 _lockTypeIndex = userReleaseToken[_user].addrLockType;
135 		if(_lockTypeIndex != 0) {
136 			require (balances[_user].sub(_value) >= userReleaseToken[_user].UST.sub(calcReleaseToken(_user, _time, _lockTypeIndex)));
137         }
138         
139 		_;
140     }
141     
142     
143     function canTransferUST(bool _bool) public onlyOwner{
144         emergencyStop = _bool;
145     }
146     
147     /// @notice get `_user` transferable token amount 
148     /// @param _user The user's address
149     /// @param _time The present time
150     /// @param _lockTypeIndex The user's investment lock type
151     /// @return Return the amount of user's transferable token
152     function calcReleaseToken(address _user, uint256 _time, uint256 _lockTypeIndex) internal view returns (uint256) {
153         uint256 _timeDifference = _time.sub(releaseStartTime);
154         uint256 _whichPeriod = getPeriod(_lockTypeIndex, _timeDifference);
155         
156         if(_lockTypeIndex == 1) {
157             
158             return (percent(userReleaseToken[_user].UST, 25) + percent(userReleaseToken[_user].UST, _whichPeriod.mul(25)));
159         }
160         
161         if(_lockTypeIndex == 2) {
162             return (percent(userReleaseToken[_user].UST, 25) + percent(userReleaseToken[_user].UST, _whichPeriod.mul(25)));
163         }
164         
165         if(_lockTypeIndex == 3) {
166             return (percent(userReleaseToken[_user].UST, 10) + percent(userReleaseToken[_user].UST, _whichPeriod.mul(15)));
167         }
168 		
169 		revert();
170     
171     }
172     
173     /// @notice get time period for the given '_lockTypeIndex'
174     /// @param _lockTypeIndex The user's investment locktype index
175     /// @param _timeDifference The passed time since releaseStartTime to now
176     /// @return Return the time period
177     function getPeriod(uint256 _lockTypeIndex, uint256 _timeDifference) internal view returns (uint256) {
178         if(_lockTypeIndex == 1) {           //The lock for the usechain coreTeamSupply
179             uint256 _period1 = (_timeDifference.div(oneMonth)).div(12);
180             if(_period1 >= 3){
181                 _period1 = 3;
182             }
183             return _period1;
184         }
185         if(_lockTypeIndex == 2) {           //The lock for medium investment
186             uint256 _period2 = _timeDifference.div(oneMonth);
187             if(_period2 >= 3){
188                 _period2 = 3;
189             }
190             return _period2;
191         }
192         if(_lockTypeIndex == 3) {           //The lock for massive investment
193             uint256 _period3 = _timeDifference.div(oneMonth);
194             if(_period3 >= 6){
195                 _period3 = 6;
196             }
197             return _period3;
198         }
199 		
200 		revert();
201     }
202     
203     function percent(uint _token, uint _percentage) internal pure returns (uint) {
204         return _percentage.mul(_token).div(100);
205     }
206     
207 }
208 
209 contract standardToken is ERC20Token, Controlled {
210     
211     mapping (address => mapping (address => uint256)) public allowances;
212     
213     /// @param _owner The address that's balance is being requested
214     /// @return The balance of `_owner` at the current block
215     function balanceOf(address _owner) constant public returns (uint256) {
216         return balances[_owner];
217     }
218 
219     /// @notice Send `_value` tokens to `_to` from `msg.sender`
220     /// @param _to The address of the recipient
221     /// @param _value The amount of tokens to be transferred
222     /// @return Whether the transfer was successful or not
223     
224 	function transfer(
225         address _to,
226         uint256 _value) 
227         public 
228         canTransfer
229         releaseTokenValid(msg.sender, now, _value)
230         returns (bool) 
231     {
232         require (balances[msg.sender] >= _value);           // Throw if sender has insufficient balance
233         require (balances[_to] + _value >= balances[_to]);  // Throw if owerflow detected
234         balances[msg.sender] -= _value;                     // Deduct senders balance
235         balances[_to] += _value;                            // Add recivers balance
236         emit Transfer(msg.sender, _to, _value);             // Raise Transfer event
237         return true;
238     }
239     
240     /// @notice `msg.sender` approves `_spender` to spend `_value` tokens on
241     ///  its behalf. This is a modified version of the ERC20 approve function
242     ///  to be a little bit safer
243     /// @param _spender The address of the account able to transfer the tokens
244     /// @param _value The amount of tokens to be approved for transfer
245     /// @return True if the approval was successful
246     function approve(address _spender, uint256 _value) public returns (bool success) {
247         allowances[msg.sender][_spender] = _value;          // Set allowance
248         emit Approval(msg.sender, _spender, _value);             // Raise Approval event
249         return true;
250     }
251 
252     /// @notice `msg.sender` approves `_spender` to send `_value` tokens on
253     ///  its behalf, and then a function is triggered in the contract that is
254     ///  being approved, `_spender`. This allows users to use their tokens to
255     ///  interact with contracts in one function call instead of two
256     /// @param _spender The address of the contract able to transfer the tokens
257     /// @param _value The amount of tokens to be approved for transfer
258     /// @return True if the function call was successful
259     function approveAndCall(address _spender, uint256 _value, bytes _extraData) public returns (bool success) {
260         approve(_spender, _value);                          // Set approval to contract for _value
261         //receiveApproval(address _from, uint256 _value, address _tokenContract, bytes _extraData)
262         //it is assumed that when does this that the call *should* succeed, otherwise one would use vanilla approve instead.
263         if(!_spender.call(bytes4(bytes32(keccak256("receiveApproval(address,uint256,address,bytes)"))), msg.sender, _value, this, _extraData)) { 
264             revert(); 
265         }
266         return true;
267     }
268 
269     /// @notice Send `_value` tokens to `_to` from `_from` on the condition it
270     ///  is approved by `_from`
271     /// @param _from The address holding the tokens being transferred
272     /// @param _to The address of the recipient
273     /// @param _value The amount of tokens to be transferred
274     /// @return True if the transfer was successful
275     function transferFrom(address _from, address _to, uint256 _value) public canTransfer releaseTokenValid(msg.sender, now, _value) returns (bool success) {
276         require (balances[_from] >= _value);                // Throw if sender does not have enough balance
277         require (balances[_to] + _value >= balances[_to]);  // Throw if overflow detected
278         require (_value <= allowances[_from][msg.sender]);  // Throw if you do not have allowance
279         balances[_from] -= _value;                          // Deduct senders balance
280         balances[_to] += _value;                            // Add recipient balance
281         allowances[_from][msg.sender] -= _value;            // Deduct allowance for this address
282         emit Transfer(_from, _to, _value);                       // Raise Transfer event
283         return true;
284     }
285 
286     /// @dev This function makes it easy to read the `allowances[]` map
287     /// @param _owner The address of the account that owns the token
288     /// @param _spender The address of the account able to transfer the tokens
289     /// @return Amount of remaining tokens of _owner that _spender is allowed to spend
290     function allowance(address _owner, address _spender) constant public returns (uint256) {
291         return allowances[_owner][_spender];
292     }
293 
294 }
295 
296 contract UST is Owned, standardToken {
297         
298     string constant public name   = "UseChainToken";
299     string constant public symbol = "UST";
300     uint constant public decimals = 18;
301 
302     uint256 public totalSupply = 0;
303     uint256 constant public topTotalSupply = 2 * 10**10 * 10**decimals;
304     uint public forSaleSupply        = percent(topTotalSupply, 45);
305     uint public marketingPartnerSupply = percent(topTotalSupply, 5);
306     uint public coreTeamSupply   = percent(topTotalSupply, 15);
307     uint public technicalCommunitySupply       = percent(topTotalSupply, 15);
308     uint public communitySupply          = percent(topTotalSupply, 20);
309     uint public softCap                = percent(topTotalSupply, 30);
310     
311     function () public {
312         revert();
313     }
314     
315     /// @dev Owner can change the releaseStartTime when needs
316     /// @param _time The releaseStartTime, UTC timezone
317     function setRealseTime(uint256 _time) public onlyOwner {
318         releaseStartTime = _time;
319     }
320     
321     /// @dev This owner allocate token for private sale
322     /// @param _owners The address of the account that owns the token
323     /// @param _values The amount of tokens
324     /// @param _addrLockType The locktype for different investment type
325     function allocateToken(address[] _owners, uint256[] _values, uint256[] _addrLockType) public onlyOwner {
326         require ((_owners.length == _values.length) && ( _values.length == _addrLockType.length));
327         for(uint i = 0; i < _owners.length ; i++){
328             uint256 value = _values[i] * 10 ** decimals;
329             
330             totalSupply = totalSupply.add(value);
331             balances[_owners[i]] = balances[_owners[i]].add(value);             // Set minted coins to target
332             emit Transfer(0x0, _owners[i], value);    
333             
334             userReleaseToken[_owners[i]].UST = userReleaseToken[_owners[i]].UST.add(value);
335             userReleaseToken[_owners[i]].addrLockType = _addrLockType[i];
336         }
337     }
338     
339     /// @dev This owner allocate token for candy airdrop
340     /// @param _owners The address of the account that owns the token
341     /// @param _values The amount of tokens
342 	function allocateCandyToken(address[] _owners, uint256[] _values) public onlyOwner {
343        for(uint i = 0; i < _owners.length ; i++){
344            uint256 value = _values[i] * 10 ** decimals;
345            totalSupply = totalSupply.add(value);
346 		   balances[_owners[i]] = balances[_owners[i]].add(value); 
347 		   emit Transfer(0x0, _owners[i], value);  		  
348         }
349     }
350     
351 }