1 pragma solidity ^0.4.11;
2 
3 // ==== DISCLAIMER ====
4 //
5 // ETHEREUM IS STILL AN EXPEREMENTAL TECHNOLOGY.
6 // ALTHOUGH THIS SMART CONTRACT WAS CREATED WITH GREAT CARE AND IN THE HOPE OF BEING USEFUL, NO GUARANTEES OF FLAWLESS OPERATION CAN BE GIVEN.
7 // IN PARTICULAR - SUBTILE BUGS, HACKER ATTACKS OR MALFUNCTION OF UNDERLYING TECHNOLOGY CAN CAUSE UNINTENTIONAL BEHAVIOUR.
8 // YOU ARE STRONGLY ENCOURAGED TO STUDY THIS SMART CONTRACT CAREFULLY IN ORDER TO UNDERSTAND POSSIBLE EDGE CASES AND RISKS.
9 // DON'T USE THIS SMART CONTRACT IF YOU HAVE SUBSTANTIAL DOUBTS OR IF YOU DON'T KNOW WHAT YOU ARE DOING.
10 //
11 // THIS SOFTWARE IS PROVIDED "AS IS" AND ANY EXPRESS OR IMPLIED WARRANTIES, INCLUDING, BUT NOT LIMITED TO, THE IMPLIED WARRANTIES OF MERCHANTABILITY
12 // AND FITNESS FOR A PARTICULAR PURPOSE ARE DISCLAIMED. IN NO EVENT SHALL THE COPYRIGHT OWNER OR CONTRIBUTORS BE LIABLE FOR ANY DIRECT, INDIRECT,
13 // INCIDENTAL, SPECIAL, EXEMPLARY, OR CONSEQUENTIAL DAMAGES (INCLUDING, BUT NOT LIMITED TO, PROCUREMENT OF SUBSTITUTE GOODS OR SERVICES; LOSS OF USE, DATA,
14 // OR PROFITS; OR BUSINESS INTERRUPTION) HOWEVER CAUSED AND ON ANY THEORY OF LIABILITY, WHETHER IN CONTRACT, STRICT LIABILITY,
15 // OR TORT (INCLUDING NEGLIGENCE OR OTHERWISE) ARISING IN ANY WAY OUT OF THE USE OF THIS SOFTWARE, EVEN IF ADVISED OF THE POSSIBILITY OF SUCH DAMAGE.
16 // ====
17 //
18 
19 /// @author Santiment LLC
20 /// @title  SAN - santiment token
21 
22 contract Base {
23 
24     function max(uint a, uint b) returns (uint) { return a >= b ? a : b; }
25     function min(uint a, uint b) returns (uint) { return a <= b ? a : b; }
26 
27     modifier only(address allowed) {
28         if (msg.sender != allowed) throw;
29         _;
30     }
31 
32 
33     ///@return True if `_addr` is a contract
34     function isContract(address _addr) constant internal returns (bool) {
35         if (_addr == 0) return false;
36         uint size;
37         assembly {
38             size := extcodesize(_addr)
39         }
40         return (size > 0);
41     }
42 
43     // *************************************************
44     // *          reentrancy handling                  *
45     // *************************************************
46 
47     //@dev predefined locks (up to uint bit length, i.e. 256 possible)
48     uint constant internal L00 = 2 ** 0;
49     uint constant internal L01 = 2 ** 1;
50     uint constant internal L02 = 2 ** 2;
51     uint constant internal L03 = 2 ** 3;
52     uint constant internal L04 = 2 ** 4;
53     uint constant internal L05 = 2 ** 5;
54 
55     //prevents reentrancy attacs: specific locks
56     uint private bitlocks = 0;
57     modifier noReentrancy(uint m) {
58         var _locks = bitlocks;
59         if (_locks & m > 0) throw;
60         bitlocks |= m;
61         _;
62         bitlocks = _locks;
63     }
64 
65     modifier noAnyReentrancy {
66         var _locks = bitlocks;
67         if (_locks > 0) throw;
68         bitlocks = uint(-1);
69         _;
70         bitlocks = _locks;
71     }
72 
73     ///@dev empty marking modifier signaling to user of the marked function , that it can cause an reentrant call.
74     ///     developer should make the caller function reentrant-safe if it use a reentrant function.
75     modifier reentrant { _; }
76 
77 }
78 
79 contract Owned is Base {
80 
81     address public owner;
82     address public newOwner;
83 
84     function Owned() {
85         owner = msg.sender;
86     }
87 
88     function transferOwnership(address _newOwner) only(owner) {
89         newOwner = _newOwner;
90     }
91 
92     function acceptOwnership() only(newOwner) {
93         OwnershipTransferred(owner, newOwner);
94         owner = newOwner;
95     }
96 
97     event OwnershipTransferred(address indexed _from, address indexed _to);
98 
99 }
100 
101 
102 contract ERC20 is Owned {
103 
104     event Transfer(address indexed _from, address indexed _to, uint256 _value);
105     event Approval(address indexed _owner, address indexed _spender, uint256 _value);
106 
107     function transfer(address _to, uint256 _value) isStartedOnly returns (bool success) {
108         if (balances[msg.sender] >= _value && balances[_to] + _value > balances[_to]) {
109             balances[msg.sender] -= _value;
110             balances[_to] += _value;
111             Transfer(msg.sender, _to, _value);
112             return true;
113         } else { return false; }
114     }
115 
116     function transferFrom(address _from, address _to, uint256 _value) isStartedOnly returns (bool success) {
117         if (balances[_from] >= _value && allowed[_from][msg.sender] >= _value && balances[_to] + _value > balances[_to]) {
118             balances[_to] += _value;
119             balances[_from] -= _value;
120             allowed[_from][msg.sender] -= _value;
121             Transfer(_from, _to, _value);
122             return true;
123         } else { return false; }
124     }
125 
126     function balanceOf(address _owner) constant returns (uint256 balance) {
127         return balances[_owner];
128     }
129 
130     function approve(address _spender, uint256 _value) isStartedOnly returns (bool success) {
131         allowed[msg.sender][_spender] = _value;
132         Approval(msg.sender, _spender, _value);
133         return true;
134     }
135 
136     function allowance(address _owner, address _spender) constant returns (uint256 remaining) {
137         return allowed[_owner][_spender];
138     }
139 
140     mapping (address => uint256) balances;
141     mapping (address => mapping (address => uint256)) allowed;
142 
143     uint256 public totalSupply;
144     bool    public isStarted = false;
145 
146     modifier onlyHolder(address holder) {
147         if (balanceOf(holder) == 0) throw;
148         _;
149     }
150 
151     modifier isStartedOnly() {
152         if (!isStarted) throw;
153         _;
154     }
155 
156 }
157 
158 
159 contract SubscriptionModule {
160     function attachToken(address addr) public ;
161 }
162 
163 contract SAN is Owned, ERC20 {
164 
165     string public constant name     = "SANtiment network token";
166     string public constant symbol   = "SAN";
167     uint8  public constant decimals = 15;
168 
169     address CROWDSALE_MINTER = 0xDa2Cf810c5718135247628689D84F94c61B41d6A;
170     address public SUBSCRIPTION_MODULE = 0x00000000;
171     address public beneficiary;
172 
173     uint public PLATFORM_FEE_PER_10000 = 1; //0.01%
174     uint public totalOnDeposit;
175     uint public totalInCirculation;
176 
177     ///@dev constructor
178     function SAN() {
179         beneficiary = owner = msg.sender;
180     }
181 
182     // ------------------------------------------------------------------------
183     // Don't accept ethers
184     // ------------------------------------------------------------------------
185     function () {
186         throw;
187     }
188 
189     //======== SECTION Configuration: Owner only ========
190     //
191     ///@notice set beneficiary - the account receiving platform fees.
192     function setBeneficiary(address newBeneficiary)
193     external
194     only(owner) {
195         beneficiary = newBeneficiary;
196     }
197 
198 
199     ///@notice attach module managing subscriptions. if subModule==0x0, then disables subscription functionality for this token.
200     /// detached module can usually manage subscriptions, but all operations changing token balances are disabled.
201     function attachSubscriptionModule(SubscriptionModule subModule)
202     noAnyReentrancy
203     external
204     only(owner) {
205         SUBSCRIPTION_MODULE = subModule;
206         if (address(subModule) > 0) subModule.attachToken(this);
207     }
208 
209     ///@notice set platform fee denominated in 1/10000 of SAN token. Thus "1" means 0.01% of SAN token.
210     function setPlatformFeePer10000(uint newFee)
211     external
212     only(owner) {
213         require (newFee <= 10000); //formally maximum fee is 100% (completely insane but technically possible)
214         PLATFORM_FEE_PER_10000 = newFee;
215     }
216 
217 
218     //======== Interface XRateProvider: a trivial exchange rate provider. Rate is 1:1 and SAN symbol as the code
219     //
220     ///@dev used as a default XRateProvider (id==0) by subscription module.
221     ///@notice returns always 1 because exchange rate of the token to itself is always 1.
222     function getRate() returns(uint32 ,uint32) { return (1,1);  }
223     function getCode() public returns(string)  { return symbol; }
224 
225 
226     //==== Interface ERC20ModuleSupport: Subscription, Deposit and Payment Support =====
227     ///
228     ///@dev used by subscription module to operate on token balances.
229     ///@param msg_sender should be an original msg.sender provided to subscription module.
230     function _fulfillPreapprovedPayment(address _from, address _to, uint _value, address msg_sender)
231     public
232     onlyTrusted
233     returns(bool success) {
234         success = _from != msg_sender && allowed[_from][msg_sender] >= _value;
235         if (!success) {
236             Payment(_from, _to, _value, _fee(_value), msg_sender, PaymentStatus.APPROVAL_ERROR, 0);
237         } else {
238             success = _fulfillPayment(_from, _to, _value, 0, msg_sender);
239             if (success) {
240                 allowed[_from][msg_sender] -= _value;
241             }
242         }
243         return success;
244     }
245 
246     ///@dev used by subscription module to operate on token balances.
247     ///@param msg_sender should be an original msg.sender provided to subscription module.
248     function _fulfillPayment(address _from, address _to, uint _value, uint subId, address msg_sender)
249     public
250     onlyTrusted
251     returns (bool success) {
252         var fee = _fee(_value);
253         assert (fee <= _value); //internal sanity check
254         if (balances[_from] >= _value && balances[_to] + _value > balances[_to]) {
255             balances[_from] -= _value;
256             balances[_to] += _value - fee;
257             balances[beneficiary] += fee;
258             Payment(_from, _to, _value, fee, msg_sender, PaymentStatus.OK, subId);
259             return true;
260         } else {
261             Payment(_from, _to, _value, fee, msg_sender, PaymentStatus.BALANCE_ERROR, subId);
262             return false;
263         }
264     }
265 
266     function _fee(uint _value) internal constant returns (uint fee) {
267         return _value * PLATFORM_FEE_PER_10000 / 10000;
268     }
269 
270     ///@notice used by subscription module to re-create token from returning deposit.
271     ///@dev a subscription module is responsible to correct deposit management.
272     function _mintFromDeposit(address owner, uint amount)
273     public
274     onlyTrusted {
275         balances[owner] += amount;
276         totalOnDeposit -= amount;
277         totalInCirculation += amount;
278     }
279 
280     ///@notice used by subscription module to burn token while creating a new deposit.
281     ///@dev a subscription module is responsible to create and maintain the deposit record.
282     function _burnForDeposit(address owner, uint amount)
283     public
284     onlyTrusted
285     returns (bool success) {
286         if (balances[owner] >= amount) {
287             balances[owner] -= amount;
288             totalOnDeposit += amount;
289             totalInCirculation -= amount;
290             return true;
291         } else { return false; }
292     }
293 
294     //========= Crowdsale Only ===============
295     ///@notice mint new token for given account in crowdsale stage
296     ///@dev allowed only if token not started yet and only for registered minter.
297     ///@dev tokens are become in circulation after token start.
298     function mint(uint amount, address account)
299     onlyCrowdsaleMinter
300     isNotStartedOnly
301     {
302         totalSupply += amount;
303         balances[account]+=amount;
304     }
305 
306     ///@notice start normal operation of the token. No minting is possible after this point.
307     function start()
308     isNotStartedOnly
309     only(owner) {
310         totalInCirculation = totalSupply;
311         isStarted = true;
312     }
313 
314     //========= SECTION: Modifier ===============
315 
316     modifier onlyCrowdsaleMinter() {
317         if (msg.sender != CROWDSALE_MINTER) throw;
318         _;
319     }
320 
321     modifier onlyTrusted() {
322         if (msg.sender != SUBSCRIPTION_MODULE) throw;
323         _;
324     }
325 
326     ///@dev token not started means minting is possible, but usual token operations are not.
327     modifier isNotStartedOnly() {
328         if (isStarted) throw;
329         _;
330     }
331 
332     enum PaymentStatus {OK, BALANCE_ERROR, APPROVAL_ERROR}
333     ///@notice event issued on any fee based payment (made of failed).
334     ///@param subId - related subscription Id if any, or zero otherwise.
335     event Payment(address _from, address _to, uint _value, uint _fee, address caller, PaymentStatus status, uint subId);
336 
337 }//contract SAN