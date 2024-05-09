1 pragma solidity ^0.4.13;
2 
3 library Cyber {
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
48 
49     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
50 
51 
52     /**
53      * @dev The Ownable constructor sets the original `owner` of the contract to the sender
54      * account.
55      */
56     function Ownable() public {
57         owner = msg.sender;
58     }
59 
60     /**
61      * @dev Throws if called by any account other than the owner.
62      */
63     modifier onlyOwner() {
64         require(msg.sender == owner);
65         _;
66     }
67 
68     /**
69      * @dev Allows the current owner to transfer control of the contract to a newOwner.
70      * @param newOwner The address to transfer ownership to.
71      */
72     function transferOwnership(address newOwner) public onlyOwner {
73         require(newOwner != address(0));
74         OwnershipTransferred(owner, newOwner);
75         owner = newOwner;
76     }
77 
78 }
79 
80 contract ERC20Basic {
81     function totalSupply() public view returns (uint256);
82     function balanceOf(address who) public view returns (uint256);
83     function transfer(address to, uint256 value) public returns (bool);
84     event Transfer(address indexed from, address indexed to, uint256 value);
85 }
86 
87 contract BasicToken is ERC20Basic {
88     using Cyber for uint256;
89 
90     mapping(address => uint256) balances;
91 
92     uint256 totalSupply_;
93 
94     /**
95     * @dev total number of tokens in existence
96     */
97     function totalSupply() public view returns (uint256) {
98         return totalSupply_;
99     }
100 
101     /**
102     * @dev transfer token for a specified address
103     * @param _to The address to transfer to.
104     * @param _value The amount to be transferred.
105     */
106     function transfer(address _to, uint256 _value) public returns (bool) {
107         require(_to != address(0));
108         require(_value <= balances[msg.sender]);
109 
110         // Cyber.sub will throw if there is not enough balance.
111         balances[msg.sender] = balances[msg.sender].sub(_value);
112         balances[_to] = balances[_to].add(_value);
113         Transfer(msg.sender, _to, _value);
114         return true;
115     }
116 
117     /**
118     * @dev Gets the balance of the specified address.
119     * @param _owner The address to query the the balance of.
120     * @return An uint256 representing the amount owned by the passed address.
121     */
122     function balanceOf(address _owner) public view returns (uint256 balance) {
123         return balances[_owner];
124     }
125 
126 }
127 
128 contract BurnableToken is BasicToken {
129 
130     event Burn(address indexed burner, uint256 value);
131 
132     /**
133      * @dev Burns a specific amount of tokens.
134      * @param _value The amount of token to be burned.
135      */
136     function burn(uint256 _value) public {
137         require(_value <= balances[msg.sender]);
138         // no need to require value <= totalSupply, since that would imply the
139         // sender's balance is greater than the totalSupply, which *should* be an assertion failure
140 
141         address burner = msg.sender;
142         balances[burner] = balances[burner].sub(_value);
143         totalSupply_ = totalSupply_.sub(_value);
144         Burn(burner, _value);
145     }
146 }
147 
148 contract ERC20 is ERC20Basic {
149     function allowance(address owner, address spender) public view returns (uint256);
150     function transferFrom(address from, address to, uint256 value) public returns (bool);
151     function approve(address spender, uint256 value) public returns (bool);
152     event Approval(address indexed owner, address indexed spender, uint256 value);
153 }
154 
155 library SafeERC20 {
156     function safeTransfer(ERC20Basic token, address to, uint256 value) internal {
157         assert(token.transfer(to, value));
158     }
159 
160     function safeTransferFrom(ERC20 token, address from, address to, uint256 value) internal {
161         assert(token.transferFrom(from, to, value));
162     }
163 
164     function safeApprove(ERC20 token, address spender, uint256 value) internal {
165         assert(token.approve(spender, value));
166     }
167 }
168 
169 contract StandardToken is ERC20, BasicToken {
170 
171     mapping (address => mapping (address => uint256)) internal allowed;
172 
173 
174     /**
175      * @dev Transfer tokens from one address to another
176      * @param _from address The address which you want to send tokens from
177      * @param _to address The address which you want to transfer to
178      * @param _value uint256 the amount of tokens to be transferred
179      */
180     function transferFrom(address _from, address _to, uint256 _value) public returns (bool) {
181         require(_to != address(0));
182         require(_value <= balances[_from]);
183         require(_value <= allowed[_from][msg.sender]);
184 
185         balances[_from] = balances[_from].sub(_value);
186         balances[_to] = balances[_to].add(_value);
187         allowed[_from][msg.sender] = allowed[_from][msg.sender].sub(_value);
188         Transfer(_from, _to, _value);
189         return true;
190     }
191 
192     /**
193      * @dev Approve the passed address to spend the specified amount of tokens on behalf of msg.sender.
194      *
195      * Beware that changing an allowance with this method brings the risk that someone may use both the old
196      * and the new allowance by unfortunate transaction ordering. One possible solution to mitigate this
197      * race condition is to first reduce the spender's allowance to 0 and set the desired value afterwards:
198      * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
199      * @param _spender The address which will spend the funds.
200      * @param _value The amount of tokens to be spent.
201      */
202     function approve(address _spender, uint256 _value) public returns (bool) {
203         allowed[msg.sender][_spender] = _value;
204         Approval(msg.sender, _spender, _value);
205         return true;
206     }
207 
208     /**
209      * @dev Function to check the amount of tokens that an owner allowed to a spender.
210      * @param _owner address The address which owns the funds.
211      * @param _spender address The address which will spend the funds.
212      * @return A uint256 specifying the amount of tokens still available for the spender.
213      */
214     function allowance(address _owner, address _spender) public view returns (uint256) {
215         return allowed[_owner][_spender];
216     }
217 
218     /**
219      * @dev Increase the amount of tokens that an owner allowed to a spender.
220      *
221      * approve should be called when allowed[_spender] == 0. To increment
222      * allowed value is better to use this function to avoid 2 calls (and wait until
223      * the first transaction is mined)
224      * From MonolithDAO Token.sol
225      * @param _spender The address which will spend the funds.
226      * @param _addedValue The amount of tokens to increase the allowance by.
227      */
228     function increaseApproval(address _spender, uint _addedValue) public returns (bool) {
229         allowed[msg.sender][_spender] = allowed[msg.sender][_spender].add(_addedValue);
230         Approval(msg.sender, _spender, allowed[msg.sender][_spender]);
231         return true;
232     }
233 
234     /**
235      * @dev Decrease the amount of tokens that an owner allowed to a spender.
236      *
237      * approve should be called when allowed[_spender] == 0. To decrement
238      * allowed value is better to use this function to avoid 2 calls (and wait until
239      * the first transaction is mined)
240      * From MonolithDAO Token.sol
241      * @param _spender The address which will spend the funds.
242      * @param _subtractedValue The amount of tokens to decrease the allowance by.
243      */
244     function decreaseApproval(address _spender, uint _subtractedValue) public returns (bool) {
245         uint oldValue = allowed[msg.sender][_spender];
246         if (_subtractedValue > oldValue) {
247             allowed[msg.sender][_spender] = 0;
248         } else {
249             allowed[msg.sender][_spender] = oldValue.sub(_subtractedValue);
250         }
251         Approval(msg.sender, _spender, allowed[msg.sender][_spender]);
252         return true;
253     }
254 
255 }
256 
257 contract CyberRailNET is StandardToken, BurnableToken, Ownable {
258     using Cyber for uint;
259 
260     string constant public symbol = "CRNT";
261     string constant public name = "CyberRailNET";
262 
263     uint8 constant public decimals = 18;
264     uint256 INITIAL_SUPPLY = 100000000e18;
265 
266     uint constant ITSStartTime = 1521640800;
267     uint constant ITSEndTime = 1525184400;
268     uint constant unlockTime = 1546300800;
269 
270     address company = 0xb1F0E186C5565BC307b68B62caBAeD9C907eFd52;
271     address team = 0x9530D6F3c4c1d6F6dF85C7977121f202f8250F81;
272 
273     address crowdsale = 0xb775FE20D71DaafEA1747eF48dC9398361c3c6f9;
274     address bounty = 0x6a90c521501C1c00039677bD78b6A4b1AAB0fAFb;
275 
276     address beneficiary = 0x506b773d1DDF79674da4e4440577a50a2923bBf4;
277 
278     uint constant companyTokens = 22000000e18;
279     uint constant teamTokens = 500000e18;
280     uint constant crowdsaleTokens = 25000000e18;
281     uint constant bountyTokens = 20000000e18;
282 
283 
284     function CyberRailNET() public {
285 
286         totalSupply_ = INITIAL_SUPPLY;
287 
288         // InitialDistribution
289         preSale(company, companyTokens);
290         preSale(team, teamTokens);
291         preSale(crowdsale, crowdsaleTokens);
292         preSale(bounty, bountyTokens);
293 
294         // Pre-Sale
295         preSale(0x6984b3344790446fa7985bd745ed085fAE58B0c5, 20000000e18);
296         preSale(0x5F8091556ecE67934a8D459bC10E1194840EFf77, 10000000e18);
297     }
298 
299     function preSale(address _address, uint _amount) internal returns (bool) {
300         balances[_address] = _amount;
301         Transfer(address(0x0), _address, _amount);
302     }
303 
304     function checkPermissions(address _from) internal constant returns (bool) {
305 
306         if (_from == team && now < unlockTime) {
307             return false;
308         }
309 
310         if (_from == bounty || _from == crowdsale || _from == company) {
311             return true;
312         }
313 
314         if (now < ITSEndTime) {
315             return false;
316         } else {
317             return true;
318         }
319 
320     }
321 
322     function transfer(address _to, uint256 _value) public returns (bool) {
323 
324         require(checkPermissions(msg.sender));
325         super.transfer(_to, _value);
326     }
327 
328     function transferFrom(address _from, address _to, uint256 _value) public returns (bool) {
329 
330         require(checkPermissions(_from));
331         super.transferFrom(_from, _to, _value);
332     }
333 
334     function () public payable {
335         require(msg.value >= 1e16);
336         beneficiary.transfer(msg.value);
337     }
338 
339 }