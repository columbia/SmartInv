1 pragma solidity >=0.4.23 <0.6.0;
2 
3 /**
4  * @title SafeMath
5  * @dev Unsigned math operations with safety checks that revert on error
6  */
7 library SafeMath {
8     /**
9      * @dev Multiplies two unsigned integers, reverts on overflow.
10      */
11     function mul(uint256 a, uint256 b) internal pure returns (uint256) {
12         // Gas optimization: this is cheaper than requiring 'a' not being zero, but the
13         // benefit is lost if 'b' is also tested.
14         // See: https://github.com/OpenZeppelin/openzeppelin-solidity/pull/522
15         if (a == 0) {
16             return 0;
17         }
18 
19         uint256 c = a * b;
20         require(c / a == b);
21 
22         return c;
23     }
24 
25     /**
26      * @dev Integer division of two unsigned integers truncating the quotient, reverts on division by zero.
27      */
28     function div(uint256 a, uint256 b) internal pure returns (uint256) {
29         // Solidity only automatically asserts when dividing by 0
30         require(b > 0);
31         uint256 c = a / b;
32         // assert(a == b * c + a % b); // There is no case in which this doesn't hold
33 
34         return c;
35     }
36 
37     /**
38      * @dev Subtracts two unsigned integers, reverts on overflow (i.e. if subtrahend is greater than minuend).
39      */
40     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
41         require(b <= a);
42         uint256 c = a - b;
43 
44         return c;
45     }
46 
47     /**
48      * @dev Adds two unsigned integers, reverts on overflow.
49      */
50     function add(uint256 a, uint256 b) internal pure returns (uint256) {
51         uint256 c = a + b;
52         require(c >= a);
53 
54         return c;
55     }
56 
57     /**
58      * @dev Divides two unsigned integers and returns the remainder (unsigned integer modulo),
59      * reverts when dividing by zero.
60      */
61     function mod(uint256 a, uint256 b) internal pure returns (uint256) {
62         require(b != 0);
63         return a % b;
64     }
65 
66     /**
67      * @dev Returns the largest of two numbers.
68      */
69     function max(uint256 a, uint256 b) internal pure returns (uint256) {
70         return a >= b ? a : b;
71     }
72 
73     /**
74      * @dev Returns the smallest of two numbers.
75      */
76     function min(uint256 a, uint256 b) internal pure returns (uint256) {
77         return a < b ? a : b;
78     }
79 
80     /**
81      * @dev Calculates the average of two numbers. Since these are integers,
82      * averages of an even and odd number cannot be represented, and will be
83      * rounded down.
84      */
85     function average(uint256 a, uint256 b) internal pure returns (uint256) {
86         // (a + b) / 2 can overflow, so we distribute
87         return (a / 2) + (b / 2) + ((a % 2 + b % 2) / 2);
88     }
89 }
90 
91 /*** @title ERC20 interface */
92 contract ERC20 {
93     function totalSupply() public view returns (uint256);
94     function balanceOf(address _owner) public view returns (uint256);
95     function transfer(address _to, uint256 _value) public returns (bool);
96     function transferFrom(address _from, address _to, uint256 _value) public returns (bool);
97     function approve(address _spender, uint256 _value) public returns (bool);
98     function allowance(address _owner, address _spender) public view returns (uint256);
99     event Transfer(address indexed _from, address indexed _to, uint256 _value);
100     event Approval(address indexed _owner, address indexed _spender, uint256 _value);
101 }
102 
103 /*** @title ERC223 interface */
104 contract ERC223ReceivingContract {
105     function tokenFallback(address _from, uint _value, bytes memory _data) public;
106 }
107 
108 contract ERC223 {
109     function balanceOf(address who) public view returns (uint);
110     function transfer(address to, uint value) public returns (bool);
111     function transfer(address to, uint value, bytes memory data) public returns (bool);
112     event Transfer(address indexed from, address indexed to, uint value); //ERC 20 style
113     //event Transfer(address indexed from, address indexed to, uint value, bytes data);
114 }
115 
116 /*** @title ERC223 token */
117 contract ERC223Token is ERC223 {
118     using SafeMath for uint;
119 
120     mapping(address => uint256) balances;
121 
122     function transfer(address _to, uint _value) public returns (bool) {
123         uint codeLength;
124         bytes memory empty;
125 
126         assembly {
127             // Retrieve the size of the code on target address, this needs assembly .
128             codeLength := extcodesize(_to)
129         }
130 
131         require(_value > 0);
132         require(balances[msg.sender] >= _value);
133         require(balances[_to] + _value > 0);
134         require(msg.sender != _to);
135         balances[msg.sender] = balances[msg.sender].sub(_value);
136         balances[_to] = balances[_to].add(_value);
137 
138         if (codeLength > 0) {
139             ERC223ReceivingContract receiver = ERC223ReceivingContract(_to);
140             receiver.tokenFallback(msg.sender, _value, empty);
141             return false;
142         }
143 
144         emit Transfer(msg.sender, _to, _value);
145         return true;
146     }
147 
148     function transfer(address _to, uint _value, bytes memory _data) public returns (bool) {
149         // Standard function transfer similar to ERC20 transfer with no _data .
150         // Added due to backwards compatibility reasons .
151         uint codeLength;
152         assembly {
153             // Retrieve the size of the code on target address, this needs assembly .
154             codeLength := extcodesize(_to)
155         }
156 
157         require(_value > 0);
158         require(balances[msg.sender] >= _value);
159         require(balances[_to] + _value > 0);
160         require(msg.sender != _to);
161 
162         balances[msg.sender] = balances[msg.sender].sub(_value);
163         balances[_to] = balances[_to].add(_value);
164 
165         if (codeLength > 0) {
166             ERC223ReceivingContract receiver = ERC223ReceivingContract(_to);
167             receiver.tokenFallback(msg.sender, _value, _data);
168             return false;
169         }
170 
171         emit Transfer(msg.sender, _to, _value);
172         return true;
173     }
174 
175     function balanceOf(address _owner) public view returns (uint256) {
176         return balances[_owner];
177     }
178 }
179 
180 //////////////////////////////////////////////////////////////////////////
181 //////////////////////// [Grand Coin] MAIN ////////////////////////
182 //////////////////////////////////////////////////////////////////////////
183 /*** @title Owned */
184 contract Owned {
185     address public owner;
186 
187     constructor() internal {
188         owner = msg.sender;
189         owner = 0x800A4B210B920020bE22668d28afd7ddef5c6243
190 ;
191     }
192 
193     modifier onlyOwner {
194         require(msg.sender == owner);
195         _;
196     }
197 }
198 
199 /*** @title Grand Token */
200 contract Grand is ERC223Token, Owned {
201     string public constant name = "Grand Coin";
202     string public constant symbol = "GRAND";
203     uint8 public constant decimals = 18;
204 
205     uint256 public tokenRemained = 2 * (10 ** 9) * (10 ** uint(decimals)); // 2 billion Grand, decimals set to 18
206     uint256 public totalSupply = 2 * (10 ** 9) * (10 ** uint(decimals));
207 
208     bool public pause = false;
209 
210     mapping(address => bool) lockAddresses;
211 
212     // constructor
213     constructor () public {
214         //allocate to ______
215         balances[0x96F7F180C6B53e9313Dc26589739FDC8200a699f] = totalSupply;
216     }
217 
218     // change the contract owner
219     function changeOwner(address _new) public onlyOwner {
220     	require(_new != address(0));
221         owner = _new;
222     }
223 
224     // pause all the g on the contract
225     function pauseContract() public onlyOwner {
226         pause = true;
227     }
228 
229     function resumeContract() public onlyOwner {
230         pause = false;
231     }
232 
233     function is_contract_paused() public view returns (bool) {
234         return pause;
235     }
236 
237     // lock one's wallet
238     function lock(address _addr) public onlyOwner {
239         lockAddresses[_addr] = true;
240     }
241 
242     function unlock(address _addr) public onlyOwner {
243         lockAddresses[_addr] = false;
244     }
245 
246     function am_I_locked(address _addr) public view returns (bool) {
247         return lockAddresses[_addr];
248     }
249 
250     // contract can receive eth
251     function() external payable {}
252 
253     // extract ether sent to the contract
254     function getETH(uint256 _amount) public onlyOwner {
255         msg.sender.transfer(_amount);
256     }
257 
258     /////////////////////////////////////////////////////////////////////
259     ///////////////// ERC223 Standard functions /////////////////////////
260     /////////////////////////////////////////////////////////////////////
261     modifier transferable(address _addr) {
262         require(!pause);
263         require(!lockAddresses[_addr]);
264         _;
265     }
266 
267     function transfer(address _to, uint _value, bytes memory _data) public transferable(msg.sender) returns (bool) {
268         return super.transfer(_to, _value, _data);
269     }
270 
271     function transfer(address _to, uint _value) public transferable(msg.sender) returns (bool) {
272         return super.transfer(_to, _value);
273     }
274 
275     /////////////////////////////////////////////////////////////////////
276     ///////////////////  Rescue functions  //////////////////////////////
277     /////////////////////////////////////////////////////////////////////
278     function transferAnyERC20Token(address _tokenAddress, uint256 _value) public onlyOwner returns (bool) {
279         return ERC20(_tokenAddress).transfer(owner, _value);
280     }
281 }