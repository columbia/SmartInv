1 pragma solidity ^0.4.17;
2 
3 /**
4  * @title SafeMath
5  * @dev Math operations with safety checks that throw on error
6  */
7 library SafeMath {
8     function mul(uint256 a, uint256 b) internal pure returns (uint256) {
9         uint256 c = a * b;
10         assert(a == 0 || c / a == b);
11         return c;
12     }
13 
14     function div(uint256 a, uint256 b) internal pure returns (uint256) {
15         // assert(b > 0); // Solidity automatically throws when dividing by 0
16         uint256 c = a / b;
17         // assert(a == b * c + a % b); // There is no case in which this doesn't hold
18         return c;
19     }
20 
21     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
22         assert(b <= a);
23         return a - b;
24     }
25 
26     function add(uint256 a, uint256 b) internal pure returns (uint256) {
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
50      * @dev Throws if called by any account other than the owner.
51      */
52     modifier onlyOwner() {
53         require(msg.sender == owner);
54         _;
55     }
56 
57     /**
58      * @dev Allows the current owner to transfer control of the contract to a newOwner.
59      * @param newOwner The address to transfer ownership to.
60      */
61     function transferOwnership(address newOwner) public onlyOwner {
62         if (newOwner != address(0)) {
63             owner = newOwner;
64         }
65     }
66 }
67 
68 /**
69  * @title ERC20Basic
70  * @dev Simpler version of ERC20 interface
71  * @dev see https://github.com/ethereum/EIPs/issues/179
72  */
73 contract ERC20Basic {
74     uint256 public totalSupply;
75     function balanceOf(address who) public view returns (uint256);
76     function transfer(address to, uint256 value) public returns (bool);
77     event Transfer(address indexed from, address indexed to, uint256 value);
78 }
79 
80 /**
81  * @title ERC20 interface
82  * @dev see https://github.com/ethereum/EIPs/issues/20
83  */
84 contract ERC20 is ERC20Basic {
85     function allowance(address owner, address spender) public view returns (uint256);
86     function transferFrom(address from, address to, uint256 value) public returns (bool);
87     function approve(address spender, uint256 value) public returns (bool);
88     event Approval(address indexed owner, address indexed spender, uint256 value);
89 }
90 
91 /**
92  * @title Basic token
93  * @dev Basic version of StandardToken, with no allowances.
94  */
95 contract BasicToken is ERC20Basic {
96     using SafeMath for uint256;
97 
98     mapping(address => uint256) balances;
99 
100     /**
101     * @dev transfer token for a specified address
102     * @param _to The address to transfer to.
103     * @param _value The amount to be transferred.
104     */
105     function transfer(address _to, uint256 _value) public returns (bool) {
106         balances[msg.sender] = balances[msg.sender].sub(_value);
107         balances[_to] = balances[_to].add(_value);
108         Transfer(msg.sender, _to, _value);
109         return true;
110     }
111 
112     /**
113     * @dev Gets the balance of the specified address.
114     * @param _owner The address to query the the balance of.
115     * @return An uint256 representing the amount owned by the passed address.
116     */
117     function balanceOf(address _owner) public view returns (uint256 balance) {
118         return balances[_owner];
119     }
120 }
121 
122 /**
123  * @title Standard ERC20 token
124  *
125  * @dev Implementation of the basic standard token.
126  * @dev https://github.com/ethereum/EIPs/issues/20
127  * @dev Based on code by FirstBlood: https://github.com/Firstbloodio/token/blob/master/smart_contract/FirstBloodToken.sol
128  */
129 contract StandardToken is ERC20, BasicToken {
130 
131     mapping (address => mapping (address => uint256)) allowed;
132 
133 
134     /**
135      * @dev Transfer tokens from one address to another
136      * @param _from address The address which you want to send tokens from
137      * @param _to address The address which you want to transfer to
138      * @param _value uint256 the amout of tokens to be transfered
139      */
140     function transferFrom(address _from, address _to, uint256 _value) public returns (bool) {
141         var _allowance = allowed[_from][msg.sender];
142 
143         // Check is not needed because sub(_allowance, _value) will already throw if this condition is not met
144         // require (_value <= _allowance);
145 
146         balances[_to] = balances[_to].add(_value);
147         balances[_from] = balances[_from].sub(_value);
148         allowed[_from][msg.sender] = _allowance.sub(_value);
149         Transfer(_from, _to, _value);
150         return true;
151     }
152 
153     /**
154      * @dev Aprove the passed address to spend the specified amount of tokens on behalf of msg.sender.
155      * @param _spender The address which will spend the funds.
156      * @param _value The amount of tokens to be spent.
157      */
158     function approve(address _spender, uint256 _value) public returns (bool) {
159 
160         // To change the approve amount you first have to reduce the addresses`
161         //  allowance to zero by calling `approve(_spender, 0)` if it is not
162         //  already 0 to mitigate the race condition described here:
163         //  https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
164         require((_value == 0) || (allowed[msg.sender][_spender] == 0));
165 
166         allowed[msg.sender][_spender] = _value;
167         Approval(msg.sender, _spender, _value);
168         return true;
169     }
170 
171     /**
172      * @dev Function to check the amount of tokens that an owner allowed to a spender.
173      * @param _owner address The address which owns the funds.
174      * @param _spender address The address which will spend the funds.
175      * @return A uint256 specifing the amount of tokens still avaible for the spender.
176      */
177     function allowance(address _owner, address _spender) public view returns (uint256 remaining) {
178         return allowed[_owner][_spender];
179     }
180 
181 }
182 
183 contract TempusPresaleToken is StandardToken, Ownable {
184 
185     string public constant name = "Tempus Presale Token";
186 
187     string public constant symbol = "TPS";
188 
189     uint8 public constant decimals = 18;
190 
191     address public trustedContractAddr;
192 
193     uint public constant INITIAL_SUPPLY = 1200000 * 1 ether;
194 
195     function TempusPresaleToken() {
196         totalSupply = INITIAL_SUPPLY;
197         balances[msg.sender] = INITIAL_SUPPLY;
198     }
199 
200     function setTrustedAddr(address newAddr) public onlyOwner {
201         if (newAddr != address(0)) {
202             trustedContractAddr = newAddr;
203         }
204     }
205 
206     function transferFromTrustedContract(address _to, uint256 _amount) public returns (bool) {
207         require(msg.sender == trustedContractAddr);
208 
209         balances[owner] = balances[owner].sub(_amount);
210         balances[_to] = balances[_to].add(_amount);
211         Transfer(owner, _to, _amount);
212         return true;
213     }
214 }