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
101         uint amount;
102         uint blockNumber;
103         uint blockTimestamp;
104     }
105 
106     function() 
107         public
108         payable
109     {
110         require(msg.value > 0);
111         uint toSend = address(this).balance.mul(numerator).div(denominator);
112         require(receiver1.send(toSend));
113         require(receiver2.send(toSend));
114     }
115 
116     constructor(
117         address _receiver1,
118         address _receiver2)
119         public
120     {
121         receiver1 = _receiver1;
122         receiver2 = _receiver2;
123     }
124 
125     function deposit()
126         public
127         payable
128         returns(bool)
129     {}
130 
131     function withdraw(
132         uint _value)
133         public
134         returns(bool)
135     {
136         require(
137             msg.sender == receiver1 
138             || msg.sender == receiver2);
139 
140         uint amount = _value;
141         if (amount > address(this).balance) {
142             amount = address(this).balance;
143         }
144 
145         withdrawals[msg.sender].push(Withdraw({
146             amount: amount,
147             blockNumber: block.number,
148             blockTimestamp: block.timestamp
149         }));
150 
151         return (msg.sender.send(amount));
152     }
153 
154     function setReceiver1(
155         address _receiver
156     )
157         public
158         onlyOwner
159     {
160         require(_receiver != address(0) && _receiver != receiver1);
161         receiver1 = _receiver;
162     }
163 
164     function setReceiver2(
165         address _receiver
166     )
167         public
168         onlyOwner
169     {
170         require(_receiver != address(0) && _receiver != receiver2);
171         receiver2 = _receiver;
172     }
173 
174     function setNumeratorDenominator(
175         uint _numerator,
176         uint _denominator
177     )
178         public
179         onlyOwner
180     {
181         require(_numerator > 0 && (_numerator*2) <= _denominator);
182         numerator = _numerator;
183         denominator = _denominator;
184     }
185 
186     function getBalance()
187         public
188         view
189         returns (uint)
190     {
191         return address(this).balance;
192     }
193 }