1 library SafeMath {
2   function mul(uint a, uint b) internal pure  returns (uint) {
3     uint c = a * b;
4     require(a == 0 || c / a == b);
5     return c;
6   }
7   function div(uint a, uint b) internal pure returns (uint) {
8     require(b > 0);
9     uint c = a / b;
10     require(a == b * c + a % b);
11     return c;
12   }
13   function sub(uint a, uint b) internal pure returns (uint) {
14     require(b <= a);
15     return a - b;
16   }
17   function add(uint a, uint b) internal pure returns (uint) {
18     uint c = a + b;
19     require(c >= a);
20     return c;
21   }
22   function max64(uint64 a, uint64 b) internal  pure returns (uint64) {
23     return a >= b ? a : b;
24   }
25   function min64(uint64 a, uint64 b) internal  pure returns (uint64) {
26     return a < b ? a : b;
27   }
28   function max256(uint256 a, uint256 b) internal  pure returns (uint256) {
29     return a >= b ? a : b;
30   }
31   function min256(uint256 a, uint256 b) internal  pure returns (uint256) {
32     return a < b ? a : b;
33   }
34 }
35 
36 
37 contract Ownable {
38     address public owner;
39 
40     function Ownable() public{
41         owner = msg.sender;
42     }
43 
44     modifier onlyOwner {
45         require(msg.sender == owner);
46         _;
47     }
48     function transferOwnership(address newOwner) onlyOwner public{
49         if (newOwner != address(0)) {
50             owner = newOwner;
51         }
52     }
53 }
54 
55 interface IERC20 {
56     function transfer(address to, uint256 value) external returns (bool);
57     function transferFrom(address from, address to, uint256 value) external returns (bool);
58     function balanceOf(address _owner) external view returns (uint256 balance);
59 
60 }
61 
62 contract TokenAirdroperFor5GT is Ownable{
63     
64     using SafeMath for uint;
65 
66     address public tokenAddress = 0xf82c9bbcc3b1407b494c8529256c2a8ea5dd8eb6;
67 
68     uint256 public limitPayValue = 0.1 ether;
69   
70     uint256 public airdropRate = 555;
71     bool public airdropPaused = false;
72 
73 
74     constructor(){}
75      
76     function () payable public{
77         require(airdropPaused == false);
78         require(msg.value == limitPayValue);
79         require(owner.send(msg.value));
80         require(IERC20(tokenAddress).transfer(msg.sender,airdropRate.mul(1 ether)));
81     }
82     function changeAirdropStatus(bool _airdropPaused) public onlyOwner{
83         airdropPaused = _airdropPaused;
84     }
85     
86     function withdraw(address _tokenAddress) public onlyOwner{
87          if(_tokenAddress == address(0)){
88           require(owner.send(address(this).balance));
89           return;
90       }
91       IERC20 erc20 = IERC20(tokenAddress);
92       uint256 balance = erc20.balanceOf(this);
93       require(erc20.transfer(owner,balance));
94     }
95 
96     
97 }