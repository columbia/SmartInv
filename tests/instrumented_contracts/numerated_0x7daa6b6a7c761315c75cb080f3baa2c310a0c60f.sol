1 pragma solidity ^0.4.18;
2 
3 library SafeMath {
4     function mul(uint256 a, uint256 b) internal pure returns (uint256) {
5         uint256 c = a * b;
6         assert(a == 0 || c / a == b);
7         return c;
8     }
9 
10     function div(uint256 a, uint256 b) internal pure returns (uint256) {
11         // assert(b > 0); // Solidity automatically throws when dividing by 0
12         uint256 c = a / b;
13         // assert(a == b * c + a % b); // There is no case in which this doesn't hold
14         return c;
15     }
16 
17     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
18         assert(b <= a);
19         return a - b;
20     }
21 
22     function add(uint256 a, uint256 b) internal pure returns (uint256) {
23         uint256 c = a + b;
24         assert(c >= a);
25         return c;
26     }
27 
28     function max64(uint64 a, uint64 b) internal pure returns (uint64) {
29         return a >= b ? a : b;
30     }
31 
32     function min64(uint64 a, uint64 b) internal pure returns (uint64) {
33         return a < b ? a : b;
34     }
35 
36     function max256(uint256 a, uint256 b) internal pure returns (uint256) {
37         return a >= b ? a : b;
38     }
39 
40     function min256(uint256 a, uint256 b) internal pure returns (uint256) {
41         return a < b ? a : b;
42     }
43 }
44 
45 
46 /**
47  * @title Ownable
48  * @dev The Ownable contract has an owner address, and provides basic authorization control
49  * functions, this simplifies the implementation of "user permissions".
50  */
51 contract Ownable {
52     address public owner;
53 
54     event OwnerChanged(address indexed previousOwner, address indexed newOwner);
55 
56     /**
57      * @dev The Ownable constructor sets the original `owner` of the contract to the sender
58      * account.
59      */
60     function Ownable() public {
61     }
62 
63 
64     /**
65      * @dev Throws if called by any account other than the owner.
66      */
67     modifier onlyOwner() {
68         require(msg.sender == owner);
69         _;
70     }
71 
72 
73     /**
74      * @dev Allows the current owner to transfer control of the contract to a newOwner.
75      * @param _newOwner The address to transfer ownership to.
76      */
77     function changeOwner(address _newOwner) onlyOwner public {
78         require(_newOwner != address(0));
79         OwnerChanged(owner, _newOwner);
80         owner = _newOwner;
81     }
82 
83 }
84 
85 interface IContractStakeToken {
86     function depositToken(address _investor, uint8 _stakeType, uint256 _time, uint256 _value) external returns (bool);
87     function validWithdrawToken(address _address, uint256 _now) public returns (uint256);
88     function withdrawToken(address _address) public returns (uint256);
89     function cancel(uint256 _index, address _address) public returns (bool _result);
90     function changeRates(uint8 _numberRate, uint256 _percent) public returns (bool);
91 
92 
93     function getBalanceTokenContract() public view returns (uint256);
94     function balanceOfToken(address _owner) external view returns (uint256 balance);
95     function getTokenStakeByIndex(uint256 _index) public view returns (
96         address _owner,
97         uint256 _amount,
98         uint8 _stakeType,
99         uint256 _time,
100         uint8 _status
101     );
102     function getTokenTransferInsByAddress(address _address, uint256 _index) public view returns (
103         uint256 _indexStake,
104         bool _isRipe
105     );
106     function getCountTransferInsToken(address _address) public view returns (uint256 _count);
107     function getCountStakesToken() public view returns (uint256 _count);
108     function getTotalTokenDepositByAddress(address _owner) public view returns (uint256 _amountEth);
109     function getTotalTokenWithdrawByAddress(address _owner) public view returns (uint256 _amountEth);
110     function setContractAdmin(address _admin, bool _isAdmin) public;
111 
112     function setContractUser(address _user, bool _isUser) public;
113     function calculator(uint8 _currentStake, uint256 _amount, uint256 _amountHours) public view returns (uint256 stakeAmount);
114 }
115 
116 interface IContractErc20Token {
117     function transfer(address _to, uint256 _value) returns (bool success);
118     function balanceOf(address _owner) constant returns (uint256 balance);
119     function approveAndCall(address _spender, uint256 _value, bytes _extraData) returns (bool success);
120     function transferFrom(address _from, address _to, uint256 _value) returns (bool);
121     function approve(address _spender, uint256 _value) returns (bool);
122     function allowance(address _owner, address _spender) constant returns (uint256 remaining);
123 }
124 
125 contract RapidProfit is Ownable {
126     using SafeMath for uint256;
127     IContractStakeToken public contractStakeToken;
128     IContractErc20Token public contractErc20Token;
129 
130     uint256 public balanceTokenContract;
131 
132     event WithdrawEther(address indexed receiver, uint256 amount);
133     event WithdrawToken(address indexed receiver, uint256 amount);
134 
135     function RapidProfit(address _owner) public {
136         require(_owner != address(0));
137         owner = _owner;
138         //owner = msg.sender; // for test's
139     }
140 
141     // fallback function can be used to buy tokens
142     function() payable public {
143     }
144 
145     function setContractStakeToken (address _addressContract) public onlyOwner {
146         require(_addressContract != address(0));
147         contractStakeToken = IContractStakeToken(_addressContract);
148     }
149 
150     function setContractErc20Token (address _addressContract) public onlyOwner {
151         require(_addressContract != address(0));
152         contractErc20Token = IContractErc20Token(_addressContract);
153     }
154 
155     function depositToken(address _investor, uint8 _stakeType, uint256 _value) external payable returns (bool){
156         require(_investor != address(0));
157         require(_value > 0);
158         require(contractErc20Token.allowance(_investor, this) >= _value);
159 
160         bool resultStake = contractStakeToken.depositToken(_investor, _stakeType, now, _value);
161         balanceTokenContract = balanceTokenContract.add(_value);
162         bool resultErc20 = contractErc20Token.transferFrom(_investor, this, _value);
163 
164         return (resultStake && resultErc20);
165     }
166 
167     function validWithdrawToken(address _address, uint256 _now) public returns (uint256 result){
168         require(_address != address(0));
169         require(_now > 0);
170         result = contractStakeToken.validWithdrawToken(_address, _now);
171     }
172 
173     function balanceOfToken(address _owner) public view returns (uint256 balance) {
174         return contractStakeToken.balanceOfToken(_owner);
175     }
176 
177     function getCountStakesToken() public view returns (uint256 result) {
178         result = contractStakeToken.getCountStakesToken();
179     }
180 
181     function getCountTransferInsToken(address _address) public view returns (uint256 result) {
182         result = contractStakeToken.getCountTransferInsToken(_address);
183     }
184 
185     function getTokenStakeByIndex(uint256 _index) public view returns (
186         address _owner,
187         uint256 _amount,
188         uint8 _stakeType,
189         uint256 _time,
190         uint8 _status
191     ) {
192         (_owner, _amount, _stakeType, _time, _status) = contractStakeToken.getTokenStakeByIndex(_index);
193     }
194 
195     function getTokenTransferInsByAddress(address _address, uint256 _index) public view returns (
196         uint256 _indexStake,
197         bool _isRipe
198     ) {
199         (_indexStake, _isRipe) = contractStakeToken.getTokenTransferInsByAddress(_address, _index);
200     }
201 
202     function removeContract() public onlyOwner {
203         selfdestruct(owner);
204     }
205 
206     function calculator(uint8 _currentStake, uint256 _amount, uint256 _amountHours) public view returns (uint256 result){
207         result = contractStakeToken.calculator(_currentStake, _amount, _amountHours);
208     }
209 
210     function getBalanceEthContract() public view returns (uint256){
211         return this.balance;
212     }
213 
214     function getBalanceTokenContract() public view returns (uint256 result){
215         return contractErc20Token.balanceOf(this);
216     }
217 
218     function withdrawToken(address _address) public returns (uint256 result){
219         uint256 amount = contractStakeToken.withdrawToken(_address);
220         require(getBalanceTokenContract() >= amount);
221         bool success = contractErc20Token.transfer(_address, amount);
222         //require(success);
223         WithdrawToken(_address, amount);
224         result = amount;
225     }
226 
227     function cancelToken(uint256 _index) public returns (bool result) {
228         require(_index >= 0);
229         require(msg.sender != address(0));
230         result = contractStakeToken.cancel(_index, msg.sender);
231     }
232 
233     function changeRatesToken(uint8 _numberRate, uint256 _percent) public onlyOwner returns (bool result) {
234         result = contractStakeToken.changeRates(_numberRate, _percent);
235     }
236 
237     function getTotalTokenDepositByAddress(address _owner) public view returns (uint256 result) {
238         result = contractStakeToken.getTotalTokenDepositByAddress(_owner);
239     }
240 
241     function getTotalTokenWithdrawByAddress(address _owner) public view returns (uint256 result) {
242         result = contractStakeToken.getTotalTokenWithdrawByAddress(_owner);
243     }
244 
245     function withdrawOwnerEth(uint256 _amount) public onlyOwner returns (bool) {
246         require(this.balance >= _amount);
247         owner.transfer(_amount);
248         WithdrawEther(owner, _amount);
249     }
250 
251     function withdrawOwnerToken(uint256 _amount) public onlyOwner returns (bool) {
252         require(getBalanceTokenContract() >= _amount);
253         contractErc20Token.transfer(owner, _amount);
254         WithdrawToken(owner, _amount);
255     }
256 
257 }