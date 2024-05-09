1 pragma solidity ^0.4.18;
2 /*
3 ERC-20 Token Standard Compliant
4 Remyt is a decentralized peer to peer application platform for borderless transfer
5 */
6 
7 /**
8  * @title SafeMath
9  * @dev Math operations with safety checks that throw on error
10  */
11 library SafeMath {
12 
13     /**
14     * @dev Multiplies two numbers, throws on overflow.
15     */
16     function mul(uint256 a, uint256 b) internal pure returns (uint256) {
17         if (a == 0) {
18             return 0;
19         }
20         uint256 c = a * b;
21         assert(c / a == b);
22         return c;
23     }
24 
25     /**
26     * @dev Integer division of two numbers, truncating the quotient.
27     */
28     function div(uint256 a, uint256 b) internal pure returns (uint256) {
29         // assert(b > 0); // Solidity automatically throws when dividing by 0
30         // uint256 c = a / b;
31         // assert(a == b * c + a % b); // There is no case in which this doesn't hold
32         return a / b;
33     }
34 
35     /**
36     * @dev Subtracts two numbers, throws on overflow (i.e. if subtrahend is greater than minuend).
37     */
38     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
39         assert(b <= a);
40         return a - b;
41     }
42 
43     /**
44     * @dev Adds two numbers, throws on overflow.
45     */
46     function add(uint256 a, uint256 b) internal pure returns (uint256) {
47         uint256 c = a + b;
48         assert(c >= a);
49         return c;
50     }
51 }
52 
53 
54 /**
55  * @title Ownable
56  * @dev The Ownable contract has an owner address, and provides basic authorization control
57  * functions, this simplifies the implementation of "user permissions".
58  */
59 contract Ownable {
60     address public owner;
61 
62     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
63 
64     /**
65     * @dev The Ownable constructor sets the original `owner` of the contract to the sender
66     * account.
67     */
68     function Ownable() public {
69         owner = msg.sender;
70     }
71 
72     /**
73     * @dev Throws if called by any account other than the owner.
74     */
75     modifier onlyOwner() {
76         require(msg.sender == owner);
77         _;
78     }
79 
80     /**
81     * @dev Allows the current owner to transfer control of the contract to a newOwner.
82     * @param newOwner The address to transfer ownership to.
83     */
84     function transferOwnership(address newOwner) public onlyOwner {
85         require(newOwner != address(0));
86         emit OwnershipTransferred(owner, newOwner);
87         owner = newOwner;
88     }
89 
90 }
91 
92 /**
93  * @title ERC20Basic
94  * @dev Simpler version of ERC20 interface
95  */
96 contract ERC20Basic {
97     function totalSupply() public view returns (uint256);
98     function balanceOf(address who) public view returns (uint256);
99     function transfer(address to, uint256 value) public returns (bool);
100     event Transfer(address indexed from, address indexed to, uint256 value);
101 }
102 
103 
104 /**
105  * @title ERC20 interface
106  */
107 contract ERC20 is ERC20Basic {
108     function allowance(address owner, address spender) public view returns (uint256);
109     function transferFrom(address from, address to, uint256 value) public returns (bool);
110     function approve(address spender, uint256 value) public returns (bool);
111     event Approval(address indexed owner, address indexed spender, uint256 value);
112 }
113 
114 /**
115  * @title Basic token
116  * @dev Basic version of StandardToken, with no allowances.
117  */
118 contract BasicToken is ERC20Basic {
119     using SafeMath for uint256;
120 
121     mapping(address => uint256) balances;
122 
123     uint256 totalSupply_;
124 
125     /**
126     * @dev total number of tokens in existence
127     */
128     function totalSupply() public view returns (uint256) {
129         return totalSupply_;
130     }
131 
132     /**
133     * @dev transfer token for a specified address
134     * @param _to The address to transfer to.
135     * @param _value The amount to be transferred.
136     */
137     function transfer(address _to, uint256 _value) public returns (bool) {
138         require(_to != address(0));
139         require(_value <= balances[msg.sender]);
140 
141         balances[msg.sender] = balances[msg.sender].sub(_value);
142         balances[_to] = balances[_to].add(_value);
143         emit Transfer(msg.sender, _to, _value);
144         return true;
145     }
146 
147     /**
148     * @dev Gets the balance of the specified address.
149     * @param _owner The address to query the the balance of.
150     * @return An uint256 representing the amount owned by the passed address.
151     */
152     function balanceOf(address _owner) public view returns (uint256 balance) {
153         return balances[_owner];
154     }
155 
156 }
157 
158 /**
159  * @title Standard ERC20 token
160  *
161  * @dev Implementation of the basic standard token.
162  */
163 contract StandardToken is ERC20, BasicToken {
164 
165     mapping (address => mapping (address => uint256)) internal allowed;
166 
167     /**
168     * @dev Transfer tokens from one address to another
169     * @param _from address The address which you want to send tokens from
170     * @param _to address The address which you want to transfer to
171     * @param _value uint256 the amount of tokens to be transferred
172     */
173     function transferFrom(address _from, address _to, uint256 _value) public returns (bool) {
174         require(_to != address(0));
175         require(_value <= balances[_from]);
176         require(_value <= allowed[_from][msg.sender]);
177 
178         balances[_from] = balances[_from].sub(_value);
179         balances[_to] = balances[_to].add(_value);
180         allowed[_from][msg.sender] = allowed[_from][msg.sender].sub(_value);
181         emit Transfer(_from, _to, _value);
182         return true;
183     }
184 
185     /**
186     * @dev Approve the passed address to spend the specified amount of tokens on behalf of msg.sender.
187     *
188     * Beware that changing an allowance with this method brings the risk that someone may use both the old
189     * and the new allowance by unfortunate transaction ordering. One possible solution to mitigate this
190     * race condition is to first reduce the spender's allowance to 0 and set the desired value afterwards:
191     * @param _spender The address which will spend the funds.
192     * @param _value The amount of tokens to be spent.
193     */
194     function approve(address _spender, uint256 _value) public returns (bool) {
195         allowed[msg.sender][_spender] = _value;
196         emit Approval(msg.sender, _spender, _value);
197         return true;
198     }
199 
200     /**
201     * @dev Function to check the amount of tokens that an owner allowed to a spender.
202     * @param _owner address The address which owns the funds.
203     * @param _spender address The address which will spend the funds.
204     * @return A uint256 specifying the amount of tokens still available for the spender.
205     */
206     function allowance(address _owner, address _spender) public view returns (uint256) {
207         return allowed[_owner][_spender];
208     }
209 
210     /**
211     * @dev Increase the amount of tokens that an owner allowed to a spender.
212     *
213     * approve should be called when allowed[_spender] == 0. To increment
214     * allowed value is better to use this function to avoid 2 calls (and wait until
215     * the first transaction is mined)
216     * @param _spender The address which will spend the funds.
217     * @param _addedValue The amount of tokens to increase the allowance by.
218     */
219     function increaseApproval(address _spender, uint _addedValue) public returns (bool) {
220         allowed[msg.sender][_spender] = allowed[msg.sender][_spender].add(_addedValue);
221         emit Approval(msg.sender, _spender, allowed[msg.sender][_spender]);
222         return true;
223     }
224 
225     /**
226     * @dev Decrease the amount of tokens that an owner allowed to a spender.
227     *
228     * approve should be called when allowed[_spender] == 0. To decrement
229     * allowed value is better to use this function to avoid 2 calls (and wait until
230     * the first transaction is mined)
231     * @param _spender The address which will spend the funds.
232     * @param _subtractedValue The amount of tokens to decrease the allowance by.
233     */
234     function decreaseApproval(address _spender, uint _subtractedValue) public returns (bool) {
235         uint oldValue = allowed[msg.sender][_spender];
236         if (_subtractedValue > oldValue) {
237             allowed[msg.sender][_spender] = 0;
238         } else {
239             allowed[msg.sender][_spender] = oldValue.sub(_subtractedValue);
240         }
241         emit Approval(msg.sender, _spender, allowed[msg.sender][_spender]);
242         return true;
243     }
244 
245 }
246 
247 
248 contract Remyt is StandardToken, Ownable {
249     
250     string public name = "Remyt";
251     string public symbol = "XRT";
252     string public version = "1.0";
253     uint8 public decimals = 18;
254     
255     uint256 INITIAL_SUPPLY = 5500000e18;
256     
257     //event
258     event Burn(address indexed burner, uint256 value);
259     
260     function Remyt() public {
261         totalSupply_ = INITIAL_SUPPLY;
262         balances[this] = totalSupply_;
263         allowed[this][msg.sender] = totalSupply_;
264         
265         emit Approval(this, msg.sender, balances[this]);
266     }
267     
268     function burn(uint256 _value, address _addressToBurn) public onlyOwner {
269         require(_value <= balances[_addressToBurn]);
270         
271         address burner = _addressToBurn;
272         balances[burner] = balances[burner].sub(_value);
273         totalSupply_ = totalSupply_.sub(_value);
274         emit Burn(burner, _value);
275         emit Transfer(burner, address(0), _value);
276     }
277 
278 }