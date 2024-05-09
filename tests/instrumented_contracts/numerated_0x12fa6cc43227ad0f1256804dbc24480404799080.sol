1 // ----------------------------------------------------------------------------
2 // ERC Token Standard #20 Interface
3 // ODIN token contract 
4 // ----------------------------------------------------------------------------
5 pragma solidity ^0.4.21;
6 
7 library SafeMath {
8   function mul(uint256 a, uint256 b) internal pure returns (uint256) {
9     if (a == 0) {
10       return 0;
11     }
12     uint256 c = a * b;
13     assert(c / a == b);
14     return c;
15   }
16 
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
37 contract ERC20Interface {
38 //    function totalSupply() public constant returns (uint);
39     function balanceOf(address tokenOwner) public constant returns (uint balance);
40     function allowance(address tokenOwner, address spender) public constant returns (uint remaining);
41     function transfer(address to, uint tokens) public returns (bool success);
42     function approve(address spender, uint tokens) public returns (bool success);
43     function transferFrom(address from, address to, uint tokens) public returns (bool success);
44 
45     event Transfer(address indexed from, address indexed to, uint tokens);
46     event Approval(address indexed tokenOwner, address indexed spender, uint tokens);
47     event Burn(uint tokens);
48 
49     // mitigates the ERC20 short address attack
50     modifier onlyPayloadSize(uint size) {
51         assert(msg.data.length >= size + 4);
52         _;
53     }
54     
55 }
56 
57 contract Owned {
58     address public owner;
59 
60     modifier onlyOwner {
61         require(msg.sender == owner);
62         _;
63     }
64 
65 }
66 
67 // ----------------------------------------------------------------------------
68 // ERC20 Token, with the addition of symbol, name and decimals and assisted
69 // token transfers
70 // ----------------------------------------------------------------------------
71 contract OdinToken is ERC20Interface, Owned {
72 
73   using SafeMath for uint256;
74 
75     string public symbol;
76     string public name;
77     uint8 public decimals;
78 //    uint private totalSupply;
79     bool private _whitelistAll;
80 
81     struct balanceData {  
82        bool locked;
83        uint balance;
84        uint airDropQty;
85     }
86 
87     mapping(address => balanceData) balances;
88     mapping(address => mapping(address => uint)) allowed;
89 
90 
91   /**
92   * @dev Constructor for Odin creation
93   * @dev Initially assigns the totalSupply to the contract creator
94   */
95     function OdinToken() public {
96         
97         // owner of this contract
98         owner = msg.sender;
99         symbol = "ODIN";
100         name = "ODIN Token";
101         decimals = 18;
102         _whitelistAll=false;
103         totalSupply = 100000000000000000000000;
104         balances[owner].balance = totalSupply;
105 
106         emit Transfer(address(0), msg.sender, totalSupply);
107     }
108 
109     // function totalSupply() constant public returns (uint256 totalSupply) {
110     //     return totalSupply;
111     // }
112     uint256 public totalSupply;
113 
114 
115     // ------------------------------------------------------------------------
116     // whitelist an address
117     // ------------------------------------------------------------------------
118     function whitelistAddress(address tokenOwner) onlyOwner public returns (bool)    {
119 		balances[tokenOwner].airDropQty = 0;
120 		return true;
121     }
122 
123 
124     /**
125   * @dev Whitelist all addresses early
126   * @return An bool showing if the function succeeded.
127   */
128     function whitelistAllAddresses() onlyOwner public returns (bool) {
129         _whitelistAll = true;
130         return true;
131     }
132 
133 
134     /**
135   * @dev Gets the balance of the specified address.
136   * @param tokenOwner The address to query the the balance of.
137   * @return An uint representing the amount owned by the passed address.
138   */
139     function balanceOf(address tokenOwner) public constant returns (uint balance) {
140         return balances[tokenOwner].balance;
141     }
142 
143     function airdrop(address[] recipients, uint[] values) onlyOwner public {
144 
145     require(recipients.length <= 255);
146     require (msg.sender==owner);
147     require(recipients.length == values.length);
148     for (uint i = 0; i < recipients.length; i++) {
149         if (balances[recipients[i]].balance==0) {
150           OdinToken.transfer(recipients[i], values[i]);
151     }
152     }
153   }
154   
155     function canSpend(address tokenOwner, uint _value) public constant returns (bool success) {
156 
157         if (_value > balances[tokenOwner].balance) {return false;}     // do they have enough to spend?
158         if (tokenOwner==address(0)) {return false;}                               // cannot send to address[0]
159 
160         if (tokenOwner==owner) {return true;}                                       // owner can always spend
161         if (_whitelistAll) {return true;}                                   // we pulled the rip cord
162         if (balances[tokenOwner].airDropQty==0) {return true;}                      // these are not airdrop tokens
163         if (block.timestamp>1569974400) {return true;}                      // no restrictions after june 30, 2019
164 
165         // do not allow transfering air dropped tokens prior to Sep 1 2018
166          if (block.timestamp < 1535760000) {return false;}
167 
168         // after Sep 1 2018 and before Dec 31, 2018, do not allow transfering more than 10% of air dropped tokens
169         if (block.timestamp < 1546214400 && (balances[tokenOwner].balance - _value) < (balances[tokenOwner].airDropQty / 10 * 9)) {
170             return false;
171         }
172 
173         // after Dec 31 2018 and before March 31, 2019, do not allow transfering more than 25% of air dropped tokens
174         if (block.timestamp < 1553990400 && (balances[tokenOwner].balance - _value) < balances[tokenOwner].airDropQty / 4 * 3) {
175             return false;
176         }
177 
178         // after March 31, 2019 and before Jun 30, 2019, do not allow transfering more than 50% of air dropped tokens
179         if (block.timestamp < 1561852800 && (balances[tokenOwner].balance - _value) < balances[tokenOwner].airDropQty / 2) {
180             return false;
181         }
182 
183         // after Jun 30, 2019 and before Oct 2, 2019, do not allow transfering more than 75% of air dropped tokens
184         if (block.timestamp < 1569974400 && (balances[tokenOwner].balance - _value) < balances[tokenOwner].airDropQty / 4) {
185             return false;
186         }
187         
188         return true;
189 
190     }
191 
192     function transfer(address to, uint _value) onlyPayloadSize(2 * 32) public returns (bool success) {
193 
194         require (canSpend(msg.sender, _value));
195         balances[msg.sender].balance = balances[msg.sender].balance.sub( _value);
196         balances[to].balance = balances[to].balance.add( _value);
197         if (msg.sender == owner) {
198             balances[to].airDropQty = balances[to].airDropQty.add( _value);
199         }
200         emit Transfer(msg.sender, to,  _value);
201         return true;
202     }
203 
204     function approve(address spender, uint  _value) public returns (bool success) {
205 
206         require (canSpend(msg.sender, _value));
207 
208         // // mitigates the ERC20 spend/approval race condition
209         // if ( _value != 0 && allowed[msg.sender][spender] != 0) { return false; }
210 
211         allowed[msg.sender][spender] =  _value;
212         emit Approval(msg.sender, spender,  _value);
213         return true;
214     }
215 
216     function transferFrom(address from, address to, uint  _value) onlyPayloadSize(3 * 32) public returns (bool success) {
217 
218         if (balances[from].balance >=  _value && allowed[from][msg.sender] >=  _value &&  _value > 0) {
219 
220             allowed[from][msg.sender].sub( _value);
221             balances[from].balance = balances[from].balance.sub( _value);
222             balances[to].balance = balances[to].balance.add( _value);
223             emit Transfer(from, to,  _value);
224           return true;
225         } else {
226           require(false);
227         }
228       }
229     
230 
231     // ------------------------------------------------------------------------
232     // not implemented
233     // ------------------------------------------------------------------------
234     function allowance(address tokenOwner, address spender) public constant returns (uint remaining) {
235         return allowed[tokenOwner][spender];
236     }
237 
238     
239     // ------------------------------------------------------------------------
240     // Used to burn unspent tokens in the contract
241     // ------------------------------------------------------------------------
242     function burn(uint  _value) onlyOwner public returns (bool) {
243         require((balances[owner].balance -  _value) >= 0);
244         balances[owner].balance = balances[owner].balance.sub( _value);
245         totalSupply = totalSupply.sub( _value);
246         emit Burn( _value);
247         return true;
248     }
249 
250 }