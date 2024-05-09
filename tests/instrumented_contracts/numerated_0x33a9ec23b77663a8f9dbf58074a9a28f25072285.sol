1 pragma solidity ^0.4.24;
2 /**
3 * @dev SafeMath
4 **/
5 library SafeMath {
6     function mul(uint256 a, uint256 b) internal pure returns (uint256) {
7         uint256 c = a * b;
8         assert(a == 0 || c / a == b);
9         return c;
10     }
11 
12     function div(uint256 a, uint256 b) internal pure returns (uint256) {
13         // assert(b > 0); // Solidity automatically throws when dividing by 0
14         uint256 c = a / b;
15         // assert(a == b * c + a % b); // There is no case in which this doesn't hold
16         return c;
17     }
18 
19     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
20         assert(b <= a);
21         return a - b;
22     }
23 
24     function add(uint256 a, uint256 b) internal pure returns (uint256) {
25         uint256 c = a + b;
26         assert(c >= a);
27         return c;
28     }
29 }
30 
31 
32 /**
33 * @dev ERC20Basic Interface
34 **/
35 contract ERC20Basic {
36     //ERC20 interface
37 
38 
39     //returns the total token supply
40     function totalSupply() public view returns(uint256);
41     //returns the account balance of another account with address
42     function balanceOf(address _owner) public view returns (uint256);
43     //transfer token, must fire Transfer even
44     //this function used for widthdraw
45     function transfer(address _to, uint256 _value) public returns (bool);
46     //transfer token from _from, _to
47     function transferFrom(address _from, address _to, uint256 _value) public returns (bool);
48     //allows _spender to withdraw from your account up the _value
49     function approve(address _spender, uint256 _value) public returns (bool);
50     //returns the amount which _spender is still allowed
51     function allowance(address owner, address spender) public view returns (uint256);
52     uint256 totalSupply_;
53 
54     event Transfer(address indexed _from, address indexed _to, uint256 _value);
55     event Approval(address indexed _owner, address indexed _spender, uint256 _value);
56 
57 
58 }
59 
60 /**
61 * @dev StandardToken Interface Function Description
62 **/
63 contract StandardToken is ERC20Basic {
64     using SafeMath for uint256;
65 
66     mapping(address => uint256) balances;
67     mapping (address => mapping (address => uint256)) allowed;
68 
69     /**
70     * @dev return totalSupply
71     */
72     function totalSupply() public view returns (uint256) {
73         return totalSupply_;
74     }
75 
76     /**
77     * @dev transfer token for a specified address
78     * @param _to The address to transfer to.
79     * @param _value The amount to be transferred.
80     */
81     function transfer(address _to, uint256 _value) public returns (bool) {
82         balances[msg.sender] = balances[msg.sender].sub(_value);
83         balances[_to] = balances[_to].add(_value);
84         emit Transfer(msg.sender, _to, _value);
85         return true;
86     }
87 
88     /**
89     * @dev Gets the balance of the specified address.
90     * @param _owner The address to query the the balance of.
91     * @return An uint256 representing the amount owned by the passed address.
92     */
93     function balanceOf(address _owner) public view returns (uint256) {
94         return balances[_owner];
95     }
96 
97     /**
98      * @dev Transfer tokens from one address to another
99      * @param _from address The address which you want to send tokens from
100      * @param _to address The address which you want to transfer to
101      * @param _value uint256 the amout of tokens to be transfered
102      */
103     function transferFrom(address _from, address _to, uint256 _value) public returns (bool) {
104         uint _allowance = allowed[_from][msg.sender];
105 
106         // Check is not needed because sub(_allowance, _value) will already throw if this condition is not met
107         // require (_value <= _allowance);
108 
109         balances[_to] = balances[_to].add(_value);
110         balances[_from] = balances[_from].sub(_value);
111         allowed[_from][msg.sender] = _allowance.sub(_value);
112         emit Transfer(_from, _to, _value);
113         return true;
114     }
115 
116     /**
117      * @dev Aprove the passed address to spend the specified amount of tokens on behalf of msg.sender.
118      * @param _spender The address which will spend the funds.
119      * @param _value The amount of tokens to be spent.
120      */
121     function approve(address _spender, uint256 _value) public returns (bool) {
122 
123         // To change the approve amount you first have to reduce the addresses`
124         //  allowance to zero by calling `approve(_spender, 0)` if it is not
125         //  already 0 to mitigate the race condition described here:
126         //  https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
127         require((_value == 0) || (allowed[msg.sender][_spender] == 0));
128 
129         allowed[msg.sender][_spender] = _value;
130         emit Approval(msg.sender, _spender, _value);
131         return true;
132     }
133 
134     /**
135      * @dev Function to check the amount of tokens that an owner allowed to a spender.
136      * @param _owner address The address which owns the funds.
137      * @param _spender address The address which will spend the funds.
138      * @return A uint256 specifing the amount of tokens still available for the spender.
139      */
140     function allowance(address _owner, address _spender) public view returns (uint256 remaining) {
141         return allowed[_owner][_spender];
142     }
143 
144 }
145 
146 
147 /**
148 * @dev Ownable
149 **/
150 contract Ownable {
151     address public owner;
152 
153 
154     /**
155      * @dev The Ownable constructor sets the original `owner` of the contract to the sender
156      * account.
157      */
158     constructor() public {
159         owner = msg.sender;
160     }
161 
162 
163     /**
164      * @dev Throws if called by any account other than the owner.
165      */
166     modifier onlyOwner() {
167         require(msg.sender == owner);
168         _;
169     }
170 
171     /**
172      * @dev Allows the current owner to transfer control of the contract to a newOwner.
173      * @param newOwner The address to transfer ownership to.
174      */
175     function transferOwnership(address newOwner) public onlyOwner {
176         require(newOwner != address(0));
177         owner = newOwner;
178     }
179 }
180 
181 /**
182 * @dev MintableToken
183 **/
184 contract MintableToken is StandardToken, Ownable {
185     event Mint(address indexed to, uint256 amount);
186     event MintFinished();
187 
188     bool public mintingFinished = false;
189 
190 
191     modifier canMint() {
192         require(!mintingFinished);
193         _;
194     }
195 
196     /**
197      * @dev Function to mint tokens
198      * @param _to The address that will recieve the minted tokens.
199      * @param _amount The amount of tokens to mint.
200      * @return A boolean that indicates if the operation was successful.
201      */
202     function mint(address _to, uint256 _amount) public onlyOwner canMint returns (bool) {
203         totalSupply_ = totalSupply_.add(_amount);
204         balances[_to] = balances[_to].add(_amount);
205         emit Mint(_to, _amount);
206         emit Transfer(address(0), _to, _amount);
207         return true;
208     }
209 
210     /**
211      * @dev Function to stop minting new tokens.
212      * @return True if the operation was successful.
213      */
214     function finishMinting() public onlyOwner returns (bool) {
215         mintingFinished = true;
216         emit MintFinished();
217         return true;
218     }
219 }
220 
221 
222 /**
223  * @title SimpleToken
224  * @dev Very simple ERC20 Token example, where all tokens are pre-assigned to the creator.
225  * Note they can later distribute these tokens as they wish using `transfer` and other
226  * `ERC20` functions.
227  */
228 contract GlobalPayCoin is MintableToken {
229 
230     string public constant name = "Global Pay Coin";
231     string public constant symbol = "GPC";
232     uint8 public constant decimals = 18;
233 
234     uint256 public constant INITIAL_SUPPLY = 10000000000 * (10 ** uint256(decimals));
235 
236     /**
237      * @dev Constructor that gives msg.sender all of existing tokens.
238      */
239     constructor(address _owner) public {
240         mint(_owner, INITIAL_SUPPLY);
241         transferOwnership(_owner);
242     }
243 
244 }