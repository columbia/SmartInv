1 pragma solidity ^0.5.5;
2 
3 library SafeMath {
4     function mul(uint256 a, uint256 b) internal pure returns (uint256) {
5         uint256 c = a * b;
6         assert(a == 0 || c / a == b);
7         return c;
8     }
9 
10     function div(uint256 a, uint256 b) internal pure returns (uint256) {
11         // assert(b > 0); // Solidity automatically throws when dividing by 0
12         uint256 c = a / b;
13         // assert(a == b * c + a % b); // There is no case in which this doesn't hold
14         return c;
15     }
16 
17     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
18         assert(b <= a);
19         return a - b;
20     }
21 
22     function add(uint256 a, uint256 b) internal pure returns (uint256) {
23         uint256 c = a + b;
24         assert(c >= a);
25         return c;
26     }
27 }
28 
29 contract Ownable {
30     address public owner;
31 
32 
33     /**
34      * @dev The Ownable constructor sets the original `owner` of the contract to the sender
35      * account.
36      */
37     constructor() public {
38         owner = msg.sender;
39     }
40 
41 
42     /**
43      * @dev Throws if called by any account other than the owner.
44      */
45     modifier onlyOwner() {
46         require(msg.sender == owner);
47         _;
48     }
49 
50 
51     /**
52      * @dev Allows the current owner to transfer control of the contract to a newOwner.
53      * @param newOwner The address to transfer ownership to.
54      */
55     function transferOwnership(address newOwner) onlyOwner public{
56         if (newOwner != address(0)) {
57             owner = newOwner;
58         }
59     }
60 
61 }
62 
63 contract ERC20Basic {
64     uint256 public totalSupply;
65     function balanceOf(address who) public view returns (uint256);
66     function transfer(address to, uint256 value) public returns (bool);
67     event Transfer(address indexed _from, address indexed _to, uint _value);
68 }
69 
70 contract BasicToken is ERC20Basic {
71     using SafeMath for uint256;
72 
73     mapping(address => uint256) balances;
74 
75     /**
76     * @dev transfer token for a specified address
77     * @param _to The address to transfer to.
78     * @param _value The amount to be transferred.
79     */
80     function transfer(address _to, uint256 _value) public returns (bool) {
81         balances[msg.sender] = balances[msg.sender].sub(_value);
82         balances[_to] = balances[_to].add(_value);
83         emit Transfer(msg.sender, _to, _value);
84         return true;
85     }
86 
87     /**
88     * @dev Gets the balance of the specified address.
89     * @param _owner The address to query the the balance of.
90     * @return An uint256 representing the amount owned by the passed address.
91     */
92     function balanceOf(address _owner) public view returns (uint256 balance) {
93         return balances[_owner];
94     }
95 
96 }
97 
98 contract ERC20 is ERC20Basic {
99     function allowance(address owner, address spender) public view returns (uint256);
100     function transferFrom(address from, address to, uint256 value) public returns (bool);
101     function approve(address spender, uint256 value) public returns (bool);
102 
103     event Approval(address indexed _owner, address indexed _spender, uint _value);
104 }
105 
106 contract StandardToken is ERC20, BasicToken {
107 
108     mapping (address => mapping (address => uint256)) allowed;
109 
110 
111     /**
112      * @dev Transfer tokens from one address to another
113      * @param _from address The address which you want to send tokens from
114      * @param _to address The address which you want to transfer to
115      * @param _value uint256 the amout of tokens to be transfered
116      */
117     function transferFrom(address _from, address _to, uint256 _value) public returns (bool) {
118         uint256 _allowance = allowed[_from][msg.sender];
119 
120         balances[_from] = balances[_from].sub(_value);
121         balances[_to] = balances[_to].add(_value);
122         allowed[_from][msg.sender] = _allowance.sub(_value);
123         emit Transfer(_from, _to, _value);
124         return true;
125     }
126 
127     /**
128      * @dev Aprove the passed address to spend the specified amount of tokens on behalf of msg.sender.
129      * @param _spender The address which will spend the funds.
130      * @param _value The amount of tokens to be spent.
131      */
132     function approve(address _spender, uint256 _value) public returns (bool) {
133 
134         // To change the approve amount you first have to reduce the addresses`
135         //  allowance to zero by calling `approve(_spender, 0)` if it is not
136         //  already 0 to mitigate the race condition described here:
137         //  https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
138         require((_value == 0) || (allowed[msg.sender][_spender] == 0));
139 
140         allowed[msg.sender][_spender] = _value;
141         emit Approval(msg.sender, _spender, _value);
142         return true;
143     }
144 
145     /**
146      * @dev Function to check the amount of tokens that an owner allowed to a spender.
147      * @param _owner address The address which owns the funds.
148      * @param _spender address The address which will spend the funds.
149      * @return A uint256 specifing the amount of tokens still avaible for the spender.
150      */
151     function allowance(address _owner, address _spender) public view returns (uint256 remaining) {
152         return allowed[_owner][_spender];
153     }
154 
155 }
156 
157 contract FilescoinToken is StandardToken, Ownable {
158     string  public  constant name = "Filescoin";
159     string  public  constant symbol = "FILs";
160     uint    public  constant decimals = 6;
161 
162 
163     modifier validDestination( address to ) {
164         require(to != address(0x0));
165         require(to != address(this) );
166         _;
167     }
168 
169     constructor() public {
170         totalSupply = 40000000 * (10 ** decimals);
171         address to = msg.sender;
172         balances[to] = totalSupply;
173         emit Transfer(address(0x0), to, totalSupply);
174         transferOwnership(msg.sender); // admin could drain tokens that were sent here by mistake
175     }
176 
177     function transfer(address _to, uint _value)
178     validDestination(_to)
179     public returns (bool) {
180         return super.transfer(_to, _value);
181     }
182 
183     function transferFrom(address _from, address _to, uint _value)
184     validDestination(_to)
185     public returns (bool) {
186         return super.transferFrom(_from, _to, _value);
187     }
188 
189     function emergencyERC20Drain( ERC20 token, uint amount ) onlyOwner public {
190         token.transfer( owner, amount );
191     }
192 }