1 pragma solidity ^0.4.19;
2 
3 contract SafeMath {
4   function safeMul(uint a, uint b) internal pure returns (uint256) {
5     uint c = a * b;
6     assert(a == 0 || c / a == b);
7     return c;
8   }
9 
10   function safeDiv(uint a, uint b) internal pure returns (uint256) {
11     uint c = a / b;
12     return c;
13   }
14 
15   function safeSub(uint a, uint b) internal pure returns (uint256) {
16     assert(b <= a);
17     return a - b;
18   }
19 
20   function safeAdd(uint a, uint b) internal pure returns (uint256) {
21     uint c = a + b;
22     assert(c >= a);
23     return c;
24   }
25 }
26 
27 contract Ownable {
28   address public owner;
29 
30   function Ownable() public {
31     owner = msg.sender;
32   }
33 
34   modifier onlyOwner() {
35     require(msg.sender == owner);
36     _;
37   }
38   //transfer owner to another address
39   function transferOwnership(address _newOwner) public onlyOwner {
40     if (_newOwner != address(0)) {
41       owner = _newOwner;
42     }
43   }
44 }
45 
46 contract ERC20Token is SafeMath {
47   string public name;
48   string public symbol;
49   uint256 public totalSupply;
50   uint8 public decimals;
51 
52   mapping (address => uint256) balances;
53   mapping (address => mapping (address => uint256)) allowed;
54 
55   event Transfer(address indexed _from, address indexed _to, uint256 _value);
56   event Approval(address indexed _owner, address indexed _spender, uint256 _value);
57 
58   modifier onlyPayloadSize(uint size) {   
59     require(msg.data.length == size + 4);
60     _;
61   }
62 
63   /**
64     @dev send coins
65     throws on any error rather then return a false flag to minimize user errors
66 
67     @param _to      target address
68     @param _value   transfer amount
69 
70     @return true if the transfer was successful, false if it wasn't
71   */
72   function transfer(address _to, uint256 _value)
73       public
74       onlyPayloadSize(2 * 32)
75       returns (bool success)
76   {
77     balances[msg.sender] = safeSub(balances[msg.sender], _value);
78     balances[_to] = safeAdd(balances[_to], _value);
79     Transfer(msg.sender, _to, _value);
80     return true;
81   }
82 
83   /**
84     @dev an account/contract attempts to get the coins
85     throws on any error rather then return a false flag to minimize user errors
86 
87     @param _from    source address
88     @param _to      target address
89     @param _value   transfer amount
90 
91     @return true if the transfer was successful, false if it wasn't
92   */
93   function transferFrom(address _from, address _to, uint256 _value)
94     public
95     onlyPayloadSize(3 * 32)
96     returns (bool success)
97   {
98     allowed[_from][msg.sender] = safeSub(allowed[_from][msg.sender], _value);
99     balances[_from] = safeSub(balances[_from], _value);
100     balances[_to] = safeAdd(balances[_to], _value);
101     Transfer(_from, _to, _value);
102     return true;
103   }
104   
105   function approve(address _spender, uint256 _value)
106     public
107     onlyPayloadSize(2 * 32)
108     returns (bool success)
109   {
110     // if the allowance isn't 0, it can only be updated to 0 to prevent an allowance change immediately after withdrawal
111     require(_value == 0 || allowed[msg.sender][_spender] == 0);
112 
113     allowed[msg.sender][_spender] = _value;
114     Approval(msg.sender, _spender, _value);
115     return true;
116   }
117 
118   function allowance(address _owner, address _spender) public constant returns (uint) {
119     return allowed[_owner][_spender];
120   }
121 
122   function balanceOf(address _holder) public constant returns (uint) {
123     return balances[_holder];
124   }
125 }
126 
127 contract BitEyeToken is ERC20Token, Ownable {
128 
129   bool public distributed = false;
130 
131   function BitEyeToken() public {
132     name = "BitEye Token";
133     symbol = "BEY";
134     decimals = 18;
135     totalSupply = 1000000000 * 1e18;
136   }
137 
138   function distribute(address _bitEyeExAddr, address _operationAddr, address _airdropAddr) public onlyOwner {
139     require(!distributed);
140     distributed = true;
141 
142     balances[_bitEyeExAddr] = 900000000 * 1e18;
143     Transfer(address(0), _bitEyeExAddr, 900000000 * 1e18);
144 
145     balances[_operationAddr] = 50000000 * 1e18;
146     Transfer(address(0), _operationAddr, 50000000 * 1e18);
147 
148     balances[_airdropAddr] = 50000000 * 1e18;
149     Transfer(address(0), _airdropAddr, 50000000 * 1e18);
150   }
151 }