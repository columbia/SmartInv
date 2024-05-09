1 pragma solidity ^0.4.11;
2 
3 /**
4  * @title SafeMath
5  * @dev Math operations with safety checks that throw on error
6  */
7 library SafeMath {
8     function mul(uint256 a, uint256 b) internal returns (uint256) {
9         uint256 c = a * b;
10         assert(a == 0 || c / a == b);
11         return c;
12     }
13 
14     function div(uint256 a, uint256 b) internal returns (uint256) {
15         // assert(b > 0); // Solidity automatically throws when dividing by 0
16         uint256 c = a / b;
17         // assert(a == b * c + a % b); // There is no case in which this doesn't hold
18         return c;
19     }
20 
21     function sub(uint256 a, uint256 b) internal returns (uint256) {
22         assert(b <= a);
23         return a - b;
24     }
25 
26     function add(uint256 a, uint256 b) internal returns (uint256) {
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
41     /** 
42      * @dev The Ownable constructor sets the original `owner` of the contract to the sender
43      * account.
44      */
45     function Ownable() {
46         owner = msg.sender;
47     }
48 
49     /**
50     * @dev Throws if called by any account other than the owner. 
51     */
52     modifier onlyOwner() {
53         if (msg.sender != owner) {
54             throw;
55         }
56         _;
57     }
58 
59     /**
60     * @dev Allows the current owner to transfer control of the contract to a newOwner.
61     * @param newOwner The address to transfer ownership to. 
62     */
63     function transferOwnership(address newOwner) onlyOwner {
64         if (newOwner != address(0)) {
65             owner = newOwner;
66         }
67     }
68 }
69 
70 /**
71  * @title ERC20Basic
72  * @dev Simpler version of ERC20 interface
73  * @dev see https://github.com/ethereum/EIPs/issues/20
74  */
75 contract ERC20Basic {
76     uint256 public totalSupply;
77     function balanceOf(address who) constant returns (uint256);
78     function transfer(address to, uint256 value);
79     event Transfer(address indexed from, address indexed to, uint256 value);
80 }
81 
82 /**
83  * @title ERC20 interface
84  * @dev see https://github.com/ethereum/EIPs/issues/20
85  */
86 contract ERC20 is ERC20Basic {
87     function allowance(address owner, address spender) constant returns (uint256);
88     function transferFrom(address from, address to, uint256 value);
89     function approve(address spender, uint256 value);
90     event Approval(address indexed owner, address indexed spender, uint256 value);
91 }
92 
93 /**
94  * @title Basic token
95  * @dev Basic version of StandardToken, with no allowances. 
96  */
97 contract BasicToken is ERC20Basic, Ownable {
98     using SafeMath for uint256;
99 
100     mapping(address => uint256) balances;
101 
102     /**
103     * @dev transfer token for a specified address
104     * @param _to The address to transfer to.
105     * @param _value The amount to be transferred.
106     */
107     function transfer(address _to, uint256 _value) {
108         balances[msg.sender] = balances[msg.sender].sub(_value);
109         balances[_to] = balances[_to].add(_value);
110         Transfer(msg.sender, _to, _value);
111     }
112 
113     /**
114     * @dev Gets the balance of the specified address.
115     * @param _owner The address to query the the balance of. 
116     * @return An uint256 representing the amount owned by the passed address.
117     */
118     function balanceOf(address _owner) constant returns (uint256 balance) {
119         return balances[_owner];
120     }
121 }
122 
123 /**
124  * @title Standard ERC20 token
125  *
126  * @dev Implementation of the basic standard token.
127  * @dev https://github.com/ethereum/EIPs/issues/20
128  * @dev Based on code by FirstBlood: https://github.com/Firstbloodio/token/blob/master/smart_contract/FirstBloodToken.sol
129  */
130 contract StandardToken is ERC20, BasicToken {
131     mapping (address => mapping (address => uint256)) allowed;
132 
133     /**
134     * @dev Transfer tokens from one address to another
135     * @param _from address The address which you want to send tokens from
136     * @param _to address The address which you want to transfer to
137     * @param _value uint256 the amout of tokens to be transfered
138     */
139     function transferFrom(address _from, address _to, uint256 _value) {
140         var _allowance = allowed[_from][msg.sender];
141 
142         // Check is not needed because sub(_allowance, _value) will already throw if this condition is not met
143         // if (_value > _allowance) throw;
144 
145         balances[_to] = balances[_to].add(_value);
146         balances[_from] = balances[_from].sub(_value);
147         allowed[_from][msg.sender] = _allowance.sub(_value);
148         Transfer(_from, _to, _value);
149     }
150 
151     /**
152     * @dev Aprove the passed address to spend the specified amount of tokens on behalf of msg.sender.
153     * @param _spender The address which will spend the funds.
154     * @param _value The amount of tokens to be spent.
155     */
156     function approve(address _spender, uint256 _value) {
157 
158         // To change the approve amount you first have to reduce the addresses`
159         //  allowance to zero by calling `approve(_spender, 0)` if it is not
160         //  already 0 to mitigate the race condition described here:
161         //  https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
162         if ((_value != 0) && (allowed[msg.sender][_spender] != 0)) throw;
163 
164         allowed[msg.sender][_spender] = _value;
165         Approval(msg.sender, _spender, _value);
166     }
167 
168     /**
169     * @dev Function to check the amount of tokens that an owner allowed to a spender.
170     * @param _owner address The address which owns the funds.
171     * @param _spender address The address which will spend the funds.
172     * @return A uint256 specifing the amount of tokens still avaible for the spender.
173     */
174     function allowance(address _owner, address _spender) constant returns (uint256 remaining) {
175         return allowed[_owner][_spender];
176     }
177 }
178 
179 /**
180  * @title TKRPToken
181  * @dev Very simple ERC20 Token example, where all tokens are pre-assigned to the creator. 
182  * Note they can later distribute these tokens as they wish using `transfer` and other
183  * `StandardToken` functions.
184  */
185 contract TKRPToken is StandardToken {
186     event Destroy(address indexed _from);
187 
188     string public name = "TKRPToken";
189     string public symbol = "TKRP";
190     uint256 public decimals = 18;
191     uint256 public initialSupply = 500000;
192 
193     /**
194     * @dev Contructor that gives the sender all tokens
195     */
196     function TKRPToken() {
197         totalSupply = initialSupply;
198         balances[msg.sender] = initialSupply;
199     }
200 
201     /**
202     * @dev Destroys tokens from an address, this process is irrecoverable.
203     * @param _from The address to destroy the tokens from.
204     */
205     function destroyFrom(address _from) onlyOwner returns (bool) {
206         uint256 balance = balanceOf(_from);
207         if (balance == 0) throw;
208 
209         balances[_from] = 0;
210         totalSupply = totalSupply.sub(balance);
211 
212         Destroy(_from);
213     }
214 }