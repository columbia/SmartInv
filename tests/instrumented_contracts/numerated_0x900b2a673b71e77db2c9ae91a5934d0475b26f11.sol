1 pragma solidity 0.4.23;
2 
3 
4 /**
5  * @title SafeMath
6  * @dev Math operations with safety checks that throw on error
7  */
8 library SafeMath {
9     function mul(uint256 a, uint256 b) internal pure returns (uint256) {
10         if (a == 0) {
11             return 0;
12         }
13         uint256 c = a * b;
14         assert(c / a == b);
15         return c;
16     }
17 
18     function div(uint256 a, uint256 b) internal pure returns (uint256) {
19         // assert(b > 0); // Solidity automatically throws when dividing by 0
20         uint256 c = a / b;
21         // assert(a == b * c + a % b); // There is no case in which this doesn't hold
22         return c;
23     }
24 
25     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
26         assert(b <= a);
27         return a - b;
28     }
29 
30     function add(uint256 a, uint256 b) internal pure returns (uint256) {
31         uint256 c = a + b;
32         assert(c >= a);
33         return c;
34     }
35 }
36 
37 
38 /**
39  * @title ERC20Basic
40  * @dev Simpler version of ERC20 interface
41  * @dev see https://github.com/ethereum/EIPs/issues/179
42  */
43 contract ERC20Basic {
44     uint256 public totalSupply;
45 
46     function balanceOf(address who) public view returns (uint256);
47 
48     function transfer(address to, uint256 value) public returns (bool);
49 
50     event Transfer(address indexed from, address indexed to, uint256 value);
51 }
52 
53 
54 /**
55  * @title Basic token
56  * @dev Basic version of StandardToken, with no allowances.
57  */
58 contract BasicToken is ERC20Basic {
59     using SafeMath for uint256;
60 
61     mapping(address => uint256) balances;
62 
63     /**
64     * @dev transfer token for a specified address
65     * @param _to The address to transfer to.
66     * @param _value The amount to be transferred.
67     */
68     function transfer(address _to, uint256 _value) public returns (bool) {
69         require(_to != address(0));
70         require(_value <= balances[msg.sender]);
71 
72         // SafeMath.sub will throw if there is not enough balance.
73         balances[msg.sender] = balances[msg.sender].sub(_value);
74         balances[_to] = balances[_to].add(_value);
75         emit Transfer(msg.sender, _to, _value);
76         return true;
77     }
78 
79     /**
80     * @dev Gets the balance of the specified address.
81     * @param _owner The address to query the the balance of.
82     * @return An uint256 representing the amount owned by the passed address.
83     */
84     function balanceOf(address _owner) public view returns (uint256 balance) {
85         return balances[_owner];
86     }
87 
88 }
89 
90 
91 /**
92  * @title ERC20 interface
93  * @dev see https://github.com/ethereum/EIPs/issues/20
94  */
95 contract ERC20 is ERC20Basic {
96     function allowance(address owner, address spender) public view returns (uint256);
97 
98     function transferFrom(address from, address to, uint256 value) public returns (bool);
99 
100     function approve(address spender, uint256 value) public returns (bool);
101 
102     event Approval(address indexed owner, address indexed spender, uint256 value);
103 }
104 
105 
106 /**
107  * @title Standard ERC20 token
108  *
109  * @dev Implementation of the basic standard token.
110  * @dev https://github.com/ethereum/EIPs/issues/20
111  * @dev Based on code by FirstBlood: https://github.com/Firstbloodio/token/blob/master/smart_contract/FirstBloodToken.sol
112  */
113 contract StandardToken is ERC20, BasicToken {
114 
115     mapping(address => mapping(address => uint256)) internal allowed;
116 
117 
118     /**
119      * @dev Transfer tokens from one address to another
120      * @param _from address The address which you want to send tokens from
121      * @param _to address The address which you want to transfer to
122      * @param _value uint256 the amount of tokens to be transferred
123      */
124     function transferFrom(address _from, address _to, uint256 _value) public returns (bool) {
125         require(_to != address(0));
126         require(_value <= balances[_from]);
127         require(_value <= allowed[_from][msg.sender]);
128 
129         balances[_from] = balances[_from].sub(_value);
130         balances[_to] = balances[_to].add(_value);
131         allowed[_from][msg.sender] = allowed[_from][msg.sender].sub(_value);
132         emit Transfer(_from, _to, _value);
133         return true;
134     }
135 
136     /**
137      * @dev Approve the passed address to spend the specified amount of tokens on behalf of msg.sender.
138      *
139      * Beware that changing an allowance with this method brings the risk that someone may use both the old
140      * and the new allowance by unfortunate transaction ordering. One possible solution to mitigate this
141      * race condition is to first reduce the spender's allowance to 0 and set the desired value afterwards:
142      * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
143      * @param _spender The address which will spend the funds.
144      * @param _value The amount of tokens to be spent.
145      */
146     function approve(address _spender, uint256 _value) public returns (bool) {
147         allowed[msg.sender][_spender] = _value;
148         emit Approval(msg.sender, _spender, _value);
149         return true;
150     }
151 
152     /**
153      * @dev Function to check the amount of tokens that an owner allowed to a spender.
154      * @param _owner address The address which owns the funds.
155      * @param _spender address The address which will spend the funds.
156      * @return A uint256 specifying the amount of tokens still available for the spender.
157      */
158     function allowance(address _owner, address _spender) public view returns (uint256) {
159         return allowed[_owner][_spender];
160     }
161 
162     /**
163      * @dev Increase the amount of tokens that an owner allowed to a spender.
164      *
165      * approve should be called when allowed[_spender] == 0. To increment
166      * allowed value is better to use this function to avoid 2 calls (and wait until
167      * the first transaction is mined)
168      * From MonolithDAO Token.sol
169      * @param _spender The address which will spend the funds.
170      * @param _addedValue The amount of tokens to increase the allowance by.
171      */
172     function increaseApproval(address _spender, uint _addedValue) public returns (bool) {
173         allowed[msg.sender][_spender] = allowed[msg.sender][_spender].add(_addedValue);
174         emit Approval(msg.sender, _spender, allowed[msg.sender][_spender]);
175         return true;
176     }
177 
178     /**
179      * @dev Decrease the amount of tokens that an owner allowed to a spender.
180      *
181      * approve should be called when allowed[_spender] == 0. To decrement
182      * allowed value is better to use this function to avoid 2 calls (and wait until
183      * the first transaction is mined)
184      * From MonolithDAO Token.sol
185      * @param _spender The address which will spend the funds.
186      * @param _subtractedValue The amount of tokens to decrease the allowance by.
187      */
188     function decreaseApproval(address _spender, uint _subtractedValue) public returns (bool) {
189         uint oldValue = allowed[msg.sender][_spender];
190         if (_subtractedValue > oldValue) {
191             allowed[msg.sender][_spender] = 0;
192         } else {
193             allowed[msg.sender][_spender] = oldValue.sub(_subtractedValue);
194         }
195         emit Approval(msg.sender, _spender, allowed[msg.sender][_spender]);
196         return true;
197     }
198 
199 }
200 
201 
202 contract TempusToken is StandardToken {
203     string public name = "Tempus";
204     string public symbol = "TPS";
205     uint8 public decimals = 8;
206     uint256 public cap = 100000000000000000;
207     mapping(address => bool) public owners;
208     mapping(address => bool) public minters;
209 
210     event Mint(address indexed to, uint256 amount);
211     event OwnerAdded(address indexed newOwner);
212     event OwnerRemoved(address indexed removedOwner);
213     event MinterAdded(address indexed newMinter);
214     event MinterRemoved(address indexed removedMinter);
215     event Burn(address indexed burner, uint256 value);
216 
217     constructor() public {
218         owners[msg.sender] = true;
219     }
220 
221     /**
222      * @dev Function to mint tokens
223      * @param _to The address that will receive the minted tokens.
224      * @param _amount The amount of tokens to mint.
225      * @return A boolean that indicates if the operation was successful.
226      */
227     function mint(address _to, uint256 _amount) public onlyMinter returns (bool) {
228         require(totalSupply.add(_amount) <= cap);
229         totalSupply = totalSupply.add(_amount);
230         balances[_to] = balances[_to].add(_amount);
231         emit Mint(_to, _amount);
232         emit Transfer(address(0), _to, _amount);
233         return true;
234     }
235 
236     /**
237      * @dev Burns a specific amount of tokens.
238      * @param _value The amount of token to be burned.
239      */
240     function burn(uint256 _value) public {
241         require(_value <= balances[msg.sender]);
242         // no need to require value <= totalSupply, since that would imply the
243         // sender's balance is greater than the totalSupply, which *should* be an assertion failure
244 
245         address burner = msg.sender;
246         balances[burner] = balances[burner].sub(_value);
247         totalSupply = totalSupply.sub(_value);
248         emit Burn(burner, _value);
249     }
250 
251     /**
252      * @dev Adds administrative role to address
253      * @param _address The address that will get administrative privileges
254      */
255     function addOwner(address _address) public onlyOwner {
256         owners[_address] = true;
257         emit OwnerAdded(_address);
258     }
259 
260     /**
261      * @dev Removes administrative role from address
262      * @param _address The address to remove administrative privileges from
263      */
264     function delOwner(address _address) public onlyOwner {
265         owners[_address] = false;
266         emit OwnerRemoved(_address);
267     }
268 
269     /**
270      * @dev Throws if called by any account other than the owner.
271      */
272     modifier onlyOwner() {
273         require(owners[msg.sender]);
274         _;
275     }
276 
277     /**
278      * @dev Adds minter role to address (able to create new tokens)
279      * @param _address The address that will get minter privileges
280      */
281     function addMinter(address _address) public onlyOwner {
282         minters[_address] = true;
283         emit MinterAdded(_address);
284     }
285 
286     /**
287      * @dev Removes minter role from address
288      * @param _address The address to remove minter privileges
289      */
290     function delMinter(address _address) public onlyOwner {
291         minters[_address] = false;
292         emit MinterRemoved(_address);
293     }
294 
295     /**
296      * @dev Throws if called by any account other than the minter.
297      */
298     modifier onlyMinter() {
299         require(minters[msg.sender]);
300         _;
301     }
302 }