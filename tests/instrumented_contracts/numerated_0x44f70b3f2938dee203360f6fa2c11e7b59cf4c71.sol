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
35 contract BaseLBSCToken {
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
219 }
220 
221 contract LBSCToken is BaseLBSCToken {
222     
223     // Constants
224     string  public constant name = "LabelsCoin";
225     string  public constant symbol = "LBSC";
226     uint8   public constant decimals = 18;
227 
228     uint256 public constant INITIAL_SUPPLY      =  30000000 * (10 ** uint256(decimals));
229     //uint256 public constant CROWDSALE_ALLOWANCE =  1000000000 * (10 ** uint256(decimals));
230     uint256 public constant ADMIN_ALLOWANCE     =  30000000 * (10 ** uint256(decimals));
231     
232     // Properties
233     //uint256 public totalSupply;
234     //uint256 public crowdSaleAllowance;      // the number of tokens available for crowdsales
235     uint256 public adminAllowance;          // the number of tokens available for the administrator
236     //address public crowdSaleAddr;           // the address of a crowdsale currently selling this token
237     address public adminAddr;               // the address of a crowdsale currently selling this token
238     //bool    public transferEnabled = false; // indicates if transferring tokens is enabled or not
239     bool    public transferEnabled = true;  // Enables everyone to transfer tokens
240 
241     /**
242      * The listed addresses are not valid recipients of tokens.
243      *
244      * 0x0           - the zero address is not valid
245      * this          - the contract itself should not receive tokens
246      * owner         - the owner has all the initial tokens, but cannot receive any back
247      * adminAddr     - the admin has an allowance of tokens to transfer, but does not receive any
248      * crowdSaleAddr - the crowdsale has an allowance of tokens to transfer, but does not receive any
249      */
250     modifier validDestination(address _to) {
251         require(_to != address(0x0), "Cannot send to 0 address");
252         require(_to != address(this), "Cannot send to contract address");
253         //require(_to != owner, "Cannot send to the owner");
254         //require(_to != address(adminAddr), "Cannot send to admin address");
255         //require(_to != address(crowdSaleAddr), "Cannot send to crowdsale address");
256         _;
257     }
258 
259     constructor(address _admin) public {
260         require(msg.sender != _admin, "Owner and admin cannot be the same");
261 
262         totalSupply_ = INITIAL_SUPPLY;
263         adminAllowance = ADMIN_ALLOWANCE;
264 
265         // mint all tokens
266         //balances[msg.sender] = totalSupply_.sub(adminAllowance);
267         //emit Transfer(address(0x0), msg.sender, totalSupply_.sub(adminAllowance));
268 
269         balances[_admin] = adminAllowance;
270         emit Transfer(address(0x0), _admin, adminAllowance);
271 
272         adminAddr = _admin;
273         approve(adminAddr, adminAllowance);
274     }
275 
276     /**
277      * Overrides ERC20 transfer function with modifier that prevents the
278      * ability to transfer tokens until after transfers have been enabled.
279      */
280     function transfer(address _to, uint256 _value) public validDestination(_to) returns (bool) {
281         return super.transfer(_to, _value);
282     }
283 
284     /**
285      * Overrides ERC20 transferFrom function with modifier that prevents the
286      * ability to transfer tokens until after transfers have been enabled.
287      */
288     function transferFrom(address _from, address _to, uint256 _value) public validDestination(_to) returns (bool) {
289         bool result = super.transferFrom(_from, _to, _value);
290         if (result) {
291             if (msg.sender == adminAddr)
292                 adminAllowance = adminAllowance.sub(_value);
293         }
294         return result;
295     }
296 }