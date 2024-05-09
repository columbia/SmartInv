1 pragma solidity ^0.4.18;
2 
3 
4 /**
5  * Math operations with safety checks
6  */
7 
8 library SafeMath {
9 
10 
11     function mul(uint a, uint b) internal pure returns (uint) {
12         uint c = a * b;
13         assert(a == 0 || c / a == b);
14         return c;
15     }
16 
17     function sub(uint a, uint b) internal pure returns (uint) {
18         assert(b <= a);
19         return a - b;
20     }
21 
22     function add(uint a, uint b) internal pure returns (uint) {
23         uint c = a + b;
24         assert(c>=a && c>=b);
25         return c;
26     }
27 }
28 
29 
30 /* 
31  * Token related contracts 
32  */
33 
34 
35 /*
36  * ERC20Basic
37  * Simpler version of ERC20 interface
38  * see https://github.com/ethereum/EIPs/issues/20
39  */
40 
41 contract ERC20Basic {
42     uint public totalSupply;
43     function balanceOf(address who) public view returns (uint);
44     function transfer(address to, uint256 value) public returns (bool);
45     event Transfer(address indexed from, address indexed to, uint value);
46 }
47 
48 
49 /**
50  * @title ERC20 interface
51  * @dev see https://github.com/ethereum/EIPs/issues/20
52  */
53 
54 contract ERC20 is ERC20Basic {
55     function allowance(address owner, address spender) public view returns (uint256);
56     function transferFrom(address from, address to, uint256 value) public returns (bool);
57     function approve(address spender, uint256 value) public returns (bool);
58     event Approval(address indexed owner, address indexed spender, uint256 value);
59 }
60 
61 
62 /**
63  * @title Basic token
64  * @dev Basic version of StandardToken, with no allowances.
65  */
66 
67 contract BasicToken is ERC20Basic {
68     using SafeMath for uint256;
69 
70     mapping(address => uint256) balances;
71 
72     /**
73      * @dev transfer token for a specified address
74      * @param _to The address to transfer to.
75      * @param _value The amount to be transferred.
76      */
77     function transfer(address _to, uint256 _value) public returns (bool) {
78         require(_to != address(0));
79         require(_value <= balances[msg.sender]);
80 
81         // SafeMath.sub will throw if there is not enough balance.
82         balances[msg.sender] = balances[msg.sender].sub(_value);
83         balances[_to] = balances[_to].add(_value);
84         Transfer(msg.sender, _to, _value);
85         return true;
86     }
87 
88     /**
89      * @dev Gets the balance of the specified address.
90      * @param _owner The address to query the the balance of.
91      * @return An uint representing the amount owned by the passed address.
92      */
93     function balanceOf(address _owner) public view returns (uint) {
94         return balances[_owner];
95     }
96 
97 }
98 
99 
100 /**
101  * @title Standard ERC20 token
102  *
103  * @dev Implementation of the basic standard token.
104  * @dev https://github.com/ethereum/EIPs/issues/20
105  * @dev Based on code by FirstBlood: https://github.com/Firstbloodio/token/blob/master/smart_contract/FirstBloodToken.sol
106  */
107 
108 contract StandardToken is ERC20, BasicToken {
109 
110     mapping (address => mapping (address => uint256)) internal allowed;
111 
112 
113     /**
114      * @dev Transfer tokens from one address to another
115      * @param _from address The address which you want to send tokens from
116      * @param _to address The address which you want to transfer to
117      * @param _value uint256 the amount of tokens to be transferred
118      */
119     function transferFrom(address _from, address _to, uint256 _value) public returns (bool) {
120         require(_to != address(0));
121         require(_value <= balances[_from]);
122         require(_value <= allowed[_from][msg.sender]);
123 
124         balances[_from] = balances[_from].sub(_value);
125         balances[_to] = balances[_to].add(_value);
126         allowed[_from][msg.sender] = allowed[_from][msg.sender].sub(_value);
127         Transfer(_from, _to, _value);
128         return true;
129     }
130 
131     /**
132      * @dev Approve the passed address to spend the specified amount of tokens on behalf of msg.sender.
133      *
134      * Beware that changing an allowance with this method brings the risk that someone may use both the old
135      * and the new allowance by unfortunate transaction ordering. One possible solution to mitigate this
136      * race condition is to first reduce the spender's allowance to 0 and set the desired value afterwards:
137      * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
138      * @param _spender The address which will spend the funds.
139      * @param _value The amount of tokens to be spent.
140      */
141     function approve(address _spender, uint256 _value) public returns (bool) {
142         allowed[msg.sender][_spender] = _value;
143         Approval(msg.sender, _spender, _value);
144         return true;
145     }
146 
147     /**
148      * @dev Function to check the amount of tokens that an owner allowed to a spender.
149      * @param _owner address The address which owns the funds.
150      * @param _spender address The address which will spend the funds.
151      * @return A uint256 specifying the amount of tokens still available for the spender.
152      */
153     function allowance(address _owner, address _spender) public view returns (uint256) {
154         return allowed[_owner][_spender];
155     }
156 
157 }
158 
159 
160 /*
161  * Ownable
162  *
163  * Base contract with an owner.
164  * Provides onlyOwner modifier, which prevents function from running if it is called by anyone other than the owner.
165  */
166 
167 contract Ownable {
168     address public owner;
169     address public newOwner;
170 
171     function Ownable() public {
172         owner = msg.sender;
173     }
174 
175     modifier onlyOwner() { 
176         require(msg.sender == owner);
177         _;
178     }
179 
180     modifier onlyNewOwner() {
181         require(msg.sender == newOwner);
182         _;
183     }
184     /*
185     // This code is dangerous because an error in the newOwner 
186     // means that this contract will be ownerless 
187     function transfer(address newOwner) public onlyOwner {
188         require(newOwner != address(0)); 
189         owner = newOwner;
190     }
191    */
192 
193     function proposeNewOwner(address _newOwner) external onlyOwner {
194         require(_newOwner != address(0));
195         newOwner = _newOwner;
196     }
197 
198     function acceptOwnership() external onlyNewOwner {
199         require(newOwner != owner);
200         owner = newOwner;
201     }
202 }
203 
204 
205 /**
206  * @title Mintable token
207  * @dev Simple ERC20 Token example, with mintable token creation
208  * @dev Issue: * https://github.com/OpenZeppelin/zeppelin-solidity/issues/120
209  * Based on code by TokenMarketNet: https://github.com/TokenMarketNet/ico/blob/master/contracts/MintableToken.sol
210  */
211 
212 contract MintableToken is StandardToken, Ownable {
213     event Mint(address indexed to, uint256 amount);
214     event MintFinished();
215 
216     bool public mintingFinished = false;
217 
218 
219     modifier canMint() {
220         require(!mintingFinished);
221         _;
222     }
223 
224     /**
225      * @dev Function to mint tokens
226      * @param _to The address that will receive the minted tokens.
227      * @param _amount The amount of tokens to mint.
228      * @return A boolean that indicates if the operation was successful.
229      */
230     function mint(address _to, uint256 _amount) public onlyOwner canMint returns (bool) {
231         totalSupply = totalSupply.add(_amount);
232         balances[_to] = balances[_to].add(_amount);
233         Mint(_to, _amount);
234         Transfer(address(0), _to, _amount);
235         return true;
236     }
237 
238     /**
239      * @dev Function to stop minting new tokens.
240      * @return True if the operation was successful.
241      */
242     function finishMinting() public onlyOwner canMint returns (bool) {
243         mintingFinished = true;
244         MintFinished();
245         return true;
246     }
247 }
248 
249 
250 /**
251  * @title Burnable Token
252  * @dev Token that can be irreversibly burned (destroyed).
253  */
254 contract BurnableToken is BasicToken {
255 
256     event Burn(address indexed burner, uint256 value);
257 
258     /**
259      * @dev Burns a specific amount of tokens.
260      * @param _value The amount of token to be burned.
261      */
262     function burn(uint256 _value) public  {
263         require(_value <= balances[msg.sender]);
264         // no need to require value <= totalSupply, since that would imply the
265         // sender's balance is greater than the totalSupply, which *should* be an assertion failure
266 
267         address burner = msg.sender;
268         balances[burner] = balances[burner].sub(_value);
269         totalSupply = totalSupply.sub(_value);
270         Burn(burner, _value);
271     }
272 }
273 
274 
275 /**
276  * @title Pausable
277  * @dev Base contract which allows children to implement an emergency stop mechanism.
278  */
279 
280 contract Pausable is Ownable {
281 
282 
283     event Pause();
284     event Unpause();
285 
286     bool public paused = true;
287 
288 
289     /**
290      * @dev Modifier to make a function callable only when the contract is not paused.
291      */
292     modifier whenNotPaused() {
293         require(!paused);
294         _;
295     }
296 
297     /**
298      * @dev Modifier to make a function callable only when the contract is paused.
299      */
300     modifier whenPaused() {
301         require(paused);
302         _;
303     }
304 
305     /**
306      * @dev called by the owner to pause, triggers stopped state
307      */
308     function pause() onlyOwner whenNotPaused public {
309         paused = true;
310         Pause();
311     }
312 
313     /**
314      * @dev called by the owner to unpause, returns to normal state
315      */
316     function unpause() onlyOwner whenPaused public {
317         paused = false;
318         Unpause();
319     }
320 }
321 
322 
323 
324 /* @title Pausable token
325  *
326  * @dev StandardToken modified with pausable transfers.
327  **/
328 
329 contract PausableToken is StandardToken, Pausable {
330 
331     function transfer(address _to, uint256 _value) public whenNotPaused returns (bool) {
332         return super.transfer(_to, _value);
333     }
334 
335     function transferFrom(address _from, address _to, uint256 _value) public whenNotPaused returns (bool) {
336         return super.transferFrom(_from, _to, _value);
337     }
338 
339     function approve(address _spender, uint256 _value) public whenNotPaused returns (bool) {
340         return super.approve(_spender, _value);
341     }
342 
343 }
344 
345 
346 /*
347  * Actual token contract
348  */
349 
350 contract AcjToken is BurnableToken, MintableToken, PausableToken {
351     using SafeMath for uint256;
352 
353     string public constant name = "Artist Connect Coin";
354     string public constant symbol = "ACJ";
355     uint public constant decimals = 18;
356     
357     function AcjToken() public {
358         totalSupply = 150000000 ether; 
359         balances[msg.sender] = totalSupply;
360         paused = true;
361     }
362 
363     function activate() external onlyOwner {
364         unpause();
365         finishMinting();
366     }
367 
368     // This method will be used by the crowdsale smart contract 
369     // that owns the AcjToken and will distribute 
370     // the tokens to the contributors
371     function initialTransfer(address _to, uint _value) external onlyOwner returns (bool) {
372         require(_to != address(0));
373         require(_value <= balances[msg.sender]);
374 
375         balances[msg.sender] = balances[msg.sender].sub(_value);
376         balances[_to] = balances[_to].add(_value);
377         Transfer(msg.sender, _to, _value);
378         return true;
379     }
380 
381     function burn(uint256 _amount) public onlyOwner {
382         super.burn(_amount);
383     }
384 
385 }