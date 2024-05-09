1 pragma solidity 0.4.24;
2 
3 
4 /**
5  * @title SafeMath
6  * @dev Math operations with safety checks that throw on error
7  */
8 library SafeMath {
9 
10     /**
11     * @dev Multiplies two numbers, throws on overflow.
12     */
13     function mul(uint256 a, uint256 b) internal pure returns (uint256 c) {
14         if (a == 0) {
15             return 0;
16         }
17 
18         c = a * b;
19         assert(c / a == b);
20         return c;
21     }
22 
23     /**
24     * @dev Integer division of two numbers, truncating the quotient.
25     */
26     function div(uint256 a, uint256 b) internal pure returns (uint256) {
27         return a / b;
28     }
29 
30     /**
31     * @dev Subtracts two numbers, throws on overflow (i.e. if subtrahend is greater than minuend).
32     */
33     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
34         assert(b <= a);
35         return a - b;
36     }
37 
38     /**
39     * @dev Adds two numbers, throws on overflow.
40     */
41     function add(uint256 a, uint256 b) internal pure returns (uint256 c) {
42         c = a + b;
43         assert(c >= a);
44         return c;
45     }
46 
47 }
48 
49 
50 /**
51  * @title Ownable
52  * @dev The Ownable contract has an owner address, and provides basic authorization control
53  * functions, ownership can be transferred in 2 steps (transfer-accept).
54  */
55 contract Ownable {
56     address public owner;
57     address public pendingOwner;
58     bool isOwnershipTransferActive = false;
59 
60     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
61 
62     /**
63      * @dev The Ownable constructor sets the original `owner` of the contract to the sender
64      * account.
65      */
66     constructor() public {
67         owner = msg.sender;
68     }
69 
70     /**
71      * @dev Throws if called by any account other than the owner.
72      */
73     modifier onlyOwner() {
74         require(msg.sender == owner, "Only owner can do that.");
75         _;
76     }
77 
78     /**
79      * @dev Modifier throws if called by any account other than the pendingOwner.
80      */
81     modifier onlyPendingOwner() {
82         require(isOwnershipTransferActive);
83         require(msg.sender == pendingOwner, "Only nominated pretender can do that.");
84         _;
85     }
86 
87     /**
88      * @dev Allows the current owner to set the pendingOwner address.
89      * @param _newOwner The address to transfer ownership to.
90      */
91     function transferOwnership(address _newOwner) public onlyOwner {
92         pendingOwner = _newOwner;
93         isOwnershipTransferActive = true;
94     }
95 
96     /**
97      * @dev Allows the pendingOwner address to finalize the transfer.
98      */
99     function acceptOwnership() public onlyPendingOwner {
100         emit OwnershipTransferred(owner, pendingOwner);
101         owner = pendingOwner;
102         isOwnershipTransferActive = false;
103         pendingOwner = address(0);
104     }
105 }
106 
107 
108 /**
109  * @title ERC20 Token Standard Interface
110  * @dev see https://github.com/ethereum/EIPs/issues/20
111  */
112 contract ERC20 {
113     function totalSupply() public view returns (uint256);
114     function balanceOf(address _owner) public view returns (uint256);
115     function transfer(address _to, uint256 _value) public returns (bool);
116 
117     function transferFrom(address _from, address _to, uint256 _value) public returns (bool);
118     function approve(address _spender, uint256 _value) public returns (bool);
119     function allowance(address _owner, address _spender) public view returns (uint256);
120 
121     event Transfer(address indexed _from, address indexed _to, uint256 _value);
122     event Approval(address indexed _owner, address indexed _spender, uint256 _value);
123 }
124 
125 
126 /**
127  * @title Aurum Services Token
128  * @author Igor Dëmin
129  * @dev Token with predefined initial supply which could be reduced by owner.
130  */
131 contract AurumToken is ERC20, Ownable {
132     using SafeMath for uint256;
133 
134     string public constant name = "Aurum Services Token";
135     string public constant symbol = "AURUM";
136     uint8 public constant decimals = 18;
137 
138     uint256 public constant INITIAL_SUPPLY = 375 * (10 ** 6) * (10 ** uint256(decimals));
139 
140     // Expected gradual reduction of total supply
141     uint256 totalSupply_;
142 
143     mapping(address => uint256) balances;
144     mapping(address => mapping(address => uint256)) allowed;
145 
146     event Burn(address indexed _owner, uint256 _value);
147 
148     constructor() public {
149         // Initially total and initial supply are equal
150         totalSupply_ = INITIAL_SUPPLY;
151         // Initially assign all tokens to the contract's creator, to rule them all :-)
152         balances[msg.sender] = INITIAL_SUPPLY;
153         emit Transfer(address(0), msg.sender, INITIAL_SUPPLY);
154     }
155 
156     /**
157      * @dev Reclaim all ERC20 compatible tokens
158      * @param _token ERC20 The address of the token contract
159      */
160     function reclaimToken(ERC20 _token) external onlyOwner {
161         uint256 tokenBalance = _token.balanceOf(this);
162         require(_token.transfer(owner, tokenBalance));
163     }
164 
165     /**
166      * @dev Transfer all Ether held by the contract to the owner.
167      */
168     function reclaimEther() external onlyOwner {
169         owner.transfer(address(this).balance);
170     }
171 
172     /**
173      * @dev Total number of tokens in existence
174      */
175     function totalSupply() public view returns (uint256) {
176         return totalSupply_;
177     }
178 
179     /**
180      * @dev Gets the balance of the specified address.
181      * @param _owner The address to query the the balance of.
182      * @return An uint256 representing the amount owned by the passed address.
183      */
184     function balanceOf(address _owner) public view returns (uint256) {
185         return balances[_owner];
186     }
187 
188     /**
189      * @dev Transfer token for a specified address
190      * @param _to The address to transfer to.
191      * @param _value The amount to be transferred.
192      */
193     function transfer(address _to, uint256 _value) public returns (bool) {
194         require(_to != address(0));
195         require(_value <= balances[msg.sender]);
196 
197         // subtract from sender's balance
198         balances[msg.sender] = balances[msg.sender].sub(_value);
199         // add to recipient's balance
200         balances[_to] = balances[_to].add(_value);
201         emit Transfer(msg.sender, _to, _value);
202         return true;
203     }
204 
205     /**
206      * @dev Transfer tokens from one address to another
207      * @param _from address The address which you want to send tokens from
208      * @param _to address The address which you want to transfer to
209      * @param _value uint256 the amount of tokens to be transferred
210      */
211     function transferFrom(address _from, address _to, uint256 _value) public returns (bool) {
212         require(_to != address(0));
213         require(_value <= balances[_from]);
214         require(_value <= allowed[_from][msg.sender]);
215 
216         balances[_from] = balances[_from].sub(_value);
217         balances[_to] = balances[_to].add(_value);
218         allowed[_from][msg.sender] = allowed[_from][msg.sender].sub(_value);
219         emit Transfer(_from, _to, _value);
220         return true;
221     }
222 
223     /**
224      * @dev Approve the passed address to spend the specified amount of tokens on behalf of msg.sender.
225      * @param _spender The address which will spend the funds.
226      * @param _value The amount of tokens to be spent.
227      */
228     function approve(address _spender, uint256 _value) public returns (bool) {
229         allowed[msg.sender][_spender] = _value;
230         emit Approval(msg.sender, _spender, _value);
231         return true;
232     }
233 
234     /**
235      * @dev Function to check the amount of tokens that an owner allowed to a spender.
236      * @param _owner address The address which owns the funds.
237      * @param _spender address The address which will spend the funds.
238      * @return A uint256 specifying the amount of tokens still available for the spender.
239      */
240     function allowance(address _owner, address _spender) public view returns (uint256) {
241         return allowed[_owner][_spender];
242     }
243 
244     /**
245      * @dev Only contract owner can burns a specific amount of tokens that he owns.
246      * @param _value The amount of token to be burned.
247      */
248     function burn(uint256 _value) public onlyOwner {
249         require(_value <= balances[owner]);
250 
251         balances[owner] = balances[owner].sub(_value);
252         totalSupply_ = totalSupply_.sub(_value);
253         emit Burn(owner, _value);
254         emit Transfer(owner, address(0), _value);
255     }
256 
257 }