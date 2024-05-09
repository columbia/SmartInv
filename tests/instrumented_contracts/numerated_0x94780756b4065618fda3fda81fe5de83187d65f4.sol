1 pragma solidity ^0.4.18;
2 
3 /**
4  * @title SafeMath
5  * @dev Math operations for Binkey Coins (BNKY) with Gateway operations and safety checks that throw on error
6  */
7 library SafeMath {
8   function mul(uint256 a, uint256 b) internal pure returns (uint256) {
9     if (a == 0) {
10       return 0;
11     }
12     uint256 c = a * b;
13     assert(c / a == b);
14     return c;
15   }
16 
17   function div(uint256 a, uint256 b) internal pure returns (uint256) {
18     // assert(b > 0); // Solidity automatically throws when dividing by 0
19     uint256 c = a / b;
20     // assert(a == b * c + a % b); // There is no case in which this doesn't hold
21     return c;
22   }
23 
24   function sub(uint256 a, uint256 b) internal pure returns (uint256) {
25     assert(b <= a);
26     return a - b;
27   }
28 
29   function add(uint256 a, uint256 b) internal pure returns (uint256) {
30     uint256 c = a + b;
31     assert(c >= a);
32     return c;
33   }
34 }
35 
36 contract Token {
37   /// @return total amount of tokens
38   function totalSupply() public constant returns (uint256 supply);
39 
40   /// @param _owner The address from which the balance will be retrieved
41   /// @return The balance
42   function balanceOf(address _owner) public constant returns (uint256 balance);
43 
44   /// @notice send `_value` token to `_to` from `msg.sender`
45   /// @param _to The address of the recipient
46   /// @param _value The amount of token to be transferred
47   /// @return Whether the transfer was successful or not
48   function transfer(address _to, uint256 _value) public returns (bool success);
49 
50   /// @notice send `_value` token to `_to` from `_from` on the condition it is approved by `_from`
51   /// @param _from The address of the sender
52   /// @param _to The address of the recipient
53   /// @param _value The amount of token to be transferred
54   /// @return Whether the transfer was successful or not
55   function transferFrom(address _from, address _to, uint256 _value) public returns (bool success);
56 
57   /// @notice `msg.sender` approves `_addr` to spend `_value` tokens
58   /// @param _spender The address of the account able to transfer the tokens
59   /// @param _value The amount of wei to be approved for transfer
60   /// @return Whether the approval was successful or not
61   function approve(address _spender, uint256 _value) public returns (bool success);
62 
63   /// @param _owner The address of the account owning tokens
64   /// @param _spender The address of the account able to transfer the tokens
65   /// @return Amount of remaining tokens allowed to spent
66   function allowance(address _owner, address _spender) public constant returns (uint256 remaining);
67 
68   event Transfer(address indexed _from, address indexed _to, uint256 _value);
69   event Approval(address indexed _owner, address indexed _spender, uint256 _value);
70 
71   uint public decimals;
72   string public name;
73 }
74 
75 /**
76  * @title Ownable
77  * @dev The Ownable contract has an owner address, and provides basic authorization control
78  * functions, this simplifies the implementation of "user permissions".
79  */
80 contract Ownable {
81     
82   address public owner;
83 
84   /**
85    * @dev The Ownable constructor sets the original `owner` of the contract to the sender
86    * account.
87    */
88   constructor() public {
89     owner = msg.sender;
90   }
91 
92   /**
93    * @dev Throws if called by any account other than the owner.
94    */
95   modifier onlyOwner() {
96     require(msg.sender == owner);
97     _;
98   }
99 
100   /**
101    * @dev Allows the current owner to transfer control of the contract to a newOwner.
102    * @param newOwner The address to transfer ownership to.
103    */
104   function transferOwnership(address newOwner) onlyOwner public {
105     require(newOwner != address(0));      
106     owner = newOwner;
107   }
108 
109 }
110 contract Gateway is Ownable{
111     using SafeMath for uint;
112     address public feeAccount1 = 0xec2c6cf5f919e538975e6c58dfa315b803223ce2; //the account1 that will receive fees
113     address public feeAccount2 = 0xec2c6cf5f919e538975e6c58dfa315b803223ce2; //the account2 that will receive fees
114     
115     struct BuyInfo {
116       address buyerAddress; 
117       address sellerAddress;
118       uint value;
119       address currency;
120     }
121     
122     mapping(address => mapping(uint => BuyInfo)) public payment;
123    
124     mapping(address => uint) public balances;
125     uint balanceFee;
126     uint public feePercent;
127     uint public maxFee;
128     constructor() public{
129        feePercent = 1500000; // decimals 6. 1,5% fee by default
130        maxFee = 3000000; // fee can not exceed 3%
131     }
132     
133     
134     function getBuyerAddressPayment(address _sellerAddress, uint _orderId) public constant returns(address){
135       return  payment[_sellerAddress][_orderId].buyerAddress;
136     }    
137     function getSellerAddressPayment(address _sellerAddress, uint _orderId) public constant returns(address){
138       return  payment[_sellerAddress][_orderId].sellerAddress;
139     }    
140     
141     function getValuePayment(address _sellerAddress, uint _orderId) public constant returns(uint){
142       return  payment[_sellerAddress][_orderId].value;
143     }    
144     
145     function getCurrencyPayment(address _sellerAddress, uint _orderId) public constant returns(address){
146       return  payment[_sellerAddress][_orderId].currency;
147     }
148     
149     
150     function setFeeAccount1(address _feeAccount1) onlyOwner public{
151       feeAccount1 = _feeAccount1;  
152     }
153     function setFeeAccount2(address _feeAccount2) onlyOwner public{
154       feeAccount2 = _feeAccount2;  
155     }
156     function setFeePercent(uint _feePercent) onlyOwner public{
157       require(_feePercent <= maxFee);
158       feePercent = _feePercent;  
159     }    
160     function payToken(address _tokenAddress, address _sellerAddress, uint _orderId,  uint _value) public returns (bool success){
161       require(_tokenAddress != address(0));
162       require(_sellerAddress != address(0)); 
163       require(_value > 0);
164       Token token = Token(_tokenAddress);
165       require(token.allowance(msg.sender, this) >= _value);
166       token.transferFrom(msg.sender, _sellerAddress, _value);
167       payment[_sellerAddress][_orderId] = BuyInfo(msg.sender, _sellerAddress, _value, _tokenAddress);
168       success = true;
169     }
170     function payEth(address _sellerAddress, uint _orderId, uint _value) public returns  (bool success){
171       require(_sellerAddress != address(0)); 
172       require(_value > 0);
173       require(balances[msg.sender] >= _value);
174       uint fee = _value.mul(feePercent).div(100000000);
175       balances[msg.sender] = balances[msg.sender].sub(_value);
176       _sellerAddress.transfer(_value.sub(fee));
177       balanceFee = balanceFee.add(fee);
178       payment[_sellerAddress][_orderId] = BuyInfo(msg.sender, _sellerAddress, _value, 0x0000000000000000000000000000000000000001);    
179       success = true;
180     }
181     function transferFee() onlyOwner public{
182       uint valfee1 = balanceFee.div(2);
183       feeAccount1.transfer(valfee1);
184       balanceFee = balanceFee.sub(valfee1);
185       feeAccount2.transfer(balanceFee);
186       balanceFee = 0;
187     }
188     function balanceOfToken(address _tokenAddress, address _Address) public constant returns (uint) {
189       Token token = Token(_tokenAddress);
190       return token.balanceOf(_Address);
191     }
192     function balanceOfEthFee() public constant returns (uint) {
193       return balanceFee;
194     }
195     function refund() public{
196       require(balances[msg.sender] > 0);
197       uint value = balances[msg.sender];
198       balances[msg.sender] = 0;
199       msg.sender.transfer(value);
200     }
201     function getBalanceEth() public constant returns(uint){
202       return balances[msg.sender];    
203     }
204     function() external payable {
205       balances[msg.sender] = balances[msg.sender].add(msg.value);    
206   }
207 }