1 pragma solidity ^0.4.18;
2 
3 /**
4  * @title ERC20Basic
5  * @dev Simpler version of ERC20 interface
6  * @dev see https://github.com/ethereum/EIPs/issues/179
7  */
8 contract ERC20Basic {
9     uint256 public totalSupply;
10     uint256 public maxGIRL;
11 
12     function balanceOf(address who) public view returns (uint256);
13 
14     function transfer(address to, uint256 value) public returns (bool);
15 
16     event Transfer(address indexed from, address indexed to, uint256 value);
17     event Approval(address indexed owner, address indexed spender, uint256 value);
18 }
19 
20 /**
21  * @title SafeMath
22  * @dev Math operations with safety checks that throw on error
23  */
24 library SafeMath {
25     function mul(uint256 a, uint256 b) internal pure returns (uint256) {
26         if (a == 0) {
27             return 0;
28         }
29         uint256 c = a * b;
30         assert(c / a == b);
31         return c;
32     }
33 
34     function div(uint256 a, uint256 b) internal pure returns (uint256) {
35         // assert(b > 0); // Solidity automatically throws when dividing by 0
36         uint256 c = a / b;
37         // assert(a == b * c + a % b); // There is no case in which this doesn't hold
38         return c;
39     }
40 
41     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
42         assert(b <= a);
43         return a - b;
44     }
45 
46     function add(uint256 a, uint256 b) internal pure returns (uint256) {
47         uint256 c = a + b;
48         assert(c >= a);
49         return c;
50     }
51 }
52 /**
53  * @title Ownable
54  * @dev The Ownable contract has an owner address, and provides basic authorization control
55  * functions, this simplifies the implementation of "user permissions".
56  */
57 contract Ownable {
58     address public owner;
59 
60     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
61     /**
62      * @dev The Ownable constructor sets the original `owner` of the contract to the sender
63      * account.
64      */
65     function Ownable() public {
66         owner = msg.sender;
67     }
68     /**
69      * @dev Throws if called by any account other than the owner.
70      */
71     modifier onlyOwner() {
72         require(msg.sender == owner);
73         _;
74     }
75     /**
76      * @dev Allows the current owner to transfer control of the contract to a newOwner.
77      * @param newOwner The address to transfer ownership to.
78      */
79     function transferOwnership(address newOwner) public onlyOwner {
80         require(newOwner != address(0));
81         emit OwnershipTransferred(owner, newOwner);
82         owner = newOwner;
83     }
84 }
85 
86 /**
87  * @title Basic token
88  * @dev Basic version of StandardToken, with no allowances.
89  */
90 contract BasicToken is ERC20Basic, Ownable {
91     using SafeMath for uint256;
92     bool public transfersEnabled;
93     mapping(address => uint256) balances;
94     mapping(address => mapping(address => uint256)) internal allowed;
95     /**
96     * @dev transfer token for a specified address
97     * @param _to The address to transfer to.
98     * @param _value The amount to be transferred.
99     */
100     function transfer(address _to, uint256 _value) public returns (bool) {
101         require(transfersEnabled);
102         require(_to != address(0));
103         require(_value <= balances[msg.sender]);
104         // SafeMath.sub will throw if there is not enough balance.
105         balances[msg.sender] = balances[msg.sender].sub(_value);
106         balances[_to] = balances[_to].add(_value);
107         emit Transfer(msg.sender, _to, _value);
108         return true;
109     }
110 
111     /**
112     * @dev Gets the balance of the specified address.
113     * @param _owner The address to query the the balance of.
114     * @return An uint256 representing the amount owned by the passed address.
115     */
116     function balanceOf(address _owner) public view returns (uint256 balance) {
117         return balances[_owner];
118     }
119 
120     /**
121      * @dev Transfer tokens from one address to another
122      * @param _from address The address which you want to send tokens from
123      * @param _to address The address which you want to transfer to
124      * @param _value uint256 the amount of tokens to be transferred
125      */
126     function transferFrom(address _from, address _to, uint256 _value) public returns (bool) {
127         require(_to != address(0));
128         require(_value <= balances[_from]);
129         require(_value <= allowed[_from][msg.sender]);
130 
131         balances[_from] = balances[_from].sub(_value);
132         balances[_to] = balances[_to].add(_value);
133         allowed[_from][msg.sender] = allowed[_from][msg.sender].sub(_value);
134         emit Transfer(_from, _to, _value);
135         return true;
136     }
137 
138     /**
139      * @dev Approve the passed address to spend the specified amount of tokens on behalf of msg.sender.
140      *
141      * Beware that changing an allowance with this method brings the risk that someone may use both the old
142      * and the new allowance by unfortunate transaction ordering. One possible solution to mitigate this
143      * race condition is to first reduce the spender's allowance to 0 and set the desired value afterwards:
144      * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
145      * @param _spender The address which will spend the funds.
146      * @param _value The amount of tokens to be spent.
147      */
148     function approve(address _spender, uint256 _value) public returns (bool) {
149         allowed[msg.sender][_spender] = _value;
150         emit Approval(msg.sender, _spender, _value);
151         return true;
152     }
153 
154     /**
155      * @dev Function to check the amount of tokens that an owner allowed to a spender.
156      * @param _owner address The address which owns the funds.
157      * @param _spender address The address which will spend the funds.
158      * @return A uint256 specifying the amount of tokens still available for the spender.
159      */
160     function allowance(address _owner, address _spender) public view returns (uint256) {
161         return allowed[_owner][_spender];
162     }
163 
164     function enableTransfers(bool _transfersEnabled) public onlyOwner {
165         transfersEnabled = _transfersEnabled;
166     }
167 }
168 
169 contract DetailedERC20 is BasicToken {
170     string public name;
171     string public symbol;
172     uint8 public decimals;
173 
174     function DetailedERC20(uint256 _totalSupply, string _name, string _symbol, uint8 _decimals) public {
175         name = _name;
176         symbol = _symbol;
177         decimals = _decimals;
178         totalSupply = _totalSupply;
179         maxGIRL = _totalSupply;
180         balances[owner] = _totalSupply;
181     }
182 }
183 
184 /**
185  * @title Burnable Token
186  * @dev Token that can be irreversibly burned (destroyed).
187  */
188 contract BurnableToken is BasicToken {
189 
190     event Burn(address indexed burner, uint256 value);
191 
192     /**
193      * @dev Burns a specific amount of tokens.
194      * @param _value The amount of token to be burned.
195      */
196     function burn(uint256 _value) public {
197         require(_value <= balances[msg.sender]);
198         // no need to require value <= totalSupply, since that would imply the
199         // sender's balance is greater than the totalSupply, which *should* be an assertion failure
200         address burner = msg.sender;
201         balances[burner] = balances[burner].sub(_value);
202         totalSupply = totalSupply.sub(_value);
203         emit Burn(burner, _value);
204     }
205 }
206 
207 contract GIRLToken is BurnableToken, DetailedERC20 {
208     uint8 constant DECIMALS = 18;
209     string constant NAME = "GIRL";
210     string constant SYM = "GIRL";
211     uint256 constant MAXGIRLTOKEN = 100 * 10 ** 8 * 10 ** 18;
212 
213     function GIRLToken() DetailedERC20(MAXGIRLTOKEN, NAME, SYM, DECIMALS) public {}
214 }