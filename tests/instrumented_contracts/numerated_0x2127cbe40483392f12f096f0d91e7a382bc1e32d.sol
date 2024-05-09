1 pragma solidity 0.4.18;
2 
3 /**
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
34 }
35 
36   contract ERC20 {
37   function totalSupply()public view returns (uint total_Supply);
38   function balanceOf(address _owner)public view returns (uint256 balance);
39   function allowance(address _owner, address _spender)public view returns (uint remaining);
40   function transferFrom(address _from, address _to, uint _amount)public returns (bool ok);
41   function approve(address _spender, uint _amount)public returns (bool ok);
42   function transfer(address _to, uint _amount)public returns (bool ok);
43   event Transfer(address indexed _from, address indexed _to, uint _amount);
44   event Approval(address indexed _owner, address indexed _spender, uint _amount);
45 }
46 
47 contract jioCoin is ERC20
48 {
49     using SafeMath for uint256;
50     string public constant symbol = "JIO";
51     string public constant name = "JIO Coin";
52     uint8 public constant decimals = 4;
53     // 100 million total supply // muliplies dues to decimal precision
54     uint256 public _totalSupply = 500000000000 * 10 **4;   // 500 billion            
55     // Balances for each account
56     mapping(address => uint256) balances;   
57     // Owner of this contract
58     address public owner;
59     
60 
61     mapping (address => mapping (address => uint)) allowed;
62     
63     event Transfer(address indexed _from, address indexed _to, uint _value);
64     event Approval(address indexed _owner, address indexed _spender, uint _value);
65 
66     modifier onlyOwner() {
67       if (msg.sender != owner) {
68             revert();
69         }
70         _;
71         }
72         
73     
74     function jioCoin() public
75     {
76         owner = msg.sender;
77         balances[owner] = _totalSupply; // 500 billion token with company/owner
78 
79     }
80 
81 
82     
83     // total supply of the tokens
84     function totalSupply() public view returns (uint256 total_Supply) {
85          total_Supply = _totalSupply;
86      }
87   
88      //  balance of a particular account
89      function balanceOf(address _owner)public view returns (uint256 balance) {
90          return balances[_owner];
91      }
92   
93      // Transfer the balance from owner's account to another account
94      function transfer(address _to, uint256 _amount)public returns (bool success) {
95          require( _to != 0x0);
96          require(balances[msg.sender] >= _amount 
97              && _amount >= 0
98              && balances[_to] + _amount >= balances[_to]);
99              balances[msg.sender] = balances[msg.sender].sub(_amount);
100              balances[_to] = balances[_to].add(_amount);
101              Transfer(msg.sender, _to, _amount);
102              return true;
103      }
104   
105      // Send _value amount of tokens from address _from to address _to
106      // The transferFrom method is used for a withdraw workflow, allowing contracts to send
107      // tokens on your behalf, for example to "deposit" to a contract address and/or to charge
108      // fees in sub-currencies; the command should fail unless the _from account has
109      // deliberately authorized the sender of the message via some mechanism; we propose
110      // these standardized APIs for approval:
111      function transferFrom(
112          address _from,
113          address _to,
114          uint256 _amount
115      )public returns (bool success) {
116         require(_to != 0x0); 
117          require(balances[_from] >= _amount
118              && allowed[_from][msg.sender] >= _amount
119              && _amount >= 0
120              && balances[_to] + _amount >= balances[_to]);
121              balances[_from] = balances[_from].sub(_amount);
122              allowed[_from][msg.sender] = allowed[_from][msg.sender].sub(_amount);
123              balances[_to] = balances[_to].add(_amount);
124              Transfer(_from, _to, _amount);
125              return true;
126              }
127  
128      // Allow _spender to withdraw from your account, multiple times, up to the _value amount.
129      // If this function is called again it overwrites the current allowance with _value.
130      function approve(address _spender, uint256 _amount)public returns (bool success) {
131          allowed[msg.sender][_spender] = _amount;
132          Approval(msg.sender, _spender, _amount);
133          return true;
134      }
135   
136      function allowance(address _owner, address _spender)public view returns (uint256 remaining) {
137          return allowed[_owner][_spender];
138    }
139 
140 	// drain ether called by only owner
141 	function drain() external onlyOwner {
142         owner.transfer(this.balance);
143     }
144     
145 }