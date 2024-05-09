1 pragma solidity ^0.4.17;
2 
3 contract Ownable {
4     address public owner;
5 
6 
7     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
8 
9 
10     /**
11      * @dev The Ownable constructor sets the original `owner` of the contract to the sender
12      * account.
13      */
14     constructor() public {
15         owner = msg.sender;
16     }
17 
18     /**
19      * @dev Throws if called by any accounnot other than the owner.
20      */
21     modifier onlyOwner() {
22         require(msg.sender == owner);
23         _;
24     }
25 
26     /**
27      * @dev Allows the current owner to transfer control of the contract to a newOwner.
28      * @param newOwner The address to transfer ownership to.
29      */
30     function transferOwnership(address newOwner) public onlyOwner {
31         require(newOwner != address(0));
32         emit OwnershipTransferred(owner, newOwner);
33         owner = newOwner;
34     }
35 
36 }
37 
38 contract ERC20Basic {
39     function totalSupply() public view returns (uint256);
40     function balanceOf(address who) public view returns (uint256);
41     function transfer(address to, uint256 value) public returns (bool);
42     event Transfer(address indexed from, address indexed to, uint256 value);
43 }
44 
45 contract ERC20 is ERC20Basic {
46     function allowance(address owner, address spender) public view returns (uint256);
47     function transferFrom(address from, address to, uint256 value) public returns (bool);
48     function approve(address spender, uint256 value) public returns (bool);
49     event Approval(address indexed owner, address indexed spender, uint256 value);
50 }
51 
52 library SafeMath {
53 
54     /**
55     * @dev Multiplies two numbers, throws on overflow.
56     */
57     function mul(uint256 a, uint256 b) internal pure returns (uint256) {
58         if (a == 0) {
59             return 0;
60         }
61         uint256 c = a * b;
62         require(c / a == b);
63         return c;
64     }
65 
66     /**
67     * @dev Integer division of two numbers, truncating the quotient.
68     */
69     function div(uint256 a, uint256 b) internal pure returns (uint256) {
70         // require(b > 0); // Solidity automatically throws when dividing by 0
71         uint256 c = a / b;
72         // require(a == b * c + a % b); // There is no case in which this doesn't hold
73         return c;
74     }
75 
76     /**
77     * @dev Substracts two numbers, throws on overflow (i.e. if subtrahend is greater than minuend).
78     */
79     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
80         require(b <= a);
81         return a - b;
82     }
83 
84     /**
85     * @dev Adds two numbers, throws on overflow.
86     */
87     function add(uint256 a, uint256 b) internal pure returns (uint256) {
88         uint256 c = a + b;
89         require(c >= a);
90         return c;
91     }
92 }
93 
94 contract BasicToken is ERC20Basic {
95     using SafeMath for uint256;
96 
97     mapping(address => uint256) balances;
98 
99     uint256 totalSupply_;
100 
101     /**
102     * @dev total number of tokens in existence
103     */
104     function totalSupply() public view returns (uint256) {
105         return totalSupply_;
106     }
107 
108     /**
109     * @dev transfer token for a specified address
110     * @param _to The address to transfer to.
111     * @param _value The amount to be transferred.
112     */
113     function transfer(address _to, uint256 _value) public returns (bool) {
114         require(_to != address(0));
115         require(_value <= balances[msg.sender]);
116 
117         // SafeMath.sub will throw if there is not enough balance.
118         balances[msg.sender] = balances[msg.sender].sub(_value);
119         balances[_to] = balances[_to].add(_value);
120         emit Transfer(msg.sender, _to, _value);
121         return true;
122     }
123 
124     /**
125     * @dev Gets the balance of the specified address.
126     * @param _owner The address to query the the balance of.
127     * @return An uint256 representing the amount owned by the passed address.
128     */
129     function balanceOf(address _owner) public view returns (uint256 balance) {
130         return balances[_owner];
131     }
132 
133 }
134 
135 contract StandardToken is ERC20, BasicToken {
136 
137     mapping (address => mapping (address => uint256)) internal allowed;
138 
139 
140     /**
141      * @dev Transfer tokens from one address to another
142      * @param _from address The address which you want to send tokens from
143      * @param _to address The address which you want to transfer to
144      * @param _value uint256 the amount of tokens to be transferred
145      */
146     function transferFrom(address _from, address _to, uint256 _value) public returns (bool) {
147         require(_to != address(0));
148         require(_value <= balances[_from]);
149         require(_value <= allowed[_from][msg.sender]);
150 
151         balances[_from] = balances[_from].sub(_value);
152         balances[_to] = balances[_to].add(_value);
153         allowed[_from][msg.sender] = allowed[_from][msg.sender].sub(_value);
154         emit Transfer(_from, _to, _value);
155         return true;
156     }
157 
158     /**
159      * @dev Approve the passed address to spend the specified amount of tokens on behalf of msg.sender.
160      *
161      * Beware that changing an allowance with this method brings the risk that someone may use both the old
162      * and the new allowance by unfortunate transaction ordering. One possible solution to mitigate this
163      * race condition is to first reduce the spender's allowance to 0 and set the desired value afterwards:
164      * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
165      * @param _spender The address which will spend the funds.
166      * @param _value The amount of tokens to be spent.
167      */
168     function approve(address _spender, uint256 _value) public returns (bool) {
169         allowed[msg.sender][_spender] = _value;
170         emit Approval(msg.sender, _spender, _value);
171         return true;
172     }
173 
174     /**
175      * @dev Function to check the amount of tokens that an owner allowed to a spender.
176      * @param _owner address The address which owns the funds.
177      * @param _spender address The address which will spend the funds.
178      * @return A uint256 specifying the amount of tokens still available for the spender.
179      */
180     function allowance(address _owner, address _spender) public view returns (uint256) {
181         return allowed[_owner][_spender];
182     }
183 
184     /**
185      * @dev Increase the amount of tokens that an owner allowed to a spender.
186      *
187      * approve should be called when allowed[_spender] == 0. To increment
188      * allowed value is better to use this function to avoid 2 calls (and wait until
189      * the first transaction is mined)
190      * From MonolithDAO Token.sol
191      * @param _spender The address which will spend the funds.
192      * @param _addedValue The amount of tokens to increase the allowance by.
193      */
194     function increaseApproval(address _spender, uint _addedValue) public returns (bool) {
195         allowed[msg.sender][_spender] = allowed[msg.sender][_spender].add(_addedValue);
196         emit Approval(msg.sender, _spender, allowed[msg.sender][_spender]);
197         return true;
198     }
199 
200     /**
201      * @dev Decrease the amount of tokens that an owner allowed to a spender.
202      *
203      * approve should be called when allowed[_spender] == 0. To decrement
204      * allowed value is better to use this function to avoid 2 calls (and wait until
205      * the first transaction is mined)
206      * From MonolithDAO Token.sol
207      * @param _spender The address which will spend the funds.
208      * @param _subtractedValue The amount of tokens to decrease the allowance by.
209      */
210     function decreaseApproval(address _spender, uint _subtractedValue) public returns (bool) {
211         uint oldValue = allowed[msg.sender][_spender];
212         if (_subtractedValue > oldValue) {
213             allowed[msg.sender][_spender] = 0;
214         } else {
215             allowed[msg.sender][_spender] = oldValue.sub(_subtractedValue);
216         }
217         emit Approval(msg.sender, _spender, allowed[msg.sender][_spender]);
218         return true;
219     }
220 
221 }
222 
223 contract LockToken is StandardToken, Ownable {
224     string public name = "Lock Token";
225     string public symbol = "LOK";
226     uint8 public decimals = 18;
227 
228     constructor() public {
229         totalSupply_ = 3000000000 * (10 ** 18);
230         balances[owner] = totalSupply_;
231         emit Transfer(address(0), owner, totalSupply_);
232     }
233 
234 }