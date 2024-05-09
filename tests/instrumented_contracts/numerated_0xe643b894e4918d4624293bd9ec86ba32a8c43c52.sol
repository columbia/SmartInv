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
11     // assert(b > 0); // Solidity automatically throws when dividing by 0
12     uint256 c = a / b;
13     // assert(a == b * c + a % b); // There is no case in which this doesn't hold
14     return c;
15   }
16  
17   function sub(uint256 a, uint256 b) internal pure returns (uint256) {
18     assert(b <= a); 
19     return a - b; 
20   } 
21   
22   function add(uint256 a, uint256 b) internal pure returns (uint256) { 
23     uint256 c = a + b; assert(c >= a);
24     return c;
25   }
26  
27 }
28 
29 contract Ownable {
30     address public owner;
31 
32     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
33 
34     modifier onlyOwner() { require(msg.sender == owner); _; }
35 
36     function Ownable() public {
37         owner = msg.sender;
38     }
39 
40     function transferOwnership(address newOwner) public onlyOwner {
41         require(newOwner != address(0));
42         owner = newOwner;
43         OwnershipTransferred(owner, newOwner);
44     }
45 
46 }
47 
48 contract ERC20Basic {
49   uint256 public totalSupply;
50   function balanceOf(address who) constant returns (uint256);
51   function transfer(address to, uint256 value) returns (bool);
52   event Transfer(address indexed from, address indexed to, uint256 value);
53 }
54 
55 contract ERC20 is ERC20Basic {
56   function allowance(address owner, address spender) constant returns (uint256);
57   function transferFrom(address from, address to, uint256 value) returns (bool);
58   function approve(address spender, uint256 value) returns (bool);
59   event Approval(address indexed owner, address indexed spender, uint256 value);
60 }
61 
62 contract FiatContract {
63   function USD(uint _id) constant returns (uint256);
64 }
65 
66 contract Main is Ownable {
67     using SafeMath for uint256;
68     address public wallet = 0x849861cE5c88F355A286d973302cf84A5e33fa6b; 
69     uint256 public bonus = 50;
70     uint256 public price = 10;
71 
72     function setBonus(uint newBonus) onlyOwner public  {
73         bonus = newBonus;
74     }
75 
76     function setWallet(address _newWallet) onlyOwner public {
77         require(_newWallet != address(0));
78         wallet = _newWallet;
79     }
80 
81     function setPrice(uint newPrice) onlyOwner public  {
82         price = newPrice;
83     }
84 
85 
86 }
87 
88 
89 contract Transaction is Main  {
90     uint256 USDv;
91     uint256 MIRAv;
92     FiatContract public fiat;
93     
94     ERC20 MIRAtoken = ERC20(0x8BCD8DaFc917BFe3C82313e05fc9738aeB72d555);
95 
96      function Transaction() {
97           fiat = FiatContract(0x8055d0504666e2B6942BeB8D6014c964658Ca591);
98      }
99    
100 
101     function() external payable {
102         address buyer = msg.sender;
103         require(buyer != address(0));
104         require(msg.value != 0);
105         MIRAv = msg.value;
106         uint256 cent = fiat.USD(0);
107         uint256 dollar = cent*100;
108 
109         USDv = msg.value.div(dollar); //USD
110         
111         require(USDv != 0);
112         
113         MIRAv = USDv.mul(1000).div(price);              // without bonus
114         MIRAv = MIRAv + MIRAv.div(100).mul(bonus);      // + bonus
115         MIRAv = MIRAv.mul(100000000);
116         
117         address(wallet).send(msg.value); //send eth
118         MIRAtoken.transfer(buyer,MIRAv); //send tokens
119     }
120 
121     function getMIRABALANCE() public  constant returns (uint256) {  
122         require(msg.sender == owner);
123         return MIRAtoken.balanceOf(address(this)).div(100000000); 
124         }
125     function getADR() public constant returns (address) {   return address(this);  }
126 
127 }
128 
129 
130 
131 // Please, visit https://miramind.io/risks.pdf to know more about the risks