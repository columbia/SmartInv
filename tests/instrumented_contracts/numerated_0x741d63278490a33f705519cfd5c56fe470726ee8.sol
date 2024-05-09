1 pragma solidity ^0.4.24;
2 
3 library SafeMath {
4 
5     function mul(uint256 _a, uint256 _b) internal pure returns (uint256 c) {
6         if (_a == 0) {
7             return 0;
8         }
9 
10         c = _a * _b;
11         assert(c / _a == _b);
12         return c;
13     }
14 
15     function div(uint256 _a, uint256 _b) internal pure returns (uint256) {
16         return _a / _b;
17     }
18 
19     function sub(uint256 _a, uint256 _b) internal pure returns (uint256) {
20         assert(_b <= _a);
21         return _a - _b;
22     }
23 
24     function add(uint256 _a, uint256 _b) internal pure returns (uint256 c) {
25         c = _a + _b;
26         assert(c >= _a);
27         return c;
28     }
29 }
30 
31 
32 
33 
34 
35 contract BaseSKOToken {
36     using SafeMath for uint256;
37 
38     // Globals
39     address public owner;
40     mapping(address => uint256) internal balances;
41     mapping (address => mapping (address => uint256)) internal allowed;
42     uint256 internal totalSupply_;
43 
44     // Events
45     event Transfer(address indexed from, address indexed to, uint256 value);
46     event Approval(address indexed owner, address indexed spender, uint256 value);
47     event Burn(address indexed burner, uint256 value);
48     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
49     event Mint(address indexed to, uint256 amount);
50 
51     // Modifiers
52     modifier onlyOwner() {
53         require(msg.sender == owner,"Only the owner is allowed to call this.");
54         _;
55     }
56 
57     constructor() public{
58         owner = msg.sender;
59     }
60 
61     /**
62     * @dev Total number of tokens in existence
63     */
64     function totalSupply() public view returns (uint256) {
65         return totalSupply_;
66     }
67 
68     /**
69     * @dev Transfer token for a specified address
70     * @param _to The address to transfer to.
71     * @param _value The amount to be transferred.
72     */
73     function transfer(address _to, uint256 _value) public returns (bool) {
74         require(_value <= balances[msg.sender], "You do not have sufficient balance.");
75         require(_to != address(0), "You cannot send tokens to 0 address");
76 
77         balances[msg.sender] = balances[msg.sender].sub(_value);
78         balances[_to] = balances[_to].add(_value);
79         emit Transfer(msg.sender, _to, _value);
80         return true;
81     }
82 
83     /**
84     * @dev Gets the balance of the specified address.
85     * @param _owner The address to query the the balance of.
86     * @return An uint256 representing the amount owned by the passed address.
87     */
88     function balanceOf(address _owner) public view returns (uint256) {
89         return balances[_owner];
90     }
91 
92     /**
93     * @dev Transfer tokens from one address to another
94     * @param _from address The address which you want to send tokens from
95     * @param _to address The address which you want to transfer to
96     * @param _value uint256 the amount of tokens to be transferred
97     */
98     function transferFrom(address _from, address _to, uint256 _value) public returns (bool){
99         require(_value <= balances[_from], "You do not have sufficient balance.");
100         require(_value <= allowed[_from][msg.sender], "You do not have allowance.");
101         require(_to != address(0), "You cannot send tokens to 0 address");
102 
103         balances[_from] = balances[_from].sub(_value);
104         balances[_to] = balances[_to].add(_value);
105         allowed[_from][msg.sender] = allowed[_from][msg.sender].sub(_value);
106         emit Transfer(_from, _to, _value);
107         return true;
108     }
109 
110     /**
111     * @dev Approve the passed address to spend the specified amount of tokens on behalf of msg.sender.
112     * Beware that changing an allowance with this method brings the risk that someone may use both the old
113     * and the new allowance by unfortunate transaction ordering. One possible solution to mitigate this
114     * race condition is to first reduce the spender's allowance to 0 and set the desired value afterwards:
115     * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
116     * @param _spender The address which will spend the funds.
117     * @param _value The amount of tokens to be spent.
118     */
119     function approve(address _spender, uint256 _value) public returns (bool) {
120         allowed[msg.sender][_spender] = _value;
121         emit Approval(msg.sender, _spender, _value);
122         return true;
123     }
124 
125     /**
126     * @dev Function to check the amount of tokens that an owner allowed to a spender.
127     * @param _owner address The address which owns the funds.
128     * @param _spender address The address which will spend the funds.
129     * @return A uint256 specifying the amount of tokens still available for the spender.
130     */
131     function allowance(address _owner, address _spender) public view returns (uint256){
132         return allowed[_owner][_spender];
133     }
134 
135     /**
136     * @dev Increase the amount of tokens that an owner allowed to a spender.
137     * approve should be called when allowed[_spender] == 0. To increment
138     * allowed value is better to use this function to avoid 2 calls (and wait until
139     * the first transaction is mined)
140     * From MonolithDAO Token.sol
141     * @param _spender The address which will spend the funds.
142     * @param _addedValue The amount of tokens to increase the allowance by.
143     */
144     function increaseApproval(address _spender, uint256 _addedValue) public returns (bool){
145         allowed[msg.sender][_spender] = (
146         allowed[msg.sender][_spender].add(_addedValue));
147         emit Approval(msg.sender, _spender, allowed[msg.sender][_spender]);
148         return true;
149     }
150 
151     /**
152     * @dev Decrease the amount of tokens that an owner allowed to a spender.
153     * approve should be called when allowed[_spender] == 0. To decrement
154     * allowed value is better to use this function to avoid 2 calls (and wait until
155     * the first transaction is mined)
156     * From MonolithDAO Token.sol
157     * @param _spender The address which will spend the funds.
158     * @param _subtractedValue The amount of tokens to decrease the allowance by.
159     */
160     function decreaseApproval(address _spender, uint256 _subtractedValue) public returns (bool){
161         uint256 oldValue = allowed[msg.sender][_spender];
162         if (_subtractedValue >= oldValue) {
163             allowed[msg.sender][_spender] = 0;
164         } else {
165             allowed[msg.sender][_spender] = oldValue.sub(_subtractedValue);
166         }
167         emit Approval(msg.sender, _spender, allowed[msg.sender][_spender]);
168         return true;
169     }
170 
171     /**
172     * @dev Burns a specific amount of tokens.
173     * @param _value The amount of token to be burned.
174     */
175     function burn(uint256 _value) public {
176         _burn(msg.sender, _value);
177     }
178 
179     function _burn(address _who, uint256 _value) internal {
180         require(_value <= balances[_who], "Insufficient balance of tokens");
181         // no need to require value <= totalSupply, since that would imply the
182         // sender's balance is greater than the totalSupply, which *should* be an assertion failure
183 
184         balances[_who] = balances[_who].sub(_value);
185         totalSupply_ = totalSupply_.sub(_value);
186         emit Burn(_who, _value);
187         emit Transfer(_who, address(0), _value);
188     }
189 
190     /**
191     * @dev Burns a specific amount of tokens from the target address and decrements allowance
192     * @param _from address The address which you want to send tokens from
193     * @param _value uint256 The amount of token to be burned
194     */
195     function burnFrom(address _from, uint256 _value) public {
196         require(_value <= allowed[_from][msg.sender], "Insufficient allowance to burn tokens.");
197         allowed[_from][msg.sender] = allowed[_from][msg.sender].sub(_value);
198         _burn(_from, _value);
199     }
200 
201     /**
202     * @dev Allows the current owner to transfer control of the contract to a newOwner.
203     * @param _newOwner The address to transfer ownership to.
204     */
205     function transferOwnership(address _newOwner) public onlyOwner {
206         _transferOwnership(_newOwner);
207     }
208 
209     /**
210     * @dev Transfers control of the contract to a newOwner.
211     * @param _newOwner The address to transfer ownership to.
212     */
213     function _transferOwnership(address _newOwner) internal {
214         require(_newOwner != address(0), "Owner cannot be 0 address.");
215         emit OwnershipTransferred(owner, _newOwner);
216         owner = _newOwner;
217     }
218 
219     /**
220     * @dev Function to mint tokens
221     * @param _to The address that will receive the minted tokens.
222     * @param _amount The amount of tokens to mint.
223     * @return A boolean that indicates if the operation was successful.
224     */
225     function mint(address _to, uint256 _amount) public onlyOwner returns (bool){
226         totalSupply_ = totalSupply_.add(_amount);
227         balances[_to] = balances[_to].add(_amount);
228         emit Mint(_to, _amount);
229         emit Transfer(address(0), _to, _amount);
230         return true;
231     }
232 
233 }
234 
235 contract SKOToken is BaseSKOToken {
236     // Constants
237     string  public constant name = "Skolkovo";
238     string  public organizationName = "ДЕНЕБСОФТ";
239     string  public constant symbol = "SKO";
240     uint8   public constant decimals = 18;
241 
242     uint256 public constant INITIAL_SUPPLY      =  1500000000 * (10 ** uint256(decimals));
243     uint256 public constant CROWDSALE_ALLOWANCE =   800000000 * (10 ** uint256(decimals));
244     uint256 public constant ADMIN_ALLOWANCE     =  1425000000 * (10 ** uint256(decimals));
245     uint256 public constant TEAM_ALLOWANCE     =     75000000 * (10 ** uint256(decimals));
246 
247     // Properties
248     //uint256 public totalSupply;
249     uint256 public crowdSaleAllowance;      // the number of tokens available for crowdsales
250     uint256 public adminAllowance;          // the number of tokens available for the administrator
251     uint256 public teamAllowance;          // the number of tokens available for the team
252     address public crowdSaleAddr;           // the address of a crowdsale currently selling this token
253     address public adminAddr;               // the address of a crowdsale currently selling this token
254     address public teamAddr;               // the address of a team account
255     //bool    public transferEnabled = false; // indicates if transferring tokens is enabled or not
256     bool    public transferEnabled = true;  // Enables everyone to transfer tokens
257 
258     /**
259      * The listed addresses are not valid recipients of tokens.
260      *
261      * 0x0           - the zero address is not valid
262      * this          - the contract itself should not receive tokens
263      * owner         - the owner has all the initial tokens, but cannot receive any back
264      * adminAddr     - the admin has an allowance of tokens to transfer, but does not receive any
265      * crowdSaleAddr - the crowdsale has an allowance of tokens to transfer, but does not receive any
266      */
267     modifier validDestination(address _to) {
268         require(_to != address(0x0), "Cannot send to 0 address");
269         require(_to != address(this), "Cannot send to contract address");
270         //require(_to != owner, "Cannot send to the owner");
271         //require(_to != address(adminAddr), "Cannot send to admin address");
272         require(_to != address(crowdSaleAddr), "Cannot send to crowdsale address");
273         _;
274     }
275 
276     modifier onlyCrowdsale {
277         require(msg.sender == crowdSaleAddr, "Only crowdsale contract can call this");
278         _;
279     }
280 
281     modifier onlyAdmin {
282         require(msg.sender == adminAddr || msg.sender == owner, "Only admin can call this");
283         _;
284     }
285 
286     constructor(address _admin, address _team) public {
287         require(msg.sender != _admin, "Owner and admin cannot be the same");
288 
289         totalSupply_ = INITIAL_SUPPLY;
290         crowdSaleAllowance = CROWDSALE_ALLOWANCE;
291         adminAllowance = ADMIN_ALLOWANCE;
292         teamAllowance = TEAM_ALLOWANCE;
293 
294         // mint all tokens
295         //balances[msg.sender] = totalSupply_.sub(adminAllowance);
296         //emit Transfer(address(0x0), msg.sender, totalSupply_.sub(adminAllowance));
297 
298         balances[_admin] = adminAllowance;
299         emit Transfer(address(0x0), _admin, adminAllowance);
300         adminAddr = _admin;
301         approve(adminAddr, adminAllowance);
302 
303         balances[_team] = teamAllowance;
304         emit Transfer(address(0x0), _team, teamAllowance);
305         teamAddr = _team;
306         approve(teamAddr, teamAllowance);
307     }
308 
309     /**
310      * Overrides ERC20 transfer function with modifier that prevents the
311      * ability to transfer tokens until after transfers have been enabled.
312      */
313     function transfer(address _to, uint256 _value) public validDestination(_to) returns (bool) {
314         return super.transfer(_to, _value);
315     }
316 
317     /**
318      * Overrides ERC20 transferFrom function with modifier that prevents the
319      * ability to transfer tokens until after transfers have been enabled.
320      */
321     function transferFrom(address _from, address _to, uint256 _value) public validDestination(_to) returns (bool) {
322         bool result = super.transferFrom(_from, _to, _value);
323         if (result) {
324             if (msg.sender == crowdSaleAddr)
325                 crowdSaleAllowance = crowdSaleAllowance.sub(_value);
326             if (msg.sender == adminAddr)
327                 adminAllowance = adminAllowance.sub(_value);
328         }
329         return result;
330     }
331 
332     /**
333      * Associates this token with a current crowdsale, giving the crowdsale
334      * an allowance of tokens from the crowdsale supply. This gives the
335      * crowdsale the ability to call transferFrom to transfer tokens to
336      * whomever has purchased them.
337      *
338      * Note that if _amountForSale is 0, then it is assumed that the full
339      * remaining crowdsale supply is made available to the crowdsale.
340      *
341      * @param _crowdSaleAddr The address of a crowdsale contract that will sell this token
342      * @param _amountForSale The supply of tokens provided to the crowdsale
343      */
344     function setCrowdsale(address _crowdSaleAddr, uint256 _amountForSale) external onlyOwner {
345         require(_amountForSale <= crowdSaleAllowance, "Sale amount should be less than the crowdsale allowance limits.");
346 
347         // if 0, then full available crowdsale supply is assumed
348         uint amount = (_amountForSale == 0) ? crowdSaleAllowance : _amountForSale;
349 
350         // Clear allowance of old, and set allowance of new
351         approve(crowdSaleAddr, 0);
352         approve(_crowdSaleAddr, amount);
353 
354         crowdSaleAddr = _crowdSaleAddr;
355     }
356 
357     function setAllowanceBeforeWithdrawal(address _from, address _to, uint _value) public onlyCrowdsale returns (bool) {
358         allowed[_from][_to] = _value;
359         emit Approval(_from, _to, _value);
360         return true;
361     }
362 
363     function setOrganizationName(string _newName) public onlyOwner {
364         organizationName = _newName;
365     }
366 }