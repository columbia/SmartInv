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
64 
65     /*
66        * Fix for the ERC20 short address attack  
67       */
68       modifier onlyPayloadSize(uint size) {
69          if(msg.data.length < size + 4) {
70            throw;
71          }
72          _;
73       }
74 
75 
76     function tokenFallback(address _from, uint256 _value, bytes  _data) external {
77         _from;
78         _value;
79         _data;
80         throw;
81     }
82 
83     function transfer(address _to, uint256 _value, bytes _data)  returns (bool success) {
84 
85         //Standard ERC23 transfer function
86 
87         if(isContract(_to)) {
88             transferToContract(_to, _value, _data);
89         }
90         else {
91             transferToAddress(_to, _value, _data);
92         }
93         return true;
94     }
95 
96     function transfer(address _to, uint256 _value) onlyPayloadSize(2 * 32) {
97 
98         //standard function transfer similar to ERC20 transfer with no _data
99         //added due to backwards compatibility reasons
100 
101         bytes memory empty;
102         if(isContract(_to)) {
103             transferToContract(_to, _value, empty);
104         }
105         else {
106             transferToAddress(_to, _value, empty);
107         }
108     }
109 
110     function transferToAddress(address _to, uint256 _value, bytes _data)  internal {
111         _data;
112         balances[msg.sender] = balances[msg.sender].sub(_value);
113         balances[_to] = balances[_to].add(_value);
114         Transfer(msg.sender, _to, _value);
115      }
116 
117     function transferToContract(address _to, uint256 _value, bytes _data)  internal {
118         balances[msg.sender] = balances[msg.sender].sub( _value);
119         balances[_to] = balances[_to].add( _value);
120         ContractReceiver receiver = ContractReceiver(_to);
121         receiver.tokenFallback(msg.sender, _value, _data);
122         Transfer(msg.sender, _to, _value);    }
123 
124     function balanceOf(address _owner) constant returns (uint256 balance) {
125         return balances[_owner];
126     }
127 
128     //assemble the given address bytecode. If bytecode exists then the _addr is a contract.
129     function isContract(address _addr) returns (bool is_contract) {
130             _addr;
131           uint256 length;
132           assembly {
133               //retrieve the size of the code on target address, this needs assembly
134               length := extcodesize(_addr)
135           }
136           if(length>0) {
137               return true;
138           }
139           else {
140               return false;
141           }
142     }
143 }
144 
145 contract ERC23StandardToken is ERC23BasicToken {
146     mapping (address => mapping (address => uint256)) allowed;
147     event Approval (address indexed owner, address indexed spender, uint256 value);
148 
149     function transferFrom(address _from, address _to, uint256 _value) onlyPayloadSize(3 * 32) {
150         var _allowance = allowed[_from][msg.sender];
151 
152         // Check is not needed because sub(_allowance, _value) will already throw if this condition is not met
153         // if (_value > _allowance) throw;
154 
155         balances[_to] = balances[_to].add(_value);
156         balances[_from] = balances[_from].sub(_value);
157         allowed[_from][msg.sender] = _allowance.sub(_value);
158         Transfer(_from, _to, _value);
159     }
160 
161     function approve(address _spender, uint256 _value) onlyPayloadSize(2 * 32) {
162 
163         // To change the approve amount you first have to reduce the addresses`
164         //  allowance to zero by calling `approve(_spender, 0)` if it is not
165         //  already 0 to mitigate the race condition described here:
166         //  https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
167         if ((_value != 0) && (allowed[msg.sender][_spender] != 0)) throw;
168 
169         allowed[msg.sender][_spender] = _value;
170         Approval(msg.sender, _spender, _value);
171     }
172 
173     function allowance(address _owner, address _spender) constant returns (uint256 remaining) {
174         return allowed[_owner][_spender];
175     }
176 
177 }
178 
179 
180 
181 
182 // Based in part on code by Open-Zeppelin: https://github.com/OpenZeppelin/zeppelin-solidity.git
183 // Based in part on code by FirstBlood: https://github.com/Firstbloodio/token/blob/master/smart_contract/FirstBloodToken.sol
184 contract GamePlayerCoin is ERC23StandardToken {
185     string public constant name = "Game Player Coin";
186     string public constant symbol = "GPC";
187     uint256 public constant decimals = 18;
188     address public multisig=address(0x003f69f85bb97E221795f4c2708EA004C73378Fa); //multisig wallet, to which all contributions will be sent
189     address public foundation; //owner address
190     address public candidate; //owner candidate in 2-phase ownership transfer
191     uint256 public hour_blocks = 212; // every hour blocks 
192     uint256 public day_blocks = hour_blocks * 24 ; // every day blocks 
193 
194     mapping (address => uint256) contributions; //keeps track of ether contributions in Wei of each contributor address
195     uint256 public startBlock = 4047500; //pre-crowdsale start block 
196     uint256 public preEndBlock = startBlock + day_blocks * 7; // week 1 pre-crowdsale end block
197     uint256 public phase1StartBlock = preEndBlock; //Crowdsale start block
198     uint256 public phase1EndBlock = phase1StartBlock + day_blocks * 7; //Week 2 end block (estimate)
199     uint256 public phase2EndBlock = phase1EndBlock + day_blocks * 7; //Week 3 end block (estimate)
200     uint256 public phase3EndBlock = phase2EndBlock +  day_blocks * 7 ; //Week 4 end block (estimate)
201     uint256 public endBlock = startBlock + day_blocks * 184; // whole crowdsale end block (184 days , 6 month)
202     uint256 public crowdsaleTokenSupply = 70 * (10**6) * (10**18); //Amount of tokens for sale during crowdsale
203     uint256 public bountyTokenSupply = 10 * (10**6) * (10**18); //Tokens for bounty
204     uint256 public foundationTokenSupply = 20 * (10**6) * (10**18); //Tokens for Gameplayercoin team
205     uint256 public crowdsaleTokenSold = 0; //Keeps track of the amount of tokens sold during the crowdsale
206     uint256 public presaleEtherRaised = 0; //Keeps track of the Ether raised during the crowdsale
207     
208     bool public halted = false; //Halt crowdsale in emergency
209     event Halt(); //Halt event
210     event Unhalt(); //Unhalt event
211 
212     modifier onlyFoundation() {
213         //only do if call is from owner modifier
214         if (msg.sender != foundation) throw;
215         _;
216     }
217 
218 
219     modifier whenNotHalted() {
220         // only do when not halted modifier
221         if (halted) throw;
222         _;
223     }
224 
225     //Constructor: set multisig crowdsale recipient wallet address and fund the foundation
226     //Initialize total supply and allocate ecosystem & foundation tokens
227   	function GamePlayerCoin() {
228         foundation = msg.sender;
229         totalSupply = bountyTokenSupply.add(foundationTokenSupply);
230         balances[foundation] = totalSupply;
231   	}
232 
233     //Fallback function when receiving Ether.
234     function() payable {
235         buy();
236     }
237 
238 
239     //Halt ICO in case of emergency.
240     function halt() onlyFoundation {
241         halted = true;
242         Halt();
243     }
244 
245     function unhalt() onlyFoundation {
246         halted = false;
247         Unhalt();
248     }
249 
250     function buy() payable {
251         buyRecipient(msg.sender);
252     }
253 
254     //Allow addresses to buy token for another account
255     function buyRecipient(address recipient) public payable whenNotHalted {
256         if(msg.value == 0) throw;
257         if(!(preCrowdsaleOn()||crowdsaleOn())) throw;//only allows during presale/crowdsale
258         if(contributions[recipient].add(msg.value)>perAddressCap()) throw;//per address cap
259         uint256 tokens = msg.value.mul(returnRate()); //decimals=18, so no need to adjust for unit
260         if(crowdsaleTokenSold.add(tokens)>crowdsaleTokenSupply) throw;//max supply limit
261 
262         balances[recipient] = balances[recipient].add(tokens);
263         totalSupply = totalSupply.add(tokens);
264         presaleEtherRaised = presaleEtherRaised.add(msg.value);
265         contributions[recipient] = contributions[recipient].add(msg.value);
266         crowdsaleTokenSold = crowdsaleTokenSold.add(tokens);
267         if(crowdsaleTokenSold == crowdsaleTokenSupply ){
268             //If crowdsale token sold out, end crowdsale
269             if(block.number < preEndBlock) {
270                 preEndBlock = block.number;
271             }
272             endBlock = block.number;
273         }
274         if (!multisig.send(msg.value)) throw; //immediately send Ether to multisig address
275         Transfer(this, recipient, tokens);
276     }
277 
278     //Burns the specified amount of tokens from the foundation
279     //Used to burn unspent funds in foundation DAO
280     function burn(uint256 _value) external onlyFoundation returns (bool) {
281         balances[msg.sender] = balances[msg.sender].sub(_value);
282         totalSupply = totalSupply.sub(_value);
283         Transfer(msg.sender, address(0), _value);
284         return true;
285     }
286 
287     //2-phase ownership transfer;
288     //prevent transferring ownership to non-existent addresses by accident.
289     function proposeFoundationTransfer(address newFoundation) external onlyFoundation {
290         //propose new owner
291         candidate = newFoundation;
292     }
293 
294     function cancelFoundationTransfer() external onlyFoundation {
295         candidate = address(0);
296     }
297 
298     function acceptFoundationTransfer() external {
299         //new owner accept transfer to complete transfer
300         if(msg.sender != candidate) throw;
301         foundation = candidate;
302         candidate = address(0);
303     }
304 
305     //Allow to change the recipient multisig address
306     function setMultisig(address addr) external onlyFoundation {
307       	if (addr == address(0)) throw;
308       	multisig = addr;
309     }
310 
311     function transfer(address _to, uint256 _value, bytes _data) public  returns (bool success) {
312         return super.transfer(_to, _value, _data);
313     }
314 
315 	  function transfer(address _to, uint256 _value) public  {
316         super.transfer(_to, _value);
317 	  }
318 
319     function transferFrom(address _from, address _to, uint256 _value) public  {
320         super.transferFrom(_from, _to, _value);
321     }
322 
323     //Return rate of token against ether.
324     function returnRate() public constant returns(uint256) {
325         if (block.number>=startBlock && block.number<=preEndBlock) return 3000; // Week 1 Pre-crowdsale , 50% bounty
326         if (block.number>=phase1StartBlock && block.number<=phase1EndBlock) return 2800; //Week 2 Crowdsale phase1 40% bounty
327         if (block.number>phase1EndBlock && block.number<=phase2EndBlock) return 2600; //Week 3 Phase2 30% bounty
328         if (block.number>phase2EndBlock && block.number<=phase3EndBlock) return 2400; //Week 4 Phase3 20% bounty
329         return 2000;// rest days , normal 
330     }
331 
332     //per address cap in Wei: 1000 ether + 1% of ether received at the given time.
333     function perAddressCap() public constant returns(uint256) {
334         uint256 baseline = 1000 * (10**18);
335         return baseline.add(presaleEtherRaised.div(100));
336     }
337 
338     function preCrowdsaleOn() public constant returns (bool) {
339         //return whether presale is on according to block number
340         return (block.number>=startBlock && block.number<=preEndBlock);
341     }
342 
343     function crowdsaleOn() public constant returns (bool) {
344         //return whether crowdsale is on according to block number
345         return (block.number>=phase1StartBlock && block.number<=endBlock);
346     }
347 
348 
349     function getEtherRaised() external constant returns (uint256) {
350         //getter function for etherRaised
351         return presaleEtherRaised;
352     }
353 
354     function getTokenSold() external constant returns (uint256) {
355         //getter function for crowdsaleTokenSold
356         return crowdsaleTokenSold;
357     }
358 
359 }