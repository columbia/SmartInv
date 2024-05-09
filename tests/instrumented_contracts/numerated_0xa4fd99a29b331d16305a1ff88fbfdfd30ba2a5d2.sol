1 pragma solidity ^0.4.24;
2 // produced by the Solididy File Flattener (c) David Appleton 2018
3 // contact : dave@akomba.com
4 // released under Apache 2.0 licence
5 // input  /Users/daveappleton/Documents/akombalabs/peep2/contracts/PeepToken.sol
6 // flattened :  Wednesday, 31-Oct-18 00:34:17 UTC
7 contract Ownable {
8   address public owner;
9 
10 
11   event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
12 
13 
14   /**
15    * @dev The Ownable constructor sets the original `owner` of the contract to the sender
16    * account.
17    */
18   function Ownable() public {
19     owner = msg.sender;
20   }
21 
22   /**
23    * @dev Throws if called by any account other than the owner.
24    */
25   modifier onlyOwner() {
26     require(msg.sender == owner);
27     _;
28   }
29 
30   /**
31    * @dev Allows the current owner to transfer control of the contract to a newOwner.
32    * @param newOwner The address to transfer ownership to.
33    */
34   function transferOwnership(address newOwner) public onlyOwner {
35     require(newOwner != address(0));
36     OwnershipTransferred(owner, newOwner);
37     owner = newOwner;
38   }
39 
40 }
41 
42 contract ERC20Basic {
43   function totalSupply() public view returns (uint256);
44   function balanceOf(address who) public view returns (uint256);
45   function transfer(address to, uint256 value) public returns (bool);
46   event Transfer(address indexed from, address indexed to, uint256 value);
47 }
48 
49 library SafeMath {
50 
51   /**
52   * @dev Multiplies two numbers, throws on overflow.
53   */
54   function mul(uint256 a, uint256 b) internal pure returns (uint256) {
55     if (a == 0) {
56       return 0;
57     }
58     uint256 c = a * b;
59     assert(c / a == b);
60     return c;
61   }
62 
63   /**
64   * @dev Integer division of two numbers, truncating the quotient.
65   */
66   function div(uint256 a, uint256 b) internal pure returns (uint256) {
67     // assert(b > 0); // Solidity automatically throws when dividing by 0
68     uint256 c = a / b;
69     // assert(a == b * c + a % b); // There is no case in which this doesn't hold
70     return c;
71   }
72 
73   /**
74   * @dev Substracts two numbers, throws on overflow (i.e. if subtrahend is greater than minuend).
75   */
76   function sub(uint256 a, uint256 b) internal pure returns (uint256) {
77     assert(b <= a);
78     return a - b;
79   }
80 
81   /**
82   * @dev Adds two numbers, throws on overflow.
83   */
84   function add(uint256 a, uint256 b) internal pure returns (uint256) {
85     uint256 c = a + b;
86     assert(c >= a);
87     return c;
88   }
89 }
90 
91 contract PeepTokenConfig {
92     string public constant NAME = "Devcon4PeepToken";
93     string public constant SYMBOL = "PEEP";
94     uint8 public constant DECIMALS = 0;
95     uint public constant TOTALSUPPLY = 100;
96 }
97 contract ERC20 is ERC20Basic {
98   function allowance(address owner, address spender) public view returns (uint256);
99   function transferFrom(address from, address to, uint256 value) public returns (bool);
100   function approve(address spender, uint256 value) public returns (bool);
101   event Approval(address indexed owner, address indexed spender, uint256 value);
102 }
103 
104 contract BasicToken is ERC20Basic {
105   using SafeMath for uint256;
106 
107   mapping(address => uint256) balances;
108 
109   uint256 totalSupply_;
110 
111   /**
112   * @dev total number of tokens in existence
113   */
114   function totalSupply() public view returns (uint256) {
115     return totalSupply_;
116   }
117 
118   /**
119   * @dev transfer token for a specified address
120   * @param _to The address to transfer to.
121   * @param _value The amount to be transferred.
122   */
123   function transfer(address _to, uint256 _value) public returns (bool) {
124     require(_to != address(0));
125     require(_value <= balances[msg.sender]);
126 
127     // SafeMath.sub will throw if there is not enough balance.
128     balances[msg.sender] = balances[msg.sender].sub(_value);
129     balances[_to] = balances[_to].add(_value);
130     Transfer(msg.sender, _to, _value);
131     return true;
132   }
133 
134   /**
135   * @dev Gets the balance of the specified address.
136   * @param _owner The address to query the the balance of.
137   * @return An uint256 representing the amount owned by the passed address.
138   */
139   function balanceOf(address _owner) public view returns (uint256 balance) {
140     return balances[_owner];
141   }
142 
143 }
144 
145 contract StandardToken is ERC20, BasicToken {
146 
147   mapping (address => mapping (address => uint256)) internal allowed;
148 
149 
150   /**
151    * @dev Transfer tokens from one address to another
152    * @param _from address The address which you want to send tokens from
153    * @param _to address The address which you want to transfer to
154    * @param _value uint256 the amount of tokens to be transferred
155    */
156   function transferFrom(address _from, address _to, uint256 _value) public returns (bool) {
157     require(_to != address(0));
158     require(_value <= balances[_from]);
159     require(_value <= allowed[_from][msg.sender]);
160 
161     balances[_from] = balances[_from].sub(_value);
162     balances[_to] = balances[_to].add(_value);
163     allowed[_from][msg.sender] = allowed[_from][msg.sender].sub(_value);
164     Transfer(_from, _to, _value);
165     return true;
166   }
167 
168   /**
169    * @dev Approve the passed address to spend the specified amount of tokens on behalf of msg.sender.
170    *
171    * Beware that changing an allowance with this method brings the risk that someone may use both the old
172    * and the new allowance by unfortunate transaction ordering. One possible solution to mitigate this
173    * race condition is to first reduce the spender's allowance to 0 and set the desired value afterwards:
174    * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
175    * @param _spender The address which will spend the funds.
176    * @param _value The amount of tokens to be spent.
177    */
178   function approve(address _spender, uint256 _value) public returns (bool) {
179     allowed[msg.sender][_spender] = _value;
180     Approval(msg.sender, _spender, _value);
181     return true;
182   }
183 
184   /**
185    * @dev Function to check the amount of tokens that an owner allowed to a spender.
186    * @param _owner address The address which owns the funds.
187    * @param _spender address The address which will spend the funds.
188    * @return A uint256 specifying the amount of tokens still available for the spender.
189    */
190   function allowance(address _owner, address _spender) public view returns (uint256) {
191     return allowed[_owner][_spender];
192   }
193 
194   /**
195    * @dev Increase the amount of tokens that an owner allowed to a spender.
196    *
197    * approve should be called when allowed[_spender] == 0. To increment
198    * allowed value is better to use this function to avoid 2 calls (and wait until
199    * the first transaction is mined)
200    * From MonolithDAO Token.sol
201    * @param _spender The address which will spend the funds.
202    * @param _addedValue The amount of tokens to increase the allowance by.
203    */
204   function increaseApproval(address _spender, uint _addedValue) public returns (bool) {
205     allowed[msg.sender][_spender] = allowed[msg.sender][_spender].add(_addedValue);
206     Approval(msg.sender, _spender, allowed[msg.sender][_spender]);
207     return true;
208   }
209 
210   /**
211    * @dev Decrease the amount of tokens that an owner allowed to a spender.
212    *
213    * approve should be called when allowed[_spender] == 0. To decrement
214    * allowed value is better to use this function to avoid 2 calls (and wait until
215    * the first transaction is mined)
216    * From MonolithDAO Token.sol
217    * @param _spender The address which will spend the funds.
218    * @param _subtractedValue The amount of tokens to decrease the allowance by.
219    */
220   function decreaseApproval(address _spender, uint _subtractedValue) public returns (bool) {
221     uint oldValue = allowed[msg.sender][_spender];
222     if (_subtractedValue > oldValue) {
223       allowed[msg.sender][_spender] = 0;
224     } else {
225       allowed[msg.sender][_spender] = oldValue.sub(_subtractedValue);
226     }
227     Approval(msg.sender, _spender, allowed[msg.sender][_spender]);
228     return true;
229   }
230 
231 }
232 
233 contract Salvageable is Ownable {
234     // Salvage other tokens that are accidentally sent into this token
235     function emergencyERC20Drain(ERC20 oddToken, uint amount) public onlyOwner {
236         if (address(oddToken) == address(0)) {
237             owner.transfer(amount);
238             return;
239         }
240         oddToken.transfer(owner, amount);
241     }
242 }
243 contract Devcon4PeepToken is StandardToken, PeepTokenConfig, Salvageable { 
244     using SafeMath for uint;
245 
246     string  public name = NAME;
247     string  public symbol = SYMBOL;
248     uint8   public decimals = DECIMALS;
249     uint    public numCardsPurchased;
250     address public peepethAccount = 0xdD53530eAA9c7B47AD8f97a5BF1C797aB6f6cf28;
251  
252     event CardPurchased(address buyer, uint cardnumber, bytes32 data);
253 
254     constructor() public {
255         issueCard(0x2a9623C8f0Afb3C61579130bA9285BdD122Dd003);
256         issueCard(0xD64eed8e7250636Cb17f2314c81F9DF33a32A93D);
257         issueCard(0x32D90824d2Bf1a668196939858269948E6a1afe0);
258         issueCard(0xA0f0F8A9380Ce8925F5232EA6377A4C864B60BD1);
259         issueCard(0x1a1146Fae0CA9F883827177cE0e3FDc17a3Dfc92);
260         issueCard(0x43A3C6D8Ab17700F02678769D707A8506979f90a);
261         issueCard(0xB648A7c8eD58108194888Fb4701543E134EC91f9);
262         issueCard(0x68a9d79EEd5E5fA3a76C9d28303f2Ccf65680665);
263         issueCard(0x823887649977942A94003Dd970C05Aa3B6647A60);
264         issueCard(0x39Da47B370EaeF6E2eA30270466071cb1e0A52CC);
265         issueCard(0x63DCe2d2F21d681aBa83521D7EdaC276C00c2a01);
266         issueCard(0xcBfF2cC509eafdE2e7176660A7B09fFD27433a6f);
267         issueCard(0x932fE9C7Aa5bcd89822B590f15E2c42Fb1896Ea0);
268         issueCard(0x89d2119b24E9535Bc3EBDE78A8f26a256272f24F);
269         issueCard(0xD130f6b32E4D6e22a0E119b883Fa824206a9db9b);
270         issueCard(0x327aBcA5aB769fF74dED50120197A8B77d037735);
271         issueCard(0xc624053a439b58Bd136Cd16ada512eFC0a8f707D);
272         issueCard(0xd62D756f6850991F79F17614B4f4B0FAdE3C87c2);
273         issueCard(0x51f10B415b09936cBD39E32097603af9110B8d01);
274         issueCard(0xbB4D0669a5EcbEFDF15e594bF4137aAb5E87b8a1);
275         issueCard(0xec1A47D2a1991AaeB738C9f59fB735DCD5f4574b);
276         issueCard(0xAacc237256d2Ea2063E8B6fd2F9811327a39579F);
277         issueCard(0xEE52Bf933CFbA9a874B9757E5037695fC702b2C0);
278         issueCard(0x275a8f8E57c873C393355f0A925A305B0E6D4354);
279         issueCard(0xEADF5909f7b0Ff9F2d7837b4EcA68649446ed18f);
280         issueCard(0x06f6e762C30c193dfD2D0d426707210dB1E407a7);
281         issueCard(0x15D9C502F590192087dAC2e2676C82caC1e560d6);
282         issueCard(0x66565277cfdb8f3F8e407BBe162a18f8f799C1e5);
283         issueCard(0x3CAA2BcCC07eb4F2468cBC49361B7E2AD315C266);
284         issueCard(0x6FB1E21c0590a4Bc1cc1C22881FdA02Ae6973fEF);
285         issueCard(0x82Dad93aE893DE9d0015B9a9eE4229249Bd9875e);
286         issueCard(0xCA7Cc5231801A32754a108042AC0c3532b9ca8Ff);
287         issueCard(0x3dD0e09437FB2a4848D36eb063bb54a7270ae2aA);
288         issueCard(0x5c8d16c6d3Ba0eEcc3E1f641223d3744980B5E58);
289         issueCard(0xc024D90cE1cdD63B0D6D2441575c58044A4c67d1);
290         issueCard(0x776769Dc05fB6cFB7915dad855296F2f22538bb5);
291         issueCard(0x8F7A119Fb68e4eD4341bEb69E32aF91712930DDD);
292         issueCard(0xf666C24f9CA6D4f72AdDf08028Aa7CC80e48F135);
293         issueCard(0xa23Fe6084BF11b82117BA0A529aDe79271009766);
294         issueCard(0x78b2bd4926cE54D9C4f89a960922DaC386F5D5C5);
295         issueCard(0x5aBE0e4C01Bddc040C2d3179D94F5CF6918A0479);
296         issueCard(0x7bb2033847db5856530f287fB79Ee2f93441d96E);
297         issueCard(0x33AaD2a62BAB912dEfde87Ed4f5B402125D7a0E3);
298         issueCard(0xbA8f0a4b927a1352d9D4DCf544eBaa29cE289B3a);
299         issueCard(0x73874C9b7953AA3Cdc05c928703c6aE83C4040EE);
300         issueCard(0xAe34eb13cFba837f8b2839C561eE910598aC3C47);
301         issueCard(0xAe34eb13cFba837f8b2839C561eE910598aC3C47);
302         issueCard(0x4eA47B5aef9C97616586d6c2f326C88C65D2F67f);
303         issueCard(0x2b0e52238Ad855b6FC05148BE17eb67Add6eB307);
304         issueCard(0x9f5A16875d2FAf6a7b7b8eAEfDe0619421fb020b);
305         issueCard(0xF592a8B6286a050D4D6077c8f07A19eD47D2bFA4);
306         issueCard(0x7498b3F5dDf6139f1257cd43fC2EE58c658a987A);
307         issueCard(0x3AC7970f5ab9014d8bd0af0B9BDd8072c8ba731D);
308         issueCard(0x7E08cd0C07F98D5f2cA39d62Be19799aB827aF5a);
309         issueCard(0x5254745B9579c177C9CCf0aac6E0e2F1dB4484Ea);
310         issueCard(0x05f3c2FDbc013828E2090E15ffDd22892168B5F9);
311         issueCard(0xd55B26Cf46B138c818cfC8722AC3FB06a0544559);
312         issueCard(0x2fEa40F4af632B21968e478c80835F6b71Ad28DF);
313         issueCard(0x09D1A2B76C35986EC1F9c19dAfb93CC9eDCF2F40);
314         issueCard(0x85B2Cc7c0Aeabf19c1e15E3887166f544247371b);
315         issueCard(0xBD82fDE36ABa3d1E6A056D5A33a4F02Df789829b);
316         issueCard(0x3472bEA0374807c51d350A920a4Bb0A259322E12);
317         issueCard(0x536F7d9f989E33742dA8822406d02cA28d288f05);
318         issueCard(0xa88E4620ED86d3D3cc69F568C5086366c5EEF9Fc);
319         issueCard(0xF62286b69a1D9Bb3179076cc3ba2ff8b1dAe1B7c);
320         issueCard(0xd802a19F58c011DB1F61fA944535F5c43A706eE2);
321         issueCard(0x20B4BAA7951Eb952F2FaB431a51EFa560cd153Bc);
322         issueCard(0x7ff6e330B35c895DeD5e9B230a325aeF9F78924d);
323         issueCard(0x324EC6dB2f0738d4f15DD63bA623EAA4218041C4);
324         issueCard(0x92c04400E2d08f4Becd643aF043760fcEE710c30);
325         issueCard(0x8d202E81FfB2D3Da80A4Db5787540f88BEDf309d);
326         issueCard(0x0a1cd617215EB8C02fCb1d0B08df5C9B82240A76);
327         issueCard(0x05A3C3D3180e34A2b215986E6FeDF51c660DE3B6);
328         issueCard(0x1BD718F0085df0DedDCe804218C8B3c70Fac82b7);
329         issueCard(0x6f68b6d07929B99b3e3e6E647383C65DcBA70498);
330         issueCard(0x02cE8E0D042A2B16d95020cE959b91a8B92e2Ee8);
331         issueCard(0x7Bfe41Ea4D4d1368D10A84556F892fF4F5691b79);
332         issueCard(0x5fAB308F168fad0B0B1dF9B518eB3366d12a1Fae);
333         issueCard(0xA4d917C157ce08c53D336fB4ADE1868b6FaE36F7);
334         issueCard(0x7D1072a6c2148b1ccAB3F9aA34555Ff7B22Ebd7c);
335         issueCard(0xd6d5b13976CbF94703794bb96a5858ccaaBc63E0);
336         issueCard(0xc390A2572E07533AcF6480311b75Fac7fa4BF498);
337         issueCard(0xea53334A77B3a779A031FE9210036d8Fa4aA639B);
338         issueCard(0x576468BA4f84b630213b9afeEd846B9028A573Be);
339         issueCard(0x0C8a0b6C0e24Bd5f3C121dddd1cED0f56ccF0666);
340         issueCard(0x09eA17757b648F97c5699806ea7BD87F5206F425);
341         issueCard(0x5f93d99F5Fc313843C750dE4293F66c642ee4216);
342         issueCard(0x07CEc5c2e69b0938fFFE0caa6EF1508557E12FDB);
343         issueCard(0x27B7DD511CCE6FA49eeb79846c478E1D96b64145);
344         issueCard(0x95750579C47c3ecaf419422E3f841e9976e7B447);
345         issueCard(0xE410641a155be2a333d2f0e2D30c6863fA0BFe10);
346         issueCard(0x46e1480e8E8C2767D926719Ff4072Aba3848C355);
347         issueCard(0x39841fDDF2FdA2be6c60c9A910e4A2C6D692Df6A);
348         issueCard(0xBC93E622e43D63A7F091fd223BB3030F56c296a3);
349         issueCard(0xA539ba60D4D1086d1F21150C3186579efa991705);
350         issueCard(0x7FB3d8a3595dF044c42d7622f9813244564B8977);
351         issueCard(0xF48eECE024C878612Db464bA54c211534F903817);
352         issueCard(0x785640B80c1147D7a45a0B60051d6aBF58Cae763);
353         issueCard(0x36ea6AF4B00653ad236953dA4a1505632Cbe2163);
354         issueCard(0x978Ed1225A9b3EaAaC1B0De4BD6BF0D1d2fE929f);
355     }
356 
357     function issueCard(address _to) internal{
358         totalSupply_ = totalSupply_ + 1;
359         balances[_to] = 1;
360         emit Transfer(address(0), _to, 1);
361     }
362 
363     function buyCard(bytes32 data) public payable {
364         require(numCardsPurchased < 100, "Cards sold out");
365         require(msg.value >= 1 ether, "min 1 ether");
366         emit CardPurchased(msg.sender, numCardsPurchased,data);
367         peepethAccount.transfer(msg.value);
368         numCardsPurchased++;
369     }
370 
371 }