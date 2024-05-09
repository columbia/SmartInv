1 pragma solidity ^0.4.17;
2 
3 library SafeMath {
4 
5     /**
6     * @dev Multiplies two numbers, throws on overflow.
7     */
8     function mul(uint256 a, uint256 b) internal pure returns (uint256) {
9         if (a == 0) {
10             return 0;
11         }
12         uint256 c = a * b;
13         assert(c / a == b);
14         return c;
15     }
16 
17     /**
18     * @dev Integer division of two numbers, truncating the quotient.
19     */
20     function div(uint256 a, uint256 b) internal pure returns (uint256) {
21         // assert(b > 0); // Solidity automatically throws when dividing by 0
22         uint256 c = a / b;
23         // assert(a == b * c + a % b); // There is no case in which this doesn't hold
24         return c;
25     }
26 
27     /**
28     * @dev Substracts two numbers, throws on overflow (i.e. if subtrahend is greater than minuend).
29     */
30     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
31         assert(b <= a);
32         return a - b;
33     }
34 
35     /**
36     * @dev Adds two numbers, throws on overflow.
37     */
38     function add(uint256 a, uint256 b) internal pure returns (uint256) {
39         uint256 c = a + b;
40         assert(c >= a);
41         return c;
42     }
43 }
44 
45 contract Ownable {
46     address public owner;
47 
48     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
49 
50 
51     /**
52      * @dev The Ownable constructor sets the original `owner` of the contract to the sender
53      * account.
54      */
55     function Ownable() public {
56         owner = msg.sender;
57     }
58 
59     /**
60      * @dev Throws if called by any account other than the owner.
61      */
62     modifier onlyOwner() {
63         require(msg.sender == owner);
64         _;
65     }
66 
67     /**
68      * @dev Allows the current owner to transfer control of the contract to a newOwner.
69      * @param newOwner The address to transfer ownership to.
70      */
71     function transferOwnership(address newOwner) public onlyOwner {
72         require(newOwner != address(0));
73         OwnershipTransferred(owner, newOwner);
74         owner = newOwner;
75     }
76 
77 }
78 
79 contract ERC20Basic {
80     function totalSupply() public view returns (uint256);
81     function balanceOf(address who) public view returns (uint256);
82     function transfer(address to, uint256 value) public returns (bool);
83     event Transfer(address indexed from, address indexed to, uint256 value);
84 }
85 
86 contract BasicToken is ERC20Basic {
87     using SafeMath for uint256;
88 
89     mapping(address => uint256) balances;
90 
91     uint256 totalSupply_;
92 
93     /**
94     * @dev total number of tokens in existence
95     */
96     function totalSupply() public view returns (uint256) {
97         return totalSupply_;
98     }
99 
100     /**
101     * @dev transfer token for a specified address
102     * @param _to The address to transfer to.
103     * @param _value The amount to be transferred.
104     */
105     function transfer(address _to, uint256 _value) public returns (bool) {
106         require(_to != address(0));
107         require(_value <= balances[msg.sender]);
108 
109         // SafeMath.sub will throw if there is not enough balance.
110         balances[msg.sender] = balances[msg.sender].sub(_value);
111         balances[_to] = balances[_to].add(_value);
112         Transfer(msg.sender, _to, _value);
113         return true;
114     }
115 
116     /**
117     * @dev Gets the balance of the specified address.
118     * @param _owner The address to query the the balance of.
119     * @return An uint256 representing the amount owned by the passed address.
120     */
121     function balanceOf(address _owner) public view returns (uint256 balance) {
122         return balances[_owner];
123     }
124 
125 }
126 
127 contract BurnableToken is BasicToken {
128 
129     event Burn(address indexed burner, uint256 value);
130 
131     /**
132      * @dev Burns a specific amount of tokens.
133      * @param _value The amount of token to be burned.
134      */
135     function burn(uint256 _value) public {
136         require(_value <= balances[msg.sender]);
137         // no need to require value <= totalSupply, since that would imply the
138         // sender's balance is greater than the totalSupply, which *should* be an assertion failure
139 
140         address burner = msg.sender;
141         balances[burner] = balances[burner].sub(_value);
142         totalSupply_ = totalSupply_.sub(_value);
143         Burn(burner, _value);
144     }
145 }
146 
147 contract ERC20 is ERC20Basic {
148     function allowance(address owner, address spender) public view returns (uint256);
149     function transferFrom(address from, address to, uint256 value) public returns (bool);
150     function approve(address spender, uint256 value) public returns (bool);
151     event Approval(address indexed owner, address indexed spender, uint256 value);
152 }
153 
154 library SafeERC20 {
155     function safeTransfer(ERC20Basic token, address to, uint256 value) internal {
156         assert(token.transfer(to, value));
157     }
158 
159     function safeTransferFrom(ERC20 token, address from, address to, uint256 value) internal {
160         assert(token.transferFrom(from, to, value));
161     }
162 
163     function safeApprove(ERC20 token, address spender, uint256 value) internal {
164         assert(token.approve(spender, value));
165     }
166 }
167 
168 contract StandardToken is ERC20, BasicToken {
169 
170     mapping (address => mapping (address => uint256)) internal allowed;
171 
172 
173     /**
174      * @dev Transfer tokens from one address to another
175      * @param _from address The address which you want to send tokens from
176      * @param _to address The address which you want to transfer to
177      * @param _value uint256 the amount of tokens to be transferred
178      */
179     function transferFrom(address _from, address _to, uint256 _value) public returns (bool) {
180         require(_to != address(0));
181         require(_value <= balances[_from]);
182         require(_value <= allowed[_from][msg.sender]);
183 
184         balances[_from] = balances[_from].sub(_value);
185         balances[_to] = balances[_to].add(_value);
186         allowed[_from][msg.sender] = allowed[_from][msg.sender].sub(_value);
187         Transfer(_from, _to, _value);
188         return true;
189     }
190 
191     /**
192      * @dev Approve the passed address to spend the specified amount of tokens on behalf of msg.sender.
193      *
194      * Beware that changing an allowance with this method brings the risk that someone may use both the old
195      * and the new allowance by unfortunate transaction ordering. One possible solution to mitigate this
196      * race condition is to first reduce the spender's allowance to 0 and set the desired value afterwards:
197      * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
198      * @param _spender The address which will spend the funds.
199      * @param _value The amount of tokens to be spent.
200      */
201     function approve(address _spender, uint256 _value) public returns (bool) {
202         allowed[msg.sender][_spender] = _value;
203         Approval(msg.sender, _spender, _value);
204         return true;
205     }
206 
207     /**
208      * @dev Function to check the amount of tokens that an owner allowed to a spender.
209      * @param _owner address The address which owns the funds.
210      * @param _spender address The address which will spend the funds.
211      * @return A uint256 specifying the amount of tokens still available for the spender.
212      */
213     function allowance(address _owner, address _spender) public view returns (uint256) {
214         return allowed[_owner][_spender];
215     }
216 
217     /**
218      * @dev Increase the amount of tokens that an owner allowed to a spender.
219      *
220      * approve should be called when allowed[_spender] == 0. To increment
221      * allowed value is better to use this function to avoid 2 calls (and wait until
222      * the first transaction is mined)
223      * From MonolithDAO Token.sol
224      * @param _spender The address which will spend the funds.
225      * @param _addedValue The amount of tokens to increase the allowance by.
226      */
227     function increaseApproval(address _spender, uint _addedValue) public returns (bool) {
228         allowed[msg.sender][_spender] = allowed[msg.sender][_spender].add(_addedValue);
229         Approval(msg.sender, _spender, allowed[msg.sender][_spender]);
230         return true;
231     }
232 
233     /**
234      * @dev Decrease the amount of tokens that an owner allowed to a spender.
235      *
236      * approve should be called when allowed[_spender] == 0. To decrement
237      * allowed value is better to use this function to avoid 2 calls (and wait until
238      * the first transaction is mined)
239      * From MonolithDAO Token.sol
240      * @param _spender The address which will spend the funds.
241      * @param _subtractedValue The amount of tokens to decrease the allowance by.
242      */
243     function decreaseApproval(address _spender, uint _subtractedValue) public returns (bool) {
244         uint oldValue = allowed[msg.sender][_spender];
245         if (_subtractedValue > oldValue) {
246             allowed[msg.sender][_spender] = 0;
247         } else {
248             allowed[msg.sender][_spender] = oldValue.sub(_subtractedValue);
249         }
250         Approval(msg.sender, _spender, allowed[msg.sender][_spender]);
251         return true;
252     }
253 
254 }
255 
256 contract PixelToken is StandardToken, BurnableToken, Ownable {
257     using SafeMath for uint;
258 
259     string constant public symbol = "PXLT";
260     string constant public name = "Pixel Crowdsale Token";
261 
262     uint8 constant public decimals = 18;
263     uint256 INITIAL_SUPPLY = 20000000e18;
264 
265     uint constant ITSStartTime = 1523350800; //  Tuesday, April 10, 2018 5:00:00 PM
266     uint constant ITSEndTime = 1526446800; // Wednesday, May 16, 2018 5:00:00 AM
267     uint constant unlockTime = 1546300800; //  Tuesday, January 1, 2019 12:00:00 AM
268 
269     address company = 0x5028aea7b621782ca58fe066b5b16b4fe2ead8d6;
270     address team = 0x628f126d16acf0ba234f5ece4aa5bc2baba7ffda;
271 
272     address crowdsale = 0x7085a139792aec99514352a3cfa657cdd4aeabbc;
273     address bounty = 0x214c50f0133943f06060ee693353d91ef2c693c7;
274 
275     address beneficiary = 0x143f85a5e90ed6a1409536a723589203b59bbe7e;
276 
277     uint constant companyTokens = 2400000e18;
278     uint constant teamTokens = 1800000e18;
279     uint constant crowdsaleTokens = 15000000e18;
280     uint constant bountyTokens = 800000e18;
281 
282     function PixelToken() public {
283 
284         totalSupply_ = INITIAL_SUPPLY;
285 
286         // InitialDistribution
287         preSale(company, companyTokens);
288         preSale(team, teamTokens);
289         preSale(crowdsale, crowdsaleTokens);
290         preSale(bounty, bountyTokens);
291     }
292 
293     function preSale(address _address, uint _amount) internal returns (bool) {
294         balances[_address] = _amount;
295         Transfer(address(0x0), _address, _amount);
296     }
297 
298     function checkPermissions(address _from) internal constant returns (bool) {
299 
300         if (_from == team && now < unlockTime) {
301             return false;
302         }
303 
304         if (_from == bounty || _from == crowdsale || _from == company) {
305             return true;
306         }
307 
308         if (now < ITSEndTime) {
309             return false;
310         } else {
311             return true;
312         }
313 
314     }
315 
316     function transfer(address _to, uint256 _value) public returns (bool) {
317 
318         require(checkPermissions(msg.sender));
319         super.transfer(_to, _value);
320     }
321 
322     function transferFrom(address _from, address _to, uint256 _value) public returns (bool) {
323 
324         require(checkPermissions(_from));
325         super.transferFrom(_from, _to, _value);
326     }
327 
328     function () public payable {
329         require(msg.value >= 1e16);
330         beneficiary.transfer(msg.value);
331     }
332 
333 }