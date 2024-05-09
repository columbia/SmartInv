1 pragma solidity 0.4.24;
2 
3 interface tokenRecipient { function receiveApproval(address _from, uint256 _value, address _token, bytes _extraData) external; }
4 
5 library SafeMath {
6   function mul(uint256 a, uint256 b) internal pure returns (uint256) {
7     if (a == 0) {
8       return 0;
9     }
10     uint256 c = a * b;
11     assert(c / a == b);
12     return c;
13   }
14 
15   function div(uint256 a, uint256 b) internal pure returns (uint256) {
16     // assert(b > 0); // Solidity automatically throws when dividing by 0
17     uint256 c = a / b;
18     // assert(a == b * c + a % b); // There is no case in which this doesn't hold
19     return c;
20   }
21 
22   function sub(uint256 a, uint256 b) internal pure returns (uint256) {
23     assert(b <= a);
24     return a - b;
25   }
26 
27   function add(uint256 a, uint256 b) internal pure returns (uint256) {
28     uint256 c = a + b;
29     assert(c >= a);
30     return c;
31   }
32 }
33 
34 contract ERC20 {
35   function totalSupply()public view returns (uint256 total_Supply);
36   function balanceOf(address _owner)public view returns (uint256 balance);
37   function allowance(address _owner, address _spender)public view returns (uint256 remaining);
38   function transferFrom(address _from, address _to, uint256 _amount)public returns (bool ok);
39   function approve(address _spender, uint256 _amount)public returns (bool ok);
40   function transfer(address _to, uint256 _amount)public returns (bool ok);
41   event Transfer(address indexed _from, address indexed _to, uint256 _amount);
42   event Approval(address indexed _owner, address indexed _spender, uint256 _amount);
43 }
44 
45 contract DCLINIC is ERC20
46 {
47     using SafeMath for uint256;
48     string public constant symbol = "DHC";
49     string public constant name = "DCLINIC";
50     uint8 public constant decimals = 6;
51     uint256 public _totalSupply = 5000000000 * 10 ** uint256(decimals);     // 5 bilion supply           
52     // Balances for each account
53     mapping(address => uint256) balances;  
54     mapping (address => mapping (address => uint)) allowed;
55     
56     // Owner of this contract
57     address public owner;
58     uint256 public owner_balance = _totalSupply;
59 
60     event Transfer(address indexed _from, address indexed _to, uint _value);
61     event Approval(address indexed _owner, address indexed _spender, uint _value);
62 
63     modifier onlyOwner() {
64       if (msg.sender != owner) {
65             revert();
66         }
67         _;
68         }
69     
70     constructor () public
71     {
72         owner = msg.sender;
73         balances[owner] = owner_balance; // 5 billion with owner
74         emit Transfer(0x00, owner, owner_balance);
75     }
76     
77     //contract will not accept any ether sent accidently to the contract address
78     function () public payable 
79     {
80         revert();
81     }
82 
83     
84      // total supply of the tokens
85     function totalSupply() public view returns (uint256 total_Supply) {
86          total_Supply = _totalSupply;
87      }
88   
89      //  balance of a particular account
90      function balanceOf(address _owner)public view returns (uint256 balance) {
91          return balances[_owner];
92      }
93   
94      // Transfer the balance from owner's account to another account
95      function transfer(address _to, uint256 _amount)public returns (bool success) {
96          require( _to != 0x0);
97          require(balances[msg.sender] >= _amount 
98              && _amount >= 0
99              && balances[_to] + _amount >= balances[_to]);
100              balances[msg.sender] = balances[msg.sender].sub(_amount);
101              balances[_to] = balances[_to].add(_amount);
102              emit Transfer(msg.sender, _to, _amount);
103              return true;
104      }
105   
106      // Send _value amount of tokens from address _from to address _to
107      // The transferFrom method is used for a withdraw workflow, allowing contracts to send
108      // tokens on your behalf, for example to "deposit" to a contract address and/or to charge
109      // fees in sub-currencies; the command should fail unless the _from account has
110      // deliberately authorized the sender of the message via some mechanism; we propose
111      // these standardized APIs for approval:
112      function transferFrom(
113          address _from,
114          address _to,
115          uint256 _amount
116      )public returns (bool success) {
117         require(_to != 0x0); 
118          require(balances[_from] >= _amount
119              && allowed[_from][msg.sender] >= _amount
120              && _amount >= 0
121              && balances[_to] + _amount >= balances[_to]);
122              balances[_from] = balances[_from].sub(_amount);
123              allowed[_from][msg.sender] = allowed[_from][msg.sender].sub(_amount);
124              balances[_to] = balances[_to].add(_amount);
125              emit Transfer(_from, _to, _amount);
126              return true;
127              }
128  
129      // Allow _spender to withdraw from your account, multiple times, up to the _value amount.
130      // If this function is called again it overwrites the current allowance with _value.
131      function approve(address _spender, uint256 _amount)public returns (bool success) {
132          allowed[msg.sender][_spender] = _amount;
133          emit Approval(msg.sender, _spender, _amount);
134          return true;
135      }
136   
137      function allowance(address _owner, address _spender)public view returns (uint256 remaining) {
138          return allowed[_owner][_spender];
139    }
140    
141    	//In case the ownership needs to be transferred
142 	function transferOwnership(address newOwner)public onlyOwner
143 	{
144 	    require( newOwner != 0x0);
145 	    uint256 transferredBalance = balances[owner];
146 	    balances[newOwner] = balances[newOwner].add(balances[owner]);
147 	    balances[owner] = 0;
148 	    address oldOwner = owner;
149 	    owner = newOwner;
150 	    emit Transfer(oldOwner, owner, transferredBalance);
151 	}
152 	
153 	 //Burning tokens should be called after ICo ends
154     function burntokens(uint256 burn_amount) external onlyOwner {
155         require(burn_amount >0 && burn_amount <= balances[owner]);
156          _totalSupply = (_totalSupply).sub(burn_amount);
157          balances[owner] = (balances[owner].sub(burn_amount));
158           emit Transfer(owner, 0x00, burn_amount);
159      }
160     
161     // used to send tokens to other contract and notify
162     
163         function approveAndCall(address _spender, uint256 _value, bytes _extraData)
164         public
165         returns (bool success) {
166         tokenRecipient spender = tokenRecipient(_spender);
167         if (approve(_spender, _value)) {
168             spender.receiveApproval(msg.sender, _value, this, _extraData);
169             return true;
170         }
171     }
172 }