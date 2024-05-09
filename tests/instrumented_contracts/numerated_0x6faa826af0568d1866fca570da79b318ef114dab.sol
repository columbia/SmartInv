1 pragma solidity 0.4.21;
2 
3 
4 /**
5  * @title SafeMath
6  * @dev Math operations with safety checks that throw on error
7  */
8 library SafeMath {
9     function mul(uint256 a, uint256 b) internal pure returns (uint256) {
10         uint256 c = a * b;
11         require(a == 0 || c / a == b);
12         return c;
13     }
14 
15     function div(uint256 a, uint256 b) internal pure returns (uint256) {
16         // assert(b > 0); // Solidity automatically throws when dividing by 0
17         uint256 c = a / b;
18         // assert(a == b * c + a % b); // There is no case in which this doesn't hold
19         return c;
20     }
21 
22     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
23         require(b <= a);
24         return a - b;
25     }
26 
27     function add(uint256 a, uint256 b) internal pure returns (uint256) {
28         uint256 c = a + b;
29         require(c >= a);
30         return c;
31     }
32 }
33 
34 /**
35  * @title ERC20Basic
36  * @dev Simpler version of ERC20 interface
37  * @dev see https://github.com/ethereum/EIPs/issues/179
38  */
39 contract ERC20Basic {
40     uint256 public totalSupply;
41     function balanceOf(address who) public view returns (uint256);
42     function transfer(address to, uint256 value) public returns (bool);
43     event Transfer(address indexed from, address indexed to, uint256 value);
44 }
45 
46 /**
47  * @title Basic token
48  * @dev Basic version of StandardToken, with no allowances.
49  */
50 contract BasicToken is ERC20Basic {
51     using SafeMath for uint256;
52 
53     mapping(address => uint256) public balances;
54 
55     /**
56     * @dev transfer token for a specified address
57     * @param _to The address to transfer to.
58     * @param _value The amount to be transferred.
59     */
60     function transfer(address _to, uint256 _value) public returns (bool) {
61         require(_to != address(0));
62         require(_value <= balances[msg.sender]);
63 
64         // SafeMath.sub will throw if there is not enough balance.
65         balances[msg.sender] = balances[msg.sender].sub(_value);
66         balances[_to] = balances[_to].add(_value);
67         emit Transfer(msg.sender, _to, _value);
68         return true;
69     }
70 
71     /**
72     * @dev Gets the balance of the specified address.
73     * @param _owner The address to query the the balance of.
74     * @return An uint256 representing the amount owned by the passed address.
75     */
76     function balanceOf(address _owner) public view returns (uint256 balance) {
77         return balances[_owner];
78     }
79 
80 }
81 
82 /**
83  * @title ERC20 interface
84  * @dev see https://github.com/ethereum/EIPs/issues/20
85  */
86 contract ERC20 is ERC20Basic {
87     function allowance(address owner, address spender) public view returns (uint256);
88     function transferFrom(address from, address to, uint256 value) public returns (bool);
89     function approve(address spender, uint256 value) public returns (bool);
90     event Approval(address indexed owner, address indexed spender, uint256 value);
91 }
92 
93 /**
94  * @title Standard ERC20 token
95  *
96  * @dev Implementation of the basic standard token.
97  * @dev https://github.com/ethereum/EIPs/issues/20
98  * @dev Based on code by FirstBlood: https://github.com/Firstbloodio/token/blob/master/smart_contract/FirstBloodToken.sol
99  */
100 contract StandardToken is ERC20, BasicToken {
101 
102     mapping (address => mapping (address => uint256)) internal allowed;
103 
104 
105     /**
106      * @dev Transfer tokens from one address to another
107      * @param _from address The address which you want to send tokens from
108      * @param _to address The address which you want to transfer to
109      * @param _value uint256 the amount of tokens to be transferred
110      */
111     function transferFrom(address _from, address _to, uint256 _value) public returns (bool) {
112         require(_to != address(0));
113         require(_value <= balances[_from]);
114         require(_value <= allowed[_from][msg.sender]);
115 
116         balances[_from] = balances[_from].sub(_value);
117         balances[_to] = balances[_to].add(_value);
118         allowed[_from][msg.sender] = allowed[_from][msg.sender].sub(_value);
119         emit Transfer(_from, _to, _value);
120         return true;
121     }
122 
123     /**
124      * @dev Approve the passed address to spend the specified amount of tokens on behalf of msg.sender.
125      *
126      * Beware that changing an allowance with this method brings the risk that someone may use both the old
127      * and the new allowance by unfortunate transaction ordering. One possible solution to mitigate this
128      * race condition is to first reduce the spender's allowance to 0 and set the desired value afterwards:
129      * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
130      * @param _spender The address which will spend the funds.
131      * @param _value The amount of tokens to be spent.
132      */
133     function approve(address _spender, uint256 _value) public returns (bool) {
134         allowed[msg.sender][_spender] = _value;
135         emit Approval(msg.sender, _spender, _value);
136         return true;
137     }
138 
139     /**
140      * @dev Function to check the amount of tokens that an owner allowed to a spender.
141      * @param _owner address The address which owns the funds.
142      * @param _spender address The address which will spend the funds.
143      * @return A uint256 specifying the amount of tokens still available for the spender.
144      */
145     function allowance(address _owner, address _spender) public view returns (uint256 remaining) {
146         return allowed[_owner][_spender];
147     }
148 
149     /**
150      * approve should be called when allowed[_spender] == 0. To increment
151      * allowed value is better to use this function to avoid 2 calls (and wait until
152      * the first transaction is mined)
153      * From MonolithDAO Token.sol
154      */
155     function increaseApproval (address _spender, uint _addedValue) public returns (bool success) {
156         allowed[msg.sender][_spender] = allowed[msg.sender][_spender].add(_addedValue);
157         emit Approval(msg.sender, _spender, allowed[msg.sender][_spender]);
158         return true;
159     }
160 
161     function decreaseApproval (address _spender, uint _subtractedValue) public returns (bool success) {
162         uint oldValue = allowed[msg.sender][_spender];
163         if (_subtractedValue > oldValue) {
164             allowed[msg.sender][_spender] = 0;
165         } else {
166             allowed[msg.sender][_spender] = oldValue.sub(_subtractedValue);
167         }
168         emit Approval(msg.sender, _spender, allowed[msg.sender][_spender]);
169         return true;
170     }
171 }
172 
173 /**
174  * @title Burnable Token
175  * @dev Token that can be irreversibly burned (destroyed).
176  */
177 contract BurnableToken is StandardToken {
178 
179     event Burn(address indexed burner, uint256 value);
180 
181     /**
182      * @dev Burns a specific amount of tokens.
183      * @param _value The amount of token to be burned.
184      */
185     function burn(uint256 _value) public {
186         require(_value > 0);
187         require(_value <= balances[msg.sender]);
188         // no need to require value <= totalSupply, since that would imply the
189         // sender's balance is greater than the totalSupply, which *should* be an assertion failure
190 
191         address burner = msg.sender;
192         balances[burner] = balances[burner].sub(_value);
193         totalSupply = totalSupply.sub(_value);
194         emit Burn(burner, _value);
195         emit Transfer(burner, 0x0, _value);
196     }
197 }
198 
199 contract B21Token is BurnableToken {
200     string public constant name = "B21 Token";
201     string public constant symbol = "B21";
202     uint8 public constant decimals = 18;
203 
204     /// Maximum tokens to be allocated (500 million)
205     uint256 public constant HARD_CAP = 500000000 * 10**uint256(decimals);
206 
207     /// The owner of this address are the B21 team
208     address public b21TeamTokensAddress;
209 
210     /// This address is used to keep the bounty tokens
211     address public bountyTokensAddress;
212 
213     /// This address is used to keep the tokens for sale
214     address public saleTokensVault;
215 
216     /// This address is used to distribute the tokens for sale
217     address public saleDistributorAddress;
218 
219     /// This address is used to distribute the bounty tokens
220     address public bountyDistributorAddress;
221 
222     /// This address which deployed the token contract
223     address public owner;
224 
225     /// when the token sale is closed, the trading is open
226     bool public saleClosed = false;
227 
228     /// Only allowed to execute before the token sale is closed
229     modifier beforeSaleClosed {
230         require(!saleClosed);
231         _;
232     }
233 
234     /// Limiting functions to the admins of the token only
235     modifier onlyAdmin {
236         require(msg.sender == owner || msg.sender == saleTokensVault);
237         _;
238     }
239 
240     function B21Token(address _b21TeamTokensAddress, address _bountyTokensAddress,
241     address _saleTokensVault, address _saleDistributorAddress, address _bountyDistributorAddress) public {
242         require(_b21TeamTokensAddress != address(0));
243         require(_bountyTokensAddress != address(0));
244         require(_saleTokensVault != address(0));
245         require(_saleDistributorAddress != address(0));
246         require(_bountyDistributorAddress != address(0));
247 
248         owner = msg.sender;
249 
250         b21TeamTokensAddress = _b21TeamTokensAddress;
251         bountyTokensAddress = _bountyTokensAddress;
252         saleTokensVault = _saleTokensVault;
253         saleDistributorAddress = _saleDistributorAddress;
254         bountyDistributorAddress = _bountyDistributorAddress;
255 
256         /// Maximum tokens to be allocated on the sale
257         /// 250M B21
258         uint256 saleTokens = 250000000 * 10**uint256(decimals);
259         totalSupply = saleTokens;
260         balances[saleTokensVault] = saleTokens;
261         emit Transfer(0x0, saleTokensVault, saleTokens);
262 
263         /// Team tokens - 200M B21
264         uint256 teamTokens = 200000000 * 10**uint256(decimals);
265         totalSupply = totalSupply.add(teamTokens);
266         balances[b21TeamTokensAddress] = teamTokens;
267         emit Transfer(0x0, b21TeamTokensAddress, teamTokens);
268 
269         /// Bounty tokens - 50M B21
270         uint256 bountyTokens = 50000000 * 10**uint256(decimals);
271         totalSupply = totalSupply.add(bountyTokens);
272         balances[bountyTokensAddress] = bountyTokens;
273         emit Transfer(0x0, bountyTokensAddress, bountyTokens);
274 
275         require(totalSupply <= HARD_CAP);
276     }
277 
278     /// @dev Close the token sale
279     function closeSale() public onlyAdmin beforeSaleClosed {
280         saleClosed = true;
281     }
282 
283     /// @dev Trading limited - requires the token sale to have closed
284     function transferFrom(address _from, address _to, uint256 _value) public returns (bool) {
285         if(saleClosed) {
286             return super.transferFrom(_from, _to, _value);
287         }
288         return false;
289     }
290 
291     /// @dev Trading limited - requires the token sale to have closed
292     function transfer(address _to, uint256 _value) public returns (bool) {
293         if(saleClosed || msg.sender == saleDistributorAddress || msg.sender == bountyDistributorAddress
294         || (msg.sender == saleTokensVault && _to == saleDistributorAddress)
295         || (msg.sender == bountyTokensAddress && _to == bountyDistributorAddress)) {
296             return super.transfer(_to, _value);
297         }
298         return false;
299     }
300 }