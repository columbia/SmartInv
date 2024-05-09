1 library SafeMath {
2   function mul(uint256 a, uint256 b) internal constant returns (uint256) {
3     uint256 c = a * b;
4     assert(a == 0 || c / a == b);
5     return c;
6   }
7 
8   function div(uint256 a, uint256 b) internal constant returns (uint256) {
9     // assert(b > 0); // Solidity automatically throws when dividing by 0
10     uint256 c = a / b;
11     // assert(a == b * c + a % b); // There is no case in which this doesn't hold
12     return c;
13   }
14 
15   function sub(uint256 a, uint256 b) internal constant returns (uint256) {
16     assert(b <= a);
17     return a - b;
18   }
19 
20   function add(uint256 a, uint256 b) internal constant returns (uint256) {
21     uint256 c = a + b;
22     assert(c >= a);
23     return c;
24   }
25 }
26 
27 contract Ownable {
28   address public owner;
29   event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
30 
31   function Ownable() public {
32     owner = msg.sender;
33   }
34 
35   modifier onlyOwner() {
36     require(msg.sender == owner);
37     _;
38   }
39 
40   function transferOwnership(address newOwner) public onlyOwner {
41     require(newOwner != address(0));
42     OwnershipTransferred(owner, newOwner);
43     owner = newOwner;
44   }
45   
46   function getOwner() public returns (address) {
47 	return owner;
48   }
49 
50 }
51 
52 contract AngelToken {
53 	function getTotalSupply() public returns (uint256);
54 	function totalSupply() public view returns (uint256);
55 	function balanceOf(address who) public view returns (uint256);
56 	function transfer(address to, uint256 value) public returns (bool);
57 }
58 
59 contract GiveAnAngelCS is Ownable {
60     using SafeMath for uint256;
61 
62     AngelToken public token;
63     address public wallet;
64     uint256 public price;
65     uint256 public weiRaised;
66 	// integer number - eg. 30 means 30 percent 
67 	uint256 public currentBonus = 0;
68 	uint256 public constant ETH_LIMIT = 1 * (10 ** 17);
69 
70     event AngelTokenPurchase(address indexed purchaser, address indexed beneficiary, uint256 value, uint256 amount);
71 
72     function GiveAnAngelCS(uint256 _price, address _wallet) {
73         require(_price > 0);
74         require(_wallet != address(0));
75 
76         token = AngelToken(0x4597cf324eb06ff0c4d1cc97576f11336d8da730);
77         price = _price;
78         wallet = _wallet;
79     }
80 
81     // fallback function can be used to buy tokens
82     function () payable {
83         buyTokens(msg.sender);
84     }
85 
86     // low level token purchase function
87     function buyTokens(address beneficiary) public payable {
88         require(beneficiary != address(0));
89         uint256 weiAmount = msg.value;
90 
91 		require(weiAmount >= ETH_LIMIT);
92 		
93         // calculate token amount to be created
94         uint256 tokens = weiAmount.mul(currentBonus.add(100)).mul(10**18).div(price).div(100);
95 
96         require(validPurchase(tokens));
97 
98         // update state
99         weiRaised = weiRaised.add(weiAmount);
100 
101         token.transfer(msg.sender, tokens);
102 
103         AngelTokenPurchase(msg.sender, beneficiary, weiAmount, tokens);
104         forwardFunds();
105     }
106 
107     // send ether to the fund collection wallet
108     function forwardFunds() internal {
109         wallet.transfer(msg.value);
110     }
111 
112     // @return true if the transaction can buy tokens
113     function validPurchase(uint256 tokens) internal constant returns (bool) {
114         return token.balanceOf(this) >= tokens;
115     }
116 	
117 	function setBonus(uint256 _bonus) onlyOwner public {
118 		currentBonus = _bonus;
119 	}
120 	
121 	function setPrice(uint256 _price) onlyOwner public {
122 		price = _price;
123 	}
124 	
125 	function getBonus() public returns (uint256) {
126         return currentBonus;
127     }
128 	
129 	function getRaised() public returns (uint256) {
130         return weiRaised;
131     }
132 	
133 	function returnToOwner() onlyOwner public {
134 		uint256 currentBalance = token.balanceOf(this);
135 		token.transfer(getOwner(), currentBalance);
136 	}
137 }