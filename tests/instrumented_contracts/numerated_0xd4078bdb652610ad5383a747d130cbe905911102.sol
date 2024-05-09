1 pragma solidity 0.4.20;
2 
3 // ----------------------------------------------------------------------------
4 // 'VIOLET' 'VIOLET Token' token contract
5 //
6 // Symbol      : VAI
7 // Name        : VIOLET
8 // Total supply: 250,000,000.000000000000000000
9 // Decimals    : 18
10 //
11 // Enjoy.
12 //
13 // (c) Viola.AI Tech Pte Ltd 2018. The MIT Licence.
14 // ----------------------------------------------------------------------------
15 
16 
17 /**
18  * @title SafeMath
19  * @dev Math operations with safety checks that throw on error
20  */
21 library SafeMath {
22 
23   /**
24   * @dev Multiplies two numbers, throws on overflow.
25   */
26   function mul(uint256 a, uint256 b) internal pure returns (uint256) {
27     if (a == 0) {
28       return 0;
29     }
30     uint256 c = a * b;
31     assert(c / a == b);
32     return c;
33   }
34 
35   /**
36   * @dev Integer division of two numbers, truncating the quotient.
37   */
38   function div(uint256 a, uint256 b) internal pure returns (uint256) {
39     // assert(b > 0); // Solidity automatically throws when dividing by 0
40     uint256 c = a / b;
41     // assert(a == b * c + a % b); // There is no case in which this doesn't hold
42     return c;
43   }
44 
45   /**
46   * @dev Substracts two numbers, throws on overflow (i.e. if subtrahend is greater than minuend).
47   */
48   function sub(uint256 a, uint256 b) internal pure returns (uint256) {
49     assert(b <= a);
50     return a - b;
51   }
52 
53   /**
54   * @dev Adds two numbers, throws on overflow.
55   */
56   function add(uint256 a, uint256 b) internal pure returns (uint256) {
57     uint256 c = a + b;
58     assert(c >= a);
59     return c;
60   }
61 }
62 
63 
64 // ----------------------------------------------------------------------------
65 // ERC Token Standard #20 Interface
66 // https://github.com/ethereum/EIPs/blob/master/EIPS/eip-20-token-standard.md
67 // ----------------------------------------------------------------------------
68 contract ERC20Interface {
69     function totalSupply() public view returns (uint256);
70     function balanceOf(address who) public view returns (uint256);
71     function transfer(address to, uint256 value) public returns (bool);
72     function allowance(address owner, address spender) public view returns (uint256);
73     function transferFrom(address from, address to, uint256 value) public returns (bool);
74     function approve(address spender, uint256 value) public returns (bool);
75 
76     event Approval(address indexed owner, address indexed spender, uint256 value);
77     event Transfer(address indexed from, address indexed to, uint256 value);
78     event Burn(address indexed burner, uint256 value);
79 }
80 
81 
82 // ----------------------------------------------------------------------------
83 // VIOLET ERC20 Standard Token
84 // ----------------------------------------------------------------------------
85 contract VLTToken is ERC20Interface {
86     using SafeMath for uint256;
87 
88     address public owner = msg.sender;
89 
90     bytes32 public symbol;
91     bytes32 public name;
92     uint8 public decimals;
93     uint256 public _totalSupply;
94 
95     mapping(address => uint256) internal balances;
96     mapping(address => mapping (address => uint256)) internal allowed;
97 
98     modifier onlyOwner() {
99         require(msg.sender == owner);
100         _;
101     }
102 
103     // ------------------------------------------------------------------------
104     // Constructor
105     // ------------------------------------------------------------------------
106     function VLTToken() public {
107         symbol = "VAI";
108         name = "VIOLET";
109         decimals = 18;
110         _totalSupply = 250000000 * 10**uint256(decimals);
111         balances[owner] = _totalSupply;
112         Transfer(address(0), owner, _totalSupply);
113     }
114 
115 
116     /**
117     * @dev total number of tokens in existence
118     */
119     function totalSupply() public view returns (uint256) {
120         return _totalSupply;
121     }
122 
123     /**
124     * @dev Gets the balance of the specified address.
125     * @param _owner The address to query the the balance of.
126     * @return An uint256 representing the amount owned by the passed address.
127     */
128     function balanceOf(address _owner) public view returns (uint256 balance) {
129         return balances[_owner];
130     }
131 
132     /**
133     * @dev transfer token for a specified address
134     * @param _to The address to transfer to.
135     * @param _value The amount to be transferred.
136     */
137     function transfer(address _to, uint256 _value) public returns (bool) {
138         // allow sending 0 tokens
139         if (_value == 0) {
140             Transfer(msg.sender, _to, _value);    // Follow the spec to louch the event when transfer 0
141             return;
142         }
143         
144         require(_to != address(0));
145         require(_value <= balances[msg.sender]);
146 
147         // SafeMath.sub will throw if there is not enough balance.
148         balances[msg.sender] = balances[msg.sender].sub(_value);
149         balances[_to] = balances[_to].add(_value);
150         Transfer(msg.sender, _to, _value);
151         return true;
152     }
153 
154     /**
155     * @dev Approve the passed address to spend the specified amount of tokens on behalf of msg.sender.
156     *
157     * Beware that changing an allowance with this method brings the risk that someone may use both the old
158     * and the new allowance by unfortunate transaction ordering. One possible solution to mitigate this
159     * race condition is to first reduce the spender's allowance to 0 and set the desired value afterwards:
160     * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
161     * @param _spender The address which will spend the funds.
162     * @param _value The amount of tokens to be spent.
163     */
164     function approve(address _spender, uint256 _value) public returns (bool) {
165         allowed[msg.sender][_spender] = _value;
166         Approval(msg.sender, _spender, _value);
167         return true;
168     }
169 
170     /**
171     * @dev Transfer tokens from one address to another
172     * @param _from address The address which you want to send tokens from
173     * @param _to address The address which you want to transfer to
174     * @param _value uint256 the amount of tokens to be transferred
175     */
176     function transferFrom(address _from, address _to, uint256 _value) public returns (bool) {
177         // allow sending 0 tokens
178         if (_value == 0) {
179             Transfer(_from, _to, _value);    // Follow the spec to louch the event when transfer 0
180             return;
181         }
182 
183         require(_to != address(0));
184         require(_value <= balances[_from]);
185         require(_value <= allowed[_from][msg.sender]);
186 
187         balances[_from] = balances[_from].sub(_value);
188         balances[_to] = balances[_to].add(_value);
189         allowed[_from][msg.sender] = allowed[_from][msg.sender].sub(_value);
190         Transfer(_from, _to, _value);
191         return true;
192     }
193 
194 
195     /**
196     * @dev Function to check the amount of tokens that an owner allowed to a spender.
197     * @param _owner address The address which owns the funds.
198     * @param _spender address The address which will spend the funds.
199     * @return A uint256 specifying the amount of tokens still available for the spender.
200     */
201     function allowance(address _owner, address _spender) public view returns (uint256) {
202         return allowed[_owner][_spender];
203     }
204 
205 
206     /**
207     * @dev Increase the amount of tokens that an owner allowed to a spender.
208     *
209     * approve should be called when allowed[_spender] == 0. To increment
210     * allowed value is better to use this function to avoid 2 calls (and wait until
211     * the first transaction is mined)
212     * From MonolithDAO Token.sol
213     * @param _spender The address which will spend the funds.
214     * @param _addedValue The amount of tokens to increase the allowance by.
215     */
216     function increaseApproval(address _spender, uint _addedValue) public returns (bool) {
217         allowed[msg.sender][_spender] = allowed[msg.sender][_spender].add(_addedValue);
218         Approval(msg.sender, _spender, allowed[msg.sender][_spender]);
219         return true;
220     }
221 
222     /**
223     * @dev Decrease the amount of tokens that an owner allowed to a spender.
224     *
225     * approve should be called when allowed[_spender] == 0. To decrement
226     * allowed value is better to use this function to avoid 2 calls (and wait until
227     * the first transaction is mined)
228     * From MonolithDAO Token.sol
229     * @param _spender The address which will spend the funds.
230     * @param _subtractedValue The amount of tokens to decrease the allowance by.
231     */
232     function decreaseApproval(address _spender, uint _subtractedValue) public returns (bool) {
233         uint oldValue = allowed[msg.sender][_spender];
234         if (_subtractedValue > oldValue) {
235         allowed[msg.sender][_spender] = 0;
236         } else {
237         allowed[msg.sender][_spender] = oldValue.sub(_subtractedValue);
238         }
239         Approval(msg.sender, _spender, allowed[msg.sender][_spender]);
240         return true;
241     }
242 
243     /**
244     * @dev Burns a specific amount of tokens.
245     * @param _value The amount of token to be burned.
246     */
247     function burn(uint256 _value) public {
248         require(_value <= balances[msg.sender]);
249         // no need to require value <= totalSupply, since that would imply the
250         // sender's balance is greater than the totalSupply, which *should* be an assertion failure
251 
252         address burner = msg.sender;
253         balances[burner] = balances[burner].sub(_value);
254         _totalSupply = _totalSupply.sub(_value);
255         Burn(burner, _value);
256         Transfer(burner, address(0), _value);
257     }
258 
259     /**
260      * Destroy tokens from other account
261      * Remove `_value` tokens from the system irreversibly on behalf of `_from`.
262      * @param _from the address of the sender
263      * @param _value the amount of money to burn
264      */
265     function burnFrom(address _from, uint256 _value) public returns (bool) {
266         require(_value <= balances[_from]);               // Check if the targeted balance is enough
267         require(_value <= allowed[_from][msg.sender]);    // Check allowed allowance
268         balances[_from] = balances[_from].sub(_value);  // Subtract from the targeted balance
269         allowed[_from][msg.sender] = allowed[_from][msg.sender].sub(_value);             // Subtract from the sender's allowance
270         _totalSupply = _totalSupply.sub(_value);                              // Update totalSupply
271         Burn(_from, _value);
272         Transfer(_from, address(0), _value);
273         return true;
274     } 
275 
276     // ------------------------------------------------------------------------
277     // Owner can transfer out any accidentally sent ERC20 tokens
278     // ------------------------------------------------------------------------
279     function transferAnyERC20Token(address tokenAddress, uint tokens) public onlyOwner returns (bool success) {
280         return ERC20Interface(tokenAddress).transfer(owner, tokens);
281     }
282 }