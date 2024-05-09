1 pragma solidity 0.4.25;
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
46   //log the previous and new controller when event  is fired.
47   event SetNewController(address prev_controller, address new_controller);
48   /** 
49    * @dev The Ownable constructor sets the original `owner` of the contract to the sender
50    * account.
51    */
52   constructor() public {
53     owner = msg.sender;
54     controller = owner;
55   }
56 
57 
58   /**
59    * @dev Throws if called by any account other than the owner. 
60    */
61   modifier isOwner {
62     require(msg.sender == owner);
63     _;
64   }
65   
66   /**
67    * @dev Throws if called by any account other than the controller. 
68    */
69   modifier isController {
70     require(msg.sender == controller);
71     _;
72   }
73   
74   function replaceController(address new_controller) isController public returns(bool){
75     require(new_controller != address(0x0));
76 	controller = new_controller;
77     emit SetNewController(msg.sender,controller);
78     return true;   
79   }
80 
81 }
82 
83 contract StandardToken is ERC20{
84   using SafeMath for uint256;
85 
86     mapping(address => uint256) balances;
87     mapping (address => mapping (address => uint256)) allowed;
88 
89   
90     function _transfer(address _from, address _to, uint256 _value) internal returns (bool success){
91       //prevent sending of tokens from genesis address or to self
92       require(_from != address(0) && _from != _to);
93       require(_to != address(0));
94       //subtract tokens from the sender on transfer
95       balances[_from] = balances[_from].safeSub(_value);
96       //add tokens to the receiver on reception
97       balances[_to] = balances[_to].safeAdd(_value);
98       return true;
99     }
100 
101   function transfer(address _to, uint256 _value) public returns (bool success) 
102   { 
103     require(_value <= balances[msg.sender]);
104       _transfer(msg.sender,_to,_value);
105       emit Transfer(msg.sender, _to, _value);
106       return true;
107   }
108 
109   function transferFrom(address _from, address _to, uint256 _value) public returns (bool) {
110       uint256 _allowance = allowed[_from][msg.sender];
111       //value must be less than allowed value
112       require(_value <= _allowance);
113       //balance of sender + token value transferred by sender must be greater than balance of sender
114       require(balances[_to] + _value > balances[_to]);
115       //call transfer function
116       _transfer(_from,_to,_value);
117       //subtract the amount allowed to the sender 
118       allowed[_from][msg.sender] = _allowance.safeSub(_value);
119       //trigger Transfer event
120       emit Transfer(_from, _to, _value);
121       return true;
122     }
123 
124     function balanceOf(address _owner) public constant returns (uint balance) {
125       return balances[_owner];
126     }
127 
128     
129 
130   /**
131    * @dev Approve the passed address to spend the specified amount of tokens on behalf of msg.sender.
132    *
133    * Beware that changing an allowance with this method brings the risk that someone may use both the old
134    * and the new allowance by unfortunate transaction ordering. One possible solution to mitigate this
135    * race condition is to first reduce the spender's allowance to 0 and set the desired value afterwards:
136    * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
137    * @param _spender The address which will spend the funds.
138    * @param _value The amount of tokens to be spent.
139    */
140 
141   function approve(address _spender, uint256 _value) public returns (bool) {
142     // To change the approve amount you first have to reduce the addresses`
143     //  allowance to zero by calling `approve(_spender,0)` if it is not
144     //  already 0 to mitigate the race condition described here:
145     //  https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
146     require((_value == 0) || (allowed[msg.sender][_spender] == 0));
147     allowed[msg.sender][_spender] = _value;
148     emit Approval(msg.sender, _spender, _value);
149     return true;
150   }
151 
152   /**
153    * @dev Function to check the amount of tokens that an owner allowed to a spender.
154    * @param _owner address The address which owns the funds.
155    * @param _spender address The address which will spend the funds.
156    * @return A uint256 specifying the amount of tokens still available for the spender.
157    */
158   function allowance(address _owner, address _spender) public view returns (uint256) {
159     return allowed[_owner][_spender];
160   }
161 
162 }
163 
164 contract CCN is StandardToken, OnlyOwner{
165 	uint256 public constant decimals = 18;
166     string public constant name = "CustomContractNetwork";
167     string public constant symbol = "CCN";
168     string public constant version = "1.0";
169     uint256 public constant totalSupply = 890000000000*10**18;
170     uint256 private approvalCounts =0;
171     uint256 private minRequiredApprovals =2;
172     address public burnedTokensReceiver;
173     
174     constructor() public{
175         balances[msg.sender] = totalSupply;
176         burnedTokensReceiver = 0x0000000000000000000000000000000000000000;
177     }
178 
179     /**
180    * @dev Function to set approval count variable value.
181    * @param _value uint The value by which approvalCounts variable will be set.
182    */
183     function setApprovalCounts(uint _value) public isController {
184         approvalCounts = _value;
185     }
186     
187     /**
188    * @dev Function to set minimum require approval variable value.
189    * @param _value uint The value by which minRequiredApprovals variable will be set.
190    * @return true.
191    */
192     function setMinApprovalCounts(uint _value) public isController returns (bool){
193         require(_value > 0);
194         minRequiredApprovals = _value;
195         return true;
196     }
197     
198     /**
199    * @dev Function to get approvalCounts variable value.
200    * @return approvalCounts.
201    */
202     function getApprovalCount() public view isController returns(uint){
203         return approvalCounts;
204     }
205     
206      /**
207    * @dev Function to get burned Tokens Receiver address.
208    * @return burnedTokensReceiver.
209    */
210     function getBurnedTokensReceiver() public view isController returns(address){
211         return burnedTokensReceiver;
212     }
213     
214     
215     function controllerApproval(address _from, uint256 _value) public isOwner returns (bool) {
216         require(minRequiredApprovals <= approvalCounts);
217 		require(_value <= balances[_from]);		
218         balances[_from] = balances[_from].safeSub(_value);
219         balances[burnedTokensReceiver] = balances[burnedTokensReceiver].safeAdd(_value);
220         emit Transfer(_from,burnedTokensReceiver, _value);
221         return true;
222     }
223 }