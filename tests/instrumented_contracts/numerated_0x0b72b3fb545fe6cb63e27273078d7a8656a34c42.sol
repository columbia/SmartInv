1 pragma solidity ^0.4.21;
2 
3 /**
4  * Changes by https://www.docademic.com/
5  */
6  
7  /**
8  * @title SafeMath
9  * @dev Math operations with safety checks that throw on error
10  */
11 library SafeMath {
12   function mul(uint256 a, uint256 b) internal pure returns (uint256) {
13     if (a == 0) {
14       return 0;
15     }
16     uint256 c = a * b;
17     assert(c / a == b);
18     return c;
19   }
20 
21   function div(uint256 a, uint256 b) internal pure returns (uint256) {
22     // assert(b > 0); // Solidity automatically throws when dividing by 0
23     uint256 c = a / b;
24     // assert(a == b * c + a % b); // There is no case in which this doesn't hold
25     return c;
26   }
27 
28   function sub(uint256 a, uint256 b) internal pure returns (uint256) {
29     assert(b <= a);
30     return a - b;
31   }
32 
33   function add(uint256 a, uint256 b) internal pure returns (uint256) {
34     uint256 c = a + b;
35     assert(c >= a);
36     return c;
37   }
38 }
39 
40 /**
41  * @title Ownable
42  * @dev The Ownable contract has an owner address, and provides basic authorization control
43  * functions, this simplifies the implementation of "user permissions".
44  */
45 contract Ownable {
46   address public owner;
47 
48   event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
49 
50   /**
51    * @dev The Ownable constructor sets the original `owner` of the contract to the sender
52    * account.
53    */
54   function Ownable() public {
55     owner = msg.sender;
56   }
57 
58   /**
59    * @dev Throws if called by any account other than the owner.
60    */
61   modifier onlyOwner() {
62     require(msg.sender == owner);
63     _;
64   }
65 
66   /**
67    * @dev Allows the current owner to transfer control of the contract to a newOwner.
68    * @param newOwner The address to transfer ownership to.
69    */
70   function transferOwnership(address newOwner) public onlyOwner {
71     require(newOwner != address(0));
72     emit OwnershipTransferred(owner, newOwner);
73     owner = newOwner;
74   }
75 }
76 
77 contract Destroyable is Ownable{
78     /**
79      * @notice Allows to destroy the contract and return the tokens to the owner.
80      */
81     function destroy() public onlyOwner{
82         selfdestruct(owner);
83     }
84 }
85 
86 interface Token {
87     function transfer(address _to, uint256 _value) external returns (bool);
88 
89     function balanceOf(address who) view external returns (uint256);
90 }
91 
92 contract Airdrop is Ownable, Destroyable {
93     using SafeMath for uint256;
94 
95     /*
96      *   Structures
97      */
98     // Holder of tokens
99     struct Beneficiary {
100         uint256 balance;
101         uint256 airdrop;
102         bool isBeneficiary;
103     }
104 
105     /*
106      *  State
107      */
108     bool public filled;
109     bool public airdropped;
110     uint256 public airdropLimit;
111     uint256 public currentCirculating;
112     uint256 public burn;
113     address public hell;
114     address[] public addresses;
115     Token public token;
116     mapping(address => Beneficiary) public beneficiaries;
117 
118 
119     /*
120      *  Events
121      */
122     event NewBeneficiary(address _beneficiary);
123     event SnapshotTaken(uint256 _totalBalance, uint256 _totalAirdrop, uint256 _toBurn,uint256 _numberOfBeneficiaries, uint256 _numberOfAirdrops);
124     event Airdropped(uint256 _totalAirdrop, uint256 _numberOfAirdrops);
125     event TokenChanged(address _prevToken, address _token);
126     event AirdropLimitChanged(uint256 _prevLimit, uint256 _airdropLimit);
127     event CurrentCirculatingChanged(uint256 _prevCirculating, uint256 _currentCirculating);
128     event Cleaned(uint256 _numberOfBeneficiaries);
129     event Burned(uint256 _tokensBurned);
130 
131     /*
132      *  Modifiers
133      */
134     modifier isNotBeneficiary(address _beneficiary) {
135         require(!beneficiaries[_beneficiary].isBeneficiary);
136         _;
137     }
138     modifier isBeneficiary(address _beneficiary) {
139         require(beneficiaries[_beneficiary].isBeneficiary);
140         _;
141     }
142     modifier isFilled() {
143         require(filled);
144         _;
145     }
146     modifier isNotFilled() {
147         require(!filled);
148         _;
149     }
150     modifier wasAirdropped() {
151         require(airdropped);
152         _;
153     }
154     modifier wasNotAirdropped() {
155         require(!airdropped);
156         _;
157     }
158 
159     /*
160      *  Behavior
161      */
162 
163     /**
164      * @dev Constructor.
165      * @param _token The token address
166      * @param _airdropLimit The token limit by airdrop in wei
167      * @param _currentCirculating The current circulating tokens in wei
168      * @param _hell The address where tokens wil be burned
169      */
170     function Airdrop(address _token, uint256 _airdropLimit, uint256 _currentCirculating, address _hell) public{
171         require(_token != address(0));
172         token = Token(_token);
173         airdropLimit = _airdropLimit;
174         currentCirculating = _currentCirculating;
175         hell = _hell;
176     }
177 
178     /**
179      * @dev Allows the sender to register itself as a beneficiary for the airdrop.
180      */
181     function() payable public {
182         addBeneficiary(msg.sender);
183     }
184 
185 
186     /**
187      * @dev Allows the sender to register itself as a beneficiary for the airdrop.
188      */
189     function register() public {
190         addBeneficiary(msg.sender);
191     }
192 
193     /**
194      * @dev Allows the owner to register a beneficiary for the airdrop.
195      * @param _beneficiary The address of the beneficiary
196      */
197     function registerBeneficiary(address _beneficiary) public
198     onlyOwner {
199         addBeneficiary(_beneficiary);
200     }
201 
202     /**
203      * @dev Allows the owner to register beneficiaries for the airdrop.
204      * @param _beneficiaries The array of addresses
205      */
206     function registerBeneficiaries(address[] _beneficiaries) public
207     onlyOwner {
208         for (uint i = 0; i < _beneficiaries.length; i++) {
209             addBeneficiary(_beneficiaries[i]);
210         }
211     }
212 
213     /**
214      * @dev Add a beneficiary for the airdrop.
215      * @param _beneficiary The address of the beneficiary
216      */
217     function addBeneficiary(address _beneficiary) private
218     isNotBeneficiary(_beneficiary) {
219         require(_beneficiary != address(0));
220         beneficiaries[_beneficiary] = Beneficiary({
221             balance : 0,
222             airdrop : 0,
223             isBeneficiary : true
224             });
225         addresses.push(_beneficiary);
226         emit NewBeneficiary(_beneficiary);
227     }
228 
229     /**
230      * @dev Take the balance of all the beneficiaries.
231      */
232     function takeSnapshot() public
233     onlyOwner
234     isNotFilled
235     wasNotAirdropped {
236         uint256 totalBalance = 0;
237         uint256 totalAirdrop = 0;
238         uint256 airdrops = 0;
239         for (uint i = 0; i < addresses.length; i++) {
240             Beneficiary storage beneficiary = beneficiaries[addresses[i]];
241             beneficiary.balance = token.balanceOf(addresses[i]);
242             totalBalance = totalBalance.add(beneficiary.balance);
243             if (beneficiary.balance > 0) {
244                 beneficiary.airdrop = (beneficiary.balance.mul(airdropLimit).div(currentCirculating));
245                 totalAirdrop = totalAirdrop.add(beneficiary.airdrop);
246                 airdrops = airdrops.add(1);
247             }
248         }
249         filled = true;
250         burn = airdropLimit.sub(totalAirdrop);
251         emit SnapshotTaken(totalBalance, totalAirdrop, burn, addresses.length, airdrops);
252     }
253 
254     /**
255      * @dev Start the airdrop.
256      */
257     function airdropAndBurn() public
258     onlyOwner
259     isFilled
260     wasNotAirdropped {
261         uint256 airdrops = 0;
262         uint256 totalAirdrop = 0;
263         for (uint256 i = 0; i < addresses.length; i++)
264         {
265             Beneficiary storage beneficiary = beneficiaries[addresses[i]];
266             if (beneficiary.airdrop > 0) {
267                 require(token.transfer(addresses[i], beneficiary.airdrop));
268                 totalAirdrop = totalAirdrop.add(beneficiary.airdrop);
269                 airdrops = airdrops.add(1);
270             }
271         }
272         airdropped = true;
273         currentCirculating = currentCirculating.add(totalAirdrop);
274         emit Airdropped(totalAirdrop, airdrops);
275         emit Burned(burn);
276         token.transfer(hell, burn);
277 
278     }
279 
280     /**
281      * @dev Reset all the balances to 0 and the state to false.
282      */
283     function clean() public
284     onlyOwner {
285         for (uint256 i = 0; i < addresses.length; i++)
286         {
287             Beneficiary storage beneficiary = beneficiaries[addresses[i]];
288             beneficiary.balance = 0;
289             beneficiary.airdrop = 0;
290         }
291         filled = false;
292         airdropped = false;
293         burn = 0;
294         emit Cleaned(addresses.length);
295     }
296 
297     /**
298      * @dev Allows the owner to change the token address.
299      * @param _token New token address.
300      */
301     function changeToken(address _token) public
302     onlyOwner {
303         emit TokenChanged(address(token), _token);
304         token = Token(_token);
305     }
306 
307     /**
308      * @dev Allows the owner to change the token limit by airdrop.
309      * @param _airdropLimit The token limit by airdrop in wei.
310      */
311     function changeAirdropLimit(uint256 _airdropLimit) public
312     onlyOwner {
313         emit AirdropLimitChanged(airdropLimit, _airdropLimit);
314         airdropLimit = _airdropLimit;
315     }
316 
317     /**
318      * @dev Allows the owner to change the token limit by airdrop.
319      * @param _currentCirculating The current circulating tokens in wei.
320      */
321     function changeCurrentCirculating(uint256 _currentCirculating) public
322     onlyOwner {
323         emit CurrentCirculatingChanged(currentCirculating, _currentCirculating);
324         currentCirculating = _currentCirculating;
325     }
326 
327     /**
328      * @dev Allows the owner to flush the eth.
329      */
330     function flushEth() public onlyOwner {
331         owner.transfer(address(this).balance);
332     }
333 
334     /**
335      * @dev Allows the owner to flush the tokens of the contract.
336      */
337     function flushTokens() public onlyOwner {
338         token.transfer(owner, token.balanceOf(address(this)));
339     }
340 
341     /**
342      * @dev Allows the owner to destroy the contract and return the tokens to the owner.
343      */
344     function destroy() public onlyOwner {
345         token.transfer(owner, token.balanceOf(address(this)));
346         selfdestruct(owner);
347     }
348 
349     /**
350      * @dev Get the token balance of the contract.
351      * @return _balance The token balance of this contract
352      */
353     function tokenBalance() view public returns (uint256 _balance) {
354         return token.balanceOf(address(this));
355     }
356 
357     /**
358      * @dev Get the token balance of the beneficiary.
359      * @param _beneficiary The address of the beneficiary
360      * @return _balance The token balance of the beneficiary
361      */
362     function getBalanceAtSnapshot(address _beneficiary) view public returns (uint256 _balance) {
363         return beneficiaries[_beneficiary].balance / 1 ether;
364     }
365 
366     /**
367      * @dev Get the airdrop reward of the beneficiary.
368      * @param _beneficiary The address of the beneficiary
369      * @return _airdrop The token balance of the beneficiary
370      */
371     function getAirdropAtSnapshot(address _beneficiary) view public returns (uint256 _airdrop) {
372         return beneficiaries[_beneficiary].airdrop / 1 ether;
373     }
374 
375     /**
376      * @dev Allows a beneficiary to verify if he is already registered.
377      * @param _beneficiary The address of the beneficiary
378      * @return _isBeneficiary The boolean value
379      */
380     function amIBeneficiary(address _beneficiary) view public returns (bool _isBeneficiary) {
381         return beneficiaries[_beneficiary].isBeneficiary;
382     }
383 
384     /**
385      * @dev Get the number of beneficiaries.
386      * @return _length The number of beneficiaries
387      */
388     function beneficiariesLength() view public returns (uint256 _length) {
389         return addresses.length;
390     }
391 }