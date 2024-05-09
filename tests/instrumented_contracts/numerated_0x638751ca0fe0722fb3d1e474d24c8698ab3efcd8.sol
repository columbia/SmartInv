1 pragma solidity ^0.4.23;
2 
3 
4 /**
5  * @title IERC20Token - ERC20 interface
6  * @dev see https://github.com/ethereum/EIPs/issues/20
7  */
8 contract IERC20Token {
9     string public name;
10     string public symbol;
11     uint8 public decimals;
12     uint256 public totalSupply;
13 
14     function balanceOf(address _owner) public constant returns (uint256 balance);
15     function transfer(address _to, uint256 _value)  public returns (bool success);
16     function transferFrom(address _from, address _to, uint256 _value)  public returns (bool success);
17     function approve(address _spender, uint256 _value)  public returns (bool success);
18     function allowance(address _owner, address _spender)  public constant returns (uint256 remaining);
19 
20     event Transfer(address indexed _from, address indexed _to, uint256 _value);
21     event Approval(address indexed _owner, address indexed _spender, uint256 _value);
22 }
23 
24 /**
25  * @title SafeMath
26  * @dev Math operations with safety checks that throw on error
27  */
28 contract SafeMath {
29     /**
30     * @dev constructor
31     */
32     constructor() public {
33     }
34 
35     function safeMul(uint256 a, uint256 b) internal pure returns (uint256) {
36         uint256 c = a * b;
37         assert(a == 0 || c / a == b);
38         return c;
39     }
40 
41     function safeDiv(uint256 a, uint256 b) internal pure returns (uint256) {
42         uint256 c = a / b;
43         return c;
44     }
45 
46     function safeSub(uint256 a, uint256 b) internal pure returns (uint256) {
47         assert(a >= b);
48         return a - b;
49     }
50 
51     function safeAdd(uint256 a, uint256 b) internal pure returns (uint256) {
52         uint256 c = a + b;
53         assert(c >= a);
54         return c;
55     }
56 }
57 
58 /**
59  * @title ERC20Token - ERC20 base implementation
60  * @dev see https://github.com/ethereum/EIPs/issues/20
61  */
62 contract ERC20Token is IERC20Token, SafeMath {
63     mapping (address => uint256) public balances;
64     mapping (address => mapping (address => uint256)) public allowed;
65 
66     function transfer(address _to, uint256 _value) public returns (bool) {
67         require(_to != address(0));
68         require(balances[msg.sender] >= _value);
69 
70         balances[msg.sender] = safeSub(balances[msg.sender], _value);
71         balances[_to] = safeAdd(balances[_to], _value);
72         emit Transfer(msg.sender, _to, _value);
73         return true;
74     }
75 
76     function transferFrom(address _from, address _to, uint256 _value) public returns (bool) {
77         require(_to != address(0));
78         require(balances[_from] >= _value && allowed[_from][msg.sender] >= _value);
79 
80         balances[_to] = safeAdd(balances[_to], _value);
81         balances[_from] = safeSub(balances[_from], _value);
82         allowed[_from][msg.sender] = safeSub(allowed[_from][msg.sender], _value);
83         emit Transfer(_from, _to, _value);
84         return true;
85     }
86 
87     function balanceOf(address _owner) public constant returns (uint256) {
88         return balances[_owner];
89     }
90 
91     function approve(address _spender, uint256 _value) public returns (bool) {
92         allowed[msg.sender][_spender] = _value;
93         emit Approval(msg.sender, _spender, _value);
94         return true;
95     }
96 
97     function allowance(address _owner, address _spender) public constant returns (uint256) {
98         return allowed[_owner][_spender];
99     }
100 }
101 
102 contract Bdoks is ERC20Token {
103 
104     uint256 public mintTotal;
105     address public owner;
106 
107     event Mint(address _toAddress, uint256 _amount);
108 
109     constructor(address _owner) public {
110         require(address(0) != _owner);
111 
112         name = "Bdoks";
113         symbol = "BDX";
114         decimals = 18;
115         totalSupply = 1 * 100 *1000 * 10**uint256(decimals);
116 
117         mintTotal = 0;
118         owner = _owner;
119     }
120 
121     function mint (address _toAddress, uint256 _amount) public returns (bool) {
122         require(msg.sender == owner);
123         require(address(0) != _toAddress);
124         require(_amount >= 0);
125         require( safeAdd(_amount,mintTotal) <= totalSupply);
126 
127         mintTotal = safeAdd(_amount, mintTotal);
128         balances[_toAddress] = safeAdd(balances[_toAddress], _amount);
129 
130         emit Mint(_toAddress, _amount);
131         return (true);
132     }
133 
134     function() public payable {
135         revert();
136     }
137 }