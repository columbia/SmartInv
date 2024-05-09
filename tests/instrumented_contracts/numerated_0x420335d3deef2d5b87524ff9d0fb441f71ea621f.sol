1 pragma solidity ^0.4.15;
2 
3 /**
4  *  Standard Interface for ERC20 Contract
5  */
6 contract IERC20 {
7     function totalSupply() constant returns (uint _totalSupply);
8     function balanceOf(address _owner) constant returns (uint balance);
9     function transfer(address _to, uint _value) returns (bool success);
10     function transferFrom(address _from, address _to, uint _value) returns (bool success);
11     function approve(address _spender, uint _value) returns (bool success);
12     function allowance(address _owner, address _spender) constant returns (uint remaining);
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
50   mapping (address => bool) public accessHolder;
51 
52   /**
53    * @notice The Ownable constructor sets the original `owner` of the contract to the sender
54    * account.
55    */
56   function Ownable() {
57     owner = msg.sender;
58   }
59 
60   /**
61    * @notice Throws if called by any account other than the owner.
62    */
63   modifier onlyOwner() {
64     require(msg.sender == owner);
65     _;
66   }
67 
68   /**
69    * @notice Allows the current owner to transfer control of the contract to a newOwner.
70    * @param newOwner The address to transfer ownership to.
71    */
72   function transferOwnership(address newOwner) onlyOwner {
73     require(newOwner != address(0));
74     owner = newOwner;
75   }
76   
77   /**
78    * @notice Adds the provided addresses to Access List.
79    * @param user The address to user to whom access is to be granted.
80    */
81   function addToAccesslist(address user) onlyOwner {
82     accessHolder[user] = true;
83   }
84   
85 }
86 
87 
88 /**
89  * @title BitIndia Coin
90  * @notice The ERC20 Token for Cove Identity.
91  */
92 contract BitIndia is IERC20, Ownable {
93     
94     using SafeMathLib for uint256;
95     
96     uint256 public constant totalTokenSupply = 180000000 * 10**18;
97 
98     string public name;    // BitIndia
99     string public symbol;  // BitIndia
100     uint8 public constant decimals = 18;
101     
102     uint private publicTransferDealine = 1509494400; //11/01/2017 @ 12:00am (UTC)
103     bool private isPublicTransferAllowed = false;
104     
105     
106     mapping (address => uint256) public balances;
107     //approved[owner][spender]
108     mapping(address => mapping(address => uint256)) approved;
109     
110     function BitIndia(string tokenName, string tokenSymbol) {
111         
112         name = tokenName;
113         symbol = tokenSymbol;
114         balances[msg.sender] = totalTokenSupply;
115 
116     }
117     
118     function totalSupply() constant returns (uint256 _totalSupply) {
119         return totalTokenSupply;
120     }
121     
122     function balanceOf(address _owner) constant returns (uint256 balance) {
123         return balances[_owner];
124     }
125     
126     /* Internal transfer, only can be called by this contract */
127     function _transfer(address _from, address _to, uint256 _value) internal {
128         require (_to != 0x0);                               // Prevent transfer to 0x0 address. Use burn() instead
129         require (balances[_from] >= _value);                 // Check if the sender has enough
130         require (balances[_to] + _value > balances[_to]);   // Check for overflows
131         balances[_from] = balances[_from].minus(_value);    // Subtract from the sender
132         balances[_to] = balances[_to].plus(_value);         // Add the same to the recipient
133         Transfer(_from, _to, _value);
134     }
135 
136     /**
137      * @notice Send `_value` tokens to `_to` from your account
138      * @param _to The address of the recipient
139      * @param _value the amount to send
140      */
141     function transfer(address _to, uint256 _value) returns (bool success) {
142         _transfer(msg.sender, _to, _value);
143         return true;
144     }
145     
146     /**
147      * @notice Send `_value` tokens to `_to` on behalf of `_from`
148      * @param _from The address of the sender
149      * @param _to The address of the recipient
150      * @param _value the amount to send
151      */
152     function transferFrom(address _from, address _to, uint256 _value) returns (bool success) {
153         require (_value <= approved[_from][msg.sender]);     // Check allowance
154         approved[_from][msg.sender] = approved[_from][msg.sender].minus(_value);
155         _transfer(_from, _to, _value);
156         return true;
157     }
158     
159     /**
160      * @notice Approve `_value` tokens for `_spender`
161      * @param _spender The address of the sender
162      * @param _value the amount to send
163      */
164     function approve(address _spender, uint256 _value) returns (bool success) {
165         if(balances[msg.sender] >= _value) {
166             approved[msg.sender][_spender] = _value;
167             Approval(msg.sender, _spender, _value);
168             return true;
169         }
170         return false;
171     }
172     
173     /**
174      * @notice Check `_value` tokens allowed to `_spender` by `_owner`
175      * @param _owner The address of the Owner
176      * @param _spender The address of the Spender
177      */
178     function allowance(address _owner, address _spender) constant returns (uint256 remaining) {
179         return approved[_owner][_spender];
180     }
181     
182     /**
183      * @notice Function to allow the Token users to transfer
184      * among themselves.
185      */
186     function allowPublicTransfer() onlyOwner {
187         isPublicTransferAllowed = true;
188     }
189     
190     event Transfer(address indexed _from, address indexed _to, uint256 _value);
191     
192     event Approval(address indexed _owner, address indexed _spender, uint256 _value);
193     
194 }