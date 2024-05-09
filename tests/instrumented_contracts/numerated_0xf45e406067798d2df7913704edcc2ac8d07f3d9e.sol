1 pragma solidity ^0.4.23;
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
99 // File: contracts/TakeBack.sol
100 
101 contract TakeBack is Ownable{
102 
103     // address of RING.sol on ethereum
104     address public tokenAdd;
105 
106     address public supervisor;
107 
108     uint256 public networkId;
109 
110     mapping (address => uint256) public userToNonce;
111 
112     // used for old&new users to claim their ring out
113     event TakedBack(address indexed _user, uint indexed _nonce, uint256 _value);
114     // used for supervisor to claim all kind of token
115     event ClaimedTokens(address indexed _token, address indexed _controller, uint _amount);
116 
117 
118     constructor(address _token, address _supervisor, uint256 _networkId) public {
119         tokenAdd = _token;
120         supervisor = _supervisor;
121         networkId = _networkId;
122     }
123 
124     // _hashmessage = hash("${_user}${_nonce}${_value}")
125     // _v, _r, _s are from supervisor's signature on _hashmessage
126     // claimRing(...) is invoked by the user who want to claim rings
127     // while the _hashmessage is signed by supervisor
128     function takeBack(uint256 _nonce, uint256 _value, bytes32 _hashmessage, uint8 _v, bytes32 _r, bytes32 _s) public {
129         address _user = msg.sender;
130 
131         // verify the _nonce is right
132         require(userToNonce[_user] == _nonce);
133 
134         // verify the _hashmessage is signed by supervisor
135         require(supervisor == verify(_hashmessage, _v, _r, _s));
136 
137         // verify that the _user, _nonce, _value are exactly what they should be
138         require(keccak256(abi.encodePacked(_user,_nonce,_value,networkId)) == _hashmessage);
139 
140         // transfer token from address(this) to _user
141         ERC20 token = ERC20(tokenAdd);
142         token.transfer(_user, _value);
143 
144         // after the claiming operation succeeds
145         userToNonce[_user]  += 1;
146         emit TakedBack(_user, _nonce, _value);
147     }
148 
149     function verify(bytes32 _hashmessage, uint8 _v, bytes32 _r, bytes32 _s) internal pure returns (address) {
150         bytes memory prefix = "\x19EvolutionLand Signed Message:\n32";
151         bytes32 prefixedHash = keccak256(abi.encodePacked(prefix, _hashmessage));
152         address signer = ecrecover(prefixedHash, _v, _r, _s);
153         return signer;
154     }
155 
156     function claimTokens(address _token) public onlyOwner {
157         if (_token == 0x0) {
158             owner.transfer(address(this).balance);
159             return;
160         }
161 
162         ERC20 token = ERC20(_token);
163         uint balance = token.balanceOf(this);
164         token.transfer(owner, balance);
165 
166         emit ClaimedTokens(_token, owner, balance);
167     }
168 
169     function changeSupervisor(address _newSupervisor) public onlyOwner {
170         supervisor = _newSupervisor;
171     }
172 }