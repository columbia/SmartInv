1 pragma solidity 0.4.18;
2 
3 /**
4  * @title SafeMath
5  * @dev Math operations with safety checks that throw on error
6  */
7 library SafeMath {
8     function mul(uint256 a, uint256 b) internal pure returns (uint256) {
9         uint256 c = a * b;
10         assert(a == 0 || c / a == b);
11         return c;
12     }
13 
14     function div(uint256 a, uint256 b) internal pure returns (uint256) {
15         // assert(b > 0); // Solidity automatically throws when dividing by 0
16         uint256 c = a / b;
17         // assert(a == b * c + a % b); // There is no case in which this doesn't hold
18         return c;
19     }
20 
21     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
22         assert(b <= a);
23         return a - b;
24     }
25 
26     function add(uint256 a, uint256 b) internal pure returns (uint256) {
27         uint256 c = a + b;
28         require(c >= a);
29         return c;
30     }
31 }
32 
33 /**
34  * @title ERC20Basic
35  * @dev Simpler version of ERC20 interface
36  * @dev see https://github.com/ethereum/EIPs/issues/179
37  */
38 contract ERC20Basic {
39     uint256 public totalSupply;
40     function balanceOf(address who) public view returns (uint256);
41     function transfer(address to, uint256 value) public returns (bool);
42     event Transfer(address indexed from, address indexed to, uint256 value);
43 }
44 
45 /**
46  * @title Basic token
47  * @dev Basic version of StandardToken, with no allowances.
48  */
49 contract BasicToken is ERC20Basic {
50     using SafeMath for uint256;
51 
52     mapping(address => uint256) public balances;
53 
54     /**
55     * @dev transfer token for a specified address
56     * @param _to The address to transfer to.
57     * @param _value The amount to be transferred.
58     */
59     function transfer(address _to, uint256 _value) public returns (bool) {
60         require(_to != address(0));
61         require(_value <= balances[msg.sender]);
62 
63         // SafeMath.sub will throw if there is not enough balance.
64         balances[msg.sender] = balances[msg.sender].sub(_value);
65         balances[_to] = balances[_to].add(_value);
66         Transfer(msg.sender, _to, _value);
67         return true;
68     }
69 
70     /**
71     * @dev Gets the balance of the specified address.
72     * @param _owner The address to query the the balance of.
73     * @return An uint256 representing the amount owned by the passed address.
74     */
75     function balanceOf(address _owner) public view returns (uint256 balance) {
76         return balances[_owner];
77     }
78 
79 }
80 
81 /**
82  * @title ERC20 interface
83  * @dev see https://github.com/ethereum/EIPs/issues/20
84  */
85 contract ERC20 is ERC20Basic {
86     function allowance(address owner, address spender) public view returns (uint256);
87     function transferFrom(address from, address to, uint256 value) public returns (bool);
88     function approve(address spender, uint256 value) public returns (bool);
89     event Approval(address indexed owner, address indexed spender, uint256 value);
90 }
91 
92 /**
93  * @title SafeERC20
94  * @dev Wrappers around ERC20 operations that throw on failure.
95  * To use this library you can add a `using SafeERC20 for ERC20;` statement to your contract,
96  * which allows you to call the safe operations as `token.safeTransfer(...)`, etc.
97  */
98 library SafeERC20 {
99   function safeTransfer(ERC20Basic token, address to, uint256 value) internal {
100     assert(token.transfer(to, value));
101   }
102 
103   function safeTransferFrom(ERC20 token, address from, address to, uint256 value) internal {
104     assert(token.transferFrom(from, to, value));
105   }
106 
107   function safeApprove(ERC20 token, address spender, uint256 value) internal {
108     assert(token.approve(spender, value));
109   }
110 }
111 
112 /**
113  * @title TokenTimelock
114  * @dev TokenTimelock is a token holder contract that will allow a
115  * beneficiary to extract the tokens after a given release time
116  */
117 contract TokenTimelock {
118   using SafeERC20 for ERC20Basic;
119 
120   // ERC20 basic token contract being held
121   ERC20Basic public token;
122 
123   // beneficiary of tokens after they are released
124   address public beneficiary;
125 
126   // timestamp when token release is enabled
127   uint64 public releaseTime;
128 
129   function TokenTimelock(ERC20Basic _token, address _beneficiary, uint64 _releaseTime) public {
130     require(_releaseTime > uint64(block.timestamp));
131     token = _token;
132     beneficiary = _beneficiary;
133     releaseTime = _releaseTime;
134   }
135 
136   /**
137    * @notice Transfers tokens held by timelock to beneficiary.
138    */
139   function release() public {
140     require(uint64(block.timestamp) >= releaseTime);
141 
142     uint256 amount = token.balanceOf(this);
143     require(amount > 0);
144 
145     token.safeTransfer(beneficiary, amount);
146   }
147 }
148 
149 /**
150  * @title Standard ERC20 token
151  *
152  * @dev Implementation of the basic standard token.
153  * @dev https://github.com/ethereum/EIPs/issues/20
154  * @dev Based on code by FirstBlood: https://github.com/Firstbloodio/token/blob/master/smart_contract/FirstBloodToken.sol
155  */
156 contract StandardToken is ERC20, BasicToken {
157 
158     mapping (address => mapping (address => uint256)) internal allowed;
159 
160 
161     /**
162      * @dev Transfer tokens from one address to another
163      * @param _from address The address which you want to send tokens from
164      * @param _to address The address which you want to transfer to
165      * @param _value uint256 the amount of tokens to be transferred
166      */
167     function transferFrom(address _from, address _to, uint256 _value) public returns (bool) {
168         require(_to != address(0));
169         require(_value <= balances[_from]);
170         require(_value <= allowed[_from][msg.sender]);
171 
172         balances[_from] = balances[_from].sub(_value);
173         balances[_to] = balances[_to].add(_value);
174         allowed[_from][msg.sender] = allowed[_from][msg.sender].sub(_value);
175         Transfer(_from, _to, _value);
176         return true;
177     }
178 
179     /**
180      * @dev Approve the passed address to spend the specified amount of tokens on behalf of msg.sender.
181      *
182      * Beware that changing an allowance with this method brings the risk that someone may use both the old
183      * and the new allowance by unfortunate transaction ordering. One possible solution to mitigate this
184      * race condition is to first reduce the spender's allowance to 0 and set the desired value afterwards:
185      * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
186      * @param _spender The address which will spend the funds.
187      * @param _value The amount of tokens to be spent.
188      */
189     function approve(address _spender, uint256 _value) public returns (bool) {
190         allowed[msg.sender][_spender] = _value;
191         Approval(msg.sender, _spender, _value);
192         return true;
193     }
194 
195     /**
196      * @dev Function to check the amount of tokens that an owner allowed to a spender.
197      * @param _owner address The address which owns the funds.
198      * @param _spender address The address which will spend the funds.
199      * @return A uint256 specifying the amount of tokens still available for the spender.
200      */
201     function allowance(address _owner, address _spender) public view returns (uint256 remaining) {
202         return allowed[_owner][_spender];
203     }
204 
205     /**
206      * approve should be called when allowed[_spender] == 0. To increment
207      * allowed value is better to use this function to avoid 2 calls (and wait until
208      * the first transaction is mined)
209      * From MonolithDAO Token.sol
210      */
211     function increaseApproval (address _spender, uint _addedValue) public returns (bool success) {
212         allowed[msg.sender][_spender] = allowed[msg.sender][_spender].add(_addedValue);
213         Approval(msg.sender, _spender, allowed[msg.sender][_spender]);
214         return true;
215     }
216 
217     function decreaseApproval (address _spender, uint _subtractedValue) public returns (bool success) {
218         uint oldValue = allowed[msg.sender][_spender];
219         if (_subtractedValue > oldValue) {
220             allowed[msg.sender][_spender] = 0;
221         } else {
222             allowed[msg.sender][_spender] = oldValue.sub(_subtractedValue);
223         }
224         Approval(msg.sender, _spender, allowed[msg.sender][_spender]);
225         return true;
226     }
227 
228 }
229 
230 contract Owned {
231     address public owner;
232 
233     function Owned() public {
234         owner = msg.sender;
235     }
236 
237     modifier onlyOwner {
238         require(msg.sender == owner);
239         _;
240     }
241 }
242 
243 /// TokenDesk token contract ///
244 contract TokenDeskToken is StandardToken, Owned {
245     string public constant name = "TokenDesk";
246     string public constant symbol = "TDS";
247     uint256 public constant decimals = 18;
248 
249     /// Maximum tokens to be allocated.
250     uint256 public constant TOKENS_HARD_CAP = 20000000 * 10**decimals;
251 
252     /// Maximum tokens to be allocated on the sale (70% of the hard cap)
253     uint256 public constant TOKENS_SALE_HARD_CAP = 14000000 * 10**decimals;
254 
255     bool public tokenSaleClosed = false;
256 
257     // contract to be called to release the TD team tokens
258     address public timelockContractAddress;
259 
260     // seconds since 01.01.1970 to 24.12.2017 (both 00:00:00 o'clock UTC)
261     uint64 private date24Dec2017 = 1514073600;
262 
263     // seconds since 01.01.1970 to 01.01.2019 (both 00:00:00 o'clock UTC)
264     uint64 private date01Jan2019 = 1546300800;
265 
266     modifier inProgress {
267         require(totalSupply < TOKENS_SALE_HARD_CAP && !tokenSaleClosed);
268         _;
269     }
270 
271     modifier beforeEnd {
272         require(!tokenSaleClosed);
273         _;
274     }
275 
276     /// Either sale closed or 24 Dec 2017 passed
277     modifier tradingOpen {
278         require(tokenSaleClosed || (uint64(block.timestamp) > date24Dec2017));
279         _;
280     }
281 
282     function issueTokensMulti(address[] _addresses, uint256[] _tokensInteger) public onlyOwner inProgress {
283         require(_addresses.length == _tokensInteger.length);
284         require(_addresses.length <= 100);
285 
286         for (uint256 i = 0; i < _tokensInteger.length; i = i.add(1)) {
287             issueTokens(_addresses[i], _tokensInteger[i]);
288         }
289     }
290 
291     function issueTokens(address _investor, uint256 _tokensInteger) public onlyOwner inProgress {
292         require(_investor != address(0));
293 
294         uint256 tokens = _tokensInteger.mul(10**decimals);
295         // compute without actually increasing it
296         uint256 increasedTotalSupply = totalSupply.add(tokens);
297         // roll back if hard cap reached
298         require(increasedTotalSupply <= TOKENS_SALE_HARD_CAP);
299 
300         //increase token total supply
301         totalSupply = increasedTotalSupply;
302         //update the investors balance to number of tokens sent
303         balances[_investor] = balances[_investor].add(tokens);
304     }
305 
306     function close() public onlyOwner beforeEnd {
307         // final supply = investors tokens + team tokens
308         // team tokens = 30% final supply = 30/100 * final supply
309         // investors tokens = totalSupply = 70% final supply = 70/100 * final supply
310         // final supply = 100/70 * totalSupply
311         // team tokens = 30/70 * totalSupply = totalSupply * (3/7)
312 
313         uint256 teamTokens = totalSupply.mul(3).div(7);
314 
315         // check for rounding errors when cap is reached
316         if(totalSupply.add(teamTokens) > TOKENS_HARD_CAP) {
317             teamTokens = TOKENS_HARD_CAP.sub(totalSupply);
318         }
319 
320         /// lock until 01 Jan 2019
321         TokenTimelock lockedTeamTokens = new TokenTimelock(this, owner, date01Jan2019);
322         timelockContractAddress = address(lockedTeamTokens);
323         balances[timelockContractAddress] = balances[timelockContractAddress].add(teamTokens);
324         
325         /// increase token total supply
326         totalSupply = totalSupply.add(teamTokens);
327 
328         tokenSaleClosed = true;
329     }
330 
331     /// Transfer limited by the tradingOpen modifier (either sale closed or 24 Dec 2017 passed)
332     function transferFrom(address _from, address _to, uint256 _value) public tradingOpen returns (bool) {
333         return super.transferFrom(_from, _to, _value);
334     }
335 
336     /// Transfer limited by the tradingOpen modifier (either sale closed or 24 Dec 2017 passed)
337     function transfer(address _to, uint256 _value) public tradingOpen returns (bool) {
338         return super.transfer(_to, _value);
339     }
340 }