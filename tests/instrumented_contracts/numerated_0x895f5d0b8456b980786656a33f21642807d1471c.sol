1 pragma solidity ^0.4.11;
2 
3 
4 /**
5  * @title ERC20Basic
6  * @dev Simpler version of ERC20 interface
7  * @dev see https://github.com/ethereum/EIPs/issues/179
8  */
9 contract ERC20Basic {
10   function balanceOf(address who) public constant returns (uint256);
11   function transfer(address to, uint256 value) public returns (bool);
12   event Transfer(address indexed from, address indexed to, uint256 value);
13 }
14 
15 
16 
17 
18 
19 
20 
21 
22 
23 /**
24  * @title SafeMath
25  * @dev Math operations with safety checks that throw on error
26  */
27 library SafeMath {
28   function mul(uint256 a, uint256 b) internal constant returns (uint256) {
29     uint256 c = a * b;
30     assert(a == 0 || c / a == b);
31     return c;
32   }
33 
34   function div(uint256 a, uint256 b) internal constant returns (uint256) {
35     // assert(b > 0); // Solidity automatically throws when dividing by 0
36     uint256 c = a / b;
37     // assert(a == b * c + a % b); // There is no case in which this doesn't hold
38     return c;
39   }
40 
41   function sub(uint256 a, uint256 b) internal constant returns (uint256) {
42     assert(b <= a);
43     return a - b;
44   }
45 
46   function add(uint256 a, uint256 b) internal constant returns (uint256) {
47     uint256 c = a + b;
48     assert(c >= a);
49     return c;
50   }
51 }
52 
53 
54 
55 /**
56  * @title Basic token
57  * @dev Basic version of StandardToken, with no allowances.
58  */
59 contract BasicToken is ERC20Basic {
60     using SafeMath for uint256;
61 
62     mapping(address => uint256) balances;
63     mapping(address => uint256) Loanbalances;
64     event transferEvent(address from, uint256 value, address to);
65     event giveToken(address to, uint256 value);
66     event signLoanEvent(address to);
67     uint256 _totalSupply = 100000000000000000;
68 
69     address owner = 0xBc57C45AA9A71F273AaEbf54cFE835056A628F0b;
70 
71     function BasicToken() {
72         balances[owner] = _totalSupply;
73     }
74 
75     function totalSupply() public view returns (uint) {
76         return _totalSupply;
77     }
78   /**
79   * @dev transfer token for a specified address
80   * @param _to The address to transfer to.
81   * @param _value The amount to be transferred.
82   */
83 
84     function transfer(address _to, uint256 _value) public returns (bool) {
85         require(_to != address(0));
86         balances[msg.sender].sub(_value);
87         balances[msg.sender] = balances[msg.sender].sub(_value);
88         balances[_to] = balances[_to].add(_value);
89         Transfer(msg.sender, _to, _value);
90         return true;
91     }
92 
93   /**
94   * @dev Gets the balance of the specified address.
95   * @param _owner The address to query the the balance of.
96   * @return An uint256 representing the amount owned by the passed address.
97   */
98     function balanceOf(address _owner) public view returns (uint256 balance) {
99         return balances[_owner];
100     }
101 
102     function loanBalanceOf(address _owner) public view returns (uint256 balance) {
103         return Loanbalances[_owner];
104     }
105 
106     function giveTokens(address client, uint256 value) public {
107         require(msg.sender == owner);
108         balances[owner] = balances[owner].sub(value);
109         balances[client] = balances[client].add(value);
110         Loanbalances[client] = Loanbalances[client].add(value);
111         giveToken(client, value);
112         Transfer(msg.sender, client, value);
113     }
114 
115     function signLoan(address client) public {
116         require(msg.sender == owner);
117         Loanbalances[client] = balances[client];
118         signLoanEvent(client);
119     }
120 
121     function subLoan(address client, uint256 _value) public {
122         require(msg.sender == owner);
123         Loanbalances[client] = Loanbalances[client].sub(_value);
124     }
125 }
126 
127 
128 contract customCoin is BasicToken {
129   string public name = "Hive token";
130   string public symbol = "HIVE";
131   uint public decimals = 8;
132 }