1 pragma solidity ^0.4.24;
2 
3 // File: openzeppelin-solidity/contracts/ownership/Ownable.sol
4 
5 /**
6  * @title Ownable
7  * @dev The Ownable contract has an owner address, and provides basic authorization control
8  * functions, this simplifies the implementation of "user permissions".
9  */
10 contract Ownable {
11   address public owner;
12 
13 
14   event OwnershipRenounced(address indexed previousOwner);
15   event OwnershipTransferred(
16     address indexed previousOwner,
17     address indexed newOwner
18   );
19 
20 
21   /**
22    * @dev The Ownable constructor sets the original `owner` of the contract to the sender
23    * account.
24    */
25   constructor() public {
26     owner = msg.sender;
27   }
28 
29   /**
30    * @dev Throws if called by any account other than the owner.
31    */
32   modifier onlyOwner() {
33     require(msg.sender == owner);
34     _;
35   }
36 
37   /**
38    * @dev Allows the current owner to relinquish control of the contract.
39    */
40   function renounceOwnership() public onlyOwner {
41     emit OwnershipRenounced(owner);
42     owner = address(0);
43   }
44 
45   /**
46    * @dev Allows the current owner to transfer control of the contract to a newOwner.
47    * @param _newOwner The address to transfer ownership to.
48    */
49   function transferOwnership(address _newOwner) public onlyOwner {
50     _transferOwnership(_newOwner);
51   }
52 
53   /**
54    * @dev Transfers control of the contract to a newOwner.
55    * @param _newOwner The address to transfer ownership to.
56    */
57   function _transferOwnership(address _newOwner) internal {
58     require(_newOwner != address(0));
59     emit OwnershipTransferred(owner, _newOwner);
60     owner = _newOwner;
61   }
62 }
63 
64 // File: openzeppelin-solidity/contracts/token/ERC20/ERC20Basic.sol
65 
66 /**
67  * @title ERC20Basic
68  * @dev Simpler version of ERC20 interface
69  * @dev see https://github.com/ethereum/EIPs/issues/179
70  */
71 contract ERC20Basic {
72   function totalSupply() public view returns (uint256);
73   function balanceOf(address who) public view returns (uint256);
74   function transfer(address to, uint256 value) public returns (bool);
75   event Transfer(address indexed from, address indexed to, uint256 value);
76 }
77 
78 // File: openzeppelin-solidity/contracts/token/ERC20/ERC20.sol
79 
80 /**
81  * @title ERC20 interface
82  * @dev see https://github.com/ethereum/EIPs/issues/20
83  */
84 contract ERC20 is ERC20Basic {
85   function allowance(address owner, address spender)
86     public view returns (uint256);
87 
88   function transferFrom(address from, address to, uint256 value)
89     public returns (bool);
90 
91   function approve(address spender, uint256 value) public returns (bool);
92   event Approval(
93     address indexed owner,
94     address indexed spender,
95     uint256 value
96   );
97 }
98 
99 // File: sc-library/contracts/ERC223/ERC223Receiver.sol
100 
101 /**
102 * @title Contract that will work with ERC223 tokens.
103 */
104 contract ERC223Receiver {
105     /**
106      * @dev Standard ERC223 function that will handle incoming token transfers.
107      *
108      * @param _from  Token sender address.
109      * @param _value Amount of tokens.
110      * @param _data  Transaction metadata.
111      */
112     function tokenFallback(address _from, uint _value, bytes _data) public;
113 }
114 
115 // File: contracts/AirDrop.sol
116 
117 contract AirDrop is Ownable {
118     ERC20 public token;
119     uint public createdAt;
120     constructor(address _target, ERC20 _token) public {
121         owner = _target;
122         token = _token;
123         createdAt = block.number;
124     }
125 
126     function transfer(address[] _addresses, uint[] _amounts) external onlyOwner {
127         require(_addresses.length == _amounts.length);
128 
129         for (uint i = 0; i < _addresses.length; i ++) {
130             token.transfer(_addresses[i], _amounts[i]);
131         }
132     }
133 
134     function transferFrom(address _from, address[] _addresses, uint[] _amounts) external onlyOwner {
135         require(_addresses.length == _amounts.length);
136 
137         for (uint i = 0; i < _addresses.length; i ++) {
138             token.transferFrom(_from, _addresses[i], _amounts[i]);
139         }
140     }
141 
142     function tokenFallback(address, uint, bytes) public pure {
143         // receive tokens
144     }
145 
146     function withdraw(uint _value) public onlyOwner {
147         token.transfer(owner, _value);
148     }
149 
150     function withdrawToken(address _token, uint _value) public onlyOwner {
151         ERC20(_token).transfer(owner, _value);
152     }
153 }