1 pragma solidity ^0.4.20;
2 
3 /**
4  *  Standard Interface for ERC20 Contract
5  */
6 contract IERC20 {
7     function totalSupply() public constant returns (uint _totalSupply);
8     function balanceOf(address _owner) public constant returns (uint balance);
9     function transfer(address _to, uint _value) public returns (bool success);
10     function transferFrom(address _from, address _to, uint _value) public returns (bool success);
11     function approve(address _spender, uint _value) public returns (bool success);
12     function allowance(address _owner, address _spender) constant public returns (uint remaining);
13     event Transfer(address indexed _from, address indexed _to, uint _value);
14     event Approval(address indexed _owner, address indexed _spender, uint _value);
15 }
16 
17 
18 /**
19  * Checking overflows for various operations
20  */
21 library SafeMathLib {
22 
23 /**
24 * Issue: Change to internal constant
25 **/
26   function minus(uint a, uint b) internal constant returns (uint) {
27     assert(b <= a);
28     return a - b;
29   }
30 
31 /**
32 * Issue: Change to internal constant
33 **/
34   function plus(uint a, uint b) internal constant returns (uint) {
35     uint c = a + b;
36     assert(c>=a && c>=b);
37     return c;
38   }
39 
40 }
41 
42 /**
43  * @title Ownable
44  * @notice The Ownable contract has an owner address, and provides basic authorization control
45  * functions, this simplifies the implementation of "user permissions".
46  */
47 contract Ownable {
48 
49   address public owner;
50 
51   /**
52    * @notice The Ownable constructor sets the original `owner` of the contract to the sender
53    * account.
54    */
55   function Ownable() public {
56     owner = msg.sender;
57   }
58 
59   /**
60    * @notice Throws if called by any account other than the owner.
61    */
62   modifier onlyOwner() {
63     require(msg.sender == owner);
64     _;
65   }
66 
67   /**
68    * @notice Allows the current owner to transfer control of the contract to a newOwner.
69    * @param newOwner The address to transfer ownership to.
70    */
71   function transferOwnership(address newOwner) onlyOwner public {
72     require(newOwner != address(0));
73     owner = newOwner;
74   }
75     
76 }
77 
78 contract HasAddresses {
79     address teamAddress = 0xb72D3a827c7a7267C0c8E14A1F4729bF38950887;
80     address advisoryPoolAddress = 0x83a330c4A0f7b2bBe1B463F7a5a5eb6EA429E981;
81     address companyReserveAddress = 0x6F221CFDdac264146DEBaF88DaaE7Bb811C29fB5;
82     address freePoolAddress = 0x108102b4e6F92a7A140C38F3529c7bfFc950081B;
83 }
84 
85 
86 contract VestingPeriods{
87     uint teamVestingTime = 1557360000;            // GMT: Thursday, 9 May 2019 00:00:00 
88     uint advisoryPoolVestingTime = 1541721600;    // Human time (GMT): Friday, 9 November 2018 00:00:00
89     uint companyReserveAmountVestingTime = 1541721600;    // Human time (GMT): Friday, 9 November 2018 00:00:00
90 
91 }
92 
93 
94 contract Vestable {
95 
96     uint defaultVestingDate = 1526428800;  // timestamp after which transfers will be enabled,  Wednesday, 16 May 2018 00:00:00
97 
98     mapping(address => uint) vestedAddresses ;    // Addresses vested till date
99     bool isVestingOver = false;
100 
101     function addVestingAddress(address vestingAddress, uint maturityTimestamp) internal{
102         vestedAddresses[vestingAddress] = maturityTimestamp;
103     }
104 
105     function checkVestingTimestamp(address testAddress) public constant returns(uint){
106         return vestedAddresses[testAddress];
107 
108     }
109 
110     function checkVestingCondition(address sender) internal returns(bool) {
111         uint vestingTimestamp = vestedAddresses[sender];
112         if(vestingTimestamp == 0){
113             vestingTimestamp = defaultVestingDate;
114         }
115         return now > vestingTimestamp;
116     }
117 }
118 
119 /**
120  * @title ENKToken Token
121  * @notice The ERC20 Token.
122  */
123 contract ENKToken is IERC20, Ownable, Vestable, HasAddresses, VestingPeriods {
124     
125     using SafeMathLib for uint256;
126     
127     uint256 public constant totalTokenSupply = 1500000000 * 10**18;
128 
129     uint256 public burntTokens;
130 
131     string public constant name = "Enkidu";    // Enkidu
132     string public constant symbol = "ENK";  // ENK
133     uint8 public constant decimals = 18;
134             
135     mapping (address => uint256) public balances;
136     //approved[owner][spender]
137     mapping(address => mapping(address => uint256)) approved;
138     
139     function ENKToken() public {
140         
141         uint256 teamPoolAmount = 420 * 10**6 * 10**18;         // 420 million ENK
142         uint256 advisoryPoolAmount = 19 * 10**5 * 10**18;      // 1.9 million ENK
143         uint256 companyReserveAmount = 135 * 10**6 * 10**18;   // 135 million ENK
144         
145         uint256 freePoolAmmount = totalTokenSupply - teamPoolAmount - advisoryPoolAmount;     //   1.5 billion - ( 556.9 million )
146         balances[teamAddress] = teamPoolAmount;
147         balances[freePoolAddress] = freePoolAmmount;
148         balances[advisoryPoolAddress] = advisoryPoolAmount;    
149         balances[companyReserveAddress] = companyReserveAmount;
150         emit Transfer(address(this), teamAddress, teamPoolAmount);
151         emit Transfer(address(this), freePoolAddress, freePoolAmmount);
152         emit Transfer(address(this), advisoryPoolAddress, advisoryPoolAmount);
153         emit Transfer(address(this), companyReserveAddress, companyReserveAmount);
154         addVestingAddress(teamAddress, teamVestingTime);            // GMT: Thursday, 9 May 2019 00:00:00 
155         addVestingAddress(advisoryPoolAddress, advisoryPoolVestingTime);    // Human time (GMT): Friday, 9 November 2018 00:00:00
156         addVestingAddress(companyReserveAddress, companyReserveAmountVestingTime);    // Human time (GMT): Friday, 9 November 2018 00:00:00
157     }
158 
159     function burn(uint256 _value) public {
160         require (balances[msg.sender] >= _value);                 // Check if the sender has enough
161         balances[msg.sender] = balances[msg.sender].minus(_value);
162         burntTokens += _value;
163         emit BurnToken(msg.sender, _value);
164     } 
165 
166     
167     function totalSupply() constant public returns (uint256 _totalSupply) {
168         return totalTokenSupply - burntTokens;
169     }
170     
171     function balanceOf(address _owner) constant public returns (uint256 balance) {
172         return balances[_owner];
173     }
174     
175     /* Internal transfer, only can be called by this contract */
176     function _transfer(address _from, address _to, uint256 _value) internal {
177         require (_to != 0x0);                               // Prevent transfer to 0x0 address. Use burn() instead
178         require (balances[_from] >= _value);                 // Check if the sender has enough
179         require (balances[_to] + _value > balances[_to]);   // Check for overflows
180         balances[_from] = balances[_from].minus(_value);    // Subtract from the sender
181         balances[_to] = balances[_to].plus(_value);         // Add the same to the recipient
182         emit Transfer(_from, _to, _value);
183     }
184 
185     /**
186      * @notice Send `_value` tokens to `_to` from your account
187      * @param _to The address of the recipient
188      * @param _value the amount to send
189      */
190     function transfer(address _to, uint256 _value) public returns (bool success){
191         require(checkVestingCondition(msg.sender));
192         _transfer(msg.sender, _to, _value);
193         return true;
194     }
195     
196     /**
197      * @notice Send `_value` tokens to `_to` on behalf of `_from`
198      * @param _from The address of the sender
199      * @param _to The address of the recipient
200      * @param _value the amount to send
201      */
202     function transferFrom(address _from, address _to, uint256 _value) public returns (bool success) {
203         require(checkVestingCondition(_from));
204         require (_value <= approved[_from][msg.sender]);     // Check allowance
205         approved[_from][msg.sender] = approved[_from][msg.sender].minus(_value);
206         _transfer(_from, _to, _value);
207         return true;
208     }
209     
210     /**
211      * @notice Approve `_value` tokens for `_spender`
212      * @param _spender The address of the sender
213      * @param _value the amount to send
214      */
215     function approve(address _spender, uint256 _value) public returns (bool success) {
216         require(checkVestingCondition(_spender));
217         if(balances[msg.sender] >= _value) {
218             approved[msg.sender][_spender] = _value;
219             emit Approval(msg.sender, _spender, _value);
220             return true;
221         }
222         return false;
223     }
224         
225     /**
226      * @notice Check `_value` tokens allowed to `_spender` by `_owner`
227      * @param _owner The address of the Owner
228      * @param _spender The address of the Spender
229      */
230     function allowance(address _owner, address _spender) constant public returns (uint256 remaining) {
231         return approved[_owner][_spender];
232     }
233         
234     event Transfer(address indexed _from, address indexed _to, uint256 _value);
235     
236     event Approval(address indexed _owner, address indexed _spender, uint256 _value);
237 
238     event BurnToken(address _owner, uint256 _value);
239     
240 }