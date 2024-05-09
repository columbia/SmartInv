1 pragma solidity ^0.4.15;
2 
3 /**
4  * @title SafeMath
5  * @dev Math operations with safety checks that throw on error
6  */
7 library SafeMath {
8     function mul(uint256 a, uint256 b) internal constant returns (uint256) {
9         uint256 c = a * b;
10         assert(a == 0 || c / a == b);
11         return c;
12     }
13 
14     function div(uint256 a, uint256 b) internal constant returns (uint256) {
15         // assert(b > 0); // Solidity automatically throws when dividing by 0
16         uint256 c = a / b;
17         // assert(a == b * c + a % b); // There is no case in which this doesn't hold
18         return c;
19     }
20 
21     function sub(uint256 a, uint256 b) internal constant returns (uint256) {
22         assert(b <= a);
23         return a - b;
24     }
25 
26     function add(uint256 a, uint256 b) internal constant returns (uint256) {
27         uint256 c = a + b;
28         assert(c >= a);
29         return c;
30     }
31 }
32 
33 /**
34  * @title Ownable
35  * @dev The Ownable contract has an owner address, and provides basic authorization control
36  * functions, this simplifies the implementation of "user permissions".
37  */
38 contract Ownable {
39     address public owner;
40 
41 
42     /**
43      * @dev The Ownable constructor sets the original `owner` of the contract to the sender
44      * account.
45      */
46     function Ownable() {
47         owner = msg.sender;
48     }
49 
50 
51     /**
52      * @dev Throws if called by any account other than the owner.
53      */
54     modifier onlyOwner() {
55         require(msg.sender == owner);
56         _;
57     }
58 
59 
60     /**
61      * @dev Allows the current owner to transfer control of the contract to a newOwner.
62      * @param newOwner The address to transfer ownership to.
63      */
64     function transferOwnership(address newOwner) onlyOwner {
65         if (newOwner != address(0)) {
66             owner = newOwner;
67         }
68     }
69 
70 }
71 
72 
73 /**
74  * @title ERC20Basic
75  * @dev Simpler version of ERC20 interface
76  * @dev see https://github.com/ethereum/EIPs/issues/179
77  */
78 contract ERC20Basic {
79     uint256 public totalSupply;
80     function balanceOf(address who) constant returns (uint256);
81     function transfer(address to, uint256 value) returns (bool);
82     event Transfer(address indexed from, address indexed to, uint256 value);
83 }
84 
85 /**
86  * @title ERC20 interface
87  * @dev see https://github.com/ethereum/EIPs/issues/20
88  */
89 contract ERC20 is ERC20Basic {
90     function allowance(address owner, address spender) constant returns (uint256);
91     function transferFrom(address from, address to, uint256 value) returns (bool);
92     function approve(address spender, uint256 value) returns (bool);
93     event Approval(address indexed owner, address indexed spender, uint256 value);
94 }
95 
96 /**
97  * @title Basic token
98  * @dev Basic version of StandardToken, with no allowances.
99  */
100 contract BasicToken is ERC20Basic {
101     using SafeMath for uint256;
102 
103     mapping(address => uint256) balances;
104 
105     /**
106     * @dev transfer token for a specified address
107     * @param _to The address to transfer to.
108     * @param _value The amount to be transferred.
109     */
110     function transfer(address _to, uint256 _value) returns (bool) {
111         balances[msg.sender] = balances[msg.sender].sub(_value);
112         balances[_to] = balances[_to].add(_value);
113         Transfer(msg.sender, _to, _value);
114         return true;
115     }
116 
117     /**
118     * @dev Gets the balance of the specified address.
119     * @param _owner The address to query the the balance of.
120     * @return An uint256 representing the amount owned by the passed address.
121     */
122     function balanceOf(address _owner) constant returns (uint256 balance) {
123         return balances[_owner];
124     }
125 
126 }
127 
128 /**
129  * @title Standard ERC20 token
130  *
131  * @dev Implementation of the basic standard token.
132  * @dev https://github.com/ethereum/EIPs/issues/20
133  * @dev Based on code by FirstBlood: https://github.com/Firstbloodio/token/blob/master/smart_contract/FirstBloodToken.sol
134  */
135 contract StandardToken is ERC20, BasicToken {
136 
137     mapping (address => mapping (address => uint256)) allowed;
138 
139 
140     /**
141      * @dev Transfer tokens from one address to another
142      * @param _from address The address which you want to send tokens from
143      * @param _to address The address which you want to transfer to
144      * @param _value uint256 the amout of tokens to be transfered
145      */
146     function transferFrom(address _from, address _to, uint256 _value) returns (bool) {
147         var _allowance = allowed[_from][msg.sender];
148 
149         // Check is not needed because sub(_allowance, _value) will already throw if this condition is not met
150         // require (_value <= _allowance);
151 
152         balances[_to] = balances[_to].add(_value);
153         balances[_from] = balances[_from].sub(_value);
154         allowed[_from][msg.sender] = _allowance.sub(_value);
155         Transfer(_from, _to, _value);
156         return true;
157     }
158 
159     /**
160      * @dev Aprove the passed address to spend the specified amount of tokens on behalf of msg.sender.
161      * @param _spender The address which will spend the funds.
162      * @param _value The amount of tokens to be spent.
163      */
164     function approve(address _spender, uint256 _value) returns (bool) {
165 
166         // To change the approve amount you first have to reduce the addresses`
167         //  allowance to zero by calling `approve(_spender, 0)` if it is not
168         //  already 0 to mitigate the race condition described here:
169         //  https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
170         require((_value == 0) || (allowed[msg.sender][_spender] == 0));
171 
172         allowed[msg.sender][_spender] = _value;
173         Approval(msg.sender, _spender, _value);
174         return true;
175     }
176 
177     /**
178      * @dev Function to check the amount of tokens that an owner allowed to a spender.
179      * @param _owner address The address which owns the funds.
180      * @param _spender address The address which will spend the funds.
181      * @return A uint256 specifing the amount of tokens still avaible for the spender.
182      */
183     function allowance(address _owner, address _spender) constant returns (uint256 remaining) {
184         return allowed[_owner][_spender];
185     }
186 
187 }
188 
189 contract Iq300Token is StandardToken, Ownable {
190 
191     string public constant name = "IQ300 Coin";
192 
193     string public constant symbol = "IQC";
194 
195     uint32 public constant decimals = 18;
196 
197     address public trustedContractAddr;
198 
199     event Mint(address indexed to, uint256 amount);
200     event MintFinished();
201 
202     bool public mintingFinished = false;
203 
204 
205     modifier canMint() {
206         require(!mintingFinished);
207         _;
208     }
209 
210     /**
211      * @dev Function to stop minting new tokens.
212      * @return True if the operation was successful.
213      */
214     function finishMinting() onlyOwner returns (bool) {
215         mintingFinished = true;
216         MintFinished();
217         return true;
218     }
219 
220     /**
221      * @dev Function to mint tokens
222      * @param _to The address that will recieve the minted tokens.
223      * @param _amount The amount of tokens to mint.
224      * @return A boolean that indicates if the operation was successful.
225      */
226     function mint(address _to, uint256 _amount) onlyOwner canMint returns (bool) {
227         return _mint(_to, _amount);
228     }
229 
230 
231     function setTrustedMinterAddr(address newAddr) onlyOwner {
232         if (newAddr != address(0)) {
233             trustedContractAddr = newAddr;
234         }
235     }
236 
237     function mintFromTrustedContract(address _to, uint256 _amount) canMint returns (bool) {
238         require(msg.sender == trustedContractAddr);
239 
240         return _mint(_to, _amount);
241     }
242 
243     function _mint(address _to, uint256 _amount) private canMint returns (bool) {
244         totalSupply = totalSupply.add(_amount);
245         balances[_to] = balances[_to].add(_amount);
246         Mint(_to, _amount);
247         return true;
248     }
249 }