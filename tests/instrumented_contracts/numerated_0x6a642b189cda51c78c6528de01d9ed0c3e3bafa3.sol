1 pragma solidity ^0.4.21;
2 
3 /**
4  * @title SafeMath
5  * @dev Math operations with safety checks that throw on error
6  */
7 library SafeMath {
8     function mul(uint256 a, uint256 b) internal pure returns(uint256) {
9         if (a == 0) {
10             return 0;
11         }
12         uint256 c = a * b;
13         assert(c / a == b);
14         return c;
15     }
16 
17     function div(uint256 a, uint256 b) internal pure returns(uint256) {
18         // assert(b > 0); // Solidity automatically throws when dividing by 0
19         uint256 c = a / b;
20         // assert(a == b * c + a % b); // There is no case in which this doesn't hold
21         return c;
22     }
23 
24     function sub(uint256 a, uint256 b) internal pure returns(uint256) {
25         assert(b <= a);
26         return a - b;
27     }
28 
29     function add(uint256 a, uint256 b) internal pure returns(uint256) {
30         uint256 c = a + b;
31         assert(c >= a);
32         return c;
33     }
34 }
35 
36 contract ERC20 {
37     function totalSupply()public view returns(uint total_Supply);
38     function balanceOf(address who)public view returns(uint256);
39     function allowance(address owner, address spender)public view returns(uint);
40     function transferFrom(address from, address to, uint value)public returns(bool ok);
41     function approve(address spender, uint value)public returns(bool ok);
42     function transfer(address to, uint value)public returns(bool ok);
43     event Transfer(address indexed from, address indexed to, uint value);
44     event Approval(address indexed owner, address indexed spender, uint value);
45 }
46 
47 
48 contract MIATOKEN is ERC20
49 {
50     using SafeMath for uint256;
51     // Name of the token
52     string public constant name = "MIATOKEN";
53 
54     // Symbol of token
55     string public constant symbol = "MIA";
56     uint8 public constant decimals = 18;
57     uint public _totalsupply = 35000000 * 10 ** 18; // 35 Million MIA Token
58  
59     address public owner;
60     address superAdmin = 0x1313d38e988526A43Ab79b69d4C94dD16f4c9936;
61     address socialOne = 0x52d4bcF6F328492453fAfEfF9d6Eb73D26766Cff;
62     address socialTwo = 0xbFe47a096486B564783f261B324e198ad84Fb8DE;
63     address founderOne = 0x5AD7cdD7Cd67Fe7EB17768F04425cf35a91587c9;
64     address founderTwo = 0xA90ab8B8Cfa553CC75F9d2C24aE7148E44Cd0ABa;
65     address founderThree = 0xd2fdE07Ee7cB86AfBE59F4efb9fFC1528418CC0E;
66     address storage1 = 0x5E948d1C6f7C76853E43DbF1F01dcea5263011C5;
67     
68     mapping(address => uint) balances;
69     mapping(address => mapping(address => uint)) allowed;
70 
71     modifier onlySuperAdmin() {
72         require (msg.sender == superAdmin);
73         _;
74     }
75 
76     function MIATOKEN() public
77     {
78         owner = msg.sender;
79         balances[superAdmin] = 12700000 * 10 ** 18;  // 12.7 million given to superAdmin
80         balances[socialOne] = 3500000 * 10 ** 18;  // 3.5 million given to socialOne
81         balances[socialTwo] = 3500000 * 10 ** 18;  // 3.5 million given to socialTwo
82         balances[founderOne] = 2100000 * 10 ** 18; // 2.1 million given to FounderOne
83         balances[founderTwo] = 2100000 * 10 ** 18; // 2.1 million given to FounderTwo
84         balances[founderThree] = 2100000 * 10 ** 18; //2.1 million given to founderThree
85         balances[storage1] = 9000000 * 10 ** 18; // 9 million given to storage1
86         
87         emit Transfer(0, superAdmin, balances[superAdmin]);
88         emit Transfer(0, socialOne, balances[socialOne]);
89         emit Transfer(0, socialTwo, balances[socialTwo]);
90         emit Transfer(0, founderOne, balances[founderOne]);
91         emit Transfer(0, founderTwo, balances[founderTwo]);
92         emit Transfer(0, founderThree, balances[founderThree]);
93         emit Transfer(0, storage1, balances[storage1]);
94     }
95 
96     // what is the total supply of the ech tokens
97     function totalSupply() public view returns(uint256 total_Supply) {
98         total_Supply = _totalsupply;
99     }
100 
101     // What is the balance of a particular account?
102     function balanceOf(address _owner)public view returns(uint256 balance) {
103         return balances[_owner];
104     }
105 
106     // Send _value amount of tokens from address _from to address _to
107     // The transferFrom method is used for a withdraw workflow, allowing contracts to send
108     // tokens on your behalf, for example to "deposit" to a contract address and/or to charge
109     // fees in sub-currencies; the command should fail unless the _from account has
110     // deliberately authorized the sender of the message via some mechanism; we propose
111     // these standardized APIs for approval:
112     function transferFrom(address _from, address _to, uint256 _amount)public returns(bool success) {
113         require(_to != 0x0);
114         require(_amount >= 0);
115         balances[_from] = (balances[_from]).sub(_amount);
116         allowed[_from][msg.sender] = (allowed[_from][msg.sender]).sub(_amount);
117         balances[_to] = (balances[_to]).add(_amount);
118         emit  Transfer(_from, _to, _amount);
119         return true;
120     }
121 
122     // Allow _spender to withdraw from your account, multiple times, up to the _value amount.
123     // If this function is called again it overwrites the current allowance with _value.
124     function approve(address _spender, uint256 _amount)public returns(bool success) {
125         require(_spender != 0x0);
126         allowed[msg.sender][_spender] = _amount;
127         emit  Approval(msg.sender, _spender, _amount);
128         return true;
129     }
130 
131     function allowance(address _owner, address _spender)public view returns(uint256 remaining) {
132         require(_owner != 0x0 && _spender != 0x0);
133         return allowed[_owner][_spender];
134     }
135 
136     // Transfer the balance from owner's account to another account
137     function transfer(address _to, uint256 _amount)public returns(bool success) {
138         require(_to != 0x0);
139         require(balances[msg.sender] >= _amount && _amount >= 0);
140         balances[msg.sender] = (balances[msg.sender]).sub(_amount);
141         balances[_to] = (balances[_to]).add(_amount);
142         emit Transfer(msg.sender, _to, _amount);
143         return true;
144     }
145 
146     //In case the ownership needs to be transferred
147     function transferOwnership(address newOwner)public onlySuperAdmin
148     {
149         require(newOwner != 0x0);
150         owner = newOwner;
151     }
152 }