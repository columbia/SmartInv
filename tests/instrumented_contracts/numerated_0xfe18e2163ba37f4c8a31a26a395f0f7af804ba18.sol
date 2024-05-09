1 pragma solidity ^0.4.16;
2 
3 library SafeMath {
4   function mul(uint256 a, uint256 b) internal constant returns (uint256) {
5     uint256 c = a * b;
6     assert(a == 0 || c / a == b);
7     return c;
8   }
9 
10   function div(uint256 a, uint256 b) internal constant returns (uint256) {
11     // assert(b > 0); // Solidity automatically throws when dividing by 0
12     uint256 c = a / b;
13     // assert(a == b * c + a % b); // There is no case in which this doesn't hold
14     return c;
15   }
16 
17   function sub(uint256 a, uint256 b) internal constant returns (uint256) {
18     assert(b <= a);
19     return a - b;
20   }
21 
22   function add(uint256 a, uint256 b) internal constant returns (uint256) {
23     uint256 c = a + b;
24     assert(c >= a);
25     return c;
26   }
27 
28 }
29 
30 contract Ownable {
31   address public owner;
32 
33   /**
34    * @dev The Ownable constructor sets the original `owner` of the contract to the sender
35    * account.
36    */
37   function Ownable() {
38     owner = msg.sender;
39   }
40 
41   /**
42    * @dev Throws if called by any account other than the owner.
43    */
44   modifier onlyOwner() {
45     require(msg.sender == owner);
46     _;
47   }
48 
49   function transferOwnership(address newOwner) onlyOwner {
50     if (newOwner != address(0)) {
51       owner = newOwner;
52     }
53   }
54 
55 }
56 
57 contract Pausable is Ownable {
58   event Pause();
59   event Unpause();
60 
61   bool public paused = false;
62   /**
63    * @dev Modifier to make a function callable only when the contract is not paused.
64    */
65   modifier whenNotPaused() {
66     require(!paused);
67     _;
68   }
69 
70   /**
71    * @dev Modifier to make a function callable only when the contract is paused.
72    */
73   modifier whenPaused() {
74     require(paused);
75     _;
76   }
77 
78   /**
79    * @dev called by the owner to pause, triggers stopped state
80    */
81   function pause() onlyOwner whenNotPaused public {
82     paused = true;
83     Pause();
84   }
85 
86   /**
87    * @dev called by the owner to unpause, returns to normal state
88    */
89   function unpause() onlyOwner whenPaused public {
90     paused = false;
91     Unpause();
92   }
93 }
94 
95 contract ERC20Basic is Pausable {
96   uint256 public totalSupply;
97   function balanceOf(address who) constant returns (uint256);
98   function transfer(address to, uint256 value) returns (bool);
99   event Transfer(address indexed from, address indexed to, uint256 tokens);
100 }
101 
102 contract BasicToken is ERC20Basic {
103   using SafeMath for uint256;
104 
105   mapping(address => uint256) balances;
106   address public voiceOfSteelTokenAddress;
107   uint256 noEther = 0;
108 
109   string public name = "Voice of Steel Token";
110   uint8 public decimals = 18;
111   string public symbol = "VST";
112 
113   address public enterWallet = 0xD7F68D64719401853eC60173891DC1AA7c0ecd71;
114   address public investWallet = 0x14c7FBA3C597b53571169Ae2c40CC765303932aE;
115   address public exitWallet = 0xD7F68D64719401853eC60173891DC1AA7c0ecd71;
116   uint256 public priceEthPerToken = 10000;
117   
118   uint256 public investCommission = 50;
119   uint256 public withdrawCommission = 100;
120   bool public availableWithdrawal = false;
121   
122   event MoreData(uint256 ethAmount, uint256 price);
123 
124   /**
125   * @dev transfer token for a specified address
126   * @param _to The address to transfer to.
127   * @param _value The amount to be transferred.
128   */
129   function transfer(address _to, uint256 _value) whenNotPaused returns (bool) {
130     
131     require(_to != address(0));
132     require(_value <= balances[msg.sender]);
133 
134     if (_to == voiceOfSteelTokenAddress && availableWithdrawal) {
135 
136       uint256 weiAmount = _value.mul(withdrawCommission).div(priceEthPerToken);
137 
138       balances[msg.sender] = balances[msg.sender].sub(_value);
139       totalSupply = totalSupply.sub(_value);
140 
141       msg.sender.transfer(weiAmount);
142       exitWallet.transfer(weiAmount.div(100).mul(uint256(100).sub(withdrawCommission)));
143 
144       Transfer(msg.sender, voiceOfSteelTokenAddress, _value);
145       MoreData(weiAmount, priceEthPerToken);
146       return true;
147 
148     } else {
149       balances[msg.sender] = balances[msg.sender].sub(_value);
150       balances[_to] = balances[_to].add(_value);
151       Transfer(msg.sender, _to, _value);
152       MoreData(0, priceEthPerToken);
153       return true;
154     }
155   }
156 
157   /**
158   * @dev Gets the balance of the specified address.
159   * @param _owner The address to query the the balance of. 
160   * @return An uint256 representing the amount owned by the passed address.
161   */
162   function balanceOf(address _owner) constant returns (uint256 balance) {
163     return balances[_owner];
164   }
165 
166 }
167 
168 contract ERC20 is ERC20Basic {
169   function allowance(address owner, address spender) constant returns (uint256);
170   function transferFrom(address from, address to, uint256 value) returns (bool);
171   function approve(address spender, uint256 value) returns (bool);
172   event Approval(address indexed owner, address indexed spender, uint256 value);
173 }
174 
175 contract StandardToken is ERC20, BasicToken {
176 
177   mapping (address => mapping (address => uint256)) allowed;
178 
179   function transferFrom(address _from, address _to, uint256 _value) whenNotPaused returns (bool) {
180     
181     require(_to != address(0));
182     require(_value <= balances[_from]);
183     require(_value <= allowed[_from][msg.sender]);
184 
185     if (_to == voiceOfSteelTokenAddress && availableWithdrawal) {
186 
187       uint256 weiAmount = _value.mul(withdrawCommission).div(priceEthPerToken);
188 
189       balances[_from] = balances[_from].sub(_value);
190       allowed[_from][msg.sender] = allowed[_from][msg.sender].sub(_value);
191 
192       msg.sender.transfer(weiAmount);
193       exitWallet.transfer(weiAmount.div(100).mul(uint256(100).sub(withdrawCommission)));
194 
195       Transfer(_from, voiceOfSteelTokenAddress, _value);
196       MoreData(weiAmount, priceEthPerToken);
197       return true;
198 
199     } else {
200         balances[_to] = balances[_to].add(_value);
201         balances[_from] = balances[_from].sub(_value);
202         allowed[_from][msg.sender] = allowed[_from][msg.sender].sub(_value);
203         Transfer(_from, _to, _value);
204         MoreData(0, priceEthPerToken);
205         return true;
206     }
207   }
208 
209   /**
210    * @dev Aprove the passed address to spend the specified amount of tokens on behalf of msg.sender.
211    * @param _spender The address which will spend the funds.
212    * @param _value The amount of tokens to be spent.
213    */
214   function approve(address _spender, uint256 _value) returns (bool) {
215 
216     // To change the approve amount you first have to reduce the addresses`
217     //  allowance to zero by calling `approve(_spender, 0)` if it is not
218     //  already 0 to mitigate the race condition described here:
219     //  https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
220     require((_value == 0) || (allowed[msg.sender][_spender] == 0));
221 
222     allowed[msg.sender][_spender] = _value;
223     Approval(msg.sender, _spender, _value);
224     return true;
225   }
226 
227   /**
228    * @dev Function to check the amount of tokens that an owner allowed to a spender.
229    * @param _owner address The address which owns the funds.
230    * @param _spender address The address which will spend the funds.
231    * @return A uint256 specifing the amount of tokens still avaible for the spender.
232    */
233   function allowance(address _owner, address _spender) constant returns (uint256 remaining) {
234     return allowed[_owner][_spender];
235   }
236 
237 }
238 
239 contract VoiceOfSteelToken is StandardToken {
240 
241   uint256 public minimalAmout = 1000000000000000000;
242     
243   function () payable whenNotPaused {
244     require(msg.value >= minimalAmout);
245     
246     uint256 amount = msg.value;
247     address investor = msg.sender;
248     
249     uint256 tokens = amount.mul(priceEthPerToken).div(10000);
250     
251     totalSupply = totalSupply.add(tokens);
252     balances[investor] = balances[investor].add(tokens);
253 
254     uint256 fisrtAmount = amount.div(100).mul(investCommission);
255     investWallet.transfer(fisrtAmount);
256     uint256 leftAmount = amount.sub(fisrtAmount);
257     enterWallet.transfer(leftAmount);
258     
259     Transfer(voiceOfSteelTokenAddress, investor, tokens);
260     MoreData(amount, priceEthPerToken);
261     
262   }
263 
264   function setVoiceOfSteelTokenAddress(address _address) onlyOwner {
265     voiceOfSteelTokenAddress = _address;
266   }
267 
268   function addEther() payable onlyOwner {}
269 
270   function deleteInvestorTokens(address investor, uint256 tokens) onlyOwner {
271     require(tokens <= balances[investor]);
272 
273     balances[investor] = balances[investor].sub(tokens);
274     totalSupply = totalSupply.sub(tokens);
275     Transfer(investor, voiceOfSteelTokenAddress, tokens);
276     MoreData(0, priceEthPerToken);
277   }
278 
279   function setNewPrice(uint256 _ethPerToken) onlyOwner {
280     priceEthPerToken = _ethPerToken;
281   }
282 
283   function getWei(uint256 weiAmount) onlyOwner {
284     owner.transfer(weiAmount);
285   }
286 
287   function airdrop(address[] _array1, uint256[] _array2) onlyOwner {
288     address[] memory arrayAddress = _array1;
289     uint256[] memory arrayAmount = _array2;
290     uint256 arrayLength = arrayAddress.length.sub(1);
291     uint256 i = 0;
292      
293     while (i <= arrayLength) {
294         totalSupply = totalSupply.add(arrayAmount[i]);
295         balances[arrayAddress[i]] = balances[arrayAddress[i]].add(arrayAmount[i]);
296         Transfer(voiceOfSteelTokenAddress, arrayAddress[i], arrayAmount[i]);
297         MoreData(0, priceEthPerToken);
298         i = i.add(1);
299     }  
300   }
301   
302   function setNewMinimalAmount(uint256 _newMinimalAmout) onlyOwner {
303     minimalAmout = _newMinimalAmout;
304   }
305   
306   function setNewInvestCommission(uint256 _newInvestCommission) onlyOwner {
307     investCommission = _newInvestCommission;
308   }
309   
310   function setNewAvailableWithdrawal(bool _newAvailableWithdrawal) onlyOwner {
311     availableWithdrawal = _newAvailableWithdrawal;
312   }
313   
314   function setNewWithdrawCommission(uint256 _newWithdrawCommission) onlyOwner {
315     withdrawCommission = _newWithdrawCommission;
316   }
317   
318   function newEnterWallet(address _enterWallet) onlyOwner {
319     enterWallet = _enterWallet;
320   }
321   
322   function newInvestWallet(address _investWallet) onlyOwner {
323     investWallet = _investWallet;
324   }
325   
326   function newExitWallet(address _exitWallet) onlyOwner {
327     exitWallet = _exitWallet;
328   }
329   
330 }