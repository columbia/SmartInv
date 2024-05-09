1 pragma solidity ^0.4.21;
2 
3 
4 
5 /**
6  * @title SafeMath
7  * @dev Math operations with safety checks that throw on error
8  */
9 library SafeMath {
10 
11     function mul(uint256 a, uint256 b) internal pure returns (uint256) {
12         uint256 c = a * b;
13         assert(a == 0 || c / a == b);
14         return c;
15     }
16 
17     function div(uint256 a, uint256 b) internal pure returns (uint256) {
18         // assert(b > 0); // Solidity automatically throws when dividing by 0
19         uint256 c = a / b;
20         // assert(a == b * c + a % b); // There is no case in which this doesn't hold
21         return c;
22     }
23 
24     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
25         assert(b <= a);
26         return a - b;
27     }
28 
29     function add(uint256 a, uint256 b) internal pure returns (uint256) {
30         uint256 c = a + b;
31         assert(c >= a);
32         return c;
33     }
34 }
35 
36 
37 contract ERC20 {
38 
39     uint256 public totalSupply;
40 
41     function balanceOf(address _owner) public view returns (uint256 balance);
42 
43     function transfer(address _to, uint256 _value) public returns (bool success);
44 
45     function transferFrom(address _from, address _to, uint256 _value) public returns (bool success);
46 
47     function approve(address _spender, uint256 _value) public returns (bool success);
48 
49     function allowance(address _owner, address _spender) public view returns (uint256 remaining);
50 
51     event Transfer(address indexed _from, address indexed _to, uint256 _value);
52 
53     event Approval(address indexed _owner, address indexed _spender, uint256 _value);
54 }
55 
56 
57 contract MultiOwnable {
58 
59     mapping (address => bool) public isOwner;
60     address[] public ownerHistory;
61 
62     event OwnerAddedEvent(address indexed _newOwner);
63     event OwnerRemovedEvent(address indexed _oldOwner);
64 
65     constructor() {
66         // Add default owner
67         address owner = msg.sender;
68         ownerHistory.push(owner);
69         isOwner[owner] = true;
70     }
71 
72     modifier onlyOwner() {
73         require(isOwner[msg.sender]);
74         _;
75     }
76 
77     function ownerHistoryCount() public view returns (uint) {
78         return ownerHistory.length;
79     }
80 
81     /** Add extra owner. */
82     function addOwner(address owner) onlyOwner public {
83         require(owner != address(0));
84         require(!isOwner[owner]);
85         ownerHistory.push(owner);
86         isOwner[owner] = true;
87         emit OwnerAddedEvent(owner);
88     }
89 
90     /** Remove extra owner. */
91     function removeOwner(address owner) onlyOwner public {
92         require(isOwner[owner]);
93         isOwner[owner] = false;
94         emit OwnerRemovedEvent(owner);
95     }
96 }
97 
98 
99 
100 
101 
102 
103 
104 
105 
106 contract StandardToken is ERC20 {
107 
108     using SafeMath for uint;
109 
110     mapping(address => uint256) balances;
111 
112     mapping(address => mapping(address => uint256)) allowed;
113 
114     function balanceOf(address _owner) public view returns (uint256 balance) {
115         return balances[_owner];
116     }
117 
118     function transfer(address _to, uint256 _value) public returns (bool) {
119         require(_to != address(0));
120 
121         balances[msg.sender] = balances[msg.sender].sub(_value);
122         balances[_to] = balances[_to].add(_value);
123         emit Transfer(msg.sender, _to, _value);
124         return true;
125     }
126 
127     /// @dev Allows allowed third party to transfer tokens from one address to another. Returns success.
128     /// @param _from Address from where tokens are withdrawn.
129     /// @param _to Address to where tokens are sent.
130     /// @param _value Number of tokens to transfer.
131     function transferFrom(address _from, address _to, uint256 _value) public returns (bool) {
132         require(_to != address(0));
133 
134         balances[_from] = balances[_from].sub(_value);
135         balances[_to] = balances[_to].add(_value);
136         allowed[_from][msg.sender] = allowed[_from][msg.sender].sub(_value);
137         emit Transfer(_from, _to, _value);
138         return true;
139     }
140 
141     /// @dev Sets approved amount of tokens for spender. Returns success.
142     /// @param _spender Address of allowed account.
143     /// @param _value Number of approved tokens.
144     function approve(address _spender, uint256 _value) public returns (bool) {
145         allowed[msg.sender][_spender] = _value;
146         emit Approval(msg.sender, _spender, _value);
147         return true;
148     }
149 
150     /// @dev Returns number of allowed tokens for given address.
151     /// @param _owner Address of token owner.
152     /// @param _spender Address of token spender.
153     function allowance(address _owner, address _spender) public view returns (uint256 remaining) {
154         return allowed[_owner][_spender];
155     }
156 }
157 
158 
159 
160 contract CommonToken is StandardToken, MultiOwnable {
161 
162     string public constant name   = 'TMSY';
163     string public constant symbol = 'TMSY';
164     uint8 public constant decimals = 18;
165 
166     uint256 public saleLimit;   // 85% of tokens for sale.
167     uint256 public teamTokens;  // 7% of tokens goes to the team and will be locked for 1 year.
168     uint256 public partnersTokens;
169     uint256 public advisorsTokens;
170     uint256 public reservaTokens;
171 
172     // 7% of team tokens will be locked at this address for 1 year.
173     address public teamWallet; // Team address.
174     address public partnersWallet; // bountry address.
175     address public advisorsWallet; // Team address.
176     address public reservaWallet;
177 
178     uint public unlockTeamTokensTime = now + 365 days;
179 
180     // The main account that holds all tokens at the beginning and during tokensale.
181     address public seller; // Seller address (main holder of tokens)
182 
183     uint256 public tokensSold; // (e18) Number of tokens sold through all tiers or tokensales.
184     uint256 public totalSales; // Total number of sales (including external sales) made through all tiers or tokensales.
185 
186     // Lock the transfer functions during tokensales to prevent price speculations.
187     bool public locked = true;
188     mapping (address => bool) public walletsNotLocked;
189 
190     event SellEvent(address indexed _seller, address indexed _buyer, uint256 _value);
191     event ChangeSellerEvent(address indexed _oldSeller, address indexed _newSeller);
192     event Burn(address indexed _burner, uint256 _value);
193     event Unlock();
194 
195     constructor (
196         address _seller,
197         address _teamWallet,
198         address _partnersWallet,
199         address _advisorsWallet,
200         address _reservaWallet
201     ) MultiOwnable() public {
202 
203         totalSupply    = 600000000 ether;
204         saleLimit      = 390000000 ether;
205         teamTokens     = 120000000 ether;
206         partnersTokens =  30000000 ether;
207         reservaTokens  =  30000000 ether;
208         advisorsTokens =  30000000 ether;
209 
210         seller         = _seller;
211         teamWallet     = _teamWallet;
212         partnersWallet = _partnersWallet;
213         advisorsWallet = _advisorsWallet;
214         reservaWallet  = _reservaWallet;
215 
216         uint sellerTokens = totalSupply - teamTokens - partnersTokens - advisorsTokens - reservaTokens;
217         balances[seller] = sellerTokens;
218         emit Transfer(0x0, seller, sellerTokens);
219 
220         balances[teamWallet] = teamTokens;
221         emit Transfer(0x0, teamWallet, teamTokens);
222 
223         balances[partnersWallet] = partnersTokens;
224         emit Transfer(0x0, partnersWallet, partnersTokens);
225 
226         balances[reservaWallet] = reservaTokens;
227         emit Transfer(0x0, reservaWallet, reservaTokens);
228 
229         balances[advisorsWallet] = advisorsTokens;
230         emit Transfer(0x0, advisorsWallet, advisorsTokens);
231     }
232 
233     modifier ifUnlocked(address _from, address _to) {
234         //TODO: lockup excepto para direcciones concretas... pago de servicio, conversion fase 2
235         //TODO: Hacer funcion que añada direcciones de excepcion
236         //TODO: Para el team hacer las exceptions
237         require(walletsNotLocked[_to]);
238 
239         require(!locked);
240 
241         // If requested a transfer from the team wallet:
242         // TODO: fecha cada 6 meses 25% de desbloqueo
243         /*if (_from == teamWallet) {
244             require(now >= unlockTeamTokensTime);
245         }*/
246         // Advisors: 25% cada 3 meses
247 
248         // Reserva: 25% cada 6 meses
249 
250         // Partners: El bloqueo de todos... no pueden hacer nada
251 
252         _;
253     }
254 
255     /** Can be called once by super owner. */
256     function unlock() onlyOwner public {
257         require(locked);
258         locked = false;
259         emit Unlock();
260     }
261 
262     function walletLocked(address _wallet) onlyOwner public {
263       walletsNotLocked[_wallet] = false;
264     }
265 
266     function walletNotLocked(address _wallet) onlyOwner public {
267       walletsNotLocked[_wallet] = true;
268     }
269 
270     /**
271      * An address can become a new seller only in case it has no tokens.
272      * This is required to prevent stealing of tokens  from newSeller via
273      * 2 calls of this function.
274      */
275     function changeSeller(address newSeller) onlyOwner public returns (bool) {
276         require(newSeller != address(0));
277         require(seller != newSeller);
278 
279         // To prevent stealing of tokens from newSeller via 2 calls of changeSeller:
280         require(balances[newSeller] == 0);
281 
282         address oldSeller = seller;
283         uint256 unsoldTokens = balances[oldSeller];
284         balances[oldSeller] = 0;
285         balances[newSeller] = unsoldTokens;
286         emit Transfer(oldSeller, newSeller, unsoldTokens);
287 
288         seller = newSeller;
289         emit ChangeSellerEvent(oldSeller, newSeller);
290         return true;
291     }
292 
293     /**
294      * User-friendly alternative to sell() function.
295      */
296     function sellNoDecimals(address _to, uint256 _value) public returns (bool) {
297         return sell(_to, _value * 1e18);
298     }
299 
300     function sell(address _to, uint256 _value)  public returns (bool) {
301         // Check that we are not out of limit and still can sell tokens:
302         // Cambiar a hardcap en usd
303         //require(tokensSold.add(_value) <= saleLimit);
304         require(msg.sender == seller, "User not authorized");
305 
306         require(_to != address(0));
307         require(_value > 0);
308 
309         require(_value <= balances[seller]);
310 
311         balances[seller] = balances[seller].sub(_value);
312         balances[_to] = balances[_to].add(_value);
313 
314         emit Transfer(seller, _to, _value);
315 
316         totalSales++;
317         tokensSold = tokensSold.add(_value);
318         emit SellEvent(seller, _to, _value);
319         return true;
320     }
321 
322     /**
323      * Until all tokens are sold, tokens can be transfered to/from owner's accounts.
324      */
325     function transfer(address _to, uint256 _value) ifUnlocked(msg.sender, _to) public returns (bool) {
326         return super.transfer(_to, _value);
327     }
328 
329     /**
330      * Until all tokens are sold, tokens can be transfered to/from owner's accounts.
331      */
332     function transferFrom(address _from, address _to, uint256 _value) ifUnlocked(_from, _to) public returns (bool) {
333         return super.transferFrom(_from, _to, _value);
334     }
335 
336     function burn(uint256 _value) public returns (bool) {
337         require(_value > 0, 'Value is zero');
338 
339         balances[msg.sender] = balances[msg.sender].sub(_value);
340         totalSupply = totalSupply.sub(_value);
341         emit Transfer(msg.sender, 0x0, _value);
342         emit Burn(msg.sender, _value);
343         return true;
344     }
345 }
346 
347 
348 contract TMSYToken is CommonToken {
349     constructor(
350       address _seller,
351       address _teamWallet,
352       address _partnersWallet,
353       address _advisorsWallet,
354       address _reservaWallet) CommonToken(
355         _seller,
356         _teamWallet,
357         _partnersWallet,
358         _advisorsWallet,
359         _reservaWallet
360     ) public {}
361 }