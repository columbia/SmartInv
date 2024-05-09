1 pragma solidity ^0.4.19;
2 
3 /**
4  * @title SafeMath
5  * @dev Math operations with safety checks that throw on error
6  */
7 library SafeMath {
8   function mul(uint256 a, uint256 b) internal constant returns (uint256) {
9     uint256 c = a * b;
10     assert(a == 0 || c / a == b);
11     return c;
12   }
13 
14   function div(uint256 a, uint256 b) internal constant returns (uint256) {
15     // assert(b > 0); // Solidity automatically throws when dividing by 0
16     uint256 c = a / b;
17     // assert(a == b * c + a % b); // There is no case in which this doesn't hold
18     return c;
19   }
20 
21   function sub(uint256 a, uint256 b) internal constant returns (uint256) {
22     assert(b <= a);
23     return a - b;
24   }
25 
26   function add(uint256 a, uint256 b) internal constant returns (uint256) {
27     uint256 c = a + b;
28     assert(c >= a);
29     return c;
30   }
31 }
32 
33 contract Ownable {
34   address public owner;
35 
36   event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
37 
38   /**
39    * @dev The Ownable constructor sets the original `owner` of the contract to the sender
40    * account.
41    */
42   function Ownable() public {
43     owner = msg.sender;
44   }
45 
46   /**
47    * @dev Throws if called by any account other than the owner.
48    */
49   modifier onlyOwner() {
50     require(msg.sender == owner);
51     _;
52   }
53 
54   /**
55    * @dev Allows the current owner to transfer control of the contract to a newOwner.
56    * @param newOwner The address to transfer ownership to.
57    */
58   function transferOwnership(address newOwner) public onlyOwner {
59     require(newOwner != address(0));
60     OwnershipTransferred(owner, newOwner);
61     owner = newOwner;
62   }
63 
64 }
65 
66 contract ERC20 {
67   uint256 public totalSupply;
68   function balanceOf(address who) constant returns (uint256);
69   function transfer(address to, uint256 value) returns (bool);
70   event Transfer(address indexed from, address indexed to, uint256 value);
71   function allowance(address owner, address spender) constant returns (uint256);
72   function transferFrom(address from, address to, uint256 value) returns (bool);
73   function approve(address spender, uint256 value) returns (bool);
74   event Approval(address indexed owner, address indexed spender, uint256 value);
75     
76 }
77 
78 
79 contract BasicToken is ERC20 {
80     using SafeMath for uint256;
81 
82     mapping(address => uint256) balances;
83     mapping (address => mapping (address => uint256)) allowed;
84 
85     modifier nonZeroEth(uint _value) {
86       require(_value > 0);
87       _;
88     }
89 
90     modifier onlyPayloadSize() {
91       require(msg.data.length >= 68);
92       _;
93     }
94 
95 
96     event Transfer(address indexed from, address indexed to, uint256 value);
97     event Allocate(address indexed from, address indexed to, uint256 value);
98     event Approval(address indexed owner, address indexed spender, uint256 value);
99 
100 
101     /**
102   * @dev transfer token for a specified address
103   * @param _to The address to transfer to.
104   * @param _value The amount to be transferred.
105   */
106 
107     function transfer(address _to, uint256 _value) nonZeroEth(_value) onlyPayloadSize returns (bool) {
108         if (balances[msg.sender] >= _value && balances[_to] + _value > balances[_to]){
109             balances[msg.sender] = balances[msg.sender].sub(_value);
110             balances[_to] = balances[_to].add(_value);
111             Transfer(msg.sender, _to, _value);
112             return true;
113         }else{
114             return false;
115         }
116     }
117 
118 
119     /**
120    * @dev Transfer tokens from one address to another
121    * @param _from address The address which you want to send tokens from
122    * @param _to address The address which you want to transfer to
123    * @param _value uint256 the amout of tokens to be transfered
124    */
125 
126     function transferFrom(address _from, address _to, uint256 _value) nonZeroEth(_value) onlyPayloadSize returns (bool) {
127       if(balances[_from] >= _value && allowed[_from][msg.sender] >= _value && balances[_to] + _value > balances[_to]){
128         uint256 _allowance = allowed[_from][msg.sender];
129         allowed[_from][msg.sender] = _allowance.sub(_value);
130         balances[_to] = balances[_to].add(_value);
131         balances[_from] = balances[_from].sub(_value);
132         Transfer(_from, _to, _value);
133         return true;
134       }else{
135         return false;
136       }
137 }
138 
139 
140     /**
141   * @dev Gets the balance of the specified address.
142   * @param _owner The address to query the the balance of.
143   * @return An uint256 representing the amount owned by the passed address.
144   */
145 
146     function balanceOf(address _owner) constant returns (uint256 balance) {
147     return balances[_owner];
148   }
149 
150   function approve(address _spender, uint256 _value) returns (bool) {
151 
152     // To change the approve amount you first have to reduce the addresses`
153     //  allowance to zero by calling `approve(_spender, 0)` if it is not
154     //  already 0 to mitigate the race condition described here:
155     //  https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
156     require((_value == 0) || (allowed[msg.sender][_spender] == 0));
157 
158     allowed[msg.sender][_spender] = _value;
159     Approval(msg.sender, _spender, _value);
160     return true;
161   }
162 
163   /**
164    * @dev Function to check the amount of tokens that an owner allowed to a spender.
165    * @param _owner address The address which owns the funds.
166    * @param _spender address The address which will spend the funds.
167    * @return A uint256 specifing the amount of tokens still avaible for the spender.
168    */
169   function allowance(address _owner, address _spender) constant returns (uint256 remaining) {
170     return allowed[_owner][_spender];
171   }
172 
173 
174 }
175 
176 
177 
178 contract BoonTech is BasicToken, Ownable{
179 
180 using SafeMath for uint256;
181 
182 //token attributes
183 
184 string public name = "Boon Tech";                 //name of the token
185 
186 string public symbol = "BOON";                      // symbol of the token
187 
188 uint8 public decimals = 18;                        // decimals
189 
190 uint256 public totalSupply = 500000000 * 10**uint256(decimals);  // total supply of BOON Tokens
191 
192 uint256 private constant decimalFactor = 10**uint256(decimals);
193 
194 bool public transfersAreLocked = true;
195 
196 mapping (address => Allocation) public allocations;
197 
198 // Allocation with vesting information
199 // 25% Released at Token Distribution +0.5 year -> 100% at Token Distribution +2 years
200 struct Allocation {
201   uint256 startTime;
202   uint256 endCliff;       // Tokens are locked until
203   uint256 endVesting;     // This is when the tokens are fully unvested
204   uint256 totalAllocated; // Total tokens allocated
205   uint256 amountClaimed;  // Total tokens claimed
206 }
207 
208 uint256 public grandTotalClaimed = 0;
209 uint256 tokensForDistribution = totalSupply.div(2);
210 uint256 ethPrice = 960;
211 uint256 tokenPrice = 4;
212 
213 //events
214 event LogNewAllocation(address indexed _recipient, uint256 _totalAllocated);
215 event LogBoonReleased(address indexed _recipient, uint256 _amountClaimed, uint256 _totalAllocated, uint256 _grandTotalClaimed);
216 
217 ///////////////////////////////////////// CONSTRUCTOR for Distribution //////////////////////////////////////////////////
218 
219   function BoonTech () {
220     balances[msg.sender] = totalSupply;
221   }
222 
223 ///////////////////////////////////////// MODIFIERS /////////////////////////////////////////////////
224 
225 // Checks whether it can transfer or otherwise throws.
226   modifier canTransfer() {
227     require(transfersAreLocked == false);
228     _;
229   }
230 
231   modifier nonZeroAddress(address _to) {
232     require(_to != 0x0);
233     _;
234   }
235 
236 ////////////////////////////////////////// FUNCTIONS //////////////////////////////////////////////
237 
238 // Returns current token Owner
239 
240   function tokenOwner() public view returns (address) {
241     return owner;
242   }
243 
244 // Checks modifier and allows transfer if tokens are not locked.
245   function transfer(address _to, uint _value) canTransfer() public returns (bool success) {
246     return super.transfer(_to, _value);
247   }
248 
249   // Checks modifier and allows transfer if tokens are not locked.
250   function transferFrom(address _from, address _to, uint _value) canTransfer() public returns (bool success) {
251     return super.transferFrom(_from, _to, _value);
252   }
253 
254   // lock/unlock transfers
255   function transferLock() onlyOwner public{
256         transfersAreLocked = true;
257   }
258   function transferUnlock() onlyOwner public{
259         transfersAreLocked = false;
260   }
261 
262   function setFounderAllocation(address _recipient, uint256 _totalAllocated) onlyOwner public {
263     require(allocations[_recipient].totalAllocated == 0 && _totalAllocated > 0);
264     require(_recipient != address(0));
265 
266     allocations[_recipient] = Allocation(now, now + 0.5 years, now + 2 years, _totalAllocated, 0);
267     //allocations[_recipient] = Allocation(now, now + 2 minutes, now + 4 minutes, _totalAllocated, 0);
268 
269     LogNewAllocation(_recipient, _totalAllocated);
270   }
271 
272  
273   function releaseVestedTokens(address _tokenAddress) onlyOwner public{
274     require(allocations[_tokenAddress].amountClaimed < allocations[_tokenAddress].totalAllocated);
275     require(now >= allocations[_tokenAddress].endCliff);
276     require(now >= allocations[_tokenAddress].startTime);
277     uint256 newAmountClaimed;
278     if (allocations[_tokenAddress].endVesting > now) {
279       // Transfer available amount based on vesting schedule and allocation
280       newAmountClaimed = allocations[_tokenAddress].totalAllocated.mul(now.sub(allocations[_tokenAddress].startTime)).div(allocations[_tokenAddress].endVesting.sub(allocations[_tokenAddress].startTime));
281     } else {
282       // Transfer total allocated (minus previously claimed tokens)
283       newAmountClaimed = allocations[_tokenAddress].totalAllocated;
284     }
285     uint256 tokensToTransfer = newAmountClaimed.sub(allocations[_tokenAddress].amountClaimed);
286     allocations[_tokenAddress].amountClaimed = newAmountClaimed;
287     if(transfersAreLocked == true){
288       transfersAreLocked = false;
289       require(transfer(_tokenAddress, tokensToTransfer * decimalFactor));
290       transfersAreLocked = true;
291     }else{
292       require(transfer(_tokenAddress, tokensToTransfer * decimalFactor));
293     }
294     grandTotalClaimed = grandTotalClaimed.add(tokensToTransfer);
295     LogBoonReleased(_tokenAddress, tokensToTransfer, newAmountClaimed, grandTotalClaimed);
296   }
297 
298   function distributeToken(address[] _addresses, uint256[] _value) onlyOwner public {
299      for (uint i = 0; i < _addresses.length; i++) {
300          transfersAreLocked = false;
301          require(transfer(_addresses[i], _value[i] * decimalFactor));
302          transfersAreLocked = true;
303      }
304       
305   }
306 
307       // Buy token function call only in duration of crowdfund active
308     function getNoOfTokensTransfer(uint32 _exchangeRate , uint256 _amount) internal returns (uint256) {
309          uint256 noOfToken = _amount.mul(_exchangeRate);
310          uint256 noOfTokenWithBonus =(100 * noOfToken ) / 100;
311          return noOfTokenWithBonus;
312     }
313 
314     function setEthPrice(uint256 value)
315     external
316     onlyOwner
317     {
318         ethPrice = value;
319 
320     }
321     function calcToken(uint256 value)
322         internal
323         returns(uint256 amount){
324              amount =  ethPrice.mul(100).mul(value).div(tokenPrice);
325              return amount;
326         }
327      function buyTokens()
328             external
329             payable
330             returns (uint256 amount)
331             {
332                 amount = calcToken(msg.value);
333                 require(msg.value > 0);
334                 require(balanceOf(owner) >= amount);
335                 balances[owner] = balances[owner].sub(msg.value);
336                 balances[msg.sender] = balances[msg.sender].add(msg.value);
337                 return amount;
338     }
339 }