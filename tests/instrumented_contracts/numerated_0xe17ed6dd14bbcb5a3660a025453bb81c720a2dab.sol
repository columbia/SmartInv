1 pragma solidity ^0.4.18;
2 
3 
4 /**
5  * @title SafeMath
6  * @dev Math operations with safety checks that throw on error
7  */
8 library SafeMath {
9 
10   /**
11   * @dev Multiplies two numbers, throws on overflow.
12   */
13     function mul(uint256 a, uint256 b) internal pure returns (uint256) {
14         if (a == 0) {
15             return 0;
16         }
17         uint256 c = a * b;
18         assert(c / a == b);
19         return c;
20     }
21 
22     /**
23     * @dev Integer division of two numbers, truncating the quotient.
24     */
25     function div(uint256 a, uint256 b) internal pure returns (uint256) {
26         // assert(b > 0); // Solidity automatically throws when dividing by 0
27         uint256 c = a / b;
28         // assert(a == b * c + a % b); // There is no case in which this doesn't hold
29         return c;
30     }
31 
32     /**
33     * @dev Substracts two numbers, throws on overflow (i.e. if subtrahend is greater than minuend).
34     */
35     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
36         assert(b <= a);
37         return a - b;
38     }
39 
40     /**
41     * @dev Adds two numbers, throws on overflow.
42     */
43     function add(uint256 a, uint256 b) internal pure returns (uint256) {
44         uint256 c = a + b;
45         assert(c >= a);
46         return c;
47     }
48 }
49 
50 
51 /**
52  * @title Ownable
53  * @dev The Ownable contract has an owner address, and provides basic authorization control
54  * functions, this simplifies the implementation of "user permissions".
55  */
56 contract Ownable {
57     address public owner;
58 
59     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
60 
61     /**
62     * @dev The Ownable constructor sets the original `owner` of the contract to the sender
63     * account.
64     */
65     function Ownable() public {
66         owner = msg.sender;
67     }
68 
69     /**
70     * @dev Throws if called by any account other than the owner.
71     */
72     modifier onlyOwner() {
73         require(msg.sender == owner);
74         _;
75     }
76 
77     /**
78     * @dev Allows the current owner to transfer control of the contract to a newOwner.
79     * @param newOwner The address to transfer ownership to.
80     */
81     function transferOwnership(address newOwner) public onlyOwner {
82         require(newOwner != address(0));
83         OwnershipTransferred(owner, newOwner);
84         owner = newOwner;
85     }
86 
87 }
88 
89 
90 /**
91  * @title ERC20Basic
92  * @dev Simpler version of ERC20 interface
93  * @dev see https://github.com/ethereum/EIPs/issues/179
94  */
95 contract ERC20BasicInterface {
96     function totalSupply() public view returns (uint256);
97     function balanceOf(address who) public view returns (uint256);
98     function transfer(address to, uint256 value) public returns (bool);
99     event Transfer(address indexed from, address indexed to, uint256 value);
100 
101     uint8 public decimals;
102 }
103 
104 
105 /**
106  * @title AirDropContract
107  * Simply do the airdrop.
108  */
109 contract AirDrop is Ownable {
110     using SafeMath for uint256;
111 
112     // the amount that owner wants to send each time
113     uint public airDropAmount;
114 
115     // the mapping to judge whether each address has already been airDropped
116     mapping ( address => bool ) public invalidAirDrop;
117 
118     // flag to stop airdrop
119     bool public stop = false;
120 
121     ERC20BasicInterface public erc20;
122 
123     uint256 public startTime;
124     uint256 public endTime;
125 
126     // event
127     event LogAirDrop(address indexed receiver, uint amount);
128     event LogStop();
129     event LogStart();
130     event LogWithdrawal(address indexed receiver, uint amount);
131 
132     /**
133     * @dev Constructor to set _airDropAmount and _tokenAddresss.
134     * @param _airDropAmount The amount of token that is sent for doing airDrop.
135     * @param _tokenAddress The address of token.
136     */
137     function AirDrop(uint256 _startTime, uint256 _endTime, uint _airDropAmount, address _tokenAddress) public {
138         require(_startTime >= now &&
139             _endTime >= _startTime &&
140             _airDropAmount > 0 &&
141             _tokenAddress != address(0)
142         );
143         startTime = _startTime;
144         endTime = _endTime;
145         erc20 = ERC20BasicInterface(_tokenAddress);
146         uint tokenDecimals = erc20.decimals();
147         airDropAmount = _airDropAmount.mul(10 ** tokenDecimals);
148     }
149 
150     /**
151     * @dev Confirm that airDrop is available.
152     * @return A bool to confirm that airDrop is available.
153     */
154     function isValidAirDropForAll() public view returns (bool) {
155         bool validNotStop = !stop;
156         bool validAmount = erc20.balanceOf(this) >= airDropAmount;
157         bool validPeriod = now >= startTime && now <= endTime;
158         return validNotStop && validAmount && validPeriod;
159     }
160 
161     /**
162     * @dev Confirm that airDrop is available for msg.sender.
163     * @return A bool to confirm that airDrop is available for msg.sender.
164     */
165     function isValidAirDropForIndividual() public view returns (bool) {
166         bool validNotStop = !stop;
167         bool validAmount = erc20.balanceOf(this) >= airDropAmount;
168         bool validPeriod = now >= startTime && now <= endTime;
169         bool validAmountForIndividual = !invalidAirDrop[msg.sender];
170         return validNotStop && validAmount && validPeriod && validAmountForIndividual;
171     }
172 
173     /**
174     * @dev Do the airDrop to msg.sender
175     */
176     function receiveAirDrop() public {
177         require(isValidAirDropForIndividual());
178 
179         // set invalidAirDrop of msg.sender to true
180         invalidAirDrop[msg.sender] = true;
181 
182         // execute transferFrom
183         require(erc20.transfer(msg.sender, airDropAmount));
184 
185         LogAirDrop(msg.sender, airDropAmount);
186     }
187 
188     /**
189     * @dev Change the state of stop flag
190     */
191     function toggle() public onlyOwner {
192         stop = !stop;
193 
194         if (stop) {
195             LogStop();
196         } else {
197             LogStart();
198         }
199     }
200 
201     /**
202     * @dev Withdraw the amount of token that is remaining in this contract.
203     * @param _address The address of EOA that can receive token from this contract.
204     */
205     function withdraw(address _address) public onlyOwner {
206         require(stop || now > endTime);
207         require(_address != address(0));
208         uint tokenBalanceOfContract = erc20.balanceOf(this);
209         require(erc20.transfer(_address, tokenBalanceOfContract));
210         LogWithdrawal(_address, tokenBalanceOfContract);
211     }
212 }