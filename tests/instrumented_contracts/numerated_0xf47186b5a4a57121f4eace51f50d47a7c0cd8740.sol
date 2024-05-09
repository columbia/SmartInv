1 pragma solidity ^0.4.22;
2 
3 contract ERC20Basic {
4   // events
5   event Transfer(address indexed from, address indexed to, uint256 value);
6 
7   // public functions
8   function totalSupply() public view returns (uint256);
9   function balanceOf(address addr) public view returns (uint256);
10   function transfer(address to, uint256 value) public returns (bool);
11 }
12 
13 contract BasicToken is ERC20Basic {
14   using SafeMath for uint256;
15 
16   // public variables
17   string public name;
18   string public symbol;
19   uint8 public decimals = 18;
20 
21   // internal variables
22   uint256 _totalSupply;
23   mapping(address => uint256) _balances;
24 
25   // events
26 
27   // public functions
28   function totalSupply() public view returns (uint256) {
29     return _totalSupply;
30   }
31 
32   function balanceOf(address addr) public view returns (uint256 balance) {
33     return _balances[addr];
34   }
35 
36   function transfer(address to, uint256 value) public returns (bool) {
37     require(to != address(0));
38     require(value <= _balances[msg.sender]);
39 
40     _balances[msg.sender] = _balances[msg.sender].sub(value);
41     _balances[to] = _balances[to].add(value);
42     emit Transfer(msg.sender, to, value);
43     return true;
44   }
45 
46   // internal functions
47 
48 }
49 
50 contract ERC20 is ERC20Basic {
51   // events
52   event Approval(address indexed owner, address indexed agent, uint256 value);
53 
54   // public functions
55   function allowance(address owner, address agent) public view returns (uint256);
56   function transferFrom(address from, address to, uint256 value) public returns (bool);
57   function approve(address agent, uint256 value) public returns (bool);
58 
59 }
60 
61 contract Ownable {
62 
63     // public variables
64     address public owner;
65 
66     // internal variables
67 
68     // events
69     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
70 
71     // public functions
72     constructor() public {
73         owner = msg.sender;
74     }
75 
76     modifier onlyOwner() {
77         require(msg.sender == owner);
78         _;
79     }
80 
81     function transferOwnership(address newOwner) public onlyOwner {
82         require(newOwner != address(0));
83         emit OwnershipTransferred(owner, newOwner);
84         owner = newOwner;
85     }
86 
87     // internal functions
88 }
89 
90 contract Freezeable is Ownable{
91     // public variables
92 
93     // internal variables
94     mapping(address => bool) _freezeList;
95 
96     // events
97     event Freezed(address indexed freezedAddr);
98     event UnFreezed(address indexed unfreezedAddr);
99 
100     // public functions
101     function freeze(address addr) onlyOwner whenNotFreezed public returns (bool) {
102       require(true != _freezeList[addr]);
103 
104       _freezeList[addr] = true;
105 
106       emit Freezed(addr);
107       return true;
108     }
109 
110     function unfreeze(address addr) onlyOwner whenFreezed public returns (bool) {
111       require(true == _freezeList[addr]);
112 
113       _freezeList[addr] = false;
114 
115       emit UnFreezed(addr);
116       return true;
117     }
118 
119     modifier whenNotFreezed() {
120         require(true != _freezeList[msg.sender]);
121         _;
122     }
123 
124     modifier whenFreezed() {
125         require(true == _freezeList[msg.sender]);
126         _;
127     }
128 
129     function isFreezing(address addr) public view returns (bool) {
130         if (true == _freezeList[addr]) {
131             return true;
132         } else {
133             return false;
134         }
135     }
136 
137     // internal functions
138 }
139 
140 contract StandardToken is ERC20, BasicToken {
141   // public variables
142 
143   // internal variables
144   mapping (address => mapping (address => uint256)) _allowances;
145 
146   // events
147 
148   // public functions
149   function transferFrom(address from, address to, uint256 value) public returns (bool) {
150     require(to != address(0));
151     require(value <= _balances[from]);
152     require(value <= _allowances[from][msg.sender]);
153 
154     _balances[from] = _balances[from].sub(value);
155     _balances[to] = _balances[to].add(value);
156     _allowances[from][msg.sender] = _allowances[from][msg.sender].sub(value);
157     emit Transfer(from, to, value);
158     return true;
159   }
160 
161   function approve(address agent, uint256 value) public returns (bool) {
162     _allowances[msg.sender][agent] = value;
163     emit Approval(msg.sender, agent, value);
164     return true;
165   }
166 
167   function allowance(address owner, address agent) public view returns (uint256) {
168     return _allowances[owner][agent];
169   }
170 
171   function increaseApproval(address agent, uint value) public returns (bool) {
172     _allowances[msg.sender][agent] = _allowances[msg.sender][agent].add(value);
173     emit Approval(msg.sender, agent, _allowances[msg.sender][agent]);
174     return true;
175   }
176 
177   function decreaseApproval(address agent, uint value) public returns (bool) {
178     uint allowanceValue = _allowances[msg.sender][agent];
179     if (value > allowanceValue) {
180       _allowances[msg.sender][agent] = 0;
181     } else {
182       _allowances[msg.sender][agent] = allowanceValue.sub(value);
183     }
184     emit Approval(msg.sender, agent, _allowances[msg.sender][agent]);
185     return true;
186   }
187 
188   // internal functions
189 }
190 
191 contract FreezeableToken is StandardToken, Freezeable {
192     // public variables
193 
194     // internal variables
195 
196     // events
197 
198     // public functions
199     function transfer(address to, uint256 value) public whenNotFreezed returns (bool) {
200       return super.transfer(to, value);
201     }
202 
203     function transferFrom(address from, address to, uint256 value) public whenNotFreezed returns (bool) {
204       return super.transferFrom(from, to, value);
205     }
206 
207     function approve(address agent, uint256 value) public whenNotFreezed returns (bool) {
208       return super.approve(agent, value);
209     }
210 
211     function increaseApproval(address agent, uint value) public whenNotFreezed returns (bool success) {
212       return super.increaseApproval(agent, value);
213     }
214 
215     function decreaseApproval(address agent, uint value) public whenNotFreezed returns (bool success) {
216       return super.decreaseApproval(agent, value);
217     }
218 
219     // internal functions
220 }
221 
222 contract MintableToken is StandardToken, Ownable {
223     // public variables
224 
225     // internal variables
226 
227     // events
228     event Mint(address indexed to, uint256 value);
229     event Burn(address indexed to, uint256 value);
230 
231     // public functions
232     function mint(address addr, uint256 value) onlyOwner public returns (bool) {
233       _totalSupply = _totalSupply.add(value);
234       _balances[addr] = _balances[addr].add(value);
235 
236       emit Mint(addr, value);
237       emit Transfer(address(0), addr, value);
238 
239       return true;
240     }
241 
242     function burn(uint256 value) onlyOwner public returns (bool) {
243         require(_balances[msg.sender] >= value);   // Check if the sender has enough
244         _balances[msg.sender] -= value;            // Subtract from the sender
245         _totalSupply -= value;                      // Updates totalSupply
246         emit Burn(msg.sender, value);
247         return true;
248     }
249 
250     // internal functions
251 }
252 
253 interface ArtChainInterface {
254     function isPaused() external view returns (bool);
255     function isItemExist(uint256 _tokenId) external view returns (bool);
256     function isItemSell(uint256 _tokenId) external view returns (bool);
257     function getItemPrice(uint256 _tokenId) external view returns (uint256);
258     function buyItem(address _buyer, uint256 _tokenId, uint256 _affCode) external;
259 }
260 
261 contract YibEvents {
262     event UpdatePrice
263     (
264         uint256 timeStamp,
265         uint256 price
266     );
267 }
268 
269 contract YibToken is FreezeableToken, MintableToken,YibEvents {
270     // public variables
271     string public name = "Yi Chain";
272     string public symbol = "YIB";
273     uint8 public decimals = 8;
274 
275     ArtChainInterface artChain;
276 
277     uint256 public yibPrice = 1000000;
278 
279     uint256 public lastPrice = 800000;
280     string private lastDate ="";
281 
282     constructor() public {
283       _totalSupply = 10000000000 * (10 ** uint256(decimals));
284 
285       _balances[msg.sender] = _totalSupply;
286       emit Transfer(0x0, msg.sender, _totalSupply);
287     }
288 
289     function setArtChain(address _addr)
290         onlyOwner()
291         public
292     {
293         artChain = ArtChainInterface(_addr);
294     }
295 
296     function setYibPrice(string _date, uint256 _newPrice)
297         onlyOwner()
298         public
299     {
300         if(keccak256(lastDate) != keccak256(_date)) {
301             lastPrice = yibPrice;
302             lastDate = _date;
303         }
304 
305         yibPrice = _newPrice;
306 
307         emit YibEvents.UpdatePrice ({
308             timeStamp: now,
309             price: yibPrice
310         });
311     }
312 
313     function buyArtByYib(uint256 _tokenId, uint256 _affCode)
314         public
315     {
316         require(artChain != address(0), "artchain is empty");
317         require(artChain.isPaused() == false, "artchain paused");
318         require(artChain.isItemExist(_tokenId) == true, "item do not exist");
319         require(artChain.isItemSell(_tokenId) == false, "item already sold");
320 
321         uint256 _price =  artChain.getItemPrice(_tokenId);
322         approve(address(artChain),_price);
323 
324         artChain.buyItem(msg.sender,_tokenId,_affCode);
325     }
326 
327     function getCurrentPrice()
328         public
329         view
330         returns (uint256)
331     {
332         return yibPrice;
333     }
334 }
335 
336 library SafeMath {
337     function mul(uint256 a, uint256 b) internal pure returns (uint256) {
338       if (a == 0) {
339         return 0;
340       }
341       uint256 c = a * b;
342       assert(c / a == b);
343       return c;
344     }
345 
346     function div(uint256 a, uint256 b) internal pure returns (uint256) {
347       // assert(b > 0); // Solidity automatically throws when dividing by 0
348       uint256 c = a / b;
349       // assert(a == b * c + a % b); // There is no case in which this doesn't hold
350       return c;
351     }
352 
353     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
354       assert(b <= a);
355       return a - b;
356     }
357 
358     function add(uint256 a, uint256 b) internal pure returns (uint256) {
359       uint256 c = a + b;
360       assert(c >= a);
361       return c;
362     }
363 }