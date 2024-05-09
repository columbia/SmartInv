1 pragma solidity ^0.4.23;



2 contract ERC20Basic {
3   function totalSupply() public view returns (uint256);
4   function balanceOf(address who) public view returns (uint256);
5   function transfer(address to, uint256 value) public returns (bool);
6   event Transfer(address indexed from, address indexed to, uint256 value);
7 }


8 library SafeMath {


9   function mul(uint256 a, uint256 b) internal pure returns (uint256 c) {
10     // Gas optimization: this is cheaper than asserting 'a' not being zero, but the
11     // benefit is lost if 'b' is also tested.
12     // See: https://github.com/OpenZeppelin/openzeppelin-solidity/pull/522
13     if (a == 0) {
14       return 0;
15     }

16     c = a * b;
17     assert(c / a == b);
18     return c;
19   }

 
20   function div(uint256 a, uint256 b) internal pure returns (uint256) {
21     // assert(b > 0); // Solidity automatically throws when dividing by 0
22     // uint256 c = a / b;
23     // assert(a == b * c + a % b); // There is no case in which this doesn't hold
24     return a / b;
25   }

 
26   function sub(uint256 a, uint256 b) internal pure returns (uint256) {
27     assert(b <= a);
28     return a - b;
29   }


30   function add(uint256 a, uint256 b) internal pure returns (uint256 c) {
31     c = a + b;
32     assert(c >= a);
33     return c;
34   }
35 }


36 contract BasicToken is ERC20Basic {
37   using SafeMath for uint256;

38   mapping(address => uint256) balances;

39   uint256 totalSupply_;

40   function totalSupply() public view returns (uint256) {
41     return totalSupply_;
42   }


43   function transfer(address _to, uint256 _value) public returns (bool) {
44     require(_to != address(0));
45     require(_value <= balances[msg.sender]);

46     balances[msg.sender] = balances[msg.sender].sub(_value);
47     balances[_to] = balances[_to].add(_value);
48     emit Transfer(msg.sender, _to, _value);
49     return true;
50   }

 
51   function balanceOf(address _owner) public view returns (uint256) {
52     return balances[_owner];
53   }

54 }



55 contract ERC20 is ERC20Basic {
56   function allowance(address owner, address spender)
57     public view returns (uint256);

58   function transferFrom(address from, address to, uint256 value)
59     public returns (bool);

60   function approve(address spender, uint256 value) public returns (bool);
61   event Approval(
62     address indexed owner,
63     address indexed spender,
64     uint256 value
65   );
66 }


67 contract StandardToken is ERC20, BasicToken {

68   mapping (address => mapping (address => uint256)) internal allowed;



69   function transferFrom(
70     address _from,
71     address _to,
72     uint256 _value
73   )
74     public
75     returns (bool)
76   {
77     require(_to != address(0));
78     require(_value <= balances[_from]);
79     require(_value <= allowed[_from][msg.sender]);

80     balances[_from] = balances[_from].sub(_value);
81     balances[_to] = balances[_to].add(_value);
82     allowed[_from][msg.sender] = allowed[_from][msg.sender].sub(_value);
83     emit Transfer(_from, _to, _value);
84     return true;
85   }

86   function approve(address _spender, uint256 _value) public returns (bool) {
87     allowed[msg.sender][_spender] = _value;
88     emit Approval(msg.sender, _spender, _value);
89     return true;
90   }


91   function allowance(
92     address _owner,
93     address _spender
94    )
95     public
96     view
97     returns (uint256)
98   {
99     return allowed[_owner][_spender];
100   }

101   function increaseApproval(
102     address _spender,
103     uint _addedValue
104   )
105     public
106     returns (bool)
107   {
108     allowed[msg.sender][_spender] = (
109       allowed[msg.sender][_spender].add(_addedValue));
110     emit Approval(msg.sender, _spender, allowed[msg.sender][_spender]);
111     return true;
112   }

113   function decreaseApproval(
114     address _spender,
115     uint _subtractedValue
116   )
117     public
118     returns (bool)
119   {
120     uint oldValue = allowed[msg.sender][_spender];
121     if (_subtractedValue > oldValue) {
122       allowed[msg.sender][_spender] = 0;
123     } else {
124       allowed[msg.sender][_spender] = oldValue.sub(_subtractedValue);
125     }
126     emit Approval(msg.sender, _spender, allowed[msg.sender][_spender]);
127     return true;
128   }

129 }



130 contract Ownable {
131   address public owner;


132   event OwnershipRenounced(address indexed previousOwner);
133   event OwnershipTransferred(
134     address indexed previousOwner,
135     address indexed newOwner
136   );


137   constructor() public {
138     owner = msg.sender;
139   }

 
140   modifier onlyOwner() {
141     require(msg.sender == owner);
142     _;
143   }

 
144   function renounceOwnership() public onlyOwner {
145     emit OwnershipRenounced(owner);
146     owner = address(0);
147   }


148   function transferOwnership(address _newOwner) public onlyOwner {
149     _transferOwnership(_newOwner);
150   }

151   function _transferOwnership(address _newOwner) internal {
152     require(_newOwner != address(0));
153     emit OwnershipTransferred(owner, _newOwner);
154     owner = _newOwner;
155   }
156 }



