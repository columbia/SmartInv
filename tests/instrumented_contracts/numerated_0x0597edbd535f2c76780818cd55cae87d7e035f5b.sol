1 pragma solidity ^0.5.7;
2 
3 
4 /**
5  * @title ERC20Basic
6  * @dev Simpler version of ERC20 interface
7  * @dev see https://github.com/ethereum/EIPs/issues/179
8  */
9 contract ERC20Basic {
10     function totalSupply() public view returns (uint256);
11     function balanceOf(address who) public view returns (uint256);
12     function transfer(address to, uint256 value) public returns (bool);
13     event Transfer(address indexed from, address indexed to, uint256 value);
14 }
15 
16 /**
17  * @title SafeMath
18  * @dev Math operations with safety checks that throw on error
19  */
20 library SafeMath {
21 
22     /**
23     * @dev Multiplies two numbers, throws on overflow.
24     */
25     function mul(uint256 a, uint256 b) internal pure returns (uint256) {
26         if (a == 0) {
27             return 0;
28         }
29         uint256 c = a * b;
30         assert(c / a == b);
31         return c;
32     }
33 
34     /**
35     * @dev Integer division of two numbers, truncating the quotient.
36     */
37     function div(uint256 a, uint256 b) internal pure returns (uint256) {
38         // assert(b > 0); // Solidity automatically throws when dividing by 0
39         uint256 c = a / b;
40         // assert(a == b * c + a % b); // There is no case in which this doesn't hold
41         return c;
42     }
43 
44     /**
45     * @dev Substracts two numbers, throws on overflow (i.e. if subtrahend is greater than minuend).
46     */
47     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
48         assert(b <= a);
49         return a - b;
50     }
51 
52     /**
53     * @dev Adds two numbers, throws on overflow.
54     */
55     function add(uint256 a, uint256 b) internal pure returns (uint256) {
56         uint256 c = a + b;
57         assert(c >= a);
58         return c;
59     }
60 }
61 
62 
63 /**
64  * @title ERC20 interface
65  * @dev see https://github.com/ethereum/EIPs/issues/20
66  */
67 contract ERC20 is ERC20Basic {
68     function allowance(address owner, address spender) public view returns (uint256);
69     function transferFrom(address from, address to, uint256 value) public returns (bool);
70     function approve(address spender, uint256 value) public returns (bool);
71     event Approval(address indexed owner, address indexed spender, uint256 value);
72 }
73 
74 
75 /**
76  * @title Basic token
77  * @dev Basic version of StandardToken, with no allowances.
78  */
79 contract BasicToken is ERC20Basic {
80     using SafeMath for uint256;
81 
82     mapping(address => uint256) balances;
83 
84     uint256 totalSupply_;
85 
86     /**
87     * @dev total number of tokens in existence
88     */
89     function totalSupply() public view returns (uint256) {
90         return totalSupply_;
91     }
92 
93     /**
94     * @dev transfer token for a specified address
95     * @param _to The address to transfer to.
96     * @param _value The amount to be transferred.
97     */
98     function transfer(address _to, uint256 _value) public returns (bool) {
99         require(_to != address(0));
100         require(_value <= balances[msg.sender]);
101 
102         // SafeMath.sub will throw if there is not enough balance.
103         balances[msg.sender] = balances[msg.sender].sub(_value);
104         balances[_to] = balances[_to].add(_value);
105         emit Transfer(msg.sender, _to, _value);
106         return true;
107     }
108 
109     /**
110     * @dev Gets the balance of the specified address.
111     * @param _owner The address to query the the balance of.
112     * @return An uint256 representing the amount owned by the passed address.
113     */
114     function balanceOf(address _owner) public view returns (uint256 balance) {
115         return balances[_owner];
116     }
117 
118 }
119 
120 
121 /**
122  * @title Standard ERC20 token
123  *
124  * @dev Implementation of the basic standard token.
125  * @dev https://github.com/ethereum/EIPs/issues/20
126  * @dev Based on code by FirstBlood: https://github.com/Firstbloodio/token/blob/master/smart_contract/FirstBloodToken.sol
127  */
128 contract StandardToken is ERC20, BasicToken {
129 
130     mapping (address => mapping (address => uint256)) internal allowed;
131 
132 
133     /**
134      * @dev Transfer tokens from one address to another
135      * @param _from address The address which you want to send tokens from
136      * @param _to address The address which you want to transfer to
137      * @param _value uint256 the amount of tokens to be transferred
138      */
139     function transferFrom(address _from, address _to, uint256 _value) public returns (bool) {
140         require(_to != address(0));
141         require(_value <= balances[_from]);
142         require(_value <= allowed[_from][msg.sender]);
143 
144         balances[_from] = balances[_from].sub(_value);
145         balances[_to] = balances[_to].add(_value);
146         allowed[_from][msg.sender] = allowed[_from][msg.sender].sub(_value);
147         emit Transfer(_from, _to, _value);
148         return true;
149     }
150 
151     /**
152      * @dev Approve the passed address to spend the specified amount of tokens on behalf of msg.sender.
153      *
154      * Beware that changing an allowance with this method brings the risk that someone may use both the old
155      * and the new allowance by unfortunate transaction ordering. One possible solution to mitigate this
156      * race condition is to first reduce the spender's allowance to 0 and set the desired value afterwards:
157      * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
158      * @param _spender The address which will spend the funds.
159      * @param _value The amount of tokens to be spent.
160      */
161     function approve(address _spender, uint256 _value) public returns (bool) {
162         require((_value == 0) || allowed[msg.sender][_spender]== 0);
163         allowed[msg.sender][_spender] = _value;
164         emit Approval(msg.sender, _spender, _value);
165         return true;
166     }
167 
168     /**
169      * @dev Function to check the amount of tokens that an owner allowed to a spender.
170      * @param _owner address The address which owns the funds.
171      * @param _spender address The address which will spend the funds.
172      * @return A uint256 specifying the amount of tokens still available for the spender.
173      */
174     function allowance(address _owner, address _spender) public view returns (uint256) {
175         return allowed[_owner][_spender];
176     }
177     
178   /**
179    * @dev Increase the amount of tokens that an owner allowed to a spender.
180    *
181    * approve should be called when allowed[_spender] == 0. To increment
182    * allowed value is better to use this function to avoid 2 calls (and wait until
183    * the first transaction is mined)
184    * From MonolithDAO Token.sol
185    * @param _spender The address which will spend the funds.
186    * @param _addedValue The amount of tokens to increase the allowance by.
187    */
188   function increaseApproval(address _spender, uint _addedValue) public returns (bool) {
189     allowed[msg.sender][_spender] = allowed[msg.sender][_spender].add(_addedValue);
190     emit Approval(msg.sender, _spender, allowed[msg.sender][_spender]);
191     return true;
192   }
193 
194   /**
195    * @dev Decrease the amount of tokens that an owner allowed to a spender.
196    *
197    * approve should be called when allowed[_spender] == 0. To decrement
198    * allowed value is better to use this function to avoid 2 calls (and wait until
199    * the first transaction is mined)
200    * From MonolithDAO Token.sol
201    * @param _spender The address which will spend the funds.
202    * @param _subtractedValue The amount of tokens to decrease the allowance by.
203    */
204   function decreaseApproval(address _spender, uint _subtractedValue) public returns (bool) {
205     uint oldValue = allowed[msg.sender][_spender];
206     if (_subtractedValue > oldValue) {
207       allowed[msg.sender][_spender] = 0;
208     } else {
209       allowed[msg.sender][_spender] = oldValue.sub(_subtractedValue);
210     }
211     emit Approval(msg.sender, _spender, allowed[msg.sender][_spender]);
212     return true;
213   }
214 }
215 
216 
217 /**
218  * @title SimpleToken
219  * @dev All tokens are pre-assigned to the creator.
220  * Note they can later distribute these tokens as they wish using `transfer` and other
221  * `StandardToken` functions.
222  */
223 contract MOONToken is StandardToken {
224 
225     string public constant name = "Moon"; 
226     string public constant symbol = "MOON";
227     uint8 public constant decimals = 18; 
228 
229     uint256 public constant INITIAL_SUPPLY = 1e27;  // 1e9 * 1e18, that is 1000,000,000 ACTM.
230 
231     /**
232     * @dev Constructor that gives msg.sender all of existing tokens.
233     */
234     constructor() public {
235         totalSupply_ = INITIAL_SUPPLY;
236         balances[msg.sender] = INITIAL_SUPPLY;
237         emit Transfer(address(0), msg.sender, totalSupply_);
238     }
239 }