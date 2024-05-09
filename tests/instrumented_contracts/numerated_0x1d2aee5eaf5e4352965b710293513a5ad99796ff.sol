1 pragma solidity ^0.4.24;
2 
3 /**
4  * @title ERC20 interface
5  * @dev see https://github.com/ethereum/EIPs/issues/20
6  */
7 contract ERC20 {
8 
9     function totalSupply() public view returns (uint256);
10 
11     function balanceOf(address _who) public view returns (uint256);
12 
13     function allowance(address _owner, address _spender) public view returns (uint256);
14 
15     function transfer(address _to, uint256 _value) public returns (bool);
16 
17     function approve(address _spender, uint256 _value) public returns (bool);
18 
19     function transferFrom(address _from, address _to, uint256 _value) public returns (bool);
20 
21     event Transfer (address indexed from, address indexed to, uint256 value);
22 
23     event Approval(address indexed owner, address indexed spender, uint256 value);
24     
25 }
26 
27 
28 /**
29  * @title SafeMath
30  * @dev Math operations with safety checks that revert on error
31  */
32 library SafeMath {
33 
34     /**
35     * @dev Multiplies two numbers, reverts on overflow.
36     */
37     function mul(uint256 _a, uint256 _b) internal pure returns (uint256) {
38         // Gas optimization: this is cheaper than requiring 'a' not being zero, but the
39         // benefit is lost if 'b' is also tested.
40         // See: https://github.com/OpenZeppelin/openzeppelin-solidity/pull/522
41         if (_a == 0) {
42             return 0;
43         }
44 
45         uint256 c = _a * _b;
46         require(c / _a == _b);
47 
48         return c;
49     }
50 
51     /**
52     * @dev Integer division of two numbers truncating the quotient, reverts on division by zero.
53     */
54     function div(uint256 _a, uint256 _b) internal pure returns (uint256) {
55         require(_b > 0); // Solidity only automatically asserts when dividing by 0
56         uint256 c = _a / _b;
57         // assert(_a == _b * c + _a % _b); // There is no case in which this doesn't hold
58 
59         return c;
60     }
61 
62     /**
63     * @dev Subtracts two numbers, reverts on overflow (i.e. if subtrahend is greater than minuend).
64     */
65     function sub(uint256 _a, uint256 _b) internal pure returns (uint256) {
66         require(_b <= _a);
67         uint256 c = _a - _b;
68 
69         return c;
70     }
71 
72     /**
73     * @dev Adds two numbers, reverts on overflow.
74     */
75     function add(uint256 _a, uint256 _b) internal pure returns (uint256) {
76         uint256 c = _a + _b;
77         require(c >= _a);
78 
79         return c;
80     }
81 
82     /**
83     * @dev Divides two numbers and returns the remainder (unsigned integer modulo),
84     * reverts when dividing by zero.
85     */
86     function mod(uint256 a, uint256 b) internal pure returns (uint256) {
87         require(b != 0);
88         return a % b;
89     }
90 }
91 
92 
93 /**
94  * @title Standard ERC20 token
95  *
96  * @dev Implementation of the basic standard token.
97  * https://github.com/ethereum/EIPs/blob/master/EIPS/eip-20.md
98  * Based on code by FirstBlood: https://github.com/Firstbloodio/token/blob/master/smart_contract/FirstBloodToken.sol
99  */
100 contract StandardToken is ERC20 {
101     
102     using SafeMath for uint256;
103 
104     mapping (address => uint256) internal balances;
105 
106     mapping (address => mapping (address => uint256)) private allowed;
107 
108     uint256 internal totalSupply_;
109 
110     /**
111     * @dev Total tokens amount
112     */
113     function totalSupply() public view returns (uint256) {
114         return totalSupply_;
115     }
116 
117     /**
118     * @dev Gets the balance of the specified address.
119     * @param _owner The address to query the the balance of.
120     * @return An uint256 representing the amount owned by the passed address.
121     */
122     function balanceOf(address _owner) public view returns (uint256) {
123         return balances[_owner];
124     }
125 
126     /**
127     * @dev Function to check the amount of tokens that an owner allowed to a spender.
128     * @param _owner address The address which owns the funds.
129     * @param _spender address The address which will spend the funds.
130     * @return A uint256 specifying the amount of tokens still available for the spender.
131     */
132     function allowance(address _owner,address _spender) public view returns (uint256){
133         return allowed[_owner][_spender];
134     }
135 
136     /**
137     * @dev Transfer token for a specified address
138     * @param _to The address to transfer to.
139     * @param _value The amount to be transferred.
140     */
141     function transfer(address _to, uint256 _value) public returns (bool) {
142         require(_value <= balances[msg.sender]);
143         require(_to != address(0));
144 
145         balances[msg.sender] = balances[msg.sender].sub(_value);
146         balances[_to] = balances[_to].add(_value);
147         emit Transfer(msg.sender, _to, _value);
148         return true;
149     }
150 
151     /**
152     * @dev Approve the passed address to spend the specified amount of tokens on behalf of msg.sender.
153     * Beware that changing an allowance with this method brings the risk that someone may use both the old
154     * and the new allowance by unfortunate transaction ordering. One possible solution to mitigate this
155     * race condition is to first reduce the spender's allowance to 0 and set the desired value afterwards:
156     * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
157     * @param _spender The address which will spend the funds.
158     * @param _value The amount of tokens to be spent.
159     */
160     function approve(address _spender, uint256 _value) public returns (bool) {
161         allowed[msg.sender][_spender] = _value;
162         emit Approval(msg.sender, _spender, _value);
163         return true;
164     }
165 
166     /**
167     * @dev Transfer tokens from one address to another
168     * @param _from address The address which you want to send tokens from
169     * @param _to address The address which you want to transfer to
170     * @param _value uint256 the amount of tokens to be transferred
171     */
172     function transferFrom(address _from,address _to,uint256 _value)public returns (bool){
173         require(_value <= balances[_from]);
174         require(_value <= allowed[_from][msg.sender]);
175         require(_to != address(0));
176 
177         balances[_from] = balances[_from].sub(_value);
178         balances[_to] = balances[_to].add(_value);
179         allowed[_from][msg.sender] = allowed[_from][msg.sender].sub(_value);
180         emit Transfer(_from, _to, _value);
181         return true;
182     }
183 
184     /**
185     * @dev Increase the amount of tokens that an owner allowed to a spender.
186     * approve should be called when allowed[_spender] == 0. To increment
187     * allowed value is better to use this function to avoid 2 calls (and wait until
188     * the first transaction is mined)
189     * From MonolithDAO Token.sol
190     * @param _spender The address which will spend the funds.
191     * @param _addedValue The amount of tokens to increase the allowance by.
192     */
193     function increaseApproval(address _spender,uint256 _addedValue) public returns (bool){
194         allowed[msg.sender][_spender] = (allowed[msg.sender][_spender].add(_addedValue));
195         emit Approval(msg.sender, _spender, allowed[msg.sender][_spender]);
196         return true;
197     }
198 
199     /**
200     * @dev Decrease the amount of tokens that an owner allowed to a spender.
201     * approve should be called when allowed[_spender] == 0. To decrement
202     * allowed value is better to use this function to avoid 2 calls (and wait until
203     * the first transaction is mined)
204     * From MonolithDAO Token.sol
205     * @param _spender The address which will spend the funds.
206     * @param _subtractedValue The amount of tokens to decrease the allowance by.
207     */
208     function decreaseApproval(address _spender,uint256 _subtractedValue) public returns (bool){
209         uint256 oldValue = allowed[msg.sender][_spender];
210         if (_subtractedValue >= oldValue) {
211             allowed[msg.sender][_spender] = 0;
212         } else {
213             allowed[msg.sender][_spender] = oldValue.sub(_subtractedValue);
214         }
215         emit Approval(msg.sender, _spender, allowed[msg.sender][_spender]);
216         return true;
217     }
218 }
219 
220 /**
221  * @title IMPCoin implementation based on ERC20 standard token
222  */
223 contract IMPERIVMCoin is StandardToken {
224     
225     using SafeMath for uint;
226     
227     string public name = "IMPERIVMCoin";
228     string public symbol = "IMPCN";
229     uint8 public decimals = 6;
230     
231     address owner;
232     
233     /**
234      *  @dev Contract initiallization
235      *  @param _initialSupply total tokens amount
236      */
237     constructor(uint _initialSupply) public {
238         totalSupply_ = _initialSupply * 10 ** uint(decimals);
239         owner = msg.sender;
240         balances[owner] = balances[owner].add(totalSupply_);
241     }
242     
243 }