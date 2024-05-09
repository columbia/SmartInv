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
184 contract Profit1000 is ERC23StandardToken {
185     string public constant name = "Profit 1000 Token";
186     string public constant symbol = "1000";
187     uint256 public constant decimals = 18;
188     address public multisig=address(0x871D9225C237049c2FB82A32647511128741A616); //multisig wallet, to which all contributions will be sent
189     address public foundation; //owner address
190     address public candidate; //owner candidate in 2-phase ownership transfer
191     uint256 public hour_blocks = 212; // every hour blocks 
192     uint256 public day_blocks = hour_blocks * 24 ; // every day blocks 
193 
194     mapping (address => uint256) contributions; //keeps track of ether contributions in Wei of each contributor address
195     uint256 public startBlock = 4070472; //crowdsale start block 
196     uint256 public endBlock = startBlock + day_blocks * 30; // whole crowdsale end block (30 days , 1 month)
197     uint256 public crowdsaleTokenSupply = 800 * (10**18); //Amount of tokens for sale during crowdsale
198     uint256 public foundationTokenSupply = 200 * (10**18); //Tokens for  team
199     uint256 public crowdsaleTokenSold = 0; //Keeps track of the amount of tokens sold during the crowdsale
200     uint256 public presaleEtherRaised = 0; //Keeps track of the Ether raised during the crowdsale
201     
202     bool public halted = false; //Halt crowdsale in emergency
203     event Halt(); //Halt event
204     event Unhalt(); //Unhalt event
205 
206     modifier onlyFoundation() {
207         //only do if call is from owner modifier
208         if (msg.sender != foundation) throw;
209         _;
210     }
211 
212 
213     modifier whenNotHalted() {
214         // only do when not halted modifier
215         if (halted) throw;
216         _;
217     }
218 
219     //Constructor: set multisig crowdsale recipient wallet address and fund the foundation
220     //Initialize total supply and allocate ecosystem & foundation tokens
221   	function Profit1000() {
222         foundation = msg.sender;
223         totalSupply = foundationTokenSupply;
224         balances[foundation] = totalSupply;
225   	}
226 
227     //Fallback function when receiving Ether.
228     function() payable {
229         buy();
230     }
231 
232 
233     //Halt ICO in case of emergency.
234     function halt() onlyFoundation {
235         halted = true;
236         Halt();
237     }
238 
239     function unhalt() onlyFoundation {
240         halted = false;
241         Unhalt();
242     }
243 
244     function buy() payable {
245         buyRecipient(msg.sender);
246     }
247 
248     //Allow addresses to buy token for another account
249     function buyRecipient(address recipient) public payable whenNotHalted {
250         if(msg.value == 0) throw;
251         if(!crowdsaleOn()) throw;//only allows during presale/crowdsale
252         if(contributions[recipient].add(msg.value)>perAddressCap()) throw;//per address cap
253         uint256 tokens = msg.value.mul(returnRate()); //decimals=18, so no need to adjust for unit
254         if(crowdsaleTokenSold.add(tokens)>crowdsaleTokenSupply) throw;//max supply limit
255 
256         balances[recipient] = balances[recipient].add(tokens);
257         totalSupply = totalSupply.add(tokens);
258         presaleEtherRaised = presaleEtherRaised.add(msg.value);
259         contributions[recipient] = contributions[recipient].add(msg.value);
260         crowdsaleTokenSold = crowdsaleTokenSold.add(tokens);
261         if(crowdsaleTokenSold == crowdsaleTokenSupply ){
262             //If crowdsale token sold out, end crowdsale
263             endBlock = block.number;
264         }
265         if (!multisig.send(msg.value)) throw; //immediately send Ether to multisig address
266         Transfer(this, recipient, tokens);
267     }
268 
269     //Burns the specified amount of tokens from the foundation
270     //Used to burn unspent funds in foundation DAO
271     function burn(uint256 _value) external onlyFoundation returns (bool) {
272         balances[msg.sender] = balances[msg.sender].sub(_value);
273         totalSupply = totalSupply.sub(_value);
274         Transfer(msg.sender, address(0), _value);
275         return true;
276     }
277 
278     //2-phase ownership transfer;
279     //prevent transferring ownership to non-existent addresses by accident.
280     function proposeFoundationTransfer(address newFoundation) external onlyFoundation {
281         //propose new owner
282         candidate = newFoundation;
283     }
284 
285     function cancelFoundationTransfer() external onlyFoundation {
286         candidate = address(0);
287     }
288 
289     function acceptFoundationTransfer() external {
290         //new owner accept transfer to complete transfer
291         if(msg.sender != candidate) throw;
292         foundation = candidate;
293         candidate = address(0);
294     }
295 
296     //Allow to change the recipient multisig address
297     function setMultisig(address addr) external onlyFoundation {
298       	if (addr == address(0)) throw;
299       	multisig = addr;
300     }
301 
302     function transfer(address _to, uint256 _value, bytes _data) public  returns (bool success) {
303         return super.transfer(_to, _value, _data);
304     }
305 
306 	  function transfer(address _to, uint256 _value) public  {
307         super.transfer(_to, _value);
308 	  }
309 
310     function transferFrom(address _from, address _to, uint256 _value) public  {
311         super.transferFrom(_from, _to, _value);
312     }
313 
314     //Return rate of token against ether.
315     function returnRate() public constant returns(uint256) {
316         if (block.number>=startBlock && block.number<=endBlock) return 4; // ICO
317         return 0;// out of ICO 
318     }
319 
320     //per address cap in Wei: 1000 ether + 1% of ether received at the given time.
321     function perAddressCap() public constant returns(uint256) {
322         uint256 baseline = 1000 * (10**18);
323         return baseline.add(presaleEtherRaised.div(100));
324     }
325 
326     function crowdsaleOn() public constant returns (bool) {
327         //return whether crowdsale is on according to block number
328         return (block.number>=startBlock && block.number<=endBlock);
329     }
330 
331 
332     function getEtherRaised() external constant returns (uint256) {
333         //getter function for etherRaised
334         return presaleEtherRaised;
335     }
336 
337     function getTokenSold() external constant returns (uint256) {
338         //getter function for crowdsaleTokenSold
339         return crowdsaleTokenSold;
340     }
341 
342 }