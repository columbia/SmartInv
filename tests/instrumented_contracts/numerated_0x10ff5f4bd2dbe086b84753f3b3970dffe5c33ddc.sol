1 pragma solidity ^0.4.24;
2 
3 /**
4  * @title SafeMath
5  * @dev Math operations with safety checks that throw on error
6  */
7 library SafeMath {
8 
9     /**
10     * @dev Multiplies two numbers, throws on overflow.
11     */
12     function mul(uint256 a, uint256 b) internal pure returns (uint256) {
13         if (a == 0) {
14             return 0;
15         }
16         uint256 c = a * b;
17         assert(c / a == b);
18         return c;
19     }
20 
21     /**
22     * @dev Integer division of two numbers, truncating the quotient.
23     */
24     function div(uint256 a, uint256 b) internal pure returns (uint256) {
25         // assert(b > 0); // Solidity automatically throws when dividing by 0
26         // uint256 c = a / b;
27         // assert(a == b * c + a % b); // There is no case in which this doesn't hold
28         return a / b;
29     }
30 
31     /**
32     * @dev Subtracts two numbers, throws on overflow (i.e. if subtrahend is greater than minuend).
33     */
34     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
35         assert(b <= a);
36         return a - b;
37     }
38 
39     /**
40     * @dev Adds two numbers, throws on overflow.
41     */
42     function add(uint256 a, uint256 b) internal pure returns (uint256) {
43         uint256 c = a + b;
44         assert(c >= a);
45         return c;
46     }
47 }
48 
49 /**
50  * @title Standard Token
51  */
52 contract StandardToken {
53     using SafeMath for uint256;
54 
55     event Transfer(address indexed from, address indexed to, uint256 value);
56     event Approval(address indexed owner, address indexed spender, uint256 value);
57 
58     mapping(address => uint256) internal balances;
59     mapping (address => mapping (address => uint256)) internal allowed;
60 
61     uint256 internal totalSupply_;
62     string public name;
63     string public symbol;
64     uint8 public decimals;
65 
66     constructor(string tokenName, string tokenSymbol, uint8 tokenDecimals, uint256 tokenSupply) public {
67         name = tokenName;
68         symbol = tokenSymbol;
69         decimals = tokenDecimals;
70         totalSupply_ = tokenSupply * 10 ** uint256(decimals);
71         balances[msg.sender] = totalSupply_;
72     }
73 
74     /**
75     * @dev total number of tokens in existence
76     */
77     function totalSupply() public view returns (uint256) {
78         return totalSupply_;
79     }
80 
81     /**
82     * @dev Gets the balance of the specified address.
83     * @param _owner The address to query the the balance of.
84     * @return An uint256 representing the amount owned by the passed address.
85     */
86     function balanceOf(address _owner) public view returns (uint256) {
87         return balances[_owner];
88     }
89 
90     /**
91      * @dev Function to check the amount of tokens that an owner allowed to a spender.
92      * @param _owner address The address which owns the funds.
93      * @param _spender address The address which will spend the funds.
94      * @return A uint256 specifying the amount of tokens still available for the spender.
95      */
96     function allowance(address _owner, address _spender) public view returns (uint256) {
97         return allowed[_owner][_spender];
98     }
99 
100     /**
101     * @dev transfer token for a specified address
102     * @param _to The address to transfer to.
103     * @param _value The amount to be transferred.
104     */
105     function transfer(address _to, uint256 _value) public returns (bool) {
106         require(_to != address(0));
107         require(_value <= balances[msg.sender]);
108 
109         balances[msg.sender] = balances[msg.sender].sub(_value);
110         balances[_to] = balances[_to].add(_value);
111         emit Transfer(msg.sender, _to, _value);
112         return true;
113     }
114 
115 
116     /**
117      * @dev Transfer tokens from one address to another
118      * @param _from address The address which you want to send tokens from
119      * @param _to address The address which you want to transfer to
120      * @param _value uint256 the amount of tokens to be transferred
121      */
122     function transferFrom(address _from, address _to, uint256 _value) public returns (bool) {
123         require(_to != address(0));
124         require(_value <= balances[_from]);
125         require(_value <= allowed[_from][msg.sender]);
126 
127         balances[_from] = balances[_from].sub(_value);
128         balances[_to] = balances[_to].add(_value);
129         allowed[_from][msg.sender] = allowed[_from][msg.sender].sub(_value);
130         emit Transfer(_from, _to, _value);
131         return true;
132     }
133 
134     /**
135      * @dev Approve the passed address to spend the specified amount of tokens on behalf of msg.sender.
136      *
137      * Beware that changing an allowance with this method brings the risk that someone may use both the old
138      * and the new allowance by unfortunate transaction ordering. One possible solution to mitigate this
139      * race condition is to first reduce the spender's allowance to 0 and set the desired value afterwards:
140      * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
141      * @param _spender The address which will spend the funds.
142      * @param _value The amount of tokens to be spent.
143      */
144     function approve(address _spender, uint256 _value) public returns (bool) {
145         allowed[msg.sender][_spender] = _value;
146         emit Approval(msg.sender, _spender, _value);
147         return true;
148     }
149 
150     /**
151      * @dev Increase the amount of tokens that an owner allowed to a spender.
152      * approve should be called when allowed[_spender] == 0. To increment
153      * allowed value is better to use this function to avoid 2 calls (and wait until
154      * the first transaction is mined)
155      * From MonolithDAO Token.sol
156      * @param _spender The address which will spend the funds.
157      * @param _addedValue The amount of tokens to increase the allowance by.
158      */
159     function increaseApproval(address _spender, uint256 _addedValue) public returns (bool) {
160         allowed[msg.sender][_spender] = (
161         allowed[msg.sender][_spender].add(_addedValue));
162         emit Approval(msg.sender, _spender, allowed[msg.sender][_spender]);
163         return true;
164     }
165 
166     /**
167      * @dev Decrease the amount of tokens that an owner allowed to a spender.
168      * approve should be called when allowed[_spender] == 0. To decrement
169      * allowed value is better to use this function to avoid 2 calls (and wait until
170      * the first transaction is mined)
171      * From MonolithDAO Token.sol
172      * @param _spender The address which will spend the funds.
173      * @param _subtractedValue The amount of tokens to decrease the allowance by.
174      */
175     function decreaseApproval(address _spender, uint256 _subtractedValue) public returns (bool) {
176         uint256 oldValue = allowed[msg.sender][_spender];
177         if (_subtractedValue >= oldValue) {
178             allowed[msg.sender][_spender] = 0;
179         } else {
180             allowed[msg.sender][_spender] = oldValue.sub(_subtractedValue);
181         }
182         emit Approval(msg.sender, _spender, allowed[msg.sender][_spender]);
183         return true;
184     }
185 }
186 
187 /**
188  * @title Basic token
189  * @dev Basic version of StandardToken
190  */
191 contract ERC20Token is StandardToken {
192     constructor(string tokenName, string tokenSymbol, uint8 tokenDecimals, uint256 tokenSupply, address initAddress, uint256 initBalance) StandardToken(tokenName, tokenSymbol, tokenDecimals, tokenSupply) public {
193         if (initBalance > 0 && initAddress != address(0)) {
194             uint256 ib = initBalance * 10 ** uint256(decimals);
195             require(ib <= totalSupply_);
196             balances[initAddress] = ib;
197             balances[msg.sender] = totalSupply_.sub(ib);
198         }
199     }
200 }
201 
202 /**
203  * @title Burnable Token
204  * @dev Token that can be irreversibly burned (destroyed).
205  */
206 contract BurnableERC20Token is ERC20Token {
207 
208     event Burn(address indexed burner, uint256 value);
209 
210     constructor(string tokenName, string tokenSymbol, uint8 tokenDecimals, uint256 tokenSupply, address initAddress, uint256 initBalance) ERC20Token(tokenName, tokenSymbol, tokenDecimals, tokenSupply, initAddress, initBalance) public {
211     }
212 
213     /**
214      * @dev Burns a specific amount of tokens.
215      * @param _value The amount of token to be burned.
216      */
217     function burn(uint256 _value) public {
218         _burn(msg.sender, _value);
219     }
220 
221     /**
222      * @dev Burns a specific amount of tokens from the target address and decrements allowance
223      * @param _from address The address which you want to send tokens from
224      * @param _value uint256 The amount of token to be burned
225      */
226     function burnFrom(address _from, uint256 _value) public {
227         require(_value <= allowed[_from][msg.sender]);
228         // Should https://github.com/OpenZeppelin/zeppelin-solidity/issues/707 be accepted,
229         // this function needs to emit an event with the updated approval.
230         allowed[_from][msg.sender] = allowed[_from][msg.sender].sub(_value);
231         _burn(_from, _value);
232     }
233 
234     function _burn(address _who, uint256 _value) internal {
235         require(_value <= balances[_who]);
236         // no need to require value <= totalSupply, since that would imply the
237         // sender's balance is greater than the totalSupply, which *should* be an assertion failure
238 
239         balances[_who] = balances[_who].sub(_value);
240         totalSupply_ = totalSupply_.sub(_value);
241         emit Burn(_who, _value);
242         emit Transfer(_who, address(0), _value);
243     }
244 }