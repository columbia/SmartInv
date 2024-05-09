1 pragma solidity ^0.4.18;
2 
3 
4 /**
5  * @title SafeMath
6  * @dev Math operations with safety checks that throw on error
7  */
8 library SafeMath {
9   function mul(uint256 a, uint256 b) internal pure returns (uint256) {
10     if (a == 0) {
11       return 0;
12     }
13     uint256 c = a * b;
14     assert(c / a == b);
15     return c;
16   }
17 
18   function div(uint256 a, uint256 b) internal pure returns (uint256) {
19     // assert(b > 0); // Solidity automatically throws when dividing by 0
20     uint256 c = a / b;
21     // assert(a == b * c + a % b); // There is no case in which this doesn't hold
22     return c;
23   }
24 
25   function sub(uint256 a, uint256 b) internal pure returns (uint256) {
26     assert(b <= a);
27     return a - b;
28   }
29 
30   function add(uint256 a, uint256 b) internal pure returns (uint256) {
31     uint256 c = a + b;
32     assert(c >= a);
33     return c;
34   }
35 }
36 
37 
38 /**
39  * @title Ownable
40  * @dev The Ownable contract has an owner address, and provides basic authorization control
41  * functions, this simplifies the implementation of "user permissions".
42  */
43 contract Ownable {
44   address public owner;
45 
46 
47   event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
48 
49 
50   /**
51    * @dev The Ownable constructor sets the original `owner` of the contract to the sender
52    * account.
53    */
54   function Ownable() public {
55     owner = msg.sender;
56   }
57 
58   /**
59    * @dev Throws if called by any account other than the owner.
60    */
61   modifier onlyOwner() {
62     require(msg.sender == owner);
63     _;
64   }
65 
66   /**
67    * @dev Allows the current owner to transfer control of the contract to a newOwner.
68    * @param newOwner The address to transfer ownership to.
69    */
70   function transferOwnership(address newOwner) public onlyOwner {
71     require(newOwner != address(0));
72     OwnershipTransferred(owner, newOwner);
73     owner = newOwner;
74   }
75 
76 }
77 contract MultiTokenBasics {
78 
79     function totalSupply(uint256 _tokenId) public view returns (uint256);
80 
81     function balanceOf(uint256 _tokenId, address _owner) public view returns (uint256);
82 
83     function allowance(uint256 _tokenId, address _owner, address _spender) public view returns (uint256);
84 
85     function transfer(uint256 _tokenId, address _to, uint256 _value) public returns (bool);
86 
87     function transferFrom(uint256 _tokenId, address _from, address _to, uint256 _value) public returns (bool);
88 
89     function approve(uint256 _tokenId, address _spender, uint256 _value) public returns (bool);
90 
91 
92     event Transfer(uint256 indexed tokenId, address indexed from, address indexed to, uint256 value);
93     event Approval(uint256 indexed tokenId, address indexed owner, address indexed spender, uint256 value);
94 
95 }
96 
97 contract MultiToken is Ownable, MultiTokenBasics {
98     using SafeMath for uint256;
99 
100     mapping(uint256 => mapping(address => mapping(address => uint256))) private allowed;
101     mapping(uint256 => mapping(address => uint256)) private balance;
102     mapping(uint256 => uint256) private totalSupply_;
103 
104 
105     uint8 public decimals = 18;
106     uint256 public mask = 0xffffffff;
107 
108 
109 
110     /**
111     * @dev Throws if _tokenId not exists
112     * @param _tokenId uint256 is subtoken identifier
113     */
114 
115     modifier existingToken(uint256 _tokenId) {
116         require(totalSupply_[_tokenId] > 0 && (_tokenId & mask == _tokenId));
117         _;
118     }
119 
120     /**
121     * @dev Throws if  _tokenId exists
122     * @param _tokenId uint256 is subtoken identifier
123     */
124 
125     modifier notExistingToken(uint256 _tokenId) {
126         require(totalSupply_[_tokenId] == 0 && (_tokenId & mask == _tokenId));
127         _;
128     }
129 
130 
131 
132 
133 
134     /**
135     * @dev create new subtoken with unique tokenId
136     * @param _tokenId uint256 is subtoken identifier
137     * @param _to The address to transfer to.
138     * @param _value The amount to be transferred.
139     * @return uint256 representing the total amount of tokens
140     */
141 
142     function createNewSubtoken(uint256 _tokenId, address _to, uint256 _value) notExistingToken(_tokenId) onlyOwner() public returns (bool) {
143         require(_value > 0);
144         balance[_tokenId][_to] = _value;
145         totalSupply_[_tokenId] = _value;
146         Transfer(_tokenId, address(0), _to, _value);
147         return true;
148     }
149 
150 
151     /**
152     * @dev Gets the total amount of tokens stored by the contract
153     * @param _tokenId uint256 is subtoken identifier
154     * @return uint256 representing the total amount of tokens
155     */
156 
157     function totalSupply(uint256 _tokenId) existingToken(_tokenId) public view returns (uint256) {
158         return totalSupply_[_tokenId];
159     }
160 
161     /**
162     * @dev Gets the balance of the specified address
163     * @param _tokenId uint256 is subtoken identifier
164     * @param _owner address to query the balance of
165     * @return uint256 representing the amount owned by the passed address
166     */
167 
168     function balanceOf(uint256 _tokenId, address _owner) existingToken(_tokenId) public view returns (uint256) {
169         return balance[_tokenId][_owner];
170     }
171 
172 
173 
174     /**
175     * @dev Function to check the amount of tokens that an owner allowed to a spender.
176     * @param _tokenId uint256 is subtoken identifier
177     * @param _owner address The address which owns the funds.
178     * @param _spender address The address which will spend the funds.
179     * @return A uint256 specifying the amount of tokens still available for the spender.
180     */
181 
182     function allowance(uint256 _tokenId, address _owner, address _spender) existingToken(_tokenId) public view returns (uint256) {
183         return allowed[_tokenId][_owner][_spender];
184     }
185 
186 
187 
188     /**
189     * @dev transfer token for a specified address
190     * @param _tokenId uint256 is subtoken identifier
191     * @param _to The address to transfer to.
192     * @param _value The amount to be transferred.
193     */
194 
195     function transfer(uint256 _tokenId, address _to, uint256 _value) existingToken(_tokenId) public returns (bool) {
196         require(_to != address(0));
197         var _sender = msg.sender;
198         var balances = balance[_tokenId];
199         require(_to != address(0));
200         require(_value <= balances[_sender]);
201 
202         // SafeMath.sub will throw if there is not enough balance.
203         balances[_sender] = balances[_sender].sub(_value);
204         balances[_to] = balances[_to].add(_value);
205         Transfer(_tokenId, _sender, _to, _value);
206         return true;
207     }
208 
209 
210     /**
211     * @dev Transfer tokens from one address to another
212     * @param _tokenId uint256 is subtoken identifier
213     * @param _from address The address which you want to send tokens from
214     * @param _to address The address which you want to transfer to
215     * @param _value uint256 the amount of tokens to be transferred
216     */
217 
218     function transferFrom(uint256 _tokenId, address _from, address _to, uint256 _value) existingToken(_tokenId) public returns (bool) {
219         address _sender = msg.sender;
220         var balances = balance[_tokenId];
221         var tokenAllowed = allowed[_tokenId];
222 
223         require(_to != address(0));
224         require(_value <= balances[_from]);
225         require(_value <= tokenAllowed[_from][_sender]);
226 
227         balances[_from] = balances[_from].sub(_value);
228         balances[_to] = balances[_to].add(_value);
229         tokenAllowed[_from][_sender] = tokenAllowed[_from][_sender].sub(_value);
230         Transfer(_tokenId, _from, _to, _value);
231         return true;
232     }
233 
234 
235 
236     /**
237     * @dev Approve the passed address to spend the specified amount of tokens on behalf of msg.sender.
238     *
239     * Beware that changing an allowance with this method brings the risk that someone may use both the old
240     * and the new allowance by unfortunate transaction ordering. One possible solution to mitigate this
241     * race condition is to first reduce the spender's allowance to 0 and set the desired value afterwards:
242     * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
243     * @param _tokenId uint256 is subtoken identifier
244     * @param _spender The address which will spend the funds.
245     * @param _value The amount of tokens to be spent.
246     */
247 
248 
249 
250     function approve(uint256 _tokenId, address _spender, uint256 _value) public returns (bool) {
251         var _sender = msg.sender;
252         allowed[_tokenId][_sender][_spender] = _value;
253         Approval(_tokenId, _sender, _spender, _value);
254         return true;
255     }
256 
257 
258 }