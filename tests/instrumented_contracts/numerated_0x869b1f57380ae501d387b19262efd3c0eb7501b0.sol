1 pragma solidity 0.4.24;
2 
3 library SafeMath {
4   function add(uint a, uint b) internal pure returns (uint c) {
5       c = a + b;
6       require(c >= a);
7   }
8   function sub(uint a, uint b) internal pure returns (uint c) {
9       require(b <= a);
10       c = a - b;
11   }
12   function mul(uint a, uint b) internal pure returns (uint c) {
13       c = a * b;
14       require(a == 0 || c / a == b);
15   }
16   function div(uint a, uint b) internal pure returns (uint c) {
17       require(b > 0);
18       c = a / b;
19   }
20 }
21 
22 contract ERC20Interface {
23   function totalSupply() public constant returns (uint);
24   function balanceOf(address tokenOwner) public constant returns (uint balance);
25   function allowance(address tokenOwner, address spender) public constant returns (uint remaining);
26   function transfer(address to, uint tokens) public returns (bool success);
27   function approve(address spender, uint tokens) public returns (bool success);
28   function transferFrom(address from, address to, uint tokens) public returns (bool success);
29 
30   event Transfer(address indexed from, address indexed to, uint tokens);
31   event Approval(address indexed tokenOwner, address indexed spender, uint tokens);
32   event Burn(address indexed from, uint value);
33 }
34 
35 
36 
37 contract Owned {
38   address public owner;
39   address public newOwner;
40 
41   event OwnershipTransferred(address indexed from, address indexed _to);
42 
43   constructor() public {
44     owner = msg.sender;
45   }
46 
47   modifier onlyOwner {
48     require(msg.sender == owner);
49     _;
50   }
51 
52   function transferOwnership(address _newOwner) public onlyOwner {
53     newOwner = _newOwner;
54   }
55   function acceptOwnership() public {
56     require(msg.sender == newOwner);
57     owner = newOwner;
58     newOwner = address(0);
59     emit OwnershipTransferred(owner, newOwner);
60   }
61 }
62 
63 contract Pausable is Owned {
64   event Pause();
65   event Unpause();
66 
67   bool public paused = false;
68 
69   modifier whenNotPaused() {
70     require(!paused);
71     _;
72   }
73 
74   modifier whenPaused() {
75     require(paused);
76     _;
77   }
78 
79   function pause() onlyOwner whenNotPaused public {
80     paused = true;
81     emit Pause();
82   }
83 
84   function unpause() onlyOwner whenPaused public {
85     paused = false;
86     emit Unpause();
87   }
88 }
89 
90 contract OxyCoin is ERC20Interface, Owned, Pausable {
91   using SafeMath for uint;
92 
93   string public symbol;
94   string public name;
95   uint8 public decimals;
96   uint _totalSupply;
97 
98   mapping(address => uint) balances;
99   mapping(address => mapping(address => uint)) allowed;
100 
101   constructor() public {
102     symbol = "OXY";
103     name = "Oxycoin";
104     decimals = 18;
105     _totalSupply = 1200000000 * 10 ** uint(decimals);
106     balances[owner] = _totalSupply;
107     emit Transfer(address(0), owner, _totalSupply);
108   }
109   
110   modifier onlyPayloadSize(uint numWords) {
111     assert(msg.data.length >= numWords * 32 + 4);
112     _;
113   }
114     
115  /**
116   * @dev function to check whether passed address is a contract address
117   */
118     function isContract(address _address) private view returns (bool is_contract) {
119       uint256 length;
120       assembly {
121       //retrieve the size of the code on target address, this needs assembly
122         length := extcodesize(_address)
123       }
124       return (length > 0);
125     }
126     
127   /**
128   * @dev Total number of tokens in existence
129   */
130     function totalSupply() public view returns (uint) {
131       return _totalSupply;
132     }
133     
134     
135  /**
136   * @dev Gets the balance of the specified address.
137   * @param tokenOwner The address to query the the balance of.
138   * @return An uint representing the amount owned by the passed address.
139   */
140 
141   function balanceOf(address tokenOwner) public view returns (uint balance) {
142     return balances[tokenOwner];
143   }
144 
145 
146  /**
147    * @dev Function to check the amount of tokens that an owner allowed to a spender.
148    * @param tokenOwner address The address which owns the funds.
149    * @param spender address The address which will spend the funds.
150    * @return A uint specifying the amount of tokens still available for the spender.
151    */
152   function allowance(address tokenOwner, address spender) public view returns (uint remaining) {
153     return allowed[tokenOwner][spender];
154   }
155     
156     
157  /**
158   * @dev Transfer token for a specified address
159   * @param to The address to transfer to.
160   * @param tokens The amount to be transferred.
161   */
162   function transfer(address to, uint tokens) public whenNotPaused onlyPayloadSize(2) returns (bool success) {
163     require(to != address(0));
164     require(tokens > 0);
165     require(tokens <= balances[msg.sender]);
166     balances[msg.sender] = balances[msg.sender].sub(tokens);
167     balances[to] = balances[to].add(tokens);
168     emit Transfer(msg.sender, to, tokens);
169     return true;
170   }
171 /**
172    * @dev Approve the passed address to spend the specified amount of tokens on behalf of msg.sender.
173    * Beware that changing an allowance with this method brings the risk that someone may use both the old
174    * and the new allowance by unfortunate transaction ordering. One possible solution to mitigate this
175    * race condition is to first reduce the spender's allowance to 0 and set the desired value afterwards:
176    * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
177    * @param spender The address which will spend the funds.
178    * @param tokens The amount of tokens to be spent.
179    */
180   function approve(address spender, uint tokens) public whenNotPaused onlyPayloadSize(2) returns (bool success) {
181     require(spender != address(0));
182     allowed[msg.sender][spender] = tokens;
183     emit Approval(msg.sender, spender, tokens);
184     return true;
185   }
186     
187      /**
188    * @dev Transfer tokens from one address to another
189    * @param from address The address which you want to send tokens from
190    * @param to address The address which you want to transfer to
191    * @param tokens uint256 the amount of tokens to be transferred
192    */
193 
194 
195     function transferFrom(address from, address to, uint tokens) public whenNotPaused onlyPayloadSize(3) returns (bool success) {
196         require(tokens > 0);
197         require(from != address(0));
198         require(to != address(0));
199         require(allowed[from][msg.sender] > 0);
200         require(balances[from]>0);
201         balances[from] = balances[from].sub(tokens);
202         allowed[from][msg.sender] = allowed[from][msg.sender].sub(tokens);
203         balances[to] = balances[to].add(tokens);
204         emit Transfer(from, to, tokens);
205         return true;
206     }
207  
208 
209    /**
210    * @dev Burns a specific amount of tokens.
211    * @param _value The amount of token to be burned.
212    */
213     function burn(uint _value) public returns (bool success) {
214         require(balances[msg.sender] >= _value);
215         balances[msg.sender] = balances[msg.sender].sub(_value);
216         _totalSupply =_totalSupply.sub(_value);
217         emit Burn(msg.sender, _value);
218         return true;
219     }
220   
221   /**
222    * @dev Burns a specific amount of tokens from the target address and decrements allowance
223    * @param from address The address which you want to send tokens from
224    * @param _value uint256 The amount of token to be burned
225    */
226     function burnFrom(address from, uint _value) public returns (bool success) {
227         require(balances[from] >= _value);
228         require(_value <= allowed[from][msg.sender]);
229         balances[from] = balances[from].sub(_value);
230         allowed[from][msg.sender] = allowed[from][msg.sender].sub(_value);
231         _totalSupply = _totalSupply.sub(_value);
232         emit Burn(from, _value);
233         return true;
234     }
235  /**
236    * @dev Function to mint tokens
237    * @param target The address that will receive the minted tokens.
238    * @param mintedAmount The amount of tokens to mint.
239    * @return A boolean that indicates if the operation was successful.
240    */
241     function mintToken(address target, uint mintedAmount) onlyOwner public  returns (bool) {
242         require(mintedAmount > 0);
243         require(target != address(0));
244         balances[target] = balances[target].add(mintedAmount);
245         _totalSupply = _totalSupply.add(mintedAmount);
246         emit Transfer(owner, target, mintedAmount);
247         return true;
248     }
249 
250     function () public payable {
251         revert();
252     }
253     
254     
255 /**
256    * @dev Function to transfer any ERC20 token  to owner address which gets accidentally transferred to this contract
257    * @param tokenAddress The address of the ERC20 contract
258    * @param tokens The amount of tokens to transfer.
259    * @return A boolean that indicates if the operation was successful.
260    */
261     function transferAnyERC20Token(address tokenAddress, uint tokens) public onlyOwner returns (bool success) {
262         require(tokenAddress != address(0));
263         require(isContract(tokenAddress));
264         return ERC20Interface(tokenAddress).transfer(owner, tokens);
265     }
266 }