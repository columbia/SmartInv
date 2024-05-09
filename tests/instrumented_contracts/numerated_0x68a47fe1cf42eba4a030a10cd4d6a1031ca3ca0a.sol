1 pragma solidity 0.4.17;
2 
3 /*  
4  *   Math operations with safety checks that throw on error
5  */
6 library SafeMath {
7     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
8         assert(b <= a);
9         return a - b;
10     }
11 
12     function add(uint256 a, uint256 b) internal pure returns (uint256) {
13         uint256 c = a + b;
14         assert(c >= a);
15         return c;
16     }
17 }
18 
19 /*
20  *  The Ownable contract has an owner address, and provides basic authorization control
21  * functions, this simplifies the implementation of "user permissions".
22  */
23 contract Ownable {
24     address public owner;
25     address public newOwner;
26 	
27     function Ownable() public {
28         owner = msg.sender;
29     }
30 
31     modifier onlyOwner() {
32         require(msg.sender == owner);
33         _;
34     }
35 
36     function changeOwner(address _owner) onlyOwner public {
37         require(_owner != 0);
38         newOwner = _owner;
39     }
40     
41     function confirmOwner() public {
42         require(newOwner == msg.sender);
43         owner = newOwner;
44         delete newOwner;
45     }
46 }
47 
48 /*
49  * Simpler version of ERC20 interface
50  *  see https://github.com/ethereum/EIPs/issues/20
51  */
52 contract ERC20Basic {
53     uint256 public _totalSupply;
54     function totalSupply() public view returns (uint256);
55     function balanceOf(address who) public view returns (uint256 balance);
56     function transfer(address to, uint value) public returns (bool success);
57     event Transfer(address indexed _from, address indexed _to, uint256 _value);
58 }
59 
60 /*
61  * ERC20 interface
62  *  see https://github.com/ethereum/EIPs/issues/20
63  */
64 contract ERC20 is ERC20Basic {
65     function allowance(address owner, address spender) public view returns (uint256 remaining);
66     function transferFrom(address from, address to, uint256 value) public returns (bool success);
67     function approve(address spender, uint256 value) public returns (bool success);
68     event Approval(address indexed _owner, address indexed _spender, uint256 _value);
69 }
70 
71 /*
72  *  Basic token
73  *  Basic version of StandardToken, with no allowances.
74  */
75 contract BasicToken is Ownable, ERC20Basic {
76     using SafeMath for uint256;
77 
78     mapping(address => uint256) public balances;
79 
80     /*
81     *  Fix for the ERC20 short address attack.
82     */
83     modifier onlyPayloadSize(uint256 size) {
84         require(!(msg.data.length < size + 4));
85         _;
86     }
87 
88     /*
89     *  transfer token for a specified address
90     * @param _to The address to transfer to.
91     * @param _value The amount to be transferred.
92     */
93     function transfer(address _to, uint256 _value) public onlyPayloadSize(2 * 32) returns (bool success) {
94         require (!(_to == 0x0));
95         balances[msg.sender] = balances[msg.sender].sub(_value);
96         balances[_to] = balances[_to].add(_value);
97         Transfer(msg.sender, _to, _value);
98         return true;
99     }
100 
101     /*
102     *  Gets the balance of the specified address.
103     * @param _owner The address to query the the balance of.
104     * @return An uint representing the amount owned by the passed address.
105     */
106     function balanceOf(address _owner) public view returns (uint256 balance) {
107         return balances[_owner];
108     }
109 }
110 
111 
112 /*
113  *  Implementation of the basic standard token.
114  * see https://github.com/ethereum/EIPs/issues/20
115  */
116 contract StandardToken is BasicToken, ERC20 {
117 
118     mapping (address => mapping (address => uint256)) public allowed;
119     uint256 public constant maxtet =1000000000000000;  
120                              
121     /*
122     *  Transfer tokens from one address to another
123     * @param _from address The address which you want to send tokens from
124     * @param _to address The address which you want to transfer to
125     * @param _value uint the amount of tokens to be transferred
126     */
127     function transferFrom(address _from, address _to, uint256 _value) public  onlyPayloadSize(3 * 32) returns (bool success) {
128         require (!(_to == 0x0));
129         var _allowance = allowed[_from][msg.sender];
130 
131         if (_allowance < maxtet) {
132             allowed[_from][msg.sender] = _allowance.sub(_value);
133         }
134         balances[_from] = balances[_from].sub(_value);
135         balances[_to] = balances[_to].add(_value);
136         Transfer(_from, _to, _value);
137         return true;
138     }
139 
140     /*
141     *  Approve the passed address to spend the specified amount of tokens on behalf of msg.sender.
142     * @param _spender The address which will spend the funds.
143     * @param _value The amount of tokens to be spent.
144     */
145     function approve(address _spender, uint256 _value) public onlyPayloadSize(2 * 32) returns (bool success) {
146 
147         // To change the approve amount you first have to reduce the addresses`
148         //  allowance to zero by calling `approve(_spender, 0)` if it is not
149         //  already 0 to mitigate the race condition described here:
150         //  https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
151         require(!((_value != 0) && (allowed[msg.sender][_spender] != 0)));
152 
153         allowed[msg.sender][_spender] = _value;
154         Approval(msg.sender, _spender, _value);
155         return true;
156     }
157 
158     /*
159     * Function to check the amount of tokens than an owner allowed to a spender.
160     * @param _owner address The address which owns the funds.
161     * @param _spender address The address which will spend the funds.
162     * @return A uint specifying the amount of tokens still available for the spender.
163     */
164     function allowance(address _owner, address _spender) public view returns (uint256 remaining) {
165         return allowed[_owner][_spender];
166     }
167 }
168 
169 
170 contract Tettoken is  StandardToken {
171 
172     string public name;
173     string public symbol;
174     uint8 public decimals;
175 
176     function name() public view returns (string) {
177         return name;
178     }
179 
180     function symbol() public view returns (string) {
181         return symbol;
182     }
183 
184     function decimals() public view returns (uint8) {
185         return decimals;
186     }
187 
188     //  The contract can be initialized with a number of tokens
189     //  All the tokens are deposited to the owner address
190     //
191     // @param _balance Initial supply of the contract
192     // @param _name Token Name
193     // @param _symbol Token symbol
194     // @param _decimals Token decimals
195     function Tettoken(uint256 _initialSupply, string _name, string _symbol, uint8 _decimals) public {
196         require( _initialSupply <= maxtet); 
197         _totalSupply = _initialSupply;
198         name = _name;
199         symbol = _symbol;
200         decimals = _decimals;
201         balances[owner] = _initialSupply;
202     }
203 
204     function totalSupply() public view returns (uint256) {
205             return _totalSupply;
206     }
207 
208     function tetwrite(uint256 _newts) public onlyOwner returns (uint256 tetts) {
209         require( _newts <= maxtet);
210         require( _newts != _totalSupply);
211 
212         if (_newts > _totalSupply) {
213                balances[owner] = balances[owner].add(_newts - _totalSupply);
214         } else {
215                   require  (balances[owner] >= ( _totalSupply - _newts ));
216                 balances[owner] = balances[owner].sub(_totalSupply - _newts)  ;
217         }
218          _totalSupply = _newts ;
219          Tetwrite(_totalSupply);
220          return _totalSupply ;
221     }
222 
223 
224     // Issue a new amount of tokens
225     // these tokens are deposited into the owner address
226     //
227     // @param _amount Number of tokens to be issued
228     function issue(uint256 _amount) public onlyOwner returns (bool success) {
229         require(_totalSupply + _amount <= maxtet); 
230         require(_totalSupply + _amount > _totalSupply);
231         require(balances[owner] + _amount > balances[owner]);
232 
233         balances[owner] += _amount;
234         _totalSupply += _amount;
235         Issue(_amount);
236         return true;
237     }
238 
239     // Redeem tokens.
240     // These tokens are withdrawn from the owner address
241     // if the balance must be enough to cover the redeem
242     // or the call will fail.
243     // @param _amount Number of tokens to be issued
244     function redeem(uint256 _amount) public onlyOwner returns (bool success) {
245         require(_totalSupply >= _amount);
246         require(balances[owner] >= _amount);
247 
248         _totalSupply -= _amount;
249         balances[owner] -= _amount;
250         Redeem(_amount);
251         return true;
252     }
253 
254     event Issue(uint256 _amount);
255 
256     event Redeem(uint256 _amount);
257 
258     event Tetwrite(uint256 _tetts);
259 }