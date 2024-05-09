1 pragma solidity ^0.4.16;
2 
3 contract owned {
4     address public owner;
5 
6     function owned() {
7         owner = msg.sender;
8     }
9 
10     modifier onlyOwner {
11         if (msg.sender != owner) {
12             revert();
13         }
14         _;
15     }
16 }
17 
18 library SafeMath {
19 	function mul(uint256 a, uint256 b) internal constant returns (uint256) {
20 		uint256 c = a * b;
21 		assert(a == 0 || c / a == b);
22 		return c;
23 	}
24 
25 	function div(uint256 a, uint256 b) internal constant returns (uint256) {
26 		// assert(b > 0); // Solidity automatically throws when dividing by 0
27 		uint256 c = a / b;
28 		// assert(a == b * c + a % b); // There is no case in which this doesn't hold
29 		return c;
30 	}
31 
32 	function sub(uint256 a, uint256 b) internal constant returns (uint256) {
33 		assert(b <= a);
34 		return a - b;
35 	}
36 
37 	function add(uint256 a, uint256 b) internal constant returns (uint256) {
38 		uint256 c = a + b;
39 		assert(c >= a);
40 		return c;
41 	}
42 }
43 
44 contract GexCryptoPresale is owned {
45 
46     uint public presaleStart;
47     uint public saleEnd;
48     uint256 public presaleBonus;
49     uint256 public buyingPrice;
50     uint256 public totalInvestors;
51 
52     function GexCryptoPresale() {
53         presaleStart = 1508011200; 
54         saleEnd = 1512972000;
55         presaleBonus = 30;
56         buyingPrice = 350877190000000;
57     }
58 
59     event EtherTransfer(address indexed _from,address indexed _to,uint256 _value);
60 
61     function changeTiming(uint _presaleStart,uint _saleEnd) onlyOwner {
62         presaleStart = _presaleStart;
63         saleEnd = _saleEnd;
64     }
65 
66     function changeBonus(uint256 _presaleBonus) onlyOwner {
67         presaleBonus = _presaleBonus;
68     }
69 
70     function changeBuyingPrice(uint256 _buyingPrice) onlyOwner {
71         buyingPrice = _buyingPrice;
72     }
73 
74     function withdrawEther(address _account) onlyOwner payable returns (bool success) {
75         require(_account.send(this.balance));
76 
77         EtherTransfer(this, _account, this.balance);
78         return true;
79     }
80 
81     function destroyContract() {
82         if (msg.sender == owner) {
83             selfdestruct(owner);
84         }
85     }
86 
87     function () payable {
88         uint256 tokens = msg.value / buyingPrice;
89         totalInvestors = totalInvestors + 1;
90         if (presaleStart < now && saleEnd > now) {
91             require(msg.value >= 1 ether);
92         } else {
93             revert();
94         }
95     }
96 
97 }