1 pragma solidity ^0.5.1;
2 
3 contract Ownable {
4     address private _owner;
5 
6     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
7 
8     /**
9      * @dev The Ownable constructor sets the original `owner` of the contract to the sender
10      * account.
11      */
12     constructor () internal {
13         _owner = msg.sender;
14         emit OwnershipTransferred(address(0), _owner);
15     }
16 
17     /**
18      * @return the address of the owner.
19      */
20     function owner() public view returns (address) {
21         return _owner;
22     }
23 
24     /**
25      * @dev Throws if called by any account other than the owner.
26      */
27     modifier onlyOwner() {
28         require(isOwner());
29         _;
30     }
31 
32     /**
33      * @return true if `msg.sender` is the owner of the contract.
34      */
35     function isOwner() public view returns (bool) {
36         return msg.sender == _owner;
37     }
38 
39     /**
40      * @dev Allows the current owner to relinquish control of the contract.
41      * @notice Renouncing to ownership will leave the contract without an owner.
42      * It will not be possible to call the functions with the `onlyOwner`
43      * modifier anymore.
44      */
45     function renounceOwnership() public onlyOwner {
46         emit OwnershipTransferred(_owner, address(0));
47         _owner = address(0);
48     }
49 
50     /**
51      * @dev Allows the current owner to transfer control of the contract to a newOwner.
52      * @param newOwner The address to transfer ownership to.
53      */
54     function transferOwnership(address newOwner) public onlyOwner {
55         _transferOwnership(newOwner);
56     }
57 
58     /**
59      * @dev Transfers control of the contract to a newOwner.
60      * @param newOwner The address to transfer ownership to.
61      */
62     function _transferOwnership(address newOwner) internal {
63         require(newOwner != address(0));
64         emit OwnershipTransferred(_owner, newOwner);
65         _owner = newOwner;
66     }
67 }
68 
69 library SafeMath {
70     /**
71     * @dev Multiplies two unsigned integers, reverts on overflow.
72     */
73     function mul(uint256 a, uint256 b) internal pure returns (uint256) {
74         // Gas optimization: this is cheaper than requiring 'a' not being zero, but the
75         // benefit is lost if 'b' is also tested.
76         // See: https://github.com/OpenZeppelin/openzeppelin-solidity/pull/522
77         if (a == 0) {
78             return 0;
79         }
80 
81         uint256 c = a * b;
82         require(c / a == b);
83 
84         return c;
85     }
86 
87     /**
88     * @dev Integer division of two unsigned integers truncating the quotient, reverts on division by zero.
89     */
90     function div(uint256 a, uint256 b) internal pure returns (uint256) {
91         // Solidity only automatically asserts when dividing by 0
92         require(b > 0);
93         uint256 c = a / b;
94         // assert(a == b * c + a % b); // There is no case in which this doesn't hold
95 
96         return c;
97     }
98 
99     /**
100     * @dev Subtracts two unsigned integers, reverts on overflow (i.e. if subtrahend is greater than minuend).
101     */
102     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
103         require(b <= a);
104         uint256 c = a - b;
105 
106         return c;
107     }
108 
109     /**
110     * @dev Adds two unsigned integers, reverts on overflow.
111     */
112     function add(uint256 a, uint256 b) internal pure returns (uint256) {
113         uint256 c = a + b;
114         require(c >= a);
115 
116         return c;
117     }
118 
119     /**
120     * @dev Divides two unsigned integers and returns the remainder (unsigned integer modulo),
121     * reverts when dividing by zero.
122     */
123     function mod(uint256 a, uint256 b) internal pure returns (uint256) {
124         require(b != 0);
125         return a % b;
126     }
127 }
128 
129 
130 contract ERC20Interface {
131     function transferFrom(address src, address dst, uint wad) public returns (bool);
132     function transfer(address dst, uint wad) public returns (bool);
133 }
134 
135 contract ChainBot2000 is Ownable {
136     
137     using SafeMath for uint256;
138     
139     ERC20Interface DAIContract;
140     mapping(bytes32 => uint) public deposits;
141     
142     event Deposit(address indexed _address, bytes32 indexed _steamid, uint indexed _amount);
143     event Purchase(address indexed _address, uint indexed _amount);
144     
145     constructor(address _address) public {
146         DAIContract = ERC20Interface(_address);
147     }
148     
149     function updateBalance(bytes32 _steamid, uint _amount) external {
150         assert(DAIContract.transferFrom(msg.sender, address(this), _amount));
151         deposits[_steamid] = deposits[_steamid].add( _amount);
152         emit Deposit(msg.sender, _steamid, _amount);
153 	}
154 	
155 	function purchase(address _address, uint _amount) external onlyOwner {
156 	    assert(DAIContract.transfer(_address, _amount));
157 	    emit Purchase(_address, _amount);
158 	}
159     
160 }