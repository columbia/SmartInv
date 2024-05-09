1 pragma solidity ^0.4.25;
2 
3 library SafeMath {
4   function add(uint256 a, uint256 b) internal pure returns (uint256 c) {
5       c = a + b;
6       require(c >= a);
7   }
8   function sub(uint256 a, uint256 b) internal pure returns (uint256 c) {
9       require(b <= a);
10       c = a - b;
11   }
12   function mul(uint256 a, uint256 b) internal pure returns (uint256 c) {
13       c = a * b;
14       require(a == 0 || c / a == b);
15   }
16   function div(uint256 a, uint256 b) internal pure returns (uint256 c) {
17       require(b > 0);
18       c = a / b;
19   }
20 }
21 
22 contract ERC20Interface {
23   function totalSupply() public constant returns (uint256);
24   function balanceOf(address tokenOwner) public constant returns (uint256 balance);
25   function allowance(address tokenOwner, address spender) public constant returns (uint256 remaining);
26   function transfer(address to, uint256 tokens) public returns (bool success);
27   function approve(address spender, uint256 tokens) public returns (bool success);
28   function transferFrom(address from, address to, uint256 tokens) public returns (bool success);
29 
30   event Transfer(address indexed from, address indexed to, uint256 tokens);
31   event Approval(address indexed tokenOwner, address indexed spender, uint256 tokens);
32   event Burn(address indexed from, uint256 value);
33 }
34 
35 contract Owned {
36   address public owner;
37   address public newOwner;
38 
39   event OwnershipTransferred(address indexed from, address indexed _to);
40 
41   constructor() public {
42     owner = msg.sender;
43   }
44 
45   modifier onlyOwner {
46     require(msg.sender == owner);
47     _;
48   }
49 
50   function transferOwnership(address _newOwner) public onlyOwner {
51     newOwner = _newOwner;
52   }
53   function acceptOwnership() public {
54     require(msg.sender == newOwner);
55     owner = newOwner;
56     newOwner = address(0);
57     emit OwnershipTransferred(owner, newOwner);
58   }
59 }
60 
61 contract Pausable is Owned {
62   event Pause();
63   event Unpause();
64 
65   bool public paused = false;
66 
67   modifier whenNotPaused() {
68     require(!paused);
69     _;
70   }
71 
72   modifier whenPaused() {
73     require(paused);
74     _;
75   }
76 
77   function pause() onlyOwner whenNotPaused public {
78     paused = true;
79     emit Pause();
80   }
81 
82   function unpause() onlyOwner whenPaused public {
83     paused = false;
84     emit Unpause();
85   }
86 }
87 
88 contract EuroX is ERC20Interface, Owned, Pausable {
89   using SafeMath for uint256;
90 
91   string public symbol;
92   string public name;
93   uint8 public decimals;
94   uint256 _totalSupply;
95 
96   mapping(address => uint256) balances;
97   mapping(address => mapping(address => uint256)) allowed;
98 
99   constructor() public {
100     symbol = "EUROX";
101     name = "EuroX";
102     decimals = 18;
103     _totalSupply = 100000 * 10 ** uint256(decimals);
104     balances[owner] = _totalSupply;
105     emit Transfer(address(0), owner, _totalSupply);
106   }
107   
108   modifier onlyPayloadSize(uint256 numWords) {
109     assert(msg.data.length >= numWords * 32 + 4);
110     _;
111   }
112     
113  /**
114   * @dev function to check whether passed address is a contract address
115   */
116     function isContract(address _address) private view returns (bool is_contract) {
117       uint256 length;
118       assembly {
119       //retrieve the size of the code on target address, this needs assembly
120         length := extcodesize(_address)
121       }
122       return (length > 0);
123     }
124     
125   /**
126   * @dev Total number of tokens in existence
127   */
128     function totalSupply() public view returns (uint256) {
129       return _totalSupply;
130     }
131     
132     
133  /**
134   * @dev Gets the balance of the specified address.
135   * @param tokenOwner The address to query the the balance of.
136   * @return An uint256 representing the amount owned by the passed address.
137   */
138 
139   function balanceOf(address tokenOwner) public view returns (uint256 balance) {
140     return balances[tokenOwner];
141   }
142 
143 
144  /**
145    * @dev Function to check the amount of tokens that an owner allowed to a spender.
146    * @param tokenOwner address The address which owns the funds.
147    * @param spender address The address which will spend the funds.
148    * @return A uint256 specifying the amount of tokens still available for the spender.
149    */
150   function allowance(address tokenOwner, address spender) public view returns (uint256 remaining) {
151     return allowed[tokenOwner][spender];
152   }
153     
154     
155  /**
156   * @dev Transfer token for a specified address
157   * @param to The address to transfer to.
158   * @param tokens The amount to be transferred.
159   */
160   function transfer(address to, uint256 tokens) public whenNotPaused onlyPayloadSize(2) returns (bool success) {
161     require(to != address(0));
162     require(tokens > 0);
163     require(tokens <= balances[msg.sender]);
164     balances[msg.sender] = balances[msg.sender].sub(tokens);
165     balances[to] = balances[to].add(tokens);
166     emit Transfer(msg.sender, to, tokens);
167     return true;
168   }
169  /**
170    * @dev Approve the passed address to spend the specified amount of tokens on behalf of msg.sender.
171    * @param spender The address which will spend the funds.
172    * @param tokens The amount of tokens to be spent.
173    */
174   function approve(address spender, uint256 tokens) public whenNotPaused onlyPayloadSize(2) returns (bool success) {
175     require(spender != address(0));
176     allowed[msg.sender][spender] = tokens;
177     emit Approval(msg.sender, spender, tokens);
178     return true;
179   }
180 
181     
182  /**
183    * @dev Transfer tokens from one address to another
184    * @param from address The address which you want to send tokens from
185    * @param to address The address which you want to transfer to
186    * @param tokens uint256 the amount of tokens to be transferred
187    */
188     function transferFrom(address from, address to, uint256 tokens) public whenNotPaused onlyPayloadSize(3) returns (bool success) {
189         require(tokens > 0);
190         require(from != address(0));
191         require(to != address(0));
192         require(allowed[from][msg.sender] > 0);
193         require(balances[from]>0);
194         balances[from] = balances[from].sub(tokens);
195         allowed[from][msg.sender] = allowed[from][msg.sender].sub(tokens);
196         balances[to] = balances[to].add(tokens);
197         emit Transfer(from, to, tokens);
198         return true;
199     }
200  
201 
202  /**
203    * @dev Burns a specific amount of tokens.
204    * @param _value The amount of token to be burned.
205    */
206     function burn(uint256 _value) public returns (bool success) {
207         require(balances[msg.sender] >= _value);
208         balances[msg.sender] = balances[msg.sender].sub(_value);
209         _totalSupply =_totalSupply.sub(_value);
210         emit Burn(msg.sender, _value);
211         return true;
212     }
213   
214   /**
215    * @dev Burns a specific amount of tokens from the target address and decrements allowance
216    * @param from address The address which you want to send tokens from
217    * @param _value uint256 The amount of token to be burned
218    */
219     function burnFrom(address from, uint256 _value) public returns (bool success) {
220         require(balances[from] >= _value);
221         require(_value <= allowed[from][msg.sender]);
222         balances[from] = balances[from].sub(_value);
223         allowed[from][msg.sender] = allowed[from][msg.sender].sub(_value);
224         _totalSupply = _totalSupply.sub(_value);
225         emit Burn(from, _value);
226         return true;
227     }
228  /**
229    * @dev Function to mint tokens
230    * @param target The address that will receive the minted tokens.
231    * @param mintedAmount The amount of tokens to mint.
232    * @return A boolean that indicates if the operation was successful.
233    */
234     function mintToken(address target, uint256 mintedAmount) onlyOwner public  returns (bool) {
235         require(mintedAmount > 0);
236         require(target != address(0));
237         balances[target] = balances[target].add(mintedAmount);
238         _totalSupply = _totalSupply.add(mintedAmount);
239         emit Transfer(owner, target, mintedAmount);
240         return true;
241     }
242 
243     function () public payable {
244         revert();
245     }
246     
247     
248 /**
249    * @dev Function to transfer any ERC20 token  to owner address which gets accidentally transferred to this contract
250    * @param tokenAddress The address of the ERC20 contract
251    * @param tokens The amount of tokens to transfer.
252    * @return A boolean that indicates if the operation was successful.
253    */
254     function transferAnyERC20Token(address tokenAddress, uint256 tokens) public onlyOwner returns (bool success) {
255         require(tokenAddress != address(0));
256         require(isContract(tokenAddress));
257         return ERC20Interface(tokenAddress).transfer(owner, tokens);
258     }
259 }