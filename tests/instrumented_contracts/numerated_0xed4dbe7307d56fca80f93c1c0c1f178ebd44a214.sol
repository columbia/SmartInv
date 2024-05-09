1 /**
2  *Submitted for verification at Etherscan.io on 2019-08-11
3 */
4 
5 pragma solidity ^0.5.10;
6 /**
7  * @title ERC20Basic
8  * @dev Simpler version of ERC20 interface
9  * @dev see https://github.com/ethereum/EIPs/issues/179
10  */
11 contract ERC20Basic 
12 {
13     function totalSupply() public view returns (uint256);
14     function balanceOf(address who) public view returns (uint256);
15     function transfer(address to, uint256 value) public returns (bool);
16     event Transfer(address indexed from, address indexed to, uint256 value);
17 }
18 /**
19  * @title SafeMath
20  * @dev Math operations with safety checks that throw on error
21  */
22 library SafeMath 
23 {
24     /**
25     * @dev Multiplies two numbers, throws on overflow.
26     */
27     function mul(uint256 a, uint256 b) internal pure returns (uint256 c) 
28     {
29         if (a == 0) {
30             return 0;
31         }
32         c = a * b;
33         assert(c  / a == b);
34         return c;
35     }
36     /**
37     * @dev Integer division of two numbers, truncating the quotient.
38     */
39     function div(uint256 a, uint256 b) internal pure returns (uint256) 
40     {
41         return a  / b;
42     }
43     /**
44     * @dev Subtracts two numbers, throws on overflow (i.e. if subtrahend is greater than minuend).
45     */
46     function sub(uint256 a, uint256 b) internal pure returns (uint256) 
47     {
48         assert(b <= a);
49         return a - b;
50     }
51     /**
52     * @dev Adds two numbers, throws on overflow.
53     */
54     function add(uint256 a, uint256 b) internal pure returns (uint256 c) 
55     {
56         c = a + b;
57         assert(c >= a);
58         return c;
59     }
60 }
61 pragma solidity ^0.5.10;
62 /**
63  * @title ERC20 interface
64  * @dev see https://github.com/ethereum/EIPs/issues/20
65  */
66 contract ERC20 is ERC20Basic 
67 {
68     function allowance(address owner, address spender) public view returns (uint256);
69     function transferFrom(address from, address to, uint256 value) public returns (bool);
70     function approve(address spender, uint256 value) public returns (bool);
71     event Approval(address indexed owner, address indexed spender, uint256 value);
72 }
73 contract Owner
74 {
75     address internal owner;
76     modifier onlyOwner {
77         require(msg.sender == owner);
78         _;
79     }
80     function changeOwner(address newOwner) public onlyOwner returns(bool)
81     {
82         owner = newOwner;
83         return true;
84     }
85 }
86 
87 pragma solidity ^0.5.10;
88 /**
89  * @title Basic token
90  * @dev Basic version of StandardToken, with no allowances.
91  */
92 contract BasicToken is ERC20Basic, Owner
93 {
94     using SafeMath for uint256;
95     uint256 internal totalSupply_;
96     mapping (address => bool) internal locked;
97 	mapping(address => uint256) internal balances;
98     /**
99     * alan: lock or unlock account
100     */
101     function lockAccount(address _addr) public onlyOwner returns (bool)
102     {
103         require(_addr != address(0));
104         locked[_addr] = true;
105         return true;
106     }
107     function unlockAccount(address _addr) public onlyOwner returns (bool)
108     {
109         require(_addr != address(0));
110         locked[_addr] = false;
111         return true;
112     }
113     /**
114     * alan: get lock status
115     */
116     function isLocked(address addr) public view returns(bool) 
117     {
118         return locked[addr];
119     }
120     bool internal stopped = false;
121     modifier running {
122         assert (!stopped);
123         _;
124     }
125     function stop() public onlyOwner 
126     {
127         stopped = true;
128     }
129     function start() public onlyOwner 
130     {
131         stopped = false;
132     }
133     function isStopped() public view returns(bool)
134     {
135         return stopped;
136     }
137     /**
138     * @dev total number of tokens in existence
139     */
140     function totalSupply() public view returns (uint256) 
141     {
142         return totalSupply_;
143     }
144     /**
145     * @dev transfer token for a specified address
146     * @param _to The address to transfer to.
147     * @param _value The amount to be transferred.
148     */
149     function transfer(address _to, uint256 _value) public running returns (bool) 
150     {
151         require(_to != address(0));
152         require(_value <= balances[msg.sender]);
153         require( locked[msg.sender] != true);
154         require( locked[_to] != true);
155         
156         balances[msg.sender] = balances[msg.sender].sub(_value);
157         balances[_to] = balances[_to].add(_value);
158         emit Transfer(msg.sender, _to, _value);
159         return true;
160     }
161     /**
162     * @dev Gets the balance of the specified address.
163     * @param _owner The address to query the the balance of.
164     * @return An uint256 representing the amount owned by the passed address.
165     */
166     function balanceOf(address _owner) public view returns (uint256) 
167     {
168         return balances[_owner];
169     }
170 }
171 pragma solidity ^0.5.10;
172 /**
173  * @title Standard ERC20 token
174  *
175  * @dev Implementation of the basic standard token.
176  * @dev https://github.com/ethereum/EIPs/issues/20
177  * @dev Based on code by FirstBlood: https://github.com/Firstbloodio/token/blob/master/smart_contract/FirstBloodToken.sol
178  */
179 contract StandardToken is ERC20, BasicToken 
180 {
181     mapping (address => mapping (address => uint256)) internal allowed;
182     /**
183     * @dev Transfer tokens from one address to another
184     * @param _from address The address which you want to send tokens from
185     * @param _to address The address which you want to transfer to
186     * @param _value uint256 the amount of tokens to be transferred
187     */
188     function transferFrom(address _from, address _to, uint256 _value) public running returns (bool) 
189     {
190         require(_to != address(0));
191         require( locked[_from] != true && locked[_to] != true);
192         require(_value <= balances[_from]);
193         require(_value <= allowed[_from][msg.sender]);
194         balances[_from] = balances[_from].sub(_value);
195         balances[_to] = balances[_to].add(_value);
196         allowed[_from][msg.sender] = allowed[_from][msg.sender].sub(_value);
197         emit Transfer(_from, _to, _value);
198         return true;
199     }
200     /**
201     * @dev Approve the passed address to spend the specified amount of tokens on behalf of msg.sender.
202     *
203     * Beware that changing an allowance with this method brings the risk that someone may use both the
204     old
205     * and the new allowance by unfortunate transaction ordering. One possible solution to mitigate this
206     * race condition is to first reduce the spender's allowance to 0 and set the desired value afterwards:
207     * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
208     * @param _spender The address which will spend the funds.
209     * @param _value The amount of tokens to be spent.
210     */
211     function approve(address _spender, uint256 _value) public running returns (bool) 
212     {
213         allowed[msg.sender][_spender] = _value;
214         emit Approval(msg.sender, _spender, _value);
215         return true;
216     }
217     /**
218     * @dev Function to check the amount of tokens that an owner allowed to a spender.
219     * @param _owner address The address which owns the funds.
220     * @param _spender address The address which will spend the funds.
221     * @return A uint256 specifying the amount of tokens still available for the spender.
222     */
223     function allowance(address _owner, address _spender) public view returns (uint256) 
224     {
225         return allowed[_owner][_spender];
226     }
227 }
228 
229 contract NNDToken is StandardToken
230 {
231     function additional(uint amount) public onlyOwner running returns(bool)
232     {
233         totalSupply_ = totalSupply_.add(amount);
234         balances[owner] = balances[owner].add(amount);
235         return true;
236     }
237     event Burn(address indexed from, uint256 value);
238     /**
239     * Destroy tokens
240     * Remove `_value` tokens from the system irreversibly
241     * @param _value the amount of money to burn
242     */
243     function burn(uint256 _value) public onlyOwner running returns (bool success) 
244     {
245         require(balances[msg.sender] >= _value);
246         balances[msg.sender] = balances[msg.sender].sub(_value);
247         totalSupply_ = totalSupply_.sub(_value);
248         emit Burn(msg.sender, _value);
249         return true;
250     }
251     /**
252     * Destroy tokens from other account
253     *
254     * Remove `_value` tokens from the system irreversibly on behalf of `_from`.
255     *
256     * @param _from the address of the senderT
257     * @param _value the amount of money to burn
258     */
259     function burnFrom(address _from, uint256 _value) public onlyOwner returns (bool success) 
260     {
261         require(balances[_from] >= _value);
262         if (_value <= allowed[_from][msg.sender]) {
263             allowed[_from][msg.sender] -= _value;
264         }
265         else {
266             allowed[_from][msg.sender] = 0;
267         }
268         balances[_from] -= _value;
269         totalSupply_ -= _value;
270         emit Burn(_from, _value);
271         return true;
272     }
273 }
274 
275 pragma solidity ^0.5.10;
276 contract NND is NNDToken 
277 {
278     string public constant name = "NND";
279     string public constant symbol = "NND";
280     uint8 public constant decimals = 18;
281     uint256 private constant INITIAL_SUPPLY = 990000000 * (10 ** uint256(decimals));
282 
283     constructor(uint totalSupply) public 
284     {
285         owner = msg.sender;
286         totalSupply_ = totalSupply > 0 ? totalSupply : INITIAL_SUPPLY;
287         balances[owner] = totalSupply_;
288     }
289 }