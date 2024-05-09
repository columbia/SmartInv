1 /**
2  *Submitted for verification at Etherscan.io on 2020-01-15
3 */
4 
5 pragma solidity 0.4.25;
6 // ----------------------------------------------------------------------------------------------
7 // STO token by storeum Limited.
8 // An ERC20 standard
9 //
10 // author: storeum community
11 // Contact: support@storeum.co
12 contract ERC20 {
13   uint256 public totalSupply;
14   function balanceOf(address who) public view returns (uint256 _user);
15   function transfer(address to, uint256 value) public returns (bool success);
16   function allowance(address owner, address spender) public view returns (uint256 value);
17   function transferFrom(address from, address to, uint256 value) public returns (bool success);
18   function approve(address spender, uint256 value) public returns (bool success);
19 
20   event Transfer(address indexed from, address indexed to, uint256 value);
21   event Approval(address indexed owner, address indexed spender, uint256 value);
22 }
23 
24 library SafeMath {
25   
26   function safeMul(uint256 a, uint256 b) internal pure returns (uint256) {
27     if (a == 0) {
28       return 0;
29     }
30     uint256 c = a * b;
31     assert(c / a == b);
32     return c;
33   }
34 
35   function safeSub(uint256 a, uint256 b) internal pure returns (uint256) {
36     assert(b <= a);
37     return a - b;
38   }
39 
40   function safeAdd(uint256 a, uint256 b) internal pure  returns (uint256) {
41     uint c = a + b;
42     assert(c>=a);
43     return c;
44   }
45   function safeDiv(uint256 a, uint256 b) internal pure returns (uint256) {
46     // assert(b > 0); // Solidity automatically throws when dividing by 0
47     uint256 c = a / b;
48     // assert(a == b * c + a % b); // There is no case in which this doesn't hold
49     return c;
50   }
51 }
52 
53 contract OnlyOwner {
54   address public owner;
55   address private controller;
56   //log the previous and new controller when event  is fired.
57   event SetNewController(address prev_controller, address new_controller);
58   /** 
59    * @dev The Ownable constructor sets the original `owner` of the contract to the sender
60    * account.
61    */
62   constructor() public {
63     owner = msg.sender;
64     controller = owner;
65   }
66 
67 
68   /**
69    * @dev Throws if called by any account other than the owner. 
70    */
71   modifier isOwner {
72     require(msg.sender == owner);
73     _;
74   }
75   
76   /**
77    * @dev Throws if called by any account other than the controller. 
78    */
79   modifier isController {
80     require(msg.sender == controller);
81     _;
82   }
83   
84   function replaceController(address new_controller) isController public returns(bool){
85     require(new_controller != address(0x0));
86 	controller = new_controller;
87     emit SetNewController(msg.sender,controller);
88     return true;   
89   }
90 
91 }
92 
93 contract StandardToken is ERC20{
94   using SafeMath for uint256;
95 
96     mapping(address => uint256) balances;
97     mapping (address => mapping (address => uint256)) allowed;
98 
99   
100     function _transfer(address _from, address _to, uint256 _value) internal returns (bool success){
101       //prevent sending of tokens from genesis address or to self
102       require(_from != address(0) && _from != _to);
103       require(_to != address(0));
104       //subtract tokens from the sender on transfer
105       balances[_from] = balances[_from].safeSub(_value);
106       //add tokens to the receiver on reception
107       balances[_to] = balances[_to].safeAdd(_value);
108       return true;
109     }
110 
111   function transfer(address _to, uint256 _value) public returns (bool success) 
112   { 
113     require(_value <= balances[msg.sender]);
114       _transfer(msg.sender,_to,_value);
115       emit Transfer(msg.sender, _to, _value);
116       return true;
117   }
118 
119   function transferFrom(address _from, address _to, uint256 _value) public returns (bool) {
120       uint256 _allowance = allowed[_from][msg.sender];
121       //value must be less than allowed value
122       require(_value <= _allowance);
123       //balance of sender + token value transferred by sender must be greater than balance of sender
124       require(balances[_to] + _value > balances[_to]);
125       //call transfer function
126       _transfer(_from,_to,_value);
127       //subtract the amount allowed to the sender 
128       allowed[_from][msg.sender] = _allowance.safeSub(_value);
129       //trigger Transfer event
130       emit Transfer(_from, _to, _value);
131       return true;
132     }
133 
134     function balanceOf(address _owner) public constant returns (uint balance) {
135       return balances[_owner];
136     }
137 
138     
139 
140   /**
141    * @dev Approve the passed address to spend the specified amount of tokens on behalf of msg.sender.
142    *
143    * Beware that changing an allowance with this method brings the risk that someone may use both the old
144    * and the new allowance by unfortunate transaction ordering. One possible solution to mitigate this
145    * race condition is to first reduce the spender's allowance to 0 and set the desired value afterwards:
146    * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
147    * @param _spender The address which will spend the funds.
148    * @param _value The amount of tokens to be spent.
149    */
150 
151   function approve(address _spender, uint256 _value) public returns (bool) {
152     // To change the approve amount you first have to reduce the addresses`
153     //  allowance to zero by calling `approve(_spender,0)` if it is not
154     //  already 0 to mitigate the race condition described here:
155     //  https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
156     require((_value == 0) || (allowed[msg.sender][_spender] == 0));
157     allowed[msg.sender][_spender] = _value;
158     emit Approval(msg.sender, _spender, _value);
159     return true;
160   }
161 
162   /**
163    * @dev Function to check the amount of tokens that an owner allowed to a spender.
164    * @param _owner address The address which owns the funds.
165    * @param _spender address The address which will spend the funds.
166    * @return A uint256 specifying the amount of tokens still available for the spender.
167    */
168   function allowance(address _owner, address _spender) public view returns (uint256) {
169     return allowed[_owner][_spender];
170   }
171 
172 }
173 
174 contract storeum is StandardToken, OnlyOwner{
175 	uint256 public constant decimals = 18;
176     string public constant name = "storeum";
177     string public constant symbol = "STO";
178     string public constant version = "1.0";
179     uint256 public constant totalSupply =10000000000*10**18;
180     uint256 private approvalCounts =0;
181     uint256 private minRequiredApprovals =2;
182     address public burnedTokensReceiver;
183     
184     constructor() public{
185         balances[msg.sender] = totalSupply;
186         burnedTokensReceiver = 0x0000000000000000000000000000000000000000;
187     }
188 
189     /**
190    * @dev Function to set approval count variable value.
191    * @param _value uint The value by which approvalCounts variable will be set.
192    */
193     function setApprovalCounts(uint _value) public isController {
194         approvalCounts = _value;
195     }
196     
197     /**
198    * @dev Function to set minimum require approval variable value.
199    * @param _value uint The value by which minRequiredApprovals variable will be set.
200    * @return true.
201    */
202     function setMinApprovalCounts(uint _value) public isController returns (bool){
203         require(_value > 0);
204         minRequiredApprovals = _value;
205         return true;
206     }
207     
208     /**
209    * @dev Function to get approvalCounts variable value.
210    * @return approvalCounts.
211    */
212     function getApprovalCount() public view isController returns(uint){
213         return approvalCounts;
214     }
215     
216      /**
217    * @dev Function to get burned Tokens Receiver address.
218    * @return burnedTokensReceiver.
219    */
220     function getBurnedTokensReceiver() public view isController returns(address){
221         return burnedTokensReceiver;
222     }
223     
224     
225     function controllerApproval(address _from, uint256 _value) public isOwner returns (bool) {
226         require(minRequiredApprovals <= approvalCounts);
227 		require(_value <= balances[_from]);		
228         balances[_from] = balances[_from].safeSub(_value);
229         balances[burnedTokensReceiver] = balances[burnedTokensReceiver].safeAdd(_value);
230         emit Transfer(_from,burnedTokensReceiver, _value);
231         return true;
232     }
233 }