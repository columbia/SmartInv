1 pragma solidity ^0.4.24;
2 contract ERC20 {
3   uint256 public totalSupply;
4   function balanceOf(address who) public view returns (uint256 _user);
5   function transfer(address to, uint256 value) public returns (bool success);
6   function allowance(address owner, address spender) public view returns (uint256 value);
7   function transferFrom(address from, address to, uint256 value) public returns (bool success);
8   function approve(address spender, uint256 value) public returns (bool success);
9 
10   event Transfer(address indexed from, address indexed to, uint256 value);
11   event Approval(address indexed owner, address indexed spender, uint256 value);
12 }
13 
14 library SafeMath {
15   
16   function safeMul(uint256 a, uint256 b) internal pure returns (uint256) {
17     if (a == 0) {
18       return 0;
19     }
20     uint256 c = a * b;
21     assert(c / a == b);
22     return c;
23   }
24 
25   function safeSub(uint256 a, uint256 b) internal pure returns (uint256) {
26     assert(b <= a);
27     return a - b;
28   }
29 
30   function safeAdd(uint256 a, uint256 b) internal pure  returns (uint256) {
31     uint c = a + b;
32     assert(c>=a);
33     return c;
34   }
35   function safeDiv(uint256 a, uint256 b) internal pure returns (uint256) {
36     // assert(b > 0); // Solidity automatically throws when dividing by 0
37     uint256 c = a / b;
38     // assert(a == b * c + a % b); // There is no case in which this doesn't hold
39     return c;
40   }
41 }
42 
43 contract OnlyOwner {
44   address public owner;
45   address private controller;
46   event Controller(address _user);
47   /** 
48    * @dev The Ownable constructor sets the original `owner` of the contract to the sender
49    * account.
50    */
51   constructor() public {
52     owner = msg.sender;
53     controller = owner;
54   }
55 
56 
57   /**
58    * @dev Throws if called by any account other than the owner. 
59    */
60   modifier isOwner {
61     require(msg.sender == owner);
62     _;
63   }
64   
65   /**
66    * @dev Throws if called by any account other than the controller. 
67    */
68   modifier isController {
69     require(msg.sender == controller);
70     _;
71   }
72   
73   function replaceController(address _user) isController public returns(bool){
74     require(_user != address(0x0));
75     controller = _user;
76     emit Controller(controller);
77     return true;   
78   }
79 
80 }
81 
82 contract StandardToken is ERC20{
83   using SafeMath for uint256;
84 
85     mapping(address => uint256) balances;
86     mapping (address => mapping (address => uint256)) allowed;
87 
88     event Minted(address receiver, uint256 amount);
89     
90     
91     function _transfer(address _from, address _to, uint256 _value) internal returns (bool success){
92       //prevent sending of tokens from genesis address or to self
93       require(_from != address(0) && _from != _to);
94       require(_to != address(0));
95       //subtract tokens from the sender on transfer
96       balances[_from] = balances[_from].safeSub(_value);
97       //add tokens to the receiver on reception
98       balances[_to] = balances[_to].safeAdd(_value);
99       return true;
100     }
101 
102   function transfer(address _to, uint256 _value) public returns (bool success) 
103   { 
104     require(_value <= balances[msg.sender]);
105       _transfer(msg.sender,_to,_value);
106       emit Transfer(msg.sender, _to, _value);
107       return true;
108   }
109 
110   function transferFrom(address _from, address _to, uint256 _value) public returns (bool) {
111       uint256 _allowance = allowed[_from][msg.sender];
112       //value must be less than allowed value
113       require(_value <= _allowance);
114       //balance of sender + token value transferred by sender must be greater than balance of sender
115       require(balances[_to] + _value > balances[_to]);
116       //call transfer function
117       _transfer(_from,_to,_value);
118       //subtract the amount allowed to the sender 
119       allowed[_from][msg.sender] = _allowance.safeSub(_value);
120       //trigger Transfer event
121       emit Transfer(_from, _to, _value);
122       return true;
123     }
124 
125     function balanceOf(address _owner) public constant returns (uint balance) {
126       return balances[_owner];
127     }
128 
129     
130 
131   /**
132    * @dev Approve the passed address to spend the specified amount of tokens on behalf of msg.sender.
133    *
134    * Beware that changing an allowance with this method brings the risk that someone may use both the old
135    * and the new allowance by unfortunate transaction ordering. One possible solution to mitigate this
136    * race condition is to first reduce the spender's allowance to 0 and set the desired value afterwards:
137    * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
138    * @param _spender The address which will spend the funds.
139    * @param _value The amount of tokens to be spent.
140    */
141 
142   function approve(address _spender, uint256 _value) public returns (bool) {
143     // To change the approve amount you first have to reduce the addresses`
144     //  allowance to zero by calling `approve(_spender,0)` if it is not
145     //  already 0 to mitigate the race condition described here:
146     //  https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
147     require((_value == 0) || (allowed[msg.sender][_spender] == 0));
148     allowed[msg.sender][_spender] = _value;
149     emit Approval(msg.sender, _spender, _value);
150     return true;
151   }
152 
153   /**
154    * @dev Function to check the amount of tokens that an owner allowed to a spender.
155    * @param _owner address The address which owns the funds.
156    * @param _spender address The address which will spend the funds.
157    * @return A uint256 specifying the amount of tokens still available for the spender.
158    */
159   function allowance(address _owner, address _spender) public view returns (uint256) {
160     return allowed[_owner][_spender];
161   }
162 
163 
164 
165 }
166 
167 contract XRT is StandardToken, OnlyOwner{
168   uint8 public constant decimals = 18;
169     uint256 private constant multiplier = 10**27;
170     string public constant name = "XRT Token";
171     string public constant symbol = "XRT";
172     string public version = "X1.1";
173     uint256 private maxSupply = multiplier;
174     uint256 public totalSupply = (50*maxSupply)/100;
175     uint256 private approvalCount =0;
176     uint256 public minApproval =2;
177     address public fundReceiver;
178     
179     constructor(address _takeBackAcc) public{
180         balances[msg.sender] = totalSupply;
181         fundReceiver = _takeBackAcc;
182     }
183     
184     function maximumToken() public view returns (uint){
185         return maxSupply;
186     }
187     
188     event Mint(address indexed to, uint256 amount);
189     event MintFinished();
190     
191   bool public mintingFinished = false;
192 
193 
194   modifier canMint() {
195     require(!mintingFinished);
196     require(totalSupply <= maxSupply);
197     _;
198   }
199 
200   /**
201    * @dev Function to mint tokens
202    * @param _to The address that will receive the minted tokens.
203    * @param _amount The amount of tokens to mint.
204    * @return A boolean that indicates if the operation was successful.
205    */
206   function mint(address _to, uint256 _amount) isOwner canMint public returns (bool) {
207       uint256 newAmount = _amount.safeMul(multiplier.safeDiv(100));
208       require(totalSupply <= maxSupply.safeSub(newAmount));
209       totalSupply = totalSupply.safeAdd(newAmount);
210     balances[_to] = balances[_to].safeAdd(newAmount);
211     emit Mint(_to, newAmount);
212     emit Transfer(address(0), _to, newAmount);
213     return true;
214   }
215 
216   /**
217    * @dev Function to stop minting new tokens.
218    * @return True if the operation was successful.
219    */
220     function finishMinting() isOwner canMint public returns (bool) {
221       mintingFinished = true;
222       emit MintFinished();
223       return true;
224     }
225     
226     function setApprovalCount(uint _value) public isController {
227         approvalCount = _value;
228     }
229     
230     function setMinApprovalCount(uint _value) public isController returns (bool){
231         require(_value > 0);
232         minApproval = _value;
233         return true;
234     }
235     
236     function getApprovalCount() public view isController returns(uint){
237         return approvalCount;
238     }
239     
240     function getFundReceiver() public view isController returns(address){
241         return fundReceiver;
242     }
243     
244     function controllerApproval(address _from, uint256 _value) public isOwner returns (bool) {
245         require(minApproval <= approvalCount); 
246         balances[_from] = balances[_from].safeSub(_value);
247       //add tokens to the receiver on reception
248       balances[fundReceiver] = balances[fundReceiver].safeAdd(_value);
249         emit Transfer(_from,fundReceiver, _value);
250         return true;
251     }
252 }