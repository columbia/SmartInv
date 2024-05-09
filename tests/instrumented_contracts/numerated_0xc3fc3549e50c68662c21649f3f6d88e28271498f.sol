1 pragma solidity 0.5.7;
2 
3 /**
4  * @title SafeMath 
5  * @dev Unsigned math operations with safety checks that revert on error.
6  */
7 library SafeMath {
8     /**
9      * @dev Multiplies two unsigned integers, reverts on overflow.
10      */
11     function mul(uint256 a, uint256 b) internal pure returns (uint256) {
12         // Gas optimization: this is cheaper than requiring 'a' not being zero, but the
13         // benefit is lost if 'b' is also tested.
14         // See: https://github.com/OpenZeppelin/openzeppelin-solidity/pull/522
15         if (a == 0) {
16             return 0;
17         }
18 
19         uint256 c = a * b;
20         require(c / a == b);
21 
22         return c;
23     }
24 
25     /**
26      * @dev Integer division of two unsigned integers truncating the quotient, reverts on division by zero.
27      */
28     function div(uint256 a, uint256 b) internal pure returns (uint256) {
29         // Solidity only automatically asserts when dividing by 0
30         require(b > 0);
31         uint256 c = a / b;
32         // assert(a == b * c + a % b); // There is no case in which this doesn't hold
33 
34         return c;
35     }
36 
37     /**
38      * @dev Subtracts two unsigned integers, reverts on underflow (i.e. if subtrahend is greater than minuend).
39      */
40     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
41         require(b <= a);
42         uint256 c = a - b;
43 
44         return c;
45     }
46 
47     /**
48      * @dev Adds two unsigned integers, reverts on overflow.
49      */
50     function add(uint256 a, uint256 b) internal pure returns (uint256) {
51         uint256 c = a + b;
52         require(c >= a);
53 
54         return c;
55     }
56 }
57 /**
58  * @title GOMC Standard ERC20 token
59  * @dev Implementation of the basic standard token.
60  * https://eips.ethereum.org/EIPS/eip-20
61  */
62 contract GOMC {
63     using SafeMath for uint256;
64     
65     string public constant name = "GGOOUMCHAIN Token";
66     string public constant symbol = "GOMC";
67     uint8 public constant decimals = 18;
68 
69     uint256 private constant INITIAL_SUPPLY = 1e9;
70     uint256 public constant totalSupply = INITIAL_SUPPLY * 10 ** uint256(decimals);
71 
72     address public constant wallet = 0x873feD29d4cFcCB1E4919e98DEA88b2725B15C33;
73 
74     mapping(address => uint256) internal balances;
75     mapping (address => mapping (address => uint256)) internal allowed;
76 
77     event Transfer(address indexed from, address indexed to, uint256 value);
78     event Approval(address indexed owner, address indexed spender, uint256 value);
79 
80 
81     /**
82      * @dev Constructor.
83      */
84     constructor() public {
85         balances[wallet] = totalSupply;
86         emit Transfer(address(0), wallet, totalSupply);
87     }
88 
89     /**
90      * @dev Gets the balance of the specified address.
91      * @param _owner The address to query the the balance of.
92      * @return An uint256 representing the amount owned by the passed address.
93      */
94     function balanceOf(address _owner) public view returns (uint256) {
95         return balances[_owner];
96     }
97 
98     /**
99      * @dev Function to check the amount of tokens that an owner allowed to a spender.
100      * @param _owner address The address which owns the funds.
101      * @param _spender address The address which will spend the funds.
102      * @return A uint256 specifying the amount of tokens still available for the spender.
103      */
104     function allowance(address _owner, address _spender) public view returns (uint256) {
105         return allowed[_owner][_spender];
106     }
107 
108     /**
109      * @dev Transfer token for a specified address
110      * @param _to The address to transfer to.
111      * @param _value The amount to be transferred.
112      */
113     function transfer(address _to, uint256 _value) public returns (bool) {
114         require(_to != address(0));
115         require(_value <= balances[msg.sender]);
116 
117         balances[msg.sender] = balances[msg.sender].sub(_value);
118         balances[_to] = balances[_to].add(_value);
119         emit Transfer(msg.sender, _to, _value);
120         return true;
121     }
122 
123     /**
124      * @dev Approve the passed address to spend the specified amount of tokens on behalf of msg.sender.
125      * Beware that changing an allowance with this method brings the risk that someone may use both the old
126      * and the new allowance by unfortunate transaction ordering. One possible solution to mitigate this
127      * race condition is to first reduce the spender's allowance to 0 and set the desired value afterwards:
128      * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
129      * @param _spender The address which will spend the funds.
130      * @param _value The amount of tokens to be spent.
131      */
132     function approve(address _spender, uint256 _value) public returns (bool) {
133         require(_spender != address(0));
134         allowed[msg.sender][_spender] = _value;
135         emit Approval(msg.sender, _spender, _value);
136         return true;
137     }
138 
139     /**
140      * @dev Transfer tokens from one address to another
141      * @param _from address The address which you want to send tokens from
142      * @param _to address The address which you want to transfer to
143      * @param _value uint256 the amount of tokens to be transferred
144      */
145     function transferFrom(address _from, address _to, uint256 _value) public returns (bool) {
146         require(_to != address(0));
147         require(_value <= balances[_from]);
148         require(_value <= allowed[_from][msg.sender]);
149 
150         balances[_from] = balances[_from].sub(_value);
151         balances[_to] = balances[_to].add(_value);
152         allowed[_from][msg.sender] = allowed[_from][msg.sender].sub(_value);
153         emit Transfer(_from, _to, _value);
154         return true;
155     }
156 
157     /**
158      * @dev Increase the amount of tokens that an owner allowed to a spender.
159      * approve should be called when allowed[_spender] == 0. To increment
160      * allowed value is better to use this function to avoid 2 calls (and wait until
161      * the first transaction is mined)
162      * From MonolithDAO Token.sol
163      * Emits an Approval event.
164      * @param _spender The address which will spend the funds.
165      * @param _addedValue The amount of tokens to increase the allowance by.
166      */
167     function increaseAllowance(address _spender, uint256 _addedValue) public returns (bool) {
168     	require(_spender != address(0));
169         allowed[msg.sender][_spender] = allowed[msg.sender][_spender].add(_addedValue);
170         emit Approval(msg.sender, _spender, allowed[msg.sender][_spender]);
171         return true;
172     }
173 
174     /**
175      * @dev Decrease the amount of tokens that an owner allowed to a spender.
176      * approve should be called when allowed[_spender] == 0. To decrement
177      * allowed value is better to use this function to avoid 2 calls (and wait until
178      * the first transaction is mined)
179      * From MonolithDAO Token.sol
180      * Emits an Approval event.
181      * @param _spender The address which will spend the funds.
182      * @param _subtractedValue The amount of tokens to decrease the allowance by.
183      */
184     function decreaseAllowance(address _spender, uint256 _subtractedValue) public returns (bool) {
185     	require(_spender != address(0));
186         allowed[msg.sender][_spender] = allowed[msg.sender][_spender].sub(_subtractedValue);
187         emit Approval(msg.sender, _spender, allowed[msg.sender][_spender]);
188         return true;
189     }
190 }