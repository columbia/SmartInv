1 pragma solidity 0.4.18;
2 
3 
4 /**
5  * @title SafeMath
6  * @dev Math operations with safety checks that throw on error
7  */
8 library SafeMath {
9     function mul(uint256 a, uint256 b) internal constant returns (uint256) {
10         uint256 c = a * b;
11         assert(a == 0 || c / a == b);
12         return c;
13     }
14 
15     function div(uint256 a, uint256 b) internal constant returns (uint256) {
16         // assert(b > 0); // Solidity automatically throws when dividing by 0
17         uint256 c = a / b;
18         // assert(a == b * c + a % b); // There is no case in which this doesn't hold
19         return c;
20     }
21 
22     function sub(uint256 a, uint256 b) internal constant returns (uint256) {
23         assert(b <= a);
24         return a - b;
25     }
26 
27     function add(uint256 a, uint256 b) internal constant returns (uint256) {
28         uint256 c = a + b;
29         assert(c >= a);
30         return c;
31     }
32 }
33 
34 /**
35  * @title Ownable
36  * @dev The Ownable contract has an owner address, and provides basic authorization control
37  * functions, this simplifies the implementation of "user permissions".
38  */
39 contract Ownable {
40     //Variables
41     address public owner;
42 
43     address public newOwner;
44 
45     //    Modifiers
46     /**
47      * @dev Throws if called by any account other than the owner.
48      */
49     modifier onlyOwner() {
50         require(msg.sender == owner);
51         _;
52     }
53 
54     /**
55      * @dev The Ownable constructor sets the original `owner` of the contract to the sender
56      * account.
57      */
58     function Ownable() public {
59         owner = msg.sender;
60     }
61 
62     /**
63      * @dev Allows the current owner to transfer control of the contract to a newOwner.
64      * @param _newOwner The address to transfer ownership to.
65      */
66     function transferOwnership(address _newOwner) public onlyOwner {
67         require(_newOwner != address(0));
68         newOwner = _newOwner;
69 
70     }
71 
72     function acceptOwnership() public {
73         if (msg.sender == newOwner) {
74             owner = newOwner;
75         }
76     }
77 }
78 
79 contract ERC20Basic {
80     uint256 public totalSupply;
81     function balanceOf(address who) public constant returns (uint256);
82     function transfer(address to, uint256 value) public returns (bool);
83     event Transfer(address indexed from, address indexed to, uint256 value);
84 }
85 
86 contract ERC20 is ERC20Basic {
87     function allowance(address owner, address spender) public constant returns (uint256);
88     function transferFrom(address from, address to, uint256 value) public returns (bool);
89     function approve(address spender, uint256 value) public returns (bool);
90     event Approval(address indexed owner, address indexed spender, uint256 value);
91 }
92 
93 contract BasicToken is ERC20Basic {
94     using SafeMath for uint256;
95 
96     mapping(address => uint256) balances;
97 
98     /**
99     * @dev transfer token for a specified address
100     * @param _to The address to transfer to.
101     * @param _value The amount to be transferred.
102     */
103     function transfer(address _to, uint256 _value) public returns (bool) {
104         require(_to != address(0));
105         require(_value <= balances[msg.sender]);
106 
107         // SafeMath.sub will throw if there is not enough balance.
108         balances[msg.sender] = balances[msg.sender].sub(_value);
109         balances[_to] = balances[_to].add(_value);
110         Transfer(msg.sender, _to, _value);
111         return true;
112     }
113 
114     /**
115     * @dev Gets the balance of the specified address.
116     * @param _owner The address to query the the balance of.
117     * @return An uint256 representing the amount owned by the passed address.
118     */
119     function balanceOf(address _owner) public constant returns (uint256 balance) {
120         return balances[_owner];
121     }
122 
123 }
124 
125 contract StandardToken is ERC20, BasicToken {
126 
127     mapping (address => mapping (address => uint256)) internal allowed;
128 
129     /**
130      * @dev Transfer tokens from one address to another
131      * @param _from address The address which you want to send tokens from
132      * @param _to address The address which you want to transfer to
133      * @param _value uint256 the amount of tokens to be transferred
134      */
135     function transferFrom(address _from, address _to, uint256 _value) public returns (bool) {
136         require(_to != address(0));
137         require(_value <= balances[_from]);
138         require(_value <= allowed[_from][msg.sender]);
139 
140         balances[_from] = balances[_from].sub(_value);
141         balances[_to] = balances[_to].add(_value);
142         allowed[_from][msg.sender] = allowed[_from][msg.sender].sub(_value);
143         Transfer(_from, _to, _value);
144         return true;
145     }
146 
147     /**
148      * @dev Approve the passed address to spend the specified amount of tokens on behalf of msg.sender.
149      *
150      * Beware that changing an allowance with this method brings the risk that someone may use both the old
151      * and the new allowance by unfortunate transaction ordering. One possible solution to mitigate this
152      * race condition is to first reduce the spender's allowance to 0 and set the desired value afterwards:
153      * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
154      * @param _spender The address which will spend the funds.
155      * @param _value The amount of tokens to be spent.
156      */
157     function approve(address _spender, uint256 _value) public returns (bool) {
158         allowed[msg.sender][_spender] = _value;
159         Approval(msg.sender, _spender, _value);
160         return true;
161     }
162 
163     /**
164      * @dev Function to check the amount of tokens that an owner allowed to a spender.
165      * @param _owner address The address which owns the funds.
166      * @param _spender address The address which will spend the funds.
167      * @return A uint256 specifying the amount of tokens still available for the spender.
168      */
169     function allowance(address _owner, address _spender) public constant returns (uint256 remaining) {
170         return allowed[_owner][_spender];
171     }
172 
173     /**
174      * approve should be called when allowed[_spender] == 0. To increment
175      * allowed value is better to use this function to avoid 2 calls (and wait until
176      * the first transaction is mined)
177      * From MonolithDAO Token.sol
178      */
179     function increaseApproval(address _spender, uint _addedValue) public returns (bool success) {
180         allowed[msg.sender][_spender] = allowed[msg.sender][_spender].add(_addedValue);
181         Approval(msg.sender, _spender, allowed[msg.sender][_spender]);
182         return true;
183     }
184 
185     function decreaseApproval(address _spender, uint _subtractedValue) public returns (bool success) {
186         uint oldValue = allowed[msg.sender][_spender];
187         if (_subtractedValue > oldValue) {
188             allowed[msg.sender][_spender] = 0;
189         } else {
190             allowed[msg.sender][_spender] = oldValue.sub(_subtractedValue);
191         }
192         Approval(msg.sender, _spender, allowed[msg.sender][_spender]);
193         return true;
194     }
195 
196 }
197 
198 contract BiddableERC20 is StandardToken, Ownable {
199     /* Public variables of the token */
200     uint256 public creationBlock;
201 
202     uint8 public decimals;
203 
204     string public name;
205 
206     string public symbol;
207 
208     string public standard;
209 
210     bool public locked;
211 
212     /* Initializes contract with initial supply tokens to the creator of the contract */
213     function BiddableERC20(
214         uint256 _totalSupply,
215         string _tokenName,
216         uint8 _decimalUnits,
217         string _tokenSymbol,
218         bool _transferAllSupplyToOwner,
219         bool _locked
220     ) public {
221         standard = "ERC20 0.1";
222         locked = _locked;
223         totalSupply = _totalSupply;
224 
225         if (_transferAllSupplyToOwner) {
226             balances[msg.sender] = totalSupply;
227         } else {
228             balances[this] = totalSupply;
229         }
230         name = _tokenName;
231         // Set the name for display purposes
232         symbol = _tokenSymbol;
233         // Set the symbol for display purposes
234         decimals = _decimalUnits;
235         // Amount of decimals for display purposes
236         creationBlock = block.number;
237     }
238 
239     /* public methods */
240     function transfer(address _to, uint256 _value) public returns (bool) {
241         require(locked == false);
242         return super.transfer(_to, _value);
243     }
244 
245     function approve(address _spender, uint256 _value) public returns (bool success) {
246         if (locked) {
247             return false;
248         }
249         return super.approve(_spender, _value);
250     }
251 
252     function increaseApproval(address _spender, uint _addedValue) public returns (bool success) {
253         if (locked) {
254             return false;
255         }
256         return super.increaseApproval(_spender, _addedValue);
257     }
258 
259     function decreaseApproval(address _spender, uint _subtractedValue) public returns (bool success) {
260         if (locked) {
261             return false;
262         }
263         return super.decreaseApproval(_spender, _subtractedValue);
264     }
265 
266     function transferFrom(address _from, address _to, uint256 _value) public returns (bool success) {
267         if (locked) {
268             return false;
269         }
270 
271         return super.transferFrom(_from, _to, _value);
272     }
273 }
274 
275 contract MintingERC20 is BiddableERC20 {
276 
277     //Variables
278     mapping (address => bool) public minters;
279 
280     uint256 public maxSupply;
281     bool public disableMinting;
282 
283     //    Modifiers
284     modifier onlyMinters () {
285         require(true == minters[msg.sender]);
286         _;
287     }
288 
289     function MintingERC20(
290         uint256 _initialSupply,
291         uint256 _maxSupply,
292         string _tokenName,
293         uint8 _decimals,
294         string _symbol,
295         bool _transferAllSupplyToOwner,
296         bool _locked
297     )
298     public
299     BiddableERC20(_initialSupply, _tokenName, _decimals, _symbol, _transferAllSupplyToOwner, _locked)
300     {
301         standard = "MintingERC20 0.1";
302         minters[msg.sender] = true;
303         maxSupply = _maxSupply;
304     }
305 
306     function addMinter(address _newMinter) public onlyOwner {
307         minters[_newMinter] = true;
308     }
309 
310     function removeMinter(address _minter) public onlyOwner {
311         minters[_minter] = false;
312     }
313 
314     function mint(address _addr, uint256 _amount) public onlyMinters returns (uint256) {
315         if (true == disableMinting) {
316             return uint256(0);
317         }
318 
319         if (_amount == uint256(0)) {
320             return uint256(0);
321         }
322 
323         if (totalSupply.add(_amount) > maxSupply) {
324             return uint256(0);
325         }
326 
327         totalSupply = totalSupply.add(_amount);
328         balances[_addr] = balances[_addr].add(_amount);
329         Transfer(address(0), _addr, _amount);
330 
331         return _amount;
332     }
333 }
334 
335 contract Biddable is MintingERC20 {
336 
337     bool public transferFrozen;
338 
339     uint256 public maxSupply = (200 * uint(10) ** 6) * uint(10) ** 18; // 200,000,000
340 
341     function Biddable(
342         uint256 _initialSupply,
343         bool _locked
344     )
345     public
346     MintingERC20(_initialSupply, maxSupply, "BidDex", 18, "BDX", false, _locked)
347     {
348         standard = "Biddable 0.1";
349     }
350 
351     // Lock contract
352     function setLocked(bool _locked) public onlyOwner {
353         locked = _locked;
354     }
355 
356     // Allow token transfer.
357     function freezing(bool _transferFrozen) public onlyOwner {
358         transferFrozen = _transferFrozen;
359     }
360 
361     // ERC20 functions
362     // =========================
363     function transfer(address _to, uint _value) public returns (bool) {
364         require(!transferFrozen);
365         return super.transfer(_to, _value);
366     }
367 
368     function transferFrom(address _from, address _to, uint _value) public returns (bool success) {
369         require(!transferFrozen);
370         return super.transferFrom(_from, _to, _value);
371     }
372 }