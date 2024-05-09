1 /**
2  *Submitted for verification at Etherscan.io on 2020-07-28
3 */
4 
5 pragma solidity ^0.5.7;
6 /**
7  * @title ERC20Basic
8  * @dev Simpler version of ERC20 interface
9  * @dev see https://github.com/ethereum/EIPs/issues/179
10  */
11 contract ERC20Basic {
12     function totalSupply() public view returns (uint256);
13 
14     function balanceOf(address who) public view returns (uint256);
15 
16     function transfer(address to, uint256 value) public returns (bool);
17 
18     event Transfer(address indexed from, address indexed to, uint256 value);
19 }
20 /**
21  * @title ERC20 interface
22  * @dev see https://github.com/ethereum/EIPs/issues/20
23  */
24 contract ERC20 is ERC20Basic {
25     function allowance(address owner, address spender) public view returns (uint256);
26 
27     function transferFrom(address from, address to, uint256 value) public returns (bool);
28 
29     function approve(address spender, uint256 value) public returns (bool);
30 
31     event Approval(address indexed owner, address indexed spender, uint256 value);
32 }
33 
34 /**
35  * @title SafeMath
36  * @dev Math operations with safety checks that throw on error
37  */
38 library SafeMath {
39 
40     /**
41     * @dev Multiplies two numbers, throws on overflow.
42     */
43     function mul(uint256 a, uint256 b) internal pure returns (uint256) {
44         if (a == 0) {
45             return 0;
46         }
47         uint256 c = a * b;
48         assert(c / a == b);
49         return c;
50     }
51 
52     /**
53     * @dev Integer division of two numbers, truncating the quotient.
54     */
55     function div(uint256 a, uint256 b) internal pure returns (uint256) {
56         // assert(b > 0); // Solidity automatically throws when dividing by 0
57         uint256 c = a / b;
58         // assert(a == b * c + a % b); // There is no case in which this doesn't hold
59         return c;
60     }
61 
62     /**
63     * @dev Subtracts two numbers, throws on overflow (i.e. if subtrahend is greater than minuend).
64     */
65     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
66         assert(b <= a);
67         return a - b;
68     }
69 
70     /**
71     * @dev Adds two numbers, throws on overflow.
72     */
73     function add(uint256 a, uint256 b) internal pure returns (uint256) {
74         uint256 c = a + b;
75         assert(c >= a);
76         return c;
77     }
78 }
79 
80 /**
81  * @title Basic token
82  * @dev Basic version of StandardToken, with no allowances.
83  */
84 contract BasicToken is ERC20Basic {
85 
86     using SafeMath for uint256;
87 
88 
89     mapping(address => uint256) balances;
90 
91 
92     uint256 totalSupply_;
93 
94     /**
95     * @dev total number of tokens in existence
96     */
97     function totalSupply() public view returns (uint256) {
98         return totalSupply_;
99     }
100 
101     /**
102     * @dev transfer token for a specified address
103     * @param _to The address to transfer to.
104     * @param _value The amount to be transferred.
105     */
106     function transfer(address _to, uint256 _value) public returns (bool) {
107         require(_to != address(0));
108         require(_value <= balances[msg.sender]);
109 
110         // SafeMath.sub will throw if there is not enough balance.
111         balances[msg.sender] = balances[msg.sender].sub(_value);
112         balances[_to] = balances[_to].add(_value);
113         emit Transfer(msg.sender, _to, _value);
114         return true;
115     }
116 
117     /**
118     * @dev Gets the balance of the specified address.
119     * @param _owner The address to query the the balance of.
120     * @return An uint256 representing the amount owned by the passed address.
121     */
122     function balanceOf(address _owner) public view returns (uint256 balance) {
123         return balances[_owner];
124     }
125 
126 
127 }
128 /**
129  * @title Standard ERC20 token
130  *
131  * @dev Implementation of the basic standard token.
132  * @dev https://github.com/ethereum/EIPs/issues/20
133  * @dev Based on code by FirstBlood: https://github.com/Firstbloodio/token/blob/master/smart_contract/FirstBloodToken.sol
134  */
135 contract StandardToken is ERC20, BasicToken {
136 
137     mapping(address => mapping(address => uint256)) internal allowed;
138 
139 
140 
141     /**
142      * @dev Transfer tokens from one address to another
143      * @param _from address The address which you want to send tokens from
144      * @param _to address The address which you want to transfer to
145      * @param _value uint256 the amount of tokens to be transferred
146      */
147     function transferFrom(address _from, address _to, uint256 _value) public returns (bool) {
148         require(_to != address(0));
149         require(_value <= balances[_from]);
150         require(_value <= allowed[_from][msg.sender]);
151 
152         balances[_from] = balances[_from].sub(_value);
153         balances[_to] = balances[_to].add(_value);
154         allowed[_from][msg.sender] = allowed[_from][msg.sender].sub(_value);
155         emit Transfer(_from, _to, _value);
156         return true;
157     }
158 
159     /**
160      * @dev Approve the passed address to spend the specified amount of tokens on behalf of msg.sender.
161      *
162      * Beware that changing an allowance with this method brings the risk that someone may use both the old
163      * and the new allowance by unfortunate transaction ordering. One possible solution to mitigate this
164      * race condition is to first reduce the spender's allowance to 0 and set the desired value afterwards:
165      * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
166      * @param _spender The address which will spend the funds.
167      * @param _value The amount of tokens to be spent.
168      */
169     function approve(address _spender, uint256 _value) public returns (bool) {
170         allowed[msg.sender][_spender] = _value;
171         emit  Approval(msg.sender, _spender, _value);
172         return true;
173     }
174 
175     /**
176      * @dev Function to check the amount of tokens that an owner allowed to a spender.
177      * @param _owner address The address which owns the funds.
178      * @param _spender address The address which will spend the funds.
179      * @return A uint256 specifying the amount of tokens still available for the spender.
180      */
181     function allowance(address _owner, address _spender) public view returns (uint256) {
182         return allowed[_owner][_spender];
183     }
184 
185     /**
186      * @dev Increase the amount of tokens that an owner allowed to a spender.
187      *
188      * approve should be called when allowed[_spender] == 0. To increment
189      * allowed value is better to use this function to avoid 2 calls (and wait until
190      * the first transaction is mined)
191      * From MonolithDAO Token.sol
192      * @param _spender The address which will spend the funds.
193      * @param _addedValue The amount of tokens to increase the allowance by.
194      */
195     function increaseApproval(address _spender, uint _addedValue) public returns (bool) {
196         allowed[msg.sender][_spender] = allowed[msg.sender][_spender].add(_addedValue);
197         emit  Approval(msg.sender, _spender, allowed[msg.sender][_spender]);
198         return true;
199     }
200 
201     /**
202      * @dev Decrease the amount of tokens that an owner allowed to a spender.
203      *
204      * approve should be called when allowed[_spender] == 0. To decrement
205      * allowed value is better to use this function to avoid 2 calls (and wait until
206      * the first transaction is mined)
207      * From MonolithDAO Token.sol
208      * @param _spender The address which will spend the funds.
209      * @param _subtractedValue The amount of tokens to decrease the allowance by.
210      */
211     function decreaseApproval(address _spender, uint _subtractedValue) public returns (bool) {
212         uint oldValue = allowed[msg.sender][_spender];
213         if (_subtractedValue > oldValue) {
214             allowed[msg.sender][_spender] = 0;
215         } else {
216             allowed[msg.sender][_spender] = oldValue.sub(_subtractedValue);
217         }
218         emit Approval(msg.sender, _spender, allowed[msg.sender][_spender]);
219         return true;
220     }
221 
222 }
223 
224 contract Hqg is StandardToken {
225 
226     string public name = "环球股";
227 
228     string public symbol = "HQG";
229 
230     uint8 public decimals = 6;
231 
232     uint public INITIAL_SUPPLY = 10000000000e6;
233 
234     constructor() public {
235         totalSupply_ = INITIAL_SUPPLY;
236         balances[msg.sender] = INITIAL_SUPPLY;
237 
238     }
239 
240 }