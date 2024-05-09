1 pragma solidity >=0.4.21 <0.6.0;
2 
3 library SafeMath {
4 
5     function mul(uint a, uint b) internal pure returns(uint) {
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
16     function add(uint a, uint b) internal  pure returns(uint) {
17         uint c = a + b;
18         assert(c >= a && c >= b);
19         return c;
20     }
21 }
22 
23 
24 contract ERC20 {
25     uint public totalSupply;
26 
27     function balanceOf(address who) public view returns(uint);
28 
29     function allowance(address owner, address spender) public view returns(uint);
30 
31     function transfer(address to, uint value) public returns(bool ok);
32 
33     function transferFrom(address from, address to, uint value) public returns(bool ok);
34 
35     function approve(address spender, uint value) public returns(bool ok);
36 
37     event Transfer(address indexed from, address indexed to, uint value);
38     event Approval(address indexed owner, address indexed spender, uint value);
39 }
40 
41 /**
42  * @title Ownable
43  * @dev The Ownable contract has an owner address, and provides basic authorization control
44  * functions, this simplifies the implementation of "user permissions".
45  */
46 contract Ownable {
47     address payable public owner;
48     address payable public newOwner;
49 
50     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
51 
52     /**
53     * @dev The Ownable constructor sets the original `owner` of the contract to the sender
54     * account.
55     */
56     constructor() public {
57         owner = msg.sender;
58         newOwner = address(0);
59     }
60 
61     /**
62     * @dev Throws if called by any account other than the owner.
63     */
64     modifier onlyOwner() {
65         require(msg.sender == owner);
66         _;
67     }
68 
69     /**
70     * @dev Allows the current owner to transfer control of the contract to a newOwner.
71     * @param _newOwner The address to transfer ownership to.
72     */
73     function transferOwnership(address payable _newOwner) public onlyOwner {
74         require(address(0) != _newOwner);
75         newOwner = _newOwner;
76     }
77 
78     function acceptOwnership() public {
79         require(msg.sender == newOwner);
80         emit OwnershipTransferred(owner, msg.sender);
81         owner = msg.sender;
82         newOwner = address(0);
83     }
84 
85 }
86 
87 /**
88 * ================================*
89 *   ____  ____   ___      ______    
90 *  |_  _||_  _|.'   `.   |_   _ \   
91 *    \ \  / / /  .-.  \    | |_) |  
92 *     \ \/ /  | |   | |    |  __'.  
93 *     _|  |_  \  `-'  \_  _| |__) | 
94 *    |______|  `.___.\__||_______/  
95 *        YiQiBi.亿企币!
96 * ================================*
97 */
98 contract YQB is ERC20, Ownable {
99 
100     event Burn(address indexed burner, uint256 value);
101 
102     using SafeMath for uint;
103     // Public variables of the token
104     string public name = "YiQiBi"; // the name for display purposes
105     string public symbol = "YQB"; // the symbol for display purposes
106     uint public decimals = 18; // How many decimals to show.
107     string public version = "1.0"; // Version of token
108     uint public totalSupply = 1000000000 * (10**18);
109 
110     mapping(address => uint) public balances;
111     mapping(address => mapping(address => uint)) public allowed;
112 
113     // The Token constructor
114     constructor()
115     public
116     {
117         balances[owner] = totalSupply;
118     }
119 
120     // @notice If we want to rebrand, we can.
121     function setName(string memory _name)
122     onlyOwner
123     public
124     {
125         name = _name;
126     }
127 
128     // @notice If we want to rebrand, we can.
129     function setSymbol(string memory _symbol)
130     onlyOwner
131     public
132     {
133         symbol = _symbol;
134     }
135 
136     // @notice transfer tokens to given address
137     // @param _to {address} address or recipient
138     // @param _value {uint} amount to transfer
139     // @return  {bool} true if successful
140     function transfer(address _to, uint _value) public returns(bool) {
141 
142         require(_to != address(0));
143         require(balances[msg.sender] >= _value);
144         balances[msg.sender] = balances[msg.sender].sub(_value);
145         balances[_to] = balances[_to].add(_value);
146         emit Transfer(msg.sender, _to, _value);
147         return true;
148     }
149 
150     // @notice transfer tokens from given address to another address
151     // @param _from {address} from whom tokens are transferred
152     // @param _to {address} to whom tokens are transferred
153     // @param _value {uint} amount of tokens to transfer
154     // @return  {bool} true if successful
155     function transferFrom(address _from, address _to, uint256 _value) public  returns(bool success) {
156 
157         require(_to != address(0));
158         require(balances[_from] >= _value); // Check if the sender has enough
159         require(_value <= allowed[_from][msg.sender]); // Check if allowed is greater or equal
160         balances[_from] = balances[_from].sub(_value); // Subtract from the sender
161         balances[_to] = balances[_to].add(_value); // Add the same to the recipient
162         allowed[_from][msg.sender] = allowed[_from][msg.sender].sub(_value); // adjust allowed
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
209     function decreaseApproval (address _spender, uint _subtractedValue) public returns (bool success) {
210         uint oldValue = allowed[msg.sender][_spender];
211         if (_subtractedValue > oldValue) {
212             allowed[msg.sender][_spender] = 0;
213         } else {
214             allowed[msg.sender][_spender] = oldValue.sub(_subtractedValue);
215         }
216         emit Approval(msg.sender, _spender, allowed[msg.sender][_spender]);
217         return true;
218     }
219 
220     /**
221      * @dev Burns a specific amount of tokens.
222      * @param _value The amount of token to be burned.
223      */
224     function burn(uint256 _value) public {
225         require(_value <= balances[msg.sender]);
226         // no need to require value <= totalSupply, since that would imply the
227         // sender's balance is greater than the totalSupply, which *should* be an assertion failure
228 
229         address burner = msg.sender;
230         balances[burner] = balances[burner].sub(_value);
231         totalSupply = totalSupply.sub(_value);
232         emit Burn(burner, _value);
233     }
234 
235 }