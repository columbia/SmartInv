1 pragma solidity ^0.4.8;
2 
3 
4 /**
5  * Math operations with safety checks
6  * By OpenZeppelin: https://github.com/OpenZeppelin/zeppelin-solidity/contracts/SafeMath.sol
7  */
8 library SafeMath {
9   function mul(uint256 a, uint256 b) internal returns (uint256) {
10     uint256 c = a * b;
11     if(!(a == 0 || c / a == b)) throw;
12     return c;
13   }
14 
15   function div(uint256 a, uint256 b) internal returns (uint256) {
16     // assert(b > 0); // Solidity automatically throws when dividing by 0
17     uint256 c = a / b;
18     // assert(a == b * c + a % b); // There is no case in which this doesn't hold
19     return c;
20   }
21 
22   function sub(uint256 a, uint256 b) internal returns (uint256) {
23     if(!(b <= a)) throw;
24     return a - b;
25   }
26 
27   function add(uint256 a, uint256 b) internal returns (uint256) {
28     uint256 c = a + b;
29     if(!(c >= a)) throw;
30     return c;
31   }
32 
33   function max64(uint64 a, uint64 b) internal constant returns (uint64) {
34     return a >= b ? a : b;
35   }
36 
37   function min64(uint64 a, uint64 b) internal constant returns (uint64) {
38     return a < b ? a : b;
39   }
40 
41   function max256(uint256 a, uint256 b) internal constant returns (uint256) {
42     return a >= b ? a : b;
43   }
44 
45   function min256(uint256 a, uint256 b) internal constant returns (uint256) {
46     return a < b ? a : b;
47   }
48 
49 }
50 
51 contract ContractReceiver{
52     function tokenFallback(address _from, uint256 _value, bytes  _data) external;
53 }
54 
55 
56 //Basic ERC23 token, backward compatible with ERC20 transfer function.
57 //Based in part on code by open-zeppelin: https://github.com/OpenZeppelin/zeppelin-solidity.git
58 contract ERC23BasicToken {
59     using SafeMath for uint256;
60     uint256 public totalSupply;
61     mapping(address => uint256) balances;
62     event Transfer(address indexed from, address indexed to, uint256 value);
63     
64     function tokenFallback(address _from, uint256 _value, bytes  _data) external {
65         throw;
66     }
67 
68     function transfer(address _to, uint256 _value, bytes _data) returns (bool success) {
69 
70         //Standard ERC23 transfer function
71 
72         if(isContract(_to)) {
73             transferToContract(_to, _value, _data);
74         }
75         else {
76             transferToAddress(_to, _value, _data);
77         }
78         return true;
79     }
80 
81     function transfer(address _to, uint256 _value) {
82 
83         //standard function transfer similar to ERC20 transfer with no _data
84         //added due to backwards compatibility reasons
85 
86         bytes memory empty;
87         if(isContract(_to)) {
88             transferToContract(_to, _value, empty);
89         }
90         else {
91             transferToAddress(_to, _value, empty);
92         }
93     }
94 
95     function transferToAddress(address _to, uint256 _value, bytes _data) internal {
96         balances[msg.sender] = balances[msg.sender].sub(_value);
97         balances[_to] = balances[_to].add(_value);
98         Transfer(msg.sender, _to, _value);
99      }
100 
101     function transferToContract(address _to, uint256 _value, bytes _data) internal {
102         balances[msg.sender] = balances[msg.sender].sub( _value);
103         balances[_to] = balances[_to].add( _value);
104         ContractReceiver receiver = ContractReceiver(_to);
105         receiver.tokenFallback(msg.sender, _value, _data);
106         Transfer(msg.sender, _to, _value);    }
107 
108     function balanceOf(address _owner) constant returns (uint256 balance) {
109         return balances[_owner];
110     }
111 
112     //assemble the given address bytecode. If bytecode exists then the _addr is a contract.
113     function isContract(address _addr) returns (bool is_contract) {
114           uint256 length;
115           assembly {
116               //retrieve the size of the code on target address, this needs assembly
117               length := extcodesize(_addr)
118           }
119           if(length>0) {
120               return true;
121           }
122           else {
123               return false;
124           }
125     }
126 }
127 
128 contract ERC23StandardToken is ERC23BasicToken {
129     mapping (address => mapping (address => uint256)) allowed;
130     event Approval (address indexed owner, address indexed spender, uint256 value);
131 
132     function transferFrom(address _from, address _to, uint256 _value) {
133         var _allowance = allowed[_from][msg.sender];
134 
135         // Check is not needed because sub(_allowance, _value) will already throw if this condition is not met
136         // if (_value > _allowance) throw;
137 
138         balances[_to] = balances[_to].add(_value);
139         balances[_from] = balances[_from].sub(_value);
140         allowed[_from][msg.sender] = _allowance.sub(_value);
141         Transfer(_from, _to, _value);
142     }
143 
144     function approve(address _spender, uint256 _value) {
145 
146         // To change the approve amount you first have to reduce the addresses`
147         //  allowance to zero by calling `approve(_spender, 0)` if it is not
148         //  already 0 to mitigate the race condition described here:
149         //  https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
150         if ((_value != 0) && (allowed[msg.sender][_spender] != 0)) throw;
151 
152         allowed[msg.sender][_spender] = _value;
153         Approval(msg.sender, _spender, _value);
154     }
155 
156     function allowance(address _owner, address _spender) constant returns (uint256 remaining) {
157         return allowed[_owner][_spender];
158     }
159 
160 }
161 
162 
163 
164 
165 // Based in part on code by Open-Zeppelin: https://github.com/OpenZeppelin/zeppelin-solidity.git
166 // Based in part on code by FirstBlood: https://github.com/Firstbloodio/token/blob/master/smart_contract/FirstBloodToken.sol
167 contract OpusToken is ERC23StandardToken {
168     string public constant name = "Opus Token";
169     string public constant symbol = "OPT";
170     uint256 public constant decimals = 18;
171     address public multisig=address(0x1426c1f91b923043F7C5FbabC6e369e7cBaef3f0); //multisig wallet, to which all contributions will be sent
172     address public foundation; //owner address
173     address public candidate; //owner candidate in 2-phase ownership transfer
174 
175     mapping (address => uint256) contributions; //keeps track of ether contributions in Wei of each contributor address
176     uint256 public startBlock = 4023333; //pre-crowdsale start block (30min ealier than estimate) 
177     uint256 public preEndBlock = 4057233; //pre-crowdsale end block(1h after estimated time)
178     uint256 public phase1StartBlock = 4066633; //Crowdsale start block (1h earlier)
179     uint256 public phase1EndBlock = 4100233; //Week 1 end block (estimate)
180     uint256 public phase2EndBlock = 4133833; //Week 2 end block (estimate)
181     uint256 public phase3EndBlock = 4201433; //Week 4 end block (2h later)
182     uint256 public endBlock = 4201433; //whole crowdsale end block
183     uint256 public crowdsaleTokenSupply = 900000000 * (10**18); //Amount of tokens for sale during crowdsale
184     uint256 public ecosystemTokenSupply = 100000000 * (10**18); //Tokens for supporting the Opus eco-system, e.g. purchasing music licenses, artist bounties, etc.
185     uint256 public foundationTokenSupply = 600000000 * (10**18); //Tokens distributed to the Opus foundation, developers and angel investors
186     uint256 public crowdsaleTokenSold = 0; //Keeps track of the amount of tokens sold during the crowdsale
187     uint256 public presaleEtherRaised = 0; //Keeps track of the Ether raised during the crowdsale
188     uint256 public transferLockup = 9600;
189     bool public halted = false; //Halt crowdsale in emergency
190     event Halt(); //Halt event
191     event Unhalt(); //Unhalt event
192 
193     modifier onlyFoundation() {
194         //only do if call is from owner modifier
195         if (msg.sender != foundation) throw;
196         _;
197     }
198 
199     modifier crowdsaleTransferLock() {
200         // lockup during and after 48h of end of crowdsale
201         if (block.number <= endBlock.add(transferLockup)) throw;
202         _;
203     }
204 
205     modifier whenNotHalted() {
206         // only do when not halted modifier
207         if (halted) throw;
208         _;
209     }
210 
211     //Constructor: set multisig crowdsale recipient wallet address and fund the foundation
212     //Initialize total supply and allocate ecosystem & foundation tokens
213   	function OpusToken() {
214         foundation = msg.sender;
215         totalSupply = ecosystemTokenSupply.add(foundationTokenSupply);
216         balances[foundation] = totalSupply;
217   	}
218 
219     //Fallback function when receiving Ether.
220     function() payable {
221         buy();
222     }
223 
224 
225     //Halt ICO in case of emergency.
226     function halt() onlyFoundation {
227         halted = true;
228         Halt();
229     }
230 
231     function unhalt() onlyFoundation {
232         halted = false;
233         Unhalt();
234     }
235 
236     function buy() payable {
237         buyRecipient(msg.sender);
238     }
239 
240     //Allow addresses to buy token for another account
241     function buyRecipient(address recipient) public payable whenNotHalted {
242         if(msg.value == 0) throw;
243         if(!(preCrowdsaleOn()||crowdsaleOn())) throw;//only allows during presale/crowdsale
244         if(contributions[recipient].add(msg.value)>perAddressCap()) throw;//per address cap
245         uint256 tokens = msg.value.mul(returnRate()); //decimals=18, so no need to adjust for unit
246         if(crowdsaleTokenSold.add(tokens)>crowdsaleTokenSupply) throw;//max supply limit
247 
248         balances[recipient] = balances[recipient].add(tokens);
249         totalSupply = totalSupply.add(tokens);
250         presaleEtherRaised = presaleEtherRaised.add(msg.value);
251         contributions[recipient] = contributions[recipient].add(msg.value);
252         crowdsaleTokenSold = crowdsaleTokenSold.add(tokens);
253         if(crowdsaleTokenSold == crowdsaleTokenSupply){
254         //If crowdsale token sold out, end crowdsale
255             if(block.number < preEndBlock) {
256                 preEndBlock = block.number;
257             }
258             endBlock = block.number;
259         }
260         if (!multisig.send(msg.value)) throw; //immediately send Ether to multisig address
261         Transfer(this, recipient, tokens);
262     }
263 
264     //Burns the specified amount of tokens from the foundation
265     //Used to burn unspent funds in foundation DAO
266     function burn(uint256 _value) external onlyFoundation returns (bool) {
267         balances[msg.sender] = balances[msg.sender].sub(_value);
268         totalSupply = totalSupply.sub(_value);
269         Transfer(msg.sender, address(0), _value);
270         return true;
271     }
272 
273     //2-phase ownership transfer;
274     //prevent transferring ownership to non-existent addresses by accident.
275     function proposeFoundationTransfer(address newFoundation) external onlyFoundation {
276         //propose new owner
277         candidate = newFoundation;
278     }
279 
280     function cancelFoundationTransfer() external onlyFoundation {
281         candidate = address(0);
282     }
283 
284     function acceptFoundationTransfer() external {
285         //new owner accept transfer to complete transfer
286         if(msg.sender != candidate) throw;
287         foundation = candidate;
288         candidate = address(0);
289     }
290 
291     //Allow to change the recipient multisig address
292     function setMultisig(address addr) external onlyFoundation {
293       	if (addr == address(0)) throw;
294       	multisig = addr;
295     }
296 
297     function transfer(address _to, uint256 _value, bytes _data) public crowdsaleTransferLock returns (bool success) {
298         return super.transfer(_to, _value, _data);
299     }
300 
301 	  function transfer(address _to, uint256 _value) public crowdsaleTransferLock {
302         super.transfer(_to, _value);
303 	  }
304 
305     function transferFrom(address _from, address _to, uint256 _value) public crowdsaleTransferLock {
306         super.transferFrom(_from, _to, _value);
307     }
308 
309     //Return rate of token against ether.
310     function returnRate() public constant returns(uint256) {
311         if (block.number>=startBlock && block.number<=preEndBlock) return 8888; //Pre-crowdsale
312         if (block.number>=phase1StartBlock && block.number<=phase1EndBlock) return 8000; //Crowdsale phase1
313         if (block.number>phase1EndBlock && block.number<=phase2EndBlock) return 7500; //Phase2
314         if (block.number>phase2EndBlock && block.number<=phase3EndBlock) return 7000; //Phase3
315     }
316 
317     //per address cap in Wei: 1000 ether + 1% of ether received at the given time.
318     function perAddressCap() public constant returns(uint256) {
319         uint256 baseline = 1000 * (10**18);
320         return baseline.add(presaleEtherRaised.div(100));
321     }
322 
323     function preCrowdsaleOn() public constant returns (bool) {
324         //return whether presale is on according to block number
325         return (block.number>=startBlock && block.number<=preEndBlock);
326     }
327 
328     function crowdsaleOn() public constant returns (bool) {
329         //return whether crowdsale is on according to block number
330         return (block.number>=phase1StartBlock && block.number<=endBlock);
331     }
332 
333 
334     function getEtherRaised() external constant returns (uint256) {
335         //getter function for etherRaised
336         return presaleEtherRaised;
337     }
338 
339     function getTokenSold() external constant returns (uint256) {
340         //getter function for crowdsaleTokenSold
341         return crowdsaleTokenSold;
342     }
343 
344 }