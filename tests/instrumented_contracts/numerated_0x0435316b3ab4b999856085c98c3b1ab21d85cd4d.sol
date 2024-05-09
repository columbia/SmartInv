1 pragma solidity 0.4.24;
2 
3  /**
4  * @title SafeMath
5  * @dev Math operations with safety checks that throw on error
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
34   
35   function percent(uint value,uint numerator, uint denominator, uint precision) internal pure  returns(uint quotient) {
36     uint _numerator  = numerator * 10 ** (precision+1);
37     uint _quotient =  ((_numerator / denominator) + 5) / 10;
38     return (value*_quotient/1000000000000000000);
39   }
40 }
41 
42 contract ERC20 {
43   function totalSupply()public view returns (uint total_Supply);
44   function balanceOf(address who)public view returns (uint256);
45   function allowance(address owner, address spender)public view returns (uint);
46   function transferFrom(address from, address to, uint value)public returns (bool ok);
47   function approve(address spender, uint value)public returns (bool ok);
48   function transfer(address to, uint value)public returns (bool ok);
49   event Transfer(address indexed from, address indexed to, uint value);
50   event Approval(address indexed owner, address indexed spender, uint value);
51 }
52 
53 
54 contract DeltaExCoin is ERC20 { 
55     
56     using SafeMath for uint256;
57     string public constant name     		= "DeltaExCoin";                    // Name of the token
58     string public constant symbol   		= "DLTX";                       // Symbol of token
59     uint8 public constant decimals  		= 18;                           // Decimal of token
60     uint public _totalsupply        		= 500000000 * 10 ** 18;         // 500 million total supply // muliplies dues to decimal precision
61     uint public crowdSale           		= 60000000 * 10 ** 18;          // 60 million in Crowd Sale
62     uint public posMining           		= 100000000 * 10 ** 18;         // 100 million in POS Mining
63     uint public corporateReserve    		= 140000000 * 10 ** 18;         // 140 million in Corporate Reserve
64     uint public marketinganddevelopment     = 200000000 * 10 ** 18;         // 200 million in Promotion & Bounty
65     uint public remainingToken      		= 400000000 * 10 ** 18;         // 400 million in Remaining Token | Total Supply - POS
66     address public owner;                                           // Owner of this contract
67     mapping(address => uint256) internal mintingDate;
68     mapping(address => uint) balances;
69     mapping(address => mapping(address => uint)) allowed;
70     
71     modifier onlyOwner() {
72         if (msg.sender != owner) {
73             revert();
74         }
75         _;
76     }
77 
78     function DeltaExCoin() public {
79         balances[msg.sender] = remainingToken;
80         Transfer(0, msg.sender, remainingToken);
81     }
82     
83     // what is the total supply
84     function totalSupply() public view returns (uint256 total_Supply) {
85         total_Supply = _totalsupply;
86     }
87     
88     // What is the balance of a particular account?
89     function balanceOf(address _owner) public view returns (uint256 balance) {
90         return balances[_owner];
91     }
92     
93     // Token minting function
94     function mint() public {
95         address _customerAddress = msg.sender;
96         uint256 userBalance = balances[_customerAddress];
97         uint256 currentTs = now;
98         uint256 userMintingDate = mintingDate[_customerAddress] + 7 days;
99         require (userBalance > 0);
100         require (currentTs > userMintingDate);
101         mintingDate[_customerAddress] = currentTs;
102         uint256 _bonusAmount = SafeMath.percent(userBalance,2,100,18);
103         balances[_customerAddress] = (uint256)(balances[_customerAddress]).add(_bonusAmount);
104     }
105     
106     // Send _value amount of tokens from address _from to address _to
107     // The transferFrom method is used for a withdraw workflow, allowing contracts to send
108     // tokens on your behalf, for example to "deposit" to a contract address and/or to charge
109     // fees in sub-currencies; the command should fail unless the _from account has
110     // deliberately authorized the sender of the message via some mechanism; we propose
111     // these standardized APIs for approval:
112     function transferFrom( address _from, address _to, uint256 _amount ) public returns (bool success) {
113         require( _to != 0x0);
114         require(balances[_from] >= _amount && allowed[_from][msg.sender] >= _amount && _amount >= 0);
115         balances[_from] = (balances[_from]).sub(_amount);
116         allowed[_from][msg.sender] = (allowed[_from][msg.sender]).sub(_amount);
117         balances[_to] = (balances[_to]).add(_amount);
118         Transfer(_from, _to, _amount);
119         return true;
120     }
121     
122     // Allow _spender to withdraw from your account, multiple times, up to the _value amount.
123     // If this function is called again it overwrites the current allowance with _value.
124     function approve(address _spender, uint256 _amount) public returns (bool success) {
125         require( _spender != 0x0);
126         allowed[msg.sender][_spender] = _amount;
127         Approval(msg.sender, _spender, _amount);
128         return true;
129     }
130   
131     function allowance(address _owner, address _spender) public view returns (uint256 remaining) {
132         require( _owner != 0x0 && _spender !=0x0);
133         return allowed[_owner][_spender];
134     }
135 
136     // Transfer the balance from owner's account to another account
137     function transfer(address _to, uint256 _amount) public returns (bool success) {
138         require( _to != 0x0);
139         require(balances[msg.sender] >= _amount && _amount >= 0);
140         
141         address _customerAddress = msg.sender;
142         uint256 currentTs = now;
143         uint256 userMintingDate = mintingDate[_customerAddress] + 7 days;
144         require (currentTs > userMintingDate);
145         
146         balances[msg.sender] = (balances[msg.sender]).sub(_amount);
147         balances[_to] = (balances[_to]).add(_amount);
148         Transfer(msg.sender, _to, _amount);
149         return true;
150     }
151     
152     // Transfer the balance from owner's account to another account
153     function transferTokens(address _to, uint256 _amount) private returns (bool success) {
154         require( _to != 0x0);       
155         require(balances[address(this)] >= _amount && _amount > 0);
156         balances[address(this)] = (balances[address(this)]).sub(_amount);
157         balances[_to] = (balances[_to]).add(_amount);
158         Transfer(address(this), _to, _amount);
159         return true;
160     }
161  
162     function drain() external onlyOwner {
163         owner.transfer(this.balance);
164     }
165 }