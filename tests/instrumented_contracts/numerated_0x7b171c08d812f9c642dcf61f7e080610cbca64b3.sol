1 library SafeMath {
2   function mul(uint256 a, uint256 b) internal pure returns (uint256) {
3     uint256 c = a * b;
4     assert(a == 0 || c / a == b);
5     return c;
6   }
7 
8   function div(uint256 a, uint256 b) internal pure returns (uint256) {
9     // assert(b > 0); // Solidity automatically throws when dividing by 0
10     uint256 c = a / b;
11     // assert(a == b * c + a % b); // There is no case in which this doesn't hold
12     return c;
13   }
14 
15   function sub(uint256 a, uint256 b) internal pure returns (uint256) {
16     assert(b <= a);
17     return a - b;
18   }
19 
20   function add(uint256 a, uint256 b) internal pure returns (uint256) {
21     uint256 c = a + b;
22     assert(c >= a);
23     return c;
24   }
25 }
26 
27 contract ERC20 {
28   uint256 public totalSupply;
29   function balanceOf(address who) external view returns (uint256);
30   function transfer(address to, uint256 value) external;
31   function allowance(address owner, address spender) external view returns (uint256);
32   function transferFrom(address from, address to, uint256 value) external;
33   function approve(address spender, uint256 value) external;
34   event Transfer(address indexed from, address indexed to, uint256 value);
35   event Approval(address indexed owner, address indexed spender, uint256 value);
36 }
37 
38 contract BasicToken is ERC20 {
39 
40     using SafeMath for uint256;
41 
42     mapping(address => uint256) balances;
43     mapping (address => mapping (address => uint256)) allowed;
44 
45     /**
46   * @dev transfer token for a specified address
47   * @param _to The address to transfer to.
48   * @param _value The amount to be transferred.
49   */
50     function transfer(address _to, uint256 _value) external {
51         address _from = msg.sender;
52         require (balances[_from] >= _value && balances[_to] + _value > balances[_to]);
53         balances[_from] = balances[_from].sub(_value);
54         balances[_to] = balances[_to].add(_value);
55         Transfer(_from, _to, _value);
56     }
57 
58     /**
59    * @dev Transfer tokens from one address to another
60    * @param _from address The address which you want to send tokens from
61    * @param _to address The address which you want to transfer to
62    * @param _value uint256 the amout of tokens to be transfered
63    */
64 
65     function transferFrom(address _from, address _to, uint256 _value) external {
66       if (balances[_from] >= _value && allowed[_from][msg.sender] >= _value && balances[_to] + _value > balances[_to]){
67         uint256 _allowance = allowed[_from][msg.sender];
68         allowed[_from][msg.sender] = _allowance.sub(_value);
69         balances[_to] = balances[_to].add(_value);
70         balances[_from] = balances[_from].sub(_value);
71         Transfer(_from, _to, _value);
72       }
73     }
74 
75     function balanceOf(address _owner) external view returns (uint256 balance) {
76         balance = balances[_owner];
77     }
78 
79     function approve(address _spender, uint256 _value) external {
80         // To change the approve amount you first have to reduce the addresses`
81         //  allowance to zero by calling `approve(_spender, 0)` if it is not
82         //  already 0 to mitigate the race condition described here:
83         //  https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
84         require((_value == 0) || (allowed[msg.sender][_spender] == 0));
85 
86         allowed[msg.sender][_spender] = _value;
87         Approval(msg.sender, _spender, _value);
88   }
89 
90   /**
91    * @dev Function to check the amount of tokens that an owner allowed to a spender.
92    * @param _owner address The address which owns the funds.
93    * @param _spender address The address which will spend the funds.
94    * @return A uint256 specifing the amount of tokens still avaible for the spender.
95    */
96   function allowance(address _owner, address _spender) external view returns (uint256 remaining) {
97         remaining = allowed[_owner][_spender];
98   }
99 }
100 
101 
102 contract HadeCoin is BasicToken {
103 
104     using SafeMath for uint256;
105 
106     /*
107        STORAGE
108     */
109 
110     // name of the token
111     string public name = "HADE Platform";
112 
113     // symbol of token
114     string public symbol = "HADE";
115 
116     // decimals
117     uint8 public decimals = 18;
118 
119     // total supply of Hade Coin
120     uint256 public totalSupply = 150000000 * 10**18;
121 
122     // multi sign address of founders which hold
123     address public adminMultiSig;
124 
125     /*
126        EVENTS
127     */
128 
129     event ChangeAdminWalletAddress(uint256  _blockTimeStamp, address indexed _foundersWalletAddress);
130 
131     /*
132        CONSTRUCTOR
133     */
134 
135     function HadeCoin(address _adminMultiSig) public {
136 
137         adminMultiSig = _adminMultiSig;
138         balances[adminMultiSig] = totalSupply;
139     }
140 
141     /*
142        MODIFIERS
143     */
144 
145     modifier nonZeroAddress(address _to) {
146         require(_to != 0x0);
147         _;
148     }
149 
150     modifier onlyAdmin() {
151         require(msg.sender == adminMultiSig);
152         _;
153     }
154 
155     /*
156        OWNER FUNCTIONS
157     */
158 
159     // @title mint sends new coin to the specificed recepiant
160     // @param _to is the recepiant the new coins
161     // @param _value is the number of coins to mint
162     function mint(address _to, uint256 _value) external onlyAdmin {
163 
164         require(_to != address(0));
165         require(_value > 0);
166         totalSupply += _value;
167         balances[_to] += _value;
168         Transfer(address(0), _to, _value);
169     }
170 
171     // @title burn allows the administrator to burn their own tokens
172     // @param _value is the number of tokens to burn
173     // @dev note that admin can only burn their own tokens
174     function burn(uint256 _value) external onlyAdmin {
175 
176         require(_value > 0 && balances[msg.sender] >= _value);
177         totalSupply -= _value;
178         balances[msg.sender] -= _value;
179     }
180 
181     // @title changeAdminAddress allows to update the owner wallet
182     // @param _newAddress is the address of the new admin wallet
183     // @dev only callable by current owner
184     function changeAdminAddress(address _newAddress)
185 
186     external
187     onlyAdmin
188     nonZeroAddress(_newAddress)
189     {
190         adminMultiSig = _newAddress;
191         ChangeAdminWalletAddress(now, adminMultiSig);
192     }
193 
194     // @title fallback reverts if a method call does not match
195     // @dev reverts if any money is sent
196     function() public {
197         revert();
198     }
199 }