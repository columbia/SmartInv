1 pragma solidity ^0.5.4;
2 
3 /**
4  * @title SafeMath
5  * @dev Unsigned math operations with safety checks that revert on error
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
38      * @dev Subtracts two unsigned integers, reverts on overflow (i.e. if subtrahend is greater than minuend).
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
57 
58 contract StandardToken {
59     using SafeMath for uint256;
60 
61     mapping(address => uint256) internal balances;
62 
63     mapping(address => mapping(address => uint256)) internal allowed;
64 
65     uint256 public totalSupply;
66 
67     event Transfer(address indexed from, address indexed to, uint256 value);
68 
69     event Approval(address indexed owner, address indexed spender, uint256 vaule);
70 
71     /**
72      * @dev Gets the balance of the specified address.
73      * @param _owner The address to query the the balance of.
74      * @return An uint256 representing the amount owned by the passed address.
75      */
76     function balanceOf(address _owner) public view returns(uint256) {
77         return balances[_owner];
78     }
79 
80     /**
81      * @dev Function to check the amount of tokens that an owner allowed to a spender.
82      * @param _owner address The address which owns the funds.
83      * @param _spender address The address which will spend the funds.
84      * @return A uint256 specifying the amount of tokens still available for the spender.
85      */
86     function allowance(address _owner, address _spender) public view returns(uint256) {
87         return allowed[_owner][_spender];
88     }
89 
90     /**
91      * @dev Transfer token for a specified address
92      * @param _to The address to transfer to.
93      * @param _value The amount to be transferred.
94      */
95     function transfer(address _to, uint256 _value) public returns(bool) {
96         require(_to != address(0));
97         require(_value <= balances[msg.sender]);
98 
99         balances[msg.sender] = balances[msg.sender].sub(_value);
100         balances[_to] = balances[_to].add(_value);
101         emit Transfer(msg.sender, _to, _value);
102         return true;
103     }
104 
105     /**
106      * @dev Approve the passed address to spend the specified amount of tokens on behalf of msg.sender.
107      * Beware that changing an allowance with this method brings the risk that someone may use both the old
108      * and the new allowance by unfortunate transaction ordering. One possible solution to mitigate this
109      * race condition is to first reduce the spender's allowance to 0 and set the desired value afterwards:
110      * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
111      * @param _spender The address which will spend the funds.
112      * @param _value The amount of tokens to be spent.
113      */
114     function approve(address _spender, uint256 _value) public returns(bool) {
115         allowed[msg.sender][_spender] = _value;
116         emit Approval(msg.sender, _spender, _value);
117         return true;
118     }
119 
120     /**
121      * @dev Transfer tokens from one address to another
122      * @param _from address The address which you want to send tokens from
123      * @param _to address The address which you want to transfer to
124      * @param _value uint256 the amount of tokens to be transferred
125      */
126     function transferFrom(address _from, address _to, uint256 _value) public returns(bool) {
127         require(_to != address(0));
128         require(_value <= balances[_from]);
129         require(_value <= allowed[_from][msg.sender]);
130 
131         balances[_from] = balances[_from].sub(_value);
132         balances[_to] = balances[_to].add(_value);
133         allowed[_from][msg.sender] = allowed[_from][msg.sender].sub(_value);
134         emit Transfer(_from, _to, _value);
135         return true;
136     }
137 
138     /**
139      * @dev Increase the amount of tokens that an owner allowed to a spender.
140      * approve should be called when allowed[_spender] == 0. To increment
141      * allowed value is better to use this function to avoid 2 calls (and wait until
142      * the first transaction is mined)
143      * From MonolithDAO Token.sol
144      * @param _spender The address which will spend the funds.
145      * @param _addedValue The amount of tokens to increase the allowance by.
146      */
147     function increaseApproval(address _spender, uint256 _addedValue) public returns(bool) {
148         allowed[msg.sender][_spender] = allowed[msg.sender][_spender].add(_addedValue);
149         emit Approval(msg.sender, _spender, allowed[msg.sender][_spender]);
150         return true;
151     }
152 
153     /**
154      * @dev Decrease the amount of tokens that an owner allowed to a spender.
155      * approve should be called when allowed[_spender] == 0. To decrement
156      * allowed value is better to use this function to avoid 2 calls (and wait until
157      * the first transaction is mined)
158      * From MonolithDAO Token.sol
159      * @param _spender The address which will spend the funds.
160      * @param _subtractedValue The amount of tokens to decrease the allowance by.
161      */
162     function decreaseApproval(address _spender, uint256 _subtractedValue) public returns(bool) {
163         uint256 oldValue = allowed[msg.sender][_spender];
164         if (_subtractedValue >= oldValue) {
165             allowed[msg.sender][_spender] = 0;
166         } else {
167             allowed[msg.sender][_spender] = oldValue.sub(_subtractedValue);
168         }
169         emit Approval(msg.sender, _spender, allowed[msg.sender][_spender]);
170         return true;
171     }
172 }
173 
174 contract KG is StandardToken {
175     string public constant name = "KG"; // name of Token 
176     string public constant symbol = "KG"; // symbol of Token 
177     uint8 public constant decimals = 18;
178 
179     uint256 internal constant INIT_TOTALSUPPLY = 30000000000; // Total amount of tokens
180 
181     constructor() public {
182         address wallet = 0xBd58bb4471B32bdA19dac4c5B3772e92fb78c79a;
183         totalSupply = INIT_TOTALSUPPLY * 10 ** uint256(decimals);
184         balances[wallet] = totalSupply;
185         emit Transfer(address(0), wallet, totalSupply);
186     }
187 }