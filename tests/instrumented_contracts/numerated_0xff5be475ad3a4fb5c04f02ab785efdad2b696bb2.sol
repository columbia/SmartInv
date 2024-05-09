1 // 0.4.20+commit.3155dd80.Emscripten.clang
2 pragma solidity ^0.4.20;
3 
4 contract owned {
5   address public owner;
6 
7   function owned() public { owner = msg.sender; }
8 
9   modifier onlyOwner {
10     if (msg.sender != owner) { revert(); }
11     _;
12   }
13 
14   function changeOwner( address newowner ) public onlyOwner {
15     owner = newowner;
16   }
17 }
18 
19 // Kuberan Govender's ERC20 coin
20 contract Kuberand is owned
21 {
22   string  public name;
23   string  public symbol;
24   uint8   public decimals;
25   uint256 public totalSupply;
26 
27   mapping( address => uint256 ) balances_;
28   mapping( address => mapping(address => uint256) ) allowances_;
29 
30   event Approval( address indexed owner,
31                   address indexed spender,
32                   uint value );
33 
34   event Transfer( address indexed from,
35                   address indexed to,
36                   uint256 value );
37 
38   event Burn( address indexed from, uint256 value );
39 
40   function Kuberand() public
41   {
42     decimals = uint8(18);
43 
44     balances_[msg.sender] = uint256( 1e9 * 10 ** uint256(decimals) );
45     totalSupply = balances_[msg.sender];
46     name = "Kuberand";
47     symbol = "KUBR";
48 
49     Transfer( address(0), msg.sender, totalSupply );
50   }
51 
52   function() public payable { revert(); } // does not accept money
53 
54   function balanceOf( address owner ) public constant returns (uint) {
55     return balances_[owner];
56   }
57 
58   function approve( address spender, uint256 value ) public
59   returns (bool success)
60   {
61     allowances_[msg.sender][spender] = value;
62     Approval( msg.sender, spender, value );
63     return true;
64   }
65  
66   function allowance( address owner, address spender ) public constant
67   returns (uint256 remaining)
68   {
69     return allowances_[owner][spender];
70   }
71 
72   function transfer(address to, uint256 value) public returns (bool)
73   {
74     _transfer( msg.sender, to, value );
75     return true;
76   }
77 
78   function transferFrom( address from, address to, uint256 value ) public
79   returns (bool success)
80   {
81     require( value <= allowances_[from][msg.sender] );
82 
83     allowances_[from][msg.sender] -= value;
84     _transfer( from, to, value );
85 
86     return true;
87   }
88 
89   function burn( uint256 value ) public returns (bool success)
90   {
91     require( balances_[msg.sender] >= value );
92     balances_[msg.sender] -= value;
93     totalSupply -= value;
94 
95     Burn( msg.sender, value );
96     return true;
97   }
98 
99   function burnFrom( address from, uint256 value ) public returns (bool success)
100   {
101     require( balances_[from] >= value );
102     require( value <= allowances_[from][msg.sender] );
103 
104     balances_[from] -= value;
105     allowances_[from][msg.sender] -= value;
106     totalSupply -= value;
107 
108     Burn( from, value );
109     return true;
110   }
111 
112   function _transfer( address from,
113                       address to,
114                       uint value ) internal
115   {
116     require( to != 0x0 );
117     require( balances_[from] >= value );
118     require( balances_[to] + value > balances_[to] ); // catch overflow
119 
120     balances_[from] -= value;
121     balances_[to] += value;
122 
123     Transfer( from, to, value );
124   }
125 }