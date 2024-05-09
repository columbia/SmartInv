1 pragma solidity ^0.4.18;
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
44     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
45 
46     /**
47      * @dev The Ownable constructor sets the original `owner` of the contract to the sender
48      * account.
49      */
50     function Ownable() public {
51         owner = msg.sender;
52     }
53     /**
54      * @dev Throws if called by any account other than the owner.
55      */
56     modifier onlyOwner() {
57         require(msg.sender == owner);
58         _;
59     }
60 
61     /**
62      * @dev Allows the current owner to transfer control of the contract to a newOwner.
63      * @param newOwner The address to transfer ownership to.
64      */
65     function transferOwnership(address newOwner) public onlyOwner {
66         require(newOwner != address(0));
67         OwnershipTransferred(owner, newOwner);
68         owner = newOwner;
69     }
70 }
71 
72 /**
73  * @title ERC20Basic
74  * @dev Simpler version of ERC20 interface
75  * @dev see https://github.com/ethereum/EIPs/issues/179
76  */
77 contract ERC20Basic {
78     uint256 public totalSupply;
79     function balanceOf(address who) public view returns (uint256);
80     function transfer(address to, uint256 value) public returns (bool);
81     event Transfer(address indexed from, address indexed to, uint256 value);
82 }
83 
84 /**
85  * @title ERC20 interface
86  * @dev see https://github.com/ethereum/EIPs/issues/20
87  */
88 contract ERC20 is ERC20Basic {
89     function allowance(address owner, address spender) public view returns (uint256);
90     function transferFrom(address from, address to, uint256 value) public returns (bool);
91     function approve(address spender, uint256 value) public returns (bool);
92     event Approval(address indexed owner, address indexed spender, uint256 value);
93 }
94 
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
110     function transfer(address _to, uint256 _value) public returns (bool) {
111         require(_to != address(0));
112         require(_value <= balances[msg.sender]);
113 
114         // SafeMath.sub will throw if there is not enough balance.
115         balances[msg.sender] = balances[msg.sender].sub(_value);
116         balances[_to] = balances[_to].add(_value);
117         Transfer(msg.sender, _to, _value);
118         return true;
119     }
120 
121     /**
122     * @dev Gets the balance of the specified address.
123     * @param _owner The address to query the the balance of.
124     * @return An uint256 representing the amount owned by the passed address.
125     */
126     function balanceOf(address _owner) public view returns (uint256 balance) {
127         return balances[_owner];
128     }
129 
130 }
131 
132 /**
133  * @title Standard ERC20 token
134  *
135  * @dev Implementation of the basic standard token.
136  * @dev https://github.com/ethereum/EIPs/issues/20
137  * @dev Based on code by FirstBlood: https://github.com/Firstbloodio/token/blob/master/smart_contract/FirstBloodToken.sol
138  */
139 contract StandardToken is ERC20, BasicToken {
140 
141     mapping(address => mapping(address => uint256)) internal allowed;
142 
143 
144     /**
145      * @dev Transfer tokens from one address to another
146      * @param _from address The address which you want to send tokens from
147      * @param _to address The address which you want to transfer to
148      * @param _value uint256 the amount of tokens to be transferred
149      */
150     function transferFrom(address _from, address _to, uint256 _value) public returns (bool) {
151         require(_to != address(0));
152         require(_value <= balances[_from]);
153         require(_value <= allowed[_from][msg.sender]);
154 
155         balances[_from] = balances[_from].sub(_value);
156         balances[_to] = balances[_to].add(_value);
157         allowed[_from][msg.sender] = allowed[_from][msg.sender].sub(_value);
158         Transfer(_from, _to, _value);
159         return true;
160     }
161 
162     /**
163      * @dev Approve the passed address to spend the specified amount of tokens on behalf of msg.sender.
164      *
165      * Beware that changing an allowance with this method brings the risk that someone may use both the old
166      * and the new allowance by unfortunate transaction ordering. One possible solution to mitigate this
167      * race condition is to first reduce the spender's allowance to 0 and set the desired value afterwards:
168      * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
169      * @param _spender The address which will spend the funds.
170      * @param _value The amount of tokens to be spent.
171      */
172     function approve(address _spender, uint256 _value) public returns (bool) {
173         allowed[msg.sender][_spender] = _value;
174         Approval(msg.sender, _spender, _value);
175         return true;
176     }
177 
178     /**
179      * @dev Function to check the amount of tokens that an owner allowed to a spender.
180      * @param _owner address The address which owns the funds.
181      * @param _spender address The address which will spend the funds.
182      * @return A uint256 specifying the amount of tokens still available for the spender.
183      */
184     function allowance(address _owner, address _spender) public view returns (uint256 remaining) {
185         return allowed[_owner][_spender];
186     }
187 
188     /**
189      * approve should be called when allowed[_spender] == 0. To increment
190      * allowed value is better to use this function to avoid 2 calls (and wait until
191      * the first transaction is mined)
192      * From MonolithDAO Token.sol
193      */
194     function increaseApproval (address _spender, uint _addedValue) public returns (bool success) {
195         allowed[msg.sender][_spender] = allowed[msg.sender][_spender].add(_addedValue);
196         Approval(msg.sender, _spender, allowed[msg.sender][_spender]);
197         return true;
198     }
199 
200     function decreaseApproval (address _spender, uint _subtractedValue) public returns (bool success) {
201         uint oldValue = allowed[msg.sender][_spender];
202         if (_subtractedValue > oldValue) {
203             allowed[msg.sender][_spender] = 0;
204         } else {
205             allowed[msg.sender][_spender] = oldValue.sub(_subtractedValue);
206         }
207         Approval(msg.sender, _spender, allowed[msg.sender][_spender]);
208         return true;
209     }
210 
211 }
212 
213 contract ZmineToken is StandardToken, Ownable {
214     
215     string public name = "ZMINE Token";
216     string public symbol = "ZMN";
217     uint public decimals = 18;
218     
219     uint256 public totalSupply = 1000000000 ether; // 1,000,000,000 ^ 18
220     
221     function ZmineToken() public {
222         balances[owner] = totalSupply;
223     }
224     
225     /**
226      * burn token if token is not sold out after ico
227      */
228     function burn(uint _amount) public onlyOwner {
229         require(balances[owner] >= _amount);
230         balances[owner] = balances[owner] - _amount;
231         totalSupply = totalSupply - _amount;
232     }
233 }