1 pragma solidity ^0.4.11;
2 
3 /**
4  * @title SafeMath
5  * @dev Math operations with safety checks that revert on error
6  */
7 library SafeMath {
8 
9   /**
10   * @dev Multiplies two numbers, reverts on overflow.
11   */
12   function mul(uint256 a, uint256 b) internal pure returns (uint256) {
13     // Gas optimization: this is cheaper than requiring 'a' not being zero, but the
14     // benefit is lost if 'b' is also tested.
15     // See: https://github.com/OpenZeppelin/openzeppelin-solidity/pull/522
16     if (a == 0) {
17       return 0;
18     }
19 
20     uint256 c = a * b;
21     require(c / a == b);
22 
23     return c;
24   }
25 
26   /**
27   * @dev Integer division of two numbers truncating the quotient, reverts on division by zero.
28   */
29   function div(uint256 a, uint256 b) internal pure returns (uint256) {
30     require(b > 0); // Solidity only automatically asserts when dividing by 0
31     uint256 c = a / b;
32     // assert(a == b * c + a % b); // There is no case in which this doesn't hold
33 
34     return c;
35   }
36 
37   /**
38   * @dev Subtracts two numbers, reverts on overflow (i.e. if subtrahend is greater than minuend).
39   */
40   function sub(uint256 a, uint256 b) internal pure returns (uint256) {
41     require(b <= a);
42     uint256 c = a - b;
43 
44     return c;
45   }
46 
47   /**
48   * @dev Adds two numbers, reverts on overflow.
49   */
50   function add(uint256 a, uint256 b) internal pure returns (uint256) {
51     uint256 c = a + b;
52     require(c >= a);
53 
54     return c;
55   }
56 
57   /**
58   * @dev Divides two numbers and returns the remainder (unsigned integer modulo),
59   * reverts when dividing by zero.
60   */
61   function mod(uint256 a, uint256 b) internal pure returns (uint256) {
62     require(b != 0);
63     return a % b;
64   }
65 }
66 
67 contract Owned {
68 
69     /// `owner` is the only address that can call a function with this
70     /// modifier
71     modifier onlyOwner() {
72         require(msg.sender == owner);
73         _;
74     }
75 
76     address public owner;
77 
78     /// @notice The Constructor assigns the message sender to be `owner`
79     function Owned() {
80         owner = msg.sender;
81     }
82 
83     address newOwner=0x0;
84 
85     event OwnerUpdate(address _prevOwner, address _newOwner);
86 
87     ///change the owner
88     function changeOwner(address _newOwner) public onlyOwner {
89         require(_newOwner != owner);
90         newOwner = _newOwner;
91     }
92 
93     /// accept the ownership
94     function acceptOwnership() public{
95         require(msg.sender == newOwner);
96         OwnerUpdate(owner, newOwner);
97         owner = newOwner;
98         newOwner = 0x0;
99     }
100 }
101 
102 contract Token {
103     /* This is a slight change to the ERC20 base standard.
104     function totalSupply() constant returns (uint256 supply);
105     is replaced with:
106     uint256 public totalSupply;
107     This automatically creates a getter function for the totalSupply.
108     This is moved to the base contract since public getter functions are not
109     currently recognised as an implementation of the matching abstract
110     function by the compiler.
111     */
112     /// total amount of tokens
113     uint256 public totalSupply;
114 
115     /// @param _owner The address from which the balance will be retrieved
116     /// @return The balance
117     function balanceOf(address _owner) constant returns (uint256 balance);
118 
119     /// @notice send `_value` token to `_to` from `msg.sender`
120     /// @param _to The address of the recipient
121     /// @param _value The amount of token to be transferred
122     /// @return Whether the transfer was successful or not
123     function transfer(address _to, uint256 _value) returns (bool success);
124 
125     /// @notice send `_value` token to `_to` from `_from` on the condition it is approved by `_from`
126     /// @param _from The address of the sender
127     /// @param _to The address of the recipient
128     /// @param _value The amount of token to be transferred
129     /// @return Whether the transfer was successful or not
130     function transferFrom(address _from, address _to, uint256 _value) returns (bool success);
131 
132     /// @notice `msg.sender` approves `_spender` to spend `_value` tokens
133     /// @param _spender The address of the account able to transfer the tokens
134     /// @param _value The amount of tokens to be approved for transfer
135     /// @return Whether the approval was successful or not
136     function approve(address _spender, uint256 _value) returns (bool success);
137 
138     /// @param _owner The address of the account owning tokens
139     /// @param _spender The address of the account able to transfer the tokens
140     /// @return Amount of remaining tokens allowed to spent
141     function allowance(address _owner, address _spender) constant returns (uint256 remaining);
142 
143     event Transfer(address indexed _from, address indexed _to, uint256 _value);
144     event Approval(address indexed _owner, address indexed _spender, uint256 _value);
145     event Frozen(address indexed _spender, uint256 _value);
146 }
147 
148 contract Controlled is Owned{
149 
150     function Controlled() {
151        setExclude(msg.sender);
152     }
153 
154     // Flag that determines if the token is transferable or not.
155     bool public transferEnabled = false;
156 
157     // flag that makes locked address effect
158     bool lockFlag=true;
159     mapping(address => bool) locked;
160     mapping(address => bool) exclude;
161 
162     function enableTransfer(bool _enable) 
163     public onlyOwner{
164         transferEnabled=_enable;
165     }
166     function disableLock(bool _enable)
167     onlyOwner
168     returns (bool success){
169         lockFlag=_enable;
170         return true;
171     }
172     function addLock(address _addr) 
173     onlyOwner 
174     returns (bool success){
175         require(_addr!=msg.sender);
176         locked[_addr]=true;
177         return true;
178     }
179 
180     function setExclude(address _addr) 
181     onlyOwner 
182     returns (bool success){
183         exclude[_addr]=true;
184         return true;
185     }
186     function removeLock(address _addr)
187     onlyOwner
188     returns (bool success){
189         locked[_addr]=false;
190         return true;
191     }
192 
193     modifier transferAllowed {
194         if (!exclude[msg.sender]) {
195             assert(transferEnabled);
196             if(lockFlag){
197                 assert(!locked[msg.sender]);
198             }
199         }
200         
201         _;
202     }
203   
204 }
205 
206 /*
207 You should inherit from StandardToken or, for a token like you would want to
208 deploy in something like Mist, see HumanStandardToken.sol.
209 (This implements ONLY the standard functions and NOTHING else.
210 If you deploy this, you won't have anything useful.)
211 
212 Implements ERC 20 Token standard: https://github.com/ethereum/EIPs/issues/20
213 .*/
214 
215 contract StandardToken is Token,Controlled {
216     using SafeMath for uint;
217 
218     function transfer(address _to, uint256 _value) transferAllowed returns (bool success) {
219         //Default assumes totalSupply can't be over max (2^256 - 1).
220         //If your token leaves out totalSupply and can issue more tokens as time goes on, you need to check if it doesn't wrap.
221         //Replace the if with this one instead.
222         if (balances[msg.sender] >= _value.add(frozenBalance[msg.sender]) && _value > 0) {
223             balances[msg.sender] = balances[msg.sender].sub(_value);
224             balances[_to] = balances[_to].add(_value);
225             Transfer(msg.sender, _to, _value);
226             return true;
227         } else { throw; }
228     }
229 
230     function transferFrom(address _from, address _to, uint256 _value) transferAllowed returns (bool success) {
231         //same as above. Replace this line with the following if you want to protect against wrapping uints.
232         if (balances[_from] >= _value.add(frozenBalance[_from]) && _value > 0) {
233             balances[_to] = balances[_to].add(_value);
234             balances[_from] = balances[_from].sub(_value);
235             allowed[_from][msg.sender] = allowed[_from][msg.sender].sub(_value);
236             Transfer(_from, _to, _value);
237             return true;
238         } else { throw; }
239     }
240 
241     function balanceOf(address _owner) constant returns (uint256 balance) {
242         return balances[_owner];
243     }
244 
245     function approve(address _spender, uint256 _value) returns (bool success) {
246         allowed[msg.sender][_spender] = _value;
247         Approval(msg.sender, _spender, _value);
248         return true;
249     }
250 
251     function allowance(address _owner, address _spender) constant returns (uint256 remaining) {
252       return allowed[_owner][_spender];
253     }
254 
255     function setFrozen(address _spender, uint256 _value) onlyOwner returns (bool success) {
256         if (_value < 0) {
257             throw;
258         }
259         frozenBalance[_spender] = _value;
260         Frozen(_spender, _value);
261         return true;
262     }
263 
264     function getFrozen(address _owner) constant returns (uint256 balance) {
265         return frozenBalance[_owner];
266     }
267 
268     mapping (address => uint256) balances;
269     mapping (address => mapping (address => uint256)) allowed;
270     mapping (address => uint256) frozenBalance; // user cannot use balance in frozenBalance
271 }
272 
273 contract BitDATAToken is StandardToken {
274 
275     function () {
276         //if ether is sent to this address, send it back.
277         throw;
278     }
279 
280     /* Public variables of the token */
281 
282     /*
283     NOTE:
284     The following variables are OPTIONAL vanities. One does not have to include them.
285     They allow one to customise the token contract & in no way influences the core functionality.
286     Some wallets/interfaces might not even bother to look at this information.
287     */
288     string public name;                   //fancy name: eg Simon Bucks
289     uint8 public decimals;                //How many decimals to show. ie. There could 1000 base units with 3 decimals. Meaning 0.980 SBX = 980 base units. It's like comparing 1 wei to 1 ether.
290     string public symbol;                 //An identifier: eg SBX
291 
292     function BitDATAToken() {
293         totalSupply = 3000000000 * (10 ** 18); 
294         balances[msg.sender] = totalSupply;               // Give the creator all initial tokens
295         name = "BitDATA Token";                                   // Set the name for display purposes
296         decimals = 18;                            // Amount of decimals for display purposes
297         symbol = "BDT";                       // Set the symbol for display purposes
298     }
299 
300     /* Approves and then calls the receiving contract */
301     function approveAndCall(address _spender, uint256 _value, bytes _extraData) returns (bool success) {
302         allowed[msg.sender][_spender] = _value;
303         Approval(msg.sender, _spender, _value);
304 
305         //call the receiveApproval function on the contract you want to be notified. This crafts the function signature manually so one doesn't have to include a contract in here just for this.
306         //receiveApproval(address _from, uint256 _value, address _tokenContract, bytes _extraData)
307         //it is assumed that when does this that the call *should* succeed, otherwise one would use vanilla approve instead.
308         if(!_spender.call(bytes4(bytes32(sha3("receiveApproval(address,uint256,address,bytes)"))), msg.sender, _value, this, _extraData)) { throw; }
309         return true;
310     }
311 
312 }