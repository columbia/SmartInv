1 pragma solidity 0.4.25;
2 /**
3  * @title SafeMath
4  * @dev Math operations with safety checks that throw on error
5  */
6 library SafeMath {
7   function mul(uint256 a, uint256 b) internal pure returns (uint256) {
8     if (a == 0) {
9       return 0;
10     }
11     uint256 c = a * b;
12     assert(c / a == b);
13     return c;
14   }
15 
16   function div(uint256 a, uint256 b) internal pure returns (uint256) {
17     require(b > 0); // Solidity automatically throws when dividing by 0
18     uint256 c = a / b;
19     assert(a == b * c + a % b); // There is no case in which this doesn't hold
20     return c;
21   }
22 
23   function sub(uint256 a, uint256 b) internal pure returns (uint256) {
24     require(b <= a);
25     return a - b;
26   }
27 
28   function add(uint256 a, uint256 b) internal pure returns (uint256) {
29     uint256 c = a + b;
30     require(c >= a);
31     return c;
32   }
33 }
34 contract owned {
35     address public owner;
36     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
37     
38     constructor() public {
39         owner = msg.sender;
40     }
41 
42     modifier onlyOwner {
43         require(msg.sender == owner , "Unauthorized Access");
44         _;
45     }
46 
47     function transferOwnership(address newOwner) onlyOwner public {
48         require(newOwner != address(0));
49         emit OwnershipTransferred(owner, newOwner);
50         owner = newOwner;
51     }
52 }
53 interface tokenRecipient { function receiveApproval(address _from, uint256 _value, address _token, bytes _extraData) external; }
54 interface ERC20Interface {
55    
56       /// @param _owner The address from which the balance will be retrieved
57     /// @return The balance
58     function balanceOf(address _owner) view external returns (uint256 balance);
59 
60     /// @notice send `_value` token to `_to` from `msg.sender`
61     /// @param _to The address of the recipient
62     /// @param _value The amount of token to be transferred
63     /// @return Whether the transfer was successful or not
64     function transfer(address _to, uint256 _value) external returns (bool success);
65 
66     /// @notice send `_value` token to `_to` from `_from` on the condition it is approved by `_from`
67     /// @param _from The address of the sender
68     /// @param _to The address of the recipient
69     /// @param _value The amount of token to be transferred
70     /// @return Whether the transfer was successful or not
71     function transferFrom(address _from, address _to, uint256 _value) external returns (bool success);
72 
73     
74 
75     event Transfer(address indexed _from, address indexed _to, uint256 _value);
76 
77    
78     function approve(address _spender, uint256 _value) external returns (bool success);
79     function disApprove(address _spender)  external returns (bool success);
80    function increaseApproval(address _spender, uint _addedValue) external returns (bool success);
81    function decreaseApproval(address _spender, uint _subtractedValue) external returns (bool success);
82      /// @param _owner The address of the account owning tokens
83     /// @param _spender The address of the account able to transfer the tokens
84     /// @return Amount of remaining tokens allowed to spent
85     function allowance(address _owner, address _spender) constant external returns (uint256 remaining);
86      function name() external view returns (string _name);
87 
88     /* Get the contract constant _symbol */
89     function symbol() external view returns (string _symbol);
90 
91     /* Get the contract constant _decimals */
92     function decimals() external view returns (uint8 _decimals); 
93     event Approval(address indexed _owner, address indexed _spender, uint256 _value);
94 }
95 library SafeERC20{
96 
97   function safeTransfer(ERC20Interface token, address to, uint256 value) internal {
98     assert(token.transfer(to, value));
99   }    
100     
101   
102 
103   function safeTransferFrom(ERC20Interface token, address from, address to, uint256 value) internal {
104     assert(token.transferFrom(from, to, value));
105   }
106 
107   function safeApprove(ERC20Interface token, address spender, uint256 value) internal {
108     assert(token.approve(spender, value));
109   }
110 }
111 
112 contract TansalICOTokenVault is owned{
113     
114      using SafeERC20 for ERC20Interface;
115      ERC20Interface TansalCoin;
116       struct Investor {
117         string fName;
118         string lName;
119         uint256 totalTokenWithdrawn;
120         bool exists;
121     }
122     
123     mapping (address => Investor) public investors;
124     address[] public investorAccts;
125     uint256 public numberOFApprovedInvestorAccounts;
126 
127      constructor() public
128      {
129          
130          TansalCoin = ERC20Interface(0x0EF0183E9Db9069a7207543db99a4Ec4d06f11cB);
131      }
132     
133      function() public {
134          //not payable fallback function
135           revert();
136     }
137     
138      function sendApprovedTokensToInvestor(address _benificiary,uint256 _approvedamount,string _fName, string _lName) public onlyOwner
139     {
140         uint256 totalwithdrawnamount;
141         require(TansalCoin.balanceOf(address(this)) > _approvedamount);
142         if(investors[_benificiary].exists)
143         {
144             uint256 alreadywithdrawn = investors[_benificiary].totalTokenWithdrawn;
145             totalwithdrawnamount = alreadywithdrawn + _approvedamount;
146             
147         }
148         else
149         {
150           totalwithdrawnamount = _approvedamount;
151           investorAccts.push(_benificiary) -1;
152         }
153          investors[_benificiary] = Investor({
154                                             fName: _fName,
155                                             lName: _lName,
156                                             totalTokenWithdrawn: totalwithdrawnamount,
157                                             exists: true
158             
159         });
160         numberOFApprovedInvestorAccounts = investorAccts.length;
161         TansalCoin.safeTransfer(_benificiary , _approvedamount);
162     }
163     
164      function onlyPayForFuel() public payable onlyOwner{
165         // Owner will pay in contract to bear the gas price if transactions made from contract
166         
167     }
168     function withdrawEtherFromcontract(uint _amountInwei) public onlyOwner{
169         require(address(this).balance > _amountInwei);
170       require(msg.sender == owner);
171       owner.transfer(_amountInwei);
172      
173     }
174     function withdrawTokenFromcontract(ERC20Interface _token, uint256 _tamount) public onlyOwner{
175         require(_token.balanceOf(address(this)) > _tamount);
176          _token.safeTransfer(owner, _tamount);
177      
178     }
179 }