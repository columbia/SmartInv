1 pragma solidity 0.4.20;
2 /**
3 * @notice TOKEN CONTRACT
4 * @dev ERC-20 Token Standar Compliant
5 * @author Fares A. Akel C. f.antonio.akel@gmail.com
6 */
7 
8 /**
9  * @title SafeMath by OpenZeppelin
10  * @dev Math operations with safety checks that throw on error
11  */
12 library SafeMath {
13 
14     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
15         assert(b <= a);
16         return a - b;
17     }
18 
19     function add(uint256 a, uint256 b) internal pure returns (uint256) {
20         uint256 c = a + b;
21         assert(c >= a);
22         return c;
23     }
24 
25 }
26 
27 contract admined { //This token contract is administered
28     address public admin; //Admin address is public
29 
30     function admined() internal {
31         admin = msg.sender; //Set initial admin to contract creator
32         Admined(admin);
33     }
34 
35     modifier onlyAdmin() { //A modifier to define admin-only functions
36         require(msg.sender == admin);
37         _;
38     }
39 
40     function transferAdminship(address _newAdmin) onlyAdmin public { //Admin can be transfered
41         admin = _newAdmin;
42         TransferAdminship(admin);
43     }
44 
45     //All admin actions have a log for public review
46     event TransferAdminship(address newAdminister);
47     event Admined(address administer);
48 
49 }
50 
51 /**
52  * @title ERC20TokenInterface
53  * @dev Token contract interface for external use
54  */
55 contract ERC20TokenInterface {
56 
57     function balanceOf(address _owner) public constant returns (uint256 balance);
58     function transfer(address _to, uint256 _value) public returns (bool success);
59     function transferFrom(address _from, address _to, uint256 _value) public returns (bool success);
60     function approve(address _spender, uint256 _value) public returns (bool success);
61     function allowance(address _owner, address _spender) public constant returns (uint256 remaining);
62 
63     }
64 
65 
66 /**
67 * @title ERC20Token
68 * @notice Token definition contract
69 */
70 contract ERC20Token is admined,ERC20TokenInterface { //Standar definition of an ERC20Token
71     using SafeMath for uint256; //SafeMath is used for uint256 operations
72     mapping (address => uint256) balances; //A mapping of all balances per address
73     mapping (address => mapping (address => uint256)) allowed; //A mapping of all allowances
74     uint256 public totalSupply;
75     
76     /**
77     * @notice Get the balance of an _owner address.
78     * @param _owner The address to be query.
79     */
80     function balanceOf(address _owner) public constant returns (uint256 bal) {
81       return balances[_owner];
82     }
83 
84     /**
85     * @notice transfer _value tokens to address _to
86     * @param _to The address to transfer to.
87     * @param _value The amount to be transferred.
88     * @return success with boolean value true if done
89     */
90     function transfer(address _to, uint256 _value) public returns (bool success) {
91         require(_to != address(0)); //If you dont want that people destroy token
92         require(balances[msg.sender] >= _value);
93         balances[msg.sender] = balances[msg.sender].sub(_value);
94         balances[_to] = balances[_to].add(_value);
95         Transfer(msg.sender, _to, _value);
96         return true;
97     }
98 
99     /**
100     * @notice Transfer _value tokens from address _from to address _to using allowance msg.sender allowance on _from
101     * @param _from The address where tokens comes.
102     * @param _to The address to transfer to.
103     * @param _value The amount to be transferred.
104     * @return success with boolean value true if done
105     */
106     function transferFrom(address _from, address _to, uint256 _value) public returns (bool success) {
107         require(_to != address(0)); //If you dont want that people destroy token
108         require(balances[_from] >= _value && allowed[_from][msg.sender] >= _value);
109         balances[_to] = balances[_to].add(_value);
110         balances[_from] = balances[_from].sub(_value);
111         allowed[_from][msg.sender] = allowed[_from][msg.sender].sub(_value);
112         Transfer(_from, _to, _value);
113         return true;
114     }
115 
116     /**
117     * @notice Assign allowance _value to _spender address to use the msg.sender balance
118     * @param _spender The address to be allowed to spend.
119     * @param _value The amount to be allowed.
120     * @return success with boolean value true
121     */
122     function approve(address _spender, uint256 _value) public returns (bool success) {
123       allowed[msg.sender][_spender] = _value;
124         Approval(msg.sender, _spender, _value);
125         return true;
126     }
127 
128     /**
129     * @notice Get the allowance of an specified address to use another address balance.
130     * @param _owner The address of the owner of the tokens.
131     * @param _spender The address of the allowed spender.
132     * @return remaining with the allowance value
133     */
134     function allowance(address _owner, address _spender) public constant returns (uint256 remaining) {
135     return allowed[_owner][_spender];
136     }
137 
138     /**
139     * This is an especial Admin-only function to make massive tokens assignments
140     */
141 
142     function batch(address[] data,uint256[] amount) onlyAdmin public { //It takes an array of addresses and an amount
143         
144         require(data.length == amount.length);
145         uint256 length = data.length;
146         address target;
147         uint256 value;
148 
149         for (uint i=0; i<length; i++) { //It moves over the array
150             target = data[i]; //Take an address
151             value = amount[i]; //Amount
152             transfer(target,value);
153         }
154     }
155 
156     /**
157     * @dev Log Events
158     */
159     event Transfer(address indexed _from, address indexed _to, uint256 _value);
160     event Approval(address indexed _owner, address indexed _spender, uint256 _value);
161 
162 }
163 
164 /**
165 * @title Asset
166 * @notice Token creation.
167 * @dev ERC20 Token
168 */
169 contract Asset is ERC20Token {
170     string public name = 'CT Global';
171     uint8 public decimals = 18;
172     string public symbol = 'CTG';
173     string public version = '1';
174     
175     /**
176     * @notice token contructor.
177     */
178     function Asset() public {
179 
180         address writer = 0xFAB6368b0F7be60c573a6562d82469B5ED9e7eE6;
181         totalSupply = 1000000 * (10 ** uint256(decimals)); //1Million Tokens initial supply;
182         
183         balances[msg.sender] = 999000 * (10 ** uint256(decimals)); //99% to creator
184         balances[writer] = 1000 * (10 ** uint256(decimals)); //0.1% to writer
185         
186         Transfer(0, this, totalSupply);
187         Transfer(this, msg.sender, balances[msg.sender]); 
188         Transfer(this, writer, balances[writer]);       
189     }
190     
191     /**
192     * @notice this contract will revert on direct non-function calls
193     * @dev Function to handle callback calls
194     */
195     function() public {
196         revert();
197     }
198 
199 }