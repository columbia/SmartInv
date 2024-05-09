1 pragma solidity ^0.4.18;
2 
3 /**
4  * @title Ownable
5  * @dev The Ownable contract has an owner address, and provides basic authorization control
6  * functions, this simplifies the implementation of "user permissions".
7  */
8 contract Ownable {
9     address public owner;
10 
11 
12     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
13 
14 
15     /**
16      * @dev The Ownable constructor sets the original `owner` of the contract to the sender
17      * account.
18      */
19     function Ownable() public {
20         owner = msg.sender;
21     }
22 
23 
24     /**
25      * @dev Throws if called by any account other than the owner.
26      */
27     modifier onlyOwner() {
28         require(msg.sender == owner);
29         _;
30     }
31 
32 
33     /**
34      * @dev Allows the current owner to transfer control of the contract to a newOwner.
35      * @param newOwner The address to transfer ownership to.
36      */
37     function transferOwnership(address newOwner) public onlyOwner {
38         require(newOwner != address(0));
39         OwnershipTransferred(owner, newOwner);
40         owner = newOwner;
41     }
42 
43 }
44 
45 /**
46  * @title SafeMath
47  * @dev Math operations with safety checks that throw on error
48  */
49 library SafeMath {
50     function mul(uint256 a, uint256 b) internal pure returns (uint256) {
51         if (a == 0) {
52             return 0;
53         }
54         uint256 c = a * b;
55         assert(c / a == b);
56         return c;
57     }
58 
59     function div(uint256 a, uint256 b) internal pure returns (uint256) {
60         // assert(b > 0); // Solidity automatically throws when dividing by 0
61         uint256 c = a / b;
62         // assert(a == b * c + a % b); // There is no case in which this doesn't hold
63         return c;
64     }
65 
66     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
67         assert(b <= a);
68         return a - b;
69     }
70 
71     function add(uint256 a, uint256 b) internal pure returns (uint256) {
72         uint256 c = a + b;
73         assert(c >= a);
74         return c;
75     }
76 }
77 
78 /**
79  * @title ERC20Basic
80  * @dev Simpler version of ERC20 interface
81  * @dev see https://github.com/ethereum/EIPs/issues/179
82  */
83 contract ERC20Basic {
84     uint256 public totalSupply;
85     function balanceOf(address who) public view returns (uint256);
86     function transfer(address to, uint256 value) public returns (bool);
87     event Transfer(address indexed from, address indexed to, uint256 value);
88 }
89 
90 /**
91  * @title Basic token
92  * @dev Basic version of StandardToken, with no allowances.
93  */
94 contract BasicToken is ERC20Basic {
95     using SafeMath for uint256;
96 
97     mapping(address => uint256) balances;
98 
99     /**
100     * @dev transfer token for a specified address
101     * @param _to The address to transfer to.
102     * @param _value The amount to be transferred.
103     */
104     function transfer(address _to, uint256 _value) public returns (bool) {
105         require(_to != address(0));
106         require(_value <= balances[msg.sender]);
107 
108         // SafeMath.sub will throw if there is not enough balance.
109         balances[msg.sender] = balances[msg.sender].sub(_value);
110         balances[_to] = balances[_to].add(_value);
111         Transfer(msg.sender, _to, _value);
112         return true;
113     }
114 
115     /**
116     * @dev Gets the balance of the specified address.
117     * @param _owner The address to query the the balance of.
118     * @return An uint256 representing the amount owned by the passed address.
119     */
120     function balanceOf(address _owner) public view returns (uint256 balance) {
121         return balances[_owner];
122     }
123 
124 }
125 
126 /**
127  * @title ERC20 interface
128  * @dev see https://github.com/ethereum/EIPs/issues/20
129  */
130 contract ERC20 is ERC20Basic {
131     function allowance(address owner, address spender) public view returns (uint256);
132     function transferFrom(address from, address to, uint256 value) public returns (bool);
133     function approve(address spender, uint256 value) public returns (bool);
134     event Approval(address indexed owner, address indexed spender, uint256 value);
135 }
136 
137 /**
138  * @title Standard ERC20 token
139  *
140  * @dev Implementation of the basic standard token.
141  * @dev https://github.com/ethereum/EIPs/issues/20
142  * @dev Based on code by FirstBlood: https://github.com/Firstbloodio/token/blob/master/smart_contract/FirstBloodToken.sol
143  */
144 contract StandardToken is ERC20, BasicToken {
145 
146     mapping (address => mapping (address => uint256)) internal allowed;
147 
148 
149     /**
150      * @dev Transfer tokens from one address to another
151      * @param _from address The address which you want to send tokens from
152      * @param _to address The address which you want to transfer to
153      * @param _value uint256 the amount of tokens to be transferred
154      */
155     function transferFrom(address _from, address _to, uint256 _value) public returns (bool) {
156         require(_to != address(0));
157         require(_value <= balances[_from]);
158         require(_value <= allowed[_from][msg.sender]);
159 
160         balances[_from] = balances[_from].sub(_value);
161         balances[_to] = balances[_to].add(_value);
162         allowed[_from][msg.sender] = allowed[_from][msg.sender].sub(_value);
163         Transfer(_from, _to, _value);
164         return true;
165     }
166 
167     /**
168      * @dev Approve the passed address to spend the specified amount of tokens on behalf of msg.sender.
169      *
170      * Beware that changing an allowance with this method brings the risk that someone may use both the old
171      * and the new allowance by unfortunate transaction ordering. One possible solution to mitigate this
172      * race condition is to first reduce the spender's allowance to 0 and set the desired value afterwards:
173      * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
174      * @param _spender The address which will spend the funds.
175      * @param _value The amount of tokens to be spent.
176      */
177     function approve(address _spender, uint256 _value) public returns (bool) {
178         allowed[msg.sender][_spender] = _value;
179         Approval(msg.sender, _spender, _value);
180         return true;
181     }
182 
183     /**
184      * @dev Function to check the amount of tokens that an owner allowed to a spender.
185      * @param _owner address The address which owns the funds.
186      * @param _spender address The address which will spend the funds.
187      * @return A uint256 specifying the amount of tokens still available for the spender.
188      */
189     function allowance(address _owner, address _spender) public view returns (uint256) {
190         return allowed[_owner][_spender];
191     }
192 
193     /**
194      * approve should be called when allowed[_spender] == 0. To increment
195      * allowed value is better to use this function to avoid 2 calls (and wait until
196      * the first transaction is mined)
197      * From MonolithDAO Token.sol
198      */
199     function increaseApproval(address _spender, uint _addedValue) public returns (bool) {
200         allowed[msg.sender][_spender] = allowed[msg.sender][_spender].add(_addedValue);
201         Approval(msg.sender, _spender, allowed[msg.sender][_spender]);
202         return true;
203     }
204 
205     function decreaseApproval(address _spender, uint _subtractedValue) public returns (bool) {
206         uint oldValue = allowed[msg.sender][_spender];
207         if (_subtractedValue > oldValue) {
208             allowed[msg.sender][_spender] = 0;
209         } else {
210             allowed[msg.sender][_spender] = oldValue.sub(_subtractedValue);
211         }
212         Approval(msg.sender, _spender, allowed[msg.sender][_spender]);
213         return true;
214     }
215 
216 }
217 
218 contract GameStarsToken is StandardToken, Ownable {
219     string public constant name = "GameStars";
220     string public constant symbol = "STAR";
221     uint8 public constant decimals = 18;
222 
223     bool public mintingFinished = false;
224 
225     mapping (address => bool) public mintAgents;
226 
227     function mint(address _to, uint256 _amount)
228         public onlyMintAgent canMint returns(bool)
229     {
230         totalSupply = totalSupply.add(_amount);
231         balances[_to] = balances[_to].add(_amount);
232 
233         Mint(_to, _amount);
234         Transfer(address(0), _to, _amount);
235 
236         return true;
237     }
238 
239     function setMintAgent(address _address, bool _state)
240         onlyOwner canMint public
241     {
242         mintAgents[_address] = _state;
243         MintingAgentChanged(_address, _state);
244     }
245 
246     modifier canMint() {
247         require(!mintingFinished);
248         _;
249     }
250 
251     modifier onlyMintAgent() {
252         require(mintAgents[msg.sender] == true);
253         _;
254     }
255 
256     event Mint(address indexed to, uint256 amount);
257     event MintingAgentChanged(address addr, bool state);
258     event MintFinished();
259 }