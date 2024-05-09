1 pragma solidity ^0.4.18;
2 /**
3 * @title SafeMath
4 * @dev Math operations with safety checks that throw on error
5 */
6 library SafeMath {
7     /**
8     * @dev Multiplies two numbers, throws on overflow.
9     */
10     function mul(uint256 a, uint256 b) internal pure returns (uint256) {
11         if (a == 0) {
12             return 0;
13         }
14         uint256 c = a * b;
15         assert(c / a == b);
16         return c;
17     }
18     /**
19     * @dev Integer division of two numbers, truncating the quotient.
20     */
21     function div(uint256 a, uint256 b) internal pure returns (uint256) {
22         // assert(b > 0); // Solidity automatically throws when dividing by 0
23         uint256 c = a / b;
24         // assert(a == b * c + a % b); // There is no case in which this doesn't hold
25         return c;
26     }
27     /**
28     * @dev Substracts two numbers, throws on overflow (i.e. if subtrahend is greater than minuend).
29     */
30     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
31         assert(b <= a);
32         return a - b;
33     }
34     /**
35     * @dev Adds two numbers, throws on overflow.
36     */
37     function add(uint256 a, uint256 b) internal pure returns (uint256) {
38         uint256 c = a + b;
39         assert(c >= a);
40         return c;
41     }
42 }
43 /**
44 * @title ERC20Basic
45 * @dev Simpler version of ERC20 interface
46 * @dev see https://github.com/ethereum/EIPs/issues/179
47 */
48 contract ERC20Basic {
49     function totalSupply() public view returns (uint256);
50 
51     function balanceOf(address who) public view returns (uint256);
52 
53     function transfer(address to, uint256 value) public returns (bool);
54 
55     event Transfer(address indexed from, address indexed to, uint256 value);
56 }
57 /**
58 * @title ERC20 interface
59 * @dev see https://github.com/ethereum/EIPs/issues/20
60 */
61 contract ERC20 is ERC20Basic {
62     function allowance(address owner, address spender) public view returns (uint256);
63 
64     function transferFrom(address from, address to, uint256 value) public returns (bool);
65 
66     function approve(address spender, uint256 value) public returns (bool);
67 
68     event Approval(address indexed owner, address indexed spender, uint256 value);
69 }
70 /**
71 * @title Basic token
72 * @dev Basic version of StandardToken, with no allowances.
73 */
74 contract BasicToken is ERC20Basic {
75     using SafeMath for uint256;
76     mapping(address => uint256) balances;
77     uint256 totalSupply_;
78     /**
79     * @dev total number of tokens in existence
80     */
81     function totalSupply() public view returns (uint256) {
82         return totalSupply_;
83     }
84     /**
85     * @dev transfer token for a specified address
86     * @param _to The address to transfer to.
87     * @param _value The amount to be transferred.
88     */
89     function transfer(address _to, uint256 _value) public returns (bool) {
90         require(_to != address(0));
91         require(_value <= balances[msg.sender]);
92         // SafeMath.sub will throw if there is not enough balance.
93         balances[msg.sender] = balances[msg.sender].sub(_value);
94         balances[_to] = balances[_to].add(_value);
95         Transfer(msg.sender, _to, _value);
96         return true;
97     }
98     /**
99     * @dev Gets the balance of the specified address.
100     * @param _owner The address to query the the balance of.
101     * @return An uint256 representing the amount owned by the passed address.
102     */
103     function balanceOf(address _owner) public view returns (uint256 balance) {
104         return balances[_owner];
105     }
106 }
107 /**
108 * @title Ownable
109 * @dev The Ownable contract has an owner address, and provides basic authorization control
110 * functions, this simplifies the implementation of "user permissions".
111 */
112 contract Ownable {
113     address public owner;
114 
115     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
116     /**
117     * @dev The Ownable constructor sets the original `owner` of the contract to the sender
118     * account.
119     */
120     function Ownable() public {
121         owner = msg.sender;
122     }
123     /**
124     * @dev Throws if called by any account other than the owner.
125     */
126     modifier onlyOwner() {
127         require(msg.sender == owner);
128         _;
129     }
130     /**
131     * @dev Allows the current owner to transfer control of the contract to a newOwner.
132     * @param newOwner The address to transfer ownership to.
133     */
134     function transferOwnership(address newOwner) public onlyOwner {
135         require(newOwner != address(0));
136         OwnershipTransferred(owner, newOwner);
137         owner = newOwner;
138     }
139 }
140 /**
141 * @title Standard ERC20 token
142 *
143 * @dev Implementation of the basic standard token.
144 * @dev https://github.com/ethereum/EIPs/issues/20
145 * @dev Based on code by FirstBlood: https://github.com/Firstbloodio/token/blob/master/smart_contract/FirstBloodToken.sol
146 */
147 contract StandardToken is ERC20, BasicToken {
148     mapping(address => mapping(address => uint256)) internal allowed;
149     /**
150     * @dev Transfer tokens from one address to another
151     * @param _from address The address which you want to send tokens from
152     * @param _to address The address which you want to transfer to
153     * @param _value uint256 the amount of tokens to be transferred
154     */
155     function transferFrom(address _from, address _to, uint256 _value) public returns (bool) {
156         require(_to != address(0));
157         require(_value <= balances[_from]);
158         require(_value <= allowed[_from][msg.sender]);
159         balances[_from] = balances[_from].sub(_value);
160         balances[_to] = balances[_to].add(_value);
161         allowed[_from][msg.sender] = allowed[_from][msg.sender].sub(_value);
162         Transfer(_from, _to, _value);
163         return true;
164     }
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
177         Approval(msg.sender, _spender, _value);
178         return true;
179     }
180     /**
181     * @dev Function to check the amount of tokens that an owner allowed to a spender.
182     * @param _owner address The address which owns the funds.
183     * @param _spender address The address which will spend the funds.
184     * @return A uint256 specifying the amount of tokens still available for the spender.
185     */
186     function allowance(address _owner, address _spender) public view returns (uint256) {
187         return allowed[_owner][_spender];
188     }
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
201         Approval(msg.sender, _spender, allowed[msg.sender][_spender]);
202         return true;
203     }
204     /**
205     * @dev Decrease the amount of tokens that an owner allowed to a spender.
206     *
207     * approve should be called when allowed[_spender] == 0. To decrement
208     * allowed value is better to use this function to avoid 2 calls (and wait until
209     * the first transaction is mined)
210     * From MonolithDAO Token.sol
211     * @param _spender The address which will spend the funds.
212     * @param _subtractedValue The amount of tokens to decrease the allowance by.
213     */
214     function decreaseApproval(address _spender, uint _subtractedValue) public returns (bool) {
215         uint oldValue = allowed[msg.sender][_spender];
216         if (_subtractedValue > oldValue) {
217             allowed[msg.sender][_spender] = 0;
218         } else {
219             allowed[msg.sender][_spender] = oldValue.sub(_subtractedValue);
220         }
221         Approval(msg.sender, _spender, allowed[msg.sender][_spender]);
222         return true;
223     }
224 }
225 
226 contract BonumPromoToken is StandardToken, Ownable {
227     string public name = "Bonum Promo Token";
228     string public symbol = "Bonum Promo";
229     uint public decimals = 0;
230     uint public constant INITIAL_SUPPLY = 777 * 10 ** 9;
231 
232     function BonumPromoToken(){
233         totalSupply_ = INITIAL_SUPPLY;
234         balances[msg.sender] = INITIAL_SUPPLY;
235     }
236 
237     function transferTo(address[] recievers) external onlyOwner {
238         for (uint i = 0; i < recievers.length; i ++) {
239             transfer(recievers[i], 777);
240         }
241     }
242 }