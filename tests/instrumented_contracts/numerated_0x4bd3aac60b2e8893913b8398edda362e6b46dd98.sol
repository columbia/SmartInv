1 pragma solidity ^0.4.23;
2 
3 // File: contracts/Utils/Math.sol
4 
5 library MathUtils {
6     function add(uint a, uint b) internal pure returns (uint) {
7         uint result = a + b;
8 
9         if (a == 0 || b == 0) {
10             return result;
11         }
12 
13         require(result > a && result > b);
14 
15         return result;
16     }
17 
18     function sub(uint a, uint b) internal pure returns (uint) {
19         require(a >= b);
20 
21         return a - b;
22     }
23 
24     function mul(uint a, uint b) internal pure returns (uint) {
25         if (a == 0 || b == 0) {
26             return 0;
27         }
28 
29         uint result = a * b;
30 
31         require(result / a == b);
32 
33         return result;
34     }
35 }
36 
37 // File: contracts/Token/Balance.sol
38 
39 contract Balance {
40     mapping(address => uint) public balances;
41 
42     // ERC20 function
43     function balanceOf(address account) public constant returns (uint) {
44         return balances[account];
45     }
46 
47     modifier hasSufficientBalance(address account, uint balance) {
48         require(balances[account] >= balance);
49         _;
50     }
51 }
52 
53 // File: contracts/Utils/Ownable.sol
54 
55 contract Ownable {
56     address public owner;
57 
58     constructor() public {
59         owner = msg.sender;
60     }
61 
62     function isOwner() view public returns (bool) {
63         return msg.sender == owner;
64     }
65 
66     modifier grantOwner {
67         require(isOwner());
68         _;
69     }
70 }
71 
72 // File: contracts/Token/CrowdsaleState.sol
73 
74 interface CrowdsaleState {
75     function isCrowdsaleSuccessful() external view returns(bool);
76 }
77 
78 // File: contracts/Token/HardCap.sol
79 
80 interface HardCap {
81     function getHardCap() external pure returns(uint);
82 }
83 
84 // File: contracts/Token/Crowdsale.sol
85 
86 contract Crowdsale is Ownable {
87     address public crowdsaleContract;
88 
89     function isCrowdsale() internal view returns(bool) {
90         return crowdsaleSet() && msg.sender == crowdsaleContract;
91     }
92 
93     function crowdsaleSet() internal view returns(bool) {
94         return crowdsaleContract != address(0);
95     }
96 
97     function addressIsCrowdsale(address _address) public view returns(bool) {
98         return crowdsaleSet() && crowdsaleContract == _address;
99     }
100 
101     function setCrowdsaleContract(address crowdsale) public grantOwner {
102         require(crowdsaleContract == address(0));
103         crowdsaleContract = crowdsale;
104     }
105 
106     function crowdsaleSuccessful() internal view returns(bool) {
107         require(crowdsaleSet());
108         return CrowdsaleState(crowdsaleContract).isCrowdsaleSuccessful();
109     }
110 
111     function getCrowdsaleHardCap() internal view returns(uint) {
112         require(crowdsaleSet());
113         return HardCap(crowdsaleContract).getHardCap();
114     }
115 }
116 
117 // File: contracts/Token/TotalSupply.sol
118 
119 contract TotalSupply {
120     uint public totalSupply = 1000000000 * 10**18;
121 
122     // ERC20 function
123     function totalSupply() external constant returns (uint) {
124         return totalSupply;
125     }
126 }
127 
128 // File: contracts/Token/Burnable.sol
129 
130 contract Burnable is TotalSupply, Balance, Ownable, Crowdsale {
131     using MathUtils for uint;
132 
133     event Burn(address account, uint value);
134 
135     function burn(uint amount) public grantBurner hasSufficientBalance(msg.sender, amount) {
136         balances[msg.sender] = balances[msg.sender].sub(amount);
137         totalSupply = totalSupply.sub(amount);
138         emit Burn(msg.sender, amount);
139     }
140 
141     modifier grantBurner {
142         require(isCrowdsale());
143         _;
144     }
145 }
146 
147 // File: contracts/Token/TokenRecipient.sol
148 
149 interface TokenRecipient {
150     function receiveApproval(address _from, uint256 _value, address _token, bytes _extraData) external;
151 }
152 
153 // File: contracts/Token/CryptoPoliceOfficerToken.sol
154 
155 /// ERC20 compliant token contract
156 contract CryptoPoliceOfficerToken is TotalSupply, Balance, Burnable {
157     using MathUtils for uint;
158 
159     string public name;
160     string public symbol;
161     uint8 public decimals = 18;
162 
163     mapping(address => mapping(address => uint)) allowances;
164     
165     bool public publicTransfersEnabled = false;
166     uint public releaseStartTime;
167 
168     uint public lockedAmount;
169     TokenLock[] public locks;
170 
171     struct TokenLock {
172         uint amount;
173         uint timespan;
174         bool released;
175     }
176 
177     event Transfer(
178         address indexed fromAccount,
179         address indexed destination,
180         uint amount
181     );
182     
183     event Approval(
184         address indexed fromAccount,
185         address indexed destination,
186         uint amount
187     );
188     
189     constructor(
190         string tokenName,
191         string tokenSymbol
192     )
193         public
194     {
195         name = tokenName;
196         symbol = tokenSymbol;
197         balances[msg.sender] = totalSupply;
198     }
199     
200     function _transfer(
201         address source,
202         address destination,
203         uint amount
204     )
205         internal
206         hasSufficientBalance(source, amount)
207         whenTransferable(destination)
208         hasUnlockedAmount(source, amount)
209     {
210         require(destination != address(this) && destination != 0x0);
211 
212         if (amount > 0) {
213             balances[source] -= amount;
214             balances[destination] = balances[destination].add(amount);
215         }
216 
217         emit Transfer(source, destination, amount);
218     }
219 
220     function transfer(address destination, uint amount)
221     public returns (bool)
222     {
223         _transfer(msg.sender, destination, amount);
224         return true;
225     }
226 
227     function transferFrom(
228         address source,
229         address destination,
230         uint amount
231     )
232         public returns (bool)
233     {
234         require(allowances[source][msg.sender] >= amount);
235 
236         allowances[source][msg.sender] -= amount;
237 
238         _transfer(source, destination, amount);
239         
240         return true;
241     }
242     
243     /**
244      * Allow destination address to withdraw funds from account that is caller
245      * of this function
246      *
247      * @param destination The one who receives permission
248      * @param amount How much funds can be withdrawn
249      * @return Whether or not approval was successful
250      */
251     function approve(
252         address destination,
253         uint amount
254     )
255         public returns (bool)
256     {
257         allowances[msg.sender][destination] = amount;
258         emit Approval(msg.sender, destination, amount);
259         
260         return true;
261     }
262     
263     function allowance(
264         address fromAccount,
265         address destination
266     )
267         public constant returns (uint)
268     {
269         return allowances[fromAccount][destination];
270     }
271 
272     function approveAndCall(
273         address _spender,
274         uint256 _value,
275         bytes _extraData
276     )
277         public
278         returns (bool)
279     {
280         TokenRecipient spender = TokenRecipient(_spender);
281 
282         if (approve(_spender, _value)) {
283             spender.receiveApproval(msg.sender, _value, this, _extraData);
284             return true;
285         }
286 
287         return false;
288     }
289 
290     function enablePublicTransfers()
291     public grantOwner
292     {
293         require(crowdsaleSuccessful());
294         
295         publicTransfersEnabled = true;
296         releaseStartTime = now;
297     }
298 
299     function addTokenLock(uint amount, uint timespan)
300     public grantOwner
301     {
302         require(releaseStartTime == 0);
303         requireOwnerUnlockedAmount(amount);
304 
305         locks.push(TokenLock({
306             amount: amount,
307             timespan: timespan,
308             released: false
309         }));
310 
311         lockedAmount += amount;
312     }
313 
314     function releaseLockedTokens(uint8 idx)
315     public grantOwner
316     {
317         require(releaseStartTime > 0);
318         require(!locks[idx].released);
319         require((releaseStartTime + locks[idx].timespan) < now);
320 
321         locks[idx].released = true;
322         lockedAmount -= locks[idx].amount;
323     }
324 
325     function requireOwnerUnlockedAmount(uint amount)
326     internal view
327     {
328         require(balanceOf(owner).sub(lockedAmount) >= amount);
329     }
330 
331     function setCrowdsaleContract(address crowdsale)
332     public grantOwner
333     {
334         super.setCrowdsaleContract(crowdsale);
335         transfer(crowdsale, getCrowdsaleHardCap());
336     }
337 
338     modifier hasUnlockedAmount(address account, uint amount) {
339         if (owner == account) {
340             requireOwnerUnlockedAmount(amount);
341         }
342         _;
343     }
344 
345     modifier whenTransferable(address destination) {
346         require(publicTransfersEnabled
347             || isCrowdsale()
348             || (isOwner() && addressIsCrowdsale(destination) && balanceOf(crowdsaleContract) == 0)
349             || (isOwner() && !crowdsaleSet())
350         );
351         _;
352     }
353 }