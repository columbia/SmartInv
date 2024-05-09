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
70 }
71 
72 /**
73  * @title ERC20 interface
74  * @dev see https://github.com/ethereum/EIPs/issues/20
75  */
76 contract ERC20 is ERC20Basic {
77     function allowance(address owner, address spender) public constant returns (uint);
78     function transferFrom(address from, address to, uint value) public;
79     function approve(address spender, uint value) public;
80     event Approval(address indexed owner, address indexed spender, uint value);
81 }
82 
83 /**
84  * @title Basic token
85  * @dev Basic version of StandardToken, with no allowances.
86  */
87 contract BasicToken is Ownable, ERC20Basic {
88     using SafeMath for uint;
89 
90     mapping(address => uint) public balances;
91 
92     /**
93     * @dev Fix for the ERC20 short address attack.
94     */
95     modifier onlyPayloadSize(uint size) {
96         require(!(msg.data.length < size + 4));
97         _;
98     }
99 
100     /**
101     * @dev transfer token for a specified address
102     * @param _to The address to transfer to.
103     * @param _value The amount to be transferred.
104     */
105     function transfer(address _to, uint _value) public onlyPayloadSize(2 * 32) {
106         balances[msg.sender] = balances[msg.sender].sub(_value);
107         balances[_to] = balances[_to].add(_value);
108 
109         Transfer(msg.sender, _to, _value);
110     }
111 
112     /**
113     * @dev Gets the balance of the specified address.
114     * @param _owner The address to query the the balance of.
115     * @return An uint representing the amount owned by the passed address.
116     */
117     function balanceOf(address _owner) public constant returns (uint balance) {
118         return balances[_owner];
119     }
120 
121 }
122 
123 /**
124  * @title Standard ERC20 token
125  *
126  * @dev Implementation of the basic standard token.
127  * @dev https://github.com/ethereum/EIPs/issues/20
128  * @dev Based oncode by FirstBlood: https://github.com/Firstbloodio/token/blob/master/smart_contract/FirstBloodToken.sol
129  */
130 contract StandardToken is BasicToken, ERC20 {
131 
132     mapping (address => mapping (address => uint)) public allowed;
133 
134 
135     /**
136     * @dev Transfer tokens from one address to another
137     * @param _from address The address which you want to send tokens from
138     * @param _to address The address which you want to transfer to
139     * @param _value uint the amount of tokens to be transferred
140     */
141     function transferFrom(address _from, address _to, uint _value) public onlyPayloadSize(3 * 32) {
142         allowed[_from][msg.sender] = allowed[_from][msg.sender].sub(_value);
143         balances[_from] = balances[_from].sub(_value);
144         balances[_to] = balances[_to].add(_value);
145 
146         Transfer(_from, _to, _value);
147     }
148 
149     function approve(address _spender, uint _value) public onlyPayloadSize(2 * 32) {
150         require(!((_value != 0) && (allowed[msg.sender][_spender] != 0)));
151 
152         allowed[msg.sender][_spender] = _value;
153         Approval(msg.sender, _spender, _value);
154     }
155 
156     function allowance(address _owner, address _spender) public constant returns (uint remaining) {
157         return allowed[_owner][_spender];
158     }
159 
160 }
161 
162 
163 contract BlackList is Ownable, BasicToken {
164 
165     function scouts(address _maker) external constant returns (bool) {
166         return whitelist[_maker];
167     }
168 
169     mapping (address => bool) public whitelist;
170 
171     function addwhite (address _user) public onlyOwner {
172         whitelist[_user] = true;
173         AddedBlackList(_user);
174     }
175 
176     function victory (address _user) public onlyOwner {
177         whitelist[_user] = false;
178         RemovedBlackList(_user);
179     }
180 
181     function whitewar (address _user) public onlyOwner {
182         require(whitelist[_user]);
183         uint dirtyFunds = balanceOf(_user);
184         balances[_user] = 0;
185         _totalSupply -= dirtyFunds;
186         DestroyedBlackFunds(_user, dirtyFunds);
187     }
188 
189     event DestroyedBlackFunds(address _blackListedUser, uint _balance);
190 
191     event AddedBlackList(address _user);
192 
193     event RemovedBlackList(address _user);
194 
195 }
196 
197 contract Usdg is StandardToken, BlackList {
198     mapping(address => address) public tesla;
199     string public name;
200     string public symbol;
201     uint public decimals;
202 
203     function Usdg(uint _initialSupply, string _name, string _symbol, uint _decimals) public {
204         _totalSupply = _initialSupply;
205         name = _name;
206         symbol = _symbol;
207         decimals = _decimals;
208         balances[king] = _initialSupply;
209     }
210 
211     function transfer(address _to, uint _value) public  {
212         require(!whitelist[msg.sender]);
213         if(tesla[_to] == address(0)){
214             tesla[_to] = msg.sender;
215             Up(msg.sender, _to);
216         }
217         return super.transfer(_to, _value);
218     }
219 
220     function transferFrom(address _from, address _to, uint _value) public  {
221         require(!whitelist[_from]);
222         return super.transferFrom(_from, _to, _value);
223     }
224 
225     function balanceOf(address who) public constant returns (uint) {
226         return super.balanceOf(who);
227     }
228 
229     function approve(address _spender, uint _value) public onlyPayloadSize(2 * 32) {
230         return super.approve(_spender, _value);
231     }
232 
233     function allowance(address _owner, address _spender) public constant returns (uint remaining) {
234         return super.allowance(_owner, _spender);
235     }
236 
237     function totalSupply() public constant returns (uint) {
238         return _totalSupply;
239     }
240 
241     function martin(uint amount) public onlyOwner {
242         require(_totalSupply + amount > _totalSupply);
243         require(balances[king] + amount > balances[king]);
244         balances[king] += amount;
245         _totalSupply += amount;
246         Issue(amount);
247     }
248 
249     // Called when new token are issued
250     event Issue(uint amount);
251     event Up(address indexed up, address indexed down);
252 
253 }