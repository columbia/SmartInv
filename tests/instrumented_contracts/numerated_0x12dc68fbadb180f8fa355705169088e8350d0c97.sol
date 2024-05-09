1 pragma solidity ^ 0.4.17;
2 /**
3  * @title ERC20Basic
4  * @dev Simpler version of ERC20 interface
5  * @dev see https://github.com/ethereum/EIPs/issues/179
6  */
7 contract ERC20Basic {
8     uint256 public totalSupply;
9 
10     function balanceOf(address who) public constant returns(uint256);
11 
12     function transfer(address to, uint256 value) public returns(bool);
13     event Transfer(address indexed from, address indexed to, uint256 value);
14 }
15 
16 contract Ownable {
17     address public owner;
18     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
19     /**
20      * @dev The Ownable constructor sets the original `owner` of the contract to the sender
21      * account.
22      */
23     function Ownable() public {
24         owner = msg.sender;
25     }
26     /**
27      * @dev Throws if called by any account other than the owner.
28      */
29     modifier onlyOwner() {
30         require(msg.sender == owner);
31         _;
32     }
33     /**
34      * @dev Allows the current owner to transfer control of the contract to a newOwner.
35      * @param newOwner The address to transfer ownership to.
36      */
37     function transferOwnership(address newOwner) onlyOwner public {
38         require(newOwner != address(0));
39         OwnershipTransferred(owner, newOwner);
40         owner = newOwner;
41     }
42 }
43 /**
44  * @title SafeMath
45  * @dev Math operations with safety checks that throw on error
46  */
47 library SafeMath {
48     function mul(uint256 a, uint256 b) internal pure returns(uint256) {
49         uint256 c = a * b;
50         assert(a == 0 || c / a == b);
51         return c;
52     }
53 
54     function div(uint256 a, uint256 b) internal pure returns(uint256) {
55         // assert(b > 0); // Solidity automatically throws when dividing by 0
56         uint256 c = a / b;
57         // assert(a == b * c + a % b); // There is no case in which this doesn't hold
58         return c;
59     }
60 
61     function sub(uint256 a, uint256 b) internal pure returns(uint256) {
62         assert(b <= a);
63         return a - b;
64     }
65 
66     function add(uint256 a, uint256 b) internal pure returns(uint256) {
67         uint256 c = a + b;
68         assert(c >= a);
69         return c;
70     }
71 }
72 /**
73  * @title Basic token
74  * @dev Basic version of StandardToken, with no allowances.
75  */
76 contract SafeBasicToken is ERC20Basic {
77     using SafeMath
78     for uint256;
79     mapping(address => uint256) balances;
80 
81     /**
82      * @dev transfer token for a specified address
83      * @param _to The address to transfer to.
84      * @param _value The amount to be transferred.
85      */
86     function transfer(address _to, uint256 _value) public returns(bool) {
87         require(_to != address(0));
88         // SafeMath.sub will throw if there is not enough balance.
89         balances[msg.sender] = balances[msg.sender].sub(_value);
90         balances[_to] = balances[_to].add(_value);
91         Transfer(msg.sender, _to, _value);
92         return true;
93     }
94     /**
95      * @dev Gets the balance of the specified address.
96      * @param _owner The address to query the the balance of.
97      * @return An uint256 representing the amount owned by the passed address.
98      */
99     function balanceOf(address _owner) public constant returns(uint256 balance) {
100         return balances[_owner];
101     }
102 }
103 /**
104  * @title ERC20 interface
105  * @dev see https://github.com/ethereum/EIPs/issues/20
106  */
107 contract ERC20 is ERC20Basic {
108     function allowance(address owner, address spender) public constant returns(uint256);
109 
110     function transferFrom(address from, address to, uint256 value) public returns(bool);
111 
112     function approve(address spender, uint256 value) public returns(bool);
113     event Approval(address indexed owner, address indexed spender, uint256 value);
114 }
115 /**
116  * @title Standard ERC20 token
117  *
118  * @dev Implementation of the basic standard token.
119  * @dev https://github.com/ethereum/EIPs/issues/20
120  * @dev Based on code by FirstBlood: https://github.com/Firstbloodio/token/blob/master/smart_contract/FirstBloodToken.sol
121  */
122 contract SafeStandardToken is ERC20, SafeBasicToken {
123     mapping(address => mapping(address => uint256)) allowed;
124     /**
125      * @dev Transfer tokens from one address to another
126      * @param _from address The address which you want to send tokens from
127      * @param _to address The address which you want to transfer to
128      * @param _value uint256 the amount of tokens to be transferred
129      */
130     function transferFrom(address _from, address _to, uint256 _value) public returns(bool) {
131         require(_to != address(0));
132         uint256 _allowance = allowed[_from][msg.sender];
133         // Check is not needed because sub(_allowance, _value) will already throw if this condition is not met
134         // require (_value <= _allowance);
135         balances[_from] = balances[_from].sub(_value);
136         balances[_to] = balances[_to].add(_value);
137         allowed[_from][msg.sender] = _allowance.sub(_value);
138         Transfer(_from, _to, _value);
139         return true;
140     }
141     /**
142      * @dev Approve the passed address to spend the specified amount of tokens on behalf of msg.sender.
143      *
144      * Beware that changing an allowance with this method brings the risk that someone may use both the old
145      * and the new allowance by unfortunate transaction ordering. One possible solution to mitigate this
146      * race condition is to first reduce the spender's allowance to 0 and set the desired value afterwards:
147      * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
148      * @param _spender The address which will spend the funds.
149      * @param _value The amount of tokens to be spent.
150      */
151     function approve(address _spender, uint256 _value) public returns(bool) {
152         allowed[msg.sender][_spender] = _value;
153         Approval(msg.sender, _spender, _value);
154         return true;
155     }
156     /**
157      * @dev Function to check the amount of tokens that an owner allowed to a spender.
158      * @param _owner address The address which owns the funds.
159      * @param _spender address The address which will spend the funds.
160      * @return A uint256 specifying the amount of tokens still available for the spender.
161      */
162     function allowance(address _owner, address _spender) public constant returns(uint256 remaining) {
163         return allowed[_owner][_spender];
164     }
165     /**
166      * approve should be called when allowed[_spender] == 0. To increment
167      * allowed value is better to use this function to avoid 2 calls (and wait until
168      * the first transaction is mined)
169      * From MonolithDAO Token.sol
170      */
171     function increaseApproval(address _spender, uint _addedValue) public
172     returns(bool success) 
173     {
174         allowed[msg.sender][_spender] = allowed[msg.sender][_spender].add(_addedValue);
175         Approval(msg.sender, _spender, allowed[msg.sender][_spender]);
176         return true;
177     }
178 
179     function decreaseApproval(address _spender, uint _subtractedValue) public
180     returns(bool success) 
181     {
182         uint oldValue = allowed[msg.sender][_spender];
183         if (_subtractedValue > oldValue) {
184             allowed[msg.sender][_spender] = 0;
185         } else {
186             allowed[msg.sender][_spender] = oldValue.sub(_subtractedValue);
187         }
188         Approval(msg.sender, _spender, allowed[msg.sender][_spender]);
189         return true;
190     }
191 }
192 
193 contract VelocityToken is SafeStandardToken {
194 
195     string public constant name = "Velocity Token";
196     string public constant symbol = "VTN";
197     uint256 public constant decimals = 8;
198     uint256 public constant INITIAL_SUPPLY = 12000000 * (10 ** uint256(decimals));
199 
200     event Burnt(address indexed _from, uint256 _amount);
201 
202     function VelocityToken() public {
203         totalSupply = INITIAL_SUPPLY;
204         balances[msg.sender] = INITIAL_SUPPLY;
205         Transfer(0x0, msg.sender, totalSupply);
206     }
207 
208     function burn(uint256 _value) public returns (bool success) {
209         require(_value <= balances[msg.sender]);
210 
211         balances[msg.sender] = balances[msg.sender].sub(_value);
212         totalSupply = totalSupply.sub(_value);
213 
214         Burnt(msg.sender, _value);
215 
216         return true;
217     }
218 }