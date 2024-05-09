1 pragma solidity ^0.4.18;
2 
3 /**
4  * @title SafeMath
5  * @dev Math operations with safety checks that throw on error
6  */
7 library SafeMath {
8 
9   /**
10   * @dev Multiplies two numbers, throws on overflow.
11   */
12   function mul(uint256 a, uint256 b) internal pure returns (uint256) {
13     if (a == 0) {
14       return 0;
15     }
16     uint256 c = a * b;
17     assert(c / a == b);
18     return c;
19   }
20 
21   /**
22   * @dev Integer division of two numbers, truncating the quotient.
23   */
24   function div(uint256 a, uint256 b) internal pure returns (uint256) {
25     // assert(b > 0); // Solidity automatically throws when dividing by 0
26     uint256 c = a / b;
27     // assert(a == b * c + a % b); // There is no case in which this doesn't hold
28     return c;
29   }
30 
31   /**
32   * @dev Subtracts two numbers, throws on overflow (i.e. if subtrahend is greater than minuend).
33   */
34   function sub(uint256 a, uint256 b) internal pure returns (uint256) {
35     assert(b <= a);
36     return a - b;
37   }
38 
39   /**
40   * @dev Adds two numbers, throws on overflow.
41   */
42   function add(uint256 a, uint256 b) internal pure returns (uint256) {
43     uint256 c = a + b;
44     assert(c >= a);
45     return c;
46   }
47 }
48 
49 
50 /**
51  * @title ERC20Basic
52  * @dev Simpler version of ERC20 interface
53  * @dev see https://github.com/ethereum/EIPs/issues/179
54  */
55 contract ERC20Basic {
56   function totalSupply() public view returns (uint256);
57   function balanceOf(address who) public view returns (uint256);
58   function transfer(address to, uint256 value) public returns (bool);
59   event Transfer(address indexed from, address indexed to, uint256 value);
60 }
61 
62 
63 /**
64  * @title ERC20 interface
65  * @dev see https://github.com/ethereum/EIPs/issues/20
66  */
67 contract ERC20 is ERC20Basic {
68   function allowance(address owner, address spender) public view returns (uint256);
69   function transferFrom(address from, address to, uint256 value) public returns (bool);
70   function approve(address spender, uint256 value) public returns (bool);
71   event Approval(address indexed owner, address indexed spender, uint256 value);
72 }
73 
74 
75 /**
76  * @title Basic token
77  * @dev Basic version of StandardToken, with no allowances.
78  */
79 contract BasicToken is ERC20Basic {
80   using SafeMath for uint256;
81 
82   mapping(address => uint256) balances;
83 
84   uint256 totalSupply_;
85 
86   /**
87   * @dev total number of tokens in existence
88   */
89   function totalSupply() public view returns (uint256) {
90     return totalSupply_;
91   }
92 
93   /**
94   * @dev transfer token for a specified address
95   * @param _to The address to transfer to.
96   * @param _value The amount to be transferred.
97   */
98   function transfer(address _to, uint256 _value) public returns (bool) {
99     require(_to != address(0));
100     require(_value <= balances[msg.sender]);
101 
102     // SafeMath.sub will throw if there is not enough balance.
103     balances[msg.sender] = balances[msg.sender].sub(_value);
104     balances[_to] = balances[_to].add(_value);
105     emit Transfer(msg.sender, _to, _value);
106     return true;
107   }
108 
109   /**
110   * @dev Gets the balance of the specified address.
111   * @param _owner The address to query the the balance of.
112   * @return An uint256 representing the amount owned by the passed address.
113   */
114   function balanceOf(address _owner) public view returns (uint256 balance) {
115     return balances[_owner];
116   }
117 
118 }
119 
120 
121 /**
122  * @title Standard ERC20 token
123  *
124  * @dev Implementation of the basic standard token.
125  * @dev https://github.com/ethereum/EIPs/issues/20
126  * @dev Based on code by FirstBlood: https://github.com/Firstbloodio/token/blob/master/smart_contract/FirstBloodToken.sol
127  */
128 contract StandardToken is ERC20, BasicToken {
129 
130   mapping (address => mapping (address => uint256)) internal allowed;
131 
132   /**
133    * @dev Transfer tokens from one address to another
134    * @param _from address The address which you want to send tokens from
135    * @param _to address The address which you want to transfer to
136    * @param _value uint256 the amount of tokens to be transferred
137    */
138   function transferFrom(address _from, address _to, uint256 _value) public returns (bool) {
139     require(_to != address(0));
140     require(_value <= balances[_from]);
141     require(_value <= allowed[_from][msg.sender]);
142 
143     balances[_from] = balances[_from].sub(_value);
144     balances[_to] = balances[_to].add(_value);
145     allowed[_from][msg.sender] = allowed[_from][msg.sender].sub(_value);
146     emit Transfer(_from, _to, _value);
147     return true;
148   }
149 
150   /**
151    * @dev Approve the passed address to spend the specified amount of tokens on behalf of msg.sender.
152    *
153    * Beware that changing an allowance with this method brings the risk that someone may use both the old
154    * and the new allowance by unfortunate transaction ordering. One possible solution to mitigate this
155    * race condition is to first reduce the spender's allowance to 0 and set the desired value afterwards:
156    * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
157    * @param _spender The address which will spend the funds.
158    * @param _value The amount of tokens to be spent.
159    */
160   function approve(address _spender, uint256 _value) public returns (bool) {
161     allowed[msg.sender][_spender] = _value;
162     emit Approval(msg.sender, _spender, _value);
163     return true;
164   }
165 
166   /**
167    * @dev Function to check the amount of tokens that an owner allowed to a spender.
168    * @param _owner address The address which owns the funds.
169    * @param _spender address The address which will spend the funds.
170    * @return A uint256 specifying the amount of tokens still available for the spender.
171    */
172   function allowance(address _owner, address _spender) public view returns (uint256) {
173     return allowed[_owner][_spender];
174   }
175 
176   /**
177    * @dev Increase the amount of tokens that an owner allowed to a spender.
178    *
179    * approve should be called when allowed[_spender] == 0. To increment
180    * allowed value is better to use this function to avoid 2 calls (and wait until
181    * the first transaction is mined)
182    * From MonolithDAO Token.sol
183    * @param _spender The address which will spend the funds.
184    * @param _addedValue The amount of tokens to increase the allowance by.
185    */
186   function increaseApproval(address _spender, uint _addedValue) public returns (bool) {
187     allowed[msg.sender][_spender] = allowed[msg.sender][_spender].add(_addedValue);
188     emit Approval(msg.sender, _spender, allowed[msg.sender][_spender]);
189     return true;
190   }
191 
192   /**
193    * @dev Decrease the amount of tokens that an owner allowed to a spender.
194    *
195    * approve should be called when allowed[_spender] == 0. To decrement
196    * allowed value is better to use this function to avoid 2 calls (and wait until
197    * the first transaction is mined)
198    * From MonolithDAO Token.sol
199    * @param _spender The address which will spend the funds.
200    * @param _subtractedValue The amount of tokens to decrease the allowance by.
201    */
202   function decreaseApproval(address _spender, uint _subtractedValue) public returns (bool) {
203     uint oldValue = allowed[msg.sender][_spender];
204     if (_subtractedValue > oldValue) {
205       allowed[msg.sender][_spender] = 0;
206     } else {
207       allowed[msg.sender][_spender] = oldValue.sub(_subtractedValue);
208     }
209     emit Approval(msg.sender, _spender, allowed[msg.sender][_spender]);
210     return true;
211   }
212 
213 }
214 
215 
216 /**
217  * @title IHF
218  * @dev IHF is the ERC20 token of the Invictus Hyperion fund
219 */
220 
221 contract IHF is StandardToken {
222   using SafeMath for uint256;
223 
224   string public name = "Invictus Hyperion";
225   string public symbol = "IHF";
226   uint8 public decimals = 18;
227   string public version = "1.0";
228 
229   uint256 public fundingEndBlock;
230 
231   // vesting fields
232   address public vestingContract;
233   bool private vestingSet = false;
234 
235   address public fundWallet1;
236   address public fundWallet2;
237 
238   bool public tradeable = false;
239 
240   // maybe event for mint
241 
242   modifier isTradeable { // exempt vestingContract and fundWallet to allow dev allocations
243       require(tradeable || msg.sender == fundWallet1 || msg.sender == vestingContract);
244       _;
245   }
246 
247   modifier onlyFundWallets {
248       require(msg.sender == fundWallet1 || msg.sender == fundWallet2);
249       _;
250   }
251 
252   // constructor
253   function IHF(address backupFundWallet, uint256 endBlockInput) public {
254       require(backupFundWallet != address(0));
255       require(block.number < endBlockInput);
256       fundWallet1 = msg.sender;
257       fundWallet2 = backupFundWallet;
258       fundingEndBlock = endBlockInput;
259   }
260 
261   function setVestingContract(address vestingContractInput) external onlyFundWallets {
262       require(!vestingSet); // can only be called once
263       require(vestingContractInput != address(0));
264       vestingContract = vestingContractInput;
265       vestingSet = true;
266   }
267 
268   function allocateTokens(address participant, uint256 amountTokens) private {
269       require(vestingSet);
270       // 2.5% of total allocated for Invictus Capital & Team
271       uint256 developmentAllocation = amountTokens.mul(25641025641025641).div(1000000000000000000);
272       uint256 newTokens = amountTokens.add(developmentAllocation);
273       // increase token supply, assign tokens to participant
274       totalSupply_ = totalSupply_.add(newTokens);
275       balances[participant] = balances[participant].add(amountTokens);
276       balances[vestingContract] = balances[vestingContract].add(developmentAllocation);
277       emit Transfer(address(0), participant, amountTokens);
278       emit Transfer(address(0), vestingContract, developmentAllocation);
279   }
280 
281   function batchAllocate(address[] participants, uint256[] values) external onlyFundWallets returns(uint256) {
282       require(block.number < fundingEndBlock);
283       uint256 i = 0;
284       while (i < participants.length) {
285         allocateTokens(participants[i], values[i]);
286         i++;
287       }
288       return(i);
289   }
290 
291   // @dev sets a users balance to zero, adjusts supply and dev allocation as well
292   function adjustBalance(address participant) external onlyFundWallets {
293       require(vestingSet);
294       require(block.number < fundingEndBlock);
295       uint256 amountTokens = balances[participant];
296       uint256 developmentAllocation = amountTokens.mul(25641025641025641).div(1000000000000000000);
297       uint256 removeTokens = amountTokens.add(developmentAllocation);
298       totalSupply_ = totalSupply_.sub(removeTokens);
299       balances[participant] = 0;
300       balances[vestingContract] = balances[vestingContract].sub(developmentAllocation);
301       emit Transfer(participant, address(0), amountTokens);
302       emit Transfer(vestingContract, address(0), developmentAllocation);
303   }
304 
305   function changeFundWallet1(address newFundWallet) external onlyFundWallets {
306       require(newFundWallet != address(0));
307       fundWallet1 = newFundWallet;
308   }
309   function changeFundWallet2(address newFundWallet) external onlyFundWallets {
310       require(newFundWallet != address(0));
311       fundWallet2 = newFundWallet;
312   }
313 
314   function updateFundingEndBlock(uint256 newFundingEndBlock) external onlyFundWallets {
315       require(block.number < fundingEndBlock);
316       require(block.number < newFundingEndBlock);
317       fundingEndBlock = newFundingEndBlock;
318   }
319 
320   function enableTrading() external onlyFundWallets {
321       require(block.number > fundingEndBlock);
322       tradeable = true;
323   }
324 
325   function() payable public {
326       require(false); // throw
327   }
328 
329   function claimTokens(address _token) external onlyFundWallets {
330       require(_token != address(0));
331       ERC20Basic token = ERC20Basic(_token);
332       uint256 balance = token.balanceOf(this);
333       token.transfer(fundWallet1, balance);
334    }
335 
336    function removeEth() external onlyFundWallets {
337       fundWallet1.transfer(address(this).balance);
338     }
339 
340     function burn(uint256 _value) external onlyFundWallets {
341       require(balances[msg.sender] >= _value);
342       balances[msg.sender] = balances[msg.sender].sub(_value);
343       balances[0x0] = balances[0x0].add(_value);
344       totalSupply_ = totalSupply_.sub(_value);
345       emit Transfer(msg.sender, 0x0, _value);
346     }
347 
348    // prevent transfers until trading allowed
349    function transfer(address _to, uint256 _value) isTradeable public returns (bool success) {
350        return super.transfer(_to, _value);
351    }
352    function transferFrom(address _from, address _to, uint256 _value) isTradeable public returns (bool success) {
353        return super.transferFrom(_from, _to, _value);
354    }
355 
356 }