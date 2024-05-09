1 pragma solidity >=0.4.22 <0.6.0;
2 
3 /**
4  * @title SafeMath
5  *  Math operations with safety checks that throw on error
6  */
7 library SafeMath {
8 
9   /**
10   *  Multiplies two numbers, throws on overflow.
11   */
12   function mul(uint256 a, uint256 b) internal pure returns (uint256 c) {
13     if (a == 0) {
14         return 0;
15     }
16     c = a * b;
17     assert(c / a == b);
18     return c;
19   }
20 
21   /**
22   *  Integer division of two numbers, truncating the quotient.
23   */
24   function div(uint256 a, uint256 b) internal pure returns (uint256) {
25     // assert(b > 0); // Solidity automatically throws when dividing by 0
26     // uint256 c = a / b;
27     // assert(a == b * c + a % b); // There is no case in which this doesn't hold
28     return a / b;
29   }
30 
31   /**
32   *  Subtracts two numbers, throws on overflow (i.e. if subtrahend is greater than minuend).
33   */
34   function sub(uint256 a, uint256 b) internal pure returns (uint256) {
35     assert(b <= a);
36     return a - b;
37   }
38 
39   /**
40   *  Adds two numbers, throws on overflow.
41   */
42   function add(uint256 a, uint256 b) internal pure returns (uint256 c) {
43     c = a + b;
44     assert(c >= a);
45     return c;
46   }
47 }
48 
49 
50 contract Ownable {
51     address public owner;
52 
53     constructor() public {
54         owner = msg.sender;
55     }
56 
57     modifier onlyOwner {
58         require(msg.sender == owner);
59         _;
60     }
61 }
62 
63 contract TokenERC20 is Ownable {
64     using SafeMath for uint256;
65 
66     // Public variables of the token
67     string public name;
68     string public symbol;
69     uint8 public decimals;
70 
71     uint256 private _totalSupply;
72     uint256 public cap;
73 
74     // This creates an array with all balances
75     mapping (address => uint256) private _balances;
76     mapping (address => mapping (address => uint256)) private _allowed;
77 
78     // This generates a public event on the blockchain that will notify clients
79     event Transfer(address indexed from, address indexed to, uint256 value);
80 
81     // This generates a public event on the blockchain that will notify clients
82     event Approval(address indexed owner, address indexed spender, uint256 value);
83 
84     // This generates a public event on the blockchain that will notify clients
85     event Mint(address indexed to, uint256 amount);
86 
87     /**
88      * @dev Fix for the ERC20 short address attack.
89      */
90     modifier onlyPayloadSize(uint size) {
91         require(msg.data.length >= size + 4);
92         _;
93     }
94 
95     /**
96      * Constrctor function
97      *
98      * Initializes contract with initial supply tokens to the creator of the contract
99      */
100     constructor(
101         uint256 _cap,
102         uint256 _initialSupply,
103         string memory _name,
104         string memory _symbol,
105         uint8 _decimals
106     ) public {
107         require(_cap >= _initialSupply);
108 
109         cap = _cap;
110         name = _name;                                       // Set the cap of total supply
111         symbol = _symbol;                                   // Set the symbol for display purposes
112         decimals = _decimals;                               // Set the decimals
113 
114         _totalSupply = _initialSupply;                      // Update total supply with the decimal amount
115         _balances[owner] = _totalSupply;                    // Give the creator all initial tokens
116         emit Transfer(address(0), owner, _totalSupply);
117     }
118 
119     /**
120      * Total number of tokens in existence.
121      */
122     function totalSupply() public view returns (uint256) {
123         return _totalSupply;
124     }
125 
126     /**
127      * Gets the balance of the specified address.
128      * @param _owner The address to query the balance of.
129      * @return A uint256 representing the amount owned by the passed address.
130      */
131     function balanceOf(address _owner) public view returns (uint256) {
132         return _balances[_owner];
133     }
134 
135     /**
136      * Function to check the amount of tokens that an owner allowed to a spender.
137      * @param _owner address The address which owns the funds.
138      * @param _spender address The address which will spend the funds.
139      * @return A uint256 specifying the amount of tokens still available for the spender.
140      */
141     function allowance(address _owner, address _spender) public view returns (uint256) {
142         return _allowed[_owner][_spender];
143     }
144 
145     /**
146      * Transfer token to a specified address.
147      * @param _to The address to transfer to.
148      * @param _value The amount to be transferred.
149      */
150     function transfer(address _to, uint256 _value) onlyPayloadSize(2 * 32) public returns (bool) {
151         _transfer(msg.sender, _to, _value);
152         return true;
153     }
154 
155     /**
156      * Approve the passed address to spend the specified amount of tokens on behalf of msg.sender.
157      * Beware that changing an allowance with this method brings the risk that someone may use both the old
158      * and the new allowance by unfortunate transaction ordering. One possible solution to mitigate this
159      * race condition is to first reduce the spender's allowance to 0 and set the desired value afterwards:
160      * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
161      * @param _spender The address which will spend the funds.
162      * @param _value The amount of tokens to be spent.
163      */
164     function approve(address _spender, uint256 _value) public returns (bool) {
165         _approve(msg.sender, _spender, _value);
166         return true;
167     }
168 
169     /**
170      * Transfer tokens from one address to another.
171      * Note that while this function emits an Approval event, this is not required as per the specification,
172      * and other compliant implementations may not emit the event.
173      * @param _from address The address which you want to send tokens from
174      * @param _to address The address which you want to transfer to
175      * @param _value uint256 the amount of tokens to be transferred
176      */
177     function transferFrom(address _from, address _to, uint256 _value) onlyPayloadSize(3 * 32) public returns (bool) {
178         _transfer(_from, _to, _value);
179         _approve(_from, msg.sender, _allowed[_from][msg.sender].sub(_value));
180         return true;
181     }
182 
183     /**
184      * Transfer token for a specified addresses.
185      * @param _from The address to transfer from.
186      * @param _to The address to transfer to.
187      * @param _value The amount to be transferred.
188      */
189     function _transfer(address _from, address _to, uint256 _value) internal {
190         require(_to != address(0), "ERC20: transfer to the zero address");
191 
192         _balances[_from] = _balances[_from].sub(_value);
193         _balances[_to] = _balances[_to].add(_value);
194         emit Transfer(_from, _to, _value);
195     }
196 
197     /**
198      * Approve an address to spend another addresses' tokens.
199      * @param _owner The address that owns the tokens.
200      * @param _spender The address that will spend the tokens.
201      * @param _value The number of tokens that can be spent.
202      */
203     function _approve(address _owner, address _spender, uint256 _value) internal {
204         require(_owner != address(0), "ERC20: approve from the zero address");
205         require(_spender != address(0), "ERC20: approve to the zero address");
206 
207         _allowed[_owner][_spender] = _value;
208         emit Approval(_owner, _spender, _value);
209     }
210 
211     /**
212      * Function to mint tokens
213      * @param _to The address that will receive the minted tokens.
214      * @param _amount The amount of tokens to mint.
215      * @return A boolean that indicates if the operation was successful.
216      */
217     function mint(address _to, uint256 _amount) onlyOwner public returns (bool) {
218         require(_totalSupply.add(_amount) <= cap);
219 
220         _totalSupply = _totalSupply.add(_amount);
221         _balances[_to] = _balances[_to].add(_amount);
222         emit Mint(_to, _amount);
223         emit Transfer(address(0), _to, _amount);
224         return true;
225     }
226 
227     /**
228      * Transfer token to servral addresses.
229      * @param _tos The addresses to transfer to.
230      * @param _values The amounts to be transferred.
231      */
232     function transferBatch(address[] memory _tos, uint256[] memory _values) public returns (bool) {
233         require(_tos.length == _values.length);
234 
235         for (uint256 i = 0; i < _tos.length; i++) {
236             transfer(_tos[i], _values[i]);
237         }
238         return true;
239     }
240 }
241 
242 /******************************************/
243 /*       XLToken TOKEN STARTS HERE       */
244 /******************************************/
245 
246 contract XLToken is TokenERC20 {
247     /* Initializes contract with initial supply tokens to the creator of the contract */
248     constructor() TokenERC20(18*10**16, 12*10**16, "XL Token", "XL", 8) public {}
249 }