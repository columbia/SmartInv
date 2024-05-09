1 pragma solidity ^0.4.21;
2 /**
3  * Changes by https://www.docademic.com/
4  */
5 
6 /**
7  * @title Ownable
8  * @dev The Ownable contract has an owner address, and provides basic authorization control
9  * functions, this simplifies the implementation of "user permissions".
10  */
11 contract Ownable {
12   address public owner;
13 
14   event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
15 
16   /**
17    * @dev The Ownable constructor sets the original `owner` of the contract to the sender
18    * account.
19    */
20   function Ownable() public {
21     owner = msg.sender;
22   }
23 
24   /**
25    * @dev Throws if called by any account other than the owner.
26    */
27   modifier onlyOwner() {
28     require(msg.sender == owner);
29     _;
30   }
31 
32   /**
33    * @dev Allows the current owner to transfer control of the contract to a newOwner.
34    * @param newOwner The address to transfer ownership to.
35    */
36   function transferOwnership(address newOwner) public onlyOwner {
37     require(newOwner != address(0));
38     emit OwnershipTransferred(owner, newOwner);
39     owner = newOwner;
40   }
41 }
42 
43 /**
44  * @title SafeMath
45  * @dev Math operations with safety checks that throw on error
46  */
47 library SafeMath {
48   function mul(uint256 a, uint256 b) internal pure returns (uint256) {
49     if (a == 0) {
50       return 0;
51     }
52     uint256 c = a * b;
53     assert(c / a == b);
54     return c;
55   }
56 
57   function div(uint256 a, uint256 b) internal pure returns (uint256) {
58     // assert(b > 0); // Solidity automatically throws when dividing by 0
59     uint256 c = a / b;
60     // assert(a == b * c + a % b); // There is no case in which this doesn't hold
61     return c;
62   }
63 
64   function sub(uint256 a, uint256 b) internal pure returns (uint256) {
65     assert(b <= a);
66     return a - b;
67   }
68 
69   function add(uint256 a, uint256 b) internal pure returns (uint256) {
70     uint256 c = a + b;
71     assert(c >= a);
72     return c;
73   }
74 }
75 
76 contract Destroyable is Ownable{
77     /**
78      * @notice Allows to destroy the contract and return the tokens to the owner.
79      */
80     function destroy() public onlyOwner{
81         selfdestruct(owner);
82     }
83 }
84 
85 interface Token {
86     function transfer(address _to, uint256 _value) external returns (bool);
87 
88     function balanceOf(address who) view external returns (uint256);
89 }
90 
91 contract Airdrop is Ownable, Destroyable {
92     using SafeMath for uint256;
93 
94     /*
95      *   Structures
96      */
97     // Holder of tokens
98     struct Beneficiary {
99         uint256 balance;
100         uint256 airdrop;
101         bool isBeneficiary;
102     }
103 
104     /*
105      *  State
106      */
107     bool public filled;
108     bool public airdropped;
109     uint256 public airdropLimit;
110     uint256 public currentCirculating;
111     uint256 public toVault;
112     address public vault;
113     address[] public addresses;
114     Token public token;
115     mapping(address => Beneficiary) public beneficiaries;
116 
117 
118     /*
119      *  Events
120      */
121     event NewBeneficiary(address _beneficiary);
122     event SnapshotTaken(uint256 _totalBalance, uint256 _totalAirdrop, uint256 _toBurn,uint256 _numberOfBeneficiaries, uint256 _numberOfAirdrops);
123     event Airdropped(uint256 _totalAirdrop, uint256 _numberOfAirdrops);
124     event TokenChanged(address _prevToken, address _token);
125     event VaultChanged(address _prevVault, address _vault);
126     event AirdropLimitChanged(uint256 _prevLimit, uint256 _airdropLimit);
127     event CurrentCirculatingChanged(uint256 _prevCirculating, uint256 _currentCirculating);
128     event Cleaned(uint256 _numberOfBeneficiaries);
129     event Vaulted(uint256 _tokensBurned);
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
168      * @param _vault The address where tokens will be vaulted
169      */
170     function Airdrop(address _token, uint256 _airdropLimit, uint256 _currentCirculating, address _vault) public{
171         require(_token != address(0));
172         token = Token(_token);
173         airdropLimit = _airdropLimit;
174         currentCirculating = _currentCirculating;
175         vault = _vault;
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
250         toVault = airdropLimit.sub(totalAirdrop);
251         emit SnapshotTaken(totalBalance, totalAirdrop, toVault, addresses.length, airdrops);
252     }
253 
254     /**
255      * @dev Start the airdrop.
256      */
257     function airdropAndVault() public
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
273         currentCirculating = currentCirculating.add(airdropLimit);
274         emit Airdropped(totalAirdrop, airdrops);
275 
276         token.transfer(vault, toVault);
277         emit Vaulted(toVault);
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
293         toVault = 0;
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
308      * @dev Allows the owner to change the vault address.
309      * @param _vault New vault address.
310      */
311     function changeVault(address _vault) public
312     onlyOwner {
313         emit VaultChanged(vault, _vault);
314         vault = _vault;
315     }
316 
317     /**
318      * @dev Allows the owner to change the token limit by airdrop.
319      * @param _airdropLimit The token limit by airdrop in wei.
320      */
321     function changeAirdropLimit(uint256 _airdropLimit) public
322     onlyOwner {
323         emit AirdropLimitChanged(airdropLimit, _airdropLimit);
324         airdropLimit = _airdropLimit;
325     }
326 
327     /**
328      * @dev Allows the owner to change the token limit by airdrop.
329      * @param _currentCirculating The current circulating tokens in wei.
330      */
331     function changeCurrentCirculating(uint256 _currentCirculating) public
332     onlyOwner {
333         emit CurrentCirculatingChanged(currentCirculating, _currentCirculating);
334         currentCirculating = _currentCirculating;
335     }
336 
337     /**
338      * @dev Allows the owner to flush the eth.
339      */
340     function flushEth() public onlyOwner {
341         owner.transfer(address(this).balance);
342     }
343 
344     /**
345      * @dev Allows the owner to flush the tokens of the contract.
346      */
347     function flushTokens() public onlyOwner {
348         token.transfer(owner, token.balanceOf(address(this)));
349     }
350 
351     /**
352      * @dev Allows the owner to destroy the contract and return the tokens to the owner.
353      */
354     function destroy() public onlyOwner {
355         token.transfer(owner, token.balanceOf(address(this)));
356         selfdestruct(owner);
357     }
358 
359     /**
360      * @dev Get the token balance of the contract.
361      * @return _balance The token balance of this contract
362      */
363     function tokenBalance() view public returns (uint256 _balance) {
364         return token.balanceOf(address(this));
365     }
366 
367     /**
368      * @dev Get the token balance of the beneficiary.
369      * @param _beneficiary The address of the beneficiary
370      * @return _balance The token balance of the beneficiary
371      */
372     function getBalanceAtSnapshot(address _beneficiary) view public returns (uint256 _balance) {
373         return beneficiaries[_beneficiary].balance / 1 ether;
374     }
375 
376     /**
377      * @dev Get the airdrop reward of the beneficiary.
378      * @param _beneficiary The address of the beneficiary
379      * @return _airdrop The token balance of the beneficiary
380      */
381     function getAirdropAtSnapshot(address _beneficiary) view public returns (uint256 _airdrop) {
382         return beneficiaries[_beneficiary].airdrop / 1 ether;
383     }
384 
385     /**
386      * @dev Allows a beneficiary to verify if he is already registered.
387      * @param _beneficiary The address of the beneficiary
388      * @return _isBeneficiary The boolean value
389      */
390     function amIBeneficiary(address _beneficiary) view public returns (bool _isBeneficiary) {
391         return beneficiaries[_beneficiary].isBeneficiary;
392     }
393 
394     /**
395      * @dev Get the number of beneficiaries.
396      * @return _length The number of beneficiaries
397      */
398     function beneficiariesLength() view public returns (uint256 _length) {
399         return addresses.length;
400     }
401 }