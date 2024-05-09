1 pragma solidity ^0.5.12;
2 
3 // ----------------------------------------------------------------------------
4 // "Golden Ratio Coin Token contract"
5 //
6 // Symbol      : GOLDR
7 // Name        : Golden Ratio Coin
8 // Total supply: 1618034
9 // Decimals    : 8
10 //
11 // Contract Developed by Kuwaiti Coin Limited
12 // ----------------------------------------------------------------------------
13 
14 
15 // ----------------------------------------------------------------------------
16 // ERC Token Standard #20 Interface
17 // https://github.com/ethereum/EIPs/blob/master/EIPS/eip-20-token-standard.md
18 // ----------------------------------------------------------------------------
19 
20 contract ERC20 {
21   function balanceOf(address who) public view returns (uint256);
22   function allowance(address owner, address spender) public view returns (uint256);
23   function transferFrom(address from, address to, uint256 value) public returns (bool);
24   function approve(address spender, uint256 value) public returns (bool);
25   function transfer(address to, uint value) public returns(bool);
26   event Transfer(address indexed from, address indexed to, uint value);
27   event Approval(address indexed owner, address indexed spender, uint256 value);
28 }
29 
30 library SafeMath { 
31     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
32       assert(b <= a);
33       return a - b;
34     }
35     
36     function add(uint256 a, uint256 b) internal pure returns (uint256) {
37       uint256 c = a + b;
38       assert(c >= a);
39       return c;
40     }
41 }
42 
43 contract Golden_Ratio_Coin is ERC20 {
44 
45     using SafeMath for uint256;
46     
47     string public name;
48     string public symbol;
49     uint8 public decimals;  
50     address internal _admin;
51     uint256 public _totalSupply;
52     uint256 internal collateralLimit;
53     
54     mapping(address => uint256) balances;
55     mapping(address => uint256) public collateralBalance;
56     mapping(address => mapping (address => uint256)) allowed;
57 
58     constructor() public {  
59         symbol = "GOLDR";  
60         name = "Golden Ratio Coin"; 
61         decimals = 8;
62         _totalSupply = 1618034 * 10**uint(decimals);
63         _admin = msg.sender;
64         initial();
65     }
66     
67     modifier onlyOwner(){
68         require(msg.sender == _admin);
69         _;
70     }
71     
72     function initial() internal{
73         balances[_admin] = 300000 * 10**uint(decimals);
74         emit ERC20.Transfer(address(0), msg.sender, balances[_admin]);
75         balances[address(this)] = 1318034 * 10**uint(decimals);
76         collateralLimit  = 5000 * 10**uint(decimals);
77     }
78 
79     function totalSupply() public view returns (uint256) {
80 	    return _totalSupply;
81     }
82     
83     function balanceOf(address tokenOwner) public view returns (uint) {
84         return balances[tokenOwner];
85     }
86     
87     function setCollateralLimit(uint256 _amount) public onlyOwner returns (bool) {
88         require(_amount > 0);
89         collateralLimit = _amount * 10**uint(decimals);
90         return true;
91     }
92 
93     function transfer(address receiver, uint numTokens) public returns (bool) {
94         require(numTokens <= balances[msg.sender]);
95         require(receiver != address(0));
96         
97         balances[msg.sender] = balances[msg.sender].sub(numTokens);
98         balances[receiver] = balances[receiver].add(numTokens);
99         emit ERC20.Transfer(msg.sender, receiver, numTokens);
100         return true;
101     }
102 
103     function approve(address delegate, uint numTokens) public returns (bool) {
104         allowed[msg.sender][delegate] = numTokens;
105         emit ERC20.Approval(msg.sender, delegate, numTokens);
106         return true;
107     }
108 
109     function allowance(address owner, address delegate) public view returns (uint) {
110         return allowed[owner][delegate];
111     }
112 
113     function transferFrom(address owner, address buyer, uint numTokens) public returns (bool) {
114         require(numTokens <= balances[owner]);    
115         require(numTokens <= allowed[owner][msg.sender]);
116     
117         balances[owner] = balances[owner].sub(numTokens);
118         allowed[owner][msg.sender] = allowed[owner][msg.sender].sub(numTokens);
119         balances[buyer] = balances[buyer].add(numTokens);
120         emit ERC20.Transfer(owner, buyer, numTokens);
121         return true;
122     }
123     
124     function fromContract(address receiver, uint _amount) public onlyOwner returns (bool) {
125         require(receiver != address(0));
126         require( _amount > 0 );
127         
128         balances[address(this)] = balances[address(this)].sub(_amount);
129         balances[receiver] = balances[receiver].add(_amount);
130         emit ERC20.Transfer(address(this), receiver, _amount);
131         return true;
132     }
133     
134     function mint(address _receiver, uint256 _amount) public onlyOwner returns (bool) {
135         require( _amount > 0 );
136         require(_receiver != address(0));
137         require(balances[_receiver] >= collateralLimit);
138 
139         _totalSupply = _totalSupply.add(_amount);
140         balances[_receiver] = balances[_receiver].add(_amount);
141         return true;
142     }
143     
144     function lockTokens(uint256 _amount) public returns(bool){
145         require( balances[msg.sender]>=_amount);
146         balances[msg.sender] = balances[msg.sender].sub(_amount);
147         collateralBalance[msg.sender] = collateralBalance[msg.sender].add(_amount);
148         return true;
149     }
150     
151     function unlockTokens(uint256 _amount) onlyOwner public returns (bool) {
152         require(collateralLimit >= _amount);
153         balances[msg.sender] = balances[msg.sender].add( _amount);
154         collateralBalance[msg.sender] = collateralBalance[msg.sender].sub(_amount);       
155         return true;
156     }
157 }