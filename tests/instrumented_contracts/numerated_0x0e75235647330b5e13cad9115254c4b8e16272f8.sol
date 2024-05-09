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
28     * @dev Substracts two numbers, throws on overflow (i.e. if subtrahend is greater than minuend).
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
47 
48     function balanceOf(address who) public view returns (uint256);
49 
50     function transfer(address to, uint256 value) public returns (bool);
51 
52     event Transfer(address indexed from, address indexed to, uint256 value);
53 }
54 
55 
56 contract ERC20 is ERC20Basic {
57     function allowance(address owner, address spender) public view returns (uint256);
58 
59     function transferFrom(address from, address to, uint256 value) public returns (bool);
60 
61     function approve(address spender, uint256 value) public returns (bool);
62 
63     event Approval(address indexed owner, address indexed spender, uint256 value);
64 }
65 
66 contract BasicToken is ERC20Basic {
67     using SafeMath for uint256;
68 
69     mapping(address => uint256) balances;
70 
71     uint256 totalSupply_;
72 
73     /**
74     * @dev total number of tokens in existence
75     */
76     function totalSupply() public view returns (uint256) {
77         return totalSupply_;
78     }
79 
80     /**
81     * @dev transfer token for a specified address
82     * @param _to The address to transfer to.
83     * @param _value The amount to be transferred.
84     */
85     function transfer(address _to, uint256 _value) public returns (bool) {
86         require(_to != address(0));
87         require(_value <= balances[msg.sender]);
88 
89         // SafeMath.sub will throw if there is not enough balance.
90         balances[msg.sender] = balances[msg.sender].sub(_value);
91         balances[_to] = balances[_to].add(_value);
92         emit Transfer(msg.sender, _to, _value);
93         return true;
94     }
95 
96     /**
97     * @dev Gets the balance of the specified address.
98     * @param _owner The address to query the the balance of.
99     * @return An uint256 representing the amount owned by the passed address.
100     */
101     function balanceOf(address _owner) public view returns (uint256 balance) {
102         return balances[_owner];
103     }
104 
105 }
106 
107 contract StandardToken is ERC20, BasicToken {
108 
109     mapping(address => mapping(address => uint256)) internal allowed;
110 
111 
112     /**
113      * @dev Transfer tokens from one address to another
114      * @param _from address The address which you want to send tokens from
115      * @param _to address The address which you want to transfer to
116      * @param _value uint256 the amount of tokens to be transferred
117      */
118     function transferFrom(address _from, address _to, uint256 _value) public returns (bool) {
119         require(_to != address(0));
120         require(_value <= balances[_from]);
121         require(_value <= allowed[_from][msg.sender]);
122 
123         balances[_from] = balances[_from].sub(_value);
124         balances[_to] = balances[_to].add(_value);
125         allowed[_from][msg.sender] = allowed[_from][msg.sender].sub(_value);
126         emit Transfer(_from, _to, _value);
127         return true;
128     }
129 
130     /**
131      * @dev Approve the passed address to spend the specified amount of tokens on behalf of msg.sender.
132      *
133      * Beware that changing an allowance with this method brings the risk that someone may use both the old
134      * and the new allowance by unfortunate transaction ordering. One possible solution to mitigate this
135      * race condition is to first reduce the spender's allowance to 0 and set the desired value afterwards:
136      * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
137      * @param _spender The address which will spend the funds.
138      * @param _value The amount of tokens to be spent.
139      */
140     function approve(address _spender, uint256 _value) public returns (bool) {
141         allowed[msg.sender][_spender] = _value;
142         emit Approval(msg.sender, _spender, _value);
143         return true;
144     }
145 
146     /**
147      * @dev Function to check the amount of tokens that an owner allowed to a spender.
148      * @param _owner address The address which owns the funds.
149      * @param _spender address The address which will spend the funds.
150      * @return A uint256 specifying the amount of tokens still available for the spender.
151      */
152     function allowance(address _owner, address _spender) public view returns (uint256) {
153         return allowed[_owner][_spender];
154     }
155 
156     /**
157      * @dev Increase the amount of tokens that an owner allowed to a spender.
158      *
159      * approve should be called when allowed[_spender] == 0. To increment
160      * allowed value is better to use this function to avoid 2 calls (and wait until
161      * the first transaction is mined)
162      * From MonolithDAO Token.sol
163      * @param _spender The address which will spend the funds.
164      * @param _addedValue The amount of tokens to increase the allowance by.
165      */
166     function increaseApproval(address _spender, uint _addedValue) public returns (bool) {
167         allowed[msg.sender][_spender] = allowed[msg.sender][_spender].add(_addedValue);
168         emit Approval(msg.sender, _spender, allowed[msg.sender][_spender]);
169         return true;
170     }
171 
172     /**
173      * @dev Decrease the amount of tokens that an owner allowed to a spender.
174      *
175      * approve should be called when allowed[_spender] == 0. To decrement
176      * allowed value is better to use this function to avoid 2 calls (and wait until
177      * the first transaction is mined)
178      * From MonolithDAO Token.sol
179      * @param _spender The address which will spend the funds.
180      * @param _subtractedValue The amount of tokens to decrease the allowance by.
181      */
182     function decreaseApproval(address _spender, uint _subtractedValue) public returns (bool) {
183         uint oldValue = allowed[msg.sender][_spender];
184         if (_subtractedValue > oldValue) {
185             allowed[msg.sender][_spender] = 0;
186         } else {
187             allowed[msg.sender][_spender] = oldValue.sub(_subtractedValue);
188         }
189         emit Approval(msg.sender, _spender, allowed[msg.sender][_spender]);
190         return true;
191     }
192 
193 }
194 
195 contract BurnableToken is BasicToken {
196 
197     event Burn(address indexed burner, uint256 value);
198 
199     /**
200      * @dev Burns a specific amount of tokens.
201      * @param _value The amount of token to be burned.
202      */
203     function burn(uint256 _value) public {
204         require(_value <= balances[msg.sender]);
205         // no need to require value <= totalSupply, since that would imply the
206         // sender's balance is greater than the totalSupply, which *should* be an assertion failure
207 
208         address burner = msg.sender;
209         balances[burner] = balances[burner].sub(_value);
210         totalSupply_ = totalSupply_.sub(_value);
211         emit Burn(burner, _value);
212     }
213 }
214 
215 contract XRRtoken is StandardToken, BurnableToken {
216 
217 
218     string public constant name = "Xchangerate Coin";
219     string public constant symbol = "XRR";
220     uint8 public constant decimals = 18;
221 
222     // Total Supply: 250 million
223     uint256 public constant INITIAL_SUPPLY = 250000000 * (10 ** uint256(decimals));
224 
225     function XRRtoken() public {
226         totalSupply_ = INITIAL_SUPPLY;
227         balances[msg.sender] = INITIAL_SUPPLY;
228         emit Transfer(0x0, msg.sender, INITIAL_SUPPLY);
229     }
230 }