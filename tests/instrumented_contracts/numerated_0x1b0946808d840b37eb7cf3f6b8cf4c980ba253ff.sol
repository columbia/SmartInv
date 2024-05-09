1 pragma solidity ^0.4.21;
2 
3 
4 /**
5 * @title SafeMath
6 * @dev Math operations with safety checks that throw on error
7 */
8 library SafeMath {
9     function mul(uint256 a, uint256 b) internal pure returns (uint256) {
10         uint256 c = a * b;
11         assert(a == 0 || c / a == b);
12         return c;
13     }
14 
15     function div(uint256 a, uint256 b) internal pure returns (uint256) {
16         // assert(b > 0); // Solidity automatically throws when dividing by 0
17         uint256 c = a / b;
18         // assert(a == b * c + a % b); // There is no case in which this doesn't hold
19         return c;
20     }
21 
22     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
23         assert(b <= a);
24         return a - b;
25     }
26 
27     function add(uint256 a, uint256 b) internal pure returns (uint256) {
28         uint256 c = a + b;
29         assert(c >= a);
30         return c;
31     }
32 }
33 
34 /**
35 * @title Ownable
36 * @dev The Ownable contract has an owner address, and provides basic authorization control 
37 * functions, this simplifies the implementation of "user permissions". 
38 */ 
39 contract Ownable {
40     address public owner;
41 
42 /** 
43 * @dev The Ownable constructor sets the original `owner` of the contract to the sender
44 * account.
45 */
46     constructor() public {
47         owner = msg.sender;
48     }
49 
50     /**
51     * @dev Throws if called by any account other than the owner.
52     */
53     modifier onlyOwner() {
54         require(msg.sender == owner);
55         _;
56     }
57 
58     /**
59     * @dev Allows the current owner to transfer control of the contract to a newOwner.
60     * @param newOwner The address to transfer ownership to.
61     */
62     function transferOwnership(address newOwner) public onlyOwner {
63         if (newOwner != address(0)) {
64             owner = newOwner;
65         }
66     }
67 }
68 
69 /**
70  * @title ERC20Basic
71     * @dev Simpler version of ERC20 interface
72        * @dev see https://github.com/ethereum/EIPs/issues/179
73           */
74 contract ERC20Basic {
75     uint256 public totalSupply;
76     function balanceOf(address who) public constant returns  (uint256);
77     function transfer(address to, uint256 value) public returns (bool);
78     event Transfer(address indexed from, address indexed to, uint256 value);
79 }
80 
81 /**
82  * @title Basic token
83     * @dev Basic version of StandardToken, with no allowances. 
84        */
85 contract BasicToken is ERC20Basic {
86   using SafeMath for uint256;
87 
88   mapping(address => uint256) balances;
89 
90   /**
91   * @dev transfer token for a specified address
92       * @param _to The address to transfer to.
93           * @param _value The amount to be transferred.
94               */
95   function transfer(address _to, uint256 _value) returns (bool) {
96     balances[msg.sender] = balances[msg.sender].sub(_value);
97     balances[_to] = balances[_to].add(_value);
98     Transfer(msg.sender, _to, _value);
99     return true;
100   }
101 
102   /**
103   * @dev Gets the balance of the specified address.
104       * @param _owner The address to query the the balance of. 
105           * @return An uint256 representing the amount owned by the passed address.
106               */
107   function balanceOf(address _owner) constant returns (uint256 balance) {
108     return balances[_owner];
109   }
110 }
111 
112 /**
113  * @title ERC20 interface
114     * @dev see https://github.com/ethereum/EIPs/issues/20
115        */
116 contract ERC20 is ERC20Basic {
117     function allowance(address owner, address spender) public constant returns (uint256);
118     function transferFrom(address from, address to, uint256 value) public returns (bool);
119     function approve(address spender, uint256 value) public returns (bool);
120     event Approval(address indexed owner, address indexed spender, uint256 value);
121 }
122 
123 /**
124  * @title Standard ERC20 token
125     *
126       * @dev Implementation of the basic standard token.
127          * @dev https://github.com/ethereum/EIPs/issues/20
128             * @dev Based on code by FirstBlood: https://github.com/Firstbloodio/token/blob/master/smart_contract/FirstBloodToken.sol
129                */
130 contract StandardToken is ERC20, BasicToken {
131 
132   mapping (address => mapping (address => uint256)) allowed;
133 
134 
135   /**
136    * @dev Transfer tokens from one address to another
137         * @param _from address The address which you want to send tokens from
138              * @param _to address The address which you want to transfer to
139                   * @param _value uint256 the amout of tokens to be transfered
140                        */
141   function transferFrom(address _from, address _to, uint256 _value) returns (bool) {
142     var _allowance = allowed[_from][msg.sender];
143 
144     // Check is not needed because sub(_allowance, _value) will already throw if this condition is not met
145     // require (_value <= _allowance);
146 
147     balances[_to] = balances[_to].add(_value);
148     balances[_from] = balances[_from].sub(_value);
149     allowed[_from][msg.sender] = _allowance.sub(_value);
150     Transfer(_from, _to, _value);
151     return true;
152   }
153 
154   /**
155    * @dev Aprove the passed address to spend the specified amount of tokens on behalf of msg.sender.
156         * @param _spender The address which will spend the funds.
157              * @param _value The amount of tokens to be spent.
158                   */
159   function approve(address _spender, uint256 _value) returns (bool) {
160 
161     // To change the approve amount you first have to reduce the addresses`
162     //  allowance to zero by calling `approve(_spender, 0)` if it is not
163     //  already 0 to mitigate the race condition described here:
164     //  https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
165     require((_value == 0) || (allowed[msg.sender][_spender] == 0));
166 
167     allowed[msg.sender][_spender] = _value;
168     Approval(msg.sender, _spender, _value);
169     return true;
170   }
171 
172   /**
173    * @dev Function to check the amount of tokens that an owner allowed to a spender.
174         * @param _owner address The address which owns the funds.
175              * @param _spender address The address which will spend the funds.
176                   * @return A uint256 specifing the amount of tokens still avaible for the spender.
177                        */
178   function allowance(address _owner, address _spender) constant returns (uint256 remaining) {
179     return allowed[_owner][_spender];
180   }
181 
182 }
183 
184 
185 /*Token  Contract*/
186 contract ZXCToken is StandardToken, Ownable {
187     using SafeMath for uint256;
188 
189     // Token 資訊
190     string  public constant name = "M726 Coin";
191     string  public constant symbol = "M726";
192     uint8   public constant decimals = 18;
193 
194     // Sale period1.
195     uint256 public startDate1;
196     uint256 public endDate1;
197 
198     // Sale period2.
199     uint256 public startDate2;
200     uint256 public endDate2;
201 
202      //目前銷售額
203     uint256 public saleCap;
204 
205     // Address Where Token are keep
206     address public tokenWallet;
207 
208     // Address where funds are collected.
209     address public fundWallet;
210 
211     // Amount of raised money in wei.
212     uint256 public weiRaised;
213 
214     // Event
215     event TokenPurchase(address indexed purchaser, uint256 value, uint256 amount);
216 
217     // Modifiers
218     modifier uninitialized() {
219         require(tokenWallet == 0x0);
220         require(fundWallet == 0x0);
221         _;
222     }
223 
224     constructor() public {}
225     // Trigger with Transfer event
226     // Fallback function can be used to buy tokens
227     function () public payable {
228         buyTokens(msg.sender, msg.value);
229     }
230 
231     //初始化合約
232     function initialize(address _tokenWallet, address _fundWallet, uint256 _start1, uint256 _end1,
233                         uint256 _saleCap, uint256 _totalSupply) public
234                         onlyOwner uninitialized {
235         //require(_start >= getCurrentTimestamp());
236         require(_start1 < _end1);
237         require(_tokenWallet != 0x0);
238         require(_fundWallet != 0x0);
239         require(_totalSupply >= _saleCap);
240 
241         startDate1 = _start1;
242         endDate1 = _end1;
243         saleCap = _saleCap;
244         tokenWallet = _tokenWallet;
245         fundWallet = _fundWallet;
246         totalSupply = _totalSupply;
247 
248         balances[tokenWallet] = saleCap;
249         balances[0xb1] = _totalSupply.sub(saleCap);
250     }
251 
252     //設定銷售期間
253     function setPeriod(uint period, uint256 _start, uint256 _end) public onlyOwner {
254         require(_end > _start);
255         if (period == 1) {
256             startDate1 = _start;
257             endDate1 = _end;
258         }else if (period == 2) {
259             require(_start > endDate1);
260             startDate2 = _start;
261             endDate2 = _end;      
262         }
263     }
264 
265     // For pushing pre-ICO records
266     function sendForPreICO(address buyer, uint256 amount) public onlyOwner {
267         require(saleCap >= amount);
268 
269         saleCap = saleCap - amount;
270         // Transfer
271         balances[tokenWallet] = balances[tokenWallet].sub(amount);
272         balances[buyer] = balances[buyer].add(amount);
273     }
274 
275         //Set SaleCap
276     function setSaleCap(uint256 _saleCap) public onlyOwner {
277         require(balances[0xb1].add(balances[tokenWallet]).sub(_saleCap) > 0);
278         uint256 amount=0;
279         //目前銷售額 大於 新銷售額
280         if (balances[tokenWallet] > _saleCap) {
281             amount = balances[tokenWallet].sub(_saleCap);
282             balances[0xb1] = balances[0xb1].add(amount);
283         } else {
284             amount = _saleCap.sub(balances[tokenWallet]);
285             balances[0xb1] = balances[0xb1].sub(amount);
286         }
287         balances[tokenWallet] = _saleCap;
288         saleCap = _saleCap;
289     }
290 
291     //Calcute Bouns
292     function getBonusByTime(uint256 atTime) public constant returns (uint256) {
293         if (atTime < startDate1) {
294             return 0;
295         } else if (endDate1 > atTime && atTime > startDate1) {
296             return 5000;
297         } else if (endDate2 > atTime && atTime > startDate2) {
298             return 2500;
299         } else {
300             return 0;
301         }
302     }
303 
304     function getBounsByAmount(uint256 etherAmount, uint256 tokenAmount) public pure returns (uint256) {
305         //最高40%
306         uint256 bonusRatio = etherAmount.div(500 ether);
307         if (bonusRatio > 4) {
308             bonusRatio = 4;
309         }
310         uint256 bonusCount = SafeMath.mul(bonusRatio, 10);
311         uint256 bouns = SafeMath.mul(tokenAmount, bonusCount);
312         uint256 realBouns = SafeMath.div(bouns, 100);
313         return realBouns;
314     }
315 
316     //終止合約
317     function finalize() public onlyOwner {
318         require(!saleActive());
319 
320         // Transfer the rest of token to tokenWallet
321         balances[tokenWallet] = balances[tokenWallet].add(balances[0xb1]);
322         balances[0xb1] = 0;
323     }
324     
325     //確認是否正常銷售
326     function saleActive() public constant returns (bool) {
327         return (
328             (getCurrentTimestamp() >= startDate1 &&
329                 getCurrentTimestamp() < endDate1 && saleCap > 0) ||
330             (getCurrentTimestamp() >= startDate2 &&
331                 getCurrentTimestamp() < endDate2 && saleCap > 0)
332                 );
333     }
334    
335     //Get CurrentTS
336     function getCurrentTimestamp() internal view returns (uint256) {
337         return now;
338     }
339 
340      //購買Token
341     function buyTokens(address sender, uint256 value) internal {
342         //Check Sale Status
343         require(saleActive());
344         
345         //Minum buying limit
346         require(value >= 0.5 ether);
347 
348         // Calculate token amount to be purchased
349         uint256 bonus = getBonusByTime(getCurrentTimestamp());
350         uint256 amount = value.mul(bonus);
351         // 第一階段銷售期，每次購買量超過500Ether，多增加10%
352         if (getCurrentTimestamp() >= startDate1 && getCurrentTimestamp() < endDate1) {
353             uint256 p1Bouns = getBounsByAmount(value, amount);
354             amount = amount + p1Bouns;
355         }
356         // We have enough token to sale
357         require(saleCap >= amount);
358 
359         // Transfer
360         balances[tokenWallet] = balances[tokenWallet].sub(amount);
361         balances[sender] = balances[sender].add(amount);
362         TokenPurchase(sender,value, amount);
363         
364         saleCap = saleCap - amount;
365 
366         // Update state.
367         weiRaised = weiRaised + value;
368 
369         // Forward the fund to fund collection wallet.
370         //tokenWallet.transfer(msg.value);
371         fundWallet.transfer(msg.value);
372     }   
373 }