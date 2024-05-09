1 pragma solidity ^0.5.8;
2 
3 /**
4  * @title ERC20Basic
5  * @dev Simpler version of ERC20 interface
6  * @dev see https://github.com/ethereum/EIPs/issues/179
7  */
8 contract ERC20Basic {
9     function totalSupply() public view returns (uint256);
10     function balanceOf(address who) public view returns (uint256);
11     function transfer(address to, uint256 value) public returns (bool);
12     event Transfer(address indexed from, address indexed to, uint256 value);
13     event MintCoin(address indexed to, uint256 value);
14 }
15 /**
16  * @title SafeMath
17  * @dev Math operations with safety checks that throw on error
18  */
19 library SafeMath {
20     /**
21      * @dev Multiplies two numbers, throws on overflow.
22      */
23     function mul(uint256 a, uint256 b) internal pure returns (uint256) {
24         if (a == 0) {
25             return 0;
26         }
27         uint256 c = a * b;
28         assert(c / a == b);
29         return c;
30     }
31     /**
32      * @dev Integer division of two numbers, truncating the quotient.
33      */
34     function div(uint256 a, uint256 b) internal pure returns (uint256) {
35         // assert(b > 0); // Solidity automatically throws when dividing by 0
36         uint256 c = a / b;
37         // assert(a == b * c + a % b); // There is no case in which this doesn't hold
38         return c;
39     }
40     /**
41      * @dev Subtracts two numbers, throws on overflow (i.e. if subtrahend is greater than minuend).
42      */
43     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
44         assert(b <= a);
45         return a - b;
46     }
47     /**
48      * @dev Adds two numbers, throws on overflow.
49      */
50     function add(uint256 a, uint256 b) internal pure returns (uint256) {
51         uint256 c = a + b;
52         assert(c >= a);
53         return c;
54     }
55 }
56 
57 contract Ownable {
58     address public owner;
59 
60     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
61 
62     /**
63      * @dev The Ownable constructor sets the original `owner` of the contract to the sender
64      * account.
65      */
66     constructor() public {
67         owner = msg.sender;
68     }
69 
70     /**
71      * @dev Throws if called by any account other than the owner.
72      */
73     modifier onlyOwner() {
74         require(msg.sender == owner);
75         _;
76     }
77 
78     /**
79      * @dev Allows the current owner to transfer control of the contract to a newOwner.
80      * @param _newOwner The address to transfer ownership to.
81      */
82     function transferOwnership(address _newOwner) public onlyOwner {
83         _transferOwnership(_newOwner);
84     }
85 
86     /**
87      * @dev Transfers control of the contract to a newOwner.
88      * @param _newOwner The address to transfer ownership to.
89      */
90     function _transferOwnership(address _newOwner) internal {
91         require(_newOwner != address(0));
92         emit OwnershipTransferred(owner, _newOwner);
93         owner = _newOwner;
94     }
95 }
96 /**
97  * @title Basic token
98  * @dev Basic version of StandardToken, with no allowances.
99  */
100 contract BasicToken is ERC20Basic, Ownable {
101     using SafeMath for uint256;
102     mapping(address => uint256) balances;
103     uint256 totalSupply_;
104 
105     /**
106      * @dev total number of tokens in existence
107      */
108     function totalSupply() public view returns (uint256) {
109         return totalSupply_;
110     }
111 
112     /**
113      * @dev transfer token for a specified address
114      * @param _to The address to transfer to.
115      * @param _value The amount to be transferred.
116      */
117     function transfer(address _to, uint256 _value) public returns (bool) {
118         require(_to != address(0));
119         require(_value <= balances[msg.sender]);
120         // SafeMath.sub will throw if there is not enough balance.
121         balances[msg.sender] = balances[msg.sender].sub(_value);
122         balances[_to] = balances[_to].add(_value);
123         emit Transfer(msg.sender, _to, _value);
124         return true;
125     }
126     /**
127      * @dev Gets the balance of the specified address.
128      * @param _owner The address to query the the balance of.
129      * @return An uint256 representing the amount owned by the passed address.
130      */
131     function balanceOf(address _owner) public view returns (uint256) {
132         return balances[_owner];
133     }
134 }
135 /**
136  * @title ERC20 interface
137  * @dev see https://github.com/ethereum/EIPs/issues/20
138  */
139 contract ERC20 is ERC20Basic {
140     function allowance(address owner, address spender) public view returns (uint256);
141     function transferFrom(address from, address to, uint256 value) public returns (bool);
142     function approve(address spender, uint256 value) public returns (bool);
143     event Approval(address indexed owner, address indexed spender, uint256 value);
144 }
145 /**
146  * @title Standard ERC20 token
147  *
148  * @dev Implementation of the basic standard token.
149  * @dev https://github.com/ethereum/EIPs/issues/20
150  * @dev Based on code by FirstBlood: https://github.com/Firstbloodio/token/blob/master/smart_contract/FirstBloodToken.sol
151  */
152 contract StandardToken is ERC20, BasicToken {
153     uint public constant MAX_UINT = 2**256 - 1;
154 
155     mapping (address => mapping (address => uint256)) internal allowed;
156 
157     /**
158      * @dev Transfer tokens from one address to another
159      * @param _from address The address which you want to send tokens from
160      * @param _to address The address which you want to transfer to
161      * @param _value uint256 the amount of tokens to be transferred
162      */
163     function transferFrom(address _from, address _to, uint256 _value) public returns (bool) {
164         require(_to != address(0));
165         require(_value <= balances[_from]);
166         require(_value <= allowed[_from][msg.sender]);
167         balances[_from] = balances[_from].sub(_value);
168         balances[_to] = balances[_to].add(_value);
169 
170         /// an allowance of MAX_UINT represents an unlimited allowance.
171         /// @dev see https://github.com/ethereum/EIPs/issues/717
172         if (allowed[_from][msg.sender] < MAX_UINT) {
173             allowed[_from][msg.sender] = allowed[_from][msg.sender].sub(_value);
174         }
175         emit Transfer(_from, _to, _value);
176         return true;
177     }
178     /**
179      * @dev Approve the passed address to spend the specified amount of tokens on behalf of msg.sender.
180      *
181      * Beware that changing an allowance with this method brings the risk that someone may use both the old
182      * and the new allowance by unfortunate transaction ordering. One possible solution to mitigate this
183      * race condition is to first reduce the spender's allowance to 0 and set the desired value afterwards:
184      * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
185      * @param _spender The address which will spend the funds.
186      * @param _value The amount of tokens to be spent.
187      */
188     function approve(address _spender, uint256 _value) public returns (bool) {
189         allowed[msg.sender][_spender] = _value;
190         emit Approval(msg.sender, _spender, _value);
191         return true;
192     }
193     /**
194      * @dev Function to check the amount of tokens that an owner allowed to a spender.
195      * @param _owner address The address which owns the funds.
196      * @param _spender address The address which will spend the funds.
197      * @return A uint256 specifying the amount of tokens still available for the spender.
198      */
199     function allowance(address _owner, address _spender) public view returns (uint256) {
200         return allowed[_owner][_spender];
201     }
202     /**
203      * @dev Increase the amount of tokens that an owner allowed to a spender.
204      *
205      * approve should be called when allowed[_spender] == 0. To increment
206      * allowed value is better to use this function to avoid 2 calls (and wait until
207      * the first transaction is mined)
208      * From MonolithDAO Token.sol
209      * @param _spender The address which will spend the funds.
210      * @param _addedValue The amount of tokens to increase the allowance by.
211      */
212     function increaseApproval(address _spender, uint _addedValue) public returns (bool) {
213         allowed[msg.sender][_spender] = allowed[msg.sender][_spender].add(_addedValue);
214         emit Approval(msg.sender, _spender, allowed[msg.sender][_spender]);
215         return true;
216     }
217     /**
218      * @dev Decrease the amount of tokens that an owner allowed to a spender.
219      *
220      * approve should be called when allowed[_spender] == 0. To decrement
221      * allowed value is better to use this function to avoid 2 calls (and wait until
222      * the first transaction is mined)
223      * From MonolithDAO Token.sol
224      * @param _spender The address which will spend the funds.
225      * @param _subtractedValue The amount of tokens to decrease the allowance by.
226      */
227     function decreaseApproval(address _spender, uint _subtractedValue) public returns (bool) {
228         uint oldValue = allowed[msg.sender][_spender];
229         if (_subtractedValue > oldValue) {
230             allowed[msg.sender][_spender] = 0;
231         } else {
232             allowed[msg.sender][_spender] = oldValue.sub(_subtractedValue);
233         }
234         emit Approval(msg.sender, _spender, allowed[msg.sender][_spender]);
235         return true;
236     }
237 }
238 
239 contract VRBankToken is StandardToken {
240     using SafeMath for uint256;
241 
242     string     public name = "VR Bank Token";
243     string     public symbol = "VRT";
244     uint8      public decimals = 18;
245     uint256    private constant initialSupply = 1000000000;
246 
247     constructor() public {
248         totalSupply_ = initialSupply * 10 ** uint256(decimals);
249         balances[msg.sender] = totalSupply_;
250         emit MintCoin(msg.sender, totalSupply_);
251     }
252 
253     function () payable external {
254         revert();
255     }
256 
257 }