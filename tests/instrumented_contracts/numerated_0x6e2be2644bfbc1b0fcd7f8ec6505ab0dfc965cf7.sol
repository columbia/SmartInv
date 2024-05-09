1 /**
2  *Submitted for verification at Etherscan.io on 2018-01-28
3 */
4 
5 pragma solidity 0.4.18;
6 
7 
8 /**
9  * @title SafeMath
10  * @dev Math operations with safety checks that throw on error
11  */
12 library SafeMath {
13   function mul(uint256 a, uint256 b) internal pure returns (uint256) {
14     if (a == 0) {
15       return 0;
16     }
17     uint256 c = a * b;
18     assert(c / a == b);
19     return c;
20   }
21 
22   function div(uint256 a, uint256 b) internal pure returns (uint256) {
23     // assert(b > 0); // Solidity automatically throws when dividing by 0
24     uint256 c = a / b;
25     // assert(a == b * c + a % b); // There is no case in which this doesn't hold
26     return c;
27   }
28 
29   function sub(uint256 a, uint256 b) internal pure returns (uint256) {
30     assert(b <= a);
31     return a - b;
32   }
33 
34   function add(uint256 a, uint256 b) internal pure returns (uint256) {
35     uint256 c = a + b;
36     assert(c >= a);
37     return c;
38   }
39 }
40 
41   contract ERC20 {
42   function totalSupply()public view returns (uint total_Supply);
43   function balanceOf(address _owner)public view returns (uint256 balance);
44   function allowance(address _owner, address _spender)public view returns (uint remaining);
45   function transferFrom(address _from, address _to, uint _amount)public returns (bool ok);
46   function approve(address _spender, uint _amount)public returns (bool ok);
47   function transfer(address _to, uint _amount)public returns (bool ok);
48   event Transfer(address indexed _from, address indexed _to, uint _amount);
49   event Approval(address indexed _owner, address indexed _spender, uint _amount);
50 }
51 
52 contract DevG is ERC20
53 {
54     using SafeMath for uint256;
55     string public constant symbol = "DevG";
56     string public constant name = "DevG";
57     uint8 public constant decimals = 18;
58     // 100 million total supply // muliplies dues to decimal precision
59     uint256 public _totalSupply = 10000000000 * 10 **18;     // 10 billion supply           
60     // Balances for each account
61     mapping(address => uint256) balances;   
62     // Owner of this contract
63     address public owner;
64     
65     mapping (address => mapping (address => uint)) allowed;
66     
67     event Transfer(address indexed _from, address indexed _to, uint _value);
68     event Approval(address indexed _owner, address indexed _spender, uint _value);
69 
70     modifier onlyOwner() {
71       if (msg.sender != owner) {
72             revert();
73         }
74         _;
75         }
76     
77     function DevG() public
78     {
79         owner = msg.sender;
80         balances[owner] = _totalSupply;
81     }
82     
83  
84     // to be called by owner, should includes decimal
85     function mineToken(uint256 supply_to_increase) public onlyOwner
86     {
87 
88         balances[owner] += supply_to_increase;
89         _totalSupply += supply_to_increase;
90         Transfer(0,owner,supply_to_increase);
91     }
92     
93     
94     // total supply of the tokens
95     function totalSupply() public view returns (uint256 total_Supply) {
96          total_Supply = _totalSupply;
97      }
98   
99      //  balance of a particular account
100      function balanceOf(address _owner)public view returns (uint256 balance) {
101          return balances[_owner];
102      }
103   
104      // Transfer the balance from owner's account to another account
105      function transfer(address _to, uint256 _amount)public returns (bool success) {
106          require( _to != 0x0);
107          require(balances[msg.sender] >= _amount 
108              && _amount >= 0
109              && balances[_to] + _amount >= balances[_to]);
110              balances[msg.sender] = balances[msg.sender].sub(_amount);
111              balances[_to] = balances[_to].add(_amount);
112              Transfer(msg.sender, _to, _amount);
113              return true;
114      }
115   
116      // Send _value amount of tokens from address _from to address _to
117      // The transferFrom method is used for a withdraw workflow, allowing contracts to send
118      // tokens on your behalf, for example to "deposit" to a contract address and/or to charge
119      // fees in sub-currencies; the command should fail unless the _from account has
120      // deliberately authorized the sender of the message via some mechanism; we propose
121      // these standardized APIs for approval:
122      function transferFrom(
123          address _from,
124          address _to,
125          uint256 _amount
126      )public returns (bool success) {
127         require(_to != 0x0); 
128          require(balances[_from] >= _amount
129              && allowed[_from][msg.sender] >= _amount
130              && _amount >= 0
131              && balances[_to] + _amount >= balances[_to]);
132              balances[_from] = balances[_from].sub(_amount);
133              allowed[_from][msg.sender] = allowed[_from][msg.sender].sub(_amount);
134              balances[_to] = balances[_to].add(_amount);
135              Transfer(_from, _to, _amount);
136              return true;
137              }
138  
139      // Allow _spender to withdraw from your account, multiple times, up to the _value amount.
140      // If this function is called again it overwrites the current allowance with _value.
141      function approve(address _spender, uint256 _amount)public returns (bool success) {
142          allowed[msg.sender][_spender] = _amount;
143          Approval(msg.sender, _spender, _amount);
144          return true;
145      }
146   
147      function allowance(address _owner, address _spender)public view returns (uint256 remaining) {
148          return allowed[_owner][_spender];
149    }
150    
151    	//In case the ownership needs to be transferred
152 	function transferOwnership(address newOwner)public onlyOwner
153 	{
154 	    require( newOwner != 0x0);
155 	    balances[newOwner] = balances[newOwner].add(balances[owner]);
156 	    balances[owner] = 0;
157 	    owner = newOwner;
158 	}
159 	
160 }