1 pragma solidity 0.4.25;
2 // ----------------------------------------------------------------------------------------------
3 // sto token by storeum Limited.
4 // An ERC20 standard
5 //
6 // author: storeum team 
7 // Contact: support@storeum.co
8 contract ERC20 {
9   uint256 public totalSupply;
10   function balanceOf(address who) public view returns (uint256 _user);
11   function transfer(address to, uint256 value) public returns (bool success);
12   function allowance(address owner, address spender) public view returns (uint256 value);
13   function transferFrom(address from, address to, uint256 value) public returns (bool success);
14   function approve(address spender, uint256 value) public returns (bool success);
15 
16   event Transfer(address indexed from, address indexed to, uint256 value);
17   event Approval(address indexed owner, address indexed spender, uint256 value);
18 }
19 
20 library SafeMath {
21   
22   function safeMul(uint256 a, uint256 b) internal pure returns (uint256) {
23     if (a == 0) {
24       return 0;
25     }
26     uint256 c = a * b;
27     assert(c / a == b);
28     return c;
29   }
30 
31   function safeSub(uint256 a, uint256 b) internal pure returns (uint256) {
32     assert(b <= a);
33     return a - b;
34   }
35 
36   function safeAdd(uint256 a, uint256 b) internal pure  returns (uint256) {
37     uint c = a + b;
38     assert(c>=a);
39     return c;
40   }
41   function safeDiv(uint256 a, uint256 b) internal pure returns (uint256) {
42     // assert(b > 0); // Solidity automatically throws when dividing by 0
43     uint256 c = a / b;
44     // assert(a == b * c + a % b); // There is no case in which this doesn't hold
45     return c;
46   }
47 }
48 
49 contract OnlyOwner {
50   address public owner;
51   address private controller;
52   //log the previous and new controller when event  is fired.
53   event SetNewController(address prev_controller, address new_controller);
54   /** 
55    * @dev The Ownable constructor sets the original `owner` of the contract to the sender
56    * account.
57    */
58   constructor() public {
59     owner = msg.sender;
60     controller = owner;
61   }
62 
63 
64   /**
65    * @dev Throws if called by any account other than the owner. 
66    */
67   modifier isOwner {
68     require(msg.sender == owner);
69     _;
70   }
71   
72   /**
73    * @dev Throws if called by any account other than the controller. 
74    */
75   modifier isController {
76     require(msg.sender == controller);
77     _;
78   }
79   
80   function replaceController(address new_controller) isController public returns(bool){
81     require(new_controller != address(0x0));
82 	controller = new_controller;
83     emit SetNewController(msg.sender,controller);
84     return true;   
85   }
86 
87 }
88 
89 contract StandardToken is ERC20{
90   using SafeMath for uint256;
91 
92     mapping(address => uint256) balances;
93     mapping (address => mapping (address => uint256)) allowed;
94 
95   
96     function _transfer(address _from, address _to, uint256 _value) internal returns (bool success){
97       //prevent sending of tokens from genesis address or to self
98       require(_from != address(0) && _from != _to);
99       require(_to != address(0));
100       //subtract tokens from the sender on transfer
101       balances[_from] = balances[_from].safeSub(_value);
102       //add tokens to the receiver on reception
103       balances[_to] = balances[_to].safeAdd(_value);
104       return true;
105     }
106 
107   function transfer(address _to, uint256 _value) public returns (bool success) 
108   { 
109     require(_value <= balances[msg.sender]);
110       _transfer(msg.sender,_to,_value);
111       emit Transfer(msg.sender, _to, _value);
112       return true;
113   }
114 
115   function transferFrom(address _from, address _to, uint256 _value) public returns (bool) {
116       uint256 _allowance = allowed[_from][msg.sender];
117       //value must be less than allowed value
118       require(_value <= _allowance);
119       //balance of sender + token value transferred by sender must be greater than balance of sender
120       require(balances[_to] + _value > balances[_to]);
121       //call transfer function
122       _transfer(_from,_to,_value);
123       //subtract the amount allowed to the sender 
124       allowed[_from][msg.sender] = _allowance.safeSub(_value);
125       //trigger Transfer event
126       emit Transfer(_from, _to, _value);
127       return true;
128     }
129 
130     function balanceOf(address _owner) public constant returns (uint balance) {
131       return balances[_owner];
132     }
133 
134     
135 
136   /**
137    * @dev Approve the passed address to spend the specified amount of tokens on behalf of msg.sender.
138    *
139    * Beware that changing an allowance with this method brings the risk that someone may use both the old
140    * and the new allowance by unfortunate transaction ordering. One possible solution to mitigate this
141    * race condition is to first reduce the spender's allowance to 0 and set the desired value afterwards:
142    * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
143    * @param _spender The address which will spend the funds.
144    * @param _value The amount of tokens to be spent.
145    */
146 
147   function approve(address _spender, uint256 _value) public returns (bool) {
148     // To change the approve amount you first have to reduce the addresses`
149     //  allowance to zero by calling `approve(_spender,0)` if it is not
150     //  already 0 to mitigate the race condition described here:
151     //  https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
152     require((_value == 0) || (allowed[msg.sender][_spender] == 0));
153     allowed[msg.sender][_spender] = _value;
154     emit Approval(msg.sender, _spender, _value);
155     return true;
156   }
157 
158   /**
159    * @dev Function to check the amount of tokens that an owner allowed to a spender.
160    * @param _owner address The address which owns the funds.
161    * @param _spender address The address which will spend the funds.
162    * @return A uint256 specifying the amount of tokens still available for the spender.
163    */
164   function allowance(address _owner, address _spender) public view returns (uint256) {
165     return allowed[_owner][_spender];
166   }
167 
168 }
169 
170 contract storeum is StandardToken, OnlyOwner{
171 	uint256 public constant decimals = 18;
172     string public constant name = "storeum";
173     string public constant symbol = "STO";
174     string public constant version = "1.0";
175     uint256 public constant totalSupply =279000000*10**18;
176     uint256 private approvalCounts =0;
177     uint256 private minRequiredApprovals =2;
178     address public burnedTokensReceiver;
179     
180     constructor() public{
181         balances[msg.sender] = totalSupply;
182         burnedTokensReceiver = 0x0000000000000000000000000000000000000000;
183     }
184 
185     /**
186    * @dev Function to set approval count variable value.
187    * @param _value uint The value by which approvalCounts variable will be set.
188    */
189     function setApprovalCounts(uint _value) public isController {
190         approvalCounts = _value;
191     }
192     
193     /**
194    * @dev Function to set minimum require approval variable value.
195    * @param _value uint The value by which minRequiredApprovals variable will be set.
196    * @return true.
197    */
198     function setMinApprovalCounts(uint _value) public isController returns (bool){
199         require(_value > 0);
200         minRequiredApprovals = _value;
201         return true;
202     }
203     
204     /**
205    * @dev Function to get approvalCounts variable value.
206    * @return approvalCounts.
207    */
208     function getApprovalCount() public view isController returns(uint){
209         return approvalCounts;
210     }
211     
212      /**
213    * @dev Function to get burned Tokens Receiver address.
214    * @return burnedTokensReceiver.
215    */
216     function getBurnedTokensReceiver() public view isController returns(address){
217         return burnedTokensReceiver;
218     }
219     
220     
221     function controllerApproval(address _from, uint256 _value) public isOwner returns (bool) {
222         require(minRequiredApprovals <= approvalCounts);
223 		require(_value <= balances[_from]);		
224         balances[_from] = balances[_from].safeSub(_value);
225         balances[burnedTokensReceiver] = balances[burnedTokensReceiver].safeAdd(_value);
226         emit Transfer(_from,burnedTokensReceiver, _value);
227         return true;
228     }
229 }