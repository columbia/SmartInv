1 pragma solidity ^0.4.18;
2 
3 
4 library SafeMath {
5     function mul(uint256 a, uint256 b) internal pure returns (uint256) {
6         if (a == 0) {
7             return 0;
8         }
9         uint256 c = a * b;
10         assert(c / a == b);
11         return c;
12     }
13 
14     function div(uint256 a, uint256 b) internal pure returns (uint256) {
15         // assert(b > 0); // Solidity automatically throws when dividing by 0
16         uint256 c = a / b;
17         // assert(a == b * c + a % b); // There is no case in which this doesn't hold
18         return c;
19     }
20 
21     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
22         assert(b <= a);
23         return a - b;
24     }
25 
26     function add(uint256 a, uint256 b) internal pure returns (uint256) {
27         uint256 c = a + b;
28         assert(c >= a);
29         return c;
30     }
31 }
32 
33 
34 
35 contract ERC20Basic {
36     uint256 public totalSupply;
37     function balanceOf(address who) public view returns (uint256);
38     function transfer(address to, uint256 value) public returns (bool);
39     event Transfer(address indexed from, address indexed to, uint256 value);
40 }
41 
42 contract ERC20 is ERC20Basic {
43     function allowance(address owner, address spender) public view returns (uint256);
44     function transferFrom(address from, address to, uint256 value) public returns (bool);
45     function approve(address spender, uint256 value) public returns (bool);
46     event Approval(address indexed owner, address indexed spender, uint256 value);
47 }
48 
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
61         require(_value <= balances[msg.sender]);
62 
63         // SafeMath.sub will throw if there is not enough balance.
64         balances[msg.sender] = balances[msg.sender].sub(_value);
65         balances[_to] = balances[_to].add(_value);
66         Transfer(msg.sender, _to, _value);
67         return true;
68     }
69 
70     /**
71     * @dev Gets the balance of the specified address.
72     * @param _owner The address to query the the balance of.
73     * @return An uint256 representing the amount owned by the passed address.
74     */
75     function balanceOf(address _owner) public view returns (uint256 balance) {
76         return balances[_owner];
77     }
78 
79 }
80 
81 
82 contract StandardToken is ERC20, BasicToken {
83 
84     mapping (address => mapping (address => uint256)) internal allowed;
85 
86 
87     /**
88      * @dev Transfer tokens from one address to another
89      * @param _from address The address which you want to send tokens from
90      * @param _to address The address which you want to transfer to
91      * @param _value uint256 the amount of tokens to be transferred
92      */
93     function transferFrom(address _from, address _to, uint256 _value) public returns (bool) {
94         require(_to != address(0));
95         require(_value <= balances[_from]);
96         require(_value <= allowed[_from][msg.sender]);
97 
98         balances[_from] = balances[_from].sub(_value);
99         balances[_to] = balances[_to].add(_value);
100         allowed[_from][msg.sender] = allowed[_from][msg.sender].sub(_value);
101         Transfer(_from, _to, _value);
102         return true;
103     }
104 
105     /**
106      * @dev Approve the passed address to spend the specified amount of tokens on behalf of msg.sender.
107      *
108      * Beware that changing an allowance with this method brings the risk that someone may use both the old
109      * and the new allowance by unfortunate transaction ordering. One possible solution to mitigate this
110      * race condition is to first reduce the spender's allowance to 0 and set the desired value afterwards:
111      * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
112      * @param _spender The address which will spend the funds.
113      * @param _value The amount of tokens to be spent.
114      */
115     function approve(address _spender, uint256 _value) public returns (bool) {
116         allowed[msg.sender][_spender] = _value;
117         Approval(msg.sender, _spender, _value);
118         return true;
119     }
120 
121     /**
122      * @dev Function to check the amount of tokens that an owner allowed to a spender.
123      * @param _owner address The address which owns the funds.
124      * @param _spender address The address which will spend the funds.
125      * @return A uint256 specifying the amount of tokens still available for the spender.
126      */
127     function allowance(address _owner, address _spender) public view returns (uint256) {
128         return allowed[_owner][_spender];
129     }
130 
131     /**
132      * @dev Increase the amount of tokens that an owner allowed to a spender.
133      *
134      * approve should be called when allowed[_spender] == 0. To increment
135      * allowed value is better to use this function to avoid 2 calls (and wait until
136      * the first transaction is mined)
137      * From MonolithDAO Token.sol
138      * @param _spender The address which will spend the funds.
139      * @param _addedValue The amount of tokens to increase the allowance by.
140      */
141     function increaseApproval(address _spender, uint _addedValue) public returns (bool) {
142         allowed[msg.sender][_spender] = allowed[msg.sender][_spender].add(_addedValue);
143         Approval(msg.sender, _spender, allowed[msg.sender][_spender]);
144         return true;
145     }
146 
147     /**
148      * @dev Decrease the amount of tokens that an owner allowed to a spender.
149      *
150      * approve should be called when allowed[_spender] == 0. To decrement
151      * allowed value is better to use this function to avoid 2 calls (and wait until
152      * the first transaction is mined)
153      * From MonolithDAO Token.sol
154      * @param _spender The address which will spend the funds.
155      * @param _subtractedValue The amount of tokens to decrease the allowance by.
156      */
157     function decreaseApproval(address _spender, uint _subtractedValue) public returns (bool) {
158         uint oldValue = allowed[msg.sender][_spender];
159         if (_subtractedValue > oldValue) {
160             allowed[msg.sender][_spender] = 0;
161         } else {
162             allowed[msg.sender][_spender] = oldValue.sub(_subtractedValue);
163         }
164         Approval(msg.sender, _spender, allowed[msg.sender][_spender]);
165         return true;
166     }
167 
168 }
169 
170 contract ClickableTVToken  is StandardToken {
171 
172     string public constant name = "ClickableTV";
173     string public constant symbol = "CTV";
174     uint8 public constant decimals = 18;
175 
176     uint256 public constant INITIAL_SUPPLY = 100000000 * (10 ** uint256(decimals));
177 
178     /**
179      * @dev Constructor that gives msg.sender all of existing tokens.
180      */
181     function ClickableTVToken() public {
182         totalSupply = INITIAL_SUPPLY;
183         balances[msg.sender] = INITIAL_SUPPLY;
184         Transfer(0x0, msg.sender, INITIAL_SUPPLY);
185     }
186 
187 }