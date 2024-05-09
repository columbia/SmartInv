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
89 *            power of group.社群动力!
90 * ================================*
91 */
92 contract PowerOfGroup is ERC20, Ownable {
93 
94     event Burn(address indexed burner, uint256 value);
95 
96     using SafeMath for uint;
97     // Public variables of the token
98     string public name = "Power Of Group"; // the name for display purposes
99     string public symbol = "POG"; // the symbol for display purposes
100     uint public decimals = 18; // How many decimals to show.
101     string public version = "1.0"; // Version of token
102     uint public totalSupply = 1000000000 * (10**18);
103 
104     mapping(address => uint) public balances;
105     mapping(address => mapping(address => uint)) public allowed;
106 
107     // The Token constructor
108     constructor()
109     public
110     {
111         balances[owner] = totalSupply;
112     }
113 
114     // @notice If we want to rebrand, we can.
115     function setName(string memory _name)
116     onlyOwner
117     public
118     {
119         name = _name;
120     }
121 
122     // @notice If we want to rebrand, we can.
123     function setSymbol(string memory _symbol)
124     onlyOwner
125     public
126     {
127         symbol = _symbol;
128     }
129 
130     // @notice transfer tokens to given address
131     // @param _to {address} address or recipient
132     // @param _value {uint} amount to transfer
133     // @return  {bool} true if successful
134     function transfer(address _to, uint _value) public returns(bool) {
135 
136         require(_to != address(0));
137         require(balances[msg.sender] >= _value);
138         balances[msg.sender] = balances[msg.sender].sub(_value);
139         balances[_to] = balances[_to].add(_value);
140         emit Transfer(msg.sender, _to, _value);
141         return true;
142     }
143 
144     // @notice transfer tokens from given address to another address
145     // @param _from {address} from whom tokens are transferred
146     // @param _to {address} to whom tokens are transferred
147     // @param _value {uint} amount of tokens to transfer
148     // @return  {bool} true if successful
149     function transferFrom(address _from, address _to, uint256 _value) public  returns(bool success) {
150 
151         require(_to != address(0));
152         require(balances[_from] >= _value); // Check if the sender has enough
153         require(_value <= allowed[_from][msg.sender]); // Check if allowed is greater or equal
154         balances[_from] = balances[_from].sub(_value); // Subtract from the sender
155         balances[_to] = balances[_to].add(_value); // Add the same to the recipient
156         allowed[_from][msg.sender] = allowed[_from][msg.sender].sub(_value); // adjust allowed
157         emit Transfer(_from, _to, _value);
158         return true;
159     }
160 
161     // @notice to query balance of account
162     // @return _owner {address} address of user to query balance
163     function balanceOf(address _owner) public view returns(uint balance) {
164         return balances[_owner];
165     }
166 
167     /**
168     * @dev Approve the passed address to spend the specified amount of tokens on behalf of msg.sender.
169     *
170     * Beware that changing an allowance with this method brings the risk that someone may use both the old
171     * and the new allowance by unfortunate transaction ordering. One possible solution to mitigate this
172     * race condition is to first reduce the spender's allowance to 0 and set the desired value afterwards:
173     * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
174     * @param _spender The address which will spend the funds.
175     * @param _value The amount of tokens to be spent.
176     */
177     function approve(address _spender, uint _value) public returns(bool) {
178         allowed[msg.sender][_spender] = _value;
179         emit Approval(msg.sender, _spender, _value);
180         return true;
181     }
182 
183     // @notice to query of allowance of one user to the other
184     // @param _owner {address} of the owner of the account
185     // @param _spender {address} of the spender of the account
186     // @return remaining {uint} amount of remaining allowance
187     function allowance(address _owner, address _spender) public view returns(uint remaining) {
188         return allowed[_owner][_spender];
189     }
190 
191     /**
192     * approve should be called when allowed[_spender] == 0. To increment
193     * allowed value is better to use this function to avoid 2 calls (and wait until
194     * the first transaction is mined)
195     * From MonolithDAO Token.sol
196     */
197     function increaseApproval (address _spender, uint _addedValue) public returns (bool success) {
198         allowed[msg.sender][_spender] = allowed[msg.sender][_spender].add(_addedValue);
199         emit Approval(msg.sender, _spender, allowed[msg.sender][_spender]);
200         return true;
201     }
202 
203     function decreaseApproval (address _spender, uint _subtractedValue) public returns (bool success) {
204         uint oldValue = allowed[msg.sender][_spender];
205         if (_subtractedValue > oldValue) {
206             allowed[msg.sender][_spender] = 0;
207         } else {
208             allowed[msg.sender][_spender] = oldValue.sub(_subtractedValue);
209         }
210         emit Approval(msg.sender, _spender, allowed[msg.sender][_spender]);
211         return true;
212     }
213 
214     /**
215      * @dev Burns a specific amount of tokens.
216      * @param _value The amount of token to be burned.
217      */
218     function burn(uint256 _value) public {
219         require(_value <= balances[msg.sender]);
220         // no need to require value <= totalSupply, since that would imply the
221         // sender's balance is greater than the totalSupply, which *should* be an assertion failure
222 
223         address burner = msg.sender;
224         balances[burner] = balances[burner].sub(_value);
225         totalSupply = totalSupply.sub(_value);
226         emit Burn(burner, _value);
227     }
228 
229 }