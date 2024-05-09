1 pragma solidity 0.5.17;
2 
3 library SafeMath {
4 
5     function mul(uint256 a, uint256 b) internal pure returns (uint256) {
6         if (a == 0) 
7             return 0;
8         uint256 c = a * b;
9         require(c / a == b);
10         return c;
11     }
12 
13     function div(uint256 a, uint256 b) internal pure returns (uint256) {
14         require(b > 0);
15         uint256 c = a / b;
16         return c;
17     }
18 
19     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
20         require(b <= a);
21         uint256 c = a - b;
22         return c;
23     }
24 
25     function add(uint256 a, uint256 b) internal pure returns (uint256) {
26         uint256 c = a + b;
27         require(c >= a);
28         return c;
29     }
30 
31     function mod(uint256 a, uint256 b) internal pure returns (uint256) {
32         require(b != 0);
33         return a % b;
34     }
35 }
36 
37 contract Ownable {
38     address public owner;
39 
40     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
41 
42     constructor() public {
43         owner = msg.sender;
44     }
45 
46     modifier onlyOwner() {
47         require(msg.sender == owner, "permission denied");
48         _;
49     }
50 
51     function transferOwnership(address newOwner) public onlyOwner {
52         require(newOwner != address(0), "invalid address");
53         emit OwnershipTransferred(owner, newOwner);
54         owner = newOwner;
55     }
56 }
57 
58 contract ERC20 {
59     using SafeMath for uint256;
60 
61     mapping (address => uint256) internal _balances;
62     mapping (address => mapping (address => uint256)) internal _allowed;
63     
64     event Transfer(address indexed from, address indexed to, uint256 value);
65     event Approval(address indexed owner, address indexed spender, uint256 value);
66 
67     uint256 internal _totalSupply;
68 
69     /**
70     * @dev Total number of tokens in existence
71     */
72     function totalSupply() public view returns (uint256) {
73         return _totalSupply;
74     }
75 
76     /**
77     * @dev Gets the balance of the specified address.
78     * @param owner The address to query the balance of.
79     * @return A uint256 representing the amount owned by the passed address.
80     */
81     function balanceOf(address owner) public view returns (uint256) {
82         return _balances[owner];
83     }
84 
85     /**
86     * @dev Function to check the amount of tokens that an owner allowed to a spender.
87     * @param owner address The address which owns the funds.
88     * @param spender address The address which will spend the funds.
89     * @return A uint256 specifying the amount of tokens still available for the spender.
90     */
91     function allowance(address owner, address spender) public view returns (uint256) {
92         return _allowed[owner][spender];
93     }
94 
95     /**
96     * @dev Transfer token to a specified address
97     * @param to The address to transfer to.
98     * @param value The amount to be transferred.
99     */
100     function transfer(address to, uint256 value) public returns (bool) {
101         _transfer(msg.sender, to, value);
102         return true;
103     }
104 
105     /**
106     * @dev Approve the passed address to spend the specified amount of tokens on behalf of msg.sender.
107     * Beware that changing an allowance with this method brings the risk that someone may use both the old
108     * and the new allowance by unfortunate transaction ordering. One possible solution to mitigate this
109     * race condition is to first reduce the spender's allowance to 0 and set the desired value afterwards:
110     * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
111     * @param spender The address which will spend the funds.
112     * @param value The amount of tokens to be spent.
113     */
114     function approve(address spender, uint256 value) public returns (bool) {
115         _allowed[msg.sender][spender] = value;
116         emit Approval(msg.sender, spender, value);
117         return true;
118     }
119 
120     /**
121     * @dev Transfer tokens from one address to another.
122     * Note that while this function emits an Approval event, this is not required as per the specification,
123     * and other compliant implementations may not emit the event.
124     * @param from address The address which you want to send tokens from
125     * @param to address The address which you want to transfer to
126     * @param value uint256 the amount of tokens to be transferred
127     */
128     function transferFrom(address from, address to, uint256 value) public returns (bool) {
129         if (from != msg.sender && _allowed[from][msg.sender] != uint256(-1))
130             _allowed[from][msg.sender] = _allowed[from][msg.sender].sub(value);
131         _transfer(from, to, value);
132         return true;
133     }
134 
135     function _transfer(address from, address to, uint256 value) internal {
136         require(to != address(0));
137         _balances[from] = _balances[from].sub(value);
138         _balances[to] = _balances[to].add(value);
139         emit Transfer(from, to, value);
140     }
141 
142 }
143 
144 contract ERC20Mintable is ERC20 {
145     string public name;
146     string public symbol;
147     uint8 public decimals;
148 
149     function _mint(address to, uint256 amount) internal {
150         _balances[to] = _balances[to].add(amount);
151         _totalSupply = _totalSupply.add(amount);
152         emit Transfer(address(0), to, amount);
153     }
154 
155     function _burn(address from, uint256 amount) internal {
156         _balances[from] = _balances[from].sub(amount);
157         _totalSupply = _totalSupply.sub(amount);
158         emit Transfer(from, address(0), amount);
159     }
160 }
161 
162 contract Seal is ERC20Mintable, Ownable {
163     using SafeMath for uint256;
164     
165     mapping (address => bool) public isMinter;
166 
167     constructor() public {
168         name = "Seal Finance";
169         symbol = "Seal";
170         decimals = 18;
171     }
172 
173     function setMinter(address minter, bool flag) external onlyOwner {
174         isMinter[minter] = flag;
175     }
176 
177     function mint(address to, uint256 amount) external {
178         require(isMinter[msg.sender], "Not Minter");
179         _mint(to, amount);
180     }
181 
182     function burn(address from, uint256 amount) external {
183         if (from != msg.sender && _allowed[from][msg.sender] != uint256(-1))
184             _allowed[from][msg.sender] = _allowed[from][msg.sender].sub(amount);
185         require(_balances[from] >= amount, "insufficient-balance");
186         _burn(from, amount);
187     }
188     
189 }