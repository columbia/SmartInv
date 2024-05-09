1 pragma solidity 0.4.21;
2 
3 
4 library SafeMath {
5     function mul(uint a, uint b) internal pure  returns(uint) {
6         uint c = a * b;
7         assert(a == 0 || c / a == b);
8         return c;
9     }
10 
11     function sub(uint a, uint b) internal pure  returns(uint) {
12         assert(b <= a);
13         return a - b;
14     }
15 
16     function add(uint a, uint b) internal pure  returns(uint) {
17         uint c = a + b;
18         assert(c >= a && c >= b);
19         return c;
20     }
21 }
22 
23 
24 /**
25  * @title Ownable
26  * @dev The Ownable contract has an owner address, and provides basic authorization control
27  * functions, this simplifies the implementation of "user permissions".
28  */
29 contract Ownable {
30     address public owner;
31     address public newOwner;
32 
33     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
34 
35     /**
36     * @dev The Ownable constructor sets the original `owner` of the contract to the sender
37     * account.
38     */
39     function Ownable() public {
40         owner = msg.sender;
41         newOwner = address(0);
42     }
43 
44     /**
45     * @dev Throws if called by any account other than the owner.
46     */
47     modifier onlyOwner() {
48         require(msg.sender == owner);
49         _;
50     }
51 
52     /**
53     * @dev Allows the current owner to transfer control of the contract to a newOwner.
54     * @param _newOwner The address to transfer ownership to.
55     */
56     function transferOwnership(address _newOwner) public onlyOwner {
57         require(address(0) != _newOwner);
58         newOwner = _newOwner;
59     }
60 
61     function acceptOwnership() public {
62         require(msg.sender == newOwner);
63         emit OwnershipTransferred(owner, msg.sender);
64         owner = msg.sender;
65         newOwner = address(0);
66     }
67 
68 }
69 
70 contract ERC20 {
71     uint public totalSupply;
72 
73     function balanceOf(address who) public view returns(uint);
74 
75     function allowance(address owner, address spender) public view returns(uint);
76 
77     function transfer(address to, uint value) public returns(bool ok);
78 
79     function transferFrom(address from, address to, uint value) public returns(bool ok);
80 
81     function approve(address spender, uint value) public returns(bool ok);
82 
83     event Transfer(address indexed from, address indexed to, uint value);
84     event Approval(address indexed owner, address indexed spender, uint value);
85 }
86 
87 
88 // The token
89 contract Token is ERC20, Ownable {
90 
91     using SafeMath for uint;
92 
93     // Public variables of the token
94     string public name;
95     string public symbol;
96     uint8 public decimals; // How many decimals to show.
97     string public version = "v0.1";
98     uint public totalSupply;
99     bool public locked;
100     mapping(address => uint) balances;
101     mapping(address => mapping(address => uint)) allowed;
102     address public crowdSaleAddress;
103 
104 
105     // Lock transfer for contributors during the ICO
106     modifier onlyUnlocked() {
107         if (msg.sender != crowdSaleAddress && msg.sender != owner && locked)
108             revert();
109         _;
110     }
111 
112     modifier onlyAuthorized() {
113         if (msg.sender != owner && msg.sender != crowdSaleAddress)
114             revert();
115         _;
116     }
117 
118     // @notice The Token contract
119     function Token(address _crowdsaleAddress) public {
120 
121         require(_crowdsaleAddress != address(0));
122         locked = true; // Lock the transfer of tokens during the crowdsale
123         totalSupply = 2600000000e8;
124         name = "Kripton";                           // Set the name for display purposes
125         symbol = "LPK";                             // Set the symbol for display purposes
126         decimals = 8;                               // Amount of decimals
127         crowdSaleAddress = _crowdsaleAddress;
128         balances[_crowdsaleAddress] = totalSupply;
129     }
130 
131     // @notice unlock token for trading
132     function unlock() public onlyAuthorized {
133         locked = false;
134     }
135 
136     // @lock token from trading during ICO
137     function lock() public onlyAuthorized {
138         locked = true;
139     }
140 
141     // @notice transfer tokens to given address
142     // @param _to {address} address or recipient
143     // @param _value {uint} amount to transfer
144     // @return  {bool} true if successful
145     function transfer(address _to, uint _value) public onlyUnlocked returns(bool) {
146         balances[msg.sender] = balances[msg.sender].sub(_value);
147         balances[_to] = balances[_to].add(_value);
148         emit Transfer(msg.sender, _to, _value);
149         return true;
150     }
151 
152     // @notice transfer tokens from given address to another address
153     // @param _from {address} from whom tokens are transferred
154     // @param _to {address} to whom tokens are transferred
155     // @parm _value {uint} amount of tokens to transfer
156     // @return  {bool} true if successful
157     function transferFrom(address _from, address _to, uint256 _value) public onlyUnlocked returns(bool success) {
158         require(balances[_from] >= _value); // Check if the sender has enough
159         require(_value <= allowed[_from][msg.sender]); // Check if allowed is greater or equal
160         balances[_from] = balances[_from].sub(_value); // Subtract from the sender
161         balances[_to] = balances[_to].add(_value); // Add the same to the recipient
162         allowed[_from][msg.sender] = allowed[_from][msg.sender].sub(_value);
163         emit Transfer(_from, _to, _value);
164         return true;
165     }
166 
167     // @notice to query balance of account
168     // @return _owner {address} address of user to query balance
169     function balanceOf(address _owner) public view returns(uint balance) {
170         return balances[_owner];
171     }
172 
173     /**
174     * @dev Approve the passed address to spend the specified amount of tokens on behalf of msg.sender.
175     *
176     * Beware that changing an allowance with this method brings the risk that someone may use both the old
177     * and the new allowance by unfortunate transaction ordering. One possible solution to mitigate this
178     * race condition is to first reduce the spender's allowance to 0 and set the desired value afterwards:
179     * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
180     * @param _spender The address which will spend the funds.
181     * @param _value The amount of tokens to be spent.
182     */
183     function approve(address _spender, uint _value) public returns(bool) {
184         allowed[msg.sender][_spender] = _value;
185         emit Approval(msg.sender, _spender, _value);
186         return true;
187     }
188 
189     // @notice to query of allowance of one user to the other
190     // @param _owner {address} of the owner of the account
191     // @param _spender {address} of the spender of the account
192     // @return remaining {uint} amount of remaining allowance
193     function allowance(address _owner, address _spender) public view returns(uint remaining) {
194         return allowed[_owner][_spender];
195     }
196 
197     /**
198     * approve should be called when allowed[_spender] == 0. To increment
199     * allowed value is better to use this function to avoid 2 calls (and wait until
200     * the first transaction is mined)
201     * From MonolithDAO Token.sol
202     */
203     function increaseApproval (address _spender, uint _addedValue) public returns (bool success) {
204         allowed[msg.sender][_spender] = allowed[msg.sender][_spender].add(_addedValue);
205         emit Approval(msg.sender, _spender, allowed[msg.sender][_spender]);
206         return true;
207     }
208 
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
221 }