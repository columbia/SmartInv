1 pragma solidity >=0.5.1 < 0.6.0;
2 
3 library SafeMath {
4     function mul(uint256 a, uint256 b) internal pure returns (uint256) {
5         if (a == 0) { return 0; }
6         uint256 c = a * b;
7         require(c / a == b);
8         return c;
9     }
10 
11     function div(uint256 a, uint256 b) internal pure returns (uint256) {
12         require(b > 0);
13         uint256 c = a / b;
14         return c;
15     }
16 
17     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
18         require(b <= a);
19         uint256 c = a - b;
20         return c;
21     }
22 
23     function add(uint256 a, uint256 b) internal pure returns (uint256) {
24         uint256 c = a + b;
25         require(c >= a);
26         return c;
27     }
28 
29     function mod(uint256 a, uint256 b) internal pure returns (uint256) {
30         require(b != 0);
31         return a % b;
32     }
33 }
34 
35 interface ERC20 {
36   function balanceOf(address _who) external view returns (uint256);
37   function transfer(address _to, uint256 _value) external returns (bool);
38   function allowance(address _owner, address _spender) external view returns (uint256);
39   function transferFrom(address _from, address _to, uint256 _value) external returns (bool);
40   function approve(address _spender, uint256 _value) external returns (bool);
41   event Transfer(address indexed from, address indexed to, uint256 value);
42   event Approval(address indexed owner, address indexed spender, uint256 value);
43 }
44 
45 interface ERC223 {
46     function transfer(address _to, uint _value, bytes calldata _data) external;
47     event Transfer(address indexed from, address indexed to, uint value, bytes indexed data);
48 }
49 
50 contract ERC223ReceivingContract { 
51     function tokenFallback(address _from, uint _value, bytes memory _data) public;
52 }
53 
54 contract Ownable {
55     
56     address private _owner;
57 
58     event OwnershipTransferred(address indexed previousPrimary, address indexed newPrimary);
59 
60     constructor () internal {
61         _owner = msg.sender;
62         emit OwnershipTransferred(address(0), _owner);
63     }
64 
65     function owner() public view returns (address) {
66         return _owner;
67     }
68     
69     modifier onlyOwner() {
70         require(isOwner(), "Ownable: caller is not the owner of contract");
71         _;
72     }
73     
74     function isOwner() public view returns (bool) {
75         return msg.sender == _owner;
76     }
77     
78     //------------------------- Main Ownership Transfer Functions -------------------------
79 
80     function transferOwnership(address newOwner) public onlyOwner {
81         _transferOwnership(newOwner);
82     }
83     
84     function _transferOwnership(address newOwner) internal {
85         require(newOwner != address(0), "Ownable: new owner is the zero address");
86         emit OwnershipTransferred(_owner, newOwner);
87         _owner = newOwner;
88     }
89     
90 }
91 
92 contract BaseERC223 is ERC20, ERC223{
93     using SafeMath for uint256;
94     
95     string internal _name;
96     string internal _symbol;
97     uint8 internal _decimals;
98     uint256 internal _totalSupply;
99     
100     mapping (address => uint256) balances;
101     mapping (address => mapping (address => uint256)) allowed;
102 
103     function name() public view returns (string memory) { return _name; }
104 
105     function symbol()public view returns (string memory) { return _symbol; }
106 
107     function decimals()public view returns (uint8) { return _decimals; }
108 
109     function totalSupply()public view returns (uint256) { return _totalSupply; }
110     
111     // ------------------------- ERC20 Functions -------------------------
112     
113     function balanceOf(address _owner) public view returns (uint256 balance) {
114         return balances[_owner];
115     }
116     
117     // Transfer ERC20 with ERC223 security compability
118     function transfer(address _to, uint256 _value) public returns (bool) {             
119         require(_to != address(0));
120         require(_value <= balances[msg.sender]);
121         uint codeLength;
122         bytes memory empty;
123         assembly {
124             codeLength := extcodesize(_to)
125         }
126         balances[msg.sender] = balances[msg.sender].sub(_value);
127         balances[_to] = balances[_to].add(_value);
128         // Check to see if receiver is contract
129         if(codeLength>0) { 
130             ERC223ReceivingContract receiver = ERC223ReceivingContract(_to);
131             receiver.tokenFallback(msg.sender, _value, empty);
132         }
133         emit Transfer(msg.sender, _to, _value);
134         return true;
135     }
136     
137     function transferFrom(address _from, address _to, uint256 _value) public returns (bool) {
138         require(_to != address(0));
139         require(_value <= balances[_from]);
140         require(_value <= allowed[_from][msg.sender]);
141 
142         balances[_from] = SafeMath.sub(balances[_from], _value);
143         balances[_to] = SafeMath.add(balances[_to], _value);
144         allowed[_from][msg.sender] = SafeMath.sub(allowed[_from][msg.sender], _value);
145         emit Transfer(_from, _to, _value);
146         return true;
147     }
148     
149     function approve(address _spender, uint256 _value) public returns (bool) {
150         allowed[msg.sender][_spender] = _value;
151         emit Approval(msg.sender, _spender, _value);
152         return true;
153     }
154 
155     function allowance(address _owner, address _spender) public view returns (uint256) {
156         return allowed[_owner][_spender];
157     }
158    
159    // ------------------------- ERC223 Functions -------------------------
160    
161    function transfer(address _to, uint _value, bytes memory _data) public {
162     require(_value > 0 );
163         if(isContract(_to)) {
164             ERC223ReceivingContract receiver = ERC223ReceivingContract(_to);
165             receiver.tokenFallback(msg.sender, _value, _data);
166         }
167         balances[msg.sender] = balances[msg.sender].sub(_value);
168         balances[_to] = balances[_to].add(_value);
169         emit Transfer(msg.sender, _to, _value, _data);
170     }
171     
172     function isContract(address _addr) private view returns (bool is_contract) {
173         uint length;
174         assembly {
175             //retrieve the size of the code on target address, this needs assembly
176             length := extcodesize(_addr)
177         }
178         return (length>0);
179     }
180     
181     // ------------------------- Extra Functions -------------------------
182     
183      function increaseApproval(address _spender, uint256 _addedValue) public returns (bool) {
184         allowed[msg.sender][_spender] = SafeMath.add(allowed[msg.sender][_spender], _addedValue);
185         emit Approval(msg.sender, _spender, allowed[msg.sender][_spender]);
186         return true;
187     }
188 
189     function decreaseApproval(address _spender, uint256 _subtractedValue) public returns (bool) {
190         uint256 oldValue = allowed[msg.sender][_spender];
191         if (_subtractedValue > oldValue) {
192            allowed[msg.sender][_spender] = 0;
193         } else {
194            allowed[msg.sender][_spender] = SafeMath.sub(oldValue, _subtractedValue);
195         }
196         emit Approval(msg.sender, _spender, allowed[msg.sender][_spender]);
197         return true;
198     }
199    
200     // ------------------------- Internal Functions -------------------------
201     
202     function _convertToWei (uint256 _val) internal view returns (uint256){
203         return (_val * 10**uint256(decimals()));
204     }
205 }
206 
207 contract LIFEX is BaseERC223, Ownable{
208     
209     bool internal hasDistributed = false;
210     bool internal hasSecondaryOwnership = false;
211     address[] internal distAddr;
212     uint256[] internal distBal;
213     
214     // ---------------------------------------------------------------
215     // ------------------------- Constructor -------------------------
216     constructor() public {
217         _name = "LIFEX";
218         _symbol = "LFX";
219         _decimals = 18;
220         _totalSupply = _convertToWei(2222222222);
221         
222         balances[msg.sender] = _totalSupply;
223         
224         emit Transfer(address(0x0), msg.sender, _totalSupply);
225     }
226     
227     // ------------------------- Distribute Functions -------------------------
228     // -- functions that are meant for distribution purposes, can set until token are distributed (only once)
229     
230     // ** set addresses that needs the token to be distrubuted later, token value input in whole number
231     function addDistributionAddresses(address _distAddress, uint256 _distToken) public onlyOwner {
232         require(!hasDistributed);
233         _addDistributeChecks(_distAddress, _distToken);
234         distAddr.push(_distAddress);
235         distBal.push(_convertToWei(_distToken));
236     }
237     
238     // ** after executing this contract, distribute functions will be disabled and unused, and all distribution data will be deleted
239     // ** note that make sure all data has been inputted before executing this function
240     function distributeToAddresses() public onlyOwner{
241         require(!hasDistributed);
242         require(distAddr.length != 0);
243         for(uint256 i = 0; i < distAddr.length; i++){
244             transfer(distAddr[i], distBal[i]);
245         }
246         hasDistributed = true;
247         _deleteDistData();
248     }
249     
250     // ** call status of distribution have been made or not
251     function hasDistribute() public view onlyOwner returns (bool){
252         return hasDistributed;
253     }
254     
255     // ** list all data for addresses and amount of token to be distributed
256     function listDistributionData() public view onlyOwner returns (address[] memory, uint256[] memory){
257         return (distAddr, distBal);
258     }
259     
260     // ------------------------- Internal Functions -------------------------
261     // -- internal functions are hidden from public and used for checks and smaller functions to save gas
262     
263     // ** checks on adding address to distribution data
264     function _addDistributeChecks(address _a, uint256 _v) internal pure {
265         require(_a != address(0));
266         require(_v > 0);
267     }
268     
269     // ** distribution data deletion
270     function _deleteDistData() internal {
271         delete distAddr;
272         delete distBal;
273     }
274     
275 }