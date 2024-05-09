1 pragma solidity ^0.4.23;
2 
3 /**
4  * @title SafeMath
5  * @dev Math operations with safety checks that throw on error
6  */
7 library SafeMath {
8 
9   /**
10   * @dev Multiplies two numbers, throws on overflow.
11   */
12   function mul(uint256 a, uint256 b) internal pure returns (uint256 c) {
13     if (a == 0) {
14       return 0;
15     }
16     c = a * b;
17     assert(c / a == b);
18     return c;
19   }
20 
21   /**
22   * @dev Integer division of two numbers, truncating the quotient.
23   */
24   function div(uint256 a, uint256 b) internal pure returns (uint256) {
25     // assert(b > 0); // Solidity automatically throws when dividing by 0
26     // uint256 c = a / b;
27     // assert(a == b * c + a % b); // There is no case in which this doesn't hold
28     return a / b;
29   }
30 
31   /**
32   * @dev Subtracts two numbers, throws on overflow (i.e. if subtrahend is greater than minuend).
33   */
34   function sub(uint256 a, uint256 b) internal pure returns (uint256) {
35     assert(b <= a);
36     return a - b;
37   }
38 
39   /**
40   * @dev Adds two numbers, throws on overflow.
41   */
42   function add(uint256 a, uint256 b) internal pure returns (uint256 c) {
43     c = a + b;
44     assert(c >= a);
45     return c;
46   }
47 }
48 
49 /**
50  * @title Ownable
51  * @dev The Ownable contract has an owner address, and provides basic authorization control
52  * functions, this simplifies the implementation of "user permissions".
53  */
54 contract Ownable {
55   address public owner;
56 
57 
58   event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
59 
60 
61   /**
62    * @dev The Ownable constructor sets the original `owner` of the contract to the sender
63    * account.
64    */
65   function Ownable() public {
66     owner = msg.sender;
67   }
68 
69   /**
70    * @dev Throws if called by any account other than the owner.
71    */
72   modifier onlyOwner() {
73     require(msg.sender == owner);
74     _;
75   }
76 
77   /**
78    * @dev Allows the current owner to transfer control of the contract to a newOwner.
79    * @param newOwner The address to transfer ownership to.
80    */
81   function transferOwnership(address newOwner) public onlyOwner {
82     require(newOwner != address(0));
83     emit OwnershipTransferred(owner, newOwner);
84     owner = newOwner;
85   }
86 
87 }
88 
89 contract B0xAccount is Ownable {
90     using SafeMath for uint;
91 
92 	mapping (address => Withdraw[]) public withdrawals;
93 
94     address public receiver1;
95     address public receiver2;
96 
97     uint public numerator = 3;
98     uint public denominator = 7;
99 
100     struct Withdraw {
101         address receiver;
102         uint amount;
103         uint blockNumber;
104         uint blockTimestamp;
105     }
106 
107     function() 
108         public
109         payable
110     {
111         require(msg.value > 0);
112         uint toSend = msg.value.mul(numerator).div(denominator);
113         require(receiver1.send(toSend));
114         require(receiver2.send(toSend));
115     }
116 
117     constructor(
118         address _receiver1,
119         address _receiver2)
120         public
121     {
122         receiver1 = _receiver1;
123         receiver2 = _receiver2;
124     }
125 
126     function deposit()
127         public
128         payable
129         returns(bool)
130     {}
131 
132     function withdraw(
133         uint _value)
134         public
135         returns(bool)
136     {
137         return (withdrawTo(
138             _value,
139             msg.sender
140         ));
141     }
142 
143     function withdrawTo(
144         uint _value,
145         address _to)
146         public
147         returns(bool)
148     {
149         require(
150             msg.sender == receiver1 
151             || msg.sender == receiver2);
152 
153         uint amount = _value;
154         if (amount > address(this).balance) {
155             amount = address(this).balance;
156         }
157 
158         withdrawals[msg.sender].push(Withdraw({
159             receiver: _to,
160             amount: amount,
161             blockNumber: block.number,
162             blockTimestamp: block.timestamp
163         }));
164 
165         return (_to.send(amount));
166     }
167 
168     function transferToken(
169         address _tokenAddress,
170         address _to,
171         uint _value)
172         public
173         onlyOwner
174         returns (bool)
175     {
176         // bytes4(keccak256("transfer(address,uint256)")) == 0xa9059cbb
177         require(_tokenAddress.call(0xa9059cbb, _to, _value));
178 
179         return true;
180     }    
181 
182     function setReceiver1(
183         address _receiver
184     )
185         public
186         onlyOwner
187     {
188         require(_receiver != address(0) && _receiver != receiver1);
189         receiver1 = _receiver;
190     }
191 
192     function setReceiver2(
193         address _receiver
194     )
195         public
196         onlyOwner
197     {
198         require(_receiver != address(0) && _receiver != receiver2);
199         receiver2 = _receiver;
200     }
201 
202     function setNumeratorDenominator(
203         uint _numerator,
204         uint _denominator
205     )
206         public
207         onlyOwner
208     {
209         require(_numerator > 0 && (_numerator*2) <= _denominator);
210         numerator = _numerator;
211         denominator = _denominator;
212     }
213 
214     function getBalance()
215         public
216         view
217         returns (uint)
218     {
219         return address(this).balance;
220     }
221 }