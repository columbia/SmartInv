1 pragma solidity ^0.4.19;
2 
3 // Made with Pragma at www.withpragma.com
4 
5 /**
6  * @title SafeMath
7  * @dev Math operations with safety checks that throw on error
8  */
9 library SafeMath {
10 
11     /**
12     * @dev Multiplies two numbers, throws on overflow.
13     */
14     function mul(uint256 a, uint256 b) internal pure returns (uint256) {
15         if (a == 0) {
16             return 0;
17         }
18         uint256 c = a * b;
19         assert(c / a == b);
20         return c;
21     }
22 
23     /**
24     * @dev Integer division of two numbers, truncating the quotient.
25     */
26     function div(uint256 a, uint256 b) internal pure returns (uint256) {
27         // assert(b > 0); // Solidity automatically throws when dividing by 0
28         uint256 c = a / b;
29         // assert(a == b * c + a % b); // There is no case in which this doesn't hold
30         return c;
31     }
32 
33     /**
34     * @dev Substracts two numbers, throws on overflow (i.e. if subtrahend is greater than minuend).
35     */
36     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
37         assert(b <= a);
38         return a - b;
39     }
40 
41     /**
42     * @dev Adds two numbers, throws on overflow.
43     */
44     function add(uint256 a, uint256 b) internal pure returns (uint256) {
45         uint256 c = a + b;
46         assert(c >= a);
47         return c;
48     }
49 }
50 
51 /**
52  * @title Ownable
53  * @dev The Ownable contract has an owner address, and provides basic authorization control
54  * functions, this simplifies the implementation of "user permissions".
55  */
56 contract Ownable {
57     address public owner;
58 
59     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
60 
61     /**
62     * @dev The Ownable constructor sets the original `owner` of the contract to the sender
63     * account.
64     */
65     function Ownable() public {
66         owner = msg.sender;
67     }
68 
69     /**
70     * @dev Throws if called by any account other than the owner.
71     */
72     modifier onlyOwner() {
73         require(msg.sender == owner);
74         _;
75     }
76 
77     /**
78     * @dev Allows the current owner to transfer control of the contract to a newOwner.
79     * @param newOwner The address to transfer ownership to.
80     */
81     function transferOwnership(address newOwner) public onlyOwner {
82         require(newOwner != address(0));
83         OwnershipTransferred(owner, newOwner);
84         owner = newOwner;
85     }
86 
87 }
88 
89 /**
90  * @title ERC20Basic
91  * @dev Simpler version of ERC20 interface
92  * @dev see https://github.com/ethereum/EIPs/issues/179
93  */
94 contract ERC20Basic {
95     function totalSupply() public view returns (uint256);
96     function balanceOf(address who) public view returns (uint256);
97     function transfer(address to, uint256 value) public returns (bool);
98     event Transfer(address indexed from, address indexed to, uint256 value);
99 }
100 
101 /**
102  * @title ERC20 interface
103  * @dev see https://github.com/ethereum/EIPs/issues/20
104  */
105 contract ERC20 is ERC20Basic {
106     function allowance(address owner, address spender) public view returns (uint256);
107     function transferFrom(address from, address to, uint256 value) public returns (bool);
108     function approve(address spender, uint256 value) public returns (bool);
109     event Approval(address indexed owner, address indexed spender, uint256 value);
110 }
111 
112 /**
113  * @title Basic token
114  * @dev Basic version of StandardToken, with no allowances.
115  */
116 contract BasicToken is ERC20Basic {
117     using SafeMath for uint256;
118     
119     mapping(address => uint256) balances;
120     
121     uint256 totalSupply_;
122 
123     /**
124     * @dev total number of tokens in existence
125     */
126     function totalSupply() public view returns (uint256) {
127         return totalSupply_;
128     }
129 
130     /**
131     * @dev transfer token for a specified address
132     * @param _to The address to transfer to.
133     * @param _value The amount to be transferred.
134     */
135     function transfer(address _to, uint256 _value) public returns (bool) {
136         require(_to != address(0));
137         require(_value <= balances[msg.sender]);
138         
139         // SafeMath.sub will throw if there is not enough balance.
140         balances[msg.sender] = balances[msg.sender].sub(_value);
141         balances[_to] = balances[_to].add(_value);
142         Transfer(msg.sender, _to, _value);
143         return true;
144     }
145 
146     /**
147     * @dev Gets the balance of the specified address.
148     * @param _owner The address to query the the balance of.
149     * @return An uint256 representing the amount owned by the passed address.
150     */
151     function balanceOf(address _owner) public view returns (uint256 balance) {
152         return balances[_owner];
153     }
154 
155 }
156 
157 /**
158  * @title Standard ERC20 token
159  *
160  * @dev Implementation of the basic standard token.
161  * @dev https://github.com/ethereum/EIPs/issues/20
162  * @dev Based on code by FirstBlood: https://github.com/Firstbloodio/token/blob/master/smart_contract/FirstBloodToken.sol
163  */
164 contract StandardToken is ERC20, BasicToken {
165 
166     mapping (address => mapping (address => uint256)) internal allowed;
167     
168     /**
169     * @dev Transfer tokens from one address to another
170     * @param _from address The address which you want to send tokens from
171     * @param _to address The address which you want to transfer to
172     * @param _value uint256 the amount of tokens to be transferred
173     */
174     function transferFrom(address _from, address _to, uint256 _value) public returns (bool) {
175         require(_to != address(0));
176         require(_value <= balances[_from]);
177         require(_value <= allowed[_from][msg.sender]);
178         
179         balances[_from] = balances[_from].sub(_value);
180         balances[_to] = balances[_to].add(_value);
181         allowed[_from][msg.sender] = allowed[_from][msg.sender].sub(_value);
182         Transfer(_from, _to, _value);
183         return true;
184     }
185 
186     /**
187     * @dev Approve the passed address to spend the specified amount of tokens on behalf of msg.sender.
188     *
189     * Beware that changing an allowance with this method brings the risk that someone may use both the old
190     * and the new allowance by unfortunate transaction ordering. One possible solution to mitigate this
191     * race condition is to first reduce the spender's allowance to 0 and set the desired value afterwards:
192     * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
193     * @param _spender The address which will spend the funds.
194     * @param _value The amount of tokens to be spent.
195     */
196     function approve(address _spender, uint256 _value) public returns (bool) {
197         allowed[msg.sender][_spender] = _value;
198         Approval(msg.sender, _spender, _value);
199         return true;
200     }
201 
202     /**
203     * @dev Function to check the amount of tokens that an owner allowed to a spender.
204     * @param _owner address The address which owns the funds.
205     * @param _spender address The address which will spend the funds.
206     * @return A uint256 specifying the amount of tokens still available for the spender.
207     */
208     function allowance(address _owner, address _spender) public view returns (uint256) {
209         return allowed[_owner][_spender];
210     }
211 
212     /**
213     * @dev Increase the amount of tokens that an owner allowed to a spender.
214     *
215     * approve should be called when allowed[_spender] == 0. To increment
216     * allowed value is better to use this function to avoid 2 calls (and wait until
217     * the first transaction is mined)
218     * From MonolithDAO Token.sol
219     * @param _spender The address which will spend the funds.
220     * @param _addedValue The amount of tokens to increase the allowance by.
221     */
222     function increaseApproval(address _spender, uint _addedValue) public returns (bool) {
223         allowed[msg.sender][_spender] = allowed[msg.sender][_spender].add(_addedValue);
224         Approval(msg.sender, _spender, allowed[msg.sender][_spender]);
225         return true;
226     }
227 
228     /**
229     * @dev Decrease the amount of tokens that an owner allowed to a spender.
230     *
231     * approve should be called when allowed[_spender] == 0. To decrement
232     * allowed value is better to use this function to avoid 2 calls (and wait until
233     * the first transaction is mined)
234     * From MonolithDAO Token.sol
235     * @param _spender The address which will spend the funds.
236     * @param _subtractedValue The amount of tokens to decrease the allowance by.
237     */
238     function decreaseApproval(address _spender, uint _subtractedValue) public returns (bool) {
239         uint oldValue = allowed[msg.sender][_spender];
240         if (_subtractedValue > oldValue) {
241             allowed[msg.sender][_spender] = 0;
242         } else {
243             allowed[msg.sender][_spender] = oldValue.sub(_subtractedValue);
244         }
245         Approval(msg.sender, _spender, allowed[msg.sender][_spender]);
246         return true;
247     }
248 
249 }
250 
251 // Made by John Palmer & Marcus Molchany (Pragma W18)
252 contract FounderCoin is StandardToken, Ownable {
253   
254     /*
255     * Token meta data
256     */
257     string constant public name = "FounderCoin";
258     string constant public symbol = "FC";
259     uint8 constant public decimals = 0;
260     bool public mintingFinished = false;
261     
262     event Mint(address indexed to, uint256 amount);
263     event MintFinished(uint _finalAmount);
264     
265     modifier canMint() {
266         require(!mintingFinished);
267         _;
268     }
269 
270     /**
271     * @dev Function to mint tokens
272     * @param _to The address that will receive the minted tokens.
273     * @param _amount The amount of tokens to mint.
274     * @return A boolean that indicates if the operation was successful.
275     */
276     function mint(address _to, uint256 _amount) onlyOwner canMint public returns (bool) {
277         totalSupply_ = totalSupply_.add(_amount);
278         balances[_to] = balances[_to].add(_amount);
279         Mint(_to, _amount);
280         Transfer(address(0), _to, _amount);
281         return true;
282     }
283     
284     /**
285     * @dev Function to stop minting new tokens.
286     * @return True if the operation was successful.
287     */
288     function finishMinting() onlyOwner canMint public returns (bool) {
289         mintingFinished = true;
290         MintFinished(totalSupply_);
291         return true;
292     }
293 }