1 pragma solidity ^0.4.13;
2 
3 contract ERC20Basic {
4   uint256 public totalSupply;
5   function balanceOf(address who) public constant returns (uint256);
6   function transfer(address to, uint256 value) public returns (bool);
7   event Transfer(address indexed from, address indexed to, uint256 value);
8 }
9 
10 contract ERC20 is ERC20Basic {
11   function allowance(address owner, address spender) public constant returns (uint256);
12   function transferFrom(address from, address to, uint256 value) public returns (bool);
13   function approve(address spender, uint256 value) public returns (bool);
14   event Approval(address indexed owner, address indexed spender, uint256 value);
15 }
16 
17 contract Ownable {
18   address public owner;
19 
20 
21   event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
22 
23 
24   /**
25    * @dev The Ownable constructor sets the original `owner` of the contract to the sender
26    * account.
27    */
28   function Ownable() {
29     owner = msg.sender;
30   }
31 
32 
33   /**
34    * @dev Throws if called by any account other than the owner.
35    */
36   modifier onlyOwner() {
37     require(msg.sender == owner);
38     _;
39   }
40 
41 
42   /**
43    * @dev Allows the current owner to transfer control of the contract to a newOwner.
44    * @param newOwner The address to transfer ownership to.
45    */
46   function transferOwnership(address newOwner) onlyOwner public {
47     require(newOwner != address(0));
48     OwnershipTransferred(owner, newOwner);
49     owner = newOwner;
50   }
51 
52 }
53 
54 contract VeTokenizedAssetRegistry is Ownable {
55 
56     //--- Definitions
57 
58     struct Asset {
59         address addr;
60         string meta;
61     }
62 
63     //--- Storage
64 
65     mapping (string => Asset) assets;
66 
67     //--- Constructor
68 
69     function VeTokenizedAssetRegistry()
70         Ownable
71     {
72     }
73 
74     //--- Events
75 
76     event AssetCreated(
77         address indexed addr
78     );
79 
80     event AssetRegistered(
81         address indexed addr,
82         string symbol,
83         string name,
84         string description,
85         uint256 decimals
86     );
87 
88     event MetaUpdated(string symbol, string meta);
89 
90     //--- Public mutable functions
91 
92     function create(
93         string symbol,
94         string name,
95         string description,
96         uint256 decimals,
97         string source,
98         string proof,
99         uint256 totalSupply,
100         string meta
101     )
102         public
103         onlyOwner
104         returns (address)
105     {
106         VeTokenizedAsset asset = new VeTokenizedAsset();
107         asset.setup(
108             symbol,
109             name,
110             description,
111             decimals,
112             source,
113             proof,
114             totalSupply
115         );
116 
117         asset.transferOwnership(msg.sender);
118 
119         AssetCreated(asset);
120 
121         register(
122             asset,
123             symbol,
124             name,
125             description,
126             decimals,
127             meta
128         );
129 
130         return asset;
131     }
132 
133     function register(
134         address addr,
135         string symbol,
136         string name,
137         string description,
138         uint256 decimals,
139         string meta
140     )
141         public
142         onlyOwner
143     {
144         assets[symbol].addr = addr;
145 
146         AssetRegistered(
147             addr,
148             symbol,
149             name,
150             description,
151             decimals
152         );
153 
154         updateMeta(symbol, meta);
155     }
156 
157     function updateMeta(string symbol, string meta) public onlyOwner {
158         assets[symbol].meta = meta;
159 
160         MetaUpdated(symbol, meta);
161     }
162 
163     function getAsset(string symbol) public constant returns (address addr, string meta) {
164         Asset storage asset = assets[symbol];
165         addr = asset.addr;
166         meta = asset.meta;
167     }
168 }
169 
170 library SafeMath {
171   function mul(uint256 a, uint256 b) internal constant returns (uint256) {
172     uint256 c = a * b;
173     assert(a == 0 || c / a == b);
174     return c;
175   }
176 
177   function div(uint256 a, uint256 b) internal constant returns (uint256) {
178     // assert(b > 0); // Solidity automatically throws when dividing by 0
179     uint256 c = a / b;
180     // assert(a == b * c + a % b); // There is no case in which this doesn't hold
181     return c;
182   }
183 
184   function sub(uint256 a, uint256 b) internal constant returns (uint256) {
185     assert(b <= a);
186     return a - b;
187   }
188 
189   function add(uint256 a, uint256 b) internal constant returns (uint256) {
190     uint256 c = a + b;
191     assert(c >= a);
192     return c;
193   }
194 }
195 
196 contract BasicToken is ERC20Basic {
197   using SafeMath for uint256;
198 
199   mapping(address => uint256) balances;
200 
201   /**
202   * @dev transfer token for a specified address
203   * @param _to The address to transfer to.
204   * @param _value The amount to be transferred.
205   */
206   function transfer(address _to, uint256 _value) public returns (bool) {
207     require(_to != address(0));
208 
209     // SafeMath.sub will throw if there is not enough balance.
210     balances[msg.sender] = balances[msg.sender].sub(_value);
211     balances[_to] = balances[_to].add(_value);
212     Transfer(msg.sender, _to, _value);
213     return true;
214   }
215 
216   /**
217   * @dev Gets the balance of the specified address.
218   * @param _owner The address to query the the balance of.
219   * @return An uint256 representing the amount owned by the passed address.
220   */
221   function balanceOf(address _owner) public constant returns (uint256 balance) {
222     return balances[_owner];
223   }
224 
225 }
226 
227 contract StandardToken is ERC20, BasicToken {
228 
229   mapping (address => mapping (address => uint256)) allowed;
230 
231 
232   /**
233    * @dev Transfer tokens from one address to another
234    * @param _from address The address which you want to send tokens from
235    * @param _to address The address which you want to transfer to
236    * @param _value uint256 the amount of tokens to be transferred
237    */
238   function transferFrom(address _from, address _to, uint256 _value) public returns (bool) {
239     require(_to != address(0));
240 
241     uint256 _allowance = allowed[_from][msg.sender];
242 
243     // Check is not needed because sub(_allowance, _value) will already throw if this condition is not met
244     // require (_value <= _allowance);
245 
246     balances[_from] = balances[_from].sub(_value);
247     balances[_to] = balances[_to].add(_value);
248     allowed[_from][msg.sender] = _allowance.sub(_value);
249     Transfer(_from, _to, _value);
250     return true;
251   }
252 
253   /**
254    * @dev Approve the passed address to spend the specified amount of tokens on behalf of msg.sender.
255    *
256    * Beware that changing an allowance with this method brings the risk that someone may use both the old
257    * and the new allowance by unfortunate transaction ordering. One possible solution to mitigate this
258    * race condition is to first reduce the spender's allowance to 0 and set the desired value afterwards:
259    * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
260    * @param _spender The address which will spend the funds.
261    * @param _value The amount of tokens to be spent.
262    */
263   function approve(address _spender, uint256 _value) public returns (bool) {
264     allowed[msg.sender][_spender] = _value;
265     Approval(msg.sender, _spender, _value);
266     return true;
267   }
268 
269   /**
270    * @dev Function to check the amount of tokens that an owner allowed to a spender.
271    * @param _owner address The address which owns the funds.
272    * @param _spender address The address which will spend the funds.
273    * @return A uint256 specifying the amount of tokens still available for the spender.
274    */
275   function allowance(address _owner, address _spender) public constant returns (uint256 remaining) {
276     return allowed[_owner][_spender];
277   }
278 
279   /**
280    * approve should be called when allowed[_spender] == 0. To increment
281    * allowed value is better to use this function to avoid 2 calls (and wait until
282    * the first transaction is mined)
283    * From MonolithDAO Token.sol
284    */
285   function increaseApproval (address _spender, uint _addedValue)
286     returns (bool success) {
287     allowed[msg.sender][_spender] = allowed[msg.sender][_spender].add(_addedValue);
288     Approval(msg.sender, _spender, allowed[msg.sender][_spender]);
289     return true;
290   }
291 
292   function decreaseApproval (address _spender, uint _subtractedValue)
293     returns (bool success) {
294     uint oldValue = allowed[msg.sender][_spender];
295     if (_subtractedValue > oldValue) {
296       allowed[msg.sender][_spender] = 0;
297     } else {
298       allowed[msg.sender][_spender] = oldValue.sub(_subtractedValue);
299     }
300     Approval(msg.sender, _spender, allowed[msg.sender][_spender]);
301     return true;
302   }
303 
304 }
305 
306 contract VeTokenizedAsset is StandardToken, Ownable {
307 
308     //--- Definitions
309 
310     using SafeMath for uint256;
311 
312     //--- Storage
313 
314     bool public configured;
315     string public symbol;
316     string public name;
317     string public description;
318     uint256 public decimals;
319     string public source;
320     string public proof;
321     uint256 public totalSupply;
322 
323     //--- Construction
324 
325     function VeTokenizedAsset() {
326         // asset should be parametrized using `setup()` function
327     }
328 
329     //--- Events
330 
331     event SourceChanged(string newSource, string newProof, uint256 newTotalSupply);
332     event SupplyChanged(uint256 newTotalSupply);
333 
334     //--- Public mutable functions
335 
336     function setup(
337         string _symbol,
338         string _name,
339         string _description,
340         uint256 _decimals,
341         string _source,
342         string _proof,
343         uint256 _totalSupply
344     )
345         public
346         onlyOwner
347     {
348         require(!configured);
349         require(bytes(_symbol).length > 0);
350         require(bytes(_name).length > 0);
351         require(_decimals > 0 && _decimals <= 32);
352 
353         symbol = _symbol;
354         name = _name;
355         description = _description;
356         decimals = _decimals;
357         source = _source;
358         proof = _proof;
359         totalSupply = _totalSupply;
360         configured = true;
361 
362         balances[owner] = _totalSupply;
363 
364         SourceChanged(_source, _proof, _totalSupply);
365     }
366 
367     function changeSource(string newSource, string newProof, uint256 newTotalSupply) onlyOwner {
368         uint256 prevBalance = balances[owner];
369 
370         if (newTotalSupply < totalSupply) {
371             uint256 decrease = totalSupply.sub(newTotalSupply);
372             balances[owner] = prevBalance.sub(decrease); // throws when balance is insufficient
373         } else if (newTotalSupply > totalSupply) {
374             uint256 increase = newTotalSupply.sub(totalSupply);
375             balances[owner] = prevBalance.add(increase);
376         }
377 
378         source = newSource;
379         proof = newProof;
380         totalSupply = newTotalSupply;
381 
382         SourceChanged(newSource, newProof, newTotalSupply);
383     }
384 
385     function mint(uint256 amount) public onlyOwner {
386         require(amount > 0);
387 
388         totalSupply = totalSupply.add(amount);
389         balances[owner] = balances[owner].add(amount);
390 
391         SupplyChanged(totalSupply);
392     }
393 
394     function burn(uint256 amount) public onlyOwner {
395         require(amount > 0);
396         require(amount <= balances[owner]);
397 
398         totalSupply = totalSupply.sub(amount);
399         balances[owner] = balances[owner].sub(amount); // throws when balance is insufficient
400 
401         SupplyChanged(totalSupply);
402     }
403 }