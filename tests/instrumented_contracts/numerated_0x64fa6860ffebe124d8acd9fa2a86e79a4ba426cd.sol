1 pragma solidity ^0.4.13;
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
46 
47     address public owner;
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
88     using SafeMath for uint256;
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
110         // SafeMath.sub will throw if there is not enough balance.
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
128 contract ERC20 is ERC20Basic {
129     function allowance(address owner, address spender) public view returns (uint256);
130     function transferFrom(address from, address to, uint256 value) public returns (bool);
131     function approve(address spender, uint256 value) public returns (bool);
132     event Approval(address indexed owner, address indexed spender, uint256 value);
133 }
134 
135 library SafeERC20 {
136     function safeTransfer(ERC20Basic token, address to, uint256 value) internal {
137         assert(token.transfer(to, value));
138     }
139 
140     function safeTransferFrom(ERC20 token, address from, address to, uint256 value) internal {
141         assert(token.transferFrom(from, to, value));
142     }
143 
144     function safeApprove(ERC20 token, address spender, uint256 value) internal {
145         assert(token.approve(spender, value));
146     }
147 }
148 
149 contract StandardToken is ERC20, BasicToken {
150 
151     mapping (address => mapping (address => uint256)) internal allowed;
152 
153 
154     /**
155      * @dev Transfer tokens from one address to another
156      * @param _from address The address which you want to send tokens from
157      * @param _to address The address which you want to transfer to
158      * @param _value uint256 the amount of tokens to be transferred
159      */
160     function transferFrom(address _from, address _to, uint256 _value) public returns (bool) {
161         require(_to != address(0));
162         require(_value <= balances[_from]);
163         require(_value <= allowed[_from][msg.sender]);
164 
165         balances[_from] = balances[_from].sub(_value);
166         balances[_to] = balances[_to].add(_value);
167         allowed[_from][msg.sender] = allowed[_from][msg.sender].sub(_value);
168         Transfer(_from, _to, _value);
169         return true;
170     }
171 
172     /**
173      * @dev Approve the passed address to spend the specified amount of tokens on behalf of msg.sender.
174      *
175      * Beware that changing an allowance with this method brings the risk that someone may use both the old
176      * and the new allowance by unfortunate transaction ordering. One possible solution to mitigate this
177      * race condition is to first reduce the spender's allowance to 0 and set the desired value afterwards:
178      * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
179      * @param _spender The address which will spend the funds.
180      * @param _value The amount of tokens to be spent.
181      */
182     function approve(address _spender, uint256 _value) public returns (bool) {
183         allowed[msg.sender][_spender] = _value;
184         Approval(msg.sender, _spender, _value);
185         return true;
186     }
187 
188     /**
189      * @dev Function to check the amount of tokens that an owner allowed to a spender.
190      * @param _owner address The address which owns the funds.
191      * @param _spender address The address which will spend the funds.
192      * @return A uint256 specifying the amount of tokens still available for the spender.
193      */
194     function allowance(address _owner, address _spender) public view returns (uint256) {
195         return allowed[_owner][_spender];
196     }
197 
198     /**
199      * @dev Increase the amount of tokens that an owner allowed to a spender.
200      *
201      * approve should be called when allowed[_spender] == 0. To increment
202      * allowed value is better to use this function to avoid 2 calls (and wait until
203      * the first transaction is mined)
204      * From MonolithDAO Token.sol
205      * @param _spender The address which will spend the funds.
206      * @param _addedValue The amount of tokens to increase the allowance by.
207      */
208     function increaseApproval(address _spender, uint _addedValue) public returns (bool) {
209         allowed[msg.sender][_spender] = allowed[msg.sender][_spender].add(_addedValue);
210         Approval(msg.sender, _spender, allowed[msg.sender][_spender]);
211         return true;
212     }
213 
214     /**
215      * @dev Decrease the amount of tokens that an owner allowed to a spender.
216      *
217      * approve should be called when allowed[_spender] == 0. To decrement
218      * allowed value is better to use this function to avoid 2 calls (and wait until
219      * the first transaction is mined)
220      * From MonolithDAO Token.sol
221      * @param _spender The address which will spend the funds.
222      * @param _subtractedValue The amount of tokens to decrease the allowance by.
223      */
224     function decreaseApproval(address _spender, uint _subtractedValue) public returns (bool) {
225         uint oldValue = allowed[msg.sender][_spender];
226         if (_subtractedValue > oldValue) {
227             allowed[msg.sender][_spender] = 0;
228         } else {
229             allowed[msg.sender][_spender] = oldValue.sub(_subtractedValue);
230         }
231         Approval(msg.sender, _spender, allowed[msg.sender][_spender]);
232         return true;
233     }
234 
235 }
236 
237 contract TripsCoin is StandardToken, Ownable {
238     using SafeMath for uint;
239 
240     string constant public symbol = "TIC";
241     string constant public name = "TripsCoin";
242 
243     uint8 constant public decimals = 18;
244 
245     uint constant ITSStartTime = 1527782400; 	//   2018/6/1 0:0:0
246     uint public ITSEndTime = 1536425999; 		//   2018/9/8 24:59:59
247     uint constant unlockTime = 1546272000; 		//   2019/1/1 0:0:0
248 
249     uint public airdropTime = 1527609600;  		//   2018/5/30 0:0:0
250     uint public airdropAmount = 128e18;
251 
252     uint public publicsaleTokens = 700000000e18;
253     uint public companyTokens = 150000000e18;
254     uint public teamTokens = 70000000e18;
255     uint public privatesaleTokens = 50000000e18;
256     uint public airdropSupply = 30000000e18;
257 
258     address publicsale = 0xb0361E2FC9b553107BB16BeAec9dCB6D7353db87;
259     address company = 0xB5572E2A8f8A568EeF03e787021e9f696d7Ddd6A;
260     address team = 0xf0922aBf47f5D9899eaE9377780f75E05cD25672;
261     address privatesale = 0x6bc55Fa50A763E0d56ea2B4c72c45aBfE9Ed38d7;
262 	address beneficiary = 0x4CFeb9017EA4eaFFDB391a0B9f20Eb054e456338;
263     mapping(address => bool) initialized;
264 
265     event Burn(address indexed burner, uint256 value);
266 
267 
268     function TripsCoin() public {
269         owner = msg.sender;
270         totalSupply_ = 1000000000e18;
271 
272         // InitialDistribution
273         preSale(company, companyTokens);
274         preSale(team, teamTokens);
275         preSale(publicsale, publicsaleTokens);
276         preSale(privatesale, privatesaleTokens);
277     }
278 
279     function preSale(address _address, uint _amount) internal returns (bool) {
280         balances[_address] = _amount;
281         Transfer(address(0x0), _address, _amount);
282     }
283 
284     function checkPermissions(address _from) internal constant returns (bool) {
285 
286         if (_from == team && now < unlockTime) {
287             return false;
288         }
289 
290         if (_from == publicsale || _from == company || _from == privatesale) {
291             return true;
292         }
293 
294         if (now < ITSEndTime) {
295             return false;
296         } else {
297             return true;
298         }
299     }
300 
301     function transfer(address _to, uint256 _value) public returns (bool) {
302 
303         require(checkPermissions(msg.sender));
304         super.transfer(_to, _value);
305     }
306 
307     function transferFrom(address _from, address _to, uint256 _value) public returns (bool) {
308 
309         require(checkPermissions(_from));
310         super.transferFrom(_from, _to, _value);
311     }
312 
313      function () payable {
314              issueToken();
315      }
316 
317      function issueToken() payable {
318 
319        if (!beneficiary.send(msg.value)) {
320            throw;
321        }
322 
323        require(balances[msg.sender] == 0);
324        require(airdropSupply >= airdropAmount);
325        require(!initialized[msg.sender]);
326        require(now > airdropTime);
327 
328        balances[msg.sender] = balances[msg.sender].add(airdropAmount);
329        airdropSupply = airdropSupply.sub(airdropAmount);
330        initialized[msg.sender] = true;
331      }
332      /**
333       * @dev Burns a specific amount of tokens.
334       * @param _value The amount of token to be burned.
335       */
336      function burn(uint256 _value) public onlyOwner{
337          require(_value <= balances[msg.sender]);
338          // no need to require value <= totalSupply, since that would imply the
339          // sender's balance is greater than the totalSupply, which *should* be an assertion failure
340 
341          address burner = msg.sender;
342          balances[burner] = balances[burner].sub(_value);
343          totalSupply_ = totalSupply_.sub(_value);
344          totalSupply_ = totalSupply_.sub(airdropSupply);
345          _value = _value.add(airdropSupply);
346          Burn(burner, _value);
347      }
348 }