1 pragma solidity 0.4.18;
2 
3 /// @title Ownable
4 /// @dev The Ownable contract has an owner address, and provides basic authorization control functions,
5 /// this simplifies the implementation of "user permissions".
6 /// @dev Based on OpenZeppelin's Ownable.
7 
8 contract Ownable {
9     address public owner;
10     address public newOwnerCandidate;
11 
12     event OwnershipRequested(address indexed _by, address indexed _to);
13     event OwnershipTransferred(address indexed _from, address indexed _to);
14 
15     /// @dev Constructor sets the original `owner` of the contract to the sender account.
16     function Ownable() public {
17         owner = msg.sender;
18     }
19 
20     /// @dev Reverts if called by any account other than the owner.
21     modifier onlyOwner() {
22         require(msg.sender == owner);
23         _;
24     }
25 
26     modifier onlyOwnerCandidate() {
27         require(msg.sender == newOwnerCandidate);
28         _;
29     }
30 
31     /// @dev Proposes to transfer control of the contract to a newOwnerCandidate.
32     /// @param _newOwnerCandidate address The address to transfer ownership to.
33     function requestOwnershipTransfer(address _newOwnerCandidate) external onlyOwner {
34         require(_newOwnerCandidate != address(0));
35 
36         newOwnerCandidate = _newOwnerCandidate;
37 
38         OwnershipRequested(msg.sender, newOwnerCandidate);
39     }
40 
41     /// @dev Accept ownership transfer. This method needs to be called by the perviously proposed owner.
42     function acceptOwnership() external onlyOwnerCandidate {
43         address previousOwner = owner;
44 
45         owner = newOwnerCandidate;
46         newOwnerCandidate = address(0);
47 
48         OwnershipTransferred(previousOwner, owner);
49     }
50 }
51 
52 /// @title Math operations with safety checks
53 library SafeMath {
54     function mul(uint256 a, uint256 b) internal pure returns (uint256) {
55         uint256 c = a * b;
56         require(a == 0 || c / a == b);
57         return c;
58     }
59 
60     function div(uint256 a, uint256 b) internal pure returns (uint256) {
61         // require(b > 0); // Solidity automatically throws when dividing by 0
62         uint256 c = a / b;
63         // require(a == b * c + a % b); // There is no case in which this doesn't hold
64         return c;
65     }
66 
67     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
68         require(b <= a);
69         return a - b;
70     }
71 
72     function add(uint256 a, uint256 b) internal pure returns (uint256) {
73         uint256 c = a + b;
74         require(c >= a);
75         return c;
76     }
77 
78     function max64(uint64 a, uint64 b) internal pure returns (uint64) {
79         return a >= b ? a : b;
80     }
81 
82     function min64(uint64 a, uint64 b) internal pure returns (uint64) {
83         return a < b ? a : b;
84     }
85 
86     function max256(uint256 a, uint256 b) internal pure returns (uint256) {
87         return a >= b ? a : b;
88     }
89 
90     function min256(uint256 a, uint256 b) internal pure returns (uint256) {
91         return a < b ? a : b;
92     }
93 
94     function toPower2(uint256 a) internal pure returns (uint256) {
95         return mul(a, a);
96     }
97 
98     function sqrt(uint256 a) internal pure returns (uint256) {
99         uint256 c = (a + 1) / 2;
100         uint256 b = a;
101         while (c < b) {
102             b = c;
103             c = (a / c + c) / 2;
104         }
105         return b;
106     }
107 }
108 
109 /// @title ERC Token Standard #20 Interface (https://github.com/ethereum/EIPs/issues/20)
110 contract ERC20 {
111     uint public totalSupply;
112     function balanceOf(address _owner) constant public returns (uint balance);
113     function transfer(address _to, uint _value) public returns (bool success);
114     function transferFrom(address _from, address _to, uint _value) public returns (bool success);
115     function approve(address _spender, uint _value) public returns (bool success);
116     function allowance(address _owner, address _spender) public constant returns (uint remaining);
117     event Transfer(address indexed from, address indexed to, uint value);
118     event Approval(address indexed owner, address indexed spender, uint value);
119 }
120 
121 
122 
123 /// @title ERC Token Standard #677 Interface (https://github.com/ethereum/EIPs/issues/677)
124 contract ERC677 is ERC20 {
125     function transferAndCall(address to, uint value, bytes data) public returns (bool ok);
126 
127     event TransferAndCall(address indexed from, address indexed to, uint value, bytes data);
128 }
129 
130 /// @title ERC223Receiver Interface
131 /// @dev Based on the specs form: https://github.com/ethereum/EIPs/issues/223
132 contract ERC223Receiver {
133     function tokenFallback(address _sender, uint _value, bytes _data) external returns (bool ok);
134 }
135 
136 
137 
138 
139 /// @title Basic ERC20 token contract implementation.
140 /// @dev Based on OpenZeppelin's StandardToken.
141 contract BasicToken is ERC20 {
142     using SafeMath for uint256;
143 
144     uint256 public totalSupply;
145     mapping (address => mapping (address => uint256)) allowed;
146     mapping (address => uint256) balances;
147 
148     event Approval(address indexed owner, address indexed spender, uint256 value);
149     event Transfer(address indexed from, address indexed to, uint256 value);
150 
151     /// @dev Approve the passed address to spend the specified amount of tokens on behalf of msg.sender.
152     /// @param _spender address The address which will spend the funds.
153     /// @param _value uint256 The amount of tokens to be spent.
154     function approve(address _spender, uint256 _value) public returns (bool) {
155         // https://github.com/ethereum/EIPs/blob/master/EIPS/eip-20.md#approve (see NOTE)
156         if ((_value != 0) && (allowed[msg.sender][_spender] != 0)) {
157             revert();
158         }
159 
160         allowed[msg.sender][_spender] = _value;
161 
162         Approval(msg.sender, _spender, _value);
163 
164         return true;
165     }
166 
167     /// @dev Function to check the amount of tokens that an owner allowed to a spender.
168     /// @param _owner address The address which owns the funds.
169     /// @param _spender address The address which will spend the funds.
170     /// @return uint256 specifying the amount of tokens still available for the spender.
171     function allowance(address _owner, address _spender) constant public returns (uint256 remaining) {
172         return allowed[_owner][_spender];
173     }
174 
175 
176     /// @dev Gets the balance of the specified address.
177     /// @param _owner address The address to query the the balance of.
178     /// @return uint256 representing the amount owned by the passed address.
179     function balanceOf(address _owner) constant public returns (uint256 balance) {
180         return balances[_owner];
181     }
182 
183     /// @dev Transfer token to a specified address.
184     /// @param _to address The address to transfer to.
185     /// @param _value uint256 The amount to be transferred.
186     function transfer(address _to, uint256 _value) public returns (bool) {
187         require(_to != address(0));
188         balances[msg.sender] = balances[msg.sender].sub(_value);
189         balances[_to] = balances[_to].add(_value);
190 
191         Transfer(msg.sender, _to, _value);
192 
193         return true;
194     }
195 
196     /// @dev Transfer tokens from one address to another.
197     /// @param _from address The address which you want to send tokens from.
198     /// @param _to address The address which you want to transfer to.
199     /// @param _value uint256 the amount of tokens to be transferred.
200     function transferFrom(address _from, address _to, uint256 _value) public returns (bool) {
201         require(_to != address(0));
202         var _allowance = allowed[_from][msg.sender];
203 
204         balances[_from] = balances[_from].sub(_value);
205         balances[_to] = balances[_to].add(_value);
206 
207         allowed[_from][msg.sender] = _allowance.sub(_value);
208 
209         Transfer(_from, _to, _value);
210 
211         return true;
212     }
213 }
214 
215 
216 
217 
218 
219 
220 /// @title Standard677Token implentation, base on https://github.com/ethereum/EIPs/issues/677
221 
222 contract Standard677Token is ERC677, BasicToken {
223 
224   /// @dev ERC223 safe token transfer from one address to another
225   /// @param _to address the address which you want to transfer to.
226   /// @param _value uint256 the amount of tokens to be transferred.
227   /// @param _data bytes data that can be attached to the token transation
228   function transferAndCall(address _to, uint _value, bytes _data) public returns (bool) {
229     require(super.transfer(_to, _value)); // do a normal token transfer
230     TransferAndCall(msg.sender, _to, _value, _data);
231     //filtering if the target is a contract with bytecode inside it
232     if (isContract(_to)) return contractFallback(_to, _value, _data);
233     return true;
234   }
235 
236   /// @dev called when transaction target is a contract
237   /// @param _to address the address which you want to transfer to.
238   /// @param _value uint256 the amount of tokens to be transferred.
239   /// @param _data bytes data that can be attached to the token transation
240   function contractFallback(address _to, uint _value, bytes _data) private returns (bool) {
241     ERC223Receiver receiver = ERC223Receiver(_to);
242     require(receiver.tokenFallback(msg.sender, _value, _data));
243     return true;
244   }
245 
246   /// @dev check if the address is contract
247   /// assemble the given address bytecode. If bytecode exists then the _addr is a contract.
248   /// @param _addr address the address to check
249   function isContract(address _addr) private constant returns (bool is_contract) {
250     // retrieve the size of the code on target address, this needs assembly
251     uint length;
252     assembly { length := extcodesize(_addr) }
253     return length > 0;
254   }
255 }
256 
257 
258 
259 
260 
261 /// @title Token holder contract.
262 contract TokenHolder is Ownable {
263     /// @dev Allow the owner to transfer out any accidentally sent ERC20 tokens.
264     /// @param _tokenAddress address The address of the ERC20 contract.
265     /// @param _amount uint256 The amount of tokens to be transferred.
266     function transferAnyERC20Token(address _tokenAddress, uint256 _amount) public onlyOwner returns (bool success) {
267         return ERC20(_tokenAddress).transfer(owner, _amount);
268     }
269 }
270 
271 
272 
273 
274 
275 
276 /// @title Colu Local Network contract.
277 /// @author Tal Beja.
278 contract ColuLocalNetwork is Ownable, Standard677Token, TokenHolder {
279     using SafeMath for uint256;
280 
281     string public constant name = "Colu Local Network";
282     string public constant symbol = "CLN";
283 
284     // Using same decimals value as ETH (makes ETH-CLN conversion much easier).
285     uint8 public constant decimals = 18;
286 
287     // States whether token transfers is allowed or not.
288     // Used during token sale.
289     bool public isTransferable = false;
290 
291     event TokensTransferable();
292 
293     modifier transferable() {
294         require(msg.sender == owner || isTransferable);
295         _;
296     }
297 
298     /// @dev Creates all tokens and gives them to the owner.
299     function ColuLocalNetwork(uint256 _totalSupply) public {
300         totalSupply = _totalSupply;
301         balances[msg.sender] = totalSupply;
302     }
303 
304     /// @dev start transferable mode.
305     function makeTokensTransferable() external onlyOwner {
306         if (isTransferable) {
307             return;
308         }
309 
310         isTransferable = true;
311 
312         TokensTransferable();
313     }
314 
315     /// @dev Same ERC20 behavior, but reverts if not transferable.
316     /// @param _spender address The address which will spend the funds.
317     /// @param _value uint256 The amount of tokens to be spent.
318     function approve(address _spender, uint256 _value) public transferable returns (bool) {
319         return super.approve(_spender, _value);
320     }
321 
322     /// @dev Same ERC20 behavior, but reverts if not transferable.
323     /// @param _to address The address to transfer to.
324     /// @param _value uint256 The amount to be transferred.
325     function transfer(address _to, uint256 _value) public transferable returns (bool) {
326         return super.transfer(_to, _value);
327     }
328 
329     /// @dev Same ERC20 behavior, but reverts if not transferable.
330     /// @param _from address The address to send tokens from.
331     /// @param _to address The address to transfer to.
332     /// @param _value uint256 the amount of tokens to be transferred.
333     function transferFrom(address _from, address _to, uint256 _value) public transferable returns (bool) {
334         return super.transferFrom(_from, _to, _value);
335     }
336 
337     /// @dev Same ERC677 behavior, but reverts if not transferable.
338     /// @param _to address The address to transfer to.
339     /// @param _value uint256 The amount to be transferred.
340     /// @param _data bytes data to send to receiver if it is a contract.
341     function transferAndCall(address _to, uint _value, bytes _data) public transferable returns (bool success) {
342       return super.transferAndCall(_to, _value, _data);
343     }
344 }