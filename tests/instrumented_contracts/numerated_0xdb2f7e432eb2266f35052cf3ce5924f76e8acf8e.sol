1 pragma solidity 0.4.24;
2 
3 
4 /**
5  * @title SafeMath
6  * @dev Math operations with safety checks that throw on error
7  */
8 library SafeMath {
9 
10   /**
11   * @dev Multiplies two numbers, throws on overflow.
12   */
13   function mul(uint256 a, uint256 b) internal pure returns (uint256) {
14     if (a == 0) {
15       return 0;
16     }
17     uint256 c = a * b;
18     assert(c / a == b);
19     return c;
20   }
21 
22   /**
23   * @dev Integer division of two numbers, truncating the quotient.
24   */
25   function div(uint256 a, uint256 b) internal pure returns (uint256) {
26     // assert(b > 0); // Solidity automatically throws when dividing by 0
27     uint256 c = a / b;
28     // assert(a == b * c + a % b); // There is no case in which this doesn't hold
29     return c;
30   }
31 
32   /**
33   * @dev Substracts two numbers, throws on overflow (i.e. if subtrahend is greater than minuend).
34   */
35   function sub(uint256 a, uint256 b) internal pure returns (uint256) {
36     assert(b <= a);
37     return a - b;
38   }
39 
40   /**
41   * @dev Adds two numbers, throws on overflow.
42   */
43   function add(uint256 a, uint256 b) internal pure returns (uint256) {
44     uint256 c = a + b;
45     assert(c >= a);
46     return c;
47   }
48 }
49 
50 
51 // ----------------------------------------------------------------------------
52 // ERC Token Standard #20 Interface
53 // https://github.com/ethereum/EIPs/blob/master/EIPS/eip-20-token-standard.md
54 // ----------------------------------------------------------------------------
55 contract ERC20Interface {
56     function totalSupply() public view returns (uint256);
57     function balanceOf(address who) public view returns (uint256);
58     function transfer(address to, uint256 value) public returns (bool);
59     function allowance(address owner, address spender) public view returns (uint256);
60     function transferFrom(address from, address to, uint256 value) public returns (bool);
61     function approve(address spender, uint256 value) public returns (bool);
62 
63     event Approval(address indexed owner, address indexed spender, uint256 value);
64     event Transfer(address indexed from, address indexed to, uint256 value);
65     event Burn(address indexed burner, uint256 value);
66 }
67 
68 
69 
70 // ----------------------------------------------------------------------------
71 // VIOLET ERC20 Standard Token
72 // ----------------------------------------------------------------------------
73 contract BFCToken is ERC20Interface {
74     using SafeMath for uint256;
75      event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
76 
77     address public owner = msg.sender;
78     address public newOwner;
79 
80     string public symbol;
81     string public name;
82     uint8 public decimals;
83     uint256 public _totalSupply;
84 
85     mapping(address => uint256) internal balances;
86     mapping(address => mapping (address => uint256)) internal allowed;
87 
88     modifier onlyOwner() {
89         require(msg.sender == owner);
90         _;
91     }
92     
93     function transferOwnership(address _newOwner) public onlyOwner {
94         newOwner = _newOwner;
95     }
96     
97     function acceptOwnership() public {
98         require(msg.sender == newOwner);
99         emit OwnershipTransferred(owner, newOwner);
100         owner = newOwner;
101         newOwner = address(0);
102     }
103 
104 
105 
106     // ------------------------------------------------------------------------
107     // Constructor
108     // ------------------------------------------------------------------------
109     constructor() public {
110         symbol = "BFC";
111         name = "BLOCKFREELANCER";
112         decimals = 18;
113         _totalSupply = 100000000 * 10**uint256(decimals);
114         balances[owner] = _totalSupply;
115         emit Transfer(address(0), owner, _totalSupply);
116     }
117 
118 
119     /**
120     * @dev total number of tokens in existence
121     */
122     function totalSupply() public view returns (uint256) {
123         return _totalSupply;
124     }
125 
126     /**
127     * @dev Gets the balance of the specified address.
128     * @param _owner The address to query the the balance of.
129     * @return An uint256 representing the amount owned by the passed address.
130     */
131     function balanceOf(address _owner) public view returns (uint256 balance) {
132         return balances[_owner];
133     }
134 
135     /**
136     * @dev transfer token for a specified address
137     * @param _to The address to transfer to.
138     * @param _value The amount to be transferred.
139     */
140     function transfer(address _to, uint256 _value) public returns (bool) {
141         // allow sending 0 tokens
142         if (_value == 0) {
143             emit Transfer(msg.sender, _to, _value);    // Follow the spec to louch the event when transfer 0
144             return;
145         }
146 
147         require(_to != address(0));
148         require(_value <= balances[msg.sender]);
149 
150         // SafeMath.sub will throw if there is not enough balance.
151         balances[msg.sender] = balances[msg.sender].sub(_value);
152         balances[_to] = balances[_to].add(_value);
153         emit Transfer(msg.sender, _to, _value);
154         return true;
155     }
156 
157     /**
158     * @dev Approve the passed address to spend the specified amount of tokens on behalf of msg.sender.
159     *
160     * Beware that changing an allowance with this method brings the risk that someone may use both the old
161     * and the new allowance by unfortunate transaction ordering. One possible solution to mitigate this
162     * race condition is to first reduce the spender's allowance to 0 and set the desired value afterwards:
163     * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
164     * @param _spender The address which will spend the funds.
165     * @param _value The amount of tokens to be spent.
166     */
167     function approve(address _spender, uint256 _value) public returns (bool) {
168         allowed[msg.sender][_spender] = _value;
169         emit Approval(msg.sender, _spender, _value);
170         return true;
171     }
172 
173     /**
174     * @dev Transfer tokens from one address to another
175     * @param _from address The address which you want to send tokens from
176     * @param _to address The address which you want to transfer to
177     * @param _value uint256 the amount of tokens to be transferred
178     */
179     function transferFrom(address _from, address _to, uint256 _value) public returns (bool) {
180         // allow sending 0 tokens
181         if (_value == 0) {
182             emit Transfer(_from, _to, _value);    // Follow the spec to louch the event when transfer 0
183             return;
184         }
185 
186         require(_to != address(0));
187         require(_value <= balances[_from]);
188         require(_value <= allowed[_from][msg.sender]);
189 
190         balances[_from] = balances[_from].sub(_value);
191         balances[_to] = balances[_to].add(_value);
192         allowed[_from][msg.sender] = allowed[_from][msg.sender].sub(_value);
193         emit Transfer(_from, _to, _value);
194         return true;
195     }
196 
197 
198     /**
199     * @dev Function to check the amount of tokens that an owner allowed to a spender.
200     * @param _owner address The address which owns the funds.
201     * @param _spender address The address which will spend the funds.
202     * @return A uint256 specifying the amount of tokens still available for the spender.
203     */
204     function allowance(address _owner, address _spender) public view returns (uint256) {
205         return allowed[_owner][_spender];
206     }
207 
208 
209     /**
210     * @dev Increase the amount of tokens that an owner allowed to a spender.
211     *
212     * approve should be called when allowed[_spender] == 0. To increment
213     * allowed value is better to use this function to avoid 2 calls (and wait until
214     * the first transaction is mined)
215     * From MonolithDAO Token.sol
216     * @param _spender The address which will spend the funds.
217     * @param _addedValue The amount of tokens to increase the allowance by.
218     */
219     function increaseApproval(address _spender, uint _addedValue) public returns (bool) {
220         allowed[msg.sender][_spender] = allowed[msg.sender][_spender].add(_addedValue);
221         emit Approval(msg.sender, _spender, allowed[msg.sender][_spender]);
222         return true;
223     }
224 
225     /**
226     * @dev Decrease the amount of tokens that an owner allowed to a spender.
227     *
228     * approve should be called when allowed[_spender] == 0. To decrement
229     * allowed value is better to use this function to avoid 2 calls (and wait until
230     * the first transaction is mined)
231     * From MonolithDAO Token.sol
232     * @param _spender The address which will spend the funds.
233     * @param _subtractedValue The amount of tokens to decrease the allowance by.
234     */
235     function decreaseApproval(address _spender, uint _subtractedValue) public returns (bool) {
236         uint oldValue = allowed[msg.sender][_spender];
237         if (_subtractedValue > oldValue) {
238         allowed[msg.sender][_spender] = 0;
239         } else {
240         allowed[msg.sender][_spender] = oldValue.sub(_subtractedValue);
241         }
242         emit Approval(msg.sender, _spender, allowed[msg.sender][_spender]);
243         return true;
244     }
245 
246     /**
247     * @dev Burns a specific amount of tokens.
248     * @param _value The amount of token to be burned.
249     */
250     function burn(uint256 _value) public {
251         require(_value <= balances[msg.sender]);
252         // no need to require value <= totalSupply, since that would imply the
253         // sender's balance is greater than the totalSupply, which *should* be an assertion failure
254 
255         address burner = msg.sender;
256         balances[burner] = balances[burner].sub(_value);
257         _totalSupply = _totalSupply.sub(_value);
258         emit Burn(burner, _value);
259         emit Transfer(burner, address(0), _value);
260     }
261 
262 
263 
264     // ------------------------------------------------------------------------
265     // Owner can transfer out any accidentally sent ERC20 tokens
266     // ------------------------------------------------------------------------
267     function transferAnyERC20Token(address tokenAddress, uint tokens) public onlyOwner returns (bool success) {
268         return ERC20Interface(tokenAddress).transfer(owner, tokens);
269     }
270 }