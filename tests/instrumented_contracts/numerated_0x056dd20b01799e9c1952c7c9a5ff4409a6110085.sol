1 pragma solidity ^0.4.19;
2 
3 /**
4  * @title ERC20
5  * @dev ERC20 interface
6  */
7 contract ERC20 {
8     function balanceOf(address who) public constant returns (uint256);
9     function transfer(address to, uint256 value) public returns (bool);
10     function allowance(address owner, address spender) public constant returns (uint256);
11     function transferFrom(address from, address to, uint256 value) public returns (bool);
12     function approve(address spender, uint256 value) public returns (bool);
13     event Transfer(address indexed from, address indexed to, uint256 value);
14     event Approval(address indexed owner, address indexed spender, uint256 value);
15 }
16 
17 /**
18  * @title Ownable
19  * @dev The Ownable contract has an owner address, and provides basic authorization control
20  * functions, this simplifies the implementation of "user permissions".
21  */
22 contract Ownable {
23   address public owner;
24 
25 
26   event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
27 
28 
29   /**
30    * @dev The Ownable constructor sets the original `owner` of the contract to the sender
31    * account.
32    */
33   constructor() public{
34     owner = msg.sender;
35   }
36 
37 
38   /**
39    * @dev Throws if called by any account other than the owner.
40    */
41   modifier onlyOwner() {
42     require(msg.sender == owner);
43     _;
44   }
45 
46 
47   /**
48    * @dev Allows the current owner to transfer control of the contract to a newOwner.
49    * @param newOwner The address to transfer ownership to.
50    */
51   function transferOwnership(address newOwner) onlyOwner public {
52     require(newOwner != address(0));
53     emit OwnershipTransferred(owner, newOwner);
54     owner = newOwner;
55   }
56 
57 }
58 
59 /**
60  * @title SafeMath
61  * @dev Math operations with safety checks that throw on error
62  */
63 library SafeMath {
64   function mul(uint256 a, uint256 b) internal pure returns (uint256) {
65     uint256 c = a * b;
66     assert(a == 0 || c / a == b);
67     return c;
68   }
69 
70   function div(uint256 a, uint256 b) internal pure returns (uint256) {
71     // assert(b > 0); // Solidity automatically throws when dividing by 0
72     uint256 c = a / b;
73     // assert(a == b * c + a % b); // There is no case in which this doesn't hold
74     return c;
75   }
76 
77   function sub(uint256 a, uint256 b) internal pure returns (uint256) {
78     assert(b <= a);
79     return a - b;
80   }
81 
82   function add(uint256 a, uint256 b) internal pure returns (uint256) {
83     uint256 c = a + b;
84     assert(c >= a);
85     return c;
86   }
87 }
88 
89 /**
90  * The WPPToken contract does this and that...
91  */
92 contract WPPToken is ERC20, Ownable {
93 
94 	using SafeMath for uint256;
95 
96 	uint256  public  totalSupply = 5000000000 * 1 ether;
97 
98 
99 	mapping  (address => uint256)             public          _balances;
100     mapping  (address => mapping (address => uint256)) public  _approvals;
101 
102     string   public  name = "WPPTOKEN";
103     string   public  symbol = "WPP";
104     uint256  public  decimals = 18;
105 
106     event Transfer(address indexed from, address indexed to, uint256 value);
107     event Approval(address indexed owner, address indexed spender, uint256 value);
108     
109 
110     constructor () public{
111 		_balances[owner] = totalSupply;
112 	}
113 
114     function totalSupply() public constant returns (uint256) {
115         return totalSupply;
116     }
117     function balanceOf(address src) public constant returns (uint256) {
118         return _balances[src];
119     }
120     function allowance(address src, address guy) public constant returns (uint256) {
121         return _approvals[src][guy];
122     }
123     
124     function transfer(address dst, uint256 wad) public returns (bool) {
125         assert(_balances[msg.sender] >= wad);
126         
127         _balances[msg.sender] = _balances[msg.sender].sub(wad);
128         _balances[dst] = _balances[dst].add(wad);
129         
130         emit Transfer(msg.sender, dst, wad);
131         
132         return true;
133     }
134     
135     function transferFrom(address src, address dst, uint256 wad) public returns (bool) {
136         assert(_balances[src] >= wad);
137         assert(_approvals[src][msg.sender] >= wad);
138         
139         _approvals[src][msg.sender] = _approvals[src][msg.sender].sub(wad);
140         _balances[src] = _balances[src].sub(wad);
141         _balances[dst] = _balances[dst].add(wad);
142         
143         emit Transfer(src, dst, wad);
144         
145         return true;
146     }
147     
148     function approve(address guy, uint256 wad) public returns (bool) {
149         _approvals[msg.sender][guy] = wad;
150         
151         emit Approval(msg.sender, guy, wad);
152         
153         return true;
154     }
155 
156 }