157 contract MintableToken is StandardToken, Ownable {
158   event Mint(address indexed to, uint256 amount);
159   event MintFinished();

160   bool public mintingFinished = false;


161   modifier canMint() {
162     require(!mintingFinished);
163     _;
164   }

165   modifier hasMintPermission() {
166     require(msg.sender == owner);
167     _;
168   }


169   function mint(
170     address _to,
171     uint256 _amount
172   )
173     hasMintPermission
174     canMint
175     public
176     returns (bool)
177   {
178     totalSupply_ = totalSupply_.add(_amount);
179     balances[_to] = balances[_to].add(_amount);
180     emit Mint(_to, _amount);
181     emit Transfer(address(0), _to, _amount);
182     return true;
183   }


184   function finishMinting() onlyOwner canMint public returns (bool) {
185     mintingFinished = true;
186     emit MintFinished();
187     return true;
188   }
189 }


190 contract FreezableToken is StandardToken {
191     // freezing chains
192     mapping (bytes32 => uint64) internal chains;
193     // freezing amounts for each chain
194     mapping (bytes32 => uint) internal freezings;
195     // total freezing balance per address
196     mapping (address => uint) internal freezingBalance;

197     event Freezed(address indexed to, uint64 release, uint amount);
198     event Released(address indexed owner, uint amount);


199     function balanceOf(address _owner) public view returns (uint256 balance) {
200         return super.balanceOf(_owner) + freezingBalance[_owner];
201     }

 
202     function actualBalanceOf(address _owner) public view returns (uint256 balance) {
203         return super.balanceOf(_owner);
204     }

205     function freezingBalanceOf(address _owner) public view returns (uint256 balance) {
206         return freezingBalance[_owner];
207     }


208     function freezingCount(address _addr) public view returns (uint count) {
209         uint64 release = chains[toKey(_addr, 0)];
210         while (release != 0) {
211             count++;
212             release = chains[toKey(_addr, release)];
213         }
214     }


215     function getFreezing(address _addr, uint _index) public view returns (uint64 _release, uint _balance) {
216         for (uint i = 0; i < _index + 1; i++) {
217             _release = chains[toKey(_addr, _release)];
218             if (_release == 0) {
219                 return;
220             }
221         }
222         _balance = freezings[toKey(_addr, _release)];
223     }


224     function freezeTo(address _to, uint _amount, uint64 _until) public {
225         require(_to != address(0));
226         require(_amount <= balances[msg.sender]);

227         balances[msg.sender] = balances[msg.sender].sub(_amount);

228         bytes32 currentKey = toKey(_to, _until);
229         freezings[currentKey] = freezings[currentKey].add(_amount);
230         freezingBalance[_to] = freezingBalance[_to].add(_amount);

231         freeze(_to, _until);
232         emit Transfer(msg.sender, _to, _amount);
233         emit Freezed(_to, _until, _amount);
234     }

235     function releaseOnce() public {
236         bytes32 headKey = toKey(msg.sender, 0);
237         uint64 head = chains[headKey];
238         require(head != 0);
239         require(uint64(block.timestamp) > head);
240         bytes32 currentKey = toKey(msg.sender, head);

241         uint64 next = chains[currentKey];

242         uint amount = freezings[currentKey];
243         delete freezings[currentKey];

244         balances[msg.sender] = balances[msg.sender].add(amount);
245         freezingBalance[msg.sender] = freezingBalance[msg.sender].sub(amount);

246         if (next == 0) {
247             delete chains[headKey];
248         } else {
249             chains[headKey] = next;
250             delete chains[currentKey];
251         }
252         emit Released(msg.sender, amount);
253     }

   
254     function releaseAll() public returns (uint tokens) {
255         uint release;
256         uint balance;
257         (release, balance) = getFreezing(msg.sender, 0);
258         while (release != 0 && block.timestamp > release) {
259             releaseOnce();
260             tokens += balance;
261             (release, balance) = getFreezing(msg.sender, 0);
262         }
263     }

264     function toKey(address _addr, uint _release) internal pure returns (bytes32 result) {
265         // WISH masc to increase entropy
266         result = 0x5749534800000000000000000000000000000000000000000000000000000000;
267         assembly {
268             result := or(result, mul(_addr, 0x10000000000000000))
269             result := or(result, and(_release, 0xffffffffffffffff))
270         }
271     }

272     function freeze(address _to, uint64 _until) internal {
273         require(_until > block.timestamp);
274         bytes32 key = toKey(_to, _until);
275         bytes32 parentKey = toKey(_to, uint64(0));
276         uint64 next = chains[parentKey];

277         if (next == 0) {
278             chains[parentKey] = _until;
279             return;
280         }

281         bytes32 nextKey = toKey(_to, next);
282         uint parent;

283         while (next != 0 && _until > next) {
284             parent = next;
285             parentKey = nextKey;

286             next = chains[nextKey];
287             nextKey = toKey(_to, next);
288         }

289         if (_until == next) {
290             return;
291         }

292         if (next != 0) {
293             chains[key] = next;
294         }

295         chains[parentKey] = _until;
296     }
297 }



