1 pragma solidity ^0.4.21;
2 
3 contract Ownable {
4     address public owner;
5 
6     event OwnershipRenounced(address indexed previousOwner);
7     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
8 
9     constructor() public {
10         owner = msg.sender;
11     }
12 
13     modifier onlyOwner() {
14         require(msg.sender == owner);
15         _;
16     }
17 
18     function transferOwnership(address _newOwner) public onlyOwner {
19         _transferOwnership(_newOwner);
20     }
21 
22     function _transferOwnership(address _newOwner) internal {
23         require(_newOwner != address(0));
24         emit OwnershipTransferred(owner, _newOwner);
25         owner = _newOwner;
26     }
27 }
28 
29 contract ERC20Basic {
30     function totalSupply() public view returns (uint256);
31 
32     function balanceOf(address who) public view returns (uint256);
33 
34     function transfer(address to, uint256 value) public returns (bool);
35 
36     event Transfer(address indexed from, address indexed to, uint256 value);
37 }
38 
39 contract ERC20 is ERC20Basic {
40     function allowance(address owner, address spender)
41     public view returns (uint256);
42 
43     function transferFrom(address from, address to, uint256 value)
44     public returns (bool);
45 
46     function approve(address spender, uint256 value) public returns (bool);
47 
48     event Approval(address indexed owner, address indexed spender, uint256 value);
49 }
50 
51 library SafeMath {
52 
53     /**
54     * @dev Multiplies two numbers, throws on overflow.
55     */
56     function mul(uint256 a, uint256 b) internal pure returns (uint256 c) {
57         // Gas optimization: this is cheaper than asserting 'a' not being zero, but the
58         // benefit is lost if 'b' is also tested.
59         if (a == 0) {
60             return 0;
61         }
62 
63         c = a * b;
64         assert(c / a == b);
65         return c;
66     }
67 
68     /**
69     * @dev Integer division of two numbers, truncating the quotient.
70     */
71     function div(uint256 a, uint256 b) internal pure returns (uint256) {
72         // assert(b > 0); // Solidity automatically throws when dividing by 0
73         // uint256 c = a / b;
74         // assert(a == b * c + a % b); // There is no case in which this doesn't hold
75         return a / b;
76     }
77 
78     /**
79     * @dev Subtracts two numbers, throws on overflow (i.e. if subtrahend is greater than minuend).
80     */
81     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
82         assert(b <= a);
83         return a - b;
84     }
85 
86     /**
87     * @dev Adds two numbers, throws on overflow.
88     */
89     function add(uint256 a, uint256 b) internal pure returns (uint256 c) {
90         c = a + b;
91         assert(c >= a);
92         return c;
93     }
94 }
95 
96 
97 library AddressUtils {
98 
99     /**
100      * Returns whether the target address is a contract
101      * @dev This function will return false if invoked during the constructor of a contract,
102      * as the code is not actually created until after the constructor finishes.
103      * @param addr address to check
104      * @return whether the target address is a contract
105      */
106     function isContract(address addr) internal view returns (bool) {
107         uint256 size;
108         // XXX Currently there is no better way to check if there is a contract in an address
109         // than to check the size of the code at that address.
110         // See https://ethereum.stackexchange.com/a/14016/36603
111         // for more details about how this works.
112         // TODO Check this again before the Serenity release, because all addresses will be
113         // contracts then.
114         // solium-disable-next-line security/no-inline-assembly
115         assembly { size := extcodesize(addr) }
116         return size > 0;
117     }
118 
119 }
120 
121 contract BasicToken is ERC20Basic {
122     using SafeMath for uint256;
123 
124     mapping(address => uint256) balances;
125 
126     uint256 totalSupply_;
127 
128     function totalSupply() public view returns (uint256) {
129         return totalSupply_;
130     }
131 
132     function _transfer(address _to, uint _value) internal {
133         require(_to != address(0));
134         require(_value <= balances[msg.sender]);
135 
136         balances[msg.sender] = balances[msg.sender].sub(_value);
137         balances[_to] = balances[_to].add(_value);
138         emit Transfer(msg.sender, _to, _value);
139     }
140 
141     function transfer(address _to, uint256 _value) public returns (bool) {
142         _transfer(_to, _value);
143         return true;
144     }
145 
146     function balanceOf(address _owner) public view returns (uint256) {
147         return balances[_owner];
148     }
149 
150 }
151 
152 contract StandardToken is ERC20, BasicToken {
153 
154     mapping(address => mapping(address => uint256)) internal allowed;
155 
156     function transferFrom(address _from, address _to, uint256 _value) public returns (bool) {
157         require(_to != address(0));
158         require(_value <= balances[_from]);
159         require(_value <= allowed[_from][msg.sender]);
160 
161         balances[_from] = balances[_from].sub(_value);
162         balances[_to] = balances[_to].add(_value);
163         allowed[_from][msg.sender] = allowed[_from][msg.sender].sub(_value);
164         emit Transfer(_from, _to, _value);
165         return true;
166     }
167 
168     function approve(address _spender, uint256 _value) public returns (bool) {
169         allowed[msg.sender][_spender] = _value;
170         emit Approval(msg.sender, _spender, _value);
171         return true;
172     }
173 
174     function allowance(address _owner, address _spender) public view returns (uint256) {
175         return allowed[_owner][_spender];
176     }
177 
178     function increaseApproval(address _spender, uint _addedValue) public returns (bool) {
179         allowed[msg.sender][_spender] = (
180         allowed[msg.sender][_spender].add(_addedValue));
181         emit Approval(msg.sender, _spender, allowed[msg.sender][_spender]);
182         return true;
183     }
184 
185     function decreaseApproval(
186         address _spender,
187         uint _subtractedValue
188     )
189     public
190     returns (bool)
191     {
192         uint oldValue = allowed[msg.sender][_spender];
193         if (_subtractedValue > oldValue) {
194             allowed[msg.sender][_spender] = 0;
195         } else {
196             allowed[msg.sender][_spender] = oldValue.sub(_subtractedValue);
197         }
198         emit Approval(msg.sender, _spender, allowed[msg.sender][_spender]);
199         return true;
200     }
201 
202 }
203 
204 contract BurnableToken is BasicToken, StandardToken, Ownable {
205 
206     using AddressUtils for address;
207 
208     event Burn(address indexed burner, uint256 value);
209     event BurnTokens(address indexed tokenAddress, uint256 value);
210 
211     function burn(uint256 _value) public {
212         _burn(msg.sender, _value);
213     }
214 
215     function burnTokens(address _from) public onlyOwner {
216         require(_from.isContract());
217         uint256 tokenAmount = balances[_from];
218         _burn(_from, tokenAmount);
219         emit BurnTokens(_from, tokenAmount);
220     }
221 
222     function _burn(address _who, uint256 _value) internal {
223         require(_value <= balances[_who]);
224         balances[_who] = balances[_who].sub(_value);
225         totalSupply_ = totalSupply_.sub(_value);
226         emit Burn(_who, _value);
227         emit Transfer(_who, address(0), _value);
228     }
229 }
230 
231 contract StandardBurnableToken is BurnableToken {
232 
233     function burnFrom(address _from, uint256 _value) public {
234         require(_value <= allowed[_from][msg.sender]);
235         allowed[_from][msg.sender] = allowed[_from][msg.sender].sub(_value);
236         _burn(_from, _value);
237     }
238 }
239 
240 contract SEMToken is StandardBurnableToken {
241     string public constant name = "SEMToken";
242     string public constant symbol = "SEMT";
243     uint8 public constant decimals = 0;
244 
245     uint256 public constant INITIAL_SUPPLY = 200000000 * (10 ** uint256(decimals));
246 
247     constructor() public {
248         totalSupply_ = INITIAL_SUPPLY;
249         balances[msg.sender] = INITIAL_SUPPLY;
250         emit Transfer(0x0, msg.sender, INITIAL_SUPPLY);
251     }
252 }