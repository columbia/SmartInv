1 pragma solidity ^0.4.17;
2 
3 /**
4  * @title SafeMath
5  * @dev Math operations with safety checks that throw on error
6  */
7 library SafeMath {
8     function mul(uint256 a, uint256 b) internal pure returns (uint256) {
9         if (a == 0) {
10             return 0;
11         }
12         uint256 c = a * b;
13         assert(c / a == b);
14         return c;
15     }
16 
17     function div(uint256 a, uint256 b) internal pure returns (uint256) {
18         // assert(b > 0); // Solidity automatically throws when dividing by 0
19         uint256 c = a / b;
20         // assert(a == b * c + a % b); // There is no case in which this doesn't hold
21         return c;
22     }
23 
24     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
25         assert(b <= a);
26         return a - b;
27     }
28 
29     function add(uint256 a, uint256 b) internal pure returns (uint256) {
30         uint256 c = a + b;
31         assert(c >= a);
32         return c;
33     }
34 }
35 
36 /**
37  * @title Ownable
38  * @dev The Ownable contract has an owner address, and provides basic authorization control
39  * functions, this simplifies the implementation of "user permissions".
40  */
41 contract Ownable {
42     address public owner;
43 
44     /**
45       * @dev The Ownable constructor sets the original `owner` of the contract to the sender
46       * account.
47       */
48     function Ownable() public {
49         owner = msg.sender;
50     }
51 
52     /**
53       * @dev Throws if called by any account other than the owner.
54       */
55     modifier onlyOwner() {
56         require(msg.sender == owner);
57         _;
58     }
59 
60     /**
61     * @dev Allows the current owner to transfer control of the contract to a newOwner.
62     * @param newOwner The address to transfer ownership to.
63     */
64     function transferOwnership(address newOwner) public onlyOwner {
65         if (newOwner != address(0)) {
66             owner = newOwner;
67         }
68     }
69 
70 }
71 
72 /**
73  * @title ERC20Basic
74  * @dev Simpler version of ERC20 interface
75  * @dev see https://github.com/ethereum/EIPs/issues/20
76  */
77 contract ERC20Basic {
78     uint public _totalSupply;
79     function totalSupply() public constant returns (uint);
80     function balanceOf(address who) public constant returns (uint);
81     function transfer(address to, uint value) public;
82     event Transfer(address indexed from, address indexed to, uint value);
83 }
84 
85 /**
86  * @title ERC20 interface
87  * @dev see https://github.com/ethereum/EIPs/issues/20
88  */
89 contract ERC20 is ERC20Basic {
90     function allowance(address owner, address spender) public constant returns (uint);
91     function transferFrom(address from, address to, uint value) public;
92     function approve(address spender, uint value) public;
93     event Approval(address indexed owner, address indexed spender, uint value);
94 }
95 
96 /**
97  * @title Basic token
98  * @dev Basic version of StandardToken, with no allowances.
99  */
100 contract BasicToken is Ownable, ERC20Basic {
101     using SafeMath for uint;
102 
103     mapping(address => uint) public balances;
104 
105     /**
106     * @dev Fix for the ERC20 short address attack.
107     */
108     modifier onlyPayloadSize(uint size) {
109         require(!(msg.data.length < size + 4));
110         _;
111     }
112 
113     /**
114     * @dev transfer token for a specified address
115     * @param _to The address to transfer to.
116     * @param _value The amount to be transferred.
117     */
118     function transfer(address _to, uint _value) public onlyPayloadSize(2 * 32) {
119         uint sendAmount = _value;
120         balances[msg.sender] = balances[msg.sender].sub(_value);
121         balances[_to] = balances[_to].add(sendAmount);
122         Transfer(msg.sender, _to, sendAmount);
123     }
124 
125     /**
126     * @dev Gets the balance of the specified address.
127     * @param _owner The address to query the the balance of.
128     * @return An uint representing the amount owned by the passed address.
129     */
130     function balanceOf(address _owner) public constant returns (uint balance) {
131         return balances[_owner];
132     }
133 
134 }
135 
136 /**
137  * @title Standard ERC20 token
138  *
139  * @dev Implementation of the basic standard token.
140  * @dev https://github.com/ethereum/EIPs/issues/20
141  * @dev Based oncode by FirstBlood: https://github.com/Firstbloodio/token/blob/master/smart_contract/FirstBloodToken.sol
142  */
143 contract StandardToken is BasicToken, ERC20 {
144 
145     mapping (address => mapping (address => uint)) public allowed;
146 
147     uint public constant MAX_UINT = 2**256 - 1;
148 
149     /**
150     * @dev Transfer tokens from one address to another
151     * @param _from address The address which you want to send tokens from
152     * @param _to address The address which you want to transfer to
153     * @param _value uint the amount of tokens to be transferred
154     */
155     function transferFrom(address _from, address _to, uint _value) public onlyPayloadSize(3 * 32) {
156         var _allowance = allowed[_from][msg.sender];
157 
158         // Check is not needed because sub(_allowance, _value) will already throw if this condition is not met
159         // if (_value > _allowance) throw;
160 
161         if (_allowance < MAX_UINT) {
162             allowed[_from][msg.sender] = _allowance.sub(_value);
163         }
164         uint sendAmount = _value;
165         balances[_from] = balances[_from].sub(_value);
166         balances[_to] = balances[_to].add(sendAmount);
167         Transfer(_from, _to, sendAmount);
168     }
169 
170     /**
171     * @dev Approve the passed address to spend the specified amount of tokens on behalf of msg.sender.
172     * @param _spender The address which will spend the funds.
173     * @param _value The amount of tokens to be spent.
174     */
175     function approve(address _spender, uint _value) public onlyPayloadSize(2 * 32) {
176 
177         // To change the approve amount you first have to reduce the addresses`
178         //  allowance to zero by calling `approve(_spender, 0)` if it is not
179         //  already 0 to mitigate the race condition described here:
180         //  https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
181         require(!((_value != 0) && (allowed[msg.sender][_spender] != 0)));
182 
183         allowed[msg.sender][_spender] = _value;
184         Approval(msg.sender, _spender, _value);
185     }
186 
187     /**
188     * @dev Function to check the amount of tokens than an owner allowed to a spender.
189     * @param _owner address The address which owns the funds.
190     * @param _spender address The address which will spend the funds.
191     * @return A uint specifying the amount of tokens still available for the spender.
192     */
193     function allowance(address _owner, address _spender) public constant returns (uint remaining) {
194         return allowed[_owner][_spender];
195     }
196 
197 }
198 
199 contract OurToken is StandardToken {
200 
201     string public name;
202     string public symbol;
203     uint public decimals;
204 
205     //  The contract can be initialized with a number of tokens
206     //  All the tokens are deposited to the owner address
207     //
208     // @param _balance Initial supply of the contract
209     // @param _name Token Name
210     // @param _symbol Token symbol
211     function OurToken(uint _initialSupply, string _name, string _symbol) public {
212         _totalSupply = _initialSupply;
213         name = _name;
214         symbol = _symbol;
215         decimals = 0;
216         balances[owner] = _initialSupply;
217     }
218 
219     function totalSupply() public constant returns (uint) {
220         return _totalSupply;
221     }
222 
223     // Issue a new amount of tokens
224     // these tokens are deposited into the owner address
225     //
226     // @param _amount Number of tokens to be issued
227     function issue(uint amount) public onlyOwner {
228         require(_totalSupply + amount > _totalSupply);
229         require(balances[owner] + amount > balances[owner]);
230 
231         balances[owner] += amount;
232         _totalSupply += amount;
233         Issue(amount);
234     }
235 
236     // Redeem tokens.
237     // These tokens are withdrawn from the owner address
238     // if the balance must be enough to cover the redeem
239     // or the call will fail.
240     // @param _amount Number of tokens to be issued
241     function redeem(uint amount) public onlyOwner {
242         require(_totalSupply >= amount);
243         require(balances[owner] >= amount);
244 
245         _totalSupply -= amount;
246         balances[owner] -= amount;
247         Redeem(amount);
248     }
249 
250 
251     // Called when new token are issued
252     event Issue(uint amount);
253 
254     // Called when tokens are redeemed
255     event Redeem(uint amount);
256 }