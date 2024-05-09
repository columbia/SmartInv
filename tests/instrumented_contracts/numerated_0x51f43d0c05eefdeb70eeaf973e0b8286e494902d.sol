1 pragma solidity ^0.5.8;
2 
3 /**
4  * @title SafeMath
5  */
6 library SafeMath {
7 
8     /**
9     * @dev Multiplies two numbers, throws on overflow.
10     */
11     function mul(uint a, uint b) internal pure returns (uint c) {
12         c = a * b;
13         require(a == 0 || c / a == b);
14     }
15     /**
16     * @dev Integer division of two numbers, truncating the quotient.
17     */
18    function div(uint a, uint b) internal pure returns (uint c) {
19         require(b > 0);
20         c = a / b;
21     }
22     /**
23     * @dev Subtracts two numbers, throws on overflow (i.e. if subtrahend is greater than minuend).
24     */
25     function sub(uint a, uint b) internal pure returns (uint c) {
26         require(b <= a);
27         c = a - b;
28     }
29     /**
30     * @dev Adds two numbers, throws on overflow.
31     */
32     function add(uint a, uint b) internal pure returns (uint c) {
33         c = a + b;
34         require(c >= a);
35     }
36 }
37 
38 contract ERC20Standard {
39     function totalSupply() public view returns (uint256);
40     function balanceOf(address tokenOwner) public view returns (uint256 balance);
41     function allowance(address tokenOwner, address spender) public view returns (uint256 remaining);
42     function transfer(address to, uint256 tokens) public returns (bool success);
43     function approve(address spender, uint256 tokens) public returns (bool success);
44     function transferFrom(address from, address to, uint256 tokens) public returns (bool success);
45 }
46 
47 contract Owned {
48     address payable public owner;
49     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
50 
51     /**
52      * @dev The Ownable constructor sets the original `owner` of the contract to the sender
53      * account.
54      */
55     constructor() public {
56         owner = msg.sender;
57     }
58 
59     /**
60      * @dev Throws if called by any account other than the owner.
61      */
62     modifier onlyOwner() {
63         require(msg.sender == owner);
64         _;
65     }
66 
67     /**
68      * @dev Allows the current owner to transfer control of the contract to a newOwner.
69      * @param newOwner The address to transfer ownership to.
70      */
71     function transferOwnership(address payable newOwner) public onlyOwner {
72         require(newOwner != address(0));
73         emit OwnershipTransferred(owner, newOwner);
74         owner = newOwner;
75     }
76 
77 }
78 
79 contract Exsender is Owned {
80     using SafeMath for uint256;
81     
82     function distributeForeignTokenWithUnifiedAmount(ERC20Standard _tokenContract, address[] calldata _addresses, uint256 _amount) external {
83         for (uint256 i = 0; i < _addresses.length; i++) {
84             _tokenContract.transferFrom(msg.sender, _addresses[i], _amount);
85         }
86     }
87     
88     function distributeForeignTokenWithSplittedAmount(ERC20Standard _tokenContract, address[] calldata _addresses, uint256[] calldata _amounts) external {
89         require(_addresses.length == _amounts.length);
90         for (uint256 i = 0; i < _addresses.length; i++) {
91             _tokenContract.transferFrom(msg.sender, _addresses[i], _amounts[i]);
92         }
93     }
94     
95     function distributeEtherWithUnifiedAmount(address payable[] calldata _addresses) payable external {
96         uint256 amount = msg.value.div(_addresses.length);
97         for (uint256 i = 0; i < _addresses.length; i++) {
98             _addresses[i].transfer(amount);
99         }
100     }
101     
102     function distributeEtherWithSplittedAmount(address payable[] calldata _addresses, uint256[] calldata _amounts) payable external {
103         require(_addresses.length == _amounts.length);
104         require(msg.value >= sumArray(_amounts));
105         for (uint256 i = 0; i < _addresses.length; i++) {
106             _addresses[i].transfer(_amounts[i]);
107         }
108     }
109     
110     function liftTokensToSingleAddress(ERC20Standard[] calldata _tokenContract, address _receiver, uint256[] calldata _amounts) external {
111         for (uint256 i = 0; i < _tokenContract.length; i++) {
112             _tokenContract[i].transferFrom(msg.sender, _receiver, _amounts[i]);
113         }
114     }
115 
116     function liftTokensToMultipleAddresses(ERC20Standard[] calldata _tokenContract, address[] calldata _receiver, uint256[] calldata _amounts) external {
117         for (uint256 i = 0; i < _tokenContract.length; i++) {
118             _tokenContract[i].transferFrom(msg.sender, _receiver[i], _amounts[i]);
119         }
120     }
121     
122     function getForeignTokenBalance(ERC20Standard _tokenContract, address who) view public returns (uint256) {
123         return _tokenContract.balanceOf(who);
124     }
125         
126     function transferEther(address payable _receiver, uint256 _amount) public onlyOwner {
127         require(_amount <= address(this).balance);
128         emit TransferEther(address(this), _receiver, _amount);
129         _receiver.transfer(_amount);
130     }
131     
132     function withdrawFund() onlyOwner public {
133         uint256 balance = address(this).balance;
134         owner.transfer(balance);
135     }
136     
137     function withdrawForeignTokens(ERC20Standard _tokenContract) onlyOwner public {
138         uint256 amount = _tokenContract.balanceOf(address(this));
139         _tokenContract.transfer(owner, amount);
140     }
141 
142     function sumArray(uint256[] memory _array) public pure returns (uint256 sum_) {
143         sum_ = 0;
144         for (uint256 i = 0; i < _array.length; i++) {
145             sum_ += _array[i];
146         }
147     }
148     event TransferEther(address indexed _from, address indexed _to, uint256 _value);
149 }