1 pragma solidity ^0.4.18;
2 
3 library SafeMath {
4   function mul(uint256 a, uint256 b) internal pure returns (uint256) {
5     uint256 c = a * b;
6     assert(a == 0 || c / a == b);
7     return c;
8   }
9 
10   function div(uint256 a, uint256 b) internal pure returns (uint256) {
11       assert(b > 0); 
12       uint256 c = a / b;
13       assert(a == b * c + a % b); 
14       return c;
15   }
16 
17   function sub(uint256 a, uint256 b) internal pure returns (uint256) {
18     assert(b <= a);
19     return a - b;
20   }
21 
22   function add(uint256 a, uint256 b) internal pure returns (uint256) {
23     uint256 c = a + b;
24     assert(c >= a);
25     return c;
26   }
27 }
28 contract Ownable {
29   address public owner;
30 
31 
32   function Ownable() public {
33     owner = msg.sender;
34   }
35 
36 
37   modifier onlyOwner() {
38     require(msg.sender == owner);
39     _;
40   }
41 
42   function transferOwnership(address newOwner) public onlyOwner {
43     require(newOwner != address(0));
44     owner = newOwner;
45   }
46 }
47 
48 contract ERC20Standard {
49 
50 
51     // total amount of tokens
52     function totalSupply() public constant returns (uint256) ;
53 
54     /*
55      *  Events
56      */
57     event Transfer(address indexed _from, address indexed _to, uint256 _value);
58     event Approval(address indexed _owner, address indexed _spender, uint256 _value);
59 
60     /*
61      *  Public functions
62      */
63     function transfer(address _to, uint256 _value) public returns (bool);
64 
65     function transferFrom(address _from, address _to, uint256 _value)  public returns (bool);
66 
67 
68     function approve(address _spender, uint256 _value) public  returns (bool);
69 
70     function balanceOf(address _owner) public constant returns (uint256);
71 
72     function allowance(address _owner, address _spender) public constant returns (uint256);
73 }
74 
75 contract ERC20StandardToken is ERC20Standard {
76     using SafeMath for uint256;
77 
78     /*
79      *  Storage
80      */
81     mapping (address => uint256) balances;
82     mapping (address => mapping (address => uint256)) allowances;
83 
84 
85     function transfer(address to, uint256 value) public returns (bool){
86         require(to !=address(0));
87         require(value<=balances[msg.sender]);
88 
89         balances[msg.sender]=balances[msg.sender].sub(value);
90         balances[to] = balances[to].add(value);
91         emit Transfer(msg.sender,to,value);
92         return true;
93     }
94 
95 
96     function transferFrom(address from, address to, uint256 value) public returns (bool){
97         require(to != address(0));
98         require(value <= balances[from]);
99         require(value <= allowances[from][msg.sender]);
100 
101         balances[from] = balances[from].sub(value);
102         balances[to] = balances[to].add(value);
103         allowances[from][msg.sender] = allowances[from][msg.sender].sub(value);
104         emit Transfer(from, to, value);
105         return true;
106 
107     }
108 
109     function approve(address spender, uint256 value) public returns (bool){
110         require((value == 0) || (allowances[msg.sender][spender] == 0));
111         allowances[msg.sender][spender] = value;
112         emit Approval(msg.sender, spender, value);
113         return true;
114     }
115 
116     function allowance(address owner, address spender) public constant returns (uint256){
117         return allowances[owner][spender];
118     }
119 
120 
121     function balanceOf(address owner) public constant returns (uint256){
122         return balances[owner];
123     }
124 }
125 
126 contract IOBT is ERC20StandardToken, Ownable {
127 
128     // token information
129     string public constant name = "Internet of Blockchain Token";
130     string public constant symbol = "IOBT";
131     uint8 public constant decimals = 18;
132     uint256 TotalTokenSupply=5*(10**8)*(10**uint256(decimals));
133 
134      function totalSupply() public constant returns (uint256 ) {
135           return TotalTokenSupply;
136       }
137 
138     /// transfer all tokens to holders
139     address public constant MAIN_HOLDER_ADDR=0x7e647B726052238AE2439BD36257C2a2bB283dDa;
140 
141 
142     function IOBT() public onlyOwner{
143         balances[MAIN_HOLDER_ADDR]+=TotalTokenSupply;
144         emit Transfer(0,MAIN_HOLDER_ADDR,TotalTokenSupply);
145       }
146 }