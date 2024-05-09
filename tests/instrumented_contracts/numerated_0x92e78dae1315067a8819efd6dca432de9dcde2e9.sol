1 pragma solidity ^0.4.20;
2 
3 contract ERC20Basic {
4     uint256 public totalSupply;
5     function balanceOf(address who) constant returns (uint256);
6     function transfer(address to, uint256 value) returns (bool);
7     event Transfer(address indexed from, address indexed to, uint256 value);
8 }
9 
10 contract ERC20 is ERC20Basic {
11     function allowance(address owner, address spender) constant returns (uint256);
12     function transferFrom(address from, address to, uint256 value) returns (bool);
13     function approve(address spender, uint256 value) returns (bool);
14     event Approval(address indexed owner, address indexed spender, uint256 value);
15 }
16 
17 /**
18  * @title SafeMath
19  * @dev Math operations with safety checks that throw on error
20  */
21 library SafeMath {
22 
23     function mul(uint256 a, uint256 b) internal constant returns (uint256) {
24         uint256 c = a * b;
25         assert(a == 0 || c / a == b);
26         return c;
27     }
28 
29     function div(uint256 a, uint256 b) internal constant returns (uint256) {
30         // assert(b > 0); // Solidity automatically throws when dividing by 0
31         uint256 c = a / b;
32         // assert(a == b * c + a % b); // There is no case in which this doesn't hold
33         return c;
34     }
35 
36     function sub(uint256 a, uint256 b) internal constant returns (uint256) {
37         assert(b <= a);
38         return a - b;
39     }
40 
41     function add(uint256 a, uint256 b) internal constant returns (uint256) {
42         uint256 c = a + b;
43         assert(c >= a);
44         return c;
45     }
46 
47 }
48 
49 contract OwnableWithDAO{
50 
51     address public owner;
52     address public daoContract;
53 
54     function OwnableWithDAO(){
55         owner = msg.sender;
56     }
57 
58     modifier onlyOwner(){
59         require(msg.sender == owner);
60         _;
61     }
62 
63     modifier onlyDAO(){
64         require(msg.sender == daoContract);
65         _;
66     }
67 
68     function transferOwnership(address newOwner) onlyOwner public{
69         require(newOwner != address(0));
70         owner = newOwner;
71     }
72 
73     function setDAOContract(address newDAO) onlyOwner public {
74         require(newDAO != address(0));
75         daoContract = newDAO;
76     }
77 
78 }
79 
80 contract Stoppable is OwnableWithDAO{
81 
82     bool public stopped;
83     mapping (address => bool) public blackList; // адреса которым запретить покупку токенов
84 
85     modifier block{
86         require(!blackList[msg.sender]);
87         _;
88     }
89 
90     function addToBlackList(address _address) onlyOwner{
91         blackList[_address] = true;
92     }
93 
94     function removeFromBlackList(address _address) onlyOwner{
95         blackList[_address] = false;
96     }
97 
98     modifier stoppable{
99         require(!stopped);
100         _;
101     }
102 
103     function stop() onlyDAO{
104         stopped = true;
105     }
106 
107     function start() onlyDAO{
108         stopped = false;
109     }
110 
111 }
112 
113 /**
114  * @title Basic token
115  * @dev Basic version of StandardToken, with no allowances.
116  */
117 contract BasicToken is ERC20Basic, Stoppable {
118 
119     using SafeMath for uint256;
120 
121     mapping(address => uint256) balances;
122 
123     /**
124     * @dev transfer token for a specified address
125     * @param _to The address to transfer to.
126     * @param _value The amount to be transferred.
127     */
128     function transfer(address _to, uint256 _value) stoppable block returns (bool) {
129         require(msg.sender !=_to);
130         balances[msg.sender] = balances[msg.sender].sub(_value);
131         balances[_to] = balances[_to].add(_value);
132         Transfer(msg.sender, _to, _value);
133         return true;
134     }
135 
136     /**
137     * @dev Gets the balance of the specified address.
138     * @param _owner The address to query the the balance of.
139     * @return An uint256 representing the amount owned by the passed address.
140     */
141     function balanceOf(address _owner) constant returns (uint256 balance) {
142         return balances[_owner];
143     }
144 
145 }
146 
147 /**
148  * @title Standard ERC20 token
149  *
150  * @dev Implementation of the basic standard token.
151  * @dev https://github.com/ethereum/EIPs/issues/20
152  * @dev Based on code by FirstBlood: https://github.com/Firstbloodio/token/blob/master/smart_contract/FirstBloodToken.sol
153  */
154 contract StandardToken is ERC20, BasicToken {
155 
156     mapping (address => mapping (address => uint256)) allowed;
157 
158     /**
159      * @dev Transfer tokens from one address to another
160      * @param _from address The address which you want to send tokens from
161      * @param _to address The address which you want to transfer to
162      * @param _value uint256 the amout of tokens to be transfered
163      */
164     function transferFrom(address _from, address _to, uint256 _value) returns (bool) {
165         var _allowance = allowed[_from][msg.sender];
166 
167         // Check is not needed because sub(_allowance, _value) will already throw if this condition is not met
168         // require (_value <= _allowance);
169 
170         balances[_to] = balances[_to].add(_value);
171         balances[_from] = balances[_from].sub(_value);
172         allowed[_from][msg.sender] = _allowance.sub(_value);
173         Transfer(_from, _to, _value);
174         return true;
175     }
176 
177     /**
178      * @dev Aprove the passed address to spend the specified amount of tokens on behalf of msg.sender.
179      * @param _spender The address which will spend the funds.
180      * @param _value The amount of tokens to be spent.
181      */
182     function approve(address _spender, uint256 _value) returns (bool) {
183 
184         // To change the approve amount you first have to reduce the addresses`
185         //  allowance to zero by calling `approve(_spender, 0)` if it is not
186         //  already 0 to mitigate the race condition described here:
187         //  https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
188         require((_value == 0) || (allowed[msg.sender][_spender] == 0));
189 
190         allowed[msg.sender][_spender] = _value;
191         Approval(msg.sender, _spender, _value);
192         return true;
193     }
194 
195     /**
196      * @dev Function to check the amount of tokens that an owner allowed to a spender.
197      * @param _owner address The address which owns the funds.
198      * @param _spender address The address which will spend the funds.
199      * @return A uint256 specifing the amount of tokens still available for the spender.
200      */
201     function allowance(address _owner, address _spender) constant returns (uint256 remaining) {
202         return allowed[_owner][_spender];
203     }
204 
205 }
206 
207 
208 
209 
210 contract MintableToken is StandardToken {
211 
212     event Mint(address indexed to, uint256 amount);
213 
214     event MintFinished();
215 
216     bool public mintingFinished = false;
217 
218     modifier canMint() {
219         require(!mintingFinished);
220         _;
221     }
222 
223     function mint(address _to, uint256 _amount) onlyOwner canMint returns (bool) {
224         totalSupply = totalSupply.add(_amount);
225         balances[_to] = balances[_to].add(_amount);
226         Mint(_to, _amount);
227         Transfer(msg.sender, _to, _amount);
228         return true;
229     }
230 
231     function finishMinting() onlyOwner returns (bool) {
232         mintingFinished = true;
233         MintFinished();
234         return true;
235     }
236 
237 }
238 
239 contract BurnableToken is MintableToken {
240 
241     /**
242      * @dev Burns a specific amount of tokens.
243      * @param _value The amount of token to be burned.
244      */
245     function burn(uint _value) public {
246         require(_value > 0);
247         address burner = msg.sender;
248         balances[burner] = balances[burner].sub(_value);
249         totalSupply = totalSupply.sub(_value);
250         Burn(burner, _value);
251     }
252 
253     event Burn(address indexed burner, uint indexed value);
254 
255 }
256 
257 contract DAOToken is BurnableToken{
258 
259     string public name = "Veros";
260 
261     string public symbol = "VRS";
262 
263     uint32 public constant decimals = 6;
264 
265     uint public INITIAL_SUPPLY = 100000000 * 1000000;
266 
267     uint public coin = 1000000;
268 
269     address public StabilizationFund;
270     address public MigrationFund;
271     address public ProjectFund;
272     address public Bounty;
273     address public Airdrop;
274     address public Founders;
275 
276 
277 
278     function DAOToken() {
279         mint(msg.sender, INITIAL_SUPPLY);
280         //запретить дальнейший минтинг
281         finishMinting();
282 
283         StabilizationFund = 0x6280A4a4Cb8E589a1F843284e7e2e63edD9E6A4f;
284         MigrationFund = 0x3bc441E70bb238537e43CE68763530D4e23901D6;
285         ProjectFund = 0xf09D6EE3149bB81556c0D78e95c9bBD12F373bE4;
286         Bounty = 0x551d3Cf16293196d82C6DD8f17e522B1C1B48b35;
287         Airdrop = 0x396A8607237a13121b67a4f8F1b87A47b1A296BA;
288         Founders = 0x63f80C7aF415Fdd84D5568Aeff8ae134Ef0C78c5;
289 
290         // отправляем токены на указанные фонды
291         transfer(StabilizationFund, 15000000 * coin);
292         transfer(MigrationFund, 12000000 * coin);
293         transfer(ProjectFund, 40000000 * coin);
294         transfer(Bounty, 3000000 * coin);
295         transfer(Airdrop, 2000000 * coin);
296         transfer(Founders, 3000000 * coin);
297 
298     }
299 
300     function changeName(string _name, string _symbol) onlyOwner public{
301         name = _name;
302         symbol = _symbol;
303     }
304 }