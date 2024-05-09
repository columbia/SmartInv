1 pragma solidity ^0.4.18;
2 /*
3 Nvc Fund Coin is an ERC-20 Token Standard Compliant
4 */
5 
6 /**
7  * @title SafeMath
8  * @dev Math operations with safety checks that throw on error
9  */
10 library SafeMath {
11 
12     /**
13     * @dev Multiplies two numbers, throws on overflow.
14     */
15     function mul(uint256 a, uint256 b) internal pure returns (uint256) {
16         if (a == 0) {
17             return 0;
18         }
19         uint256 c = a * b;
20         assert(c / a == b);
21         return c;
22     }
23 
24     /**
25     * @dev Integer division of two numbers, truncating the quotient.
26     */
27     function div(uint256 a, uint256 b) internal pure returns (uint256) {
28         // assert(b > 0); // Solidity automatically throws when dividing by 0
29         // uint256 c = a / b;
30         // assert(a == b * c + a % b); // There is no case in which this doesn't hold
31         return a / b;
32     }
33 
34     /**
35     * @dev Subtracts two numbers, throws on overflow (i.e. if subtrahend is greater than minuend).
36     */
37     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
38         assert(b <= a);
39         return a - b;
40     }
41 
42     /**
43     * @dev Adds two numbers, throws on overflow.
44     */
45     function add(uint256 a, uint256 b) internal pure returns (uint256) {
46         uint256 c = a + b;
47         assert(c >= a);
48         return c;
49     }
50 }
51 
52 /**
53  * @title Ownable
54  * @dev The Ownable contract has an owner address, and provides basic authorization control
55  * functions, this simplifies the implementation of "user permissions".
56  */
57 contract Ownable {
58     address public owner;
59 
60     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
61 
62 
63     /**
64      * @dev The Ownable constructor sets the original `owner` of the contract to the sender
65      * account.
66      */
67     function Ownable() public {
68         owner = msg.sender;
69     }
70 
71     /**
72      * @dev Throws if called by any account other than the owner.
73      */
74     modifier onlyOwner() {
75         require(msg.sender == owner);
76         _;
77     }
78 
79     /**
80      * @dev Allows the current owner to transfer control of the contract to a newOwner.
81      * @param newOwner The address to transfer ownership to.
82      */
83     function transferOwnership(address newOwner) public onlyOwner {
84         require(newOwner != address(0));
85         emit OwnershipTransferred(owner, newOwner);
86         owner = newOwner;
87     }
88 
89 }
90 
91 /**
92  * @title ERC20Basic
93  * @dev Simpler version of ERC20 interface
94  */
95 contract ERC20Basic {
96     function totalSupply() public view returns (uint256);
97     function balanceOf(address who) public view returns (uint256);
98     function transfer(address to, uint256 value) public returns (bool);
99     event Transfer(address indexed from, address indexed to, uint256 value);
100 }
101 
102 
103 /**
104  * @title ERC20 interface
105  */
106 contract ERC20 is ERC20Basic {
107     function allowance(address owner, address spender) public view returns (uint256);
108     function transferFrom(address from, address to, uint256 value) public returns (bool);
109     function approve(address spender, uint256 value) public returns (bool);
110     event Approval(address indexed owner, address indexed spender, uint256 value);
111 }
112 
113 /**
114  * @title SafeERC20
115  * @dev Wrappers around ERC20 operations that throw on failure.
116  */
117 library SafeERC20 {
118     function safeTransfer(ERC20Basic token, address to, uint256 value) internal {
119         assert(token.transfer(to, value));
120     }
121 
122     function safeTransferFrom(ERC20 token, address from, address to, uint256 value) internal {
123         assert(token.transferFrom(from, to, value));
124     }
125 
126     function safeApprove(ERC20 token, address spender, uint256 value) internal {
127         assert(token.approve(spender, value));
128     }
129 }
130 
131 /**
132  * @title Basic token
133  * @dev Basic version of StandardToken, with no allowances.
134  */
135 contract NvcFundToken is ERC20Basic {
136     using SafeMath for uint256;
137 
138     mapping(address => uint256) balances;
139 
140     uint256 totalSupply_;
141 
142     /**
143     * @dev total number of tokens in existence
144     */
145     function totalSupply() public view returns (uint256) {
146         return totalSupply_;
147     }
148 
149     /**
150     * @dev transfer token for a specified address
151     * @param _to The address to transfer to.
152     * @param _value The amount to be transferred.
153     */
154     function transfer(address _to, uint256 _value) public returns (bool) {
155         require(_to != address(0));
156         require(_value <= balances[msg.sender]);
157 
158         balances[msg.sender] = balances[msg.sender].sub(_value);
159         balances[_to] = balances[_to].add(_value);
160         emit Transfer(msg.sender, _to, _value);
161         return true;
162     }
163 
164     /**
165     * @dev Gets the balance of the specified address.
166     * @param _owner The address to query the the balance of.
167     * @return An uint256 representing the amount owned by the passed address.
168     */
169     function balanceOf(address _owner) public view returns (uint256 balance) {
170         return balances[_owner];
171     }
172 
173 }
174 
175 /**
176  * @title Standard ERC20 token
177  *
178  * @dev Implementation of the basic standard token.
179  */
180 contract StandardToken is ERC20, NvcFundToken {
181 
182     mapping (address => mapping (address => uint256)) internal allowed;
183 
184     /**
185     * @dev Transfer tokens from one address to another
186     * @param _from address The address which you want to send tokens from
187     * @param _to address The address which you want to transfer to
188     * @param _value uint256 the amount of tokens to be transferred
189     */
190     function transferFrom(address _from, address _to, uint256 _value) public returns (bool) {
191         require(_to != address(0));
192         require(_value <= balances[_from]);
193         require(_value <= allowed[_from][msg.sender]);
194 
195         balances[_from] = balances[_from].sub(_value);
196         balances[_to] = balances[_to].add(_value);
197         allowed[_from][msg.sender] = allowed[_from][msg.sender].sub(_value);
198         emit Transfer(_from, _to, _value);
199         return true;
200     }
201 
202     /**
203     * @dev Approve the passed address to spend the specified amount of tokens on behalf of msg.sender.
204     *
205     * Beware that changing an allowance with this method brings the risk that someone may use both the old
206     * and the new allowance by unfortunate transaction ordering. One possible solution to mitigate this
207     * race condition is to first reduce the spender's allowance to 0 and set the desired value afterwards:
208     * @param _spender The address which will spend the funds.
209     * @param _value The amount of tokens to be spent.
210     */
211     function approve(address _spender, uint256 _value) public returns (bool) {
212         allowed[msg.sender][_spender] = _value;
213         emit Approval(msg.sender, _spender, _value);
214         return true;
215     }
216 
217     /**
218     * @dev Function to check the amount of tokens that an owner allowed to a spender.
219     * @param _owner address The address which owns the funds.
220     * @param _spender address The address which will spend the funds.
221     * @return A uint256 specifying the amount of tokens still available for the spender.
222     */
223     function allowance(address _owner, address _spender) public view returns (uint256) {
224         return allowed[_owner][_spender];
225     }
226 
227     /**
228     * @dev Increase the amount of tokens that an owner allowed to a spender.
229     *
230     * approve should be called when allowed[_spender] == 0. To increment
231     * allowed value is better to use this function to avoid 2 calls (and wait until
232     * the first transaction is mined)
233     * @param _spender The address which will spend the funds.
234     * @param _addedValue The amount of tokens to increase the allowance by.
235     */
236     function increaseApproval(address _spender, uint _addedValue) public returns (bool) {
237         allowed[msg.sender][_spender] = allowed[msg.sender][_spender].add(_addedValue);
238         emit Approval(msg.sender, _spender, allowed[msg.sender][_spender]);
239         return true;
240     }
241 
242     /**
243     * @dev Decrease the amount of tokens that an owner allowed to a spender.
244     *
245     * approve should be called when allowed[_spender] == 0. To decrement
246     * allowed value is better to use this function to avoid 2 calls (and wait until
247     * the first transaction is mined)
248     * @param _spender The address which will spend the funds.
249     * @param _subtractedValue The amount of tokens to decrease the allowance by.
250     */
251     function decreaseApproval(address _spender, uint _subtractedValue) public returns (bool) {
252         uint oldValue = allowed[msg.sender][_spender];
253         if (_subtractedValue > oldValue) {
254             allowed[msg.sender][_spender] = 0;
255         } else {
256             allowed[msg.sender][_spender] = oldValue.sub(_subtractedValue);
257         }
258         emit Approval(msg.sender, _spender, allowed[msg.sender][_spender]);
259         return true;
260     }
261 
262 }
263 
264 
265 contract NvcFundCoin is StandardToken, Ownable {
266     
267     string public name = "Nvc Fund Coin";
268     string public symbol = "NVF";
269     string public version = "1.0";
270     uint8 public decimals = 18;
271     
272     uint256 INITIAL_SUPPLY = 1000000000e18;
273     
274     function NvcFundCoin() public {
275         totalSupply_ = INITIAL_SUPPLY;
276         balances[this] = totalSupply_;
277         allowed[this][msg.sender] = totalSupply_;
278         
279         emit Approval(this, msg.sender, balances[this]);
280     }
281     
282     /**
283     *@dev Function to handle callback calls
284     */
285     function() public {
286         revert();
287     }    
288 
289 }