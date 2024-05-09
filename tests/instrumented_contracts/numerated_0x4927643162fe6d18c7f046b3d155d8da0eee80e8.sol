1 pragma solidity ^0.5.8;
2 
3 library SafeMath {
4 
5   function mul(uint256 a, uint256 b) internal pure returns (uint256) {
6     if (a == 0) {
7       return 0;
8     }
9     uint256 c = a * b;
10     require(c / a == b);
11     return c;
12   }
13 
14   function div(uint256 a, uint256 b) internal pure returns (uint256) {
15     require(b > 0);
16     uint256 c = a / b;
17     return c;
18   }
19 
20   function sub(uint256 a, uint256 b) internal pure returns (uint256) {
21     require(b <= a);
22     uint256 c = a - b;
23     return c;
24   }
25 
26   function add(uint256 a, uint256 b) internal pure returns (uint256) {
27     uint256 c = a + b;
28     require(c >= a);
29     return c;
30   }
31 
32 }
33 
34 interface IERC20 {
35   function totalSupply() external view returns (uint256);
36   function balanceOf(address who) external view returns (uint256);
37   function allowance(address owner, address spender) external view returns (uint256);
38   function transfer(address to, uint256 value) external returns (bool);
39   function approve(address spender, uint256 value) external returns (bool);
40   function transferFrom(address from, address to, uint256 value) external returns (bool);
41   event Transfer(address indexed from,address indexed to,uint256 value);
42   event Approval(address indexed owner,address indexed spender,uint256 value);
43 }
44 
45 contract Owned {
46   address owner;
47   constructor () public {
48     owner = msg.sender;
49   }
50   modifier onlyOwner {
51     require(msg.sender == owner,"Only owner can do it.");
52     _;
53   }
54 }
55 
56 contract IGCToken is IERC20 , Owned{
57 
58   string public constant name = "IGCcoin";
59   string public constant symbol = "IGC";
60   uint8 public constant decimals = 18;
61 
62   uint256 private constant INITIAL_SUPPLY = 1000000000 * (10 ** uint256(decimals));
63 
64   uint256 public role1_balance = INITIAL_SUPPLY.mul(4).div(100);
65 
66   using SafeMath for uint256;
67 
68   mapping (address => uint256) private _balances;
69 
70   mapping (address => mapping (address => uint256)) private _allowed;
71 
72   uint256 private _totalSupply;
73 
74   uint256 public beginTime = 1559361600;
75 
76   function setBeginTime(uint256 _begin) onlyOwner public{
77     beginTime = _begin;
78   }
79 
80   struct Role {
81     uint256 releaseTime;
82     uint256 nolockRate;
83     uint256 releaseRate;
84   }
85 
86   struct Account {
87     uint8 roleType;
88     uint256 ownAmount;
89     uint256 releasedAmount;
90   }
91 
92   mapping(address => Account) private accountMapping;
93 
94   mapping(address => bool) private nolockReleasedMapping;
95 
96   mapping(address => uint256) private releasedRateMapping;
97 
98   function allocateTokenByType(address accountAddress,uint256 amount,uint8 roleType) onlyOwner public {
99     require(accountAddress != address(0x0), "accountAddress not right");
100     require(roleType <=5 ,"roleType must be 0~5");
101     require(now < beginTime ,"beginTime <= now, so can not set");
102 
103     amount = amount.mul(10 ** uint256(decimals));
104     Account memory _account = accountMapping[accountAddress];
105     if(_account.ownAmount == 0){
106          accountMapping[accountAddress] = Account(roleType,amount,0);
107     }else{
108         require(roleType == _account.roleType ,"roleType must be same!");
109         accountMapping[accountAddress].ownAmount = _account.ownAmount.add(amount);
110         accountMapping[accountAddress].releasedAmount = 0;
111         delete nolockReleasedMapping[accountAddress];
112         delete releasedRateMapping[accountAddress];
113     }
114     _balances[accountAddress] = _balances[accountAddress].add(amount);
115     _balances[msg.sender] = _balances[msg.sender].sub(amount);
116     if(roleType == 1){
117         role1_balance = role1_balance.sub(amount);
118     }
119     releaseToken(accountAddress);
120   }
121 
122   event Burn(address indexed from, uint256 value);
123 
124   function burn(uint256 _value, uint8 _roleType) onlyOwner public returns (bool success) {
125     require(_value > 0, "_value > 0");
126     _value = _value.mul(10 ** uint256(decimals));
127     require(_balances[msg.sender] >= _value);
128     _balances[msg.sender] = _balances[msg.sender].sub(_value);
129     _totalSupply = _totalSupply.sub(_value);
130     if(_roleType == 1){
131         role1_balance = role1_balance.sub(_value);
132     }
133     emit Burn(msg.sender, _value);
134     return true;
135   }
136 
137   function releaseToken(address accountAddress) private returns (bool) {
138     require(accountAddress != address(0x0), "accountAddress not right");
139 
140     Account memory _account = accountMapping[accountAddress];
141     if(_account.ownAmount == 0){
142       return true;
143     }
144     if(_account.releasedAmount == _account.ownAmount){
145       return true;
146     }
147     uint256 _releasedAmount = 0;
148     uint256 releaseTime;
149     uint256 nolockRate;
150     uint256 releaseRate;
151     (releaseTime,nolockRate,releaseRate) = getRoles(_account.roleType);
152 
153     if(nolockRate > 0 && nolockReleasedMapping[accountAddress] != true){
154       _releasedAmount = _releasedAmount.add(_account.ownAmount.mul(nolockRate).div(100));
155       nolockReleasedMapping[accountAddress] = true;
156     }
157     if(releaseTime <= now){
158       uint256 _momth = now.sub(releaseTime).div(30 days).add(1);
159       if(releasedRateMapping[accountAddress] <=  _momth) {
160         _releasedAmount = _releasedAmount.add(_account.ownAmount.mul(_momth-releasedRateMapping[accountAddress]).mul(releaseRate).div(100));
161         releasedRateMapping[accountAddress] = _momth;
162       }
163     }
164     if(_releasedAmount > 0){
165         if(accountMapping[accountAddress].releasedAmount.add(_releasedAmount) <= _account.ownAmount){
166             accountMapping[accountAddress].releasedAmount = accountMapping[accountAddress].releasedAmount.add(_releasedAmount);
167         }else{
168             accountMapping[accountAddress].releasedAmount = _account.ownAmount;
169         }
170       
171     }
172     return true;
173   }
174 
175   function getRoles(uint8 _type) private pure returns(uint256,uint256,uint256) {
176     require(_type <= 5);
177     if(_type == 0){
178       return (1559361600,0,100);
179     }
180     if(_type == 1){
181       return (1564632000,0,10);
182     }
183     if(_type == 2){
184       return (1575172800,0,2);
185     }
186     if(_type == 3){
187       return (1567310400,20,10);
188     }
189     if(_type == 4){
190       return (1559361600,10,5);
191     }
192     if(_type == 5){
193       return (1559361600,0,100);
194     }
195   }
196   
197   constructor() public {
198     _mint(msg.sender, INITIAL_SUPPLY);
199   }
200 
201   function _mint(address account, uint256 value) internal {
202     require(account != address(0x0));
203     _totalSupply = _totalSupply.add(value);
204     _balances[account] = _balances[account].add(value);
205     emit Transfer(address(0), account, value);
206   }
207   
208   function totalSupply() public view returns (uint256) {
209     return _totalSupply;
210   }
211 
212   function balanceOf(address owner) public view returns (uint256) {
213     return _balances[owner];
214   }
215 
216   function allowance(
217     address owner,
218     address spender
219    )
220     public
221     view
222     returns (uint256)
223   {
224     return _allowed[owner][spender];
225   }
226 
227   function transfer(address to, uint256 value) public returns (bool) {
228     if(_canTransfer(msg.sender,value)){ 
229       _transfer(msg.sender, to, value);
230       return true;
231     } else {
232       return false;
233     }
234   }
235 
236   function _canTransfer(address from,uint256 _amount) private returns (bool) {
237     if(now < beginTime){
238       return false;
239     }
240     if((balanceOf(from))<=0){
241       return false;
242     }
243     releaseToken(from);
244     Account memory _account = accountMapping[from];
245     if(_account.ownAmount == 0){
246       return true;
247     }
248     
249     if(balanceOf(from).sub(_amount) < _account.ownAmount.sub(_account.releasedAmount)){
250       return false;
251     }
252 
253     return true;
254   }
255 
256   function approve(address spender, uint256 value) public returns (bool) {
257     require(spender != address(0));
258 
259     _allowed[msg.sender][spender] = value;
260     emit Approval(msg.sender, spender, value);
261     return true;
262   }
263 
264   function transferFrom(
265     address from,
266     address to,
267     uint256 value
268   )
269     public
270     returns (bool)
271   {
272     require(value <= _allowed[from][msg.sender]);
273     
274     if (_canTransfer(from, value)) {
275         _allowed[from][msg.sender] = _allowed[from][msg.sender].sub(value);
276         _transfer(from, to, value);
277         return true;
278     } else {
279         return false;
280     }
281   }
282 
283   function _transfer(address from, address to, uint256 value) internal {
284     require(value <= _balances[from]);
285     require(to != address(0));
286     
287     _balances[from] = _balances[from].sub(value);
288     _balances[to] = _balances[to].add(value);
289     emit Transfer(from, to, value);
290     
291   }
292 
293 }