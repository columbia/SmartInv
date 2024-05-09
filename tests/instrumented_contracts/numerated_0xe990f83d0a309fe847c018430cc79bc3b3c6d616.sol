1 pragma solidity 0.4.21;
2 
3 library SafeMath {
4     function mul(uint256 a, uint256 b) internal pure returns (uint256) {
5         if (a == 0) {
6             return 0;
7         }
8         uint256 c = a * b;
9         assert(c / a == b);
10         return c;
11     }
12 
13     function div(uint256 a, uint256 b) internal pure returns (uint256) {
14         // assert(b > 0); // Solidity automatically throws when dividing by 0
15         uint256 c = a / b;
16         // assert(a == b * c + a % b); // There is no case in which this doesn't hold
17         return c;
18     }
19 
20     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
21         assert(b <= a);
22         return a - b;
23     }
24 
25     function add(uint256 a, uint256 b) internal pure returns (uint256) {
26         uint256 c = a + b;
27         assert(c >= a);
28         return c;
29     }
30 }
31 
32 contract ERC20 {
33     uint256 public totalSupply;
34     function balanceOf(address who) public view returns (uint256);
35     function transfer(address to, uint256 value) public returns (bool);
36     event Transfer(address indexed from, address indexed to, uint256 value);
37     function allowance(address owner, address spender) public view returns (uint256);
38     function transferFrom(address from, address to, uint256 value) public returns (bool);
39     function approve(address spender, uint256 value) public returns (bool);
40     event Approval(address indexed owner, address indexed spender, uint256 value);
41 }
42 
43 contract StandardToken is ERC20 {
44     using SafeMath for uint256;
45 
46     mapping(address => uint256) balances;
47     mapping (address => mapping (address => uint256)) internal allowed;
48 
49 
50     event Burn(address indexed burner, uint256 value);
51 
52     /**
53     * @dev transfer token for a specified address
54     * @param _to The address to transfer to.
55     * @param _value The amount to be transferred.
56     */
57     function transfer(address _to, uint256 _value) public returns (bool) {
58         require(_to != address(0));
59         require(_value <= balances[msg.sender]);
60 
61         // SafeMath.sub will throw if there is not enough balance.
62         balances[msg.sender] = balances[msg.sender].sub(_value);
63         balances[_to] = balances[_to].add(_value);
64         emit Transfer(msg.sender, _to, _value);
65         return true;
66     }
67 
68     /**
69     * @dev Gets the balance of the specified address.
70     * @param _owner The address to query the the balance of.
71     * @return An uint256 representing the amount owned by the passed address.
72     */
73     function balanceOf(address _owner) public view returns (uint256 balance) {
74         return balances[_owner];
75     }
76 
77 
78     /**
79      * @dev Transfer tokens from one address to another
80      * @param _from address The address which you want to send tokens from
81      * @param _to address The address which you want to transfer to
82      * @param _value uint256 the amount of tokens to be transferred
83      */
84     function transferFrom(address _from, address _to, uint256 _value) public returns (bool) {
85         require(_to != address(0));
86         require(_value <= balances[_from]);
87         require(_value <= allowed[_from][msg.sender]);
88 
89         balances[_from] = balances[_from].sub(_value);
90         balances[_to] = balances[_to].add(_value);
91         allowed[_from][msg.sender] = allowed[_from][msg.sender].sub(_value);
92         emit Transfer(_from, _to, _value);
93         return true;
94     }
95 
96     /**
97      * @dev Approve the passed address to spend the specified amount of tokens on behalf of msg.sender.
98      *
99      * Beware that changing an allowance with this method brings the risk that someone may use both the old
100      * and the new allowance by unfortunate transaction ordering. One possible solution to mitigate this
101      * race condition is to first reduce the spender's allowance to 0 and set the desired value afterwards:
102      * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
103      * @param _spender The address which will spend the funds.
104      * @param _value The amount of tokens to be spent.
105      */
106     function approve(address _spender, uint256 _value) public returns (bool) {
107         allowed[msg.sender][_spender] = _value;
108         emit Approval(msg.sender, _spender, _value);
109         return true;
110     }
111 
112     /**
113      * @dev Function to check the amount of tokens that an owner allowed to a spender.
114      * @param _owner address The address which owns the funds.
115      * @param _spender address The address which will spend the funds.
116      * @return A uint256 specifying the amount of tokens still available for the spender.
117      */
118     function allowance(address _owner, address _spender) public view returns (uint256) {
119         return allowed[_owner][_spender];
120     }
121 
122     /**
123      * @dev Increase the amount of tokens that an owner allowed to a spender.
124      *
125      * approve should be called when allowed[_spender] == 0. To increment
126      * allowed value is better to use this function to avoid 2 calls (and wait until
127      * the first transaction is mined)
128      * From MonolithDAO Token.sol
129      * @param _spender The address which will spend the funds.
130      * @param _addedValue The amount of tokens to increase the allowance by.
131      */
132     function increaseApproval(address _spender, uint _addedValue) public returns (bool) {
133         allowed[msg.sender][_spender] = allowed[msg.sender][_spender].add(_addedValue);
134         emit Approval(msg.sender, _spender, allowed[msg.sender][_spender]);
135         return true;
136     }
137 
138     /**
139      * @dev Decrease the amount of tokens that an owner allowed to a spender.
140      *
141      * approve should be called when allowed[_spender] == 0. To decrement
142      * allowed value is better to use this function to avoid 2 calls (and wait until
143      * the first transaction is mined)
144      * From MonolithDAO Token.sol
145      * @param _spender The address which will spend the funds.
146      * @param _subtractedValue The amount of tokens to decrease the allowance by.
147      */
148     function decreaseApproval(address _spender, uint _subtractedValue) public returns (bool) {
149         uint oldValue = allowed[msg.sender][_spender];
150         if (_subtractedValue > oldValue) {
151             allowed[msg.sender][_spender] = 0;
152         } else {
153             allowed[msg.sender][_spender] = oldValue.sub(_subtractedValue);
154         }
155         emit Approval(msg.sender, _spender, allowed[msg.sender][_spender]);
156         return true;
157     }
158 
159 
160     /**
161      * @dev Burns a specific amount of tokens.
162      * @param _value The amount of token to be burned.
163      */
164     function burn(uint256 _value) public {
165         require(_value <= balances[msg.sender]);
166         // no need to require value <= totalSupply, since that would imply the
167         // sender's balance is greater than the totalSupply, which *should* be an assertion failure
168 
169         address burner = msg.sender;
170         balances[burner] = balances[burner].sub(_value);
171         totalSupply = totalSupply.sub(_value);
172         emit Burn(burner, _value);
173     }
174 
175 }
176 
177 
178 contract CryptoRoboticsToken is StandardToken {
179     using SafeMath for uint256;
180 
181     string public constant name = "CryptoRobotics";
182     string public constant symbol = "ROBO";
183     uint8 public constant decimals = 18;
184 
185     address public advisors;
186     address public bounty;
187     address public reserve_fund;
188 
189     uint256 public constant INITIAL_SUPPLY = 120000000 * (10 ** uint256(decimals));
190 
191     /**
192      * @dev Constructor that gives msg.sender all of existing tokens.
193      */
194     function CryptoRoboticsToken() public {
195         totalSupply = INITIAL_SUPPLY;
196 
197         advisors = 0x24Eff98D6c10f9132a62B02dF415c917Bf6b4D12;
198         bounty = 0x23b8A6dD54bd6107EA9BD11D9B3856f8de4De10B;
199         reserve_fund = 0x7C88C296B9042946f821F5456bd00EA92a13B3BB;
200 
201         balances[advisors] = getPercent(INITIAL_SUPPLY,7);
202         emit Transfer(address(0), advisors, getPercent(INITIAL_SUPPLY,7));
203 
204         balances[bounty] = getPercent(INITIAL_SUPPLY,3);
205         emit Transfer(address(0), bounty, getPercent(INITIAL_SUPPLY,3));
206 
207         balances[reserve_fund] = getPercent(INITIAL_SUPPLY,9);
208         emit Transfer(address(0), reserve_fund, getPercent(INITIAL_SUPPLY,9));
209 
210         balances[msg.sender] = getPercent(INITIAL_SUPPLY,81); //for preico 8%  and ico 40%  and founders 30% + dev 3%
211         emit Transfer(address(0), msg.sender, getPercent(INITIAL_SUPPLY,81));
212         //after deploy owner send tokens for ico and to founders contract
213     }
214 
215     function getPercent(uint _value, uint _percent) internal pure returns(uint quotient)
216     {
217         uint _quotient = _value.mul(_percent).div(100);
218         return ( _quotient);
219     }
220 
221 }