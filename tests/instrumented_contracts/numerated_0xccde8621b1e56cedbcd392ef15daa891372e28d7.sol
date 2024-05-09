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
84         if(msg.sender != owner){
85             require(paused == false);
86         }
87         _;
88     }
89 }
90 contract ERC223Interface is Haltable, ERC20Interface{
91     function transfer(address _to, uint _amount, bytes _data) public returns (bool success);
92     event Transfer(address indexed from, address indexed to, uint tokens, bytes data);
93 }
94 
95 
96 contract PERA is ERC223Interface{
97     using SafeMath for uint256;
98     mapping (address => uint256) balances;
99     mapping (address => mapping (address => uint256)) internal allowed;
100 
101     //Getter functions are defined automatically for the following variables.
102     string public name;
103     string public symbol;
104     uint8 public decimals;
105     uint256 public totalSupply;
106 
107     constructor(string _name, string _symbol, uint8 _decimals, uint256 _supply) public{
108         name = _name;
109         symbol = _symbol;
110         decimals = _decimals;
111         totalSupply = _supply;
112         balances[msg.sender] = totalSupply;
113     }
114     /**
115      * @notice Underlying transfer function; it is called by public functions later.
116      * @dev This architecture saves >30000 gas as compared to having two independent public functions
117      *      for transfer with and without `_data`.
118      **/
119     function _transfer(address _from, address _to, uint256 _amount, bytes _data) internal returns (bool success){
120         require(_to != 0x0);
121         require(_amount <= balanceOf(_from));
122 
123         uint256 initialBalances = balanceOf(_from).add(balanceOf(_to));
124 
125         balances[_from] = balanceOf(_from).sub(_amount);
126         balances[_to] = balanceOf(_to).add(_amount);
127 
128         if(isContract(_to)){
129             ReceiverContract receiver = ReceiverContract(_to);
130             receiver.tokenFallback(_from, _amount, _data);
131         }
132         assert(initialBalances == balanceOf(_from).add(balanceOf(_to)));
133         return true;
134     }
135 
136     /**
137      * @notice Transfer with addidition data.
138      * @param _data will be sent to tokenFallback() if receiver is a contract.
139      **/
140     function transfer(address _to, uint256 _amount, bytes _data) stopOnPause public returns (bool success){
141         if (_transfer(msg.sender, _to, _amount, _data)){
142             emit Transfer(msg.sender, _to, _amount, _data);
143             return true;
144         }
145         return false;
146     }
147 
148     /**
149      * @notice Transfer without additional data.
150      * @dev An empty `bytes` instance will be created and sent to `tokenFallback()` if receiver is a contract.
151      **/
152     function transfer(address _to, uint256 _amount) stopOnPause public returns (bool success){
153         bytes memory empty;
154         if (_transfer(msg.sender, _to, _amount, empty)){
155             emit Transfer(msg.sender , _to, _amount);
156             return true;
157         }
158         return false;
159     }
160 
161 
162     /**
163      * @notice Transfers `_amount` from `_from` to `_to` without additional data.
164      * @dev Only if `approve` has been called before!
165      * @param _data will be sent to tokenFallback() if receiver is a contract.
166      **/
167     function transferFrom(address _from, address _to, uint256 _amount, bytes _data) stopOnPause public returns (bool success){
168         require(_from != 0x0);
169         require(allowance(_from, msg.sender) >= _amount);
170 
171 
172         allowed[_from][msg.sender] = allowance(_from, msg.sender).sub(_amount);
173         assert(_transfer(_from, _to, _amount, _data));
174         emit Transfer(_from, _to, _amount, _data);
175         return true;
176     }
177 
178     /**
179      * @notice Transfers `_amount` from `_from` to `_to` with additional data.
180      * @dev Only if `approve` has been called before!
181      * @dev An empty `bytes` instance will be created and sent to `tokenFallback()` if receiver is a contract.
182      **/
183     function transferFrom(address _from, address _to, uint256 _amount) stopOnPause  public returns (bool success){
184         require(_from != 0x0);
185         require(allowance(_from, msg.sender) >= _amount);
186 
187         bytes memory empty;
188         allowed[_from][msg.sender] = allowance(_from, msg.sender).sub(_amount);
189         assert(_transfer(_from, _to, _amount, empty));
190         emit Transfer(_from, _to, _amount, empty);
191         return true;
192     }
193 
194     /**
195      * @notice gives `_spender` allowance to spend `amount` from sender's balance.
196      **/
197     function approve(address _spender, uint256 _amount) stopOnPause public returns (bool success){
198         require(_spender != 0x0);
199         allowed[msg.sender][_spender] = _amount;
200         emit Approval(msg.sender, _spender, _amount);
201         return true;
202     }
203 
204 
205     /**
206      * @notice Checks how much a certain user allowed to a different one.
207      **/
208     function allowance(address _owner, address _spender) public view returns (uint256){
209         return allowed[_owner][_spender];
210     }
211 
212     /**
213      * @notice Checks if a contract is behind an address.
214      * @dev Does it by checking if it has ANY code.
215      **/
216     function isContract(address _addr) public view returns(bool is_contract){
217         uint length;
218         assembly {
219             //retrieve the code length/size on target address
220             length := extcodesize(_addr)
221         }
222       return (length>0);
223     }
224 
225     /**
226      * @notice Returns balance of an address.
227      * @dev Returns `0` the address was never seen before.
228      **/
229     function balanceOf(address _addr) public view returns (uint256){
230         return balances[_addr];
231     }
232 }