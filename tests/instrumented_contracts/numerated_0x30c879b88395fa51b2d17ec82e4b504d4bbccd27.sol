1 pragma solidity ^0.4.24;
2 
3 /**
4  * Composed from OpenZeppelin
5  */
6 
7 contract ERC20 {
8     function totalSupply() public view returns (uint256);
9 
10     function balanceOf(address who) public view returns (uint256);
11     function transfer(address to, uint256 value) public returns (bool);
12     event Transfer(address indexed from, address indexed to, uint256 value);
13 
14     function allowance(address owner, address spender) public view returns (uint256);
15     function transferFrom(address from, address to, uint256 value) public returns (bool);
16     function approve(address spender, uint256 value) public returns (bool);
17     event Approval(address indexed owner, address indexed spender, uint256 value);
18 }
19 
20 /**
21  * @title SafeMath
22  * @dev Math operations with safety checks that throw on error
23  */
24 library SafeMath {
25 
26     /**
27      * @dev Multiplies two numbers, throws on overflow.
28      */
29     function mul(uint256 a, uint256 b) internal pure returns (uint256 c) {
30         // Gas optimization: this is cheaper than asserting 'a' not being zero, but the
31         // benefit is lost if 'b' is also tested.
32         // See: https://github.com/OpenZeppelin/openzeppelin-solidity/pull/522
33         if (a == 0) {
34             return 0;
35         }
36 
37         c = a * b;
38         assert(c / a == b);
39         return c;
40     }
41 
42     /**
43      * @dev Integer division of two numbers, truncating the quotient.
44      */
45     function div(uint256 a, uint256 b) internal pure returns (uint256) {
46         // assert(b > 0); // Solidity automatically throws when dividing by 0
47         // uint256 c = a / b;
48         // assert(a == b * c + a % b); // There is no case in which this doesn't hold
49         return a / b;
50     }
51 
52     /**
53      * @dev Subtracts two numbers, throws on overflow (i.e. if subtrahend is greater than minuend).
54      */
55     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
56         assert(b <= a);
57         return a - b;
58     }
59 
60     /**
61      * @dev Adds two numbers, throws on overflow.
62      */
63     function add(uint256 a, uint256 b) internal pure returns (uint256 c) {
64         c = a + b;
65         assert(c >= a);
66         return c;
67     }
68 }
69 
70 
71 contract StandardBurnableToken is ERC20 {
72     using SafeMath for uint256;
73 
74     mapping(address => uint256) balances;
75 
76     uint256 totalSupply_;
77 
78     /**
79      * @dev Total number of tokens in existence
80      */
81     function totalSupply() public view returns (uint256) {
82         return totalSupply_;
83     }
84 
85     /**
86      * @dev Transfer token for a specified address
87      * @param _to The address to transfer to.
88      * @param _value The amount to be transferred.
89      */
90     function transfer(address _to, uint256 _value) public returns (bool) {
91         require(_to != address(0));
92         require(_value <= balances[msg.sender]);
93 
94         balances[msg.sender] = balances[msg.sender].sub(_value);
95         balances[_to] = balances[_to].add(_value);
96         emit Transfer(msg.sender, _to, _value);
97         return true;
98     }
99 
100     /**
101      * @dev Gets the balance of the specified address.
102      * @param _owner The address to query the the balance of.
103      * @return An uint256 representing the amount owned by the passed address.
104      */
105     function balanceOf(address _owner) public view returns (uint256) {
106         return balances[_owner];
107     }
108 
109     mapping (address => mapping (address => uint256)) internal allowed;
110 
111     /**
112      * @dev Transfer tokens from one address to another
113      * @param _from address The address which you want to send tokens from
114      * @param _to address The address which you want to transfer to
115      * @param _value uint256 the amount of tokens to be transferred
116      */
117     function transferFrom(
118         address _from,
119         address _to,
120         uint256 _value
121     )
122     public
123     returns (bool)
124     {
125         require(_to != address(0));
126         require(_value <= balances[_from]);
127         require(_value <= allowed[_from][msg.sender]);
128 
129         balances[_from] = balances[_from].sub(_value);
130         balances[_to] = balances[_to].add(_value);
131         allowed[_from][msg.sender] = allowed[_from][msg.sender].sub(_value);
132         emit Transfer(_from, _to, _value);
133         return true;
134     }
135 
136     /**
137      * @dev Approve the passed address to spend the specified amount of tokens on behalf of msg.sender.
138      * Beware that changing an allowance with this method brings the risk that someone may use both the old
139      * and the new allowance by unfortunate transaction ordering. One possible solution to mitigate this
140      * race condition is to first reduce the spender's allowance to 0 and set the desired value afterwards:
141      * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
142      * @param _spender The address which will spend the funds.
143      * @param _value The amount of tokens to be spent.
144      */
145     function approve(address _spender, uint256 _value) public returns (bool) {
146         allowed[msg.sender][_spender] = _value;
147         emit Approval(msg.sender, _spender, _value);
148         return true;
149     }
150 
151     /**
152      * @dev Function to check the amount of tokens that an owner allowed to a spender.
153      * @param _owner address The address which owns the funds.
154      * @param _spender address The address which will spend the funds.
155      * @return A uint256 specifying the amount of tokens still available for the spender.
156      */
157     function allowance(
158         address _owner,
159         address _spender
160     )
161     public
162     view
163     returns (uint256)
164     {
165         return allowed[_owner][_spender];
166     }
167 
168     /**
169      * @dev Increase the amount of tokens that an owner allowed to a spender.
170      * approve should be called when allowed[_spender] == 0. To increment
171      * allowed value is better to use this function to avoid 2 calls (and wait until
172      * the first transaction is mined)
173      * From MonolithDAO Token.sol
174      * @param _spender The address which will spend the funds.
175      * @param _addedValue The amount of tokens to increase the allowance by.
176      */
177     function increaseApproval(
178         address _spender,
179         uint256 _addedValue
180     )
181     public
182     returns (bool)
183     {
184         allowed[msg.sender][_spender] = (
185             allowed[msg.sender][_spender].add(_addedValue));
186         emit Approval(msg.sender, _spender, allowed[msg.sender][_spender]);
187         return true;
188     }
189 
190     /**
191      * @dev Decrease the amount of tokens that an owner allowed to a spender.
192      * approve should be called when allowed[_spender] == 0. To decrement
193      * allowed value is better to use this function to avoid 2 calls (and wait until
194      * the first transaction is mined)
195      * From MonolithDAO Token.sol
196      * @param _spender The address which will spend the funds.
197      * @param _subtractedValue The amount of tokens to decrease the allowance by.
198      */
199     function decreaseApproval(
200         address _spender,
201         uint256 _subtractedValue
202     )
203     public
204     returns (bool)
205     {
206         uint256 oldValue = allowed[msg.sender][_spender];
207         if (_subtractedValue > oldValue) {
208             allowed[msg.sender][_spender] = 0;
209         } else {
210             allowed[msg.sender][_spender] = oldValue.sub(_subtractedValue);
211         }
212         emit Approval(msg.sender, _spender, allowed[msg.sender][_spender]);
213         return true;
214     }
215 
216     event Burn(address indexed burner, uint256 value);
217 
218     /**
219      * @dev Burns a specific amount of tokens.
220      * @param _value The amount of token to be burned.
221      */
222     function burn(uint256 _value) public {
223         _burn(msg.sender, _value);
224     }
225 
226     function _burn(address _who, uint256 _value) internal {
227         require(_value <= balances[_who]);
228         // no need to require value <= totalSupply, since that would imply the
229         // sender's balance is greater than the totalSupply, which *should* be an assertion failure
230 
231         balances[_who] = balances[_who].sub(_value);
232         totalSupply_ = totalSupply_.sub(_value);
233         emit Burn(_who, _value);
234         emit Transfer(_who, address(0), _value);
235     }
236 
237     /**
238      * @dev Burns a specific amount of tokens from the target address and decrements allowance
239      * @param _from address The address which you want to send tokens from
240      * @param _value uint256 The amount of token to be burned
241      */
242     function burnFrom(address _from, uint256 _value) public {
243         require(_value <= allowed[_from][msg.sender]);
244         // Should https://github.com/OpenZeppelin/zeppelin-solidity/issues/707 be accepted,
245         // this function needs to emit an event with the updated approval.
246         allowed[_from][msg.sender] = allowed[_from][msg.sender].sub(_value);
247         _burn(_from, _value);
248     }
249 
250 }
251 
252 contract NUTSToken is StandardBurnableToken {
253 
254     string public constant name = 'NUTSToken';
255     string public constant symbol = 'NUTS';
256     uint8 public constant decimals = 18;
257 
258     uint INITIAL_SUPPLY = 1000000000;
259 
260     constructor() public {
261         totalSupply_ = INITIAL_SUPPLY * 10 ** uint256(decimals);
262         balances[msg.sender] = totalSupply_;
263     }
264 }