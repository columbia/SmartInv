1 /**
2  *Submitted for verification at Etherscan.io on 2020-10-10
3  */
4 
5 pragma solidity 0.5.17;
6 
7 library SafeMath {
8     function mul(uint256 a, uint256 b) internal pure returns (uint256) {
9         if (a == 0) return 0;
10         uint256 c = a * b;
11         require(c / a == b);
12         return c;
13     }
14 
15     function div(uint256 a, uint256 b) internal pure returns (uint256) {
16         require(b > 0);
17         uint256 c = a / b;
18         return c;
19     }
20 
21     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
22         require(b <= a);
23         uint256 c = a - b;
24         return c;
25     }
26 
27     function add(uint256 a, uint256 b) internal pure returns (uint256) {
28         uint256 c = a + b;
29         require(c >= a);
30         return c;
31     }
32 
33     function mod(uint256 a, uint256 b) internal pure returns (uint256) {
34         require(b != 0);
35         return a % b;
36     }
37 }
38 
39 contract Ownable {
40     address public owner;
41 
42     event OwnershipTransferred(
43         address indexed previousOwner,
44         address indexed newOwner
45     );
46 
47     constructor() public {
48         owner = msg.sender;
49     }
50 
51     modifier onlyOwner() {
52         require(msg.sender == owner, "permission denied");
53         _;
54     }
55 
56     function transferOwnership(address newOwner) public onlyOwner {
57         require(newOwner != address(0), "invalid address");
58         emit OwnershipTransferred(owner, newOwner);
59         owner = newOwner;
60     }
61 }
62 
63 contract ERC20 {
64     using SafeMath for uint256;
65 
66     mapping(address => uint256) internal _balances;
67     mapping(address => mapping(address => uint256)) internal _allowed;
68 
69     event Transfer(address indexed from, address indexed to, uint256 value);
70     event Approval(
71         address indexed owner,
72         address indexed spender,
73         uint256 value
74     );
75 
76     uint256 internal _totalSupply;
77 
78     /**
79      * @dev Total number of tokens in existence
80      */
81     function totalSupply() public view returns (uint256) {
82         return _totalSupply;
83     }
84 
85     /**
86      * @dev Gets the balance of the specified address.
87      * @param owner The address to query the balance of.
88      * @return A uint256 representing the amount owned by the passed address.
89      */
90     function balanceOf(address owner) public view returns (uint256) {
91         return _balances[owner];
92     }
93 
94     /**
95      * @dev Function to check the amount of tokens that an owner allowed to a spender.
96      * @param owner address The address which owns the funds.
97      * @param spender address The address which will spend the funds.
98      * @return A uint256 specifying the amount of tokens still available for the spender.
99      */
100     function allowance(address owner, address spender)
101         public
102         view
103         returns (uint256)
104     {
105         return _allowed[owner][spender];
106     }
107 
108     /**
109      * @dev Transfer token to a specified address
110      * @param to The address to transfer to.
111      * @param value The amount to be transferred.
112      */
113     function transfer(address to, uint256 value) public returns (bool) {
114         _transfer(msg.sender, to, value);
115         return true;
116     }
117 
118     /**
119      * @dev Approve the passed address to spend the specified amount of tokens on behalf of msg.sender.
120      * Beware that changing an allowance with this method brings the risk that someone may use both the old
121      * and the new allowance by unfortunate transaction ordering. One possible solution to mitigate this
122      * race condition is to first reduce the spender's allowance to 0 and set the desired value afterwards:
123      * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
124      * @param spender The address which will spend the funds.
125      * @param value The amount of tokens to be spent.
126      */
127     function approve(address spender, uint256 value) public returns (bool) {
128         _allowed[msg.sender][spender] = value;
129         emit Approval(msg.sender, spender, value);
130         return true;
131     }
132 
133     /**
134      * @dev Transfer tokens from one address to another.
135      * Note that while this function emits an Approval event, this is not required as per the specification,
136      * and other compliant implementations may not emit the event.
137      * @param from address The address which you want to send tokens from
138      * @param to address The address which you want to transfer to
139      * @param value uint256 the amount of tokens to be transferred
140      */
141     function transferFrom(
142         address from,
143         address to,
144         uint256 value
145     ) public returns (bool) {
146         if (from != msg.sender && _allowed[from][msg.sender] != uint256(-1))
147             _allowed[from][msg.sender] = _allowed[from][msg.sender].sub(value);
148         _transfer(from, to, value);
149         return true;
150     }
151 
152     function _transfer(
153         address from,
154         address to,
155         uint256 value
156     ) internal {
157         require(to != address(0));
158         _balances[from] = _balances[from].sub(value);
159         _balances[to] = _balances[to].add(value);
160         emit Transfer(from, to, value);
161     }
162 }
163 
164 contract ERC20Mintable is ERC20 {
165     string public name;
166     string public symbol;
167     uint8 public decimals;
168 
169     function _mint(address to, uint256 amount) internal {
170         _balances[to] = _balances[to].add(amount);
171         _totalSupply = _totalSupply.add(amount);
172         emit Transfer(address(0), to, amount);
173     }
174 
175     function _burn(address from, uint256 amount) internal {
176         _balances[from] = _balances[from].sub(amount);
177         _totalSupply = _totalSupply.sub(amount);
178         emit Transfer(from, address(0), amount);
179     }
180 }
181 
182 contract Emoji is ERC20Mintable, Ownable {
183     using SafeMath for uint256;
184 
185     mapping(address => bool) public isMinter;
186 
187     constructor(address _presale_address) public {
188         name = "Emojis Farm";
189         symbol = "EMOJI";
190         decimals = 18;
191         _mint(_presale_address, 500 * (10 ** 18));
192     }
193 
194     function setMinter(address minter, bool flag) external onlyOwner {
195         isMinter[minter] = flag;
196     }
197 
198     function mint(address to, uint256 amount) external {
199         require(isMinter[msg.sender], "Not Minter");
200         _mint(to, amount);
201     }
202 
203     function burn(address from, uint256 amount) external {
204         if (from != msg.sender && _allowed[from][msg.sender] != uint256(-1))
205             _allowed[from][msg.sender] = _allowed[from][msg.sender].sub(amount);
206         require(_balances[from] >= amount, "insufficient-balance");
207         _burn(from, amount);
208     }
209 }