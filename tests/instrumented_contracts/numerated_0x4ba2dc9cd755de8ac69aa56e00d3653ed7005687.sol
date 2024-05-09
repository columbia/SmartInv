1 pragma solidity ^0.4.18;
2 
3 
4 /**
5  * @title SafeMath
6  * @dev Math operations with safety checks that throw on error
7  */
8 library SafeMath {
9   function mul(uint256 a, uint256 b) internal pure returns (uint256) {
10     if (a == 0) {
11       return 0;
12     }
13     uint256 c = a * b;
14     assert(c / a == b);
15     return c;
16   }
17 
18   function div(uint256 a, uint256 b) internal pure returns (uint256) {
19     // assert(b > 0); // Solidity automatically throws when dividing by 0
20     uint256 c = a / b;
21     // assert(a == b * c + a % b); // There is no case in which this doesn't hold
22     return c;
23   }
24 
25   function sub(uint256 a, uint256 b) internal pure returns (uint256) {
26     assert(b <= a);
27     return a - b;
28   }
29 
30   function add(uint256 a, uint256 b) internal pure returns (uint256) {
31     uint256 c = a + b;
32     assert(c >= a);
33     return c;
34   }
35 }
36 
37 /**
38  * @title Ownable
39  * @dev The Ownable contract has an owner address, and provides basic authorization control
40  * functions, this simplifies the implementation of "user permissions".
41  */
42 contract Ownable {
43     address public owner;
44 
45 
46     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
47 
48 
49     /**
50      * @dev The Ownable constructor sets the original `owner` of the contract to the sender
51      * account.
52      */
53     function Ownable() public {
54         owner = msg.sender;
55     }
56 
57 
58     /**
59      * @dev Throws if called by any account other than the owner.
60      */
61     modifier onlyOwner() {
62         require(msg.sender == owner);
63         _;
64     }
65 
66 
67     /**
68      * @dev Allows the current owner to transfer control of the contract to a newOwner.
69      * @param newOwner The address to transfer ownership to.
70      */
71     function transferOwnership(address newOwner) public onlyOwner {
72         require(newOwner != address(0));
73         OwnershipTransferred(owner, newOwner);
74         owner = newOwner;
75     }
76 
77 }
78 
79 /**
80  * @title ERC20Basic
81  * @dev Simpler version of ERC20 interface
82  * @dev see https://github.com/ethereum/EIPs/issues/179
83  */
84 contract ERC20Basic {
85     uint256 public totalSupply;
86     function balanceOf(address who) public view returns (uint256);
87     function transfer(address to, uint256 value) public returns (bool);
88     event Transfer(address indexed from, address indexed to, uint256 value);
89 }
90 
91 /**
92  * @title ERC20 interface
93  * @dev see https://github.com/ethereum/EIPs/issues/20
94  */
95 contract ERC20 is ERC20Basic {
96     function allowance(address owner, address spender) public view returns (uint256);
97     function transferFrom(address from, address to, uint256 value) public returns (bool);
98     function approve(address spender, uint256 value) public returns (bool);
99     event Approval(address indexed owner, address indexed spender, uint256 value);
100 }
101 
102 /**
103  * @title Basic token
104  * @dev Basic version of StandardToken, with no allowances.
105  */
106 contract BasicToken is ERC20Basic {
107     using SafeMath for uint256;
108 
109     mapping(address => uint256) balances;
110 
111     /**
112     * @dev transfer token for a specified address
113     * @param _to The address to transfer to.
114     * @param _value The amount to be transferred.
115     */
116 
117     function transfer(address _to, uint256 _value) public returns (bool) {
118         require(_to != address(0));
119         require(_value <= balances[msg.sender]);
120 
121         // SafeMath.sub will throw if there is not enough balance.
122         balances[msg.sender] = balances[msg.sender].sub(_value);
123         balances[_to] = balances[_to].add(_value);
124         emit Transfer(msg.sender, _to, _value);
125         return true;
126     }
127     
128     /**
129     * @dev Gets the balance of the specified address.
130     * @param _owner The address to query the the balance of.
131     * @return An uint256 representing the amount owned by the passed address.
132     */
133     function balanceOf(address _owner) public view returns (uint256 balance) {
134         return balances[_owner];
135     }
136 
137 }
138 
139 /**
140  * @title Standard ERC20 token
141  *
142  * @dev Implementation of the basic standard token.
143  * @dev https://github.com/ethereum/EIPs/issues/20
144  * @dev Based on code by FirstBlood: https://github.com/Firstbloodio/token/blob/master/smart_contract/FirstBloodToken.sol
145  */
146 contract StandardToken is ERC20, BasicToken {
147 
148     mapping (address => mapping (address => uint256)) internal allowed;
149 
150 
151     /**
152      * @dev Transfer tokens from one address to another
153      * @param _from address The address which you want to send tokens from
154      * @param _to address The address which you want to transfer to
155      * @param _value uint256 the amount of tokens to be transferred
156      */
157     function transferFrom(address _from, address _to, uint256 _value) public returns (bool) {
158         require(_to != address(0));
159         require(_value <= balances[_from]);
160         require(_value <= allowed[_from][msg.sender]);
161 
162         balances[_from] = balances[_from].sub(_value);
163         balances[_to] = balances[_to].add(_value);
164         allowed[_from][msg.sender] = allowed[_from][msg.sender].sub(_value);
165         emit Transfer(_from, _to, _value);
166         return true;
167     }
168 
169     /**
170      * @dev Approve the passed address to spend the specified amount of tokens on behalf of msg.sender.
171      *
172      * Beware that changing an allowance with this method brings the risk that someone may use both the old
173      * and the new allowance by unfortunate transaction ordering. One possible solution to mitigate this
174      * race condition is to first reduce the spender's allowance to 0 and set the desired value afterwards:
175      * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
176      * @param _spender The address which will spend the funds.
177      * @param _value The amount of tokens to be spent.
178      */
179     function approve(address _spender, uint256 _value) public returns (bool) {
180         allowed[msg.sender][_spender] = _value;
181         //emit Approval(msg.sender, _spender, _value);
182         return true;
183     }
184 
185     /**
186      * @dev Function to check the amount of tokens that an owner allowed to a spender.
187      * @param _owner address The address which owns the funds.
188      * @param _spender address The address which will spend the funds.
189      * @return A uint256 specifying the amount of tokens still available for the spender.
190      */
191     function allowance(address _owner, address _spender) public view returns (uint256) {
192         return allowed[_owner][_spender];
193     }
194 
195     /**
196      * approve should be called when allowed[_spender] == 0. To increment
197      * allowed value is better to use this function to avoid 2 calls (and wait until
198      * the first transaction is mined)
199      * From MonolithDAO Token.sol
200      */
201     function increaseApproval(address _spender, uint _addedValue) public returns (bool) {
202         allowed[msg.sender][_spender] = allowed[msg.sender][_spender].add(_addedValue);
203         //emit Approval(msg.sender, _spender, allowed[msg.sender][_spender]);
204         return true;
205     }
206 
207     function decreaseApproval(address _spender, uint _subtractedValue) public returns (bool) {
208         uint oldValue = allowed[msg.sender][_spender];
209         if (_subtractedValue > oldValue) {
210             allowed[msg.sender][_spender] = 0;
211         } else {
212             allowed[msg.sender][_spender] = oldValue.sub(_subtractedValue);
213         }
214         //emit Approval(msg.sender, _spender, allowed[msg.sender][_spender]);
215         return true;
216     }
217 
218 }
219 
220 /**
221  * @title Mintable token
222  * @dev Simple ERC20 Token example, with mintable token creation
223  * @dev Issue: * https://github.com/OpenZeppelin/zeppelin-solidity/issues/120
224  * Based on code by TokenMarketNet: https://github.com/TokenMarketNet/ico/blob/master/contracts/MintableToken.sol
225  */
226 
227 contract MintableToken is StandardToken, Ownable {
228     event Mint(address indexed to, uint256 amount);
229     event MintFinished();
230 
231     bool public mintingFinished = false;
232 
233 
234     modifier canMint() {
235         require(!mintingFinished);
236         _;
237     }
238 
239     /**
240      * @dev Function to mint tokens
241      * @param _to The address that will receive the minted tokens.
242      * @param _amount The amount of tokens to mint.
243      * @return A boolean that indicates if the operation was successful.
244      */
245     function mint(address _to, uint256 _amount) onlyOwner canMint public returns (bool) {
246         totalSupply = totalSupply.add(_amount);
247         balances[_to] = balances[_to].add(_amount);
248         //emit Mint(_to, _amount);
249         //emit Transfer(address(0), _to, _amount);
250         return true;
251     }
252 
253     /**
254      * @dev Function to stop minting new tokens.
255      * @return True if the operation was successful.
256      */
257     function finishMinting() onlyOwner canMint public returns (bool) {
258         mintingFinished = true;
259         //emit MintFinished();
260         return true;
261     }
262 }
263 
264 contract UNTToken is MintableToken{
265 
266     string public constant name = "untd";
267     string public constant symbol = "UNTD";
268     uint32 public constant decimals = 8;
269 
270     function UNTToken() public {
271         totalSupply = 2000000000E8;
272         balances[msg.sender] = totalSupply; // Add all tokens to issuer balance (crowdsale in this case)
273     }
274 
275 }