1 pragma solidity >=0.5.0 <0.7.0;
2 
3 // Ownable contract from open zepplin
4 
5 contract Ownable {
6     
7     address private _owner;
8 
9     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
10 
11     /**
12      * @dev Initializes the contract setting the deployer as the initial owner.
13      */
14     constructor () public {
15         _owner = msg.sender;
16         emit OwnershipTransferred(address(0), _owner);
17     }
18 
19     /**
20      * @dev Returns the address of the current owner.
21      */
22     function owner() public view returns (address) {
23         return _owner;
24     }
25 
26     /**
27      * @dev Throws if called by any account other than the owner.
28      */
29     modifier onlyOwner() {
30         require(isOwner(), "Ownable: caller is not the owner");
31         _;
32     }
33 
34     /**
35      * @dev Returns true if the caller is the current owner.
36      */
37     function isOwner() public view returns (bool) {
38         return msg.sender == _owner;
39     }
40 
41     /**
42      * @dev Leaves the contract without owner. It will not be possible to call
43      * `onlyOwner` functions anymore. Can only be called by the current owner.
44      *
45      * > Note: Renouncing ownership will leave the contract without an owner,
46      * thereby removing any functionality that is only available to the owner.
47      */
48 
49 
50     /**
51      * @dev Transfers ownership of the contract to a new account (`newOwner`).
52      * Can only be called by the current owner.
53      */
54     function transferOwnership(address _newOwner) public onlyOwner {
55         _transferOwnership(_newOwner);
56     }
57 
58     /**
59      * @dev Transfers ownership of the contract to a new account (`newOwner`).
60      */
61     function _transferOwnership(address _newOwner) internal {
62         require(_newOwner != address(0), "Ownable: new owner is the zero address");
63         emit OwnershipTransferred(_owner, _newOwner);
64         _owner = _newOwner;
65     }
66 }
67 
68 
69 // safemath library for addition and subtraction
70 
71 library SafeMath {
72     function safeAdd(uint a, uint b) internal pure returns (uint c) {
73         c = a + b;
74         require(c >= a);
75     }
76     function safeSub(uint a, uint b) internal pure returns (uint c) {
77         require(b <= a);
78         c = a - b;
79     }
80     function safeMul(uint a, uint b) internal pure returns (uint c) {
81         c = a * b;
82         require(a == 0 || c / a == b);
83     }
84     function safeDiv(uint a, uint b) internal pure returns (uint c) {
85         require(b > 0);
86         c = a / b;
87     }
88 }
89 
90 
91 // erc20 interface
92 
93 interface ERC20{
94     
95     function totalSupply() external view returns (uint256);
96     function balanceOf(address _tokenOwner) external view returns (uint256);
97     function allowance(address _tokenOwner, address _spender) external view returns (uint256);
98     function transfer(address _to, uint256 _tokens) external returns (bool);
99     function approve(address _spender, uint256 _tokens)  external returns (bool);
100     function transferFrom(address _from, address _to, uint256 _tokens) external returns (bool);
101     
102     event Approval(address indexed tokenOwner, address indexed spender, uint tokens);
103     event Transfer(address indexed from, address indexed to, uint tokens);
104     
105 }
106 
107 
108 // contract
109 
110 contract EU21_SupporterToken is Ownable, ERC20{
111     
112     using SafeMath for uint256;
113 
114     string _name;
115     string  _symbol;
116     uint256 _totalSupply;
117     uint256 _decimal;
118     
119     mapping(address => uint256) _balances;
120     mapping(address => mapping (address => uint256)) _allowances;
121     
122     event Approval(address indexed tokenOwner, address indexed spender, uint tokens);
123     event Transfer(address indexed from, address indexed to, uint tokens);
124     
125     constructor() public {
126         _name = "EURO 2021";
127         _symbol = "EU21";
128         _decimal = 18;
129         _totalSupply = 165000 * 10 ** _decimal;
130         _balances[msg.sender] = _totalSupply;
131     }
132     
133     
134     function name() public view returns (string memory) {
135         return _name;
136     }
137     
138     function symbol() public view returns (string memory) {
139         return _symbol;
140     }
141     
142     function decimals() public view returns (uint256) {
143         return _decimal;
144     }
145     
146     function totalSupply() external view  override returns (uint256) {
147         return _totalSupply;
148     }
149     
150     function balanceOf(address _tokenOwner) external view override returns (uint256) {
151         return _balances[_tokenOwner];
152     }
153     
154     function transfer(address _to, uint256 _tokens) external override returns (bool) {
155         _transfer(msg.sender, _to, _tokens);
156         return true;
157     }
158     
159     function _transfer(address _sender, address _recipient, uint256 _amount) internal {
160         require(_sender != address(0), "ERC20: transfer from the zero address");
161         require(_recipient != address(0), "ERC20: transfer to the zero address");
162 
163         _balances[_sender] = _balances[_sender].safeSub(_amount);
164         _balances[_recipient] = _balances[_recipient].safeAdd(_amount);
165         emit Transfer(_sender, _recipient, _amount);
166     }
167     
168     function allowance(address _tokenOwner, address _spender) external view override returns (uint256) {
169         return _allowances[_tokenOwner][_spender];
170     }
171     
172     function approve(address _spender, uint256 _tokens) external override returns (bool) {
173         _approve(msg.sender, _spender, _tokens);
174         return true;
175     }
176     
177     function _approve(address _owner, address _spender, uint256 _value) internal {
178         require(_owner != address(0), "ERC20: approve from the zero address");
179         require(_spender != address(0), "ERC20: approve to the zero address");
180 
181         _allowances[_owner][_spender] = _value;
182         emit Approval(_owner, _spender, _value);
183     }
184     
185     
186     function transferFrom(address _from, address _to, uint256 _tokens) external override returns (bool) {
187         _transfer(_from, _to, _tokens);
188         _approve(_from, msg.sender, _allowances[_from][msg.sender].safeSub(_tokens));
189         return true;
190     }
191     // don't accept eth
192     receive () external payable {
193         revert();
194     }
195 
196 }