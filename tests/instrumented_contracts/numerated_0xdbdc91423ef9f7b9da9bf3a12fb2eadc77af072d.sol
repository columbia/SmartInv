1 pragma solidity ^0.4.13;
2 
3 
4 contract ERC20Basic {
5   uint256 public totalSupply;
6   function balanceOf(address who) public view returns (uint256);
7   function transfer(address to, uint256 value) public returns (bool);
8   event Transfer(address indexed from, address indexed to, uint256 value);
9 }
10 
11 contract ERC20 is ERC20Basic {
12   function allowance(address owner, address spender) public view returns (uint256);
13   function transferFrom(address from, address to, uint256 value) public returns (bool);
14   function approve(address spender, uint256 value) public returns (bool);
15   event Approval(address indexed owner, address indexed spender, uint256 value);
16 }
17 contract Ownable {
18   address public owner;
19 
20 
21   event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
22 
23 
24   /**
25    * @dev The Ownable constructor sets the original `owner` of the contract to the sender
26    * account.
27    */
28   function Ownable() public {
29     owner = msg.sender;
30   }
31 
32 
33   /**
34    * @dev Throws if called by any account other than the owner.
35    */
36   modifier onlyOwner() {
37     require(msg.sender == owner);
38     _;
39   }
40 
41 
42   /**
43    * @dev Allows the current owner to transfer control of the contract to a newOwner.
44    * @param newOwner The address to transfer ownership to.
45    */
46   function transferOwnership(address newOwner) public onlyOwner {
47     require(newOwner != address(0));
48     OwnershipTransferred(owner, newOwner);
49     owner = newOwner;
50   }
51 
52 }
53 
54 library SafeMath {
55   function mul(uint256 a, uint256 b) internal pure returns (uint256) {
56     if (a == 0) {
57       return 0;
58     }
59     uint256 c = a * b;
60     assert(c / a == b);
61     return c;
62   }
63 
64   function div(uint256 a, uint256 b) internal pure returns (uint256) {
65     // assert(b > 0); // Solidity automatically throws when dividing by 0
66     uint256 c = a / b;
67     // assert(a == b * c + a % b); // There is no case in which this doesn't hold
68     return c;
69   }
70 
71   function sub(uint256 a, uint256 b) internal pure returns (uint256) {
72     assert(b <= a);
73     return a - b;
74   }
75 
76   function add(uint256 a, uint256 b) internal pure returns (uint256) {
77     uint256 c = a + b;
78     assert(c >= a);
79     return c;
80   }
81 }
82 contract TokenBooksAirdrop is Ownable{
83 	using SafeMath for uint256;
84 
85 	mapping (address => uint) public airdropSupplyMap;
86 	function TokenBooksAirdrop(){
87 	}
88 
89 
90     function withdrawCoinToOwner(address tokenAddress ,uint256 _value) external
91 		onlyOwner
92 	{
93 		processFunding(tokenAddress,msg.sender,_value,1);
94 	}
95 	//空投
96     function airdrop(address tokenAddress,address [] _holders,uint256 paySize) external
97     	onlyOwner 
98 	{
99 		ERC20 token = ERC20(tokenAddress);
100         uint256 count = _holders.length;
101         assert(paySize.mul(count) <= token.balanceOf(this));
102         for (uint256 i = 0; i < count; i++) {
103 			processFunding(tokenAddress,_holders [i],paySize,1);
104 			airdropSupplyMap[tokenAddress] = airdropSupplyMap[tokenAddress].add(paySize); 
105         }
106     }
107 	function processFunding(address tokenAddress,address receiver,uint256 _value,uint256 _rate) internal
108 	{
109 		ERC20 token = ERC20(tokenAddress);
110 		uint256 amount=_value.mul(_rate);
111 		require(amount<=token.balanceOf(this));
112 		if(!token.transfer(receiver,amount)){
113 			revert();
114 		}
115 	}
116 
117 	
118 	function etherProceeds() external
119 		onlyOwner
120 
121 	{
122 		if(!msg.sender.send(this.balance)) revert();
123 	}
124 
125 }