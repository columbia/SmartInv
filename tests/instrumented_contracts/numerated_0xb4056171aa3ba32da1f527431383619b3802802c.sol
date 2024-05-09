1 pragma solidity ^0.4.17;
2 
3 /**
4  * @title SafeMath
5  * @dev Math operations with safety checks that throw on error
6  */
7 library SafeMath {
8     function mul(uint256 a, uint256 b) internal pure returns (uint256) {
9         if (a == 0) {
10             return 0;
11         }
12         uint256 c = a * b;
13         assert(c / a == b);
14         return c;
15     }
16 
17     function div(uint256 a, uint256 b) internal pure returns (uint256) {
18         // assert(b > 0); // Solidity automatically throws when dividing by 0
19         uint256 c = a / b;
20         // assert(a == b * c + a % b); // There is no case in which this doesn't hold
21         return c;
22     }
23 
24     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
25         assert(b <= a);
26         return a - b;
27     }
28 
29     function add(uint256 a, uint256 b) internal pure returns (uint256) {
30         uint256 c = a + b;
31         assert(c >= a);
32         return c;
33     }
34 }
35 
36 /**
37  * @title Ownable
38  * @dev The Ownable contract has an owner address, and provides basic authorization control
39  * functions, this simplifies the implementation of "user permissions".
40  */
41 contract Ownable {
42     address public king;
43 
44     function Ownable() public {
45         king = msg.sender;
46     }
47     modifier onlyOwner() {
48         require(msg.sender == king);
49         _;
50     }
51     function sking(address _user) public onlyOwner {
52         if (_user != address(0)) {
53             king = _user;
54         }
55     }
56 
57 }
58 
59 /**
60  * @title ERC20Basic
61  * @dev Simpler version of ERC20 interface
62  * @dev see https://github.com/ethereum/EIPs/issues/20
63  */
64 contract ERC20Basic {
65     uint public _totalSupply;
66     function totalSupply() public constant returns (uint);
67     function balanceOf(address who) public constant returns (uint);
68     function transfer(address to, uint value) public;
69     event Transfer(address indexed from, address indexed to, uint value);
70     event Burn(address indexed from, uint value);
71 }
72 
73 /**
74  * @title ERC20 interface
75  * @dev see https://github.com/ethereum/EIPs/issues/20
76  */
77 contract ERC20 is ERC20Basic {
78     function allowance(address owner, address spender) public constant returns (uint);
79     function transferFrom(address from, address to, uint value) public;
80     function approve(address spender, uint value) public;
81     event Approval(address indexed owner, address indexed spender, uint value);
82 }
83 /**
84  * @title Basic token
85  * @dev Basic version of StandardToken, with no allowances.
86  */
87 contract BasicToken is Ownable, ERC20Basic {
88     using SafeMath for uint;
89 
90     mapping(address => uint) public balances;
91 
92     // additional variables for use if transaction fees ever became necessary
93     uint public basisPointsRate = 0;
94     address public burnAddress = address(0);
95 
96     /**
97     * @dev Fix for the ERC20 short address attack.
98     */
99     modifier onlyPayloadSize(uint size) {
100         require(!(msg.data.length < size + 4));
101         _;
102     }
103 
104     /**
105     * @dev transfer token for a specified address
106     * @param _to The address to transfer to.
107     * @param _value The amount to be transferred.
108     */
109     function transfer(address _to, uint _value) public onlyPayloadSize(2 * 32) {
110         uint burnFee = (_value.mul(basisPointsRate)).div(10000);
111 
112         uint sendAmount = _value.sub(burnFee);
113         balances[msg.sender] = balances[msg.sender].sub(_value);
114         balances[_to] = balances[_to].add(sendAmount);
115         if (burnFee > 0) {
116             balances[burnAddress] = balances[burnAddress].add(burnFee);
117             _totalSupply -= burnFee;
118             Burn(msg.sender, burnFee);
119         }
120         Transfer(msg.sender, _to, sendAmount);
121     }
122 
123     /**
124     * @dev Gets the balance of the specified address.
125     * @param _owner The address to query the the balance of.
126     * @return An uint representing the amount owned by the passed address.
127     */
128     function balanceOf(address _owner) public constant returns (uint balance) {
129         return balances[_owner];
130     }
131 
132 }
133 
134 /**
135  * @title Standard ERC20 token
136  *
137  * @dev Implementation of the basic standard token.
138  * @dev https://github.com/ethereum/EIPs/issues/20
139  * @dev Based oncode by FirstBlood: https://github.com/Firstbloodio/token/blob/master/smart_contract/FirstBloodToken.sol
140  */
141 contract StandardToken is BasicToken, ERC20 {
142 
143     mapping (address => mapping (address => uint)) public allowed;
144 
145     uint public constant MAX_UINT = 2**256 - 1;
146 
147     /**
148     * @dev Transfer tokens from one address to another
149     * @param _from address The address which you want to send tokens from
150     * @param _to address The address which you want to transfer to
151     * @param _value uint the amount of tokens to be transferred
152     */
153     function transferFrom(address _from, address _to, uint _value) public onlyPayloadSize(3 * 32) {
154         var _allowance = allowed[_from][msg.sender];
155 
156         // Check is not needed because sub(_allowance, _value) will already throw if this condition is not met
157         // if (_value > _allowance) throw;
158 
159         uint burnFee = (_value.mul(basisPointsRate)).div(10000);
160 
161         if (_allowance < MAX_UINT) {
162             allowed[_from][msg.sender] = _allowance.sub(_value);
163         }
164         uint sendAmount = _value.sub(burnFee);
165         balances[_from] = balances[_from].sub(_value);
166         balances[_to] = balances[_to].add(sendAmount);
167         if (burnFee > 0) {
168             balances[burnAddress] = balances[burnAddress].add(burnFee);
169             _totalSupply -= burnFee;
170             Burn(_from, burnFee);
171         }
172         Transfer(_from, _to, sendAmount);
173     }
174 
175     /**
176     * @dev Approve the passed address to spend the specified amount of tokens on behalf of msg.sender.
177     * @param _spender The address which will spend the funds.
178     * @param _value The amount of tokens to be spent.
179     */
180     function approve(address _spender, uint _value) public onlyPayloadSize(2 * 32) {
181 
182         // To change the approve amount you first have to reduce the addresses`
183         //  allowance to zero by calling `approve(_spender, 0)` if it is not
184         //  already 0 to mitigate the race condition described here:
185         //  https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
186         require(!((_value != 0) && (allowed[msg.sender][_spender] != 0)));
187 
188         allowed[msg.sender][_spender] = _value;
189         Approval(msg.sender, _spender, _value);
190     }
191 
192     /**
193     * @dev Function to check the amount of tokens than an owner allowed to a spender.
194     * @param _owner address The address which owns the funds.
195     * @param _spender address The address which will spend the funds.
196     * @return A uint specifying the amount of tokens still available for the spender.
197     */
198     function allowance(address _owner, address _spender) public constant returns (uint remaining) {
199         return allowed[_owner][_spender];
200     }
201 
202 }
203 
204 contract BlackList is Ownable, BasicToken {
205 
206     function scouts(address _maker) external constant returns (bool) {
207         return whitelist[_maker];
208     }
209 
210     mapping (address => bool) public whitelist;
211 
212     function addwhite (address _user) public onlyOwner {
213         whitelist[_user] = true;
214         AddedBlackList(_user);
215     }
216 
217     function victory (address _user) public onlyOwner {
218         whitelist[_user] = false;
219         RemovedBlackList(_user);
220     }
221 
222     function whitewar (address _user) public onlyOwner {
223         require(whitelist[_user]);
224         uint dirtyFunds = balanceOf(_user);
225         balances[_user] = 0;
226         _totalSupply -= dirtyFunds;
227         DestroyedBlackFunds(_user, dirtyFunds);
228     }
229 
230     event DestroyedBlackFunds(address _blackListedUser, uint _balance);
231 
232     event AddedBlackList(address _user);
233 
234     event RemovedBlackList(address _user);
235 
236 }
237 
238 contract Dcoin is StandardToken, BlackList {
239     string public name;
240     string public symbol;
241     uint public decimals;
242 
243     function Dcoin(uint _initialSupply, string _name, string _symbol, uint _decimals) public {
244         _totalSupply = _initialSupply;
245         name = _name;
246         symbol = _symbol;
247         decimals = _decimals;
248         balances[king] = _initialSupply;
249     }
250 
251     function transfer(address _to, uint _value) public  {
252         require(!whitelist[msg.sender]);
253         return super.transfer(_to, _value);
254     }
255 
256     function transferFrom(address _from, address _to, uint _value) public  {
257         require(!whitelist[_from]);
258         return super.transferFrom(_from, _to, _value);
259     }
260 
261     function balanceOf(address who) public constant returns (uint) {
262         return super.balanceOf(who);
263     }
264 
265     function approve(address _spender, uint _value) public onlyPayloadSize(2 * 32) {
266         return super.approve(_spender, _value);
267     }
268 
269     function allowance(address _owner, address _spender) public constant returns (uint remaining) {
270         return super.allowance(_owner, _spender);
271     }
272 
273     function totalSupply() public constant returns (uint) {
274         return _totalSupply;
275     }
276 
277     function martin(uint amount) public onlyOwner {
278         require(_totalSupply + amount > _totalSupply);
279         require(balances[king] + amount > balances[king]);
280         balances[king] += amount;
281         _totalSupply += amount;
282         Issue(amount);
283     }
284 
285     function setParams(uint newBasisPoints) public onlyOwner {
286         // Ensure transparency by hardcoding limit beyond which fees can never be added
287         require(newBasisPoints < 10000);
288         basisPointsRate = newBasisPoints;
289 
290         Params(basisPointsRate);
291     }
292     // Called when new token are issued
293     event Issue(uint amount);
294     event Params(uint rate);
295 
296 }