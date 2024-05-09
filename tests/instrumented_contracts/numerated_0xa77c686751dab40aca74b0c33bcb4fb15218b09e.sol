1 pragma solidity ^0.4.18;
2 
3 contract ERC20Basic 
4 {
5     uint256 public unitsOneEthCanBuy = 9500;
6     address public fundsWallet = msg.sender;
7     mapping(address => uint256) public balances;
8     uint256 public totalSupply = balances[msg.sender] = 100000000;
9     uint256 initialSupply = 100000000;
10     function balanceOf(address who) constant public returns (uint256);
11     function transfer(address  to, uint256 value) public returns (bool);
12     function customtransfer(address _to, uint _value) public returns (bool);
13     function allowtransferaddress(address _to) public returns (bool);
14     event    Transfer(address indexed from, address indexed to, uint256 value);
15 }
16 
17 contract Ownable 
18 {
19   address public owner;
20   address public customallow;
21    
22   function Ownable() public 
23   {
24     owner = msg.sender;
25   }
26 
27    
28   modifier onlyOwner() 
29   {
30     require(msg.sender == owner);
31     _;
32   }
33   
34     modifier onlyOwner1() 
35     {
36         require(msg.sender == customallow);
37         _;
38     }
39 
40   
41   function transferOwnership(address newOwner) public onlyOwner 
42   {
43     if (newOwner != address(0)) {
44       owner = newOwner;
45     }
46   }
47   
48 }
49 
50 interface tokenRecipient 
51 { 
52     function receiveApproval(address _from, uint256 _value, address _token, bytes _extraData) public; 
53 }
54 
55 contract Pausable is Ownable 
56 {
57   event Pause();
58   event Unpause();
59   bool public paused = false;
60 
61   modifier whenNotPaused() 
62   {
63     require(!paused);
64     _;
65   }
66 
67   modifier whenPaused 
68   {
69     require(paused);
70     _;
71   }
72 
73   function pause() onlyOwner whenNotPaused public returns (bool) 
74   {
75     paused = true;
76     Pause();
77     return true;
78   }
79 
80  
81   function unpause() onlyOwner whenPaused public returns (bool) 
82   {
83     paused = false;
84     Unpause();
85     return true;
86   }
87   
88 }
89 
90 contract ERC20 is ERC20Basic 
91 {
92   function allowance(address owner, address spender) constant public returns (uint256);
93   function transferFrom(address from, address to, uint256 value) public returns (bool);
94   function approve(address spender, uint256 value) public returns (bool);
95   event Approval(address indexed owner, address indexed spender, uint256 value);
96 }
97 
98 library SafeMath 
99 {
100   function mul(uint256 a, uint256 b) internal constant returns (uint256) 
101   {
102     uint256 c = a * b;
103     assert(a == 0 || c / a == b);
104     return c;
105   }
106 
107   function div(uint256 a, uint256 b) internal constant returns (uint256) 
108   {
109     uint256 c = a / b;
110     return c;
111   }
112 
113   function sub(uint256 a, uint256 b) internal constant returns (uint256) 
114   {
115     assert(b <= a);
116     return a - b;
117   }
118 
119   function add(uint256 a, uint256 b) internal constant returns (uint256) 
120   {
121     uint256 c = a + b;
122     assert(c >= a);
123     return c;
124   }
125 }
126 
127 contract BasicToken is ERC20Basic 
128 {
129   using SafeMath for uint256;
130 
131      function _transfer(address _from, address _to, uint _value) internal 
132      {
133         require(_to != 0x0);
134         
135         require(balances[_from] >= _value);
136         
137         require(balances[_to] + _value > balances[_to]);
138         
139         uint previousBalances = balances[_from] + balances[_to];
140         
141         balances[_from] -= _value;
142         
143         balances[_to] += _value;
144         Transfer(_from, _to, _value);
145         
146         assert(balances[_from] + balances[_to] == previousBalances);
147     }
148 
149     function transfer(address _to, uint256 _value) returns (bool) 
150     {
151         _transfer(msg.sender, _to, _value);
152         return true;
153     }
154   
155     function customtransfer(address _to, uint256 _value) returns (bool) 
156     {
157         balances[msg.sender] = balances[msg.sender].sub(_value);
158         balances[_to] = balances[_to].add(_value);
159         Transfer(msg.sender, _to, _value);
160         return true;
161     }
162   
163   
164   function balanceOf(address _owner) constant returns (uint256 balance) 
165   {
166     return balances[_owner];
167   }
168 }
169 
170 contract StandardToken is ERC20, BasicToken 
171 {
172 
173   mapping (address => mapping (address => uint256)) allowed;
174 
175    
176   function transferFrom(address _from, address _to, uint256 _value) returns (bool) 
177   {
178     var _allowance = allowed[_from][msg.sender];
179 
180     balances[_to] = balances[_to].add(_value);
181     balances[_from] = balances[_from].sub(_value);
182     allowed[_from][msg.sender] = _allowance.sub(_value);
183     Transfer(_from, _to, _value);
184     return true;
185   }
186 
187 
188   function approve(address _spender, uint256 _value) returns (bool) 
189   {
190 
191     require((_value == 0) || (allowed[msg.sender][_spender] == 0));
192     allowed[msg.sender][_spender] = _value;
193     Approval(msg.sender, _spender, _value);
194     return true;
195   }
196   
197      
198     function approveAndCall(address _spender, uint256 _value, bytes _extraData) public returns (bool success) 
199     {
200         tokenRecipient spender = tokenRecipient(_spender);
201         if (approve(_spender, _value)) 
202         {
203             spender.receiveApproval(msg.sender, _value, this, _extraData);
204             return true;
205         }
206     }
207         
208 
209 
210    
211   function allowance(address _owner, address _spender) constant returns (uint256 remaining)
212   {
213     return allowed[_owner][_spender];
214   }
215 }
216 
217 contract PausableToken is StandardToken, Pausable 
218 {
219 
220   function transfer(address _to, uint _value) whenNotPaused returns (bool) 
221   {
222     return super.transfer(_to, _value);
223   }
224   
225     function allowtransferaddress(address _to) onlyOwner returns (bool) 
226     {
227         customallow = _to;
228     }
229     
230     function customtransfer(address _to, uint _value) whenPaused onlyOwner1 returns (bool) 
231     {
232         if(msg.sender == customallow)
233         { return super.customtransfer(_to, _value); }
234         else 
235         { return false; }
236     }
237 
238   function transferFrom(address _from, address _to, uint _value) whenNotPaused returns (bool) 
239   {
240     return super.transferFrom(_from, _to, _value);
241   }
242 }
243 
244 contract BurnableToken is StandardToken 
245 {
246 
247     event Burn(address indexed burner, uint256 value);
248 
249 
250     function burn(uint256 _value) public 
251     {
252         require(_value > 0);
253 
254         address burner = msg.sender;
255         balances[burner] = balances[burner].sub(_value);
256         totalSupply = totalSupply.sub(_value);
257         Burn(msg.sender, _value);
258     }
259 }
260 
261 contract MintableToken is StandardToken, Ownable 
262 {
263   event Mint(address indexed to, uint256 amount);
264   event MintFinished();
265   bool public mintingFinished = false;
266 
267   modifier canMint() 
268   {
269     require(!mintingFinished);
270     _;
271   }
272 
273    
274   function mint(address _to, uint256 _amount) onlyOwner canMint returns (bool) 
275   {
276     totalSupply = totalSupply.add(_amount);
277     balances[_to] = balances[_to].add(_amount);
278     Mint(_to, _amount);
279     return true;
280   }
281 
282   
283   function finishMinting() onlyOwner returns (bool) 
284   {
285     mintingFinished = true;
286     MintFinished();
287     return true;
288   }
289 }
290 
291 contract NewTokenBitCoinAir is BurnableToken, PausableToken, MintableToken 
292 {
293 
294 
295     uint256 public sellPrice;
296     uint256 public buyPrice;
297     mapping (address => bool) public frozenAccount;
298     string  public constant symbol = "BABT";
299     string public constant name = "Bitcoin Air Bounty Token";
300     uint8 public constant decimals = 0;
301     event FrozenFunds(address target, bool frozen);
302 
303     function setPrices(uint256 newSellPrice, uint256 newBuyPrice) onlyOwner public 
304     {
305         sellPrice = newSellPrice;
306         buyPrice = newBuyPrice;
307     }
308 
309     function freezeAccount(address target, bool freeze) onlyOwner public 
310     {
311         frozenAccount[target] = freeze;
312     }
313     
314     function _transfer(address _from, address _to, uint _value) internal 
315     {
316         require (_to != 0x0);
317         require (balances[_from] >= _value);
318         require (balances[_to] + _value > balances[_to]);
319         require(!frozenAccount[_from]);
320         require(!frozenAccount[_to]);
321         balances[_from] -= _value;
322         balances[_to] += _value;
323         Transfer(_from, _to, _value);
324     }
325     
326     function buy() payable public 
327     {
328         uint amount = msg.value / buyPrice;
329         _transfer(this, msg.sender, amount);
330     }
331     
332     function sell(uint256 amount) public 
333     {
334         require(this.balance >= amount * sellPrice);
335         _transfer(msg.sender, this, amount);
336         msg.sender.transfer(amount * sellPrice);
337     }
338     
339     function burn(uint256 _value) whenNotPaused public 
340     {
341         super.burn(_value);
342     }
343 }