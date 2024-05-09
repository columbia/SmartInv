1 pragma solidity 0.5.17;
2 
3 /**
4  * @title SafeMath
5  * @dev Math operations with safety checks that throw on error
6  */
7 
8 library SafeMath {
9 
10     function add(uint256 a, uint256 b) internal pure returns (uint256) {
11         uint256 c = a + b;
12         require(c >= a, "SafeMath: addition overflow");
13 
14         return c;
15     }
16 
17     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
18         return sub(a, b, "SafeMath: subtraction overflow");
19     }
20 
21     function sub(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
22         require(b <= a, errorMessage);
23         uint256 c = a - b;
24 
25         return c;
26     }
27 
28     function mul(uint256 a, uint256 b) internal pure returns (uint256) {
29         if (a == 0) {
30             return 0;
31         }
32 
33         uint256 c = a * b;
34         require(c / a == b, "SafeMath: multiplication overflow");
35 
36         return c;
37     }
38 
39     function div(uint256 a, uint256 b) internal pure returns (uint256) {
40         return div(a, b, "SafeMath: division by zero");
41     }
42 
43     function div(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
44         require(b > 0, errorMessage);
45         uint256 c = a / b;
46 
47         return c;
48     }
49 
50     function mod(uint256 a, uint256 b) internal pure returns (uint256) {
51         return mod(a, b, "SafeMath: modulo by zero");
52     }
53 
54     function mod(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
55         require(b != 0, errorMessage);
56         return a % b;
57     }
58 }
59 
60 contract ERC20Interface {
61     function totalSupply() external view returns (uint256);
62     function balanceOf(address _who) external view returns (uint256);
63     function transfer(address _to, uint256 _value) external returns (bool);
64     function allowance(address _owner, address _spender) external view returns (uint256);
65     function transferFrom(address _from, address _to, uint256 _value) external returns (bool);
66     function approve(address _spender, uint256 _value) external returns (bool);
67 
68     event Approval(address indexed _owner, address indexed _spender, uint256 _value);
69     event Transfer(address indexed _from, address indexed _to, uint256 _value);
70 }
71 
72 /**
73  * @title HBC token
74  */
75 
76 contract HBC is ERC20Interface {
77 
78     using SafeMath for uint256;
79    
80     uint256 constant public TOKEN_DECIMALS = 10 ** 18;
81     string public constant name            = "Hybrid Bank Cash";
82     string public constant symbol          = "HBC";
83     uint256 public totalTokenSupply        = 10000000000 * TOKEN_DECIMALS;
84     uint8 public constant decimals         = 18;
85     bool public stopped                    = false;
86     address public owner;
87     uint256 public totalBurned;
88 
89     event Burn(address indexed _burner, uint256 _value);
90     event OwnershipTransferred(address indexed _previousOwner, address indexed _newOwner);
91     event OwnershipRenounced(address indexed _previousOwner);
92 
93     /** mappings **/ 
94     mapping(address => uint256) public balances;
95     mapping(address => mapping(address => uint256)) internal allowed;
96     mapping(address => address) private forbiddenAddresses;
97  
98     /**
99      * @dev Throws if called by any account other than the owner.
100      */
101 
102     modifier onlyOwner() {
103        require(msg.sender == owner, "Caller is not owner");
104        _;
105     }
106     
107     /** constructor **/
108 
109     constructor() public {
110        owner = msg.sender;
111        balances[owner] = totalTokenSupply;
112 
113        emit Transfer(address(0x0), owner, balances[owner]);
114     }
115 
116     /**
117      * @dev To pause token transfer. In general pauseTransfer can be triggered
118      *      only on some specific error conditions 
119      */
120 
121     function pauseTransfer() external onlyOwner {
122         stopped = true;
123     }
124 
125     /**
126      * @dev To resume token transfer
127      */
128 
129     function resumeTransfer() external onlyOwner {
130         stopped = false;
131     }
132 
133     /**
134      * @dev To add address into forbiddenAddresses
135      */
136 
137     function addToForbiddenAddresses(address _newAddr) external onlyOwner {
138        forbiddenAddresses[_newAddr] = _newAddr;
139     }
140 
141     /**
142      * @dev To remove address from forbiddenAddresses
143      */
144 
145     function removeFromForbiddenAddresses(address _newAddr) external onlyOwner {
146        delete forbiddenAddresses[_newAddr];
147     }
148 
149     /**
150      * @dev Burn specified number of HBC tokens from token owner wallet
151      */
152 
153     function burn(uint256 _value) onlyOwner external returns (bool) {
154        require(!stopped, "Paused");
155 
156        address burner = msg.sender;
157 
158        balances[burner] = balances[burner].sub(_value, "burn amount exceeds balance");
159        totalTokenSupply = totalTokenSupply.sub(_value);
160        totalBurned      = totalBurned.add(_value);
161 
162        emit Burn(burner, _value);
163        emit Transfer(burner, address(0x0), _value);
164 
165        return true;
166     }     
167 
168     /**
169      * @dev total number of tokens in existence
170      * @return An uint256 representing the total number of tokens in existence
171      */
172 
173     function totalSupply() external view returns (uint256) { 
174        return totalTokenSupply; 
175     }
176 
177     /**
178      * @dev Gets the balance of the specified address
179      * @param _owner The address to query the the balance of 
180      * @return An uint256 representing the amount owned by the passed address
181      */
182 
183     function balanceOf(address _owner) external view returns (uint256) {
184        return balances[_owner];
185     }
186 
187     /**
188      * @dev Transfer tokens from one address to another
189      * @param _from address The address which you want to send tokens from
190      * @param _to address The address which you want to transfer to
191      * @param _value uint256 the amout of tokens to be transfered
192      */
193 
194     function transferFrom(address _from, address _to, uint256 _value) external returns (bool) {    
195 
196        require(!stopped, "Paused");
197  
198        require(_to != address(0x0), "ERC20: transferring to zero address");
199 
200        require(_from != address(0x0), "ERC20: transferring from zero address");
201 
202        require(forbiddenAddresses[_from] != _from, "ERC20: transfer from forbidden address");
203 
204        require(forbiddenAddresses[_to] != _to, "ERC20: transfer to forbidden address");
205 
206 
207        if (_value == 0) 
208        {
209            emit Transfer(_from, _to, _value);  // Follow the spec to launch the event when value is equal to 0
210            return true;
211        }
212 
213 
214        require(balances[_from] >= _value && allowed[_from][msg.sender] >= _value && _value >= 0);
215 
216        balances[_from] = balances[_from].sub(_value, "transfer amount exceeds balance");
217        allowed[_from][msg.sender] = allowed[_from][msg.sender].sub(_value);
218        balances[_to] = balances[_to].add(_value);
219 
220        emit Transfer(_from, _to, _value);
221 
222        return true;
223     }
224 
225     /**
226      * @dev Approve the passed address to spend the specified amount of tokens on behalf of msg.sender
227      *
228      * Beware that changing an allowance with this method brings the risk that someone may use both the old
229      * and the new allowance by unfortunate transaction ordering. One possible solution to mitigate this
230      * race condition is to first reduce the spender's allowance to 0 and set the desired value afterwards:
231      * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
232      * @param _spender The address which will spend the funds
233      * @param _tokens The amount of tokens to be spent
234      */
235 
236     function approve(address _spender, uint256 _tokens) external returns(bool) {
237 
238        require(!stopped, "Paused");
239 
240        require(_spender != address(0x0));
241 
242        allowed[msg.sender][_spender] = _tokens;
243 
244        emit Approval(msg.sender, _spender, _tokens);
245 
246        return true;
247     }
248 
249     /**
250      * @dev Function to check the amount of tokens that an owner allowed to a spender
251      * @param _owner address The address which owns the funds
252      * @param _spender address The address which will spend the funds
253      * @return A uint256 specifing the amount of tokens still avaible for the spender
254      */
255 
256     function allowance(address _owner, address _spender) external view returns(uint256) {
257 
258        require(!stopped, "Paused");
259 
260        require(_owner != address(0x0) && _spender != address(0x0));
261 
262        return allowed[_owner][_spender];
263     }
264 
265     /**
266      * @dev transfer token for a specified address
267      * @param _address The address to transfer to
268      * @param _tokens The amount to be transferred
269      */
270 
271     function transfer(address _address, uint256 _tokens) external returns(bool) {
272 
273        require(!stopped, "Paused");
274 
275        require(_address != address(0x0), "ERC20: transferring to zero address");
276 
277        require(forbiddenAddresses[msg.sender] != msg.sender, "ERC20: transfer from forbidden address");
278 
279        require(forbiddenAddresses[_address] != _address, "ERC20: transfer to forbidden address");
280 
281        if (_tokens == 0) 
282        {
283            emit Transfer(msg.sender, _address, _tokens);  // Follow the spec to launch the event when tokens are equal to 0
284            return true;
285        }
286 
287 
288        require(balances[msg.sender] >= _tokens);
289 
290        balances[msg.sender] = (balances[msg.sender]).sub(_tokens, "transfer amount exceeds balance");
291        balances[_address] = (balances[_address]).add(_tokens);
292 
293        emit Transfer(msg.sender, _address, _tokens);
294 
295        return true;
296     }
297 
298     /**
299      * @dev transfer ownership of this contract, only by owner
300      * @param _newOwner The address of the new owner to transfer ownership
301      */
302 
303     function transferOwnership(address _newOwner) external onlyOwner {
304 
305        uint256 ownerBalances;
306 
307        require(!stopped, "Paused");
308 
309        require( _newOwner != address(0x0), "ERC20: transferOwnership address is zero address");
310 
311        ownerBalances = balances[owner];
312 
313        balances[_newOwner] = (balances[_newOwner]).add(balances[owner]);
314        balances[owner] = 0;
315        owner = _newOwner;
316 
317        emit Transfer(msg.sender, _newOwner, ownerBalances);
318    }
319 
320    /**
321     * @dev Allows the current owner to relinquish control of the contract
322     * @notice Renouncing to ownership will leave the contract without an owner
323     * It will not be possible to call the functions with the `onlyOwner`
324     * modifier anymore
325     */
326 
327    function renounceOwnership() external onlyOwner {
328 
329       require(!stopped, "Paused");
330 
331       owner = address(0x0);
332       emit OwnershipRenounced(owner);
333    }
334 
335    /**
336     * @dev Increase the amount of tokens that an owner allowed to a spender
337     */
338 
339    function increaseApproval(address _spender, uint256 _addedValue) external returns (bool success) {
340 
341       require(!stopped, "Paused");
342 
343       allowed[msg.sender][_spender] = allowed[msg.sender][_spender].add(_addedValue);
344       emit Approval(msg.sender, _spender, allowed[msg.sender][_spender]);
345 
346       return true;
347    }
348 
349    /**
350     * @dev Decrease the amount of tokens that an owner allowed to a spender
351     */
352 
353    function decreaseApproval(address _spender, uint256 _subtractedValue) external returns (bool success) {
354 
355       uint256 oldValue = allowed[msg.sender][_spender];
356 
357       require(!stopped, "Paused");
358 
359       if (_subtractedValue > oldValue) 
360       {
361          allowed[msg.sender][_spender] = 0;
362       }
363       else 
364       {
365          allowed[msg.sender][_spender] = oldValue.sub(_subtractedValue);
366       }
367 
368       emit Approval(msg.sender, _spender, allowed[msg.sender][_spender]);
369 
370       return true;
371    }
372 
373 }