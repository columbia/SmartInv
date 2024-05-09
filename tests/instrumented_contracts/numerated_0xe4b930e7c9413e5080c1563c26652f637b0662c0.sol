1 pragma solidity ^0.4.17;
2 library SafeMath {
3   function mul(uint256 a, uint256 b) internal pure returns (uint256) {
4     uint256 c = a * b;
5     assert(a == 0 || c / a == b);
6     return c;
7   }
8   function div(uint256 a, uint256 b) internal pure returns (uint256) {
9     assert(b > 0);
10     uint256 c = a / b;
11     assert(a == b * c + a % b);
12     return c;
13   }
14   function sub(uint256 a, uint256 b) internal pure returns (uint256) {
15     assert(b <= a);
16     return a - b;
17   }
18   function add(uint256 a, uint256 b) internal pure returns (uint256) {
19     uint256 c = a + b;
20     assert(c >= a);
21     return c;
22   }
23 }
24 contract Ownable {
25   address public owner;
26   function Ownable() public {
27     owner = msg.sender;
28   }
29   modifier onlyOwner() {
30     require(msg.sender == owner);
31     _;
32   }
33   function transferOwnership(address newOwner) public onlyOwner {
34     require(newOwner != address(0));
35     owner = newOwner;
36   }
37 }
38 contract Migrations {
39   address public owner;
40   uint public last_completed_migration;
41   modifier restricted() {
42     if (msg.sender == owner) _;
43   }
44   function Migrations() public {
45     owner = msg.sender;
46   }
47   function setCompleted(uint completed) public restricted {
48     last_completed_migration = completed;
49   }
50   function upgrade(address new_address) public restricted {
51     Migrations upgraded = Migrations(new_address);
52     upgraded.setCompleted(last_completed_migration);
53   }
54 }
55 contract ERC20Standard {
56     // total amount of tokens
57     function totalSupply() public constant returns (uint256) ;
58     /*
59      *  Events
60      */
61     event Transfer(address indexed _from, address indexed _to, uint256 _value);
62     event Approval(address indexed _owner, address indexed _spender, uint256 _value);
63     /*
64      *  Public functions
65      */
66     function transfer(address _to, uint256 _value) public returns (bool);
67     function transferFrom(address _from, address _to, uint256 _value) public returns (bool);
68     function approve(address _spender, uint256 _value) public returns (bool);
69     function balanceOf(address _owner) public constant returns (uint256);
70     function allowance(address _owner, address _spender) public constant returns (uint256);
71 }
72 contract ERC20StandardToken is ERC20Standard {
73     using SafeMath for uint256;
74     /*
75      *  Storage
76      */
77     mapping (address => uint256) balances;
78     mapping (address => mapping (address => uint256)) allowances;
79     function transfer(address to, uint256 value) public returns (bool){
80         require(to !=address(0));
81         balances[msg.sender]=balances[msg.sender].sub(value);
82         balances[to] = balances[to].add(value);
83         Transfer(msg.sender,to,value);
84         return true;
85     }
86     function transferFrom(address from, address to, uint256 value) public returns (bool){
87         require(to != address(0));
88         var allowanceAmount = allowances[from][msg.sender];
89         balances[from] = balances[from].sub(value);
90         balances[to] = balances[to].add(value);
91         allowances[from][msg.sender] = allowanceAmount.sub(value);
92         Transfer(from, to, value);
93         return true;
94     }
95     function approve(address spender, uint256 value) public returns (bool){
96         require((value == 0) || (allowances[msg.sender][spender] == 0));
97         allowances[msg.sender][spender] = value;
98         Approval(msg.sender, spender, value);
99         return true;
100     }
101     function allowance(address owner, address spender) public constant returns (uint256){
102         return allowances[owner][spender];
103     }
104     function balanceOf(address owner) public constant returns (uint256){
105         return balances[owner];
106     }
107 }
108 contract TradeHKD is ERC20StandardToken, Ownable {
109     // token information
110     string public constant name = "Trade HKD";
111     string public constant symbol = "HKDT";
112     uint256 public constant decimals = 18;
113     uint TotalTokenSupply=1*(10**8)* (10**decimals);
114      function totalSupply() public constant returns (uint256 ) {
115           return TotalTokenSupply;
116       }
117     /// transfer all tokens to holders
118     address public constant MAIN_HOLDER_ADDR=0xD8B213E9107378caCF5e700E26b07dd652077F8E;
119     function TradeHKD() public onlyOwner{
120         balances[MAIN_HOLDER_ADDR]+=TotalTokenSupply;
121         Transfer(0,MAIN_HOLDER_ADDR,TotalTokenSupply);
122       }
123 }