298 contract BurnableToken is BasicToken {

299   event Burn(address indexed burner, uint256 value);

 
300   function burn(uint256 _value) public {
301     _burn(msg.sender, _value);
302   }

303   function _burn(address _who, uint256 _value) internal {
304     require(_value <= balances[_who]);
305     // no need to require value <= totalSupply, since that would imply the
306     // sender's balance is greater than the totalSupply, which *should* be an assertion failure

307     balances[_who] = balances[_who].sub(_value);
308     totalSupply_ = totalSupply_.sub(_value);
309     emit Burn(_who, _value);
310     emit Transfer(_who, address(0), _value);
311   }
312 }



313 contract Pausable is Ownable {
314   event Pause();
315   event Unpause();

316   bool public paused = false;


 
317   modifier whenNotPaused() {
318     require(!paused);
319     _;
320   }


321   modifier whenPaused() {
322     require(paused);
323     _;
324   }


325   function pause() onlyOwner whenNotPaused public {
326     paused = true;
327     emit Pause();
328   }

329   function unpause() onlyOwner whenPaused public {
330     paused = false;
331     emit Unpause();
332   }
333 }


334 contract FreezableMintableToken is FreezableToken, MintableToken {

335     function mintAndFreeze(address _to, uint _amount, uint64 _until) public onlyOwner canMint returns (bool) {
336         totalSupply_ = totalSupply_.add(_amount);

337         bytes32 currentKey = toKey(_to, _until);
338         freezings[currentKey] = freezings[currentKey].add(_amount);
339         freezingBalance[_to] = freezingBalance[_to].add(_amount);

340         freeze(_to, _until);
341         emit Mint(_to, _amount);
342         emit Freezed(_to, _until, _amount);
343         emit Transfer(msg.sender, _to, _amount);
344         return true;
345     }
346 }



347 contract Consts {
348     uint public constant TOKEN_DECIMALS = 18;
349     uint8 public constant TOKEN_DECIMALS_UINT8 = 18;
350     uint public constant TOKEN_DECIMAL_MULTIPLIER = 10 ** TOKEN_DECIMALS;

351     string public constant TOKEN_NAME = "Phuket Holiday Coin";
352     string public constant TOKEN_SYMBOL = "PHC";
353     bool public constant PAUSED = false;
354     address public constant TARGET_USER = 0xf4A9B48F974AC8cA9f240F06b3ef71D003248F5a;
    
355     bool public constant CONTINUE_MINTING = true;
356 }




357 contract MainToken is Consts, FreezableMintableToken, BurnableToken, Pausable
    
358 {
    
359     event Initialized();
360     bool public initialized = false;

361     constructor() public {
362         init();
363         transferOwnership(TARGET_USER);
364     }
    

365     function name() public pure returns (string _name) {
366         return TOKEN_NAME;
367     }

368     function symbol() public pure returns (string _symbol) {
369         return TOKEN_SYMBOL;
370     }

371     function decimals() public pure returns (uint8 _decimals) {
372         return TOKEN_DECIMALS_UINT8;
373     }

374     function transferFrom(address _from, address _to, uint256 _value) public returns (bool _success) {
375         require(!paused);
376         return super.transferFrom(_from, _to, _value);
377     }

378     function transfer(address _to, uint256 _value) public returns (bool _success) {
379         require(!paused);
380         return super.transfer(_to, _value);
381     }

    
382     function init() private {
383         require(!initialized);
384         initialized = true;

385         if (PAUSED) {
386             pause();
387         }

        
388         address[1] memory addresses = [address(0xf4a9b48f974ac8ca9f240f06b3ef71d003248f5a)];
389         uint[1] memory amounts = [uint(220000000000000000000000000)];
390         uint64[1] memory freezes = [uint64(0)];

391         for (uint i = 0; i < addresses.length; i++) {
392             if (freezes[i] == 0) {
393                 mint(addresses[i], amounts[i]);
394             } else {
395                 mintAndFreeze(addresses[i], amounts[i], freezes[i]);
396             }
397         }
        

398         if (!CONTINUE_MINTING) {
399             finishMinting();
400         }

401         emit Initialized();
402     }
    
403 }