1 pragma solidity ^0.4.18;
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
27 
28 }
29 
30 contract ERC20Basic {
31     uint256 public totalSupply;
32 
33     bool public transfersEnabled;
34 
35     function balanceOf(address who) public view returns (uint256);
36 
37     function transfer(address to, uint256 value) public returns (bool);
38 
39     event Transfer(address indexed from, address indexed to, uint256 value);
40 }
41 
42 contract ERC20 {
43     uint256 public totalSupply;
44 
45     bool public transfersEnabled;
46 
47     function balanceOf(address _owner) public constant returns (uint256 balance);
48 
49     function transfer(address _to, uint256 _value) public returns (bool success);
50 
51     function transferFrom(address _from, address _to, uint256 _value) public returns (bool success);
52 
53     function approve(address _spender, uint256 _value) public returns (bool success);
54 
55     function allowance(address _owner, address _spender) public constant returns (uint256 remaining);
56 
57     event Transfer(address indexed _from, address indexed _to, uint256 _value);
58     event Approval(address indexed _owner, address indexed _spender, uint256 _value);
59 }
60 
61 contract BasicToken is ERC20Basic {
62     using SafeMath for uint256;
63 
64     mapping(address => uint256) balances;
65 
66     /**
67     * @dev protection against short address attack
68     */
69     modifier onlyPayloadSize(uint numwords) {
70         assert(msg.data.length == numwords * 32 + 4);
71         _;
72     }
73 
74     /**
75     * @dev transfer token for a specified address
76     * @param _to The address to transfer to.
77     * @param _value The amount to be transferred.
78     */
79     function transfer(address _to, uint256 _value) public onlyPayloadSize(2) returns (bool) {
80         require(_to != address(0));
81         require(_value <= balances[msg.sender]);
82         require(transfersEnabled);
83 
84         // SafeMath.sub will throw if there is not enough balance.
85         balances[msg.sender] = balances[msg.sender].sub(_value);
86         balances[_to] = balances[_to].add(_value);
87         Transfer(msg.sender, _to, _value);
88         return true;
89     }
90 
91     /**
92     * @dev Gets the balance of the specified address.
93     * @param _owner The address to query the the balance of.
94     * @return An uint256 representing the amount owned by the passed address.
95     */
96     function balanceOf(address _owner) public constant returns (uint256 balance) {
97         return balances[_owner];
98     }
99 
100 }
101 
102 contract StandardToken is ERC20, BasicToken {
103 
104     mapping(address => mapping(address => uint256)) internal allowed;
105 
106     /**
107      * @dev Transfer tokens from one address to another
108      * @param _from address The address which you want to send tokens from
109      * @param _to address The address which you want to transfer to
110      * @param _value uint256 the amount of tokens to be transferred
111      */
112     function transferFrom(address _from, address _to, uint256 _value) public onlyPayloadSize(3) returns (bool) {
113         require(_to != address(0));
114         require(_value <= balances[_from]);
115         require(_value <= allowed[_from][msg.sender]);
116         require(transfersEnabled);
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
147     function allowance(address _owner, address _spender) public onlyPayloadSize(2) constant returns (uint256 remaining) {
148         return allowed[_owner][_spender];
149     }
150 
151     /**
152      * approve should be called when allowed[_spender] == 0. To increment
153      * allowed value is better to use this function to avoid 2 calls (and wait until
154      * the first transaction is mined)
155      * From MonolithDAO Token.sol
156      */
157     function increaseApproval(address _spender, uint _addedValue) public returns (bool success) {
158         allowed[msg.sender][_spender] = allowed[msg.sender][_spender].add(_addedValue);
159         Approval(msg.sender, _spender, allowed[msg.sender][_spender]);
160         return true;
161     }
162 
163     function decreaseApproval(address _spender, uint _subtractedValue) public returns (bool success) {
164         uint oldValue = allowed[msg.sender][_spender];
165         if (_subtractedValue > oldValue) {
166             allowed[msg.sender][_spender] = 0;
167         } else {
168             allowed[msg.sender][_spender] = oldValue.sub(_subtractedValue);
169         }
170         Approval(msg.sender, _spender, allowed[msg.sender][_spender]);
171         return true;
172     }
173 
174 }
175 
176 contract HPQToken is StandardToken {
177 
178     string public constant name = "High Purity Quartz";
179     string public constant symbol = "HPQ";
180     uint8 public constant decimals = 2;
181     uint256 public constant INITIAL_SUPPLY = 50 * 10**6 * (10**uint256(decimals));
182 
183     address public owner;
184 
185     function HPQToken(address _owner) public {
186         totalSupply = INITIAL_SUPPLY;
187         owner = _owner;
188         //owner = msg.sender; // for testing
189         balances[owner] = INITIAL_SUPPLY;
190         transfersEnabled = true;
191     }
192 
193     modifier onlyOwner() {
194         require(msg.sender == owner);
195         _;
196     }
197 
198     function enableTransfers(bool _transfersEnabled) onlyOwner public {
199         transfersEnabled = _transfersEnabled;
200     }
201 
202     /**
203      * Peterson's Law Protection
204      * Claim tokens
205      */
206     function claimTokens() public onlyOwner {
207         owner.transfer(this.balance);
208         uint256 balance = balanceOf(this);
209         transfer(owner, balance);
210         Transfer(this, owner, balance);
211     }
212 }