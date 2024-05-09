1 pragma solidity ^0.4.22;
2 /**
3  * @title SafeMath
4  * @dev Math operations with safety checks that revert on error
5  */
6 library SafeMath {
7 
8   /**
9   * @dev Multiplies two numbers, reverts on overflow.
10   */
11   function mul(uint256 a, uint256 b) internal pure returns (uint256) {
12     // Gas optimization: this is cheaper than requiring 'a' not being zero, but the
13     // benefit is lost if 'b' is also tested.
14     // See: https://github.com/OpenZeppelin/openzeppelin-solidity/pull/522
15     if (a == 0) {
16       return 0;
17     }
18 
19     uint256 c = a * b;
20     require(c / a == b);
21 
22     return c;
23   }
24 
25   /**
26   * @dev Integer division of two numbers truncating the quotient, reverts on division by zero.
27   */
28   function div(uint256 a, uint256 b) internal pure returns (uint256) {
29     require(b > 0); // Solidity only automatically asserts when dividing by 0
30     uint256 c = a / b;
31     // assert(a == b * c + a % b); // There is no case in which this doesn't hold
32 
33     return c;
34   }
35 
36   /**
37   * @dev Subtracts two numbers, reverts on overflow (i.e. if subtrahend is greater than minuend).
38   */
39   function sub(uint256 a, uint256 b) internal pure returns (uint256) {
40     require(b <= a);
41     uint256 c = a - b;
42 
43     return c;
44   }
45 
46   /**
47   * @dev Adds two numbers, reverts on overflow.
48   */
49   function add(uint256 a, uint256 b) internal pure returns (uint256) {
50     uint256 c = a + b;
51     require(c >= a);
52 
53     return c;
54   }
55 
56   /**
57   * @dev Divides two numbers and returns the remainder (unsigned integer modulo),
58   * reverts when dividing by zero.
59   */
60   function mod(uint256 a, uint256 b) internal pure returns (uint256) {
61     require(b != 0);
62     return a % b;
63   }
64 }
65 // 名称检验
66 library NameFilter {
67 
68 function filter(string _input)
69     internal
70     pure
71     returns(string)
72     {
73         bytes memory _temp = bytes(_input);
74         uint256 _length = _temp.length;
75 
76         require (_length <= 256 && _length > 0, "string must be between 1 and 256 characters");
77         require(_temp[0] != 0x20 && _temp[_length-1] != 0x20, "string cannot start or end with space");
78         if (_temp[0] == 0x30)
79         {
80             require(_temp[1] != 0x78, "string cannot start with 0x");
81             require(_temp[1] != 0x58, "string cannot start with 0X");
82         }
83         return _input;
84     }
85 }
86 
87 
88 
89 contract SimpleAuction {
90     using NameFilter for string;
91     using SafeMath for *;
92     
93     
94     // 受益人
95     address private boss;
96 
97     // fees
98     uint public fees;
99 
100     address private top;
101 
102     address private loser;
103 
104     uint private topbid;
105 
106     uint private loserbid;
107 
108 
109     //可以取回的之前的出价
110     mapping(address => uint) pendingReturns;
111 
112     mapping(address => string) giverNames;
113 
114     mapping(address => string) giverMessages;
115 
116 
117 
118 
119 
120     constructor(
121         address _beneficiary
122     ) public {
123         boss = _beneficiary;
124     }
125 
126 
127     /// How much would you like to pay?
128     function bid() public payable {
129         // 如果出价不够0.0001ether
130         require(
131             msg.value > 0.0001 ether,
132             "?????"
133         );
134         // 如果出价不够高，返还你的钱
135         require(
136             msg.value > topbid,
137             "loser fuck off."
138         );
139         // 参数不是必要的。因为所有的信息已经包含在了交易中。
140         // 对于能接收以太币的函数，关键字 payable 是必须的。
141         pendingReturns[msg.sender] += (msg.value.div(10).mul(9));
142         fees+= msg.value.div(10);
143         
144         if(top != 0){
145             loser = top;
146             loserbid = topbid;
147         }
148         top = msg.sender;
149         topbid = msg.value;
150 
151         if(bytes(giverNames[msg.sender]).length== 0) {
152             giverNames[msg.sender] = "#Anonymous";
153             giverMessages[msg.sender] = "#Nothing";
154         }
155     }
156 
157     function setInfo(string _name,string _message) public {
158         
159         giverNames[msg.sender] = _name.filter();
160         giverMessages[msg.sender] = _message.filter();
161     }
162 
163     function getMyInfo() public view returns (string,string){
164         return getInfo(msg.sender);
165     }
166     
167     function getFess() public view returns (uint){
168         return fees;
169     }
170 
171 
172 
173     function getWLInfo() public view returns (string,string,uint,string,string,uint){
174 return (giverNames[top],giverMessages[top],topbid,giverNames[loser],giverMessages[loser],loserbid);
175     }
176 
177 
178 
179     function getInfo(address _add) public view returns (string,string){
180         return (giverNames[_add],giverMessages[_add]);
181     }
182 
183 
184     /// 取回
185     function withdraw() public returns (bool) {
186         require(pendingReturns[msg.sender]>0,"Nothing left for you");
187         uint amount = pendingReturns[msg.sender];
188         pendingReturns[msg.sender] = 0;
189         msg.sender.transfer(amount);
190         if(msg.sender==top){
191             loser = top;
192             loserbid =topbid;
193             top = 0;
194             topbid = 0;
195         }    
196         return true;
197     }
198 
199     /// shouqian
200     function woyaoqianqian(uint fee) public {
201                 require(
202             fee < fees,
203             "loser fuck off."
204         );
205         fees = fees.sub(fee);
206         // 3. 交互
207         boss.transfer(fee);
208     }
209 }