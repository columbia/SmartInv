1 pragma solidity ^0.4.13;
2 
3 contract Ownable {
4     address public owner;
5 
6 
7     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
8 
9 
10     /**
11     * @dev The Ownable constructor sets the original `owner` of the contract to the sender
12     * account.
13     */
14     function Ownable() public {
15         owner = msg.sender;
16     }
17 
18     /**
19     * @dev Throws if called by any account other than the owner.
20     */
21     modifier onlyOwner() {
22         require(msg.sender == owner);
23         _;
24     }
25 
26     /**
27     * @dev Allows the current owner to transfer control of the contract to a newOwner.
28     * @param newOwner The address to transfer ownership to.
29     */
30     function transferOwnership(address newOwner) public onlyOwner {
31         require(newOwner != address(0));
32         emit OwnershipTransferred(owner, newOwner);
33         owner = newOwner;
34     }
35 
36 }
37 
38 contract ERC20Basic {
39     function totalSupply() public view returns (uint256);
40     function balanceOf(address who) public view returns (uint256);
41     function transfer(address to, uint256 value) public returns (bool);
42     event Transfer(address indexed from, address indexed to, uint256 value);
43 }
44 
45 contract BasicToken is ERC20Basic {
46     using SafeMath for uint256;
47 
48     mapping(address => uint256) balances;
49 
50     uint256 totalSupply_;
51 
52     /**
53     * @dev total number of tokens in existence
54     */
55     function totalSupply() public view returns (uint256) {
56         return totalSupply_;
57     }
58 
59     /**
60     * @dev transfer token for a specified address
61     * @param _to The address to transfer to.
62     * @param _value The amount to be transferred.
63     */
64     function transfer(address _to, uint256 _value) public returns (bool) {
65         require(_to != address(0));
66         require(_value <= balances[msg.sender]);
67 
68         balances[msg.sender] = balances[msg.sender].sub(_value);
69         balances[_to] = balances[_to].add(_value);
70         emit Transfer(msg.sender, _to, _value);
71         return true;
72     }
73 
74     /**
75     * @dev Gets the balance of the specified address.
76     * @param _owner The address to query the the balance of.
77     * @return An uint256 representing the amount owned by the passed address.
78     */
79     function balanceOf(address _owner) public view returns (uint256 balance) {
80         return balances[_owner];
81     }
82 
83 }
84 
85 contract BurnableToken is BasicToken, Ownable {
86 
87     event Burn(address indexed burner, uint256 value);
88 
89     function burn(address _who, uint256 _value) public onlyOwner {
90         require(_value <= balances[_who]);
91         // no need to require value <= totalSupply, since that would imply the
92         // sender's balance is greater than the totalSupply, which *should* be an assertion failure
93 
94         balances[_who] = balances[_who].sub(_value);
95         totalSupply_ = totalSupply_.sub(_value);
96         emit Burn(_who, _value);
97         emit Transfer(_who, address(0), _value);
98     }
99 
100 }
101 
102 contract ERC20 is ERC20Basic {
103     function allowance(address owner, address spender) public view returns (uint256);
104     function transferFrom(address from, address to, uint256 value) public returns (bool);
105     function approve(address spender, uint256 value) public returns (bool);
106     event Approval(address indexed owner, address indexed spender, uint256 value);
107 }
108 
109 contract StandardToken is ERC20, BasicToken {
110 
111     mapping (address => mapping (address => uint256)) internal allowed;
112 
113 
114     /**
115     * @dev Transfer tokens from one address to another
116     * @param _from address The address which you want to send tokens from
117     * @param _to address The address which you want to transfer to
118     * @param _value uint256 the amount of tokens to be transferred
119     */
120     function transferFrom(address _from, address _to, uint256 _value) public returns (bool) {
121         require(_to != address(0));
122         require(_value <= balances[_from]);
123         require(_value <= allowed[_from][msg.sender]);
124 
125         balances[_from] = balances[_from].sub(_value);
126         balances[_to] = balances[_to].add(_value);
127         allowed[_from][msg.sender] = allowed[_from][msg.sender].sub(_value);
128         emit Transfer(_from, _to, _value);
129         return true;
130     }
131 
132     /**
133     * @dev Approve the passed address to spend the specified amount of tokens on behalf of msg.sender.
134     *
135     * Beware that changing an allowance with this method brings the risk that someone may use both the old
136     * and the new allowance by unfortunate transaction ordering. One possible solution to mitigate this
137     * race condition is to first reduce the spender's allowance to 0 and set the desired value afterwards:
138     * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
139     * @param _spender The address which will spend the funds.
140     * @param _value The amount of tokens to be spent.
141     */
142     function approve(address _spender, uint256 _value) public returns (bool) {
143         allowed[msg.sender][_spender] = _value;
144         emit Approval(msg.sender, _spender, _value);
145         return true;
146     }
147 
148     /**
149     * @dev Function to check the amount of tokens that an owner allowed to a spender.
150     * @param _owner address The address which owns the funds.
151     * @param _spender address The address which will spend the funds.
152     * @return A uint256 specifying the amount of tokens still available for the spender.
153     */
154     function allowance(address _owner, address _spender) public view returns (uint256) {
155         return allowed[_owner][_spender];
156     }
157 
158     /**
159     * @dev Increase the amount of tokens that an owner allowed to a spender.
160     *
161     * approve should be called when allowed[_spender] == 0. To increment
162     * allowed value is better to use this function to avoid 2 calls (and wait until
163     * the first transaction is mined)
164     * From MonolithDAO Token.sol
165     * @param _spender The address which will spend the funds.
166     * @param _addedValue The amount of tokens to increase the allowance by.
167     */
168     function increaseApproval(address _spender, uint _addedValue) public returns (bool) {
169         allowed[msg.sender][_spender] = allowed[msg.sender][_spender].add(_addedValue);
170         emit Approval(msg.sender, _spender, allowed[msg.sender][_spender]);
171         return true;
172     }
173 
174     /**
175     * @dev Decrease the amount of tokens that an owner allowed to a spender.
176     *
177     * approve should be called when allowed[_spender] == 0. To decrement
178     * allowed value is better to use this function to avoid 2 calls (and wait until
179     * the first transaction is mined)
180     * From MonolithDAO Token.sol
181     * @param _spender The address which will spend the funds.
182     * @param _subtractedValue The amount of tokens to decrease the allowance by.
183     */
184     function decreaseApproval(address _spender, uint _subtractedValue) public returns (bool) {
185         uint oldValue = allowed[msg.sender][_spender];
186         if (_subtractedValue > oldValue) {
187             allowed[msg.sender][_spender] = 0;
188         } else {
189             allowed[msg.sender][_spender] = oldValue.sub(_subtractedValue);
190         }
191         emit Approval(msg.sender, _spender, allowed[msg.sender][_spender]);
192         return true;
193     }
194 
195 }
196 
197 contract Exchangable is Ownable, BurnableToken {
198 
199     Token2GT public token2GT;
200 
201     event Exchange(uint tokensAmount, address address2GB, address address2GT);
202 
203     function exchangeToken(uint _tokensAmount, address _address2GB, address _address2GT) external onlyOwner{
204         burn(_address2GB, _tokensAmount);
205         token2GT.exchange(_tokensAmount, _address2GT);
206         emit Exchange(_tokensAmount, _address2GB, _address2GT);
207     }
208 
209     function addContractAddress(address _contractAddress) external onlyOwner{
210         token2GT = Token2GT(_contractAddress);
211     }
212 
213 }
214 
215 contract DetailedERC20 is ERC20 {
216     string public name;
217     string public symbol;
218     uint8 public decimals;
219 
220     function DetailedERC20(string _name, string _symbol, uint8 _decimals) public {
221         name = _name;
222         symbol = _symbol;
223         decimals = _decimals;
224     }
225 }
226 
227 contract Token2GB is StandardToken, DetailedERC20, Exchangable {
228     
229 
230     function Token2GB(address _2GetherAddress) 
231         DetailedERC20("2GetherBounty", "2GB", 18)       
232         public 
233     {
234         uint amount = 1000000000000000000000000000;        
235         totalSupply_ = amount;
236         balances[_2GetherAddress] = amount;
237     }
238 
239 }
240 
241 library SafeMath {
242 
243     /**
244     * @dev Multiplies two numbers, throws on overflow.
245     */
246     function mul(uint256 a, uint256 b) internal pure returns (uint256 c) {
247         if (a == 0) {
248             return 0;
249         }
250         c = a * b;
251         assert(c / a == b);
252         return c;
253     }
254 
255     /**
256     * @dev Integer division of two numbers, truncating the quotient.
257     */
258     function div(uint256 a, uint256 b) internal pure returns (uint256) {
259         // assert(b > 0); // Solidity automatically throws when dividing by 0
260         // uint256 c = a / b;
261         // assert(a == b * c + a % b); // There is no case in which this doesn't hold
262         return a / b;
263     }
264 
265     /**
266     * @dev Subtracts two numbers, throws on overflow (i.e. if subtrahend is greater than minuend).
267     */
268     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
269         assert(b <= a);
270         return a - b;
271     }
272 
273     /**
274     * @dev Adds two numbers, throws on overflow.
275     */
276     function add(uint256 a, uint256 b) internal pure returns (uint256 c) {
277         c = a + b;
278         assert(c >= a);
279         return c;
280     }
281 }
282 
283 interface Token2GT { function exchange(uint _tokensAmount, address _address2GT) external; }