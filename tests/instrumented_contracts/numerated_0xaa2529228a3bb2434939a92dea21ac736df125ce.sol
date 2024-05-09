1 pragma solidity ^ 0.5 .7;
2 // ----------------------------------------------------------------------------
3 // Safe maths
4 // ----------------------------------------------------------------------------
5 library SafeMath {
6     /**
7      * @dev Multiplies two numbers, throws on overflow.
8      */
9     function mul(uint256 a, uint256 b) internal pure returns(uint256) {
10         if (a == 0) {
11             return 0;
12         }
13         uint256 c = a * b;
14         require(c / a == b);
15         return c;
16     }
17     /**
18      * @dev Integer division of two numbers, truncating the quotient.
19      */
20     function div(uint256 a, uint256 b) internal pure returns(uint256) {
21         // require(b > 0); // Solidity automatically throws when dividing by 0
22         uint256 c = a / b;
23         // require(a == b * c + a % b); // There is no case in which this doesn't hold
24         return c;
25     }
26     /**
27      * @dev Subtracts two numbers, throws on overflow (i.e. if subtrahend is greater than minuend).
28      */
29     function sub(uint256 a, uint256 b) internal pure returns(uint256) {
30         require(b <= a);
31         return a - b;
32     }
33     /**
34      * @dev Adds two numbers, throws on overflow.
35      */
36     function add(uint256 a, uint256 b) internal pure returns(uint256) {
37         uint256 c = a + b;
38         require(c >= a);
39         return c;
40     }
41 }
42 /**
43  * @title ERC20Basic
44  * @dev Simpler version of ERC20 interface
45  * @dev see https://github.com/ethereum/EIPs/issues/179
46  */
47 contract ERC20Basic {
48     function totalSupply() external view returns(uint256);
49 
50     function balanceOf(address who) external view returns(uint256);
51 
52     function transfer(address to, uint256 value) external returns(bool);
53     event Transfer(address indexed from, address indexed to, uint256 value);
54 }
55 /**
56  * @title ERC20 interface
57  * @dev see https://github.com/ethereum/EIPs/issues/20
58  */
59 contract ERC20 is ERC20Basic {
60     uint256 public totalSupply;
61 
62     function allowance(address holder, address spender) external view returns(uint256);
63 
64     function transferFrom(address from, address to, uint256 value) external returns(bool);
65 
66     function approve(address spender, uint256 value) external returns(bool);
67   
68     event Approval(address indexed holder, address indexed spender, uint256 value);
69 }
70 contract Ownable {
71     address public owner;
72   
73     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
74     /**
75      * @dev The Ownable constructor sets the original `owner` of the contract to the sender
76      * account.
77      */
78     constructor() public {
79         owner = msg.sender;
80     }
81     /**
82      * @dev Throws if called by any account other than the owner.
83      */
84     modifier onlyOwner() {
85         require(msg.sender == owner);
86         _;
87     }
88     /**
89      * @dev Allows the current owner to transfer control of the contract to a newOwner.
90      * @param newOwner The address to transfer ownership to.
91      */
92     function transferOwnership(address newOwner) public onlyOwner {
93         require(newOwner != address(0));
94         emit OwnershipTransferred(owner, newOwner);
95         owner = newOwner;
96     }
97 }
98 contract WCCToken is ERC20, Ownable {
99     using SafeMath for uint256;
100     string public constant name = "World currency conference coin";
101     string public constant symbol = "WCC";
102     uint8 public constant decimals = 18;
103     mapping(address => uint256) balances;
104     mapping(address => mapping(address => uint256)) allowed;
105   
106     // ------------------------------------------------------------------------
107     // Constructor
108     // ------------------------------------------------------------------------
109     constructor() public {
110         totalSupply = 900000000000 * (uint256(10) ** decimals);
111         balances[msg.sender] = totalSupply;
112         emit Transfer(address(0x0), msg.sender, balances[msg.sender]);
113     }
114     /**
115      * @dev Transfer the balance from token owner's account  to account
116      * @param _to The address to transfer to.
117      * @param _value The amount to be transferred.
118      */
119     function transfer(address _to, uint256 _value) external returns(bool) {
120         require(_to != address(0));
121         require(_to != address(this));
122         // SafeMath.sub will revert if there is not enough balance.
123         balances[msg.sender] = balances[msg.sender].sub(_value);
124         balances[_to] = balances[_to].add(_value);
125         emit Transfer(msg.sender, _to, _value);
126         return true;
127     }
128     /**
129      * @dev Gets the balance of the specified address.
130      * @param _holder The address to query the the balance of.
131      * @return An uint256 representing the payable amount owned by the passed address.
132      */
133     function balanceOf(address _holder) external view returns(uint256) {
134         return balances[_holder];
135     }
136     /**
137      * @dev Transfer tokens from one address to another
138      * @param _from address The address which you want to send tokens from
139      * @param _to address The address which you want to transfer to
140      * @param _value uint256 the amount of tokens to be transferred
141      */
142     function transferFrom(address _from, address _to, uint256 _value) external returns(bool) {
143         require(_to != address(0));
144         require(_to != address(this));
145         balances[_from] = balances[_from].sub(_value);
146         balances[_to] = balances[_to].add(_value);
147         allowed[_from][msg.sender] = allowed[_from][msg.sender].sub(_value);
148         emit Transfer(_from, _to, _value);
149         return true;
150     }
151     /**
152      * @dev Aprove the passed address to spend the specified amount of tokens on behalf of msg.sender.
153 	 
154      *
155      * Beware that changing an allowance with this method brings the risk that someone may use both the old
156      * and the new allowance by unfortunate transaction ordering. One possible solution to mitigate this
157      * race condition is to first reduce the spender's allowance to 0 and set the desired value afterwards:
158      * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
159      * @param _spender The address which will spend the funds.
160      * @param _value The amount of tokens to be spent.
161      */
162     function approve(address _spender, uint256 _value) external returns(bool) {
163         allowed[msg.sender][_spender] = _value;
164         emit Approval(msg.sender, _spender, _value);
165         return true;
166     }
167     /**
168      * @dev Function to check the amount of tokens that an owner allowed to a spender.
169      * @param _holder address The address which owns the funds.
170      * @param _spender address The address which will spend the funds.
171      * @return A uint256 specifying the amount of tokens still available for the spender.
172      */
173     function allowance(address _holder, address _spender) external view returns(uint256) {
174         return allowed[_holder][_spender];
175     }
176 }