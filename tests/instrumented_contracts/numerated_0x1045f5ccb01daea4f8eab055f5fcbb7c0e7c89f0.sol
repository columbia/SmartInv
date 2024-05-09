1 pragma solidity ^0.4.20;
2 
3 library SafeMath {
4 
5     function add(uint a, uint b) internal pure returns (uint c) {
6         c = a + b;
7         require(c >= a);
8     }
9 
10     function sub(uint a, uint b) internal pure returns (uint c) {
11         require(b <= a);
12         c = a - b;
13     }
14 
15     function mul(uint a, uint b) internal pure returns (uint c) {
16         c = a * b;
17         require(a == 0 || c / a == b);
18     }
19 
20     function div(uint a, uint b) internal pure returns (uint c) {
21         require(b > 0);
22         c = a / b;
23     }
24 
25 }
26 
27 contract ERC20 {
28     // Get the total token supply
29     function totalSupply() public constant returns (uint256 _totalSupply);
30  
31     // Get the account balance of another account with address _owner
32     function balanceOf(address _owner) public constant returns (uint256 balance);
33  
34     // Send _value amount of tokens to address _to
35     function transfer(address _to, uint256 _value) public returns (bool success);
36     
37     // transfer _value amount of token approved by address _from
38     function transferFrom(address _from, address _to, uint256 _value) public returns (bool success);
39     
40     // approve an address with _value amount of tokens
41     function approve(address _spender, uint256 _value) public returns (bool success);
42 
43     // get remaining token approved by _owner to _spender
44     function allowance(address _owner, address _spender) public constant returns (uint256 remaining);
45   
46     // Triggered when tokens are transferred.
47     event Transfer(address indexed _from, address indexed _to, uint256 _value);
48  
49     // Triggered whenever approve(address _spender, uint256 _value) is called.
50     event Approval(address indexed _owner, address indexed _spender, uint256 _value);
51 }
52 
53 contract ERC223 is ERC20{
54     function transfer(address _to, uint _value, bytes _data) public returns (bool success);
55     function transfer(address _to, uint _value, bytes _data, string _custom_fallback) public returns (bool success);
56     event Transfer(address indexed _from, address indexed _to, uint _value, bytes indexed _data);
57 }
58 
59 /// contract receiver interface
60 contract ContractReceiver {  
61     function tokenFallback(address _from, uint _value, bytes _data) external;
62 }
63 
64 contract Ownable {
65     address private _owner;
66     address private _previousOwner;
67     uint256 private _lockTime;
68 
69     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
70 
71     function Ownable() public {
72         _owner = msg.sender;
73         OwnershipTransferred(address(0), msg.sender);
74     }
75 
76     function owner() public view returns (address) {
77         return _owner;
78     }   
79     
80     modifier onlyOwner() {
81         require(_owner == msg.sender);
82         _;
83     }
84     
85     function renounceOwnership() public onlyOwner {
86         OwnershipTransferred(_owner, address(0));
87         _owner = address(0);
88     }
89 
90     function transferOwnership(address newOwner) public onlyOwner {
91         require(newOwner != address(0));
92         OwnershipTransferred(_owner, newOwner);
93         _owner = newOwner;
94     }
95 
96     function getUnlockTime() public view returns (uint256) {
97         return _lockTime;
98     }
99     
100     function getTime() public view returns (uint256) {
101         return block.timestamp;
102     }
103 
104     function lock(uint256 time) public onlyOwner {
105         _previousOwner = _owner;
106         _owner = address(0);
107         _lockTime = block.timestamp + time;
108         OwnershipTransferred(_owner, address(0));
109     }
110     
111     function unlock() public {
112         require(_previousOwner == msg.sender);
113         require(block.timestamp > _lockTime );
114         OwnershipTransferred(_owner, _previousOwner);
115         _owner = _previousOwner;
116     }
117 }
118 
119 contract BasicToken is Ownable, ERC223 {
120     using SafeMath for uint256;
121     
122     uint256 public constant decimals = 18;
123     string public constant symbol = "DFIAT";
124     string public constant name = "DeFiato";
125     uint256 public totalSupply = 250000000 * 10**18;
126 
127     address public admin;
128 
129     // tradable
130     bool public tradable = false;
131 
132     // Balances DFO for each account
133     mapping(address => uint256) balances;
134     
135     // Owner of account approves the transfer of an amount to another account
136     mapping(address => mapping (address => uint256)) allowed;
137 
138     modifier isTradable(){
139         require(tradable == true || msg.sender == admin || msg.sender == owner());
140         _;
141     }
142 
143     /// @dev Gets totalSupply
144     /// @return Total supply
145     function totalSupply()
146     public 
147     constant 
148     returns (uint256) {
149         return totalSupply;
150     }
151         
152     /// @dev Gets account's balance
153     /// @param _addr Address of the account
154     /// @return Account balance
155     function balanceOf(address _addr) 
156     public
157     constant 
158     returns (uint256) {
159         return balances[_addr];
160     }
161     
162     
163     //assemble the given address bytecode. If bytecode exists then the _addr is a contract.
164     function isContract(address _addr) 
165     private 
166     view 
167     returns (bool is_contract) {
168         uint length;
169         assembly {
170             //retrieve the size of the code on target address, this needs assembly
171             length := extcodesize(_addr)
172         }
173         return (length>0);
174     }
175  
176     /// @dev Transfers the balance from msg.sender to an account
177     /// @param _to Recipient address
178     /// @param _value Transfered amount in unit
179     /// @return Transfer status
180     // Standard function transfer similar to ERC20 transfer with no _data .
181     // Added due to backwards compatibility reasons .
182     function transfer(address _to, uint _value) 
183     public 
184     isTradable
185     returns (bool success) {
186         require(_to != 0x0);
187         balances[msg.sender] = balances[msg.sender].sub(_value);
188         balances[_to] = balances[_to].add(_value);
189 
190         Transfer(msg.sender, _to, _value);
191         return true;
192     }
193     
194     /// @dev Function that is called when a user or another contract wants to transfer funds .
195     /// @param _to Recipient address
196     /// @param _value Transfer amount in unit
197     /// @param _data the data pass to contract reveiver
198     function transfer(
199         address _to, 
200         uint _value, 
201         bytes _data) 
202     public
203     isTradable 
204     returns (bool success) {
205         require(_to != 0x0);
206         balances[msg.sender] = balanceOf(msg.sender).sub(_value);
207         balances[_to] = balanceOf(_to).add(_value);
208         Transfer(msg.sender, _to, _value);
209         if(isContract(_to)) {
210             ContractReceiver receiver = ContractReceiver(_to);
211             receiver.tokenFallback(msg.sender, _value, _data);
212             Transfer(msg.sender, _to, _value, _data);
213         }
214         
215         return true;
216     }
217     
218     /// @dev Function that is called when a user or another contract wants to transfer funds .
219     /// @param _to Recipient address
220     /// @param _value Transfer amount in unit
221     /// @param _data the data pass to contract reveiver
222     /// @param _custom_fallback custom name of fallback function
223     function transfer(
224         address _to, 
225         uint _value, 
226         bytes _data, 
227         string _custom_fallback) 
228     public 
229     isTradable
230     returns (bool success) {
231         require(_to != 0x0);
232         balances[msg.sender] = balanceOf(msg.sender).sub(_value);
233         balances[_to] = balanceOf(_to).add(_value);
234         Transfer(msg.sender, _to, _value);
235 
236         if(isContract(_to)) {
237             assert(_to.call.value(0)(bytes4(keccak256(_custom_fallback)), msg.sender, _value, _data));
238             Transfer(msg.sender, _to, _value, _data);
239         }
240         return true;
241     }
242          
243     // Send _value amount of tokens from address _from to address _to
244     // The transferFrom method is used for a withdraw workflow, allowing contracts to send
245     // tokens on your behalf, for example to "deposit" to a contract address and/or to charge
246     // fees in sub-currencies; the command should fail unless the _from account has
247     // deliberately authorized the sender of the message via some mechanism; we propose
248     // these standardized APIs for approval:
249     function transferFrom(
250         address _from,
251         address _to,
252         uint256 _value)
253     public
254     isTradable
255     returns (bool success) {
256         require(_to != 0x0);
257         balances[_from] = balances[_from].sub(_value);
258         allowed[_from][msg.sender] = allowed[_from][msg.sender].sub(_value);
259         balances[_to] = balances[_to].add(_value);
260 
261         Transfer(_from, _to, _value);
262         return true;
263     }
264     
265     // Allow _spender to withdraw from your account, multiple times, up to the _value amount.
266     // If this function is called again it overwrites the current allowance with _value.
267     function approve(address _spender, uint256 _amount) 
268     public
269     returns (bool success) {
270         allowed[msg.sender][_spender] = _amount;
271         Approval(msg.sender, _spender, _amount);
272         return true;
273     }
274     
275     // get allowance
276     function allowance(address _owner, address _spender) 
277     public
278     constant 
279     returns (uint256 remaining) {
280         return allowed[_owner][_spender];
281     }
282     
283     // @dev allow owner to update admin
284     function updateAdmin(address _admin) 
285     public 
286     onlyOwner{
287         admin = _admin;
288     }
289     
290     // allow people can transfer their token
291     // NOTE: can not turn off
292     function turnOnTradable() 
293     public onlyOwner {
294         tradable = true;
295     }
296 }
297 
298 contract DEFIATO is BasicToken {
299 
300     function DEFIATO() public {
301         balances[msg.sender] = totalSupply;
302         Transfer(0x0, msg.sender, totalSupply);
303     }
304 
305     function()
306     public
307     payable {
308         
309     }
310 
311     /// @dev Withdraws Ether in contract (Owner only)
312     /// @return Status of withdrawal
313     function withdraw() onlyOwner 
314     public 
315     returns (bool) {
316         return owner().send(this.balance);
317     }
318 
319     /// @dev Withdraws ERC20 Token in contract (Owner only)
320     /// @return Status of withdrawal
321     function transferAnyERC20Token(address tokenAddress, uint256 amount) public returns (bool success) {
322         return ERC20(tokenAddress).transfer(owner(), amount);
323     }
324 }