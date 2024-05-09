1 pragma solidity 0.4.18;
2   
3   contract ERC20 {
4   function totalSupply()public view returns (uint total_Supply);
5   function balanceOf(address _owner)public view returns (uint256 balance);
6   function allowance(address _owner, address _spender)public view returns (uint remaining);
7   function transferFrom(address _from, address _to, uint _amount)public returns (bool ok);
8   function approve(address _spender, uint _amount)public returns (bool ok);
9   function transfer(address _to, uint _amount)public returns (bool ok);
10   event Transfer(address indexed _from, address indexed _to, uint _amount);
11   event Approval(address indexed _owner, address indexed _spender, uint _amount);
12 }
13 
14 /**
15  * @title SafeMath
16  * @dev Math operations with safety checks that throw on error
17  */
18 library SafeMath {
19   function mul(uint256 a, uint256 b) internal pure returns (uint256) {
20     if (a == 0) {
21       return 0;
22     }
23     uint256 c = a * b;
24     assert(c / a == b);
25     return c;
26   }
27 
28   function div(uint256 a, uint256 b) internal pure returns (uint256) {
29     // assert(b > 0); // Solidity automatically throws when dividing by 0
30     uint256 c = a / b;
31     // assert(a == b * c + a % b); // There is no case in which this doesn't hold
32     return c;
33   }
34 
35   function sub(uint256 a, uint256 b) internal pure returns (uint256) {
36     assert(b <= a);
37     return a - b;
38   }
39 
40   function add(uint256 a, uint256 b) internal pure returns (uint256) {
41     uint256 c = a + b;
42     assert(c >= a);
43     return c;
44   }
45 }
46 
47 contract Bitcoiin is ERC20
48 {
49     using SafeMath for uint256;
50     string public constant symbol = "B2G";
51     string public constant name = "Bitcoiin";
52     uint8 public constant decimals = 10;
53      // muliplies dues to decimal precision
54     uint256 public _totalSupply = 50000000 * 10 **10;     // 50 million supply           
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
66     event LOG(string e,uint256 value);
67     
68     modifier onlyOwner() {
69       if (msg.sender != owner) {
70             revert();
71         }
72         _;
73         }
74 
75     
76     function Bitcoiin() public
77     {
78         owner = msg.sender;
79         balances[owner] = _totalSupply; 
80     }
81     
82     // total supply of the tokens
83     function totalSupply() public view returns (uint256 total_Supply) {
84          total_Supply = _totalSupply;
85      }
86   
87      //  balance of a particular account
88      function balanceOf(address _owner)public view returns (uint256 balance) {
89          return balances[_owner];
90      }
91   
92      // Transfer the balance from owner's account to another account
93      function transfer(address _to, uint256 _amount)public returns (bool success) {
94          require( _to != 0x0);
95          require(balances[msg.sender] >= _amount 
96              && _amount >= 0
97              && balances[_to] + _amount >= balances[_to]);
98              balances[msg.sender] = balances[msg.sender].sub(_amount);
99              balances[_to] = balances[_to].add(_amount);
100              Transfer(msg.sender, _to, _amount);
101              return true;
102      }
103   
104      // Send _value amount of tokens from address _from to address _to
105      // The transferFrom method is used for a withdraw workflow, allowing contracts to send
106      // tokens on your behalf, for example to "deposit" to a contract address and/or to charge
107      // fees in sub-currencies; the command should fail unless the _from account has
108      // deliberately authorized the sender of the message via some mechanism; we propose
109      // these standardized APIs for approval:
110      function transferFrom(
111          address _from,
112          address _to,
113          uint256 _amount
114      )public returns (bool success) {
115         require(_to != 0x0); 
116          require(balances[_from] >= _amount
117              && allowed[_from][msg.sender] >= _amount
118              && _amount >= 0
119              && balances[_to] + _amount >= balances[_to]);
120              balances[_from] = balances[_from].sub(_amount);
121              allowed[_from][msg.sender] = allowed[_from][msg.sender].sub(_amount);
122              balances[_to] = balances[_to].add(_amount);
123              Transfer(_from, _to, _amount);
124              return true;
125              }
126  
127      // Allow _spender to withdraw from your account, multiple times, up to the _value amount.
128      // If this function is called again it overwrites the current allowance with _value.
129      function approve(address _spender, uint256 _amount)public returns (bool success) {
130          allowed[msg.sender][_spender] = _amount;
131          Approval(msg.sender, _spender, _amount);
132          return true;
133      }
134   
135      function allowance(address _owner, address _spender)public view returns (uint256 remaining) {
136          return allowed[_owner][_spender];
137    }
138    
139    	//In case the ownership needs to be transferred
140 	function transferOwnership(address newOwner)public onlyOwner
141 	{
142 	    require( newOwner != 0x0);
143 	    balances[newOwner] = balances[newOwner].add(balances[owner]);
144         Transfer(0, newOwner, balances[owner]);
145 	    balances[owner] = 0;
146 	    owner = newOwner;
147         
148 	}
149 	
150     
151 }