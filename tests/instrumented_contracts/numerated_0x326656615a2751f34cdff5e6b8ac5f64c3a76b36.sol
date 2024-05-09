1 pragma solidity ^0.4.11;
2 
3 
4 /**
5  * Math operations with safety checks
6  */
7 library SafeMath {
8   function mul(uint a, uint b) internal returns (uint) {
9     uint c = a * b;
10     assert(a == 0 || c / a == b);
11     return c;
12   }
13 
14   function div(uint a, uint b) internal returns (uint) {
15     // assert(b > 0); // Solidity automatically throws when dividing by 0
16     uint c = a / b;
17     // assert(a == b * c + a % b); // There is no case in which this doesn't hold
18     return c;
19   }
20 
21   function sub(uint a, uint b) internal returns (uint) {
22     assert(b <= a);
23     return a - b;
24   }
25 
26   function add(uint a, uint b) internal returns (uint) {
27     uint c = a + b;
28     assert(c >= a);
29     return c;
30   }
31 
32   function max64(uint64 a, uint64 b) internal constant returns (uint64) {
33     return a >= b ? a : b;
34   }
35 
36   function min64(uint64 a, uint64 b) internal constant returns (uint64) {
37     return a < b ? a : b;
38   }
39 
40   function max256(uint256 a, uint256 b) internal constant returns (uint256) {
41     return a >= b ? a : b;
42   }
43 
44   function min256(uint256 a, uint256 b) internal constant returns (uint256) {
45     return a < b ? a : b;
46   }
47 
48   function assert(bool assertion) internal {
49     if (!assertion) {
50       revert();
51     }
52   }
53 }
54 
55 
56 /**
57  * @title ERC20Basic
58  * @dev Simpler version of ERC20 interface
59  * @dev see https://github.com/ethereum/EIPs/issues/20
60  */
61 contract ERC20Basic {
62   uint public totalSupply;
63   function balanceOf(address who) constant returns (uint);
64   function transfer(address to, uint value);
65   event Transfer(address indexed from, address indexed to, uint value);
66 }
67 
68 
69 
70 
71 
72 /**
73  * @title ERC20 interface
74  * @dev see https://github.com/ethereum/EIPs/issues/20
75  */
76 contract ERC20 is ERC20Basic {
77   function allowance(address owner, address spender) constant returns (uint);
78   function transferFrom(address from, address to, uint value);
79   function approve(address spender, uint value);
80   event Approval(address indexed owner, address indexed spender, uint value);
81 }
82 
83 
84 
85 
86 /**
87  * @title Basic token
88  * @dev Basic version of StandardToken, with no allowances. 
89  */
90 contract BasicToken is ERC20Basic {
91   using SafeMath for uint;
92 
93   mapping(address => uint) balances;
94 
95   /**
96    * @dev Fix for the ERC20 short address attack.
97    */
98   modifier onlyPayloadSize(uint size) {
99      if(msg.data.length < size + 4) {
100        revert();
101      }
102      _;
103   }
104 
105   /**
106   * @dev transfer token for a specified address
107   * @param _to The address to transfer to.
108   * @param _value The amount to be transferred.
109   */
110   function transfer(address _to, uint _value) onlyPayloadSize(2 * 32) {
111     balances[msg.sender] = balances[msg.sender].sub(_value);
112     balances[_to] = balances[_to].add(_value);
113     Transfer(msg.sender, _to, _value);
114   }
115 
116   /**
117   * @dev Gets the balance of the specified address.
118   * @param _owner The address to query the the balance of. 
119   * @return An uint representing the amount owned by the passed address.
120   */
121   function balanceOf(address _owner) constant returns (uint balance) {
122     return balances[_owner];
123   }
124 
125 }
126 
127 
128 
129 
130 /**
131  * @title Standard ERC20 token
132  *
133  * @dev Implemantation of the basic standart token.
134  * @dev https://github.com/ethereum/EIPs/issues/20
135  * @dev Based on code by FirstBlood: https://github.com/Firstbloodio/token/blob/master/smart_contract/FirstBloodToken.sol
136  */
137 contract StandardToken is BasicToken, ERC20 {
138 
139   mapping (address => mapping (address => uint)) allowed;
140 
141 
142   /**
143    * @dev Transfer tokens from one address to another
144    * @param _from address The address which you want to send tokens from
145    * @param _to address The address which you want to transfer to
146    * @param _value uint the amout of tokens to be transfered
147    */
148   function transferFrom(address _from, address _to, uint _value) onlyPayloadSize(3 * 32) {
149     var _allowance = allowed[_from][msg.sender];
150 
151     // Check is not needed because sub(_allowance, _value) will already throw if this condition is not met
152     // if (_value > _allowance) throw;
153 
154     balances[_to] = balances[_to].add(_value);
155     balances[_from] = balances[_from].sub(_value);
156     allowed[_from][msg.sender] = _allowance.sub(_value);
157     Transfer(_from, _to, _value);
158   }
159 
160   /**
161    * @dev Aprove the passed address to spend the specified amount of tokens on beahlf of msg.sender.
162    * @param _spender The address which will spend the funds.
163    * @param _value The amount of tokens to be spent.
164    */
165   function approve(address _spender, uint _value) {
166 
167     // To change the approve amount you first have to reduce the addresses`
168     //  allowance to zero by calling `approve(_spender, 0)` if it is not
169     //  already 0 to mitigate the race condition described here:
170     //  https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
171     if ((_value != 0) && (allowed[msg.sender][_spender] != 0)) revert();
172 
173     allowed[msg.sender][_spender] = _value;
174     Approval(msg.sender, _spender, _value);
175   }
176 
177   /**
178    * @dev Function to check the amount of tokens than an owner allowed to a spender.
179    * @param _owner address The address which owns the funds.
180    * @param _spender address The address which will spend the funds.
181    * @return A uint specifing the amount of tokens still avaible for the spender.
182    */
183   function allowance(address _owner, address _spender) constant returns (uint remaining) {
184     return allowed[_owner][_spender];
185   }
186 
187 }
188 /*
189 
190   Copyright 2017 Bitnan.
191 
192   Licensed under the Apache License, Version 2.0 (the "License");
193   you may not use this file except in compliance with the License.
194   You may obtain a copy of the License at
195 
196   http://www.apache.org/licenses/LICENSE-2.0
197 
198   Unless required by applicable law or agreed to in writing, software
199   distributed under the License is distributed on an "AS IS" BASIS,
200   WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
201   See the License for the specific language governing permissions and
202   limitations under the License.
203 
204 */
205 
206 
207 contract BitnanRewardToken is StandardToken {
208     /* constants */
209     string public constant NAME = "BitnanRewardToken";
210     string public constant SYMBOL = "BRT";
211     uint public constant DECIMALS = 18;
212     uint256 public constant ETH_MIN_GOAL = 3000 ether;
213     uint256 public constant ETH_MAX_GOAL = 6000 ether;
214     uint256 public constant ORIGIN_ETH_BRT_RATIO = 3000;
215     uint public constant UNSOLD_SOLD_RATIO = 50;
216     uint public constant PHASE_NUMBER = 5;
217     uint public constant BLOCKS_PER_PHASE = 30500;
218     uint8[5] public bonusPercents = [
219       20,
220       15,
221       10,
222       5,
223       0
224     ];
225 
226     /* vars */
227     address public owner;
228     uint public totalEthAmount = 0;
229     uint public tokenIssueIndex = 0;
230     uint public deadline;
231     uint public durationInDays;
232     uint public startBlock = 0;
233     bool public isLeftTokenIssued = false;
234 
235 
236     /* events */
237     event TokenSaleStart();
238     event TokenSaleEnd();
239     event FakeOwner(address fakeOwner);
240     event CommonError(bytes error);
241     event IssueToken(uint index, address addr, uint ethAmount, uint tokenAmount);
242     event TokenSaleSucceed();
243     event TokenSaleFail();
244     event TokenSendFail(uint ethAmount);
245 
246     /* modifier */
247     modifier onlyOwner {
248       if(msg.sender != owner) {
249         FakeOwner(msg.sender);
250         revert();
251       }
252       _;        
253     }
254     modifier beforeSale {
255       if(!saleInProgress()) {
256         _;
257       }
258       else {
259         CommonError('Sale has not started!');
260         revert();
261       }
262     }
263     modifier inSale {
264       if(saleInProgress() && !saleOver()) {
265         _;
266       }
267       else {
268         CommonError('Token is not in sale!');
269         revert();
270       }
271     }
272     modifier afterSale {
273       if(saleOver()) {
274         _;
275       }
276       else {
277         CommonError('Sale is not over!');
278         revert();
279       }
280     }
281     /* functions */
282     function () payable {
283       issueToken(msg.sender);
284     }
285     function issueToken(address recipient) payable inSale {
286       assert(msg.value >= 0.01 ether);
287       uint tokenAmount = generateTokenAmount(msg.value);
288       totalEthAmount = totalEthAmount.add(msg.value);
289       totalSupply = totalSupply.add(tokenAmount);
290       balances[recipient] = balances[recipient].add(tokenAmount);
291       IssueToken(tokenIssueIndex, recipient, msg.value, tokenAmount);
292       if(!owner.send(msg.value)) {
293         TokenSendFail(msg.value);
294         revert();
295       }
296     }
297     function issueLeftToken() internal {
298       if(isLeftTokenIssued) {
299         CommonError("Left tokens has been issued!");
300       }
301       else {
302         require(totalEthAmount >= ETH_MIN_GOAL);
303         uint leftTokenAmount = totalSupply.mul(UNSOLD_SOLD_RATIO).div(100);
304         totalSupply = totalSupply.add(leftTokenAmount);
305         balances[owner] = balances[owner].add(leftTokenAmount);
306         IssueToken(tokenIssueIndex++, owner, 0, leftTokenAmount);
307         isLeftTokenIssued = true;
308       }
309     }
310     function BitnanRewardToken(address _owner) {
311       owner = _owner;
312     }
313     function start(uint _startBlock) public onlyOwner beforeSale {
314       startBlock = _startBlock;
315       TokenSaleStart();
316     }
317     function close() public onlyOwner afterSale {
318       if(totalEthAmount < ETH_MIN_GOAL) {
319         TokenSaleFail();
320       }
321       else {
322         issueLeftToken();
323         TokenSaleSucceed();
324       }
325     }
326     function generateTokenAmount(uint ethAmount) internal constant returns (uint tokenAmount) {
327       uint phase = (block.number - startBlock).div(BLOCKS_PER_PHASE);
328       if(phase >= bonusPercents.length) {
329         phase = bonusPercents.length - 1;
330       }
331       uint originTokenAmount = ethAmount.mul(ORIGIN_ETH_BRT_RATIO);
332       uint bonusTokenAmount = originTokenAmount.mul(bonusPercents[phase]).div(100);
333       tokenAmount = originTokenAmount.add(bonusTokenAmount);
334     }
335     /* constant functions */
336     function saleInProgress() constant returns (bool) {
337       return (startBlock > 0 && block.number >= startBlock);
338     }
339     function saleOver() constant returns (bool) {
340       return startBlock > 0 && (saleOverInTime() || saleOverReachMaxETH());
341     }
342     function saleOverInTime() constant returns (bool) {
343       return block.number >= startBlock + BLOCKS_PER_PHASE * PHASE_NUMBER;
344     }
345     function saleOverReachMaxETH() constant returns (bool) {
346       return totalEthAmount >= ETH_MAX_GOAL;
347     }
348 }