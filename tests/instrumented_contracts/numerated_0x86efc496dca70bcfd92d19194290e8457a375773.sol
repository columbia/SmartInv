1 /**
2  *Submitted for verification at Etherscan.io on 2020-05-06
3 */
4 
5 pragma solidity ^0.4.17;
6 
7 /**
8  * @title SafeMath
9  * @dev Math operations with safety checks that throw on error
10  */
11 library SafeMath {
12     function mul(uint256 a, uint256 b) internal pure returns (uint256) {
13         if (a == 0) {
14             return 0;
15         }
16         uint256 c = a * b;
17         assert(c / a == b);
18         return c;
19     }
20 
21     function div(uint256 a, uint256 b) internal pure returns (uint256) {
22         // assert(b > 0); // Solidity automatically throws when dividing by 0
23         uint256 c = a / b;
24         // assert(a == b * c + a % b); // There is no case in which this doesn't hold
25         return c;
26     }
27 
28     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
29         assert(b <= a);
30         return a - b;
31     }
32 
33     function add(uint256 a, uint256 b) internal pure returns (uint256) {
34         uint256 c = a + b;
35         assert(c >= a);
36         return c;
37     }
38 }
39 
40 /**
41  * @title Ownable
42  * @dev The Ownable contract has an owner address, and provides basic authorization control
43  * functions, this simplifies the implementation of "user permissions".
44  */
45 contract Ownable {
46     address public owner;
47 
48     /**
49       * @dev The Ownable constructor sets the original `owner` of the contract to the sender
50       * account.
51       */
52     function Ownable() public {
53         owner = msg.sender;
54     }
55 
56     /**
57       * @dev Throws if called by any account other than the owner.
58       */
59     modifier onlyOwner() {
60         require(msg.sender == owner);
61         _;
62     }
63 
64     /**
65     * @dev Allows the current owner to transfer control of the contract to a newOwner.
66     * @param newOwner The address to transfer ownership to.
67     */
68     function transferOwnership(address newOwner) public onlyOwner {
69         if (newOwner != address(0)) {
70             owner = newOwner;
71         }
72     }
73 
74 }
75 
76 /**
77  * @title ERC20Basic
78  * @dev Simpler version of ERC20 interface
79  * @dev see https://github.com/ethereum/EIPs/issues/20
80  */
81 contract ERC20Basic {
82     uint public _totalSupply;
83     function totalSupply() public constant returns (uint);
84     function balanceOf(address who) public constant returns (uint);
85     function transfer(address to, uint value) public;
86     event Transfer(address indexed from, address indexed to, uint value);
87 }
88 
89 /**
90  * @title ERC20 interface
91  * @dev see https://github.com/ethereum/EIPs/issues/20
92  */
93 contract ERC20 is ERC20Basic {
94     function allowance(address owner, address spender) public constant returns (uint);
95     function transferFrom(address from, address to, uint value) public;
96     function approve(address spender, uint value) public;
97     event Approval(address indexed owner, address indexed spender, uint value);
98 }
99 
100 /**
101  * @title Basic token
102  * @dev Basic version of StandardToken, with no allowances.
103  */
104 contract BasicToken is Ownable, ERC20Basic {
105     using SafeMath for uint;
106 
107     mapping(address => uint) public balances;
108 
109     /**
110     * @dev Fix for the ERC20 short address attack.
111     */
112     modifier onlyPayloadSize(uint size) {
113         require(!(msg.data.length < size + 4));
114         _;
115     }
116 
117     /**
118     * @dev transfer token for a specified address
119     * @param _to The address to transfer to.
120     * @param _value The amount to be transferred.
121     */
122     function transfer(address _to, uint _value) public onlyPayloadSize(2 * 32) {
123         uint sendAmount = _value;
124         balances[msg.sender] = balances[msg.sender].sub(_value);
125         balances[_to] = balances[_to].add(sendAmount);
126         Transfer(msg.sender, _to, sendAmount);
127     }
128 
129     /**
130     * @dev Gets the balance of the specified address.
131     * @param _owner The address to query the the balance of.
132     * @return An uint representing the amount owned by the passed address.
133     */
134     function balanceOf(address _owner) public constant returns (uint balance) {
135         return balances[_owner];
136     }
137 
138 }
139 
140 /**
141  * @title Standard ERC20 token
142  *
143  * @dev Implementation of the basic standard token.
144  * @dev https://github.com/ethereum/EIPs/issues/20
145  * @dev Based oncode by FirstBlood: https://github.com/Firstbloodio/token/blob/master/smart_contract/FirstBloodToken.sol
146  */
147 contract StandardToken is BasicToken, ERC20 {
148 
149     mapping (address => mapping (address => uint)) public allowed;
150 
151     uint public constant MAX_UINT = 2**256 - 1;
152 
153     /**
154     * @dev Transfer tokens from one address to another
155     * @param _from address The address which you want to send tokens from
156     * @param _to address The address which you want to transfer to
157     * @param _value uint the amount of tokens to be transferred
158     */
159     function transferFrom(address _from, address _to, uint _value) public onlyPayloadSize(3 * 32) {
160         var _allowance = allowed[_from][msg.sender];
161 
162         // Check is not needed because sub(_allowance, _value) will already throw if this condition is not met
163         // if (_value > _allowance) throw;
164 
165         if (_allowance < MAX_UINT) {
166             allowed[_from][msg.sender] = _allowance.sub(_value);
167         }
168         uint sendAmount = _value;
169         balances[_from] = balances[_from].sub(_value);
170         balances[_to] = balances[_to].add(sendAmount);
171         Transfer(_from, _to, sendAmount);
172     }
173 
174     /**
175     * @dev Approve the passed address to spend the specified amount of tokens on behalf of msg.sender.
176     * @param _spender The address which will spend the funds.
177     * @param _value The amount of tokens to be spent.
178     */
179     function approve(address _spender, uint _value) public onlyPayloadSize(2 * 32) {
180 
181         // To change the approve amount you first have to reduce the addresses`
182         //  allowance to zero by calling `approve(_spender, 0)` if it is not
183         //  already 0 to mitigate the race condition described here:
184         //  https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
185         require(!((_value != 0) && (allowed[msg.sender][_spender] != 0)));
186 
187         allowed[msg.sender][_spender] = _value;
188         Approval(msg.sender, _spender, _value);
189     }
190 
191     /**
192     * @dev Function to check the amount of tokens than an owner allowed to a spender.
193     * @param _owner address The address which owns the funds.
194     * @param _spender address The address which will spend the funds.
195     * @return A uint specifying the amount of tokens still available for the spender.
196     */
197     function allowance(address _owner, address _spender) public constant returns (uint remaining) {
198         return allowed[_owner][_spender];
199     }
200 
201 }
202 
203 contract OurToken is StandardToken {
204 
205     string public name;
206     string public symbol;
207     uint public decimals;
208 
209     //  The contract can be initialized with a number of tokens
210     //  All the tokens are deposited to the owner address
211     //
212     // @param _balance Initial supply of the contract
213     // @param _name Token Name
214     // @param _symbol Token symbol
215     function OurToken(uint _initialSupply, string _name, string _symbol) public {
216         _totalSupply = _initialSupply;
217         name = _name;
218         symbol = _symbol;
219         decimals = 0;
220         balances[owner] = _initialSupply;
221     }
222 
223     function totalSupply() public constant returns (uint) {
224         return _totalSupply;
225     }
226 }