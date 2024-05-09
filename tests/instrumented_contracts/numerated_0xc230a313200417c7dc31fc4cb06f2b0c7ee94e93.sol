1 pragma solidity ^0.4.23;
2 
3 /**
4  * @title ERC20Basic
5  * @dev Simpler version of ERC20 interface
6  * @dev see https://github.com/ethereum/EIPs/issues/179
7  */
8 contract ERC20Basic {
9     function totalSupply() public view returns (uint256);
10     function balanceOf(address who) public view returns (uint256);
11     function transfer(address to, uint256 value) public returns (bool);
12     event Transfer(address indexed from, address indexed to, uint256 value);
13 }
14 
15 
16 /**
17  * @title SafeMath
18  * @dev Math operations with safety checks that throw on error
19  */
20 library SafeMath {
21 
22   /**
23   * @dev Multiplies two numbers, throws on overflow.
24   */
25     function mul(uint256 a, uint256 b) internal pure returns (uint256 c) {
26         if (a == 0) {
27             return 0;
28         }
29         c = a * b;
30         assert(c / a == b);
31         return c;
32     }
33 
34     /**
35     * @dev Integer division of two numbers, truncating the quotient.
36     */
37     function div(uint256 a, uint256 b) internal pure returns (uint256) {
38         // assert(b > 0); // Solidity automatically throws when dividing by 0
39         // uint256 c = a / b;
40         // assert(a == b * c + a % b); // There is no case in which this doesn't hold
41         return a / b;
42     }
43 
44     /**
45     * @dev Subtracts two numbers, throws on overflow (i.e. if subtrahend is greater than minuend).
46     */
47     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
48         assert(b <= a);
49         return a - b;
50     }
51 
52     /**
53     * @dev Adds two numbers, throws on overflow.
54     */
55     function add(uint256 a, uint256 b) internal pure returns (uint256 c) {
56         c = a + b;
57         assert(c >= a);
58         return c;
59     }
60 }
61 
62 
63 /**
64  * @title Basic token
65  * @dev Basic version of StandardToken, with no allowances.
66  */
67 contract BasicToken is ERC20Basic {
68     using SafeMath for uint256;
69 
70     mapping(address => uint256) balances;
71 
72     uint256 totalSupply_;
73 
74     /**
75     * @dev total number of tokens in existence
76     */
77     function totalSupply() public view returns (uint256) {
78         return totalSupply_;
79     }
80 
81     /**
82     * @dev transfer token for a specified address
83     * @param _to The address to transfer to.
84     * @param _value The amount to be transferred.
85     */
86     function transfer(address _to, uint256 _value) public returns (bool) {
87         require(_to != address(0));
88         require(_value <= balances[msg.sender]);
89 
90         balances[msg.sender] = balances[msg.sender].sub(_value);
91         balances[_to] = balances[_to].add(_value);
92         emit Transfer(msg.sender, _to, _value);
93         return true;
94     }
95 
96     /**
97     * @dev Gets the balance of the specified address.
98     * @param _owner The address to query the the balance of.
99     * @return An uint256 representing the amount owned by the passed address.
100     */
101     function balanceOf(address _owner) public view returns (uint256) {
102         return balances[_owner];
103     }
104 
105 }
106 
107 
108 /**
109  * @title ERC20 interface
110  * @dev see https://github.com/ethereum/EIPs/issues/20
111  */
112 contract ERC20 is ERC20Basic {
113     function allowance(address owner, address spender)
114         public view returns (uint256);
115 
116     function transferFrom(address from, address to, uint256 value)
117         public returns (bool);
118 
119     function approve(address spender, uint256 value) public returns (bool);
120     event Approval(
121         address indexed owner,
122         address indexed spender,
123         uint256 value
124     );
125 }
126 
127 
128 /**
129  * @title Standard ERC20 token
130  *
131  * @dev Implementation of the basic standard token.
132  * @dev https://github.com/ethereum/EIPs/issues/20
133  * @dev Based on code by FirstBlood: https://github.com/Firstbloodio/token/blob/master/smart_contract/FirstBloodToken.sol
134  */
135 contract StandardToken is ERC20, BasicToken {
136 
137     mapping (address => mapping (address => uint256)) internal allowed;
138 
139 
140     /**
141     * @dev Transfer tokens from one address to another
142     * @param _from address The address which you want to send tokens from
143     * @param _to address The address which you want to transfer to
144     * @param _value uint256 the amount of tokens to be transferred
145     */
146     function transferFrom(
147         address _from,
148         address _to,
149         uint256 _value
150     )
151         public
152         returns (bool)
153     {
154         require(_to != address(0));
155         require(_value <= balances[_from]);
156         require(_value <= allowed[_from][msg.sender]);
157 
158         balances[_from] = balances[_from].sub(_value);
159         balances[_to] = balances[_to].add(_value);
160         allowed[_from][msg.sender] = allowed[_from][msg.sender].sub(_value);
161         emit Transfer(_from, _to, _value);
162         return true;
163     }
164 
165     /**
166     * @dev Approve the passed address to spend the specified amount of tokens on behalf of msg.sender.
167     *
168     * Beware that changing an allowance with this method brings the risk that someone may use both the old
169     * and the new allowance by unfortunate transaction ordering. One possible solution to mitigate this
170     * race condition is to first reduce the spender's allowance to 0 and set the desired value afterwards:
171     * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
172     * @param _spender The address which will spend the funds.
173     * @param _value The amount of tokens to be spent.
174     */
175     function approve(address _spender, uint256 _value) public returns (bool) {
176         allowed[msg.sender][_spender] = _value;
177         emit Approval(msg.sender, _spender, _value);
178         return true;
179     }
180 
181     /**
182     * @dev Function to check the amount of tokens that an owner allowed to a spender.
183     * @param _owner address The address which owns the funds.
184     * @param _spender address The address which will spend the funds.
185     * @return A uint256 specifying the amount of tokens still available for the spender.
186     */
187     function allowance(
188         address _owner,
189         address _spender
190     )
191         public
192         view
193         returns (uint256)
194     {
195         return allowed[_owner][_spender];
196     }
197 
198     /**
199     * @dev Increase the amount of tokens that an owner allowed to a spender.
200     *
201     * approve should be called when allowed[_spender] == 0. To increment
202     * allowed value is better to use this function to avoid 2 calls (and wait until
203     * the first transaction is mined)
204     * From MonolithDAO Token.sol
205     * @param _spender The address which will spend the funds.
206     * @param _addedValue The amount of tokens to increase the allowance by.
207     */
208     function increaseApproval(
209         address _spender,
210         uint _addedValue
211     )
212         public
213         returns (bool)
214     {
215         allowed[msg.sender][_spender] = (
216         allowed[msg.sender][_spender].add(_addedValue));
217         emit Approval(msg.sender, _spender, allowed[msg.sender][_spender]);
218         return true;
219     }
220 
221     /**
222     * @dev Decrease the amount of tokens that an owner allowed to a spender.
223     *
224     * approve should be called when allowed[_spender] == 0. To decrement
225     * allowed value is better to use this function to avoid 2 calls (and wait until
226     * the first transaction is mined)
227     * From MonolithDAO Token.sol
228     * @param _spender The address which will spend the funds.
229     * @param _subtractedValue The amount of tokens to decrease the allowance by.
230     */
231     function decreaseApproval(
232         address _spender,
233         uint _subtractedValue
234     )
235         public
236         returns (bool)
237     {
238         uint oldValue = allowed[msg.sender][_spender];
239         if (_subtractedValue > oldValue) {
240             allowed[msg.sender][_spender] = 0;
241         } else {
242             allowed[msg.sender][_spender] = oldValue.sub(_subtractedValue);
243         }
244         emit Approval(msg.sender, _spender, allowed[msg.sender][_spender]);
245         return true;
246     }
247 
248 }
249 
250 
251 contract AsiaPacificCoin is StandardToken {
252 
253     string public constant name = "Asia Pacific Coin";
254     string public constant symbol = "APC";
255     uint8 public constant decimals = 6;
256 
257     uint256 public constant INITIAL_SUPPLY = 88 * (10 ** uint256(8)) * (10 ** uint256(decimals));
258 
259     constructor() public {
260         totalSupply_ = INITIAL_SUPPLY;
261         balances[msg.sender] = INITIAL_SUPPLY;
262         emit Transfer(0x0, msg.sender, INITIAL_SUPPLY);
263     }
264 
265 }