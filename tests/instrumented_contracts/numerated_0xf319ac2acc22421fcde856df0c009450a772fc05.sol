1 pragma solidity ^0.4.24;
2 
3 /**
4 *
5 WaitOrReinvest HYIP strategy:
6 Withdraw dividends will reduce investments.
7 Reinvest dividends will increase investments.
8 50% dividends per day.
9 */
10 contract WaitOrReinvest{
11     
12     using SafeMath for uint256;
13 
14     mapping(address => uint256) investments;
15     mapping(address => uint256) joined;
16     mapping(address => address) referrer;
17 	
18     uint256 public stepUp = 50; //50% per day
19     address public ownerWallet;
20 
21     event Invest(address investor, uint256 amount);
22     event Withdraw(address investor, uint256 amount);
23     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
24     
25     /**
26      * @dev Сonstructor Sets the original roles of the contract 
27      */
28      
29     constructor() public {
30         ownerWallet = msg.sender;
31     }
32 
33     /**
34      * @dev Modifiers
35      */
36      
37     modifier onlyOwner() {
38         require(msg.sender == ownerWallet);
39         _;
40     }
41 
42     /**
43      * @dev Allows current owner to transfer control of the contract to a newOwner.
44      * @param newOwnerWallet The address to transfer ownership to.
45      */
46     function transferOwnership(address newOwnerWallet) public onlyOwner {
47         require(newOwnerWallet != address(0));
48         emit OwnershipTransferred(ownerWallet, newOwnerWallet);
49         ownerWallet = newOwnerWallet;
50     }
51 
52     /**
53      * @dev Investments
54      */
55 	 
56     function () public payable {
57 		invest(address(0));
58 	}
59 	
60     function invest(address _ref) public payable {
61         require(msg.value >= 0);
62         if (investments[msg.sender] > 0){
63             reinvest(); 
64         }
65         investments[msg.sender] = investments[msg.sender].add(msg.value);
66         joined[msg.sender] = now;
67 		
68 		uint256 dfFee = msg.value.div(100).mul(5); //dev or ref fee
69         ownerWallet.transfer(dfFee);
70 		
71 		
72 		if (referrer[msg.sender] == address(0) && address(_ref) > 0 && address(_ref) != msg.sender)
73 			referrer[msg.sender] = _ref;
74 		
75 		address ref = referrer[msg.sender];	
76         if (ref > 0 ) 
77 			ref.transfer(dfFee); // bounty program
78 			
79         emit Invest(msg.sender, msg.value);
80     }
81 	
82     function reinvest() public {
83 		require(investments[msg.sender] > 0);
84 		require((now - joined[msg.sender]) > 5);
85 		
86 		uint256 balance = getDivsBalance(msg.sender);
87 		
88 		uint256 dfFee = balance.div(100).mul(5); //dev or ref fee
89 		
90 		if (address(this).balance > dfFee) {
91 			address ref = referrer[msg.sender];	 
92 			if (ref != address(0))
93 				ref.transfer(dfFee); // bounty program
94 			else 
95 				ownerWallet.transfer(dfFee); // or dev fee
96 			balance = balance.sub(dfFee); 
97 		}
98 			
99 		investments[msg.sender] += balance;
100 		joined[msg.sender] = now;
101 	}	
102 
103     /**
104     * @dev Evaluate current balance
105     * @param _address Address of investor
106     */
107     function getDivsBalance(address _address) view public returns (uint256) {
108         uint256 secondsCount = now.sub(joined[_address]);
109         uint256 percentDivs = investments[_address].mul(stepUp).div(100);
110         uint256 dividends = percentDivs.mul(secondsCount).div(86400);
111 
112         return dividends;
113     }
114 
115     /**
116     * @dev Withdraw dividends from contract
117     */
118     function withdraw() public returns (bool){
119         require(joined[msg.sender] > 0);
120         uint256 balance = getDivsBalance(msg.sender);
121         if (address(this).balance > balance){
122             if (balance > 0){
123 				joined[msg.sender]=now;
124                 msg.sender.transfer(balance);
125 				
126 				if (investments[msg.sender] > balance)
127 					investments[msg.sender] = SafeMath.sub(investments[msg.sender],balance);
128 				else 
129 					investments[msg.sender] = 0;
130 					
131                 emit Withdraw(msg.sender, balance);
132             }
133             return true;
134         } else {
135             return false;
136         }
137     }
138     
139 
140     /**
141     * @dev Gets balance of the sender address.
142     * @return An uint256 representing the amount owned by the msg.sender.
143     */
144     function checkDivsBalance() public view returns (uint256) {
145         return getDivsBalance(msg.sender);
146     }
147 
148 
149     /**
150     * @dev Gets investments of the specified address.
151     * @param _investor The address to query the the balance of.
152     * @return An uint256 representing the amount owned by the passed address.
153     */
154     function checkInvestments(address _investor) public view returns (uint256) {
155         return investments[_investor];
156     }
157 
158     
159 }
160 
161 /**
162  * @title SafeMath
163  * @dev Math operations with safety checks that throw on error
164  */
165 library SafeMath {
166     function mul(uint256 a, uint256 b) internal pure returns (uint256) {
167         if (a == 0) {
168             return 0;
169         }
170         uint256 c = a * b;
171         assert(c / a == b);
172         return c;
173     }
174 
175     function div(uint256 a, uint256 b) internal pure returns (uint256) {
176         // assert(b > 0); // Solidity automatically throws when dividing by 0
177         uint256 c = a / b;
178         // assert(a == b * c + a % b); // There is no case in which this doesn't hold
179         return c;
180     }
181 
182     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
183         assert(b <= a);
184         return a - b;
185     }
186 
187     function add(uint256 a, uint256 b) internal pure returns (uint256) {
188         uint256 c = a + b;
189         assert(c >= a);
190         return c;
191     }
192 }