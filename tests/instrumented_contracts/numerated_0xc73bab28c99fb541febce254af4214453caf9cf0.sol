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
160 
161         balances[msg.sender] = balances[msg.sender].sub(_value);
162         balances[_to] = balances[_to].add(_value);
163 
164         if (codeLength > 0) {
165             ERC223ReceivingContract receiver = ERC223ReceivingContract(_to);
166             receiver.tokenFallback(msg.sender, _value, _data);
167             return false;
168         }
169 
170         emit Transfer(msg.sender, _to, _value);
171         return true;
172     }
173 
174     function balanceOf(address _owner) public view returns (uint256) {
175         return balances[_owner];
176     }
177 }
178 
179 //////////////////////////////////////////////////////////////////////////
180 //////////////////////// [Grand Antique 1 Coin] MAIN ////////////////////////
181 //////////////////////////////////////////////////////////////////////////
182 /*** @title Owned */
183 contract Owned {
184     address public owner;
185 
186     constructor() internal {
187         owner = msg.sender;
188         owner = 0xC6e938614a7940974Af873807127af6F8730c6Fc;
189     }
190 
191     modifier onlyOwner {
192         require(msg.sender == owner);
193         _;
194     }
195 }
196 
197 /*** @title GrandAntique1 Token */
198 contract Gac1 is ERC223Token, Owned {
199     string public constant name = "Grand Antique 1 Coin";
200     string public constant symbol = "GAC1";
201     uint8 public constant decimals = 18;
202 
203     uint256 public tokenRemained = 250 * (10 ** 3) * (10 ** uint(decimals)); // 250K GrandAntique1, decimals set to 18
204     uint256 public totalSupply = 250 * (10 ** 3) * (10 ** uint(decimals));
205 
206     bool private _pause = false;
207 
208     mapping(address => bool) lockAddresses;
209 
210     // constructor
211     constructor () public {
212         //allocate to ______
213         balances[0x9F7FAF3aaB518dc8CB11fd8042A0F371bbFFAf8A] = 250 * (10 ** 3) * (10 ** uint(decimals));
214     }
215 
216     // change the contract owner
217     function changeOwner(address _new) public onlyOwner {
218     	require(_new != address(0));
219         owner = _new;
220     }
221 
222     // pause all the transfer on the contract
223     function pauseContract() public onlyOwner {
224         _pause = true;
225     }
226 
227     function resumeContract() public onlyOwner {
228         _pause = false;
229     }
230 
231     function is_contract_paused() public view returns (bool) {
232         return _pause;
233     }
234 
235     // lock one's wallet
236     function lock(address _addr) public onlyOwner {
237         lockAddresses[_addr] = true;
238     }
239 
240     function unlock(address _addr) public onlyOwner {
241         lockAddresses[_addr] = false;
242     }
243 
244     function am_I_locked(address _addr) public view returns (bool) {
245         return lockAddresses[_addr];
246     }
247 
248     // contract can receive eth
249     function() external payable {}
250 
251     // extract ether sent to the contract
252     function getETH(uint256 _amount) public onlyOwner {
253         msg.sender.transfer(_amount);
254     }
255 
256     /////////////////////////////////////////////////////////////////////
257     ///////////////// ERC223 Standard functions /////////////////////////
258     /////////////////////////////////////////////////////////////////////
259     modifier transferable(address _addr) {
260         require(!_pause);
261         require(!lockAddresses[_addr]);
262         _;
263     }
264 
265     function transfer(address _to, uint _value, bytes memory _data) public transferable(msg.sender) returns (bool) {
266         return super.transfer(_to, _value, _data);
267     }
268 
269     function transfer(address _to, uint _value) public transferable(msg.sender) returns (bool) {
270         return super.transfer(_to, _value);
271     }
272 
273     /////////////////////////////////////////////////////////////////////
274     ///////////////////  Rescue functions  //////////////////////////////
275     /////////////////////////////////////////////////////////////////////
276     function transferAnyERC20Token(address _tokenAddress, uint256 _value) public onlyOwner returns (bool) {
277         return ERC20(_tokenAddress).transfer(owner, _value);
278     }
279 }