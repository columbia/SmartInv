1 pragma solidity 0.5.6;
2 
3 /**
4  * @title SafeMath
5  * @dev Unsigned math operations with safety checks that revert on error
6  */
7 library SafeMath {
8     /**
9      * @dev Multiplies two unsigned integers, reverts on overflow.
10      */
11     function mul(uint256 a, uint256 b) internal pure returns (uint256) {
12         // Gas optimization: this is cheaper than requiring 'a' not being zero, but the
13         // benefit is lost if 'b' is also tested.
14         // See: https://github.com/OpenZeppelin/openzeppelin-solidity/pull/522
15         if (a == 0) {
16             return 0;
17         }
18 
19         uint256 c = a * b;
20         require(c / a == b);
21 
22         return c;
23     }
24 
25     /**
26      * @dev Integer division of two unsigned integers truncating the quotient, reverts on division by zero.
27      */
28     function div(uint256 a, uint256 b) internal pure returns (uint256) {
29         // Solidity only automatically asserts when dividing by 0
30         require(b > 0);
31         uint256 c = a / b;
32         // assert(a == b * c + a % b); // There is no case in which this doesn't hold
33 
34         return c;
35     }
36 
37     /**
38      * @dev Subtracts two unsigned integers, reverts on overflow (i.e. if subtrahend is greater than minuend).
39      */
40     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
41         require(b <= a);
42         uint256 c = a - b;
43 
44         return c;
45     }
46 
47     /**
48      * @dev Adds two unsigned integers, reverts on overflow.
49      */
50     function add(uint256 a, uint256 b) internal pure returns (uint256) {
51         uint256 c = a + b;
52         require(c >= a);
53 
54         return c;
55     }
56 }
57 
58 /**
59  * @title Ownable
60  * @dev The Ownable contract has an owner address, and provides basic authorization control
61  * functions, this simplifies the implementation of "user permissions".
62  */
63 contract Ownable {
64     address public owner; 
65     
66     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner); 
67 
68     /**
69      * @dev Throws if called by any account other than the owner.
70      */
71     modifier onlyOwner() {
72         require(msg.sender == owner);
73         _;
74     }
75 
76     /**
77      * @dev Allows the current owner to transfer control of the contract to a newOwner.
78      * @param newOwner The address to transfer ownership to.
79      */
80     function transferOwnership(address newOwner) public onlyOwner {
81         _transferOwnership(newOwner);
82     }
83 
84     /**
85      * @dev Transfers control of the contract to a newOwner.
86      * @param newOwner The address to transfer ownership to.
87      */
88     function _transferOwnership(address newOwner) internal {
89         require(newOwner != address(0));
90         emit OwnershipTransferred(owner, newOwner);
91         owner = newOwner;
92     }
93 }
94 
95 /**
96  * @title StandardToken
97  * @dev Implementation of the basic standard token.
98  */
99 contract StandardToken {
100     using SafeMath for uint256;
101 
102     mapping(address => uint256) internal balances;
103 
104     mapping(address => mapping(address => uint256)) internal allowed;
105 
106     uint256 public totalSupply;
107 
108     event Transfer(address indexed from, address indexed to, uint256 value);
109 
110     event Approval(address indexed owner, address indexed spender, uint256 vaule);
111 
112     /**
113      * @dev Gets the balance of the specified address.
114      * @param _owner The address to query the the balance of.
115      * @return An uint256 representing the amount owned by the passed address.
116      */
117     function balanceOf(address _owner) public view returns(uint256) {
118         return balances[_owner];
119     }
120 
121     /**
122      * @dev Function to check the amount of tokens that an owner allowed to a spender.
123      * @param _owner The address which owns the funds.
124      * @param _spender The address which will spend the funds.
125      * @return A uint256 specifying the amount of tokens still available for the spender.
126      */
127     function allowance(address _owner, address _spender) public view returns(uint256) {
128         return allowed[_owner][_spender];
129     }
130 
131     /**
132      * @dev Transfer token for a specified address
133      * @param _to The address to transfer to.
134      * @param _value The amount to be transferred.
135      */
136     function transfer(address _to, uint256 _value) public returns(bool) {
137         require(_to != address(0));
138         require(_value <= balances[msg.sender]);
139         
140         balances[msg.sender] = balances[msg.sender].sub(_value);
141         balances[_to] = balances[_to].add(_value);
142         emit Transfer(msg.sender, _to, _value);
143         return true;
144     }
145 
146     /**
147      * @dev Approve the passed address to spend the specified amount of tokens on behalf of msg.sender.
148      * Beware that changing an allowance with this method brings the risk that someone may use both the old
149      * and the new allowance by unfortunate transaction ordering. One possible solution to mitigate this
150      * race condition is to first reduce the spender's allowance to 0 and set the desired value afterwards:
151      * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
152      * @param _spender The address which will spend the funds.
153      * @param _value The amount of tokens to be spent.
154      */
155     
156     function approve(address _spender, uint256 _value) public returns(bool) {
157         allowed[msg.sender][_spender] = _value;
158         emit Approval(msg.sender, _spender, _value);
159         return true;
160     }
161 
162     /**
163      * @dev Transfer tokens from one address to another
164      * @param _from address The address which you want to send tokens from
165      * @param _to address The address which you want to transfer to
166      * @param _value uint256 the amount of tokens to be transferred
167      */
168     function transferFrom(address _from, address _to, uint256 _value) public returns(bool) {
169         require(_to != address(0));
170         require(_value <= balances[_from]);
171         require(_value <= allowed[_from][msg.sender]);
172         
173         balances[_from] = balances[_from].sub(_value);
174         balances[_to] = balances[_to].add(_value);
175         allowed[_from][msg.sender] = allowed[_from][msg.sender].sub(_value);
176         emit Transfer(_from, _to, _value);
177         return true;
178     }
179 
180     /**
181      * @dev Increase the amount of tokens that an owner allowed to a spender.
182      * approve should be called when allowed[_spender] == 0. To increment
183      * allowed value is better to use this function to avoid 2 calls (and wait until
184      * the first transaction is mined)
185      * From MonolithDAO Token.sol
186      * @param _spender The address which will spend the funds.
187      * @param _addedValue The amount of tokens to increase the allowance by.
188      */
189     function increaseApproval(address _spender, uint256 _addedValue) public returns(bool) {
190         allowed[msg.sender][_spender] = allowed[msg.sender][_spender].add(_addedValue);
191         emit Approval(msg.sender, _spender, allowed[msg.sender][_spender]);
192         return true;
193     }
194 
195     /**
196      * @dev Decrease the amount of tokens that an owner allowed to a spender.
197      * approve should be called when allowed[_spender] == 0. To decrement
198      * allowed value is better to use this function to avoid 2 calls (and wait until
199      * the first transaction is mined)
200      * From MonolithDAO Token.sol
201      * @param _spender The address which will spend the funds.
202      * @param _subtractedValue The amount of tokens to decrease the allowance by.
203      */
204     function decreaseApproval(address _spender, uint256 _subtractedValue) public returns(bool) {
205         uint256 oldValue = allowed[msg.sender][_spender];
206         if (_subtractedValue >= oldValue) {
207             allowed[msg.sender][_spender] = 0;
208         } else {
209             allowed[msg.sender][_spender] = oldValue.sub(_subtractedValue);
210         }
211         emit Approval(msg.sender, _spender, allowed[msg.sender][_spender]);
212         return true;
213     }
214 
215 }
216 
217 
218 contract DEJToken is StandardToken, Ownable {
219     string public constant name = "DEHOME"; // Name of token 
220     string public constant symbol = "DEJ"; // Symbol of token 
221     uint8 public constant decimals = 18; // Decimals of token
222 
223     address public constant beneficiary = 0x505e83c8805DE632CA8d3d5d59701c1316136106; // Beneficiary of tokens after they are released
224     uint256 public releasedTime; // Timestamp when token release is enabled
225     uint256 public vestedAmount; // Amount of tokens locked
226 
227     uint256 internal constant INIT_TOTALSUPPLY = 2000000000; // Total amount of tokens
228     // evnets
229     event ReleaseToken(address indexed beneficiary, uint256 vestedAmount);
230     event TokenVesting(address indexed beneficiary, uint256 vestedAmount, uint256 releasedTime);
231     
232     constructor() public {
233         owner = beneficiary;
234         totalSupply = INIT_TOTALSUPPLY * 10 ** uint256(decimals);
235         vestedAmount = 1000000000 * 10 ** uint256(decimals);
236         uint256 ownerBalances = totalSupply.sub(vestedAmount);
237         balances[owner] = ownerBalances;
238         releasedTime = now.add(2*365 days);
239         emit Transfer(address(0), owner, ownerBalances);
240         emit TokenVesting(beneficiary, vestedAmount, releasedTime);
241     }
242 
243     /**
244      * @dev Releases token
245      */
246     function releaseToken() public onlyOwner returns (bool) {
247         require(now > releasedTime, "Not reaching release time");
248         require(vestedAmount > 0, "Already released");
249         balances[beneficiary] = balances[beneficiary].add(vestedAmount);
250         emit ReleaseToken(beneficiary,vestedAmount);
251         vestedAmount = 0;
252         return true;
253     }
254 }