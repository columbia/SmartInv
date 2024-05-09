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
53         require(msg.sender == owner);
54         _;
55     }
56 
57     /**
58     * @dev Allows the current owner to transfer control of the contract to a newOwner.
59     * @param newOwner The address to transfer ownership to. 
60     */
61     function transferOwnership(address newOwner) onlyOwner {
62         if (newOwner != address(0)) {
63             owner = newOwner;
64         }
65     }
66 }
67 
68 /**
69  * @title ERC20Basic
70  * @dev Simpler version of ERC20 interface
71  * @dev see https://github.com/ethereum/EIPs/issues/20
72  */
73 contract ERC20Basic {
74     uint256 public totalSupply;
75     function balanceOf(address who) constant returns (uint256);
76     function transfer(address to, uint256 value);
77     event Transfer(address indexed from, address indexed to, uint256 value);
78 }
79 
80 /**
81  * @title ERC20 interface
82  * @dev see https://github.com/ethereum/EIPs/issues/20
83  */
84 contract ERC20 is ERC20Basic {
85     function allowance(address owner, address spender) constant returns (uint256);
86     function transferFrom(address from, address to, uint256 value);
87     function approve(address spender, uint256 value);
88     event Approval(address indexed owner, address indexed spender, uint256 value);
89 }
90 
91 /**
92  * @title Basic token
93  * @dev Basic version of StandardToken, with no allowances. 
94  */
95 contract BasicToken is ERC20Basic, Ownable {
96     using SafeMath for uint256;
97 
98     mapping(address => uint256) balances;
99 
100     /**
101     * @dev transfer token for a specified address
102     * @param _to The address to transfer to.
103     * @param _value The amount to be transferred.
104     */
105     function transfer(address _to, uint256 _value) {
106         balances[msg.sender] = balances[msg.sender].sub(_value);
107         balances[_to] = balances[_to].add(_value);
108         Transfer(msg.sender, _to, _value);
109     }
110 
111     /**
112     * @dev Gets the balance of the specified address.
113     * @param _owner The address to query the the balance of. 
114     * @return An uint256 representing the amount owned by the passed address.
115     */
116     function balanceOf(address _owner) constant returns (uint256 balance) {
117         return balances[_owner];
118     }
119 }
120 
121 /**
122  * @title Standard ERC20 token
123  *
124  * @dev Implementation of the basic standard token.
125  * @dev https://github.com/ethereum/EIPs/issues/20
126  * @dev Based on code by FirstBlood: https://github.com/Firstbloodio/token/blob/master/smart_contract/FirstBloodToken.sol
127  */
128 contract StandardToken is ERC20, BasicToken {
129     mapping (address => mapping (address => uint256)) allowed;
130 
131     /**
132     * @dev Transfer tokens from one address to another
133     * @param _from address The address which you want to send tokens from
134     * @param _to address The address which you want to transfer to
135     * @param _value uint256 the amout of tokens to be transfered
136     */
137     function transferFrom(address _from, address _to, uint256 _value) {
138         var _allowance = allowed[_from][msg.sender];
139 
140         // Check is not needed because sub(_allowance, _value) will already throw if this condition is not met
141         // if (_value > _allowance) throw;
142 
143         balances[_to] = balances[_to].add(_value);
144         balances[_from] = balances[_from].sub(_value);
145         allowed[_from][msg.sender] = _allowance.sub(_value);
146         Transfer(_from, _to, _value);
147     }
148 
149     /**
150     * @dev Aprove the passed address to spend the specified amount of tokens on behalf of msg.sender.
151     * @param _spender The address which will spend the funds.
152     * @param _value The amount of tokens to be spent.
153     */
154     function approve(address _spender, uint256 _value) {
155 
156         // To change the approve amount you first have to reduce the addresses`
157         //  allowance to zero by calling `approve(_spender, 0)` if it is not
158         //  already 0 to mitigate the race condition described here:
159         //  https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
160         require((_value == 0) || (allowed[msg.sender][_spender] == 0));
161         allowed[msg.sender][_spender] = _value;
162         Approval(msg.sender, _spender, _value);
163     }
164 
165     /**
166     * @dev Function to check the amount of tokens that an owner allowed to a spender.
167     * @param _owner address The address which owns the funds.
168     * @param _spender address The address which will spend the funds.
169     * @return A uint256 specifing the amount of tokens still avaible for the spender.
170     */
171     function allowance(address _owner, address _spender) constant returns (uint256 remaining) {
172         return allowed[_owner][_spender];
173     }
174 }
175 
176 /**
177  * @title TKRToken
178  * @dev Very simple ERC20 Token example, where all tokens are pre-assigned to the creator. 
179  * Note they can later distribute these tokens as they wish using `transfer` and other
180  * `StandardToken` functions.
181  */
182 contract TKRToken is StandardToken {
183     event Destroy(address indexed _from, address indexed _to, uint256 _value);
184 
185     string public name = "TKRToken";
186     string public symbol = "TKR";
187     uint256 public decimals = 18;
188     uint256 public initialSupply = 65500000 * 10 ** 18;
189 
190     /**
191     * @dev Contructor that gives the sender all tokens
192     */
193     function TKRToken() {
194         totalSupply = initialSupply;
195         balances[msg.sender] = initialSupply;
196     }
197 
198     /**
199     * @dev Destroys tokens, this process is irrecoverable.
200     * @param _value The amount to destroy.
201     */
202     function destroy(uint256 _value) onlyOwner returns (bool) {
203         balances[msg.sender] = balances[msg.sender].sub(_value);
204         totalSupply = totalSupply.sub(_value);
205         Destroy(msg.sender, 0x0, _value);
206     }
207 }