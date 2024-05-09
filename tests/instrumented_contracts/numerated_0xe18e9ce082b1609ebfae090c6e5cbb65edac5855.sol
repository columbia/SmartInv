1 pragma solidity ^0.4.13;
2 // Abstract contract for the full ERC 20 Token standard
3 // https://github.com/ethereum/EIPs/issues/20
4 
5 contract ERC20 {
6     /// total amount of tokens
7     uint256 public totalSupply;
8 
9     /// @param _owner The address from which the balance will be retrieved
10     /// @return The balance
11     function balanceOf(address _owner) constant returns (uint256 balance);
12 
13     /// @notice send `_value` token to `_to` from `msg.sender`
14     /// @param _to The address of the recipient
15     /// @param _value The amount of token to be transferred
16     /// @return Whether the transfer was successful or not
17     function transfer(address _to, uint256 _value) returns (bool success);
18 
19     /// @notice send `_value` token to `_to` from `_from` on the condition it is approved by `_from`
20     /// @param _from The address of the sender
21     /// @param _to The address of the recipient
22     /// @param _value The amount of token to be transferred
23     /// @return Whether the transfer was successful or not
24     function transferFrom(address _from, address _to, uint256 _value) returns (bool success);
25 
26     /// @notice `msg.sender` approves `_spender` to spend `_value` tokens
27     /// @param _spender The address of the account able to transfer the tokens
28     /// @param _value The amount of tokens to be approved for transfer
29     /// @return Whether the approval was successful or not
30     function approve(address _spender, uint256 _value) returns (bool success);
31 
32     /// @param _owner The address of the account owning tokens
33     /// @param _spender The address of the account able to transfer the tokens
34     /// @return Amount of remaining tokens allowed to spent
35     function allowance(address _owner, address _spender) constant returns (uint256 remaining);
36 
37     event Transfer(address indexed _from, address indexed _to, uint256 _value);
38     event Approval(address indexed _owner, address indexed _spender, uint256 _value);
39 }
40 
41 contract SafeMath {
42   function safeMul(uint a, uint b) internal returns (uint) {
43     uint c = a * b;
44     assert(a == 0 || c / a == b);
45     return c;
46   }
47 
48   function safeDiv(uint a, uint b) internal returns (uint) {
49     assert(b > 0);
50     uint c = a / b;
51     assert(a == b * c + a % b);
52     return c;
53   }
54 
55   function safeSub(uint a, uint b) internal returns (uint) {
56     assert(b <= a);
57     return a - b;
58   }
59 
60   function safeAdd(uint a, uint b) internal returns (uint) {
61     uint c = a + b;
62     assert(c>=a && c>=b);
63     return c;
64   }
65 
66   function max64(uint64 a, uint64 b) internal constant returns (uint64) {
67     return a >= b ? a : b;
68   }
69 
70   function min64(uint64 a, uint64 b) internal constant returns (uint64) {
71     return a < b ? a : b;
72   }
73 
74   function max256(uint256 a, uint256 b) internal constant returns (uint256) {
75     return a >= b ? a : b;
76   }
77 
78   function min256(uint256 a, uint256 b) internal constant returns (uint256) {
79     return a < b ? a : b;
80   }
81 
82   function assert(bool assertion) internal {
83     if (!assertion) {
84       throw;
85     }
86   }
87 }
88 
89 contract Controlled {
90     modifier onlyController() {
91         require(msg.sender == controller);
92         _;
93     }
94 
95     address public controller;
96 
97     function Controlled() {
98         controller = msg.sender;
99     }
100 
101     address public newController;
102 
103     function changeOwner(address _newController) onlyController {
104         newController = _newController;
105     }
106 
107     function acceptOwnership() {
108         if (msg.sender == newController) {
109             controller = newController;
110         }
111     }
112 }
113 contract DAOControlled is Controlled{
114     address public dao;
115     modifier onlyDAO{
116         require(msg.sender == dao);
117         _;
118     }
119     function setDAO(address _dao) onlyController{
120         dao = _dao;
121     }
122 }
123 
124 contract MintableToken is ERC20, SafeMath, DAOControlled{
125 	mapping(address => uint) public balances;
126 	address[] public mintingFactories;
127 	uint public numFactories;
128 	function resetFactories() onlyController{
129 	    numFactories = 0;
130 	}
131 	function addMintingFactory(address _factory) onlyController{
132 	    mintingFactories.push(_factory);
133 	    numFactories += 1;
134 	}
135 	
136 	function removeMintingFactory(address _factory) onlyController{
137 	    for (uint i = 0; i < numFactories; i++){
138 	        if (_factory == mintingFactories[i])
139 	        {
140 	            mintingFactories[i] = 0;
141 	        }
142 	    }
143 	}
144 	
145 	modifier onlyFactory{
146 	    bool isFactory = false;
147 	    for (uint i = 0; i < numFactories; i++){
148 	        if (msg.sender == mintingFactories[i] && msg.sender != address(0))
149 	        {
150 	            isFactory = true;
151 	        }
152 	    }
153 	    if (!isFactory) throw;
154 	    _;
155 	}
156 }
157 contract CollectibleFeeToken is MintableToken{
158 	uint8 public decimals;
159 	mapping(uint => uint) public roundFees;
160 	mapping(uint => uint) public recordedCoinSupplyForRound;
161 	mapping(uint => mapping (address => uint)) public claimedFees;
162 	mapping(address => uint) public lastClaimedRound;
163 	uint public latestRound = 0;
164 	uint public initialRound = 1;
165 	uint public reserves;
166     event Claimed(address indexed _owner, uint256 _amount);
167     event Deposited(uint256 _amount, uint indexed round);
168 	
169 	modifier onlyPayloadSize(uint size) {
170 		if(msg.data.length != size + 4) {
171 		throw;
172 		}
173 		_;
174 	}
175 	
176 	function reduceReserves(uint value) onlyPayloadSize(1 * 32) onlyDAO{
177 	    reserves = safeSub(reserves, value);
178 	}
179 	
180 	function addReserves(uint value) onlyPayloadSize(1 * 32) onlyDAO{
181 	    reserves = safeAdd(reserves, value);
182 	}
183 	
184 	function depositFees(uint value) onlyDAO {
185 		latestRound += 1;
186 		Deposited(value, latestRound);
187 		recordedCoinSupplyForRound[latestRound] = totalSupply;
188 		roundFees[latestRound] = value;
189 	}
190 	function claimFees(address _owner) onlyPayloadSize(1 * 32) onlyDAO returns (uint totalFees) {
191 		totalFees = 0;
192 		for (uint i = lastClaimedRound[_owner] + 1; i <= latestRound; i++){
193 			uint feeForRound = balances[_owner] * feePerUnitOfCoin(i);
194 			if (feeForRound > claimedFees[i][_owner]){
195 				feeForRound = safeSub(feeForRound,claimedFees[i][_owner]);
196 			}
197 			else {
198 				feeForRound = 0;
199 			}
200 			claimedFees[i][_owner] = safeAdd(claimedFees[i][_owner], feeForRound);
201 			totalFees = safeAdd(totalFees, feeForRound);
202 		}
203 		lastClaimedRound[_owner] = latestRound;
204 		Claimed(_owner, feeForRound);
205 		return totalFees;
206 	}
207 
208 	function claimFeesForRound(address _owner, uint round) onlyPayloadSize(2 * 32) onlyDAO returns (uint feeForRound) {
209 		feeForRound = balances[_owner] * feePerUnitOfCoin(round);
210 		if (feeForRound > claimedFees[round][_owner]){
211 			feeForRound = safeSub(feeForRound,claimedFees[round][_owner]);
212 		}
213 		else {
214 			feeForRound = 0;
215 		}
216 		claimedFees[round][_owner] = safeAdd(claimedFees[round][_owner], feeForRound);
217 		Claimed(_owner, feeForRound);
218 		return feeForRound;
219 	}
220 
221 	function _resetTransferredCoinFees(address _owner, address _receipient, uint numCoins) internal returns (bool){
222 		for (uint i = lastClaimedRound[_owner] + 1; i <= latestRound; i++){
223 			uint feeForRound = balances[_owner] * feePerUnitOfCoin(i);
224 			if (feeForRound > claimedFees[i][_owner]) {
225 				//Add unclaimed fees to reserves
226 				uint unclaimedFees = min256(numCoins * feePerUnitOfCoin(i), safeSub(feeForRound, claimedFees[i][_owner]));
227 				reserves = safeAdd(reserves, unclaimedFees);
228 				claimedFees[i][_owner] = safeAdd(claimedFees[i][_owner], unclaimedFees);
229 			}
230 		}
231 		for (uint x = lastClaimedRound[_receipient] + 1; x <= latestRound; x++){
232 			//Empty fees for new receipient
233 			claimedFees[x][_receipient] = safeAdd(claimedFees[x][_receipient], numCoins * feePerUnitOfCoin(x));
234 		}
235 		return true;
236 	}
237 	function feePerUnitOfCoin(uint round) public constant returns (uint fee){
238 		return safeDiv(roundFees[round], recordedCoinSupplyForRound[round]);
239 	}
240 	
241 	function reservesPerUnitToken() public constant returns(uint) {
242 	    return reserves / totalSupply;
243 	}
244 	
245    function mintTokens(address _owner, uint amount) onlyFactory{
246        //Upon factory transfer, fees will be redistributed into reserves
247        lastClaimedRound[msg.sender] = latestRound;
248        totalSupply = safeAdd(totalSupply, amount);
249        balances[_owner] += amount;
250    }
251 }
252 
253 contract BurnableToken is CollectibleFeeToken{
254 
255     event Burned(address indexed _owner, uint256 _value);
256     function burn(address _owner, uint amount) onlyDAO returns (uint burnValue){
257         require(balances[_owner] >= amount);
258         //Validation is done to ensure no fees remaining in token
259         require(latestRound == lastClaimedRound[_owner]);
260         burnValue = reservesPerUnitToken() * amount;
261         reserves = safeSub(reserves, burnValue);
262         balances[_owner] = safeSub(balances[_owner], amount);
263         totalSupply = safeSub(totalSupply, amount);
264         Transfer(_owner, this, amount);
265         Burned(_owner, amount);
266         return burnValue;
267     }
268     
269 }
270 /*
271  * Haltable
272  *
273  * Abstract contract that allows children to implement an
274  * emergency stop mechanism. Differs from Pausable by causing a throw when in halt mode.
275  *
276  *
277  * Originally envisioned in FirstBlood ICO contract.
278  */
279 contract Haltable is Controlled {
280   bool public halted;
281 
282   modifier stopInEmergency {
283     if (halted) throw;
284     _;
285   }
286 
287   modifier onlyInEmergency {
288     if (!halted) throw;
289     _;
290   }
291 
292   // called by the owner on emergency, triggers stopped state
293   function halt() external onlyController {
294     halted = true;
295   }
296 
297   // called by the owner on end of emergency, returns to normal state
298   function unhalt() external onlyController onlyInEmergency {
299     halted = false;
300   }
301 
302 }
303 
304 /**
305  * Standard ERC20 token with Short Hand Attack and approve() race condition mitigation.
306  *
307  * Based on code by FirstBlood:
308  * https://github.com/Firstbloodio/token/blob/master/smart_contract/FirstBloodToken.sol
309  */
310 contract SphereToken is BurnableToken, Haltable {
311     
312     string public name;                //The Token's name: e.g. DigixDAO Tokens
313     string public symbol;              //An identifier: e.g. REP
314     string public version = 'SPR_0.1'; //An arbitrary versioning scheme
315     bool public isTransferEnabled;
316   mapping (address => mapping (address => uint)) allowed;
317 
318     function SphereToken(){
319         name = 'EtherSphere';
320         symbol = 'SPR';
321         decimals = 4;
322         isTransferEnabled = false;
323     }
324   /**
325    *
326    * Fix for the ERC20 short address attack
327    *
328    * http://vessenes.com/the-erc20-short-address-attack-explained/
329    */
330   modifier onlyPayloadSize(uint size) {
331      if(msg.data.length != size + 4) {
332        throw;
333      }
334      _;
335   }
336 
337     function setTransferEnable(bool enabled) onlyDAO{
338         isTransferEnabled = enabled;
339     }
340     function doTransfer(address _from, address _to, uint _value) private returns (bool success){
341         if (_value > balances[_from] || !isTransferEnabled) return false;
342         if (!_resetTransferredCoinFees(_from, _to, _value)) return false;
343         balances[_from] = safeSub(balances[_from], _value);
344         balances[_to] = safeAdd(balances[_to], _value);
345         Transfer(msg.sender, _to, _value);
346         return true;
347     }
348   function transfer(address _to, uint _value) onlyPayloadSize(2 * 32) stopInEmergency returns (bool success) {
349     return doTransfer(msg.sender, _to, _value);
350   }
351 
352   function exchangeTransfer(address _to, uint _value) stopInEmergency onlyFactory returns (bool success) {
353         if (_value > balances[msg.sender]) {return false;}
354         if (!_resetTransferredCoinFees(msg.sender, _to, _value)){ return false;}
355         balances[msg.sender] = safeSub(balances[msg.sender], _value);
356         balances[_to] = safeAdd(balances[_to], _value);
357         Transfer(msg.sender, _to, _value);
358         return true;
359   }
360   function transferFrom(address _from, address _to, uint _value) onlyPayloadSize(3 * 32) stopInEmergency returns (bool success) {
361     var _allowance = allowed[_from][msg.sender];
362     if (_value > balances[_from] || !isTransferEnabled || _value > _allowance) return false;
363     allowed[_from][msg.sender] = safeSub(_allowance, _value);
364     return doTransfer(_from, _to, _value);
365   }
366 
367   function balanceOf(address _owner) constant returns (uint balance) {
368     return balances[_owner];
369   }
370 
371   function approve(address _spender, uint _value) stopInEmergency returns (bool success) {
372 
373     // To change the approve amount you first have to reduce the addresses`
374     //  allowance to zero by calling `approve(_spender, 0)` if it is not
375     //  already 0 to mitigate the race condition described here:
376     //  https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
377     if ((_value != 0) && (allowed[msg.sender][_spender] != 0)) {
378         return false;
379     }
380 
381     allowed[msg.sender][_spender] = _value;
382     Approval(msg.sender, _spender, _value);
383     return true;
384   }
385 
386   function allowance(address _owner, address _spender) constant returns (uint remaining) {
387     return allowed[_owner][_spender];
388   }
389 
390   /**
391    * Atomic increment of approved spending
392    *
393    * Works around https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
394    *
395    */
396   function addApproval(address _spender, uint _addedValue)
397   onlyPayloadSize(2 * 32) stopInEmergency
398   returns (bool success) {
399       uint oldValue = allowed[msg.sender][_spender];
400       allowed[msg.sender][_spender] = safeAdd(oldValue, _addedValue);
401       return true;
402   }
403 
404   /**
405    * Atomic decrement of approved spending.
406    *
407    * Works around https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
408    */
409   function subApproval(address _spender, uint _subtractedValue)
410   onlyPayloadSize(2 * 32) stopInEmergency
411   returns (bool success) {
412 
413       uint oldVal = allowed[msg.sender][_spender];
414 
415       if (_subtractedValue > oldVal) {
416           allowed[msg.sender][_spender] = 0;
417       } else {
418           allowed[msg.sender][_spender] = safeSub(oldVal, _subtractedValue);
419       }
420       return true;
421   }
422 
423 }