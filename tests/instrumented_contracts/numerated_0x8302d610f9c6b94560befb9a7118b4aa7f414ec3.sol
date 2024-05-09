1 pragma solidity ^0.4.18;
2 /*
3 
4 0xBitcoin Token Faucet in a Smart Contract (ver 0.0.0)
5 
6 Any tokens sent to this contract may be withdrawn by other users through use
7 of the dispense() function. The dispensed amount is dependant on the
8 transaction's gas price. This means a transaction sent at 4 gwei will dispense
9 twice as many tokens as a transaction sent at 2 gwei.
10 
11 The dispensing "rate" is changable by the contract owner and allows the rate to
12 be changed over time to follow the token's price. The intention of this ratio is
13 to ensure that the value of ether spent as gas is roughly equal to the value of
14 the tokens received.
15 
16 Typically calls to dispense() cost about 41879 gas total.
17 
18 */
19 
20 
21 /**
22  * @title SafeMath
23  * @dev Math operations with safety checks that throw on error
24  */
25 library SafeMath {
26 
27   /**
28   * @dev Multiplies two numbers, throws on overflow.
29   */
30   function mul(uint256 a, uint256 b) internal pure returns (uint256) {
31     if (a == 0) {
32       return 0;
33     }
34     uint256 c = a * b;
35     assert(c / a == b);
36     return c;
37   }
38 
39   /**
40   * @dev Integer division of two numbers, truncating the quotient.
41   */
42   function div(uint256 a, uint256 b) internal pure returns (uint256) {
43     // assert(b > 0); // Solidity automatically throws when dividing by 0
44     uint256 c = a / b;
45     // assert(a == b * c + a % b); // There is no case in which this doesn't hold
46     return c;
47   }
48 
49   /**
50   * @dev Substracts two numbers, throws on overflow (i.e. if subtrahend is greater than minuend).
51   */
52   function sub(uint256 a, uint256 b) internal pure returns (uint256) {
53     assert(b <= a);
54     return a - b;
55   }
56 
57   /**
58   * @dev Adds two numbers, throws on overflow.
59   */
60   function add(uint256 a, uint256 b) internal pure returns (uint256) {
61     uint256 c = a + b;
62     assert(c >= a);
63     return c;
64   }
65 }
66 
67 
68 contract ERC20Interface {
69     function totalSupply() public constant returns (uint);
70     function balanceOf(address tokenOwner) public constant returns (uint balance);
71     function allowance(address tokenOwner, address spender) public constant returns (uint remaining);
72     function transfer(address to, uint tokens) public returns (bool success);
73     function approve(address spender, uint tokens) public returns (bool success);
74     function transferFrom(address from, address to, uint tokens) public returns (bool success);
75 
76     event Transfer(address indexed from, address indexed to, uint tokens);
77     event Approval(address indexed tokenOwner, address indexed spender, uint tokens);
78 }
79 
80 
81 // ----------------------------------------------------------------------------
82 // Owned contract
83 // ----------------------------------------------------------------------------
84 contract Owned {
85     address public owner;
86     address public newOwner;
87 
88     event OwnershipTransferred(address indexed _from, address indexed _to);
89 
90     function Owned() public {
91         owner = msg.sender;
92     }
93 
94     modifier onlyOwner {
95         require(msg.sender == owner);
96         _;
97     }
98 
99     function transferOwnership(address _newOwner) public onlyOwner {
100         newOwner = _newOwner;
101     }
102     function acceptOwnership() public {
103         require(msg.sender == newOwner);
104         OwnershipTransferred(owner, newOwner);
105         owner = newOwner;
106         newOwner = address(0);
107     }
108 }
109 
110 
111 contract GasFaucet is Owned {
112     using SafeMath for uint256;
113 
114     address public faucetTokenAddress;
115     uint256 public priceInWeiPerSatoshi;
116 
117     event Dispense(address indexed destination, uint256 sendAmount);
118 
119     constructor() public {
120         // 0xBitcoin Token Address (Ropsten)
121         // faucetTokenAddress = 0x9D2Cc383E677292ed87f63586086CfF62a009010;
122         // 0xBitcoin Token Address (Mainnet)
123         faucetTokenAddress = 0xB6eD7644C69416d67B522e20bC294A9a9B405B31;
124 
125         // Set rate to 0 satoshis / wei. Calls to 'dispense' will send 0 tokens
126         // until the rate is manually changed.
127         priceInWeiPerSatoshi = 0;
128     }
129 
130     // ------------------------------------------------------------------------
131     // Dispense some free tokens. The more gas you spend, the more tokens you
132     // recieve. 
133     // 
134     // Tokens recieved (in satoshi) = gasprice / priceInWeiPerSatoshi
135     // ------------------------------------------------------------------------
136     function dispense(address destination) public {
137         uint256 sendAmount = calculateDispensedTokensForGasPrice(tx.gasprice);
138         require(tokenBalance() > sendAmount);
139 
140         ERC20Interface(faucetTokenAddress).transfer(destination, sendAmount);
141 
142         emit Dispense(destination, sendAmount);
143     }
144     
145     // ------------------------------------------------------------------------
146     // Retrieve the current dispensing rate in satoshis per gwei
147     // ------------------------------------------------------------------------
148     function calculateDispensedTokensForGasPrice(uint256 gasprice) public view returns (uint256) {
149         if(priceInWeiPerSatoshi == 0){ 
150             return 0; 
151         }
152         return gasprice.div(priceInWeiPerSatoshi);
153     }
154     
155     // ------------------------------------------------------------------------
156     // Retrieve Faucet's balance 
157     // ------------------------------------------------------------------------
158     function tokenBalance() public view returns (uint)  {
159         return ERC20Interface(faucetTokenAddress).balanceOf(this);
160     }
161     
162     // ------------------------------------------------------------------------
163     // Retrieve the current dispensing rate in satoshis per gwei
164     // ------------------------------------------------------------------------
165     function getWeiPerSatoshi() public view returns (uint256) {
166         return priceInWeiPerSatoshi;
167     }
168     
169     // ------------------------------------------------------------------------
170     // Set the current dispensing rate in satoshis per gwei
171     // ------------------------------------------------------------------------
172     function setWeiPerSatoshi(uint256 price) public onlyOwner {
173         priceInWeiPerSatoshi = price;
174     }
175 
176     // ------------------------------------------------------------------------
177     // Don't accept ETH
178     // ------------------------------------------------------------------------
179     function () public payable {
180         revert();
181     }
182 
183     // ------------------------------------------------------------------------
184     // Owner can withdraw any accidentally sent eth
185     // ------------------------------------------------------------------------
186     function withdrawEth(uint256 amount) public onlyOwner {
187         require(amount < address(this).balance);
188         owner.transfer(amount);
189     }
190 
191     // ------------------------------------------------------------------------
192     // Owner can transfer out any ERC20 tokens
193     // ------------------------------------------------------------------------
194     function transferAnyERC20Token(address tokenAddress, uint256 tokens) public onlyOwner {
195         
196         // Note: Owner has full control of priceInWeiPerSatoshi, so preventing
197         // withdrawal of the faucetTokenAddress token serves no purpose. It
198         // would merely be misleading.
199         //
200         // if(tokenAddress == faucetTokenAddress){ 
201         //     revert(); 
202         // }
203 
204         ERC20Interface(tokenAddress).transfer(owner, tokens);
205     }
206 }