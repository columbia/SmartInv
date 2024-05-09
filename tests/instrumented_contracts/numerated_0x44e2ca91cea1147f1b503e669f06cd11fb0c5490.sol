1 pragma solidity ^0.4.21;
2 
3 /**
4  * @title Ownable
5  * @dev The Ownable contract has an owner address, and provides basic authorization control
6  * functions, this simplifies the implementation of "user permissions".
7  */
8 contract Ownable {
9     address public owner;
10 
11 
12     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
13 
14 
15     /**
16      * @dev The Ownable constructor sets the original `owner` of the contract to the sender
17      * account.
18      */
19     constructor () public {
20         owner = msg.sender;
21     }
22 
23 
24     /**
25      * @dev Throws if called by any account other than the owner.
26      */
27     modifier onlyOwner() {
28         require(msg.sender == owner);
29         _;
30     }
31 
32 
33     /**
34      * @dev Allows the current owner to transfer control of the contract to a newOwner.
35      * @param newOwner The address to transfer ownership to.
36      */
37     function transferOwnership(address newOwner) public onlyOwner {
38         require(newOwner != address(0));
39         emit OwnershipTransferred(owner, newOwner);
40         owner = newOwner;
41     }
42 
43 }
44 
45 /**
46  * @title SafeMath
47  * @dev Math operations with safety checks that throw on error
48  */
49 library SafeMath {
50     function mul(uint256 a, uint256 b) internal pure returns (uint256) {
51         uint256 c = a * b;
52         assert(a == 0 || c / a == b);
53         return c;
54     }
55 
56     function div(uint256 a, uint256 b) internal pure returns (uint256) {
57         // assert(b > 0); // Solidity automatically throws when dividing by 0
58         uint256 c = a / b;
59         // assert(a == b * c + a % b); // There is no case in which this doesn't hold
60         return c;
61     }
62 
63     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
64         assert(b <= a);
65         return a - b;
66     }
67 
68     function add(uint256 a, uint256 b) internal pure returns (uint256) {
69         uint256 c = a + b;
70         assert(c >= a);
71         return c;
72     }
73 }
74 
75 /**
76  *  @title Contract for CoinMetro Token
77  *  Dec 2017, Anton Corbijn (CoinMetro)
78  */
79 contract CoinMetroToken is Ownable {
80     using SafeMath for uint;
81 
82     string public constant name = "CoinMetro Token";
83     string public constant symbol = "XCM";
84     uint8 public constant decimals = 18;
85     uint256 public totalSupply;
86 
87     bool public mintingFinished = false;
88 
89     mapping(address => uint256) balances;
90     mapping (address => mapping (address => uint256)) internal allowed;
91 
92     event NewToken(address _token);
93     event Transfer(address indexed from, address indexed to, uint256 value);
94     event Approval(address indexed owner, address indexed spender, uint256 value);
95     event Burned(address burner, uint burnedAmount);
96     event MintFinished();
97 
98     modifier canMint() {
99         require(!mintingFinished, "Minting was already finished");
100         _;
101     }
102 
103     constructor () public {
104         emit NewToken(address(this));
105     }
106 
107     /**
108      * @dev Function to mint tokens
109      * @param _to The address that will receive the minted tokens.
110      * @param _amount The amount of tokens to mint.
111      * @return A boolean that indicates if the operation was successful.
112      */
113     function mint(address _to, uint256 _amount) public onlyOwner canMint returns (bool) {
114         totalSupply = totalSupply.add(_amount);
115         balances[_to] = balances[_to].add(_amount);
116         emit Transfer(address(0), _to, _amount);
117         return true;
118     }
119 
120     // Burn tokens from an address
121     function burn(uint burnAmount) public {
122         address burner = msg.sender;
123         balances[burner] = balances[burner].sub(burnAmount);
124         totalSupply = totalSupply.sub(burnAmount);
125         emit Burned(burner, burnAmount);
126     }
127 
128     /**
129      * @dev Function to stop minting new tokens.
130      * @return True if the operation was successful.
131      */
132     function finishMinting() public onlyOwner returns (bool) {
133         mintingFinished = true;
134         emit MintFinished();
135         return true;
136     }
137 
138     /**
139     * @dev transfer token for a specified address
140     * @param _to The address to transfer to.
141     * @param _value The amount to be transferred.
142     */
143     function transfer(address _to, uint256 _value) public returns (bool) {
144         require(_to != address(0), "Address should not be zero");
145         require(_value <= balances[msg.sender], "Insufficient balance");
146 
147         // SafeMath.sub will throw if there is not enough balance.
148         balances[msg.sender] = balances[msg.sender] - _value;
149         balances[_to] = balances[_to].add(_value);
150         emit Transfer(msg.sender, _to, _value);
151         return true;
152     }
153 
154     /**
155      * @dev Transfer tokens from one address to another
156      * @param _from address The address which you want to send tokens from
157      * @param _to address The address which you want to transfer to
158      * @param _value uint256 the amount of tokens to be transferred
159      */
160     function transferFrom(address _from, address _to, uint256 _value) public returns (bool) {
161         require(_to != address(0), "Address should not be zero");
162         require(_value <= balances[_from], "Insufficient Balance");
163         require(_value <= allowed[_from][msg.sender], "Insufficient Allowance");
164 
165         balances[_from] = balances[_from] - _value;
166         balances[_to] = balances[_to].add(_value);
167         allowed[_from][msg.sender] = allowed[_from][msg.sender] - _value;
168         emit Transfer(_from, _to, _value);
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
184         emit Approval(msg.sender, _spender, _value);
185         return true;
186     }
187 
188     /**
189      * @dev Function to check the amount of tokens that an owner allowed to a spender.
190      * @param _owner address The address which owns the funds.
191      * @param _spender address The address which will spend the funds.
192      * @return A uint256 specifying the amount of tokens still available for the spender.
193      */
194     function allowance(address _owner, address _spender) public view returns (uint256 remaining) {
195         return allowed[_owner][_spender];
196     }
197 
198     /**
199      * approve should be called when allowed[_spender] == 0. To increment
200      * allowed value is better to use this function to avoid 2 calls (and wait until
201      * the first transaction is mined)
202      * From MonolithDAO Token.sol
203      */
204     function increaseApproval (address _spender, uint _addedValue) public returns (bool success) {
205         allowed[msg.sender][_spender] = allowed[msg.sender][_spender].add(_addedValue);
206         emit Approval(msg.sender, _spender, allowed[msg.sender][_spender]);
207         return true;
208     }
209 
210     function decreaseApproval (address _spender, uint _subtractedValue) public returns (bool success) {
211         uint oldValue = allowed[msg.sender][_spender];
212         if (_subtractedValue > oldValue) {
213             allowed[msg.sender][_spender] = 0;
214         } else {
215             allowed[msg.sender][_spender] = oldValue.sub(_subtractedValue);
216         }
217         emit Approval(msg.sender, _spender, allowed[msg.sender][_spender]);
218         return true;
219     }
220 
221     /**
222     * @dev Gets the balance of the specified address.
223     * @param _owner The address to query the the balance of.
224     * @return An uint256 representing the amount owned by the passed address.
225     */
226     function balanceOf(address _owner) public view returns (uint256 balance) {
227         return balances[_owner];
228     }
229 }