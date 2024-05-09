1 pragma solidity ^0.5.8;
2 
3 /**
4  * @title SafeMaths
5  * @dev Math operations with safety checks that throw on error
6  */
7 
8 library SafeMath {
9     function mul(uint256 a, uint256 b) internal pure returns (uint256) {
10         uint256 c = a * b;
11         assert(a == 0 || c / a == b);
12         return c;
13     }
14 
15     function div(uint256 a, uint256 b) internal pure returns (uint256) {
16         // assert(b > 0); // Solidity automatically throws when dividing by 0
17         uint256 c = a / b;
18         // assert(a == b * c + a % b); // There is no case in which this doesn't hold
19         return c;
20     }
21 
22     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
23         assert(b <= a);
24         return a - b;
25     }
26 
27     function add(uint256 a, uint256 b) internal pure returns (uint256) {
28         uint256 c = a + b;
29         assert(c >= a);
30         return c;
31     }
32 }
33 
34 /**
35  * Welcome to the Telegram chat https://devsolidity.io/
36  */
37 contract Token {
38     uint256 public totalSupply;
39 
40     function balanceOf(address who) public view returns (uint256);
41     function transfer(address to, uint256 value) public returns (bool);
42     function allowance(address owner, address spender) public view returns (uint256);
43     function transferFrom(address from, address to, uint256 value) public returns (bool);
44     function approve(address spender, uint256 value) public returns (bool);
45 
46     event Transfer(address indexed from, address indexed to, uint256 value);
47     event Approval(address indexed owner, address indexed spender, uint256 value);
48 }
49 
50 contract StandardToken is Token {
51     using SafeMath for uint256;
52     mapping(address => mapping (address => uint256)) internal allowed;
53     mapping(address => uint256) balances;
54 
55     /**
56     * @dev transfer token for a specified address
57     * @param _to The address to transfer to.
58     * @param _value The amount to be transferred.
59     */
60     function transfer(address _to, uint256 _value) public returns (bool) {
61         require(_to != address(0));
62         require(balances[msg.sender] >= _value && balances[_to].add(_value) >= balances[_to]);
63 
64         balances[msg.sender] = balances[msg.sender].sub(_value);
65         balances[_to] = balances[_to].add(_value);
66 
67         emit Transfer(msg.sender, _to, _value);
68         return true;
69     }
70 
71     /**
72     * @dev Gets the balance of the specified address.
73     * @param _owner The address to query the the balance of.
74     * @return An uint256 representing the amount owned by the passed address.
75     */
76     function balanceOf(address _owner) public view returns (uint256 balance) {
77         return balances[_owner];
78     }
79 
80 
81     /**
82     * @dev Transfer tokens from one address to another
83     * @param _from address The address which you want to send tokens from
84     * @param _to address The address which you want to transfer to
85     * @param _value uint256 the amount of tokens to be transferred
86     */
87     function transferFrom(address _from, address _to, uint256 _value) public returns (bool) {
88         require(_to != address(0));
89         require(_value <= allowed[_from][msg.sender]);
90 
91         balances[_from] = balances[_from].sub(_value);
92         balances[_to] = balances[_to].add(_value);
93         allowed[_from][msg.sender] = allowed[_from][msg.sender].sub(_value);
94 
95         emit Transfer(_from, _to, _value);
96         return true;
97     }
98 
99     /**
100     * @dev Approve the passed address to spend the specified amount of tokens on behalf of msg.sender.
101     *
102     * Beware that changing an allowance with this method brings the risk that someone may use both the old
103     * and the new allowance by unfortunate transaction ordering. One possible solution to mitigate this
104     * race condition is to first reduce the spender's allowance to 0 and set the desired value afterwards:
105     * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
106     * @param _spender The address which will spend the funds.
107     * @param _value The amount of tokens to be spent.
108     */
109     function approve(address _spender, uint256 _value) public returns (bool) {
110         allowed[msg.sender][_spender] = _value;
111 
112         emit Approval(msg.sender, _spender, _value);
113         return true;
114     }
115 
116     /**
117     * @dev Function to check the amount of tokens that an owner allowed to a spender.
118     * @param _owner address The address which owns the funds.
119     * @param _spender address The address which will spend the funds.
120     * @return A uint256 specifying the amount of tokens still available for the spender.
121     */
122     function allowance(address _owner, address _spender) public view returns (uint256 remaining) {
123         return allowed[_owner][_spender];
124     }
125 
126     /**
127     * approve should be called when allowed[_spender] == 0. To increment
128     * allowed value is better to use this function to avoid 2 calls (and wait until
129     * the first transaction is mined)
130     * From MonolithDAO Token.sol
131     */
132     function increaseApproval(address _spender, uint256 _addedValue) public returns (bool success) {
133         allowed[msg.sender][_spender] = allowed[msg.sender][_spender].add(_addedValue);
134 
135         emit Approval(msg.sender, _spender, allowed[msg.sender][_spender]);
136         return true;
137     }
138 
139     function decreaseApproval(address _spender, uint256 _subtractedValue) public returns (bool success) {
140         uint256 oldValue = allowed[msg.sender][_spender];
141 
142         if (_subtractedValue > oldValue) {
143           allowed[msg.sender][_spender] = 0;
144         } else {
145           allowed[msg.sender][_spender] = oldValue.sub(_subtractedValue);
146         }
147 
148         emit Approval(msg.sender, _spender, allowed[msg.sender][_spender]);
149         return true;
150     }
151 }
152 
153 contract DappChannel is StandardToken {
154     string public constant name = "Yanzhi Blockchain";
155     string public constant symbol = "YZB";
156     uint256 public constant decimals = 18;
157     uint256 public constant INITIAL_SUPPLY = 210000000 * (10**decimals);
158     address public tokenWallet;
159 
160     constructor() public {
161         totalSupply = INITIAL_SUPPLY;
162         tokenWallet = msg.sender;
163         balances[tokenWallet] = totalSupply;
164     }
165 }