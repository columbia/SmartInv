1 pragma solidity ^0.4.18;
2 
3 library SafeMath {
4   function mul(uint a, uint b) internal pure returns (uint) 
5   {
6     uint c = a * b;
7     assert(a == 0 || c / a == b);
8     return c;
9   }
10   
11   function div(uint a, uint b) internal pure returns (uint) 
12   {
13     assert(b > 0);
14     uint c = a / b;
15     assert(a == b * c + a % b);
16     return c;
17   }
18   function sub(uint a, uint b) internal pure returns (uint) {
19     assert(b <= a);
20     return a - b;
21   }
22   function add(uint a, uint b) internal pure returns (uint) {
23     uint c = a + b;
24     assert(c >= a);
25     return c;
26   }
27   function max64(uint64 a, uint64 b) internal pure returns (uint64) {
28     return a >= b ? a : b;
29   }
30   function min64(uint64 a, uint64 b) internal pure returns (uint64) {
31     return a < b ? a : b;
32   }
33   function max256(uint256 a, uint256 b) internal pure returns (uint256) {
34     return a >= b ? a : b;
35   }
36   function min256(uint256 a, uint256 b) internal pure returns (uint256) {
37     return a < b ? a : b;
38   }
39 }
40 
41 contract Ownable {
42     address public owner;
43     function Ownable() public {
44         owner = msg.sender;
45     }
46     modifier onlyOwner {
47         require(msg.sender == owner);
48         _;
49     }
50     function  transferOwnership(address newOwner) onlyOwner public {
51         if (newOwner != address(0)) {
52             owner = newOwner;
53         }
54     }
55 }
56 
57 contract GranitePreICO is Ownable {
58     using SafeMath for uint;
59     string public constant name = "Pre-ICO Granite Labor Coin";
60     string public constant symbol = "PGLC";
61     uint public constant coinPrice = 25 * 10 ** 14;
62     uint public constant decimals = 18;
63     uint public constant bonus = 50;
64     uint public minAmount = 10 ** 18;
65     uint public totalSupply = 0;
66     bool public isActive = true;
67     uint public investorsCount = 0;
68     uint public constant hardCap = 250000 * 10 ** 18;
69 
70     mapping(address => uint256) balances;
71     mapping(address => uint) personalBonuses;
72     mapping(uint => address) investors;
73 
74     event Paid(address indexed from, uint value);
75 
76     function() payable public {
77         receiveETH();
78     }
79 
80     function receiveETH() internal {
81         require(isActive); // can receive ETH only if pre-ICO is active
82         
83         require(msg.value >= minAmount);
84         
85         uint coinsCount = msg.value.div(coinPrice).mul(10 ** 18); // counts amount
86         coinsCount = coinsCount.add(coinsCount.div(100).mul(personalBonuses[msg.sender] > 0 ? personalBonuses[msg.sender] : bonus)); // bonus
87 
88         require((totalSupply + coinsCount) <= hardCap);
89 
90         if (balances[msg.sender] == 0) {
91             investors[investorsCount] = msg.sender;
92             investorsCount++;
93         }
94 
95         balances[msg.sender] += coinsCount;
96         totalSupply += coinsCount;
97 
98         Paid(msg.sender, coinsCount);
99     }
100 
101     function balanceOf(address _addr) constant public returns(uint256)
102     {
103         return balances[_addr];    
104     }
105 
106     function getPersonalBonus(address _addr) constant public returns(uint) {
107         return personalBonuses[_addr] > 0 ? personalBonuses[_addr] : bonus;
108     }
109 
110     function setPersonalBonus(address _addr, uint8 _value) onlyOwner public {
111         require(_value > 0 && _value <=100);
112         personalBonuses[_addr] = _value;
113     }
114  
115     function getInvestorAddress(uint index) constant public returns(address)
116     {
117         require(investorsCount > index);
118         return investors[index];
119     }
120     
121     function getInvestorBalance(uint index) constant public returns(uint256) 
122     {
123         address addr = investors[index];
124         require(addr != 0);
125         return  balances[addr];
126     }
127 
128     function setActive(bool _value) onlyOwner public {
129         isActive = _value;
130     }
131     
132     function setMinAmount(uint amount) onlyOwner public {
133         require(amount > 0);
134         minAmount = amount;
135     }
136 
137     function drain() onlyOwner public {
138         msg.sender.transfer(this.balance);
139     }
140  }