1 pragma solidity 0.5.8;
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
13     event Burn(address indexed burner, uint256 value);
14 }
15 
16 /**
17  * @title SafeMath
18  * @dev Math operations with safety checks that throw on error
19  */
20 library SafeMath {
21     /**
22      * @dev Multiplies two numbers, throws on overflow
23      */
24     function mul(uint256 a, uint256 b) internal pure returns (uint256) {
25         if (a == 0) {
26             return 0;
27         }
28         uint256 c = a * b;
29         assert(c / a == b);
30         return c;
31     }
32 
33     /**
34      * @dev Integer division of two numbers, truncating the quotient
35      */
36     function div(uint256 a, uint256 b) internal pure returns (uint256) {
37         // assert(b > 0); // Solidity automatically throws when dividing by 0
38         uint256 c = a / b;
39         // assert(a == b * c + a % b); // There is no case in which this doesn't hold
40         return c;
41     }
42 
43     /**
44      * @dev Subtracts two numbers, throws on overflow (i.e. if subtrahend is greater than minuend)
45      */
46     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
47         assert(b <= a);
48         return a - b;
49     }
50 
51     /**
52      * @dev Adds two numbers, throws on overflow
53      */
54     function add(uint256 a, uint256 b) internal pure returns (uint256) {
55         uint256 c = a + b;
56         assert(c >= a);
57         return c;
58     }
59 }
60 
61 /**
62  * @title Basic token
63  * @dev Basic version of StandardToken, with no allowances
64  */
65 contract BasicToken is ERC20Basic {
66     using SafeMath for uint256;
67     
68     mapping(address => uint256) balances;
69     uint256 totalSupply_;
70     uint256 burnedTotalNum_;
71 
72     /**
73      * @dev Total number of tokens in existence
74      */
75     function totalSupply() public view returns (uint256) {
76         return totalSupply_;
77     }
78 
79     /**
80      * @dev Total number of tokens already burned
81      */
82     function totalBurned() public view returns (uint256) {
83         return burnedTotalNum_;
84     }
85 
86     /**
87      * @dev Burn tokens for sender
88      * @param _value The amount to be burned
89      */
90     function burn(uint256 _value) public returns (bool) {
91         require(_value <= balances[msg.sender]);
92 
93         address burner = msg.sender;
94         balances[burner] = balances[burner].sub(_value);
95         totalSupply_ = totalSupply_.sub(_value);
96         burnedTotalNum_ = burnedTotalNum_.add(_value);
97 
98         emit Burn(burner, _value);
99 
100         return true;
101     }
102 
103     /**
104      * @dev Transfer token for a specified address
105      * @param _to The address to transfer to
106      * @param _value The amount to be transferred
107      */
108     function transfer(address _to, uint256 _value) public returns (bool) {
109         // if _to is address(0), invoke burn function
110         if (_to == address(0)) {
111             return burn(_value);
112         }
113 
114         require(_value <= balances[msg.sender]);
115         // SafeMath.sub will throw if there is not enough balance
116         balances[msg.sender] = balances[msg.sender].sub(_value);
117         balances[_to] = balances[_to].add(_value);
118 
119         emit Transfer(msg.sender, _to, _value);
120 
121         return true;
122     }
123 
124     /**
125      * @dev Gets the balance of the specified address
126      * @param _owner The address to query the the balance of
127      * @return An uint256 representing the amount owned by the passed address
128      */
129     function balanceOf(address _owner) public view returns (uint256) {
130         return balances[_owner];
131     }
132 }
133 
134 /**
135  * @title ERC20 interface
136  * @dev see https://github.com/ethereum/EIPs/issues/20
137  */
138 contract ERC20 is ERC20Basic {
139     function allowance(address owner, address spender) public view returns (uint256);
140     function transferFrom(address from, address to, uint256 value) public returns (bool);
141     function approve(address spender, uint256 value) public returns (bool);
142     event Approval(address indexed owner, address indexed spender, uint256 value);
143 }
144 
145 /**
146  * @title Standard ERC20 token
147  *
148  * @dev Implementation of the basic standard token
149  * @dev https://github.com/ethereum/EIPs/issues/20
150  * @dev Based on code by FirstBlood: https://github.com/Firstbloodio/token/blob/master/smart_contract/FirstBloodToken.sol
151  */
152 contract StandardToken is ERC20, BasicToken {
153     using SafeMath for uint256;
154 
155     uint private constant MAX_UINT = 2**256 - 1;
156 
157     mapping (address => mapping (address => uint256)) internal allowed;
158 
159     /**
160      * @dev Burn tokens for a specified address
161      * @param _owner The address which you want to burn
162      * @param _value the amount of tokens to be burned
163      */
164     function burnFrom(address _owner, uint256 _value) public returns (bool) {
165         require(_owner != address(0));
166         require(_value <= balances[_owner]);
167         require(_value <= allowed[_owner][msg.sender]);
168 
169         balances[_owner] = balances[_owner].sub(_value);
170         if (allowed[_owner][msg.sender] < MAX_UINT) {
171             allowed[_owner][msg.sender] = allowed[_owner][msg.sender].sub(_value);
172         }
173         totalSupply_ = totalSupply_.sub(_value);
174         burnedTotalNum_ = burnedTotalNum_.add(_value);
175 
176         emit Burn(_owner, _value);
177 
178         return true;
179     }
180 
181     /**
182      * @dev Transfer tokens from one address to another
183      * @param _from The address which you want to send tokens from
184      * @param _to The address which you want to transfer to
185      * @param _value The amount of tokens to be transferred
186      */
187     function transferFrom(address _from, address _to, uint256 _value) public returns (bool) {
188         if (_to == address(0)) {
189             return burnFrom(_from, _value);
190         }
191 
192         require(_value <= balances[_from]);
193         require(_value <= allowed[_from][msg.sender]);
194         balances[_from] = balances[_from].sub(_value);
195         balances[_to] = balances[_to].add(_value);
196 
197         /// an allowance of MAX_UINT represents an unlimited allowance
198         /// @dev see https://github.com/ethereum/EIPs/issues/717
199         if (allowed[_from][msg.sender] < MAX_UINT) {
200             allowed[_from][msg.sender] = allowed[_from][msg.sender].sub(_value);
201         }
202 
203         emit Transfer(_from, _to, _value);
204 
205         return true;
206     }
207 
208     /**
209      * @dev Approve the passed address to spend the specified amount of tokens on behalf of msg.sender
210      *
211      * Beware that changing an allowance with this method brings the risk that someone may use both the old
212      * and the new allowance by unfortunate transaction ordering. One possible solution to mitigate this
213      * race condition is to first reduce the spender's allowance to 0 and set the desired value afterwards:
214      * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
215      * @param _spender The address which will spend the funds
216      * @param _value The amount of tokens to be spent
217      */
218     function approve(address _spender, uint256 _value) public returns (bool) {
219         allowed[msg.sender][_spender] = _value;
220 
221         emit Approval(msg.sender, _spender, _value);
222 
223         return true;
224     }
225 
226     /**
227      * @dev Function to check the amount of tokens that an owner allowed to a spender
228      * @param _owner The address which owns the funds
229      * @param _spender The address which will spend the funds
230      * @return A uint256 specifying the amount of tokens still available for the spender
231      */
232     function allowance(address _owner, address _spender) public view returns (uint256) {
233         return allowed[_owner][_spender];
234     }
235 
236     /**
237      * @dev Increase the amount of tokens that an owner allowed to a spender
238      *
239      * approve should be called when allowed[_spender] == 0. To increment
240      * allowed value is better to use this function to avoid 2 calls (and wait until
241      * the first transaction is mined)
242      * From MonolithDAO Token.sol
243      * @param _spender The address which will spend the funds
244      * @param _addedValue The amount of tokens to increase the allowance by
245      */
246     function increaseApproval(address _spender, uint _addedValue) public returns (bool) {
247         allowed[msg.sender][_spender] = allowed[msg.sender][_spender].add(_addedValue);
248 
249         emit Approval(msg.sender, _spender, allowed[msg.sender][_spender]);
250 
251         return true;
252     }
253 
254     /**
255      * @dev Decrease the amount of tokens that an owner allowed to a spender
256      *
257      * approve should be called when allowed[_spender] == 0. To decrement
258      * allowed value is better to use this function to avoid 2 calls (and wait until
259      * the first transaction is mined)
260      * From MonolithDAO Token.sol
261      * @param _spender The address which will spend the funds
262      * @param _subtractedValue The amount of tokens to decrease the allowance by
263      */
264     function decreaseApproval(address _spender, uint _subtractedValue) public returns (bool) {
265         uint oldValue = allowed[msg.sender][_spender];
266         if (_subtractedValue > oldValue) {
267             allowed[msg.sender][_spender] = 0;
268         } else {
269             allowed[msg.sender][_spender] = oldValue.sub(_subtractedValue);
270         }
271 
272         emit Approval(msg.sender, _spender, allowed[msg.sender][_spender]);
273 
274         return true;
275     }
276 }
277 
278 contract HBBToken is StandardToken {
279     using SafeMath for uint256;
280 
281     string     public name = "HBB";
282     string     public symbol = "HBB";
283     uint8      public decimals = 18;
284 
285     constructor() public {
286         totalSupply_ = 33333333333000000000000000000;
287 
288         balances[msg.sender] = totalSupply_;
289     }
290 
291     function () payable external {
292         revert();
293     }
294 
295     function batchTransfer(address[] calldata accounts, uint256[] calldata amounts) external returns (bool) {
296         require(accounts.length == amounts.length);
297         for (uint i = 0; i < accounts.length; i++) {
298             require(transfer(accounts[i], amounts[i]), "transfer failed");
299         }
300 
301         return true;
302     }
303 }