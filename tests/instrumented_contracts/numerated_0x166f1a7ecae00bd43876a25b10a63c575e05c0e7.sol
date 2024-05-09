1 pragma solidity 0.4.24;
2 
3 
4 /**
5  * @title Ownable
6  * @dev The Ownable contract has an owner address, and provides basic authorization control
7  * functions, this simplifies the implementation of user permissions.
8  */
9 contract Ownable {
10     address public owner;
11 
12 
13     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
14 
15 
16   /**
17    * @dev The Ownable constructor sets the original `owner` of the contract to the sender
18    * account.
19    */
20     constructor() public{
21         owner = msg.sender;
22     }
23 
24 
25   /**
26    * @dev Throws if called by any account other than the owner.
27    */
28     modifier onlyOwner() {
29         require(msg.sender == owner);
30         _;
31     }
32 
33 
34   /**
35    * @dev Allows the current owner to transfer control of the contract to a newOwner.
36    * @param newOwner The address to transfer ownership to.
37    */
38     function transferOwnership(address newOwner) onlyOwner public {
39         require(newOwner != address(0));
40         emit OwnershipTransferred(owner, newOwner);
41         owner = newOwner;
42     }
43 
44 }
45 
46 
47 /**
48  * @title ERC20
49  * @dev ERC20 interface
50  */
51 contract ERC20 {            
52     function balanceOf(address who) public view returns (uint256);
53     function transfer(address to, uint256 value) public returns (bool);
54     function allowance(address owner, address spender) public view returns (uint256);
55     function transferFrom(address from, address to, uint256 value) public returns (bool);
56     function approve(address spender, uint256 value) public returns (bool);
57     function mint(uint256 value) public returns (bool);
58     function burn(uint256 value) public returns (bool);
59     event Transfer(address indexed from, address indexed to, uint256 value);
60     event Approval(address indexed owner, address indexed spender, uint256 value);
61 }
62 
63 
64 
65 
66 
67 /**
68  * @title SafeMath
69  * @dev Math operations with safety checks that throw on error
70  */
71 library SafeMath {
72     function mul(uint256 a, uint256 b) internal pure returns (uint256) {
73         uint256 c = a * b;
74         require(a == 0 || c / a == b);
75         return c;
76     }
77 
78     function div(uint256 a, uint256 b) internal pure returns (uint256) {
79         // assert(b > 0); // Solidity automatically throws when dividing by 0
80         uint256 c = a / b;
81         // assert(a == b * c + a % b); // There is no case in which this doesn't hold
82         return c;
83     }
84 
85     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
86         require(b <= a);
87         return a - b;
88     }
89 
90     function add(uint256 a, uint256 b) internal pure returns (uint256) {
91         uint256 c = a + b;
92         require(c >= a);
93         return c;
94     }
95 }
96 
97 /**
98  * Vera Exchange Token
99  */
100 
101 
102 contract Vera is ERC20, Ownable {
103 
104     using SafeMath for uint256;
105 
106     uint256  public  totalSupply = 250000000 * 1 ether;
107 
108     mapping  (address => uint256)             public          _balances;
109     mapping  (address => mapping (address => uint256)) public  _approvals;
110 
111 
112     string   public  name = "Vera";
113     string   public  symbol = "Vera";
114     uint256  public  decimals = 18;
115 
116     event Mint(uint256 wad);
117     event Burn(uint256 wad);
118     event Transfer(address indexed from, address indexed to, uint256 value);
119     event Approval(address indexed owner, address indexed spender, uint256 value);
120     
121 
122     constructor () public{
123         _balances[msg.sender] = totalSupply;
124     }
125 
126     function totalSupply() public view returns (uint256) {
127         return totalSupply;
128     }
129     function balanceOf(address src) public view returns (uint256) {
130         return _balances[src];
131     }
132     function allowance(address src, address guy) public view returns (uint256) {
133         return _approvals[src][guy];
134     }
135     
136     function transfer(address dst, uint256 wad) public returns (bool) {
137         require(dst != address(0));
138         require(wad > 0 && _balances[msg.sender] >= wad);
139         _balances[msg.sender] = _balances[msg.sender].sub(wad);
140         _balances[dst] = _balances[dst].add(wad);
141         emit Transfer(msg.sender, dst, wad);
142         return true;
143     }
144     
145     function transferFrom(address src, address dst, uint256 wad) public returns (bool) {
146         require(src != address(0));
147         require(dst != address(0));
148         require(wad > 0 && _balances[src] >= wad && _approvals[src][msg.sender] >= wad);
149         _approvals[src][msg.sender] = _approvals[src][msg.sender].sub(wad);
150         _balances[src] = _balances[src].sub(wad);
151         _balances[dst] = _balances[dst].add(wad);
152         emit Transfer(src, dst, wad);
153         return true;
154     }
155     
156     function approve(address guy, uint256 wad) public returns (bool) {
157         require(guy != address(0));
158         require(wad > 0 && wad <= _balances[msg.sender]);
159         _approvals[msg.sender][guy] = wad;
160         emit Approval(msg.sender, guy, wad);
161         return true;
162     }
163 
164     function mint(uint256 wad) public onlyOwner returns (bool) {
165         require(wad > 0);
166         _balances[msg.sender] = _balances[msg.sender].add(wad);
167         totalSupply = totalSupply.add(wad);
168         emit Mint(wad);
169         return true;
170     }
171 
172     function burn(uint256 wad) public onlyOwner returns (bool)  {
173         require(wad > 0 && wad <= _balances[msg.sender]);
174         _balances[msg.sender] = _balances[msg.sender].sub(wad);
175         totalSupply = totalSupply.sub(wad);
176         emit Burn(wad);
177         return true;
178     }
179 }