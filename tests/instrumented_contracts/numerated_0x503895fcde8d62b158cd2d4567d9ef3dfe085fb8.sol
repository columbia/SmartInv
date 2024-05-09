1 pragma solidity ^0.4.18;
2 
3 library SafeMath {
4 
5     /**
6     * @dev Multiplies two numbers, throws on overflow.
7     */
8     function mul(uint256 a, uint256 b) internal pure returns (uint256) {
9         if (a == 0) {
10             return 0;
11         }
12         uint256 c = a * b;
13         assert(c / a == b);
14         return c;
15     }
16 
17     /**
18     * @dev Integer division of two numbers, truncating the quotient.
19     */
20     function div(uint256 a, uint256 b) internal pure returns (uint256) {
21         // assert(b > 0); // Solidity automatically throws when dividing by 0
22         uint256 c = a / b;
23         // assert(a == b * c + a % b); // There is no case in which this doesn't hold
24         return c;
25     }
26 
27     /**
28     * @dev Subtracts two numbers, throws on overflow (i.e. if subtrahend is greater than minuend).
29     */
30     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
31         assert(b <= a);
32         return a - b;
33     }
34 
35     /**
36     * @dev Adds two numbers, throws on overflow.
37     */
38     function add(uint256 a, uint256 b) internal pure returns (uint256) {
39         uint256 c = a + b;
40         assert(c >= a);
41         return c;
42     }
43 }
44 
45 contract ERC20Basic {
46     function totalSupply() public view returns (uint256);
47     function balanceOf(address who) public view returns (uint256);
48     function transfer(address to, uint256 value) public returns (bool);
49     event Transfer(address indexed from, address indexed to, uint256 value);
50 }
51 
52 contract ERC20 is ERC20Basic {
53     function allowance(address owner, address spender) public view returns (uint256);
54     function transferFrom(address from, address to, uint256 value) public returns (bool);
55     function approve(address spender, uint256 value) public returns (bool);
56     event Approval(address indexed owner, address indexed spender, uint256 value);
57 }
58 
59 
60 contract BasicToken is ERC20Basic {
61     using SafeMath for uint256;
62 
63     mapping(address => uint256) balances;
64 
65     uint256 totalSupply_;
66 
67     /**
68     * @dev total number of tokens in existence
69     */
70     function totalSupply() public view returns (uint256) {
71         return totalSupply_;
72     }
73 
74     /**
75     * @dev transfer token for a specified address
76     * @param _to The address to transfer to.
77     * @param _value The amount to be transferred.
78     */
79     function transfer(address _to, uint256 _value) public returns (bool) {
80         require(_to != address(0));
81         require(_value <= balances[msg.sender]);
82 
83         // SafeMath.sub will throw if there is not enough balance.
84         balances[msg.sender] = balances[msg.sender].sub(_value);
85         balances[_to] = balances[_to].add(_value);
86         Transfer(msg.sender, _to, _value);
87         return true;
88     }
89 
90     /**
91     * @dev Gets the balance of the specified address.
92     * @param _owner The address to query the the balance of.
93     * @return An uint256 representing the amount owned by the passed address.
94     */
95     function balanceOf(address _owner) public view returns (uint256 balance) {
96         return balances[_owner];
97     }
98 
99 }
100 
101 
102 contract StandardToken is ERC20, BasicToken {
103 
104     mapping (address => mapping (address => uint256)) internal allowed;
105 
106 
107     /**
108      * @dev Transfer tokens from one address to another
109      * @param _from address The address which you want to send tokens from
110      * @param _to address The address which you want to transfer to
111      * @param _value uint256 the amount of tokens to be transferred
112      */
113     function transferFrom(address _from, address _to, uint256 _value) public returns (bool) {
114         require(_to != address(0));
115         require(_value <= balances[_from]);
116         require(_value <= allowed[_from][msg.sender]);
117 
118         balances[_from] = balances[_from].sub(_value);
119         balances[_to] = balances[_to].add(_value);
120         allowed[_from][msg.sender] = allowed[_from][msg.sender].sub(_value);
121         Transfer(_from, _to, _value);
122         return true;
123     }
124 
125     /**
126      * @dev Approve the passed address to spend the specified amount of tokens on behalf of msg.sender.
127      *
128      * Beware that changing an allowance with this method brings the risk that someone may use both the old
129      * and the new allowance by unfortunate transaction ordering. One possible solution to mitigate this
130      * race condition is to first reduce the spender's allowance to 0 and set the desired value afterwards:
131      * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
132      * @param _spender The address which will spend the funds.
133      * @param _value The amount of tokens to be spent.
134      */
135     function approve(address _spender, uint256 _value) public returns (bool) {
136         allowed[msg.sender][_spender] = _value;
137         Approval(msg.sender, _spender, _value);
138         return true;
139     }
140 
141     /**
142      * @dev Function to check the amount of tokens that an owner allowed to a spender.
143      * @param _owner address The address which owns the funds.
144      * @param _spender address The address which will spend the funds.
145      * @return A uint256 specifying the amount of tokens still available for the spender.
146      */
147     function allowance(address _owner, address _spender) public view returns (uint256) {
148         return allowed[_owner][_spender];
149     }
150 
151     /**
152      * @dev Increase the amount of tokens that an owner allowed to a spender.
153      *
154      * approve should be called when allowed[_spender] == 0. To increment
155      * allowed value is better to use this function to avoid 2 calls (and wait until
156      * the first transaction is mined)
157      * From MonolithDAO Token.sol
158      * @param _spender The address which will spend the funds.
159      * @param _addedValue The amount of tokens to increase the allowance by.
160      */
161     function increaseApproval(address _spender, uint _addedValue) public returns (bool) {
162         allowed[msg.sender][_spender] = allowed[msg.sender][_spender].add(_addedValue);
163         Approval(msg.sender, _spender, allowed[msg.sender][_spender]);
164         return true;
165     }
166 
167     /**
168      * @dev Decrease the amount of tokens that an owner allowed to a spender.
169      *
170      * approve should be called when allowed[_spender] == 0. To decrement
171      * allowed value is better to use this function to avoid 2 calls (and wait until
172      * the first transaction is mined)
173      * From MonolithDAO Token.sol
174      * @param _spender The address which will spend the funds.
175      * @param _subtractedValue The amount of tokens to decrease the allowance by.
176      */
177     function decreaseApproval(address _spender, uint _subtractedValue) public returns (bool) {
178         uint oldValue = allowed[msg.sender][_spender];
179         if (_subtractedValue > oldValue) {
180             allowed[msg.sender][_spender] = 0;
181         } else {
182             allowed[msg.sender][_spender] = oldValue.sub(_subtractedValue);
183         }
184         Approval(msg.sender, _spender, allowed[msg.sender][_spender]);
185         return true;
186     }
187 
188 }
189 
190 
191 contract JTrex is StandardToken {
192 
193     string public constant name = "JTrex"; // solium-disable-line uppercase
194     string public constant symbol = "JTX"; // solium-disable-line uppercase
195     uint8 public constant decimals = 18; // solium-disable-line uppercase
196 
197     uint256 public constant INITIAL_SUPPLY = 1000000000 * (10 ** uint256(decimals));
198 
199     /**
200      * @dev Constructor that gives msg.sender all of existing tokens.
201      */
202     function JTrex() public {
203         totalSupply_ = INITIAL_SUPPLY;
204         balances[msg.sender] = INITIAL_SUPPLY;
205         Transfer(0x0, msg.sender, INITIAL_SUPPLY);
206     }
207 
208 }