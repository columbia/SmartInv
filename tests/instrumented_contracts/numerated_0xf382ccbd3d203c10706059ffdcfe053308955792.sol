1 pragma solidity ^0.4.16;
2 
3 
4 /**
5  * @title Ownable
6  * @dev The Ownable contract has an owner address, and provides basic authorization control
7  * functions, this simplifies the implementation of "user permissions".
8  */
9 contract Ownable {
10     address public owner;
11 
12 
13     /**
14      * @dev The Ownable constructor sets the original `owner` of the contract to the sender
15      * account.
16      */
17     function Ownable() public {
18         owner = msg.sender;
19     }
20 
21     /**
22      * @dev Throws if called by any account other than the owner.
23      */
24     modifier onlyOwner() {
25         if (msg.sender != owner) {
26             revert();
27         }
28         _;
29     }
30 
31 
32     /**
33      * @dev Allows the current owner to transfer control of the contract to a newOwner.
34      * @param newOwner The address to transfer ownership to.
35      */
36     function transferOwnership(address newOwner) public onlyOwner {
37         if (newOwner != address(0)) {
38             owner = newOwner;
39         }
40     }
41 
42 }
43 
44 contract Investors {
45 
46     address[] public investors;
47     mapping(address => uint) investorIndex;
48 
49     /**
50      * @dev Contructor that authorizes the msg.sender.
51      */
52     function Investors() public {
53         investors.length = 2;
54         investors[1] = msg.sender;
55         investorIndex[msg.sender] = 1;
56     }
57 
58     /**
59      * @dev Function to add a new investor
60      * @param _inv the address to add as a new investor.
61      */
62     function addInvestor(address _inv) public {
63         if (investorIndex[_inv] <= 0) {
64             investorIndex[_inv] = investors.length;
65             investors.length++;
66             investors[investors.length - 1] = _inv;
67         }
68 
69     }
70 }
71 
72 /**
73  * Math operations with safety checks
74  */
75 library SafeMath {
76     function mul(uint a, uint b) pure internal returns (uint) {
77         uint c = a * b;
78         assert(a == 0 || c / a == b);
79         return c;
80     }
81 
82     function div(uint a, uint b) pure internal returns (uint) {
83         // assert(b > 0); // Solidity automatically throws when dividing by 0
84         uint c = a / b;
85         // assert(a == b * c + a % b); // There is no case in which this doesn't hold
86         return c;
87     }
88 
89     function sub(uint a, uint b) pure internal returns (uint) {
90         assert(b <= a);
91         return a - b;
92     }
93 
94     function add(uint a, uint b) pure internal returns (uint) {
95         uint c = a + b;
96         assert(c >= a);
97         return c;
98     }
99 
100     function max64(uint64 a, uint64 b) internal pure returns (uint64) {
101         return a >= b ? a : b;
102     }
103 
104     function min64(uint64 a, uint64 b) internal pure returns (uint64) {
105         return a < b ? a : b;
106     }
107 
108     function max256(uint256 a, uint256 b) internal pure returns (uint256) {
109         return a >= b ? a : b;
110     }
111 
112     function min256(uint256 a, uint256 b) internal pure returns (uint256) {
113         return a < b ? a : b;
114     }
115 }
116 
117 /**
118  * @title ERC20Basic
119  * @dev Simpler version of ERC20 interface
120  * @dev see https://github.com/ethereum/EIPs/issues/20
121  */
122 contract ERC20Basic {
123     uint public totalSupply;
124     function balanceOf(address who) public view returns (uint);
125     function transfer(address to, uint value) public;
126     event Transfer(address indexed from, address indexed to, uint value);
127 }
128 
129 
130 
131 
132 /**
133  * @title ERC20 interface
134  * @dev see https://github.com/ethereum/EIPs/issues/20
135  */
136 contract ERC20 is ERC20Basic {
137     function allowance(address owner, address spender) public view returns (uint);
138     function transferFrom(address from, address to, uint value) public;
139     function approve(address spender, uint value)  public;
140     event Approval(address indexed owner, address indexed spender, uint value);
141 }
142 
143 /**
144  * @title Basic token
145  * @dev Basic version of StandardToken, with no allowances.
146  */
147 contract BasicToken is ERC20Basic {
148     using SafeMath for uint;
149 
150     mapping(address => uint) balances;
151 
152     /**
153      * @dev Fix for the ERC20 short address attack.
154      */
155     modifier onlyPayloadSize(uint size) {
156         if(msg.data.length < size + 4) {
157             revert();
158         }
159         _;
160     }
161 
162     /**
163     * @dev transfer token for a specified address
164     * @param _to The address to transfer to.
165     * @param _value The amount to be transferred.
166     */
167     function transfer(address _to, uint _value) public onlyPayloadSize(2 * 32) {
168         balances[msg.sender] = balances[msg.sender].sub(_value);
169         balances[_to] = balances[_to].add(_value);
170         Transfer(msg.sender, _to, _value);
171     }
172 
173     /**
174     * @dev Gets the balance of the specified address.
175     * @param _owner The address to query the the balance of.
176     * @return An uint representing the amount owned by the passed address.
177     */
178     function balanceOf(address _owner) public view returns (uint balance) {
179         return balances[_owner];
180     }
181 
182 }
183 
184 /**
185  * @title Standard ERC20 token
186  *
187  * @dev Implemantation of the basic standart token.
188  * @dev https://github.com/ethereum/EIPs/issues/20
189  * @dev Based on code by FirstBlood: https://github.com/Firstbloodio/token/blob/master/smart_contract/FirstBloodToken.sol
190  */
191 contract StandardToken is BasicToken, ERC20 {
192 
193     mapping (address => mapping (address => uint)) allowed;
194 
195 
196     /**
197      * @dev Transfer tokens from one address to another
198      * @param _from address The address which you want to send tokens from
199      * @param _to address The address which you want to transfer to
200      * @param _value uint the amout of tokens to be transfered
201      */
202     function transferFrom(address _from, address _to, uint _value) public onlyPayloadSize(3 * 32) {
203         var _allowance = allowed[_from][msg.sender];
204 
205         // Check is not needed because sub(_allowance, _value) will already throw if this condition is not met
206         // if (_value > _allowance) throw;
207 
208         balances[_to] = balances[_to].add(_value);
209         balances[_from] = balances[_from].sub(_value);
210         allowed[_from][msg.sender] = _allowance.sub(_value);
211         Transfer(_from, _to, _value);
212     }
213 
214     /**
215      * @dev Aprove the passed address to spend the specified amount of tokens on beahlf of msg.sender.
216      * @param _spender The address which will spend the funds.
217      * @param _value The amount of tokens to be spent.
218      */
219     function approve(address _spender, uint _value) public {
220 
221         // To change the approve amount you first have to reduce the addresses`
222         //  allowance to zero by calling `approve(_spender, 0)` if it is not
223         //  already 0 to mitigate the race condition described here:
224         //  https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
225         if ((_value != 0) && (allowed[msg.sender][_spender] != 0)) revert();
226 
227         allowed[msg.sender][_spender] = _value;
228         Approval(msg.sender, _spender, _value);
229     }
230 
231     /**
232      * @dev Function to check the amount of tokens than an owner allowed to a spender.
233      * @param _owner address The address which owns the funds.
234      * @param _spender address The address which will spend the funds.
235      * @return A uint specifing the amount of tokens still avaible for the spender.
236      */
237     function allowance(address _owner, address _spender) public view returns (uint remaining) {
238         return allowed[_owner][_spender];
239     }
240 
241 }
242 
243 /**
244  * @title Mintable token
245  * @dev Simple ERC20 Token example, with mintable token creation
246  * @dev Issue: * https://github.com/OpenZeppelin/zeppelin-solidity/issues/120
247  * Based on code by TokenMarketNet: https://github.com/TokenMarketNet/ico/blob/master/contracts/MintableToken.sol
248  */
249 
250 contract MintableToken is StandardToken, Ownable {
251     event MintFinished();
252 
253     bool public mintingFinished = false;
254     uint public totalSupply = 349308401e18;
255     uint public currentSupply = 0;
256 
257     modifier canMint() {
258         if(mintingFinished) revert();
259         _;
260     }
261 
262     /**
263      * @dev Function to mint tokens
264      * @param _to The address that will recieve the minted tokens.
265      * @param _amount The amount of tokens to mint.
266      * @return A boolean that indicates if the operation was successful.
267      */
268     function mint(address _to, uint _amount) public onlyOwner canMint returns (bool) {
269         require(currentSupply.add(_amount) <= totalSupply);
270         currentSupply = currentSupply.add(_amount);
271         balances[_to] = balances[_to].add(_amount);
272         Transfer(0x0, _to, _amount);
273         return true;
274     }
275 
276     /**
277      * @dev Function to stop minting new tokens.
278      * @return True if the operation was successful.
279      */
280     function finishMinting() public onlyOwner returns (bool) {
281         mintingFinished = true;
282         MintFinished();
283         return true;
284     }
285 }
286 
287 
288 /**
289  * @title InvestyToken
290  * @dev The main PAY token contract
291  * 
292  * ABI
293  * [{"constant":true,"inputs":[],"name":"mintingFinished","outputs":[{"name":"","type":"bool"}],"payable":false,"stateMutability":"view","type":"function"},{"constant":true,"inputs":[],"name":"name","outputs":[{"name":"","type":"string"}],"payable":false,"stateMutability":"view","type":"function"},{"constant":false,"inputs":[{"name":"_spender","type":"address"},{"name":"_value","type":"uint256"}],"name":"approve","outputs":[],"payable":false,"stateMutability":"nonpayable","type":"function"},{"constant":true,"inputs":[],"name":"totalSupply","outputs":[{"name":"","type":"uint256"}],"payable":false,"stateMutability":"view","type":"function"},{"constant":false,"inputs":[{"name":"_from","type":"address"},{"name":"_to","type":"address"},{"name":"_value","type":"uint256"}],"name":"transferFrom","outputs":[],"payable":false,"stateMutability":"nonpayable","type":"function"},{"constant":true,"inputs":[],"name":"decimals","outputs":[{"name":"","type":"uint256"}],"payable":false,"stateMutability":"view","type":"function"},{"constant":false,"inputs":[{"name":"_to","type":"address"},{"name":"_amount","type":"uint256"}],"name":"mint","outputs":[{"name":"","type":"bool"}],"payable":false,"stateMutability":"nonpayable","type":"function"},{"constant":true,"inputs":[{"name":"_owner","type":"address"}],"name":"balanceOf","outputs":[{"name":"balance","type":"uint256"}],"payable":false,"stateMutability":"view","type":"function"},{"constant":true,"inputs":[],"name":"currentSupply","outputs":[{"name":"","type":"uint256"}],"payable":false,"stateMutability":"view","type":"function"},{"constant":false,"inputs":[],"name":"finishMinting","outputs":[{"name":"","type":"bool"}],"payable":false,"stateMutability":"nonpayable","type":"function"},{"constant":true,"inputs":[],"name":"owner","outputs":[{"name":"","type":"address"}],"payable":false,"stateMutability":"view","type":"function"},{"constant":true,"inputs":[],"name":"symbol","outputs":[{"name":"","type":"string"}],"payable":false,"stateMutability":"view","type":"function"},{"constant":false,"inputs":[{"name":"_to","type":"address"},{"name":"_value","type":"uint256"}],"name":"transfer","outputs":[],"payable":false,"stateMutability":"nonpayable","type":"function"},{"constant":true,"inputs":[{"name":"_owner","type":"address"},{"name":"_spender","type":"address"}],"name":"allowance","outputs":[{"name":"remaining","type":"uint256"}],"payable":false,"stateMutability":"view","type":"function"},{"constant":false,"inputs":[{"name":"newOwner","type":"address"}],"name":"transferOwnership","outputs":[],"payable":false,"stateMutability":"nonpayable","type":"function"},{"anonymous":false,"inputs":[],"name":"MintFinished","type":"event"},{"anonymous":false,"inputs":[{"indexed":true,"name":"owner","type":"address"},{"indexed":true,"name":"spender","type":"address"},{"indexed":false,"name":"value","type":"uint256"}],"name":"Approval","type":"event"},{"anonymous":false,"inputs":[{"indexed":true,"name":"from","type":"address"},{"indexed":true,"name":"to","type":"address"},{"indexed":false,"name":"value","type":"uint256"}],"name":"Transfer","type":"event"}]
294  */
295 contract InvestyToken is MintableToken {
296 
297     string public name = "Investy Coin";
298     string public symbol = "IVC";
299     uint public decimals = 18;
300 }
301 
302 
303 /*
304  * @title InvestyPresale
305  * @dev Interface of presale contract
306  */
307 contract InvestyPresale is Ownable, Investors {
308     InvestyToken public token;
309 }
310 
311 /**
312  * @title InvestyContract
313  * @dev The main PAY token sale contract
314  */
315 contract InvestyContract is Ownable {
316     using SafeMath for uint;
317 
318     InvestyToken public token = new InvestyToken();
319 
320     uint importIndex = 1; // the 0th address is a zero, iterating is started from 1
321 
322     /**
323      * constructor
324      */
325     function InvestyContract() public{
326     }
327     
328     /*
329      * @dev Function to import balances from presale contract.
330      * @parm number of balances to import
331      * @return true
332      */ 
333     function importBalances(uint n, address presaleContractAddress) public onlyOwner returns (bool) {
334        require(n > 0);
335 
336        InvestyPresale presaleContract = InvestyPresale(presaleContractAddress);
337        InvestyToken presaleToken = presaleContract.token();
338 
339        while (n > 0) {
340             address recipient = presaleContract.investors(importIndex);
341 
342             uint recipientTokens = presaleToken.balanceOf(recipient);
343             token.mint(recipient, recipientTokens);
344             
345             n = n.sub(1);
346             importIndex = importIndex.add(1);
347        }
348         
349        return true;
350     }
351 
352     /**
353      * @dev Ownership of the PAY token contract is transfered to this owner.
354      */
355     function transferToken() public onlyOwner {
356         token.transferOwnership(owner);
357     }
358 }