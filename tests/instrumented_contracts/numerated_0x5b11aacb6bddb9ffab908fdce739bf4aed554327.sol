1 pragma solidity 0.4.23;
2 
3 /**
4  * @title SafeMath
5  * @dev Math operations with safety checks that throw on error
6  */
7 library SafeMath {
8 
9 
10     /**
11     * @dev Multiplies two numbers, reverts on overflow.
12     */
13     function mul(uint256 _a, uint256 _b) internal pure returns (uint256) {
14         if (_a == 0) {
15             return 0;
16         }
17         uint256 c = _a * _b;
18         require(c / _a == _b);
19 
20         return c;
21     }
22 
23     /**
24     * @dev Integer division of two numbers truncating the quotient, reverts on division by zero.
25     */
26     function div(uint256 _a, uint256 _b) internal pure returns (uint256) {
27         require(_b > 0); // Solidity only automatically asserts when dividing by 0
28         uint256 c = _a / _b;
29         // assert(_a == _b * c + _a % _b); // There is no case in which this doesn't hold
30 
31         return c;
32     }
33 
34     /**
35     * @dev Subtracts two numbers, reverts on overflow (i.e. if subtrahend is greater than minuend).
36     */
37     function sub(uint256 _a, uint256 _b) internal pure returns (uint256) {
38         require(_b <= _a);
39         uint256 c = _a - _b;
40 
41         return c;
42     }
43 
44     /**
45     * @dev Adds two numbers, throws on overflow.
46     */
47     function add(uint256 _a, uint256 _b) internal pure returns (uint256) {
48         uint256 c = _a + _b;
49         require(c >= _a);
50 
51         return c;
52     }
53 }
54 
55 /**
56  * @title ERC20 interface
57  * @dev see https://github.com/ethereum/EIPs/issues/20
58  */
59 contract ERC20 {
60     function totalSupply() public view returns (uint256);
61 
62     function balanceOf(address _who) public view returns (uint256);
63 
64     function allowance(address _owner, address _spender)
65         public view returns (uint256);
66 
67     function transfer(address _to, uint256 _value) public returns (bool);
68 
69     function approve(address _spender, uint256 _value)
70         public returns (bool);
71 
72     function transferFrom(address _from, address _to, uint256 _value)
73         public returns (bool);
74 
75     event Transfer(
76         address indexed from,
77         address indexed to,
78         uint256 value
79     );
80 
81     event Approval(
82         address indexed owner,
83         address indexed spender,
84         uint256 value
85     );
86 }
87 
88 /**
89  * @title TrueDeck TDP Token
90  * @dev ERC20 Token for TrueDeck Platform
91  */
92 contract TrueDeckToken is ERC20 {
93     using SafeMath for uint256;
94 
95     string public constant name = "TrueDeck";
96     string public constant symbol = "TDP";
97     uint8 public constant decimals = 18;
98 
99     mapping (address => uint256) private balances_;
100 
101     mapping (address => mapping (address => uint256)) private allowed_;
102 
103     uint256 private totalSupply_;
104 
105     /**
106     * @dev Initial supply of TDP tokens.
107     *      200M TDP Tokens
108     */
109     uint256 public INITIAL_SUPPLY = 200000000 * 10 ** uint256(decimals);
110 
111     constructor() public {
112         balances_[msg.sender] = INITIAL_SUPPLY;
113         totalSupply_ = INITIAL_SUPPLY;
114     }
115 
116     /**
117     * @dev total number of tokens in existence
118     */
119     function totalSupply() public view returns (uint256) {
120         return totalSupply_;
121     }
122 
123     /**
124     * @dev Transfer the specified amount of tokens to the specified address.
125     *      This function works the same with the previous one
126     *      but doesn't contain `_data` param.
127     *      Added due to backwards compatibility reasons.
128     * @param _to The address to transfer to.
129     * @param _value The amount to be transferred.
130     */
131     function transfer(address _to, uint256 _value) public returns (bool) {
132         require(_value <= balances_[msg.sender]);
133         require(_to != address(0));
134 
135         balances_[msg.sender] = balances_[msg.sender].sub(_value);
136         balances_[_to] = balances_[_to].add(_value);
137         emit Transfer(msg.sender, _to, _value);
138 
139         return true;
140     }
141 
142 
143     /**
144      * @dev Transfer tokens from one address to another
145      * @param _from address The address which you want to send tokens from
146      * @param _to address The address which you want to transfer to
147      * @param _value uint256 the amount of tokens to be transferred
148      */
149     function transferFrom(address _from, address _to, uint256 _value) public returns (bool) {
150         require(_value <= balances_[_from]);
151         require(_value <= allowed_[_from][msg.sender]);
152         require(_to != address(0));
153 
154         balances_[_from] = balances_[_from].sub(_value);
155         balances_[_to] = balances_[_to].add(_value);
156         allowed_[_from][msg.sender] = allowed_[_from][msg.sender].sub(_value);
157         emit Transfer(_from, _to, _value);
158 
159         return true;
160     }
161 
162     /**
163      * @dev Approve the passed address to spend the specified amount of tokens on behalf of msg.sender.
164      *
165      * Beware that changing an allowance with this method brings the risk that someone may use both the old
166      * and the new allowance by unfortunate transaction ordering. One possible solution to mitigate this
167      * race condition is to first reduce the spender's allowance to 0 and set the desired value afterwards:
168      * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
169      * @param _spender The address which will spend the funds.
170      * @param _value The amount of tokens to be spent.
171      */
172     function approve(address _spender, uint256 _value) public returns (bool) {
173         allowed_[msg.sender][_spender] = _value;
174         emit Approval(msg.sender, _spender, _value);
175         return true;
176     }
177 
178     /**
179      * @dev Function to check the amount of tokens that an owner allowed to a spender.
180      * @param _owner address The address which owns the funds.
181      * @param _spender address The address which will spend the funds.
182      * @return A uint256 specifying the amount of tokens still available for the spender.
183      */
184     function allowance(address _owner, address _spender) public view returns (uint256) {
185         return allowed_[_owner][_spender];
186     }
187 
188     /**
189      * @dev Increase the amount of tokens that an owner allowed to a spender.
190      *
191      * approve should be called when allowed_[_spender] == 0. To increment
192      * allowed value is better to use this function to avoid 2 calls (and wait until
193      * the first transaction is mined)
194      * From MonolithDAO Token.sol
195      * @param _spender The address which will spend the funds.
196      * @param _addedValue The amount of tokens to increase the allowance by.
197      */
198     function increaseApproval(address _spender, uint256 _addedValue) public returns (bool) {
199         allowed_[msg.sender][_spender] = (allowed_[msg.sender][_spender].add(_addedValue));
200         emit Approval(msg.sender, _spender, allowed_[msg.sender][_spender]);
201         return true;
202     }
203 
204     /**
205      * @dev Decrease the amount of tokens that an owner allowed to a spender.
206      *
207      * approve should be called when allowed_[_spender] == 0. To decrement
208      * allowed value is better to use this function to avoid 2 calls (and wait until
209      * the first transaction is mined)
210      * From MonolithDAO Token.sol
211      * @param _spender The address which will spend the funds.
212      * @param _subtractedValue The amount of tokens to decrease the allowance by.
213      */
214     function decreaseApproval(address _spender, uint256 _subtractedValue) public returns (bool) {
215         uint256 oldValue = allowed_[msg.sender][_spender];
216         if (_subtractedValue >= oldValue) {
217             allowed_[msg.sender][_spender] = 0;
218         } else {
219             allowed_[msg.sender][_spender] = oldValue.sub(_subtractedValue);
220         }
221         emit Approval(msg.sender, _spender, allowed_[msg.sender][_spender]);
222         return true;
223     }
224 
225     /**
226     * @dev Gets the balance of the specified address.
227     * @param _owner The address to query the the balance of.
228     * @return An uint256 representing the amount owned by the passed address.
229     */
230     function balanceOf(address _owner) public view returns (uint256) {
231         return balances_[_owner];
232     }
233 }