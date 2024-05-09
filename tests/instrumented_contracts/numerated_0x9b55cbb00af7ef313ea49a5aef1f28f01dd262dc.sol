1 pragma solidity ^0.4.17;
2 
3 /**
4  * @title SafeMath
5  * @dev Math operations with safety checks that throw on error
6  */
7 library SafeMath {
8   function mul(uint256 a, uint256 b) internal constant returns (uint256) {
9     uint256 c = a * b;
10     assert(a == 0 || c / a == b);
11     return c;
12   }
13 
14   function div(uint256 a, uint256 b) internal constant returns (uint256) {
15     // assert(b > 0); // Solidity automatically throws when dividing by 0
16     uint256 c = a / b;
17     // assert(a == b * c + a % b); // There is no case in which this doesn't hold
18     return c;
19   }
20 
21   function sub(uint256 a, uint256 b) internal constant returns (uint256) {
22     assert(b <= a);
23     return a - b;
24   }
25 
26   function add(uint256 a, uint256 b) internal constant returns (uint256) {
27     uint256 c = a + b;
28     assert(c >= a);
29     return c;
30   }
31 }
32 
33 
34 
35 /**
36  * @title Ownable
37  * @dev The Ownable contract has an owner address, and provides basic authorization control
38  * functions, this simplifies the implementation of "user permissions".
39  */
40 contract Ownable {
41   address public owner;
42 
43 
44   event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
45 
46 
47   /**
48    * @dev The Ownable constructor sets the original `owner` of the contract to the sender
49    * account.
50    */
51   function Ownable() {
52     owner = msg.sender;
53   }
54 
55 
56   /**
57    * @dev Throws if called by any account other than the owner.
58    */
59   modifier onlyOwner() {
60     require(msg.sender == owner);
61     _;
62   }
63 
64 
65   /**
66    * @dev Allows the current owner to transfer control of the contract to a newOwner.
67    * @param newOwner The address to transfer ownership to.
68    */
69   function transferOwnership(address newOwner) onlyOwner public {
70     require(newOwner != address(0));
71     OwnershipTransferred(owner, newOwner);
72     owner = newOwner;
73   }
74 }
75 
76 /**
77  * @title Pausable
78  * @dev Base contract which allows children to implement an emergency stop mechanism.
79  */
80 contract Pausable is Ownable {
81   event Pause();
82   event Unpause();
83 
84   bool public paused = false;
85 
86 
87   /**
88    * @dev Modifier to make a function callable only when the contract is not paused.
89    */
90   modifier whenNotPaused() {
91     require(!paused);
92     _;
93   }
94 
95   /**
96    * @dev Modifier to make a function callable only when the contract is paused.
97    */
98   modifier whenPaused() {
99     require(paused);
100     _;
101   }
102 
103   /**
104    * @dev called by the owner to pause, triggers stopped state
105    */
106   function pause() onlyOwner whenNotPaused public {
107     paused = true;
108     Pause();
109   }
110 
111   /**
112    * @dev called by the owner to unpause, returns to normal state
113    */
114   function unpause() onlyOwner whenPaused public {
115     paused = false;
116     Unpause();
117   }
118 }
119 
120 contract BonumPreICO is Pausable{
121     using SafeMath for uint;
122 
123     string public constant name = "Bonum PreICO";
124 
125     uint public fiatValueMultiplier = 10**6;
126     uint public tokenDecimals = 10**18;
127 
128     address public beneficiary;
129 
130     uint public ethUsdRate;
131     uint public collected = 0;
132     uint public tokensSold = 0;
133     uint public tokensSoldWithBonus = 0;
134 
135 
136     event NewContribution(address indexed holder, uint tokenAmount, uint etherAmount);
137 
138     function BonumPreICO(
139         address _beneficiary,
140         uint _baseEthUsdRate
141     ) public {
142         beneficiary = _beneficiary;
143 
144         ethUsdRate = _baseEthUsdRate;
145     }
146 
147 
148     function setNewBeneficiary(address newBeneficiary) external onlyOwner {
149         require(newBeneficiary != 0x0);
150         beneficiary = newBeneficiary;
151     }
152 
153     function setEthUsdRate(uint rate) external onlyOwner {
154         require(rate > 0);
155         ethUsdRate = rate;
156     }
157 
158     modifier underCap(){
159         require(tokensSold < uint(750000).mul(tokenDecimals));
160         _;
161     }
162 
163     modifier minimumAmount(){
164         require(msg.value.mul(ethUsdRate).div(fiatValueMultiplier.mul(1 ether)) >= 100);
165         _;
166     }
167 
168     mapping (address => uint) public investors;
169 
170     function() payable public whenNotPaused minimumAmount underCap{
171         uint tokens = msg.value.mul(ethUsdRate).div(fiatValueMultiplier);
172         tokensSold = tokensSold.add(tokens);
173         
174         tokens = tokens.add(tokens.mul(25).div(100));
175         tokensSoldWithBonus =  tokensSoldWithBonus.add(tokens);
176         
177         investors[msg.sender] = investors[msg.sender].add(tokens);
178         NewContribution(msg.sender, tokens, msg.value);
179 
180         collected = collected.add(msg.value);
181 
182         beneficiary.transfer(msg.value);
183     }
184 }