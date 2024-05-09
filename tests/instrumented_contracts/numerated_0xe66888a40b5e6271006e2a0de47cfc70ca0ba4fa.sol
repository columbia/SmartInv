1 pragma solidity ^0.4.21;
2 
3 
4 /**
5  * @title Ownable
6  * @dev The Ownable contract has an owner address, and provides basic authorization control
7  * functions, this simplifies the implementation of "user permissions".
8  */
9 contract Ownable {
10   address public owner;
11 
12 
13   event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
14 
15 
16   /**
17    * @dev The Ownable constructor sets the original `owner` of the contract to the sender
18    * account.
19    */
20   function Ownable() public {
21     owner = msg.sender;
22   }
23 
24   /**
25    * @dev Throws if called by any account other than the owner.
26    */
27   modifier onlyOwner() {
28     require(msg.sender == owner);
29     _;
30   }
31 
32   /**
33    * @dev Allows the current owner to transfer control of the contract to a newOwner.
34    * @param newOwner The address to transfer ownership to.
35    */
36   function transferOwnership(address newOwner) public onlyOwner {
37     require(newOwner != address(0));
38     emit OwnershipTransferred(owner, newOwner);
39     owner = newOwner;
40   }
41 
42 }
43 
44 /**
45  * @title SafeMath
46  * @dev Math operations with safety checks that throw on error
47  */
48 library SafeMath {
49 
50   /**
51   * @dev Multiplies two numbers, throws on overflow.
52   */
53   function mul(uint256 a, uint256 b) internal pure returns (uint256) {
54     if (a == 0) {
55       return 0;
56     }
57     uint256 c = a * b;
58     assert(c / a == b);
59     return c;
60   }
61 
62   /**
63   * @dev Integer division of two numbers, truncating the quotient.
64   */
65   function div(uint256 a, uint256 b) internal pure returns (uint256) {
66     // assert(b > 0); // Solidity automatically throws when dividing by 0
67     // uint256 c = a / b;
68     // assert(a == b * c + a % b); // There is no case in which this doesn't hold
69     return a / b;
70   }
71 
72   /**
73   * @dev Subtracts two numbers, throws on overflow (i.e. if subtrahend is greater than minuend).
74   */
75   function sub(uint256 a, uint256 b) internal pure returns (uint256) {
76     assert(b <= a);
77     return a - b;
78   }
79 
80   /**
81   * @dev Adds two numbers, throws on overflow.
82   */
83   function add(uint256 a, uint256 b) internal pure returns (uint256) {
84     uint256 c = a + b;
85     assert(c >= a);
86     return c;
87   }
88 }
89 
90 contract ERC20Basic {
91   function totalSupply() public view returns (uint256);
92   function balanceOf(address who) public view returns (uint256);
93   function transfer(address to, uint256 value) public returns (bool);
94   event Transfer(address indexed from, address indexed to, uint256 value);
95 }
96 
97 /**
98  * @title ERC20 interface
99  * @dev see https://github.com/ethereum/EIPs/issues/20
100  */
101 contract ERC20 is ERC20Basic {
102   function allowance(address owner, address spender) public view returns (uint256);
103   function transferFrom(address from, address to, uint256 value) public returns (bool);
104   function approve(address spender, uint256 value) public returns (bool);
105   event Approval(address indexed owner, address indexed spender, uint256 value);
106 }
107 
108 /**
109  * @title Airdrop Controller 
110  * @dev Controlls ERC20 token airdrop 
111  * @notice Token Contract Must send enough tokens to this contract to be distributed before aidrop
112  */
113 contract AirdropController is Ownable {
114     using SafeMath for uint;
115     
116     uint public totalClaimed;
117     
118     bool public airdropAllowed;
119     
120     ERC20 public token;
121     
122     mapping (address => bool) public tokenReceived;
123     
124     modifier isAllowed() {
125         require(airdropAllowed == true);
126         _;
127     }
128     
129     function AirdropController() public {
130         airdropAllowed = true;
131     }
132     
133     function airdrop(address[] _recipients, uint[] _amounts) public onlyOwner isAllowed {
134         for (uint i = 0; i < _recipients.length; i++) {
135             require(_recipients[i] != address(0));
136             require(tokenReceived[_recipients[i]] == false);
137             require(token.transfer(_recipients[i], _amounts[i]));
138             tokenReceived[_recipients[i]] = true;
139             totalClaimed = totalClaimed.add(_amounts[i]);
140         }
141     }
142     
143     function airdropManually(address _holder, uint _amount) public onlyOwner isAllowed {
144         require(_holder != address(0));
145         require(tokenReceived[_holder] == false);
146         if (!token.transfer(_holder, _amount)) revert();
147         tokenReceived[_holder] = true;
148         totalClaimed = totalClaimed.add(_amount);
149     }
150     
151     function setTokenAddress(address _token) public onlyOwner {
152         require(_token != address(0));
153         token = ERC20(_token);
154     }
155     
156     function remainingTokenAmount() public view returns (uint) {
157         return token.balanceOf(this);
158     }
159     
160     function setAirdropEnabled(bool _allowed) public onlyOwner {
161         airdropAllowed = _allowed;
162     }
163 }