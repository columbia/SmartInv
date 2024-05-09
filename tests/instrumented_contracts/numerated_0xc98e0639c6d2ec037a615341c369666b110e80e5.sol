1 pragma solidity ^0.4.17;
2 
3 /* EXMR 'eXMR eMonero is tokenized (ERC20) Monero on the Ethereum blockchain' contract Version 2.0
4 *Airdrop 100% Free for different tasks and support
5 *Refer to our Official Sites and your Community: 
6 *http://www.e-XMR.io/
7 *https://twitter.com/eXMRCoin
8 *https://medium.com/@eXMR
9 *https://github.com/eXMRcoin/e-XMR/tree/master/eXMR-master
10 *
11 *We are looking for Moderator: Telegram, Slack, Reddit and Discord
12 *https://t.me/joinEXMR 
13 *exmr-workspace.slack.com
14 *Discord Channel
15 *https://www.reddit.com/user/exmrcoin
16 *
17 *Developer: eXMR (TM) 2017.
18 *
19 * The MIT License.
20 *
21 */
22 
23 contract Ownable {
24   address public owner;
25 
26   event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
27 
28   function Ownable() {
29     owner = msg.sender;
30   }
31 
32   modifier onlyOwner() {
33     require(msg.sender == owner);
34     _;
35   }
36 
37   function transferOwnership(address newOwner) onlyOwner public {
38     require(newOwner != address(0));
39     OwnershipTransferred(owner, newOwner);
40     owner = newOwner;
41   }
42 
43 }
44 
45 library SafeMath {
46   function mul(uint256 a, uint256 b) internal constant returns (uint256) {
47     uint256 c = a * b;
48     assert(a == 0 || c / a == b);
49     return c;
50   }
51 
52   function div(uint256 a, uint256 b) internal constant returns (uint256) {
53     // assert(b > 0); // Solidity automatically throws when dividing by 0
54     uint256 c = a / b;
55     // assert(a == b * c + a % b); // There is no case in which this doesn't hold
56     return c;
57   }
58 
59   function sub(uint256 a, uint256 b) internal constant returns (uint256) {
60     assert(b <= a);
61     return a - b;
62   }
63 
64   function add(uint256 a, uint256 b) internal constant returns (uint256) {
65     uint256 c = a + b;
66     assert(c >= a);
67     return c;
68   }
69 }
70 
71 contract ERC20Basic {
72   uint256 public totalSupply;
73   function balanceOf(address who) constant returns (uint256);
74   function transfer(address to, uint256 value) returns (bool);
75   event Transfer(address indexed from, address indexed to, uint256 value);
76 }
77 
78 contract BasicToken is ERC20Basic {
79   using SafeMath for uint256;
80 
81   mapping(address => uint256) balances;
82 
83   function transfer(address _to, uint256 _value) returns (bool) {
84     balances[msg.sender] = balances[msg.sender].sub(_value);
85     balances[_to] = balances[_to].add(_value);
86     Transfer(msg.sender, _to, _value);
87     return true;
88   }
89 
90   function balanceOf(address _owner) constant returns (uint256 balance) {
91     return balances[_owner];
92   }
93 }
94 
95 contract ERC20 is ERC20Basic {
96   function allowance(address owner, address spender) constant returns (uint256);
97   function transferFrom(address from, address to, uint256 value) returns (bool);
98   function approve(address spender, uint256 value) returns (bool);
99   event Approval(address indexed owner, address indexed spender, uint256 value);
100 }
101 
102 contract StandardToken is ERC20, BasicToken {
103 
104   mapping (address => mapping (address => uint256)) allowed;
105 
106   function transferFrom(address _from, address _to, uint256 _value) returns (bool) {
107 
108     var _allowance = allowed[_from][msg.sender];
109 
110     balances[_from] = balances[_from].sub(_value);
111     balances[_to] = balances[_to].add(_value);
112     allowed[_from][msg.sender] = _allowance.sub(_value);
113     Transfer(_from, _to, _value);
114     return true;
115   }
116 
117   function approve(address _spender, uint256 _value) returns (bool) {
118     require((_value == 0) || (allowed[msg.sender][_spender] == 0));
119 
120     allowed[msg.sender][_spender] = _value;
121     Approval(msg.sender, _spender, _value);
122     return true;
123   }
124 
125   function allowance(address _owner, address _spender) constant returns (uint256 remaining) {
126     return allowed[_owner][_spender];
127   }
128 
129   function increaseApproval(address _spender, uint256 _addedValue) returns (bool success) {
130     allowed[msg.sender][_spender] = allowed[msg.sender][_spender].add(_addedValue);
131     Approval(msg.sender, _spender, allowed[msg.sender][_spender]);
132     return true;
133   }
134 
135   function decreaseApproval(address _spender, uint256 _subtractedValue) returns (bool success) {
136     uint256 oldValue = allowed[msg.sender][_spender];
137     if (_subtractedValue > oldValue) {
138       allowed[msg.sender][_spender] = 0;
139     } else {
140       allowed[msg.sender][_spender] = oldValue.sub(_subtractedValue);
141     }
142     Approval(msg.sender, _spender, allowed[msg.sender][_spender]);
143     return true;
144   }
145 
146 }
147 
148 contract EXMR is StandardToken, Ownable {
149   string public constant name = "EXMR";
150   string public constant symbol = "EXMR";
151   uint8 public constant decimals = 8;
152   uint256 public constant INITIAL_SUPPLY = 15 * 10**6 * 10**8;
153 
154   function EXMR() public {
155     totalSupply = INITIAL_SUPPLY;
156     balances[msg.sender] = INITIAL_SUPPLY;
157   }
158 
159   function airdrop(uint256 amount, address[] addresses) onlyOwner {
160     for (uint i = 0; i < addresses.length; i++) {
161       balances[owner].sub(amount);
162       balances[addresses[i]].add(amount);
163       Transfer(owner, addresses[i], amount);
164     }
165   }
166 }