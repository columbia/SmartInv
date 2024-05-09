1 pragma solidity ^0.4.24;
2 
3 
4 /**
5  * @title ERC20 interface
6  * @dev see https://github.com/ethereum/EIPs/issues/20
7  */
8 contract ERC20 {
9 
10     function totalSupply() public view returns (uint256);
11 
12     function balanceOf(address _who) public view returns (uint256);
13 
14     function allowance(address _owner, address _spender) public view returns (uint256);
15 
16     function transfer(address _to, uint256 _value) public returns (bool);
17 
18     function approve(address _spender, uint256 _value) public returns (bool);
19 
20     function transferFrom(address _from, address _to, uint256 _value) public returns (bool);
21 
22     event Transfer (address indexed from, address indexed to, uint256 value);
23 
24     event Approval(address indexed owner, address indexed spender, uint256 value);
25     
26 }
27 
28 /**
29  * @title Standard ERC20 token
30  *
31  * @dev Implementation of the basic standard token.
32  * https://github.com/ethereum/EIPs/blob/master/EIPS/eip-20.md
33  * Based on code by FirstBlood: https://github.com/Firstbloodio/token/blob/master/smart_contract/FirstBloodToken.sol
34  */
35 contract StandardToken is ERC20 {
36     
37     using SafeMath for uint256;
38 
39     mapping (address => uint256) internal balances;
40 
41     mapping (address => mapping (address => uint256)) private allowed;
42 
43     uint256 internal totalSupply_;
44 
45     /**
46     * @dev Total tokens amount
47     */
48     function totalSupply() public view returns (uint256) {
49         return totalSupply_;
50     }
51 
52     /**
53     * @dev Gets the balance of the specified address.
54     * @param _owner The address to query the the balance of.
55     * @return An uint256 representing the amount owned by the passed address.
56     */
57     function balanceOf(address _owner) public view returns (uint256) {
58         return balances[_owner];
59     }
60 
61     /**
62     * @dev Function to check the amount of tokens that an owner allowed to a spender.
63     * @param _owner address The address which owns the funds.
64     * @param _spender address The address which will spend the funds.
65     * @return A uint256 specifying the amount of tokens still available for the spender.
66     */
67     function allowance(address _owner,address _spender) public view returns (uint256){
68         return allowed[_owner][_spender];
69     }
70 
71     /**
72     * @dev Transfer token for a specified address
73     * @param _to The address to transfer to.
74     * @param _value The amount to be transferred.
75     */
76     function transfer(address _to, uint256 _value) public returns (bool) {
77         require(_value <= balances[msg.sender]);
78         require(_to != address(0));
79 
80         balances[msg.sender] = balances[msg.sender].sub(_value);
81         balances[_to] = balances[_to].add(_value);
82         emit Transfer(msg.sender, _to, _value);
83         return true;
84     }
85 
86     /**
87     * @dev Approve the passed address to spend the specified amount of tokens on behalf of msg.sender.
88     * Beware that changing an allowance with this method brings the risk that someone may use both the old
89     * and the new allowance by unfortunate transaction ordering. One possible solution to mitigate this
90     * race condition is to first reduce the spender's allowance to 0 and set the desired value afterwards:
91     * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
92     * @param _spender The address which will spend the funds.
93     * @param _value The amount of tokens to be spent.
94     */
95     function approve(address _spender, uint256 _value) public returns (bool) {
96         allowed[msg.sender][_spender] = _value;
97         emit Approval(msg.sender, _spender, _value);
98         return true;
99     }
100 
101     /**
102     * @dev Transfer tokens from one address to another
103     * @param _from address The address which you want to send tokens from
104     * @param _to address The address which you want to transfer to
105     * @param _value uint256 the amount of tokens to be transferred
106     */
107     function transferFrom(address _from,address _to,uint256 _value)public returns (bool){
108         require(_value <= balances[_from]);
109         require(_value <= allowed[_from][msg.sender]);
110         require(_to != address(0));
111 
112         balances[_from] = balances[_from].sub(_value);
113         balances[_to] = balances[_to].add(_value);
114         allowed[_from][msg.sender] = allowed[_from][msg.sender].sub(_value);
115         emit Transfer(_from, _to, _value);
116         return true;
117     }
118 
119     /**
120     * @dev Increase the amount of tokens that an owner allowed to a spender.
121     * approve should be called when allowed[_spender] == 0. To increment
122     * allowed value is better to use this function to avoid 2 calls (and wait until
123     * the first transaction is mined)
124     * From MonolithDAO Token.sol
125     * @param _spender The address which will spend the funds.
126     * @param _addedValue The amount of tokens to increase the allowance by.
127     */
128     function increaseApproval(address _spender,uint256 _addedValue) public returns (bool){
129         allowed[msg.sender][_spender] = (allowed[msg.sender][_spender].add(_addedValue));
130         emit Approval(msg.sender, _spender, allowed[msg.sender][_spender]);
131         return true;
132     }
133 
134     /**
135     * @dev Decrease the amount of tokens that an owner allowed to a spender.
136     * approve should be called when allowed[_spender] == 0. To decrement
137     * allowed value is better to use this function to avoid 2 calls (and wait until
138     * the first transaction is mined)
139     * From MonolithDAO Token.sol
140     * @param _spender The address which will spend the funds.
141     * @param _subtractedValue The amount of tokens to decrease the allowance by.
142     */
143     function decreaseApproval(address _spender,uint256 _subtractedValue) public returns (bool){
144         uint256 oldValue = allowed[msg.sender][_spender];
145         if (_subtractedValue >= oldValue) {
146             allowed[msg.sender][_spender] = 0;
147         } else {
148             allowed[msg.sender][_spender] = oldValue.sub(_subtractedValue);
149         }
150         emit Approval(msg.sender, _spender, allowed[msg.sender][_spender]);
151         return true;
152     }
153 }
154 /**
155  * @title SafeMath
156  * @dev Math operations with safety checks that revert on error
157  */
158 library SafeMath {
159 
160     /**
161     * @dev Multiplies two numbers, reverts on overflow.
162     */
163     function mul(uint256 _a, uint256 _b) internal pure returns (uint256) {
164         // Gas optimization: this is cheaper than requiring 'a' not being zero, but the
165         // benefit is lost if 'b' is also tested.
166         // See: https://github.com/OpenZeppelin/openzeppelin-solidity/pull/522
167         if (_a == 0) {
168             return 0;
169         }
170 
171         uint256 c = _a * _b;
172         require(c / _a == _b);
173 
174         return c;
175     }
176 
177     /**
178     * @dev Integer division of two numbers truncating the quotient, reverts on division by zero.
179     */
180     function div(uint256 _a, uint256 _b) internal pure returns (uint256) {
181         require(_b > 0); // Solidity only automatically asserts when dividing by 0
182         uint256 c = _a / _b;
183         // assert(_a == _b * c + _a % _b); // There is no case in which this doesn't hold
184 
185         return c;
186     }
187 
188     /**
189     * @dev Subtracts two numbers, reverts on overflow (i.e. if subtrahend is greater than minuend).
190     */
191     function sub(uint256 _a, uint256 _b) internal pure returns (uint256) {
192         require(_b <= _a);
193         uint256 c = _a - _b;
194 
195         return c;
196     }
197 
198     /**
199     * @dev Adds two numbers, reverts on overflow.
200     */
201     function add(uint256 _a, uint256 _b) internal pure returns (uint256) {
202         uint256 c = _a + _b;
203         require(c >= _a);
204 
205         return c;
206     }
207 
208     /**
209     * @dev Divides two numbers and returns the remainder (unsigned integer modulo),
210     * reverts when dividing by zero.
211     */
212     function mod(uint256 a, uint256 b) internal pure returns (uint256) {
213         require(b != 0);
214         return a % b;
215     }
216 }
217 /**
218  * @title IMPCoin implementation based on ERC20 standard token
219  */
220 contract IMPCoin is StandardToken {
221     
222     using SafeMath for uint;
223     
224     string public name = "IMPCoin";
225     string public symbol = "IMP";
226     uint8 public decimals = 6;
227     
228     address owner;
229     
230     /**
231      *  @dev Contract initiallization
232      *  @param _initialSupply total tokens amount
233      */
234     constructor(uint _initialSupply) public {
235         totalSupply_ = _initialSupply * 10 ** uint(decimals);
236         owner = msg.sender;
237         balances[owner] = balances[owner].add(totalSupply_);
238     }
239     
240 }