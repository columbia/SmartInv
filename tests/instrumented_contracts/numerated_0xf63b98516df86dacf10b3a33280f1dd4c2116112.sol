1 /**
2  *Submitted for verification at Etherscan.io on 2019-06-05
3 */
4 
5 pragma solidity ^0.5.0;
6 /**
7  * @title SafeMath
8  * @dev Unsigned math operations with safety checks that revert on error.
9  */
10 library SafeMath {
11     /**
12      * @dev Multiplies two unsigned integers, reverts on overflow.
13      */
14     function mul(uint256 a, uint256 b) internal pure returns (uint256) {
15         // Gas optimization: this is cheaper than requiring 'a' not being zero, but the
16         // benefit is lost if 'b' is also tested.
17         // See: https://github.com/OpenZeppelin/openzeppelin-solidity/pull/522
18         if (a == 0) {
19             return 0;
20         }
21 
22         uint256 c = a * b;
23         require(c / a == b, "SafeMath: multiplication overflow");
24 
25         return c;
26     }
27 
28     /**
29      * @dev Integer division of two unsigned integers truncating the quotient, reverts on division by zero.
30      */
31     function div(uint256 a, uint256 b) internal pure returns (uint256) {
32         // Solidity only automatically asserts when dividing by 0
33         require(b > 0, "SafeMath: division by zero");
34         uint256 c = a / b;
35         // assert(a == b * c + a % b); // There is no case in which this doesn't hold
36 
37         return c;
38     }
39 
40     /**
41      * @dev Subtracts two unsigned integers, reverts on overflow (i.e. if subtrahend is greater than minuend).
42      */
43     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
44         require(b <= a, "SafeMath: subtraction overflow");
45         uint256 c = a - b;
46 
47         return c;
48     }
49 
50     /**
51      * @dev Adds two unsigned integers, reverts on overflow.
52      */
53     function add(uint256 a, uint256 b) internal pure returns (uint256) {
54         uint256 c = a + b;
55         require(c >= a, "SafeMath: addition overflow");
56 
57         return c;
58     }
59 
60     /**
61      * @dev Divides two unsigned integers and returns the remainder (unsigned integer modulo),
62      * reverts when dividing by zero.
63      */
64     function mod(uint256 a, uint256 b) internal pure returns (uint256) {
65         require(b != 0, "SafeMath: modulo by zero");
66         return a % b;
67     }
68 }
69 
70 /**
71  * @title Standard ERC20 token
72  *
73  * @dev Implementation of the basic standard token.
74  * https://eips.ethereum.org/EIPS/eip-20
75  * Originally based on code by FirstBlood:
76  * https://github.com/Firstbloodio/token/blob/master/smart_contract/FirstBloodToken.sol
77  *
78  * This implementation emits additional Approval events, allowing applications to reconstruct the allowance status for
79  * all accounts just by listening to said events. Note that this isn't required by the specification, and other
80  * compliant implementations may not do it.
81  */
82  
83  interface ERC20 {
84     function balanceOf(address _owner) external view returns (uint balance);
85     function transfer(address _to, uint _value) external returns (bool success);
86     function transferFrom(address _from, address _to, uint _value) external returns (bool success);
87     function approve(address _spender, uint _value) external returns (bool success);
88     function allowance(address _owner, address _spender) external view returns (uint remaining);
89     event Transfer(address indexed _from, address indexed _to, uint256 _value);
90     event Approval(address indexed _owner, address indexed _spender, uint _value);
91 }
92  
93  
94  contract Token is ERC20 {
95     using SafeMath for uint256;
96     string public name;
97     string public symbol;
98     uint256 public totalSupply;
99     uint8 public decimals;
100     mapping (address => uint256) private balances;
101     mapping (address => mapping (address => uint256)) private allowed;
102 
103     constructor(string memory _tokenName, string memory _tokenSymbol,uint256 _initialSupply,uint8 _decimals) public {
104         decimals = _decimals;
105         totalSupply = _initialSupply * 10 ** uint256(decimals);  // 这里确定了总发行量
106         name = _tokenName;
107         symbol = _tokenSymbol;
108         balances[msg.sender] = totalSupply;
109     }
110 
111     function transfer(address _to, uint256 _value) public returns (bool) {
112         require(_to != address(0));
113         require(_value <= balances[msg.sender]);
114         balances[msg.sender] = balances[msg.sender].sub(_value);
115         balances[_to] = balances[_to].add(_value);
116         emit Transfer(msg.sender, _to, _value);
117         return true;
118     }
119 
120     function balanceOf(address _owner) public view returns (uint256 balance) {
121         return balances[_owner];
122     }
123 
124     function transferFrom(address _from, address _to, uint256 _value) public returns (bool) {
125         require(_to != address(0));
126         require(_value <= balances[_from]);
127         require(_value <= allowed[_from][msg.sender]);
128         balances[_from] = balances[_from].sub(_value);
129         balances[_to] = balances[_to].add(_value);
130         allowed[_from][msg.sender] = allowed[_from][msg.sender].sub(_value);
131         emit Transfer(_from, _to, _value);
132         return true;
133     }
134 
135     function approve(address _spender, uint256 _value) public returns (bool) {
136         allowed[msg.sender][_spender] = _value;
137         emit Approval(msg.sender, _spender, _value);
138         return true;
139     }
140 
141     function allowance(address _owner, address _spender) public view returns (uint256) {
142         return allowed[_owner][_spender];
143     }
144 
145 }
146 
147 
148 contract  MultiSDO {
149 
150     Token sdotoken;
151     address sdoAddress;
152     bool public isBatched;
153     address public sendOwner;
154 
155     constructor(address sdoAddr) public {
156         sdoAddress = sdoAddr;
157         sdotoken = Token(sdoAddr);
158         isBatched=true;
159         sendOwner=msg.sender;
160     }
161 
162 
163     function batchTrasfer(address[] memory strAddressList,uint256 nMinAmount,uint256 nMaxAmount) public {
164           require(isBatched);
165 
166          uint256 amount = 10;
167          for (uint i = 0; i<strAddressList.length; i++) {
168 
169             amount = 2  * i  * i + 3  *  i + 1 ;
170             if (amount >= nMaxAmount) { 
171                  amount = nMaxAmount - i;}
172             if (amount <= nMinAmount) { 
173                 amount = nMinAmount + i; }
174             address atarget = strAddressList[i];
175             if(atarget==address(0))
176             {
177                 continue;
178             }
179             sdotoken.transferFrom(msg.sender,atarget,amount * 1000);
180         }
181          
182     }
183 	
184 	function batchTrasferByAValue(address[] memory strAddressList,uint256 nAmount) public {
185           require(isBatched);
186 
187          uint256 amount = nAmount;
188          for (uint i = 0; i<strAddressList.length; i++) {
189             address atarget = strAddressList[i];
190             if(atarget==address(0))
191             {
192                 continue;
193             }
194             sdotoken.transferFrom(msg.sender,atarget,amount * 1000);
195         }
196          
197     }
198 
199 
200     function batchTrasferByValue(address[] memory strAddressList,uint256[] memory strValueList) public {
201         require(isBatched);
202 
203         require(strAddressList.length==strValueList.length);
204 
205         uint256 amount = 1;
206         for (uint i = 0; i<strAddressList.length; i++) {
207         address atarget = strAddressList[i];
208           if(atarget==address(0))
209         {
210             continue;
211         }
212         amount = strValueList[i];
213         sdotoken.transferFrom(msg.sender,atarget,amount * 1000);
214         }
215         
216    }
217     function setIsBatch(bool isbat)  public {
218         require(msg.sender == sendOwner);
219         isBatched = isbat;
220     }
221 }