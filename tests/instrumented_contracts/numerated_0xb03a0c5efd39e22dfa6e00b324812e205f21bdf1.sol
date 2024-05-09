1 pragma solidity ^0.4.11;
2 
3 /**
4  * @title SafeMath
5  * @dev Math operations with safety checks that throw on error
6  */
7 library SafeMath {
8     function mul(uint256 a, uint256 b) internal constant returns (uint256) {
9         uint256 c = a * b;
10         assert(a == 0 || c / a == b);
11         return c;
12     }
13 
14     function div(uint256 a, uint256 b) internal constant returns (uint256) {
15         // assert(b > 0); // Solidity automatically throws when dividing by 0
16         uint256 c = a / b;
17         // assert(a == b * c + a % b); // There is no case in which this doesn't hold
18         return c;
19     }
20 
21     function sub(uint256 a, uint256 b) internal constant returns (uint256) {
22         assert(b <= a);
23         return a - b;
24     }
25 
26     function add(uint256 a, uint256 b) internal constant returns (uint256) {
27         uint256 c = a + b;
28         assert(c >= a);
29         return c;
30     }
31 }
32 
33 
34 /**
35  * @title ERC20Basic
36  * @dev Simpler version of ERC20 interface
37  * @dev see https://github.com/ethereum/EIPs/issues/179
38  */
39 contract ERC20Basic {
40     uint256 public totalSupply;
41     function balanceOf(address who) constant returns (uint256);
42     function transfer(address to, uint256 value) returns (bool);
43     event Transfer(address indexed from, address indexed to, uint256 value);
44 }
45 
46 /**
47  * @title ERC20 interface
48  * @dev see https://github.com/ethereum/EIPs/issues/20
49  */
50 contract ERC20 is ERC20Basic {
51     function allowance(address owner, address spender) constant returns (uint256);
52     function transferFrom(address from, address to, uint256 value) returns (bool);
53     function approve(address spender, uint256 value) returns (bool);
54     event Approval(address indexed owner, address indexed spender, uint256 value);
55 }
56 
57 /**
58  * @title Basic token
59  * @dev Basic version of StandardToken, with no allowances.
60  */
61 contract BasicToken is ERC20Basic {
62     using SafeMath for uint256;
63 
64     mapping(address => uint256) balances;
65 
66     /**
67     * @dev transfer token for a specified address
68     * @param _to The address to transfer to.
69     * @param _value The amount to be transferred.
70     */
71     function transfer(address _to, uint256 _value) returns (bool) {
72         balances[msg.sender] = balances[msg.sender].sub(_value);
73         balances[_to] = balances[_to].add(_value);
74         Transfer(msg.sender, _to, _value);
75         return true;
76     }
77 
78     /**
79     * @dev Gets the balance of the specified address.
80     * @param _owner The address to query the the balance of.
81     * @return An uint256 representing the amount owned by the passed address.
82     */
83     function balanceOf(address _owner) constant returns (uint256 balance) {
84         return balances[_owner];
85     }
86 
87 }
88 
89 /**
90  * @title Standard ERC20 token
91  *
92  * @dev Implementation of the basic standard token.
93  * @dev https://github.com/ethereum/EIPs/issues/20
94  * @dev Based on code by FirstBlood: https://github.com/Firstbloodio/token/blob/master/smart_contract/FirstBloodToken.sol
95  */
96 contract StandardToken is ERC20, BasicToken {
97 
98     mapping (address => mapping (address => uint256)) allowed;
99 
100 
101     /**
102      * @dev Transfer tokens from one address to another
103      * @param _from address The address which you want to send tokens from
104      * @param _to address The address which you want to transfer to
105      * @param _value uint256 the amout of tokens to be transfered
106      */
107     function transferFrom(address _from, address _to, uint256 _value) returns (bool) {
108         var _allowance = allowed[_from][msg.sender];
109 
110         // Check is not needed because sub(_allowance, _value) will already throw if this condition is not met
111         // require (_value <= _allowance);
112 
113         balances[_to] = balances[_to].add(_value);
114         balances[_from] = balances[_from].sub(_value);
115         allowed[_from][msg.sender] = _allowance.sub(_value);
116         Transfer(_from, _to, _value);
117         return true;
118     }
119 
120     /**
121      * @dev Aprove the passed address to spend the specified amount of tokens on behalf of msg.sender.
122      * @param _spender The address which will spend the funds.
123      * @param _value The amount of tokens to be spent.
124      */
125     function approve(address _spender, uint256 _value) returns (bool) {
126 
127         // To change the approve amount you first have to reduce the addresses`
128         //  allowance to zero by calling `approve(_spender, 0)` if it is not
129         //  already 0 to mitigate the race condition described here:
130         //  https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
131         require((_value == 0) || (allowed[msg.sender][_spender] == 0));
132 
133         allowed[msg.sender][_spender] = _value;
134         Approval(msg.sender, _spender, _value);
135         return true;
136     }
137 
138     /**
139      * @dev Function to check the amount of tokens that an owner allowed to a spender.
140      * @param _owner address The address which owns the funds.
141      * @param _spender address The address which will spend the funds.
142      * @return A uint256 specifing the amount of tokens still available for the spender.
143      */
144     function allowance(address _owner, address _spender) constant returns (uint256 remaining) {
145         return allowed[_owner][_spender];
146     }
147 
148 }
149 
150 /**
151  * @title Ownable
152  * @dev The Ownable contract has an owner address, and provides basic authorization control
153  * functions, this simplifies the implementation of "user permissions".
154  */
155 contract Ownable {
156     address public owner;
157 
158 
159     /**
160      * @dev The Ownable constructor sets the original `owner` of the contract to the sender
161      * account.
162      */
163     function Ownable() {
164         owner = msg.sender;
165     }
166 
167 
168     /**
169      * @dev Throws if called by any account other than the owner.
170      */
171     modifier onlyOwner() {
172         require(msg.sender == owner);
173         _;
174     }
175 
176 
177     /**
178      * @dev Allows the current owner to transfer control of the contract to a newOwner.
179      * @param newOwner The address to transfer ownership to.
180      */
181     function transferOwnership(address newOwner) onlyOwner {
182         require(newOwner != address(0));
183         owner = newOwner;
184     }
185 
186 }
187 
188 
189 contract MintableToken is StandardToken, Ownable {
190     event Mint(address indexed to, uint256 amount);
191     event MintFinished();
192 
193     bool public mintingFinished = false;
194     uint256 public maxTokensToMint;
195 
196     modifier canMint() {
197         require(!mintingFinished);
198         _;
199     }
200 
201     /**
202     * @dev Function to mint tokens
203     * @param _to The address that will recieve the minted tokens.
204     * @param _amount The amount of tokens to mint.
205     * @return A boolean that indicates if the operation was successful.
206     */
207     function mint(address _to, uint256 _amount) onlyOwner returns (bool) {
208         require(totalSupply + _amount <= maxTokensToMint);
209         return mintInternal(_to, _amount);
210     }
211 
212     /**
213     * @dev Function to stop minting new tokens.
214     * @return True if the operation was successful.
215     */
216     function finishMinting() onlyOwner returns (bool) {
217         mintingFinished = true;
218         MintFinished();
219         return true;
220     }
221 
222     function mintInternal(address _to, uint256 _amount) internal canMint returns (bool) {
223         totalSupply = totalSupply.add(_amount);
224         balances[_to] = balances[_to].add(_amount);
225         Mint(_to, _amount);
226         return true;
227     }
228 }
229 
230 contract PreArnaToken is MintableToken {
231 
232     string public name;
233 
234     string public symbol;
235 
236     uint8 public decimals;
237 
238     mapping(address => uint256) public donations;
239 
240     uint256 public totalWeiFunded;
241 
242     uint256 public minDonationInWei;
243 
244     uint256 public maxDonationInWei;
245 
246     // address where funds are collected
247     address public wallet;
248 
249     // how many wei a buyer gets per token
250     uint256 public rate;
251 
252     event TokenPurchase(address indexed purchaser, address indexed beneficiary, uint256 value, uint256 amount);
253 
254     function PreArnaToken(
255     uint256 _rate,
256     uint256 _maxTokensToMint,
257     uint256 _maxDonationInWei,
258     uint256 _minDonationInWei,
259     address _wallet,
260     string _name,
261     string _symbol,
262     uint8 _decimals
263     ) {
264         require(_rate > 0);
265         require(_wallet != 0x0);
266 
267         rate = _rate;
268         maxTokensToMint = _maxTokensToMint;
269         maxDonationInWei = _maxDonationInWei;
270         minDonationInWei = _minDonationInWei;
271         wallet = _wallet;
272         name = _name;
273         symbol = _symbol;
274         decimals = _decimals;
275     }
276 
277     function transfer(address _to, uint _value) onlyOwner returns (bool) {
278         return super.transfer(_to, _value);
279     }
280 
281     function transferFrom(address _from, address _to, uint _value) onlyOwner returns (bool) {
282         return super.transferFrom(_from, _to, _value);
283     }
284 
285     function () payable {
286         buyTokens(msg.sender);
287     }
288 
289     function mintByOwner(address _to, uint _value) onlyOwner returns (bool) {
290         mint(_to, _value);
291     }
292 
293     function changeRate(uint _newRate) onlyOwner returns (bool) {
294         require(_newRate > 0);
295         rate = _newRate;
296         return true;
297     }
298 
299     function changeMaxDonationLimit(uint256 _newLimit) onlyOwner returns (bool) {
300         require(_newLimit > 0);
301         maxDonationInWei = _newLimit;
302         return true;
303     }
304 
305     function changeMinDonationLimit(uint _newLimit) onlyOwner returns (bool) {
306         require(_newLimit > 0);
307         minDonationInWei = _newLimit;
308         return true;
309     }
310 
311     function buyTokens(address beneficiary) payable {
312         require(beneficiary != 0x0);
313 
314         require(msg.value >= minDonationInWei);        //min value
315         require(msg.value <= maxDonationInWei);    //max value
316 
317         totalWeiFunded += msg.value;
318         donations[msg.sender] += msg.value;
319 
320         //dont mint here
321         forwardFunds();
322 
323 
324     }
325 
326     // send ether to the fund collection wallet
327     function forwardFunds() internal {
328         wallet.transfer(msg.value);
329     }
330 
331 }