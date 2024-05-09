1 // File: openzeppelin-solidity/contracts/ownership/Ownable.sol
2 
3 pragma solidity ^0.4.24;
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
40    * @notice Renouncing to ownership will leave the contract without an owner.
41    * It will not be possible to call the functions with the `onlyOwner`
42    * modifier anymore.
43    */
44   function renounceOwnership() public onlyOwner {
45     emit OwnershipRenounced(owner);
46     owner = address(0);
47   }
48 
49   /**
50    * @dev Allows the current owner to transfer control of the contract to a newOwner.
51    * @param _newOwner The address to transfer ownership to.
52    */
53   function transferOwnership(address _newOwner) public onlyOwner {
54     _transferOwnership(_newOwner);
55   }
56 
57   /**
58    * @dev Transfers control of the contract to a newOwner.
59    * @param _newOwner The address to transfer ownership to.
60    */
61   function _transferOwnership(address _newOwner) internal {
62     require(_newOwner != address(0));
63     emit OwnershipTransferred(owner, _newOwner);
64     owner = _newOwner;
65   }
66 }
67 
68 // File: openzeppelin-solidity/contracts/token/ERC20/ERC20Basic.sol
69 
70 pragma solidity ^0.4.24;
71 
72 
73 /**
74  * @title ERC20Basic
75  * @dev Simpler version of ERC20 interface
76  * See https://github.com/ethereum/EIPs/issues/179
77  */
78 contract ERC20Basic {
79   function totalSupply() public view returns (uint256);
80   function balanceOf(address _who) public view returns (uint256);
81   function transfer(address _to, uint256 _value) public returns (bool);
82   event Transfer(address indexed from, address indexed to, uint256 value);
83 }
84 
85 // File: openzeppelin-solidity/contracts/token/ERC20/ERC20.sol
86 
87 pragma solidity ^0.4.24;
88 
89 
90 
91 /**
92  * @title ERC20 interface
93  * @dev see https://github.com/ethereum/EIPs/issues/20
94  */
95 contract ERC20 is ERC20Basic {
96   function allowance(address _owner, address _spender)
97     public view returns (uint256);
98 
99   function transferFrom(address _from, address _to, uint256 _value)
100     public returns (bool);
101 
102   function approve(address _spender, uint256 _value) public returns (bool);
103   event Approval(
104     address indexed owner,
105     address indexed spender,
106     uint256 value
107   );
108 }
109 
110 // File: contracts/promocode/PromoCode.sol
111 
112 pragma solidity ^0.4.24;
113 
114 
115 
116 contract PromoCode is Ownable {
117   ERC20 public token;
118   mapping(bytes32 => bool) public used;
119   uint256 public amount;
120 
121   event Redeem(address user, uint256 amount, string code);
122 
123   constructor(ERC20 _token, uint256 _amount) public {
124     amount = _amount;
125     token = _token;
126   }
127 
128   function setAmount(uint256 _amount) public onlyOwner {
129     amount = _amount;
130   }
131 
132   function redeem(string promoCode, bytes signature) public {
133     bytes32 hash = keccak256(abi.encodePacked(promoCode));
134     bytes32 r;
135     bytes32 s;
136     uint8 v;
137     assembly {
138       r := mload(add(signature, 32))
139       s := mload(add(signature, 64))
140       v := and(mload(add(signature, 65)), 255)
141     }
142     if (v < 27) {
143       v += 27;
144     }
145 
146     require(!used[hash]);
147     used[hash] = true;
148     require(ecrecover(keccak256(abi.encodePacked("\x19Ethereum Signed Message:\n32", hash)), v, r, s) == owner);
149     address user = msg.sender;
150     require(token.transferFrom(owner, user, amount));
151     emit Redeem(user, amount, promoCode);
152   }
153 }