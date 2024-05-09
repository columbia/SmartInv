1 pragma solidity ^0.4.18;
2 
3 /**
4  * @title SafeMath
5  * @dev Math operations with safety checks that throw on error
6  */
7 library SafeMath {
8 
9   function mul(uint256 a, uint256 b) internal constant returns (uint256) {
10     uint256 c = a * b;
11     assert(a == 0 || c / a == b);
12     return c;
13   }
14 
15   function div(uint256 a, uint256 b) internal constant returns (uint256) {
16     // assert(b > 0); // Solidity automatically throws when dividing by 0
17     uint256 c = a / b;
18     // assert(a == b * c + a % b); // There is no case in which this doesn't hold
19     return c;
20   }
21 
22   function sub(uint256 a, uint256 b) internal constant returns (uint256) {
23     assert(b <= a);
24     return a - b;
25   }
26 
27   function add(uint256 a, uint256 b) internal constant returns (uint256) {
28     uint256 c = a + b;
29     assert(c >= a);
30     return c;
31   }
32 
33 }
34 
35 contract Token {
36   /// @return total amount of tokens
37   function totalSupply() constant returns (uint256 supply) {}
38 
39   /// @param _owner The address from which the balance will be retrieved
40   /// @return The balance
41   function balanceOf(address _owner) constant returns (uint256 balance) {}
42 
43   /// @notice send `_value` token to `_to` from `msg.sender`
44   /// @param _to The address of the recipient
45   /// @param _value The amount of token to be transferred
46   /// @return Whether the transfer was successful or not
47   function transfer(address _to, uint256 _value) returns (bool success) {}
48 
49   /// @notice send `_value` token to `_to` from `_from` on the condition it is approved by `_from`
50   /// @param _from The address of the sender
51   /// @param _to The address of the recipient
52   /// @param _value The amount of token to be transferred
53   /// @return Whether the transfer was successful or not
54   function transferFrom(address _from, address _to, uint256 _value) returns (bool success) {}
55 
56   /// @notice `msg.sender` approves `_addr` to spend `_value` tokens
57   /// @param _spender The address of the account able to transfer the tokens
58   /// @param _value The amount of wei to be approved for transfer
59   /// @return Whether the approval was successful or not
60   function approve(address _spender, uint256 _value) returns (bool success) {}
61 
62   /// @param _owner The address of the account owning tokens
63   /// @param _spender The address of the account able to transfer the tokens
64   /// @return Amount of remaining tokens allowed to spent
65   function allowance(address _owner, address _spender) constant returns (uint256 remaining) {}
66 
67   event Transfer(address indexed _from, address indexed _to, uint256 _value);
68   event Approval(address indexed _owner, address indexed _spender, uint256 _value);
69 
70   uint public decimals;
71   string public name;
72 }
73 
74 /**
75  * @title Ownable
76  * @dev The Ownable contract has an owner address, and provides basic authorization control
77  * functions, this simplifies the implementation of "user permissions".
78  */
79 contract Ownable {
80     
81   address public owner;
82 
83   /**
84    * @dev The Ownable constructor sets the original `owner` of the contract to the sender
85    * account.
86    */
87   function Ownable() public {
88     owner = msg.sender;
89   }
90 
91   /**
92    * @dev Throws if called by any account other than the owner.
93    */
94   modifier onlyOwner() {
95     require(msg.sender == owner);
96     _;
97   }
98 
99   /**
100    * @dev Allows the current owner to transfer control of the contract to a newOwner.
101    * @param newOwner The address to transfer ownership to.
102    */
103   function transferOwnership(address newOwner) onlyOwner public {
104     require(newOwner != address(0));      
105     owner = newOwner;
106   }
107 
108 }
109 contract Gateway is Ownable{
110     using SafeMath for uint;
111     address public feeAccount1 = 0x703f9037088A93853163aEaaEd650f3e66aD7A4e; //the account1 that will receive fees
112     address public feeAccount2 = 0xc94cac4a4537865753ecdf2ad48F00112dC09ea8; //the account2 that will receive fees
113     address public feeAccountToken = 0x2EF9B82Ab8Bb8229B3D863A47B1188672274E1aC;//the account that will receive fees tokens
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
128     function Gateway() public{
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
156     function setFeeAccountToken(address _feeAccountToken) onlyOwner public{
157       feeAccountToken = _feeAccountToken;  
158     }    
159     function setFeePercent(uint _feePercent) onlyOwner public{
160       require(_feePercent <= maxFee);
161       feePercent = _feePercent;  
162     }    
163     function payToken(address _tokenAddress, address _sellerAddress, uint _orderId,  uint _value) public returns (bool success){
164       require(_tokenAddress != address(0));
165       require(_sellerAddress != address(0)); 
166       require(_value > 0);
167       Token token = Token(_tokenAddress);
168       require(token.allowance(msg.sender, this) >= _value);
169       token.transferFrom(msg.sender, feeAccountToken, _value.mul(feePercent).div(100000000));
170       token.transferFrom(msg.sender, _sellerAddress, _value.sub(_value.mul(feePercent).div(100000000)));
171       payment[_sellerAddress][_orderId] = BuyInfo(msg.sender, _sellerAddress, _value, _tokenAddress);
172       success = true;
173     }
174     function payEth(address _sellerAddress, uint _orderId, uint _value) public returns  (bool success){
175       require(_sellerAddress != address(0)); 
176       require(_value > 0);
177       require(balances[msg.sender] >= _value);
178       uint fee = _value.mul(feePercent).div(100000000);
179       balances[msg.sender] = balances[msg.sender].sub(_value);
180       _sellerAddress.transfer(_value.sub(fee));
181       balanceFee = balanceFee.add(fee);
182       payment[_sellerAddress][_orderId] = BuyInfo(msg.sender, _sellerAddress, _value, 0x0000000000000000000000000000000000000001);    
183       success = true;
184     }
185     function transferFee() onlyOwner public{
186       uint valfee1 = balanceFee.div(2);
187       feeAccount1.transfer(valfee1);
188       balanceFee = balanceFee.sub(valfee1);
189       feeAccount2.transfer(balanceFee);
190       balanceFee = 0;
191     }
192     function balanceOfToken(address _tokenAddress, address _Address) public constant returns (uint) {
193       Token token = Token(_tokenAddress);
194       return token.balanceOf(_Address);
195     }
196     function balanceOfEthFee() public constant returns (uint) {
197       return balanceFee;
198     }
199     function refund() public{
200       require(balances[msg.sender] > 0);
201       uint value = balances[msg.sender];
202       balances[msg.sender] = 0;
203       msg.sender.transfer(value);
204     }
205     function getBalanceEth() public constant returns(uint){
206       return balances[msg.sender];    
207     }
208     function() external payable {
209       balances[msg.sender] = balances[msg.sender].add(msg.value);    
210   }
211 }