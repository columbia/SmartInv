1 pragma solidity 0.4.18;
2 
3 /**
4  * @title Ownable
5  * @dev The Ownable contract has an owner address, and provides basic authorization control 
6  * functions, this simplifies the implementation of "user permissions". 
7  */
8 contract Ownable {
9   address public owner;
10 
11 
12   /** 
13    * @dev The Ownable constructor sets the original `owner` of the contract to the sender
14    * account.
15    */
16   function Ownable() public {
17     owner = msg.sender;
18   }
19 
20 
21   /**
22    * @dev revert()s if called by any account other than the owner. 
23    */
24   modifier onlyOwner() {
25     if (msg.sender != owner) {
26       revert();
27     }
28     _;
29   }
30 
31 
32   /**
33    * @dev Allows the current owner to transfer control of the contract to a newOwner.
34    * @param newOwner The address to transfer ownership to. 
35    */
36   function transferOwnership(address newOwner) onlyOwner public {
37     if (newOwner != address(0)) {
38       owner = newOwner;
39     }
40   }
41 
42 }
43 
44 
45 
46 /**
47  * Math operations with safety checks
48  */
49 library SafeMath {
50   
51   
52   function mul256(uint256 a, uint256 b) internal pure returns (uint256) {
53     uint256 c = a * b;
54     assert(a == 0 || c / a == b);
55     return c;
56   }
57 
58   function div256(uint256 a, uint256 b) internal pure returns (uint256) {
59     require(b > 0); // Solidity automatically revert()s when dividing by 0
60     uint256 c = a / b;
61     // assert(a == b * c + a % b); // There is no case in which this doesn't hold
62     return c;
63   }
64 
65   function sub256(uint256 a, uint256 b) internal pure returns (uint256) {
66     require(b <= a);
67     return a - b;
68   }
69 
70   function add256(uint256 a, uint256 b) internal pure returns (uint256) {
71     uint256 c = a + b;
72     assert(c >= a);
73     return c;
74   }  
75   
76   function mod256(uint256 a, uint256 b) internal pure returns (uint256) {
77 	uint256 c = a % b;
78 	return c;
79   }
80 
81   function max64(uint64 a, uint64 b) internal pure returns (uint64) {
82     return a >= b ? a : b;
83   }
84 
85   function min64(uint64 a, uint64 b) internal pure returns (uint64) {
86     return a < b ? a : b;
87   }
88 
89   function max256(uint256 a, uint256 b) internal pure returns (uint256) {
90     return a >= b ? a : b;
91   }
92 
93   function min256(uint256 a, uint256 b) internal pure returns (uint256) {
94     return a < b ? a : b;
95   }
96 }
97 
98 /**
99  * @title ERC20Basic
100  * @dev Simpler version of ERC20 interface
101  */
102 contract ERC20Basic {
103   uint256 public totalSupply;
104   function balanceOf(address who) constant public returns (uint256);
105   function transfer(address to, uint256 value) public;
106   event Transfer(address indexed from, address indexed to, uint256 value);
107 }
108 
109 
110 
111 
112 /**
113  * @title ERC20 interface
114  * @dev ERC20 interface with allowances. 
115  */
116 contract ERC20 is ERC20Basic {
117   function allowance(address owner, address spender) constant public returns (uint256);
118   function transferFrom(address from, address to, uint256 value) public;
119   function approve(address spender, uint256 value) public;
120   event Approval(address indexed owner, address indexed spender, uint256 value);
121 }
122 
123 
124 
125 
126 /**
127  * @title Basic token
128  * @dev Basic version of StandardToken, with no allowances. 
129  */
130 contract BasicToken is ERC20Basic {
131   using SafeMath for uint256;
132 
133   mapping(address => uint256) balances;
134 
135   /**
136    * @dev Fix for the ERC20 short address attack.
137    */
138   modifier onlyPayloadSize(uint size) {
139      if(msg.data.length < size + 4) {
140        revert();
141      }
142      _;
143   }
144 
145   /**
146   * @dev transfer token for a specified address
147   * @param _to The address to transfer to.
148   * @param _value The amount to be transferred.
149   */
150   function transfer(address _to, uint256 _value) onlyPayloadSize(2 * 32) public {
151     balances[msg.sender] = balances[msg.sender].sub256(_value);
152     balances[_to] = balances[_to].add256(_value);
153     Transfer(msg.sender, _to, _value);
154   }
155 
156   /**
157   * @dev Gets the balance of the specified address.
158   * @param _owner The address to query the the balance of. 
159   * @return An uint representing the amount owned by the passed address.
160   */
161   function balanceOf(address _owner) constant public returns (uint256 balance) {
162     return balances[_owner];
163   }
164 
165 }
166 
167 
168 
169 
170 /**
171  * @title Standard ERC20 token
172  * @dev Implemantation of the basic standart token.
173  */
174 contract StandardToken is BasicToken, ERC20 {
175 
176   mapping (address => mapping (address => uint256)) allowed;
177 
178 
179   /**
180    * @dev Transfer tokens from one address to another
181    * @param _from address The address which you want to send tokens from
182    * @param _to address The address which you want to transfer to
183    * @param _value uint the amout of tokens to be transfered
184    */
185   function transferFrom(address _from, address _to, uint256 _value) onlyPayloadSize(3 * 32) public {
186     var _allowance = allowed[_from][msg.sender];
187 
188     // Check is not needed because sub(_allowance, _value) will already revert() if this condition is not met
189     // if (_value > _allowance) revert();
190 
191     balances[_to] = balances[_to].add256(_value);
192     balances[_from] = balances[_from].sub256(_value);
193     allowed[_from][msg.sender] = _allowance.sub256(_value);
194     Transfer(_from, _to, _value);
195   }
196 
197   /**
198    * @dev Aprove the passed address to spend the specified amount of tokens on behalf of msg.sender.
199    * @param _spender The address which will spend the funds.
200    * @param _value The amount of tokens to be spent.
201    */
202   function approve(address _spender, uint256 _value) public {
203 
204     //  To change the approve amount you first have to reduce the addresses
205     //  allowance to zero by calling `approve(_spender, 0)` if it is not
206     //  already 0 to mitigate the race condition described here:
207     //  https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
208     if ((_value != 0) && (allowed[msg.sender][_spender] != 0)) revert();
209 
210     allowed[msg.sender][_spender] = _value;
211     Approval(msg.sender, _spender, _value);
212   }
213 
214   /**
215    * @dev Function to check the amount of tokens than an owner allowed to a spender.
216    * @param _owner address The address which owns the funds.
217    * @param _spender address The address which will spend the funds.
218    * @return A uint specifing the amount of tokens still avaible for the spender.
219    */
220   function allowance(address _owner, address _spender) constant public returns (uint256 remaining) {
221     return allowed[_owner][_spender];
222   }
223 
224 
225 }
226 
227 
228 
229 /**
230  * @title TeuToken
231  * @dev The main TEU token contract
232  * 
233  */
234  
235 contract TeuToken is StandardToken, Ownable{
236   string public name = "20-footEqvUnit";
237   string public symbol = "TEU";
238   uint public decimals = 18;
239 
240   event TokenBurned(uint256 value);
241   
242   function TeuToken() public {
243     totalSupply = (10 ** 8) * (10 ** decimals);
244     balances[msg.sender] = totalSupply;
245   }
246 
247   /**
248    * @dev Allows the owner to burn the token
249    * @param _value number of tokens to be burned.
250    */
251   function burn(uint _value) onlyOwner public {
252     require(balances[msg.sender] >= _value);
253     balances[msg.sender] = balances[msg.sender].sub256(_value);
254     totalSupply = totalSupply.sub256(_value);
255     TokenBurned(_value);
256   }
257 
258 }
259 
260 /*
261  * Pausable
262  * Abstract contract that allows children to implement an
263  * emergency stop mechanism.
264  */
265 contract Pausable is Ownable {
266   bool public stopped;
267   modifier stopInEmergency {
268     if (stopped) {
269       revert();
270     }
271     _;
272   }
273   
274   modifier onlyInEmergency {
275     if (!stopped) {
276       revert();
277     }
278     _;
279   }
280   // called by the owner on emergency, triggers stopped state
281   function emergencyStop() external onlyOwner {
282     stopped = true;
283   }
284   // called by the owner on end of emergency, returns to normal state
285   function release() external onlyOwner onlyInEmergency {
286     stopped = false;
287   }
288 }
289 
290 /**
291  * @title teuBookingDeposit 
292  * @dev TEU Booking Deposit: A smart contract governing the entitlement of TEU token of two parties for a container shipping booking 
293   */
294 contract TeuBookingDeposit is Ownable, Pausable {
295 	event eAdjustClientAccountBalance(bytes32 indexed _PartnerID, bytes32 _ClientId, bytes32 _adjustedBy, string _CrDr, uint256 _tokenAmount, string CrDrR, uint256 _tokenRAmount);
296 	event eAllocateRestrictedTokenTo(bytes32 indexed _PartnerID, bytes32 indexed _clientId, bytes32 _allocatedBy, uint256 _tokenAmount);
297 	event eAllocateRestrictedTokenToPartner(bytes32 indexed _PartnerID, bytes32 _allocatedBy, uint256 _tokenAmount);
298 	event eCancelTransactionEvent(bytes32 indexed _PartnerID, string _TxNum, bytes32 indexed _fromClientId, uint256 _tokenAmount, uint256 _rAmount, uint256 _grandTotal);
299 	event eConfirmReturnToken(bytes32 indexed _PartnerID, string _TxNum, bytes32 indexed _fromClientId, uint256 _tokenAmount, uint256 _rAmount, uint256 _grandTotal);
300     event eConfirmTokenTransferToBooking(bytes32 indexed _PartnerID, string _TxNum, bytes32 _fromClientId1, bytes32 _toClientId2, uint256 _amount1, uint256 _rAmount1, uint256 _amount2, uint256 _rAmount2);
301     event eKillTransactionEvent(bytes32 _PartnerID, bytes32 _killedBy, string TxHash, string _TxNum);
302 	event ePartnerAllocateRestrictedTokenTo(bytes32 indexed _PartnerID, bytes32 indexed _clientId, uint256 _tokenAmount);
303 	event eReceiveTokenByClientAccount(bytes32 indexed _clientId, uint256 _tokenAmount, address _transferFrom);
304 	event eSetWalletToClientAccount(bytes32 _clientId, address _wallet, bytes32 _setBy);
305 	event eTransactionFeeForBooking(bytes32 indexed _PartnerID, string _TxNum, bytes32 _fromClientId1, bytes32 _toClientId2, uint256 _amount1, uint256 _rAmount1, uint256 _amount2, uint256 _rAmount2);
306 	event eWithdrawTokenToClientAccount(bytes32 indexed _clientId, bytes32 _withdrawnBy, uint256 _tokenAmount, address _transferTo);
307 	event eWithdrawUnallocatedRestrictedToken(uint256 _tokenAmount, bytes32 _withdrawnBy);
308 	
309 	
310 	
311     using SafeMath for uint256;
312 	
313 	
314     TeuToken    private token;
315 	/*  
316     * Failsafe drain
317     */
318     function drain() onlyOwner public {
319         if (!owner.send(this.balance)) revert();
320     }
321 	
322 	function () payable public {
323 		if (msg.value!=0) revert();
324 	}
325 	
326 	function stringToBytes32(string memory source) internal pure returns (bytes32 result) {
327 		bytes memory tempEmptyStringTest = bytes(source);
328 		if (tempEmptyStringTest.length == 0) {
329 			return 0x0;
330 		}
331 
332 		assembly {
333 			result := mload(add(source, 32))
334 		}
335 	}
336 	
337 	function killTransaction(bytes32 _PartnerID, bytes32 _killedBy, string _txHash, string _txNum) onlyOwner stopInEmergency public {
338 		eKillTransactionEvent(_PartnerID, _killedBy, _txHash, _txNum);
339 	}
340 	
341 		
342 	function cancelTransaction(bytes32 _PartnerID, string _TxNum, bytes32 _fromClientId1, bytes32 _toClientId2, uint256 _tokenAmount1, uint256 _rAmount1, uint256 _tokenAmount2, uint256 _rAmount2, uint256 _grandTotal) onlyOwner stopInEmergency public {
343         eCancelTransactionEvent(_PartnerID, _TxNum, _fromClientId1, _tokenAmount1, _rAmount1, _grandTotal);
344 		eCancelTransactionEvent(_PartnerID, _TxNum, _toClientId2, _tokenAmount2, _rAmount2, _grandTotal);
345 	}
346 	
347 	
348 	function AdjustClientAccountBalance(bytes32 _PartnerID, bytes32 _ClientId, bytes32 _allocatedBy, string _CrDr, uint256 _tokenAmount, string CrDrR, uint256 _RtokenAmount) onlyOwner stopInEmergency public {
349 		eAdjustClientAccountBalance(_PartnerID, _ClientId, _allocatedBy, _CrDr, _tokenAmount, CrDrR, _RtokenAmount);
350 	}
351 	
352 	function setWalletToClientAccount(bytes32 _clientId, address _wallet, bytes32 _setBy) onlyOwner public {
353         eSetWalletToClientAccount(_clientId, _wallet, _setBy);
354     }
355 	
356     function receiveTokenByClientAccount(string _clientId, uint256 _tokenAmount, address _transferFrom) stopInEmergency public {
357         require(_tokenAmount > 0);
358         bytes32 _clientId32 = stringToBytes32(_clientId);
359 		token.transferFrom(_transferFrom, this, _tokenAmount);   
360 		eReceiveTokenByClientAccount(_clientId32, _tokenAmount, _transferFrom);
361     }
362 	
363 	function withdrawTokenToClientAccount(bytes32 _clientId, bytes32 _withdrawnBy, address _transferTo, uint256 _tokenAmount) onlyOwner stopInEmergency public {
364         require(_tokenAmount > 0);
365 
366 		token.transfer(_transferTo, _tokenAmount);      
367 
368 		eWithdrawTokenToClientAccount(_clientId, _withdrawnBy, _tokenAmount, _transferTo);
369     }
370 	
371 
372 	
373     // functions for restricted token management
374     function allocateRestrictedTokenTo(bytes32 _PartnerID, bytes32 _clientId, bytes32 _allocatedBy, uint256 _tokenAmount) onlyOwner stopInEmergency public {
375 		eAllocateRestrictedTokenTo(_PartnerID, _clientId, _allocatedBy, _tokenAmount);
376     }
377     
378     function withdrawUnallocatedRestrictedToken(uint256 _tokenAmount, bytes32 _withdrawnBy) onlyOwner stopInEmergency public {
379         //require(_tokenAmount <= token.balanceOf(this).sub256(totalBookingClientToken).sub256(totalClientToken).sub256(totalRestrictedToken));
380         token.transfer(msg.sender, _tokenAmount);
381 		eWithdrawUnallocatedRestrictedToken(_tokenAmount, _withdrawnBy);
382     } 
383 
384 // functions for restricted token management Partner side
385     function allocateRestrictedTokenToPartner(bytes32 _PartnerID, bytes32 _allocatedBy, uint256 _tokenAmount) onlyOwner stopInEmergency public {
386 		eAllocateRestrictedTokenToPartner(_PartnerID, _allocatedBy, _tokenAmount);
387     }
388 	
389     function partnerAllocateRestrictedTokenTo(bytes32 _PartnerID, bytes32 _clientId, uint256 _tokenAmount) onlyOwner stopInEmergency public {
390 		ePartnerAllocateRestrictedTokenTo(_PartnerID, _clientId, _tokenAmount);
391     }
392 	
393 // functions for transferring token to booking 	
394 	function confirmTokenTransferToBooking(bytes32 _PartnerID, string _TxNum, bytes32 _fromClientId1, bytes32 _toClientId2, uint256 _tokenAmount1, uint256 _rAmount1, uint256 _tokenAmount2, uint256 _rAmount2, uint256 _txTokenAmount1, uint256 _txRAmount1, uint256 _txTokenAmount2, uint256 _txRAmount2) onlyOwner stopInEmergency public {		
395 		eConfirmTokenTransferToBooking(_PartnerID, _TxNum, _fromClientId1, _toClientId2, _tokenAmount1, _rAmount1, _tokenAmount2, _rAmount2);
396 		eTransactionFeeForBooking(_PartnerID, _TxNum, _fromClientId1, _toClientId2, _txTokenAmount1, _txRAmount1, _txTokenAmount2, _txRAmount2);
397 	}
398 
399  
400 // functions for returning tokens	
401 	function confirmReturnToken(bytes32 _PartnerID, string _TxNum, bytes32 _fromClientId1, bytes32 _toClientId2, uint256 _tokenAmount1, uint256 _rAmount1, uint256 _tokenAmount2, uint256 _rAmount2, uint256 _grandTotal) onlyOwner stopInEmergency public {
402         eConfirmReturnToken(_PartnerID, _TxNum, _fromClientId1, _tokenAmount1, _rAmount1, _grandTotal);
403 		eConfirmReturnToken(_PartnerID, _TxNum, _toClientId2, _tokenAmount2, _rAmount2, _grandTotal);
404 	}
405 
406 
407 // function for Admin
408     function getToken() constant public onlyOwner returns (address) {
409         return token;
410     }
411 	
412     function setToken(address _token) public onlyOwner stopInEmergency {
413         require(token == address(0));
414         token = TeuToken(_token);
415     }
416 
417 }