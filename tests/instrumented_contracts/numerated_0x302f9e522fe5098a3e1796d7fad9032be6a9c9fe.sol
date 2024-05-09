1 pragma solidity ^0.4.24;
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
28         assert(c >= a);
29         return c;
30     }
31 }
32 
33 /**
34  * @title Ownable
35  * @dev The Ownable contract has an owner address, and provides basic authorization control
36  * functions, this simplifies the implementation of "user permissions".
37  */
38 contract Ownable {
39     address public owner;
40 
41 
42     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
43 
44 
45     /**
46      * @dev The Ownable constructor sets the original `owner` of the contract to the sender
47      * account.
48      */
49     constructor () public {
50         owner = msg.sender;
51     }
52 
53 
54     /**
55      * @dev Throws if called by any account other than the owner.
56      */
57     modifier onlyOwner() {
58         require(msg.sender == owner);
59         _;
60     }
61 
62 
63     /**
64      * @dev Allows the current owner to transfer control of the contract to a newOwner.
65      * @param newOwner The address to transfer ownership to.
66      */
67     function transferOwnership(address newOwner) public onlyOwner {
68         require(newOwner != address(0));
69         emit OwnershipTransferred(owner, newOwner);
70         owner = newOwner;
71     }
72 
73 }
74 
75 contract CoinMetroToken is Ownable {
76     using SafeMath for uint;
77 
78     string public constant name = "CoinMetro Token";
79     string public constant symbol = "XCM";
80     uint8 public constant decimals = 18;
81     uint256 public totalSupply;
82 
83     bool public mintingFinished = false;
84 
85     mapping(address => uint256) balances;
86     mapping (address => mapping (address => uint256)) internal allowed;
87 
88     event NewToken(address _token);
89     event Transfer(address indexed from, address indexed to, uint256 value);
90     event Approval(address indexed owner, address indexed spender, uint256 value);
91     event Burned(address burner, uint burnedAmount);
92     event MintFinished();
93 
94     modifier canMint() {
95         require(!mintingFinished, "Minting was already finished");
96         _;
97     }
98 
99     constructor() public {
100         emit NewToken(address(this));
101     }
102 
103     /**
104      * @dev Function to mint tokens
105      * @param _to The address that will receive the minted tokens.
106      * @param _amount The amount of tokens to mint.
107      * @return A boolean that indicates if the operation was successful.
108      */
109     function mint(address _to, uint256 _amount) public onlyOwner canMint returns (bool) {
110         totalSupply = totalSupply.add(_amount);
111         balances[_to] = balances[_to].add(_amount);
112         emit Transfer(address(0), _to, _amount);
113         return true;
114     }
115 
116     // Burn tokens from an address
117     function burn(uint burnAmount) public {
118         address burner = msg.sender;
119         balances[burner] = balances[burner].sub(burnAmount);
120         totalSupply = totalSupply.sub(burnAmount);
121         emit Burned(burner, burnAmount);
122     }
123 
124     /**
125      * @dev Function to stop minting new tokens.
126      * @return True if the operation was successful.
127      */
128     function finishMinting() public onlyOwner returns (bool) {
129         mintingFinished = true;
130         emit MintFinished();
131         return true;
132     }
133 
134     /**
135     * @dev transfer token for a specified address
136     * @param _to The address to transfer to.
137     * @param _value The amount to be transferred.
138     */
139     function transfer(address _to, uint256 _value) public returns (bool) {
140         require(_to != address(0), "Address should not be zero");
141         require(_value <= balances[msg.sender], "Insufficient balance");
142 
143         // SafeMath.sub will throw if there is not enough balance.
144         balances[msg.sender] = balances[msg.sender] - _value;
145         balances[_to] = balances[_to].add(_value);
146         emit Transfer(msg.sender, _to, _value);
147         return true;
148     }
149 
150     /**
151      * @dev Transfer tokens from one address to another
152      * @param _from address The address which you want to send tokens from
153      * @param _to address The address which you want to transfer to
154      * @param _value uint256 the amount of tokens to be transferred
155      */
156     function transferFrom(address _from, address _to, uint256 _value) public returns (bool) {
157         require(_to != address(0), "Address should not be zero");
158         require(_value <= balances[_from], "Insufficient Balance");
159         require(_value <= allowed[_from][msg.sender], "Insufficient Allowance");
160 
161         balances[_from] = balances[_from] - _value;
162         balances[_to] = balances[_to].add(_value);
163         allowed[_from][msg.sender] = allowed[_from][msg.sender] - _value;
164         emit Transfer(_from, _to, _value);
165         return true;
166     }
167 
168     /**
169      * @dev Approve the passed address to spend the specified amount of tokens on behalf of msg.sender.
170      *
171      * Beware that changing an allowance with this method brings the risk that someone may use both the old
172      * and the new allowance by unfortunate transaction ordering. One possible solution to mitigate this
173      * race condition is to first reduce the spender's allowance to 0 and set the desired value afterwards:
174      * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
175      * @param _spender The address which will spend the funds.
176      * @param _value The amount of tokens to be spent.
177      */
178     function approve(address _spender, uint256 _value) public returns (bool) {
179         allowed[msg.sender][_spender] = _value;
180         emit Approval(msg.sender, _spender, _value);
181         return true;
182     }
183 
184     /**
185      * @dev Function to check the amount of tokens that an owner allowed to a spender.
186      * @param _owner address The address which owns the funds.
187      * @param _spender address The address which will spend the funds.
188      * @return A uint256 specifying the amount of tokens still available for the spender.
189      */
190     function allowance(address _owner, address _spender) public view returns (uint256 remaining) {
191         return allowed[_owner][_spender];
192     }
193 
194     /**
195      * approve should be called when allowed[_spender] == 0. To increment
196      * allowed value is better to use this function to avoid 2 calls (and wait until
197      * the first transaction is mined)
198      * From MonolithDAO Token.sol
199      */
200     function increaseApproval (address _spender, uint _addedValue) public returns (bool success) {
201         allowed[msg.sender][_spender] = allowed[msg.sender][_spender].add(_addedValue);
202         emit Approval(msg.sender, _spender, allowed[msg.sender][_spender]);
203         return true;
204     }
205 
206     function decreaseApproval (address _spender, uint _subtractedValue) public returns (bool success) {
207         uint oldValue = allowed[msg.sender][_spender];
208         if (_subtractedValue > oldValue) {
209             allowed[msg.sender][_spender] = 0;
210         } else {
211             allowed[msg.sender][_spender] = oldValue.sub(_subtractedValue);
212         }
213         emit Approval(msg.sender, _spender, allowed[msg.sender][_spender]);
214         return true;
215     }
216 
217     /**
218     * @dev Gets the balance of the specified address.
219     * @param _owner The address to query the the balance of.
220     * @return An uint256 representing the amount owned by the passed address.
221     */
222     function balanceOf(address _owner) public view returns (uint256 balance) {
223         return balances[_owner];
224     }
225 }
226 
227 contract CoinMetroVault is Ownable {
228     using SafeMath for uint256;
229 
230     CoinMetroToken public token;
231 
232     address public masterWallet;
233     uint256 public releaseTimestamp;
234 
235     event TokenReleased(address _masterWallet, uint256 _amount);
236 
237     constructor(CoinMetroToken _token, address _masterWallet, uint256 _releaseTimestamp) public {
238         require(_masterWallet != address(0x0));
239         require(_releaseTimestamp > now);
240         token = _token;
241         masterWallet = _masterWallet;
242         releaseTimestamp = _releaseTimestamp;
243     }
244 
245     function() external payable {
246         // does not allow incoming ETH
247         revert();
248     }
249 
250     // function to release all tokens to master wallet
251     // revert if timestamp is before {releaseTimestamp}
252     function release() external {
253         require(now > releaseTimestamp, "Transaction locked");
254         uint balance = token.balanceOf(address(this));
255         token.transfer(masterWallet, balance);
256 
257         emit TokenReleased(masterWallet, balance);
258     }
259 }