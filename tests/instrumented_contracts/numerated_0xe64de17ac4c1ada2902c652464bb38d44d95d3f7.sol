1 pragma solidity ^0.4.18;
2 
3 
4 library SafeMath {
5 
6     /**
7     * @dev Multiplies two numbers, throws on overflow.
8     */
9     function mul(uint256 a, uint256 b) internal pure returns (uint256) {
10         if (a == 0) {
11             return 0;
12         }
13         uint256 c = a * b;
14         assert(c / a == b);
15         return c;
16     }
17 
18     /**
19     * @dev Integer division of two numbers, truncating the quotient.
20     */
21     function div(uint256 a, uint256 b) internal pure returns (uint256) {
22         // assert(b > 0); // Solidity automatically throws when dividing by 0
23         uint256 c = a / b;
24         // assert(a == b * c + a % b); // There is no case in which this doesn't hold
25         return c;
26     }
27 
28     /**
29     * @dev Substracts two numbers, throws on overflow (i.e. if subtrahend is greater than minuend).
30     */
31     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
32         assert(b <= a);
33         return a - b;
34     }
35 
36     /**
37     * @dev Adds two numbers, throws on overflow.
38     */
39     function add(uint256 a, uint256 b) internal pure returns (uint256) {
40         uint256 c = a + b;
41         assert(c >= a);
42         return c;
43     }
44 }
45 
46 contract Ownable {
47     address public owner;
48 
49 
50     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
51 
52 
53     /**
54     * @dev The Ownable constructor sets the original `owner` of the contract to the sender
55     * account.
56     */
57     function Ownable() public {
58         owner = msg.sender;
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
71     * @param newOwner The address to transfer ownership to.
72     */
73     function transferOwnership(address newOwner) public onlyOwner {
74         require(newOwner != address(0));
75         emit OwnershipTransferred(owner, newOwner);
76         owner = newOwner;
77     }
78 
79 }
80 
81 
82 contract ERC20Basic {
83     function totalSupply() public view returns (uint256);
84     function balanceOf(address who) public view returns (uint256);
85     function transfer(address to, uint256 value) public returns (bool);
86     event Transfer(address indexed from, address indexed to, uint256 value);
87 }
88 
89 
90 contract ERC20 is ERC20Basic {
91     function allowance(address owner, address spender) public view returns (uint256);
92     function transferFrom(address from, address to, uint256 value) public returns (bool);
93     function approve(address spender, uint256 value) public returns (bool);
94     event Approval(address indexed owner, address indexed spender, uint256 value);
95 }
96 
97 
98 contract BasicToken is ERC20Basic {
99     using SafeMath for uint256;
100 
101     mapping(address => uint256) balances;
102 
103     uint256 totalSupply_;
104 
105     /**
106     * @dev total number of tokens in existence
107     */
108     function totalSupply() public view returns (uint256) {
109         return totalSupply_;
110     }
111 
112     /**
113     * @dev transfer token for a specified address
114     * @param _to The address to transfer to.
115     * @param _value The amount to be transferred.
116     */
117     function transfer(address _to, uint256 _value) public returns (bool) {
118         require(_to != address(0));
119         require(_value <= balances[msg.sender]);
120 
121         // SafeMath.sub will throw if there is not enough balance.
122         balances[msg.sender] = balances[msg.sender].sub(_value);
123         balances[_to] = balances[_to].add(_value);
124         emit Transfer(msg.sender, _to, _value);
125         return true;
126     }
127 
128     /**
129     * @dev Gets the balance of the specified address.
130     * @param _owner The address to query the the balance of.
131     * @return An uint256 representing the amount owned by the passed address.
132     */
133     function balanceOf(address _owner) public view returns (uint256 balance) {
134         return balances[_owner];
135     }
136 
137 }
138 
139 
140 contract StandardToken is ERC20, BasicToken {
141 
142     mapping (address => mapping (address => uint256)) internal allowed;
143 
144 
145     /**
146     * @dev Transfer tokens from one address to another
147     * @param _from address The address which you want to send tokens from
148     * @param _to address The address which you want to transfer to
149     * @param _value uint256 the amount of tokens to be transferred
150     */
151     function transferFrom(address _from, address _to, uint256 _value) public returns (bool) {
152         require(_to != address(0));
153         require(_value <= balances[_from]);
154         require(_value <= allowed[_from][msg.sender]);
155 
156         balances[_from] = balances[_from].sub(_value);
157         balances[_to] = balances[_to].add(_value);
158         allowed[_from][msg.sender] = allowed[_from][msg.sender].sub(_value);
159         emit Transfer(_from, _to, _value);
160         return true;
161     }
162 
163     /**
164     * @dev Approve the passed address to spend the specified amount of tokens on behalf of msg.sender.
165     *
166     * Beware that changing an allowance with this method brings the risk that someone may use both the old
167     * and the new allowance by unfortunate transaction ordering. One possible solution to mitigate this
168     * race condition is to first reduce the spender's allowance to 0 and set the desired value afterwards:
169     * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
170     * @param _spender The address which will spend the funds.
171     * @param _value The amount of tokens to be spent.
172     */
173     function approve(address _spender, uint256 _value) public returns (bool) {
174         allowed[msg.sender][_spender] = _value;
175         emit Approval(msg.sender, _spender, _value);
176         return true;
177     }
178 
179     /**
180     * @dev Function to check the amount of tokens that an owner allowed to a spender.
181     * @param _owner address The address which owns the funds.
182     * @param _spender address The address which will spend the funds.
183     * @return A uint256 specifying the amount of tokens still available for the spender.
184     */
185     function allowance(address _owner, address _spender) public view returns (uint256) {
186         return allowed[_owner][_spender];
187     }
188 
189     /**
190     * @dev Increase the amount of tokens that an owner allowed to a spender.
191     *
192     * approve should be called when allowed[_spender] == 0. To increment
193     * allowed value is better to use this function to avoid 2 calls (and wait until
194     * the first transaction is mined)
195     * From MonolithDAO Token.sol
196     * @param _spender The address which will spend the funds.
197     * @param _addedValue The amount of tokens to increase the allowance by.
198     */
199     function increaseApproval(address _spender, uint _addedValue) public returns (bool) {
200         allowed[msg.sender][_spender] = allowed[msg.sender][_spender].add(_addedValue);
201         emit Approval(msg.sender, _spender, allowed[msg.sender][_spender]);
202         return true;
203     }
204 
205     /**
206     * @dev Decrease the amount of tokens that an owner allowed to a spender.
207     *
208     * approve should be called when allowed[_spender] == 0. To decrement
209     * allowed value is better to use this function to avoid 2 calls (and wait until
210     * the first transaction is mined)
211     * From MonolithDAO Token.sol
212     * @param _spender The address which will spend the funds.
213     * @param _subtractedValue The amount of tokens to decrease the allowance by.
214     */
215     function decreaseApproval(address _spender, uint _subtractedValue) public returns (bool) {
216         uint oldValue = allowed[msg.sender][_spender];
217         if (_subtractedValue > oldValue) {
218             allowed[msg.sender][_spender] = 0;
219         } else {
220             allowed[msg.sender][_spender] = oldValue.sub(_subtractedValue);
221         }
222         emit Approval(msg.sender, _spender, allowed[msg.sender][_spender]);
223         return true;
224     }
225 
226 }
227 
228 
229 contract GStarToken is StandardToken, Ownable {
230     using SafeMath for uint256;
231 
232     string public constant name = "GSTAR Token";
233     string public constant symbol = "GSTAR";
234     uint8 public constant decimals = 18;
235 
236     uint256 public constant INITIAL_SUPPLY = 1600000000 * ((10 ** uint256(decimals)));
237     uint256 public currentTotalSupply = 0;
238 
239     event Burn(address indexed burner, uint256 value);
240 
241 
242     /**
243     * @dev Constructor that gives msg.sender all of existing tokens.
244     */
245     function GStarToken() public {
246         owner = msg.sender;
247         totalSupply_ = INITIAL_SUPPLY;
248         balances[owner] = INITIAL_SUPPLY;
249         currentTotalSupply = INITIAL_SUPPLY;
250         emit Transfer(address(0), owner, INITIAL_SUPPLY);
251     }
252 
253     /**
254     * @dev Burns a specific amount of tokens.
255     * @param value The amount of token to be burned.
256     */
257     function burn(uint256 value) public onlyOwner {
258         require(value <= balances[msg.sender]);
259 
260         address burner = msg.sender;
261         balances[burner] = balances[burner].sub(value);
262         currentTotalSupply = currentTotalSupply.sub(value);
263         emit Burn(burner, value);
264     }
265 }