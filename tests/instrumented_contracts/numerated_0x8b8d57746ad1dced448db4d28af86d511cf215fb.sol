1 // File: openzeppelin-solidity/contracts/ownership/Ownable.sol
2 
3 pragma solidity ^0.4.23;
4 
5 
6 /**
7  * @title Ownable
8  * @dev The Ownable contract has an owner address, and provides basic authorization control
9  * functions, this simplifies the implementation of "user permissions".
10  */
11 contract Ownable {
12   address public owner;
13 
14 
15   event OwnershipRenounced(address indexed previousOwner);
16   event OwnershipTransferred(
17     address indexed previousOwner,
18     address indexed newOwner
19   );
20 
21 
22   /**
23    * @dev The Ownable constructor sets the original `owner` of the contract to the sender
24    * account.
25    */
26   constructor() public {
27     owner = msg.sender;
28   }
29 
30   /**
31    * @dev Throws if called by any account other than the owner.
32    */
33   modifier onlyOwner() {
34     require(msg.sender == owner);
35     _;
36   }
37 
38   /**
39    * @dev Allows the current owner to relinquish control of the contract.
40    */
41   function renounceOwnership() public onlyOwner {
42     emit OwnershipRenounced(owner);
43     owner = address(0);
44   }
45 
46   /**
47    * @dev Allows the current owner to transfer control of the contract to a newOwner.
48    * @param _newOwner The address to transfer ownership to.
49    */
50   function transferOwnership(address _newOwner) public onlyOwner {
51     _transferOwnership(_newOwner);
52   }
53 
54   /**
55    * @dev Transfers control of the contract to a newOwner.
56    * @param _newOwner The address to transfer ownership to.
57    */
58   function _transferOwnership(address _newOwner) internal {
59     require(_newOwner != address(0));
60     emit OwnershipTransferred(owner, _newOwner);
61     owner = _newOwner;
62   }
63 }
64 
65 // File: openzeppelin-solidity/contracts/token/ERC20/ERC20Basic.sol
66 
67 pragma solidity ^0.4.23;
68 
69 
70 /**
71  * @title ERC20Basic
72  * @dev Simpler version of ERC20 interface
73  * @dev see https://github.com/ethereum/EIPs/issues/179
74  */
75 contract ERC20Basic {
76   function totalSupply() public view returns (uint256);
77   function balanceOf(address who) public view returns (uint256);
78   function transfer(address to, uint256 value) public returns (bool);
79   event Transfer(address indexed from, address indexed to, uint256 value);
80 }
81 
82 // File: openzeppelin-solidity/contracts/token/ERC20/ERC20.sol
83 
84 pragma solidity ^0.4.23;
85 
86 
87 
88 /**
89  * @title ERC20 interface
90  * @dev see https://github.com/ethereum/EIPs/issues/20
91  */
92 contract ERC20 is ERC20Basic {
93   function allowance(address owner, address spender)
94     public view returns (uint256);
95 
96   function transferFrom(address from, address to, uint256 value)
97     public returns (bool);
98 
99   function approve(address spender, uint256 value) public returns (bool);
100   event Approval(
101     address indexed owner,
102     address indexed spender,
103     uint256 value
104   );
105 }
106 
107 // File: sc-library/contracts/ERC223/ERC223Receiver.sol
108 
109 pragma solidity ^0.4.23;
110 
111 
112 /**
113 * @title Contract that will work with ERC223 tokens.
114 */
115 contract ERC223Receiver {
116   /**
117    * @dev Standard ERC223 function that will handle incoming token transfers.
118    *
119    * @param _from  Token sender address.
120    * @param _value Amount of tokens.
121    * @param _data  Transaction metadata.
122    */
123   function tokenFallback(address _from, uint _value, bytes _data) public;
124 }
125 
126 // File: contracts/AirDrop.sol
127 
128 pragma solidity ^0.4.24;
129 
130 
131 
132 
133 
134 contract AirDrop is Ownable {
135     ERC20 public token;
136     uint public createdAt;
137     constructor(address _target, ERC20 _token) public {
138         owner = _target;
139         token = _token;
140         createdAt = block.number;
141     }
142 
143     function transfer(address[] _addresses, uint[] _amounts) external onlyOwner {
144         require(_addresses.length == _amounts.length);
145 
146         for (uint i = 0; i < _addresses.length; i ++) {
147             token.transfer(_addresses[i], _amounts[i]);
148         }
149     }
150 
151     function transferFrom(address _from, address[] _addresses, uint[] _amounts) external onlyOwner {
152         require(_addresses.length == _amounts.length);
153 
154         for (uint i = 0; i < _addresses.length; i ++) {
155             token.transferFrom(_from, _addresses[i], _amounts[i]);
156         }
157     }
158 
159     function tokenFallback(address, uint, bytes) public pure {
160         // receive tokens
161     }
162 
163     function withdraw(uint _value) public onlyOwner {
164         token.transfer(owner, _value);
165     }
166 
167     function withdrawToken(address _token, uint _value) public onlyOwner {
168         ERC20(_token).transfer(owner, _value);
169     }
170 }