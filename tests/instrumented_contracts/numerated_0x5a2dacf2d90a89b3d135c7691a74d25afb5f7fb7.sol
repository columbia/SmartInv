1 pragma solidity ^0.4.18;
2 
3 contract safeMath {
4 
5     function add( uint256 x, uint256 y ) internal pure returns ( uint256 z ) {
6         assert( ( z = x + y ) >= x );
7     }
8 
9     function sub( uint256 x, uint256 y ) internal pure returns ( uint256 z ) {
10         assert( ( z = x - y ) <= x );
11     }
12 }
13 
14 contract ERC20 {
15     function    totalSupply() public constant returns (uint);
16     function    balanceOf(address who) public view returns (uint256);
17     function    allowance(address owner, address spender) public view returns (uint256);
18 
19     function    transfer(address to, uint256 value) public returns (bool);
20     function    transferFrom(address from, address to, uint256 value) public returns (bool);
21     function    approve(address spender, uint256 value) public returns (bool);
22 
23     event       Transfer( address indexed from, address indexed to, uint value );
24     event       Approval( address indexed owner, address indexed spender, uint value );
25 }
26 
27 contract    baseToken is ERC20, safeMath {
28     uint256     public  _totalSupply;
29     string      public  _name;
30     string      public  _symbol;
31     uint8       public  _decimals;
32 
33     mapping ( address => uint256 )                          _balanceOf;
34     mapping ( address => mapping ( address => uint256 ) )   _allowance;
35 
36     event Burn( address indexed from, uint256 value );
37 
38     function    baseToken( ) public {
39         uint256     balance;
40 
41         balance = 50000;
42         _name = "Onkostop";
43         _symbol = "OSC";
44         _balanceOf[msg.sender] = balance;
45         _totalSupply = balance;
46         _decimals = 0;
47     }   
48 
49     function    totalSupply() public constant returns ( uint256 ) {
50         return _totalSupply;
51     }
52 
53     function    balanceOf( address user ) public view returns ( uint256 ) {
54         return _balanceOf[user];
55     }
56 
57     function    allowance( address owner, address spender ) public view returns ( uint256 ) {
58         return _allowance[owner][spender];
59     }
60 
61     function    transfer( address to, uint amount ) public returns ( bool ) {
62         assert(_balanceOf[msg.sender] >= amount);
63         _balanceOf[msg.sender] = sub( _balanceOf[msg.sender], amount );
64         _balanceOf[to] = add( _balanceOf[to], amount );
65         Transfer( msg.sender, to, amount );
66         return true;
67     }
68 
69     function    transferFrom( address from, address to, uint amount ) public returns ( bool ) {
70         assert( _balanceOf[from] >= amount );
71         assert( _allowance[from][msg.sender] >= amount );
72         _allowance[from][msg.sender] = sub( _allowance[from][msg.sender], amount );
73         _balanceOf[from] = sub( _balanceOf[from], amount );
74         _balanceOf[to] = add( _balanceOf[to], amount );
75         Transfer( from, to, amount );
76         return true;
77     }
78 
79     function    approve( address spender, uint256 amount ) public returns ( bool ) {
80         _allowance[msg.sender][spender] = amount;
81         Approval( msg.sender, spender, amount );
82         return true;
83     }
84 
85     function    burn( uint256 value ) public returns ( bool success ) {
86         assert( _balanceOf[msg.sender] >= value );  // Check if the sender has enough
87         _balanceOf[msg.sender] -= value;            // Subtract from the sender
88         _totalSupply -= value;                      // Updates _totalSupply
89         Burn( msg.sender, value );
90         return true;
91     }
92 }