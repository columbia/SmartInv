1 /**
2  * Source Code first verified at https://etherscan.io on Monday, April 8, 2019
3  (UTC) */
4 
5 pragma solidity ^0.4.23;
6 
7 
8 /**
9  * @title SafeMath
10  * @dev Math operations with safety checks that throw on error
11  */
12 library SafeMath {
13 
14     /**
15     * @dev Multiplies two numbers, throws on overflow.
16     */
17     function mul(uint256 a, uint256 b) internal pure returns (uint256 c) {
18         // Gas optimization: this is cheaper than asserting 'a' not being zero, but the
19         // benefit is lost if 'b' is also tested.
20         // See: https://github.com/OpenZeppelin/openzeppelin-solidity/pull/522
21         if (a == 0) {
22             return 0;
23         }
24 
25         c = a * b;
26         assert(c / a == b);
27         return c;
28     }
29 
30     /**
31     * @dev Integer division of two numbers, truncating the quotient.
32     */
33     function div(uint256 a, uint256 b) internal pure returns (uint256) {
34         // assert(b > 0); // Solidity automatically throws when dividing by 0
35         // uint256 c = a / b;
36         // assert(a == b * c + a % b); // There is no case in which this doesn't hold
37         return a / b;
38     }
39 
40     /**
41     * @dev Subtracts two numbers, throws on overflow (i.e. if subtrahend is greater than minuend).
42     */
43     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
44         assert(b <= a);
45         return a - b;
46     }
47 
48     /**
49     * @dev Adds two numbers, throws on overflow.
50     */
51     function add(uint256 a, uint256 b) internal pure returns (uint256 c) {
52         c = a + b;
53         assert(c >= a);
54         return c;
55     }
56 }
57 
58 /**
59  * @title ERC20Basic
60  * @dev Simpler version of ERC20 interface
61  * See https://github.com/ethereum/EIPs/issues/179
62  */
63 contract ERC20Basic {
64     function totalSupply() public view returns (uint256);
65     function balanceOf(address who) public view returns (uint256);
66     function transfer(address to, uint256 value) public returns (bool);
67     event Transfer(address indexed from, address indexed to, uint256 value);
68 }
69 
70 /**
71  * @title Basic token
72  * @dev Basic version of StandardToken, with no allowances.
73  */
74 contract BasicToken is ERC20Basic {
75     using SafeMath for uint256;
76 
77     mapping(address => uint256) balances;
78 
79     uint256 totalSupply_;
80 
81     /**
82     * @dev Total number of tokens in existence
83     */
84     function totalSupply() public view returns (uint256) {
85         return totalSupply_;
86     }
87 
88     /**
89     * @dev Transfer token for a specified address
90     * @param _to The address to transfer to.
91     * @param _value The amount to be transferred.
92     */
93     function transfer(address _to, uint256 _value) public returns (bool) {
94         require(_to != address(0), "Address must not be zero.");
95         require(_value <= balances[msg.sender], "There is no enough balance.");
96 
97         balances[msg.sender] = balances[msg.sender].sub(_value);
98         balances[_to] = balances[_to].add(_value);
99         emit Transfer(msg.sender, _to, _value);
100         return true;
101     }
102 
103     /**
104     * @dev Gets the balance of the specified address.
105     * @param _owner The address to query the the balance of.
106     * @return An uint256 representing the amount owned by the passed address.
107     */
108     function balanceOf(address _owner) public view returns (uint256) {
109         return balances[_owner];
110     }
111 
112 }
113 
114 /**
115  * @title ERC20 interface
116  * @dev see https://github.com/ethereum/EIPs/issues/20
117  */
118 contract ERC20 is ERC20Basic {
119     function allowance(address owner, address spender)
120         public view returns (uint256);
121 
122     function transferFrom(address from, address to, uint256 value)
123         public returns (bool);
124 
125     function approve(address spender, uint256 value) public returns (bool);
126     event Approval(
127         address indexed owner,
128         address indexed spender,
129         uint256 value
130     );
131 }
132 
133 /**
134  * @title Standard ERC20 token
135  *
136  * @dev Implementation of the basic standard token.
137  * https://github.com/ethereum/EIPs/issues/20
138  * Based on code by FirstBlood: https://github.com/Firstbloodio/token/blob/master/smart_contract/FirstBloodToken.sol
139  */
140 contract StandardToken is ERC20, BasicToken {
141 
142     mapping (address => mapping (address => uint256)) internal allowed;
143 
144 
145     /**
146     * @dev Transfer tokens from one address to another
147     * @param _from address The address which you want to send tokens from
148     * @param _to address The address which you want to transfer to
149     * @param _value uint256 the amount of tokens to be transferred
150     */
151     function transferFrom(
152         address _from,
153         address _to,
154         uint256 _value
155     )
156         public
157         returns (bool)
158     {
159         require(_to != address(0), "Address must not be zero.");
160         require(_value <= balances[_from], "There is no enough balance.");
161         require(_value <= allowed[_from][msg.sender], "There is no enough allowed balance.");
162 
163         balances[_from] = balances[_from].sub(_value);
164         balances[_to] = balances[_to].add(_value);
165         allowed[_from][msg.sender] = allowed[_from][msg.sender].sub(_value);
166         emit Transfer(_from, _to, _value);
167         return true;
168     }
169 
170     /**
171     * @dev Approve the passed address to spend the specified amount of tokens on behalf of msg.sender.
172     * Beware that changing an allowance with this method brings the risk that someone may use both the old
173     * and the new allowance by unfortunate transaction ordering. One possible solution to mitigate this
174     * race condition is to first reduce the spender's allowance to 0 and set the desired value afterwards:
175     * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
176     * @param _spender The address which will spend the funds.
177     * @param _value The amount of tokens to be spent.
178     */
179     function approve(address _spender, uint256 _value) public returns (bool) {
180         allowed[msg.sender][_spender] = _value;
181         emit Approval(msg.sender, _spender, _value);
182         return true;
183     }
184 
185     /**
186     * @dev Function to check the amount of tokens that an owner allowed to a spender.
187     * @param _owner address The address which owns the funds.
188     * @param _spender address The address which will spend the funds.
189     * @return A uint256 specifying the amount of tokens still available for the spender.
190     */
191     function allowance(
192         address _owner,
193         address _spender
194     )
195         public
196         view
197         returns (uint256)
198     {
199         return allowed[_owner][_spender];
200     }
201 
202     /**
203     * @dev Increase the amount of tokens that an owner allowed to a spender.
204     * approve should be called when allowed[_spender] == 0. To increment
205     * allowed value is better to use this function to avoid 2 calls (and wait until
206     * the first transaction is mined)
207     * From MonolithDAO Token.sol
208     * @param _spender The address which will spend the funds.
209     * @param _addedValue The amount of tokens to increase the allowance by.
210     */
211     function increaseApproval(
212         address _spender,
213         uint256 _addedValue
214     )
215         public
216         returns (bool)
217     {
218         allowed[msg.sender][_spender] = (
219         allowed[msg.sender][_spender].add(_addedValue));
220         emit Approval(msg.sender, _spender, allowed[msg.sender][_spender]);
221         return true;
222     }
223 
224     /**
225     * @dev Decrease the amount of tokens that an owner allowed to a spender.
226     * approve should be called when allowed[_spender] == 0. To decrement
227     * allowed value is better to use this function to avoid 2 calls (and wait until
228     * the first transaction is mined)
229     * From MonolithDAO Token.sol
230     * @param _spender The address which will spend the funds.
231     * @param _subtractedValue The amount of tokens to decrease the allowance by.
232     */
233     function decreaseApproval(
234         address _spender,
235         uint256 _subtractedValue
236     )
237         public
238         returns (bool)
239     {
240         uint256 oldValue = allowed[msg.sender][_spender];
241         if (_subtractedValue > oldValue) {
242             allowed[msg.sender][_spender] = 0;
243         } else {
244             allowed[msg.sender][_spender] = oldValue.sub(_subtractedValue);
245         }
246         emit Approval(msg.sender, _spender, allowed[msg.sender][_spender]);
247         return true;
248     }
249 
250 }
251 
252 contract GNE is StandardToken {
253     string public name = "Green New Energy";
254     string public symbol = "GNE";
255     uint8 public decimals = 18;
256     uint256 public INITIAL_SUPPLY = 1000000000 * 10 ** uint256(decimals);
257 
258     constructor() public {
259         totalSupply_ = INITIAL_SUPPLY;
260         balances[msg.sender] = totalSupply_;
261         emit Transfer(0x0, msg.sender, INITIAL_SUPPLY);
262     }
263 }