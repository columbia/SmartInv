1 pragma solidity ^0.4.21;
2 
3 library SafeMath {
4 
5   /**
6   * @dev Multiplies two numbers, throws on overflow.
7   */
8   function mul(uint256 a, uint256 b) internal pure returns (uint256) {
9     if (a == 0) {
10       return 0;
11     }
12     uint256 c = a * b;
13     assert(c / a == b);
14     return c;
15   }
16 
17   /**
18   * @dev Integer division of two numbers, truncating the quotient.
19   */
20   function div(uint256 a, uint256 b) internal pure returns (uint256) {
21     // assert(b > 0); // Solidity automatically throws when dividing by 0
22     uint256 c = a / b;
23     // assert(a == b * c + a % b); // There is no case in which this doesn't hold
24     return c;
25   }
26 
27   /**
28   * @dev Subtracts two numbers, throws on overflow (i.e. if subtrahend is greater than minuend).
29   */
30   function sub(uint256 a, uint256 b) internal pure returns (uint256) {
31     assert(b <= a);
32     return a - b;
33   }
34 
35   /**
36   * @dev Adds two numbers, throws on overflow.
37   */
38   function add(uint256 a, uint256 b) internal pure returns (uint256) {
39     uint256 c = a + b;
40     assert(c >= a);
41     return c;
42   }
43 }
44 
45 contract Ownable {
46   address public owner;
47 
48 
49   event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
50 
51 
52   /**
53    * @dev The Ownable constructor sets the original `owner` of the contract to the sender
54    * account.
55    */
56   constructor() public {
57       owner = msg.sender;
58   }
59 
60   /**
61    * @dev Throws if called by any account other than the owner.
62    */
63   modifier onlyOwner() {
64     require(msg.sender == owner);
65     _;
66   }
67 
68   /**
69    * @dev Allows the current owner to transfer control of the contract to a newOwner.
70    * @param newOwner The address to transfer ownership to.
71    */
72   function transferOwnership(address newOwner) public onlyOwner {
73     require(newOwner != address(0));
74     emit OwnershipTransferred(owner, newOwner);
75     owner = newOwner;
76   }
77 
78 }
79 
80 contract Claimable is Ownable {
81   address public pendingOwner;
82 
83   /**
84    * @dev Modifier throws if called by any account other than the pendingOwner.
85    */
86   modifier onlyPendingOwner() {
87     require(msg.sender == pendingOwner);
88     _;
89   }
90 
91   /**
92    * @dev Allows the current owner to set the pendingOwner address.
93    * @param newOwner The address to transfer ownership to.
94    */
95   function transferOwnership(address newOwner) onlyOwner public {
96     pendingOwner = newOwner;
97   }
98 
99   /**
100    * @dev Allows the pendingOwner address to finalize the transfer.
101    */
102   function claimOwnership() onlyPendingOwner public {
103     emit OwnershipTransferred(owner, pendingOwner);
104     owner = pendingOwner;
105     pendingOwner = address(0);
106   }
107 }
108 
109 contract FlyDropToken is Claimable {
110     using SafeMath for uint256;
111 
112     ERC20 public erc20tk = ERC20(0xFb5a551374B656C6e39787B1D3A03fEAb7f3a98E);
113     bytes[] internal approveRecords;
114 
115     event ReceiveApproval(address _from, uint256 _value, address _token, bytes _extraData);
116 
117     /**
118      * @dev receive approval from an ERC20 token contract, take a record
119      *
120      * @param _from address The address which you want to send tokens from
121      * @param _value uint256 the amounts of tokens to be sent
122      * @param _token address the ERC20 token address
123      * @param _extraData bytes the extra data for the record
124      */
125     function receiveApproval(address _from, uint256 _value, address _token, bytes _extraData) public {
126         // erc20tk = ERC20(_token);
127         require(erc20tk.transferFrom(_from, this, _value)); // transfer tokens to this contract
128         approveRecords.push(_extraData);
129         emit ReceiveApproval(_from, _value, _token, _extraData);
130     }
131 
132     /**
133      * @dev Send tokens to other multi addresses in one function
134      *
135      * @param _destAddrs address The addresses which you want to send tokens to
136      * @param _values uint256 the amounts of tokens to be sent
137      */
138     function multiSend(address[] _destAddrs, uint256[] _values) onlyOwner public returns (uint256) {
139         require(_destAddrs.length == _values.length);
140 
141         uint256 i = 0;
142         for (; i < _destAddrs.length; i = i.add(1)) {
143             if (!erc20tk.transfer(_destAddrs[i], _values[i])) {
144                 break;
145             }
146         }
147 
148         return (i);
149     }
150 
151     function changERC20(address _token) onlyOwner public {
152         erc20tk = ERC20(_token);
153     }
154 
155     /**
156      * @dev Send tokens to other multi addresses in one function
157      *
158      * @param _from address The address which you want to send tokens from
159      * @param _destAddrs address The addresses which you want to send tokens to
160      * @param _values uint256 the amounts of tokens to be sent
161      */
162     function multiSendFrom(address _from, address[] _destAddrs, uint256[] _values) onlyOwner public returns (uint256) {
163         require(_destAddrs.length == _values.length);
164 
165         uint256 i = 0;
166         for (; i < _destAddrs.length; i = i.add(1)) {
167             if (!erc20tk.transferFrom(_from, _destAddrs[i], _values[i])) {
168                 break;
169             }
170         }
171 
172         return (i);
173     }
174 
175     /**
176      * @dev get records about approval
177      *
178      * @param _ind uint the index of record
179      */
180     function getApproveRecord(uint _ind) onlyOwner public view returns (bytes) {
181         require(_ind < approveRecords.length);
182 
183         return approveRecords[_ind];
184     }
185 }
186 
187 contract ERC20Basic {
188   function totalSupply() public view returns (uint256);
189   function balanceOf(address who) public view returns (uint256);
190   function transfer(address to, uint256 value) public returns (bool);
191   event Transfer(address indexed from, address indexed to, uint256 value);
192 }
193 
194 contract ERC20 is ERC20Basic {
195   function allowance(address owner, address spender) public view returns (uint256);
196   function transferFrom(address from, address to, uint256 value) public returns (bool);
197   function approve(address spender, uint256 value) public returns (bool);
198   event Approval(address indexed owner, address indexed spender, uint256 value);
199 }