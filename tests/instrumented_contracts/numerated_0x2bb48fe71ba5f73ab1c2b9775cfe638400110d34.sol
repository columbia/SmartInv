1 pragma solidity ^0.4.18;
2 
3 /**
4  * @title Ownable
5  * @dev The Ownable contract has an owner address, and provides basic authorization control
6  * functions, this simplifies the implementation of "user permissions".
7  */
8 contract Ownable {
9   address public owner;
10 
11   event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
12 
13   /**
14    * @dev The Ownable constructor sets the original `owner` of the contract to the sender
15    * account.
16    */
17   function Ownable() public {
18     owner = msg.sender;
19   }
20 
21 
22   /**
23    * @dev Throws if called by any account other than the owner.
24    */
25   modifier onlyOwner() {
26     require(msg.sender == owner);
27     _;
28   }
29 
30 
31   /**
32    * @dev Allows the current owner to transfer control of the contract to a newOwner.
33    * @param newOwner The address to transfer ownership to.
34    */
35   function transferOwnership(address newOwner) public onlyOwner {
36     require(newOwner != address(0));
37     OwnershipTransferred(owner, newOwner);
38     owner = newOwner;
39   }
40 
41 }
42 
43 pragma solidity ^0.4.18;
44 
45 /**
46  * @title SafeMath
47  * @dev Math operations with safety checks that throw on error
48  */
49 library SafeMath {
50 
51   /**
52   * @dev Multiplies two numbers, throws on overflow.
53   */
54   function mul(uint256 a, uint256 b) internal pure returns (uint256) {
55     if (a == 0) {
56       return 0;
57     }
58     uint256 c = a * b;
59     assert(c / a == b);
60     return c;
61   }
62 
63   /**
64   * @dev Integer division of two numbers, truncating the quotient.
65   */
66   function div(uint256 a, uint256 b) internal pure returns (uint256) {
67     // assert(b > 0); // Solidity automatically throws when dividing by 0
68     uint256 c = a / b;
69     // assert(a == b * c + a % b); // There is no case in which this doesn't hold
70     return c;
71   }
72 
73   /**
74   * @dev Substracts two numbers, throws on overflow (i.e. if subtrahend is greater than minuend).
75   */
76   function sub(uint256 a, uint256 b) internal pure returns (uint256) {
77     assert(b <= a);
78     return a - b;
79   }
80 
81   /**
82   * @dev Adds two numbers, throws on overflow.
83   */
84   function add(uint256 a, uint256 b) internal pure returns (uint256) {
85     uint256 c = a + b;
86     assert(c >= a);
87     return c;
88   }
89 }
90 
91 
92 contract ERC20Token {
93 
94     using SafeMath for uint256;
95 
96     string public constant name = "Zombie Token";
97     string public constant symbol = "ZOB";
98     uint8 public constant decimals = 18;
99     uint256 public totalSupply;
100 
101     mapping (address => uint256) public balanceOf;
102     mapping (address => mapping (address => uint256)) public allowance;
103 
104     event Transfer(address indexed from, address indexed to, uint256 value);
105     event Approval(address indexed from, uint256 value, address indexed to);
106 
107     function ERC20Token() public {
108     }
109 
110     /**
111      * Internal transfer, only can be called by this contract
112      */
113     function _transfer(address from, address to, uint256 value) internal {
114         // Check if the sender has enough balance
115         require(balanceOf[from] >= value);
116 
117         // Check for overflow
118         require(balanceOf[to] + value > balanceOf[to]);
119 
120         // Save this for an amount double check assertion
121         uint256 previousBalances = balanceOf[from].add(balanceOf[to]);
122 
123         balanceOf[from] = balanceOf[from].sub(value);
124         balanceOf[to] = balanceOf[to].add(value);
125 
126         Transfer(from, to, value);
127 
128         // Asserts for duplicate check. Should never fail.
129         assert(balanceOf[from].add(balanceOf[to]) == previousBalances);
130     }
131 
132     /**
133      * Transfer tokens
134      *
135      * Send `value` tokens to `to` from your account
136      *
137      * @param to The address of the recipient
138      * @param value the amount to send
139      */
140     function transfer(address to, uint256 value) public returns (bool success)  {
141         _transfer(msg.sender, to, value);
142         return true;
143     }
144     
145 
146     /**
147      * Transfer tokens from other address
148      *
149      * Send `value` tokens to `to` in behalf of `from`
150      *
151      * @param from The address of the sender
152      * @param to The address of the recipient
153      * @param value the amount to send
154      */
155     function transferFrom(address from, address to, uint256 value) public returns (bool success) {
156         require(value <= allowance[from][msg.sender]);
157         allowance[from][msg.sender] = allowance[from][msg.sender].sub(value);
158         _transfer(from, to, value);
159         return true;
160     }
161 
162     /**
163      * Set allowance for other address
164      *
165      * Allows `spender` to spend no more than `value` tokens in your behalf
166      *
167      * @param spender The address authorized to spend
168      * @param value the max amount they can spend
169      */
170     function approve(address spender, uint256 value) public returns (bool success) {
171         allowance[msg.sender][spender] = value;
172         Approval(msg.sender, value, spender);
173         return true;
174     }
175 
176     function _mint(address to, uint256 value) internal {
177         balanceOf[to] = balanceOf[to].add(value);
178         totalSupply = totalSupply.add(value);
179 
180         Transfer(0x0, to, value);
181     }
182 }
183 
184 contract zombieToken is Ownable, ERC20Token {
185 
186     address public invadeAddress;
187     address public creatorAddress;
188     uint public preMining = 1000000 * 10 ** 18; //for test purpose
189 
190     function zombieToken() public {
191         balanceOf[msg.sender] = preMining;
192         totalSupply = preMining;
193     }
194 
195     function setInvadeAddr(address addr)public onlyOwner {
196         invadeAddress = addr;
197     }
198     
199     function setcreatorAddr(address addr)public onlyOwner {
200         creatorAddress = addr;
201     }
202     
203     function mint(address to, uint256 value) public returns (bool success) {
204         require(msg.sender==invadeAddress);
205         _mint(to, value);
206         return true;
207     }
208 
209     function buyCard(address from, uint256 value) public returns (bool success) {
210         require(msg.sender==creatorAddress);
211         _transfer(from, creatorAddress, value);
212         return true;
213     }
214 }