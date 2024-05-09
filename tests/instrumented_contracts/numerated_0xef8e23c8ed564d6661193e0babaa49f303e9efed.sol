1 pragma solidity ^0.5.0;
2 
3 /**
4  * @dev Interface of the ERC20 standard as defined in the EIP. Does not include
5  * the optional functions; to access them see {ERC20Detailed}.
6  */
7 interface ERC20Interface {
8     /**
9      * @dev Returns the amount of tokens in existence.
10      */
11     function totalSupply() external view returns (uint256);
12 
13     /**
14      * @dev Returns the amount of tokens owned by `account`.
15      */
16     function balanceOf(address account) external view returns (uint256);
17 
18     /**
19      * @dev Moves `amount` tokens from the caller's account to `recipient`.
20      *
21      * Returns a boolean value indicating whether the operation succeeded.
22      *
23      * Emits a {Transfer} event.
24      */
25     function transfer(address recipient, uint256 amount) external returns (bool);
26 
27     /**
28      * @dev Returns the remaining number of tokens that `spender` will be
29      * allowed to spend on behalf of `owner` through {transferFrom}. This is
30      * zero by default.
31      *
32      * This value changes when {approve} or {transferFrom} are called.
33      */
34     function allowance(address owner, address spender) external view returns (uint256);
35 
36     /**
37      * @dev Sets `amount` as the allowance of `spender` over the caller's tokens.
38      *
39      * Returns a boolean value indicating whether the operation succeeded.
40      *
41      * IMPORTANT: Beware that changing an allowance with this method brings the risk
42      * that someone may use both the old and the new allowance by unfortunate
43      * transaction ordering. One possible solution to mitigate this race
44      * condition is to first reduce the spender's allowance to 0 and set the
45      * desired value afterwards:
46      * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
47      *
48      * Emits an {Approval} event.
49      */
50     function approve(address spender, uint256 amount) external returns (bool);
51 
52     /**
53      * @dev Moves `amount` tokens from `sender` to `recipient` using the
54      * allowance mechanism. `amount` is then deducted from the caller's
55      * allowance.
56      *
57      * Returns a boolean value indicating whether the operation succeeded.
58      *
59      * Emits a {Transfer} event.
60      */
61     function transferFrom(address sender, address recipient, uint256 amount) external returns (bool);
62 
63     /**
64      * @dev Emitted when `value` tokens are moved from one account (`from`) to
65      * another (`to`).
66      *
67      * Note that `value` may be zero.
68      */
69     event Transfer(address indexed from, address indexed to, uint256 value);
70 
71     /**
72      * @dev Emitted when the allowance of a `spender` for an `owner` is set by
73      * a call to {approve}. `value` is the new allowance.
74      */
75     event Approval(address indexed owner, address indexed spender, uint256 value);
76 }
77 
78 contract ERC20Base is ERC20Interface {
79     // Empty internal constructor, to prevent people from mistakenly deploying
80     // an instance of this contract, which should be used via inheritance.
81     // constructor () internal { }
82     // solhint-disable-previous-line no-empty-blocks
83 
84     mapping (address => uint256) public _balances;
85     mapping (address => mapping (address => uint256)) public _allowances;
86     uint256 public _totalSupply;
87 
88     function transfer(address _to, uint256 _value) public returns (bool success) {
89         //Default assumes totalSupply can't be over max (2^256 - 1).
90         //If your token leaves out totalSupply and can issue more tokens as time goes on, you need to check if it doesn't wrap.
91         //Replace the if with this one instead.
92         //if (balances[msg.sender] >= _value && balances[_to] + _value > balances[_to]) {
93         if (_balances[msg.sender] >= _value && _value > 0) {
94             _balances[msg.sender] -= _value;
95             _balances[_to] += _value;
96             emit Transfer(msg.sender, _to, _value);
97             return true;
98         } else { 
99             return false;
100         }
101     }
102 
103     function transferFrom(address _from, address _to, uint256 _value) public returns (bool success) {
104         //same as above. Replace this line with the following if you want to protect against wrapping uints.
105         //if (balances[_from] >= _value && allowed[_from][msg.sender] >= _value && balances[_to] + _value > balances[_to]) {
106         if (_balances[_from] >= _value && _allowances[_from][msg.sender] >= _value && _value > 0) {
107             _balances[_to] += _value;
108             _balances[_from] -= _value;
109             _allowances[_from][msg.sender] -= _value;
110             emit Transfer(_from, _to, _value);
111             return true;
112         } else {
113             return false;
114         }
115     }
116 
117     function balanceOf(address _owner) public view returns (uint256 balance) {
118         return _balances[_owner];
119     }
120 
121     function approve(address _spender, uint256 _value) public returns (bool success) {
122         _allowances[msg.sender][_spender] = _value;
123         emit Approval(msg.sender, _spender, _value);
124         return true;
125     }
126 
127     function allowance(address _owner, address _spender) public view returns (uint256 remaining) {
128       return _allowances[_owner][_spender];
129     }
130     
131     function totalSupply() public view returns (uint256 total) {
132         return _totalSupply;
133     }
134 }
135 
136 contract Token is ERC20Base {
137 
138     string private _name;
139     string private _symbol;
140     uint8 private _decimals;
141     
142     constructor (string memory name, string memory symbol, uint8 decimals, uint256 initialSupply) public payable {
143         _name = name;
144         _symbol = symbol;
145         _decimals = decimals;
146         _totalSupply = initialSupply;
147         _balances[msg.sender] = initialSupply;
148     }
149 
150     /**
151      * @dev Returns the name of the token.
152      */
153     function name() public view returns (string memory) {
154         return _name;
155     }
156 
157     /**
158      * @dev Returns the symbol of the token, usually a shorter version of the
159      * name.
160      */
161     function symbol() public view returns (string memory) {
162         return _symbol;
163     }
164 
165     /**
166      * @dev Returns the number of decimals used to get its user representation.
167      * For example, if `decimals` equals `2`, a balance of `505` tokens should
168      * be displayed to a user as `5,05` (`505 / 10 ** 2`).
169      *
170      * Tokens usually opt for a value of 18, imitating the relationship between
171      * Ether and Wei.
172      *
173      * NOTE: This information is only used for _display_ purposes: it in
174      * no way affects any of the arithmetic of the contract, including
175      * {IERC20-balanceOf} and {IERC20-transfer}.
176      */
177     function decimals() public view returns (uint8) {
178         return _decimals;
179     }
180 
181 }