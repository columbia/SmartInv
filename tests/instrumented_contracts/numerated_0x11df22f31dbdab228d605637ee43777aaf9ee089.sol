1 pragma solidity ^0.4.23;
2 
3 library SafeMath{
4     // Multiples 2 numbers, throws on overflow is detected.
5     function mul(uint256 _x, uint256 _y) internal pure returns (uint256 result){
6         if(_y == 0){
7             return 0;
8         }
9         result = _x*_y;
10         assert(_x == result/_y);
11         return result;
12     }
13     //Divides 2 numbers, solidity automatically throws if _y is 0.
14     function div(uint256 _x, uint256 _y) internal pure returns (uint256 result){
15         result = _x / _y;
16         return result;
17     }
18     //Adds 2 numbers, throws on overflow.
19     function add(uint256 _x, uint256 _y) internal pure returns (uint256 result){
20         result = _x + _y;
21         assert(result >= _x);
22         return result;
23     }
24     function sub(uint256 _x, uint256 _y) internal pure returns (uint256 result){
25         assert(_x >= _y);
26         result = _x - _y;
27         return result;
28     }
29 }
30 interface ReceiverContract{
31     function tokenFallback(address _sender, uint256 _amount, bytes _data) external;
32 }
33 
34 
35 contract ERC20Interface {
36     function balanceOf(address tokenOwner) public view returns (uint balance);
37     function transfer(address to, uint tokens) public returns (bool success);
38 
39     function allowance(address tokenOwner, address spender) public view returns (uint remaining);
40     function approve(address spender, uint tokens) public returns (bool success);
41     function transferFrom(address from, address to, uint tokens) public returns (bool success);
42 
43     event Transfer(address indexed from, address indexed to, uint tokens);
44     event Approval(address indexed tokenOwner, address indexed spender, uint tokens);
45 }
46 contract Ownable{
47     address public owner;
48     event ownerTransfer(address indexed oldOwner, address indexed newOwner);
49     event ownerGone(address indexed oldOwner);
50 
51     constructor(){
52         owner = msg.sender;
53     }
54     modifier onlyOwner(){
55         require(msg.sender == owner);
56         _;
57     }
58     function changeOwner(address _newOwner) public onlyOwner{
59         require(_newOwner != address(0x0));
60         emit ownerTransfer(owner, _newOwner);
61         owner = _newOwner;
62     }
63     function deleteOwner() public onlyOwner{
64         emit ownerGone(owner);
65         owner = 0x0;
66     }
67 }
68 contract Haltable is Ownable{
69     bool public paused;
70     event ContractPaused(address by);
71     event ContractUnpaused(address by);
72     constructor(){
73         paused = false;
74     }
75     function pause() public onlyOwner {
76         paused = true;
77         emit ContractPaused(owner);
78     }
79     function unpause() public onlyOwner {
80         paused = false;
81         emit ContractUnpaused(owner);
82     }
83     modifier stopOnPause(){
84         require(paused == false);
85         _;
86     }
87 }
88 contract ERC223Interface is Haltable, ERC20Interface{
89     function transfer(address _to, uint _amount, bytes _data) public returns (bool success);
90     event Transfer(address indexed from, address indexed to, uint tokens, bytes data);
91     event BalanceBurned(address indexed from, uint amount);
92 }
93 
94 
95 contract ABIO is ERC223Interface{
96     using SafeMath for uint256;
97     mapping (address => uint256) balances;
98     mapping (address => mapping (address => uint256)) internal allowed;
99 
100     //Getter functions are defined automatically for the following variables.
101     string public name;
102     string public symbol;
103     uint8 public decimals;
104     uint256 public totalSupply;
105 
106     address ICOAddress;
107     address PICOAddress;
108 
109     constructor(string _name, string _symbol, uint8 _decimals, uint256 _supply) public{
110         name = _name;
111         symbol = _symbol;
112         decimals = _decimals;
113         totalSupply = _supply;
114         balances[msg.sender] = totalSupply;
115     }
116 
117     function supplyPICO(address _preIco) onlyOwner{
118         require(_preIco != 0x0 && PICOAddress == 0x0);
119         PICOAddress = _preIco;
120     }
121     function supplyICO(address _ico) onlyOwner{
122         require(_ico != 0x0 && ICOAddress == 0x0);
123         ICOAddress = _ico;
124     }
125     function burnMyBalance() public {
126         require(msg.sender != 0x0);
127         require(msg.sender == ICOAddress || msg.sender == PICOAddress);
128         uint b = balanceOf(msg.sender);
129         totalSupply = totalSupply.sub(b);
130         balances[msg.sender] = 0;
131         emit BalanceBurned(msg.sender, b);
132     }
133     /**
134      * @notice Underlying transfer function; it is called by public functions later.
135      * @dev This architecture saves >30000 gas as compared to having two independent public functions
136      *      for transfer with and without `_data`.
137      **/
138     function _transfer(address _from, address _to, uint256 _amount, bytes _data) internal returns (bool success){
139         require(_to != 0x0);
140         require(_amount <= balanceOf(_from));
141 
142         uint256 initialBalances = balanceOf(_from).add(balanceOf(_to));
143 
144         balances[_from] = balanceOf(_from).sub(_amount);
145         balances[_to] = balanceOf(_to).add(_amount);
146 
147         if(isContract(_to)){
148             ReceiverContract receiver = ReceiverContract(_to);
149             receiver.tokenFallback(_from, _amount, _data);
150         }
151         assert(initialBalances == balanceOf(_from).add(balanceOf(_to)));
152         return true;
153     }
154 
155     /**
156      * @notice Transfer with addidition data.
157      * @param _data will be sent to tokenFallback() if receiver is a contract.
158      **/
159     function transfer(address _to, uint256 _amount, bytes _data) stopOnPause public returns (bool success){
160         if (_transfer(msg.sender, _to, _amount, _data)){
161             emit Transfer(msg.sender, _to, _amount, _data);
162             return true;
163         }
164         return false;
165     }
166 
167     /**
168      * @notice Transfer without additional data.
169      * @dev An empty `bytes` instance will be created and sent to `tokenFallback()` if receiver is a contract.
170      **/
171     function transfer(address _to, uint256 _amount) stopOnPause public returns (bool success){
172         bytes memory empty;
173         if (_transfer(msg.sender, _to, _amount, empty)){
174             emit Transfer(msg.sender , _to, _amount);
175             return true;
176         }
177         return false;
178     }
179 
180 
181     /**
182      * @notice Transfers `_amount` from `_from` to `_to` without additional data.
183      * @dev Only if `approve` has been called before!
184      * @param _data will be sent to tokenFallback() if receiver is a contract.
185      **/
186     function transferFrom(address _from, address _to, uint256 _amount, bytes _data) stopOnPause public returns (bool success){
187         require(_from != 0x0);
188         require(allowance(_from, msg.sender) >= _amount);
189 
190 
191         allowed[_from][msg.sender] = allowance(_from, msg.sender).sub(_amount);
192         assert(_transfer(_from, _to, _amount, _data));
193         emit Transfer(_from, _to, _amount, _data);
194         return true;
195     }
196 
197     /**
198      * @notice Transfers `_amount` from `_from` to `_to` with additional data.
199      * @dev Only if `approve` has been called before!
200      * @dev An empty `bytes` instance will be created and sent to `tokenFallback()` if receiver is a contract.
201      **/
202     function transferFrom(address _from, address _to, uint256 _amount) stopOnPause  public returns (bool success){
203         require(_from != 0x0);
204         require(allowance(_from, msg.sender) >= _amount);
205 
206         bytes memory empty;
207         allowed[_from][msg.sender] = allowance(_from, msg.sender).sub(_amount);
208         assert(_transfer(_from, _to, _amount, empty));
209         emit Transfer(_from, _to, _amount, empty);
210         return true;
211     }
212 
213     /**
214      * @notice gives `_spender` allowance to spend `amount` from sender's balance.
215      **/
216     function approve(address _spender, uint256 _amount) stopOnPause public returns (bool success){
217         require(_spender != 0x0);
218         allowed[msg.sender][_spender] = _amount;
219         emit Approval(msg.sender, _spender, _amount);
220         return true;
221     }
222 
223 
224     /**
225      * @notice Checks how much a certain user allowed to a different one.
226      **/
227     function allowance(address _owner, address _spender) public view returns (uint256){
228         return allowed[_owner][_spender];
229     }
230 
231     /**
232      * @notice Checks if a contract is behind an address.
233      * @dev Does it by checking if it has ANY code.
234      **/
235     function isContract(address _addr) public view returns(bool is_contract){
236         uint length;
237         assembly {
238             //retrieve the code length/size on target address
239             length := extcodesize(_addr)
240         }
241       return (length>0);
242     }
243 
244     /**
245      * @notice Returns balance of an address.
246      * @dev Returns `0` the address was never seen before.
247      **/
248     function balanceOf(address _addr) public view returns (uint256){
249         return balances[_addr];
250     }
251 }