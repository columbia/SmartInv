1 pragma solidity ^0.4.23;
2 
3 /**
4  * @title Ownable
5  * @dev The Ownable contract has an owner address, and provides basic authorization control
6  * functions, this simplifies the implementation of "user permissions".
7  */
8 contract Ownable {
9     address public owner;
10 
11     /**
12       * @dev The Ownable constructor sets the original `owner` of the contract to the sender
13       * account.
14       */
15     constructor() public {
16         owner = msg.sender;
17     }
18 
19     /**
20       * @dev Throws if called by any account other than the owner.
21       */
22     modifier onlyOwner() {
23         require(msg.sender == owner);
24         _;
25     }
26 
27     /**
28     * @dev Allows the current owner to transfer control of the contract to a newOwner.
29     * @param newOwner The address to transfer ownership to.
30     */
31     function transferOwnership(address newOwner) public onlyOwner {
32         if (newOwner != address(0)) {
33             owner = newOwner;
34         }
35     }
36 
37 }
38 
39 /**
40  * @title Pausable
41  * @dev Base contract which allows children to implement an emergency stop mechanism.
42  */
43 contract Pausable is Ownable {
44   event Pause();
45   event Unpause();
46 
47   bool public paused = false;
48 
49 
50   /**
51    * @dev Modifier to make a function callable only when the contract is not paused.
52    */
53   modifier whenNotPaused() {
54     require(!paused);
55     _;
56   }
57 
58   /**
59    * @dev Modifier to make a function callable only when the contract is paused.
60    */
61   modifier whenPaused() {
62     require(paused);
63     _;
64   }
65 
66   /**
67    * @dev called by the owner to pause, triggers stopped state
68    */
69   function pause() onlyOwner whenNotPaused public {
70     paused = true;
71     emit Pause();
72   }
73 
74   /**
75    * @dev called by the owner to unpause, returns to normal state
76    */
77   function unpause() onlyOwner whenPaused public {
78     paused = false;
79     emit Unpause();
80   }
81 }
82 
83 /**
84  * @title ERC20Basic
85  * @dev Simpler version of ERC20 interface
86  * @dev see https://github.com/ethereum/EIPs/issues/20
87  */
88 contract ERC20Basic {
89     uint public _totalSupply;
90     function totalSupply() public constant returns (uint);
91     function balanceOf(address who) public constant returns (uint);
92     function transfer(address to, uint value) public;
93     event Transfer(address indexed from, address indexed to, uint value);
94 }
95 
96 /**
97  * @title SafeMath
98  * @dev Math operations with safety checks that throw on error
99  */
100 library SafeMath {
101     function mul(uint256 a, uint256 b) internal pure returns (uint256) {
102         if (a == 0) {
103             return 0;
104         }
105         uint256 c = a * b;
106         assert(c / a == b);
107         return c;
108     }
109 
110     function div(uint256 a, uint256 b) internal pure returns (uint256) {
111         // assert(b > 0); // Solidity automatically throws when dividing by 0
112         uint256 c = a / b;
113         // assert(a == b * c + a % b); // There is no case in which this doesn't hold
114         return c;
115     }
116 
117     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
118         assert(b <= a);
119         return a - b;
120     }
121 
122     function add(uint256 a, uint256 b) internal pure returns (uint256) {
123         uint256 c = a + b;
124         assert(c >= a);
125         return c;
126     }
127 }
128 
129 /**
130  * @title Basic token
131  * @dev Basic version of StandardToken, with no allowances.
132  */
133 contract BasicToken is Ownable, ERC20Basic {
134     using SafeMath for uint;
135 
136     mapping(address => uint) public balances;
137 
138     // additional variables for use if transaction fees ever became necessary
139     uint public basisPointsRate = 0;
140     uint public maximumFee = 0;
141 
142     /**
143     * @dev Fix for the ERC20 short address attack.
144     */
145     modifier onlyPayloadSize(uint size) {
146         require(!(msg.data.length < size + 4));
147         _;
148     }
149 
150     /**
151     * @dev transfer token for a specified address
152     * @param _to The address to transfer to.
153     * @param _value The amount to be transferred.
154     */
155     function transfer(address _to, uint _value) public onlyPayloadSize(2 * 32) {
156         uint fee = (_value.mul(basisPointsRate)).div(10000);
157         if (fee > maximumFee) {
158             fee = maximumFee;
159         }
160         uint sendAmount = _value.sub(fee);
161         balances[msg.sender] = balances[msg.sender].sub(_value);
162         balances[_to] = balances[_to].add(sendAmount);
163         if (fee > 0) {
164             balances[owner] = balances[owner].add(fee);
165             emit Transfer(msg.sender, owner, fee);
166         }
167         emit Transfer(msg.sender, _to, sendAmount);
168     }
169 
170     /**
171     * @dev Gets the balance of the specified address.
172     * @param _owner The address to query the the balance of.
173     * @return An uint representing the amount owned by the passed address.
174     */
175     function balanceOf(address _owner) public constant returns (uint balance) {
176         return balances[_owner];
177     }
178 
179 }
180 
181 /**
182  * @title ERC20 interface
183  * @dev see https://github.com/ethereum/EIPs/issues/20
184  */
185 contract ERC20 is ERC20Basic {
186     function allowance(address owner, address spender) public constant returns (uint);
187     function transferFrom(address from, address to, uint value) public;
188     function approve(address spender, uint value) public;
189     event Approval(address indexed owner, address indexed spender, uint value);
190 }
191 
192 /**
193  * @title Standard ERC20 token
194  * @dev Implementation of the basic standard token.
195  * @dev https://github.com/ethereum/EIPs/issues/20
196  * @dev Based oncode by FirstBlood: https://github.com/Firstbloodio/token/blob/master/smart_contract/FirstBloodToken.sol
197  */
198 contract StandardToken is BasicToken, ERC20 {
199 
200     mapping (address => mapping (address => uint)) public allowed;
201 
202     uint public constant MAX_UINT = 2**256 - 1;
203 
204     /**
205     * @dev Transfer tokens from one address to another
206     * @param _from address The address which you want to send tokens from
207     * @param _to address The address which you want to transfer to
208     * @param _value uint the amount of tokens to be transferred
209     */
210     function transferFrom(address _from, address _to, uint _value) public onlyPayloadSize(3 * 32) {
211         var _allowance = allowed[_from][msg.sender];
212 
213         // Check is not needed because sub(_allowance, _value) will already throw if this condition is not met
214         // if (_value > _allowance) throw;
215 
216         uint fee = (_value.mul(basisPointsRate)).div(10000);
217         if (fee > maximumFee) {
218             fee = maximumFee;
219         }
220         if (_allowance < MAX_UINT) {
221             allowed[_from][msg.sender] = _allowance.sub(_value);
222         }
223         uint sendAmount = _value.sub(fee);
224         balances[_from] = balances[_from].sub(_value);
225         balances[_to] = balances[_to].add(sendAmount);
226         if (fee > 0) {
227             balances[owner] = balances[owner].add(fee);
228             emit Transfer(_from, owner, fee);
229         }
230         emit Transfer(_from, _to, sendAmount);
231     }
232 
233     /**
234     * @dev Approve the passed address to spend the specified amount of tokens on behalf of msg.sender.
235     * @param _spender The address which will spend the funds.
236     * @param _value The amount of tokens to be spent.
237     */
238     function approve(address _spender, uint _value) public onlyPayloadSize(2 * 32) {
239 
240         // To change the approve amount you first have to reduce the addresses`
241         //  allowance to zero by calling `approve(_spender, 0)` if it is not
242         //  already 0 to mitigate the race condition described here:
243         //  https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
244         require(!((_value != 0) && (allowed[msg.sender][_spender] != 0)));
245 
246         allowed[msg.sender][_spender] = _value;
247         emit Approval(msg.sender, _spender, _value);
248     }
249 
250     /**
251     * @dev Function to check the amount of tokens than an owner allowed to a spender.
252     * @param _owner address The address which owns the funds.
253     * @param _spender address The address which will spend the funds.
254     * @return A uint specifying the amount of tokens still available for the spender.
255     */
256     function allowance(address _owner, address _spender) public constant returns (uint remaining) {
257         return allowed[_owner][_spender];
258     }
259 }
260 
261 contract UpgradedStandardToken is StandardToken{
262     // those methods are called by the legacy contract
263     // and they must ensure msg.sender to be the contract address
264     function transferByLegacy(address from, address to, uint value) public;
265     function transferFromByLegacy(address sender, address from, address spender, uint value) public;
266     function approveByLegacy(address from, address spender, uint value) public;
267 }
268 
269 contract BlackList is Ownable, BasicToken {
270 
271     function getBlackListStatus(address _maker) external constant returns (bool) {
272         return isBlackListed[_maker];
273     }
274 
275     function getOwner() external constant returns (address) {
276         return owner;
277     }
278 
279     mapping (address => bool) public isBlackListed;
280     
281     function addBlackList (address _evilUser) public onlyOwner {
282         isBlackListed[_evilUser] = true;
283         emit AddedBlackList(_evilUser);
284     }
285 
286     function removeBlackList (address _clearedUser) public onlyOwner {
287         isBlackListed[_clearedUser] = false;
288         emit RemovedBlackList(_clearedUser);
289     }
290 
291     function destroyBlackFunds (address _blackListedUser) public onlyOwner {
292         require(isBlackListed[_blackListedUser]);
293         uint dirtyFunds = balanceOf(_blackListedUser);
294         balances[_blackListedUser] = 0;
295         //Posible Error
296         _totalSupply -= dirtyFunds;
297         emit DestroyedBlackFunds(_blackListedUser, dirtyFunds);
298     }
299 
300     event DestroyedBlackFunds(address _blackListedUser, uint _balance);
301 
302     event AddedBlackList(address _user);
303 
304     event RemovedBlackList(address _user);
305 
306 }
307 
308 contract MexaCoin is Pausable, StandardToken, BlackList {
309     
310     string public name;
311     string public symbol;
312     uint public decimals;
313     address public upgradedAddress;
314     bool public deprecated;
315 
316     // Inicializa el contrato con el suministro inicial de monedas al creador
317     //
318     // @param _initialSupply    Suministro inicial de monedas
319     // @param _name             Establece el nombre de la moneda
320     // @param _symbol           Establece el simbolo de la moneda
321     // @param _decimals         Establece el numero de decimales
322 
323     constructor (uint _initialSupply, string _name, string _symbol, uint _decimals) public {
324         _totalSupply = _initialSupply;
325         name = _name;
326         symbol = _symbol;
327         decimals = _decimals;
328         balances[owner] = _initialSupply;
329         deprecated = false;
330     }
331 
332     // Transferencias entre direcciones
333     // Requiere que ni el emisor ni el receptor esten en la lista negra
334     // Suspende actividades cuando el contrato se encuentra en pausa
335     // Utiliza ERC20.sol para actualizar el contrato si el actual llega a ser obsoleto
336     //
337     // @param _to               Direccion a la que se envian las monedas
338     // @param _value            Cantidad de monedas a enviar
339     function transfer(address _to, uint _value) public whenNotPaused {
340         require(!isBlackListed[msg.sender]);
341         require(!isBlackListed[_to]);
342         if (deprecated) {
343             return UpgradedStandardToken(upgradedAddress).transferByLegacy(msg.sender, _to, _value);
344         } else {
345             return super.transfer(_to, _value);
346         }
347     }
348 
349     // Refleja el balance de una direccion
350     // Utiliza ERC20.sol para actualizar el contrato si el actual llega a ser obsoleto
351     //
352     // @param who               Direccion a consultar
353     function balanceOf(address who) public constant returns (uint) {
354         if (deprecated) {
355             return UpgradedStandardToken(upgradedAddress).balanceOf(who);
356         } else {
357             return super.balanceOf(who);
358         }
359     }
360     
361     // Transferencias desde direcciones a nombre de terceros (concesiones)
362     // Require que ni el emisor ni el receptor esten en la lista negra
363     // Suspende actividades cuando el contrato se encuentra en pausa
364     // Utiliza ERC20.sol para actualizar el contrato si el actual llega a ser obsoleto
365     //
366     // @param _from             Direccion de la que se envian las monedas
367     // @param _to               Direccion a la que se envian las monedas
368     // @param _value            Cantidad de monedas a enviar
369     function transferFrom(address _from, address _to, uint _value) public whenNotPaused {
370         require(!isBlackListed[_from]);
371         require(!isBlackListed[_to]);
372         if (deprecated) {
373             return UpgradedStandardToken(upgradedAddress).transferFromByLegacy(msg.sender, _from, _to, _value);
374         } else {
375             return super.transferFrom(_from, _to, _value);
376         }
377     }
378 
379     // Permite genera concesiones a direcciones de terceros especificando la direccion y la cantidad de monedas a conceder
380     // Require que ni el emisor ni el receptor esten en la lista negra
381     // Suspende actividades cuando el contrato se encuentra en pausa
382     // Utiliza ERC20.sol para actualizar el contrato si el actual llega a ser obsoleto
383     //
384     // @param _spender          Direccion a la que se le conceden las monedas
385     // @param _value            Cantidad de monedas a conceder
386     function approve(address _spender, uint _value) public onlyPayloadSize(2 * 32) whenNotPaused {
387         require(!isBlackListed[msg.sender]);
388         require(!isBlackListed[_spender]);
389         if (deprecated) {
390             return UpgradedStandardToken(upgradedAddress).approveByLegacy(msg.sender, _spender, _value);
391         } else {
392             return super.approve(_spender, _value);
393         }
394     }
395 
396     // Refleja cantidad de moendas restantes en concesion
397     // Utiliza ERC20.sol para actualizar el contrato si el actual llega a ser obsoleto
398     //
399     // @param _owner            Direccion de quien concede las monedas
400     // @param _spender          Direccion que posee la concesion
401     function allowance(address _owner, address _spender) public constant returns (uint remaining) {
402         if (deprecated) {
403             return StandardToken(upgradedAddress).allowance(_owner, _spender);
404         } else {
405             return super.allowance(_owner, _spender);
406         }
407     }
408 
409     // Suspende el actual contrato a favor de uno nuevo
410     //
411     // @param _upgradedAddress  Direccion del nuevo contrato
412     function deprecate(address _upgradedAddress) public onlyOwner {
413         deprecated = true;
414         upgradedAddress = _upgradedAddress;
415         emit Deprecate(_upgradedAddress);
416     }
417 
418     // Refleja la cantidad total de monedas generada por el contrato
419     //
420     function totalSupply() public constant returns (uint) {
421         if (deprecated) {
422             return StandardToken(upgradedAddress).totalSupply();
423         } else {
424             return _totalSupply;
425         }
426     }
427 
428     // Genera nuevas monedas y las deposita en la direccion del creador
429     //
430     // @param _amount           Numero de monedas a generar
431     function issue(uint amount) public onlyOwner {
432         require(_totalSupply + amount > _totalSupply);
433         require(balances[owner] + amount > balances[owner]);
434 
435         balances[owner] += amount;
436         _totalSupply += amount;
437         emit Issue(amount);
438     }
439 
440     // Retiro de monedas
441     // Las moendas son retiradas de la cuenta del creador
442     // El balance en la cuenta debe ser suficiente para completar la transaccion de lo contrario se generara un error
443     // @param _amount           Nuemro de monedas a retirar
444     function redeem(uint amount) public onlyOwner {
445         require(_totalSupply >= amount);
446         require(balances[owner] >= amount);
447 
448         _totalSupply -= amount;
449         balances[owner] -= amount;
450         emit Redeem(amount);
451     }
452     
453     // Establece el valor de las cuotas en caso de existir
454     //
455     // @param newBasisPoints    Cuota base
456     // @param newMaxFee         Cuota maxima
457     function setParams(uint newBasisPoints, uint newMaxFee) public onlyOwner {
458         // Asegura el valor maximo que no podran sobrepasar las cuotas
459         require(newBasisPoints < 50);
460         require(newMaxFee < 1000);
461 
462         basisPointsRate = newBasisPoints;
463         maximumFee = newMaxFee.mul(10**decimals);
464 
465         emit Params(basisPointsRate, maximumFee);
466     }
467     
468     // Genera un evento publico en el Blockchain que notificara a los clientes cuando nuevas moendas sean generadas
469     event Issue(uint amount);
470 
471     // Genera un evento publico en el Blockchain que notificara a los clientes cuando nuevas moendas sean generadas
472     event Redeem(uint amount);
473 
474     // Genera un evento publico en el Blockchain que notificara a los clientes cuando nuevas moendas sean generadas
475     event Deprecate(address newAddress);
476 
477     // Genera un evento publico en el Blockchain que notificara a los clientes cuando nuevas moendas sean generadas
478     event Params(uint feeBasisPoints, uint maxFee);
479 }