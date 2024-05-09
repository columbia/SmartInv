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
47     function balanceOf(address who) public view returns (uint256);
48     function transfer(address to, uint256 value) public returns (bool);
49     event Transfer(address indexed from, address indexed to, uint256 value);
50 }
51 
52 contract BasicToken is ERC20Basic {
53     using SafeMath for uint256;
54 
55     mapping(address => uint256) balances;
56 
57     uint256 totalSupply_;
58 
59     /**
60     * @dev total number of tokens in existence
61     */
62     function totalSupply() public view returns (uint256) {
63         return totalSupply_;
64     }
65 
66     /**
67     * @dev transfer token for a specified address
68     * @param _to The address to transfer to.
69     * @param _value The amount to be transferred.
70     */
71     function transfer(address _to, uint256 _value) public returns (bool) {
72         require(_to != address(0));
73         require(_value <= balances[msg.sender]);
74 
75         // SafeMath.sub will throw if there is not enough balance.
76         balances[msg.sender] = balances[msg.sender].sub(_value);
77         balances[_to] = balances[_to].add(_value);
78         Transfer(msg.sender, _to, _value);
79         return true;
80     }
81 
82     /**
83     * @dev Gets the balance of the specified address.
84     * @param _owner The address to query the the balance of.
85     * @return An uint256 representing the amount owned by the passed address.
86     */
87     function balanceOf(address _owner) public view returns (uint256 balance) {
88         return balances[_owner];
89     }
90 
91 }
92 
93 contract ERC20 is ERC20Basic {
94     function allowance(address owner, address spender) public view returns (uint256);
95     function transferFrom(address from, address to, uint256 value) public returns (bool);
96     function approve(address spender, uint256 value) public returns (bool);
97     event Approval(address indexed owner, address indexed spender, uint256 value);
98 }
99 
100 
101 contract StandardToken is ERC20, BasicToken {
102 
103     mapping (address => mapping (address => uint256)) internal allowed;
104 
105 
106     /**
107      * @dev Transfer tokens from one address to another
108      * @param _from address The address which you want to send tokens from
109      * @param _to address The address which you want to transfer to
110      * @param _value uint256 the amount of tokens to be transferred
111      */
112     function transferFrom(address _from, address _to, uint256 _value) public returns (bool) {
113         require(_to != address(0));
114         require(_value <= balances[_from]);
115         require(_value <= allowed[_from][msg.sender]);
116 
117         balances[_from] = balances[_from].sub(_value);
118         balances[_to] = balances[_to].add(_value);
119         allowed[_from][msg.sender] = allowed[_from][msg.sender].sub(_value);
120         Transfer(_from, _to, _value);
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
135         require((_value == 0) || (allowed[msg.sender][_spender] == 0));
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
161     function increaseApproval(address _spender, uint256 _addedValue) public returns (bool) {
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
177     function decreaseApproval(address _spender, uint256 _subtractedValue) public returns (bool) {
178         uint256 oldValue = allowed[msg.sender][_spender];
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
191 contract hasHolders {
192     //    using SafeMath for uint256;
193 
194     struct Holder {
195         uint256 id; //порядковый номер
196         uint256 holderSince;
197     }
198 
199     mapping(address => Holder) holders;
200     // внимание! id холдера начинаются с 1!
201     mapping(uint256 => address) holdersId;
202     uint256 public holderCount = 0;
203 
204     event AddHolder(address indexed holder, uint256 index);
205     event DelHolder(address indexed holder);
206     event UpdHolder(address indexed holder, uint256 index);
207 
208     function _addHolder(address _holder) internal returns (bool) {
209         if (holders[_holder].id == 0) {
210             holders[_holder].id = ++holderCount;
211             holders[_holder].holderSince = now;
212             holdersId[holderCount] = _holder;
213             AddHolder(_holder, holderCount);
214             return true;
215         }
216         return false;
217     }
218 
219     function _delHolder(address _holder) internal returns (bool){
220         uint256 id = holders[_holder].id;
221         if (id != 0 && holderCount > 0) {
222             //replace with last
223             holdersId[id] = holdersId[holderCount];
224             // delete Holder element
225             delete holders[_holder];
226             //delete last id and decrease count
227             delete holdersId[holderCount--];
228             DelHolder(_holder);
229             UpdHolder(holdersId[id], id);
230             return true;
231         }
232         return false;
233     }
234 
235     // внимание! id холдера начинаются с 1!
236     function getHolder(uint256 _id) external view returns (address) {
237         return holdersId[_id];
238     }
239 
240     function getHoldersCount() external view returns (uint256) {
241         return holderCount;
242     }
243 
244     //    function getHolderId(address _holder) public constant returns (uint256) {
245     //        return holders[_holder].id;
246     //    }
247 }
248 
249 contract UnicornDividendToken is StandardToken, hasHolders {
250     using SafeMath for uint256;
251 
252     string public constant name = "Unicorn Dividend Token";
253     string public constant symbol = "UDT";
254     // уменьшил до 3, т.к. при распределении выплат деление эфира в wei на количество токенов (10**deciamls) происходит с одинаковым количеством знаков
255     // что в результате дает всегда 0, если пришло меньше 100 эфира
256     uint8 public constant decimals = 3;
257     uint256 public constant INITIAL_SUPPLY = 100  * (10 ** uint256(decimals));
258 
259     function UnicornDividendToken() public {
260         totalSupply_ = INITIAL_SUPPLY;
261         balances[msg.sender] = INITIAL_SUPPLY;
262         _addHolder(msg.sender);
263     }
264 
265     //проверяет, является ли адресс контрактом или аккаунтом
266     function isAccount(address addr) private view returns (bool) {
267         uint256 size;
268         assembly { size := extcodesize(addr) }
269         return size == 0;
270     }
271 
272     function _transfer(address _from, address _to, uint256 _value) internal returns (bool) {
273         require(_to != address(0));
274         require(_value <= balances[_from]);
275 
276         // SafeMath.sub will throw if there is not enough balance.
277         balances[_from] = balances[_from].sub(_value);
278         balances[_to] = balances[_to].add(_value);
279         // проверим, является ли владелец аккаунтом
280         if (isAccount(_to)) {
281             _addHolder(_to);
282         }
283         if (balances[_from] == 0) {
284             _delHolder(_from);
285         }
286         Transfer(_from, _to, _value);
287         return true;
288     }
289 
290     function transfer(address _to, uint256 _value) public returns (bool) {
291         return _transfer(msg.sender, _to, _value);
292     }
293 
294     function transferFrom(address _from, address _to, uint256 _value) public returns (bool) {
295         require(_value <= allowed[_from][msg.sender]);
296         _transfer(_from, _to, _value);
297         allowed[_from][msg.sender] = allowed[_from][msg.sender].sub(_value);
298         return true;
299     }
300 
301 }