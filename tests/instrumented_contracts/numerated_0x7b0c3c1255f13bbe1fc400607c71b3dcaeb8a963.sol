1 pragma solidity ^0.5.0;
2 
3 /**
4  * @title SafeMath
5  * @dev Math operations with safety checks 
6  * @dev based on the open-zeppelin template 
7  */
8 library SafeMath {
9 
10     /**
11     * @dev Subtracts two numbers, reverts on overflow.
12     */
13     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
14         require(b <= a);
15         uint256 c = a - b;
16 
17         return c;
18     }
19 
20     /**
21     * @dev Adds two numbers, reverts on overflow.
22     */
23     function add(uint256 a, uint256 b) internal pure returns (uint256) {
24         uint256 c = a + b;
25         require(c >= a);
26 
27         return c;
28     }
29 }
30 
31 /**
32  * @title VTCoin - Standard ERC20 token
33  * @dev based on the open-zeppelin template 
34  */
35 contract VTCoin {
36     
37     using SafeMath for uint256;
38 
39     mapping (address => uint256) private _balances;
40     mapping (address => mapping (address => uint256)) private _allowed;
41 
42     uint256 private _totalSupply;
43     string private _name;
44     string private _symbol;
45     uint8 private _decimals;
46 
47     /**
48     * @dev Constructs the token.
49     * @param value The initial number of tokens to mint.
50     */
51     constructor (uint256 value) public {
52 	
53         _name = "ValueTank Coin";
54         _symbol = "VTC";
55         _decimals = 2;
56         
57         _balances[msg.sender] = value;
58         _totalSupply = value;
59         emit Transfer(address(0), msg.sender, value);
60 
61     }
62     
63     event Transfer(address indexed from, address indexed to, uint256 value);
64     event Approval(address indexed owner, address indexed spender, uint256 value);
65 
66     /**
67      * @return the name of the token.
68      */
69     function name() public view returns (string memory) {
70         return _name;
71     }
72 
73     /**
74      * @return the symbol of the token.
75      */
76     function symbol() public view returns (string memory) {
77         return _symbol;
78     }
79 
80     /**
81      * @return the number of decimals of the token.
82      */
83     function decimals() public view returns (uint8) {
84         return _decimals;
85     }
86 
87     /**
88     * @dev total number of tokens in existence
89     */
90     function totalSupply() public view returns (uint256) {
91         return _totalSupply;
92     }
93 
94     /**
95     * @dev Gets the balance of the specified address.
96     * @param owner The address to query the balance of.
97     * @return An uint256 representing the amount owned by the passed address.
98     */
99     function balanceOf(address owner) public view returns (uint256) {
100         return _balances[owner];
101     }
102 
103     /**
104      * @dev Function to check the amount of tokens that an owner allowed to a spender.
105      * @param owner address The address which owns the funds.
106      * @param spender address The address which will spend the funds.
107      * @return A uint256 specifying the amount of tokens still available for the spender.
108      */
109     function allowance(address owner, address spender) public view returns (uint256) {
110         return _allowed[owner][spender];
111     }
112 
113     /**
114     * @dev Transfer token for a specified address
115     * @param to The address to transfer to.
116     * @param value The amount to be transferred.
117     */
118     function transfer(address to, uint256 value) public returns (bool) {
119         _transfer(msg.sender, to, value);
120         return true;
121     }
122 
123     /**
124      * @dev Approve the passed address to spend the specified amount of tokens on behalf of msg.sender.
125      * @param spender The address which will spend the funds.
126      * @param value The amount of tokens to be spent.
127      */
128     function approve(address spender, uint256 value) public returns (bool) {
129         require(spender != address(0));
130 
131         _allowed[msg.sender][spender] = value;
132         emit Approval(msg.sender, spender, value);
133         return true;
134     }
135 
136     /**
137      * @dev Transfer tokens from one address to another
138      * @param from address The address which you want to send tokens from
139      * @param to address The address which you want to transfer to
140      * @param value uint256 the amount of tokens to be transferred
141      */
142     function transferFrom(address from, address to, uint256 value) public returns (bool) {
143         _allowed[from][msg.sender] = _allowed[from][msg.sender].sub(value);
144         _transfer(from, to, value);
145         return true;
146     }
147 
148     /**
149     * @dev Transfer token for a specified addresses
150     * @param from The address to transfer from.
151     * @param to The address to transfer to.
152     * @param value The amount to be transferred.
153     */
154     function _transfer(address from, address to, uint256 value) internal {
155         require(to != address(0));
156 
157         _balances[from] = _balances[from].sub(value);
158         _balances[to] = _balances[to].add(value);
159         emit Transfer(from, to, value);
160     }
161 }