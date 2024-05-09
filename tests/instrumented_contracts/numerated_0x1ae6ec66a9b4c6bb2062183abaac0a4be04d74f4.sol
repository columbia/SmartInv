1 pragma solidity ^0.4.22;
2 
3 //standard library for uint
4 library SafeMath { 
5   function mul(uint256 a, uint256 b) internal pure returns (uint256) {
6     if (a == 0 || b == 0){
7         return 0;
8     }
9     uint256 c = a * b;
10     assert(c / a == b);
11     return c;
12   }
13 
14   function sub(uint256 a, uint256 b) internal pure returns (uint256) {
15     assert(b <= a);
16     return a - b;
17   }
18 
19   function add(uint256 a, uint256 b) internal pure returns (uint256) {
20     uint256 c = a + b;
21     assert(c >= a);
22     return c;
23   }
24 
25   function pow(uint256 a, uint256 b) internal pure returns (uint256){ //power function
26     if (b == 0){
27       return 1;
28     }
29     uint256 c = a**b;
30     assert (c >= a);
31     return c;
32   }
33 }
34 
35 //standard contract to identify owner
36 contract Ownable {
37 
38   address public owner;
39 
40   address public newOwner;
41 
42   modifier onlyOwner() {
43     require(msg.sender == owner);
44     _;
45   }
46 
47   function transferOwnership(address _newOwner) public onlyOwner {
48     require(_newOwner != address(0));
49     newOwner = _newOwner;
50   }
51 
52   function acceptOwnership() public {
53     if (msg.sender == newOwner) {
54       owner = newOwner;
55     }
56   }
57 }
58 contract SHAREToken is Ownable { //ERC - 20 token contract
59   using SafeMath for uint;
60   // Triggered when tokens are transferred.
61   event Transfer(address indexed _from, address indexed _to, uint256 _value);
62 
63   // Triggered whenever approve(address _spender, uint256 _value) is called.
64   event Approval(address indexed _owner, address indexed _spender, uint256 _value);
65 
66   string public constant symbol = "SVX";
67   string public constant name = "SHARE";
68   uint8 public constant decimals = 6;
69   uint256 _totalSupply = 200000000 * ((uint)(10) ** (uint)(decimals)); //include decimals;
70 
71   // Balances for each account
72   mapping(address => uint256) balances;
73 
74   // Owner of account approves the transfer of an amount to another account
75   mapping(address => mapping (address => uint256)) allowed;
76 
77   function totalSupply() public view returns (uint256) { //standard ERC-20 function
78     return _totalSupply;
79   }
80 
81   function balanceOf(address _address) public view returns (uint256 balance) {//standard ERC-20 function
82     return balances[_address];
83   }
84   
85   bool public locked = true;
86   function changeLockTransfer (bool _request) public onlyOwner {
87     locked = _request;
88   }
89   
90   //standard ERC-20 function
91   function transfer(address _to, uint256 _amount) public returns (bool success) {
92     require(this != _to && _to != address(0));
93     require(!locked);
94     balances[msg.sender] = balances[msg.sender].sub(_amount);
95     balances[_to] = balances[_to].add(_amount);
96     emit Transfer(msg.sender,_to,_amount);
97     return true;
98   }
99 
100   //standard ERC-20 function
101   function transferFrom(address _from, address _to, uint256 _amount) public returns(bool success){
102     require(this != _to && _to != address(0));
103     require(!locked);
104     balances[_from] = balances[_from].sub(_amount);
105     allowed[_from][msg.sender] = allowed[_from][msg.sender].sub(_amount);
106     balances[_to] = balances[_to].add(_amount);
107     emit Transfer(_from,_to,_amount);
108     return true;
109   }
110 
111   //standard ERC-20 function
112   function approve(address _spender, uint256 _amount)public returns (bool success) { 
113     allowed[msg.sender][_spender] = _amount;
114     emit Approval(msg.sender, _spender, _amount);
115     return true;
116   }
117 
118   //standard ERC-20 function
119   function allowance(address _owner, address _spender)public constant returns (uint256 remaining) {
120     return allowed[_owner][_spender];
121   }
122 
123   address public tokenHolder;
124   
125   constructor() public {
126     owner = 0x4fD26ff0Af100C017BEA88Bd6007FcB68C237960;
127     tokenHolder = 0x4fD26ff0Af100C017BEA88Bd6007FcB68C237960;
128     balances[tokenHolder] = _totalSupply;
129     emit Transfer(address(this), tokenHolder, _totalSupply);
130   }
131 
132   address public crowdsaleContract;
133 
134   function setCrowdsaleContract (address _address) public{
135     require(crowdsaleContract == address(0));
136 
137     crowdsaleContract = _address;
138   }
139 
140   uint public crowdsaleBalance = 120000000 * ((uint)(10) ** (uint)(decimals)); //include decimals;
141   
142   function sendCrowdsaleTokens (address _address, uint _value) public {
143     require(msg.sender == crowdsaleContract);
144 
145     balances[tokenHolder] = balances[tokenHolder].sub(_value);
146     balances[_address] = balances[_address].add(_value);
147     
148     crowdsaleBalance = crowdsaleBalance.sub(_value);
149     
150     emit Transfer(tokenHolder,_address,_value);    
151   }
152 
153   uint public teamBalance = 20000000 * ((uint)(10) ** (uint)(decimals)); 
154   uint public foundersBalance = 40000000 * ((uint)(10) ** (uint)(decimals));
155   uint public platformReferral = 10000000 * ((uint)(10) ** (uint)(decimals));
156   uint public bountyBalance = 6000000 * ((uint)(10) ** (uint)(decimals));
157   uint public advisorsBalance = 4000000 * ((uint)(10) ** (uint)(decimals));
158 
159   function sendTeamBalance (address[] _addresses, uint[] _values) external onlyOwner {
160     uint buffer = 0;
161     for(uint i = 0; i < _addresses.length; i++){
162       balances[_addresses[i]] = balances[_addresses[i]].add(_values[i]);
163       buffer = buffer.add(_values[i]);
164       emit Transfer(tokenHolder,_addresses[i],_values[i]);
165     }
166     teamBalance = teamBalance.sub(buffer);
167     balances[tokenHolder] = balances[tokenHolder].sub(buffer);
168   }
169 
170   function sendFoundersBalance (address[] _addresses, uint[] _values) external onlyOwner {
171     uint buffer = 0;
172     for(uint i = 0; i < _addresses.length; i++){
173       balances[_addresses[i]] = balances[_addresses[i]].add(_values[i]);
174       buffer = buffer.add(_values[i]);
175       emit Transfer(tokenHolder,_addresses[i],_values[i]);
176     }
177     foundersBalance = foundersBalance.sub(buffer);
178     balances[tokenHolder] = balances[tokenHolder].sub(buffer);
179   }
180 
181   function platformReferralBalance (address[] _addresses, uint[] _values) external onlyOwner {
182     uint buffer = 0;
183     for(uint i = 0; i < _addresses.length; i++){
184       balances[_addresses[i]] = balances[_addresses[i]].add(_values[i]);
185       buffer = buffer.add(_values[i]);
186       emit Transfer(tokenHolder,_addresses[i],_values[i]);
187     }
188     platformReferral = platformReferral.sub(buffer);
189     balances[tokenHolder] = balances[tokenHolder].sub(buffer);
190   }
191 
192   function sendBountyBalance (address[] _addresses, uint[] _values) external onlyOwner {
193     uint buffer = 0;
194     for(uint i = 0; i < _addresses.length; i++){
195       balances[_addresses[i]] = balances[_addresses[i]].add(_values[i]);
196       buffer = buffer.add(_values[i]);
197       emit Transfer(tokenHolder,_addresses[i],_values[i]);
198     }
199     bountyBalance = bountyBalance.sub(buffer);
200     balances[tokenHolder] = balances[tokenHolder].sub(buffer);
201   }
202 
203   function sendAdvisorsBalance (address[] _addresses, uint[] _values) external onlyOwner {
204     uint buffer = 0;
205     for(uint i = 0; i < _addresses.length; i++){
206       balances[_addresses[i]] = balances[_addresses[i]].add(_values[i]);
207       buffer = buffer.add(_values[i]);
208       emit Transfer(tokenHolder,_addresses[i],_values[i]);
209     }
210     advisorsBalance = advisorsBalance.sub(buffer);
211     balances[tokenHolder] = balances[tokenHolder].sub(buffer);
212   }
213 
214   function burnTokens (uint _value) external {
215     balances[msg.sender] = balances[msg.sender].sub(_value);
216     emit Transfer(msg.sender, 0, _value);
217     _totalSupply = _totalSupply.sub(_value);
218   }
219 
220   function burnUnsoldTokens () public onlyOwner {
221     balances[tokenHolder] = balances[tokenHolder].sub(crowdsaleBalance);
222     emit Transfer(address(tokenHolder), 0, crowdsaleBalance);
223     _totalSupply = _totalSupply.sub(crowdsaleBalance);
224     crowdsaleBalance = 0;
225   }
226 
227 }