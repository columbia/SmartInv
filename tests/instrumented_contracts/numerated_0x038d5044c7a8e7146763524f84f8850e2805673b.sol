1 pragma solidity ^0.4.24;
2 
3 
4 /**
5  * @title Ownable
6  * @dev El contrato de propiedad tiene una dirección de propietario y proporciona un control de autorización básico
7  * funciones, esto simplifica la implementación de "permisos de usuario".
8  */
9 contract Ownable {
10     address public owner;
11 
12     event OwnershipRenounced(address indexed previousOwner);
13     event OwnershipTransferred(
14         address indexed previousOwner,
15         address indexed newOwner
16     );
17 
18 /**
19     * @dev El constructor Ownable establece el "propietario" original del contrato al remitente
20     * cuenta.
21     */
22     constructor() public {
23         owner = msg.sender;
24     }
25 
26     /**
27     * @dev Lanza si es llamado por cualquier cuenta que no sea el propietario.
28     */
29     modifier onlyOwner() {
30         require(msg.sender == owner);
31         _;
32     }
33 /**
34     * @dev Permite al propietario actual transferir el control del contrato a un nuevo propietario.
35     * @param newOwner La dirección a la que se transfiere la propiedad.
36     */
37     function transferOwnership(address newOwner) public onlyOwner {
38         require(newOwner != address(0));
39         emit OwnershipTransferred(owner, newOwner);
40         owner = newOwner;
41     }
42 
43     /**
44     * @dev Permite al propietario actual ceder el control del contrato.
45     */
46     function renounceOwnership() public onlyOwner {
47         emit OwnershipRenounced(owner);
48         owner = address(0);
49     }
50 }
51 
52 /**
53  * @title SafeMath
54  * @dev Operaciones matemáticas con controles de seguridad que arrojan por error.
55  */
56 library SafeMath {
57 
58     /**
59     * @dev Multiplica dos números, lanza en desbordamiento.
60     */
61     function mul(uint256 a, uint256 b) internal pure returns (uint256 c) {
62         if (a == 0) {
63             return 0;
64         }
65         c = a * b;
66         assert(c / a == b);
67         return c;
68     }
69 
70     /**
71     * @dev División entera de dos números, truncando el cociente.
72     */
73     function div(uint256 a, uint256 b) internal pure returns (uint256) {
74         return a / b;
75     }
76 
77     /**
78     * @dev Resta dos números, arroja en desbordamiento (es decir, si el sustraendo es mayor que el minuendo).
79     */
80     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
81         assert(b <= a);
82         return a - b;
83     }
84 
85     /**
86     * @dev Agrega dos números, arroja sobre desbordamiento.
87     */
88     function add(uint256 a, uint256 b) internal pure returns (uint256 c) {
89         c = a + b;
90         assert(c >= a);
91         return c;
92     }
93 }
94 
95 /**
96  * @title ERC20Basic
97  * @dev Versión más sencilla de la interfaz ERC20
98  * @dev see https://github.com/ethereum/EIPs/issues/179
99  */
100 contract ERC20Basic {
101     function totalSupply() public view returns (uint256);
102     function balanceOf(address who) public view returns (uint256);
103     function transfer(address to, uint256 value) public returns (bool);
104     event Transfer(address indexed from, address indexed to, uint256 value);
105 }
106 
107 /**
108  * @title ERC20 interface
109  * @dev see https://github.com/ethereum/EIPs/issues/20
110  */
111 contract ERC20 is ERC20Basic {
112     function allowance(address owner, address spender) public view returns (uint256);
113     function transferFrom(address from, address to, uint256 value) public returns (bool);
114     function approve(address spender, uint256 value) public returns (bool);
115     event Approval(address indexed owner, address indexed spender, uint256 value);
116 }
117 
118 contract BasicToken is ERC20Basic {
119     using SafeMath for uint256;
120 
121     mapping(address => uint256) balances;
122 
123     uint256 totalSupply_;
124 
125     /**
126     * @dev total number of tokens in existence
127     */
128     function totalSupply() public view returns (uint256) {
129         return totalSupply_;
130     }
131 
132     /**
133     * @dev transfer token for a specified address
134     * @param _to The address to transfer to.
135     * @param _value The amount to be transferred.
136     */
137     function transfer(address _to, uint256 _value) public returns (bool) {
138         require(_to != address(0));
139         require(_value <= balances[msg.sender]);
140 
141         balances[msg.sender] = balances[msg.sender].sub(_value);
142         balances[_to] = balances[_to].add(_value);
143         emit Transfer(msg.sender, _to, _value);
144         return true;
145     }
146 
147     /**
148     * @dev Gets the balance of the specified address.
149     * @param _owner The address to query the the balance of.
150     * @return An uint256 representing the amount owned by the passed address.
151     */
152     function balanceOf(address _owner) public view returns (uint256) {
153         return balances[_owner];
154     }
155 
156 }
157 /**
158  * @title Standard ERC20 token
159  *
160  * @dev Implementación del token estándar básico.
161  * @dev https://github.com/ethereum/EIPs/issues/20
162  * @dev Based on code by FirstBlood: https://github.com/Firstbloodio/token/blob/master/smart_contract/FirstBloodToken.sol
163  */
164 contract StandardToken is ERC20, BasicToken {
165 
166     mapping (address => mapping (address => uint256)) internal allowed;
167 // This notifies clients about the amount burnt
168     event Burn(address indexed from, uint256 value);
169 
170   /**
171    * @dev Transfer tokens from one address to another
172    * @param _from address The address which you want to send tokens from
173    * @param _to address The address which you want to transfer to
174    * @param _value uint256 the amount of tokens to be transferred
175    */
176     function transferFrom(address _from, address _to, uint256 _value) public returns (bool) {
177         require(_to != address(0));
178         require(_value <= balances[_from]);
179         require(_value <= allowed[_from][msg.sender]);
180 
181         balances[_from] = balances[_from].sub(_value);
182         balances[_to] = balances[_to].add(_value);
183         allowed[_from][msg.sender] = allowed[_from][msg.sender].sub(_value);
184         emit Transfer(_from, _to, _value);
185         return true;
186     }
187 
188     /**
189     * @dev Approve the passed address to spend the specified amount of tokens on behalf of msg.sender.
190     *
191     * Beware that changing an allowance with this method brings the risk that someone may use both the old
192     * and the new allowance by unfortunate transaction ordering. One possible solution to mitigate this
193     * race condition is to first reduce the spender's allowance to 0 and set the desired value afterwards:
194     * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
195     * @param _spender The address which will spend the funds.
196     * @param _value The amount of tokens to be spent.
197     */
198     function approve(address _spender, uint256 _value) public returns (bool) {
199         allowed[msg.sender][_spender] = _value;
200         emit Approval(msg.sender, _spender, _value);
201         return true;
202     }
203 
204     /**
205     * @dev Function to check the amount of tokens that an owner allowed to a spender.
206     * @param _owner address The address which owns the funds.
207     * @param _spender address The address which will spend the funds.
208     * @return A uint256 specifying the amount of tokens still available for the spender.
209     */
210     function allowance(address _owner, address _spender) public view returns (uint256) {
211         return allowed[_owner][_spender];
212     }
213 
214     /**
215     * @dev Increase the amount of tokens that an owner allowed to a spender.
216     *
217     * approve should be called when allowed[_spender] == 0. To increment
218     * allowed value is better to use this function to avoid 2 calls (and wait until
219     * the first transaction is mined)
220     * From MonolithDAO Token.sol
221     * @param _spender The address which will spend the funds.
222     * @param _addedValue The amount of tokens to increase the allowance by.
223     */
224     function increaseApproval(address _spender, uint _addedValue) public returns (bool) {
225         allowed[msg.sender][_spender] = allowed[msg.sender][_spender].add(_addedValue);
226         emit Approval(msg.sender, _spender, allowed[msg.sender][_spender]);
227         return true;
228     }
229 
230     /**
231     * @dev Decrease the amount of tokens that an owner allowed to a spender.
232     *
233     * approve should be called when allowed[_spender] == 0. To decrement
234     * allowed value is better to use this function to avoid 2 calls (and wait until
235     * the first transaction is mined)
236     * From MonolithDAO Token.sol
237     * @param _spender The address which will spend the funds.
238     * @param _subtractedValue The amount of tokens to decrease the allowance by.
239     */
240     function decreaseApproval(address _spender, uint _subtractedValue) public returns (bool) {
241         uint oldValue = allowed[msg.sender][_spender];
242         if (_subtractedValue > oldValue) {
243             allowed[msg.sender][_spender] = 0;
244         } else {
245             allowed[msg.sender][_spender] = oldValue.sub(_subtractedValue);
246         }
247         emit Approval(msg.sender, _spender, allowed[msg.sender][_spender]);
248         return true;
249     }
250      /**
251      * Destroy tokens
252      *
253      * Remove `_value` tokens from the system irreversibly
254      *
255      * @param _value the amount of money to burn
256      */
257     function burn(uint256 _value) public returns (bool success) {
258         require(balances[msg.sender] >= _value);   // Check if the sender has enough
259         balances[msg.sender] -= _value;            // Subtract from the sender
260         totalSupply_ -= _value;                      // Updates totalSupply
261         emit Burn(msg.sender, _value);
262         return true;
263     }
264 
265     /**
266      * Destroy tokens from other account
267      *
268      * Remove `_value` tokens from the system irreversibly on behalf of `_from`.
269      *
270      * @param _from the address of the sender
271      * @param _value the amount of money to burn
272      */
273     function burnFrom(address _from, uint256 _value) public returns (bool success) {
274         require(balances[_from] >= _value);                // Check if the targeted balance is enough
275         require(_value <= allowed[_from][msg.sender]);    // Check allowance
276         balances[_from] -= _value;                         // Subtract from the targeted balance
277         allowed[_from][msg.sender] -= _value;             // Subtract from the sender's allowance
278         totalSupply_ -= _value;                              // Update totalSupply
279         emit Burn(_from, _value);
280         return true;
281     }
282 }
283 
284 contract MintableToken is StandardToken, Ownable {
285     event Mint(address indexed to, uint256 amount);
286     event MintFinished();
287 
288     bool public mintingFinished = false;
289 
290 
291     modifier canMint() {
292         require(!mintingFinished);
293         _;
294     }
295 
296     /**
297     * @dev Funciónpara acuñar fichas
298     * @param _to La dirección que recibirá las fichas acuñadas.
299     * @param _amount La cantidad de fichas para acuñar.
300     * @return Un valor booleano que indica si la operación se realizó correctamente.
301     */
302     function mint(address _to, uint256 _amount) onlyOwner canMint public returns (bool) {
303         totalSupply_ = totalSupply_.add(_amount);
304         balances[_to] = balances[_to].add(_amount);
305         emit Mint(_to, _amount);
306         emit Transfer(address(0), _to, _amount);
307         return true;
308     }
309 
310     /**
311     * @dev Función para dejar de acuñar nuevas fichas.
312     * @return Es cierto si la operación fue exitosa.
313     */
314     function finishMinting() onlyOwner canMint public returns (bool) {
315         mintingFinished = true;
316         emit MintFinished();
317         return true;
318     }
319 }
320 
321 contract Pausable is Ownable {
322     event Pause();
323     event Unpause();
324 
325     bool public paused = false;
326 
327 
328     /**
329     * @dev Modifier to make a function callable only when the contract is not paused.
330     */
331     modifier whenNotPaused() {
332         require(!paused);
333         _;
334     }
335 
336     /**
337     * @dev Modifier to make a function callable only when the contract is paused.
338     */
339     modifier whenPaused() {
340         require(paused);
341         _;
342     }
343 
344     /**
345     * @dev called by the owner to pause, triggers stopped state
346     */
347     function pause() onlyOwner whenNotPaused public {
348         paused = true;
349         emit Pause();
350     }
351 
352     /**
353     * @dev called by the owner to unpause, returns to normal state
354     */
355     function unpause() onlyOwner whenPaused public {
356         paused = false;
357         emit Unpause();
358     }
359 }
360 
361 contract PausableToken is StandardToken, Pausable {
362 
363     function transfer(address _to, uint256 _value) public whenNotPaused returns (bool) {
364         return super.transfer(_to, _value);
365     }
366 
367     function transferFrom(address _from, address _to, uint256 _value) public whenNotPaused returns (bool) {
368         return super.transferFrom(_from, _to, _value);
369     }
370 
371     function approve(address _spender, uint256 _value) public whenNotPaused returns (bool) {
372         return super.approve(_spender, _value);
373     }
374 
375     function increaseApproval(address _spender, uint _addedValue) public whenNotPaused returns (bool success) {
376         return super.increaseApproval(_spender, _addedValue);
377     }
378 
379     function decreaseApproval(address _spender, uint _subtractedValue) public whenNotPaused returns (bool success) {
380         return super.decreaseApproval(_spender, _subtractedValue);
381     }
382 }
383 
384 contract Coinbase is Ownable {
385     using SafeMath for uint256;
386     uint256 public blockHeight;
387     uint256 public decimals; 
388     uint256 public coinbaseInit;
389 
390     // Generar nuevo bloque cada 6 horas. Reducir a la mitad la base de monedas cada 120 días.
391     uint256 public halvingPeriod = 4 * 120;
392 
393     uint256 public maxSupply;
394     uint256[6] private coinbaseArray;
395     uint256 public exodus;
396 
397     event LogBlockHeight(uint256 blockHeight);
398 
399     constructor(uint256 _decimals) public{
400         decimals = _decimals;
401         maxSupply = 710000000 * (10 ** uint256(decimals));
402         // 10% of maxSupply acuñar antes de bloque de genesis
403         exodus = maxSupply / 10;
404 
405         // 90% de maxSupply para los próximos 2 años.
406         coinbaseInit = 196875 * (10 ** uint256(decimals));
407         coinbaseArray = [
408             coinbaseInit,
409             coinbaseInit / 2,
410             coinbaseInit / 4,
411             coinbaseInit / 8,
412             coinbaseInit / 16,
413             coinbaseInit / 16
414         ];
415        
416     }
417     
418     /**
419     * @dev Función para aumentar la altura del bloque.
420     * @return 
421     */
422     function nextBlock() onlyOwner public {
423         blockHeight = blockHeight.add(1);
424         emit LogBlockHeight(blockHeight);
425     }
426 
427     /**
428     * @dev Función para calcular la cantidad de coinbase del bloque en este momento.
429     * @return Un booleano que indica si la operación se realizó correctamente.
430     */
431     function coinbaseAmount() view internal returns (uint){
432         uint256 index = blockHeight.sub(1).div(halvingPeriod);
433         if (index > 5 || index < 0) {
434             return 0;
435         }
436         return coinbaseArray[index];
437     }
438 
439 }
440 
441 contract SlonpayToken is MintableToken, PausableToken, Coinbase {
442     string public constant name = "Slonpay Token"; 
443     string public constant symbol = "SLPT"; 
444     uint256 public constant decimals = 18; 
445 
446 
447     constructor() Coinbase(decimals) public{
448         mint(owner, exodus);
449     }
450 
451     /**
452     * @dev Función para coinbase en nuevo bloque 
453     * @return Un booleano que indica si la operación se realizó correctamente.
454     */
455     function coinbase() onlyOwner canMint whenNotPaused public returns (bool) {
456         nextBlock();
457         uint256 _amount =  coinbaseAmount();
458         if (_amount == 0) {
459             finishMinting();
460             return false;
461         }
462         return super.mint(owner, _amount);
463     }
464 
465     /**
466     * @dev Función para dejar de acuñar nuevas fichas.
467     * @return Es cierto si la operación fue exitosa.
468     */
469     function finishMinting() onlyOwner canMint whenNotPaused public returns (bool) {
470         return super.finishMinting();
471     }
472 
473     /**
474     * @dev Permite al propietario actual transferir el control del contrato a un nuevo propietario.
475     * @param newOwner La dirección para transferir la propiedad a.
476     */
477     function transferOwnership(address newOwner) onlyOwner whenNotPaused public {
478         super.transferOwnership(newOwner);
479     }
480 
481     /**
482     * The fallback function.
483     */
484     function() payable public {
485         revert();
486     }
487 }