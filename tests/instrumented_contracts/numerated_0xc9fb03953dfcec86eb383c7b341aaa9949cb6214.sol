1 pragma solidity ^0.4.25;
2 
3 // ----------------------------------------------------------------------------
4 // LIST101 Token
5 //
6 // (c) ERC20Dev, 2018. | https://erc20dev.com
7 // ----------------------------------------------------------------------------
8 
9 /**
10  * @title SafeMath
11  * @dev Math operations with safety checks that throw on error
12  */
13 library SafeMath {
14 
15   /**
16   * @dev Multiplies two numbers, throws on overflow.
17   */
18     function mul(uint256 _a, uint256 _b) internal pure returns (uint256 c) {
19     // Gas optimization: this is cheaper than asserting 'a' not being zero, but the
20     // benefit is lost if 'b' is also tested.
21     // See: https://github.com/OpenZeppelin/openzeppelin-solidity/pull/522
22         if (_a == 0) {
23             return 0;
24     }
25 
26         c = _a * _b;
27         assert(c / _a == _b);
28         return c;
29     }
30 
31   /**
32   * @dev Integer division of two numbers, truncating the quotient.
33   */
34     function div(uint256 _a, uint256 _b) internal pure returns (uint256) {
35     // assert(_b > 0); // Solidity automatically throws when dividing by 0
36     // uint256 c = _a / _b;
37     // assert(_a == _b * c + _a % _b); // There is no case in which this doesn't hold
38         return _a / _b;
39     }
40 
41   /**
42   * @dev Subtracts two numbers, throws on overflow (i.e. if subtrahend is greater than minuend).
43   */
44     function sub(uint256 _a, uint256 _b) internal pure returns (uint256) {
45         assert(_b <= _a);
46         return _a - _b;
47     }
48 
49   /**
50   * @dev Adds two numbers, throws on overflow.
51   */
52     function add(uint256 _a, uint256 _b) internal pure returns (uint256 c) {
53         c = _a + _b;
54         assert(c >= _a);
55         return c;
56     }
57 }
58 
59 /**
60  * @title ERC20Basic
61  * @dev Simpler version of ERC20 interface
62  * See https://github.com/ethereum/EIPs/issues/179
63  */
64 contract ERC20Basic {
65     function balanceOf(address _who) public view returns (uint256);
66     function transfer(address _to, uint256 _value) public returns (bool);
67     event Transfer(address indexed from, address indexed to, uint256 value);
68 }
69 
70 /**
71  * @title ERC20 interface
72  * @dev see https://github.com/ethereum/EIPs/issues/20
73  */
74 contract ERC20 is ERC20Basic {
75     function allowance(address _owner, address _spender) public view returns (uint256);
76 
77     function transferFrom(address _from, address _to, uint256 _value) public returns (bool);
78 
79     function approve(address _spender, uint256 _value) public returns (bool);
80     event Approval(
81     address indexed owner,
82     address indexed spender,
83     uint256 value
84     );
85 }
86 
87 /**
88  * @title Basic token
89  * @dev Basic version of StandardToken, with no allowances.
90  */
91 contract BasicToken is ERC20Basic {
92     using SafeMath for uint256;
93 
94     mapping(address => uint256) internal balances;
95 
96 
97   /**
98   * @dev Transfer token for a specified address
99   * @param _to The address to transfer to.
100   * @param _value The amount to be transferred.
101   */
102     function transfer(address _to, uint256 _value) public returns (bool) {
103         require(_value <= balances[msg.sender],"Not enough tokens left");
104         require(_to != address(0),"Address is empty");
105 
106         balances[msg.sender] = balances[msg.sender].sub(_value);
107         balances[_to] = balances[_to].add(_value);
108         emit Transfer(msg.sender, _to, _value);
109         return true;
110     }
111 
112   /**
113   * @dev Gets the balance of the specified address.
114   * @param _owner The address to query the the balance of.
115   * @return An uint256 representing the amount owned by the passed address.
116   */
117     function balanceOf(address _owner) public view returns (uint256) {
118         return balances[_owner];
119     }
120 
121 }
122 
123 /**
124  * @title Standard ERC20 token
125  *
126  * @dev Implementation of the basic standard token.
127  * https://github.com/ethereum/EIPs/issues/20
128  * Based on code by FirstBlood: https://github.com/Firstbloodio/token/blob/master/smart_contract/FirstBloodToken.sol
129  */
130 contract StandardToken is ERC20, BasicToken {
131 
132     mapping (address => mapping (address => uint256)) internal allowed;
133 
134 
135   /**
136    * @dev Transfer tokens from one address to another
137    * @param _from address The address which you want to send tokens from
138    * @param _to address The address which you want to transfer to
139    * @param _value uint256 the amount of tokens to be transferred
140    */
141     function transferFrom(address _from, address _to, uint256 _value) public returns (bool) {
142         require(_value <= balances[_from]);
143         require(_value <= allowed[_from][msg.sender]);
144         require(_to != address(0));
145 
146         balances[_from] = balances[_from].sub(_value);
147         balances[_to] = balances[_to].add(_value);
148         allowed[_from][msg.sender] = allowed[_from][msg.sender].sub(_value);
149         emit Transfer(_from, _to, _value);
150         return true;
151     }
152 
153   /**
154    * @dev Approve the passed address to spend the specified amount of tokens on behalf of msg.sender.
155    * Beware that changing an allowance with this method brings the risk that someone may use both the old
156    * and the new allowance by unfortunate transaction ordering. One possible solution to mitigate this
157    * race condition is to first reduce the spender's allowance to 0 and set the desired value afterwards:
158    * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
159    * @param _spender The address which will spend the funds.
160    * @param _value The amount of tokens to be spent.
161    */
162     function approve(address _spender, uint256 _value) public returns (bool) {
163         allowed[msg.sender][_spender] = _value;
164         emit Approval(msg.sender, _spender, _value);
165         return true;
166     }
167 
168   /**
169    * @dev Function to check the amount of tokens that an owner allowed to a spender.
170    * @param _owner address The address which owns the funds.
171    * @param _spender address The address which will spend the funds.
172    * @return A uint256 specifying the amount of tokens still available for the spender.
173    */
174     function allowance(address _owner, address _spender) public view returns (uint256) {
175         return allowed[_owner][_spender];
176     }
177 
178   /**
179    * @dev Increase the amount of tokens that an owner allowed to a spender.
180    * approve should be called when allowed[_spender] == 0. To increment
181    * allowed value is better to use this function to avoid 2 calls (and wait until
182    * the first transaction is mined)
183    * From MonolithDAO Token.sol
184    * @param _spender The address which will spend the funds.
185    * @param _addedValue The amount of tokens to increase the allowance by.
186    */
187     function increaseApproval(address _spender, uint256 _addedValue) public returns (bool) {
188         allowed[msg.sender][_spender] = (allowed[msg.sender][_spender].add(_addedValue));
189         emit Approval(msg.sender, _spender, allowed[msg.sender][_spender]);
190         return true;
191     }
192 
193   /**
194    * @dev Decrease the amount of tokens that an owner allowed to a spender.
195    * approve should be called when allowed[_spender] == 0. To decrement
196    * allowed value is better to use this function to avoid 2 calls (and wait until
197    * the first transaction is mined)
198    * From MonolithDAO Token.sol
199    * @param _spender The address which will spend the funds.
200    * @param _subtractedValue The amount of tokens to decrease the allowance by.
201    */
202     function decreaseApproval(address _spender, uint256 _subtractedValue) public returns (bool) {
203         uint256 oldValue = allowed[msg.sender][_spender];
204         if (_subtractedValue >= oldValue) {
205             allowed[msg.sender][_spender] = 0;
206     } else {
207             allowed[msg.sender][_spender] = oldValue.sub(_subtractedValue);
208     }
209         emit Approval(msg.sender, _spender, allowed[msg.sender][_spender]);
210         return true;
211     }
212 
213 }
214 
215 contract Token is StandardToken {
216 
217     uint256 public decimals = 8;
218     uint256 public totalSupply = 100e14;
219     string public name = "List101 Token";
220     string public symbol = "LST";
221     address public ico;
222     address public owner;
223 
224     modifier onlyICO {
225         require(msg.sender == ico);
226         _;
227     }
228 
229     modifier onlyOwner {
230         require(msg.sender == owner);
231         _;
232     }
233 
234     constructor() public {
235         owner = msg.sender;
236         balances[owner] = totalSupply;
237     }
238 
239     function setUpICOAddress(address _ico) public onlyOwner {
240         require(_ico != address(0),"Address is empty");
241         ico = _ico;
242     }
243     
244     function distributeICOTokens(address _buyer, uint256 _tokensToBuy) public onlyICO { //Send tokens to buyer
245         require(_buyer != address(0),"Address is empty");
246         require(_tokensToBuy > 0,"You need to buy at least 1 token");
247         balances[owner] = balances[owner].sub(_tokensToBuy);
248         balances[_buyer] = balances[_buyer].add(_tokensToBuy); 
249     }
250 
251     // Change the owner of the contract
252     function changeOwner(address newOwner) external onlyOwner {
253         require(newOwner != address(0),"Address is empty");
254         owner = newOwner;
255     }
256 }