1 pragma solidity ^0.4.20;
2 
3 //standart library for uint
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
35 //standart contract to identify owner
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
47   function Ownable() public {
48     owner = msg.sender;
49   }
50 
51   function transferOwnership(address _newOwner) public onlyOwner {
52     require(_newOwner != address(0));
53     newOwner = _newOwner;
54   }
55 
56   function acceptOwnership() public {
57     if (msg.sender == newOwner) {
58       owner = newOwner;
59     }
60   }
61 }
62 
63 contract DatareumToken is Ownable { //ERC - 20 token contract
64   using SafeMath for uint;
65   // Triggered when tokens are transferred.
66   event Transfer(address indexed _from, address indexed _to, uint256 _value);
67 
68   // Triggered whenever approve(address _spender, uint256 _value) is called.
69   event Approval(address indexed _owner, address indexed _spender, uint256 _value);
70 
71   string public constant symbol = "DTN";
72   string public constant name = "Datareum";
73   uint8 public constant decimals = 18;
74   uint256 _totalSupply = 1000000000 ether;
75 
76   // Owner of this contract
77   address public owner;
78 
79   // Balances for each account
80   mapping(address => uint256) balances;
81 
82   // Owner of account approves the transfer of an amount to another account
83   mapping(address => mapping (address => uint256)) allowed;
84 
85   function totalSupply() public view returns (uint256) { //standart ERC-20 function
86     return _totalSupply;
87   }
88 
89   function balanceOf(address _address) public view returns (uint256 balance) {//standart ERC-20 function
90     return balances[_address];
91   }
92   
93   bool public locked = true;
94   bool public canChangeLocked = true;
95 
96   function changeLockTransfer (bool _request) public onlyOwner {
97     require(canChangeLocked);
98     locked = _request;
99   }
100 
101   function finalUnlockTransfer () public {
102     require (now > finishDate + 4 weeks);
103     locked = false;
104     canChangeLocked = false;
105   }
106   
107   //standart ERC-20 function
108   function transfer(address _to, uint256 _amount) public returns (bool success) {
109     require(this != _to);
110     require (_to != address(0));
111     require(!locked);
112     balances[msg.sender] = balances[msg.sender].sub(_amount);
113     balances[_to] = balances[_to].add(_amount);
114     emit Transfer(msg.sender,_to,_amount);
115     return true;
116   }
117 
118   //standart ERC-20 function
119   function transferFrom(address _from, address _to, uint256 _amount) public returns(bool success){
120     require(this != _to);
121     require (_to != address(0));
122     require(!locked);
123     balances[_from] = balances[_from].sub(_amount);
124     allowed[_from][msg.sender] = allowed[_from][msg.sender].sub(_amount);
125     balances[_to] = balances[_to].add(_amount);
126     emit Transfer(_from,_to,_amount);
127     return true;
128   }
129   //standart ERC-20 function
130   function approve(address _spender, uint256 _amount)public returns (bool success) { 
131     allowed[msg.sender][_spender] = _amount;
132     emit Approval(msg.sender, _spender, _amount);
133     return true;
134   }
135 
136   //standart ERC-20 function
137   function allowance(address _owner, address _spender)public constant returns (uint256 remaining) {
138     return allowed[_owner][_spender];
139   }
140 
141   //Constructor
142   function DatareumToken() public {
143     owner = 0x6563Cc78478Df92097F7A666Db7f70EeA9481C2e;
144     balances[this] = _totalSupply;
145   }
146 
147   address public crowdsaleContract;
148 
149   function setCrowdsaleContract (address _address) public{
150     require(crowdsaleContract == address(0));
151 
152     crowdsaleContract = _address;
153   }
154 
155   function endICO (uint _date) public {
156     require(msg.sender == crowdsaleContract);
157     balances[this] = balances[this].sub(crowdsaleBalance);
158     emit Transfer(this,0,crowdsaleBalance);
159     
160     crowdsaleBalance = 0;
161     finishDate = _date;
162   }
163 
164   uint public finishDate = 1893456000;
165   
166   uint public crowdsaleBalance = 600000000 ether;
167   
168   function sendCrowdsaleTokens (address _address, uint _value) public {
169     require(msg.sender == crowdsaleContract);
170 
171     balances[this] = balances[this].sub(_value);
172     balances[_address] = balances[_address].add(_value);
173     
174     crowdsaleBalance = crowdsaleBalance.sub(_value);
175     
176     emit Transfer(this,_address,_value);    
177   }
178 
179   uint public advisorsBalance = 200000000 ether;
180   uint public foundersBalance = 100000000 ether;
181   uint public futureFundingBalance = 50000000 ether;
182   uint public bountyBalance = 50000000 ether;
183 
184   function sendAdvisorsBalance (address[] _addresses, uint[] _values) external onlyOwner {
185     require(crowdsaleBalance == 0);
186     uint buffer = 0;
187     for(uint i = 0; i < _addresses.length; i++){
188       balances[_addresses[i]] = balances[_addresses[i]].add(_values[i]);
189       buffer = buffer.add(_values[i]);
190       emit Transfer(this,_addresses[i],_values[i]);
191     }
192     advisorsBalance = advisorsBalance.sub(buffer);
193     balances[this] = balances[this].sub(buffer);
194   }
195   
196   function sendFoundersBalance (address[] _addresses, uint[] _values) external onlyOwner {
197     require(crowdsaleBalance == 0);
198     require(now > finishDate + 1 years);
199 
200     uint buffer = 0;
201     for(uint i = 0; i < _addresses.length; i++){
202       balances[_addresses[i]] = balances[_addresses[i]].add(_values[i]);
203       buffer = buffer.add(_values[i]);
204       emit Transfer(this,_addresses[i],_values[i]);
205     }
206     foundersBalance = foundersBalance.sub(buffer);
207     balances[this] = balances[this].sub(buffer);
208   }
209 
210   function sendFutureFundingBalance (address[] _addresses, uint[] _values) external onlyOwner {
211     require(crowdsaleBalance == 0);
212     require(now > finishDate + 2 years);
213 
214     uint buffer = 0;
215     for(uint i = 0; i < _addresses.length; i++){
216       balances[_addresses[i]] = balances[_addresses[i]].add(_values[i]);
217       buffer = buffer.add(_values[i]);
218       emit Transfer(this,_addresses[i],_values[i]);
219     }
220     futureFundingBalance = futureFundingBalance.sub(buffer);
221     balances[this] = balances[this].sub(buffer);
222   }
223 
224   uint public constant PRE_ICO_FINISH = 1525737540;
225 
226   mapping (address => bool) public bountyAddresses;
227 
228   function addBountyAddresses (address[] _addresses) external onlyOwner {
229     for (uint i = 0; i < _addresses.length; i++){
230       bountyAddresses[_addresses[i]] = true;
231     }
232   }
233 
234   function removeBountyAddresses (address[] _addresses) external onlyOwner {
235     for (uint i = 0; i < _addresses.length; i++){
236       bountyAddresses[_addresses[i]] = false;
237     }
238   }
239 
240   function sendBountyBalance (address[] _addresses, uint[] _values) external {
241     require(now >= PRE_ICO_FINISH);
242     require (bountyAddresses[msg.sender]);
243 
244     uint buffer = 0;
245     for(uint i = 0; i < _addresses.length; i++){
246       balances[_addresses[i]] = balances[_addresses[i]].add(_values[i]);
247       buffer = buffer.add(_values[i]);
248       emit Transfer(this,_addresses[i],_values[i]);
249     }
250     bountyBalance = bountyBalance.sub(buffer);
251     balances[this] = balances[this].sub(buffer);
252   }
253 }