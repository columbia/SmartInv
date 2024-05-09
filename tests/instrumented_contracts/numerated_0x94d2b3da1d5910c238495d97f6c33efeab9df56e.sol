1 pragma solidity ^0.4.24;
2 
3 /**
4  * @title SafeMath
5  * @dev Math operations with safety checks that throw on error
6  */
7 library SafeMath {
8     function mul(uint256 a, uint256 b)  internal pure returns (uint256) {
9         uint256 c = a * b;
10         assert(a == 0 || c / a == b);
11         return c;
12     }
13 
14     function div(uint256 a, uint256 b)  internal pure returns (uint256) {
15         // assert(b > 0); // Solidity automatically throws when dividing by 0
16         uint256 c = a / b;
17         // assert(a == b * c + a % b); // There is no case in which this doesn't hold
18         return c;
19     }
20 
21     function sub(uint256 a, uint256 b)  internal pure returns (uint256) {
22         assert(b <= a);
23         return a - b;
24     }
25 
26     function add(uint256 a, uint256 b)  internal pure returns (uint256) {
27         uint256 c = a + b;
28         assert(c >= a);
29         return c;
30     }
31 }
32 
33 /**
34  * @title ERC20Basic
35  * @dev Simpler version of ERC20 interface
36  * @dev see https://github.com/ethereum/EIPs/issues/179
37  */
38 contract ERC20Basic {
39     uint256 public totalSupply;
40     function balanceOf(address who) public constant returns (uint256);
41     function transfer(address to, uint256 value) public returns (bool);
42     event Transfer(address indexed from, address indexed to, uint256 value);
43 }
44 
45 /**
46  * @title Basic token
47  * @dev Basic version of StandardToken, with no allowances.
48  */
49 contract BasicToken is ERC20Basic {
50     using SafeMath for uint256;
51 
52     mapping(address => uint256) balances;
53 
54     /**
55     * @dev transfer token for a specified address
56     * @param _to The address to transfer to.
57     * @param _value The amount to be transferred.
58     */
59     function transfer(address _to, uint256 _value) public returns (bool) {
60         require(_to != address(0));
61 
62         // SafeMath.sub will throw if there is not enough balance.
63         balances[msg.sender] = balances[msg.sender].sub(_value);
64         balances[_to] = balances[_to].add(_value);
65         emit Transfer(msg.sender, _to, _value);
66         return true;
67     }
68 
69     /**
70     * @dev Gets the balance of the specified address.
71     * @param _owner The address to query the the balance of.
72     * @return An uint256 representing the amount owned by the passed address.
73     */
74     function balanceOf(address _owner) public constant returns (uint256 balance) {
75         return balances[_owner];
76     }
77 
78 }
79 /**
80  * @title ERC20 interface
81  * @dev see https://github.com/ethereum/EIPs/issues/20
82  */
83 contract ERC20 is ERC20Basic {
84     function allowance(address owner, address spender) public constant returns (uint256);
85     function transferFrom(address from, address to, uint256 value) public returns (bool);
86     function approve(address spender, uint256 value) public returns (bool);
87     event Approval(address indexed owner, address indexed spender, uint256 value);
88 }
89 
90 
91 /**
92  * @title Standard ERC20 token
93  *
94  * @dev Implementation of the basic standard token.
95  * @dev https://github.com/ethereum/EIPs/issues/20
96  * @dev Based on code by FirstBlood: https://github.com/Firstbloodio/token/blob/master/smart_contract/FirstBloodToken.sol
97  */
98 contract StandardToken is ERC20, BasicToken {
99 
100     mapping (address => mapping (address => uint256)) allowed;
101 
102 
103     /**
104      * @dev Transfer tokens from one address to another
105      * @param _from address The address which you want to send tokens from
106      * @param _to address The address which you want to transfer to
107      * @param _value uint256 the amount of tokens to be transferred
108      */
109     function transferFrom(address _from, address _to, uint256 _value) public returns (bool) {
110         require(_to != address(0));
111 
112         uint256 _allowance = allowed[_from][msg.sender];
113 
114         // Check is not needed because sub(_allowance, _value) will already throw if this condition is not met
115         // require (_value <= _allowance);
116 
117         balances[_from] = balances[_from].sub(_value);
118         balances[_to] = balances[_to].add(_value);
119         allowed[_from][msg.sender] = _allowance.sub(_value);
120         emit Transfer(_from, _to, _value);
121         return true;
122     }
123 
124     /**
125      * @dev Approve the passed address to spend the specified amount of tokens on behalf of msg.sender.
126      *
127      * Beware that changing an allowance with this method brings the risk that someone may use both the old
128      * and the new allowance by unfortunate transaction ordering. One possible solution to mitigate this
129      * race condition is to first reduce the spender's allowance to 0 and set the desired value afterwards:
130      * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
131      * @param _spender The address which will spend the funds.
132      * @param _value The amount of tokens to be spent.
133      */
134     function approve(address _spender, uint256 _value) public returns (bool) {
135         allowed[msg.sender][_spender] = _value;
136         emit Approval(msg.sender, _spender, _value);
137         return true;
138     }
139 
140     /**
141      * @dev Function to check the amount of tokens that an owner allowed to a spender.
142      * @param _owner address The address which owns the funds.
143      * @param _spender address The address which will spend the funds.
144      * @return A uint256 specifying the amount of tokens still available for the spender.
145      */
146     function allowance(address _owner, address _spender) public constant returns (uint256 remaining) {
147         return allowed[_owner][_spender];
148     }
149 
150     /**
151      * approve should be called when allowed[_spender] == 0. To increment
152      * allowed value is better to use this function to avoid 2 calls (and wait until
153      * the first transaction is mined)
154      * From MonolithDAO Token.sol
155      */
156     function increaseApproval (address _spender, uint _addedValue) public returns (bool success) {
157         allowed[msg.sender][_spender] = allowed[msg.sender][_spender].add(_addedValue);
158         emit Approval(msg.sender, _spender, allowed[msg.sender][_spender]);
159         return true;
160     }
161 
162     function decreaseApproval (address _spender, uint _subtractedValue) public returns (bool success) {
163         uint oldValue = allowed[msg.sender][_spender];
164         if (_subtractedValue > oldValue) {
165             allowed[msg.sender][_spender] = 0;
166         } else {
167             allowed[msg.sender][_spender] = oldValue.sub(_subtractedValue);
168         }
169         emit Approval(msg.sender, _spender, allowed[msg.sender][_spender]);
170         return true;
171     }
172 
173 }
174 
175 contract CandyToken is StandardToken {
176     string public name = "CandyToken";
177     string public symbol = "CANDY";
178     uint public decimals = 4;
179     uint public INIT_SUPPLY = 1000000000 * (10 ** decimals);
180 
181     constructor() public {
182         totalSupply = INIT_SUPPLY;
183         balances[msg.sender] = INIT_SUPPLY;
184         emit Transfer(0x0, msg.sender, INIT_SUPPLY);
185     }
186 }