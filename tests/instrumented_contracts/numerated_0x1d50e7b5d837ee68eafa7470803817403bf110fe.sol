1 pragma solidity ^0.4.18;
2 /**
3  * Libraries
4  */
5 library SafeMath {
6   /**
7   * @dev Multiplies two numbers, throws on overflow.
8   */
9   function mul(uint256 a, uint256 b) internal pure returns (uint256) {
10     if (a == 0) {
11       return 0;
12     }
13     uint256 c = a * b;
14     assert(c / a == b);
15     return c;
16   }
17   /**
18   * @dev Integer division of two numbers, truncating the quotient.
19   */
20   function div(uint256 a, uint256 b) internal pure returns (uint256) {
21     // assert(b > 0); // Solidity automatically throws when dividing by 0
22     uint256 c = a / b;
23     // assert(a == b * c + a % b); // There is no case in which this doesn't hold
24     return c;
25   }
26 
27   /**
28   * @dev Substracts two numbers, throws on overflow (i.e. if subtrahend is greater than minuend).
29   */
30   function sub(uint256 a, uint256 b) internal pure returns (uint256) {
31     assert(b <= a);
32     return a - b;
33   }
34 
35   /**
36   * @dev Adds two numbers, throws on overflow.
37   */
38   function add(uint256 a, uint256 b) internal pure returns (uint256) {
39     uint256 c = a + b;
40     assert(c >= a);
41     return c;
42   }
43 }
44 
45 contract Ownable {
46   address public owner;
47     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
48   /**
49    * @dev The Ownable constructor sets the original `owner` of the contract to the sender
50    * account.
51    */
52   function Ownable() public {
53     owner = msg.sender;
54   }
55 
56   /**
57    * @dev Throws if called by any account other than the owner.
58    */
59   modifier onlyOwner() {
60     require(msg.sender == owner);
61     _;
62   }
63 
64   /**
65    * @dev Allows the current owner to transfer control of the contract to a newOwner.
66    * @param newOwner The address to transfer ownership to.
67    */
68   function transferOwnership(address newOwner) public onlyOwner {
69     require(newOwner != address(0));
70     OwnershipTransferred(owner, newOwner);
71     owner = newOwner;
72   }
73 
74 }
75 /**
76  * @title ERC20Basic
77  * @dev Simpler version of ERC20 interface
78  */
79 contract ERC20Basic {
80   uint256 public totalSupply;
81   function balanceOf(address who) public view returns (uint256);
82   function transfer(address to, uint256 value) public returns (bool);
83   event Transfer(address indexed from, address indexed to, uint256 value);
84 }
85 
86 /**
87  * @title ERC20 interface
88  */
89 contract ERC20 is ERC20Basic {
90   function allowance(address owner, address spender) public view returns (uint256);
91   function transferFrom(address from, address to, uint256 value) public returns (bool);
92   function approve(address spender, uint256 value) public returns (bool);
93   event Approval(address indexed owner, address indexed spender, uint256 value);
94 }
95 
96 contract Contactable is Ownable{
97 
98     string public contactInformation;
99 
100     /**
101      * @dev Allows the owner to set a string with their contact information.
102      * @param info The contact information to attach to the contract.
103      */
104     function setContactInformation(string info) onlyOwner public {
105          contactInformation = info;
106      }
107 }
108 
109 contract BurnableToken is ERC20, Ownable {
110   using SafeMath for uint;
111   event Burn(address indexed burner, uint256 value);
112   
113    mapping (address => uint) balances;
114 
115   /**
116    * @dev Burns a specific amount of tokens.
117    * @param _value The amount of token to be burned.
118    */
119   function burn(uint256 _value) public onlyOwner {
120     require(_value <= balances[msg.sender]);
121     address burner = msg.sender;
122     balances[burner] = balances[burner].sub(_value);
123     totalSupply = totalSupply.sub(_value);
124     Burn(burner, _value);
125   }
126 }
127 
128 contract UNIToken is ERC20, Contactable,BurnableToken{
129     using SafeMath for uint;
130 
131     string constant public name = "UNI Token";
132     string constant public symbol = "UNI";
133     uint constant public decimals = 4;
134 
135     bool public isActivated = false;
136 
137     //mapping (address => uint) balances;
138     mapping (address => mapping (address => uint)) internal allowed;
139     mapping (address => bool) public freezedList;
140 
141     address public minter;
142 
143     modifier whenActivated() {
144         require(isActivated);
145         _;
146     }
147 	
148     function UNIToken(uint256 _totalSupply) public {
149         minter = msg.sender;
150 		
151 	    totalSupply = _totalSupply;
152 		// give money to us
153         balances[minter] = totalSupply;
154 
155         // first event
156         Transfer(0x0, minter, totalSupply);
157     }
158 
159     /**
160     * @dev transfer token for a specified address
161     * @param _to The address to transfer to.
162     * @param _value The amount to be transferred.
163     */
164     function transfer(address _to, uint _value) public returns (bool) {
165         bytes memory empty;
166         return transfer(_to, _value, empty);
167     }
168 
169     /**
170     * @dev transfer token for a specified address
171     * @param _to The address to transfer to.
172     * @param _value The amount to be transferred.
173     * @param _data Optional metadata.
174     */
175     function transfer(address _to, uint _value, bytes _data) public whenActivated returns (bool) {
176         require(_to != address(0));
177         require(_value <= balances[msg.sender]);
178         require(!freezedList[msg.sender]);
179 
180         // SafeMath.sub will throw if there is not enough balance.
181         balances[msg.sender] = balances[msg.sender].sub(_value);
182         balances[_to] = balances[_to].add(_value);
183         Transfer(msg.sender, _to, _value);
184 
185         return true;
186     }
187 
188     /**
189     * @dev Gets the balance of the specified address.
190     * @param _owner The address to query the the balance of.
191     * @return An uint representing the amount owned by the passed address.
192     */
193     function balanceOf(address _owner) public view returns (uint balance) {
194         return balances[_owner];
195     }
196 
197     /**
198      * @dev Transfer tokens from one address to another
199      * @param _from address The address which you want to send tokens from
200      * @param _to address The address which you want to transfer to
201      * @param _value uint the amount of tokens to be transferred
202      */
203     function transferFrom(address _from, address _to, uint _value) public returns (bool) {
204         bytes memory empty;
205         return transferFrom(_from, _to, _value, empty);
206     }
207 
208     /**
209      * @dev Transfer tokens from one address to another
210      * @param _from address The address which you want to send tokens from
211      * @param _to address The address which you want to transfer to
212      * @param _value uint the amount of tokens to be transferred
213      * @param _data Optional metadata.
214      */
215     function transferFrom(address _from, address _to, uint _value, bytes _data) public whenActivated returns (bool) {
216         require(_to != address(0));
217         require(_value <= balances[_from]);
218         require(_value <= allowed[_from][msg.sender]);
219         require(!freezedList[_from]);
220 
221         balances[_from] = balances[_from].sub(_value);
222         balances[_to] = balances[_to].add(_value);
223         allowed[_from][msg.sender] = allowed[_from][msg.sender].sub(_value);
224         Transfer(_from, _to, _value);
225         return true;
226     }
227 
228     /**
229      * @dev Approve the passed address to spend the specified amount of tokens on behalf of msg.sender.
230      * @param _spender The address which will spend the funds.
231      * @param _value The amount of tokens to be spent.
232      */
233     function approve(address _spender, uint _value) public returns (bool) {
234         require(_value == 0 || allowed[msg.sender][_spender] == 0);
235         allowed[msg.sender][_spender] = _value;
236         Approval(msg.sender, _spender, _value);
237         return true;
238     }
239 
240     /**
241      * @dev Function to check the amount of tokens that an owner allowed to a spender.
242      * @param _owner address The address which owns the funds.
243      * @param _spender address The address which will spend the funds.
244      * @return A uint specifying the amount of tokens still available for the spender.
245      */
246     function allowance(address _owner, address _spender) public view returns (uint) {
247         return allowed[_owner][_spender];
248     }
249 
250     /**
251      * @dev Increase the amount of tokens that an owner allowed to a spender.
252      * @param _spender The address which will spend the funds.
253      * @param _addedValue The amount of tokens to increase the allowance by.
254      */
255     function increaseApproval(address _spender, uint _addedValue) public returns (bool) {
256         allowed[msg.sender][_spender] = allowed[msg.sender][_spender].add(_addedValue);
257         Approval(msg.sender, _spender, allowed[msg.sender][_spender]);
258         return true;
259     }
260 
261     /**
262      * @dev Decrease the amount of tokens that an owner allowed to a spender.
263      * @param _spender The address which will spend the funds.
264      * @param _subtractedValue The amount of tokens to decrease the allowance by.
265      */
266     function decreaseApproval(address _spender, uint _subtractedValue) public returns (bool) {
267         uint oldValue = allowed[msg.sender][_spender];
268         if (_subtractedValue > oldValue) {
269             allowed[msg.sender][_spender] = 0;
270         } else {
271             allowed[msg.sender][_spender] = oldValue.sub(_subtractedValue);
272         }
273         Approval(msg.sender, _spender, allowed[msg.sender][_spender]);
274         return true;
275     }
276     
277     /**
278      * Owner can unfreeze any address
279      */
280     function removeFromFreezedList(address user) external onlyOwner {
281         freezedList[user] = false;
282     }
283 
284     /**
285      * Activation of the token allows all tokenholders to operate with the token
286      */
287     function activate() external onlyOwner returns (bool) {
288         isActivated = true;
289         return true;
290     }
291     
292 }