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
17   function div(uint256 a, uint256 b) internal pure returns (uint256) {
18     // assert(b > 0); // Solidity automatically throws when dividing by 0
19     uint256 c = a / b;
20     // assert(a == b * c + a % b); // There is no case in which this doesn't hold
21     return c;
22   }
23 
24   function sub(uint256 a, uint256 b) internal pure returns (uint256) {
25     assert(b <= a);
26     return a - b;
27   }
28 
29   function add(uint256 a, uint256 b) internal pure returns (uint256) {
30     uint256 c = a + b;
31     assert(c >= a);
32     return c;
33   }
34 }
35 
36 // ----------------------------------------------------------------------------
37 // ERC Token Standard #20 Interface
38 // https://github.com/ethereum/EIPs/blob/master/EIPS/eip-20-token-standard.md
39 // ----------------------------------------------------------------------------
40 contract ERC20Interface {
41     function totalSupply() public constant returns (uint);
42     function balanceOf(address tokenOwner) public constant returns (uint balance);
43     function allowance(address tokenOwner, address spender) public constant returns (uint remaining);
44     function transfer(address to, uint tokens) public returns (bool success);
45     function approve(address spender, uint tokens) public returns (bool success);
46     function transferFrom(address from, address to, uint tokens) public returns (bool success);
47 
48     event Transfer(address indexed from, address indexed to, uint tokens);
49     event Approval(address indexed tokenOwner, address indexed spender, uint tokens);
50     event Burn(uint tokens);
51 }
52 
53 
54 
55 // ----------------------------------------------------------------------------
56 // Owned contract
57 // ----------------------------------------------------------------------------
58 contract Owned {
59     address public owner;
60     address private newOwner;
61 
62     event OwnershipTransferred(address indexed _from, address indexed _to);
63 
64     modifier onlyOwner {
65         require(msg.sender == owner);
66         _;
67     }
68 
69     function transferOwnership(address _newOwner) onlyOwner public onlyOwner {
70         owner = _newOwner;
71         emit OwnershipTransferred(msg.sender, _newOwner);
72     }
73 
74 }
75 
76 // ----------------------------------------------------------------------------
77 // ERC20 Token, with the addition of symbol, name and decimals and assisted
78 // token transfers
79 // ----------------------------------------------------------------------------
80 contract OdinToken is ERC20Interface, Owned {
81 
82   using SafeMath for uint256;
83 
84     string public symbol;
85     string public name;
86     uint8 public decimals;
87     uint private _totalSupply;
88     bool private _whitelistAll;
89 
90     struct balanceData {  
91        bool locked;
92        uint balance;
93        uint airDropQty;
94     }
95 
96     mapping(address => balanceData) balances;
97     mapping(address => mapping(address => uint)) allowed;
98 
99 
100   /**
101   * @dev Constructor for Odin creation
102   * @dev Initially assigns the totalSupply to the contract creator
103   */
104     function OdinToken() public {
105         
106         // owner of this contract
107         owner = msg.sender;
108         symbol = "ODIN";
109         name = "ODIN Token";
110         decimals = 18;
111         _whitelistAll=false;
112         _totalSupply = 100000000000000000000000;
113         balances[owner].balance = _totalSupply;
114 
115         emit Transfer(address(0), msg.sender, _totalSupply);
116     }
117 
118     function totalSupply() constant public returns (uint256 totalSupply) {
119         return _totalSupply;
120     }
121 
122     // ------------------------------------------------------------------------
123     // whitelist an address
124     // ------------------------------------------------------------------------
125     function whitelistAddress(address to) onlyOwner public  returns (bool)    {
126 		balances[to].airDropQty = 0;
127 		return true;
128     }
129 
130 
131   /**
132   * @dev Whitelist all addresses early
133   * @return An bool showing if the function succeeded.
134   */
135     function whitelistAllAddresses() onlyOwner public returns (bool) {
136         _whitelistAll = true;
137         return true;
138     }
139 
140 
141   /**
142   * @dev Gets the balance of the specified address.
143   * @param tokenOwner The address to query the the balance of.
144   * @return An uint representing the amount owned by the passed address.
145   */
146     function balanceOf(address tokenOwner) public constant returns (uint balance) {
147         return balances[tokenOwner].balance;
148     }
149 
150   /**
151   * @dev transfer token for a specified address
152   * @param to The address to transfer to.
153   * @param tokens The amount to be transferred.
154   */
155     function transfer(address to, uint tokens) public returns (bool success) {
156 
157         require (msg.sender != to);                             // cannot send to yourself
158         require(to != address(0));                              // cannot send to address(0)
159         require(tokens <= balances[msg.sender].balance);        // do you have enough to send?
160         
161         if (!_whitelistAll) {
162 
163             // do not allow transfering air dropped tokens prior to Sep 1 2018
164              if (msg.sender != owner && block.timestamp < 1535760000 && balances[msg.sender].airDropQty>0) {
165                  require(tokens < 0);
166             }
167 
168             // after Sep 1 2018 and before Dec 31, 2018, do not allow transfering more than 10% of air dropped tokens
169             if (msg.sender != owner && block.timestamp < 1546214400 && balances[msg.sender].airDropQty>0) {
170                 require((balances[msg.sender].balance - tokens) >= (balances[msg.sender].airDropQty / 10 * 9));
171             }
172 
173             // after Dec 31 2018 and before March 31, 2019, do not allow transfering more than 25% of air dropped tokens
174             if (msg.sender != owner && block.timestamp < 1553990400 && balances[msg.sender].airDropQty>0) {
175                 require((balances[msg.sender].balance - tokens) >= balances[msg.sender].airDropQty / 4 * 3);
176             }
177 
178             // after March 31, 2019 and before Jun 30, 2019, do not allow transfering more than 50% of air dropped tokens
179             if (msg.sender != owner && block.timestamp < 1561852800 && balances[msg.sender].airDropQty>0) {
180                 require((balances[msg.sender].balance - tokens) >= balances[msg.sender].airDropQty / 2);
181             }
182 
183             // after Jun 30, 2019 and before Oct 2, 2019, do not allow transfering more than 75% of air dropped tokens
184             if (msg.sender != owner && block.timestamp < 1569974400 && balances[msg.sender].airDropQty>0) {
185                 require((balances[msg.sender].balance - tokens) >= balances[msg.sender].airDropQty / 4);
186             }
187             
188             // otherwise, no transfer restrictions
189 
190         }
191         
192         balances[msg.sender].balance = balances[msg.sender].balance.sub(tokens);
193         balances[to].balance = balances[to].balance.add(tokens);
194         if (msg.sender == owner) {
195             balances[to].airDropQty = balances[to].airDropQty.add(tokens);
196         }
197         emit Transfer(msg.sender, to, tokens);
198         return true;
199     }
200 
201     // ------------------------------------------------------------------------
202     // not implemented
203     // ------------------------------------------------------------------------
204     function approve(address spender, uint tokens) public returns (bool success) {
205         return false;
206     }
207 
208 
209     // ------------------------------------------------------------------------
210     // not implemented
211     // ------------------------------------------------------------------------
212     function transferFrom(address from, address to, uint tokens) public returns (bool success) {
213         return false;
214     }
215 
216 
217     // ------------------------------------------------------------------------
218     // not implemented
219     // ------------------------------------------------------------------------
220     function allowance(address tokenOwner, address spender) public constant returns (uint remaining) {
221         return 0;
222     }
223 
224 
225     // ------------------------------------------------------------------------
226     // not implemented
227     // ------------------------------------------------------------------------
228     function approveAndCall(address spender, uint tokens, bytes data) public returns (bool success) {
229         return false;
230     }
231     
232     // ------------------------------------------------------------------------
233     // Used to burn unspent tokens in the contract
234     // ------------------------------------------------------------------------
235     function burn(uint256 tokens) onlyOwner public returns (bool) {
236         require((balances[owner].balance - tokens) >= 0);
237         balances[owner].balance = balances[owner].balance.sub(tokens);
238         _totalSupply = _totalSupply.sub(tokens);
239         emit Burn(tokens);
240         return true;
241     }
242 
243 
244     function ()  {
245         //if ether is sent to this address, send it back.
246         throw;
247     }
248 }